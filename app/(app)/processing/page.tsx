import Link from "next/link";

import { Progress } from "@/components/ui/progress";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";

export default function ProcessingPage() {
  return (
    <div className="mx-auto max-w-3xl">
      <Card className="rounded-[32px] p-6 text-center sm:p-10">
        <p className="text-sm text-muted">Processing state</p>
        <h1 className="mt-3 text-3xl font-semibold tracking-tight">Building your current analysis snapshot</h1>
        <p className="mx-auto mt-4 max-w-xl text-sm leading-7 text-muted">
          The MVP simulates an analysis job pipeline. In production this route can poll background tasks for image preprocessing, CV inference, and recommendation generation.
        </p>
        <div className="mx-auto mt-10 max-w-xl space-y-4">
          <div className="flex justify-between text-sm text-muted">
            <span>Photo validation</span>
            <span>Complete</span>
          </div>
          <Progress value={100} />
          <div className="flex justify-between text-sm text-muted">
            <span>Feature extraction</span>
            <span>74%</span>
          </div>
          <Progress value={74} />
          <div className="flex justify-between text-sm text-muted">
            <span>Recommendation assembly</span>
            <span>52%</span>
          </div>
          <Progress value={52} />
        </div>
        <div className="mt-10 flex justify-center">
          <Link href="/dashboard">
            <Button>Open dashboard</Button>
          </Link>
        </div>
      </Card>
    </div>
  );
}
