import Foundation
import AlexaSkillsKit
import XCTest

class RequestTests: XCTestCase {
    static let allTests = [
        ("testLaunchRequest", testLaunchRequest),
        ("testIntentRequest", testIntentRequest),
        ("testSessionEndedRequest", testSessionEndedRequest)
    ]
    
    func testLaunchRequest() {
        let date = Date()
        let locale = Locale(identifier: "identifier")
        let request = Request(requestId: "requestId", timestamp: date, locale: locale)
        XCTAssertEqual(request, request)
        XCTAssertEqual(request, Request(requestId: "requestId", timestamp: date, locale: locale))
        
        XCTAssertNotEqual(request, Request(requestId: "x", timestamp: date, locale: locale))
    }
    
    func testIntentRequest() {
        let request0 = Request(requestId: "requestId", timestamp: Date(), locale: Locale(identifier: "identifier"))
        let slot = Slot(name: "name", value: "value")
        let intent = Intent(name: "name", slots: ["slot": slot])
        let intentRequest = IntentRequest(request: request0, intent: intent)
        XCTAssertEqual(intentRequest, intentRequest)
        XCTAssertEqual(intentRequest, IntentRequest(request: request0, intent: intent))
        
        let request1 = Request(requestId: "x", timestamp: Date(), locale: Locale(identifier: "x"))
        XCTAssertNotEqual(intentRequest, IntentRequest(request: request1, intent: intent))
    }
    
    func testSessionEndedRequest() {
        let request0 = Request(requestId: "requestId", timestamp: Date(), locale: Locale(identifier: "identifier"))
        let reason: Reason = .error(Error(type: .invalidResponse, message: "message"))
        let sessionEndedRequest = SessionEndedRequest(request: request0, reason: reason)
        XCTAssertEqual(sessionEndedRequest, sessionEndedRequest)
        XCTAssertEqual(sessionEndedRequest, SessionEndedRequest(request: request0, reason: reason))

        let request1 = Request(requestId: "x", timestamp: Date(), locale: Locale(identifier: "x"))
        XCTAssertNotEqual(sessionEndedRequest, SessionEndedRequest(request: request1, reason: reason))
    }
}
