import Foundation
import SwiftData

/// Factory for creating `ModelContainer` instances.
/// Accepts any `PersistentModel` types — each module passes its own.
public enum SwiftDataContainerFactory {

    /// Create a persistent `ModelContainer` for the given model types.
    public static func create(
        for models: [any PersistentModel.Type]
    ) throws -> ModelContainer {
        let schema = Schema(models)
        let config = ModelConfiguration(schema: schema)
        return try ModelContainer(for: schema, configurations: config)
    }

    /// Create an in-memory `ModelContainer` for tests. No data is written to disk.
    public static func createForTesting(
        for models: [any PersistentModel.Type]
    ) throws -> ModelContainer {
        let schema = Schema(models)
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: config)
    }
}
