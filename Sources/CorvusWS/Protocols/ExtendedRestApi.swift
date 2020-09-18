import Foundation
import Vapor
import Corvus

/// A component that is used at the root of each API and can get registered
/// to a `Vapor` `Application` by conforming to `RouteCollection`. It also
/// conforms to `ExtendedEndpoint` to remain composable itself.
public protocol ExtendedRestApi: RouteCollection, ExtendedEndpoint {}

/// An extension providing a default implementation for the `RouteCollection`'s
/// `.boot()` method, recursively invoking registration for all of its
/// `content`.
extension ExtendedRestApi {

    /// A default implementation for `boot` that recurses down the API's
    /// hierarchy.
    ///
    /// - Parameter routes: The `RoutesBuilder` containing HTTP route
    /// information up to this point.
    /// - Throws: An error if registration fails.
    public func boot(routes: RoutesBuilder) throws {
        content.register(to: routes)
    }
}
