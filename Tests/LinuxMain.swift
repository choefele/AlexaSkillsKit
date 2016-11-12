#if os(Linux)
import XCTest

@testable import AlexaSkillsKitTests

XCTMain([
    testCase(RequestDispatcherTests.allTests),
    testCase(RequestParserTests.allTests),
    testCase(RequestTests.allTests),
    testCase(ResponseGeneratorTests.allTests),
    testCase(ResponseTests.allTests)
])
#endif