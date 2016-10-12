#if os(Linux)
import XCTest

@testable import SwiftServerLibraryTests

XCTMain([
       testCase(ItemTests.allTests)
])
#endif