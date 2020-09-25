import XCTest
@testable import CoolDown

final class CoolDownTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CoolDown().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
