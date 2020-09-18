# CorvusWS

# Corvus

CorvusWS is an extension to [Corvus](https://github.com/Apodini/corvus), the first truly declarative server-side framework for Swift. It provides a declarative, composable syntax which makes it easy to get APIs up and running. It is based heavily on the existing work from [Vapor](https://github.com/vapor/vapor).

# Example

Below is an example of a WebSocket Endpoint.

```Swift
class EchoEndpoint: WebSocketEndpoint {
    var app: Application
    var pathComponent: PathComponent

    func onUpgrade(_ request: Request, _ ws: WebSocket) {}
    func onText(_ ws: WebSocket, _ text: String) {
        ws.send("Test")
    }

    init(_ pathComponent: PathComponent, _ app: Application) {
        self.pathComponent = pathComponent
        self.app = app
    }
}
```

# How to set up

After your Swift Project, in the `Package.Swift` file, you will need to add the dependencies 
for `CorvusWS`, `Corvus` and a `Fluent` database driver of your choice. Below is an example with an 
`SQLite` driver:

```Swift
// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "XpenseServer",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "XpenseServer", targets: ["XpenseServer"])
    ],
    dependencies: [
        .package(url: "https://github.com/Apodini/corvusWS.git", from: "0.0.1"),
        .package(url: "https://github.com/Apodini/corvus.git", from: "0.0.14"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0-rc")
    ],
    targets: [
        .target(name: "Run",
                dependencies: [
                    .target(name: "XpenseServer")
                ]),
        .target(name: "XpenseServer",
                dependencies: [
                    .product(name: "Corvus", package: "corvus"),
                    .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver")
                ]),
        .testTarget(name: "XpenseServerTests",
                    dependencies: [
                        .target(name: "XpenseServer"),
                        .product(name: "XCTVapor", package: "vapor"),
                        .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver")
                    ])
    ]
)
```

# How to contribute

Review our [contribution guidelines](https://github.com/Apodini/.github/blob/release/CONTRIBUTING.md) for contribution formalities.

# Sources

[Corvus](https://github.com/Apodini/corvus)

[Vapor](https://github.com/vapor/vapor)

[Fluent](https://github.com/vapor/fluent)
