import AlexaSkillsKit
import XCTest

class RequestTests: XCTestCase {
    func testSlot() {
        let slot = Slot(name: "name", value: "value")
        XCTAssertEqual(slot, slot)
        XCTAssertEqual(slot, Slot(name: "name", value: "value"))
        XCTAssertNotEqual(slot, Slot(name: "namex", value: "value"))
        XCTAssertNotEqual(slot, Slot(name: "name", value: "valuex"))
        XCTAssertNotEqual(slot, Slot(name: "namex"))
    }
}
