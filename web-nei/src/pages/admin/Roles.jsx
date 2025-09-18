import React, { useEffect, useState } from "react";
import service from "services/NEIService";
import { useUserStore } from "stores/useUserStore";
import { getArraialSocket } from "services/SocketService";

const ALL_SCOPES = [
  "admin",
  "manager-nei",
  "manager-arraial",
  "manager-tacaua",
  "manager-family",
  "manager-jantar-gala",
];

export function Component() {
  const { token } = useUserStore((s) => s);
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [saving, setSaving] = useState(false);
  const [me, setMe] = useState(null);
  const [meLoading, setMeLoading] = useState(true);

  const [arraialConfig, setArraialConfig] = useState(null);
  const [cfgLoading, setCfgLoading] = useState(true);
  const [cfgSaving, setCfgSaving] = useState(false);

  // Filter states
  const [emailFilter, setEmailFilter] = useState("");
  const [roleFilter, setRoleFilter] = useState("");

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
    setError(null);
    service
      .getUsers()
      .then((data) => {
        // Add mock users for testing
        const mockUsers = [
          { id: 100, name: "Alice", surname: "Johnson", email: "alice.johnson@ua.pt", scopes: ["manager-nei"] },
          { id: 101, name: "Bob", surname: "Smith", email: "bob.smith@ua.pt", scopes: ["manager-arraial"] },
          { id: 102, name: "Carol", surname: "Williams", email: "carol.williams@ua.pt", scopes: ["manager-tacaua"] },
          { id: 103, name: "David", surname: "Brown", email: "david.brown@ua.pt", scopes: ["manager-family"] },
          { id: 104, name: "Eva", surname: "Davis", email: "eva.davis@ua.pt", scopes: ["manager-jantar-gala"] },
          { id: 105, name: "Frank", surname: "Miller", email: "frank.miller@ua.pt", scopes: ["admin"] },
          { id: 106, name: "Grace", surname: "Wilson", email: "grace.wilson@ua.pt", scopes: ["manager-nei", "manager-arraial"] },
          { id: 107, name: "Henry", surname: "Moore", email: "henry.moore@ua.pt", scopes: ["manager-tacaua", "manager-family"] },
          { id: 108, name: "Iris", surname: "Taylor", email: "iris.taylor@ua.pt", scopes: ["manager-jantar-gala", "manager-nei"] },
          { id: 109, name: "Jack", surname: "Anderson", email: "jack.anderson@ua.pt", scopes: ["admin", "manager-arraial"] },
          { id: 110, name: "Kate", surname: "Thomas", email: "kate.thomas@ua.pt", scopes: ["manager-family"] },
          { id: 111, name: "Liam", surname: "Jackson", email: "liam.jackson@ua.pt", scopes: ["manager-tacaua"] },
          { id: 112, name: "Maya", surname: "White", email: "maya.white@ua.pt", scopes: ["manager-jantar-gala"] },
          { id: 113, name: "Noah", surname: "Harris", email: "noah.harris@ua.pt", scopes: ["manager-nei"] },
          { id: 114, name: "Olivia", surname: "Martin", email: "olivia.martin@ua.pt", scopes: ["manager-arraial", "manager-tacaua"] },
          { id: 115, name: "Paul", surname: "Garcia", email: "paul.garcia@ua.pt", scopes: ["manager-family", "manager-jantar-gala"] },
          { id: 116, name: "Quinn", surname: "Martinez", email: "quinn.martinez@ua.pt", scopes: ["admin", "manager-nei", "manager-arraial"] },
          { id: 117, name: "Ruby", surname: "Robinson", email: "ruby.robinson@ua.pt", scopes: ["manager-tacaua", "manager-family"] },
          { id: 118, name: "Sam", surname: "Clark", email: "sam.clark@ua.pt", scopes: ["manager-jantar-gala", "manager-nei"] },
          { id: 119, name: "Tina", surname: "Rodriguez", email: "tina.rodriguez@ua.pt", scopes: ["admin"] },
          { id: 120, name: "Uma", surname: "Lewis", email: "uma.lewis@ua.pt", scopes: ["manager-arraial"] },
          { id: 121, name: "Victor", surname: "Lee", email: "victor.lee@ua.pt", scopes: ["manager-tacaua"] },
          { id: 122, name: "Wendy", surname: "Walker", email: "wendy.walker@ua.pt", scopes: ["manager-family"] },
          { id: 123, name: "Xavier", surname: "Hall", email: "xavier.hall@ua.pt", scopes: ["manager-jantar-gala"] },
          { id: 124, name: "Yara", surname: "Allen", email: "yara.allen@ua.pt", scopes: ["manager-nei"] },
          { id: 125, name: "Zoe", surname: "Young", email: "zoe.young@ua.pt", scopes: ["admin", "manager-arraial", "manager-tacaua", "manager-family", "manager-jantar-gala"] },
        ];
        
        // Combine real users with mock users
        setUsers([...data, ...mockUsers]);
      })
      .catch((err) => {
        setError("Failed to load users");
      })
      .finally(() => setLoading(false));
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
    // Always load /user/me first to see current scopes
    loadMe();
  }, [token]);

  useEffect(() => {
    if (!token) return;
    // If we already have admin scope, try loading all users and config
    if (me && Array.isArray(me.scopes) && me.scopes.includes("admin")) {
      loadUsers();
      loadArraialConfig();
    } else if (!meLoading && !me) {
      // If /user/me failed, still try users (server will 403 if not allowed)
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
      } catch (_) {}
    };
    socket.addEventListener("message", onMessage);
    return () => {
      socket.removeEventListener("message", onMessage);
    };
  }, [me]);

  const toggleScope = (user, scope) => {
    const next = users.map((u) =>
      u.id === user.id
        ? {
            ...u,
            scopes: u.scopes?.includes(scope)
              ? u.scopes.filter((s) => s !== scope)
              : [...(u.scopes || []), scope],
          }
        : u
    );
    setUsers(next);
  };

  const saveScopes = async (user) => {
    try {
      setSaving(true);
      await service.updateUserScopes(user.id, user.scopes || []);
      loadUsers();
    } catch (e) {
      setError("Failed to update scopes");
    } finally {
      setSaving(false);
    }
  };

  const saveArraialConfig = async (enabled, paused) => {
    try {
      setCfgSaving(true);
      await service.setArraialConfig(enabled, paused ?? arraialConfig?.paused ?? false);
      setArraialConfig({ enabled, paused: paused ?? arraialConfig?.paused ?? false });
    } catch (e) {
      setError("Failed to save Arraial config");
    } finally {
      setCfgSaving(false);
    }
  };

  // Filter users based on email and role filters
  const filteredUsers = users.filter((user) => {
    const emailMatch = !emailFilter || 
      (user.email && user.email.toLowerCase().includes(emailFilter.toLowerCase()));
    
    const roleMatch = !roleFilter || 
      (user.scopes && user.scopes.includes(roleFilter));
    
    return emailMatch && roleMatch;
  });


  if (!token) return <div className="p-4">Unauthorized</div>;

  const showUsersTable = !loading && users.length > 0;

  return (
    <div className="mx-auto w-full max-w-4xl p-4">
      <h1>Admin · Roles</h1>

      {/* Arraial toggle (admin-only) */}
      {me && Array.isArray(me.scopes) && me.scopes.includes("admin") && (
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
                  try {
                    const ok = window.confirm("Reset Arraial? This will clear points, boosts, and history for the event.");
                    if (!ok) return;
                    await service.resetArraial();
                    // Refresh current config and let WS update points/boosts
                    loadArraialConfig();
                  } catch (e) {
                    setError("Failed to reset Arraial");
                  }
                }}
              >
                Reset Arraial
              </button>
            </div>
          )}
        </div>
      )}

      {/* Current user scopes (always shown) */}
      <div className="mt-2 rounded bg-base-200 p-3">
        {meLoading ? (
          <div className="text-sm opacity-70">Checking your permissions…</div>
        ) : me ? (
          <div className="text-sm">
            <div>
              You are logged in as <strong>{me.name} {me.surname}</strong>
            </div>
            <div className="mt-1">
              Your scopes: {Array.isArray(me.scopes) && me.scopes.length > 0 ? (
                <span className="badge badge-outline">{me.scopes.join(", ")}</span>
              ) : (
                <span className="opacity-70">none</span>
              )}
            </div>
            {!Array.isArray(me.scopes) || me.scopes.length === 0 ? (
              <div className="mt-2 text-xs opacity-70">
                If you were just promoted, log out and log back in so your token includes the new scopes.
              </div>
            ) : null}
          </div>
        ) : (
          <div className="text-sm opacity-70">Could not load your profile.</div>
        )}
      </div>

      {error && (
        <div className="alert alert-error my-3">
          <span>{error}</span>
        </div>
      )}

      {showUsersTable ? (
        <div className="mt-3">
          {/* Filter Controls */}
          <div className="rounded bg-base-200 p-3 mb-3">
            <div className="mb-2 font-semibold">Filter Users</div>
            <div className="flex flex-col sm:flex-row gap-3">
              <div className="flex-1">
                <label className="label">
                  <span className="label-text">Email</span>
                </label>
                <input
                  type="text"
                  placeholder="Filter by email..."
                  className="input input-bordered input-sm w-full"
                  value={emailFilter}
                  onChange={(e) => setEmailFilter(e.target.value)}
                />
              </div>
              <div className="flex-1">
                <label className="label">
                  <span className="label-text">Role/Scope</span>
                </label>
                <select
                  className="select select-bordered select-sm w-full"
                  value={roleFilter}
                  onChange={(e) => setRoleFilter(e.target.value)}
                >
                  <option value="">All roles</option>
                  {ALL_SCOPES.map((scope) => (
                    <option key={scope} value={scope}>
                      {scope}
                    </option>
                  ))}
                </select>
              </div>
              <div className="flex items-end">
                <button
                  className="btn btn-outline btn-sm"
                  onClick={() => {
                    setEmailFilter("");
                    setRoleFilter("");
                  }}
                >
                  Clear Filters
                </button>
              </div>
            </div>
            {filteredUsers.length !== users.length && (
              <div className="mt-2 text-sm opacity-70">
                Showing {filteredUsers.length} of {users.length} users
              </div>
            )}
          </div>

          <div className="overflow-auto rounded bg-base-200 p-2 max-h-96">
            <table className="table table-zebra">
            <thead>
              <tr>
                <th>User</th>
                <th>Email</th>
                <th>Scopes</th>
                <th className="text-right">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredUsers.map((u) => (
                <tr key={u.id}>
                  <td>{u.name} {u.surname}</td>
                  <td className="font-mono text-sm">{u.email}</td>
                  <td>
                    <div className="flex flex-wrap gap-2">
                      {ALL_SCOPES.map((s) => (
                        <label key={s} className="label cursor-pointer gap-2">
                          <input
                            type="checkbox"
                            className="checkbox checkbox-sm"
                            checked={!!(u.scopes || []).includes(s)}
                            onChange={() => toggleScope(u, s)}
                          />
                          <span className="label-text text-xs">{s}</span>
                        </label>
                      ))}
                    </div>
                  </td>
                  <td className="text-right">
                    <button
                      className="btn btn-sm"
                      disabled={saving}
                      onClick={() => saveScopes(u)}
                    >
                      Save
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          </div>
          
          {filteredUsers.length === 0 && users.length > 0 && (
            <div className="mt-3 text-center text-sm opacity-70">
              No users match the current filters.
            </div>
          )}
        </div>
      ) : (
        <div className="mt-3 text-sm opacity-70">
          {loading ? "Loading…" : "Users not available. You might need admin scope or a fresh login."}
        </div>
      )}
    </div>
  );
}
