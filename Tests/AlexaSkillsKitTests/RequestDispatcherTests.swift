import Foundation
import AlexaSkillsKit
import XCTest

private class FakeRequestHandler: RequestHandler {
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

private func createFilePath(for fileName: String) -> URL {
    return URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .appendingPathComponent(fileName)
}

class RequestDispatcherTests: XCTestCase {
    static let allTests = [
        ("testDispatchAsyncErrorParsingRequest", testDispatchAsyncErrorParsingRequest),
        ("testDispatchAsyncIntent", testDispatchAsyncIntent)
    ]
    
    private var requestHandler: FakeRequestHandler!
    var requestDispatcher: RequestDispatcher!
    
    // Error returned if unknown request type
    // Error returned if response invalid
    // Test dispatch sync
    
    // How to handle error in request handler
    // Split up dispatch handling for better testing
    
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
    
    func testDispatchAsyncIntent() throws {
        let data = try Data(contentsOf: createFilePath(for: "intent_request.json"))
        
        let testExpectation = expectation(description: #function)
        requestDispatcher.dispatch(data: data) { response in
            switch response {
            case .success:
                break
            case .failure:
                XCTFail()
            }
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        XCTAssertFalse(requestHandler.handleLaunchCalled)
        XCTAssertTrue(requestHandler.handleIntentCalled)
        XCTAssertFalse(requestHandler.handleSessionEndedCalled)
    }
}
