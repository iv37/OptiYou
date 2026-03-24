import SwiftUI

struct ProgressViewScreen: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                if appModel.hasCompletedInitialAssessment {
                    SectionHeaderView(
                        eyebrow: "Progress tracking",
                        title: "See what is improving over time.",
                        detail: "Clear labels and simple visuals keep trend tracking useful without making the screen feel busy."
                    )

                    ProgressChartCard(entries: appModel.progress)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Current trend")
                            .font(.headline)
                            .foregroundStyle(AppTheme.foreground)

                        TrendBarRow(label: "Skin clarity", value: appModel.progress.last?.skinClarity ?? 0, status: trendStatus(for: \.skinClarity))
                        TrendBarRow(label: "Grooming", value: appModel.progress.last?.groomingConsistency ?? 0, status: trendStatus(for: \.groomingConsistency))
                        TrendBarRow(label: "Body", value: appModel.progress.last?.bodyComposition ?? 0, status: trendStatus(for: \.bodyComposition))
                        TrendBarRow(label: "Hydration", value: appModel.progress.last?.hydration ?? 0, status: trendStatus(for: \.hydration))
                    }
                    .padding(20)
                    .glassCard()

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

                    EmptyStateCard(title: "Nothing to compare yet", detail: "Once the first evaluation is complete, this tab will show history, trend lines, and dated metric snapshots.")
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

private extension ProgressViewScreen {
    func trendStatus(for keyPath: KeyPath<ProgressEntry, Double>) -> String {
        guard let current = appModel.progress.last?[keyPath: keyPath] else { return "Stable" }
        guard appModel.progress.count > 1 else { return current >= 60 ? "Improving" : "Needs attention" }
        let previous = appModel.progress[appModel.progress.count - 2][keyPath: keyPath]
        let delta = current - previous
        if delta >= 3 { return "Improving" }
        if delta <= -3 { return "Needs attention" }
        return "Stable"
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
