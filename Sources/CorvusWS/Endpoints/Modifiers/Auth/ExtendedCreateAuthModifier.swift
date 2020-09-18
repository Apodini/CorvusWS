import Vapor
import Fluent
import Corvus

/// A class that wraps a `ExtendedCreate` component which utilizes an `.auth()`
/// modifier. That allows Corvus to chain modifiers, as it gets treated as any
/// other struct conforming to `ExtendedCreateAuthModifier`. Requires an object `U` that
/// represents the user to authorize.
public final class ExtendedCreateAuthModifier<
    A: ExtendedCreateEndpoint,
    U: CorvusModelAuthenticatable>:
ExtendedAuthModifier<A, U>, ExtendedCreateEndpoint {

    /// A method which checks if the user `U` supplied in the `Request` is
    /// equal to the user belonging to the particular `QuerySubject`.
    ///
    /// - Parameter req: An incoming `Request`.
    /// - Returns: An `EventLoopFuture` containing an eagerloaded value as
    /// defined by `Element`. If authorization fails or a user is not found,
    /// HTTP `.unauthorized` and `.notFound` are thrown respectively.
    /// - Throws: An `Abort` error if an item is not found.
    override public func handler(_ req: Request)
        throws -> EventLoopFuture<Element> {
        let requestContent = try req.content.decode(A.QuerySubject.self)
        let requestUser = requestContent[keyPath: self.userKeyPath]

        guard let authorized = req.auth.get(U.self) else {
            throw Abort(.unauthorized)
        }

        if authorized.id == requestUser.id {
            return try modifiedEndpoint.handler(req)
        } else {
            return req.eventLoop.makeFailedFuture(Abort(.unauthorized))
        }
    }
}

/// An extension that adds the `.auth()` modifier to components conforming to
/// `ExtendedCreateEndpoint`.
extension ExtendedCreateEndpoint {

    /// A modifier used to make sure components only authorize requests where
    /// the supplied user `U` is actually related to the `QuerySubject`.
    ///
    /// - Parameter user: A `KeyPath` to the related user property.
    /// - Returns: An instance of an `ExtendedCreateAuthModifier` with the supplied
    /// `KeyPath` to the user.
    public func auth<U: CorvusModelAuthenticatable>(
        _ user: ExtendedCreateAuthModifier<Self, U>.UserKeyPath
    ) -> ExtendedCreateAuthModifier<Self, U> {
        ExtendedCreateAuthModifier(self, user: user)
    }
}
