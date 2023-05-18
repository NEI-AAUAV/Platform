import Table from "@/components/Table";

const testingTables = [
  {
    _id: 0,
    name: "mesa1",
    head: "João Beiros",
    seats: 8,
    persons: [
      {
        id: 0,
        allergies: "",
        dish: "Meat",
        confirmed: true,
        companions: [
          {
            dish: "NOR",
            allergies: "",
          },
        ],
      },
      {
        id: 1,
        allergies: "",
        dish: "NOR",
        confirmed: true,
        companions: [],
      },
    ],
  },
  {
    _id: 0,
    name: "mesa2",
    head: "John Doe",
    seats: 10,
    persons: [
      {
        id: 0,
        allergies: "",
        dish: "Meat",
        confirmed: true,
        companions: [
          {
            dish: "NOR",
            allergies: "",
          },
        ],
      },
      {
        id: 1,
        allergies: "",
        dish: "NOR",
        confirmed: true,
        companions: [
          {
            dish: "NOR",
            allergies: "",
          },
          {
            dish: "NOR",
            allergies: "",
          },
        ],
      },
    ],
  },
];

export default function Tables() {
  return (
    <>
      <h2 className="text-2xl font-bold text-center m-20">
        Escolhe a tua mesa.
      </h2>
      <div className="">
        {testingTables.map((table) => (
          <Table key={table._id} table={table} className="m-4" />
        ))}
      </div>
    </>
  );
}
