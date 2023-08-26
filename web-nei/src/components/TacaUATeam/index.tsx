import { Banner } from "./banner";
import { ParticipantCard } from "./cards/player";
import { AddParticipantCard } from "./cards/add";

export type TeamParticipant = {
  id: number;
  name: string;
  image?: string;
};

export type Props = {
  name: string;
  admin: boolean;
  image?: string;
  participants: TeamParticipant[];
};

export function TacaUATeam({
  name,
  image,
  participants,
  admin = false,
}: Props): JSX.Element {
  return (
    <div>
      <Banner admin={admin} image={image} />
      <h2 className="py-8 text-2xl font-bold">Jogadores do {name}</h2>
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
