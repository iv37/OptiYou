import Foundation

enum RecommendationEngine {
    static func dashboardSleepTarget(for profile: ProfileRecord) -> Double {
        sleepTargetHours(for: profile)
    }

    static func dashboardHydrationTargetOunces(for profile: ProfileRecord) -> Double {
        hydrationTargetOunces(for: profile)
    }

    static func dashboardExerciseTargetDays(for profile: ProfileRecord) -> Int {
        trainingTargetDays(for: profile)
    }

    static func bodyFatTargetText(for profile: ProfileRecord) -> String {
        if shouldFavorBodyFatReduction(for: profile) {
            return "Lower slowly"
        }

        switch bodyGoalMode(for: profile) {
        case .gain:
            return "Hold steady"
        case .recomp:
            return "Improve slowly"
        case .cut:
            return "Lower slowly"
        case .maintenance:
            return "Hold steady"
        }
    }

    static func priorities(for profile: ProfileRecord, hasAssessment: Bool) -> [PriorityItem] {
        var items: [PriorityItem] = []

        if let sleepGap = sleepGap(for: profile), sleepGap > 0.4 {
            items.append(
                PriorityItem(
                    title: "Raise sleep consistency first",
                    detail: "Current sleep is \(hoursString(profile.sleepHours)) against a target of \(hoursString(sleepTargetHours(for: profile))). Better recovery should support skin calmness, training quality, and how fresh the face reads.",
                    module: "Lifestyle"
                )
            )
        }

        if let hydrationGap = hydrationGap(for: profile), hydrationGap > 12 {
            items.append(
                PriorityItem(
                    title: "Bring hydration closer to target",
                    detail: "Current intake is about \(ouncesString(from: profile.hydrationLiters)) against a target near \(Int(round(hydrationTargetOunces(for: profile)))) oz. That is an easy baseline lever for recovery and skin presentation.",
                    module: "Lifestyle"
                )
            )
        }

        if let nutritionInsight = ProfileService.dietInsight(from: profile.dietNotes, dietQuality: profile.dietQuality) {
            items.append(
                PriorityItem(
                    title: "Tighten food quality before overcomplicating the plan",
                    detail: nutritionInsight,
                    module: "Lifestyle"
                )
            )
        }

        if profile.skinGoals.contains("Clearer skin") || profile.skinGoals.contains("Reduce redness") || profile.skinGoals.contains("Calmer acne-prone skin") {
            items.append(
                PriorityItem(
                    title: hasAssessment ? "Keep the skincare plan barrier-first" : "Skincare will be one of the first scan priorities",
                    detail: hasAssessment ? "The current goal mix favors a simple cleanser, moisturizer, SPF, and slow active introduction instead of stacking harsher products." : "The selected skin goals point toward calmer barrier work and a simple routine rather than aggressive product layering.",
                    module: "Skincare"
                )
            )
        }

        if profile.hairGoals.contains("Hair loss prevention") || profile.hairGoals.contains("Better density presentation") {
            items.append(
                PriorityItem(
                    title: hasAssessment ? "Use haircut and scalp habits to improve density presentation" : "Hairline and density should be reviewed in the first scan set",
                    detail: hasAssessment ? "The current hair goals suggest presentation matters most right now: scalp comfort, clean texture, and cuts that avoid exposing the corners too harshly." : "The hair goals indicate that temple framing, density presentation, and scalp condition should be part of the first photo review.",
                    module: "Hair"
                )
            )
        }

        if bodyGoalMode(for: profile) == .cut {
            items.append(
                PriorityItem(
                    title: "Use a moderate calorie deficit, not a crash cut",
                    detail: "The body goal mix and current estimate point toward a steady cut of roughly 10 to 15% below maintenance while keeping protein high enough to protect lean mass.",
                    module: "Body"
                )
            )
        } else if bodyGoalMode(for: profile) == .gain {
            items.append(
                PriorityItem(
                    title: "Favor strength progression over scale chasing",
                    detail: "The current inputs support a small surplus or maintenance intake with consistent lifting rather than a large bulk.",
                    module: "Body"
                )
            )
        }

        return Array(items.prefix(4))
    }

