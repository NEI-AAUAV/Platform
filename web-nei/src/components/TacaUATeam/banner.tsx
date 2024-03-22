import { motion } from "framer-motion";
import { MaterialSymbol } from "react-material-symbols";
import { useEffect, useState } from "react";

export type Props = {
  admin: boolean;
  image?: string;
};

function AddBanner(): JSX.Element {
  return (
    <motion.button
      className="flex h-[20rem] w-full flex-col justify-center rounded-2xl bg-base-400"
      initial="rest"
      animate="rest"
      whileHover="hover"
    >
      <motion.div className="mx-auto" variants={iconVariants}>
        <MaterialSymbol icon="add" fill size={48} />
      </motion.div>
      <p className="text-center font-bold text-text-200">
        Adicionar foto de equipa
      </p>
    </motion.button>
  );
}

export function Banner({ image, admin }: Props): JSX.Element | false {
  const [hasImage, setHasImage] = useState(image !== undefined);

  useEffect(() => {
    setHasImage(image !== undefined);
  }, [image]);

  return hasImage ? (
    <div className="relative">
      <img
        className="w-full rounded-2xl object-cover"
        src={image}
        onError={() => setHasImage(true)}
      />
      {admin && (
        <motion.button
          className="absolute right-0 top-0 p-4 drop-shadow-[0_0_4px_rgba(0,0,0,0.25)]"
          whileHover={{ scale: 1.4 }}
        >
          <MaterialSymbol icon="edit" fill size={24} />
        </motion.button>
      )}
    </div>
  ) : (
    admin && <AddBanner />
  );
}

const iconVariants = {
  rest: { scale: 1.0 },
  hover: { scale: 1.4 },
};
