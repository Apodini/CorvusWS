import Vapor
import Fluent

/// A special `ExtendedRestEndpoint` used to provide a common interface for endpoints
/// which provide access to the `.auth()` modifier.
public protocol ExtendedAuthEndpoint: ExtendedRestEndpoint {}
