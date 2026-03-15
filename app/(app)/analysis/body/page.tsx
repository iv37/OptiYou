import { AnalysisDetail } from "@/components/analysis/analysis-detail";
import { calculateBodyComposition } from "@/lib/services/analysis-engine";
import { getDashboardData } from "@/lib/services/dashboard-service";

export default async function BodyAnalysisPage() {
  const data = await getDashboardData();
  const moduleSummary = data.modules.find((item) => item.slug === "body") ?? data.modules[3];
  const body = calculateBodyComposition(data.profile);

  return (
    <AnalysisDetail
      module={moduleSummary}
      headline={`Calculated targets: ${body.proteinTarget}g protein, ~${body.recompositionCalories} kcal recomposition range, and ${body.waterTarget}L hydration.`}
      explanation="This module contains the clearest calculations in the MVP. Targets are derived from the profile using simple accepted heuristics, then paired with rule-based guidance about whether to cut, maintain, or pursue a lean gain approach."
      bullets={[
        `Estimated lean mass: ${body.leanMassKg} kg.`,
        `Maintenance calories are approximated near ${body.maintenanceCalories} kcal/day.`,
        "Current body composition suggests a steady recomposition phase is more sensible than an aggressive cut."
      ]}
      routines={[
        {
          title: "Nutrition setup",
          detail: "Center meals around protein, keep calorie intake near the recomposition target, and avoid crash dieting."
        },
        {
          title: "Training direction",
          detail: "Maintain 4 lifting days with progressive overload and add light cardio for recovery rather than punishment."
        }
      ]}
      roadmap={data.roadmap}
    />
  );
}
