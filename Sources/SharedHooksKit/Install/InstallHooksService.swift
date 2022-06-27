// Copyright © 2022 Andrew Lord.

import Files

public struct InstallHooksService {
    public init() {}

    public func run() throws {
        printer.printMessage("🔨 Installing project Git hooks")

        try installGitHooks()
    }

    private func installGitHooks() throws {
        let gitHooksDirectory = try handleFatalError {
            try Folder.current.gitHooks()
        }
        let projectHooksDirectory = try handleFatalError {
            try Folder.current.projectHooks()
        }

        for hook in gitHooks {
            if !projectHooksDirectory.containsSubfolder(named: hook) {
                continue
            }
            handleNonFatalError {
                try gitHooksDirectory
                    .resolveHookFile(hook)
                    .setupAsHookFile()
            }
        }
    }
}

private extension Folder {
    func resolveHookFile(_ hook: String) throws -> File {
        if containsFile(named: hook) {
            try handleExistingHookFile(hook)
        }
        return try createNewHookFile(for: hook)
    }

    func handleExistingHookFile(_ hook: String) throws {
        guard let existingFile = try? file(named: hook) else {
            return
        }
        let hookContents = try readHookFileContents(hook: hook, file: existingFile)
        if hookContents.contains(File.autoGeneratedIdentifier) {
            try deleteExistingHookFile(hook: hook, file: existingFile)
        } else {
            try backupNoGeneratedHookFile(hook: hook, file: existingFile)
        }
    }

    func readHookFileContents(hook: String, file: File) throws -> String {
        do {
            return try file.readAsString()
        } catch is ReadError {
            throw SharedHooksError.resovingHookFile(hook: hook, reason: .readExistingHookFileContents)
        }
    }

    func deleteExistingHookFile(hook: String, file: File) throws {
        do {
            try file.delete()
        } catch is LocationError {
            throw SharedHooksError.resovingHookFile(hook: hook, reason: .deletingExisting)
        }
    }

    func backupNoGeneratedHookFile(hook: String, file: File) throws {
        do {
            try file.rename(to: "\(file.name).backup")
        } catch is LocationError {
            throw SharedHooksError.resovingHookFile(hook: hook, reason: .renamingBackup)
        }
    }

    func createNewHookFile(for hook: String) throws -> File {
        do {
            return try createFile(named: hook)
        } catch is WriteError {
            throw SharedHooksError.resovingHookFile(hook: hook, reason: .creatingNew)
        }
    }
}

private extension File {
    func setupAsHookFile() throws {
        try write(hookTemplate)
        try append(File.autoGeneratedIdentifier)
        try setPermissions(
            owner: [.execute, .write, .read],
            group: [.execute, .write, .read],
            others: [.execute, .write, .read]
        )
    }
}
