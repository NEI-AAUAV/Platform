import { useEffect } from "react";
import { useSearchParams } from "react-router-dom";
import { useUserStore } from "stores/useUserStore";
import config from "config";

export function Component() {
  const [searchParams] = useSearchParams();
  const { sessionLoading, token } = useUserStore((state) => state);

  useEffect(() => {
    if (sessionLoading) return;
    if (token) {
      const redirect_to = searchParams.get("redirect_to");
      globalThis.location.replace(redirect_to || "/");
      return;
    }

    const redirect_to = searchParams.get("redirect_to");
    const query = redirect_to ? `?redirect_to=${encodeURIComponent(redirect_to)}` : "";
    globalThis.location.replace(`${config.API_NEI_URL}/auth/oidc/login${query}`);
  }, [sessionLoading]);

  return (
    <div className="flex h-screen items-center justify-center">
      <span className="loading loading-spinner loading-lg" />
    </div>
  );
}
