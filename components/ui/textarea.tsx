import * as React from "react";

import { cn } from "@/lib/utils";

export function Textarea({
  className,
  ...props
}: React.TextareaHTMLAttributes<HTMLTextAreaElement>) {
  return (
    <textarea
      className={cn(
        "min-h-28 w-full rounded-3xl border border-line bg-white/70 px-4 py-3 text-sm outline-none transition placeholder:text-muted focus:border-primary/40 focus:bg-white",
        className
      )}
      {...props}
    />
  );
}
