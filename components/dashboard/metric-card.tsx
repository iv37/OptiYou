import { ArrowUpRight } from "lucide-react";

import { Card } from "@/components/ui/card";

export function MetricCard({
  label,
  value,
  detail
}: {
  label: string;
  value: string;
  detail: string;
}) {
  return (
    <Card className="rounded-[24px]">
      <p className="text-sm text-muted">{label}</p>
      <div className="mt-4 flex items-end justify-between gap-3">
        <p className="text-3xl font-semibold tracking-tight">{value}</p>
        <ArrowUpRight className="h-5 w-5 text-primary" />
      </div>
      <p className="mt-3 text-sm leading-6 text-muted">{detail}</p>
    </Card>
  );
}
