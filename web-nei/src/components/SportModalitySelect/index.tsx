import { useNavigate } from "react-router-dom";
import { cn } from "lib/utils";
import MaterialSymbol from "../MaterialSymbol";
import { Button } from "../ui/button";
import { DialogTrigger } from "../ui/dialog";
import { Dispatch, SetStateAction } from "react";
import { Modality } from "../../pages/SportDetails/types";
import { AlertDialogTrigger } from "../ui/alert-dialog";

type SelectProps = {
  admin: boolean;
  competitionId: number;
  frameArray: Modality[];
  isSelected: boolean;
  modalityId: number;
  name: string;
  setModalCurrent: Dispatch<SetStateAction<Modality[]>>;
  setModalModality: Dispatch<SetStateAction<Modality>>;
  setModalType: Dispatch<SetStateAction<"add" | "edit">>;
  tab: string;
};

export default function SportModalitySelect({
  admin,
  competitionId,
  frameArray,
  isSelected,
  modalityId,
  name,
  setModalCurrent,
  setModalModality,
  setModalType,
  tab,
}: SelectProps) {
  const navigate = useNavigate();
  const handleClick = () => {
    navigate(`/taca-ua/${modalityId}/${tab}/${competitionId}`);
  };

  return (
    <div
      className={cn(
        "group flex cursor-pointer flex-row items-center justify-between gap-1 rounded-lg py-2 pe-2 ps-4 text-start transition-colors first:mt-2",
        isSelected
          ? "bg-primary/20 font-medium hover:bg-primary/30"
          : "hover:bg-base-100 dark:hover:bg-base-200"
      )}
      onClick={handleClick}
    >
      <p>{name}</p>
      {admin && (
        <div className="flex flex-row items-center gap-1">
          <DialogTrigger
            asChild
            onClick={() => {
              setModalType("edit");
              setModalCurrent(frameArray);
              setModalModality(frameArray[0]);
            }}
          >
            <Button
              variant="ghost"
              className="h-fit p-1 opacity-0 transition-opacity group-hover:opacity-100"
            >
              <MaterialSymbol icon="edit" size={16} />
            </Button>
          </DialogTrigger>
          <AlertDialogTrigger
            asChild
            onClick={() => {
              setModalCurrent(frameArray);
              setModalModality(frameArray[0]);
            }}
          >
            <Button
              variant="ghost"
              className="h-fit p-1 opacity-0 transition-opacity group-hover:opacity-100"
            >
              <MaterialSymbol icon="delete" size={16} color="red" />
            </Button>
          </AlertDialogTrigger>
        </div>
      )}
    </div>
  );
}
