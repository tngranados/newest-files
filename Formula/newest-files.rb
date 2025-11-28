# frozen_string_literal: true

class NewestFiles < Formula
  desc 'List the N most-recently-created files in a Git repository'
  homepage 'https://github.com/tngranados/newest-files'
  url 'https://github.com/tngranados/newest-files/archive/refs/tags/v1.0.2.tar.gz'
  sha256 '36fa88ee8ea9dc0c1869a8515d6d564b63b2178da4d659ec40232805cf3650c4'

  depends_on 'ruby'

  resource 'thor' do
    url 'https://rubygems.org/downloads/thor-1.3.2.gem'
    sha256 'eef0293b9e24158ccad7ab383ae83534b7ad4ed99c09f96f1a6b036550abbeda'
  end

  def install
    ENV['GEM_HOME'] = libexec
    resources.each do |r|
      r.fetch
      system 'gem', 'install', r.cached_download, '--ignore-dependencies',
             '--no-document', '--install-dir', libexec
    end

    system 'gem', 'build', 'newest_files.gemspec'
    system 'gem', 'install', '--ignore-dependencies', '--no-document',
           '--install-dir', libexec, "newest_files-#{version}.gem"

    bin.install libexec / 'bin/newest-files'
    bin.env_script_all_files(libexec / 'bin', GEM_HOME: ENV['GEM_HOME'])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newest-files version")
    assert_match 'List the N most-recently-created files', shell_output("#{bin}/newest-files help list")
  end
end
