export default function Spinner({ className }) {
  return (
    <div
      role="status"
      className={`absolute left-1/2 top-1/2 flex -translate-x-1/2 -translate-y-1/2 transform flex-col items-center gap-3 text-center font-medium ${className}`}
    >
      <svg
        className="h-10 w-10 animate-spin text-white"
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
      >
        <circle
          className="opacity-25"
          cx="12"
          cy="12"
          r="10"
          stroke="hsl(var(--n))"
          strokeWidth="3"
        ></circle>
        <path
          className="opacity-75"
          fill="hsl(var(--p))"
          d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
        ></path>
      </svg>
      A carregar...
    </div>
  );
}
