<p align="center">
    <img src="Art/logo.png" width="500" max-width="90%" alt="SwiftHooks" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.6-orange.svg" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
     <a href="https://github.com/lordcodes/swifthooks/releases/latest">
         <img src="https://img.shields.io/github/release/lordcodes/swifthooks.svg?style=flat" alt="Latest release" />
     </a>
    <a href="https://twitter.com/lordcodes">
        <img src="https://img.shields.io/badge/twitter-@lordcodes-blue.svg?style=flat" alt="Twitter: @lordcodes" />
    </a>
</p>

---

This is **SwiftHooks** - a CLI tool to install Git hooks that can be distributed alongside a project and shared by all the contributors.

&nbsp;

<p align="center">
    <a href="#features">Features</a> • <a href="#install">Install</a> • <a href="#usage">Usage</a> • <a href="#contributing-or-help">Contributing</a>
</p>

## Features

#### ☑️ Store Git hooks within a project

Provide Git hooks for all project contributors to share.

#### ☑️ Easily install into Git

Simply run a single command and a Git hook will be installed that runs your project-specific Git hooks.

#### ☑️ Easily uninstall

A command is provided to remove any installed hooks.

&nbsp;

## Install

### ▶︎ 🖥 Standalone via Swift Package Manager

SwiftHooks can be easily installed globally using Swift Package Manager.

```terminal
 git clone https://github.com/lordcodes/swifthooks-swift
 cd swifthooks-swift
 make install
```

This will install swifthooks into `/usr/local/bin`. If you get a permission error it may be that you don't have permission to write there in which case you just need to adjust permissions using `sudo chown -R $(whoami) /usr/local/bin`.

You can uninstall it again using `make uninstall` which simply deletes it from `/usr/local/bin`.

### ▶︎ 🍀 Mint

You can install SwiftHooks on MacOS using [Mint](https://github.com/yonaskolb/Mint) as follows:

```terminal
mint install lordcodes/swifthooks
```

### ▶︎ 📦 As a Swift package

To install SwiftHooks for use in your own Swift code, add it is a Swift Package Manager dependency within your `Package.swift` file. For help in doing this, please check out the Swift Package Manager documentation.

```swift
.package(url: "https://github.com/lordcodes/swifthooks", exact: "0.3.0")
```

&nbsp;

## Usage

### Configure project hooks

Git hooks should be stored inside a `.git-hooks` directory, which should be relative to the working directory. Inside create a folder named according to the required Git hook and then place the scripts you wish to run in an executable form within the hook folder.

For example:

```terminal
.git-hooks/commit-msg/prepend-jira-issue-id.sh
.git-hooks/prepare-commit-msg/prepend-jira-issue-id.sh
```

Ensure the scripts are executable with `chmod a+x .git-hooks/commit-msg/prepend-jira-issue-id.sh`.

### 🖥 Via the Standalone CLI

```terminal
USAGE: swifthooks <install|uninstall|version> [-q|--quiet]

ARGUMENTS:
  <install>               Installs Git hooks that run's hooks stored in project.
  <uninstall>             Uninstalls Git hooks that were installed.
  <version>               Prints out the current version of the tool.

OPTIONS:
  -q, --quiet             Silence any output except errors 
```

### 📦 As a Swift Package

To use SwiftHooks within your own Swift code, import and use the public API of `SwiftHooksKit`.

```swift
import SwiftHooksKit

// Configure printing
SwiftHooks.shared.printer = ConsolePrinter(quiet: false)

// Install hooks
try InstallHooksService().run()

// Uninstall hooks
try UninstallHooksService().run()
```

## Contributing or Help

If you notice any bugs or have a new feature to suggest, please check out the [contributing guide](https://github.com/lordcodes/swifthooks/blob/master/CONTRIBUTING.md). If you want to make changes, please make sure to discuss anything big before putting in the effort of creating the PR.

To reach out, please contact [@lordcodes on Twitter](https://twitter.com/lordcodes).
