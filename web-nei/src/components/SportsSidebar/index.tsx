import MaterialSymbol from "components/MaterialSymbol";
import SportModalitySelect from "components/SportModalitySelect";
import { motion } from "framer-motion";
import { ModalitiesDataProps } from "pages/SportDetails/index";
import { ModalitiesByYearAndFrame } from "pages/SportDetails/types";
import {
  Dispatch,
  ElementRef,
  SetStateAction,
  useEffect,
  useRef,
  useState,
} from "react";
import { cn } from "lib/utils";
import { Modality } from "pages/SportDetails/types";
import { ScrollArea } from "../ui/scroll-area";
import { Dialog, DialogTrigger } from "components/ui/dialog";
import { useToast } from "components/ui/use-toast";
import SportsSidebarDialog from "./dialog";
import { Button } from "../ui/button";
import { AlertDialog } from "../ui/alert-dialog";
import SportsSidebarAlertDialog from "./alertDialog";

type SportsSidebarProps = {
  admin: boolean;
  modalitiesByYearAndFrame: ModalitiesByYearAndFrame;
  currentYear: number;
  modalityId: string | undefined;
  tab: string | undefined;
  competitionId: string | undefined;
  setIsSidebarOpen: any;
  currentModality: Modality;
  sportsList: string[];
  setData: Dispatch<SetStateAction<ModalitiesDataProps>>;
};

