import NEIService from "services/NEIService";
import { Link } from "react-router-dom";
import logo from "../../assets/icons/ua_logo.svg";
import { useRef } from "react";

const Login = () => {
  const emailRef = useRef(null);
  const passwordRef = useRef(null);
  const errorMessage = useRef(null);

  const formSubmitted = async (event) => {
    event.preventDefault();

    const formData = new FormData(event.target);
    try {
      const access = await NEIService.login(formData);
      console.log(access);

      emailRef.current.classList.remove("input-error");
      passwordRef.current.classList.remove("input-error");
      errorMessage.current.classList.add("hidden");
    } catch (error) {
      emailRef.current.classList.add("input-error");
      passwordRef.current.classList.add("input-error");
      errorMessage.current.classList.remove("hidden");
    }
  };

  return (
    <>
      <div className="m-auto sm:max-w-md h-fit bg-base-200 rounded-2xl py-6 px-14 drop-shadow-lg shadow-secondary z-10 flex flex-col align-middle max-w-[80%]">
        <div className="text-3xl text-center">Log in</div>
        <button className="btn btn-lg m-auto mt-8 mb-3 py-3 sm:px-6 px-8">
          <img src={logo} className="object-fit bg-center max-h-full" />
        </button>
        <div className="divider">OR</div>
        <form onSubmit={formSubmitted}>
          <div className="flex flex-col">
            <label className="label">
              <span className="label-text">Email</span>
            </label>
            <input
              className="input input-bordered input-primary w-full mb-1"
              name="username"
              placeholder="Email"
              type="email"
              ref={emailRef}
            />
            <label className="label">
              <span className="label-text">Password</span>
            </label>
            <input
              className="input input-bordered input-primary w-full"
              name="password"
              placeholder="Password"
              type="password"
              ref={passwordRef}
            />
            <button
              className="btn btn-primary sm:btn-wide m-auto btn-block mt-10"
              type="submit"
            >
              Login
            </button>
            <p
              className="text-xs text-error hidden mt-2 text-center"
              ref={errorMessage}
            >
              Email ou Password estão incorretos
            </p>
            <p className="mt-2 sm:text-sm text-xs m-auto">
              Não tens uma conta?{" "}
              <Link to={"/register"} className="link link-primary">
                Regista-te
              </Link>
            </p>
          </div>
        </form>
      </div>
    </>
  );
};

export default Login;
