import Foundation
import SwiftData
import SugarSwiftData

/// In-memory mock of `SugarSwiftDataProtocol` for unit testing.
/// Stores data in memory, tracks call counts, and supports simulated errors.
@MainActor
public final class MockSugarSwiftData: SugarSwiftDataProtocol {

    // MARK: - Call counters

    public var insertCallCount = 0
    public var fetchCallCount = 0
    public var deleteCallCount = 0
    public var deleteAllCallCount = 0
    public var saveCallCount = 0
    public var countCallCount = 0

    // MARK: - Error simulation

    public var shouldThrowOnFetch = false
    public var shouldThrowOnSave = false

    // MARK: - Result store

    private var fetchResults: [Any] = []

    public init() {}

    /// Set the result that `fetch` will return.
    public func setFetchResult<T: PersistentModel>(_ result: [T]) {
        fetchResults = result
    }

    // MARK: - SugarSwiftDataProtocol

    public func insert<T: PersistentModel>(_ model: T) {
        insertCallCount += 1
    }

    public func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> [T] {
        fetchCallCount += 1
        if shouldThrowOnFetch { throw SwiftDataError.fetchFailed("Mock error") }
        return fetchResults.compactMap { $0 as? T }
    }

    public func delete<T: PersistentModel>(_ model: T) {
        deleteCallCount += 1
    }

    public func deleteAll<T: PersistentModel>(_ type: T.Type) throws {
        deleteAllCallCount += 1
    }

    public func save() throws {
        saveCallCount += 1
        if shouldThrowOnSave { throw SwiftDataError.saveFailed("Mock error") }
    }

    public func count<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> Int {
        countCallCount += 1
        return fetchResults.count
    }
}
