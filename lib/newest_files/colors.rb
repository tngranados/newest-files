# frozen_string_literal: true

module NewestFiles
  # ANSI color codes for terminal output
  module Colors
    RESET = "\e[0m"
    GRAY = "\e[90m"
    BOLD = "\e[1m"
    GREEN = "\e[32m"
    YELLOW = "\e[33m"
    CYAN = "\e[36m"
    RED = "\e[31m"

    class << self
      attr_writer :enabled

      def enabled?
        return @enabled if defined?(@enabled)

        @enabled = $stdout.tty?
      end

      def colorize(text, *codes)
        return text unless enabled?

        "#{codes.join}#{text}#{RESET}"
      end

      def bold(text)
        colorize(text, BOLD)
      end

      def gray(text)
        colorize(text, GRAY)
      end

      def green(text)
        colorize(text, GREEN)
      end

      def yellow(text)
        colorize(text, YELLOW)
      end

      def red(text)
        colorize(text, RED)
      end

      def cyan(text)
        colorize(text, CYAN)
      end
    end
  end
end
