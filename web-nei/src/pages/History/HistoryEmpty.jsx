import React from "react";
import MaterialSymbol from "components/MaterialSymbol";

const COPY = {
  empty: {
    icon: "history_edu",
    title: "Ainda não há marcos publicados",
    text: "Volta em breve — a história do NEI está a ser escrita.",
  },
  error: {
    icon: "error",
    title: "Não foi possível carregar a história",
    text: "Verifica a ligação e tenta outra vez.",
  },
  filtered: {
    icon: "filter_alt_off",
    title: "Sem marcos nesta categoria",
    text: "A categoria escolhida não tem marcos publicados ou já não existe.",
  },
};

export default function HistoryEmpty({ variant, categoryLabel, onRetry, onReset }) {
  const { icon, title, text } = COPY[variant];
  return (
    // Only a failure interrupts: the other variants are the page's content,
    // read in order like the timeline they replace.
    <div className="history-empty" role={variant === "error" ? "alert" : undefined}>
      <MaterialSymbol icon={icon} size={40} />
      <h2>{categoryLabel ? `Sem marcos em «${categoryLabel}»` : title}</h2>
      <p>{text}</p>
      {onRetry && (
        <button type="button" className="history-empty__action" onClick={onRetry}>
          <MaterialSymbol icon="refresh" size={18} />
          Tentar de novo
        </button>
      )}
      {onReset && (
        <button type="button" className="history-empty__action" onClick={onReset}>
          <MaterialSymbol icon="close" size={18} />
          Ver todos os marcos
        </button>
      )}
    </div>
  );
}
