import { Fragment } from "react";
import NoteCard from "../NoteCard";

// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(
  process.env.REACT_APP_ANIMATION_INCREMENT
);

const GridView = ({ data, setSelected }) => {
  return (
    <div className="w-full grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
      {data.map((note, i) => (
        <Fragment key={i}>
          <NoteCard
            note={note}
            style={{
              animationDelay: animationBase + i * animationIncrement + "s",
            }}
            Icon={note.type?.Icon}
            onClick={() => setSelected(note)}
          />
        </Fragment>
      ))}
    </div>
  );
};

export default GridView;
