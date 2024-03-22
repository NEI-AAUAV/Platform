import { useUserStore } from "stores/useUserStore";

/**
 *
 * @param {{
 * modality: {
 *  image: string,
 *  sport: string,
 *  frame: string,
 *  type: string,
 *  competitions: {
 *    name: string,
 *    division: number
 *    id: number
 *  }[]
 * },
 * className: string
 * }} props
 * @returns
 *
 * @example
 * <SportsCard
 * modality={{
 *  image: "https://i.imgur.com/4Z5wQ9M.png",
 *  sport: "Futebol 7",
 *  frame: "Masculino",
 *  type: "Equipa",
 *  competitions: [
 *   {
 *     name: "Liga Universitária",
 *     division: 1,
 *     id: 1,
 *   },
 *   {
 *     name: "Liga Universitária",
 *     division: 2,
 *     id: 2,
 *   },
 *  ],
 * }}
 * className="w-full"
 * />
 *
 */

const GRADIENTS_LIGHT = {
  "Voleibol 4x4": "bg-gradient-to-r from-[#f6d5f7] to-[#fbe9d7]",
};

const GRADIENTS_DARK = {
  Atletismo: "bg-gradient-to-r from-[#b429f9] to-[#26c5f3]",
  Andebol: "bg-gradient-to-r from-[#ff930f] to-[#fff95b]",
  Basquetebol: "bg-gradient-to-r from-[#ce653b] to-[#2b0948]",
  Futsal: "bg-gradient-to-r from-[#D22730] to-[#D19B28]",
  "Futebol 7": "bg-gradient-to-r from-[#0f971c] to-[#0c0c0c]",
  "Voleibol 4x4": "bg-gradient-to-r from-[#EF47FC] to-[#F3E2E2]",
  "E-Sports LOL": "bg-gradient-to-r from-[#C29A3F] to-[#138D9B]",
  "E-Sports CS:GO": "bg-gradient-to-r from-[#BB460C] to-[#E9B75B]",
};

const SportsCard = ({ modality, className, refe }) => {
  const { image, sport, frame, type, competitions } = modality;
  const theme = useUserStore((state) => state.theme);

  const gradients = theme === "light" ? GRADIENTS_LIGHT : GRADIENTS_DARK;
  const gradient = gradients[sport] ?? "";
  const division =
    competitions?.length > 0 && competitions[0]?.division
      ? `${competitions[0].division}ª Divisão`
      : null;

  const firstCompetitions = competitions.slice(0, 2);
  const competitionsNode = firstCompetitions.map((competition) => (
    <li key={competition.id}>{competition.name}</li>
  ));

  return (
    <div ref={refe}
      className={`bg-base-300 rounded-2xl shadow-md shadow-gray max-w-[420px] group flex-none ${className}`}
    >
      <div className="flex p-4">
        <img
          className="aspect-square block max-h-12"
          src={image}
          alt="sport img"
        />
        <div className="ml-8 text-primary-content font-bold">
          <span>{sport}</span>
          <br />
          <span>{frame}</span>
        </div>
        <span className="ml-auto text-sm text-neutral-content">{type}</span>
      </div>
      <div
        className={`relative text-blue-400 border-none brightness-75 group-hover:brightness-110 h-1 ${gradient} transition-[filter] transition-duration-400`}
      >
        <div
          className={`absolute opacity-0 -inset-[1px] blur-lg ${gradient} group-hover:opacity-100 brightness-110 transition-opacity transition-duration-400 `}
        ></div>
      </div>

      <div className="p-4 breadcrumbs text-secondary-content font-bold">
        <ul>{competitionsNode}</ul>
        <span className="text-sm text-neutral-content">{division}</span>
      </div>
    </div>
  );
};

export default SportsCard;
