import Foundation
import SwiftData

/// Generates test documents with deep nesting for performance testing.
actor DataSeeder {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    /// Seed the database with documents in a tree structure.
    /// - Parameters:
    ///   - totalDocuments: Target number of documents to create.
    ///   - maxDepth: Maximum nesting depth.
    func seed(totalDocuments: Int, maxDepth: Int) async {
        let context = ModelContext(modelContainer)
        context.autosaveEnabled = false

        let statuses = DocumentStatus.allCases
        let types = DocumentType.allCases
        let applicants = [
            "Maxim Sokhatsky", "Alice Johnson", "Bob Smith", "Carol Williams",
            "David Brown", "Eva Martinez", "Frank Lee", "Grace Kim",
            "Henry Chen", "Irene Novak", "Julia Schmidt", "Karl Weber",
        ]
        let titles = [
            "Security Audit Report", "Budget Approval", "Contract Amendment",
            "Compliance Review", "Infrastructure Update", "Personnel Request",
            "Quarterly Review", "Policy Amendment", "Incident Report",
            "Vendor Assessment", "Risk Analysis", "Strategic Plan",
            "Procurement Order", "Access Control Update", "Training Schedule",
        ]

        var created = 0
        let batchSize = 2000

        // Phase 1: Create guaranteed deep chains (3 chains of maxDepth)
        let deepChainCount = 3
        var queue: [(doc: RMKDocument, depth: Int)] = []

        for chain in 0..<deepChainCount {
            guard created < totalDocuments else { break }

            let rootDoc = RMKDocument(
                title: "Deep Chain \(chain + 1) Root",
                documentNumber: String(format: "RMK-%04d-%05d", 2025, created + 1),
                status: statuses[chain % statuses.count],
                type: types[chain % types.count],
                applicant: applicants[chain % applicants.count],
                value: Double.random(in: 10000...500_000),
                hasUnloadedChildren: true
            )
            context.insert(rootDoc)
            created += 1

            // Create a single-child chain to max depth
            var currentParent = rootDoc
            for depth in 1..<maxDepth {
                guard created < totalDocuments else { break }

                let childDoc = RMKDocument(
                    title: "\(titles[(created) % titles.count]) L\(depth + 1)",
                    documentNumber: String(format: "RMK-%04d-%05d", 2025, created + 1),
                    status: statuses[created % statuses.count],
                    type: types[created % types.count],
                    applicant: applicants[created % applicants.count],
                    value: Double.random(in: 100...50_000),
                    parent: currentParent,
                    hasUnloadedChildren: depth + 1 < maxDepth
                )
                context.insert(childDoc)

                // Add some siblings at every 5th level for breadth
                if depth % 5 == 0 {
                    let siblingCount = min(Int.random(in: 1...3), totalDocuments - created - 1)
                    for s in 0..<siblingCount {
                        guard created + s + 1 < totalDocuments else { break }
                        let sibling = RMKDocument(
                            title: "\(titles[(created + s) % titles.count]) S\(depth)",
                            documentNumber: String(format: "RMK-%04d-%05d", 2025, created + s + 2),
                            status: statuses[(created + s) % statuses.count],
                            type: types[(created + s) % types.count],
                            applicant: applicants[(created + s) % applicants.count],
                            value: Double.random(in: 100...50_000),
                            parent: currentParent,
                            hasUnloadedChildren: false
                        )
                        context.insert(sibling)
                        queue.append((sibling, depth))
                    }
                    created += siblingCount
                }

                currentParent = childDoc
                created += 1

                if created % batchSize == 0 {
                    try? context.save()
                }
            }
            // Mark deepest leaf
            currentParent.hasUnloadedChildren = false
        }

        // Phase 2: Create remaining documents as a BFS tree
        let rootCount = min((totalDocuments - created) / 5, 30)

        for i in 0..<rootCount {
            guard created < totalDocuments else { break }
            let doc = RMKDocument(
                title: titles[i % titles.count],
                documentNumber: String(format: "RMK-%04d-%05d", 2025, created + 1),
                status: statuses[i % statuses.count],
                type: types[i % types.count],
                applicant: applicants[i % applicants.count],
                value: Double.random(in: 1000...500_000),
                hasUnloadedChildren: true
            )
            context.insert(doc)
            queue.append((doc, 1))
            created += 1
        }

        // BFS to fill remaining documents
        var head = 0
        while created < totalDocuments && head < queue.count {
            let (parentDoc, depth) = queue[head]
            head += 1

            guard depth < min(maxDepth, 15) else {
                parentDoc.hasUnloadedChildren = false
                continue
            }

            let childCount = min(Int.random(in: 2...5), totalDocuments - created)

            for j in 0..<childCount {
                let doc = RMKDocument(
                    title: "\(titles[(created + j) % titles.count]) L\(depth + 1)",
                    documentNumber: String(format: "RMK-%04d-%05d", 2025, created + 1),
                    status: statuses[(created + j) % statuses.count],
                    type: types[(created + j) % types.count],
                    applicant: applicants[(created + j) % applicants.count],
                    value: Double.random(in: 100...50_000),
                    parent: parentDoc,
                    hasUnloadedChildren: depth + 1 < 15
                )
                context.insert(doc)
                queue.append((doc, depth + 1))
                created += 1

                if created >= totalDocuments { break }
            }

            if created % batchSize == 0 {
                try? context.save()
            }
        }

        // Mark remaining leaves
        while head < queue.count {
            queue[head].doc.hasUnloadedChildren = false
            head += 1
        }

        try? context.save()
        print("DataSeeder: Created \(created) documents (max depth target: \(maxDepth))")
    }
}
