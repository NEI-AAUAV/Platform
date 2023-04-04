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
      <div className="m-auto sm:max-w-xl h-fit bg-base-200 rounded-2xl py-6 px-12 drop-shadow-lg shadow-secondary z-10 flex flex-col align-middle max-w-[80%]">
        <div className="text-3xl text-center mb-8">Sign Up</div>
        <form className="flex flex-col w-full" onSubmit={formSubmitted}>
          <div className="flex sm:flex-row flex-col justify-between w-full mb-5">
            <input
              className="input input-bordered sm:w-1/2 sm:mr-2"
              name="name"
              placeholder="Name"
              type="text"
              required
            />
            <input
              className="input input-bordered sm:w-1/2 sm:ml-2 sm:mt-0 mt-5"
              name="surname"
              placeholder="Surname"
              type="text"
              required
            />
          </div>
          <input
            className="input input-bordered mb-5"
            name="email"
            placeholder="Email"
            type="email"
            required
          />
          <input
            className="input input-bordered mb-5"
            name="password"
            placeholder="Password"
            type="password"
            required
            ref={passwordRef}
          />
          <input
            className="input input-bordered mb-5"
            name="confirm_password"
            placeholder="Repeat password"
            type="password"
            ref={confirmRef}
          />
          <p className="text-xs text-error hidden" ref={errorMessage}>
            Passwords não são iguais
          </p>
          <button
            className="btn btn-primary sm:btn-wide m-auto btn-block mt-5"
            disabled={reCaptchaLoaded ? null : ""}
            type="submit"
          >
            Register
          </button>
          <p className="mt-2 sm:text-sm text-xs m-auto max-w-xs">
            This site is protected by reCAPTCHA and the Google{" "}
            <a className="link link-primary" href="https://policies.google.com/privacy">Privacy Policy</a> and{" "}
            <a className="link link-primary" href="https://policies.google.com/terms">Terms of Service</a> apply.
          </p>
        </form>
        <p className="mt-2 sm:text-sm text-xs m-auto">
          Já tens uma conta?{" "}
          <Link to={"/auth/login"} className="link link-primary">
            Faz login
          </Link>
        </p>
      </div>
    </>
  );
};

export default Register;
