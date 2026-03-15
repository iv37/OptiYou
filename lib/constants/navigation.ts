import {
  Camera,
  Crown,
  Gauge,
  LineChart,
  Settings,
  Sparkles
} from "lucide-react";

export const appNavigation = [
  {
    href: "/dashboard",
    label: "Dashboard",
    icon: Gauge
  },
  {
    href: "/upload",
    label: "Upload",
    icon: Camera
  },
  {
    href: "/progress",
    label: "Progress",
    icon: LineChart
  },
  {
    href: "/recommendations",
    label: "Plan",
    icon: Sparkles
  },
  {
    href: "/premium",
    label: "Premium",
    icon: Crown
  },
  {
    href: "/settings",
    label: "Settings",
    icon: Settings
  }
] as const;
