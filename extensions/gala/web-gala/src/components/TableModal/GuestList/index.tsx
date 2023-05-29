type GuestListProps = {
  persons: Person[];
};

export default function GuestList({ persons }: GuestListProps) {
  return (
    <div className="flex flex-col gap-2">
      {persons.map((person) => (
        <div key={person.id} className="flex flex-col gap-1">
          <h4 className="text-lg font-semibold">{person.id}</h4>
          <div className="ml-4 flex flex-col gap-1">
            <h5 className="text-base font-semibold">{person.dish}</h5>
            <h6 className="text-sm font-light">{person.allergies}</h6>
            {person.companions.map((companion) => (
              <div key={companion.dish} className="ml-4 flex flex-col gap-1">
                <h5 className="text-base font-semibold">{companion.dish}</h5>
                <h6 className="text-sm font-light">{companion.allergies}</h6>
              </div>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
}
