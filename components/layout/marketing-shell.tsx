import type { ReactNode } from "react";
import Link from "next/link";

export function MarketingShell({ children }: { children: ReactNode }) {
  return (
    <div className="min-h-screen px-4 py-4 sm:px-6 lg:px-8">
      <div className="mx-auto max-w-7xl">
        <header className="glass-panel flex items-center justify-between rounded-[28px] border border-white/60 px-5 py-4">
          <Link href="/" className="flex items-center gap-3">
            <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-foreground text-sm font-semibold text-background">
              AO
            </div>
            <div>
              <p className="text-sm text-muted">Aesthetic Optimization</p>
              <p className="font-semibold">Supportive progress platform</p>
            </div>
          </Link>
          <div className="flex items-center gap-3">
            <Link href="/auth/sign-in" className="text-sm text-muted-strong">
              Sign in
            </Link>
            <Link
              href="/auth/sign-up"
              className="rounded-full bg-foreground px-5 py-3 text-sm font-medium text-background"
            >
              Start free
            </Link>
          </div>
        </header>
        {children}
      </div>
    </div>
  );
}
