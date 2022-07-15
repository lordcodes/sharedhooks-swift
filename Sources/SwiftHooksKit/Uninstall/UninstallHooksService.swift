// Copyright © 2022 Andrew Lord.

import Files

// TODO: Add tests

/// Service to uninstall project git hooks from .git.
/// Deletes SwiftHooks hook files and then restores backed-up non-SwiftHooks hook files if any exist.
public struct UninstallHooksService {
    /// Create the service.
    public init() {}

    /// Entry-point to run the service.
    /// - throws: ExitCode when operation ends early due to success or failure.
    public func run() throws {
        printer.printMessage("🗑  Uninstalling git hooks")

        try uninstallGitHooks()
    }

    private func uninstallGitHooks() throws {
        let gitHooksDirectory = try handleFatalError(using: printer) {
            try Folder.current.gitHooks()
        }

        for hook in gitHooks {
            handleNonFatalError(using: printer) {
                try uninstall(hook: hook, from: gitHooksDirectory)
                try restoreBackedUpHookFile(hook: hook, in: gitHooksDirectory)
            }
        }
    }

    private func uninstall(hook: String, from gitHooksDirectory: Folder) throws {
        guard let hookFile = try? gitHooksDirectory.file(named: hook) else { return }
        let hookContents = try readHookFileContents(hook: hook, file: hookFile)
        if hookContents.contains(autoGeneratedIdentifier) {
            printer.printMessage("\(hook): found SwiftHooks file, deleting…")
            try deleteExistingHookFile(hook: hook, file: hookFile)
        }
    }

    private func readHookFileContents(hook: String, file: File) throws -> String {
        do {
            return try file.readAsString()
        } catch is ReadError {
            throw SwiftHooksError.resovingHookFile(hook: hook, reason: .readExistingHookFileContents)
        }
    }

    private func deleteExistingHookFile(hook: String, file: File) throws {
        do {
            try file.delete()
        } catch is LocationError {
            throw SwiftHooksError.resovingHookFile(hook: hook, reason: .deletingExisting)
        }
    }

    private func restoreBackedUpHookFile(hook: String, in gitHooksDirectory: Folder) throws {
        if let backup = try? gitHooksDirectory.file(named: "\(hook).backup") {
            printer.printMessage("\(hook): found backed up hook file, restoring…")
            try backup.rename(to: hook, keepExtension: false)
        }
    }
}
