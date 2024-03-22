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
    <div
      className={classNames(
        "h-full md:grid md:grid-cols-[1fr_min-content] md:gap-8",
        {
          "md:h-auto": form,
          "md:h-full": !form,
        },
      )}
    >
      <FormProvider {...methods}>
        <form
          noValidate
          onSubmit={methods.handleSubmit(formSubmit)}
          className="flex h-full flex-col items-center gap-8 md:items-start"
        >
          <div className="flex w-full flex-col items-center gap-8 overflow-y-auto px-3 md:items-start">
            <div>
              <h1 className="text-3xl font-bold">{table.name}</h1>
              <div className="flex items-center">
                <h5 className="flex items-center gap-2 capitalize">
                  <Avatar id={table.head} className="w-[18px]" />
                  {`${neiUser?.name} ${neiUser?.surname}`}
                </h5>
              </div>
            </div>
            <VisualTable className="md:hidden" table={table} />
            {form ? (
              <RequestForm table={table} />
            ) : (
              <GuestList persons={table.persons} />
            )}
          </div>
          <Button
            className={classNames("mt-auto w-full", {
              hidden: form,
            })}
            onClick={() => setForm(true)}
          >
            <FontAwesomeIcon icon={faChair} /> Pedir convite para esta mesa
          </Button>
          <Button
            className={classNames("sticky bottom-0 mt-auto w-full", {
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
