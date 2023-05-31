import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faHandDots, faSeedling } from "@fortawesome/free-solid-svg-icons";
import { FrangoIcon } from "@/assets/icons";
import Avatar from "@/components/Avatar";

type GuestListProps = {
  persons: Person[];
};
const orange = { color: "#DD8500" };
const green = { color: "#198754" };
const red = { color: "#DC3545" };

const iconMap = new Map([
  ["NOR", <FrangoIcon style={orange} />],
  ["VEG", <FontAwesomeIcon icon={faSeedling} style={green} />],
]);

function allergyIcon(allergies: string) {
  return (
    allergies.length > 0 && <FontAwesomeIcon icon={faHandDots} style={red} />
  );
}

export default function GuestList({ persons }: GuestListProps) {
  return (
    <div className="w-full">
      <h3 className="text-xl font-semibold">Convidad@s</h3>
      {persons.map((person) => (
        <div key={person.id} className="">
          <div className="flex items-start gap-2">
            <Avatar isAuth={false} />
            <div className="">
              <div className="flex items-center gap-1">
                <span>{person.id}</span>
                <span className="flex gap-1">
                  {iconMap.get(person.dish)}
                  {allergyIcon(person.allergies)}
                </span>
              </div>
              <div className="flex items-center gap-1">
                <span className="font-light">
                  {person.companions.length > 0 &&
                    `+${person.companions.length} companions`}
                </span>
                <span className="flex gap-1">
                  {person.companions.map((companion) => (
                    <>
                      {iconMap.get(companion.dish)}
                      {allergyIcon(companion.allergies)}
                    </>
                  ))}
                </span>
              </div>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}
