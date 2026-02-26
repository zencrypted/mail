import SwiftUI

struct StatusBadge: View {
    let status: DocumentStatus

    private var color: Color {
        switch status {
        case .draft: .gray
        case .pending: .orange
        case .approved: .green
        case .archived: .blue
        }
    }

    var body: some View {
        Text(status.rawValue)
            .font(.caption2.bold())
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }
}
