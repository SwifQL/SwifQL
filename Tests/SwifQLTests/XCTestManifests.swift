import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BuilderTests.allTests),
        testCase(CaseTests.allTests),
        testCase(DirectiveTests.allTests),
        testCase(ExistsTests.allTests),
        testCase(FnTests.allTests),
        testCase(FromTests.allTests),
        testCase(JsonTests.allTests),
        testCase(OrderTests.allTests),
        testCase(SelectTests.allTests),
        testCase(SubqueryTests.allTests),
        testCase(SwifQLTests.allTests),
        testCase(WithTests.allTests),
        testCase(TableEncoding.allTests)
    ]
}
#endif
