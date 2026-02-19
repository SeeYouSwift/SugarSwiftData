import Foundation
import SwiftData

/// A protocol for bidirectional mapping between a SwiftData `@Model` entity and a domain model.
///
/// Conform your `@Model` class to `DomainMappable` to enable clean separation between
/// persistence and business logic:
///
/// ```swift
/// extension MyEntity: DomainMappable {
///     typealias DomainModel = MyDomainStruct
///     convenience init(from domain: MyDomainStruct) { ... }
///     func toDomain() -> MyDomainStruct? { ... }
/// }
/// ```
public protocol DomainMappable<DomainModel>: PersistentModel {
    associatedtype DomainModel

    /// Create an entity from a domain model.
    init(from domain: DomainModel)

    /// Convert the entity to a domain model. Returns `nil` if conversion is not possible.
    func toDomain() -> DomainModel?
}
