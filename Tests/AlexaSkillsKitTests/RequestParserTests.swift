import AlexaSkillsKit
import XCTest

func createFilePath(for fileName: String) -> URL {
    return URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .appendingPathComponent(fileName)
}

class RequestParserTests: XCTestCase {
    static let allTests = [
        ("testLaunchRequest", testLaunchRequest)
    ]
    
    func testLaunchRequest() throws {
        let parser = try RequestParser(contentsOf: createFilePath(for: "launchRequest.json"))
        let requestType = parser.parseRequestType()
        XCTAssertEqual(requestType, .launch)
    }
    
    func testIntentRequest() throws {
        let parser = try RequestParser(contentsOf: createFilePath(for: "intentRequest.json"))
        let requestType = parser.parseRequestType()
        XCTAssertEqual(requestType, .intent)
    }
    
    func testSessionEndedRequest() throws {
        let parser = try RequestParser(contentsOf: createFilePath(for: "sessionEndedRequest.json"))
        let requestType = parser.parseRequestType()
        XCTAssertEqual(requestType, .sessionEnded)
    }
}
