import Table from "@/components/Table";

export default function Reserve() {
  return (
    <>
      <h2 className="text-2xl font-bold text-center m-20">
        Escolhe a tua mesa.
      </h2>
      <div className="">
        <Table occupiedSeats={8} />
      </div>
    </>
  );
}
