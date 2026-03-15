import Link from "next/link";

import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";

const goals = [
  "Clearer skin",
  "Hair health",
  "Leaner face",
  "Body recomposition",
  "Stronger grooming",
  "Better consistency"
];

export default function OnboardingPage() {
  return (
    <div className="space-y-6">
      <Card className="rounded-[32px] p-6 sm:p-8">
        <div className="flex items-center justify-between gap-4">
          <div>
            <p className="text-sm text-muted">Onboarding wizard</p>
            <h1 className="mt-2 text-3xl font-semibold tracking-tight">Set up your profile and starting priorities</h1>
          </div>
          <div className="rounded-full bg-accent-soft px-4 py-2 text-sm font-medium text-primary">Step 1 of 4</div>
        </div>
        <div className="mt-8 grid gap-6 lg:grid-cols-2">
          <div className="space-y-4">
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-2">
                <label className="text-sm font-medium">Age</label>
                <Input type="number" defaultValue="24" />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Gender</label>
                <Input defaultValue="Male" />
              </div>
            </div>
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-2">
                <label className="text-sm font-medium">Height (cm)</label>
                <Input type="number" defaultValue="180" />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Weight (kg)</label>
                <Input type="number" defaultValue="78" />
              </div>
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Current goals</label>
              <div className="grid gap-3 sm:grid-cols-2">
                {goals.map((goal) => (
                  <label key={goal} className="flex items-center gap-3 rounded-2xl border border-line bg-white/70 px-4 py-3 text-sm">
                    <input type="checkbox" defaultChecked className="h-4 w-4 accent-[--primary]" />
                    {goal}
                  </label>
                ))}
              </div>
            </div>
          </div>
          <div className="space-y-4">
            <div className="space-y-2">
              <label className="text-sm font-medium">Skin type and concerns</label>
              <Textarea defaultValue="Combination skin. Main concerns are mild redness, cheek texture, and occasional congestion after workouts." />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Hair profile</label>
              <Textarea defaultValue="Medium thickness, short textured crop. Slight temple recession and some dryness at the scalp." />
            </div>
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-2">
                <label className="text-sm font-medium">Sleep average</label>
                <Input defaultValue="6.7 hours" />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Hydration</label>
                <Input defaultValue="2.1 liters" />
              </div>
            </div>
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-2">
                <label className="text-sm font-medium">Exercise days</label>
                <Input defaultValue="4" />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Diet quality</label>
                <Input defaultValue="Decent" />
              </div>
            </div>
          </div>
        </div>
        <div className="mt-8 flex justify-end">
          <Link href="/upload">
            <Button>Save and continue</Button>
          </Link>
        </div>
      </Card>
    </div>
  );
}
