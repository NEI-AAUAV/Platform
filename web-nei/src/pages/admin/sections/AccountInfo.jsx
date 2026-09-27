import React, { useEffect, useState } from "react";
import service from "services/NEIService";

export default function AccountInfo() {
  const [me, setMe] = useState(null);
  const [loading, setLoading] = useState(true);
  const [failed, setFailed] = useState(false);

  useEffect(() => {
    service
      .getCurrUser()
      .then((data) => setMe(data))
      .catch((e) => {
        console.error("Failed to load your profile:", e);
        setFailed(true);
      })
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <div className="text-sm opacity-70">Loading your profile…</div>;
  if (failed || !me) {
    return (
      <div className="alert alert-error" role="alert">
        <span>Your profile couldn&apos;t be loaded. Reload the page to try again.</span>
      </div>
    );
  }

  return (
    <div className="rounded bg-base-200 p-3 text-sm">
      <p>
        Signed in as <strong>{me.name} {me.surname}</strong>
      </p>
      <p className="mt-2">Your scopes:</p>
      {me.scopes?.length > 0 ? (
        <ul className="mt-1 flex flex-wrap gap-1">
          {me.scopes.map((scope) => (
            <li key={scope} className="badge badge-outline">
              {scope}
            </li>
          ))}
        </ul>
      ) : (
        <p className="opacity-70">none</p>
      )}
      <p className="mt-3 opacity-70">
        Recently given a new role? Sign out and back in for it to apply.
      </p>
    </div>
  );
}