    static func modules(for profile: ProfileRecord, assessmentSeed: Int) -> [AnalysisModule] {
        let skinPriority: AnalysisPriority = profile.skinGoals.isEmpty ? .medium : .high
        let hairPriority: AnalysisPriority = (profile.hairGoals.contains("Hair loss prevention") || profile.hairGoals.contains("Better density presentation")) ? .high : .medium
        let lifestylePriority: AnalysisPriority = (sleepGap(for: profile) ?? 0) > 0.4 || (hydrationGap(for: profile) ?? 0) > 12 ? .high : .medium
        let bodyPriority: AnalysisPriority = bodyGoalMode(for: profile) == .maintenance ? .medium : .high

        return [
            AnalysisModule(
                id: "facial",
                slug: "facial",
                title: "Facial balance",
                scoreLabel: facialLabel(for: profile, seed: assessmentSeed),
                priority: lifestylePriority,
                summary: facialSummary(for: profile),
                highlights: facialHighlights(for: profile, seed: assessmentSeed),
                confidence: .simulatedAI
            ),
            AnalysisModule(
                id: "skin",
                slug: "skin",
                title: "Skincare",
                scoreLabel: skinLabel(for: profile),
                priority: skinPriority,
                summary: skinSummary(for: profile),
                highlights: skinHighlights(for: profile),
                confidence: .ruleBased
            ),
            AnalysisModule(
                id: "hair",
                slug: "hair",
                title: "Hairline and density",
                scoreLabel: hairLabel(for: profile, seed: assessmentSeed),
                priority: hairPriority,
                summary: hairSummary(for: profile),
                highlights: hairHighlights(for: profile),
                confidence: .simulatedAI
            ),
            AnalysisModule(
                id: "body",
                slug: "body",
                title: "Body composition",
                scoreLabel: bodyLabel(for: profile),
                priority: bodyPriority,
                summary: bodySummary(for: profile),
                highlights: bodyHighlights(for: profile),
                confidence: .calculated
            ),
            AnalysisModule(
                id: "lifestyle",
                slug: "lifestyle",
                title: "Lifestyle",
                scoreLabel: lifestyleLabel(for: profile),
                priority: lifestylePriority,
                summary: lifestyleSummary(for: profile),
                highlights: lifestyleHighlights(for: profile),
                confidence: .ruleBased
            )
        ]
    }

    static func roadmap(for profile: ProfileRecord) -> RecommendationRoadmap {
        let metrics = bodyMetrics(for: profile)
        let sleepTarget = sleepTargetHours(for: profile)
        let hydrationTarget = hydrationTargetOunces(for: profile)
        let trainingTarget = trainingTargetDays(for: profile)
        let calorieLine = calorieGuidanceLine(for: metrics)
        let proteinLine = "Aim for about \(metrics.proteinGrams) g protein daily to support the current body goal."

        let dailyHabits = [
            "Hit at least \(hoursString(sleepTarget)) sleep on most nights.",
            "Front-load hydration and aim for roughly \(Int(round(hydrationTarget))) oz across the day.",
            proteinLine,
            skincareHabit(for: profile)
        ]

        let weeklyHabits = [
            "Train at least \(trainingTarget) days this week with 2 or more resistance-focused sessions.",
            bodyGoalMode(for: profile) == .cut ? "Keep the calorie deficit moderate and review weekly trend changes, not day-to-day scale swings." : "Keep calories steady enough that training performance does not slide backward.",
            hairHabit(for: profile),
            "Review one friction point only and tighten that before changing the rest of the plan."
        ]

        return RecommendationRoadmap(
            topPriorities: [
                sleepPriorityLine(for: profile),
                hydrationPriorityLine(for: profile),
                calorieLine
            ],
            dailyHabits: dailyHabits,
            weeklyHabits: weeklyHabits,
            morningRoutine: [
                RoutineStep(timing: "Morning", title: "Hydrate early", detail: "Get \(Int(round(min(28, hydrationTarget * 0.25)))) to \(Int(round(min(36, hydrationTarget * 0.35)))) oz in before midday so hydration does not slide later."),
                RoutineStep(timing: "Morning", title: "Keep the skin routine simple", detail: skincareMorningDetail(for: profile))
            ],
            nightRoutine: [
                RoutineStep(timing: "Night", title: "Protect sleep quality", detail: "Give yourself a consistent wind-down and aim for bedtime that supports \(hoursString(sleepTarget)) sleep."),
                RoutineStep(timing: "Night", title: "Set up tomorrow's intake", detail: bodyGoalMode(for: profile) == .cut ? "Pre-plan one high-protein meal so the calorie deficit stays controlled instead of reactive." : "Pre-plan one protein-forward meal so the current goal stays easy to repeat.")
            ],
            timeline: [
                TimelineItem(label: "2 weeks", expectation: shortTimeline(for: profile)),
                TimelineItem(label: "6 weeks", expectation: mediumTimeline(for: profile)),
                TimelineItem(label: "12 weeks", expectation: longTimeline(for: profile))
            ],
            disclaimer: "Guidance is informational, not medical care. Skin, hair, and body-composition changes should be approached conservatively, especially for younger users."
        )
    }

