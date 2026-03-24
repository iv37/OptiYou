import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                heroCard

                if appModel.authState == .loading {
                    LoadingStateCard(title: "Loading your dashboard")
                } else if let error = appModel.profileErrorMessage, appModel.currentProfile == nil {
                    ErrorStateCard(title: "Dashboard unavailable", detail: error)
                } else if appModel.hasCompletedInitialAssessment {
                    prioritiesSection
                    domainCardsSection
                    progressSection
                    updatesSection
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
                    Text("Personal dashboard")
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
            ChipView(text: appModel.hasCompletedInitialAssessment ? "Personalized dashboard" : "Before first evaluation", tint: .white)

            Text(appModel.hasCompletedInitialAssessment ? "Based on your inputs, your top priority right now is consistency." : appModel.personalizedDashboardHeadline)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)

            Text(appModel.hasCompletedInitialAssessment ? "Your dashboard is organized around what to do next, where progress is moving, and which routines deserve the most focus." : appModel.personalizedDashboardDetail)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.74))

            HStack(spacing: 12) {
                Button(appModel.hasCompletedInitialAssessment ? "Upload scans" : "Start evaluation") {
                    appModel.selectedTab = .upload
                }
                .buttonStyle(PrimaryButtonStyle())

                if appModel.hasCompletedInitialAssessment {
                    Button("View routines") {
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
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.surfaceStrong, AppTheme.background],
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
                        .fill(AppTheme.primary.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .blur(radius: 24)
                        .offset(x: 26, y: -22)
                }
        )
    }

    private var prioritiesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(
                eyebrow: "Your priorities today",
                title: "What to do next",
                detail: "A short action list built from your profile, current routine, and latest evaluation."
            )

            ForEach(Array(appModel.activePriorities.prefix(4).enumerated()), id: \.element.id) { index, item in
                ActionItemRow(index: index + 1, title: item.title, detail: item.detail)
            }
        }
    }

    private var domainCardsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(
                eyebrow: "Latest analysis",
                title: "Skin, body, and hair",
                detail: "Each area shows a quick status, the most useful recommendations, and a path to more detail."
            )

            ModuleSnapshotCard(
                title: "Skin",
                status: moduleStatus(for: "skin"),
                recommendations: moduleRecommendations(for: "skin"),
                buttonTitle: "View skin details"
            ) {
                openModule(slug: "skin")
            }

            ModuleSnapshotCard(
                title: "Body",
                status: moduleStatus(for: "body"),
                recommendations: moduleRecommendations(for: "body"),
                buttonTitle: "View body details"
            ) {
                openModule(slug: "body")
            }

            ModuleSnapshotCard(
                title: "Hair",
                status: moduleStatus(for: "hair"),
                recommendations: moduleRecommendations(for: "hair"),
                buttonTitle: "View hair details"
            ) {
                openModule(slug: "hair")
            }
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(
                eyebrow: "Progress summary",
                title: "How things are moving",
                detail: "Simple trend signals help you see where momentum is building and where the plan still needs attention."
            )

            VStack(alignment: .leading, spacing: 14) {
                TrendBarRow(label: "Skin clarity", value: latestProgress?.skinClarity ?? 0, status: trendStatus(current: latestProgress?.skinClarity, previous: previousProgress?.skinClarity))
                TrendBarRow(label: "Grooming", value: latestProgress?.groomingConsistency ?? 0, status: trendStatus(current: latestProgress?.groomingConsistency, previous: previousProgress?.groomingConsistency))
                TrendBarRow(label: "Body", value: latestProgress?.bodyComposition ?? 0, status: trendStatus(current: latestProgress?.bodyComposition, previous: previousProgress?.bodyComposition))
            }
            .padding(18)
            .glassCard()
        }
    }

    private var updatesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(
                eyebrow: "Recent updates",
                title: "What changed recently",
                detail: "A lightweight snapshot of the latest routine changes and progress movement."
            )

            VStack(alignment: .leading, spacing: 12) {
                updateRow(title: "Progress trend", detail: latestProgressLine)
                updateRow(title: "AM routine", detail: appModel.activeRoadmap.morningRoutine.first?.title ?? "Routine will appear after evaluation")
                updateRow(title: "PM routine", detail: appModel.activeRoadmap.nightRoutine.first?.title ?? "Routine will appear after evaluation")
            }
            .padding(18)
            .glassCard()
        }
    }

    private var preAssessmentState: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(
                eyebrow: "Getting started",
                title: "Complete your first intake",
                detail: "The dashboard gets more useful after you add scans. For now, we keep it focused on what to do next."
            )

            EmptyStateCard(
                title: "No analysis yet",
                detail: "Finish the first evaluation to unlock personalized skin, body, and hair cards, progress trends, and recent updates."
            )

            VStack(alignment: .leading, spacing: 12) {
                ActionItemRow(index: 1, title: "Complete profile", detail: "Add your baseline stats, goals, and routine inputs so the app can personalize guidance.")
                ActionItemRow(index: 2, title: "Upload scans", detail: "Front face, side profile, skin close-up, and hairline photos unlock the full dashboard.")
                ActionItemRow(index: 3, title: "Review your plan", detail: "After the first evaluation, your routines and progress sections will become actionable.")
            }

            if appModel.isUsingDevBypass {
                Button("Dev: generate scan results") {
                    appModel.completeAssessment()
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
    }

    private var latestProgress: ProgressEntry? {
        appModel.progress.last
    }

    private var previousProgress: ProgressEntry? {
        guard appModel.progress.count > 1 else { return nil }
        return appModel.progress[appModel.progress.count - 2]
    }

    private var latestProgressLine: String {
        guard let latestProgress else { return "No updates yet" }
        return "Skin \(Int(latestProgress.skinClarity))/100, grooming \(Int(latestProgress.groomingConsistency))/100, body \(Int(latestProgress.bodyComposition))/100."
    }

    private func moduleStatus(for slug: String) -> String {
        guard let module = appModel.activeModules.first(where: { $0.slug == slug }) else {
            return "Pending"
        }
        return module.scoreLabel
    }

    private func moduleRecommendations(for slug: String) -> [String] {
        guard let module = appModel.activeModules.first(where: { $0.slug == slug }) else {
            return ["Complete your first evaluation to unlock this section."]
        }
        return Array(module.highlights.prefix(2))
    }

    private func openModule(slug: String) {
        appModel.selectedModule = appModel.activeModules.first(where: { $0.slug == slug })
    }

    private func trendStatus(current: Double?, previous: Double?) -> String {
        guard let current else { return "Stable" }
        guard let previous else { return current >= 60 ? "Improving" : "Needs attention" }
        let delta = current - previous
        if delta >= 3 { return "Improving" }
        if delta <= -3 { return "Needs attention" }
        return "Stable"
    }

    private func updateRow(title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.muted)
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(AppTheme.foreground)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .insetSurface()
    }
}
