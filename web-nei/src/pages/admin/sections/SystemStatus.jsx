import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";
import service from "services/NEIService";

const INTEGRATIONS = [
  { key: "oidc", label: "Sign-in with Authentik" },
  { key: "authentik_api", label: "Role management through Authentik" },
  { key: "email", label: "Email sending" },
  { key: "recaptcha", label: "reCAPTCHA on sign-up" },
];

function Row({ label, children }) {
  return (
    <div className="flex flex-col gap-0.5 py-2 sm:flex-row sm:gap-4">
      <dt className="shrink-0 text-sm opacity-70 sm:w-56">{label}</dt>
      <dd className="text-sm">{children}</dd>
    </div>
  );
}

Row.propTypes = {
  label: PropTypes.string.isRequired,
  children: PropTypes.node.isRequired,
};

function describeExtensions(extensions) {
  if (extensions === null) return "All installed extensions (ENABLED_EXTENSIONS is not set)";
  if (extensions.length === 0) return "None";
  return extensions.join(", ");
}

export default function SystemStatus() {
  const [system, setSystem] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    service
      .getSystemStatus()
      .then((data) => setSystem(data))
      .catch((e) => {
        console.error("Failed to load system status:", e);
        setError(`Failed to load system status: ${e?.message || "Unknown error"}`);
      })
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <div className="text-sm opacity-70">Loading system status…</div>;
  if (error) {
    return (
      <div className="alert alert-error" role="alert">
        <span>{error}</span>
      </div>
    );
  }

  const { database } = system;
  const migrationKnown = database.current && database.expected;
  const migrationBehind = migrationKnown && database.current !== database.expected;
  const offInProduction = system.production
    ? INTEGRATIONS.filter(({ key }) => !system.integrations[key])
    : [];

  return (
    <div className="flex flex-col gap-4">
      {migrationBehind && (
        <div className="alert alert-error" role="alert">
          <span>
            The database is on migration <code>{database.current}</code>, but this code expects{" "}
            <code>{database.expected}</code>. Run the migrations before relying on new features.
          </span>
        </div>
      )}
      {offInProduction.length > 0 && (
        <div className="alert alert-warning" role="status">
          <span>
            Switched off in production: {offInProduction.map(({ label }) => label).join(", ")}.
          </span>
        </div>
      )}

      <section className="rounded bg-base-200 p-3">
        <h2 className="mb-1 text-lg font-semibold">Deployment</h2>
        <dl className="divide-y divide-base-300">
          <Row label="Environment">{system.production ? "Production" : "Development"}</Row>
          <Row label="Commit">
            {system.commit ? (
              <code title={system.commit}>{system.commit.slice(0, 7)}</code>
            ) : (
              <span className="opacity-70">Not recorded (local build)</span>
            )}
          </Row>
          <Row label="Database migration">
            {migrationKnown ? (
              <>
                <code>{database.current}</code>{" "}
                {migrationBehind ? (
                  <span className="badge badge-error badge-sm">out of date</span>
                ) : (
                  <span className="badge badge-success badge-sm">up to date</span>
                )}
              </>
            ) : (
              <span className="opacity-70">Couldn&apos;t be read; check the API logs</span>
            )}
          </Row>
          <Row label="Extensions">{describeExtensions(system.extensions)}</Row>
        </dl>
      </section>

      <section className="rounded bg-base-200 p-3">
        <h2 className="mb-1 text-lg font-semibold">Integrations</h2>
        <dl className="divide-y divide-base-300">
          {INTEGRATIONS.map(({ key, label }) => (
            <Row key={key} label={label}>
              {system.integrations[key] ? "On" : <span className="opacity-70">Off</span>}
            </Row>
          ))}
        </dl>
      </section>
    </div>
  );
}
