/* eslint-disable react/jsx-props-no-spreading */
import { Navigate, useNavigate } from "react-router-dom";
import { useForm, FormProvider, SubmitHandler } from "react-hook-form";
import { faCaretDown, faCircleCheck } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useState } from "react";
import Input from "@/components/Input";
import Select from "@/components/Select";
import { useUserStore } from "@/stores/useUserStore";
import { useGalaUserStore } from "@/stores/useGalaUserStore";
import Button from "@/components/Button";
import useUserCreate from "@/hooks/userHooks/useUserCreate";
import service from "@/services/GalaService";

type FormValues = {
  matriculation: number | null;
  nmec: number | null;
  has_payed: boolean | null;
};

export default function Register() {
  const navigate = useNavigate();

  const [selected, setSelected] = useState<number | null>(null);
  const { sessionLoading, sub } = useUserStore((state) => ({
    sessionLoading: state.sessionLoading,
    sub: state.sub,
  }));

  const methods = useForm<FormValues>({
    defaultValues: async () => {
      let user;
      try {
        user = await service.user.getSessionUser();
        setSelected(user?.matriculation ?? null);
      } catch (error) {
        console.error(error);
      }
      return {
        matriculation: user?.matriculation ?? null,
        nmec: user?.nmec ?? null,
        has_payed: user?.has_payed ?? false,
      };
    },
  });

  const options: [JSX.Element, number | null][] = [
    [<>1º Ano</>, 1],
    [<>2º Ano</>, 2],
    [<>3º Ano</>, 3],
    [<>4º Ano</>, 4],
    [<>5º Ano ou mais</>, 5],
    [<>Outro (p.e. ex-alunos)</>, null],
  ];

  const formSubmit: SubmitHandler<FormValues> = async (data) => {
    try {
      const user = await useUserCreate({
        nmec: data.nmec,
        matriculation: data.matriculation,
      });
      useGalaUserStore.setState(user);
    } catch (error) {
      console.error(error);
      return;
    }
    navigate("/");
  };

  const inGala = !!methods.formState.defaultValues?.nmec;

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
              disabled={inGala}
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
              {!methods.getValues().has_payed ? (
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
                methods.setValue("matriculation", e ?? null);
              }}
              title={
                <>
                  {options.find(
                    ([, v]) => v === methods.getValues().matriculation,
                  )?.[0] || "Escolhe a tua Matrícula "}
                  <FontAwesomeIcon
                    className="ml-auto ui-open:rotate-180"
                    icon={faCaretDown}
                  />
                </>
              }
              selected={selected}
              setSelected={setSelected}
              options={options}
              disabled={inGala}
            />
          </div>
          {!inGala && <Button submit>Submeter</Button>}
        </form>
      </FormProvider>
    </div>
  );
}
