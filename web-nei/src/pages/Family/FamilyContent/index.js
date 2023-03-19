// example from https://bl.ocks.org/mbostock/3885705

import React, { useEffect } from "react";

import { buildTree, centerTree, filterTree, patterns } from "../data";


const FamilyContent = ({ insignias, year, auth }) => {

  useEffect(() => {
    if (auth) {
      buildTree();
      centerTree();
    }
  }, [auth]);

  useEffect(() => {
    if (auth) filterTree(insignias, year);
  }, [insignias, year, auth]);

  return (
    <svg className="treeei">
      <defs>
        <marker
          id="dot"
          viewBox="0,0,20,20"
          refX="10"
          refY="10"
          markerWidth="10"
          markerHeight="10"
        >
          <circle cx="10" cy="10" r="4"></circle>
        </marker>
        <filter id="drop-shadow2" height="130%">
          <feGaussianBlur
            in="SourceAlpha"
            stdDeviation="5"
            result="blur"
          ></feGaussianBlur>
          <feOffset in="blur" dx="5" dy="5" result="offsetBlur"></feOffset>
          <feMerge>
            <feMergeNode in="offsetBlur"></feMergeNode>
            <feMergeNode in="SourceGraphic"></feMergeNode>
          </feMerge>
        </filter>
        <filter
          id="drop-shadow"
          filterUnits="userSpaceOnUse"
          width="250%"
          height="250%"
        >
          <feGaussianBlur
            in="SourceGraphic"
            stdDeviation="2"
            result="blur-out"
          ></feGaussianBlur>
          {/* <feColorMatrix in="blur-out" type="hueRotate" values="180" result="color-out"></feColorMatrix> */}
          <feOffset in="color-out" dx="1" dy="1" result="the-shadow"></feOffset>
          <feOffset
            in="color-out"
            dx="-1"
            dy="-1"
            result="the-shadow"
          ></feOffset>
          <feBlend in="SourceGraphic" in2="the-shadow" mode="normal"></feBlend>
        </filter>
        {patterns.map(({ id, image }) => (
          <pattern
            key={id}
            id={id}
            width="1"
            height="1"
            patternContentUnits="objectBoundingBox"
          >
            <image
              xlinkHref={image}
              height="1"
              width="1"
              preserveAspectRatio="xMinYMin slice"
            ></image>
          </pattern>
        ))}
      </defs>
      {/* <text x="100" y="100" style={{ font: "bold 300px sans-serif" }}>
        djfldsk
      </text> */}
    </svg>
  );
};

export default FamilyContent;
