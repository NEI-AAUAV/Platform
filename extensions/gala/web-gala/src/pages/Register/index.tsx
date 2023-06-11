/* eslint-disable react/jsx-props-no-spreading */
import { Link, Navigate, useNavigate } from "react-router-dom";
import { useForm, FormProvider, SubmitHandler } from "react-hook-form";
import { faCaretDown, faCircleCheck } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useEffect, useState } from "react";
import Input from "@/components/Input";
import Select from "@/components/Select";
import { useUserStore } from "@/stores/useUserStore";
import Button from "@/components/Button";
import useUserCreate from "@/hooks/userHooks/useUserCreate";
import useSessionUser from "@/hooks/userHooks/useSessionUser";

type FormValues = {
  matriculation: number | null;
  nmec: number | null;
  has_payed: boolean | null;
};

export default function Register() {
  const navigate = useNavigate();

  const [selected, setSelected] = useState<number | null>(null);
  const { sessionUser, isLoading, mutate: galaUserRefetch } = useSessionUser();

  useEffect(() => {
    if (!isLoading) galaUserRefetch();
  }, []);

  const { sessionLoading, sub } = useUserStore((state) => ({
    sessionLoading: state.sessionLoading,
    sub: state.sub,
  }));

  const methods = useForm<FormValues>({
    values: {
      matriculation: sessionUser?.matriculation ?? null,
      nmec: sessionUser?.nmec ?? null,
      has_payed: sessionUser?.has_payed ?? false,
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
      galaUserRefetch(user);
    } catch (error) {
      console.error(error);
      return;
    }
    navigate("/");
  };

  const inGala = !!sessionUser?.nmec;

  return (
    <div className="mx-16 sm:mx-auto sm:max-w-xl">
      {!sessionLoading && sub === undefined && <Navigate to="/" />}
      <h1 className="mb-8 mt-16 text-center text-3xl font-bold">Inscrição</h1>
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
              {methods.getValues().has_payed ? (
                <>
                  Deves enviar o teu pagamento para o <b>927 144 824</b>, via MB
                  WAY com a descrição:
                  <br />
                  <em>{"Jantar de Gala - <nome> <nmec>"}</em>
                  <br />
                  <br />
                  <b className="block text-center text-primary">
                    ... ou de preferência ...
                  </b>
                  <br />
                  Enviar o comprovatido para{" "}
                  <a
                    href="mailto:galacomissao.nei@gmail.com"
                    className="link font-bold"
                  >
                    galacomissao.nei@gmail.com
                  </a>{" "}
                  com o assunto:
                  <br />
                  <em>{"Comprovativo de Pagamento - <nome> <nmec>"}</em>
                </>
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
      <h1 className="mb-8 mt-16 text-center text-3xl font-bold">
        Para os Finalistas
      </h1>
      <p>
        Caro(a) finalista,
        <br />
        Parabéns pela conclusão desta etapa importante!
        <br />
        Deste mais um passo na longa caminhada que ainda tens à tua frente.
        <br />
        Mas nós não queremos que fiques esquecido!
        <br />
        Desta forma gostariamos que preenchesses o seguinte forms de modo a
        podermos preparar-te um miminho!
      </p>
      <div className="text-center">
        <Link
          className="btn-secondary btn-wide btn mb-32 mt-8 rounded-full normal-case"
          to="https://forms.gle/CcSHMJWnC56HUSLh9"
          target="_blank"
          rel="noopener noreferrer"
          type="button"
        >
          Formulário
        </Link>
      </div>
    </div>
  );
}
