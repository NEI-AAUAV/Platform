import Requester from "./Requester";

type AcceptTableProps = {
  persons: Person[];
  tableId: number;
  mutate: () => void;
};

export default function AcceptPending({
  persons,
  tableId,
  mutate,
}: AcceptTableProps) {
  const filteredPersons = persons.filter((person) => !person.confirmed);

  return (
    <div className="w-full">
      <h3 className="text-xl font-semibold">
        {filteredPersons.length !== 0 && "Pendentes de Confirmação"}
      </h3>
      {filteredPersons.map((person) => (
        <div key={person.id} className="">
          <div className="flex items-start gap-2">
            <Requester person={person} tableId={tableId} mutate={mutate} />
          </div>
        </div>
      ))}
    </div>
  );
}
