import XCTest
@testable import CorvusWS
import XCTVapor
import Fluent

class CorvusWSTests: XCTestCase {
    let app = Application(.testing)

    override func setUpWithError() throws {
        try super.setUpWithError()

        try app.autoMigrate().wait()
    }

    override func tearDownWithError() throws {
        let app = try XCTUnwrap(self.app)
        app.shutdown()
    }

    func tester() throws -> XCTApplicationTester {
        try XCTUnwrap(app.testable())
    }

    func database() throws -> Database {
        try XCTUnwrap(self.app.db)
    }
}
