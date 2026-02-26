import SwiftUI

/// Inline edit form for an existing CRM document.
struct DocumentEditForm: View {
    let document: Document
    @ObservedObject var store: MockDataStore
    var onDone: () -> Void

    @State private var editType: String = ""
    @State private var editInitiator: String = ""
    @State private var editAddressedTo: String = ""
    @State private var editStage: String = ""
    @State private var editCorrespondent: String = ""
    @State private var editSummary: String = ""
    @State private var editOutNumber: String = ""
    @State private var isInitialized = false

    private let stages = [
        "Draft", "Pending Signature", "For Approval", "For Acknowledge",
        "For Review", "Urgent", "Active", "For Signing", "Sent",
    ]
    private let types = [
        "Contract", "Invoice", "Memo", "Report", "Letter",
        "Directive", "NDA", "Procurement", "Resolution", "Order",
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Document header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(document.documentNumber)
                            .font(.title3.monospaced().bold())
                        Text(
                            "Created: \(document.date.formatted(date: .abbreviated, time: .shortened))"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(editStage)
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(stageColor.opacity(0.15))
                        .foregroundStyle(stageColor)
                        .clipShape(Capsule())
                }
                .padding()
                .background(CRMTheme.secondaryBackground.opacity(0.3))

                Divider()

                // Edit form
                Form {
                    Section("Document Type") {
                        Picker("Type", selection: $editType) {
                            ForEach(types, id: \.self) { t in
                                Text(t).tag(t)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    Section("Workflow") {
                        Picker("Stage", selection: $editStage) {
                            ForEach(stages, id: \.self) { s in
                                Text(s).tag(s)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    Section("Participants") {
                        TextField("Initiator", text: $editInitiator)
                            .textFieldStyle(.roundedBorder)
                        TextField("Addressed To", text: $editAddressedTo)
                            .textFieldStyle(.roundedBorder)
                        TextField("Correspondent", text: $editCorrespondent)
                            .textFieldStyle(.roundedBorder)
                    }

                    Section("Details") {
                        TextEditor(text: $editSummary)
                            .frame(minHeight: 60)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.secondary.opacity(0.2))
                            )
                        TextField("Outgoing Number", text: $editOutNumber)
                            .textFieldStyle(.roundedBorder)
                    }

                    // Attachments section
                    Section("Attachments") {
                        let docAttachments = store.attachments[document.id] ?? []
                        if docAttachments.isEmpty {
                            Text("No attachments")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(docAttachments) { att in
                                HStack {
                                    Image(systemName: att.type.icon)
                                        .foregroundStyle(.blue)
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text(att.name)
                                            .font(.callout)
                                            .lineLimit(1)
                                        Text(att.formattedSize)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Button {
                                        store.removeAttachment(
                                            from: document.id, attachmentId: att.id)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundStyle(.red)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .formStyle(.grouped)

                // Action buttons
                HStack(spacing: 12) {
                    Spacer()

                    Button("Cancel") {
                        onDone()
                    }
                    .buttonStyle(.bordered)

                    Button("Save Changes") {
                        store.updateDocument(
                            id: document.id,
                            type: editType,
                            stage: editStage,
                            summary: editSummary,
                            correspondent: editCorrespondent
                        )
                        onDone()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .onAppear {
            guard !isInitialized else { return }
            editType = document.type
            editInitiator = document.initiator
            editAddressedTo = document.addressedTo
            editStage = document.stage
            editCorrespondent = document.correspondent
            editSummary = document.shortSummary
            editOutNumber = document.outgoingNumber
            isInitialized = true
        }
    }

    private var stageColor: Color {
        switch editStage {
        case "Active", "Sent": .green
        case "Pending Signature", "For Signing": .orange
        case "Urgent": .red
        case "For Approval", "For Acknowledge": .blue
        case "For Review": .purple
        case "Draft": .gray
        default: .secondary
        }
    }
}
