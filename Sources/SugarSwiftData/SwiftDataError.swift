import Foundation

public enum SwiftDataError: LocalizedError {
    case saveFailed(String)
    case fetchFailed(String)
    case containerCreationFailed(String)

    public var errorDescription: String? {
        switch self {
        case .saveFailed(let message):
            "Save failed: \(message)"
        case .fetchFailed(let message):
            "Fetch failed: \(message)"
        case .containerCreationFailed(let message):
            "Container creation failed: \(message)"
        }
    }
}
