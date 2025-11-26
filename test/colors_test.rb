# frozen_string_literal: true

require 'test_helper'

class ColorsTest < Minitest::Test
  def teardown
    # Reset to default state
    NewestFiles::Colors.instance_variable_set(:@enabled, nil)
  end

  def test_colorize_when_enabled
    NewestFiles::Colors.enabled = true
    result = NewestFiles::Colors.colorize('test', NewestFiles::Colors::RED)
    assert_equal "\e[31mtest\e[0m", result
  end

  def test_colorize_when_disabled
    NewestFiles::Colors.enabled = false
    result = NewestFiles::Colors.colorize('test', NewestFiles::Colors::RED)
    assert_equal 'test', result
  end

  def test_bold
    NewestFiles::Colors.enabled = true
    result = NewestFiles::Colors.bold('test')
    assert_equal "\e[1mtest\e[0m", result
  end

  def test_gray
    NewestFiles::Colors.enabled = true
    result = NewestFiles::Colors.gray('test')
    assert_equal "\e[90mtest\e[0m", result
  end
end
