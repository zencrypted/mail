import SwiftUI

struct ERPMainView: View {
    @EnvironmentObject var state: ERPState
    
    // Sort orders for table
    @State private var sortOrder = [KeyPathComparator(\Document.date, order: .reverse)]
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } content: {
            tableColumn
        } detail: {
            detailColumn
        }
        .navigationSplitViewStyle(.balanced)
        .erpBackground()
    }
    
    @ViewBuilder
    private var sidebar: some View {
        List(selection: $state.selectedInbox) {
            Section(header: Text("Inboxes").foregroundColor(ERPTheme.secondaryText)) {
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
                        .foregroundColor(ERPTheme.primaryText)
                    }
                    .listRowBackground(state.selectedInbox?.id == folder.id ? ERPTheme.secondaryBackground : ERPTheme.primaryBackground)
                }
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 300)
        .background(ERPTheme.primaryBackground)
        .scrollContentBackground(.hidden)
    }
    
    @ViewBuilder
    private var tableColumn: some View {
        VStack(spacing: 0) {
            // Filter Logic
            let filteredDocs = Document.mockDocuments.filter { doc in
                (state.typeFilter.isEmpty || doc.type.localizedCaseInsensitiveContains(state.typeFilter)) &&
                (state.initiatorFilter.isEmpty || doc.initiator.localizedCaseInsensitiveContains(state.initiatorFilter)) &&
                (state.addressedToFilter.isEmpty || doc.addressedTo.localizedCaseInsensitiveContains(state.addressedToFilter)) &&
                (state.stageFilter.isEmpty || doc.stage.localizedCaseInsensitiveContains(state.stageFilter)) &&
                (state.numberFilter.isEmpty || doc.documentNumber.localizedCaseInsensitiveContains(state.numberFilter)) &&
                (state.correspondentFilter.isEmpty || doc.correspondent.localizedCaseInsensitiveContains(state.correspondentFilter)) &&
                (state.summaryFilter.isEmpty || doc.shortSummary.localizedCaseInsensitiveContains(state.summaryFilter)) &&
                (state.outNumberFilter.isEmpty || doc.outgoingNumber.localizedCaseInsensitiveContains(state.outNumberFilter))
            }
            .sorted(using: sortOrder)
            
            // Toolbar equivalent for table actions
            HStack {
                Text(state.selectedInbox?.name ?? "Select an Inbox")
                    .font(.title2.bold())
                    .foregroundColor(ERPTheme.primaryText)
                
                Spacer()
                
                Button(action: {
                    let allIds = Set(filteredDocs.map(\.id))
                    if state.selectedDocuments == allIds {
                        state.selectedDocuments.removeAll()
                    } else {
                        state.selectedDocuments = allIds
                    }
                }) {
                    Label(state.selectedDocuments.count == filteredDocs.count && !filteredDocs.isEmpty ? "Deselect All" : "Select All", systemImage: "checklist")
                }
                
                Button(action: {}) {
                    Label("Sign", systemImage: "signature")
                }
                Button(action: {
                    // Create a new document / view
                    if let firstDoc = Document.mockDocuments.first {
                        state.selectedDocuments = [firstDoc.id]
                    }
                }) {
                    Label("New Document", systemImage: "doc.badge.plus")
                }
            }
            .padding()
            .background(ERPTheme.secondaryBackground.opacity(0.3))
            .border(ERPTheme.border, width: 0.0)
            
            // Per-Column Filter Bar
            HStack(spacing: 8) {
                Spacer().frame(width: 30) // Offset for checkbox column
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundColor(ERPTheme.secondaryText)
                TextField("Type", text: $state.typeFilter).textFieldStyle(.roundedBorder)
                TextField("Initiator", text: $state.initiatorFilter).textFieldStyle(.roundedBorder)
                TextField("To...", text: $state.addressedToFilter).textFieldStyle(.roundedBorder)
               // TextField("Stage", text: $state.stageFilter).textFieldStyle(.roundedBorder)
               // TextField("Number", text: $state.numberFilter).textFieldStyle(.roundedBorder)
               // TextField("Correspondent", text: $state.correspondentFilter).textFieldStyle(.roundedBorder)
               // TextField("Summary", text: $state.summaryFilter).textFieldStyle(.roundedBorder)
               // TextField("Out Num", text: $state.outNumberFilter).textFieldStyle(.roundedBorder)
            }
            .padding()
            .background(ERPTheme.secondaryBackground.opacity(0.3))
            .border(ERPTheme.border, width: 0.0)

            // Advanced Table with specific requested columns supporting multi-selection
            Table(filteredDocs, selection: $state.selectedDocuments, sortOrder: $sortOrder) {
                TableColumn("") { doc in
                    Toggle("", isOn: Binding(
                        get: { state.selectedDocuments.contains(doc.id) },
                        set: { isSelected in
                            if isSelected {
                                state.selectedDocuments.insert(doc.id)
                            } else {
                                state.selectedDocuments.remove(doc.id)
                            }
                        }
                    ))
                    .labelsHidden()
                }
                .width(20)
                
                TableColumn("Type", value: \.type)
                TableColumn("Initiator", value: \.initiator)
                TableColumn("Addressed to", value: \.addressedTo)
                //TableColumn("Stage", value: \.stage)
                //TableColumn("Number", value: \.documentNumber)
                TableColumn("Date", value: \.date) { doc in
                    Text(doc.date, style: .date)
                }
                //TableColumn("Correspondent", value: \.correspondent)
                //TableColumn("Summary", value: \.shortSummary)
                //TableColumn("Out Number", value: \.outgoingNumber)
            }
            .tableStyle(.bordered)
        }
        .navigationSplitViewColumnWidth(min: 500, ideal: 800)
    }
    
    @ViewBuilder
    private var detailColumn: some View {
        if state.selectedDocuments.count == 1, let firstId = state.selectedDocuments.first, let document = Document.mockDocuments.first(where: { $0.id == firstId }) {
            DocumentDetailView(document: document)
        } else if state.selectedDocuments.count > 1 {
            VStack(spacing: 20) {
                Image(systemName: "square.stack.3d.up.fill")
                    .font(.system(size: 60))
                    .foregroundColor(ERPTheme.accent)
                Text("\(state.selectedDocuments.count) Documents Selected")
                    .font(.title)
                    .foregroundColor(ERPTheme.primaryText)
                
                Button("Batch Sign") {
                    // Logic to batched sign
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .erpBackground()
        } else {
            VStack {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundColor(ERPTheme.secondaryText)
                Text("Select a document to view details")
                    .foregroundColor(ERPTheme.secondaryText)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .erpBackground()
        }
    }
}
