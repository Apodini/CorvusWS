import Foundation
import Vapor
import Corvus

/// A protocol most Corvus components in a hierarchy conform to, so that they
/// may be treated as the same type interchangeably.
public protocol ExtendedEndpoint {

    /// The content of an `ExtendedEndpoint`, used for components which can harbor other
    /// components, e.g.`ExtendedGroup`.
    var content: ExtendedEndpoint { get }

    /// A method needed to implement registration of an endpoint to the
    /// `Router` provided by Vapor, this handles the logic of making certain
    /// operations accessible on certain route paths.
    ///
    /// - Parameter routes: The `RoutesBuilder` containing HTTP route
    /// information up to this point.
    func register(to routes: RoutesBuilder)

}

extension ExtendedEndpoint {

    /// A default implementation of `.register()` for components that do not
    /// need special behaviour.
    ///
    /// - Parameter routes: The `RoutesBuilder` containing HTTP route
    /// information up to this point.
    public func register(to routes: RoutesBuilder) {
        content.register(to: routes)
    }
}

extension ExtendedEndpoint {

    /// An empty default implementation for `content` for components that do not
    /// have it.
    public var content: ExtendedEndpoint { EmptyExtendedEndpoint() }
}

/// An `Array` of `ExtendedEndpoint` is registered by registering all of the
/// `Array`'s elements.
///
/// - Parameter routes: The `RoutesBuilder` containing HTTP route
/// information up to this point.
extension Array: ExtendedEndpoint where Element == ExtendedEndpoint {

    public func register(to routes: RoutesBuilder) {
        forEach({ $0.register(to: routes) })
    }
}
