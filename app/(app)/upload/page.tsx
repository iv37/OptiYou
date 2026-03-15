import Link from "next/link";
import { ImagePlus, ShieldAlert } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { getDashboardData } from "@/lib/services/dashboard-service";
import { formatDate } from "@/lib/utils";

export default async function UploadPage() {
  const data = await getDashboardData();

  return (
    <div className="space-y-6">
      <Card className="rounded-[32px] p-6 sm:p-8">
        <div className="grid gap-8 lg:grid-cols-[1fr_0.8fr]">
          <div className="space-y-4">
            <p className="text-sm text-muted">Photo upload flow</p>
            <h1 className="text-3xl font-semibold tracking-tight">Upload a new scan set with consistent lighting and angles.</h1>
            <p className="max-w-2xl text-sm leading-7 text-muted">
              The MVP saves a front face, side face, skin close-up, and hairline photo. The storage layer is abstracted so local demo uploads can later be replaced with cloud-backed signed uploads.
            </p>
            <div className="grid gap-4 sm:grid-cols-2">
              {[
                "Front face",
                "Side face",
                "Skin close-up",
                "Hairline"
              ].map((label) => (
                <label key={label} className="flex min-h-40 flex-col items-center justify-center rounded-[28px] border border-dashed border-line bg-white/65 p-5 text-center">
                  <ImagePlus className="h-7 w-7 text-primary" />
                  <p className="mt-4 font-medium">{label}</p>
                  <p className="mt-2 text-sm leading-6 text-muted">Tap to upload or drag a file here.</p>
                </label>
              ))}
            </div>
            <div className="rounded-[28px] border border-line bg-accent-soft/60 p-4 text-sm leading-6 text-muted-strong">
              <div className="flex items-start gap-3">
                <ShieldAlert className="mt-0.5 h-5 w-5 text-primary" />
                <p>
                  Keep the same mirror distance and overhead lighting each time. Progress comparisons only become useful when the input conditions stay stable.
                </p>
              </div>
            </div>
            <Link href="/processing">
              <Button>Process scan set</Button>
            </Link>
          </div>
          <Card className="rounded-[30px] bg-white/78">
            <p className="text-sm text-muted">Most recent uploads</p>
            <div className="mt-5 space-y-3">
              {data.uploads.map((asset) => (
                <div key={asset.id} className="flex items-center justify-between rounded-2xl border border-line bg-white/70 px-4 py-3">
                  <div>
                    <p className="font-medium">{asset.label}</p>
                    <p className="text-sm text-muted">{formatDate(asset.capturedAt)}</p>
                  </div>
                  <div className="rounded-full bg-accent-soft px-3 py-1 text-xs font-medium text-primary">{asset.status}</div>
                </div>
              ))}
            </div>
          </Card>
        </div>
      </Card>
    </div>
  );
}
