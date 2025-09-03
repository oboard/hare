# oboard/hare 野兔

Hare is a MoonBit Runtime / ToolKit.

## Features

- REPL - Interactive MoonBit shell
- Run - Execute MoonBit files or packages
- Version - Display version information

## Usage

```bash
# Start REPL
hare repl

# Run a MoonBit file
hare run example.mbt

# Run a package
hare run package_name

# Show version
hare version

# Show help
hare --help
```

## Quick Start

```bash
# Build and run (Native)
moon run src/main --target native

# Build and run (Node.js)
moon run src/main --target js
```

## Build

```bash
# Native
moon build --target native --release
```

```bash
# Node.js
moon build --target js --release
```

!["screenshot"](screenshot.png)

# License

This project is licensed under the Apache-2.0 License.
