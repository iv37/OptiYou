import SwiftUI

struct SectionHeaderView: View {
    let eyebrow: String
    let title: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(eyebrow.uppercased())
                .font(.caption2.weight(.bold))
                .tracking(1.8)
                .foregroundStyle(AppTheme.primary)
            Text(title)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.foreground)
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(AppTheme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MetricTileView: View {
    let title: String
    let current: String
    let target: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.foreground)
                .lineLimit(1)
            Text(current)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .foregroundStyle(title == "Body fat" ? AppTheme.primary : AppTheme.foreground)
                .lineLimit(1)
                .minimumScaleFactor(0.78)
            HStack(alignment: .center, spacing: 6) {
                Text("Target:")
                    .font(.caption2.weight(.bold))
                    .tracking(0.8)
                    .foregroundStyle(AppTheme.muted)
                Text(target)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.foreground)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
            }
            Text(detail)
                .font(.caption)
                .foregroundStyle(AppTheme.muted)
                .lineLimit(1)
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 134, alignment: .topLeading)
        .glassCard()
    }
}

struct ChipView: View {
    let text: String
    let tint: Color

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(tint.opacity(0.12), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(tint.opacity(0.4), lineWidth: 1)
            )
            .foregroundStyle(tint)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [
                        AppTheme.primaryHover.opacity(configuration.isPressed ? 0.92 : 1),
                        AppTheme.primary.opacity(configuration.isPressed ? 0.88 : 1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(AppTheme.primaryHover.opacity(0.45), lineWidth: 1)
            )
            .shadow(color: AppTheme.primary.opacity(0.16), radius: 10, y: 6)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(AppTheme.foreground)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppTheme.surfaceStrong.opacity(configuration.isPressed ? 0.95 : 1), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}
