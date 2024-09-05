// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AUnitViews",
    defaultLocalization: "en",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "AUnitViews", targets: ["AUnitViews"]),
    ],
    dependencies: [
        .package(url: "https://github.com/RapboyGao/AUnit.git", branch: "main"),
        .package(url: "https://github.com/RapboyGao/AViewUI.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "AUnitViews", dependencies: [.product(name: "AUnit", package: "AUnit"), .product(name: "AViewUI", package: "AViewUI")], resources: [.process("Resources")]),
        .testTarget(name: "AnitTests", dependencies: ["AUnitViews"]),
    ])
