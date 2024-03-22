import { Badge } from "./ui/badge";
import { bloodyButtonVariants } from "./bloody-button";
import type { VariantProps } from "class-variance-authority";
import type { ComponentProps } from "react";
import { cn } from "@/lib/utils";

type CustomBadgeProps = VariantProps<typeof bloodyButtonVariants> &
  Omit<ComponentProps<typeof Badge>, "variant">;

export default function CustomBadge({
  className,
  variant,
  ...props
}: CustomBadgeProps) {
  return (
    <Badge
      {...props}
      className={cn(bloodyButtonVariants({ variant }), "px-2 py-3", className)}
    />
  );
}
