import { ProgressChart } from "@/components/progress/progress-chart";
import { Badge } from "@/components/ui/badge";
import { Card } from "@/components/ui/card";
import { SectionHeading } from "@/components/ui/section-heading";
import { getDashboardData } from "@/lib/services/dashboard-service";
import { formatDate } from "@/lib/utils";

export default async function ProgressPage() {
  const data = await getDashboardData();

  return (
    <div className="space-y-6">
      <Card className="rounded-[32px] p-6 sm:p-8">
        <Badge>Progress tracking</Badge>
        <h1 className="mt-4 text-3xl font-semibold tracking-tight">Your trendline is moving in the right direction.</h1>
        <p className="mt-3 max-w-2xl text-sm leading-7 text-muted">
          Progress is saved as dated snapshots so you can compare routines, analysis outcomes, and key metrics over time. The chart is production-ready for real backend data.
        </p>
      </Card>

      <Card className="rounded-[32px] p-5 sm:p-6">
        <ProgressChart data={data.progress} />
      </Card>

      <section className="space-y-4">
        <SectionHeading
          eyebrow="History"
          title="Saved scan and recommendation history"
          description="Each entry ties together photo captures, key metrics, and the recommendation set that was active at that time."
        />
        <div className="space-y-3">
          {data.progress.map((entry, index) => (
            <Card key={entry.date} className="rounded-[28px]">
              <div className="grid gap-4 lg:grid-cols-[0.8fr_1.2fr_0.8fr] lg:items-center">
                <div>
                  <p className="text-sm text-muted">Snapshot date</p>
                  <p className="mt-2 text-xl font-semibold">{formatDate(entry.date)}</p>
                </div>
                <div className="grid gap-3 sm:grid-cols-2">
                  <div className="rounded-2xl bg-white/70 px-4 py-3 text-sm text-muted-strong">Skin clarity: {entry.skinClarity}</div>
                  <div className="rounded-2xl bg-white/70 px-4 py-3 text-sm text-muted-strong">Grooming consistency: {entry.groomingConsistency}</div>
                  <div className="rounded-2xl bg-white/70 px-4 py-3 text-sm text-muted-strong">Body composition: {entry.bodyComposition}</div>
                  <div className="rounded-2xl bg-white/70 px-4 py-3 text-sm text-muted-strong">Hydration consistency: {entry.hydration}</div>
                </div>
                <div className="rounded-[24px] border border-line bg-accent-soft/60 p-4 text-sm leading-6 text-muted-strong">
                  {index === data.progress.length - 1
                    ? "Most recent recommendation set emphasizes sleep regularity and a simplified routine."
                    : "Earlier recommendation set focused on building adherence and reducing inconsistency."}
                </div>
              </div>
            </Card>
          ))}
        </div>
      </section>
    </div>
  );
}
