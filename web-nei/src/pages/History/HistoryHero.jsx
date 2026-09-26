import React from "react";
import { motion, useReducedMotion } from "framer-motion";
import { Typewriter } from "react-simple-typewriter";

export default function HistoryHero({ milestones }) {
  const reducedMotion = useReducedMotion();
  const years = milestones.map((m) => new Date(m.moment).getUTCFullYear());
  const firstYear = years.length ? Math.min(...years) : null;
  const yearsOfHistory = firstYear
    ? new Date().getUTCFullYear() - firstYear
    : null;

  return (
    <section className="history-hero" aria-labelledby="history-heading">
      <motion.h1
        id="history-heading"
        className="history-hero__title"
        initial={reducedMotion ? false : { opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        <Typewriter words={["História do NEI"]} loop={1} />
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
            <dt>Anos de história</dt>
            <dd>{yearsOfHistory}</dd>
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
