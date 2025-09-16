import React from "react";
import { Link } from "react-router-dom";

export function Component() {
  return (
    <div className="mx-auto flex max-w-3xl flex-col items-center gap-6 py-16 text-center">
      <h1 className="text-6xl font-black text-error">403</h1>
      <p className="text-lg opacity-80">Não tens permissões para aceder a esta página.</p>
      <div className="flex gap-3">
        <Link to="/" className="btn btn-primary">Ir para a Home</Link>
      </div>
    </div>
  );
}