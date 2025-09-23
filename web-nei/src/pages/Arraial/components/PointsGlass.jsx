import React from "react";
import neiLogo from "assets/images/NEI.png";
import neectLogo from "assets/images/NEECT.png";
import neeetaLogo from "assets/images/NEEETA.png";

export default function PointsGlass({
  pointsData,
  pointsList,
  boosts,
  calcHeight,
  BoostCountdown,
  animateFill = false,
  isLcp = false,
}) {
  const logoSrc =
    pointsData.nucleo === "NEECT"
      ? neectLogo
      : pointsData.nucleo === "NEEETA"
      ? neeetaLogo
      : neiLogo;

  return (
    <div className="flex flex-col justify-center items-center space-y-2">
      <div className={`relative block mx-auto w-48 sm:w-56 md:w-64 lg:w-[40vh] h-[40vh] sm:h-[48vh] md:h-[55vh] border-8 border-white border-t-0 rounded-b-[3rem]`}>
        <div className="absolute inset-0 overflow-hidden rounded-b-[2.5rem]">
          <div className="glass-inner" aria-hidden="true"></div>
          <div className="glass-rim" aria-hidden="true"></div>
          <div className="absolute top-[34px] left-0 right-0 bottom-[32px] flex items-center justify-center pointer-events-none z-[5]" aria-hidden="true">
            <img
              src={logoSrc}
              alt={pointsData.nucleo}
              width="256"
              height="256"
              decoding="async"
              {...(isLcp ? { fetchpriority: 'high' } : {})}
              className="max-w-[42%] max-h-[42%] opacity-75"
            />
          </div>
          <div className={`absolute bottom-0 left-0 w-full ${animateFill ? 'transition-all duration-500' : ''}`} style={{ height: calcHeight(pointsData.value), overflow: "hidden" }}>
            <div className="relative w-full h-full">
              <div
                className="absolute left-0 right-0 bottom-0"
                style={{
                  top: `${18 + 22}px`,
                  background:
                    "linear-gradient(180deg, #f9d648 0%, #f4c534 65%, #e8b82e 100%)",
                  boxShadow: "inset 0 2px 0 rgba(255,255,255,0.25)",
                }}
                aria-hidden="true"
              ></div>
              <div className="bubbles" style={{ top: `${18}px` }} aria-hidden="true"></div>
              <div
                className="absolute top-0 left-0 right-0 overflow-hidden"
                style={{
                  height: `${18 + 22}px`,
                  background: "rgba(255,255,255,0.98)",
                  borderTopLeftRadius: 28,
                  borderTopRightRadius: 28,
                }}
                aria-hidden="true"
              >
                <div className="foam-texture" />
                <div className="foam-shadow" />
              </div>
              <div className="beer-vignette" aria-hidden="true"></div>
              <div className="glass-shadow" aria-hidden="true"></div>
              <div className="glass-base-highlight" aria-hidden="true"></div>
              <div className="glass-glare-left" aria-hidden="true"></div>
            </div>
          </div>
        </div>
      </div>

      <div className="text-center">
        <div>
          <div className="flex items-center justify-center gap-2">
            <h2>{pointsData.nucleo}</h2>
          </div>
          <h3>Points: {pointsData.value}</h3>
          {boosts?.[pointsData.nucleo] && (
            <BoostCountdown
              untilIso={boosts[pointsData.nucleo]}
              nucleo={pointsData.nucleo}
              onExpire={(n) => {
                // No-op here; parent should own state update
              }}
            />
          )}
        </div>
      </div>
    </div>
  );
}
