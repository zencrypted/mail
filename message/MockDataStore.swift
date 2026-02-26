import Foundation
import PDFKit
import SwiftUI

/// Central in-memory data store for testing all screens.
/// Provides mutable documents with generated PDFs, create/edit/delete operations.
class MockDataStore: ObservableObject {
    nonisolated(unsafe) static let shared = MockDataStore()

    // MARK: - CRM Documents (Messages tab)
    @Published var documents: [Document] = []

    // MARK: - Attachments per document
    @Published var attachments: [UUID: [MockAttachment]] = [:]

    init() {
        documents = Self.generateDocuments()
        generatePDFsForDocuments()
        generateAttachments()
    }

    // MARK: - CRUD: Messages

    func addDocument(
        type: String, initiator: String, addressedTo: String, stage: String,
        correspondent: String, summary: String
    ) -> Document {
        let count = documents.count + 1
        let doc = Document(
            id: UUID(),
            type: type,
            initiator: initiator,
            addressedTo: addressedTo,
            stage: stage,
            documentNumber: "\(type.prefix(3).uppercased())-2026-\(String(format: "%03d", count))",
            date: Date(),
            correspondent: correspondent,
            shortSummary: summary,
            outgoingNumber: "OUT-\(String(format: "%03d", count))"
        )
        documents.append(doc)
        generatePDF(for: doc)
        return doc
    }

    func updateDocument(
        id: UUID, type: String? = nil, stage: String? = nil,
        summary: String? = nil, correspondent: String? = nil
    ) {
        guard let idx = documents.firstIndex(where: { $0.id == id }) else { return }
        var doc = documents[idx]
        if let type { doc.type = type }
        if let stage { doc.stage = stage }
        if let summary { doc.shortSummary = summary }
        if let correspondent { doc.correspondent = correspondent }
        documents[idx] = doc
    }

    func deleteDocument(id: UUID) {
        documents.removeAll { $0.id == id }
        attachments.removeValue(forKey: id)
    }

    // MARK: - Attachments

    func addAttachment(to docId: UUID, name: String, size: Int64, type: AttachmentType) {
        let attachment = MockAttachment(name: name, size: size, type: type)
        attachments[docId, default: []].append(attachment)
    }

    func removeAttachment(from docId: UUID, attachmentId: UUID) {
        attachments[docId]?.removeAll { $0.id == attachmentId }
    }

    // MARK: - PDF Generation

    private func generatePDF(for doc: Document) {
        let pdf = PDFDocument()
        let page = PDFPage()
        let bounds = page.bounds(for: .mediaBox)

        #if os(macOS)
            let titleFont = NSFont.boldSystemFont(ofSize: 20)
            let bodyFont = NSFont.systemFont(ofSize: 12)
            let headerFont = NSFont.boldSystemFont(ofSize: 14)
            let darkColor = NSColor.darkGray
            let clearColor = NSColor.clear
        #else
            let titleFont = UIFont.boldSystemFont(ofSize: 20)
            let bodyFont = UIFont.systemFont(ofSize: 12)
            let headerFont = UIFont.boldSystemFont(ofSize: 14)
            let darkColor = UIColor.darkGray
            let clearColor = UIColor.clear
        #endif

        var yPos = bounds.height - 60

        func addText(_ text: String, font: Any, y: CGFloat) {
            let ann = PDFAnnotation(
                bounds: CGRect(x: 50, y: y, width: bounds.width - 100, height: 24),
                forType: .freeText, withProperties: nil)
            ann.contents = text
            #if os(macOS)
                ann.font = font as? NSFont
                ann.fontColor = darkColor
            #else
                ann.font = font as? UIFont
                ann.fontColor = darkColor
            #endif
            ann.color = clearColor
            page.addAnnotation(ann)
        }

        addText("ZEN CRYPTED", font: titleFont, y: yPos)
        yPos -= 24
        addText("Document: \(doc.documentNumber)", font: headerFont, y: yPos)
        yPos -= 20
        addText("Type: \(doc.type) | Stage: \(doc.stage)", font: bodyFont, y: yPos)
        yPos -= 18
        addText("Initiator: \(doc.initiator)", font: bodyFont, y: yPos)
        yPos -= 18
        addText("Addressed to: \(doc.addressedTo)", font: bodyFont, y: yPos)
        yPos -= 18
        addText("Correspondent: \(doc.correspondent)", font: bodyFont, y: yPos)
        yPos -= 24
        addText("Summary:", font: headerFont, y: yPos)
        yPos -= 18
        addText(doc.shortSummary, font: bodyFont, y: yPos)
        yPos -= 30
        addText(
            "Date: \(doc.date.formatted(date: .long, time: .shortened))", font: bodyFont, y: yPos)

        pdf.insert(page, at: 0)

        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("mock_pdfs", isDirectory: true)
        try? FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        let fileURL = tempDir.appendingPathComponent("\(doc.id.uuidString).pdf")
        if pdf.write(to: fileURL) {
            if let idx = documents.firstIndex(where: { $0.id == doc.id }) {
                documents[idx].pdfURL = fileURL
            }
        }
    }

