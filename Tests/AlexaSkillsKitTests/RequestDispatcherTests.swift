import Foundation
import AlexaSkillsKit
import XCTest

class FakeRequestHandler: RequestHandler {
    var handleLaunchCalled = false
    var handleIntentCalled = false
    var handleSessionEndedCalled = false
    
    func handleLaunch(request: LaunchRequest, session: Session, next: @escaping (StandardResponse) -> ()) {
        handleLaunchCalled = true
        next(StandardResponse())
    }
    
    func handleIntent(request: IntentRequest, session: Session, next: @escaping (StandardResponse) -> ()) {
        handleIntentCalled = true
        next(StandardResponse())
    }
    
    func handleSessionEnded(request: SessionEndedRequest, session: Session, next: @escaping () -> ()) {
        handleSessionEndedCalled = true
        next()
    }
}

class RequestDispatcherTests: XCTestCase {
    static let allTests = [
        ("testDispatchAsyncErrorParsingRequest", testDispatchAsyncErrorParsingRequest)
    ]
    
    var requestHandler: FakeRequestHandler!
    var requestDispatcher: RequestDispatcher!
    
    // Dispatch calls handler dispatch method
    // Handler dispatch -> intent handler calls completion async
    // Error returned if unknown request type
    // Error returned if response invalid
    
    override func setUp() {
        super.setUp()
        
        requestHandler = FakeRequestHandler()
        requestDispatcher = RequestDispatcher(requestHandler: requestHandler)
    }
    
    func testDispatchAsyncErrorParsingRequest() {
        let testExpectation = expectation(description: #function)
        requestDispatcher.dispatch(data: Data()) { response in
            switch response {
            case .success:
                XCTFail()
            case .failure:
                break
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        XCTAssertFalse(requestHandler.handleLaunchCalled)
        XCTAssertFalse(requestHandler.handleIntentCalled)
        XCTAssertFalse(requestHandler.handleSessionEndedCalled)
    }
}