    static func detail(for slug: String, profile: ProfileRecord, assessmentSeed: Int) -> AnalysisDetailContent {
        let metrics = bodyMetrics(for: profile)

        switch slug {
        case "facial":
            return AnalysisDetailContent(
                headline: facialSummary(for: profile),
                explanation: "This is a simulated scan narrative layered on top of profile inputs. It stays conservative and emphasizes habits, grooming, and presentation rather than fixed judgments.",
                observations: facialHighlights(for: profile, seed: assessmentSeed),
                routines: [
                    RoutineStep(timing: "Weekly", title: "Keep grooming structure clean", detail: groomingRoutine(for: profile)),
                    RoutineStep(timing: "Daily", title: "Support a fresher read", detail: "Sleep and hydration consistency still matter more than trying to force a structural change.")
                ],
                locked: false
            )
        case "skin":
            return AnalysisDetailContent(
                headline: skinSummary(for: profile),
                explanation: "This is mostly rule-based. It uses goals, hydration, and basic nutrition context to suggest a conservative routine rather than implying diagnosis.",
                observations: skinHighlights(for: profile),
                routines: [
                    RoutineStep(timing: "Morning", title: "Barrier-first morning", detail: skincareMorningDetail(for: profile)),
                    RoutineStep(timing: "Night", title: "Keep actives controlled", detail: "Use one active at a time and keep the base routine stable for at least a few weeks before judging it.")
                ],
                locked: false
            )
        case "hair":
            return AnalysisDetailContent(
                headline: hairSummary(for: profile),
                explanation: "This combines selected hair goals with a simulated scan read so the suggestions stay realistic for an MVP.",
                observations: hairHighlights(for: profile),
                routines: [
                    RoutineStep(timing: "Weekly", title: "Scalp support", detail: hairHabit(for: profile)),
                    RoutineStep(timing: "Barber visit", title: "Cut direction", detail: "Keep temple exposure controlled and use texture to make density read cleaner.")
                ],
                locked: false
            )
        case "body":
            return AnalysisDetailContent(
                headline: "Calculated targets: \(metrics.proteinGrams) g protein, about \(metrics.targetCalories) kcal, and \(Int(round(hydrationTargetOunces(for: profile)))) oz hydration.",
                explanation: "This module is the most calculation-heavy part of the MVP. Resting needs are estimated from weight, height, age, and sex, then adjusted by exercise frequency and the selected body goal.",
                observations: bodyHighlights(for: profile),
                routines: [
                    RoutineStep(timing: "Daily", title: "Protein anchor", detail: proteinMealGuidance(for: metrics.proteinGrams)),
                    RoutineStep(timing: "Weekly", title: "Training direction", detail: "Keep \(trainingTargetDays(for: profile)) or more productive sessions per week and adjust nutrition before adding excess volume.")
                ],
                locked: false
            )
        default:
            return AnalysisDetailContent(
                headline: lifestyleSummary(for: profile),
                explanation: "This module uses questionnaire data and evidence-based targets for sleep, hydration, and activity. It is intended to guide consistency, not diagnose problems.",
                observations: lifestyleHighlights(for: profile),
                routines: [
                    RoutineStep(timing: "Daily", title: "Sleep target", detail: sleepPriorityLine(for: profile)),
                    RoutineStep(timing: "Daily", title: "Hydration target", detail: hydrationPriorityLine(for: profile))
                ],
                locked: false
            )
        }
    }
}

