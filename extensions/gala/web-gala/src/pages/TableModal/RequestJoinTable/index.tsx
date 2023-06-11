/* eslint-disable react/jsx-props-no-spreading */
import { FormProvider, SubmitHandler, useForm } from "react-hook-form";
import { faPaperPlane, faChair } from "@fortawesome/free-solid-svg-icons";
import { useNavigate } from "react-router-dom";
import classNames from "classnames";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useState } from "react";
import Avatar from "@/components/Avatar";
import VisualTable from "@/components/Table/VisualTable";
import RequestForm from "./RequestForm";
import Button from "@/components/Button";
import useNEIUser from "@/hooks/useNEIUser";
import GuestList from "@/components/TableModal/GuestList";
import useTableReserve from "@/hooks/tableHooks/useTableReserve";

type RequestJoinTableProps = {
  table: Table;
  mutate: () => void;
};

type FormValues = {
  dish: "NOR" | "VEG";
  allergies: string;
  companions: {
    dish: "NOR" | "VEG";
    allergies: string;
  }[];
};

export default function RequestJoinTable({
  table,
  mutate,
}: RequestJoinTableProps) {
  const [form, setForm] = useState(false);
  const { neiUser } = useNEIUser(table.head);
  const methods = useForm<FormValues>({
    defaultValues: {
      dish: "NOR",
      allergies: "",
      companions: [],
    },
  });
  const navigate = useNavigate();

  const formSubmit: SubmitHandler<FormValues> = async (data) => {
    await useTableReserve(table._id, data);
    mutate();
    navigate("/reserve");
  };

  return (
    <div className="md:grid md:h-[max(100%,auto)] md:grid-cols-[1fr_min-content] md:gap-8">
      <FormProvider {...methods}>
        <form
          noValidate
          onSubmit={methods.handleSubmit(formSubmit)}
          className="flex flex-col items-center gap-3"
        >
          <div className="flex flex-col items-center gap-3 overflow-y-scroll px-3">
            <h1 className="text-3xl font-bold">{table.name}</h1>
            <div className="mb-10 flex items-center gap-3">
              <Avatar id={table.head} className="w-[18px]" />
              <h6 className="capitalize">{`${neiUser?.name} ${neiUser?.surname}`}</h6>
            </div>
            <VisualTable className="md:hidden" table={table} />
            {form ? (
              <RequestForm table={table} />
            ) : (
              <GuestList persons={table.persons} />
            )}
          </div>
          <Button
            className={classNames("mt-4 w-full", {
              hidden: form,
            })}
            onClick={() => setForm(true)}
          >
            <FontAwesomeIcon icon={faChair} /> Pedir convite para esta mesa
          </Button>
          <Button
            className={classNames("sticky bottom-0 mt-4 w-full", {
              hidden: !form,
            })}
            submit
          >
            <FontAwesomeIcon icon={faPaperPlane} /> Enviar Convite
          </Button>
        </form>
      </FormProvider>
      <div className="flex items-center justify-center">
        <VisualTable className="hidden md:block" table={table} />
      </div>
    </div>
  );
}
