import { useState, useEffect } from "react";

import { useSearchParams } from "react-router";

import service from "services/NEIService";

/**
 * Login page for Identiy provider-initiated SSO
 */
export default function ConfirmEmail() {
  const [loading, setLoading] = useState(true);
  const [success, setSuccess] = useState(false);
  const [searchParams, setSearchParams] = useSearchParams();

  useEffect(() => {
    setLoading(true);

    const params = {
      oauthToken: searchParams.get("oauth_token"),
      oauthVerifier: searchParams.get("oauth_verifier"),
    };

    service
      .redirectIdP(params)
      .then(() => {
        setSuccess(true);
        setLoading(false);
      })
      .catch(() => {
        setSuccess(false);
        setLoading(false);
      });
  }, []);

  return (
    <div>
      {!!loading ? (
        <h1>Loading</h1>
      ) : (
        <>
          {!!success ? (
            <>
              <h1>Authenticated with IDP.</h1>
            </>
          ) : (
            <>
              <h3>Failed to auth IDP. Please try again later.</h3>
            </>
          )}
        </>
      )}
    </div>
  );
}
