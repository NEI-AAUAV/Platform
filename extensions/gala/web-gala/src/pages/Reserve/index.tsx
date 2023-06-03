import { Link, useNavigate, useParams } from "react-router-dom";
import { Suspense, useEffect, useState } from "react";
import TableModal from "../TableModal";
import Table from "@/components/Table";
import useTables from "@/hooks/tableHooks/useTables";
import useTable from "@/hooks/tableHooks/useTable";
import { set } from "react-hook-form";

const testingTables = [
  {
    _id: 0,
    name: "mesa1",
    head: 0,
    seats: 8,
    persons: [
      {
        id: 3,
        allergies: "",
        dish: "VEG",
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
        allergies: "bananas",
        dish: "NOR",
        confirmed: true,
        companions: [],
      },
      {
        id: 2,
        allergies: "",
        dish: "NOR",
        confirmed: false,
        companions: [
          {
            dish: "VEG",
            allergies: "erva",
          },
        ],
      },
    ],
  },
  {
    _id: 1,
    name: "mesa2",
    head: 24434,
    seats: 10,
    persons: [
      {
        id: 0,
        allergies: "",
        dish: "NOR",
        confirmed: true,
        companions: [
          {
            dish: "NOR",
            allergies: "a",
          },
        ],
      },
      {
        id: 1,
        allergies: "",
        dish: "VEG",
        confirmed: true,
        companions: [
          {
            dish: "VEG",
            allergies: "a",
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
    head: 264872487,
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
    head: 479849587,
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
    head: 948084096,
    seats: 10,
    persons: [],
  },
  {
    _id: 5,
    name: "mesa2",
    head: 843058904986,
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
    head: 5975070948,
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
    head: 9847698749687,
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
    head: 8379573987,
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

function useTablePage() {
  const { table, setTableId } = useTable(undefined);
  const { tableId } = useParams();
  const navigate = useNavigate();

  useEffect(() => {
    setTableId(tableId ? Number(tableId) : undefined);
   
    if (table === null) {
      navigate("/reserve");
    }
  }, [tableId, table]);

  return table || undefined;
}

// function useTablePage() {
//   const { tableId } = useParams();
//   const navigate = useNavigate();
//   const { table, setTableId } = useTable(undefined);

//   useEffect(() => {
//     if (tableId === undefined) {
//       setTableId(undefined);
//       navigate("/reserve");
//       return;
//     }
//     setTableId(Number(tableId));
//   }, [tableId]);

//   useEffect(() => {
//     if (table === undefined) {
//       navigate("/reserve");
//     }
//   }, [table]);

//   return table;
// }

export default function Reserve() {
  const { tables } = useTables();
  const tablePage = useTablePage();

  useEffect(() => {
    console.count("rerendered");
  });

  return (
    <>
      <h2 className="m-20 text-center text-2xl font-bold">
        Escolhe a tua mesa.
      </h2>
      <div className="mx-10 grid grid-cols-[repeat(auto-fit,_minmax(13.25rem,_1fr))] gap-14">
        {tables?.map((table) => (
          <Link key={table._id} to={`/reserve/${table._id}`}>
            <Table table={table} />
          </Link>
        ))}
      </div>
      {tablePage !== undefined && <TableModal table={tablePage} />}
    </>
  );
}
