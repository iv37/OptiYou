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

struct ActionItemRow: View {
    let index: Int
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(String(format: "%02d", index))
                .font(.caption2.weight(.bold))
                .foregroundStyle(AppTheme.primary)
                .frame(width: 34, height: 34)
                .background(AppTheme.primary.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.foreground)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.muted)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .insetSurface()
    }
}

struct ModuleSnapshotCard: View {
    let title: String
    let status: String
    let recommendations: [String]
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.foreground)
                Spacer()
                Text(status)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AppTheme.primary.opacity(0.12), in: Capsule())
            }

            VStack(alignment: .leading, spacing: 10) {
                ForEach(recommendations.prefix(2), id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .fill(AppTheme.primary)
                            .frame(width: 6, height: 6)
                            .padding(.top, 7)
                        Text(item)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                    }
                }
            }

            Button(buttonTitle, action: action)
                .buttonStyle(SecondaryButtonStyle())
        }
        .padding(18)
        .glassCard()
    }
}

struct RoutineListCard: View {
    let title: String
    let subtitle: String
    let steps: [RoutineStep]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.foreground)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.muted)
            }

            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.primary)
                        .frame(width: 26, height: 26)
                        .background(AppTheme.primary.opacity(0.12), in: RoundedRectangle(cornerRadius: 9, style: .continuous))

                    VStack(alignment: .leading, spacing: 5) {
                        Text(step.title)
                            .font(.headline)
                            .foregroundStyle(AppTheme.foreground)
                        Text(step.timing)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(AppTheme.primary)
                        Text(step.detail)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                    }
                }
                .padding(14)
                .insetSurface()
            }
        }
        .padding(18)
        .glassCard()
    }
}

struct TrendBarRow: View {
    let label: String
    let value: Double
    let status: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.foreground)
                Spacer()
                Text(status)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(statusTint)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppTheme.surfaceInset)
                    Capsule()
                        .fill(statusTint)
                        .frame(width: max(16, geometry.size.width * CGFloat(value / 100)))
                }
            }
            .frame(height: 8)
        }
    }

    private var statusTint: Color {
        switch status {
        case "Improving": return AppTheme.success
        case "Stable": return AppTheme.primary
        default: return AppTheme.danger
        }
    }
}

struct EmptyStateCard: View {
    let title: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.foreground)
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(AppTheme.muted)
        }
        .padding(18)
        .glassCard()
    }
}

struct LoadingStateCard: View {
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ProgressView()
                .tint(AppTheme.primary)
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.foreground)
        }
        .padding(18)
        .glassCard()
    }
}

struct ErrorStateCard: View {
    let title: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.foreground)
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(AppTheme.muted)
        }
        .padding(18)
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(AppTheme.danger.opacity(0.65), lineWidth: 1)
        )
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
