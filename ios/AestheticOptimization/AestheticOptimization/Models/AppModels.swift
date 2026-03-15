import Foundation
import SwiftUI

enum PlanTier: String, CaseIterable, Identifiable {
    case free = "Free"
    case premium = "Premium"

    var id: String { rawValue }
}

enum AnalysisConfidence: String {
    case calculated = "Calculated"
    case ruleBased = "Rule-based"
    case simulatedAI = "Simulated AI"
}

enum AnalysisPriority: String {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

enum AppTab: String, CaseIterable, Identifiable {
    case dashboard
    case upload
    case progress
    case plan
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dashboard: "Dashboard"
        case .upload: "Scan"
        case .progress: "Progress"
        case .plan: "Plan"
        case .settings: "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .dashboard: "square.grid.2x2.fill"
        case .upload: "camera.aperture"
        case .progress: "chart.line.uptrend.xyaxis"
        case .plan: "sparkles"
        case .settings: "slider.horizontal.3"
        }
    }
}

struct UserProfile: Identifiable {
    let id: String
    let fullName: String
    let age: Int
    let gender: String
    let heightCM: Int
    let weightKG: Double
    let bodyFatEstimate: Double
    let plan: PlanTier
    let goals: [String]
    let skinType: String
    let skinConcerns: [String]
    let hairThickness: String
    let hairLength: String
    let hairConcerns: [String]
    let sleepHours: Double
    let hydrationLiters: Double
    let exerciseDays: Int
    let dietQuality: String
    let calorieIntake: Int
}

struct PriorityItem: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let module: String
}

struct ScanAsset: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let imageName: String
    let status: String
}

struct AnalysisModule: Identifiable, Hashable {
    let id: String
    let slug: String
    let title: String
    let scoreLabel: String
    let priority: AnalysisPriority
    let summary: String
    let highlights: [String]
    let confidence: AnalysisConfidence
}

struct RoutineStep: Identifiable {
    let id = UUID()
    let timing: String
    let title: String
    let detail: String
}

struct TimelineItem: Identifiable {
    let id = UUID()
    let label: String
    let expectation: String
}

struct RecommendationRoadmap {
    let topPriorities: [String]
    let dailyHabits: [String]
    let weeklyHabits: [String]
    let morningRoutine: [RoutineStep]
    let nightRoutine: [RoutineStep]
    let timeline: [TimelineItem]
    let disclaimer: String
}

struct ProgressEntry: Identifiable {
    let id = UUID()
    let dateLabel: String
    let skinClarity: Double
    let groomingConsistency: Double
    let bodyComposition: Double
    let hydration: Double
}

struct PremiumFeature: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
}

struct AnalysisDetailContent {
    let headline: String
    let explanation: String
    let observations: [String]
    let routines: [RoutineStep]
    let locked: Bool
}
