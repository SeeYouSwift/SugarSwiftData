import Foundation
import SwiftData

/// Concrete implementation of `SugarSwiftDataProtocol` backed by a `ModelContext`.
/// The `ModelContext` is injected at init time — create it in the app layer.
@MainActor
public final class SugarSwiftData: SugarSwiftDataProtocol {

    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - SugarSwiftDataProtocol

    public func insert<T: PersistentModel>(_ model: T) {
        modelContext.insert(model)
    }

    public func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> [T] {
        try modelContext.fetch(descriptor)
    }

    public func delete<T: PersistentModel>(_ model: T) {
        modelContext.delete(model)
    }

    public func deleteAll<T: PersistentModel>(_ type: T.Type) throws {
        try modelContext.delete(model: type)
    }

    public func save() throws {
        try modelContext.save()
    }

    public func count<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> Int {
        try modelContext.fetchCount(descriptor)
    }
}
