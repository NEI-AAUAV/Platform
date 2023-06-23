/* eslint-disable react/no-array-index-key */
/* eslint-disable jsx-a11y/label-has-associated-control */
/* eslint-disable jsx-a11y/control-has-associated-label */
import { useCallback, useEffect, useRef, useState } from "react";
import { useNavigate } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faCircleCheck,
  faCheck,
  faSeedling,
  faHandDots,
  faXmark,
  faEllipsis,
} from "@fortawesome/free-solid-svg-icons";
import classNames from "classnames";

import { FrangoIcon } from "@/assets/icons";
import Input from "@/components/Input";
import useTime from "@/hooks/timeHooks/useTime";
import useTimeEdit from "@/hooks/timeHooks/useTimeEdit";
import useTables from "@/hooks/tableHooks/useTables";
import useLimits from "@/hooks/useLimits";
import GalaService from "@/services/GalaService";
import VoteResults from "@/components/VoteCard/VoteResults";

const orange = { color: "#DD8500" };
const green = { color: "#198754" };
const red = { color: "#DC3545" };

const iconMap = new Map([
  ["NOR", <FrangoIcon style={orange} />],
  ["VEG", <FontAwesomeIcon icon={faSeedling} style={green} />],
]);

type InfoProps = {
  title: string;
  values: number[];
};

