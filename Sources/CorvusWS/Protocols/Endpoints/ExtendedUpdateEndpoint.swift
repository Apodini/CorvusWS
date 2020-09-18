import Vapor
import Fluent

/// A special `ExtendedAuthEndpoint` used to provide a common interface for `ExtendedUpdate`
/// components so they can access their own `.auth` modifier.
public protocol ExtendedUpdateEndpoint: ExtendedAuthEndpoint {}
