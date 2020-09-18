import Vapor
import Fluent
import Corvus

/// A class that wraps a component which utilizes a `.respond(with:)` modifier.
/// That allows Corvus to chain modifiers, as it gets treated as any other
/// struct conforming to `ExtendedRestEndpoint`.
public final class ExtendedResponseModifier<E: ExtendedRestEndpoint, R: CorvusResponse>:
ExtendedRestEndpoint where E.Element == R.Item {

    /// The subject of an operation's queries in its `.query()` method.
    public typealias QuerySubject = E.QuerySubject

    /// The Element that is returned by the handler.
    public typealias Element = R

    /// The instance of `ExtendedEndpoint` the `ExtendedRestEndpointModifier` is modifying.
    let modifiedEndpoint: E

    /// The HTTP method of the functionality of the component.
    public let operationType: OperationType

    /// An array of `PathComponent` describing the path that the
    /// `TypedEndpoint` extends.
    public let pathComponents: [PathComponent]

    /// A method which transform the restEndpoints's handler return value to a
    /// `Response`.
    ///
    /// - Parameter req: An incoming `Request`.
    /// - Returns: An `EventLoopFuture` containing the
    /// `ResponseModifier`'s `Response`.
    /// - Throws: An `Abort` error if something goes wrong.
    public func handler(_ req: Request) throws -> EventLoopFuture<Element> {
        try modifiedEndpoint.handler(req).map(R.init)
    }

    /// Initializes the modifier with its underlying `RestEndpoint` and its
      /// `with` relation, which is the keypath to the related property.
      ///
      /// - Parameters:
      ///     - queryEndpoint: The `QueryEndpoint` which the modifer is attached
      ///     to.
      ///     - with: A `KeyPath` which leads to the desired property.
     init(_ restEndpoint: E) {
         self.modifiedEndpoint = restEndpoint
         self.operationType = modifiedEndpoint.operationType
         self.pathComponents = modifiedEndpoint.pathComponents
     }
}

/// An extension that adds a `.respond(with:)` modifier to `ExtendedRestEndpoint`.
extension ExtendedRestEndpoint {

    /// A modifier used to transform the values returned by a component using a
    /// `CorvusResponse`.
    ///
    /// - Parameter as: A type conforming to `CorvusResponse`.
    /// - Returns: An instance of a `ExtendednResponseModifier` with the supplied
    /// `CorvusResponse`.
    public func respond<R: CorvusResponse>(
        with: R.Type
    ) -> ExtendedResponseModifier<Self, R> {
        ExtendedResponseModifier(self)
    }
}