private extension RecommendationEngine {
    enum BodyGoalMode {
        case cut
        case recomp
        case gain
        case maintenance
    }

    struct BodyMetrics {
        let maintenanceCalories: Int
        let targetCalories: Int
        let proteinGrams: Int
    }

    static func sleepTargetHours(for profile: ProfileRecord) -> Double {
        let age = profile.age ?? 18
        return age < 18 ? 8.5 : 7.5
    }

    static func hydrationTargetOunces(for profile: ProfileRecord) -> Double {
        let age = profile.age ?? 19
        let gender = profile.gender ?? "Male"

        let totalLiters: Double
        switch (age, gender) {
        case (..<14, "Female"): totalLiters = 2.1
        case (..<14, _): totalLiters = 2.4
        case (..<19, "Female"): totalLiters = 2.3
        case (..<19, _): totalLiters = 3.3
        case (_, "Female"): totalLiters = 2.7
        default: totalLiters = 3.7
        }

        return totalLiters * 0.8 * 33.814
    }

    static func trainingTargetDays(for profile: ProfileRecord) -> Int {
        max(3, min(5, (profile.exerciseDays ?? 0) < 3 ? 4 : (profile.exerciseDays ?? 0)))
    }

    static func sleepGap(for profile: ProfileRecord) -> Double? {
        guard let current = profile.sleepHours else { return nil }
        return max(0, sleepTargetHours(for: profile) - current)
    }

    static func hydrationGap(for profile: ProfileRecord) -> Double? {
        guard let current = profile.hydrationLiters else { return nil }
        let currentOunces = current * 33.814
        return max(0, hydrationTargetOunces(for: profile) - currentOunces)
    }

    static func bodyGoalMode(for profile: ProfileRecord) -> BodyGoalMode {
        let goals = Set(profile.bodyGoals)

        if goals.contains("Lower body fat") || goals.contains("Leaner physique") {
            return .cut
        }
        if goals.contains("Build strength") {
            return .gain
        }
        if goals.contains("More athletic look") {
            return .recomp
        }
        return .maintenance
    }

    static func shouldFavorBodyFatReduction(for profile: ProfileRecord) -> Bool {
        let goals = Set(profile.bodyGoals)
        if goals.contains("Lower body fat") || goals.contains("Leaner physique") {
            return true
        }

        guard let estimate = profile.bodyFatEstimate else { return false }
        let gender = profile.gender ?? "Male"

        if gender == "Female" {
            return estimate >= 32
        }

        return estimate >= 25
    }

