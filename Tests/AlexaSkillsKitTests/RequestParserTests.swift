import Foundation
import AlexaSkillsKit
import XCTest

private func createFilePath(for fileName: String) -> URL {
    return URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .appendingPathComponent(fileName)
}

private func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
    let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
    var gregorian = Calendar(identifier: .gregorian)
    gregorian.timeZone = TimeZone(abbreviation: "UTC")!
    let date = gregorian.date(from: components)
    return date!
}

class RequestParserTests: XCTestCase {
    static let allTests = [
        ("testSession", testSession),
        ("testLaunchRequest", testLaunchRequest),
        ("testIntentRequest", testIntentRequest),
        ("testSessionEndedRequest", testSessionEndedRequest)
    ]
    
    func testSession() throws {
        let parser = try RequestParser(contentsOf: createFilePath(for: "intent_request.json"))
        
        let session = parser.parseSession()
        XCTAssertEqual(session?.isNew, false)
        XCTAssertEqual(session?.sessionId, "amzn1.echo-api.session.0000000-0000-0000-0000-00000000000")
        XCTAssertEqual(session?.application.applicationId, "amzn1.echo-sdk-ams.app.000000-d0ed-0000-ad00-000000d00ebe")
        
        let attribute = session?.attributes["supportedHoroscopePeriods"] as? [String: Bool]
        XCTAssertNotNil(attribute)
        if let attribute = attribute {
            XCTAssertEqual(attribute, ["daily": true, "weekly": false, "monthly": false])
        }
        
        XCTAssertEqual(session?.user.userId, "amzn1.account.AM3B00000000000000000000000")
        XCTAssertNil(session?.user.accessToken)
    }
    
    func testLaunchRequest() throws {
        let parser = try RequestParser(contentsOf: createFilePath(for: "launch_request.json"))
        
        let requestType = parser.parseRequestType()
        XCTAssertEqual(requestType, .launch)
        
        let launchRequest = parser.parseLaunchRequest()
        XCTAssertEqual(launchRequest?.request.locale, Locale(identifier: "string"))
        XCTAssertEqual(launchRequest?.request.timestamp, createDate(year: 2015, month: 5, day: 13, hour: 12, minute: 34, second: 56))
        XCTAssertEqual(launchRequest?.request.requestId, "amzn1.echo-api.request.0000000-0000-0000-0000-00000000000")
    }
    
    func testIntentRequest() throws {
        let parser = try RequestParser(contentsOf: createFilePath(for: "intent_request.json"))
        
        let requestType = parser.parseRequestType()
        XCTAssertEqual(requestType, .intent)

        let intentRequest = parser.parseIntentRequest()
        XCTAssertEqual(intentRequest?.request.locale, Locale(identifier: "string"))
        XCTAssertEqual(intentRequest?.request.timestamp, createDate(year: 2015, month: 5, day: 13, hour: 12, minute: 34, second: 56))
        XCTAssertEqual(intentRequest?.request.requestId, "amzn1.echo-api.request.0000000-0000-0000-0000-00000000000")
        
        XCTAssertEqual(intentRequest?.intent.name, "GetZodiacHoroscopeIntent")
        XCTAssertEqual(intentRequest?.intent.slots.count, 1)
        XCTAssertEqual(intentRequest?.intent.slots["ZodiacSign"], Slot(name: "ZodiacSign", value: "virgo"))
    }
    
    func testSessionEndedRequest() throws {
        let parser = try RequestParser(contentsOf: createFilePath(for: "session_ended_request.json"))
        
        let requestType = parser.parseRequestType()
        XCTAssertEqual(requestType, .sessionEnded)
        
        let sessionEndedRequest = parser.parseSessionEndedRequest()
        XCTAssertEqual(sessionEndedRequest?.request.locale, Locale(identifier: "string"))
        XCTAssertEqual(sessionEndedRequest?.request.timestamp, createDate(year: 2015, month: 5, day: 13, hour: 12, minute: 34, second: 56))
        XCTAssertEqual(sessionEndedRequest?.request.requestId, "amzn1.echo-api.request.0000000-0000-0000-0000-00000000000")
        
        let error = Error(type: .invalidResponse, message: "message")
        XCTAssertEqual(sessionEndedRequest?.reason, .error(error))
    }
}
