import { motion } from "framer-motion";
import { MaterialSymbol } from "react-material-symbols";

import { ParticipantCard } from "./cards/player";
import { AddParticipantCard } from "./cards/add";

export type TeamParticipant = {
  id: number;
  name: string;
  image: string;
};

export type Props = {
  admin: boolean;
  image: string;
  participants: TeamParticipant[];
};

export function TacaUATeam({
  image,
  participants,
  admin = false,
}: Props): JSX.Element {
  return (
    <div>
      <div className="relative">
        <img className="w-full rounded-2xl" src={image} />
        {admin && (
          <motion.button
            className="absolute right-0 top-0 p-4 drop-shadow-[0_0_4px_rgba(0,0,0,0.25)]"
            whileHover={{ scale: 1.4 }}
          >
            <MaterialSymbol icon="edit" fill size={24} />
          </motion.button>
        )}
      </div>
      <h2 className="py-8 text-2xl font-bold">Jogadores do NEI</h2>
      <div
        className="grid w-full auto-rows-fr justify-center gap-4"
        style={{
          gridTemplateColumns: "repeat(auto-fit, 12.84375rem)",
        }}
      >
        {participants.map((participant, i) => (
          <ParticipantCard
            index={i}
            key={participant.id}
            admin={admin}
            {...participant}
          />
        ))}
        <AddParticipantCard index={participants.length} />
      </div>
    </div>
  );
}
