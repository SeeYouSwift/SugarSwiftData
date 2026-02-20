import Foundation
import SwiftData

extension SugarSwiftDataProtocol {

    /// Fetch all models of the given type without sorting.
    public func fetchAll<T: PersistentModel>(_ type: T.Type) throws -> [T] {
        try fetch(FetchDescriptor<T>())
    }

    /// Fetch all models of the given type with a sort descriptor.
    public func fetchAll<T: PersistentModel>(
        _ type: T.Type,
        sortedBy sortDescriptor: SortDescriptor<T>
    ) throws -> [T] {
        try fetch(FetchDescriptor<T>(sortBy: [sortDescriptor]))
    }

    // MARK: - Replace all

    /// Delete all existing records of the given type, insert the new ones, and save.
    public func replaceAll<T: PersistentModel>(with models: [T]) throws {
        try deleteAll(T.self)
        for model in models {
            insert(model)
        }
        try save()
    }

    // MARK: - Domain mapping

    /// Fetch all entities and map them to domain models using `DomainMappable`.
    public func fetchAllDomain<T: DomainMappable>(
        _ type: T.Type
    ) throws -> [T.DomainModel] {
        try fetchAll(type).compactMap { $0.toDomain() }
    }

    /// Fetch, sort, and map all entities to domain models.
    public func fetchAllDomain<T: DomainMappable>(
        _ type: T.Type,
        sortedBy sortDescriptor: SortDescriptor<T>
    ) throws -> [T.DomainModel] {
        try fetchAll(type, sortedBy: sortDescriptor).compactMap { $0.toDomain() }
    }
}
