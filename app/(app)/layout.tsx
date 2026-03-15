import type { ReactNode } from "react";
import { AppShell } from "@/components/layout/app-shell";
import { demoDashboardData } from "@/lib/data/demo-data";

export default function InternalLayout({ children }: { children: ReactNode }) {
  return <AppShell userName={demoDashboardData.profile.name}>{children}</AppShell>;
}
