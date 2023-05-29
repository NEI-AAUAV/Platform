import { Navigate, useNavigate, useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import TableModal from "../TableModal";
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
    _id: 1,
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
    _id: 2,
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
    _id: 3,
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
    _id: 4,
    name: "mesa2",
    head: "John Doe",
    seats: 10,
    persons: [],
  },
  {
    _id: 5,
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
    _id: 6,
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
    _id: 7,
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
    _id: 8,
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

function useTable(id: string | undefined) {
  const [tableById, setTableById] = useState<Table>();
  const navigate = useNavigate();
  useEffect(() => {
    if (id === undefined) return;
    // TODO: fetch table from server and separate this hook
    const tableFromId = testingTables.find(
      (table) => table._id === parseInt(id, 10),
    );
    if (tableFromId === undefined) {
      navigate("/reserve");
    }
    setTableById(tableFromId);
  }, [id]);

  return tableById;
}

export default function Reserve() {
  const { tableId } = useParams();
  const tablePage = useTable(tableId);
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
      {tablePage !== undefined && <TableModal table={tablePage} />}
    </>
  );
}
