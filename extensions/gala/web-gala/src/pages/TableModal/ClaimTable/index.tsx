/* eslint-disable react/jsx-props-no-spreading */
import { useRef } from "react";
import { faPlus, faXmark } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useForm } from "react-hook-form";
import Input from "@/components/Input";
import VisualTable from "@/components/Table/VisualTable";
import AddUserList from "@/components/TableModal/AddUserList";
import Button from "@/components/Button";

type ClaimTableProps = {
  table: Table;
};

function formSubmit(data: any) {
  console.log(data);
}

export default function ClaimTable({ table }: ClaimTableProps) {
  const {
    register,
    handleSubmit,
    // formState: { errors },
  } = useForm();
  const titleRef = useRef<HTMLInputElement>(null);

  function clearTitle() {
    titleRef.current!.value = "";
    titleRef.current?.focus();
  }

  return (
    <form
      className="flex flex-col items-center gap-3 bg-base-100 md:block"
      noValidate
      onSubmit={handleSubmit(formSubmit)}
    >
      <div className="relative">
        <Input
          className="px-4 py-3"
          placeholder="Título da Mesa"
          {...register("title", { required: true, maxLength: 20 })}
          ref={titleRef}
        />
        <button
          className="absolute right-0 h-full px-4"
          type="button"
          onClick={clearTitle}
        >
          <FontAwesomeIcon icon={faXmark} />
        </button>
      </div>
      <h6>Serás o dono da mesa</h6>
      <VisualTable table={table} />
      <AddUserList />
      <br />
      <Button>
        <FontAwesomeIcon icon={faPlus} /> Criar mesa
      </Button>
    </form>
  );
}
