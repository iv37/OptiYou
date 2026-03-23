import SwiftUI

struct RoadmapView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                if appModel.hasCompletedInitialAssessment {
                    SectionHeaderView(
                        eyebrow: "Improvement roadmap",
                        title: "A realistic plan built around habits that compound.",
                        detail: "The recommendation engine blends calculated targets, rule-based suggestions, and simulated AI summaries."
                    )

                    roadmapCard(title: "Top priorities", items: appModel.activeRoadmap.topPriorities)
                    roadmapCard(title: "Daily habits", items: appModel.activeRoadmap.dailyHabits)
                    roadmapCard(title: "Weekly habits", items: appModel.activeRoadmap.weeklyHabits)

                    routineCard(title: "Morning routine", steps: appModel.activeRoadmap.morningRoutine)
                    routineCard(title: "Night routine", steps: appModel.activeRoadmap.nightRoutine)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Expected timeline")
                            .font(.headline)
                        ForEach(appModel.activeRoadmap.timeline) { item in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.label)
                                    .font(.headline)
                                Text(item.expectation)
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.muted)
                            }
                            .padding(14)
                            .insetSurface()
                        }
                    }
                    .padding(20)
                    .glassCard()

                    Text(appModel.activeRoadmap.disclaimer)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.muted)
                        .padding(18)
                        .glassCard()
                } else {
                    SectionHeaderView(
                        eyebrow: "Improvement roadmap",
                        title: "Recommendations appear after intake.",
                        detail: "We hold back the plan until there is enough real user input to make it feel earned and relevant."
                    )

                    VStack(alignment: .leading, spacing: 12) {
                        Text("No roadmap yet")
                            .font(.headline)
                            .foregroundStyle(AppTheme.foreground)
                        Text("After the first photo set and profile baseline are complete, this tab will generate top priorities, daily habits, routines, and progress expectations.")
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
                    .insetSurface()
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
                        .foregroundStyle(AppTheme.primary)
                    Text(step.title)
                        .font(.headline)
                    Text(step.detail)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.muted)
                }
                .padding(14)
                .insetSurface()
            }
        }
        .padding(20)
        .glassCard()
    }
}
