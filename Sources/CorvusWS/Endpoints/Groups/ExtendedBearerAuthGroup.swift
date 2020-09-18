import Vapor
import Fluent
import Corvus

/// A special type of `ExtendedGroup` that protects its `content` with bearer token
/// authentication for a generic `CorvusModelTokenAuthenticatable`.
public struct ExtendedBearerAuthGroup<T: CorvusModelTokenAuthenticatable>: ExtendedEndpoint {

    /// An array of `PathComponent` describing the path that the
    /// `BearerAuthGroup` extends.
    let pathComponents: [PathComponent]

    /// The content of the `ExtendedBearerAuthGroup`, which can be any kind of Corvus
    /// component.
    public var content: ExtendedEndpoint

    /// Creates an `ExtendedBearerAuthGroup` from a path and a builder function passed as
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

    /// A method that registers the `content` of the `ExtendedBearerAuthGroup` to the
    /// supplied `RoutesBuilder`. It also registers basic authentication
    /// middleware using `T`conforming to `CorvusModelUserToken`.
    ///
    /// - Parameter routes: A `RoutesBuilder` containing all the information
    /// about the HTTP route leading to the current component.
    public func register(to routes: RoutesBuilder) {
        let groupedRoutesBuilder: RoutesBuilder = pathComponents.reduce(
            routes, {
                $0.grouped($1)
            }
        )

        let guardedRoutesBuilder = groupedRoutesBuilder.grouped([
            T.authenticator(),
            T.User.guardMiddleware()
        ])

        content.register(to: guardedRoutesBuilder)
    }
}
