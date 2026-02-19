import Foundation
import SwiftData

/// Generic protocol for SwiftData operations.
/// Works with any `PersistentModel` — each module defines its own `@Model` classes.
@MainActor
public protocol SugarSwiftDataProtocol: Sendable {

    /// Insert a model into the context.
    func insert<T: PersistentModel>(_ model: T)

    /// Fetch models matching the given descriptor.
    func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> [T]

    /// Delete a specific model instance.
    func delete<T: PersistentModel>(_ model: T)

    /// Delete all models of the given type.
    func deleteAll<T: PersistentModel>(_ type: T.Type) throws

    /// Persist uncommitted changes to the store.
    func save() throws

    /// Count models matching the given descriptor.
    func count<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> Int
}
