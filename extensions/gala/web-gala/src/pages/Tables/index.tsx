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
  {
    _id: 0,
    name: "mesa2",
    head: "John Doe",
    seats: 5,
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
  {
    _id: 0,
    name: "mesa2",
    head: "John Doe",
    seats: 10,
    persons: [],
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
          {
            dish: "NOR",
            allergies: "",
          },
          {
            dish: "NOR",
            allergies: "",
          },
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
      <h2 className="m-20 text-center text-2xl font-bold">
        Escolhe a tua mesa.
      </h2>
      <div className="mx-10 grid grid-cols-[repeat(auto-fit,_minmax(13.25rem,_1fr))] gap-14">
        {testingTables.map((table) => (
          <Table key={table._id} table={table} />
        ))}
      </div>
    </>
  );
}
