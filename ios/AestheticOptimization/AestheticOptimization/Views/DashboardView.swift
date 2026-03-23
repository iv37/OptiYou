import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                heroCard
                if appModel.hasCompletedInitialAssessment {
                    metricsSection
                    metricsGrid
                    prioritiesSection
                    modulesSection
                } else {
                    preAssessmentState
                }
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
                    Text("OptiYou")
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
            ChipView(text: appModel.hasCompletedInitialAssessment ? "Current dashboard" : "Before first evaluation", tint: .white)
            Text(appModel.hasCompletedInitialAssessment ? "Your current priorities are consistency, calmer skin, and sharper structure." : appModel.personalizedDashboardHeadline)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
            Text(appModel.hasCompletedInitialAssessment ? "The current plan favors habits that improve presentation steadily: cleaner recovery, less routine friction, and better framing through grooming." : appModel.personalizedDashboardDetail)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.72))
            HStack(spacing: 12) {
                Button(appModel.hasCompletedInitialAssessment ? "Upload new scan" : "Start first assessment") {
                    appModel.selectedTab = .upload
                }
                .buttonStyle(PrimaryButtonStyle())

                if appModel.hasCompletedInitialAssessment {
                    Button("Open plan") {
                        appModel.selectedTab = .plan
                    }
                    .buttonStyle(SecondaryButtonStyle())
                } else if appModel.isUsingDevBypass {
                    Button("Dev results") {
                        appModel.completeAssessment()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
            }
            .foregroundStyle(AppTheme.foreground)
            .tint(.white)
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            AppTheme.surfaceStrong,
                            AppTheme.background
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                )
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(AppTheme.primary.opacity(0.18))
                        .frame(width: 120, height: 120)
                        .blur(radius: 20)
                        .offset(x: 28, y: -22)
                }
        )
    }

    private var metricsSection: some View {
        SectionHeaderView(
            eyebrow: "Baseline",
            title: "Current baseline and plan targets",
            detail: "Each card shows what the user reported or calculated today, then the target the current plan is built around."
        )
    }

    private var preAssessmentState: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(
                eyebrow: "Getting started",
                title: "No stats yet",
                detail: "The app stays intentionally blank on scores until the first photo set is completed, but the experience is already being shaped by onboarding."
            )

            VStack(alignment: .leading, spacing: 12) {
                emptyStep(number: "01", title: "Complete baseline profile", detail: "Age, height, weight, goals, skin profile, hair profile, and lifestyle habits.")
                emptyStep(number: "02", title: "Upload face scans next", detail: "Front face, side face, skin close-up, and hairline photos under consistent lighting.")
                emptyStep(number: "03", title: "Unlock deeper recommendations", detail: "That is when we reveal tailored modules, roadmap items, and progress history.")
            }
            .padding(20)
            .glassCard()

            if appModel.isUsingDevBypass {
                Button("Dev: generate scan results") {
                    appModel.completeAssessment()
                }
                .buttonStyle(SecondaryButtonStyle())
            }

            if !appModel.activePriorities.isEmpty {
                prioritiesSection
            }
        }
    }

    private func emptyStep(number: String, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.primary)
                .frame(width: 34, height: 34)
                .background(AppTheme.accent.opacity(0.16), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.foreground)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.muted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .insetSurface()
    }

    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            MetricTileView(title: "Body fat", current: appModel.bodyFatSummary, target: appModel.bodyFatTargetText, detail: appModel.bodyFatDetail)
            MetricTileView(title: "Sleep", current: String(format: "%.1f h", appModel.effectiveSleepHours), target: appModel.sleepTargetText, detail: "Nightly baseline")
            MetricTileView(title: "Water", current: appModel.hydrationCurrentText, target: appModel.hydrationTargetText, detail: "Daily baseline")
            MetricTileView(title: "Training", current: "\(appModel.effectiveExerciseDays) days", target: appModel.exerciseTargetText, detail: "Weekly baseline")
        }
    }

    private var prioritiesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(
                eyebrow: "Priority stack",
                title: "What to focus on next",
                detail: "Calculated targets, rule-based heuristics, and simulated AI summaries work together in a single flow."
            )

            ForEach(appModel.activePriorities) { item in
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

            ForEach(appModel.activeModules) { module in
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
                                .insetSurface()
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
