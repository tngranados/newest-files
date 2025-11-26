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

    def commit_url(remote_repo)
      return nil unless remote_repo

      owner = remote_repo[:owner]
      repo = remote_repo[:repo]

      case remote_repo[:provider]
      when :github
        "https://github.com/#{owner}/#{repo}/commit/#{short_commit}"
      when :gitlab
        "https://gitlab.com/#{owner}/#{repo}/-/commit/#{short_commit}"
      when :bitbucket
        "https://bitbucket.org/#{owner}/#{repo}/commits/#{short_commit}"
      end
    end
  end
end
