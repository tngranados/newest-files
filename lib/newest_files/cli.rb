# frozen_string_literal: true

require 'optparse'

module NewestFiles
  # CLI interface using OptionParser
  class CLI
    def self.start(argv = ARGV)
      new.run(argv)
    end

    def run(argv)
      options = parse_options(argv)

      return puts("newest-files #{VERSION}") if options[:version]

      Colors.enabled = false if options[:no_color]

      glob = argv.first

      finder = Finder.new(
        directory: options[:directory],
        count: options[:count],
        glob_pattern: glob
      )

      entries = finder.find

      formatter = Formatter.new(
        entries,
        show_urls: options[:urls],
        remote_repo: finder.remote_repo,
        glob_pattern: glob
      )

      formatter.print
    rescue Error => e
      error_message = Colors.red("Error: #{e.message}")
      warn error_message
      exit 1
    end

    private

    def parse_options(argv)
      options = {
        count: 10,
        urls: false,
        directory: '.',
        no_color: false,
        version: false
      }

      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: newest-files [options] [GLOB]'
        opts.separator ''
        opts.separator 'List the N most-recently-created files in a Git repository.'
        opts.separator '"Creation" is defined as the first commit that added the file (--diff-filter=A).'
        opts.separator 'This is useful for finding recent patterns and conventions in large codebases.'
        opts.separator ''
        opts.separator 'Examples:'
        opts.separator '  newest-files                        # Show 10 newest files'
        opts.separator '  newest-files -n 20                  # Show 20 newest files'
        opts.separator '  newest-files --urls                 # Show with GitHub commit URLs'
        opts.separator '  newest-files "*.rb"                 # Show newest Ruby files'
        opts.separator '  newest-files "app/models/**/*.rb"   # Show newest model files'
        opts.separator '  newest-files -n 5 "src/**/*.py"     # Show 5 newest Python files'
        opts.separator ''
        opts.separator 'Options:'

        opts.on('-n', '--count NUMBER', Integer, 'Number of files to show (default: 10)') do |n|
          options[:count] = n
        end

        opts.on('-u', '--urls', 'Show commit URLs (GitHub, GitLab, Bitbucket)') do
          options[:urls] = true
        end

        opts.on('-C', '--directory DIR', 'Git repository directory (default: .)') do |dir|
          options[:directory] = dir
        end

        opts.on('--no-color', 'Disable colored output') do
          options[:no_color] = true
        end

        opts.on('-v', '--version', 'Print the version') do
          options[:version] = true
        end

        opts.on('-h', '--help', 'Show this help message') do
          puts opts
          exit
        end
      end

      parser.parse!(argv)
      options
    end
  end
end
