/* eslint-disable react/no-array-index-key */
import { Fragment } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faHandDots, faSeedling } from "@fortawesome/free-solid-svg-icons";
import { FrangoIcon } from "@/assets/icons";
import Guest from "./Guest";

type GuestListProps = {
  persons: Person[];
};
const orange = { color: "#DD8500" };
const green = { color: "#198754" };
const red = { color: "#DC3545" };

function countVegetarians(person: Person) {
  return person.companions.filter((companion) => companion.dish === "VEG")
    .length;
}

function countNormal(person: Person) {
  return person.companions.filter((companion) => companion.dish === "NOR")
    .length;
}

function countAllergies(person: Person) {
  return person.companions.filter((companion) => companion.allergies.length > 0)
    .length;
}

const gridTemplate = {
  gridTemplateColumns: "max-content 1fr",
};

export default function GuestList({ persons }: GuestListProps) {
  const filteredPersons = persons.filter((person) => person.confirmed);
  return (
    <div className="w-full">
      <h3 className="text-xl font-semibold">Convidad@s</h3>
      {filteredPersons.length === 0 && <p>Não há convidad@s nesta mesa</p>}
      <div className="flex flex-col gap-1">
        {filteredPersons.map((person) => (
          <div
            key={person.id}
            className="grid items-center gap-1"
            style={gridTemplate}
          >
            <Guest person={person} />
            <div />
            <div className="flex items-center gap-2 font-light">
              <span>
                {person.companions.length > 0 &&
                  `+${person.companions.length} companions`}
              </span>
              <span className="flex gap-1">
                {countNormal(person) > 0 && (
                  <span className="flex items-center gap-1">
                    <span className="text-sm text-base-content/70">
                      {countNormal(person)}
                    </span>
                    <FrangoIcon style={orange} />
                  </span>
                )}
                {countVegetarians(person) > 0 && (
                  <span className="flex items-center gap-1">
                    <span className="text-sm text-base-content/70">
                      {countVegetarians(person)}
                    </span>
                    <FontAwesomeIcon icon={faSeedling} style={green} />
                  </span>
                )}
                {countAllergies(person) > 0 && (
                  <span className="flex items-center gap-1">
                    <span className="text-sm text-base-content/70">
                      {countAllergies(person)}
                    </span>
                    <FontAwesomeIcon icon={faHandDots} style={red} />
                  </span>
                )}
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
