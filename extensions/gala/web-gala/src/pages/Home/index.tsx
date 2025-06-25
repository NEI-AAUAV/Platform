import { Link, useNavigate } from "react-router-dom";
import useSessionUser, { State } from "@/hooks/userHooks/useSessionUser";
import useLoginLink from "@/hooks/useLoginLink";
import Input from "@/components/Input";
import { useForm, FormProvider, SubmitHandler } from "react-hook-form";
import { useEffect, useState } from "react";
import Button from "@/components/Button";
import useUserCreate from "@/hooks/userHooks/useUserCreate";

type FormValues = {
  matriculation: number | null;
  nmec: number | null;
  has_payed: boolean | null;
};

export default function Home() {
  const navigate = useNavigate();

  const loginLink = useLoginLink();
  const { state, sessionUser, isLoading, mutate: galaUserRefetch } = useSessionUser();
  const [_, setError] = useState<boolean>(false);

  useEffect(() => {
    if (!isLoading) galaUserRefetch();
  }, []);


  const formSubmit: SubmitHandler<FormValues> = async (data) => {
    try {
      const user = await useUserCreate({
        nmec: data.nmec,
        matriculation: data.matriculation,
      });
      galaUserRefetch(user);
    } catch (error) {
      setError(true);
      console.error(error);
      return;
    }
    navigate("/vote");
  };
  
  const methods = useForm<FormValues>({
    values: {
      matriculation: sessionUser?.matriculation ?? null,
      nmec: sessionUser?.nmec ?? null,
      has_payed: true,
    }
  });
  
  const header = {
    [State.NONE]: {
      label: "Iniciar Sessão",
      link: loginLink,
    },
    [State.REGISTERED]: {
      label: "Votar nos Nomeados",
      link: "/vote",
    },
  };

  const inGala = !!sessionUser?.nmec;  
  
  return (
    <div className="absolute inset-0 z-10 flex items-center justify-center">
      <div className="mx-4 flex flex-col items-center text-center text-base-content text-opacity-70">
        <h4 className="text-neutral-400 text-[1rem] font-bold sm:text-3xl">
          Olá!, Bem-vind@ ao
        </h4>
        <h1 className="text-light-gold text-[3rem] font-bold font-gala leading-tight text-center sm:text-[4rem]">
          Jantar <br /> de Gala
        </h1>
        {(state === State.NONE || state == State.REGISTERED) && (
        <Link
          className="mt-12 rounded-full bg-gradient-to-r from-[#F7BBAC] to-[#C58676] font-gala px-8 py-4 font-bold text-black backdrop-blur sm:text-[1.25rem]"
          to={header[state].link}
        >
          {header[state].label}
        </Link>
        )}
        {(state === State.AUTHENTICATED) && (
          <>
          <FormProvider {...methods}>
            <form
              className="flex flex-col items-center justify-center gap-4"
              onSubmit={methods.handleSubmit(formSubmit)}
            >
                <div className="my-6 w-full font-gala text-base-200">
                  Número Mecanográfico <br />
                  <Input
                    className="w-full px-4 py-1 my-2 text-black font-gala"
                    placeholder="nmec"
                    defaultValue={sessionUser?.nmec ?? ""}
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
                <Button submit className="font-gala"> Votar nos Nomeados</Button>
              </form>
            </FormProvider>
          </>
        )}
      </div>
    </div>
  );
}
