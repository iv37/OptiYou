import Foundation
import SwiftUI

enum AuthState {
    case loading
    case unauthenticated
    case needsOnboarding
    case authenticated
}

@MainActor
final class AppModel: ObservableObject {
    @Published var authState: AuthState = .loading
    @Published var hasCompletedInitialAssessment = false
    @Published var selectedTab: AppTab = .dashboard
    @Published var selectedModule: AnalysisModule?
    @Published var showingPremium = false
    @Published var isAuthenticating = false
    @Published var authErrorMessage: String?
    @Published var isSavingProfile = false
    @Published var profileErrorMessage: String?
    @Published var currentAuthUser: AuthUser?
    @Published var currentSession: AuthSession?
    @Published var currentProfile: ProfileRecord?
    @Published var assessmentSeed: Int = 0

    let profile = MockDataService.profile
    private let scanTemplates = MockDataService.scans
    let progress = MockDataService.progressEntries
    let premiumFeatures = MockDataService.premiumFeatures

    var isUsingDevBypass: Bool {
        currentSession == nil && currentAuthUser?.id == "dev-bypass-user"
    }

    var scans: [ScanAsset] {
        guard hasCompletedInitialAssessment else {
            return scanTemplates.map { scan in
                ScanAsset(
                    id: scan.id,
                    title: scan.title,
                    subtitle: scan.subtitle,
                    imageName: scan.imageName,
                    status: "Needed"
                )
            }
        }

        return scanTemplates
    }

    var activePriorities: [PriorityItem] {
        guard let currentProfile else {
            return MockDataService.priorities
        }

        return hasCompletedInitialAssessment
            ? RecommendationEngine.priorities(for: currentProfile, hasAssessment: true)
            : RecommendationEngine.priorities(for: currentProfile, hasAssessment: false)
    }

    var activeModules: [AnalysisModule] {
        guard let currentProfile, hasCompletedInitialAssessment else {
            return []
        }

        return RecommendationEngine.modules(for: currentProfile, assessmentSeed: assessmentSeed)
    }

    var activeRoadmap: RecommendationRoadmap {
        guard let currentProfile else {
            return MockDataService.roadmap
        }

        return RecommendationEngine.roadmap(for: currentProfile)
    }

    func detailContent(for module: AnalysisModule) -> AnalysisDetailContent {
        guard let currentProfile else {
            return MockDataService.detail(for: module.slug)
        }

        return RecommendationEngine.detail(for: module.slug, profile: currentProfile, assessmentSeed: assessmentSeed)
    }

    var bodyFatSummary: String {
        guard let estimate = currentProfile?.bodyFatEstimate else {
            return "Pending"
        }

        return String(format: "%.1f%%", estimate)
    }

    var bodyFatDetail: String {
        guard let profile = currentProfile,
              let estimate = profile.bodyFatEstimate,
              let category = ProfileService.bodyFatCategory(gender: profile.gender, estimate: estimate)
        else {
            return "Complete the tape measurements in onboarding to calculate this estimate."
        }

        return "\(category) range"
    }

    var bodyFatTargetText: String {
        guard let currentProfile else { return "--" }
        return RecommendationEngine.bodyFatTargetText(for: currentProfile)
    }

    var sleepTargetText: String {
        guard let currentProfile else { return "--" }
        return String(format: "%.1f h", RecommendationEngine.dashboardSleepTarget(for: currentProfile))
    }

    var hydrationCurrentText: String {
        guard let liters = currentProfile?.hydrationLiters else { return "--" }
        return String(format: "%.0f oz", liters * 33.814)
    }

    var hydrationTargetText: String {
        guard let currentProfile else { return "--" }
        return String(format: "%.0f oz", RecommendationEngine.dashboardHydrationTargetOunces(for: currentProfile))
    }

    var exerciseTargetText: String {
        guard let currentProfile else { return "--" }
        return "\(RecommendationEngine.dashboardExerciseTargetDays(for: currentProfile)) days"
    }

