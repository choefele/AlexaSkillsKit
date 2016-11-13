#if os(Linux)
import XCTest

@testable import AlexaSkillsKitTests

XCTMain([
    testCase(RequestDispatcherTests.allTests),
    testCase(RequestHandlerTests.allTests),
    testCase(RequestParserV1Tests.allTests),
    testCase(RequestTests.allTests),
    testCase(ResponseGeneratorV1Tests.allTests),
    testCase(ResponseTests.allTests)
])
#endif
