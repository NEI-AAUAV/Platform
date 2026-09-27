import React from "react";
import { motion, useReducedMotion } from "framer-motion";
import { Typewriter } from "react-simple-typewriter";

const TITLE = "História do NEI";

/** Only facts the data states: the year of the earliest published
 * milestone and how many there are. (No "N anos de história": the earliest
 * milestone isn't necessarily the founding, and a year difference isn't an
 * age.) */
export default function HistoryHero({ milestones }) {
  const reducedMotion = useReducedMotion();
  const years = milestones.map((m) => new Date(m.moment).getUTCFullYear());
  const firstYear = years.length ? Math.min(...years) : null;

  return (
    <section className="history-hero" aria-labelledby="history-heading">
      <motion.h1
        id="history-heading"
        className="history-hero__title"
        initial={reducedMotion ? false : { opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        {reducedMotion ? (
          TITLE
        ) : (
          <>
            {/* The typed text is visual only: screen readers get the title
                once, not every intermediate keystroke. */}
            <span className="sr-only">{TITLE}</span>
            <span aria-hidden="true">
              <Typewriter words={[TITLE]} loop={1} />
            </span>
          </>
        )}
      </motion.h1>

      <p className="history-hero__intro">
        Da fundação até hoje: os marcos que fizeram do NEI o que é.
      </p>

      {firstYear && (
        <dl className="history-hero__stats">
          <div className="history-hero__stat">
            <dt>Desde</dt>
            <dd>{firstYear}</dd>
          </div>
          <div className="history-hero__stat">
            <dt>Marcos</dt>
            <dd>{milestones.length}</dd>
          </div>
        </dl>
      )}
    </section>
  );
}
