"use client";

import type { ReactNode } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";

import { appNavigation } from "@/lib/constants/navigation";
import { cn, initials } from "@/lib/utils";

export function AppShell({
  children,
  userName
}: {
  children: ReactNode;
  userName: string;
}) {
  const pathname = usePathname();

  return (
    <div className="mx-auto flex min-h-screen max-w-7xl gap-6 px-3 py-3 sm:px-6 lg:px-8">
      <aside className="glass-panel hidden w-72 shrink-0 rounded-[32px] border border-white/60 p-5 lg:flex lg:flex-col">
        <Link href="/dashboard" className="flex items-center gap-3">
          <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-foreground text-sm font-semibold text-background">
            AO
          </div>
          <div>
            <p className="text-sm text-muted">Aesthetic Optimization</p>
            <p className="font-semibold">Personal dashboard</p>
          </div>
        </Link>
        <nav className="mt-8 space-y-1">
          {appNavigation.map((item) => {
            const active = pathname === item.href || pathname.startsWith(`${item.href}/`);
            const Icon = item.icon;

            return (
              <Link
                key={item.href}
                href={item.href}
                className={cn(
                  "flex items-center gap-3 rounded-2xl px-4 py-3 text-sm transition",
                  active ? "bg-foreground text-background" : "text-muted-strong hover:bg-white/70"
                )}
              >
                <Icon className="h-4 w-4" />
                {item.label}
              </Link>
            );
          })}
        </nav>
        <div className="mt-auto rounded-[28px] border border-line bg-white/60 p-4">
          <p className="text-sm font-medium">Informational guidance</p>
          <p className="mt-2 text-sm leading-6 text-muted">
            Results combine calculations, rule-based logic, and simulated AI summaries. They are not medical diagnoses.
          </p>
        </div>
      </aside>
      <div className="mx-auto flex w-full max-w-[460px] flex-1 flex-col lg:max-w-[430px]">
        <div className="iphone-shell min-h-[100dvh] px-3 pb-3 pt-8 sm:px-4">
          <header className="iphone-safe-top glass-panel sticky top-0 z-20 flex items-center justify-between rounded-[28px] border border-white/60 px-4 py-4">
            <div>
              <p className="text-[10px] uppercase tracking-[0.24em] text-muted">iPhone app</p>
              <p className="text-lg font-semibold">Steady progress</p>
            </div>
            <div className="flex items-center gap-3">
              <div className="text-right">
                <p className="text-sm font-medium">{userName}</p>
                <p className="text-xs text-muted">Demo account</p>
              </div>
              <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-primary text-sm font-semibold text-primary-foreground">
                {initials(userName)}
              </div>
            </div>
          </header>
          <main className="space-y-4 px-1 pb-28 pt-4">{children}</main>
          <nav className="iphone-safe-bottom glass-panel fixed inset-x-3 bottom-3 z-30 mx-auto flex w-[calc(100%-1.5rem)] max-w-[436px] items-center justify-between rounded-[28px] border border-white/60 p-2 lg:inset-x-auto">
            {appNavigation.slice(0, 5).map((item) => {
              const Icon = item.icon;
              const active = pathname === item.href || pathname.startsWith(`${item.href}/`);

              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={cn(
                    "flex min-w-14 flex-1 flex-col items-center rounded-2xl px-2 py-2 text-[11px]",
                    active ? "bg-foreground text-background" : "text-muted-strong"
                  )}
                >
                  <Icon className="mb-1 h-4 w-4" />
                  {item.label}
                </Link>
              );
            })}
          </nav>
        </div>
        <div className="mt-4 hidden rounded-[28px] border border-line bg-white/60 p-4 text-sm leading-6 text-muted lg:block">
          Results combine calculations, rule-based guidance, and simulated AI summaries. They are informational and not medical diagnoses.
        </div>
      </div>
      <div className="hidden flex-1 lg:block">
        <div className="sticky top-8 rounded-[36px] border border-white/60 bg-[linear-gradient(180deg,rgba(255,255,255,0.62),rgba(255,255,255,0.3))] p-6 shadow-[0_24px_80px_rgba(31,25,18,0.08)]">
          <p className="text-sm text-muted">Native-style framing</p>
          <p className="mt-2 text-2xl font-semibold tracking-tight">This build is optimized as an iPhone-first product surface.</p>
          <p className="mt-3 text-sm leading-7 text-muted">
            The primary canvas is constrained to a phone-sized viewport with safe-area padding, bottom-tab navigation, and installable web-app metadata. Desktop keeps the same phone shell rather than expanding into a generic admin layout.
          </p>
          <div className="mt-6 space-y-3">
            {[
              "Phone-width content rhythm",
              "Persistent bottom tab bar",
              "Safe-area-aware spacing",
              "Apple web app metadata"
            ].map((item) => (
              <div key={item} className="rounded-2xl bg-white/70 px-4 py-3 text-sm text-muted-strong">
                {item}
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
