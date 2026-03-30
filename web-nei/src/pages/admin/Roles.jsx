import React, { useEffect, useState, useMemo } from "react";
import service from "services/NEIService";
import { useUserStore } from "stores/useUserStore";
import { getArraialSocket } from "services/SocketService";

const SUCCESS_MESSAGE_TIMEOUT = 3000;

export function Component() {
  const { token } = useUserStore((s) => s);

  const [users, setUsers] = useState([]);
  const [groups, setGroups] = useState([]);
  const [loading, setLoading] = useState(true);
  const [groupsLoading, setGroupsLoading] = useState(true);
  const [error, setError] = useState(null);
  const [me, setMe] = useState(null);
  const [meLoading, setMeLoading] = useState(true);
  const [successMessage, setSuccessMessage] = useState(null);
  const [pendingToggle, setPendingToggle] = useState(null); // "{groupPk}:{userId}"
  const timeoutsRef = React.useRef([]);

  const [arraialConfig, setArraialConfig] = useState(null);
  const [cfgLoading, setCfgLoading] = useState(true);
  const [cfgSaving, setCfgSaving] = useState(false);

  const [emailFilter, setEmailFilter] = useState("");
  const [groupFilter, setGroupFilter] = useState("");

  React.useEffect(() => {
    return () => {
      timeoutsRef.current.forEach((id) => clearTimeout(id));
      timeoutsRef.current = [];
    };
  }, []);

  const loadMe = () => {
    setMeLoading(true);
    service
      .getCurrUser()
      .then((data) => setMe(data))
      .catch(() => setMe(null))
      .finally(() => setMeLoading(false));
  };

  const loadUsers = () => {
    setLoading(true);
    service
      .getUsers()
      .then((data) => setUsers(data))
      .catch(() => setError("Failed to load users"))
      .finally(() => setLoading(false));
  };

  const loadGroups = () => {
    setGroupsLoading(true);
    service
      .getAuthentikGroups()
      .then((data) => setGroups(data))
      .catch(() => setGroups([]))
      .finally(() => setGroupsLoading(false));
  };

  const loadArraialConfig = () => {
    setCfgLoading(true);
    service
      .getArraialConfig()
      .then((data) => setArraialConfig(data))
      .catch(() => setArraialConfig(null))
      .finally(() => setCfgLoading(false));
  };

  useEffect(() => {
    if (!token) return;
    loadMe();
  }, [token]);

  useEffect(() => {
    if (!token) return;
    if (me && Array.isArray(me.scopes) && me.scopes.includes("admin")) {
      loadUsers();
      loadGroups();
      loadArraialConfig();
    } else if (!meLoading && !me) {
      loadUsers();
    }
  }, [token, me, meLoading]);

  // Subscribe to Arraial config WebSocket updates
  useEffect(() => {
    if (!me || !Array.isArray(me.scopes) || !me.scopes.includes("admin")) return;
    const socket = getArraialSocket();
    const onMessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        if (data?.topic === "ARRAIAL_CONFIG" && typeof data.enabled === "boolean") {
          setArraialConfig({ enabled: data.enabled, paused: !!data.paused });
        }
      } catch {
        // Ignore non-JSON or unexpected messages
      }
    };
    socket.addEventListener("message", onMessage);
    return () => socket.removeEventListener("message", onMessage);
  }, [me]);

  const toggleGroupMembership = async (user, group) => {
    const key = `${group.pk}:${user.id}`;
    if (pendingToggle == key) return;

    const isMember = group.member_subs.includes(user.authentik_sub);

    if (!user.authentik_sub) {
      setError(`${user.name || user.email} has not logged in via Authentik yet`);
      return;
    }

    setPendingToggle(key);
    try {
      if (isMember) {
        await service.removeUserFromAuthentikGroup(group.pk, user.id);
      } else {
        await service.addUserToAuthentikGroup(group.pk, user.id);
      }
      setSuccessMessage(
        `${isMember ? "Removed" : "Added"} ${user.name || user.email} ${isMember ? "from" : "to"} ${group.name}`
      );
      const id = setTimeout(() => setSuccessMessage(null), SUCCESS_MESSAGE_TIMEOUT);
      timeoutsRef.current.push(id);
      loadGroups();
    } catch (e) {
      setError(`Failed to update group membership: ${e?.message || "Unknown error"}`);
    } finally {
      setPendingToggle(null);
    }
  };

  const saveArraialConfig = async (enabled, paused) => {
    const finalPaused = paused ?? arraialConfig?.paused ?? false;
    try {
      setCfgSaving(true);
      await service.setArraialConfig(enabled, finalPaused);
      setArraialConfig({ enabled, paused: finalPaused });
      setSuccessMessage(`Arraial ${enabled ? "enabled" : "disabled"} successfully`);
      const id = setTimeout(() => setSuccessMessage(null), SUCCESS_MESSAGE_TIMEOUT);
      timeoutsRef.current.push(id);
    } catch (e) {
      setError(`Failed to save Arraial config: ${e?.message || "Unknown error"}`);
    } finally {
      setCfgSaving(false);
    }
  };

  const filteredUsers = useMemo(() => {
    return users.filter((user) => {
      const emailMatch =
        !emailFilter ||
        user.email?.toLowerCase().includes(emailFilter.toLowerCase());

      const groupMatch =
        !groupFilter ||
        groups.some(
          (g) => g.pk === groupFilter && g.member_subs.includes(user.authentik_sub)
        );

      return emailMatch && groupMatch;
    });
  }, [users, emailFilter, groupFilter, groups]);

  if (!token) return <div className="p-4">Unauthorized</div>;

  const isAdmin = me?.scopes?.includes("admin") ?? false;

  return (
    <div className="mx-auto w-full max-w-5xl p-4">
      <h1>Admin · Roles</h1>

      {/* Arraial toggle */}
      {isAdmin && (
        <div className="mt-3 rounded bg-base-200 p-3">
          <div className="mb-2 font-semibold">Arraial</div>
          {cfgLoading || !arraialConfig ? (
            <div className="text-sm opacity-70">Loading config…</div>
          ) : (
            <div className="flex flex-col gap-2">
              <label className="label cursor-pointer gap-3">
                <span className="label-text">Enable Arraial</span>
                <input
                  type="checkbox"
                  className="toggle"
                  checked={!!arraialConfig.enabled}
                  onChange={(e) => saveArraialConfig(e.target.checked, arraialConfig.paused)}
                  disabled={cfgSaving}
                />
              </label>
              <label className="label cursor-pointer gap-3">
                <span className="label-text">Pause point updates</span>
                <input
                  type="checkbox"
                  className="toggle toggle-warning"
                  checked={!!arraialConfig.paused}
                  onChange={(e) => saveArraialConfig(arraialConfig.enabled, e.target.checked)}
                  disabled={cfgSaving}
                />
              </label>
              <div className="divider my-1"></div>
              <button
                className="btn btn-error btn-sm self-start"
                onClick={async () => {
                  if (!globalThis.confirm("Reset Arraial? This will clear points, boosts, and history for the event.")) return;
                  try {
                    await service.resetArraial();
                    loadArraialConfig();
                  } catch (resetError) {
                    setError(`Failed to reset Arraial: ${resetError?.message || "Unknown error"}`);
                  }
                }}
              >
                Reset Arraial
              </button>
            </div>
          )}
        </div>
      )}

      {/* Current user info */}
      <div className="mt-2 rounded bg-base-200 p-3">
        {meLoading && <div className="text-sm opacity-70">Checking your permissions…</div>}
        {!meLoading && !me && <div className="text-sm opacity-70">Could not load your profile.</div>}
        {!meLoading && me && (
          <div className="text-sm">
            <div>
              You are logged in as <strong>{me.name} {me.surname}</strong>
            </div>
            <div className="mt-1">
              Your scopes:{" "}
              {me.scopes?.length > 0 ? (
                <span className="badge badge-outline">{me.scopes.join(", ")}</span>
              ) : (
                <span className="opacity-70">none</span>
              )}
            </div>
          </div>
        )}
      </div>

      {error && (
        <div className="alert alert-error my-3">
          <span>{error}</span>
          <button className="btn btn-sm btn-circle btn-ghost" onClick={() => setError(null)}>✕</button>
        </div>
      )}

      {successMessage && (
        <div className="toast toast-bottom toast-end z-50">
          <div className="alert alert-success">
            <span>{successMessage}</span>
            <button
              className="btn btn-sm btn-circle btn-ghost"
              onClick={() => setSuccessMessage(null)}
            >
              ✕
            </button>
          </div>
        </div>
      )}

      {/* Authentik Groups management */}
      {isAdmin && (
        <div className="mt-3">
          <div className="mb-2 font-semibold">Authentik Groups</div>

          {/* Filters */}
          <div className="rounded bg-base-200 p-3 mb-3">
            <div className="flex flex-col sm:flex-row gap-3">
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
              <div className="flex-1">
                <label htmlFor="filter-group" className="label">
                  <span className="label-text">Group</span>
                </label>
                <select
                  id="filter-group"
                  className="select select-bordered select-sm w-full"
                  value={groupFilter}
                  onChange={(e) => setGroupFilter(e.target.value)}
                >
                  <option value="">All groups</option>
                  {groups.map((g) => (
                    <option key={g.pk} value={g.pk}>
                      {g.name}
                    </option>
                  ))}
                </select>
              </div>
              <div className="flex items-end">
                <button
                  className="btn btn-outline btn-sm"
                  onClick={() => { setEmailFilter(""); setGroupFilter(""); }}
                >
                  Clear
                </button>
              </div>
            </div>
            {filteredUsers.length !== users.length && (
              <div className="mt-2 text-sm opacity-70">
                Showing {filteredUsers.length} of {users.length} users
              </div>
            )}
          </div>

          {loading || groupsLoading ? (
            <div className="text-sm opacity-70">Loading…</div>
          ) : (
            <div className="overflow-auto rounded bg-base-200 p-2 max-h-[32rem]">
              <table className="table table-zebra table-sm">
                <thead>
                  <tr>
                    <th>User</th>
                    <th>Email</th>
                    {groups.map((g) => (
                      <th key={g.pk} className="text-center text-xs whitespace-nowrap">
                        {g.name.replace(/^nei-/, "")}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {filteredUsers.map((u) => (
                    <tr key={u.id} className={u.authentik_sub ? "" : "opacity-50"}>
                      <td className="whitespace-nowrap">
                        {u.name} {u.surname}
                        {!u.authentik_sub && (
                          <span className="ml-1 badge badge-xs badge-ghost" title="Has not logged in via Authentik">
                            no SSO
                          </span>
                        )}
                      </td>
                      <td className="font-mono text-xs">{u.email}</td>
                      {groups.map((g) => {
                        const isMember = u.authentik_sub && g.member_subs.includes(u.authentik_sub);
                        const key = `${g.pk}:${u.id}`;
                        return (
                          <td key={g.pk} className="text-center">
                            <input
                              type="checkbox"
                              className="checkbox checkbox-sm"
                              checked={!!isMember}
                              disabled={!u.authentik_sub || pendingToggle == key}
                              onChange={() => toggleGroupMembership(u, g)}
                            />
                          </td>
                        );
                      })}
                    </tr>
                  ))}
                  {filteredUsers.length === 0 && (
                    <tr>
                      <td colSpan={2 + groups.length} className="text-center opacity-60 py-4">
                        No users match the current filters.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          )}
        </div>
      )}

      {!isAdmin && !meLoading && (
        <div className="mt-3 text-sm opacity-70">
          You need admin scope to manage groups. Log out and back in if you were recently promoted.
        </div>
      )}
    </div>
  );
}
