# frozen_string_literal: true

require 'test_helper'
require 'stringio'

class FormatterTest < Minitest::Test
  def test_print_replaces_stripped_glob_prefix_with_ellipsis
    entry = NewestFiles::FileEntry.new(
      created_at: '2026-02-18 14:10',
      author: 'Marco',
      path: 'app/graphql/mutations/alkimii/settings/team/absence_reasons/create_absence_reason.rb',
      commit_sha: '30188db2abcd1234'
    )

    output = capture_stdout do
      NewestFiles::Formatter.new(
        [entry],
        glob_pattern: 'app/graphql/mutations/alkimii/**/*.rb'
      ).print
    end

    assert_includes output, '…/settings/team/absence_reasons/create_absence_reason.rb'
    refute_includes output, 'app/graphql/mutations/alkimii/settings/team/absence_reasons/create_absence_reason.rb'
  end

  def test_print_keeps_path_when_glob_has_no_static_directory_prefix
    entry = NewestFiles::FileEntry.new(
      created_at: '2026-02-18 14:10',
      author: 'Marco',
      path: 'app/models/user.rb',
      commit_sha: '30188db2abcd1234'
    )

    output = capture_stdout do
      NewestFiles::Formatter.new([entry], glob_pattern: '*.rb').print
    end

    assert_includes output, 'app/models/user.rb'
  end

  def test_print_does_not_truncate_long_display_paths
    entry = NewestFiles::FileEntry.new(
      created_at: '2026-02-18 14:10',
      author: 'Marco',
      path: 'app/graphql/mutations/alkimii/settings/team/absence_reasons/deeply/nested/folder/with/a/very_long_file_name_that_should_not_be_truncated.rb',
      commit_sha: '30188db2abcd1234'
    )

    output = capture_stdout do
      NewestFiles::Formatter.new(
        [entry],
        glob_pattern: 'app/graphql/mutations/alkimii/**/*.rb'
      ).print
    end

    assert_includes output,
                    '…/settings/team/absence_reasons/deeply/nested/folder/with/a/very_long_file_name_that_should_not_be_truncated.rb'
  end

  private

  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end
end