    static func bodyMetrics(for profile: ProfileRecord) -> BodyMetrics {
        let weightKG = profile.weightKG ?? 70
        let heightCM = Double(profile.heightCM ?? 175)
        let age = Double(profile.age ?? 24)
        let gender = profile.gender ?? "Male"

        let bmr: Double
        if gender == "Female" {
            bmr = (10 * weightKG) + (6.25 * heightCM) - (5 * age) - 161
        } else {
            bmr = (10 * weightKG) + (6.25 * heightCM) - (5 * age) + 5
        }

        let activityMultiplier: Double
        switch profile.exerciseDays ?? 0 {
        case 0...1: activityMultiplier = 1.2
        case 2...3: activityMultiplier = 1.375
        case 4...5: activityMultiplier = 1.55
        default: activityMultiplier = 1.7
        }

        let maintenance = Int((bmr * activityMultiplier).rounded())

        let targetCalories: Int
        let proteinPerKG: Double
        switch bodyGoalMode(for: profile) {
        case .cut:
            let deficit = ((profile.bodyFatEstimate ?? 18) >= ((gender == "Female") ? 30 : 20)) ? 0.15 : 0.10
            targetCalories = Int((Double(maintenance) * (1 - deficit)).rounded())
            proteinPerKG = 2.0
        case .gain:
            targetCalories = Int((Double(maintenance) * 1.05).rounded())
            proteinPerKG = 1.8
        case .recomp:
            targetCalories = maintenance - 150
            proteinPerKG = 1.8
        case .maintenance:
            targetCalories = maintenance
            proteinPerKG = 1.6
        }

        return BodyMetrics(
            maintenanceCalories: maintenance,
            targetCalories: max(targetCalories, Int((bmr * 1.1).rounded())),
            proteinGrams: Int((weightKG * proteinPerKG).rounded())
        )
    }

    static func facialLabel(for profile: ProfileRecord, seed: Int) -> String {
        let recoveryWeak = (sleepGap(for: profile) ?? 0) > 0.4 || (hydrationGap(for: profile) ?? 0) > 12
        return recoveryWeak ? "Better recovery should sharpen the overall read" : (seed.isMultiple(of: 2) ? "Solid baseline with room from grooming precision" : "Stable foundation with upside from consistency")
    }

    static func facialSummary(for profile: ProfileRecord) -> String {
        if (sleepGap(for: profile) ?? 0) > 0.4 {
            return "The current face read likely has more upside from sleep and recovery than from dramatic structural changes."
        }
        return "The current face read looks like a solid baseline where grooming, hairstyle choice, and consistency should do more than aggressive interventions."
    }

    static func facialHighlights(for profile: ProfileRecord, seed: Int) -> [String] {
        var highlights = ["Grooming consistency should influence overall presentation more than hard structural assumptions."]
        if profile.groomingGoals.contains("Prevent ingrown hairs") {
            highlights.append("Keep shaving and beard-line changes conservative to reduce irritation and bumps.")
        }
        if (sleepGap(for: profile) ?? 0) > 0.4 {
            highlights.append("Sleep below target may be softening eye-area freshness more than anything fixed.")
        }
        if seed.isMultiple(of: 2) {
            highlights.append("Hairline framing and haircut shape should have a visible effect on balance.")
        } else {
            highlights.append("Hydration and routine steadiness should help the face read sharper from week to week.")
        }
        return highlights
    }

    static func skinLabel(for profile: ProfileRecord) -> String {
        if profile.skinGoals.contains("Reduce redness") || profile.skinGoals.contains("Calmer acne-prone skin") {
            return "Calm, barrier-first routine"
        }
        if profile.skinGoals.contains("Smoother texture") {
            return "Consistency before stronger actives"
        }
        return "Simple routine with steady protection"
    }

    static func skinSummary(for profile: ProfileRecord) -> String {
        if profile.skinGoals.contains("Reduce redness") || profile.skinGoals.contains("Calmer acne-prone skin") {
            return "The current skin goals point toward a calmer, barrier-first plan instead of aggressive active stacking."
        }
        if profile.skinGoals.contains("Smoother texture") {
            return "Texture goals should respond better to a stable routine and daily SPF than frequent product changes."
        }
        return "The current skin goals are best served by keeping the routine simple, consistent, and non-irritating."
    }

    static func skinHighlights(for profile: ProfileRecord) -> [String] {
        var results = ["Daily SPF and a gentle cleanser-moisturizer base should stay non-negotiable."]
        if let hydrationGap = hydrationGap(for: profile), hydrationGap > 12 {
            results.append("Hydration is low enough that skin comfort may improve from habit changes before product escalation.")
        }
        if let insight = ProfileService.dietInsight(from: profile.dietNotes, dietQuality: profile.dietQuality) {
            results.append(insight)
        }
        return Array(results.prefix(3))
    }

