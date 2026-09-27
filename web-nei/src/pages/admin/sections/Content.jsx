import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import service from "services/NEIService";

// Mirrors Infrastructure's services/directus/sql/managed-tables.txt.
const CMS_CONTENT = [
  { name: "News" },
  { name: "Notes", detail: "with subjects, teachers and authors" },
  { name: "RGM documents", detail: "grouped by mandate" },
  { name: "Team", detail: "mandates, sections and members" },
  { name: "Faina", detail: "mandates, roles and members" },
  { name: "History" },
  { name: "Videos", detail: "and their tags" },
  { name: "Partners" },
  { name: "Merch" },
];

export default function Content() {
  const [cms, setCms] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    service
      .getCmsInfo()
      .then((data) => setCms(data))
      .catch((e) => {
        console.error("Failed to load CMS info:", e);
        setError(`Failed to load the CMS link: ${e?.message || "Unknown error"}`);
      })
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <div className="text-sm opacity-70">Loading…</div>;

  return (
    <div className="flex flex-col gap-4">
      {error ? (
        <div className="alert alert-error" role="alert">
          <span>{error}</span>
        </div>
      ) : (
        <div className="alert" role="status">
          <div className="flex-1">
            <p className="font-semibold">Site content is edited in the CMS</p>
            <p className="text-sm opacity-80">
              The platform only displays this content. Sign in to the CMS with your Authentik account.
            </p>
          </div>
          <a
            href={cms.app_url}
            target="_blank"
            rel="noopener noreferrer"
            className="btn btn-sm btn-primary"
          >
            Open CMS
          </a>
        </div>
      )}

      <section className="rounded bg-base-200 p-3">
        <h2 className="mb-2 text-lg font-semibold">Edited in the CMS</h2>
        <ul className="grid gap-x-6 gap-y-1 text-sm sm:grid-cols-2">
          {CMS_CONTENT.map((item) => (
            <li key={item.name}>
              {item.name}
              {item.detail && <span className="opacity-70"> {item.detail}</span>}
            </li>
          ))}
        </ul>
      </section>

      <section className="rounded bg-base-200 p-3 text-sm">
        <h2 className="mb-1 text-lg font-semibold">Who can edit</h2>
        <p>
          Members of the <strong>cms-manager</strong> group can edit content. Members of{" "}
          <strong>admin</strong> or <strong>nei-admin</strong> also manage the CMS itself.
        </p>
        <p className="mt-2">
          To let someone edit, give them the <strong>cms-manager</strong> role in{" "}
          <Link to="/admin?tab=users" className="link">
            Users &amp; roles
          </Link>
          . It applies the next time they sign in to the CMS.
        </p>
      </section>
    </div>
  );
}
