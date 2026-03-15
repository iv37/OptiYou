import { AnalysisDetail } from "@/components/analysis/analysis-detail";
import { getDashboardData } from "@/lib/services/dashboard-service";

export default async function FacialAnalysisPage() {
  const data = await getDashboardData();
  const moduleSummary = data.modules.find((item) => item.slug === "facial") ?? data.modules[0];

  return (
    <AnalysisDetail
      module={moduleSummary}
      headline="Balanced foundation with the clearest upside coming from recovery and grooming precision."
      explanation="This summary is a simulated AI narrative built on top of rule-based heuristics from the scan set. The current read suggests balanced overall proportions, while eye-area freshness and hairstyle framing are the main improvement levers."
      bullets={[
        "Facial thirds read generally balanced in the current front and side views.",
        "Mild under-eye fatigue looks more related to recovery and hydration than fixed structure.",
        "Forward texture and reduced side bulk should keep attention centered on the eyes and jaw."
      ]}
      routines={[
        {
          title: "Grooming check twice weekly",
          detail: "Keep lineups clean, control brow overgrowth lightly, and maintain facial hair edges with restraint."
        },
        {
          title: "Sleep-first recovery",
          detail: "Treat eye-area freshness as a recovery signal. More sleep often changes facial presentation faster than extra products."
        }
      ]}
      roadmap={data.roadmap}
    />
  );
}
