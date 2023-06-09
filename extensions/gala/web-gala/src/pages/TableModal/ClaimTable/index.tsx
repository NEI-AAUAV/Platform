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
    <div className="items-center sm:flex">
      <FormProvider {...methods}>
        <form
          className="flex flex-col items-center gap-3"
          noValidate
          onSubmit={methods.handleSubmit(formSubmit)}
        >
          <div className="flex flex-col items-center gap-3 overflow-y-auto overflow-x-hidden px-10 pt-1 sm:items-start">
            <div className="relative sm:w-full">
              <Input
                className="px-4 py-3 sm:w-full"
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
                className="absolute right-0 h-full px-4"
                type="button"
                onClick={clearTitle}
              >
                <FontAwesomeIcon icon={faXmark} />
              </button>
            </div>
            <h6>
              <Avatar className="w-[18px]" /> Serás o dono da mesa
            </h6>
            <VisualTable className="sm:hidden" table={table} />
            <AddUserList
              className="sm:mt-10"
              freeSeats={table.seats - calculateOccupiedSeats(table.persons)}
            />
          </div>
          <Button className="mt-3" submit>
            <FontAwesomeIcon icon={faPlus} /> Criar mesa
          </Button>
        </form>
      </FormProvider>
      <VisualTable className="ml-auto mr-20 hidden sm:block" table={table} />
    </div>
  );
}