export default function SportsSidebar({
  admin,
  modalitiesByYearAndFrame,
  currentYear,
  tab,
  competitionId,
  setIsSidebarOpen,
  currentModality,
  sportsList,
  setData,
}: SportsSidebarProps) {
  const { toast } = useToast();

  const [sidebarExpandedYear, setSidebarExpandedYear] =
    useState<number>(currentYear);

  useEffect(() => setSidebarExpandedYear(currentYear), [currentYear]);

  const handleAccordion = (newYear: number) => {
    sidebarExpandedYear != newYear
      ? setSidebarExpandedYear(newYear)
      : setSidebarExpandedYear(0);
  };

  const sidebarRef = useRef<ElementRef<"div">>(null);
  const [sidebarHeight, setSidebarHeight] = useState(0);

  useEffect(() => {
    const resizeObserver = new ResizeObserver(() => {
      setSidebarHeight(sidebarRef.current?.clientHeight ?? 0);
    });
    if (sidebarRef.current) resizeObserver.observe(sidebarRef.current);
    return () => resizeObserver.disconnect(); // clean up
  }, []);

  const [modalModality, setModalModality] = useState<Modality>({
    id: 0,
    type: "",
    frame: "",
    year: 0,
    sport: "",
  });

  const [deleteModalOpen, setDeleteModalOpen] = useState<boolean>(false);
  const [modalOpen, setModalOpen] = useState<boolean>(false);
  const [modalCurrent, setModalCurrent] = useState<Modality[]>([]);
  const [modalType, setModalType] = useState<"add" | "edit">("add");

  return (
    <ScrollArea
      style={{ height: sidebarHeight }}
      className="max-h-[calc(100dvh-1rem)] w-full overflow-hidden rounded-2xl bg-base-300 shadow lg:max-h-[32rem]"
    >
      <AlertDialog open={deleteModalOpen} onOpenChange={setDeleteModalOpen}>
        <Dialog open={modalOpen} onOpenChange={setModalOpen}>
          <SportsSidebarDialog
            modalCurrent={modalCurrent}
            modalModality={modalModality}
            modalType={modalType}
            setAddDialogOpen={setModalOpen}
            setData={setData}
            setModalModality={setModalModality}
            sportsList={sportsList}
            toast={toast}
          />

          <SportsSidebarAlertDialog
            currentModality={currentModality}
            modalCurrent={modalCurrent}
            modalModality={modalModality}
            setData={setData}
            setModalModality={setModalModality}
            toast={toast}
          />

          <div ref={sidebarRef} className="flex flex-col gap-8 p-8">
            <div className="flex flex-row items-center justify-center">
              <p className="grow text-start text-xl font-bold lg:text-center">
                Arquivo
              </p>
              <Button
                variant="ghost"
                className="h-fit p-1 lg:hidden"
                onClick={() => setIsSidebarOpen(false)}
              >
                <MaterialSymbol icon="close" />
              </Button>
            </div>
            {Object.entries(modalitiesByYearAndFrame)
              .sort((a, b) => (a[0] > b[0] ? -1 : 1))
              .map(([key, value]) => {
                let year = parseInt(key);
                return (
                  <div className="flex flex-col" key={key}>
                    <div className="flex flex-row items-center justify-between">
                      <div className="flex flex-row items-center gap-1">
                        <p
                          className={cn(
                            "relative text-lg font-semibold before:absolute before:-left-3 before:text-primary before:transition-opacity before:content-['•']",
                            (year != currentYear ||
                              year == sidebarExpandedYear) &&
                              "before:opacity-0"
                          )}
                        >
                          {key}
                        </p>
                      </div>
                      <div className="flex flex-row items-center gap-1">
                        {admin && (
                          <motion.div
                            initial={{ opacity: 0 }}
                            animate={{ opacity: 1 }}
                            exit={{ opacity: 0 }}
                            className="h-8"
                          >
                            <DialogTrigger
                              asChild
                              onClick={() => {
                                setModalType("add");
                                setModalModality({
                                  id: 0,
                                  type: "",
                                  frame: "",
                                  year: 0,
                                  sport: "",
                                });
                              }}
                            >
                              <Button variant="ghost" className="h-fit p-1">
                                <MaterialSymbol icon="add" />
                              </Button>
                            </DialogTrigger>
                          </motion.div>
                        )}
                        <Button
                          variant="ghost"
                          className="h-fit p-1"
                          onClick={() => handleAccordion(year)}
                        >
                          <MaterialSymbol
                            icon="expand_less"
                            className={cn(
                              "transition-hover",
                              sidebarExpandedYear != year && "rotate-180"
                            )}
                          />
                        </Button>
                      </div>
                    </div>
                    <motion.div
                      initial={{
                        height: sidebarExpandedYear == year ? "auto" : 0,
                        opacity: sidebarExpandedYear == year ? 0 : 1,
                      }}
                      animate={{
                        height: sidebarExpandedYear == year ? "auto" : 0,
                        opacity: sidebarExpandedYear == year ? 1 : 0,
                      }}
                      className="flex flex-col gap-2 overflow-hidden"
                    >
                      {Object.entries(value).map(([sport, frameArray]) => (
                        <SportModalitySelect
                          admin={admin}
                          name={sport}
                          frameArray={frameArray}
                          key={frameArray[0].id}
                          isSelected={frameArray.some(
                            (frame) => currentModality.id === frame.id
                          )}
                          competitionId={parseInt(competitionId ?? "0")}
                          modalityId={frameArray[0].id}
                          tab={tab ?? "games"}
                          setModalCurrent={setModalCurrent}
                          setModalModality={setModalModality}
                          setModalType={setModalType}
                        />
                      ))}
                    </motion.div>
                  </div>
                );
              })}
            {admin && (
              <motion.div
                className="flex flex-row items-center justify-between"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
              >
                <p className="font-semibold">Adicionar ano</p>
                <DialogTrigger
                  asChild
                  onClick={() => {
                    setModalType("add");
                    setModalModality({
                      id: 0,
                      type: "",
                      frame: "",
                      year: 0,
                      sport: "",
                    });
                  }}
                >
                  <Button variant="ghost" className="h-fit p-1">
                    <MaterialSymbol icon="add" />
                  </Button>
                </DialogTrigger>
              </motion.div>
            )}
          </div>
        </Dialog>
      </AlertDialog>
    </ScrollArea>
  );
}
