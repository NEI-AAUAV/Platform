import { useEffect, useRef, useState } from "react";

import service from "@/services/GalaService";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faCircleCheck, faCheck } from "@fortawesome/free-solid-svg-icons";
import { useNavigate } from "react-router-dom";

export default function Admin() {
  const [users, setUsers] = useState<User[]>([]);
  const confirmPaymentModalRef = useRef<HTMLDialogElement>(null);
  const navigate = useNavigate();
  const selectedUser = useRef<number | null>(null);

  function modalConfirmPayment(id: number) {
    selectedUser.current = id;
    confirmPaymentModalRef.current!.showModal();
  }

  useEffect(() => {
    service.user.listUsers().then((users) => {
      setUsers(users);
    });
  }, []);

  return (
    <div>
      <div className="my-20 overflow-x-auto">
        <table className="mx-auto table">
          {/* head */}
          <thead>
            <tr className="[&_th]:bg-primary/50">
              <th></th>
              <th>NMec</th>
              <th>Email</th>
              <th>Matrícula</th>
              <th>Nome</th>
              <th>Estado do Pagamento</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user: User) => (
              <tr className="group [&_td]:hover:bg-primary/20 [&_th]:hover:bg-primary/20">
                <th>{user._id}</th>
                <td>{user.nmec}</td>
                <td>{user.email}</td>
                <td>{user.matriculation} ano</td>
                <td>{user.name}</td>
                <td>
                  {user.has_payed ? (
                    <div className="flex gap-3 items-center">
                      <FontAwesomeIcon
                        className="text-[#198754]"
                        icon={faCircleCheck}
                      />
                      Pago
                    </div>
                  ) : (
                    <div className="flex gap-3 items-center">
                      <FontAwesomeIcon
                        className="text-primary"
                        icon={faCheck}
                      />
                      A aguardar confirmação
                      <button
                        className="btn-primary btn-xs btn rounded-full opacity-0 group-hover:opacity-100"
                        onClick={() => modalConfirmPayment(user._id)}
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
