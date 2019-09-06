// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "e16server",
    products: [
      .executable(name: "e16server",
                  targets: [
                    "Server",
		  ]
      ),
    ],
    dependencies: [
        .package(url: "https://github.com/CSCIX65G/smoke-framework.git", .branch("swift5")),
        .package(url: "https://github.com/CSCIX65G/Shell.git", .branch("swift5")),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.8.1")
    ],
    targets: [
        .target(
            name: "Server",
            dependencies: ["HeliumLogger", "SmokeHTTP1", "SmokeOperationsHTTP1", "Shell"]),
        .testTarget(
            name: "ServerTests",
            dependencies: ["Server"]),
    ]
)
