import { faCircleCheck } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useState } from "react";
import Input from "@/components/Input";
import Select from "@/components/Select";
import useSessionUser from "@/hooks/userHooks/useSessionUser";
import useUserEdit from "@/hooks/userHooks/useUserEdit";

export default function Register() {
  const { sessionUser } = useSessionUser();

  const [selected, setSelected] = useState<number>(
    sessionUser?.matriculation ?? 1,
  );

  const options: [JSX.Element, number][] = [
    [<>1º Ano</>, 1],
    [<>2º Ano</>, 2],
    [<>3º Ano</>, 3],
    [<>4º Ano</>, 4],
    [<>5º Ano ou mais</>, 5],
    [<>Outro (p.e. ex-alunos)</>, 0],
  ];

  return (
    <div className="mx-16 sm:mx-auto sm:max-w-xl">
      <h1 className="my-16 text-center text-3xl font-bold">Inscrição</h1>
      <div className="flex flex-col items-center">
        <div className="my-6 w-full">
          Número Mecanográfico <br />
          <Input
            className="w-full px-4 py-1"
            placeholder={String(sessionUser?.nmec ?? "nmec")}
            onBlur={(e) => {
              if (sessionUser === undefined) return;
              if (e.target.value === "") return;
              if (Number.isNaN(e.target.value)) return;
              if (!Number.isInteger(Number(e.target.value))) return;
              if (Number(e.target.value) === sessionUser.nmec) return;
              const nmec = Number(e.target.value);

              useUserEdit({
                id: sessionUser._id,
                email: sessionUser.email,
                name: sessionUser.name,
                matriculation: selected,
                nmec,
                has_payed: sessionUser.has_payed,
              });
            }}
            defaultValue={sessionUser?.nmec ?? ""}
          />
        </div>
        <div className="my-6 w-full">
          Estado do Pagamento <br />
          <div className="rounded-3xl border border-light-gold bg-gray-100 px-4 py-1">
            {!sessionUser?.has_payed ? (
              "Deves enviar o teu pagamento para o 9xx xxx xxx, via MB WAY."
            ) : (
              <>
                <FontAwesomeIcon
                  className="text-[#198754]"
                  icon={faCircleCheck}
                />{" "}
                Pago
              </>
            )}
          </div>
        </div>
        <div className="my-6 w-full">
          Matrícula <br />
          <Select
            title={<>Escolhe a tua Matrícula</>}
            selected={selected}
            setSelected={setSelected}
            options={options}
          />
        </div>
      </div>
    </div>
  );
}
