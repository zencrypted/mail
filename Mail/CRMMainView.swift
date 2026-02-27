import PDFKit
import SwiftUI

func appLocalized(_ key: String) -> String {
    let lang = UserDefaults.standard.string(forKey: "selected_lang") ?? "ua"
    let bundlePath = Bundle.main.path(forResource: lang, ofType: "lproj") ?? Bundle.main.bundlePath
    if let bundle = Bundle(path: bundlePath) {
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
    return Bundle.main.localizedString(forKey: key, value: nil, table: nil)
}

struct CRMMainView: View {
    @EnvironmentObject var state: CRMState
    @Environment(\.openWindow) private var openWindow

    // Sort orders for table
    @State private var sortOrder = [KeyPathComparator(\Document.date, order: .reverse)]

    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            contentArea
        }
        .navigationSplitViewStyle(.balanced)
        .crmBackground()
    }

    // MARK: - Sidebar (Folders — always visible)

    @ViewBuilder
    private var sidebar: some View {
        List(selection: $state.selectedInbox) {
            Section(header: Text(appLocalized("Inboxes")).foregroundColor(CRMTheme.secondaryText)) {
                ForEach(InboxFolder.mockFolders) { folder in
                    NavigationLink(value: folder) {
                        HStack {
                            Image(systemName: folder.iconName)
                                .frame(width: 24)
                            Text(folder.name)
                            Spacer()
                            if folder.incomingCounter > 0 {
                                Text("\(folder.incomingCounter)")
                                    .font(.caption.bold())
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(folder.badgeColor)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                        .foregroundColor(CRMTheme.primaryText)
                    }
                    .contextMenu {
                        Button {
                            state.selectedInbox = folder
                        } label: {
                            Label("Open Inbox", systemImage: "tray")
                        }

                        Button {
                            openWindow(id: "inboxWindow", value: folder.id)
                        } label: {
                            Label("Open in New Tab", systemImage: "plus.rectangle.on.rectangle")
                        }
                    }
                    .listRowBackground(
                        state.selectedInbox?.id == folder.id
                            ? CRMTheme.secondaryBackground : CRMTheme.primaryBackground)
                }
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 300)
        .background(CRMTheme.primaryBackground)
        .scrollContentBackground(.hidden)
    }

    // MARK: - Content Area (Action-Driven Switching)

    @ViewBuilder
    private var contentArea: some View {
        switch state.activePanel {
        case .messages:
            messagesPanel
        case .pdfViewer:
            pdfViewerPanel
        case .attributes:
            attributesPanel
        }
    }

    // MARK: - Panel: Messages / Table (Default)

    @ViewBuilder
    private var messagesPanel: some View {
        VStack(spacing: 0) {
            let filteredDocs = state.store.documents.filter { doc in
                (state.typeFilter.isEmpty
                    || doc.type.localizedCaseInsensitiveContains(state.typeFilter))
                    && (state.initiatorFilter.isEmpty
                        || doc.initiator.localizedCaseInsensitiveContains(state.initiatorFilter))
                    && (state.addressedToFilter.isEmpty
                        || doc.addressedTo.localizedCaseInsensitiveContains(state.addressedToFilter))
                    && (state.stageFilter.isEmpty
                        || doc.stage.localizedCaseInsensitiveContains(state.stageFilter))
                    && (state.numberFilter.isEmpty
                        || doc.documentNumber.localizedCaseInsensitiveContains(state.numberFilter))
                    && (state.correspondentFilter.isEmpty
                        || doc.correspondent.localizedCaseInsensitiveContains(
                            state.correspondentFilter))
                    && (state.summaryFilter.isEmpty
                        || doc.shortSummary.localizedCaseInsensitiveContains(state.summaryFilter))
                    && (state.outNumberFilter.isEmpty
                        || doc.outgoingNumber.localizedCaseInsensitiveContains(
                            state.outNumberFilter))
            }
            .sorted(using: sortOrder)

            // Toolbar
            HStack {
                Text(state.selectedInbox?.name ?? "Select an Inbox")
                    .font(.title2.bold())
                    .foregroundColor(CRMTheme.primaryText)

                Spacer()

                Button(action: {
                    let allIds = Set(filteredDocs.map(\.id))
                    if state.selectedDocuments == allIds {
                        state.selectedDocuments.removeAll()
                    } else {
                        state.selectedDocuments = allIds
                    }
                }) {
                    Label(
                        state.selectedDocuments.count == filteredDocs.count && !filteredDocs.isEmpty
                            ? "Deselect All" : "Select All", systemImage: "checklist")
                }

                Button(action: {}) {
                    Label("Sign", systemImage: "signature")
                }

                Menu {
                    ForEach(DocumentColumn.allCases) { column in
                        Button {
                            if state.visibleColumns.contains(column) {
                                state.visibleColumns.remove(column)
                            } else {
                                state.visibleColumns.insert(column)
                            }
                        } label: {
                            HStack {
                                Text(column.rawValue)
                                if state.visibleColumns.contains(column) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Label("Columns", systemImage: "tablecells")
                }
            }
            .padding()
            .background(CRMTheme.secondaryBackground.opacity(0.3))
            .border(CRMTheme.border, width: 0.0)

            // Per-Column Filter Bar
            HStack(spacing: 8) {
                Spacer().frame(width: 30)
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundColor(CRMTheme.secondaryText)
                ForEach(DocumentColumn.allCases) { column in
                    if state.visibleColumns.contains(column) {
                        filterField(for: column)
                    }
                }
            }
            .padding()
            .background(CRMTheme.secondaryBackground.opacity(0.3))
            .border(CRMTheme.border, width: 0.0)

            // Table with row context menus for View/Edit actions
            Table(filteredDocs, selection: $state.selectedDocuments, sortOrder: $sortOrder) {
                TableColumn("") { doc in
                    HStack(spacing: 4) {
                        Toggle(
                            "",
                            isOn: Binding(
                                get: { state.selectedDocuments.contains(doc.id) },
                                set: { isSelected in
                                    if isSelected {
                                        state.selectedDocuments.insert(doc.id)
                                    } else {
                                        state.selectedDocuments.remove(doc.id)
                                    }
                                }
                            )
                        )
                        .labelsHidden()

                        Button {
                            state.selectedDocuments = [doc.id]
                            state.activePanel = .pdfViewer
                        } label: {
                            Image(systemName: "eye")
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                        .help("View PDF")

                        Button {
                            state.selectedDocuments = [doc.id]
                            state.activePanel = .attributes
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundStyle(.orange)
                        }
                        .buttonStyle(.plain)
                        .help("Edit Attributes")
                    }
                }
                .width(80)

                if isVisible(.type) { TableColumn("Type", value: \.type) }
                if isVisible(.initiator) { TableColumn("Initiator", value: \.initiator) }
                if isVisible(.addressedTo) { TableColumn("Addressed to", value: \.addressedTo) }
                if isVisible(.stage) { TableColumn("Stage", value: \.stage) }
                if isVisible(.number) { TableColumn("Number", value: \.documentNumber) }
                if isVisible(.date) {
                    TableColumn("Date", value: \.date) { Text($0.date, style: .date) }
                }
                if isVisible(.correspondent) {
                    TableColumn("Correspondent", value: \.correspondent)
                }
                if isVisible(.summary) { TableColumn("Summary", value: \.shortSummary) }
                if isVisible(.outNumber) { TableColumn("Out Number", value: \.outgoingNumber) }
            }
            #if os(macOS)
                .tableStyle(.bordered)
            #endif
        }
    }

    // MARK: - Panel: PDF Viewer (only when clicking View on a doc)

    @ViewBuilder
    private var pdfViewerPanel: some View {
        VStack(spacing: 0) {
            // Back bar
            panelHeader(title: "PDF Viewer", icon: "doc.richtext")

            if state.selectedDocuments.count == 1,
                let firstId = state.selectedDocuments.first,
                let document = state.store.documents.first(where: { $0.id == firstId })
            {

                if let pdfURL = document.pdfURL {
                    PDFKitView(
                        url: pdfURL,
                        template: nil,
                        fieldValues: [:],
                        dateValues: [:])
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundStyle(.secondary)
                        Text("No PDF attached to \"\(document.shortSummary)\"")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text("Document: \(document.documentNumber)")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .crmBackground()
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "doc.richtext")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)
                    Text("No document selected")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .crmBackground()
            }
        }
    }

    // MARK: - Panel: Attributes / Edit Form (only when clicking Edit on a doc)

    @ViewBuilder
    private var attributesPanel: some View {
        VStack(spacing: 0) {
            panelHeader(title: "Document Attributes", icon: "list.clipboard")

            if state.selectedDocuments.count == 1,
                let firstId = state.selectedDocuments.first,
                let document = state.store.documents.first(where: { $0.id == firstId })
            {
                DocumentEditForm(
                    document: document, store: state.store,
                    onDone: {
                        state.activePanel = .messages
                    })
            } else {
                NewDocumentWizardView()
            }
        }
    }

    // MARK: - Shared Panel Header with Back Button

    private func panelHeader(title: String, icon: String) -> some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    state.activePanel = .messages
                }
            } label: {
                Label("Back to Messages", systemImage: "chevron.left")
            }
            .buttonStyle(.plain)
            .foregroundStyle(CRMTheme.accent)

            Spacer()

            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
                    .font(.headline)
            }
            .foregroundStyle(CRMTheme.primaryText)

            Spacer()

            // Balance the layout
            Color.clear.frame(width: 140, height: 1)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(CRMTheme.secondaryBackground.opacity(0.3))
    }

    // MARK: - Helpers

    private func isVisible(_ column: DocumentColumn) -> Bool {
        state.visibleColumns.contains(column)
    }

    @ViewBuilder
    private func filterField(for column: DocumentColumn) -> some View {
        Group {
            switch column {
            case .type: TextField("Type", text: $state.typeFilter)
            case .initiator: TextField("Initiator", text: $state.initiatorFilter)
            case .addressedTo: TextField("To...", text: $state.addressedToFilter)
            case .stage: TextField("Stage", text: $state.stageFilter)
            case .number: TextField("Number", text: $state.numberFilter)
            case .date: Spacer().frame(width: 80)
            case .correspondent: TextField("Correspondent", text: $state.correspondentFilter)
            case .summary: TextField("Summary", text: $state.summaryFilter)
            case .outNumber: TextField("Out Num", text: $state.outNumberFilter)
            }
        }
        .textFieldStyle(.roundedBorder)
    }
}
