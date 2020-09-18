import Vapor
import Fluent
import Corvus

/// A special `ExtendedAuthEndpoint` used to provide a common interface for endpoints
/// which provide access to modifiers that are applcable for Database read
/// requests
public protocol ExtendedReadEndpoint: ExtendedAuthEndpoint {}

extension ExtendedReadEndpoint {

    public var operationType: OperationType { .get }
}
