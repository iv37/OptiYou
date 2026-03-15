import type { DashboardData } from "@/types/domain";

export const demoDashboardData: DashboardData = {
  profile: {
    id: "user_demo",
    name: "Marcus Reed",
    email: "marcus@example.com",
    age: 24,
    gender: "Male",
    heightCm: 180,
    weightKg: 78,
    bodyFatEstimate: 17,
    plan: "FREE",
    goals: ["clearer_skin", "leaner_face", "body_recomposition", "consistency"],
    skinType: "combination",
    skinConcerns: ["post-workout congestion", "mild redness", "texture"],
    hairThickness: "medium",
    hairLength: "Short textured crop",
    hairConcerns: ["slight temple recession", "dry scalp"],
    sleepHours: 6.7,
    hydrationLiters: 2.1,
    exerciseDays: 4,
    dietQuality: "decent",
    calorieIntake: 2550,
    onboardingCompleted: true
  },
  priorities: [
    {
      title: "Improve recovery consistency",
      detail: "Sleep and hydration are the fastest levers for skin calmness and facial freshness this month.",
      module: "Lifestyle"
    },
    {
      title: "Tighten the skincare routine",
      detail: "Keep the morning routine minimal and reduce irritation from stacking actives.",
      module: "Skincare"
    },
    {
      title: "Refine haircut structure",
      detail: "A lower taper with forward texture will frame the hairline more cleanly.",
      module: "Hair"
    }
  ],
  uploads: [
    {
      id: "upload_1",
      type: "front_face",
      label: "Front face",
      imageUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=900&q=80",
      capturedAt: "2026-03-01",
      status: "READY"
    },
    {
      id: "upload_2",
      type: "side_face",
      label: "Side face",
      imageUrl: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=900&q=80",
      capturedAt: "2026-03-01",
      status: "READY"
    },
    {
      id: "upload_3",
      type: "skin_closeup",
      label: "Skin close-up",
      imageUrl: "https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80",
      capturedAt: "2026-03-01",
      status: "READY"
    },
    {
      id: "upload_4",
      type: "hairline",
      label: "Hairline",
      imageUrl: "https://images.unsplash.com/photo-1504593811423-6dd665756598?auto=format&fit=crop&w=900&q=80",
      capturedAt: "2026-03-01",
      status: "PROCESSING"
    }
  ],
  modules: [
    {
      id: "mod_facial",
      slug: "facial",
      title: "Facial balance",
      scoreLabel: "Well balanced foundation",
      priority: "Medium",
      updatedAt: "2026-03-08",
      summary: "Balanced midface and jaw framing. Main upside comes from reducing puffiness and sharpening grooming structure.",
      highlights: ["Good baseline symmetry", "Hair volume helps upper-third balance", "Sleep inconsistency softens eye area"]
    },
    {
      id: "mod_skin",
      slug: "skincare",
      title: "Skincare",
      scoreLabel: "Barrier-first reset",
      priority: "High",
      updatedAt: "2026-03-08",
      summary: "Visible congestion looks mild. Focus on consistency, hydration, and fewer active layers before adding stronger treatments.",
      highlights: ["Mild redness", "Texture around cheeks", "Routine complexity is the main risk"]
    },
    {
      id: "mod_hair",
      slug: "hair",
      title: "Hairline and density",
      scoreLabel: "Stable with light recession",
      priority: "Medium",
      updatedAt: "2026-03-08",
      summary: "Density appears generally solid with slight temple recession. Cut and styling choices matter more than aggressive intervention right now.",
      highlights: ["Density reads healthy", "Temple corners slightly open", "Dry scalp likely affecting texture"]
    },
    {
      id: "mod_body",
      slug: "body",
      title: "Body composition",
      scoreLabel: "Lean gain setup",
      priority: "Medium",
      updatedAt: "2026-03-08",
      summary: "Estimated body fat supports a lean-recomposition phase rather than an aggressive cut. Preserve training performance and tighten nutrition quality.",
      highlights: ["Estimated 17% body fat", "Protein target under-hit", "Maintenance calories slightly high on rest days"]
    },
    {
      id: "mod_lifestyle",
      slug: "lifestyle",
      title: "Lifestyle",
      scoreLabel: "High upside from recovery",
      priority: "High",
      updatedAt: "2026-03-08",
      summary: "Lifestyle habits are the main multiplier. More consistent sleep and hydration should improve skin tone, eye-area freshness, and training recovery.",
      highlights: ["Sleep below target", "Hydration adequate but inconsistent", "Training frequency is good"]
    }
  ],
  roadmap: {
    topPriorities: [
      "Sleep 7.5 hours on at least five nights per week.",
      "Run a simple cleanser-moisturizer-SPF morning routine for 21 days.",
      "Increase protein intake while keeping calories near recomposition range."
    ],
    dailyHabits: [
      "500 mL water before caffeine.",
      "Morning cleanser, lightweight moisturizer, SPF 30+.",
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
      {
        timing: "6:45 AM",
        title: "Cleanse and protect",
        detail: "Use a gentle cleanser, barrier-support moisturizer, and SPF. Skip unnecessary actives on recovery days."
      },
      {
        timing: "7:00 AM",
        title: "Hydration start",
        detail: "Drink 500 to 700 mL water before your first coffee."
      }
    ],
    nightRoutine: [
      {
        timing: "9:30 PM",
        title: "Reset the skin barrier",
        detail: "Cleanse, apply moisturizer, and use a mild adapalene or salicylic rotation only if your skin stays calm."
      },
      {
        timing: "10:15 PM",
        title: "Wind down",
        detail: "Lower overhead light and keep screens off for 30 minutes before sleep."
      }
    ],
    timeline: [
      {
        label: "2 weeks",
        expectation: "Skin should feel calmer and routine adherence becomes automatic."
      },
      {
        label: "6 weeks",
        expectation: "Texture and puffiness should look more controlled if sleep and hydration improve."
      },
      {
        label: "12 weeks",
        expectation: "Body composition and grooming upgrades should read as more polished in comparison photos."
      }
    ],
    disclaimer: "Guidance is informational and should not replace care from a qualified medical professional."
  },
  progress: [
    {
      date: "2026-01-10",
      skinClarity: 55,
      groomingConsistency: 48,
      bodyComposition: 58,
      hydration: 44
    },
    {
      date: "2026-01-31",
      skinClarity: 59,
      groomingConsistency: 60,
      bodyComposition: 61,
      hydration: 57
    },
    {
      date: "2026-02-21",
      skinClarity: 63,
      groomingConsistency: 67,
      bodyComposition: 65,
      hydration: 62
    },
    {
      date: "2026-03-08",
      skinClarity: 68,
      groomingConsistency: 72,
      bodyComposition: 69,
      hydration: 70
    }
  ]
};
