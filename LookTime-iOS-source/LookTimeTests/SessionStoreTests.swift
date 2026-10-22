import XCTest
@testable import LookTime

@MainActor
final class SessionStoreTests: XCTestCase {
    func testSessionDurationIsAddedToToday() {
        let store = SessionStore()
        let start = Date()
        store.toggle(.douyinHome, now: start)
        store.stop(now: start.addingTimeInterval(90))
        XCTAssertGreaterThanOrEqual(store.total(for: .douyinHome, on: start), 90)
    }
}

