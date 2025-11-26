# frozen_string_literal: true

require 'thor'

module NewestFiles
  # CLI interface using Thor
  class CLI < Thor
    default_command :list

    def self.exit_on_failure?
      true
    end

    desc 'list [GLOB]', 'List the N most-recently-created files in a Git repository'
    long_desc <<~DESC
      List the N most-recently-created files in a Git repository.

      "Creation" is defined as the first commit that added the file (--diff-filter=A).
      This is useful for finding recent patterns and conventions in large codebases.

      Examples:

        $ newest-files                        # Show 10 newest files

        $ newest-files -n 20                  # Show 20 newest files

        $ newest-files --urls                 # Show with GitHub commit URLs

        $ newest-files "*.rb"                 # Show newest Ruby files

        $ newest-files "app/models/**/*.rb"   # Show newest model files

        $ newest-files -n 5 "src/**/*.py"     # Show 5 newest Python files
    DESC
    option :count, aliases: '-n', type: :numeric, default: 10,
                   desc: 'Number of files to show'
    option :urls, aliases: '-u', type: :boolean, default: false,
                  desc: 'Show GitHub commit URLs (only if origin is GitHub)'
    option :directory, aliases: '-C', type: :string, default: '.',
                       desc: 'Git repository directory'
    option :no_color, type: :boolean, default: false,
                      desc: 'Disable colored output'
    def list(glob = nil)
      Colors.enabled = false if options[:no_color]

      finder = Finder.new(
        directory: options[:directory],
        count: options[:count],
        glob_pattern: glob
      )

      entries = finder.find

      formatter = Formatter.new(
        entries,
        show_urls: options[:urls],
        github_repo: finder.github_repo,
        glob_pattern: glob
      )

      formatter.print
    rescue Error => e
      error_message = Colors.red("Error: #{e.message}")
      warn error_message
      exit 1
    end

    desc 'version', 'Print the version'
    def version
      puts "newest-files #{VERSION}"
    end

    map %w[-v --version] => :version
  end
end
