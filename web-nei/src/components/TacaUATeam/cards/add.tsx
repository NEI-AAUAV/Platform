import { motion } from "framer-motion";
import { MaterialSymbol } from "react-material-symbols";
import { BaseCard } from "./base";

export type Props = {
  index: number;
};

export function AddParticipantCard({ index }: Props): JSX.Element {
  return (
    <BaseCard
      as={motion.button}
      className="min-h-[14.5rem] justify-center"
      index={index}
    >
      <motion.div className="mx-auto" variants={iconVariants}>
        <MaterialSymbol icon="add" fill size={48} />
      </motion.div>
      <p className="text-center font-bold text-text-200">Adicionar Jogador</p>
    </BaseCard>
  );
}

const iconVariants = {
  hidden: { scale: 1.0 },
  visible: { scale: 1.0 },
  rest: { scale: 1.0 },
  hover: { scale: 1.4 },
};
