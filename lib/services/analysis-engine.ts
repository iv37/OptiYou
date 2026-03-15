import { demoDashboardData } from "@/lib/data/demo-data";
import type { ModuleSummary, RecommendationRoadmap, UserProfile } from "@/types/domain";

export function calculateBodyComposition(profile: UserProfile) {
  const leanMassKg = profile.weightKg * (1 - profile.bodyFatEstimate / 100);
  const proteinTarget = Math.round(leanMassKg * 2.2);
  const maintenanceCalories = Math.round(profile.weightKg * 31);
  const recompositionCalories = maintenanceCalories - 150;
  const waterTarget = Number(Math.max(2.7, profile.weightKg * 0.035).toFixed(1));

  return {
    leanMassKg: Number(leanMassKg.toFixed(1)),
    proteinTarget,
    maintenanceCalories,
    recompositionCalories,
    waterTarget
  };
}

export function buildRecommendationRoadmap(profile: UserProfile): RecommendationRoadmap {
  const body = calculateBodyComposition(profile);

  return {
    ...demoDashboardData.roadmap,
    topPriorities: [
      `Average ${Math.max(7.5, profile.sleepHours + 0.6).toFixed(1)} hours of sleep.`,
      `Reach roughly ${body.waterTarget}L of water most days.`,
      `Hold protein near ${body.proteinTarget}g for recomposition support.`
    ]
  };
}

export function moduleBySlug(slug: ModuleSummary["slug"]) {
  return demoDashboardData.modules.find((module) => module.slug === slug) ?? demoDashboardData.modules[0];
}
