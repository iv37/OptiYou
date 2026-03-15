import SwiftUI

struct RoadmapView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                SectionHeaderView(
                    eyebrow: "Improvement roadmap",
                    title: "A realistic plan built around habits that compound.",
                    detail: "The recommendation engine blends calculated targets, rule-based suggestions, and simulated AI summaries."
                )

                roadmapCard(title: "Top priorities", items: appModel.roadmap.topPriorities)
                roadmapCard(title: "Daily habits", items: appModel.roadmap.dailyHabits)
                roadmapCard(title: "Weekly habits", items: appModel.roadmap.weeklyHabits)

                routineCard(title: "Morning routine", steps: appModel.roadmap.morningRoutine)
                routineCard(title: "Night routine", steps: appModel.roadmap.nightRoutine)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Expected timeline")
                        .font(.headline)
                    ForEach(appModel.roadmap.timeline) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.label)
                                .font(.headline)
                            Text(item.expectation)
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.muted)
                        }
                        .padding(14)
                        .background(Color.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
                .padding(20)
                .glassCard()

                Text(appModel.roadmap.disclaimer)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
                    .padding(18)
                    .glassCard()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 28)
        }
        .navigationTitle("Plan")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func roadmapCard(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.muted)
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
        .padding(20)
        .glassCard()
    }

    private func routineCard(title: String, steps: [RoutineStep]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            ForEach(steps) { step in
                VStack(alignment: .leading, spacing: 6) {
                    Text(step.timing.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.muted)
                    Text(step.title)
                        .font(.headline)
                    Text(step.detail)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.muted)
                }
                .padding(14)
                .background(Color.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
        .padding(20)
        .glassCard()
    }
}
