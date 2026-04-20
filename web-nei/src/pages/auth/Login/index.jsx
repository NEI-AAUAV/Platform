import { useEffect } from "react";
import { Link, useSearchParams } from "react-router-dom";
import { useUserStore } from "stores/useUserStore";
import config from "config";

// Error codes surfaced by the backend's oidc_callback. Keep in sync with
// _login_error_redirect in api-nei/app/api/api_v1/auth/oidc.py.
const ERROR_COPY = {
  unverified: {
    title: "Verify your email to continue",
    body: "We sent you a verification link. Check your inbox (and spam folder), click the link, and come back to sign in.",
  },
  session: {
    title: "Your sign-in session expired",
    body: "Too much time passed between starting and completing sign-in. Please try again.",
  },
  idp_unreachable: {
    title: "Sign-in service is temporarily unavailable",
    body: "We couldn't reach the identity provider. Please try again in a moment.",
  },
  session_failed: {
    title: "Something went wrong starting your session",
    body: "Please try signing in again.",
  },
  invalid_response: {
    title: "Sign-in failed",
    body: "The identity provider returned an unexpected response. Please try again.",
  },
  unknown: {
    title: "Sign-in failed",
    body: "An unexpected error happened. Please try again, or contact us if the problem persists.",
  },
};

function startOidcLogin(redirect_to) {
  const query = redirect_to ? `?redirect_to=${encodeURIComponent(redirect_to)}` : "";
  globalThis.location.replace(`${config.API_NEI_URL}/auth/oidc/login${query}`);
}

export function Component() {
  const [searchParams] = useSearchParams();
  const { sessionLoading, token } = useUserStore((state) => state);

  const error = searchParams.get("error");
  const redirect_to = searchParams.get("redirect_to");

  useEffect(() => {
    if (sessionLoading) return;
    if (token) {
      globalThis.location.replace(redirect_to || "/");
      return;
    }
    if (error) return; // Render error screen; don't auto-loop into OIDC.
    startOidcLogin(redirect_to);
  }, [sessionLoading, token, error, redirect_to]);

  if (error) {
    const copy = ERROR_COPY[error] || ERROR_COPY.unknown;
    const retryHref = redirect_to
      ? `/auth/login?redirect_to=${encodeURIComponent(redirect_to)}`
      : "/auth/login";
    return (
      <div className="flex h-screen items-center justify-center p-6">
        <div className="card w-full max-w-md bg-base-100 shadow-xl">
          <div className="card-body items-center text-center">
            <h2 className="card-title text-2xl">{copy.title}</h2>
            <p className="py-2 text-base-content/80">{copy.body}</p>
            <div className="card-actions mt-4">
              <Link to={retryHref} className="btn btn-primary" replace>
                Try again
              </Link>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="flex h-screen items-center justify-center">
      <span className="loading loading-spinner loading-lg" />
    </div>
  );
}
