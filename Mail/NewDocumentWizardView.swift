import SwiftUI
internal import UniformTypeIdentifiers

// MARK: - Attachment Model

struct AttachedFile: Identifiable {
    let id = UUID()
    let name: String
    let size: Int64  // bytes
    let url: URL

    var formattedSize: String {
        ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }

    var icon: String {
        let ext = url.pathExtension.lowercased()
        switch ext {
        case "pdf": return "doc.fill"
        case "png", "jpg", "jpeg", "heic": return "photo.fill"
        case "doc", "docx": return "doc.text.fill"
        case "xls", "xlsx": return "tablecells.fill"
        default: return "paperclip"
        }
    }
}

// MARK: - Main View

struct NewDocumentWizardView: View {
    @EnvironmentObject var state: CRMState

    @State private var selectedTemplate: DocumentTemplate? = nil

    // Tracking form values dynamically based on their underlying type
    @State private var fieldValues: [UUID: String] = [:]
    @State private var dateValues: [UUID: Date] = [:]
    @State private var toggleValues: [UUID: Bool] = [:]

    // Related Documents
    @State private var relatedDocSearch: String = ""
    @State private var linkedDocuments: [Document] = []

    // Attachments
    @State private var attachedFiles: [AttachedFile] = []
    @State private var isDropTargeted: Bool = false

    private var filteredAvailableDocs: [Document] {
        let available = MockDataStore.shared.documents.filter { doc in
            !linkedDocuments.contains(where: { $0.id == doc.id })
        }
        if relatedDocSearch.isEmpty { return available }
        let query = relatedDocSearch.lowercased()
        return available.filter {
            $0.shortSummary.lowercased().contains(query)
                || $0.documentNumber.lowercased().contains(query)
                || $0.type.lowercased().contains(query)
                || $0.correspondent.lowercased().contains(query)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                #if os(macOS)
                    HSplitView {
                        leftPane
                            .frame(minWidth: 250, idealWidth: 300, maxWidth: 400)
                        middlePane
                            .frame(minWidth: 300, idealWidth: 350, maxWidth: 500)
                        rightPane
                            .frame(minWidth: 350, maxWidth: .infinity, maxHeight: .infinity)
                    }
                #else
                    HStack(spacing: 0) {
                        leftPane
                            .frame(width: 300)
                        Divider()
                        middlePane
                            .frame(width: 350)
                        Divider()
                        rightPane
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                #endif
            }
            .navigationTitle(selectedTemplate?.templateName ?? "Select Document Category")
        }
        .frame(minWidth: 1000, minHeight: 600)
    }

    // MARK: - Left Pane (Template Sidebar)

    @ViewBuilder
    private var leftPane: some View {
        TemplatePickerSidebar(
            selectedTemplate: $selectedTemplate, categories: TemplateCategory.mockCategories
        )
        .background(CRMTheme.primaryBackground)
    }

    // MARK: - Middle Pane (Form)

    @ViewBuilder
    private var middlePane: some View {
        VStack(spacing: 0) {
            unifiedFormStep
        }
        .crmBackground()
    }

    // MARK: - Right Pane (Attachments Drop Zone)

