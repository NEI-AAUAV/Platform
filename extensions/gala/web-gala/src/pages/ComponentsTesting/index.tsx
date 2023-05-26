import TableModal from "@/components/TableModal";

const table = {
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
          allergies: "hahaha",
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
};

export default function ComponentsTesting() {
  return (
    <div className="absolute inset-0 z-50 flex items-center justify-center bg-black/50">
      <TableModal table={table} />
    </div>
  );
}
