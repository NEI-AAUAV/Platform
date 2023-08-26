import equipa from "../img/equipa.jpg";
import player from "../img/dani.jpeg";
import nei from "../img/nei.png";

import { TacaUATeam } from "components/TacaUATeam";

const SportTeam = () => {
  return (
    <div className="p-8">
      <TacaUATeam
        image={equipa}
    admin={true}
        participants={[
          { id: 0, image: player, name: "Marco António" },
          { id: 1, image: equipa, name: "Marco António" },
          { id: 2, image: player, name: "Marco António" },
          { id: 3, image: nei, name: "Marco António" },
          { id: 4, image: player, name: "Marco António" },
          { id: 5, image: player, name: "Marco António" },
          { id: 6, image: player, name: "Marco António" },
          { id: 7, image: player, name: "Marco António AEi3uir hgu82y891y 897" },
        ]}
      />
    </div>
  );
};

export default SportTeam;
