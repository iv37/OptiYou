import Link from "next/link";

import { ModuleCard } from "@/components/dashboard/module-card";
import { MetricCard } from "@/components/dashboard/metric-card";
import { RoadmapCard } from "@/components/recommendations/roadmap-card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { SectionHeading } from "@/components/ui/section-heading";
import { getDashboardData } from "@/lib/services/dashboard-service";
import { formatDate } from "@/lib/utils";

export default async function DashboardPage() {
  const data = await getDashboardData();

  return (
    <div className="space-y-6">
      <Card className="overflow-hidden rounded-[32px] border-white/70 bg-[linear-gradient(140deg,rgba(24,22,18,0.96),rgba(39,66,58,0.92))] p-6 text-background sm:p-8">
        <div className="grid gap-8 lg:grid-cols-[1.1fr_0.9fr]">
          <div className="space-y-5">
            <Badge className="border-white/15 bg-white/10 text-background">Current dashboard</Badge>
            <div className="space-y-3">
              <h1 className="text-3xl font-semibold tracking-tight sm:text-4xl">Your current priorities are consistency, calm skin, and sharper structure.</h1>
              <p className="max-w-2xl text-sm leading-7 text-background/74 sm:text-base">
                The current plan favors habits that improve presentation steadily: cleaner recovery, less routine friction, and better framing through grooming.
              </p>
            </div>
            <div className="flex flex-col gap-3 sm:flex-row">
              <Link href="/upload">
                <Button>Upload new scan</Button>
              </Link>
              <Link href="/recommendations">
                <Button variant="secondary">Open improvement plan</Button>
              </Link>
            </div>
          </div>
          <div className="grid gap-3 sm:grid-cols-2">
            <div className="rounded-[28px] bg-white/8 p-5">
              <p className="text-sm text-background/68">Latest scan set</p>
              <p className="mt-3 text-3xl font-semibold">{formatDate(data.uploads[0].capturedAt)}</p>
              <p className="mt-2 text-sm text-background/68">Front, side, skin, and hairline coverage saved.</p>
            </div>
            <div className="rounded-[28px] bg-white/8 p-5">
              <p className="text-sm text-background/68">Plan tier</p>
              <p className="mt-3 text-3xl font-semibold">{data.profile.plan}</p>
              <p className="mt-2 text-sm text-background/68">Advanced comparisons and deeper AI layers are premium-ready.</p>
            </div>
          </div>
        </div>
      </Card>

      <section className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <MetricCard label="Estimated body fat" value={`${data.profile.bodyFatEstimate}%`} detail="Calculated from the current demo profile and used for calorie and macro guidance." />
        <MetricCard label="Sleep average" value={`${data.profile.sleepHours}h`} detail="Recovery is the main appearance multiplier in the current plan." />
        <MetricCard label="Hydration" value={`${data.profile.hydrationLiters}L`} detail="Raising consistency here should improve energy, skin calmness, and training recovery." />
        <MetricCard label="Exercise frequency" value={`${data.profile.exerciseDays} days`} detail="Strong baseline. Nutrition precision is now more important than adding extra sessions." />
      </section>

      <section className="space-y-4">
        <SectionHeading
          eyebrow="Priority stack"
          title="What to focus on next"
          description="These priorities combine calculated targets, rule-based heuristics, and simulated AI summaries designed to be replaceable later."
        />
        <div className="grid gap-4 lg:grid-cols-3">
          {data.priorities.map((priority) => (
            <Card key={priority.title} className="rounded-[28px]">
              <p className="text-sm text-muted">{priority.module}</p>
              <p className="mt-3 text-xl font-semibold tracking-tight">{priority.title}</p>
              <p className="mt-3 text-sm leading-6 text-muted">{priority.detail}</p>
            </Card>
          ))}
        </div>
      </section>

      <section className="space-y-4">
        <SectionHeading
          eyebrow="Analysis modules"
          title="Detailed breakdowns"
          description="Each module isolates the main opportunities so the dashboard stays focused while still giving you drill-down depth."
        />
        <div className="grid gap-4 lg:grid-cols-2 xl:grid-cols-3">
          {data.modules.map((module) => (
            <ModuleCard key={module.id} module={module} />
          ))}
        </div>
      </section>

      <section className="space-y-4">
        <SectionHeading
          eyebrow="Roadmap preview"
          title="Structured next steps"
          description="The roadmap keeps your plan realistic, incremental, and framed around routine quality rather than cosmetic extremes."
        />
        <RoadmapCard roadmap={data.roadmap} />
      </section>
    </div>
  );
}
