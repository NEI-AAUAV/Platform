import { faSeedling, faHandDots } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { FrangoIcon } from "@/assets/icons";
import Avatar from "@/components/Avatar";
import useNEIUser from "@/hooks/useNEIUser";

type GuestProps = {
  person: Person;
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

export default function Guest({ person }: GuestProps) {
  const { neiUser } = useNEIUser(person.id);
  return (
    <>
      <Avatar id={person.id} className="w-[18px]" />
      <div className="flex items-center gap-1">
        <span>{`${neiUser?.name} ${neiUser?.surname}`}</span>{" "}
        <span className="flex gap-1">
          {iconMap.get(person.dish)}
          {allergyIcon(person.allergies)}
        </span>
      </div>
    </>
  );
}
