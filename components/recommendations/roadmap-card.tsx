import { Badge } from "@/components/ui/badge";
import { Card, CardDescription, CardTitle } from "@/components/ui/card";
import type { RecommendationRoadmap } from "@/types/domain";

export function RoadmapCard({ roadmap }: { roadmap: RecommendationRoadmap }) {
  return (
    <div className="grid gap-4 lg:grid-cols-2">
      <Card className="rounded-[28px]">
        <Badge>Top priorities</Badge>
        <CardTitle className="mt-4">What moves the needle first</CardTitle>
        <div className="mt-5 space-y-3">
          {roadmap.topPriorities.map((item) => (
            <div key={item} className="rounded-2xl bg-white/70 px-4 py-3 text-sm leading-6 text-muted-strong">
              {item}
            </div>
          ))}
        </div>
      </Card>
      <Card className="rounded-[28px]">
        <Badge>Timeline</Badge>
        <CardTitle className="mt-4">Expected progress windows</CardTitle>
        <div className="mt-5 space-y-3">
          {roadmap.timeline.map((item) => (
            <div key={item.label} className="rounded-2xl border border-line bg-white/70 p-4">
              <p className="text-sm font-medium">{item.label}</p>
              <CardDescription className="mt-1">{item.expectation}</CardDescription>
            </div>
          ))}
        </div>
      </Card>
    </div>
  );
}
