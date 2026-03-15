import * as React from "react";

import { cn } from "@/lib/utils";

export function Input({ className, ...props }: React.InputHTMLAttributes<HTMLInputElement>) {
  return (
    <input
      className={cn(
        "h-12 w-full rounded-2xl border border-line bg-white/70 px-4 text-sm outline-none transition placeholder:text-muted focus:border-primary/40 focus:bg-white",
        className
      )}
      {...props}
    />
  );
}
