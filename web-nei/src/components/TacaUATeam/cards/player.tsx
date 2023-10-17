import { useEffect, useState } from "react";
import { motion } from "framer-motion";
import { MaterialSymbol } from "react-material-symbols";
import { BaseCard } from "./base";
import { TeamParticipant } from "../index";
import { PersonIcon } from "assets/icons/google";

export type Props = TeamParticipant & {
  index: number;
  admin: boolean;
};

export function ParticipantCard({
  image,
  name,
  admin,
  index,
}: Props): JSX.Element {
  const [noImage, setNoImage] = useState(image === undefined);

  useEffect(() => {
    setNoImage(image === undefined);
  }, [image]);

  return (
    <BaseCard index={index} className="group">
      <div className="relative">
        {noImage ? (
          <PersonIcon className="mx-auto h-48 w-40" />
        ) : (
          <img
            className="mx-auto h-48 w-40 rounded-xl object-cover"
            src={image}
            onError={() => setNoImage(true)}
          />
        )}
        {admin && (
          <motion.button
            className="absolute right-0 top-0 hidden p-4 text-error drop-shadow-[0_0_4px_rgba(0,0,0,0.25)] group-hover:block"
            whileHover={{ scale: 1.3 }}
          >
            <MaterialSymbol icon="delete" fill size={24} />
          </motion.button>
        )}
      </div>
      <p className="text-center font-bold text-text-100">{name}</p>
    </BaseCard>
  );
}
