// Copyright © 2022 Andrew Lord.

import Foundation

/// Print messages and errors.
public protocol Printer {
    /// Print message, may be disabled by settings such as quiet mode.
    func printMessage(_ message: @autoclosure () -> String)

    /// Print a forced message that should always be printed in general.
    func printForced(_ message: @autoclosure () -> String)

    /// Print an error.
    func printError(_ error: SharedHooksError)
}

struct NoPrinter: Printer {
    func printMessage(_ message: @autoclosure () -> String) {}

    func printForced(_ message: @autoclosure () -> String) {}

    func printError(_ error: SharedHooksError) {}
}

/// A printer for outputting to the console using `print` for messages and `fputs` to `stderr` for errors.
public struct ConsolePrinter: Printer {
    private let quiet: Bool

    /// Create a `ConsolePrinter` instance.
    /// - parameter quiet: Suppress non-forced messages.
    public init(quiet: Bool) {
        self.quiet = quiet
    }

    /// Print message when not in quiet mode.
    public func printMessage(_ message: @autoclosure () -> String) {
        if !quiet {
            print(message())
        }
    }

    /// Print a message that will always be printed.
    public func printForced(_ message: @autoclosure () -> String) {
        print(message())
    }

    /// Print an error to stderr.
    public func printError(_ error: SharedHooksError) {
        fputs("\(error.description)\n", stderr)
    }
}
