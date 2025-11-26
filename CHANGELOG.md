# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-26

### Added

- Initial release
- List newest files in a Git repository based on first commit date
- Glob pattern filtering (e.g., `*.rb`, `app/models/**/*.rb`)
- GitHub commit URL display with `--urls` flag
- Configurable result count with `-n` / `--count`
- Directory specification with `-C` / `--directory`
- Colored terminal output with `--no-color` option
- Dynamic column width based on content
