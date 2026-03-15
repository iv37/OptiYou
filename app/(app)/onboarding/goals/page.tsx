import Link from "next/link";

import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";

const goals = [
  {
    title: "Clearer skin",
    detail: "Reduce congestion, redness, or texture with a sustainable routine."
  },
  {
    title: "Hair health",
    detail: "Improve density presentation, scalp condition, and haircut direction."
  },
  {
    title: "Leaner face",
    detail: "Reduce puffiness through recovery, hydration, and body composition improvements."
  },
  {
    title: "Body recomposition",
    detail: "Build a more athletic look without extreme dieting or rebound habits."
  },
  {
    title: "Stronger grooming",
    detail: "Upgrade haircut, facial hair, eyebrows, and skin presentation."
  },
  {
    title: "Consistency",
    detail: "Build routines that hold up across school, work, and training weeks."
  }
];

export default function GoalSelectionPage() {
  return (
    <div className="space-y-6">
      <Card className="rounded-[32px] p-6 sm:p-8">
        <p className="text-sm text-muted">Goal selection</p>
        <h1 className="mt-3 text-3xl font-semibold tracking-tight">Choose the outcomes that matter most right now.</h1>
        <div className="mt-8 grid gap-4 lg:grid-cols-2">
          {goals.map((goal) => (
            <label key={goal.title} className="rounded-[28px] border border-line bg-white/70 p-5">
              <div className="flex items-start gap-3">
                <input type="checkbox" defaultChecked className="mt-1 h-4 w-4 accent-[--primary]" />
                <div>
                  <p className="font-medium">{goal.title}</p>
                  <p className="mt-2 text-sm leading-6 text-muted">{goal.detail}</p>
                </div>
              </div>
            </label>
          ))}
        </div>
        <div className="mt-8 flex justify-end">
          <Link href="/onboarding/profile">
            <Button>Continue</Button>
          </Link>
        </div>
      </Card>
    </div>
  );
}
