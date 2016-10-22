import AlexaSkillsKit
import XCTest

class ResponseGeneratorTests: XCTestCase {
    func testStandardResponseMinimal() {
        let standardResponse = StandardResponse(shouldEndSession: true)
        let generator = ResponseGenerator(standardResponse: standardResponse)
        
        let json = generator.generateJson()
        XCTAssertEqual(json["version"] as? String, "1.0")
        XCTAssertNotNil(json["response"])
    }
}
