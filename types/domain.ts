export type PlanTier = "FREE" | "PREMIUM";
export type AnalysisStatus = "READY" | "PROCESSING" | "NEEDS_REVIEW";

export type GoalKey =
  | "clearer_skin"
  | "hair_health"
  | "leaner_face"
  | "body_recomposition"
  | "stronger_grooming"
  | "consistency";

export type SkinType = "dry" | "balanced" | "combination" | "oily" | "sensitive";
export type HairThickness = "fine" | "medium" | "thick";
export type DietQuality = "improving" | "decent" | "strong";

export interface UserProfile {
  id: string;
  name: string;
  email: string;
  age: number;
  gender: string;
  heightCm: number;
  weightKg: number;
  bodyFatEstimate: number;
  plan: PlanTier;
  goals: GoalKey[];
  skinType: SkinType;
  skinConcerns: string[];
  hairThickness: HairThickness;
  hairLength: string;
  hairConcerns: string[];
  sleepHours: number;
  hydrationLiters: number;
  exerciseDays: number;
  dietQuality: DietQuality;
  calorieIntake?: number;
  onboardingCompleted: boolean;
}

export interface UploadAsset {
  id: string;
  type: "front_face" | "side_face" | "skin_closeup" | "hairline";
  label: string;
  imageUrl: string;
  capturedAt: string;
  status: AnalysisStatus;
}

export interface AnalysisInsight {
  title: string;
  summary: string;
  confidenceLabel: "Calculated" | "Rule-based" | "Simulated AI";
}

export interface ModuleSummary {
  id: string;
  slug: "facial" | "skincare" | "hair" | "body" | "lifestyle";
  title: string;
  scoreLabel: string;
  priority: "High" | "Medium" | "Low";
  updatedAt: string;
  summary: string;
  highlights: string[];
}

export interface RoutineStep {
  timing: string;
  title: string;
  detail: string;
}

export interface RecommendationRoadmap {
  topPriorities: string[];
  dailyHabits: string[];
  weeklyHabits: string[];
  morningRoutine: RoutineStep[];
  nightRoutine: RoutineStep[];
  timeline: Array<{
    label: string;
    expectation: string;
  }>;
  disclaimer: string;
}

export interface ProgressPoint {
  date: string;
  skinClarity: number;
  groomingConsistency: number;
  bodyComposition: number;
  hydration: number;
}

export interface DashboardData {
  profile: UserProfile;
  priorities: Array<{
    title: string;
    detail: string;
    module: string;
  }>;
  uploads: UploadAsset[];
  modules: ModuleSummary[];
  roadmap: RecommendationRoadmap;
  progress: ProgressPoint[];
}
