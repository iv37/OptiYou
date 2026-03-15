import Foundation

enum MockDataService {
    static let profile = UserProfile(
        id: "demo-user",
        fullName: "Marcus Reed",
        age: 24,
        gender: "Male",
        heightCM: 180,
        weightKG: 78,
        bodyFatEstimate: 17,
        plan: .free,
        goals: ["Clearer skin", "Leaner face", "Body recomposition", "Consistency"],
        skinType: "Combination",
        skinConcerns: ["Post-workout congestion", "Mild redness", "Texture"],
        hairThickness: "Medium",
        hairLength: "Short textured crop",
        hairConcerns: ["Slight temple recession", "Dry scalp"],
        sleepHours: 6.7,
        hydrationLiters: 2.1,
        exerciseDays: 4,
        dietQuality: "Decent",
        calorieIntake: 2550
    )

    static let priorities: [PriorityItem] = [
        PriorityItem(title: "Improve recovery consistency", detail: "Sleep and hydration are the fastest levers for skin calmness and facial freshness this month.", module: "Lifestyle"),
        PriorityItem(title: "Tighten the skincare routine", detail: "Keep the morning routine minimal and reduce irritation from stacking actives.", module: "Skincare"),
        PriorityItem(title: "Refine haircut structure", detail: "A lower taper with forward texture will frame the hairline more cleanly.", module: "Hair")
    ]

    static let scans: [ScanAsset] = [
        ScanAsset(id: "front", title: "Front face", subtitle: "Balanced lighting, neutral expression", imageName: "person.crop.square", status: "Ready"),
        ScanAsset(id: "side", title: "Side face", subtitle: "Jawline and profile framing", imageName: "person.crop.rectangle", status: "Ready"),
        ScanAsset(id: "skin", title: "Skin close-up", subtitle: "Texture and redness review", imageName: "sparkles.rectangle.stack", status: "Ready"),
        ScanAsset(id: "hair", title: "Hairline", subtitle: "Corners, density, and framing", imageName: "scissors", status: "Processing")
    ]

    static let modules: [AnalysisModule] = [
        AnalysisModule(
            id: "facial",
            slug: "facial",
            title: "Facial balance",
            scoreLabel: "Well balanced foundation",
            priority: .medium,
            summary: "Balanced proportions overall. The main upside comes from better recovery and tighter grooming structure.",
            highlights: ["Good baseline symmetry", "Hair volume helps upper-third balance", "Sleep inconsistency softens eye area"],
            confidence: .simulatedAI
        ),
        AnalysisModule(
            id: "skin",
            slug: "skin",
            title: "Skincare",
            scoreLabel: "Barrier-first reset",
            priority: .high,
            summary: "Mild redness and texture suggest simplifying the routine before adding stronger active stacks.",
            highlights: ["Mild redness", "Texture around cheeks", "Routine complexity is the main risk"],
            confidence: .ruleBased
        ),
        AnalysisModule(
            id: "hair",
            slug: "hair",
            title: "Hairline and density",
            scoreLabel: "Stable with light recession",
            priority: .medium,
            summary: "Density appears solid with slight temple recession. Styling decisions matter more than aggressive intervention right now.",
            highlights: ["Density reads healthy", "Temple corners slightly open", "Dry scalp likely affecting texture"],
            confidence: .simulatedAI
        ),
        AnalysisModule(
            id: "body",
            slug: "body",
            title: "Body composition",
            scoreLabel: "Lean gain setup",
            priority: .medium,
            summary: "Estimated body fat supports a lean-recomposition phase rather than an aggressive cut.",
            highlights: ["Estimated 17% body fat", "Protein target under-hit", "Rest day calories run slightly high"],
            confidence: .calculated
        ),
        AnalysisModule(
            id: "lifestyle",
            slug: "lifestyle",
            title: "Lifestyle",
            scoreLabel: "High upside from recovery",
            priority: .high,
            summary: "Lifestyle habits are the main multiplier. Better sleep and hydration should improve skin tone, eye-area freshness, and recovery.",
            highlights: ["Sleep below target", "Hydration adequate but inconsistent", "Training frequency is good"],
            confidence: .ruleBased
        )
    ]

