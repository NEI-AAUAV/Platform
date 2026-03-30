import { useEffect } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { useUserStore } from "stores/useUserStore";

export function Component() {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();

  useEffect(() => {
    const token = searchParams.get("token");
    const redirect_to = searchParams.get("redirect_to");

    if (!token) {
      navigate("/auth/login");
      return;
    }

    try {
      useUserStore.getState().login({ token });
    } catch {
      navigate("/auth/login");
      return;
    }

    if (redirect_to) {
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
