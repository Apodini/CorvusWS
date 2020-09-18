import Foundation
import Vapor
import Corvus

/// A protocol that provides functionality to create WebSockets and conforms to
/// `ExtendedEndpoint`.
public protocol WebSocketEndpoint: ExtendedEndpoint {

    var pathComponent: PathComponent { get }

    /// The `Vapor` application  which is used to implement a WebSocket `Route`.
    var app: Application {get}

}

/// Extends `WebSocketEndpoint` with default implementation for route registration.
public extension WebSocketEndpoint {

    /// This function is called when a WebSocket connection between client and server is established.
    /// - Parameters:
    ///     - request: An incoming `Request`.
    ///     - ws: The `WebSocket `which can be used to transfer data.
    func onUpgrade(_ request: Request, _ ws: WebSocket) {}

    /// This function is called when the client sends a String.
    /// - Parameters:
    ///     - ws: The `WebSocket` which is used for the connection.
    ///     - text: The String that the client sent.
    func onText(_ ws: WebSocket, _ text: String) {}

    var operationType: OperationType { .get }

    /// The empty  `pathComponents` of the `ExtendedRestEndpoint`.
    var pathComponent: PathComponent { "" }

    /// Registers the component to the `Vapor` router depending on its
    /// `operationType`.
    ///
    /// - Parameter routes: The `RoutesBuilder` to extend.
    func register(to routes: RoutesBuilder) {
        routes.add(app.webSocket(pathComponent) { req, ws in
            self.onUpgrade(req, ws)
    })
}

}
