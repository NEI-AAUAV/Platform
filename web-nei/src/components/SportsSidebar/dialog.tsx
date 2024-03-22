import TacaUAService from "../../services/TacaUAService";
import MaterialSymbol from "../MaterialSymbol";
import SelectLikeOption from "../SelectLikeOption";
import { Button } from "../ui/button";
import { DialogContent, DialogHeader, DialogTitle } from "../ui/dialog";
import { Input } from "../ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "../ui/select";
import { Modality } from "../../pages/SportDetails/types";
import { Dispatch, SetStateAction } from "react";
import { ModalitiesDataProps } from "../../pages/SportDetails";
import { ToasterToast, Toast } from "../ui/use-toast.ts";
import { MaterialSymbolProps } from "react-material-symbols";
import { cn } from "../../lib/utils.ts";
import { useNavigate } from "react-router-dom";

type SportsSidebarDialogProps = {
  modalModality: Modality;
  modalCurrent: Modality[];
  modalType: "add" | "edit";
  setAddDialogOpen: Dispatch<SetStateAction<boolean>>;
  setData: Dispatch<SetStateAction<ModalitiesDataProps>>;
  setModalModality: Dispatch<SetStateAction<Modality>>;
  sportsList: string[];
  toast: ({ ...props }: Toast) => {
    id: string;
    dismiss: () => void;
    update: (props: ToasterToast) => void;
  };
};

type Option = {
  name: string;
  icon: MaterialSymbolProps["icon"];
  color?: string;
};

export default function SportsSidebarDialog({
  modalModality,
  modalCurrent,
  modalType,
  setAddDialogOpen,
  setData,
  setModalModality,
  sportsList,
  toast,
}: SportsSidebarDialogProps) {
  const navigate = useNavigate();

  const typeOptions: Option[] = [
    {
      name: "Individual",
      icon: "person",
    },
    {
      name: "Pares",
      icon: "group",
    },
    {
      name: "Coletiva",
      icon: "groups",
    },
  ];

  const frameOptions: Option[] = [
    {
      name: "Masculino",
      icon: "person",
      color: "from-sky-400 to-purple-500",
    },
    {
      name: "Feminino",
      icon: "person",
      color: "from-violet-500 to-rose-400",
    },
    {
      name: "Misto",
      icon: "group",
      color: "from-sky-400 via-purple-500 to-rose-400",
    },
  ];

  const handleCreateOrEdit = () => {
    const apiFn = {
      add: TacaUAService.createModality,
      edit: TacaUAService.updateModality,
    }[modalType];
    apiFn({
      id: modalModality.id,
      data: {
        year: modalModality.year,
        type: modalModality.type,
        frame: modalModality.frame,
        sport: modalModality.sport,
      },
    })
      .then(async (data: any) => {
        setAddDialogOpen(false);
        toast({
          description:
            "Modalidade " +
            { add: "adicionada", edit: "editada" }[modalType] +
            " com sucesso.",
        });
        TacaUAService.getModalities()
          .then((response) => {
            setData(response as unknown as ModalitiesDataProps);
            navigate(`/taca-ua/${data.id}/games/0`);
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
  };

  return (
    <DialogContent className="bg-base-200">
      <DialogHeader>
        <DialogTitle className="text-xl">
          {{ add: "Adicionar", edit: "Editar" }[modalType]} modalidade
        </DialogTitle>
      </DialogHeader>

      <div
        className={cn(
          (modalType === "add" || modalCurrent.length <= 1) && "hidden"
        )}
      >
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

      <div className="flex flex-col gap-4 lg:flex-row">
        <div className="flex-1">
          <p className="mb-2 font-medium">Desporto</p>
          <Select
            value={modalModality.sport !== "" ? modalModality.sport : undefined}
            onValueChange={(value) =>
              setModalModality((modality) => ({
                ...modality,
                sport: value,
              }))
            }
          >
            <SelectTrigger className="w-full bg-base-300">
              <SelectValue placeholder="Escolhe um desporto" />
            </SelectTrigger>
            <SelectContent>
              {sportsList.map((sport) => (
                <SelectItem value={sport} key={sport.toLowerCase()}>
                  {sport}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <div className="flex-1">
          <p className="mb-2 font-medium">Ano</p>
          <Input
            type="number"
            className="bg-base-300"
            value={modalModality.year !== 0 ? modalModality.year : undefined}
            onChange={(event) =>
              setModalModality((modality) => ({
                ...modality,
                year: parseInt(event.target.value),
              }))
            }
            placeholder="Ano"
          />
        </div>
      </div>

      <div className="flex flex-col gap-4 lg:flex-row">
        <div className="flex-1">
          <p className="mb-2 font-medium">Tipo de jogo</p>
          <div className="flex flex-row gap-2">
            {typeOptions.map((modType) => (
              <SelectLikeOption
                key={modType.name}
                isSelected={modalModality.type === modType.name}
                onClick={() =>
                  setModalModality((modality) => ({
                    ...modality,
                    type: modType.name,
                  }))
                }
              >
                <MaterialSymbol icon={modType.icon} className="text-primary" />
                <p>{modType.name}</p>
              </SelectLikeOption>
            ))}
          </div>
        </div>

        <div className="flex-1">
          <p className="mb-2 font-medium">Quadro</p>
          <div className="flex flex-row gap-2">
            {frameOptions.map((frame) => (
              <SelectLikeOption
                key={frame.name}
                isSelected={modalModality.frame === frame.name}
                onClick={() =>
                  setModalModality((modality) => ({
                    ...modality,
                    frame: frame.name,
                  }))
                }
              >
                <MaterialSymbol
                  icon={frame.icon}
                  parentDivClassName={cn(
                    "bg-gradient-to-r bg-clip-text",
                    frame.color
                  )}
                  className="text-transparent"
                />
                <p>{frame.name}</p>
              </SelectLikeOption>
            ))}
          </div>
        </div>
      </div>

      <div className="flex justify-center">
        <Button
          variant="default"
          className="w-fit"
          onClick={handleCreateOrEdit}
        >
          <MaterialSymbol
            icon={modalType}
            className={cn(modalType === "add" && "-m-1", "mr-1")}
            size={modalType === "edit" ? 20 : 24}
          />
          <p>{{ add: "Adicionar", edit: "Editar" }[modalType]}</p>
        </Button>
      </div>
    </DialogContent>
  );
}