    private func generatePDFsForDocuments() {
        for doc in documents {
            generatePDF(for: doc)
        }
    }

    private func generateAttachments() {
        // Add sample attachments to some documents
        for (i, doc) in documents.enumerated() {
            if i % 3 == 0 {
                attachments[doc.id] = [
                    MockAttachment(
                        name: "\(doc.documentNumber).pdf", size: Int64.random(in: 50_000...500_000),
                        type: .pdf),
                    MockAttachment(
                        name: "scan_\(i + 1).jpg", size: Int64.random(in: 100_000...2_000_000),
                        type: .image),
                ]
            } else if i % 3 == 1 {
                attachments[doc.id] = [
                    MockAttachment(
                        name: "appendix_\(doc.documentNumber).pdf",
                        size: Int64.random(in: 80_000...400_000), type: .pdf)
                ]
            }
            // Every 3rd doc has no attachments
        }
    }

    // MARK: - Data Generation

    private static func generateDocuments() -> [Document] {
        let types = [
            "Contract", "Invoice", "Memo", "Report", "Letter", "Directive",
            "NDA", "Procurement", "Resolution", "Order",
        ]
        let stages = [
            "Pending Signature", "For Approval", "For Acknowledge", "For Review",
            "Urgent", "Active", "For Signing", "Sent", "Draft",
        ]
        let initiators = [
            "Maxim Sokhatsky", "Alice Smith", "Finance Dept", "HR Dept",
            "Legal Dept", "IT Department", "Security Team", "Operations",
            "Bob Jones", "Eva Martinez", "Board Secretary", "Procurement",
        ]
        let correspondents = [
            "Global Tech Inc", "Office Supplies Co", "Internal", "CloudServe Ltd",
            "Partner Corp", "DataCenter Pro", "Internal Audit", "TechSupply Inc",
            "Board Members", "External Counsel", "Analytics Team", "Board",
        ]
        let addressees = [
            "John Doe", "All Employees", "Maxim Sokhatsky", "Alice Smith",
            "Jane F.", "All Departments", "Accounting", "Eva Martinez",
            "Board of Directors", "Finance Dept",
        ]
        let summaries = [
            "Annual service agreement renewal for cloud infrastructure.",
            "Q1 Office Supplies procurement and budget allocation.",
            "Updated company policies regarding remote work and hybrid model.",
            "Q4 2025 Performance Analytics Report with KPI breakdown.",
            "Response to compliance inquiry from regulatory board.",
            "New security protocols for Q1 2026 implementation.",
            "Cloud infrastructure hosting agreement for production servers.",
            "Non-disclosure agreement for joint venture project.",
            "Monthly server hosting fees and maintenance costs.",
            "Annual security audit findings and recommendations report.",
            "Scheduled maintenance window notification for all systems.",
            "Employment agreement for Senior Developer position.",
            "Quarterly strategic update letter to stakeholders.",
            "Laptop procurement request for new engineering hires.",
            "Board resolution on annual budget allocation and review.",
            "Internal memo on updated travel reimbursement policy.",
            "Vendor risk assessment for third-party data processors.",
            "Contract amendment for extended support agreement.",
            "Project kickoff document for Phase 2 development.",
            "Incident response report for January security event.",
        ]

        var docs: [Document] = []
        for i in 0..<20 {
            docs.append(
                Document(
                    id: UUID(),
                    type: types[i % types.count],
                    initiator: initiators[i % initiators.count],
                    addressedTo: addressees[i % addressees.count],
                    stage: stages[i % stages.count],
                    documentNumber:
                        "\(types[i % types.count].prefix(3).uppercased())-2026-\(String(format: "%03d", i + 1))",
                    date: Date().addingTimeInterval(Double(-i * 43200)),
                    correspondent: correspondents[i % correspondents.count],
                    shortSummary: summaries[i % summaries.count],
                    outgoingNumber: i % 4 == 0 ? "N/A" : "OUT-\(String(format: "%03d", i + 1))"
                ))
        }
        return docs
    }
}

// MARK: - Attachment Model

enum AttachmentType: String {
    case pdf, image, document, spreadsheet, other

    var icon: String {
        switch self {
        case .pdf: "doc.fill"
        case .image: "photo.fill"
        case .document: "doc.text.fill"
        case .spreadsheet: "tablecells.fill"
        case .other: "paperclip"
        }
    }
}

struct MockAttachment: Identifiable {
    let id = UUID()
    let name: String
    let size: Int64
    let type: AttachmentType

    var formattedSize: String {
        ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
}
