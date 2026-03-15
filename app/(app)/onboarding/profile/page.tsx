import Link from "next/link";

import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";

export default function ProfileSetupPage() {
  return (
    <div className="space-y-6">
      <Card className="rounded-[32px] p-6 sm:p-8">
        <p className="text-sm text-muted">Profile setup</p>
        <h1 className="mt-3 text-3xl font-semibold tracking-tight">Add your baseline details and lifestyle context.</h1>
        <div className="mt-8 grid gap-6 lg:grid-cols-2">
          <div className="space-y-4">
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-2">
                <label className="text-sm font-medium">Age</label>
                <Input defaultValue="24" />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Gender</label>
                <Input defaultValue="Male" />
              </div>
            </div>
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-2">
                <label className="text-sm font-medium">Height (cm)</label>
                <Input defaultValue="180" />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Weight (kg)</label>
                <Input defaultValue="78" />
              </div>
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Skin profile</label>
              <Textarea defaultValue="Combination skin with mild redness and occasional congestion." />
            </div>
          </div>
          <div className="space-y-4">
            <div className="space-y-2">
              <label className="text-sm font-medium">Hair profile</label>
              <Textarea defaultValue="Medium thickness, short length, slight temple recession, dry scalp." />
            </div>
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-2">
                <label className="text-sm font-medium">Sleep</label>
                <Input defaultValue="6.7" />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Hydration</label>
                <Input defaultValue="2.1" />
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
          <Link href="/onboarding">
            <Button>Review onboarding</Button>
          </Link>
        </div>
      </Card>
    </div>
  );
}
