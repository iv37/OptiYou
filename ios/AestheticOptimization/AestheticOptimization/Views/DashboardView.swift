import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                heroCard
                metricsGrid
                prioritiesSection
                modulesSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 28)
        }
        .background(Color.clear)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text("Aesthetic OS")
                        .font(.caption)
                        .foregroundStyle(AppTheme.muted)
                    Text("Steady progress")
                        .font(.headline.weight(.semibold))
                }
            }
        }
        .navigationDestination(item: $appModel.selectedModule) { module in
            AnalysisDetailView(module: module)
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            ChipView(text: "Current dashboard", tint: .white)
            Text("Your current priorities are consistency, calmer skin, and sharper structure.")
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
            Text("The current plan favors habits that improve presentation steadily: cleaner recovery, less routine friction, and better framing through grooming.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.72))
            HStack(spacing: 12) {
                Button("Upload new scan") {
                    appModel.selectedTab = .upload
                }
                .buttonStyle(PrimaryButtonStyle())

                Button("Open plan") {
                    appModel.selectedTab = .plan
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .foregroundStyle(AppTheme.foreground)
            .tint(.white)
        }
        .padding(22)
        .background(
            LinearGradient(colors: [Color.black.opacity(0.86), AppTheme.primary.opacity(0.92)], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
    }

    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            MetricTileView(title: "Estimated body fat", value: appModel.bodyFatSummary, detail: "Calculated from the current profile and used for calorie and macro guidance.")
            MetricTileView(title: "Sleep average", value: String(format: "%.1fh", appModel.profile.sleepHours), detail: "Recovery is the main appearance multiplier in the current plan.")
            MetricTileView(title: "Hydration", value: String(format: "%.1fL", appModel.profile.hydrationLiters), detail: "Raising consistency here should improve skin calmness and training recovery.")
            MetricTileView(title: "Exercise frequency", value: "\(appModel.profile.exerciseDays) days", detail: "Strong baseline. Nutrition precision is now more important than extra sessions.")
        }
    }

    private var prioritiesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(
                eyebrow: "Priority stack",
                title: "What to focus on next",
                detail: "Calculated targets, rule-based heuristics, and simulated AI summaries work together in a single flow."
            )

            ForEach(appModel.priorities) { item in
                VStack(alignment: .leading, spacing: 10) {
                    ChipView(text: item.module, tint: AppTheme.primary)
                    Text(item.title)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(AppTheme.foreground)
                    Text(item.detail)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.muted)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassCard()
            }
        }
    }

    private var modulesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(
                eyebrow: "Analysis modules",
                title: "Detailed breakdowns",
                detail: "Each module isolates the main opportunities so the dashboard stays focused while still giving you drill-down depth."
            )

            ForEach(appModel.modules) { module in
                Button {
                    appModel.selectedModule = module
                } label: {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            ChipView(text: module.priority.rawValue + " priority", tint: module.priority == .high ? AppTheme.danger : AppTheme.primary)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .foregroundStyle(AppTheme.muted)
                        }

                        Text(module.title)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(AppTheme.foreground)
                        Text(module.scoreLabel)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(AppTheme.foreground)
                        Text(module.summary)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)

                        ForEach(module.highlights, id: \.self) { highlight in
                            Text(highlight)
                                .font(.caption)
                                .foregroundStyle(AppTheme.muted)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassCard()
                }
                .buttonStyle(.plain)
            }
        }
    }
}
