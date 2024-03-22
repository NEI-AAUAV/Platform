import { cn } from "@/lib/utils";

export default function Blood({
  className,
  variant,
  isHover,
}: {
  className?: string;
  variant?: "default" | "primary" | "neutral" | null;
  isHover?: boolean;
}) {
  const variants = {
    default: isHover ? "RGB(255 255 255 / 0.80)" : "RGB(255 255 255 / 0.95)",
    primary: isHover ? "RGB(220 38 37 / 0.6)" : "RGB(220 38 37)",
    neutral: isHover ? "RGB(255 255 255 / 0.1)" : "RGB(255 255 255 / 0.2)",
  };
  return (
    <svg
      className={cn(className)}
      width="28"
      height="5"
      viewBox="0 0 28 5"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        d="M7 3C10.5 3 10 0 14 0H0C4 0 3.5 3 7 3Z"
        fill={variants[variant ?? "default"]}
      />
      <path
        d="M21 5C24.5 5 24 0 28 0H14C18 0 17.5 5 21 5Z"
        fill={variants[variant ?? "default"]}
      />
    </svg>
  );
}
