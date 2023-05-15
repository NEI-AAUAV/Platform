import NEIService from "services/NEIService";
import { Link, useNavigate } from "react-router-dom";
import { useReCaptcha } from "utils/hooks";
import { useForm } from "react-hook-form";
import { Input } from "components/form";

const emailRegex =
  /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;

const Register = () => {
  const navigate = useNavigate();
  const {
    register,
    handleSubmit,
    watch,
    formState: { errors },
  } = useForm();

  console.log("🚀 ~ file: index.jsx:29 ~ Register ~ errors:", errors);
  const password = watch("password", "");

  const { reCaptchaLoaded, generateReCaptchaToken } = useReCaptcha();

  const formSubmitted = async (data) => {
    console.log("🚀 ~ file: index.jsx:43 ~ formSubmitted ~ event:", data);

    delete data.confirmPassword;

    const token = await generateReCaptchaToken("register");
    data.recaptcha_token = token;
    NEIService.register(data)
      .then((response) => {
        navigate("/");
      })
      .catch((error) => {
        console.error("Could not register user.");
      });
  };

  return (
    <>
      <div className="z-10 m-auto flex h-fit max-w-lg flex-col rounded-box bg-base-200 py-8 px-3 align-middle shadow-md sm:max-w-xl xs:px-14">
        <div className="mb-2 text-center text-3xl font-bold">Criar Conta</div>
        <p className="m-auto mb-8 max-w-sm text-xs sm:text-sm text-center">
          Este site é protegido pelo reCAPTCHA e aplicam-se a{" "}
          <a
            className="link-primary link whitespace-nowrap"
            href="https://policies.google.com/privacy"
          >
            Política de Privacidade
          </a>{" "}
          e os{" "}
          <a
            className="link-primary link whitespace-nowrap"
            href="https://policies.google.com/terms"
          >
            Termos de Serviço
          </a>{" "}
          do Google.
        </p>
        <form
          className="flex w-full flex-col"
          noValidate
          onSubmit={handleSubmit(formSubmitted)}
        >
          <div className="mb-1 flex w-full gap-3 flex-col justify-between sm:flex-row">
            <Input
              className="grow sm:mr-2"
              id="name"
              label="Nome"
              error={errors?.name}
              placeholder="Nome"
              name="name"
              {...register("name", {
                required: { value: true, message: "Nome é obrigatório" },
                minLength: {
                  value: 2,
                  message: "O nome tem de ter pelo menos 2 carateres",
                },
              })}
            ></Input>
            <Input
              className="grow mt-5 sm:ml-2 sm:mt-0"
              id="lastName"
              label="Sobrenome"
              error={errors?.lastName}
              placeholder="Sobrenome"
              name="surname"
              {...register("surname", {
                required: { value: true, message: "Nome é obrigatório" },
                minLength: {
                  value: 2,
                  message: "O nome tem de ter pelo menos 2 carateres",
                },
              })}
            ></Input>
          </div>

          <Input
            id="email"
            label="Email"
            error={errors?.email}
            placeholder="Email"
            type="email"
            name="email"
            {...register("email", {
              required: { value: true, message: "Email é obrigatório" },
              pattern: {
                value: emailRegex,
                message: "Email inválido",
              },
            })}
          ></Input>

          <Input
            id="password"
            label="Palavra-passe"
            error={errors?.password}
            placeholder="Palavra-passe"
            type="password"
            name="password"
            {...register("password", {
              required: { value: true, message: "Palavra-passe é obrigatória" },
              minLength: {
                value: 8,
                message: "A palavra-passe tem de ter pelo menos 8 carateres",
              },
            })}
          ></Input>

          <Input
            id="confirmPassword"
            label="Confirmar Palavra-passe"
            error={errors?.confirmPassword}
            placeholder="Confirmar Palavra-passe"
            type="password"
            name="confirmPassword"
            {...register("confirmPassword", {
              required: { value: true, message: "Confirmação é obrigatória" },
              validate: (value) =>
                value === password || "As palavra-passes não são iguais",
            })}
          ></Input>

          <button
            className="btn-primary btn-block btn m-auto mt-8 sm:btn-wide"
            disabled={reCaptchaLoaded ? null : ""}
            type="submit"
          >
            Registar
          </button>
        </form>
        <p className="m-auto mt-2 text-xs sm:text-sm">
          Terás de ativar o teu email no email que indicares.
        </p>
        <p className="m-auto mt-2 text-xs sm:text-sm">
          Já estás registado?{" "}
          <Link to={"/auth/login"} className="link-primary link">
            Inicia sessão aqui.
          </Link>
        </p>
      </div>
    </>
  );
};

export default Register;
