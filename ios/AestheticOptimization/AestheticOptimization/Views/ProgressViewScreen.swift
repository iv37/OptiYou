import SwiftUI

struct ProgressViewScreen: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                if appModel.hasCompletedInitialAssessment {
                    SectionHeaderView(
                        eyebrow: "Progress tracking",
                        title: "Your trendline is moving in the right direction.",
                        detail: "Progress is saved as dated snapshots so you can compare routines, analysis outcomes, and key metrics over time."
                    )

                    ProgressChartCard(entries: appModel.progress)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Saved history")
                            .font(.headline)
                        ForEach(appModel.progress) { entry in
                            VStack(alignment: .leading, spacing: 12) {
                                Text(entry.dateLabel)
                                    .font(.headline)
                                HStack {
                                    ProgressPill(label: "Skin", value: entry.skinClarity)
                                    ProgressPill(label: "Grooming", value: entry.groomingConsistency)
                                }
                                HStack {
                                    ProgressPill(label: "Body", value: entry.bodyComposition)
                                    ProgressPill(label: "Hydration", value: entry.hydration)
                                }
                            }
                            .padding(16)
                            .glassCard()
                        }
                    }
                } else {
                    SectionHeaderView(
                        eyebrow: "Progress tracking",
                        title: "Progress unlocks after the first evaluation.",
                        detail: "We need one complete scan set and profile baseline before it makes sense to graph anything."
                    )

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Nothing to compare yet")
                            .font(.headline)
                            .foregroundStyle(AppTheme.foreground)
                        Text("Once the first evaluation is complete, this tab will show saved history, trend lines, and dated metric snapshots instead of empty placeholders.")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                    }
                    .padding(20)
                    .glassCard()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 28)
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ProgressPill: View {
    let label: String
    let value: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(AppTheme.muted)
            Text("\(Int(value))/100")
                .font(.headline)
                .foregroundStyle(AppTheme.foreground)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .insetSurface()
    }
}

private struct ProgressChartCard: View {
    let entries: [ProgressEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trend overview")
                .font(.headline)
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let maxValue = 100.0

                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(AppTheme.surfaceInset)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(AppTheme.border, lineWidth: 1)
                        )

                    Path { path in
                        for (index, entry) in entries.enumerated() {
                            let x = width * CGFloat(index) / CGFloat(max(entries.count - 1, 1))
                            let y = height - CGFloat(entry.skinClarity / maxValue) * height
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(AppTheme.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))

                    Path { path in
                        for (index, entry) in entries.enumerated() {
                            let x = width * CGFloat(index) / CGFloat(max(entries.count - 1, 1))
                            let y = height - CGFloat(entry.groomingConsistency / maxValue) * height
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(AppTheme.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                }
            }
            .frame(height: 220)

            HStack {
                Label("Skin clarity", systemImage: "circle.fill")
                    .foregroundStyle(AppTheme.primary)
                Spacer()
                Label("Grooming consistency", systemImage: "circle.fill")
                    .foregroundStyle(AppTheme.accent)
            }
            .font(.caption)
        }
        .padding(20)
        .glassCard()
    }
}
