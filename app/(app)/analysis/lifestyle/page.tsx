import { AnalysisDetail } from "@/components/analysis/analysis-detail";
import { getDashboardData } from "@/lib/services/dashboard-service";

export default async function LifestyleAnalysisPage() {
  const data = await getDashboardData();
  const moduleSummary = data.modules.find((item) => item.slug === "lifestyle") ?? data.modules[4];

  return (
    <AnalysisDetail
      module={moduleSummary}
      headline="Lifestyle consistency is the highest-leverage appearance multiplier in the current profile."
      explanation="This module is mostly calculated from questionnaire inputs and wrapped in rule-based guidance. Better sleep, hydration, and meal quality can materially improve how the skin, eyes, recovery, and body composition present in photos."
      bullets={[
        "Sleep is currently below the target likely to improve eye-area freshness and workout recovery.",
        "Hydration is adequate on paper but should be made more consistent earlier in the day.",
        "Training frequency is solid enough that nutrition and recovery now matter more than more volume."
      ]}
      routines={[
        {
          title: "Recovery anchor",
          detail: "Set one fixed bedtime target and defend it five nights per week before changing anything else."
        },
        {
          title: "Hydration anchor",
          detail: "Front-load water in the first half of the day so evening intake does not disrupt sleep."
        }
      ]}
      roadmap={data.roadmap}
    />
  );
}
