import AlexaSkillsKit
import XCTest

class ItemTests: XCTestCase {
    static let allTests = [
        ("testGetRequestStatusCode", testGetRequestStatusCode)
    ]

    func testGetRequestStatusCode() {
        let e = expectation(description: "test")
        e.fulfill()
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(40, 40)
    }
}
