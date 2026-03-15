import Foundation
import SwiftUI

final class AppModel: ObservableObject {
    @Published var hasCompletedOnboarding = false
    @Published var selectedTab: AppTab = .dashboard
    @Published var selectedModule: AnalysisModule?
    @Published var showingPremium = false

    let profile = MockDataService.profile
    let priorities = MockDataService.priorities
    let scans = MockDataService.scans
    let modules = MockDataService.modules
    let roadmap = MockDataService.roadmap
    let progress = MockDataService.progressEntries
    let premiumFeatures = MockDataService.premiumFeatures

    func detailContent(for module: AnalysisModule) -> AnalysisDetailContent {
        MockDataService.detail(for: module.slug)
    }

    var bodyFatSummary: String {
        "\(Int(profile.bodyFatEstimate))%"
    }

    var proteinTarget: Int {
        Int((profile.weightKG * (1 - profile.bodyFatEstimate / 100)) * 2.2)
    }

    var maintenanceCalories: Int {
        Int(profile.weightKG * 31)
    }

    var recompositionCalories: Int {
        maintenanceCalories - 150
    }

    var hydrationTarget: String {
        String(format: "%.1fL", max(2.7, profile.weightKG * 0.035))
    }
}
