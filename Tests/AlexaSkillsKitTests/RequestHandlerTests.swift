import Foundation
import AlexaSkillsKit
import XCTest

private class FakeRequestHandler: RequestHandler {
    func handleLaunch(request: LaunchRequest, session: Session, next: @escaping (StandardResult) -> ()) {
        next(.success(standardResponse: StandardResponse(), sessionAttributes: [:]))
    }
    
    func handleIntent(request: IntentRequest, session: Session, next: @escaping (StandardResult) -> ()) {
        next(.success(standardResponse: StandardResponse(), sessionAttributes: [:]))
    }
    
    func handleSessionEnded(request: SessionEndedRequest, session: Session, next: @escaping (VoidResult) -> ()) {
        next(.success())
    }
}

class RequestHandlerTests: XCTestCase {
    static let allTests = [
        ("testMessageError", testMessageError),
        ("testHandleLaunch", testHandleLaunch)
    ]
    
    private var requestHandler: FakeRequestHandler!
    
    override func setUp() {
        super.setUp()
        
        requestHandler = FakeRequestHandler()
    }
    
    func testMessageError() {
        let error = MessageError(message: "message")
        XCTAssertEqual(error, error)
        XCTAssertEqual(error, MessageError(message: "message"))
        
        XCTAssertNotEqual(error, MessageError(message: "message xx"))
    }
    
    func testHandleLaunch() {
        let launchRequest = LaunchRequest(request: Request(requestId: "", timestamp: Date(), locale: Locale(identifier: "")))
        let application = Application(applicationId: "")
        let user = User(userId: "")
        let session = Session(isNew: true, sessionId: "", application: application, attributes: [:], user: user)
        
        let testExpectation = expectation(description: #function)
        requestHandler.handleLaunch(request: launchRequest, session: session) { result in
            switch result {
            case .success(let result):
                XCTAssertEqual(result.standardResponse, StandardResponse())
                XCTAssertTrue(result.sessionAttributes.isEmpty)
            case .failure:
                XCTFail()
            }
            
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
