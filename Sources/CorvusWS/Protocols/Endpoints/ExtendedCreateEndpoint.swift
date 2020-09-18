import Vapor
import Fluent

/// A special `ExtendedAuthEndpoint` used to provide a common interface for `ExtendedCreate`
/// components so they can access their own `.auth` modifier.
public protocol ExtendedCreateEndpoint: ExtendedAuthEndpoint {}
