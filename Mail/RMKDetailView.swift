import SwiftUI

struct RMKDetailView: View {
    @Bindable var document: RMKDocument

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(document.title)
                            .font(.title.bold())
                        Text(document.documentNumber)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    StatusBadge(status: document.status)
                }

                Divider()

                // Details Grid
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                    ], alignment: .leading, spacing: 16
                ) {
                    detailItem(label: "Type", value: document.type.rawValue, icon: "doc.text")
                    detailItem(
                        label: "Status", value: document.status.rawValue, icon: "circle.fill")
                    detailItem(label: "Applicant", value: document.applicant ?? "—", icon: "person")
                    detailItem(
                        label: "Value",
                        value: document.value.map { String(format: "%.2f", $0) } ?? "—",
                        icon: "banknote")
                    detailItem(
                        label: "Created",
                        value: document.createdAt.formatted(date: .abbreviated, time: .shortened),
                        icon: "calendar")
                    detailItem(
                        label: "Updated",
                        value: document.updatedAt.formatted(date: .abbreviated, time: .shortened),
                        icon: "clock")
                    detailItem(
                        label: "Children", value: "\(document.children.count)", icon: "folder")
                    detailItem(
                        label: "Has More", value: document.hasUnloadedChildren ? "Yes" : "No",
                        icon: "ellipsis.circle")
                }

                if let notes = document.notes, !notes.isEmpty {
                    Divider()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                        Text(notes)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(document.title)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private func detailItem(label: String, value: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body.weight(.medium))
            }
        }
    }
}
