import SwiftUI

struct RoadmapView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                if appModel.hasCompletedInitialAssessment {
                    SectionHeaderView(
                        eyebrow: "Improvement roadmap",
                        title: "A calm plan built around what matters most.",
                        detail: "Based on your inputs, the roadmap keeps routines structured, practical, and easy to follow."
                    )

                    roadmapCard(title: "Top priorities", items: appModel.activeRoadmap.topPriorities)
                    roadmapCard(title: "Daily habits", items: appModel.activeRoadmap.dailyHabits)
                    roadmapCard(title: "Weekly habits", items: appModel.activeRoadmap.weeklyHabits)

                    RoutineListCard(title: "AM routine", subtitle: "A simple morning setup that supports skin, energy, and consistency.", steps: appModel.activeRoadmap.morningRoutine)
                    RoutineListCard(title: "PM routine", subtitle: "A quiet evening sequence designed to protect recovery and keep routines minimal.", steps: appModel.activeRoadmap.nightRoutine)

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

                    EmptyStateCard(title: "No roadmap yet", detail: "After the first photo set and profile baseline are complete, this tab will generate top priorities, routines, and progress expectations.")
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

}
