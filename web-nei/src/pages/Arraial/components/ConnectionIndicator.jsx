import React from "react";

export default function ConnectionIndicator({ wsConnected }) {
  return (
    <div className="flex items-center justify-center gap-2 mt-2">
      <div
        className={`w-2 h-2 rounded-full ${
          wsConnected ? "bg-green-500" : "bg-red-500"
        }`}
      ></div>
      <span className="text-xs opacity-70">
        {wsConnected ? "Live" : "Offline"}
      </span>
    </div>
  );
}
