import Segment_MoEngage
import XCTest

final class Segment_MoEngageTests: XCTestCase {
    func testMoEngageDestinationNSString() {
        let expectedString = "MoEngageDestination"
        XCTAssertEqual(expectedString, NSStringFromClass(MoEngageDestination.self))
    }
}