    static func hairLabel(for profile: ProfileRecord, seed: Int) -> String {
        if profile.hairGoals.contains("Hair loss prevention") {
            return "Preventive framing and scalp care"
        }
        return seed.isMultiple(of: 2) ? "Presentation over intervention" : "Density reads best with cleaner structure"
    }

    static func hairSummary(for profile: ProfileRecord) -> String {
        if profile.hairGoals.contains("Hair loss prevention") {
            return "The hair goals suggest keeping the approach preventive and presentation-focused: scalp comfort, photo tracking, and cuts that frame the corners well."
        }
        return "The current hair goals look more responsive to styling and haircut direction than to any extreme intervention."
    }

    static func hairHighlights(for profile: ProfileRecord) -> [String] {
        var results = ["Clean cut shape and scalp comfort should matter more than forcing height or exposing the corners too aggressively."]
        if profile.hairGoals.contains("Better density presentation") {
            results.append("Forward texture and softer temple exposure should help density read better.")
        }
        if profile.hairGoals.contains("Healthier scalp") {
            results.append("A calmer scalp should make the hair look better even before any deeper changes.")
        }
        return Array(results.prefix(3))
    }

    static func bodyLabel(for profile: ProfileRecord) -> String {
        switch bodyGoalMode(for: profile) {
        case .cut: return "Moderate cut setup"
        case .gain: return "Lean gain setup"
        case .recomp: return "Recomposition setup"
        case .maintenance: return "Maintenance-first setup"
        }
    }

    static func bodySummary(for profile: ProfileRecord) -> String {
        let metrics = bodyMetrics(for: profile)
        switch bodyGoalMode(for: profile) {
        case .cut:
            return "The current stats support a moderate cut around \(metrics.targetCalories) kcal rather than aggressive restriction."
        case .gain:
            return "The current stats support a leaner gain phase around \(metrics.targetCalories) kcal with enough protein to prioritize strength."
        case .recomp:
            return "The current stats support recomposition better than a hard bulk or crash cut."
        case .maintenance:
            return "The current stats support maintaining weight while improving food quality, recovery, and training consistency."
        }
    }

    static func bodyHighlights(for profile: ProfileRecord) -> [String] {
        let metrics = bodyMetrics(for: profile)
        return [
            "Estimated maintenance sits around \(metrics.maintenanceCalories) kcal/day.",
            "Protein target is about \(metrics.proteinGrams) g/day based on the selected goal.",
            "Estimated body fat is \(profile.bodyFatEstimate.map { String(format: "%.1f%%", $0) } ?? "pending"), which helps set the current phase."
        ]
    }

    static func lifestyleLabel(for profile: ProfileRecord) -> String {
        if (sleepGap(for: profile) ?? 0) > 0.4 {
            return "Recovery has the most upside"
        }
        if (hydrationGap(for: profile) ?? 0) > 12 {
            return "Hydration consistency first"
        }
        return "Solid baseline with room from consistency"
    }

    static func lifestyleSummary(for profile: ProfileRecord) -> String {
        if (sleepGap(for: profile) ?? 0) > 0.4 {
            return "Lifestyle is still the biggest multiplier here, with sleep consistency offering the cleanest upside."
        }
        if (hydrationGap(for: profile) ?? 0) > 12 {
            return "Hydration is one of the clearest low-friction improvements in the current baseline."
        }
        return "Lifestyle habits are reasonably solid, so the next gains should come from repeating them more consistently."
    }

    static func lifestyleHighlights(for profile: ProfileRecord) -> [String] {
        var results = [
            "Target sleep is \(hoursString(sleepTargetHours(for: profile))) based on age-guided recommendations.",
            "Hydration target is around \(Int(round(hydrationTargetOunces(for: profile)))) oz from beverage intake."
        ]
        let currentExercise = profile.exerciseDays ?? 0
        results.append("Current exercise is \(currentExercise) days per week; the plan aims for at least \(trainingTargetDays(for: profile)) productive days.")
        return results
    }

