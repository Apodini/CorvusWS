// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CorvusWS",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "CorvusWS",
            targets: ["CorvusWS"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0"),
        .package(url: "https://github.com/Apodini/corvus.git", from: "0.0.16")
    ],
    targets: [
        .target(
            name: "CorvusWS",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "Corvus", package: "corvus")
        ]),
        .testTarget(
            name: "CorvusWSTests",
            dependencies: [
                .target(name: "CorvusWS"),
                .product(name: "XCTVapor", package: "vapor")])
    ]
)
