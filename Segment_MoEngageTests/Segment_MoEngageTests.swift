//
//  Segment_MoEngageTests.swift
//  Segment_MoEngageTests
//
//  Created by Uday Kiran on 15/04/25.
//

import XCTest
@testable import Segment_MoEngage

final class Segment_MoEngageTests: XCTestCase {
    
    func testMoEngageDestinationNSString() {
        let expectedString = "MoEngageDestination"
        XCTAssertEqual(expectedString, NSStringFromClass(MoEngageDestination.self))
    }
}
