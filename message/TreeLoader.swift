import Foundation
import SwiftData

/// Background actor for off-main-thread SwiftData operations.
actor TreeLoader {
    private var modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    /// Fetch direct children of a given document by its persistent ID.
    func fetchChildren(ofDocumentWithID parentID: PersistentIdentifier) throws
        -> [PersistentIdentifier]
    {
        let context = ModelContext(modelContainer)

        guard let parentDoc = context.model(for: parentID) as? RMKDocument else {
            return []
        }

        let pid = parentDoc.id
        let predicate = #Predicate<RMKDocument> { doc in
            doc.parent?.id == pid
        }
        let descriptor = FetchDescriptor<RMKDocument>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdAt)]
        )

        let results = try context.fetch(descriptor)
        return results.map(\.persistentModelID)
    }

    /// Count total documents.
    func countAll() throws -> Int {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<RMKDocument>()
        return try context.fetchCount(descriptor)
    }

    /// Count documents matching a specific status.
    func count(status: String) throws -> Int {
        let context = ModelContext(modelContainer)
        let predicate = #Predicate<RMKDocument> { $0.statusRaw == status }
        let descriptor = FetchDescriptor<RMKDocument>(predicate: predicate)
        return try context.fetchCount(descriptor)
    }

    /// Sum the `value` field across all documents.
    func totalValue() throws -> Double {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<RMKDocument>()
        let docs = try context.fetch(descriptor)
        return docs.compactMap(\.value).reduce(0, +)
    }
}
