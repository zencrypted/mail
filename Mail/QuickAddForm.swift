import SwiftUI

struct QuickAddForm: View {
    var viewModel: DashboardViewModel

    @State private var title: String = ""
    @State private var applicant: String = ""
    @State private var type: DocumentType = .incoming
    @State private var amount: String = ""

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("New RMK Card")
                    .font(.headline)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Title").font(.caption).foregroundStyle(.secondary)
                    TextField("Document title", text: $title)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Applicant").font(.caption).foregroundStyle(.secondary)
                    TextField("Applicant name", text: $applicant)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Type").font(.caption).foregroundStyle(.secondary)
                    Picker("", selection: $type) {
                        ForEach(DocumentType.allCases) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    .labelsHidden()
                    #if os(macOS)
                        .pickerStyle(.menu)
                    #endif
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Amount").font(.caption).foregroundStyle(.secondary)
                    TextField("0.00", text: $amount)
                        .textFieldStyle(.roundedBorder)
                        #if os(iOS)
                            .keyboardType(.decimalPad)
                        #endif
                }

                Button {
                    let value = Double(amount)
                    viewModel.addDocument(
                        title: title.isEmpty ? "Untitled" : title,
                        applicant: applicant.isEmpty ? nil : applicant,
                        type: type,
                        value: value
                    )
                    // Reset
                    title = ""
                    applicant = ""
                    type = .incoming
                    amount = ""
                    dismiss()
                } label: {
                    Label("Create", systemImage: "plus.circle.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(title.isEmpty)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(radius: 8)
        .padding()
    }
}
