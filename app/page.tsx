import Link from "next/link";
import {
  Activity,
  Camera,
  ChartSpline,
  CheckCircle2,
  Shield,
  Sparkles
} from "lucide-react";

import { MarketingShell } from "@/components/layout/marketing-shell";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

const features = [
  {
    icon: Camera,
    title: "Structured photo review",
    detail: "Front, side, skin, and hairline uploads with processing states and saved history."
  },
  {
    icon: Activity,
    title: "Lifestyle-aware analysis",
    detail: "Recommendations consider sleep, hydration, exercise, diet quality, and grooming habits."
  },
  {
    icon: ChartSpline,
    title: "Progress that compounds",
    detail: "Track routines, visual changes, and metrics over time instead of chasing one-off judgments."
  },
  {
    icon: Shield,
    title: "Supportive and responsible",
    detail: "Guidance stays informational, conservative, and free of degrading appearance scoring."
  }
];

export default function LandingPage() {
  return (
    <MarketingShell>
      <section className="hero-grid relative mt-4 overflow-hidden rounded-[36px] border border-white/60 px-6 py-16 shadow-[0_24px_80px_rgba(31,25,18,0.1)] sm:px-10 lg:px-14 lg:py-20">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_right,rgba(29,77,67,0.16),transparent_28%)]" />
        <div className="relative grid gap-10 lg:grid-cols-[1.1fr_0.9fr] lg:items-end">
          <div className="space-y-6">
            <Badge>Progress-first aesthetic optimization</Badge>
            <div className="space-y-5">
              <h1 className="max-w-3xl text-balance text-4xl font-semibold tracking-tight sm:text-5xl lg:text-6xl">
                Improve presentation, routines, and consistency with a calmer kind of analysis.
              </h1>
              <p className="max-w-2xl text-base leading-7 text-muted sm:text-lg">
                A premium personal dashboard for skincare, hair health, body composition, and lifestyle upgrades.
                Built around supportive guidance, practical routines, and measurable progress.
              </p>
            </div>
            <div className="flex flex-col gap-3 sm:flex-row">
              <Link href="/auth/sign-up">
                <Button size="lg">Create account</Button>
              </Link>
              <Link href="/dashboard">
                <Button size="lg" variant="secondary">
                  Explore demo dashboard
                </Button>
              </Link>
            </div>
            <div className="grid gap-3 sm:grid-cols-3">
              {[
                "Calculated body composition targets",
                "Rule-based routines and priorities",
                "Simulated AI summaries behind replaceable services"
              ].map((item) => (
                <div key={item} className="flex items-start gap-2 text-sm text-muted-strong">
                  <CheckCircle2 className="mt-0.5 h-4 w-4 text-primary" />
                  <span>{item}</span>
                </div>
              ))}
            </div>
          </div>
          <Card className="rounded-[32px] border-white/70 bg-[linear-gradient(180deg,rgba(255,255,255,0.88),rgba(247,241,232,0.88))] p-6">
            <div className="space-y-6">
              <div className="rounded-[28px] bg-foreground p-5 text-background">
                <div className="flex items-center justify-between">
                  <p className="text-sm text-background/70">This week’s priorities</p>
                  <Sparkles className="h-4 w-4" />
                </div>
                <div className="mt-4 space-y-3">
                  <div className="rounded-2xl bg-white/8 p-4">
                    <p className="font-medium">Sleep regularity</p>
                    <p className="mt-1 text-sm text-background/72">Move from 6.7 to 7.5 hours to reduce puffiness and improve recovery.</p>
                  </div>
                  <div className="rounded-2xl bg-white/8 p-4">
                    <p className="font-medium">Barrier-first skincare</p>
                    <p className="mt-1 text-sm text-background/72">Calm irritation by simplifying actives for the next 21 days.</p>
                  </div>
                </div>
              </div>
              <div className="grid gap-3 sm:grid-cols-2">
                <div className="rounded-[24px] border border-line bg-white/80 p-4">
                  <p className="text-sm text-muted">Progress trend</p>
                  <p className="mt-2 text-3xl font-semibold">+14%</p>
                  <p className="mt-1 text-sm text-muted">Hydration and grooming adherence improved over 8 weeks.</p>
                </div>
                <div className="rounded-[24px] border border-line bg-white/80 p-4">
                  <p className="text-sm text-muted">Analysis coverage</p>
                  <p className="mt-2 text-3xl font-semibold">5 modules</p>
                  <p className="mt-1 text-sm text-muted">Facial, skin, hair, body, and lifestyle are tracked in one flow.</p>
                </div>
              </div>
            </div>
          </Card>
        </div>
      </section>

      <section className="mt-8 grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        {features.map((feature) => {
          const Icon = feature.icon;
          return (
            <Card key={feature.title} className="h-full">
              <CardHeader>
                <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-accent-soft text-primary">
                  <Icon className="h-5 w-5" />
                </div>
              </CardHeader>
              <CardTitle className="mt-5">{feature.title}</CardTitle>
              <CardDescription className="mt-2">{feature.detail}</CardDescription>
            </Card>
          );
        })}
      </section>
    </MarketingShell>
  );
}
