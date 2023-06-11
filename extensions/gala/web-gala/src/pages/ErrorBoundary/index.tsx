export default function ErrorBoundary() {
  return (
    <div className="flex h-screen w-screen flex-col items-center justify-center text-7xl font-extrabold">
      <h1>Alguma coisa correu mal!</h1>
      <h3>Por favor, tenta recarregar.</h3>
    </div>
  );
}
