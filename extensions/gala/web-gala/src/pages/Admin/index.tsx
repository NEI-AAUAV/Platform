/* eslint-disable jsx-a11y/control-has-associated-label */
import { useEffect, useRef, useState } from "react";
import { useNavigate } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faCircleCheck, faCheck } from "@fortawesome/free-solid-svg-icons";

import service from "@/services/GalaService";
import Input from "@/components/Input";

export default function Admin() {
  const [users, setUsers] = useState<User[]>([]);
  const [tableSize, setTableSize] = useState<number | undefined>();
  const confirmPaymentModalRef = useRef<HTMLDialogElement>(null);
  const navigate = useNavigate();
  const selectedUser = useRef<number | null>(null);

  useEffect(() => {
    service.user.listUsers().then((u) => {
      setUsers(u);
    });
  }, []);

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

  return (
    <div>
      <div>
        {/* info cards for statistics */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
          <div className="rounded-lg bg-white p-4 shadow-md">
            <div className="flex items-center justify-between">
              <div className="truncate text-sm font-medium text-gray-500">
                Total de inscritos
                <div className="text-2xl font-bold text-gray-900">
                  {users.length}
                </div>
              </div>
            </div>
          </div>
          <div className="rounded-lg bg-white p-4 shadow-md">
            <div className="flex items-center justify-between">
              <div className="truncate text-sm font-medium text-gray-500">
                Total de inscritos
                <div className="text-2xl font-bold text-gray-900">
                  {users.length}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="relative ml-auto w-fit">
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
      <div className="my-20 overflow-x-auto">
        <table className="mx-auto table">
          {/* head */}
          <thead>
            <tr className="[&_th]:bg-primary/50">
              <th />
              <th>NMec</th>
              <th>Email</th>
              <th>Matrícula</th>
              <th>Nome</th>
              <th>Estado do Pagamento</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user: User) => (
              <tr
                key={user._id}
                className="group [&_td]:hover:bg-primary/20 [&_th]:hover:bg-primary/20"
              >
                <th>{user._id}</th>
                <td>{user.nmec}</td>
                <td>{user.email}</td>
                <td>{user.matriculation} ano</td>
                <td>{user.name}</td>
                <td>
                  {user.has_payed ? (
                    <div className="flex items-center gap-3">
                      <FontAwesomeIcon
                        className="text-[#198754]"
                        icon={faCircleCheck}
                      />
                      Pago
                    </div>
                  ) : (
                    <div className="flex items-center gap-3">
                      <FontAwesomeIcon
                        className="text-primary"
                        icon={faCheck}
                      />
                      A aguardar confirmação
                      <button
                        className="btn-primary btn-xs btn rounded-full opacity-0 group-hover:opacity-100"
                        onClick={() => modalConfirmPayment(user._id)}
                        type="button"
                      >
                        Confirmar
                      </button>
                    </div>
                  )}
                </td>
              </tr>
            ))}
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