    static func hoursString(_ value: Double?) -> String {
        guard let value else { return "--" }
        return String(format: "%.1f h", value)
    }

    static func ouncesString(from liters: Double?) -> String {
        guard let liters else { return "--" }
        return String(format: "%.0f oz", liters * 33.814)
    }

    static func sleepPriorityLine(for profile: ProfileRecord) -> String {
        "Aim for about \(hoursString(sleepTargetHours(for: profile))) sleep on most nights before making the rest of the plan more complex."
    }

    static func hydrationPriorityLine(for profile: ProfileRecord) -> String {
        "Push beverage intake toward roughly \(Int(round(hydrationTargetOunces(for: profile)))) oz per day, with more earlier in the day."
    }

    static func calorieGuidanceLine(for metrics: BodyMetrics) -> String {
        "Use about \(metrics.targetCalories) kcal as the current daily target and adjust slowly based on weekly trend changes."
    }

    static func skincareHabit(for profile: ProfileRecord) -> String {
        if profile.skinGoals.contains("Reduce redness") || profile.skinGoals.contains("Calmer acne-prone skin") {
            return "Keep skincare calm: gentle cleanser, moisturizer, SPF, and only one active at a time."
        }
        return "Keep skincare simple and steady enough that irritation does not become the limiting factor."
    }

    static func skincareMorningDetail(for profile: ProfileRecord) -> String {
        if profile.skinGoals.contains("Reduce redness") {
            return "Use a gentle cleanse only if needed, then moisturizer and SPF without layering extra irritants."
        }
        return "Use a simple cleanser, moisturizer, and SPF so the routine stays repeatable."
    }

    static func hairHabit(for profile: ProfileRecord) -> String {
        if profile.hairGoals.contains("Healthier scalp") || profile.hairGoals.contains("Hair loss prevention") {
            return "Keep scalp care gentle and consistent, and track hairline photos instead of reacting day to day."
        }
        return "Use cuts and styling that help density read cleaner without exposing the temples too aggressively."
    }

    static func groomingRoutine(for profile: ProfileRecord) -> String {
        if profile.groomingGoals.contains("Prevent ingrown hairs") {
            return "Use conservative beard-line and shaving changes so irritation stays under control."
        }
        return "Keep haircut, beard edges, and brows clean so the face reads more intentional."
    }

    static func proteinMealGuidance(for target: Int) -> String {
        let perMeal = max(25, Int((Double(target) / 4).rounded()))
        return "Split the target across 3 to 4 meals, aiming for roughly \(perMeal) to \(perMeal + 10) g protein in each."
    }

    static func shortTimeline(for profile: ProfileRecord) -> String {
        if bodyGoalMode(for: profile) == .cut {
            return "Routine adherence, hunger management, and water consistency should feel more stable."
        }
        return "Sleep, hydration, and routine consistency should feel easier to repeat without much friction."
    }

    static func mediumTimeline(for profile: ProfileRecord) -> String {
        if profile.skinGoals.contains("Smoother texture") || profile.skinGoals.contains("Reduce redness") {
            return "Skin and recovery-driven presentation changes should look more consistent if the baseline habits hold."
        }
        return "Training, grooming, and lifestyle changes should start reading as more polished and deliberate."
    }

    static func longTimeline(for profile: ProfileRecord) -> String {
        switch bodyGoalMode(for: profile) {
        case .cut:
            return "Body composition, grooming, and scan-to-scan consistency should be noticeably more refined if the deficit stays moderate."
        case .gain:
            return "Strength, body shape, and overall presentation should be more clearly improved if the surplus stays controlled."
        case .recomp, .maintenance:
            return "The biggest difference should come from compounding habits rather than any single aggressive change."
        }
    }
}
