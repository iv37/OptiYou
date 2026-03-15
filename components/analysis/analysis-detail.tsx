import Link from "next/link";
import { ArrowRight, Lock } from "lucide-react";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardDescription, CardTitle } from "@/components/ui/card";
import type { ModuleSummary, RecommendationRoadmap } from "@/types/domain";

export function AnalysisDetail({
  module,
  headline,
  explanation,
  bullets,
  routines,
  roadmap,
  locked
}: {
  module: ModuleSummary;
  headline: string;
  explanation: string;
  bullets: string[];
  routines: Array<{ title: string; detail: string }>;
  roadmap: RecommendationRoadmap;
  locked?: boolean;
}) {
  return (
    <div className="space-y-6">
      <Card className="rounded-[32px] p-6 sm:p-8">
        <div className="grid gap-6 lg:grid-cols-[1.1fr_0.9fr]">
          <div>
            <Badge>{module.priority} priority</Badge>
            <h1 className="mt-4 text-3xl font-semibold tracking-tight sm:text-4xl">{module.title}</h1>
            <p className="mt-3 text-lg font-medium text-foreground">{headline}</p>
            <p className="mt-4 max-w-2xl text-sm leading-7 text-muted">{explanation}</p>
          </div>
          <Card className="rounded-[28px] bg-white/70">
            <p className="text-sm text-muted">Model note</p>
            <p className="mt-3 text-sm leading-7 text-muted-strong">
              This module mixes clearly calculated outputs, rule-based guidance, and simulated AI phrasing. It is designed so the simulated layer can later be swapped for model-backed services without changing UI contracts.
            </p>
          </Card>
        </div>
      </Card>
      <div className="grid gap-4 lg:grid-cols-2">
        <Card className="rounded-[28px]">
          <CardTitle>Key observations</CardTitle>
          <div className="mt-5 space-y-3">
            {bullets.map((item) => (
              <div key={item} className="rounded-2xl bg-white/70 px-4 py-3 text-sm leading-6 text-muted-strong">
                {item}
              </div>
            ))}
          </div>
        </Card>
        <Card className="rounded-[28px]">
          <CardTitle>Recommended routine</CardTitle>
          <div className="mt-5 space-y-3">
            {routines.map((item) => (
              <div key={item.title} className="rounded-2xl border border-line bg-white/70 p-4">
                <p className="font-medium">{item.title}</p>
                <CardDescription className="mt-1">{item.detail}</CardDescription>
              </div>
            ))}
          </div>
        </Card>
      </div>
      <Card className="rounded-[28px]">
        <div className="flex items-center justify-between gap-4">
          <div>
            <CardTitle>Roadmap tie-in</CardTitle>
            <CardDescription className="mt-2">
              This module’s recommendations are reflected in the broader improvement roadmap.
            </CardDescription>
          </div>
          {locked ? (
            <Link href="/premium">
              <Button variant="premium">
                Unlock advanced comparisons
                <Lock className="ml-2 h-4 w-4" />
              </Button>
            </Link>
          ) : (
            <Link href="/recommendations">
              <Button variant="secondary">
                Open full roadmap
                <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
            </Link>
          )}
        </div>
        <div className="mt-5 grid gap-3 sm:grid-cols-3">
          {roadmap.topPriorities.map((item) => (
            <div key={item} className="rounded-2xl bg-white/70 px-4 py-3 text-sm leading-6 text-muted-strong">
              {item}
            </div>
          ))}
        </div>
      </Card>
    </div>
  );
}
