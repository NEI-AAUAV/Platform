/* eslint-disable jsx-a11y/control-has-associated-label */
import { useEffect, useRef, useState } from "react";
import { useNavigate } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faCircleCheck,
  faCheck,
  faSeedling,
  faHandDots,
} from "@fortawesome/free-solid-svg-icons";

import { FrangoIcon } from "@/assets/icons";
import service from "@/services/GalaService";
import Input from "@/components/Input";
import useTables from "@/hooks/tableHooks/useTables";

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
    <div className="rounded-lg border border-secondary bg-white p-2 px-4">
      <div className="flex items-center justify-between">
        <div className="truncate text-sm font-medium text-gray-500">
          <span className="max-sm:hidden">Total de </span>
          {title}
          <p className="text-xl text-gray-900 [&_b]:before:font-medium [&_b]:before:content-['_/_'] first:[&_b]:before:content-none">
            {values.map((v) => (
              <b>{v}</b>
            ))}
          </p>
        </div>
      </div>
    </div>
  );
}

export default function Admin() {
  const [users, setUsers] = useState<User[]>([]);
  const [tableSize, setTableSize] = useState<number | undefined>();
  const confirmPaymentModalRef = useRef<HTMLDialogElement>(null);
  const navigate = useNavigate();
  const selectedUser = useRef<number | null>(null);
  const { tables } = useTables();

  useEffect(() => {
    service.user.listUsers().then((data) => {
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

  function addTable() {
    if (!tableSize) return;
    service.table.createTable({ seats: tableSize }).then(() => {
      window.location.pathname = "/gala/reserve";
    });
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
      {/* info cards for statistics */}
      <div className="mb-6 grid grid-cols-2 gap-4 xs:grid-cols-[repeat(auto-fit,_minmax(16rem,16rem))]">
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
      <div className="relative mx-auto w-fit xs:ml-auto xs:mr-0">
        <Input
          className="input-sm w-72 pl-4 pr-36"
          type="number"
          min={1}
          placeholder="Nº Lugares"
          onChange={(e) =>
            setTableSize(parseInt(e.target.value, 10) || undefined)
          }
          value={tableSize || ""}
        />
        <button
          className="btn-primary btn-sm btn absolute h-full !-translate-x-[100%] whitespace-nowrap rounded-full rounded-l-none"
          type="button"
          onClick={addTable}
        >
          Adicionar mesa
        </button>
      </div>
      <div className="my-10 overflow-x-auto">
        <table className="mx-auto table w-full leading-[1rem] [&_*]:py-1 [&_*]:text-[0.8rem]">
          {/* head */}
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
                        className="btn-primary btn-xs btn mr-3 rounded-full opacity-0 group-hover:opacity-100"
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
                <tr key={idx}>
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
        <h2 className="border-b border-black/20 p-4">Are you sure?</h2>
        <div className="grid grid-cols-2">
          <button
            type="button"
            className="border-r border-black/20 p-4 "
            onClick={async () => {
              confirmPaymentModalRef.current!.close();
              if (selectedUser.current === null) return;
              await service.user.editUser({
                id: selectedUser.current,
                has_payed: true,
              });
              navigate(0);
            }}
          >
            Yes
          </button>
          <button
            type="button"
            className="p-4"
            onClick={() => confirmPaymentModalRef.current!.close()}
          >
            No
          </button>
        </div>
      </dialog>
    </div>
  );
}
