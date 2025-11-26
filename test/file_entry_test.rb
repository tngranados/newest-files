# frozen_string_literal: true

require 'test_helper'

class FileEntryTest < Minitest::Test
  def setup
    @entry = NewestFiles::FileEntry.new(
      created_at: '2025-11-26 10:00',
      author: 'Test Author',
      path: 'app/models/user.rb',
      commit_sha: 'abc123def456789'
    )
  end

  def test_short_commit
    assert_equal 'abc123de', @entry.short_commit
  end

  def test_commit_url_with_github_repo
    remote = { provider: :github, owner: 'tngranados', repo: 'newest-files' }
    url = @entry.commit_url(remote)
    assert_equal 'https://github.com/tngranados/newest-files/commit/abc123de', url
  end

  def test_commit_url_with_gitlab_repo
    remote = { provider: :gitlab, owner: 'tngranados', repo: 'newest-files' }
    url = @entry.commit_url(remote)
    assert_equal 'https://gitlab.com/tngranados/newest-files/-/commit/abc123de', url
  end

  def test_commit_url_with_bitbucket_repo
    remote = { provider: :bitbucket, owner: 'tngranados', repo: 'newest-files' }
    url = @entry.commit_url(remote)
    assert_equal 'https://bitbucket.org/tngranados/newest-files/commits/abc123de', url
  end

  def test_commit_url_without_remote_repo
    assert_nil @entry.commit_url(nil)
  end

  def test_attributes
    assert_equal '2025-11-26 10:00', @entry.created_at
    assert_equal 'Test Author', @entry.author
    assert_equal 'app/models/user.rb', @entry.path
    assert_equal 'abc123def456789', @entry.commit_sha
  end
end
