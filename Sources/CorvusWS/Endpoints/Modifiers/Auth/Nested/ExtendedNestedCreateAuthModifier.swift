import Vapor
import Fluent
import Corvus

/// A class that wraps an `ExtendedCreate` component which utilizes an `.auth()`
/// modifier. That allows Corvus to chain modifiers, as it gets treated as any
/// other struct conforming to `ExtendedNestedCreateAuthModifier`. Requires an object
/// `U` that represents the user to authorize.
public final class ExtendedNestedCreateAuthModifier<
    A: ExtendedCreateEndpoint,
    I: CorvusModel,
    U: CorvusModelAuthenticatable>:
ExtendedNestedAuthModifier<A, I, U>, ExtendedCreateEndpoint {

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

        guard let intermediateId = requestContent[
              keyPath: self.intermediateKeyPath
        ].$id.value else {
            throw Abort(.notFound)
        }

        let authorized = I.query(on: req.db)
            .filter(\._$id == intermediateId)
            .with(userKeyPath)
            .first()
            .flatMapThrowing { optionalIntermediate -> Bool in
                guard let intermediate = optionalIntermediate else {
                    throw Abort(.notFound)
                }

                guard let user = intermediate[
                    keyPath: self.userKeyPath
                ].value else {
                    throw Abort(.notFound)
                }

                guard let authorized = req.auth.get(U.self) else {
                    throw Abort(.unauthorized)
                }

                return user.id == authorized.id

            }

        return authorized.flatMap { authorized in
            guard authorized else {
                return req.eventLoop.makeFailedFuture(Abort(.unauthorized))
            }

            do {
                return try self.modifiedEndpoint.handler(req)
            } catch {
                return req.eventLoop.makeFailedFuture(error)
            }
        }
    }
}

/// An extension that adds the `.auth()` modifier to components conforming to
/// `ExtendedCreateEndpoint`.
extension ExtendedCreateEndpoint {

    /// A modifier used to make sure components only authorize requests where
    /// the supplied user `U` is actually related to the `QuerySubject`.
    ///
    /// - Parameters:
    ///     - intermediate: A `KeyPath` to the intermediate property.
    ///     - user: A `KeyPath` to the related user property from the
    ///     intermediate.
    /// - Returns: An instance of an `ExtendedAuthModifier` with the supplied `KeyPath`
    /// to the user.
    public func auth<I: CorvusModel, U: CorvusModelAuthenticatable> (
        _ intermediate: ExtendedNestedCreateAuthModifier<Self, I, U>.IntermediateKeyPath,
        _ user: ExtendedNestedCreateAuthModifier<Self, I, U>.UserKeyPath
    ) -> ExtendedNestedCreateAuthModifier<Self, I, U> {
        ExtendedNestedCreateAuthModifier(self, intermediate: intermediate, user: user)
    }
}
