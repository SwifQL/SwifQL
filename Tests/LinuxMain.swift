import XCTest

import SwifQLTests

var tests = [XCTestCaseEntry]()
tests += BuilderTests.allTests()
tests += CaseTests.allTests()
tests += DirectiveTests.allTests()
tests += ExistsTests.allTests()
tests += FnTests.allTests()
tests += FromTests.allTests()
tests += JsonTests.allTests()
tests += OrderTests.allTests()
tests += SelectTests.allTests()
tests += SubqueryTests.allTests()
tests += SwifQLTests.allTests()
tests += WithTests.allTests()
XCTMain(tests)
