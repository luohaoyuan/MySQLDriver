import XCTest

import MySQLDriverTests

var tests = [XCTestCaseEntry]()
tests += MySQLDriverTests.allTests()
XCTMain(tests)