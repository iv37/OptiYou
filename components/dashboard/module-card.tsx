import Link from "next/link";
import { ArrowUpRight } from "lucide-react";

import { Badge } from "@/components/ui/badge";
import { Card, CardDescription, CardTitle } from "@/components/ui/card";
import type { ModuleSummary } from "@/types/domain";

export function ModuleCard({ module }: { module: ModuleSummary }) {
  return (
    <Link href={`/analysis/${module.slug}`}>
      <Card className="h-full rounded-[28px] transition hover:-translate-y-0.5 hover:bg-white/86">
        <div className="flex items-start justify-between gap-4">
          <div>
            <Badge>{module.priority} priority</Badge>
            <CardTitle className="mt-4">{module.title}</CardTitle>
            <p className="mt-2 text-sm font-medium text-foreground">{module.scoreLabel}</p>
          </div>
          <ArrowUpRight className="h-5 w-5 text-muted" />
        </div>
        <CardDescription className="mt-4">{module.summary}</CardDescription>
        <div className="mt-5 space-y-2">
          {module.highlights.map((highlight) => (
            <div key={highlight} className="rounded-2xl bg-white/70 px-3 py-2 text-sm text-muted-strong">
              {highlight}
            </div>
          ))}
        </div>
      </Card>
    </Link>
  );
}
