# newest-files

[![Gem Version](https://badge.fury.io/rb/newest_files.svg)](https://badge.fury.io/rb/newest_files)

A CLI tool to list the N most-recently-created files in a Git repository. "Creation" is defined as the first commit that added the file (`--diff-filter=A`).

## Why?

In large, long-lived codebases, patterns evolve. Older files may contain legacy approaches you no longer want to replicate. **Always prefer learning from the newest files** in a category—they reflect current best practices, recent refactors, and the team's latest conventions.

This is specially usefuls for AI Agents, as they can use the newer files as reference when implementing similar code. You can use `./llms.txt` as a reference documentation so your agent knows how and when to use it.

## Installation

### Homebrew (recommended)

```bash
brew tap tngranados/newest-files
brew install newest-files
```

### RubyGems

```bash
gem install newest_files
```

### From source

```bash
git clone https://github.com/tngranados/newest-files.git
cd newest-files
bundle install
rake install
```

## Usage

```bash
newest-files [OPTIONS] [GLOB]
```

### Options

| Option        | Alias | Description              | Default |
| ------------- | ----- | ------------------------ | ------- |
| `--count`     | `-n`  | Number of files to show  | 10      |
| `--urls`      | `-u`  | Show remote commit URLs  | false   |
| `--directory` | `-C`  | Git repository directory | `.`     |
| `--no-color`  |       | Disable colored output   | false   |
| `--help`      | `-h`  | Show help message        |         |
| `--version`   | `-v`  | Show version             |         |

### Examples

```bash
# Show 10 newest files in current repo
newest-files

# Show 20 newest files
newest-files -n 20

# Show with GitHub commit URLs
newest-files --urls

# Show newest Ruby files
newest-files "*.rb"

# Show newest model files
newest-files "app/models/**/*.rb"

# Show 5 newest Python files in src/
newest-files -n 5 "src/**/*.py"

# Run from a different directory
newest-files -C ~/my-project

# Combine options
newest-files -n 5 --urls "app/services/**/*.rb"
```

## Sample Output

```
Created          │ Author              │ File                                    │ Commit
───────────────────────────────────────────────────────────────────────────────────────────
2025-11-24 17:22 │ Toni Granados       │ lib/newest_files/formatter.rb           │ 1ced2b31
                 ↳ https://github.com/tngranados/newest-files/commit/1ced2b31
2025-11-24 15:56 │ Toni Granados       │ lib/newest_files/finder.rb              │ e28a25f1
                 ↳ https://github.com/tngranados/newest-files/commit/e28a25f1
2025-11-24 14:50 │ Toni Granados       │ lib/newest_files/cli.rb                 │ 386904e1
                 ↳ https://github.com/tngranados/newest-files/commit/386904e1

Showing 3 newest files matching 'lib/**/*.rb'
```

## Common Use Cases

| Task              | Command                                       |
| ----------------- | --------------------------------------------- |
| New Ruby file     | `newest-files -n 5 "**/*.rb"`                 |
| New lib file      | `newest-files -n 5 "lib/**/*.rb"`             |
| New test file     | `newest-files -n 5 "test/**/*_test.rb"`       |
| New spec file     | `newest-files -n 5 "spec/**/*_spec.rb"`       |
| New model         | `newest-files -n 5 "app/models/**/*.rb"`      |
| New service       | `newest-files -n 5 "app/services/**/*.rb"`    |
| New controller    | `newest-files -n 5 "app/controllers/**/*.rb"` |
| New configuration | `newest-files -n 5 "config/**/*.rb"`          |

## Requirements

- Ruby 3.0+
- Git

## Development

```bash
# Clone the repo
git clone https://github.com/tngranados/newest-files.git
cd newest-files

# Install dependencies
bundle install

# Run tests
rake test

# Run the CLI locally
bundle exec exe/newest-files --help

# Build and install locally
rake install
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tngranados/newest-files.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
