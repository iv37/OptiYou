import Link from "next/link";

import { MarketingShell } from "@/components/layout/marketing-shell";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";

export default function SignInPage() {
  return (
    <MarketingShell>
      <div className="mx-auto mt-8 max-w-md">
        <Card className="p-6 sm:p-8">
          <div className="space-y-2">
            <p className="text-sm text-muted">Welcome back</p>
            <h1 className="text-3xl font-semibold tracking-tight">Sign in</h1>
            <p className="text-sm leading-6 text-muted">
              Supabase Auth is the intended production path. This screen is demo-ready and can be connected by replacing the auth service adapter.
            </p>
          </div>
          <form className="mt-8 space-y-4">
            <div className="space-y-2">
              <label className="text-sm font-medium">Email</label>
              <Input type="email" placeholder="you@example.com" defaultValue="marcus@example.com" />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Password</label>
              <Input type="password" placeholder="••••••••" defaultValue="password123" />
            </div>
            <Link href="/dashboard" className="block">
              <Button className="w-full">Continue to dashboard</Button>
            </Link>
          </form>
          <p className="mt-6 text-sm text-muted">
            Need an account?{" "}
            <Link href="/auth/sign-up" className="font-medium text-foreground">
              Create one
            </Link>
          </p>
        </Card>
      </div>
    </MarketingShell>
  );
}
