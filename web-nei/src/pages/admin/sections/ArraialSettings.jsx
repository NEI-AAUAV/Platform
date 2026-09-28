import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";
import service from "services/NEIService";
import { getArraialSocket } from "services/SocketService";
import StatusMessages, { useStatusMessages } from "../StatusMessages";

function ConfigToggle({ label, checked, onChange, disabled, className = "toggle" }) {
  return (
    <label className="label cursor-pointer justify-start gap-3">
      <input
        type="checkbox"
        className={className}
        checked={checked}
        onChange={(e) => onChange(e.target.checked)}
        disabled={disabled}
      />
      <span className="label-text">{label}</span>
    </label>
  );
}

ConfigToggle.propTypes = {
  label: PropTypes.string.isRequired,
  checked: PropTypes.bool.isRequired,
  onChange: PropTypes.func.isRequired,
  disabled: PropTypes.bool,
  className: PropTypes.string,
};

export default function ArraialSettings() {
  const [config, setConfig] = useState(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const { error, setError, success, setSuccess, showSuccess } = useStatusMessages();

  const loadConfig = React.useCallback(() => {
    setLoading(true);
    service
      .getArraialConfig()
      .then((data) => setConfig(data))
      .catch((e) => {
        console.error("Failed to load Arraial settings:", e);
        setError(`Failed to load Arraial settings: ${e?.message || "Unknown error"}`);
      })
      .finally(() => setLoading(false));
  }, [setError]);

  useEffect(() => {
    loadConfig();
  }, [loadConfig]);

  useEffect(() => {
    const socket = getArraialSocket();
    const onMessage = (event) => {
      let data;
      try {
        data = JSON.parse(event.data);
      } catch (parseError) {
        console.warn("Ignoring non-JSON Arraial socket message:", parseError);
        return;
      }
      if (data?.topic === "ARRAIAL_CONFIG" && typeof data.enabled === "boolean") {
        setConfig((prev) => ({
          ...prev,
          enabled: data.enabled,
          paused: !!data.paused,
          boosts_enabled: !!data.boosts_enabled,
          milestones_enabled: !!data.milestones_enabled,
        }));
      }
    };
    socket.addEventListener("message", onMessage);
    return () => socket.removeEventListener("message", onMessage);
  }, []);

  const save = async (changes, label) => {
    try {
      setSaving(true);
      const saved = await service.setArraialConfig(changes);
      setConfig(saved);
      const [value] = Object.values(changes);
      showSuccess(`${label} ${value ? "turned on" : "turned off"}`);
    } catch (e) {
      setError(`Failed to save Arraial settings: ${e?.message || "Unknown error"}`);
    } finally {
      setSaving(false);
    }
  };

  const reset = async () => {
    if (!globalThis.confirm("Reset Arraial? This clears all points, boosts and history.")) return;
    try {
      await service.resetArraial();
      showSuccess("Arraial reset");
      loadConfig();
    } catch (e) {
      setError(`Failed to reset Arraial: ${e?.message || "Unknown error"}`);
    }
  };

  return (
    <div>
      <StatusMessages
        error={error}
        onDismissError={() => setError(null)}
        success={success}
        onDismissSuccess={() => setSuccess(null)}
      />

      {loading && <div className="text-sm opacity-70">Loading Arraial settings…</div>}

      {!loading && config && (
        <div className="flex flex-col gap-4">
          <section className="rounded bg-base-200 p-3">
            <h2 className="mb-1 text-lg font-semibold">Page</h2>
            <ConfigToggle
              label="Show the Arraial page"
              checked={!!config.enabled}
              onChange={(v) => save({ enabled: v }, "Arraial page")}
              disabled={saving}
            />
            <ConfigToggle
              label="Pause point updates"
              className="toggle toggle-warning"
              checked={!!config.paused}
              onChange={(v) => save({ paused: v }, "Pause")}
              disabled={saving}
            />
          </section>

          <section className="rounded bg-base-200 p-3">
            <h2 className="mb-1 text-lg font-semibold">Extras</h2>
            <p className="mb-1 text-sm opacity-70">Off by default, so the page only counts pints.</p>
            <ConfigToggle
              label="Boosts (1.25x)"
              checked={!!config.boosts_enabled}
              onChange={(v) => save({ boosts_enabled: v }, "Boosts")}
              disabled={saving}
            />
            <ConfigToggle
              label="Shot Capacete milestones"
              checked={!!config.milestones_enabled}
              onChange={(v) => save({ milestones_enabled: v }, "Milestones")}
              disabled={saving}
            />
          </section>

          <section className="rounded border border-error/40 p-3">
            <h2 className="mb-1 text-lg font-semibold">Reset</h2>
            <p className="mb-2 text-sm opacity-70">
              Clears all points, boosts and history for the event. This can&apos;t be undone.
            </p>
            <button className="btn btn-error btn-sm" onClick={reset}>
              Reset Arraial
            </button>
          </section>
        </div>
      )}
    </div>
  );
}
