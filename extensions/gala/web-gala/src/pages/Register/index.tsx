/* eslint-disable react/jsx-props-no-spreading */
import { Navigate, useNavigate } from "react-router-dom";
import { useForm, FormProvider, SubmitHandler } from "react-hook-form";
import { faCaretDown, faCircleCheck } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useState } from "react";
import Input from "@/components/Input";
import Select from "@/components/Select";
import useSessionUser from "@/hooks/userHooks/useSessionUser";
import { useUserStore } from "@/stores/useUserStore";
import Button from "@/components/Button";
import useUserCreate from "@/hooks/userHooks/useUserCreate";
import useUserEdit from "@/hooks/userHooks/useUserEdit";

type FormValues = {
  name: string;
  email: string;
  matriculation: number | null;
  nmec: number | null;
};

export default function Register() {
  const { sessionUser } = useSessionUser();
  const userState = useUserStore((state) => state);
  const navigate = useNavigate();

  const methods = useForm<FormValues>({
    defaultValues: {
      name:
        sessionUser?.name ??
        `${userState?.name ?? ""} ${userState?.surname ?? ""}`,
      email: sessionUser?.email ?? "",
      matriculation: sessionUser?.matriculation ?? null,
      nmec: sessionUser?.nmec ?? null,
    },
  });
  const { sessionLoading, sub } = useUserStore((state) => ({
    sessionLoading: state.sessionLoading,
    sub: state.sub,
  }));

  const [selected, setSelected] = useState<number | null>(
    sessionUser?.matriculation ?? null,
  );

  const options: [JSX.Element, number | null][] = [
    [<>1º Ano</>, 1],
    [<>2º Ano</>, 2],
    [<>3º Ano</>, 3],
    [<>4º Ano</>, 4],
    [<>5º Ano ou mais</>, 5],
    [<>Outro (p.e. ex-alunos)</>, null],
  ];

  const formSubmit: SubmitHandler<FormValues> = async (data) => {
    if (sessionUser === undefined) {
      await useUserCreate({
        email: data.email,
        matriculation: data.matriculation,
      });
    }

    await useUserEdit({
      id: sessionUser?._id ?? 0,
      name: data.name,
      nmec: data.nmec,
      email: data.email,
      matriculation: data.matriculation,
      has_payed: sessionUser?.has_payed ?? false,
    });
    navigate("/");
  };

  return (
    <div className="mx-16 sm:mx-auto sm:max-w-xl">
      {!sessionLoading && sub === undefined && <Navigate to="/" />}
      <h1 className="my-16 text-center text-3xl font-bold">Inscrição</h1>
      <FormProvider {...methods}>
        <form
          className="flex flex-col items-center"
          noValidate
          onSubmit={methods.handleSubmit(formSubmit)}
        >
          <div className="my-6 w-full">
            Número Mecanográfico <br />
            <Input
              className="w-full px-4 py-1"
              placeholder="nmec"
              {...methods.register("nmec", {
                required: "Este campo é obrigatório",
                pattern: {
                  value: /^[0-9]+$/,
                  message: "O número mecanográfico deve conter apenas números",
                },
              })}
            />
            {methods.formState.errors.nmec && (
              <p className="text-red-500">
                {methods.formState.errors.nmec.message}
              </p>
            )}
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
              onChange={(e) => {
                methods.setValue("matriculation", e);
              }}
              title={
                <>
                  Escolhe a tua Matrícula{" "}
                  <FontAwesomeIcon
                    className="ml-auto ui-open:rotate-180"
                    icon={faCaretDown}
                  />
                </>
              }
              selected={selected}
              setSelected={setSelected}
              options={options}
            />
          </div>
          <Button submit>Submeter</Button>
        </form>
      </FormProvider>
    </div>
  );
}
