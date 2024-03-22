import NEIService from "services/NEIService";
import { useRef } from "react";

export function Component() {
  const emailRef = useRef(null);
  const errorMessage = useRef(null);
  const successMessage = useRef(null);

  const formSubmitted = async (event) => {
    event.preventDefault();

    const formData = new FormData(event.target);
    try {
      await NEIService.forgotPassword(formData);

      successMessage.current.classList.remove("hidden");
      emailRef.current.classList.remove("input-error");
      errorMessage.current.classList.add("hidden");
    } catch (error) {
      emailRef.current.classList.add("input-error");
      errorMessage.current.classList.remove("hidden");
    }
  };

  return (
    <>
      <div className="z-10 m-auto flex h-fit max-w-[80%] flex-col rounded-2xl bg-base-200 py-6 px-14 align-middle shadow-secondary drop-shadow-lg sm:max-w-md">
        <div className="mb-4 text-center text-3xl">Recupera a tua conta</div>
        <form onSubmit={formSubmitted}>
          <div className="flex flex-col">
            <label className="label">
              <span className="label-text">Email</span>
            </label>
            <input
              className="input-bordered input mb-1 w-full"
              name="email"
              placeholder="Email"
              type="email"
              ref={emailRef}
            />
            <button
              className="btn-primary btn-block btn m-auto mt-8"
              type="submit"
            >
              Recuperar conta
            </button>
            <p
              className="mt-2 hidden text-center text-xs text-error"
              ref={errorMessage}
            >
              Erro a enviar o email de recuperação
            </p>
            <p
              className="mt-2 hidden text-center text-xs text-success"
              ref={successMessage}
            >
              Email de recuperação enviado com sucesso
            </p>
          </div>
        </form>
      </div>
    </>
  );
}