    static let roadmap = RecommendationRoadmap(
        topPriorities: [
            "Sleep 7.5 hours on at least five nights per week.",
            "Run a simple cleanser, moisturizer, and SPF routine for 21 days.",
            "Increase protein intake while keeping calories near recomposition range."
        ],
        dailyHabits: [
            "500 mL water before caffeine.",
            "Morning cleanser, moisturizer, and SPF 30+.",
            "10-minute walk after the final meal.",
            "Track sleep and hydration in the app."
        ],
        weeklyHabits: [
            "Two progress photos under the same lighting.",
            "One scalp-care wash with a gentle anti-dandruff active if tolerated.",
            "Meal prep two high-protein lunches.",
            "Review the weekly trend chart and adjust one habit only."
        ],
        morningRoutine: [
            RoutineStep(timing: "6:45 AM", title: "Cleanse and protect", detail: "Use a gentle cleanser, barrier-support moisturizer, and SPF."),
            RoutineStep(timing: "7:00 AM", title: "Hydration start", detail: "Drink 500 to 700 mL water before your first coffee.")
        ],
        nightRoutine: [
            RoutineStep(timing: "9:30 PM", title: "Reset the skin barrier", detail: "Cleanse, moisturize, and rotate one active only if the skin stays calm."),
            RoutineStep(timing: "10:15 PM", title: "Wind down", detail: "Lower overhead light and keep screens off for 30 minutes before sleep.")
        ],
        timeline: [
            TimelineItem(label: "2 weeks", expectation: "Skin should feel calmer and routine adherence becomes more automatic."),
            TimelineItem(label: "6 weeks", expectation: "Texture and puffiness should look more controlled if sleep and hydration improve."),
            TimelineItem(label: "12 weeks", expectation: "Body composition and grooming upgrades should read as more polished in comparison photos.")
        ],
        disclaimer: "Guidance is informational and should not replace care from a qualified medical professional."
    )

    static let progressEntries: [ProgressEntry] = [
        ProgressEntry(dateLabel: "Jan 10", skinClarity: 55, groomingConsistency: 48, bodyComposition: 58, hydration: 44),
        ProgressEntry(dateLabel: "Jan 31", skinClarity: 59, groomingConsistency: 60, bodyComposition: 61, hydration: 57),
        ProgressEntry(dateLabel: "Feb 21", skinClarity: 63, groomingConsistency: 67, bodyComposition: 65, hydration: 62),
        ProgressEntry(dateLabel: "Mar 08", skinClarity: 68, groomingConsistency: 72, bodyComposition: 69, hydration: 70)
    ]

    static let premiumFeatures: [PremiumFeature] = [
        PremiumFeature(title: "Advanced comparison overlays", detail: "Compare jawline, skin calmness, and eye-area freshness across scan history."),
        PremiumFeature(title: "Expanded product and haircut guidance", detail: "Unlock deeper ingredient suggestions and more detailed styling frameworks."),
        PremiumFeature(title: "Priority re-analysis", detail: "Run new scans faster and save multiple roadmap versions over time."),
        PremiumFeature(title: "Future AI coach layer", detail: "Prepared for a conversational coach when model-backed services are connected.")
    ]

