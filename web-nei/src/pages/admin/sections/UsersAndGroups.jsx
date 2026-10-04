import React, { useEffect, useMemo, useState } from "react";
import PropTypes from "prop-types";
import service from "services/NEIService";
import StatusMessages, { useStatusMessages } from "../StatusMessages";
import { formatDateTime } from "../formatDate";

function OpenAuthentikLink({ url, className = "" }) {
  return (
    <a href={url} target="_blank" rel="noopener noreferrer" className={`btn btn-sm ${className}`}>
      Open Authentik
    </a>
  );
}

OpenAuthentikLink.propTypes = {
  url: PropTypes.string.isRequired,
  className: PropTypes.string,
};

function AuthentikBanner({ status }) {
  if (!status.groups_managed) {
    return (
      <div className="alert alert-warning mb-3">
        <div className="flex-1">
          <p className="font-semibold">Role management is unavailable</p>
          <p className="text-sm">
            The API has no Authentik token, so roles can&apos;t be changed from here. Set{" "}
            <code>AUTHENTIK_TOKEN</code> on api-nei, or manage groups in Authentik directly.
          </p>
        </div>
        <OpenAuthentikLink url={status.admin_url} />
      </div>
    );
  }
  return (
    <div className="alert mb-3">
      <div className="flex-1">
        <p className="font-semibold">
          {status.oidc_enabled
            ? "Sign-in and roles are managed by Authentik"
            : "Roles are managed by Authentik"}
        </p>
        <p className="text-sm opacity-80">
          Ticking a box adds the user to the Authentik group for that role. A new role applies the
          next time they sign in; a removed one stops working within an hour. Other groups,
          including Authentik&apos;s own admin groups, are managed in Authentik.
        </p>
      </div>
      <OpenAuthentikLink url={status.admin_url} className="btn-primary" />
    </div>
  );
}

AuthentikBanner.propTypes = {
  status: PropTypes.shape({
    oidc_enabled: PropTypes.bool.isRequired,
    groups_managed: PropTypes.bool.isRequired,
    admin_url: PropTypes.string.isRequired,
  }).isRequired,
};

const displayName = (user) => `${user.name} ${user.surname}`.trim() || user.email;

