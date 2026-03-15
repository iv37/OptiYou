import type { ReactNode } from "react";
import type { Metadata, Viewport } from "next";

import "@/styles/globals.css";

export const metadata: Metadata = {
  title: "Aesthetic Optimization App",
  description: "Photo-based progress tracking, routines, and supportive recommendations.",
  appleWebApp: {
    capable: true,
    statusBarStyle: "default",
    title: "Aesthetic OS"
  },
  manifest: "/manifest.webmanifest"
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  viewportFit: "cover",
  themeColor: "#f5f1ea"
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
