import { useEffect } from "react";
import config from "config";

export function Component() {
  useEffect(() => {
    globalThis.location.replace(config.AUTHENTIK_ENROLL_URL);
  }, []);

  return (
    <div className="flex h-screen items-center justify-center">
      <span className="loading loading-spinner loading-lg" />
    </div>
  );
}
