import { useDomEvent, MotionValue } from "framer-motion";
import { spring } from "popmotion";
import { debounce } from "lodash";

// Absolute distance a wheel scroll event can travel outside of
// the defined constraints before we fire a "snap back" animation
const deltaThreshold = 5;

// If wheel event fires beyond constraints, multiple the delta by this amount
const elasticFactor = 0.2;

function springTo(value, from, to) {
  if (value.isAnimating()) return;

  console.log(value, from, to)

  if (!(value instanceof MotionValue) || !(from instanceof MotionValue) || !(to instanceof MotionValue)) {
    return;
  }

  console.log('woow')

  value.start(complete => {
    const animation = spring({
      from,
      to,
      velocity: value.getVelocity(),
      stiffness: 400,
      damping: 40
    }).start({
      update: (v) => value.set(v),
      complete
    });

    return () => animation.stop();
  });
}

const debouncedSpringTo = debounce(springTo, 100);

function mix(min, max, progress) {
  return min + (max - min) * progress;
}

/**
 * Springs `y` back to `limit` once the wheel delta passes the threshold in the
 * direction of `limit`, otherwise schedules a debounced spring back.
 * Returns true if an immediate animation was started.
 */
function springBackOrDebounce(y, newY, limit, isImmediate) {
  if (isImmediate) {
    springTo(y, newY, limit);
    return true;
  }
  debouncedSpringTo(y, newY, limit);
  return false;
}

/**
 * Applies elastic resistance beyond the constraints and triggers spring-back.
 * Returns the position to apply and whether an animation was started.
 */
function resolveOverscroll(y, currentY, newY, deltaY, constraints) {
  const elasticY = mix(currentY, newY, elasticFactor);
  let startedAnimation = false;

  if (elasticY < constraints.top) {
    startedAnimation =
      springBackOrDebounce(y, elasticY, constraints.top, deltaY <= deltaThreshold) ||
      startedAnimation;
  }

  if (elasticY > constraints.bottom) {
    startedAnimation =
      springBackOrDebounce(y, elasticY, constraints.bottom, deltaY >= -deltaThreshold) ||
      startedAnimation;
  }

  return { newY: elasticY, startedAnimation };
}

function isWithinConstraints(value, constraints) {
  return value >= constraints.top && value <= constraints.bottom;
}

/**
 * Re-implements wheel scroll for overlflow: hidden elements.
 *
 * Adds Apple Watch crown-style constraints, where the user
 * must continue to input wheel events of a certain delta at a certain
 * speed or the scrollable container will spring back to the nearest
 * constraint.
 *
 * Currently achieves this using event.deltaY and a debounce, which
 * feels pretty good during direct input but it'd be better to increase
 * the deltaY threshold during momentum scroll.
 *
 * NOTE: open items before inclusion in Framer Motion:
 * - Detect momentum scroll and increase delta threshold before spring
 * - Remove padding hack
 * - Handle x-axis
 * - Perhaps handle arrow and space keyboard events?
 *
 * @param ref - Ref of the Element to attach listener to
 * @param y - MotionValue for the scrollable element - might be different to the Element
 * @param constraints - top/bottom scroll constraints in pixels.
 * @param isActive - `true` if this listener should fire.
 */
export function useWheelScroll(
  ref,
  y,
  constraints,
  onWheelCallback,
  isActive
) {
  const onWheel = (event) => {
    event.preventDefault();

    const currentY = y.get();
    let newY = currentY - event.deltaY;
    let startedAnimation = false;

    if (constraints && !isWithinConstraints(newY, constraints)) {
      ({ newY, startedAnimation } = resolveOverscroll(
        y,
        currentY,
        newY,
        event.deltaY,
        constraints
      ));
    }

    if (!startedAnimation) {
      y.stop();
      y.set(newY);
    } else {
      debouncedSpringTo.cancel();
    }

    onWheelCallback(event);
  };

  useDomEvent(ref, "wheel", isActive && onWheel, { passive: false });
}
