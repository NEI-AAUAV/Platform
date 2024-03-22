import { type ComponentProps, useState } from "react";
import { Button } from "./ui/button";
import { cn } from "@/lib/utils";
import Blood from "./blood";
import { cva, type VariantProps } from "class-variance-authority";

type BloodyButtonProps = VariantProps<typeof bloodyButtonVariants> & {
  blood?: boolean;
} & Omit<ComponentProps<typeof Button>, "variant" | "size">;

const bloodyButtonVariants = cva("rounded-3xl px-3 py-2 font-bold", {
  variants: {
    variant: {
      default: "bg-white/95 text-black/95 hover:bg-white/80",
      primary: "bg-[#dc2625] text-white hover:bg-[#dc2625]/60",
      neutral: "bg-white/20 text-white/60 hover:bg-white/10",
    },
  },
  defaultVariants: {
    variant: "default",
  },
});

function BloodyButton({
  className,
  blood,
  variant,
  ...props
}: BloodyButtonProps) {
  const [isHover, setIsHover] = useState(false);

  const toggleIsHover = () => setIsHover((prev) => !prev);
  return (
    <div className="relative">
      {blood && (
        <Blood
          className="absolute right-[25%] top-full origin-top-right text-white/60"
          variant={variant}
          isHover={isHover}
        />
      )}
      <Button
        className={cn(bloodyButtonVariants({ variant }), className)}
        onMouseEnter={toggleIsHover}
        onMouseLeave={toggleIsHover}
        {...props}
      />
    </div>
  );
}

export { BloodyButton, bloodyButtonVariants };
