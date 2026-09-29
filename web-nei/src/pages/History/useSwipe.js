import { useRef } from "react";

const SWIPE_MIN_PX = 50;
// How much more horizontal than vertical a gesture must be to count: a
// diagonal drag is someone scrolling, not flicking to the next photo.
const HORIZONTAL_DOMINANCE = 1.5;

/** Touch handlers for a horizontal swipe; `onSwipe(1)` means "next". */
export default function useSwipe(onSwipe) {
  const start = useRef(null);

  return {
    onTouchStart(event) {
      if (event.touches.length !== 1) {
        start.current = null;
        return;
      }
      const touch = event.touches[0];
      start.current = { x: touch.clientX, y: touch.clientY };
    },
    onTouchEnd(event) {
      const origin = start.current;
      start.current = null;
      const touch = event.changedTouches[0];
      if (!origin || !touch) return;

      const dx = touch.clientX - origin.x;
      const dy = touch.clientY - origin.y;
      if (Math.abs(dx) < SWIPE_MIN_PX) return;
      if (Math.abs(dx) < Math.abs(dy) * HORIZONTAL_DOMINANCE) return;
      onSwipe(dx < 0 ? 1 : -1);
    },
    onTouchCancel() {
      start.current = null;
    },
  };
}
