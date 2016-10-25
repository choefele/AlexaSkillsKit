import Foundation
import AlexaSkillsKit
import XCTest

class ResponseTests: XCTestCase {
    static let allTests = [
        ("testStandardResponse", testStandardResponse)
    ]
    
    func testStandardResponse() {
        let outputSpeech = OutputSpeech.plain(text: "text")
        let image = Image(smallImageUrl: URL(fileURLWithPath: "path"), largeImageUrl: URL(fileURLWithPath: "path"))
        let card = Card.standard(title: "title", text: "text", image: image)
        let standardResponse = StandardResponse(outputSpeech: outputSpeech, card: card, reprompt: outputSpeech, shouldEndSession: true)
        XCTAssertEqual(standardResponse, standardResponse)
        XCTAssertEqual(standardResponse, StandardResponse(outputSpeech: outputSpeech, card: card, reprompt: outputSpeech, shouldEndSession: true))
        
        XCTAssertNotEqual(standardResponse, StandardResponse(outputSpeech: outputSpeech, card: card, reprompt: outputSpeech, shouldEndSession: false))
    }
}
