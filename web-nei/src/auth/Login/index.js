import { Link } from "react-router-dom";
import logo from "assets/icons/ua_logo.svg";
import { useCallback, useEffect, useRef } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { useUserStore } from "stores/useUserStore";

import classNames from "classnames";

import { useLoading } from "utils/hooks";

import service from "services/NEIService";

const Status = {
  loading: 0b001,
  success: 0b010,
  error: 0b100,
  loadingLogin: 0b0001,
  loadingLoginIdP: 0b1001,
  errorLogin: 0b0100,
  errorLoginIdP: 0b1100,
};

const Login = ({ onRedirect }) => {
  const emailRef = useRef(null);
  const passwordRef = useRef(null);
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const [response, setResponse] = useLoading({
    status: onRedirect && Status.loadingLoginIdP,
  });

  // UseEffect to handle the response from the API
  useEffect(() => {
    switch (response.status) {
      case Status.success:
        navigate("/");
        break;
      case Status.errorLogin:
        addErrors();
        break;
      default:
        removeErrors();
        break;
    }
  }, [response]);

  // UseEffect to handle the redirect from the IdP
  useEffect(() => {
    if (!onRedirect) {
      return;
    }
    if (searchParams.get("consent") === "no") {
      setResponse({
        status: Status.errorLoginIdP,
        message: "Permissão não concedida.",
      });
      return;
    }

    const params = {
      oauthToken: searchParams.get("oauth_token"),
      oauthVerifier: searchParams.get("oauth_verifier"),
    };

    service
      .redirectIdP(params)
      .then(({ access_token }) => {
        useUserStore.getState().login({ token: access_token });
        setResponse(
          {
            status: Status.success,
          },
          2000
        );
      })
      .catch(() => {
        setResponse(
          {
            status: Status.errorLoginIdP,
            message: "Link inválido. Tenta novamente.",
          },
          2000
        );
      });
  }, []);

  const loginIdP = useCallback(() => {
    setResponse({ status: Status.loadingLoginIdP });
    service
      .loginIdP()
      .then(({ url }) => {
        // Redirect to the IdP service
        window.location.href = url;
      })
      .catch(() => {
        setResponse(
          {
            status: Status.errorLoginIdP,
            message: "Serviço indisponível.",
          },
          1000
        );
      });
  });

  const login = useCallback((event) => {
    event.preventDefault();
    setResponse({ status: Status.loadingLogin });

    const formData = new FormData(event.target);
    service
      .login(formData)
      .then(({ access_token }) => {
        useUserStore.getState().login({ token: access_token });
        setResponse(
          {
            status: Status.success,
          },
          1000
        );
      })
      .catch((e) => {
        console.error(e);
        setResponse(
          {
            status: Status.errorLogin,
            message: "Credenciais inválidas. Tenta novamente.",
          },
          1000
        );
      });
  });

  const addErrors = useCallback(() => {
    emailRef.current.classList.add("input-error");
    passwordRef.current.classList.add("input-error");
  });

  const removeErrors = useCallback(() => {
    emailRef.current.classList.remove("input-error");
    passwordRef.current.classList.remove("input-error");
  });

  const loading = response.status & Status.loading;

  return (
    <div className="rounded-box m-auto flex h-fit max-w-lg flex-col bg-base-200 py-6 px-6 align-middle shadow-secondary drop-shadow-md xs:px-14 sm:max-w-md">
      <div className="text-center text-3xl">Iniciar sessão</div>
      <button
        disabled={loading}
        onClick={loginIdP}
        className={classNames(
          "btn-block btn relative m-auto mt-8 before:absolute before:left-8",
          {
            loading: response.status === Status.loadingLoginIdP,
          }
        )}
      >
        <img src={logo} className="object-fit h-7 bg-center" />
      </button>
      <p
        className={classNames("mt-2 text-center text-xs text-error", {
          hidden: response.status !== Status.errorLoginIdP,
        })}
      >
        {response.message}
      </p>
      <div className="divider mt-8 text-base-content/50">ou</div>
      <form onSubmit={login}>
        <div className="flex flex-col">
          <label className="label">
            <span className="label-text">Email</span>
          </label>
          <input
            className="input-bordered input mb-1 w-full"
            name="username"
            placeholder="Email"
            type="email"
            ref={emailRef}
          />
          <label className="label">
            <span className="label-text">Palavra-passe</span>
          </label>
          <input
            className="input-bordered input w-full"
            name="password"
            placeholder="Palavra-passe"
            type="password"
            ref={passwordRef}
          />
          <Link to={"/auth/forgot"} className="label link-primary link text-sm">
            Esqueceste-te da tua password?
          </Link>
          <button
            disabled={loading}
            type="submit"
            className={classNames(
              "btn-primary btn-block btn relative m-auto mt-8 before:absolute before:left-8",
              {
                loading: response.status === Status.loadingLogin,
              }
            )}
          >
            Entrar
          </button>
          <p
            className={classNames("mt-2 text-center text-xs text-error", {
              hidden: response.status !== Status.errorLogin,
            })}
          >
            {response.message}
          </p>
          <p className="m-auto mt-2 text-xs sm:text-sm">
            Não estás registado?{" "}
            <Link to={"/auth/register"} className="link-primary link">
              Cria uma conta aqui.
            </Link>
          </p>
        </div>
      </form>
    </div>
  );
};

export default Login;