import { useEffect, useRef, useState } from "react";

import service from "services/NEIService";

const IDLE = { milestoneId: null, status: "idle", media: [], truncated: false, driveStatus: null };

/** Loads `/history/{id}/gallery` for the open milestone.
 *
 * State is tagged with the milestone it belongs to, and anything tagged
 * with another milestone reads as "loading" — so closing a gallery, or
 * switching to another one, never shows the previous gallery's photos or
 * loading flag, even for the render before the effect resets them. A
 * superseded request is aborted, and its late answer ignored. */
export default function useGallery(milestoneId, { onLoaded } = {}) {
  const [state, setState] = useState(IDLE);
  const [attempt, setAttempt] = useState(0);
  // Read when the answer arrives, so a new callback identity never refetches.
  const onLoadedRef = useRef(onLoaded);
  onLoadedRef.current = onLoaded;

  useEffect(() => {
    if (milestoneId == null) {
      setState(IDLE);
      return undefined;
    }

    const controller = new AbortController();
    setState({ ...IDLE, milestoneId, status: "loading" });
    service
      .getHistoryGallery(milestoneId, { signal: controller.signal })
      .then((gallery) => {
        if (controller.signal.aborted) return;
        setState({
          milestoneId,
          status: "ready",
          media: gallery.media ?? [],
          truncated: Boolean(gallery.truncated),
          driveStatus: gallery.drive_status ?? null,
        });
        onLoadedRef.current?.(gallery.media ?? []);
      })
      .catch(() => {
        if (controller.signal.aborted) return;
        setState({ ...IDLE, milestoneId, status: "error" });
      });

    return () => controller.abort();
  }, [milestoneId, attempt]);

  const retry = () => setAttempt((n) => n + 1);
  if (milestoneId == null) return { ...IDLE, retry };
  if (state.milestoneId !== milestoneId) {
    return { ...IDLE, milestoneId, status: "loading", retry };
  }
  return { ...state, retry };
}