function Info({ title, values }: InfoProps) {
  return (
    <div className="rounded-lg bg-base-200 p-2 px-4 shadow">
      <div className="mx-auto flex items-center justify-between max-xs:max-w-[18rem]">
        <div className="w-full text-sm font-medium text-gray-500 max-xs:flex max-xs:justify-between">
          <span className="max-sm:hidden">Total de </span>
          <span>{title}</span>
          <div className="whitespace-nowrap text-xl text-gray-900 [&_b]:before:font-medium [&_b]:before:content-['_/_'] first:[&_b]:before:content-none">
            {values.map((v, idx) => (
              <b key={idx}>{v}</b>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

interface TimeSlotsProps {
  start: "tablesStart" | "votesStart";
  end: "tablesEnd" | "votesEnd";
}

function TimeSlots({ start, end }: TimeSlotsProps) {
  const { time } = useTime();
  const [notDirty, setNotDirty] = useState(false);
  const [openingTime, setOpeningTime] = useState<string | undefined>();
  const [closingTime, setClosingTime] = useState<string | undefined>();

  useEffect(() => {
    setOpeningTime(time?.[start].slice(0, 16));
    setClosingTime(time?.[end].slice(0, 16));
  }, [time]);

  useEffect(() => {
    setNotDirty(
      (time?.[start].startsWith(openingTime || "") &&
        time?.[end].startsWith(closingTime || "")) ??
        false,
    );
  }, [openingTime, closingTime]);

  const handleOpeningTimeChange = (
    event: React.ChangeEvent<HTMLInputElement>,
  ) => {
    setOpeningTime(event.target.value);
  };

  const handleClosingTimeChange = (
    event: React.ChangeEvent<HTMLInputElement>,
  ) => {
    setClosingTime(event.target.value);
  };

  const handleSubmit = () => {
    if (!time) return;
    useTimeEdit({ [start]: openingTime, [end]: closingTime }).then((res) => {
      setNotDirty(
        (res[start].startsWith(openingTime || "") &&
          res[end].startsWith(closingTime || "")) ??
          false,
      );
      time[start] = openingTime || "";
      time[end] = closingTime || "";
    });
  };

  const timeSlotsStatus = useCallback(() => {
    if (!openingTime || !closingTime) return "";
    const openDate = new Date(openingTime);
    const closeDate = new Date(closingTime);
    const currentDate = new Date();
    currentDate.setHours(currentDate.getHours() - 1);
    if (currentDate < openDate) {
      return "Por abrir";
    }
    if (currentDate >= openDate && currentDate <= closeDate) {
      return "Aberto";
    }
    return "Fechado";
  }, [openingTime, closingTime]);

  return (
    <form className="flex flex-col gap-2">
      <label className="flex items-center justify-between gap-2">
        <span>Abrir</span>
        <Input
          type="datetime-local"
          className="input-sm"
          value={openingTime}
          onChange={handleOpeningTimeChange}
        />
      </label>
      <label className="flex items-center justify-between gap-2">
        <span>Fechar</span>
        <Input
          type="datetime-local"
          className="input-sm"
          value={closingTime}
          onChange={handleClosingTimeChange}
        />
      </label>
      <div className="flex items-center justify-between">
        <span className="text-sm font-bold text-gray-500">
          {timeSlotsStatus()}
        </span>
        <button
          className="btn-primary btn-sm btn rounded-full normal-case"
          onClick={handleSubmit}
          disabled={notDirty}
          type="button"
        >
          Alterar abertura
        </button>
      </div>
    </form>
  );
}

function AddTable() {
  const [tableSize, setTableSize] = useState<number | undefined>();

  function addTable() {
    if (!tableSize) return;
    GalaService.table.createTable({ seats: tableSize }).then(() => {
      window.location.pathname = "/gala/reserve";
    });
  }

  return (
    <div className="w-50 relative mx-auto h-fit xs:ml-auto xs:mr-0">
      <Input
        className="input-sm w-full pr-36"
        type="number"
        min={1}
        placeholder="Nº Lugares"
        onChange={(e) =>
          setTableSize(parseInt(e.target.value, 10) || undefined)
        }
        value={tableSize || ""}
      />
      <button
        className="btn-primary btn-sm btn absolute right-0 top-0 mt-[2px] whitespace-nowrap rounded-full normal-case"
        type="button"
        onClick={addTable}
      >
        Adicionar mesa
      </button>
    </div>
  );
}

function RegistrationLimit() {
  const { limits, refresh } = useLimits();
  const [maxRegistrations, setMaxRegistrations] = useState<number>(0);

  useEffect(() => {
    if (!limits) return;
    setMaxRegistrations(limits.maxRegistrations);
  }, [limits]);

  function updateMaxRegistrations() {
    if (limits?.maxRegistrations === maxRegistrations) return;
    GalaService.limits.editTimeSlots({ maxRegistrations });
    refresh();
  }

  return (
    <div className="w-50 relative mx-auto h-fit xs:ml-auto xs:mr-0">
      <Input
        className="input-sm w-full pr-24"
        type="number"
        min={1}
        placeholder="Máximo inscrições"
        onChange={(e) => {
          const num = parseInt(e.target.value, 10);
          if (num === null) return;
          setMaxRegistrations(num);
        }}
        value={maxRegistrations}
      />
      <button
        className="btn-primary btn-sm btn absolute right-0 top-0 mt-[2px] whitespace-nowrap rounded-full normal-case"
        type="button"
        onClick={updateMaxRegistrations}
      >
        Atualizar
      </button>
    </div>
  );
}

function ControlCardInner() {
  return (
    <>
      <div className="flex basis-0 flex-col">
        <h2 className="mb-4 font-bold">Reservar Lugar</h2>
        <TimeSlots start="tablesStart" end="tablesEnd" />
      </div>
      <div className="flex basis-0 flex-col">
        <h2 className="mb-4 font-bold">Votar</h2>
        <TimeSlots start="votesStart" end="votesEnd" />
      </div>
      <div className="flex basis-0 flex-col">
        <h2 className="mb-4 font-bold">Mesas</h2>
        <AddTable />
      </div>
      <div className="flex basis-0 flex-col">
        <h2 className="mb-4 font-bold">Máximo inscrições</h2>
        <RegistrationLimit />
      </div>
    </>
  );
}

export default function Admin() {
  const [controlCardOpen, setControlCardOpen] = useState(false);
  const [users, setUsers] = useState<User[]>([]);
  const confirmPaymentModalRef = useRef<HTMLDialogElement>(null);
  const navigate = useNavigate();
  const selectedUser = useRef<number | null>(null);
  const { tables } = useTables();

  useEffect(() => {
    GalaService.user.listUsers().then((data) => {
      setUsers(data);
    });
  }, []);

  const persons: Person[] = tables.reduce((acc: Person[], table) => {
    return acc.concat(table.persons);
  }, []);

  const usersExtended: UserExtended[] = users.map((u) => {
    const match = persons.find((p) => p.id === u._id);
    return { companions: [], ...u, ...match } as UserExtended;
  });

  function modalConfirmPayment(id: number) {
    selectedUser.current = id;
    confirmPaymentModalRef.current!.showModal();
  }

  const sumOfAllCompanions = persons.reduce(
    (sum, p) => sum + (p.companions.length ?? 0),
    0,
  );

  const sumOfAllVegetarians = persons.reduce(
    (sum, p) =>
      sum +
      (p.dish === "VEG" ? 1 : 0) +
      (p.companions.filter((c: Companion) => c.dish === "VEG").length ?? 0),
    0,
  );

  const sumOfAllPayments = users.reduce(
    (sum, u) => sum + (u.has_payed ? 1 : 0),
    0,
  );

  return (
    <div className="mx-auto mt-12 max-w-7xl">
      {/* Info cards for statistics */}
      <div className="flex gap-3 max-xs:flex-col xs:gap-4 xs:[&_*]:basis-60">
        <Info
          title="Reservas / Inscritos"
          values={[
            persons.length + sumOfAllCompanions,
            users.length + sumOfAllCompanions,
          ]}
        />
        <Info title="Vegetarianos" values={[sumOfAllVegetarians]} />
        <Info title="Pagamentos" values={[sumOfAllPayments, users.length]} />
      </div>

      {/* Control card */}
      <div
        className={classNames(
          "relative mt-6 grid grid-cols-[repeat(auto-fit,_minmax(18rem,18rem))] justify-center gap-x-20 gap-y-10 bg-base-200 shadow",
          !controlCardOpen
            ? "mb-6 ml-auto w-fit rounded-full bg-black/70 p-[1.45rem] text-white backdrop-blur hover:bg-neutral-focus"
            : "mb-10 rounded-lg p-4",
        )}
      >
        {controlCardOpen && <ControlCardInner />}
        <button
          className="absolute right-2 top-2 h-8 w-8 leading-none"
          type="button"
          onClick={() => setControlCardOpen(!controlCardOpen)}
        >
          <FontAwesomeIcon icon={controlCardOpen ? faXmark : faEllipsis} />
        </button>
      </div>

      {/* Table */}
      <div className="overflow-x-auto">
        <table className="mx-auto table w-full leading-[1rem] [&_*]:py-1 [&_*]:text-[0.8rem]">
          <thead>
            <tr className="border-b-2 border-primary [&_th]:bg-transparent">
              <th className="!bg-base-100">NMec</th>
              <th>Email</th>
              <th>Nome</th>
              <th>Matrícula</th>
              <th>Prato</th>
              <th>Estado do Pagamento</th>
            </tr>
          </thead>
          <tbody>
            {usersExtended.map((user: UserExtended) => [
              <tr
                key={user._id}
                className="group [&_td]:hover:bg-[#F9F2E8] [&_th]:hover:bg-[#F9F2E8]"
              >
                <th>{user.nmec}</th>
                <td>{user.email}</td>
                <td>{user.name}</td>
                <td>
                  {user.matriculation ? `${user.matriculation}º ano` : "Outro"}
                </td>
                <td>
                  <div className="flex items-center gap-3">
                    {iconMap.get(user.dish)}
                    {user.allergies && (
                      <FontAwesomeIcon style={red} icon={faHandDots} />
                    )}
                    <span>{user.allergies}</span>
                  </div>
                </td>
                <td>
                  {user.has_payed ? (
                    <div className="flex items-center gap-3">
                      <FontAwesomeIcon style={green} icon={faCircleCheck} />
                      Pago
                    </div>
                  ) : (
                    <div className="flex items-center gap-3">
                      <FontAwesomeIcon
                        className="text-primary"
                        icon={faCheck}
                      />
                      A aguardar
                      <button
                        className="btn-primary btn-xs btn mr-3 rounded-full normal-case opacity-0 group-hover:opacity-100"
                        onClick={() => modalConfirmPayment(user._id)}
                        type="button"
                      >
                        Confirmar
                      </button>
                    </div>
                  )}
                </td>
              </tr>,
              ...user.companions.map((c, idx) => (
                // eslint-disable-next-line react/no-array-index-key
                <tr key={`c${idx}`}>
                  <th />
                  <td />
                  <td />
                  <td />
                  <td>
                    <div className="flex items-center gap-3">
                      {iconMap.get(c.dish)}
                      {c.allergies && (
                        <FontAwesomeIcon style={red} icon={faHandDots} />
                      )}
                      <span>{c.allergies}</span>
                    </div>
                  </td>
                  <td />
                </tr>
              )),
            ])}
          </tbody>
        </table>
      </div>
      <dialog
        className="overflow-hidden rounded-3xl p-0 backdrop:bg-black backdrop:opacity-50"
        ref={confirmPaymentModalRef}
      >
        <h2 className="border-b border-black/20 p-8">
          Tens a certeza que queres confirmar o pagamento?
        </h2>
        <div className="grid grid-cols-2">
          <button
            type="button"
            className="border-r border-black/20 p-4 "
            onClick={async () => {
              confirmPaymentModalRef.current!.close();
              if (selectedUser.current === null) return;
              await GalaService.user.editUser({
                id: selectedUser.current,
                has_payed: true,
              });
              navigate(0);
            }}
          >
            Sim
          </button>
          <button
            type="button"
            className="p-4"
            onClick={() => confirmPaymentModalRef.current!.close()}
          >
            Não
          </button>
        </div>
      </dialog>

      {/* Vote Results */}
      <VoteResults />
    </div>
  );
}
