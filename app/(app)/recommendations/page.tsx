import { RoadmapCard } from "@/components/recommendations/roadmap-card";
import { Card } from "@/components/ui/card";
import { SectionHeading } from "@/components/ui/section-heading";
import { getDashboardData } from "@/lib/services/dashboard-service";

export default async function RecommendationsPage() {
  const data = await getDashboardData();

  return (
    <div className="space-y-6">
      <Card className="rounded-[32px] p-6 sm:p-8">
        <SectionHeading
          eyebrow="Improvement roadmap"
          title="A realistic plan built around habits that compound"
          description="The recommendation engine blends calculated targets, rule-based suggestions, and simulated AI summaries to keep the MVP useful today and replaceable tomorrow."
        />
      </Card>

      <RoadmapCard roadmap={data.roadmap} />

      <div className="grid gap-4 lg:grid-cols-2">
        <Card className="rounded-[28px]">
          <p className="text-lg font-semibold">Daily habits</p>
          <div className="mt-5 space-y-3">
            {data.roadmap.dailyHabits.map((habit) => (
              <div key={habit} className="rounded-2xl bg-white/70 px-4 py-3 text-sm leading-6 text-muted-strong">
                {habit}
              </div>
            ))}
          </div>
        </Card>
        <Card className="rounded-[28px]">
          <p className="text-lg font-semibold">Weekly habits</p>
          <div className="mt-5 space-y-3">
            {data.roadmap.weeklyHabits.map((habit) => (
              <div key={habit} className="rounded-2xl bg-white/70 px-4 py-3 text-sm leading-6 text-muted-strong">
                {habit}
              </div>
            ))}
          </div>
        </Card>
      </div>

      <div className="grid gap-4 lg:grid-cols-2">
        <Card className="rounded-[28px]">
          <p className="text-lg font-semibold">Morning routine</p>
          <div className="mt-5 space-y-3">
            {data.roadmap.morningRoutine.map((step) => (
              <div key={step.title} className="rounded-2xl border border-line bg-white/70 p-4">
                <p className="text-sm text-muted">{step.timing}</p>
                <p className="mt-1 font-medium">{step.title}</p>
                <p className="mt-2 text-sm leading-6 text-muted">{step.detail}</p>
              </div>
            ))}
          </div>
        </Card>
        <Card className="rounded-[28px]">
          <p className="text-lg font-semibold">Night routine</p>
          <div className="mt-5 space-y-3">
            {data.roadmap.nightRoutine.map((step) => (
              <div key={step.title} className="rounded-2xl border border-line bg-white/70 p-4">
                <p className="text-sm text-muted">{step.timing}</p>
                <p className="mt-1 font-medium">{step.title}</p>
                <p className="mt-2 text-sm leading-6 text-muted">{step.detail}</p>
              </div>
            ))}
          </div>
        </Card>
      </div>

      <Card className="rounded-[28px] border border-[rgba(155,77,63,0.12)] bg-[rgba(255,255,255,0.72)]">
        <p className="text-sm leading-6 text-muted">{data.roadmap.disclaimer}</p>
      </Card>
    </div>
  );
}
