import React from "react";

export default function AdminControls({
  paused,
  boosts,
  selectedValue,
  number,
  isLoading,
  onBoost,
  onChangeNucleo,
  onChangePoints,
  onQuickAdjust,
  onSubmit,
}) {
  return (
    <div className="rounded-box m-auto w-full max-w-lg sm:max-w-md flex h-fit flex-col bg-base-200 px-4 sm:px-6 py-6 align-middle shadow-secondary drop-shadow-md">
      <h3>Add/Remove Points</h3>
      <div className="mb-2 flex items-center gap-2">
        <span className="text-sm opacity-70">Boost 1.25x (10m):</span>
        {["NEEETA", "NEECT", "NEI"].map((n) => (
          <button
            key={n}
            className="btn btn-xs"
            disabled={paused}
            onClick={() => onBoost(n)}
          >
            {n}
          </button>
        ))}
      </div>
      {paused && (
        <div className="alert alert-warning my-2">
          <span>Point updates are paused by an administrator.</span>
        </div>
      )}
      <form
        onSubmit={(e) => {
          e.preventDefault();
          onSubmit();
        }}
      >
        <div className="flex flex-col space-y-2">
          <label htmlFor="nucleo-select" className="label">
            <span className="label-text">Núcleo:</span>
          </label>
          <select
            id="nucleo-select"
            className="text-lg bg-neutral-700 h-12 sm:h-10 w-full text-center rounded"
            value={selectedValue}
            onChange={(e) => onChangeNucleo(e.target.value)}
            disabled={paused}
            aria-label="Select núcleo"
          >
            <option value="NEEETA">NEEETA</option>
            <option value="NEECT">NEECT</option>
            <option value="NEI">NEI</option>
          </select>

          <label htmlFor="points-input" className="label">
            <span className="label-text">Points:</span>
          </label>
          <input
            id="points-input"
            type="text"
            value={number}
            onChange={(e) => onChangePoints(e.target.value)}
            placeholder="0"
            className="text-lg bg-neutral-700 h-12 sm:h-10 w-full text-center rounded"
            disabled={paused}
            aria-label="Enter points to add or remove"
          />
          <div className="mt-2 grid grid-cols-4 gap-2">
            <button
              type="button"
              className="btn btn-lg sm:btn-md touch-manipulation"
              onClick={() => onQuickAdjust(-5)}
              disabled={paused}
            >
              -5
            </button>
            <button
              type="button"
              className="btn btn-lg sm:btn-md touch-manipulation"
              onClick={() => onQuickAdjust(-1)}
              disabled={paused}
            >
              -1
            </button>
            <button
              type="button"
              className="btn btn-lg sm:btn-md touch-manipulation"
              onClick={() => onQuickAdjust(1)}
              disabled={paused}
            >
              +1
            </button>
            <button
              type="button"
              className="btn btn-lg sm:btn-md touch-manipulation"
              onClick={() => onQuickAdjust(5)}
              disabled={paused}
            >
              +5
            </button>
          </div>
          {number !== "" && !/^-?\d+$/.test(number) && (
            <p className="text-red-500">Please enter a valid whole number.</p>
          )}

          <button
            type="submit"
            disabled={
              paused ||
              number === "" ||
              number === "0" ||
              !/^-?\d+$/.test(number) ||
              isLoading
            }
            className="btn btn-primary btn-lg sm:btn-md w-full touch-manipulation"
          >
            {isLoading ? "Updating..." : "Submit"}
          </button>
        </div>
      </form>
    </div>
  );
}
