# frozen_string_literal: true

require_relative 'newest_files/version'
require_relative 'newest_files/colors'
require_relative 'newest_files/file_entry'
require_relative 'newest_files/finder'
require_relative 'newest_files/formatter'
require_relative 'newest_files/cli'

module NewestFiles
  class Error < StandardError; end
end
