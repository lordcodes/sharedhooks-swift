// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "swifthooks",
    platforms: [.macOS(.v11)],
    products: [
        .executable(name: "swifthooks", targets: ["SwiftHooksCLI"]),
        .library(name: "SwiftHooksKit", targets: ["SwiftHooksKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", .exact("4.2.0")),
    ],
    targets: [
        .executableTarget(
            name: "SwiftHooksCLI",
            dependencies: [
                .target(name: "SwiftHooksKit"),
            ]
        ),
        .target(
            name: "SwiftHooksKit",
            dependencies: [
                .product(name: "Files", package: "Files"),
            ]
        ),
        .testTarget(
            name: "SwiftHooksKitTests",
            dependencies: ["SwiftHooksKit"]
        ),
    ]
)
