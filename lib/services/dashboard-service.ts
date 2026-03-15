import { demoDashboardData } from "@/lib/data/demo-data";
import { buildRecommendationRoadmap } from "@/lib/services/analysis-engine";

export async function getDashboardData() {
  return {
    ...demoDashboardData,
    roadmap: buildRecommendationRoadmap(demoDashboardData.profile)
  };
}
