import XCTest
#if canImport(CoreUI)
@testable import CoreUI
#else
@testable import AutumnUI
@testable import SpringUI
#endif

final class CoreUITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
