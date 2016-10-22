import AlexaSkillsKit
import XCTest

class ResponseGeneratorTests: XCTestCase {
    func testStandardResponseMinimal() {
        let response = StandardResponse(shouldEndSession: true)
        let generator = ResponseGenerator(response: response)
        
        let json = generator.generateJson()
        XCTAssertEqual(json["version"] as? String, "1.0")
        XCTAssertNotNil(json["response"])
    }
}
