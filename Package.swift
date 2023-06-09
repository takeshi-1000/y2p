// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "y2p",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/behrang/YamlSwift.git", from: "3.4.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "y2p",
            dependencies: [
                .target(name: "y2pCLI")
            ]
        ),
        .target(
            name: "y2pCLI",
            dependencies: [
                .target(name: "YamlParserKit"),
                .target(name: "FileGenKit"),
                .target(name: "Data"),
            ]
        ),
        .target(
            name: "YamlParserKit",
            dependencies: [
                .target(name: "Data"),
                .product(name: "Yaml", package: "YamlSwift"),
            ]
        ),
        .target(
            name: "FileGenKit",
            dependencies: [
                .target(name: "Data"),
            ]
        ),
        .target(
            name: "Data",
            dependencies: []
        ),
        .testTarget(
            name: "y2pTests",
            dependencies: [
                .target(name: "y2p")
            ]),
        .testTarget(
            name: "y2pCLITests",
            dependencies: [
                .target(name: "y2pCLI")
            ]),
        .testTarget(
            name: "FileGenKitTests",
            dependencies: [
                .target(name: "FileGenKit")
            ]),
        .testTarget(
            name: "DataTests",
            dependencies: [
                .target(name: "Data")
            ]),
    ]
)
