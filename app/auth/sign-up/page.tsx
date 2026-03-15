import Link from "next/link";

import { MarketingShell } from "@/components/layout/marketing-shell";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";

export default function SignUpPage() {
  return (
    <MarketingShell>
      <div className="mx-auto mt-8 max-w-md">
        <Card className="p-6 sm:p-8">
          <div className="space-y-2">
            <p className="text-sm text-muted">Start free</p>
            <h1 className="text-3xl font-semibold tracking-tight">Create your account</h1>
            <p className="text-sm leading-6 text-muted">
              The MVP includes a complete auth-ready surface and demo routing. Production auth can be enabled with Supabase keys and server actions.
            </p>
          </div>
          <form className="mt-8 space-y-4">
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-2">
                <label className="text-sm font-medium">First name</label>
                <Input placeholder="Marcus" />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Last name</label>
                <Input placeholder="Reed" />
              </div>
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Email</label>
              <Input type="email" placeholder="you@example.com" />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Password</label>
              <Input type="password" placeholder="Create a password" />
            </div>
            <Link href="/onboarding" className="block">
              <Button className="w-full">Continue to onboarding</Button>
            </Link>
          </form>
          <p className="mt-6 text-sm text-muted">
            Already have an account?{" "}
            <Link href="/auth/sign-in" className="font-medium text-foreground">
              Sign in
            </Link>
          </p>
        </Card>
      </div>
    </MarketingShell>
  );
}
