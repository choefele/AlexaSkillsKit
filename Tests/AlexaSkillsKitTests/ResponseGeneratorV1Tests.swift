import Foundation
import AlexaSkillsKit
import XCTest

class ResponseGeneratorV1Tests: XCTestCase {
    static let allTests = [
        ("testResponseMinimal", testResponseMinimal),
        ("testSessionAttributes", testSessionAttributes),
        ("testStandardResponseOutputSpeechPlain", testStandardResponseOutputSpeechPlain),
        ("testStandardResponseShouldEndSessionFalse", testStandardResponseShouldEndSessionFalse),
        ("testStandardResponseOutputSpeechPlain", testStandardResponseOutputSpeechPlain),
        ("testStandardResponseCardSimple", testStandardResponseCardSimple),
        ("testStandardResponseCardStandard", testStandardResponseCardStandard),
        ("testStandardResponseRepromptPlain", testStandardResponseRepromptPlain),
        ("testGenerateJSONTrue", testGenerateJSONTrue),
        ("testGenerateJSONFalse", testGenerateJSONFalse)
    ]
    
    var generator: ResponseGeneratorV1!
    
    override func setUp() {
        super.setUp()
        
        generator = ResponseGeneratorV1()
    }

    func testResponseMinimal() {
        let json = generator.generateJSONObject()
        XCTAssertEqual(json["version"] as? String, "1.0")

        XCTAssertNil(json["sessionAttributes"])
        let jsonResponse = json["response"] as? [String: Any]
        XCTAssertEqual(jsonResponse?.count, 0)
    }
    
    func testSessionAttributes() {
        let sessionAttributes: [String: Any] = ["1": 1, "2": "two"]
        generator.update(standardResponse: nil, sessionAttributes: sessionAttributes)

        let json = generator.generateJSONObject()
        let jsonSessionAttributes = json["sessionAttributes"] as? [String: Any]
        XCTAssertEqual(jsonSessionAttributes?["1"] as? Int, sessionAttributes["1"] as? Int)
        XCTAssertEqual(jsonSessionAttributes?["2"] as? String, sessionAttributes["2"] as? String)
    }
    
    func testStandardResponseOutputSpeechPlain() {
        let outputSpeech = OutputSpeech.plain(text: "text")
        let standardResponse = StandardResponse(outputSpeech: outputSpeech)
        generator.update(standardResponse: standardResponse, sessionAttributes: [:])
        
        let json = generator.generateJSONObject()
        let jsonResponse = json["response"] as? [String: Any]
        let jsonOutputSpeech = jsonResponse?["outputSpeech"] as? [String: Any]
        XCTAssertEqual(jsonOutputSpeech?.count, 2)
        XCTAssertEqual(jsonOutputSpeech?["type"] as? String, "PlainText")
        XCTAssertEqual(jsonOutputSpeech?["text"] as? String, "text")
    }
    
    func testStandardResponseCardSimple() {
        let card = Card.simple(title: "title", content: "content")
        let standardResponse = StandardResponse(card: card)
        generator.update(standardResponse: standardResponse, sessionAttributes: [:])
        
        let json = generator.generateJSONObject()
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
        let standardResponse = StandardResponse(card: card)
        generator.update(standardResponse: standardResponse, sessionAttributes: [:])
        
        let json = generator.generateJSONObject()
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
        let standardResponse = StandardResponse(reprompt: outputSpeech)
        generator.update(standardResponse: standardResponse, sessionAttributes: [:])
        
        let json = generator.generateJSONObject()
        let jsonResponse = json["response"] as? [String: Any]
        let jsonReprompt = jsonResponse?["reprompt"] as? [String: Any]
        let jsonOutputSpeech = jsonReprompt?["outputSpeech"] as? [String: Any]
        XCTAssertEqual(jsonOutputSpeech?.count, 2)
        XCTAssertEqual(jsonOutputSpeech?["type"] as? String, "PlainText")
        XCTAssertEqual(jsonOutputSpeech?["text"] as? String, "text")
    }

    func testStandardResponseShouldEndSessionTrue() {
        let standardResponse = StandardResponse(shouldEndSession: true)
        generator.update(standardResponse: standardResponse, sessionAttributes: [:])
        
        let json = generator.generateJSONObject()
        let jsonResponse = json["response"] as? [String: Any]
        XCTAssertNil(jsonResponse?["shouldEndSession"])
    }
    
    func testStandardResponseShouldEndSessionFalse() {
        let standardResponse = StandardResponse(shouldEndSession: false)
        generator.update(standardResponse: standardResponse, sessionAttributes: [:])
        
        let json = generator.generateJSONObject()
        let jsonResponse = json["response"] as? [String: Any]
        #if os(Linux)
            XCTAssertEqual(jsonResponse?["shouldEndSession"] as? NSNumber, 0)
        #else
            XCTAssertEqual(jsonResponse?["shouldEndSession"] as? Bool, false)
        #endif
    }
    
    func testGenerateJSONTrue() {
        // JSONSerialization bug with Bools: https://bugs.swift.org/browse/SR-3013
        let standardResponse = StandardResponse(shouldEndSession: true)
        generator.update(standardResponse: standardResponse, sessionAttributes: [:])

        if true {
            let jsonData = try? generator.generateJSON()
            let jsonString = jsonData.flatMap { String(data: $0, encoding: .utf8) }
            XCTAssertTrue(jsonString?.contains("shouldEndSession") == false)
        }

        if true {
            let jsonData = try? generator.generateJSON(options: .prettyPrinted)
            let jsonString = jsonData.flatMap { String(data: $0, encoding: .utf8) }
            XCTAssertTrue(jsonString?.contains("shouldEndSession") == false)
        }
    }

    func testGenerateJSONFalse() {
        // JSONSerialization bug with Bools: https://bugs.swift.org/browse/SR-3013
        let standardResponse = StandardResponse(shouldEndSession: false)
        generator.update(standardResponse: standardResponse, sessionAttributes: [:])

        if true {
            let jsonData = try? generator.generateJSON()
            let jsonString = jsonData.flatMap { String(data: $0, encoding: .utf8) }
            XCTAssertTrue(jsonString?.contains("\"shouldEndSession\":false") == true)
        }

        if true {
            let jsonData = try? generator.generateJSON(options: .prettyPrinted)
            let jsonString = jsonData.flatMap { String(data: $0, encoding: .utf8) }
            #if os(Linux)
                XCTAssertTrue(jsonString?.contains("\"shouldEndSession\": false") == true)
            #else
                XCTAssertTrue(jsonString?.contains("\"shouldEndSession\" : false") == true)
            #endif
        }
    }
}
