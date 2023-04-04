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

const GRADIENTS = {
  Atletismo: "bg-gradient-to-r from-blue-400 to-blue-500",
  Andebol: "bg-gradient-to-r from-red-400 to-red-500",
  Basquetebol: "bg-gradient-to-r from-yellow-400 to-yellow-500",
  Futsal: "bg-gradient-to-r from-green-400 to-green-500",
  "Futebol 7": "bg-gradient-to-r from-purple-400 to-purple-500",
  "Voleibol 4x4": "bg-gradient-to-r from-pink-400 to-pink-500",
  "E-Sports LOL": "bg-gradient-to-r from-gray-400 to-gray-500",
  "E-Sports CS:GO": "bg-gradient-to-r from-gray-400 to-gray-500",
};

const SportsCard = ({ modality, className }) => {
  const { image, sport, frame, type, competitions } = modality;
  const gradient = GRADIENTS[sport] ?? "";
  const division =
    competitions?.length > 0 && competitions[0]?.division
      ? `${competitions[0].division}ª Divisão`
      : null;

  const firstCompetitions = competitions.slice(0, 2);
  const competitionsNode = firstCompetitions.map((competition) => (
    <li key={competition.id}>{competition.name}</li>
  ));

  return (
    <div
      className={`bg-base-300 rounded-2xl shadow-md shadow-gray max-w-[420px] group ${className}`}
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
        className={`relative text-blue-400 border-none h-1 ${gradient} transition-[filter] transition-duration-400`}
      >
        <div
          className={`absolute opacity-0 -inset-[1px] blur-lg ${gradient} group-hover:opacity-100 brightness-120 transition-opacity transition-duration-400 `}
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
