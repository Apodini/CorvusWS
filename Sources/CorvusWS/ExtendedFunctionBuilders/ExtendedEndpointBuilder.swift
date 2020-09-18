import Foundation
import Corvus

@_functionBuilder
public enum ExtendedEndpointBuilder {

    /// A method that transforms multiple `ExtendedEndpoints` into one.
    ///
    /// - Parameter endpoints: One or more `ExtendedEndpoints` to transform into a
    /// single endpoint.
    /// - Returns: An abstract `Endpoint` consisting of one or more endpoints.
    public static func buildBlock(_ endpoints: ExtendedEndpoint...) -> ExtendedEndpoint {
        endpoints
    }

    /// A method that enables the use of if-else in the Corvus DSL. This returns
    /// `ExtendedEndpoints` within the if-part.
    ///
    /// - Parameter first: One or more `ExtendedEndpoints` to transform into a
    /// single endpoint.
    public static func buildEither(first: ExtendedEndpoint) -> ExtendedEndpoint {
        first
    }

    /// A method that enables the use of if-else in the Corvus DSL. This returns
    /// `ExtendedEndpoints` within the else-part.
    ///
    /// - Parameter first: One or more `ExtendedEndpoints` to transform into a
    /// single endpoint.
    public static func buildEither(second: ExtendedEndpoint) -> ExtendedEndpoint {
        second
    }

}
