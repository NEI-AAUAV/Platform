import { cn } from "lib/utils";
import { SportTab } from "pages/SportDetails/types";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import MaterialSymbol from "../MaterialSymbol";
import { Button } from "../ui/button";

type SportTabSelectProps = {
  isSelected: boolean;
  tab: SportTab;
  modalityId: number;
  competitionId: string | undefined;
  isAdminOnly: boolean;
};

export default function SportTabSelect({
  isSelected,
  tab,
  modalityId,
  competitionId,
  isAdminOnly,
}: SportTabSelectProps) {
  const navigate = useNavigate();

  return (
    <motion.li
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="flex snap-start flex-col items-center gap-1"
    >
      <Button
        variant={isSelected ? "secondary" : "ghost"}
        className="gap-2 rounded"
        onClick={() =>
          navigate(`/taca-ua/${modalityId}/${tab.url}/${competitionId}`)
        }
      >
        {isAdminOnly && <MaterialSymbol icon="lock" size={20} />}
        <p className="text-lg font-semibold">{tab.name}</p>
      </Button>
      {isSelected && (
        <motion.div
          className="h-1 w-12 rounded-full bg-primary"
          layoutId="underline"
        />
      )}
    </motion.li>
  );
}
