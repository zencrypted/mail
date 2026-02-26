import Foundation
import SwiftData
import SwiftUI

@Observable
@MainActor
final class DashboardViewModel {
    var rootDocuments: [RMKDocument] = []
    var selectedDocument: RMKDocument? = nil
    var searchText: String = ""
    var statusFilter: DocumentStatus? = nil

    // KPI stats
    var totalDocs: Int = 0
    var pendingCount: Int = 0
    var approvedCount: Int = 0
    var totalValue: Double = 0

    // Quick add form
    var showQuickAdd: Bool = false

    private var modelContext: ModelContext?
    private var treeLoader: TreeLoader?

    func configure(context: ModelContext, container: ModelContainer) {
        self.modelContext = context
        self.treeLoader = TreeLoader(modelContainer: container)
    }

    // MARK: - Root Loading

    func loadRoots() {
        guard let context = modelContext else { return }
        var descriptor = FetchDescriptor<RMKDocument>(
            predicate: #Predicate { $0.parent == nil },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = 200  // Paginate roots for performance
        do {
            rootDocuments = try context.fetch(descriptor)
        } catch {
            print("Failed to load roots: \(error)")
        }
    }

    // MARK: - Lazy Child Loading

    func loadChildren(of document: RMKDocument) async {
        guard let loader = treeLoader else { return }

        do {
            let childIDs = try await loader.fetchChildren(
                ofDocumentWithID: document.persistentModelID)

            // Resolve on main context
            guard let context = modelContext else { return }
            var resolved: [RMKDocument] = []
            for pid in childIDs {
                if let child = context.model(for: pid) as? RMKDocument {
                    resolved.append(child)
                }
            }
            document.children = resolved
            document.hasUnloadedChildren = false
        } catch {
            print("Failed to load children: \(error)")
        }
    }

    // MARK: - KPI Refresh

    func refreshKPIs() async {
        guard let loader = treeLoader else { return }
        do {
            let total = try await loader.countAll()
            let pending = try await loader.count(status: DocumentStatus.pending.rawValue)
            let approved = try await loader.count(status: DocumentStatus.approved.rawValue)
            let value = try await loader.totalValue()

            totalDocs = total
            pendingCount = pending
            approvedCount = approved
            totalValue = value
        } catch {
            print("Failed to refresh KPIs: \(error)")
        }
    }

    // MARK: - Filtered Roots

    var visibleRoots: [RMKDocument] {
        var filtered = rootDocuments

        if let statusFilter {
            filtered = filtered.filter { $0.status == statusFilter }
        }

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            filtered = filtered.filter {
                $0.title.lowercased().contains(query)
                    || $0.documentNumber.lowercased().contains(query)
                    || ($0.applicant?.lowercased().contains(query) ?? false)
            }
        }

        return filtered
    }

    // MARK: - CRUD

    func addDocument(
        title: String, applicant: String?, type: DocumentType, value: Double?,
        parent: RMKDocument? = nil
    ) {
        guard let context = modelContext else { return }

        let count = (try? context.fetchCount(FetchDescriptor<RMKDocument>())) ?? 0
        let number = String(
            format: "RMK-%04d-%05d", Calendar.current.component(.year, from: Date()), count + 1)

        let doc = RMKDocument(
            title: title,
            documentNumber: number,
            status: .draft,
            type: type,
            applicant: applicant,
            value: value,
            parent: parent
        )
        context.insert(doc)

        if parent == nil {
            rootDocuments.insert(doc, at: 0)
        } else {
            parent?.children.append(doc)
        }

        try? context.save()

        // Refresh KPIs
        Task { await refreshKPIs() }
    }

    func deleteDocument(_ document: RMKDocument) {
        guard let context = modelContext else { return }

        rootDocuments.removeAll { $0.id == document.id }
        if selectedDocument?.id == document.id {
            selectedDocument = nil
        }
        context.delete(document)
        try? context.save()

        Task { await refreshKPIs() }
    }

    func archiveDocument(_ document: RMKDocument) {
        document.status = .archived
        document.updatedAt = Date()
        try? modelContext?.save()
        Task { await refreshKPIs() }
    }
}
