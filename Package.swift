// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MySQLDriver",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/BlueSocket.git", from:"1.0.8"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.9.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MySQLDriver",
            dependencies: ["Socket", "CryptoSwift"]),
        .testTarget(
            name: "MySQLDriverTests",
            dependencies: ["MySQLDriver"]),
    ]
)
