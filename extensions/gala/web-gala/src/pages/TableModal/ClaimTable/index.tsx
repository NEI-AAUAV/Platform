/* eslint-disable react/jsx-props-no-spreading */
import { useRef } from "react";
import { faPlus, faXmark } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useNavigate } from "react-router-dom";
import { FormProvider, SubmitHandler, useForm } from "react-hook-form";
import Input from "@/components/Input";
import VisualTable from "@/components/Table/VisualTable";
import AddUserList from "@/components/TableModal/AddUserList";
import Button from "@/components/Button";
import useTableReserve from "@/hooks/tableHooks/useTableReserve";
import useTableEdit from "@/hooks/tableHooks/useTableEdit";
import Avatar from "@/components/Avatar";

type ClaimTableProps = {
  table: Table;
  mutate: () => void;
};

type FormValues = {
  title: string;
  dish: "NOR" | "VEG";
  allergies: string;
  companions: {
    dish: "NOR" | "VEG";
    allergies: string;
  }[];
};

function calculateOccupiedSeats(persons: Person[]) {
  return persons.reduce((acc, person) => acc + 1 + person.companions.length, 0);
}

export default function ClaimTable({ table, mutate }: ClaimTableProps) {
  const methods = useForm<FormValues>({
    defaultValues: {
      title: "",
      dish: "NOR",
      allergies: "",
      companions: [],
    },
  });
  const navigate = useNavigate();

  const titleRef = useRef<HTMLInputElement | null>(null);
  const { ref, ...rest } = methods.register("title", {
    required: "Title is required",
    minLength: {
      value: 3,
      message: "Title must be at least 3 characters long",
    },
  });
  function clearTitle() {
    titleRef.current!.value = "";
    titleRef.current?.focus();
  }

  const formSubmit: SubmitHandler<FormValues> = async (data) => {
    const reserveRequest = {
      dish: data.dish,
      allergies: data.allergies,
      companions: data.companions,
    };

    const editRequest = {
      name: data.title,
    };
    useTableReserve(table._id, reserveRequest)
      .then(() => useTableEdit(table._id, editRequest))
      .finally(() => {
        mutate();
        navigate("/reserve");
      });
  };
  return (
    <div className="md:grid md:h-[max(100%,auto)] md:grid-cols-[1fr_min-content] md:gap-8">
      <FormProvider {...methods}>
        <form
          className="flex w-full flex-col gap-8"
          noValidate
          onSubmit={methods.handleSubmit(formSubmit)}
        >
          <div className="flex w-full flex-col items-center overflow-y-auto overflow-x-hidden md:items-start">
            <div className="relative w-full md:w-full">
              <Input
                className="px-4 py-3"
                placeholder="Título da Mesa"
                {...rest}
                ref={(e) => {
                  ref(e);
                  titleRef.current = e;
                }}
              />
              {methods.formState.errors.title && (
                <div className="text-xs text-red-500">
                  {methods.formState.errors.title.message}
                </div>
              )}
              <button
                className="absolute right-0 top-0 h-full px-4"
                type="button"
                onClick={clearTitle}
              >
                <FontAwesomeIcon icon={faXmark} />
              </button>
            </div>
            <h5 className="flex items-center gap-2">
              <Avatar className="w-[18px]" /> Serás o dono da mesa
            </h5>
            <VisualTable className="md:hidden" table={table} />
            <AddUserList
              className="md:mt-10"
              freeSeats={table.seats - calculateOccupiedSeats(table.persons)}
            />
          </div>
          <Button className="mt-auto" submit>
            <FontAwesomeIcon icon={faPlus} /> Criar mesa
          </Button>
        </form>
      </FormProvider>
      <div className="flex items-center justify-center">
        <VisualTable className="hidden md:block" table={table} />
      </div>
    </div>
  );
}
