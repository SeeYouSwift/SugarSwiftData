import Testing
import Foundation
import SwiftData
@testable import SugarSwiftData

// MARK: - Test model

@Model
final class TestItem {
    var name: String

    init(name: String) {
        self.name = name
    }
}

// MARK: - SugarSwiftData Tests

@MainActor
struct SugarSwiftDataTests {

    // MARK: - Helpers

    private func makeSUT() throws -> SugarSwiftData {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TestItem.self, configurations: config)
        return SugarSwiftData(modelContext: container.mainContext)
    }

    // MARK: - Insert and fetch

    @Test func insertAndFetchRoundTrips() throws {
        // Given
        let sut = try makeSUT()
        let item = TestItem(name: "Alpha")

        // When
        sut.insert(item)
        try sut.save()
        let result = try sut.fetch(FetchDescriptor<TestItem>())

        // Then
        #expect(result.count == 1)
        #expect(result.first?.name == "Alpha")
    }

    // MARK: - Empty store returns empty array

    @Test func fetchReturnsEmptyWhenNoData() throws {
        // Given
        let sut = try makeSUT()

        // When
        let result = try sut.fetch(FetchDescriptor<TestItem>())

        // Then
        #expect(result.isEmpty)
    }

    // MARK: - Delete a specific model

    @Test func deleteRemovesModel() throws {
        // Given
        let sut = try makeSUT()
        let item = TestItem(name: "ToDelete")
        sut.insert(item)
        try sut.save()

        // When
        sut.delete(item)
        try sut.save()
        let result = try sut.fetch(FetchDescriptor<TestItem>())

        // Then
        #expect(result.isEmpty)
    }

    // MARK: - Delete all models of a type

    @Test func deleteAllRemovesAllModels() throws {
        // Given
        let sut = try makeSUT()
        sut.insert(TestItem(name: "A"))
        sut.insert(TestItem(name: "B"))
        sut.insert(TestItem(name: "C"))
        try sut.save()

        // When
        try sut.deleteAll(TestItem.self)
        try sut.save()
        let result = try sut.fetch(FetchDescriptor<TestItem>())

        // Then
        #expect(result.isEmpty)
    }

    // MARK: - Count models

    @Test func countReturnsCorrectNumber() throws {
        // Given
        let sut = try makeSUT()
        sut.insert(TestItem(name: "X"))
        sut.insert(TestItem(name: "Y"))
        try sut.save()

        // When
        let count = try sut.count(FetchDescriptor<TestItem>())

        // Then
        #expect(count == 2)
    }
}
