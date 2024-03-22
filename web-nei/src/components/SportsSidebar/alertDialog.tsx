import TacaUAService from "../../services/TacaUAService.jsx";
import { Button } from "../ui/button.tsx";
import { Input } from "../ui/input.tsx";
import { Modality } from "../../pages/SportDetails/types.ts";
import { Dispatch, SetStateAction, useState } from "react";
import {
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "../ui/alert-dialog.tsx";
import { ToasterToast, Toast } from "../ui/use-toast.ts";
import { ModalitiesDataProps } from "../../pages/SportDetails/index.tsx";
import { cn } from "../../lib/utils.ts";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "../ui/select.tsx";

type SportsSidebarDialogProps = {
  currentModality: Modality;
  modalCurrent: Modality[];
  modalModality: Modality;
  setData: Dispatch<SetStateAction<ModalitiesDataProps>>;
  setModalModality: Dispatch<SetStateAction<Modality>>;
  toast: ({ ...props }: Toast) => {
    id: string;
    dismiss: () => void;
    update: (props: ToasterToast) => void;
  };
};

export default function SportsSidebarAlertDialog({
  currentModality,
  modalCurrent,
  modalModality,
  setData,
  setModalModality,
  toast,
}: SportsSidebarDialogProps) {
  const [deleteModalConfirmation, setDeleteModalConfirmation] =
    useState<string>("");

  return (
    <AlertDialogContent className="bg-base-200">
      <AlertDialogHeader className="flex flex-col gap-2">
        <AlertDialogTitle>Remover modalidade</AlertDialogTitle>
        <div className={cn(modalCurrent.length <= 1 && "hidden")}>
          <p className="mb-2 font-medium">Quadros já existentes</p>
          <Select
            value={modalModality.id.toString()}
            onValueChange={(value) => {
              const changed = modalCurrent.find(
                (modality) => modality.id === parseInt(value)
              );
              setModalModality(changed!!);
            }}
          >
            <SelectTrigger className="w-full bg-base-300">
              <SelectValue placeholder="Escolhe um desporto" />
            </SelectTrigger>
            <SelectContent>
              {modalCurrent.map((modality) => (
                <SelectItem value={modality.id.toString()} key={modality.frame}>
                  {modality.frame}, {modality.type}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <AlertDialogDescription>
          Para garantir que não estás a cometer um ato irrefletido, escreve na
          caixa de texto a palavra "
          <span className="font-medium">
            {modalModality.sport}
            {modalModality.frame}
            {modalModality.year}
          </span>
          ", seguido do botão Eliminar.{" "}
          <span className="font-bold">Esta operação é irreversível!</span>
        </AlertDialogDescription>
      </AlertDialogHeader>
      <AlertDialogFooter>
        <Input
          className="rounded-full bg-base-300"
          placeholder={
            modalModality.sport + modalModality.frame + modalModality.year
          }
          onChange={(event) => setDeleteModalConfirmation(event.target.value)}
        />
        <AlertDialogCancel
          className="bg-base-300"
          onClick={() => {
            setDeleteModalConfirmation("");
          }}
        >
          Cancelar
        </AlertDialogCancel>
        <AlertDialogAction
          asChild
          onClick={() => {
            TacaUAService.removeModality(modalModality.id)
              .then(() => {
                setDeleteModalConfirmation("");
                toast({
                  description: "Modalidade removida com sucesso.",
                });
                TacaUAService.getModalities()
                  .then((response) => {
                    setData(response as unknown as ModalitiesDataProps);
                  })
                  .catch((e) => {
                    toast({
                      title: "Erro a obter dados.",
                      description: e.message,
                      variant: "destructive",
                    });
                  });
              })
              .catch((e) => {
                toast({
                  title: "Oops, algo correu mal.",
                  description: e.message,
                  variant: "destructive",
                });
              });
          }}
        >
          <Button
            disabled={
              deleteModalConfirmation !==
              modalModality.sport + modalModality.frame + modalModality.year
            }
          >
            Eliminar
          </Button>
        </AlertDialogAction>
      </AlertDialogFooter>
    </AlertDialogContent>
  );
}
