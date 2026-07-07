import XCTest
@testable import WineCellarCard

final class WineCellarCardTests: XCTestCase {
    var store: Store!

    @MainActor override func setUp() {
        super.setUp()
        store = Store()
    }

    @MainActor func testSeedDataBelowFreeLimit() {
        XCTAssertLessThan(store.entries.count, Store.freeLimit)
    }

    @MainActor func testAddEntrySucceedsUnderLimit() {
        let before = store.entries.count
        let added = store.add(BottleEntry(), isPro: false)
        XCTAssertTrue(added)
        XCTAssertEqual(store.entries.count, before + 1)
    }

    @MainActor func testAddEntryFailsAtFreeLimit() {
        store.entries = (0..<Store.freeLimit).map { _ in BottleEntry() }
        let added = store.add(BottleEntry(), isPro: false)
        XCTAssertFalse(added)
        XCTAssertTrue(store.showPaywall)
    }

    @MainActor func testProUserBypassesLimit() {
        store.entries = (0..<Store.freeLimit).map { _ in BottleEntry() }
        let added = store.add(BottleEntry(), isPro: true)
        XCTAssertTrue(added)
    }

    @MainActor func testDeleteEntry() {
        let entry = BottleEntry()
        store.entries = [entry]
        store.delete(entry)
        XCTAssertTrue(store.entries.isEmpty)
    }

    @MainActor func testUpdateEntry() {
        var entry = BottleEntry()
        store.entries = [entry]
        store.update(entry)
        XCTAssertEqual(store.entries.first?.id, entry.id)
    }

    @MainActor func testDeleteAtOffsets() {
        store.entries = [BottleEntry(), BottleEntry()]
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, 1)
    }
}
