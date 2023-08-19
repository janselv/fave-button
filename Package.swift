// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FaveButton",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FaveButton",
            targets: ["FaveButton"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FaveButton",
            dependencies: [],
            path: "Source"
          )
    ],
    swiftLanguageVersions: [.v5]
)
