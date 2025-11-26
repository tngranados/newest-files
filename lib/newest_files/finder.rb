# frozen_string_literal: true

require 'open3'
require 'set'

module NewestFiles
  # Core logic for finding newest files in a Git repository
  class Finder
    attr_reader :directory, :count, :glob_pattern

    def initialize(directory: '.', count: 10, glob_pattern: nil)
      @directory = File.expand_path(directory)
      @count = count
      @glob_pattern = glob_pattern
    end

    def find
      validate_git_repository!

      # Get currently tracked files to filter results (we only want existing files)
      existing_files = list_existing_files

      entries = []
      seen = Set.new
      current_commit = nil

      # Stream git log output and terminate git as soon as we have enough results
      pid = nil
      begin
        IO.popen(git_log_command, chdir: directory) do |io|
          pid = io.pid
          io.each_line do |line|
            line = line.chomp

            # Parse commit header line: SHA|DATE|AUTHOR
            if line =~ /^([0-9a-f]{40})\|(.+?)\|(.+)$/
              current_commit = {
                sha: ::Regexp.last_match(1),
                date: ::Regexp.last_match(2),
                author: ::Regexp.last_match(3)
              }
              next
            end

            # Skip empty lines
            next if line.empty?
            next unless current_commit

            file_path = line

            # Skip files that no longer exist in the repo
            next unless existing_files.include?(file_path)

            # Apply glob filter if specified (when not using pathspec)
            next if glob_pattern && !matches_glob?(file_path, glob_pattern)

            # Skip duplicates (file could appear multiple times if deleted and re-added)
            next if seen.include?(file_path)

            seen.add(file_path)

            entries << FileEntry.new(
              created_at: current_commit[:date],
              author: current_commit[:author],
              path: file_path,
              commit_sha: current_commit[:sha]
            )

            # Stop when we have enough results - kill the git process immediately
            next unless entries.size >= count

            begin
              Process.kill('TERM', pid)
            rescue StandardError
              nil
            end
            break
          end
        end
      rescue Errno::EPIPE
        # Expected when we kill the git process
      end

      entries
    end

    def github_repo
      return @github_repo if defined?(@github_repo)

      stdout, status = Open3.capture2('git', '-C', directory, 'remote', 'get-url', 'origin')
      return @github_repo = nil unless status.success?

      remote_url = stdout.strip
      # Match GitHub URLs: git@github.com:user/repo.git or https://github.com/user/repo.git
      return unless remote_url =~ %r{github\.com[/:]([^/]+)/([^/.]+)(?:\.git)?$}

      @github_repo = "#{::Regexp.last_match(1)}/#{::Regexp.last_match(2)}"
    end

    private

    def validate_git_repository!
      _, status = Open3.capture2('git', '-C', directory, 'rev-parse', '--is-inside-work-tree')
      raise Error, "'#{directory}' is not inside a Git repository." unless status.success?
    end

    def list_existing_files
      cmd = ['git', '-C', directory, 'ls-files']
      stdout, stderr, status = Open3.capture3(*cmd)
      raise Error, "Git command failed: #{stderr}" unless status.success?

      Set.new(stdout.lines.map(&:chomp))
    end

    def git_log_command
      cmd = [
        'git', 'log',
        '--diff-filter=A',
        '--pretty=format:%H|%cd|%an',
        '--date=format:%Y-%m-%d %H:%M',
        '--name-only'
      ]

      # If glob pattern can be used as a pathspec, let git filter for us
      # This is much faster as git filters at the source
      if glob_pattern && usable_as_pathspec?(glob_pattern)
        cmd << '--'
        cmd << glob_pattern
      end

      cmd
    end

    # Check if the glob pattern can be passed directly to git as a pathspec
    # Git pathspecs support *, **, and ? wildcards
    def usable_as_pathspec?(pattern)
      # Most glob patterns work as git pathspecs
      # Exclude patterns with special fnmatch features not supported by git
      !pattern.include?('{') && !pattern.include?('[')
    end

    def matches_glob?(path, pattern)
      # Use File.fnmatch with FNM_PATHNAME for proper glob matching
      # FNM_EXTGLOB enables extended glob patterns like **
      flags = File::FNM_PATHNAME | File::FNM_EXTGLOB

      # Handle ** pattern for recursive matching
      if pattern.include?('**')
        File.fnmatch(pattern, path, flags)
      else
        # For simple patterns, also try matching just the filename
        File.fnmatch(pattern, path, flags) ||
          File.fnmatch(pattern, File.basename(path), flags)
      end
    end
  end
end
