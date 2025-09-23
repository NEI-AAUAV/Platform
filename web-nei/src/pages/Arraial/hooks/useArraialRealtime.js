import React from "react";
import service from "services/NEIService";
import { getArraialSocket } from "services/SocketService";
import { POLLING_INTERVAL } from "../constants";

export default function useArraialRealtime({ onPointsUpdate } = {}) {
  const [wsConnected, setWsConnected] = React.useState(false);
  const [enabled, setEnabled] = React.useState(null);
  const [paused, setPaused] = React.useState(false);
  const [pointsList, setPointsList] = React.useState([
    { nucleo: "NEEETA", value: 0 },
    { nucleo: "NEECT", value: 0 },
    { nucleo: "NEI", value: 0 },
  ]);
  const [boosts, setBoosts] = React.useState({});
  const [error, setError] = React.useState(null);

  React.useEffect(() => {
    const initConfig = async () => {
      try {
        const cfg = await service.getArraialConfig();
        setEnabled(!!cfg?.enabled);
        setPaused(!!cfg?.paused);
        if (cfg?.boosts) setBoosts(cfg.boosts);
      } catch (e) {
        setEnabled(true);
      }
    };

    const fetchPoints = () => {
      service
        .getArraialPoints()
        .then((data) => {
          setPointsList(data);
          setError(null);
          if (onPointsUpdate) onPointsUpdate(data);
        })
        .catch((err) => {
          setError("Failed to load points. Please try again.");
          // keep previous points
        });
    };

    initConfig();
    fetchPoints();

    const socket = getArraialSocket();
    const onMessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        if (data?.topic === "ARRAIAL_POINTS" && Array.isArray(data.points)) {
          setPointsList(data.points);
          if (onPointsUpdate) onPointsUpdate(data.points);
        } else if (
          data?.topic === "ARRAIAL_CONFIG" &&
          typeof data.enabled === "boolean"
        ) {
          setEnabled(!!data.enabled);
          setPaused(!!data.paused);
        } else if (
          data?.topic === "ARRAIAL_BOOST" &&
          data.boosts &&
          typeof data.boosts === "object"
        ) {
          setBoosts(data.boosts || {});
        }
      } catch (_) {
        // ignore
      }
    };
    const onOpen = () => setWsConnected(true);
    const onClose = () => setWsConnected(false);
    const onError = () => setWsConnected(false);

    socket.addEventListener("message", onMessage);
    socket.addEventListener("open", onOpen);
    socket.addEventListener("close", onClose);
    socket.addEventListener("error", onError);
    // Initial state
    setWsConnected(socket.readyState === WebSocket.OPEN);

    const poll = () => {
      if (socket.readyState !== WebSocket.OPEN) {
        fetchPoints();
      }
    };
    const intervalId = setInterval(poll, POLLING_INTERVAL);
    return () => {
      clearInterval(intervalId);
      socket.removeEventListener("message", onMessage);
      socket.removeEventListener("open", onOpen);
      socket.removeEventListener("close", onClose);
      socket.removeEventListener("error", onError);
    };
  }, [onPointsUpdate]);

  return {
    wsConnected,
    enabled,
    paused,
    pointsList,
    boosts,
    setBoosts,
    error,
  };
}