    var proteinTarget: Int {
        let activeWeight = currentProfile?.weightKG ?? profile.weightKG
        let activeBodyFat = currentProfile?.bodyFatEstimate ?? profile.bodyFatEstimate
        return Int((activeWeight * (1 - activeBodyFat / 100)) * 2.2)
    }

    var maintenanceCalories: Int {
        Int((currentProfile?.weightKG ?? profile.weightKG) * 31)
    }

    var recompositionCalories: Int {
        maintenanceCalories - 150
    }

    var hydrationTarget: String {
        String(format: "%.1fL", max(2.7, profile.weightKG * 0.035))
    }

    var currentUserEmail: String {
        currentAuthUser?.email ?? currentProfile?.email ?? "Not signed in"
    }

    var effectiveSleepHours: Double {
        currentProfile?.sleepHours ?? profile.sleepHours
    }

    var effectiveHydrationLiters: Double {
        currentProfile?.hydrationLiters ?? profile.hydrationLiters
    }

    var effectiveExerciseDays: Int {
        currentProfile?.exerciseDays ?? profile.exerciseDays
    }

    var effectiveWeightKG: Double {
        currentProfile?.weightKG ?? profile.weightKG
    }

    var personalizedDashboardHeadline: String {
        guard let profile = currentProfile else {
            return "Finish your first intake to unlock your personalized dashboard."
        }

        if ProfileService.dietInsight(from: profile.dietNotes, dietQuality: profile.dietQuality) != nil,
           profile.bodyGoals.contains("Lower body fat") || profile.bodyGoals.contains("Leaner physique") {
            return "Your dashboard is starting with body composition and nutrition."
        }

        let goals = primaryGoalList(from: profile)
        if goals.isEmpty {
            return "Finish your first scan set to unlock your personalized dashboard."
        }

        return "Your dashboard is shaping around \(goals.prefix(2).joined(separator: " and "))."
    }

    var personalizedDashboardDetail: String {
        guard let profile = currentProfile else {
            return "We’ll wait to show scores, trends, and recommendations until the user has uploaded photos and completed their baseline profile."
        }

        let hydration = profile.hydrationLiters.map { String(format: "%.1fL", $0) } ?? "--"
        let sleep = profile.sleepHours.map { String(format: "%.1fh", $0) } ?? "--"
        if let nutritionSignal = ProfileService.dietInsight(from: profile.dietNotes, dietQuality: profile.dietQuality) {
            return "Based on the intake, we’ll prioritize routines around the user’s goals and current habits. Current baseline points include \(sleep) sleep, \(hydration) hydration, and a nutrition read: \(nutritionSignal)"
        }
        return "Next step: upload face scans for deeper recommendations. Current baseline points include \(sleep) sleep and \(hydration) hydration."
    }

    var onboardingPriorityCards: [PriorityItem] {
        guard let profile = currentProfile else {
            return MockDataService.priorities
        }

        return RecommendationEngine.priorities(for: profile, hasAssessment: false)
    }

    func enableDevBypass() {
        authErrorMessage = nil
        profileErrorMessage = nil
        currentSession = nil
        currentAuthUser = AuthUser(id: "dev-bypass-user", email: "dev@local.test")
        currentProfile = nil
        hasCompletedInitialAssessment = false
        assessmentSeed = 0
        selectedTab = .dashboard
        authState = .needsOnboarding
    }

    func restoreSessionIfNeeded() async {
        guard authState == .loading else { return }

        do {
            guard let session = try AuthService.shared.readStoredSession() else {
                authState = .unauthenticated
                return
            }

            currentSession = session
            let user = try await AuthService.shared.fetchCurrentUser(session: session)
            currentAuthUser = user
            try await loadProfile(session: session)
        } catch {
            AuthService.shared.clearStoredSession()
            currentSession = nil
            currentAuthUser = nil
            currentProfile = nil
            assessmentSeed = 0
            authState = .unauthenticated
            authErrorMessage = error.localizedDescription
        }
    }

