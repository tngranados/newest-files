# frozen_string_literal: true

class NewestFiles < Formula
  desc 'List the N most-recently-created files in a Git repository'
  homepage 'https://github.com/tngranados/newest-files'
  url 'https://github.com/tngranados/newest-files/archive/refs/tags/v1.1.0.tar.gz'
  sha256 '8ce953fc7d589776aa09901b7db3c81e05c3b63134225cf564a4298adef5c4fa'

  depends_on 'ruby'

  def install
    ENV['GEM_HOME'] = libexec
    resources.each do |r|
      r.fetch
      system 'gem', 'install', r.cached_download, '--ignore-dependencies',
             '--no-document', '--install-dir', libexec
    end

    system 'gem', 'build', 'newest_files.gemspec'
    system 'gem', 'install', '--local', '--ignore-dependencies', '--no-document',
           '--install-dir', libexec, "newest_files-#{version}.gem"

    bin.install libexec / 'bin/newest-files'
    bin.env_script_all_files(libexec / 'bin', GEM_HOME: ENV['GEM_HOME'])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newest-files --version")
    assert_match 'List the N most-recently-created files', shell_output("#{bin}/newest-files --help")
  end
end
