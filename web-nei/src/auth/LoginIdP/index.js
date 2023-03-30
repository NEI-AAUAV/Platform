import { useState, useEffect } from "react";

import service from "services/NEIService";

/**
 * Login page for Identiy provider-initiated SSO
 */
export default function ConfirmEmail() {
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    service
      .loginIdP()
      .then(({ url }) => {
        window.location.href = url;
      })
      .catch(() => {
        setLoading(false);
      });
  }, []);

  return (
    <div>
      {!!loading ? (
        <h1>Loading</h1>
      ) : (
        <>
          <h3>Failed to auth IDP. Please try again later.</h3>
        </>
      )}
    </div>
  );
}
