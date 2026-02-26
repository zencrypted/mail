import SwiftData
import SwiftUI

// MARK: - Right Pane Tab

enum DetailTab: String, CaseIterable, Identifiable {
    case document = "Document"
    case discussion = "Discussion"
    case related = "Related"

    var id: String { rawValue }
}

// MARK: - Dashboard View

struct RMKDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = DashboardViewModel()
    @State private var hasSeeded = false
    @State private var activeTab: DetailTab = .document

    var body: some View {
        HSplitView {
            // Left: Monitor (Tree)
            monitorPane
                .frame(minWidth: 300, idealWidth: 380, maxWidth: 500)

            // Middle: Document Details (Реквізити)
            detailsPane
                .frame(minWidth: 250, idealWidth: 300, maxWidth: 400)

            // Right: Document / Discussion / Related
            rightPane
                .frame(minWidth: 350, maxWidth: .infinity)
        }
        .frame(minWidth: 1000, minHeight: 600)
        .task {
            guard !hasSeeded else { return }

            let container = modelContext.container
            viewModel.configure(context: modelContext, container: container)

            let count = (try? modelContext.fetchCount(FetchDescriptor<RMKDocument>())) ?? 0
            if count == 0 {
                let seeder = DataSeeder(modelContainer: container)
                await seeder.seed(totalDocuments: 5000, maxDepth: 55)
            }

            hasSeeded = true
            viewModel.loadRoots()
        }
    }

    // MARK: - Left Pane: Monitor (Tree)

    private var monitorPane: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "doc.text.magnifyingglass")
                    .foregroundStyle(.secondary)
                Text("Монітор")
                    .font(.headline)
                Spacer()

                Button {
                    viewModel.showQuickAdd = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(nsColor: .controlBackgroundColor))

            Divider()

            // Search
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.tertiary)
                TextField("Search...", text: $viewModel.searchText)
                    .textFieldStyle(.plain)
                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(6)
            .background(.quaternary)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .padding(8)

            Divider()

            // Tree
            if viewModel.visibleRoots.isEmpty {
                ContentUnavailableView {
                    Label("No Documents", systemImage: "doc.text.magnifyingglass")
                }
            } else {
                LazyTreeView(roots: viewModel.visibleRoots, viewModel: viewModel)
            }
        }
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
        .sheet(isPresented: $viewModel.showQuickAdd) {
            QuickAddForm(viewModel: viewModel)
                .frame(minWidth: 600, minHeight: 120)
        }
    }

    // MARK: - Middle Pane: Document Details (Реквізити документу)

    private var detailsPane: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Реквізити документу")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(nsColor: .controlBackgroundColor))

            Divider()

            if let doc = viewModel.selectedDocument {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        detailRow(label: "Ініціатор:", value: doc.applicant ?? "—")
                        detailRow(label: "Виконавець:", value: doc.applicant ?? "—")
                        detailRow(label: "До відома:", value: "—")
                        detailRow(
                            label: "Виконати до:",
                            value: doc.updatedAt.formatted(date: .abbreviated, time: .omitted))
                        detailRow(label: "Вимагає контролю:", value: "—")
                        detailRow(label: "Співвиконавці:", value: "—")

                        Divider()

                        detailRow(label: "Виконавець:", value: doc.applicant ?? "—")
                        detailRow(label: "До відома:", value: "—")
                        detailRow(
                            label: "Контроль:",
                            value: doc.createdAt.formatted(date: .abbreviated, time: .omitted))

                        Divider()

                        detailRow(label: "Тип:", value: doc.type.rawValue)
                        detailRow(label: "Статус:", value: doc.status.rawValue)
                        detailRow(label: "Номер:", value: doc.documentNumber)
                        if let value = doc.value {
                            detailRow(label: "Сума:", value: String(format: "%.2f", value))
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Ініціатор:")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(doc.applicant ?? "—")
                                .font(.body)
                        }
                    }
                    .padding(12)
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 40))
                        .foregroundStyle(.tertiary)
                    Text("Select a document")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 110, alignment: .trailing)
            Text(value)
                .font(.callout)
        }
    }

    // MARK: - Right Pane: Document / Discussion / Related

    private var rightPane: some View {
        VStack(spacing: 0) {
            // Tab Switcher
            HStack(spacing: 0) {
                ForEach(DetailTab.allCases) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            activeTab = tab
                        }
                    } label: {
                        Text(tab.rawValue)
                            .font(.subheadline.weight(activeTab == tab ? .semibold : .regular))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                activeTab == tab
                                    ? Color.accentColor
                                    : Color(nsColor: .controlBackgroundColor)
                            )
                            .foregroundStyle(activeTab == tab ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            .background(Color(nsColor: .controlBackgroundColor))

            Divider()

            // Tab Content
            switch activeTab {
            case .document:
                documentTabContent
            case .discussion:
                discussionTabContent
            case .related:
                relatedTabContent
            }
        }
    }

    // MARK: - Tab: Document (preview placeholder)

    private var documentTabContent: some View {
        Group {
            if let doc = viewModel.selectedDocument {
                VStack(spacing: 0) {
                    // Document header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                StatusBadge(status: doc.status)
                                Text(doc.documentNumber)
                                    .font(.caption.monospaced())
                                    .foregroundStyle(.secondary)
                            }
                            Text(doc.title)
                                .font(.title3.bold())
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))

                    Divider()

                    // Document body placeholder
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            if let notes = doc.notes, !notes.isEmpty {
                                Text(notes)
                                    .font(.body)
                                    .padding()
                            } else {
                                Text("Document content preview area")
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 60)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Divider()

                    // Bottom action bar
                    HStack(spacing: 12) {
                        Spacer()
                        Button {
                            // Approve
                        } label: {
                            Text("Погодити")
                                .padding(.horizontal, 12)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)

                        Button {
                            // Return
                        } label: {
                            Text("Повернути")
                                .padding(.horizontal, 12)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .padding()
                }
            } else {
                noSelectionPlaceholder
            }
        }
    }

    // MARK: - Tab: Discussion

    private var discussionTabContent: some View {
        Group {
            if let doc = viewModel.selectedDocument {
                VStack(spacing: 0) {
                    HStack {
                        Text("Discussion — \(doc.documentNumber)")
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))

                    Divider()

                    // Messages placeholder
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            discussionMessage(
                                author: doc.applicant ?? "System",
                                time: doc.createdAt.formatted(date: .abbreviated, time: .shortened),
                                text: "Document created and submitted for review."
                            )
                            discussionMessage(
                                author: "Reviewer",
                                time: doc.updatedAt.formatted(date: .abbreviated, time: .shortened),
                                text: "Reviewed. Pending approval."
                            )
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Divider()

                    // Input
                    HStack {
                        TextField("Add a comment...", text: .constant(""))
                            .textFieldStyle(.roundedBorder)
                        Button {
                            // Send
                        } label: {
                            Image(systemName: "paperplane.fill")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            } else {
                noSelectionPlaceholder
            }
        }
    }

    private func discussionMessage(author: String, time: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(author)
                    .font(.caption.bold())
                Spacer()
                Text(time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Text(text)
                .font(.callout)
        }
        .padding(10)
        .background(.quaternary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Tab: Related

    private var relatedTabContent: some View {
        Group {
            if let doc = viewModel.selectedDocument {
                VStack(spacing: 0) {
                    HStack {
                        Text("Related Documents — \(doc.documentNumber)")
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))

                    Divider()

                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            if doc.children.isEmpty && doc.parent == nil {
                                VStack(spacing: 12) {
                                    Image(systemName: "link")
                                        .font(.system(size: 40))
                                        .foregroundStyle(.tertiary)
                                    Text("No related documents")
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                            }

                            // Parent
                            if let parent = doc.parent {
                                Section {
                                    relatedRow(doc: parent, relation: "Parent")
                                } header: {
                                    Text("Parent Document")
                                        .font(.caption.bold())
                                        .foregroundStyle(.secondary)
                                        .padding(.top, 8)
                                }
                            }

                            // Children
                            if !doc.children.isEmpty {
                                Section {
                                    ForEach(doc.children) { child in
                                        relatedRow(doc: child, relation: "Child")
                                    }
                                } header: {
                                    Text("Child Documents (\(doc.children.count))")
                                        .font(.caption.bold())
                                        .foregroundStyle(.secondary)
                                        .padding(.top, 8)
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                noSelectionPlaceholder
            }
        }
    }

    private func relatedRow(doc: RMKDocument, relation: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "link")
                .foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text(doc.title)
                    .font(.callout.weight(.medium))
                    .lineLimit(1)
                Text(doc.documentNumber)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(relation)
                .font(.caption2)
                .foregroundStyle(.secondary)
            StatusBadge(status: doc.status)
        }
        .padding(8)
        .background(.quaternary)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .onTapGesture {
            viewModel.selectedDocument = doc
        }
    }

    // MARK: - Shared

    private var noSelectionPlaceholder: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text")
                .font(.system(size: 50))
                .foregroundStyle(.tertiary)
            Text("Select a document from the monitor")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
