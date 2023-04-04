import NEIService from "services/NEIService";
import { Link } from "react-router-dom";
import { useRef } from "react";
import { useReCaptcha } from "utils/hooks";

const Register = () => {
  const passwordRef = useRef(null);
  const confirmRef = useRef(null);
  const errorMessage = useRef(null);
  const { reCaptchaLoaded, generateReCaptchaToken } = useReCaptcha();

  const formSubmitted = async (event) => {
    event.preventDefault();

    const formData = new FormData(event.target);
    const data = Object.fromEntries(formData.entries());

    if (data.password !== data.confirm_password) {
      passwordRef.current.classList.add("input-error");
      confirmRef.current.classList.add("input-error");
      errorMessage.current.classList.remove("hidden");
      return;
    } else {
      passwordRef.current.classList.remove("input-error");
      confirmRef.current.classList.remove("input-error");
      errorMessage.current.classList.add("hidden");
    }

    delete data.confirm_password;

    const token = await generateReCaptchaToken("register");
    data.recaptcha_token = token;
    const access = await NEIService.register(data);
    console.log(access);
  };

  return (
    <>
      <div className="z-10 m-auto flex h-fit max-w-lg flex-col rounded-2xl bg-base-200 py-6 px-6 align-middle shadow-md sm:max-w-xl sm:px-12">
        <div className="mb-2 text-center text-3xl">Criar Conta</div>
        <p className="m-auto mb-8 max-w-sm text-xs sm:text-sm">
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
        <form className="flex w-full flex-col" onSubmit={formSubmitted}>
          <div className="mb-1 flex w-full flex-col justify-between sm:flex-row">
            <div className="grow sm:mr-2">
              <label className="label">
                <span className="label-text">Nome</span>
              </label>
              <input
                className="input-bordered input w-full"
                name="name"
                placeholder="Nome"
                type="text"
                required
              />
            </div>
            <div className="grow mt-5 sm:ml-2 sm:mt-0">
              <label className="label">
                <span className="label-text">Sobrenome</span>
              </label>
              <input
                className="input-bordered input w-full"
                name="surname"
                placeholder="Sobrenome"
                type="text"
                required
              />
            </div>
          </div>
          <label className="label">
            <span className="label-text">Email</span>
          </label>
          <input
            className="input-bordered input mb-1"
            name="email"
            placeholder="Email"
            type="email"
            required
          />
          <label className="label">
            <span className="label-text">Palavra-passe</span>
          </label>
          <input
            className="input-bordered input mb-1"
            name="password"
            placeholder="Palavra-passe"
            type="password"
            required
            ref={passwordRef}
          />
          <label className="label">
            <span className="label-text">Confirmar Palavra-passe</span>
          </label>
          <input
            className="input-bordered input mb-1"
            name="confirm_password"
            placeholder="Confirmar Palavra-passe"
            type="password"
            ref={confirmRef}
          />
          <p className="hidden text-xs text-error" ref={errorMessage}>
            As palavra-passes não são iguais.
          </p>
          <button
            className="btn-primary btn-block btn m-auto mt-8 sm:btn-wide"
            disabled={reCaptchaLoaded ? null : ""}
            type="submit"
          >
            Registar
          </button>
        </form>
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
