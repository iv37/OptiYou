import { AnalysisDetail } from "@/components/analysis/analysis-detail";
import { getDashboardData } from "@/lib/services/dashboard-service";

export default async function SkincareAnalysisPage() {
  const data = await getDashboardData();
  const moduleSummary = data.modules.find((item) => item.slug === "skincare") ?? data.modules[1];

  return (
    <AnalysisDetail
      module={moduleSummary}
      headline="Barrier-first skincare should outperform a more aggressive routine right now."
      explanation="This module is primarily rule-based. Mild redness, congestion, and texture are interpreted conservatively and framed as informational rather than diagnostic. Morning and evening guidance is designed to keep the routine simple and tolerable."
      bullets={[
        "Visible congestion appears mild and should respond better to consistency than frequent product changes.",
        "Redness and texture suggest protecting the barrier before adding stronger active combinations.",
        "SPF adherence is one of the highest-value habits for long-term skin presentation."
      ]}
      routines={[
        {
          title: "Morning routine",
          detail: "Gentle cleanser, barrier moisturizer, SPF 30+. Add vitamin C only if the skin stays calm."
        },
        {
          title: "Night routine",
          detail: "Cleanser, moisturizer, and one active rotation such as adapalene or salicylic acid on alternating nights if tolerated."
        }
      ]}
      roadmap={data.roadmap}
      locked
    />
  );
}
