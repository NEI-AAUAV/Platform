import React from "react";

export default function TrendsGraph({ pointHistory }) {
  if (pointHistory.length < 2) {
    return (
      <div className="mt-2 rounded bg-base-100 p-4 text-center">
        <div className="text-sm opacity-70">
          {pointHistory.length === 0
            ? "No data points yet. Trends will appear after point updates."
            : "Need at least 2 data points to show trends. Make another point update to see the graph."}
        </div>
      </div>
    );
  }

  const width = 1200;
  const height = 200;
  const padding = 40;
  const chartWidth = width - padding * 2;
  const chartHeight = height - padding * 2;
  const maxPoints = Math.max(
    ...pointHistory.flatMap((entry) => entry.points.map((p) => p.value)),
    1
  );
  const colors = { NEEETA: "#3B82F6", NEECT: "#10B981", NEI: "#F59E0B" };

  const getX = (index) => padding + (index / (pointHistory.length - 1)) * chartWidth;
  const getY = (value) => padding + chartHeight - (value / maxPoints) * chartHeight;

  const formatTime = (timestamp) => {
    const date = new Date(timestamp);
    const now = new Date();
    const diffMinutes = Math.floor((now - date) / (1000 * 60));
    if (diffMinutes < 1) return "Now";
    if (diffMinutes < 60) return `${diffMinutes}m ago`;
    const hours = Math.floor(diffMinutes / 60);
    const minutes = diffMinutes % 60;
    return `${hours}h ${minutes}m ago`;
  };

  const [hoveredPoint, setHoveredPoint] = React.useState(null);

  return (
    <div className="mt-4 p-2 sm:p-4 bg-base-100 rounded-lg">
      <h4 className="text-lg font-bold mb-3">Point Trends</h4>
      <div className="overflow-x-auto">
        <svg
          width={width}
          height={height}
          className="block mx-auto w-[1200px] max-w-none"
        >
          {[0, 0.25, 0.5, 0.75, 1].map((ratio) => {
            const value = Math.round(ratio * maxPoints);
            const y = padding + (1 - ratio) * chartHeight;
            return (
              <g key={ratio}>
                <line
                  x1={padding}
                  y1={y}
                  x2={padding + chartWidth}
                  y2={y}
                  stroke="currentColor"
                  strokeOpacity="0.1"
                />
                <text
                  x={padding - 10}
                  y={y + 4}
                  fontSize="10"
                  fill="currentColor"
                  textAnchor="end"
                  opacity="0.6"
                >
                  {value}
                </text>
              </g>
            );
          })}

          {["NEEETA", "NEECT", "NEI"].map((nucleo) => {
            const points = pointHistory.map((entry) => {
              const nucleoData = entry.points.find((p) => p.nucleo === nucleo);
              return nucleoData ? nucleoData.value : 0;
            });
            const pathData = points
              .map((value, index) => {
                const x = getX(index);
                const y = getY(value);
                return `${index === 0 ? "M" : "L"} ${x} ${y}`;
              })
              .join(" ");
            return (
              <g key={nucleo}>
                <path
                  d={pathData}
                  fill="none"
                  stroke={colors[nucleo]}
                  strokeWidth="3"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
                {points.map((value, index) => {
                  const entry = pointHistory[index];
                  const time = formatTime(entry.timestamp);
                  const x = getX(index);
                  const y = getY(value);
                  const isHovered = hoveredPoint?.nucleo === nucleo && hoveredPoint?.index === index;
                  return (
                    <g key={index}>
                      <circle
                        cx={x}
                        cy={y}
                        r={isHovered ? 6 : 4}
                        fill={colors[nucleo]}
                        stroke={isHovered ? "white" : "none"}
                        strokeWidth="2"
                        style={{ cursor: 'pointer' }}
                        onMouseEnter={() => setHoveredPoint({ nucleo, index, value, time })}
                        onMouseLeave={() => setHoveredPoint(null)}
                        onClick={() => setHoveredPoint((prev) => prev && prev.nucleo === nucleo && prev.index === index ? null : { nucleo, index, value, time })}
                      />
                      {isHovered && (
                        <g>
                          <rect x={x - 30} y={y - 35} width="60" height="25" fill="rgba(0,0,0,0.8)" rx="4" />
                          <text x={x} y={y - 20} fontSize="10" fill="white" textAnchor="middle">{time}</text>
                        </g>
                      )}
                    </g>
                  );
                })}
              </g>
            );
          })}

          <g transform={`translate(${padding}, ${height - 20})`}>
            {["NEEETA", "NEECT", "NEI"].map((nucleo, index) => (
              <g key={nucleo} transform={`translate(${index * 80}, 0)`}>
                <rect width="12" height="12" fill={colors[nucleo]} />
                <text x="16" y="9" fontSize="12" fill="currentColor">
                  {nucleo}
                </text>
              </g>
            ))}
          </g>
        </svg>
      </div>
    </div>
  );
}


