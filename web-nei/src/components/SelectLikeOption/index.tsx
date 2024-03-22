import { cn } from "lib/utils";

type SelectLikeOptionProps = {
  isSelected: boolean;
  onClick: () => void;
  children: React.ReactNode;
};

export default function SelectLikeOption({
  isSelected,
  onClick,
  children,
}: SelectLikeOptionProps) {
  return (
    <div
      className={cn(
        "flex flex-1 cursor-pointer flex-col items-center justify-center gap-1  rounded-lg border border-input bg-base-300 p-3 ring-2 ring-transparent ring-offset-background transition-all",
        isSelected && "border-opacity-0 ring-ring"
      )}
      onClick={onClick}
    >
      {children}
    </div>
  );
}
