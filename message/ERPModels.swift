import Foundation
import SwiftUI

// MARK: - User Profile

struct UserProfile: Identifiable, Hashable {
    let id: UUID
    let name: String
    let role: String
    let organization: String
    
    static let mock = UserProfile(id: UUID(), name: "John Doe", role: "Chief Executive Officer", organization: "Acme Corp")
}

// MARK: - Inbox Folder

struct InboxFolder: Identifiable, Hashable {
    let id: String
    let name: String
    let iconName: String
    var incomingCounter: Int
    var badgeColor: Color
    
    static let mockFolders: [InboxFolder] = [
        InboxFolder(id: "for_me", name: "For me", iconName: "tray.and.arrow.down", incomingCounter: 12, badgeColor: .blue),
        InboxFolder(id: "for_execution", name: "For execution", iconName: "doc.badge.gearshape", incomingCounter: 5, badgeColor: .orange),
        InboxFolder(id: "for_approval", name: "For approval", iconName: "checkmark.seal", incomingCounter: 3, badgeColor: .green),
        InboxFolder(id: "for_agreement", name: "For agreement", iconName: "hand.raised", incomingCounter: 1, badgeColor: .teal),
        InboxFolder(id: "for_signing", name: "For signing", iconName: "signature", incomingCounter: 8, badgeColor: .purple),
        InboxFolder(id: "for_acknowledge", name: "For acknowledge", iconName: "eye", incomingCounter: 0, badgeColor: .gray),
        InboxFolder(id: "my_resolution", name: "My resolution", iconName: "text.badge.checkmark", incomingCounter: 2, badgeColor: .cyan),
        InboxFolder(id: "first_view", name: "First view", iconName: "01.circle", incomingCounter: 4, badgeColor: .indigo),
        InboxFolder(id: "on_control", name: "On control", iconName: "lock.shield", incomingCounter: 0, badgeColor: .gray),
        InboxFolder(id: "urgent", name: "Urgent", iconName: "exclamationmark.triangle", incomingCounter: 7, badgeColor: .red),
        InboxFolder(id: "created_by_me", name: "Created by me", iconName: "doc.badge.plus", incomingCounter: 0, badgeColor: .gray),
        InboxFolder(id: "rejected", name: "Rejected", iconName: "arrow.uturn.backward", incomingCounter: 1, badgeColor: .yellow),
        InboxFolder(id: "returned", name: "Returned", iconName: "arrow.uturn.forward", incomingCounter: 0, badgeColor: .gray),
        InboxFolder(id: "from_me", name: "From me", iconName: "paperplane", incomingCounter: 0, badgeColor: .gray),
        InboxFolder(id: "finished", name: "Finished", iconName: "archivebox", incomingCounter: 0, badgeColor: .gray),
        InboxFolder(id: "favorite", name: "Favorite", iconName: "star", incomingCounter: 2, badgeColor: .yellow)
    ]
}

// MARK: - Document

struct Document: Identifiable, Hashable {
    let id: UUID
    let type: String
    let initiator: String
    let addressedTo: String
    let stage: String
    let documentNumber: String
    let date: Date
    let correspondent: String
    let shortSummary: String
    let outgoingNumber: String
    
    var pdfURL: URL? // URL to the scanned pdf
    
    static let mockDocuments: [Document] = [
        Document(
            id: UUID(),
            type: "Contract",
            initiator: "Alice Smith",
            addressedTo: "John Doe",
            stage: "Pending Signature",
            documentNumber: "CTR-2026-001",
            date: Date().addingTimeInterval(-86400),
            correspondent: "Global Tech Inc",
            shortSummary: "Annual service agreement renewal.",
            outgoingNumber: "OUT-001-A"
        ),
        Document(
            id: UUID(),
            type: "Invoice",
            initiator: "Finance Dept",
            addressedTo: "John Doe",
            stage: "For Approval",
            documentNumber: "INV-5542",
            date: Date().addingTimeInterval(-172800),
            correspondent: "Office Supplies Co",
            shortSummary: "Q1 Office Supplies procurement.",
            outgoingNumber: "OUT-002-B"
        ),
        Document(
            id: UUID(),
            type: "Memo",
            initiator: "HR Dept",
            addressedTo: "All Employees",
            stage: "For Acknowledge",
            documentNumber: "MEM-2026-012",
            date: Date().addingTimeInterval(-3600),
            correspondent: "Internal",
            shortSummary: "Updated company policies regarding remote work.",
            outgoingNumber: "N/A"
        ),
        Document(
            id: UUID(),
            type: "Report",
            initiator: "Bob Jones",
            addressedTo: "John Doe",
            stage: "For Review",
            documentNumber: "REP-Q4-2025",
            date: Date().addingTimeInterval(-432000),
            correspondent: "Analytics Team",
            shortSummary: "Q4 2025 Performance Analytics Report.",
            outgoingNumber: "OUT-005-X"
        ),
        Document(
            id: UUID(),
            type: "Letter",
            initiator: "Legal Dept",
            addressedTo: "Jane F.",
            stage: "Urgent",
            documentNumber: "LGL-992",
            date: Date(),
            correspondent: "External Counsel",
            shortSummary: "Response to compliance inquiry.",
            outgoingNumber: "OUT-088-L"
        )
    ]
}
