import NEIService from "services/NEIService";
import { Link } from "react-router-dom";
import { useRef } from "react";

const Register = () => {
  const passwordRef = useRef(null);
  const confirmRef = useRef(null);
  const errorMessage = useRef(null);

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

    const access = await NEIService.register(data);
    console.log(access);
  };

  return (
    <>
      <div className="m-auto sm:max-w-xl h-fit bg-base-200 rounded-2xl py-6 px-12 drop-shadow-lg shadow-secondary z-10 flex flex-col align-middle max-w-[80%]">
        <div className="text-3xl text-center mb-8">Sign Up</div>
        <form className="flex flex-col w-full" onSubmit={formSubmitted}>
          <div className="flex flex-row justify-between w-full mb-5">
            <input
              className="input input-bordered input-primary max-w-xs"
              name="name"
              placeholder="Name"
              type="text"
              required
            />
            <input
              className="input input-bordered input-primary max-w-xs"
              name="surname"
              placeholder="Surname"
              type="text"
              required
            />
          </div>
          <input
            className="input input-bordered input-primary mb-5"
            name="email"
            placeholder="Email"
            type="email"
            required
          />
          <input
            className="input input-bordered input-primary mb-5"
            name="password"
            placeholder="Password"
            type="password"
            required
            ref={passwordRef}
          />
          <input
            className="input input-bordered input-primary mb-5"
            name="confirm_password"
            placeholder="Repeat password"
            type="password"
            ref={confirmRef}
          />
          <p className="text-xs text-error hidden" ref={errorMessage}>
            Passwords não são iguais
          </p>
          <button className="btn sm:btn-wide m-auto btn-block mt-2">
            captcha
          </button>
          <button
            className="btn btn-primary sm:btn-wide m-auto btn-block mt-5"
            type="submit"
          >
            Register
          </button>
        </form>
        <p className="mt-2 sm:text-sm text-xs m-auto">
          Já tens uma conta?{" "}
          <Link to={"/login"} className="link link-primary">
            Faz login
          </Link>
        </p>
      </div>
    </>
  );
};

export default Register;
