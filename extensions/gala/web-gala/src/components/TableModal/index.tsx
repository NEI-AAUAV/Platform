/* eslint-disable react/jsx-props-no-spreading */
import { useForm } from "react-hook-form";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPaperPlane, faPlus } from "@fortawesome/free-solid-svg-icons";
import VisualTable from "@/components/Table/VisualTable";
import GuestList from "./GuestList";
import AddUser from "./AddUser";
import Input from "../Input";

type TableModalProps = {
  table: Table;
  status: "free" | "occupied" | "owner" | "guest";
  className?: string;
};

function getStatusUiProps(
  status: TableModalProps["status"],
  name: string,
  head: string,
  register: ReturnType<typeof useForm>["register"],
) {
  const header = (
    <>
      <h4 className="z-10 text-xl font-semibold">{name}</h4>
      <h6 className="z-10 text-sm font-light uppercase">{head}</h6>
    </>
  );
  const states = {
    free: {
      header: (
        <>
          <Input
            className="px-4 py-3"
            placeholder="Título da Mesa"
            {...register("title", { required: true, maxLength: 20 })}
          />
          <h6>Serás o dono da mesa</h6>
        </>
      ),
      guestList: false,
      body: <AddUser />,
      button: (
        <>
          <FontAwesomeIcon icon={faPlus} /> Criar mesa
        </>
      ),
    },
    occupied: {
      header,
      guestList: true,
      body: <>ola</>,
      button: (
        <>
          <FontAwesomeIcon icon={faPaperPlane} /> Enviar Convite
        </>
      ),
    },
    owner: {
      header,
      guestList: true,
      body: <>ola</>,
      button: (
        <>
          <FontAwesomeIcon icon={faPaperPlane} /> Enviar Convite
        </>
      ),
    },
    guest: {
      header,
      guestList: true,
      body: <>ola</>,
      button: (
        <>
          <FontAwesomeIcon icon={faPaperPlane} /> Enviar Convite
        </>
      ),
    },
  };

  return states[status];
}

function formSubmit(data: any) {
  console.log(data);
}

export default function TableModal({
  table,
  status,
  className,
}: TableModalProps) {
  const {
    register,
    handleSubmit,
    // formState: { errors },
  } = useForm();
  const { name, head, persons } = table;
  const tableUi = getStatusUiProps(status, name, head, register);

  return (
    <form
      className={`flex flex-col items-center gap-3 rounded-3xl bg-base-100 p-4 shadow-lg md:block  ${className}`}
      noValidate
      onSubmit={handleSubmit(formSubmit)}
    >
      {tableUi.header}
      <VisualTable table={table} />
      {tableUi.guestList && (
        <>
          <h3 className="text-xl font-semibold">Convidad@s</h3>
          <GuestList persons={persons} />
        </>
      )}
      {tableUi.body}
      <br />
      <button
        type="button"
        className="rounded-3xl bg-gradient-to-tr from-dark-gold to-light-gold px-4 py-2 font-semibold"
      >
        {tableUi.button}
      </button>
    </form>
  );
}

TableModal.defaultProps = {
  className: "",
};
