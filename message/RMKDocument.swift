import Foundation
import SwiftData

// MARK: - Enums

enum DocumentStatus: String, Codable, CaseIterable, Identifiable {
    case draft = "Draft"
    case pending = "Pending"
    case approved = "Approved"
    case archived = "Archived"

    var id: String { rawValue }
}

enum DocumentType: String, Codable, CaseIterable, Identifiable {
    case incoming = "Incoming"
    case outgoing = "Outgoing"
    case `internal` = "Internal"
    case resolution = "Resolution"

    var id: String { rawValue }
}

// MARK: - SwiftData Model

@Model
final class RMKDocument {
    var id: UUID
    var title: String
    var documentNumber: String
    var statusRaw: String
    var typeRaw: String
    var applicant: String?
    var value: Double?
    var createdAt: Date
    var updatedAt: Date
    var notes: String?
    var hasUnloadedChildren: Bool

    @Relationship(deleteRule: .cascade, inverse: \RMKDocument.parent)
    var children: [RMKDocument] = []

    var parent: RMKDocument?

    // Computed helpers (not persisted)
    var status: DocumentStatus {
        get { DocumentStatus(rawValue: statusRaw) ?? .draft }
        set { statusRaw = newValue.rawValue }
    }

    var type: DocumentType {
        get { DocumentType(rawValue: typeRaw) ?? .incoming }
        set { typeRaw = newValue.rawValue }
    }

    init(
        title: String,
        documentNumber: String,
        status: DocumentStatus = .draft,
        type: DocumentType = .incoming,
        applicant: String? = nil,
        value: Double? = nil,
        notes: String? = nil,
        parent: RMKDocument? = nil,
        hasUnloadedChildren: Bool = false
    ) {
        self.id = UUID()
        self.title = title
        self.documentNumber = documentNumber
        self.statusRaw = status.rawValue
        self.typeRaw = type.rawValue
        self.applicant = applicant
        self.value = value
        self.createdAt = Date()
        self.updatedAt = Date()
        self.notes = notes
        self.parent = parent
        self.hasUnloadedChildren = hasUnloadedChildren
    }
}
