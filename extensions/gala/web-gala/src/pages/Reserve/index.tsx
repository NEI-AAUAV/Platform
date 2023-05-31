import { Link, useNavigate, useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import TableModal from "../TableModal";
import Table from "@/components/Table";

const testingTables = [
  {
    _id: 0,
    name: "mesa1",
    head: 0,
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

function useTable() {
  const [tableById, setTableById] = useState<Table | undefined>(undefined);
  const navigate = useNavigate();
  const { tableId } = useParams();
  useEffect(() => {
    if (tableId === undefined) {
      setTableById(undefined);
      return;
    }
    // TODO: fetch table from server and separate this hook
    const tableFromId = testingTables.find(
      (table) => table._id === parseInt(tableId, 10),
    );
    if (tableFromId === undefined) {
      navigate("/reserve");
    }
    setTableById(tableFromId);
  }, [tableId]);

  return tableById;
}

export default function Reserve() {
  const tablePage = useTable();

  // TODO: Data fetching
  // useEffect(() => {
  //   const fetchTables = async () => {
  //     const response = await GalaService.listTables();
  //     const { data } = response.statusText;

  //     setStatusN(details);
  //     setTables(data);
  //   };
  //   fetchTables();
  // }, []);

  return (
    <>
      <h2 className="m-20 text-center text-2xl font-bold">
        Escolhe a tua mesa.
      </h2>
      <div className="mx-10 grid grid-cols-[repeat(auto-fit,_minmax(13.25rem,_1fr))] gap-14">
        {testingTables.map((table) => (
          <Link to={`/reserve/${table._id}`}>
            <Table table={table} />
          </Link>
        ))}
      </div>
      {tablePage !== undefined && <TableModal table={tablePage} />}
    </>
  );
}
