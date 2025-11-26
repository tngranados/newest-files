# frozen_string_literal: true

require 'open3'
require 'set'

module NewestFiles
  # Represents a single file entry with its creation metadata
  class FileEntry
    attr_reader :created_at, :author, :path, :commit_sha

    def initialize(created_at:, author:, path:, commit_sha:)
      @created_at = created_at
      @author = author
      @path = path
      @commit_sha = commit_sha
    end

    def short_commit
      commit_sha[0, 8]
    end

    def commit_url(github_repo)
      return nil unless github_repo

      "https://github.com/#{github_repo}/commit/#{short_commit}"
    end
  end
end
