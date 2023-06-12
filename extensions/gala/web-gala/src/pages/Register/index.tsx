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
      <div className="[&_b]:font-semibold [&_p]:mt-3">
        <p>
          O jantar terá um custo de <b>38€ (inclui transporte)</b> onde poderás
          contar com:
        </p>
        <ul className="list-inside list-disc pl-6">
          <li>Entradas</li>
          <li>Sopa</li>
          <li>
            Pratos Principais:
            <ul className="list-inside list-decimal pl-6">
              <li>Carne : Arroz de Pato</li>
              <li>Vegetariano/Vegan : Tofu com legumes salteados</li>
            </ul>
          </li>
          <li>Sobremesa</li>
          <li>AfterParty (Bar aberto)</li>
        </ul>
        <p>
          O pagamento realiza-se por <b>MB Way</b> para os números da respetiva
          matrículas.
        </p>
        <p>
          Após a submissão do formulário tens <b>48h</b> para realizar o
          pagamento com a seguinte descrição{" "}
          <b>{'"Pagamento Jantar de Gala de <Nome> - <Nmec>"'}</b> e enviar o
          comprovativo para{" "}
          <a
            href="mailto:galacomissao.nei@gmail.com"
            className="link-hover link font-semibold"
          >
            galacomissao.nei@gmail.com
          </a>{" "}
          com o mesmo assunto.
        </p>
        <p>Pagamento:</p>
        <table className="ml-6">
          {[
            ["1ª", "967 892 167", "Sara Almeida"],
            ["2ª", "916 162 223", "Roberto Castro"],
            ["3ª", "934 656 375", "Marta Inácio"],
            ["4ª", "925 097 774", "Renato Dias"],
            ["5ª+", "927 144 824", "Tiago Gomes"],
          ].map(([year, number, name]) => (
            <tr>
              <th className="w-14 text-left font-mono">{year}</th>
              <td className="w-32 font-mono">{number}</td>
              <td>({name})</td>
            </tr>
          ))}
        </table>
        <p>
          Caso não o faças dentro do prazo, a tua inscrição fica sem efeito.
        </p>
        <p>
          O pagamento do jantar dos acompanhantes deve ser realizada juntamente
          do pagamento normal (mesma transferência)
        </p>
        <p>Na eventualidade de não compareceres, não serás reembolsado.</p>
        <p>
          Inscreve-te até dia <b>16 de junho (15h)</b>.{" "}
          <b>Inscrições Limitadas</b>
        </p>
        <p>
          Qualquer dúvida não hesites!!! <br />
          Insta:{" "}
          <a
            href="https://www.instagram.com/jantardegalaei/"
            className="link-hover link font-semibold"
          >
            @jantardegalaei
          </a>{" "}
          <br />
          Email:{" "}
          <a
            href="mailto:galacomissao.nei@gmail.com"
            className="link-hover link font-semibold"
          >
            galacomissao.nei@gmail.com
          </a>{" "}
          /{" "}
          <a
            href="mailto:neiaauav@gmail.com"
            className="link-hover link font-semibold"
          >
            neiaauav@gmail.com
          </a>
        </p>
      </div>
      <FormProvider {...methods}>
        <form
          className="mt-5 flex flex-col items-center"
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
                <>
                  <FontAwesomeIcon
                    className="opacity-30"
                    icon={faCircleCheck}
                  />{" "}
                  Por confirmar
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
          {!inGala && <Button submit>Efetuar inscrição</Button>}
        </form>
      </FormProvider>
      <h1 className="mb-8 mt-20 text-center text-3xl font-bold">
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
          to="https://forms.gle/CcSHMJWnC56HUSLh9"
          target="_blank"
          rel="noopener noreferrer"
          type="button"
        >
          <Button className="mb-32 mt-5">Aceder Formulário</Button>
        </Link>
      </div>
    </div>
  );
}
