import Foundation
import Vapor
import Corvus

public struct ExtendedGroup: ExtendedEndpoint {

    /// An array of `PathComponent` describing the path that the
    /// `ExtendedBearerAuthGroup` extends.
    let pathComponents: [PathComponent]

    /// The content of the `ExtendedBasicAuthGroup`, which can be any kind of Corvus
    /// component.
    public var content: ExtendedEndpoint

    /// Creates an `ExtendedGroup` from a path and a builder function passed as
    /// a closure.
    ///
    /// - Parameters:
    ///     - pathComponents: One or more objects describing the route.
    ///     - content: An `ExtendedEndpointBuilder`, which is a function builder that
    ///     takes in multiple `ExtendedEndpoints` and returns them as a single
    ///     `ExtendedEndpoint`.
    public init(
        _ pathComponents: PathComponent...,
        @ExtendedEndpointBuilder content: () -> ExtendedEndpoint
    ) {
        self.pathComponents = pathComponents
        self.content = content()
    }

    /// Creates an `ExtendedGroup` from a path and a builder function passed as
    /// a closure.
    ///
    /// - Parameters:
    ///     - pathComponents: One or more objects describing the route.
    ///     - content: An `ExtendedEndpointBuilder`, which is a function builder that
    ///     takes in multiple `ExtendedEndpoints` and returns them as a single
    ///     `ExtendedEndpoint`.
    public init(
        _ pathComponents: [PathComponent],
        @ExtendedEndpointBuilder content: () -> ExtendedEndpoint
    ) {
        self.pathComponents = pathComponents
        self.content = content()
    }

    /// A method that registers the `content` of the `ExtendedGroup` to the
    /// supplied `RoutesBuilder`.
    ///
    /// - Parameter routes: A `RoutesBuilder` containing all the information
    /// about the HTTP route leading to the current component.
    public func register(to routes: RoutesBuilder) {
        let groupedRoutesBuilder: RoutesBuilder = pathComponents.reduce(
            routes, { $0.grouped($1) })
        content.register(to: groupedRoutesBuilder)
    }
}