    @ViewBuilder
    private var rightPane: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "paperclip")
                    .foregroundStyle(.secondary)
                Text("Attachments")
                    .font(.headline)
                Spacer()
                Text("\(attachedFiles.count) files")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(CRMTheme.secondaryBackground.opacity(0.5))

            Divider()

            if attachedFiles.isEmpty {
                // Empty drop zone
                dropZonePlaceholder
            } else {
                // File list + drop zone at the bottom
                List {
                    ForEach(attachedFiles) { file in
                        HStack(spacing: 10) {
                            Image(systemName: file.icon)
                                .font(.title3)
                                .foregroundStyle(.blue)
                                .frame(width: 28)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(file.name)
                                    .font(.body.weight(.medium))
                                    .lineLimit(1)
                                Text(file.formattedSize)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Button {
                                withAnimation {
                                    attachedFiles.removeAll { $0.id == file.id }
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)

                Divider()

                // Compact drop zone at the bottom for adding more
                compactDropZone
            }
        }
        .background(CRMTheme.secondaryBackground)
    }

    // MARK: - Drop Zone Views

    private var dropZonePlaceholder: some View {
        VStack(spacing: 16) {
            Image(systemName: "arrow.down.doc.fill")
                .font(.system(size: 50))
                .foregroundStyle(isDropTargeted ? .blue : .secondary.opacity(0.5))
                .symbolEffect(.pulse, isActive: isDropTargeted)

            Text("Drag & Drop Files Here")
                .font(.title3.weight(.medium))
                .foregroundStyle(isDropTargeted ? .primary : .secondary)

            Text("or")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button {
                pickFiles()
            } label: {
                Label("Browse Files", systemImage: "folder")
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(
                    isDropTargeted ? Color.blue : Color.secondary.opacity(0.3),
                    style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                )
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(isDropTargeted ? Color.blue.opacity(0.05) : Color.clear)
                )
        )
        .padding()
        .onDrop(of: [.fileURL], isTargeted: $isDropTargeted) { providers in
            handleDrop(providers)
        }
    }

    private var compactDropZone: some View {
        HStack(spacing: 12) {
            Image(systemName: "plus.circle.fill")
                .foregroundStyle(isDropTargeted ? .blue : .secondary)

            Text(isDropTargeted ? "Drop here" : "Drag files or")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if !isDropTargeted {
                Button("Browse") {
                    pickFiles()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(
                    isDropTargeted ? Color.blue : Color.secondary.opacity(0.2),
                    style: StrokeStyle(lineWidth: 1, dash: [6, 3])
                )
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(isDropTargeted ? Color.blue.opacity(0.05) : Color.clear)
                )
        )
        .padding()
        .onDrop(of: [.fileURL], isTargeted: $isDropTargeted) { providers in
            handleDrop(providers)
        }
    }

    // MARK: - Drop Handling

    private func handleDrop(_ providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) {
                item, _ in
                guard let data = item as? Data,
                    let url = URL(dataRepresentation: data, relativeTo: nil)
                else { return }

                let name = url.lastPathComponent
                let size =
                    (try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64)
                    ?? 0

                let file = AttachedFile(name: name, size: size, url: url)
                DispatchQueue.main.async {
                    withAnimation {
                        // Avoid duplicates by name
                        if !attachedFiles.contains(where: { $0.name == file.name }) {
                            attachedFiles.append(file)
                        }
                    }
                }
            }
        }
        return true
    }

    private func pickFiles() {
        #if os(macOS)
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = true
            panel.canChooseDirectories = false
            panel.canChooseFiles = true
            panel.begin { response in
                if response == .OK {
                    for url in panel.urls {
                        let name = url.lastPathComponent
                        let size =
                            (try? FileManager.default.attributesOfItem(atPath: url.path)[.size]
                                as? Int64) ?? 0
                        let file = AttachedFile(name: name, size: size, url: url)
                        if !attachedFiles.contains(where: { $0.name == file.name }) {
                            attachedFiles.append(file)
                        }
                    }
                }
            }
        #endif
    }

    // MARK: - Unified Form Step

    @ViewBuilder
    private var unifiedFormStep: some View {
        if let template = selectedTemplate {
            VStack(alignment: .leading, spacing: 16) {
                Form {
                    Section(header: Text(appLocalized("Metadata Fields"))) {
                        ForEach(template.requiredFields) { field in
                            HStack {
                                Text(field.title)
                                    .frame(alignment: .leading)
                                Spacer()
                                dynamicField(for: field)
                            }
                        }
                    }

                    // Related Documents Section
                    Section("Related Documents") {
                        // Search bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            TextField("Search documents to link...", text: $relatedDocSearch)
                                .textFieldStyle(.plain)
                            if !relatedDocSearch.isEmpty {
                                Button {
                                    relatedDocSearch = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        // Search results
                        if !relatedDocSearch.isEmpty {
                            ForEach(filteredAvailableDocs) { doc in
                                Button {
                                    withAnimation {
                                        linkedDocuments.append(doc)
                                        relatedDocSearch = ""
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundStyle(.green)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(doc.documentNumber)
                                                .font(.caption.bold())
                                            Text(doc.shortSummary)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                                .lineLimit(1)
                                        }
                                        Spacer()
                                        Text(doc.type)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .buttonStyle(.plain)
                            }

                            if filteredAvailableDocs.isEmpty {
                                Text("No matching documents found")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        // Linked documents list
                        if !linkedDocuments.isEmpty {
                            ForEach(linkedDocuments) { doc in
                                HStack {
                                    Image(systemName: "link")
                                        .foregroundStyle(.blue)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(doc.documentNumber)
                                            .font(.caption.bold())
                                        Text(doc.shortSummary)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                    Button {
                                        withAnimation {
                                            linkedDocuments.removeAll { $0.id == doc.id }
                                        }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.red)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        } else if relatedDocSearch.isEmpty {
                            Text("No related documents linked yet")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .formStyle(.grouped)

                HStack {
                    Spacer()
                    Button("Create Document") {
                        withAnimation {
                            selectedTemplate = nil
                            fieldValues.removeAll()
                            dateValues.removeAll()
                            toggleValues.removeAll()
                            linkedDocuments.removeAll()
                            relatedDocSearch = ""
                            attachedFiles.removeAll()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedTemplate == nil)
                }
                .padding()
            }
        } else {
            VStack(spacing: 20) {
                Image(systemName: "hand.point.left")
                    .font(.system(size: 60))
                    .foregroundColor(CRMTheme.secondaryText)
                Text("Select a Template")
                    .font(.headline)
                    .foregroundColor(CRMTheme.primaryText)
                Text("Choose a category and template from the left pane to begin.")
                    .font(.subheadline)
                    .foregroundColor(CRMTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Dynamic Fields

    @ViewBuilder
    private func dynamicField(for field: FormField) -> some View {
        switch field.type {
        case .text:
            TextField(
                "",
                text: Binding(
                    get: { fieldValues[field.id] ?? "" },
                    set: { fieldValues[field.id] = $0 }
                )
            )
            .textFieldStyle(.roundedBorder)

        case .number, .currency:
            TextField(
                "",
                text: Binding(
                    get: { fieldValues[field.id] ?? "" },
                    set: { fieldValues[field.id] = $0 }
                )
            )
            .textFieldStyle(.roundedBorder)

        case .date:
            DatePicker(
                "",
                selection: Binding(
                    get: { dateValues[field.id] ?? Date() },
                    set: { dateValues[field.id] = $0 }
                ), displayedComponents: .date
            )
            .labelsHidden()

        case .datetime:
            DatePicker(
                "",
                selection: Binding(
                    get: { dateValues[field.id] ?? Date() },
                    set: { dateValues[field.id] = $0 }
                )
            )
            .labelsHidden()

        case .toggle:
            Toggle(
                "",
                isOn: Binding(
                    get: { toggleValues[field.id] ?? false },
                    set: { toggleValues[field.id] = $0 }
                )
            )
            .labelsHidden()

        case .dropdown(let options), .searchDropdown(let options):
            Picker(
                "",
                selection: Binding(
                    get: { fieldValues[field.id] ?? options.first ?? "" },
                    set: { fieldValues[field.id] = $0 }
                )
            ) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
        }
    }
}

#Preview {
    NewDocumentWizardView()
        .environmentObject(CRMState())
}
