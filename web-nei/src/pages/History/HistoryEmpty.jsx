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
    text: "Tenta novamente mais tarde.",
  },
};

export default function HistoryEmpty({ variant }) {
  const { icon, title, text } = COPY[variant];
  return (
    <div className="history-empty">
      <MaterialSymbol icon={icon} size={40} />
      <h2>{title}</h2>
      <p>{text}</p>
    </div>
  );
}
