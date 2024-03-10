// Copyright © 2022 Andrew Lord.

import Files
import Foundation

struct Permission: OptionSet {
    var rawValue: Int

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    var binaryRepresentation: String {
        var binary = String(rawValue, radix: 2)
        while binary.count < 3 {
            binary = "0" + binary
        }
        return binary
    }

    static func binaryRepresentation(of permissions: [Permission]) -> String {
        permissions.map(\.binaryRepresentation).joined()
    }

    static func octalRepresentation(of permissions: [Permission]) -> Int {
        let binary = binaryRepresentation(of: permissions)
        return Int(binary, radix: 2)!
    }

    static let execute = Permission(rawValue: 1)
    static let write = Permission(rawValue: 2)
    static let read = Permission(rawValue: 4)
}

extension File {
    func setPermissions(owner: Permission, group: Permission = [], others: Permission = []) throws {
        do {
            let octal = Permission.octalRepresentation(of: [owner, group, others])
            try FileManager.default.setAttributes([.posixPermissions: octal], ofItemAtPath: path)
        } catch {
            throw PermissionsError()
        }
    }
}

struct PermissionsError: LocalizedError {
    var errorDescription: String? {
        "Error: Failed to set file permissions"
    }
}
