import Vapor

/// An empty default value when no `ExtendedEndpoint` value is needed.
public struct EmptyExtendedEndpoint: ExtendedEndpoint {

    /// An empty default implementation of `.register()` to avoid endless loops
    /// when registering `ExtendedEmptyEndpoint`s.
    ///
    /// - Parameter routes: The `RoutesBuilder` that contains HTTP route
    /// information up to this point.
    public func register(to routes: RoutesBuilder) {}
}
