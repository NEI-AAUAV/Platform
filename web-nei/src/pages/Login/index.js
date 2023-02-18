import NEIService from "services/NEIService";
import { Link } from "react-router-dom";
import logo from "../../assets/icons/ua_logo.svg";

const Login = () => {
  const formSubmitted = async (event) => {
    event.preventDefault();

    const formData = new FormData(event.target);
    const access = await NEIService.login(formData);
    console.log(access);
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
            />
            <label className="label">
              <span className="label-text">Password</span>
            </label>
            <input
              className="input input-bordered input-primary w-full mb-10"
              name="password"
              placeholder="Password"
              type="password"
            />
            <button
              className="btn btn-primary sm:btn-wide m-auto btn-block"
              type="submit"
            >
              Login
            </button>
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
