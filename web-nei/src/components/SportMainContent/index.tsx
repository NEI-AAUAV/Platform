import { tabs } from "pages/SportDetails/data";
import SportTabSelect from "../SportTabSelect";
import { Switch } from "components/ui/switch";
import { Dispatch, SetStateAction } from "react";
import { Modality } from "pages/SportDetails/types";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "components/ui/select";
import { AnimatePresence, motion } from "framer-motion";
import { ModalitiesDataProps } from "pages/SportDetails";
import { ModalityFrames } from "pages/SportDetails/types";
import { useNavigate } from "react-router-dom";

type SportMainContentProps = {
  currentTab: string | undefined;
  currentModality: Modality;
  currentModalityFrames: ModalityFrames[];
  competitionId: string | undefined;
  isAdmin: boolean;
  isAdminMode: boolean;
  setIsAdminMode: Dispatch<SetStateAction<boolean>>;
  data: ModalitiesDataProps;
};

export default function SportMainContent({
  currentTab,
  currentModality,
  currentModalityFrames,
  competitionId,
  isAdmin,
  isAdminMode,
  setIsAdminMode,
  data,
}: SportMainContentProps) {
  const navigate = useNavigate();

  return (
    <div className="rounded-2xl bg-base-200 shadow">
      <div className="flex flex-col gap-6 rounded-t-2xl bg-base-300 px-6 pt-6 lg:gap-8 lg:px-8 lg:pt-8">
        <div className="flex flex-row items-center justify-between gap-8">
          <motion.div layout="position" className="flex grow flex-col gap-2">
            <p className="text-xl font-bold">{currentModality.sport}</p>
            <Select
              value={currentModality.id.toString()}
              onValueChange={(value) =>
                navigate(`/taca-ua/${value}/${currentTab}/${competitionId}`)
              }
            >
              <SelectTrigger className="w-[180px]">
                <SelectValue placeholder="Quadro" />
              </SelectTrigger>
              <SelectContent>
                {currentModalityFrames.map((item) => (
                  <SelectItem
                    key={item.id.toString()}
                    value={item.id.toString()}
                  >
                    {item.frame}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </motion.div>
          {isAdmin && (
            <motion.div
              layout="position"
              className="flex flex-row items-end gap-2"
            >
              <p>Administrador</p>
              <Switch checked={isAdminMode} onCheckedChange={setIsAdminMode} />
            </motion.div>
          )}
        </div>
        <motion.ul
          layout="position"
          className="-m-0.5 flex max-w-full snap-x snap-mandatory flex-row flex-nowrap items-start justify-start gap-4 overflow-auto p-0.5"
        >
          <AnimatePresence>
            {tabs.map((tab) => {
              if (!tab.isAdminOnly || isAdminMode) {
                return (
                  <SportTabSelect
                    tab={tab}
                    key={tab.url}
                    isSelected={currentTab === tab.url}
                    competitionId={competitionId}
                    modalityId={currentModality.id}
                    isAdminOnly={tab.isAdminOnly}
                  />
                );
              }
            })}
          </AnimatePresence>
        </motion.ul>
      </div>

      <motion.div layout="position" className="flex flex-col gap-8 p-6 lg:p-8">
        <p>
          URL: taca-ua/{currentModality.id}/{currentTab}/{competitionId}
        </p>
      </motion.div>
    </div>
  );
}
