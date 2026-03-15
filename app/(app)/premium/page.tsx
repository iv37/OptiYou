import Link from "next/link";
import { Check, Lock, Stars } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";

const tiers = [
  {
    name: "Free",
    price: "$0",
    features: [
      "Single active recommendation roadmap",
      "Core upload flow and saved scan history",
      "Five analysis modules with summary detail"
    ]
  },
  {
    name: "Premium",
    price: "$19/mo",
    features: [
      "Advanced comparison overlays and deeper scan history",
      "Expanded ingredient and haircut libraries",
      "Priority re-analysis and premium routines",
      "Future AI-enhanced conversational coach"
    ]
  }
];

export default function PremiumPage() {
  return (
    <div className="space-y-6">
      <Card className="rounded-[32px] border-white/70 bg-[linear-gradient(145deg,rgba(26,24,20,0.98),rgba(44,51,48,0.94))] p-6 text-background sm:p-8">
        <div className="flex items-start justify-between gap-4">
          <div>
            <p className="text-sm text-background/68">Premium-ready architecture</p>
            <h1 className="mt-3 text-3xl font-semibold tracking-tight">Unlock deeper tracking and more personalized optimization layers.</h1>
            <p className="mt-3 max-w-2xl text-sm leading-7 text-background/72">
              Payments are not wired in, but the schema, gating points, and locked UI affordances are already structured for a straightforward billing integration.
            </p>
          </div>
          <div className="rounded-full bg-white/10 px-4 py-2 text-sm font-medium">Upgrade path ready</div>
        </div>
      </Card>

      <div className="grid gap-4 lg:grid-cols-2">
        {tiers.map((tier, index) => (
          <Card key={tier.name} className="rounded-[30px]">
            <div className="flex items-start justify-between gap-4">
              <div>
                <p className="text-sm text-muted">{tier.name} plan</p>
                <p className="mt-2 text-3xl font-semibold">{tier.price}</p>
              </div>
              {index === 1 ? <Stars className="h-5 w-5 text-accent" /> : <Lock className="h-5 w-5 text-muted" />}
            </div>
            <div className="mt-6 space-y-3">
              {tier.features.map((feature) => (
                <div key={feature} className="flex items-start gap-3 rounded-2xl bg-white/70 px-4 py-3 text-sm leading-6 text-muted-strong">
                  <Check className="mt-1 h-4 w-4 text-primary" />
                  {feature}
                </div>
              ))}
            </div>
            {index === 1 ? (
              <Button className="mt-6 w-full" variant="premium">
                Join waitlist
              </Button>
            ) : (
              <Link href="/dashboard" className="mt-6 block">
                <Button className="w-full" variant="secondary">
                  Stay on free
                </Button>
              </Link>
            )}
          </Card>
        ))}
      </div>
    </div>
  );
}
