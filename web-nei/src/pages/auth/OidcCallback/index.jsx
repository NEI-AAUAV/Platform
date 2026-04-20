import { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useUserStore } from "stores/useUserStore";

// Parse URL fragment (#foo=bar&baz=qux). Returns {} when absent.
function parseHash(hash) {
  if (!hash || hash.length < 2) return {};
  return Object.fromEntries(new URLSearchParams(hash.slice(1)));
}

function isSafeRedirect(value) {
  if (!value || typeof value !== "string") return false;
  const v = value.trim();
  if (!v.startsWith("/")) return false;
  if (v.length > 1 && "/\\\t \n\r".includes(v[1])) return false;
  return true;
}

export function Component() {
  const navigate = useNavigate();

  useEffect(() => {
    const params = parseHash(globalThis.location.hash);
    const token = params.token;
    const redirect_to = params.redirect_to;

    // Clear the token from the URL so it doesn't linger in browser history.
    if (globalThis.history?.replaceState) {
      globalThis.history.replaceState(
        null,
        "",
        globalThis.location.pathname + globalThis.location.search
      );
    }

    if (!token) {
      navigate("/auth/login");
      return;
    }

    try {
      useUserStore.getState().login({ token });
    } catch {
      navigate("/auth/login?error=session_failed");
      return;
    }

    if (isSafeRedirect(redirect_to)) {
      globalThis.location.replace(redirect_to);
    } else {
      navigate("/");
    }
  }, []);

  return (
    <div className="flex h-screen items-center justify-center">
      <span className="loading loading-spinner loading-lg" />
    </div>
  );
}