    static func detail(for slug: String) -> AnalysisDetailContent {
        switch slug {
        case "facial":
            return AnalysisDetailContent(
                headline: "Balanced foundation with the clearest upside coming from recovery and grooming precision.",
                explanation: "This summary is a simulated AI narrative built on top of rule-based heuristics from the scan set. The current read suggests balanced overall proportions, while eye-area freshness and hairstyle framing are the main improvement levers.",
                observations: [
                    "Facial thirds read generally balanced in the current front and side views.",
                    "Mild under-eye fatigue looks more related to recovery and hydration than fixed structure.",
                    "Forward texture and reduced side bulk should keep attention centered on the eyes and jaw."
                ],
                routines: [
                    RoutineStep(timing: "2x weekly", title: "Grooming check", detail: "Keep lineups clean, control brow overgrowth lightly, and maintain facial hair edges with restraint."),
                    RoutineStep(timing: "Nightly", title: "Sleep-first recovery", detail: "Treat eye-area freshness as a recovery signal rather than a structural issue.")
                ],
                locked: false
            )
        case "skin":
            return AnalysisDetailContent(
                headline: "Barrier-first skincare should outperform a more aggressive routine right now.",
                explanation: "This module is primarily rule-based. Mild redness, congestion, and texture are interpreted conservatively and framed as informational rather than diagnostic.",
                observations: [
                    "Visible congestion appears mild and should respond better to consistency than frequent product changes.",
                    "Redness and texture suggest protecting the barrier before adding stronger active combinations.",
                    "SPF adherence is one of the highest-value habits for long-term skin presentation."
                ],
                routines: [
                    RoutineStep(timing: "Morning", title: "Cleanse, moisturize, protect", detail: "Gentle cleanser, barrier moisturizer, and SPF 30+. Add vitamin C only if the skin stays calm."),
                    RoutineStep(timing: "Night", title: "One active rotation", detail: "Cleanser, moisturizer, and one active on alternating nights if tolerated.")
                ],
                locked: true
            )
        case "hair":
            return AnalysisDetailContent(
                headline: "Density looks generally solid, with styling and scalp condition mattering more than major intervention.",
                explanation: "This summary combines simulated AI phrasing with conservative rule-based interpretation. The near-term upside is mainly presentation: cut shape, texture control, and scalp comfort.",
                observations: [
                    "Temple corners appear lightly open but density across the top still reads healthy.",
                    "Dryness at the scalp may reduce how full the hair looks on some days.",
                    "A lower taper and forward texture should frame the hairline better than pushing volume straight up."
                ],
                routines: [
                    RoutineStep(timing: "1-2x weekly", title: "Scalp care", detail: "Use a gentle shampoo schedule and introduce anti-dandruff actives carefully if flaking is present."),
                    RoutineStep(timing: "Barber visit", title: "Cut direction", detail: "Ask for soft texture in front, less height at the corners, and no overly exposed temples.")
                ],
                locked: false
            )
        case "body":
            return AnalysisDetailContent(
                headline: "Calculated targets: 143g protein, about 2268 kcal recomposition range, and 2.7L hydration.",
                explanation: "This module contains the clearest calculations in the MVP. Targets are derived from the profile using accepted heuristics, then paired with rule-based coaching about cut versus recomposition direction.",
                observations: [
                    "Estimated lean mass: 64.7 kg.",
                    "Maintenance calories approximate to 2418 kcal/day.",
                    "Current body composition suggests a steady recomposition phase is more sensible than an aggressive cut."
                ],
                routines: [
                    RoutineStep(timing: "Daily", title: "Nutrition setup", detail: "Center meals around protein and avoid crash dieting."),
                    RoutineStep(timing: "Weekly", title: "Training direction", detail: "Keep four lifting days with progressive overload and use cardio as recovery support.")
                ],
                locked: false
            )
        default:
            return AnalysisDetailContent(
                headline: "Lifestyle consistency is the highest-leverage appearance multiplier in the current profile.",
                explanation: "This module is mostly calculated from questionnaire inputs and wrapped in rule-based guidance.",
                observations: [
                    "Sleep is currently below the target likely to improve eye-area freshness and workout recovery.",
                    "Hydration is adequate on paper but should be made more consistent earlier in the day.",
                    "Training frequency is solid enough that nutrition and recovery now matter more than more volume."
                ],
                routines: [
                    RoutineStep(timing: "Nightly", title: "Recovery anchor", detail: "Set one fixed bedtime target and defend it five nights per week before changing anything else."),
                    RoutineStep(timing: "Morning", title: "Hydration anchor", detail: "Front-load water in the first half of the day so evening intake does not disrupt sleep.")
                ],
                locked: false
            )
        }
    }
}
