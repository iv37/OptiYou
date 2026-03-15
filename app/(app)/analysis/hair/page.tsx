import { AnalysisDetail } from "@/components/analysis/analysis-detail";
import { getDashboardData } from "@/lib/services/dashboard-service";

export default async function HairAnalysisPage() {
  const data = await getDashboardData();
  const moduleSummary = data.modules.find((item) => item.slug === "hair") ?? data.modules[2];

  return (
    <AnalysisDetail
      module={moduleSummary}
      headline="Density looks generally solid, with styling and scalp condition mattering more than major intervention."
      explanation="This summary combines simulated AI phrasing with conservative rule-based interpretation. The current images suggest slight temple recession and some dryness. The near-term upside is mainly presentation: cut shape, texture control, and scalp comfort."
      bullets={[
        "Temple corners appear lightly open but density across the top still reads healthy.",
        "Dryness at the scalp may reduce how full the hair looks on some days.",
        "A lower taper and forward texture should frame the hairline better than pushing volume straight up."
      ]}
      routines={[
        {
          title: "Scalp care",
          detail: "Use a gentle shampoo schedule and introduce anti-dandruff actives carefully if flaking is present."
        },
        {
          title: "Barber brief",
          detail: "Ask for soft texture in front, less height at the corners, and no overly exposed temples."
        }
      ]}
      roadmap={data.roadmap}
    />
  );
}