export default function UsersAndGroups() {
  const [status, setStatus] = useState(null);
  const [statusLoading, setStatusLoading] = useState(true);
  const [users, setUsers] = useState([]);
  const [groups, setGroups] = useState([]);
  const [loading, setLoading] = useState(true);
  const [pending, setPending] = useState(""); // "{groupPk}:{userId}" or "signout:{userId}"
  const [emailFilter, setEmailFilter] = useState("");
  const [groupFilter, setGroupFilter] = useState("");
  const [neverSignedIn, setNeverSignedIn] = useState(false);
  const { error, setError, success, setSuccess, showSuccess } = useStatusMessages();

  const loadUsers = React.useCallback(
    () =>
      service
        .getUsers()
        .then((data) => setUsers(data))
        .catch((e) => {
          console.error("Failed to load users:", e);
          setError(`Failed to load users: ${e?.message || "Unknown error"}`);
        }),
    [setError]
  );

  const loadGroups = React.useCallback(
    () =>
      service
        .getAuthentikGroups()
        .then((data) => setGroups(data))
        .catch((e) => {
          console.error("Failed to load Authentik groups:", e);
          setError(`Failed to load Authentik groups: ${e?.message || "Unknown error"}`);
        }),
    [setError]
  );

  useEffect(() => {
    service
      .getAuthentikStatus()
      .then((data) => setStatus(data))
      .catch((e) => {
        console.error("Failed to load Authentik status:", e);
        setError(`Failed to load Authentik status: ${e?.message || "Unknown error"}`);
      })
      .finally(() => setStatusLoading(false));
  }, [setError]);

  useEffect(() => {
    if (statusLoading) return;
    setLoading(true);
    Promise.all([loadUsers(), status?.groups_managed ? loadGroups() : null])
      .catch((e) => {
        console.error("Failed to load users and groups:", e);
      })
      .finally(() => setLoading(false));
  }, [statusLoading, status, loadUsers, loadGroups]);

  const toggleRole = async (user, group) => {
    const key = `${group.pk}:${user.id}`;
    if (pending === key) return;

    if (!user.authentik_sub) {
      setError(`${displayName(user)} has not signed in with Authentik yet`);
      return;
    }

    const isMember = group.member_subs.includes(user.authentik_sub);
    setPending(key);
    try {
      if (isMember) {
        await service.removeUserFromAuthentikGroup(group.pk, user.id);
        showSuccess(`Removed the ${group.role} role from ${displayName(user)}`);
      } else {
        await service.addUserToAuthentikGroup(group.pk, user.id);
        showSuccess(`Gave ${displayName(user)} the ${group.role} role`);
      }
      await loadGroups();
    } catch (e) {
      setError(`Failed to change the ${group.role} role: ${e?.message || "Unknown error"}`);
    } finally {
      setPending("");
    }
  };

  const signOutEverywhere = async (user) => {
    const message =
      `Sign ${displayName(user)} out everywhere? They'll have to sign in again on every device. ` +
      "A page they already have open keeps working for up to an hour.";
    if (!globalThis.confirm(message)) return;

    setPending(`signout:${user.id}`);
    try {
      const { sessions_ended } = await service.signOutEverywhere(user.id);
      showSuccess(
        `Signed ${displayName(user)} out everywhere (${sessions_ended} session${sessions_ended === 1 ? "" : "s"} ended)`
      );
    } catch (e) {
      setError(`Failed to sign ${displayName(user)} out: ${e?.message || "Unknown error"}`);
    } finally {
      setPending("");
    }
  };

  const filteredUsers = useMemo(() => {
    return users.filter((user) => {
      const emailMatch =
        !emailFilter || user.email?.toLowerCase().includes(emailFilter.toLowerCase());
      const groupMatch =
        !groupFilter ||
        groups.some((g) => g.pk === groupFilter && g.member_subs.includes(user.authentik_sub));
      const signInMatch = !neverSignedIn || !user.authentik_sub;
      return emailMatch && groupMatch && signInMatch;
    });
  }, [users, emailFilter, groupFilter, neverSignedIn, groups]);

  if (statusLoading) {
    return <div className="text-sm opacity-70">Checking Authentik…</div>;
  }

  return (
    <div>
      {status && <AuthentikBanner status={status} />}

      <StatusMessages
        error={error}
        onDismissError={() => setError(null)}
        success={success}
        onDismissSuccess={() => setSuccess(null)}
      />

      <div className="rounded bg-base-200 p-3 mb-3">
        <div className="flex flex-col sm:flex-row sm:items-end gap-3">
          <div className="flex-1">
            <label htmlFor="filter-email" className="label">
              <span className="label-text">Email</span>
            </label>
            <input
              id="filter-email"
              type="text"
              placeholder="Filter by email..."
              className="input input-bordered input-sm w-full"
              value={emailFilter}
              onChange={(e) => setEmailFilter(e.target.value)}
            />
          </div>
          {groups.length > 0 && (
            <div className="flex-1">
              <label htmlFor="filter-group" className="label">
                <span className="label-text">Role</span>
              </label>
              <select
                id="filter-group"
                className="select select-bordered select-sm w-full"
                value={groupFilter}
                onChange={(e) => setGroupFilter(e.target.value)}
              >
                <option value="">All roles</option>
                {groups.map((g) => (
                  <option key={g.pk} value={g.pk}>
                    {g.role}
                  </option>
                ))}
              </select>
            </div>
          )}
          <button
            className="btn btn-outline btn-sm"
            onClick={() => {
              setEmailFilter("");
              setGroupFilter("");
              setNeverSignedIn(false);
            }}
          >
            Clear filters
          </button>
        </div>
        <label className="label cursor-pointer justify-start gap-2 mt-2">
          <input
            type="checkbox"
            className="checkbox checkbox-sm"
            checked={neverSignedIn}
            onChange={(e) => setNeverSignedIn(e.target.checked)}
          />
          <span className="label-text">Only accounts that never signed in with Authentik</span>
        </label>
        {filteredUsers.length !== users.length && (
          <div className="mt-1 text-sm opacity-70">
            Showing {filteredUsers.length} of {users.length} users
          </div>
        )}
      </div>

      {loading ? (
        <div className="text-sm opacity-70">Loading users…</div>
      ) : (
        <div className="overflow-auto rounded bg-base-200 p-2 max-h-[32rem]">
          <table className="table table-zebra table-sm">
            <thead>
              <tr>
                <th>User</th>
                <th>Email</th>
                <th className="whitespace-nowrap">Last sign-in</th>
                {groups.map((g) => (
                  <th
                    key={g.pk}
                    className="text-center text-xs whitespace-nowrap"
                    title={`Authentik group: ${g.name}`}
                  >
                    {g.role}
                  </th>
                ))}
                <th>
                  <span className="sr-only">Actions</span>
                </th>
              </tr>
            </thead>
            <tbody>
              {filteredUsers.map((u) => (
                <tr key={u.id} className={u.authentik_sub ? "" : "opacity-50"}>
                  <td className="whitespace-nowrap">
                    {u.name} {u.surname}
                    {!u.authentik_sub && (
                      <span
                        className="ml-1 badge badge-xs badge-ghost"
                        title="Has not signed in with Authentik yet"
                      >
                        no SSO
                      </span>
                    )}
                  </td>
                  <td className="font-mono text-xs">{u.email}</td>
                  <td className="whitespace-nowrap text-xs">
                    {formatDateTime(u.last_login_at) ?? <span className="opacity-60">never</span>}
                  </td>
                  {groups.map((g) => {
                    const isMember = u.authentik_sub && g.member_subs.includes(u.authentik_sub);
                    const key = `${g.pk}:${u.id}`;
                    return (
                      <td key={g.pk} className="text-center">
                        <input
                          type="checkbox"
                          className="checkbox checkbox-sm"
                          aria-label={`${g.role} role for ${u.name || u.email}`}
                          checked={!!isMember}
                          disabled={!u.authentik_sub || pending === key}
                          onChange={() => toggleRole(u, g)}
                        />
                      </td>
                    );
                  })}
                  <td className="text-right">
                    <button
                      className="btn btn-ghost btn-xs whitespace-nowrap"
                      onClick={() => signOutEverywhere(u)}
                      disabled={pending === `signout:${u.id}`}
                      aria-label={`Sign ${u.name || u.email} out everywhere`}
                    >
                      Sign out everywhere
                    </button>
                  </td>
                </tr>
              ))}
              {filteredUsers.length === 0 && (
                <tr>
                  <td colSpan={4 + groups.length} className="text-center opacity-60 py-4">
                    No users match these filters.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
