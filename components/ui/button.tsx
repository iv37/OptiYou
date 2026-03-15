import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";

import { cn } from "@/lib/utils";

const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-full text-sm font-medium transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary/30 disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        primary: "bg-primary px-5 py-3 text-primary-foreground shadow-[0_14px_30px_rgba(29,77,67,0.22)] hover:bg-primary/92",
        secondary: "border border-line bg-white/70 px-5 py-3 text-foreground hover:bg-white",
        ghost: "px-4 py-2 text-muted-strong hover:bg-white/70",
        premium: "bg-foreground px-5 py-3 text-background hover:bg-foreground/92"
      },
      size: {
        default: "",
        sm: "px-3 py-2 text-xs",
        lg: "px-6 py-3.5 text-base"
      }
    },
    defaultVariants: {
      variant: "primary",
      size: "default"
    }
  }
);

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {}

export function Button({ className, variant, size, ...props }: ButtonProps) {
  return <button className={cn(buttonVariants({ variant, size, className }))} {...props} />;
}
