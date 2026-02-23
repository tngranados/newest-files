# frozen_string_literal: true

module NewestFiles
  # Formats and prints file entries to the terminal
  class Formatter
    def initialize(entries, show_urls: false, remote_repo: nil, glob_pattern: nil)
      @entries = entries
      @show_urls = show_urls
      @remote_repo = remote_repo
      @glob_pattern = glob_pattern
      @path_prefix_to_strip = path_prefix_from_glob(glob_pattern)
    end

    def print
      if @entries.empty?
        puts Colors.yellow("\nNo files found.")
        return
      end

      print_table
      print_summary
    end

    private

    def print_table
      display_paths = @entries.map { |entry| display_path(entry.path) }

      # Calculate dynamic column widths based on content
      max_author = [@entries.map { |e| e.author.length }.max, 20].min
      max_path = [display_paths.max_by(&:length).length, 60].min

      # Print header
      puts
      header = format(
        "%-16s │ %-#{max_author}s │ %-#{max_path}s │ %-8s",
        'Created', 'Author', 'File', 'Commit'
      )
      puts Colors.bold(header)

      # Print separator
      separator_width = 16 + max_author + max_path + 8 + 9 # +9 for separators and spaces
      puts '─' * separator_width

      # Print entries
      @entries.each do |entry|
        print_entry(entry, max_author, max_path)
      end
    end

    def print_entry(entry, max_author, max_path)
      author = truncate(entry.author, max_author)
      path = truncate(display_path(entry.path), max_path)

      row = format(
        "%-16s │ %-#{max_author}s │ %-#{max_path}s │ %-8s",
        entry.created_at,
        author,
        path,
        entry.short_commit
      )
      puts row

      # Print URL if enabled and available
      return unless @show_urls && @remote_repo

      url = entry.commit_url(@remote_repo)
      puts format('%18s %s', '↳', Colors.gray(url))
    end

    def print_summary
      puts
      summary = "Showing #{@entries.size} newest file#{'s' if @entries.size != 1}"
      summary += " matching '#{@glob_pattern}'" if @glob_pattern
      puts Colors.gray(summary)
    end

    def truncate(str, max_length)
      return str if str.length <= max_length

      "#{str[0, max_length - 1]}…"
    end

    def display_path(path)
      return path unless @path_prefix_to_strip && path.start_with?(@path_prefix_to_strip)

      path.delete_prefix(@path_prefix_to_strip)
    end

    def path_prefix_from_glob(pattern)
      return nil unless pattern

      normalized_pattern = pattern.sub(%r{\A\./}, '')
      wildcard_index = normalized_pattern.index(/[*?\[{]/)
      static_part = wildcard_index ? normalized_pattern[0...wildcard_index] : normalized_pattern
      last_slash_index = static_part.rindex('/')
      return nil unless last_slash_index

      static_part[0..last_slash_index]
    end
  end
end
