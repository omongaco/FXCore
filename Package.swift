// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "FXCore",
    platforms: [
        .iOS(.v13) // This sets the minimum deployment target to iOS 13
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FXCore",
            targets: ["FXCore"]),
    ],
    dependencies: [
        // List your package's dependencies here, for example:
        .package(
            url: "https://github.com/marmelroy/Localize-Swift.git",
            .upToNextMajor(from: "3.2.0")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FXCore",
            dependencies: [
                // This should match the product name of the dependency if it's different from the package name
                .product(name: "Localize_Swift", package: "Localize-Swift")
            ],
            path: "Sources"),
        .testTarget(
            name: "FXCoreTests",
            dependencies: ["FXCore"]),
    ],
    swiftLanguageVersions: [.v5]
)
