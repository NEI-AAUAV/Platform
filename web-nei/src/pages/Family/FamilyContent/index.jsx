// example from https://bl.ocks.org/mbostock/3885705

import React, { useEffect, useState, useRef } from "react";

import { buildTree, centerTree, filterTree, patterns } from "../data";
import FamilyService from "services/FamilyService";


const FamilyContent = ({ insignias, year, auth }) => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [treeReady, setTreeReady] = useState(false);
  const svgRef = useRef(null);
  const dataRef = useRef(null);

  // Fetch data on mount
  useEffect(() => {
    async function fetchData() {
      try {
        const data = await FamilyService.getTree();
        // Store data for when SVG is ready
        dataRef.current = data.roots || [];
      } catch (err) {
        console.error("Failed to load family tree:", err);
        setError(err);
      } finally {
        setLoading(false);
      }
    }
    fetchData();
  }, []);

  // Build tree after SVG is rendered and data is loaded
  useEffect(() => {
    if (!loading && !error && svgRef.current && dataRef.current) {
      try {
        const users = flattenTreeData(dataRef.current);
        buildTree(users);
        centerTree();
        setTreeReady(true);
      } catch (err) {
        console.error("Failed to build tree:", err);
        setError(err);
      }
    }
  }, [loading, error]);

  // Filter tree when filters change
  useEffect(() => {
    if (treeReady) {
      filterTree(insignias, year);
    }
  }, [insignias, year, treeReady]);

  return (
    <>
      {loading && (
        <div className="absolute inset-0 flex h-full w-full items-center justify-center bg-base-100/80 z-10">
          <span className="loading loading-spinner loading-lg"></span>
        </div>
      )}
      {error && (
        <div className="absolute inset-0 flex h-full w-full items-center justify-center bg-base-100/80 z-10">
          <div className="text-center">
            <p className="text-error">Erro ao carregar a árvore</p>
            <button
              className="btn btn-primary btn-sm mt-2"
              onClick={() => window.location.reload()}
            >
              Tentar novamente
            </button>
          </div>
        </div>
      )}
      <svg ref={svgRef} className="treeei" width="100%" height="100%" viewBox="0 0 800 600">
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
      </svg>
    </>
  );
};

/**
 * Flatten nested tree from API into flat array for D3 stratify
 */
function flattenTreeData(roots) {
  const users = [];

  // Add virtual root
  users.push({ id: 0, parent: null, name: "Root" });

  function traverse(node, parentId) {
    const user = {
      id: node._id,
      parent: parentId,
      name: node.name,
      sex: node.sex,
      start_year: node.start_year,
      end_year: node.end_year,
      nmec: node.nmec,
      course_id: node.course_id,
      image: node.image || null,
      // Map organizations from user_roles
      // API now returns org_name directly (e.g., "NEI", "CF")
      organizations: node.user_roles?.map(r => ({
        name: r.org_name || r.role_id,
        year: r.year,
        role: r.role_name,
      })) || [],
      // Faina data
      faina: node.faina_name ? [{
        name: node.faina_name,
        year: node.start_year + 1,
      }] : null,
    };

    users.push(user);

    if (node.children) {
      for (const child of node.children) {
        traverse(child, node._id);
      }
    }
  }

  for (const root of roots) {
    traverse(root, 0);
  }

  return users;
}

export default FamilyContent;
