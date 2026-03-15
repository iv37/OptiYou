"use client";

import { useEffect } from "react";

import { Button } from "@/components/ui/button";

export default function Error({
  error,
  reset
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error(error);
  }, [error]);

  return (
    <div className="flex min-h-screen items-center justify-center px-6">
      <div className="glass-panel max-w-md rounded-[32px] border border-white/60 p-8 text-center">
        <p className="text-sm text-muted">Something interrupted the flow</p>
        <h1 className="mt-3 text-2xl font-semibold tracking-tight">The app hit an unexpected error.</h1>
        <p className="mt-3 text-sm leading-6 text-muted">
          Try the action again. If this persists in production, the failure should be captured in app monitoring.
        </p>
        <Button className="mt-6" onClick={reset}>
          Retry
        </Button>
      </div>
    </div>
  );
}
