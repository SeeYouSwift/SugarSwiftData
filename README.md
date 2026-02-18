# SugarSwiftData

A thin, protocol-driven abstraction over Apple's SwiftData framework. Provides generic CRUD operations and a `DomainMappable` protocol for clean separation between persistence models and business logic.

## Features

- Generic `insert`, `fetch`, `delete`, `save`, `count` methods
- Convenience extensions: `fetchAll`, `replaceAll`, `fetchAllDomain`
- `DomainMappable` protocol for decoupled persistence ↔ domain mapping
- `SwiftDataContainerFactory` for easy `ModelContainer` creation (including in-memory for tests)
- Full mock implementation for unit testing without a real container

## Requirements

- iOS 18+ / macOS 15+
- Swift 6+

## Installation

### Swift Package Manager

**Via Xcode:**
1. File → Add Package Dependencies
2. Enter the repository URL:
   ```
   https://github.com/SeeYouSwift/SugarSwiftData
   ```
3. Select version rule and click **Add Package**

**Via `Package.swift`:**

```swift
dependencies: [
    .package(url: "https://github.com/SeeYouSwift/SugarSwiftData", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["SugarSwiftData"]
    ),
    // For test targets — add the mock library:
    .testTarget(
        name: "YourTargetTests",
        dependencies: [
            "YourTarget",
            .product(name: "SugarSwiftDataMocks", package: "SugarSwiftData")
        ]
    )
]
```
## Usage

### 1. Define Your Persistent Model

```swift
import SwiftData
import SugarSwiftData

@Model
final class DogEntity {
    var id: UUID
    var name: String
    var imageURL: String

    init(id: UUID, name: String, imageURL: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }
}
```

### 2. Conform to `DomainMappable` (optional but recommended)

```swift
extension DogEntity: DomainMappable {
    typealias DomainModel = Dog

    convenience init(from domain: Dog) {
        self.init(id: domain.id, name: domain.name, imageURL: domain.imageURL.absoluteString)
    }

    func toDomain() -> Dog? {
        guard let url = URL(string: imageURL) else { return nil }
        return Dog(id: id, name: name, imageURL: url)
    }
}
```

### 3. Set Up the Container in Your App

```swift
import SwiftData
import SugarSwiftData

@main
struct MyApp: App {
    let container: ModelContainer = {
        try! SwiftDataContainerFactory.create(for: [DogEntity.self])
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
```

### 4. Create the Service and Use It

```swift
@MainActor
final class DogsRepository {
    private let db: SugarSwiftDataProtocol

    init(modelContext: ModelContext) {
        self.db = SugarSwiftData(modelContext: modelContext)
    }

    func save(dog: Dog) throws {
        db.insert(DogEntity(from: dog))
        try db.save()
    }

    func fetchAll() throws -> [Dog] {
        try db.fetchAllDomain(DogEntity.self)
    }

    func replaceAll(with dogs: [Dog]) throws {
        try db.replaceAll(with: dogs.map(DogEntity.init))
    }
}
```

### Testing

```swift
import SugarSwiftDataMocks

let mock = await MockSugarSwiftData()
await mock.setFetchResult([DogEntity(from: sampleDog)])

let repo = await DogsRepository(service: mock)
let dogs = try await repo.fetchAll()

await XCTAssertEqual(mock.fetchCallCount, 1)
```

## API Reference

### `SugarSwiftDataProtocol`

```swift
func insert<T: PersistentModel>(_ model: T)
func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> [T]
func delete<T: PersistentModel>(_ model: T)
func deleteAll<T: PersistentModel>(_ type: T.Type) throws
func save() throws
func count<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> Int
```

### Convenience Extensions

| Method | Description |
|--------|-------------|
| `fetchAll(_:)` | Fetch all records of a type with no sort |
| `fetchAll(_:sortedBy:)` | Fetch all records with a sort descriptor |
| `replaceAll(with:)` | Delete all existing records, insert new ones, save |
| `fetchAllDomain(_:)` | Fetch + map to domain via `DomainMappable` |
| `fetchAllDomain(_:sortedBy:)` | Fetch + sort + map to domain |

### `DomainMappable`

```swift
public protocol DomainMappable<DomainModel>: PersistentModel {
    associatedtype DomainModel
    init(from domain: DomainModel)
    func toDomain() -> DomainModel?
}
```

### `SwiftDataContainerFactory`

```swift
// Production — persists to disk
static func create(for models: [any PersistentModel.Type]) throws -> ModelContainer

// Tests — in-memory, no disk writes
static func createForTesting(for models: [any PersistentModel.Type]) throws -> ModelContainer
```

### `SwiftDataError`

| Case | Description |
|------|-------------|
| `.saveFailed(String)` | `modelContext.save()` threw |
| `.fetchFailed(String)` | `modelContext.fetch()` threw |
| `.containerCreationFailed(String)` | `ModelContainer` init threw |
