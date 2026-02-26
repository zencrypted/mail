import SwiftUI

struct KPICard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: Double?  // positive = up arrow, negative = down arrow

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.9))
                Spacer()
                if let trend {
                    HStack(spacing: 2) {
                        Image(systemName: trend >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.caption2.bold())
                        Text(String(format: "%.1f%%", abs(trend)))
                            .font(.caption2.bold())
                    }
                    .foregroundStyle(.white.opacity(0.75))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(.white.opacity(0.2))
                    .clipShape(Capsule())
                }
            }

            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(color.gradient)
        )
        .shadow(color: color.opacity(0.3), radius: 8, y: 4)
    }
}
