import SwiftUI

struct LazyTreeRow: View {
    @Bindable var document: RMKDocument
    @State private var isExpanded = false
    var viewModel: DashboardViewModel

    var body: some View {
        if document.children.isEmpty && !document.hasUnloadedChildren {
            // Leaf node — no disclosure triangle
            Button {
                viewModel.selectedDocument = document
            } label: {
                rowLabel
            }
            .buttonStyle(.plain)
            .contextMenu { contextMenuItems }
        } else {
            DisclosureGroup(isExpanded: $isExpanded) {
                if isExpanded {
                    if document.children.isEmpty && document.hasUnloadedChildren {
                        ProgressView()
                            .padding(.leading, 20)
                    } else {
                        ForEach(document.children.sorted(by: { $0.createdAt < $1.createdAt })) {
                            child in
                            LazyTreeRow(document: child, viewModel: viewModel)
                        }
                    }
                }
            } label: {
                Button {
                    viewModel.selectedDocument = document
                } label: {
                    rowLabel
                }
                .buttonStyle(.plain)
            }
            .contextMenu { contextMenuItems }
            .onChange(of: isExpanded) { _, newValue in
                if newValue && document.children.isEmpty && document.hasUnloadedChildren {
                    Task { await viewModel.loadChildren(of: document) }
                }
            }
        }
    }

    private var rowLabel: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(document.title)
                    .font(.body.weight(.medium))
                    .lineLimit(1)
                Text(document.documentNumber)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            StatusBadge(status: document.status)
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private var contextMenuItems: some View {
        Button {
            viewModel.selectedDocument = document
        } label: {
            Label("Open", systemImage: "doc.text")
        }

        Button {
            viewModel.addDocument(
                title: "New Child", applicant: nil, type: .internal, value: nil, parent: document)
        } label: {
            Label("Add Child", systemImage: "plus.circle")
        }

        Divider()

        Button {
            viewModel.archiveDocument(document)
        } label: {
            Label("Archive", systemImage: "archivebox")
        }

        Button(role: .destructive) {
            viewModel.deleteDocument(document)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}
