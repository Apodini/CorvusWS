import Foundation
import Vapor
import Corvus

public final class ExtendedApi: ExtendedRestApi {
    public let content: ExtendedEndpoint

    /// An array of `PathComponent` describing the path that the
    /// `ExtendedApi` extends.
    public let pathComponents: [PathComponent]

    /// Creates an `ExtendedApi` from a path and a builder function passed as
    /// a closure.
    ///
    /// - Parameters:
    ///     - pathComponents: One or more objects describing the route.
    ///     - content: An `ExtendedEndpointBuilder`, which is a function builder that
    ///     takes in multiple `ExtendedEndpoints` and returns them as a single
    ///     `ExtendedEndpoint`.
    public init(
        _ pathComponents: PathComponent...,
        @ExtendedEndpointBuilder content: () -> ExtendedEndpoint) {
        self.pathComponents = pathComponents
        self.content = ExtendedGroup(pathComponents) { content() }
    }
}
