import { useNavigate, useParams } from "react-router-dom";
import Typist from "react-typist";
import { AnimatePresence, motion } from "framer-motion";
import { useEffect, useState } from "react";
import MaterialSymbol from "components/MaterialSymbol";
import SportsSidebar from "components/SportsSidebar";
import SportMainContent from "components/SportMainContent";
import { Modality } from "./types";
import { tabs } from "./data";
import { cn } from "lib/utils";
import TacaUAService from "services/TacaUAService";
import { Toaster } from "components/ui/toaster";
import { useToast } from "components/ui/use-toast";
import {
  getCurrentModality,
  getCurrentModalityFrames,
  organizeModalitiesByYearAndFrame,
} from "./helpers";
import { Button } from "../../components/ui/button";
import { useUserStore } from "../../stores/useUserStore";

type ParamsProps = {
  modalityId: string;
  tab: string;
  competitionId: string;
};

export type ModalitiesDataProps = {
  modalities: Modality[];
  types: string[];
  frames: string[];
  sports: string[];
};

export function Component() {
  const { toast } = useToast();
  const { modalityId, tab, competitionId } = useParams<ParamsProps>();
  const navigate = useNavigate();
  const { scopes } = useUserStore((state) => state);
  const isAdmin =
    scopes && ["admin", "manager-tacaua"].some((s) => scopes.includes(s));

  const [data, setData] = useState<ModalitiesDataProps>({
    modalities: [],
    types: [],
    frames: [],
    sports: [],
  });
  const modalitiesByYearAndFrame = organizeModalitiesByYearAndFrame(data);
  const currentModality = getCurrentModality(modalityId ?? "0", data);
  const currentModalityFrames = getCurrentModalityFrames(currentModality, data);

  useEffect(() => {
    TacaUAService.getModalities()
      .then((response) => {
        setData(response as unknown as ModalitiesDataProps);
        currentModality.id === -1 && navigate("/taca-ua/1/games/0");
      })
      .catch((e) => {
        toast({
          title: "Erro a obter dados.",
          description: e.message,
          variant: "destructive",
        });
      });
  }, []);

  // Other states
  const [isAdminMode, setIsAdminMode] = useState<boolean>(isAdmin);
  const [isSidebarOpen, setIsSidebarOpen] = useState<boolean>(
    window.innerWidth > 1024
  );

  useEffect(() => {
    if (
      !isAdminMode &&
      tabs
        .filter((tab) => tab.isAdminOnly === true)
        .map((filteredTab) => filteredTab.url)
        .includes(tab ?? "")
    ) {
      navigate(`/taca-ua/${modalityId}/games/${competitionId}`);
    }
  }, [isAdminMode]);

  // Framer Motion sidebar animation's variants
  const variants = {
    open: { opacity: 1, translateX: 0, translateY: 0 },
    closed: {
      opacity: 0,
      translateX: window.innerWidth > 1024 ? "calc(-100% - 1rem)" : 0,
      translateY: window.innerWidth > 1024 ? 0 : "calc(100% - 1rem)",
    },
  };

  return (
    <>
      <Toaster />
      <div className="flex flex-col gap-8 transition-colors">
        <div
          className={cn(
            "pointer-events-none absolute left-0 top-0 z-40 block h-full w-full bg-black/30 opacity-0 transition-opacity lg:hidden",
            isSidebarOpen && "pointer-events-auto opacity-100"
          )}
        />
        <h2 className="text-center">
          <Typist>Taça UA</Typist>
        </h2>
        <div className="relative flex flex-row items-start gap-5">
          <Button
            variant="ghost"
            className="absolute top-[-42px] h-fit p-1"
            onClick={() => setIsSidebarOpen(!isSidebarOpen)}
          >
            <MaterialSymbol icon="dock_to_right" fill={isSidebarOpen} />
          </Button>
          <AnimatePresence mode="popLayout">
            {isSidebarOpen && (
              <motion.div
                layout="preserve-aspect"
                initial="closed"
                animate="open"
                exit="closed"
                variants={variants}
                transition={{ delay: isSidebarOpen ? 0 : 0.04, type: "tween" }}
                className="fixed bottom-0 left-0 z-50 w-full p-2 lg:relative lg:z-0 lg:w-64 lg:p-0"
              >
                <SportsSidebar
                  admin={isAdminMode}
                  modalitiesByYearAndFrame={modalitiesByYearAndFrame}
                  currentYear={currentModality.year}
                  modalityId={modalityId}
                  tab={tab}
                  competitionId={competitionId}
                  setIsSidebarOpen={setIsSidebarOpen}
                  currentModality={currentModality}
                  sportsList={data.sports}
                  setData={setData}
                />
              </motion.div>
            )}
          </AnimatePresence>

          <motion.div
            layout
            transition={{ type: "tween" }}
            className="max-w-full flex-1"
          >
            <SportMainContent
              currentTab={tab}
              currentModality={currentModality}
              currentModalityFrames={currentModalityFrames}
              competitionId={competitionId}
              isAdmin={isAdmin}
              isAdminMode={isAdminMode}
              setIsAdminMode={setIsAdminMode}
              data={data}
            />
          </motion.div>
        </div>
      </div>
    </>
  );
}
