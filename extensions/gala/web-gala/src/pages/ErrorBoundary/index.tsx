export default function ErrorBoundary() {
  return (
    <div className="flex h-screen w-screen flex-col items-center justify-center text-center font-extrabold">
      <h1 className="text-5xl">Alguma coisa correu mal!</h1>
      <br />
      <h3 className="text-3xl">Por favor, tenta recarregar a página.</h3>
    </div>
  );
}
