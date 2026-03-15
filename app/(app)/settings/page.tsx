import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";

export default function SettingsPage() {
  return (
    <div className="space-y-6">
      <Card className="rounded-[32px] p-6 sm:p-8">
        <p className="text-sm text-muted">Settings</p>
        <h1 className="mt-3 text-3xl font-semibold tracking-tight">Profile, privacy, and preferences</h1>
        <p className="mt-3 max-w-2xl text-sm leading-7 text-muted">
          This page is structured for real account management. The current MVP includes the UI, validation-ready inputs, and safe defaults.
        </p>
      </Card>

      <div className="grid gap-4 lg:grid-cols-2">
        <Card className="rounded-[28px]">
          <p className="text-lg font-semibold">Profile</p>
          <div className="mt-5 space-y-4">
            <div className="space-y-2">
              <label className="text-sm font-medium">Display name</label>
              <Input defaultValue="Marcus Reed" />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Email</label>
              <Input defaultValue="marcus@example.com" />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Profile notes</label>
              <Textarea defaultValue="Focused on clearer skin, a leaner face, and stronger consistency." />
            </div>
          </div>
        </Card>
        <Card className="rounded-[28px]">
          <p className="text-lg font-semibold">Preferences</p>
          <div className="mt-5 space-y-3">
            {[
              "Email reminders for weekly progress check-ins",
              "Save comparison photos for progress history",
              "Show premium locked modules in navigation",
              "Keep recommendation language conservative"
            ].map((item, index) => (
              <label key={item} className="flex items-center justify-between rounded-2xl border border-line bg-white/70 px-4 py-3 text-sm">
                <span className="pr-4">{item}</span>
                <input type="checkbox" defaultChecked={index !== 2} className="h-4 w-4 accent-[--primary]" />
              </label>
            ))}
          </div>
        </Card>
      </div>
    </div>
  );
}
