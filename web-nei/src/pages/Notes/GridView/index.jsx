import { motion } from "framer-motion";

import NoteCard from "../NoteCard";

const container = {
  hidden: { opacity: 1, scale: 0 },
  visible: {
    opacity: 1,
    scale: 1,
    transition: {
      delayChildren: 0.2,
      staggerChildren: 0.1,
    },
  },
};

const item = {
  hidden: { y: 20, opacity: 0 },
  visible: {
    y: 0,
    opacity: 1,
  },
};

const GridView = ({ data, setSelected }) => {
  return (
    <motion.div
      className="grid w-full grid-cols-[repeat(auto-fit,_minmax(18rem,_1fr))] gap-3"
      variants={container}
      initial="hidden"
      animate="visible"
    >
      {data.map((note, i) => (
        <motion.div key={i} variants={item} className="w-full max-w-[32rem]">
          <NoteCard
            note={note}
            Icon={note.type?.Icon}
            onClick={() => setSelected(note)}
          />
        </motion.div>
      ))}
    </motion.div>
  );
};

export default GridView;
