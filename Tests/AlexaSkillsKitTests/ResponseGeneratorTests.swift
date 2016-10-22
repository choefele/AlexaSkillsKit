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
    
    func testStandardResponseOutputSpeechPlain() {
        let outputSpeech = OutputSpeech.plain(text: "text")
        let standardResponse = StandardResponse(outputSpeech: outputSpeech, shouldEndSession: true)
        let generator = ResponseGenerator(standardResponse: standardResponse)
        
        let json = generator.generateJson()
        let jsonResponse = json["response"] as? [String: Any]
        let jsonOutputSpeech = jsonResponse?["outputSpeech"] as? [String: Any]
        XCTAssertEqual(jsonOutputSpeech?.count, 2)
        XCTAssertEqual(jsonOutputSpeech?["type"] as? String, "PlainText")
        XCTAssertEqual(jsonOutputSpeech?["text"] as? String, "text")
    }
    
    func testStandardResponseCardSimple() {
        let card = Card.simple(title: "title", content: "content")
        let standardResponse = StandardResponse(card: card, shouldEndSession: true)
        let generator = ResponseGenerator(standardResponse: standardResponse)
        
        let json = generator.generateJson()
        let jsonResponse = json["response"] as? [String: Any]
        let jsonCard = jsonResponse?["card"] as? [String: Any]
        XCTAssertEqual(jsonCard?.count, 3)
        XCTAssertEqual(jsonCard?["type"] as? String, "Simple")
        XCTAssertEqual(jsonCard?["title"] as? String, "title")
        XCTAssertEqual(jsonCard?["content"] as? String, "content")
    }
    
    func testStandardResponseCardStandard() {
        let image = Image(smallImageUrl: URL(fileURLWithPath: "path"), largeImageUrl: URL(fileURLWithPath: "path"))
        let card = Card.standard(title: "title", text: "text", image: image)
        let standardResponse = StandardResponse(card: card, shouldEndSession: true)
        let generator = ResponseGenerator(standardResponse: standardResponse)
        
        let json = generator.generateJson()
        let jsonResponse = json["response"] as? [String: Any]
        let jsonCard = jsonResponse?["card"] as? [String: Any]
        XCTAssertEqual(jsonCard?.count, 4)
        XCTAssertEqual(jsonCard?["type"] as? String, "Standard")
        XCTAssertEqual(jsonCard?["title"] as? String, "title")
        XCTAssertEqual(jsonCard?["text"] as? String, "text")
        XCTAssertNotNil(jsonCard?["image"])
    }
    
    func testStandardResponseRepromptPlain() {
        let outputSpeech = OutputSpeech.plain(text: "text")
        let standardResponse = StandardResponse(reprompt: outputSpeech, shouldEndSession: true)
        let generator = ResponseGenerator(standardResponse: standardResponse)
        
        let json = generator.generateJson()
        let jsonResponse = json["response"] as? [String: Any]
        let jsonReprompt = jsonResponse?["reprompt"] as? [String: Any]
        let jsonOutputSpeech = jsonReprompt?["outputSpeech"] as? [String: Any]
        XCTAssertEqual(jsonOutputSpeech?.count, 2)
        XCTAssertEqual(jsonOutputSpeech?["type"] as? String, "PlainText")
        XCTAssertEqual(jsonOutputSpeech?["text"] as? String, "text")
    }
}
