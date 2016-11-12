#if os(Linux)
import XCTest

@testable import AlexaSkillsKitTests

XCTMain([
    testCase(RequestDispatcherTests.allTests),
    testCase(RequestParserV1Tests.allTests),
    testCase(RequestTests.allTests),
    testCase(ResponseGeneratorTests.allTests),
    testCase(ResponseTests.allTests)
])
#endif