    func authenticate(mode: AuthMode, email: String, password: String) async {
        isAuthenticating = true
        authErrorMessage = nil

        do {
            let session: AuthSession
            switch mode {
            case .login:
                session = try await AuthService.shared.login(email: email, password: password)
            case .signup:
                session = try await AuthService.shared.signUp(email: email, password: password)
            }

            try AuthService.shared.storeSession(session)
            currentSession = session
            currentAuthUser = session.user
            try await loadProfile(session: session)
        } catch {
            authErrorMessage = error.localizedDescription
            authState = .unauthenticated
        }

        isAuthenticating = false
    }

    func saveProfile(input: ProfileInput) async -> Bool {
        isSavingProfile = true
        profileErrorMessage = nil

        if let session = currentSession {
            do {
                let profile = try await ProfileService.shared.upsertProfile(input: input, session: session)
                currentProfile = profile
                assessmentSeed = 0
                authState = .authenticated
            } catch {
                profileErrorMessage = error.localizedDescription
                isSavingProfile = false
                return false
            }
        } else {
            currentProfile = ProfileRecord(
                id: nil,
                userID: currentAuthUser?.id ?? "dev-bypass-user",
                email: currentAuthUser?.email ?? "dev@local.test",
                age: Int(input.age),
                gender: input.gender,
                heightCM: ProfileService.heightCM(feetString: input.heightFeet, inchesString: input.heightInches),
                weightKG: ProfileService.weightKG(fromPoundsString: input.weightPounds),
                neckCM: ProfileService.lengthCM(feetString: input.neckFeet, inchesString: input.neckInches),
                waistCM: ProfileService.lengthCM(feetString: input.waistFeet, inchesString: input.waistInches),
                hipCM: input.gender == "Female" ? ProfileService.lengthCM(feetString: input.hipFeet, inchesString: input.hipInches) : nil,
                bodyFatEstimate: ProfileService.bodyFatEstimate(
                    gender: input.gender,
                    heightCM: ProfileService.heightCM(feetString: input.heightFeet, inchesString: input.heightInches),
                    neckCM: ProfileService.lengthCM(feetString: input.neckFeet, inchesString: input.neckInches),
                    waistCM: ProfileService.lengthCM(feetString: input.waistFeet, inchesString: input.waistInches),
                    hipCM: input.gender == "Female" ? ProfileService.lengthCM(feetString: input.hipFeet, inchesString: input.hipInches) : nil
                ),
                skinGoals: input.skinGoals,
                hairGoals: input.hairGoals,
                bodyGoals: input.bodyGoals,
                groomingGoals: input.groomingGoals,
                sleepHours: ProfileService.sleepHours(from: input.sleepHours),
                hydrationLiters: ProfileService.hydrationLiters(fromOuncesString: input.hydrationOunces),
                exerciseDays: Int(input.exerciseDays),
                dietQuality: input.dietQuality,
                dietNotes: ProfileService.normalizedDietNotes(input.dietNotes),
                calorieIntake: Int(input.calorieIntake),
                onboardingCompleted: true,
                createdAt: nil,
                updatedAt: nil
            )
            assessmentSeed = 0
            authState = .authenticated
        }

        isSavingProfile = false
        return true
    }

    func completeAssessment() {
        assessmentSeed = Int.random(in: 0...999)
        hasCompletedInitialAssessment = true
        selectedTab = .dashboard
    }

    func logout() async {
        if let session = currentSession {
            await AuthService.shared.logout(session: session)
        } else {
            AuthService.shared.clearStoredSession()
        }

        currentSession = nil
        currentAuthUser = nil
        currentProfile = nil
        hasCompletedInitialAssessment = false
        assessmentSeed = 0
        selectedTab = .dashboard
        authState = .unauthenticated
    }

    private func loadProfile(session: AuthSession) async throws {
        let profile = try await ProfileService.shared.fetchProfile(session: session)
        currentProfile = profile
        authState = (profile == nil || profile?.onboardingCompleted == false) ? .needsOnboarding : .authenticated
    }

    private func primaryGoalList(from profile: ProfileRecord) -> [String] {
        profile.skinGoals + profile.hairGoals + profile.bodyGoals + profile.groomingGoals
    }
}
