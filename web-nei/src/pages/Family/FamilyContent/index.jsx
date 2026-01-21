/**
 * FamilyContent - Main tree visualization container
 * 
 * Integrates the D3 tree with lineage highlighting.
 */

import React, { useEffect, useState, useRef, useCallback } from "react";
import PropTypes from "prop-types";

import {
  buildTree,
  centerTree,
  filterTree,
  patterns,
  highlightLineage,
  clearHighlight,
  animatePathToNode,
  getNodeById,
  navigateToNode
} from "../data";
import { flattenTree } from "../utils";



const FamilyContent = ({
  insignias = [],
  year,
  users = [],
  minYear,
  maxYear,
  loading: externalLoading = false,
  editMode = false,
  onNodeEdit = () => { }
}) => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [treeReady, setTreeReady] = useState(false);
  const [selectedNode, setSelectedNode] = useState(null);

  const svgRef = useRef(null);

  // Build tree after users data is available
  useEffect(() => {
    if (!users || users.length === 0 || externalLoading) {
      setLoading(true);
      return;
    }

    if (!svgRef.current) {
      setLoading(false);
      return;
    }

    try {
      // Flatten tree if needed (API returns nested structure)
      const flatUsers = users[0]?.children !== undefined
        ? flattenTree(users)
        : users;

      buildTree(flatUsers, {
        minYear,
        maxYear,
        onNodeSelect: handleNodeSelect,
        onNodeHover: handleNodeHover,
        editMode,
        onNodeEdit
      });

      centerTree();
      setTreeReady(true);
      setLoading(false);

    } catch (err) {
      console.error("Failed to build tree:", err);
      setError(err);
      setLoading(false);
    }
  }, [users, externalLoading, minYear, maxYear, editMode]);

  // Filter tree when filters change
  useEffect(() => {
    if (treeReady && year !== null) {
      filterTree(insignias, year);
    }
  }, [insignias, year, treeReady]);

  // Handle node selection
  const handleNodeSelect = useCallback((nodeId) => {
    const node = getNodeById(nodeId);
    if (node) {
      setSelectedNode(node);
      highlightLineage(nodeId);
      animatePathToNode(nodeId);
    }
  }, []);

  // Handle node hover - show lineage on hover, restore selection on leave
  const handleNodeHover = useCallback((nodeId, isHovering) => {
    if (isHovering) {
      highlightLineage(nodeId);
    } else if (selectedNode) {
      highlightLineage(selectedNode.data.id);
    } else {
      clearHighlight();
    }
  }, [selectedNode]);

  // Clear selection when clicking on empty SVG area
  const handleSvgClick = useCallback((e) => {
    if (e.target.tagName === 'svg') {
      clearHighlight();
      setSelectedNode(null);
    }
  }, []);

  // Keyboard navigation helpers
  const navigateToParent = useCallback(() => {
    if (selectedNode?.parent && selectedNode.parent.data.id !== 0) {
      const parent = selectedNode.parent;
      setSelectedNode(parent);
      navigateToNode(parent);
      highlightLineage(parent.data.id);
      return true;
    }
    return false;
  }, [selectedNode]);

  const navigateToChild = useCallback(() => {
    if (selectedNode?.children?.length > 0) {
      const firstChild = selectedNode.children[0];
      setSelectedNode(firstChild);
      navigateToNode(firstChild);
      highlightLineage(firstChild.data.id);
      return true;
    }
    return false;
  }, [selectedNode]);

  const navigateToSibling = useCallback((direction) => {
    if (!selectedNode?.parent?.children) return false;
    const siblings = selectedNode.parent.children;
    const currentIdx = siblings.findIndex(s => s.data.id === selectedNode.data.id);
    const nextIdx = direction === 'left'
      ? Math.max(0, currentIdx - 1)
      : Math.min(siblings.length - 1, currentIdx + 1);
    const sibling = siblings[nextIdx];
    if (sibling && sibling.data.id !== selectedNode.data.id) {
      setSelectedNode(sibling);
      navigateToNode(sibling);
      highlightLineage(sibling.data.id);
      return true;
    }
    return false;
  }, [selectedNode]);

  // Keyboard navigation
  const handleKeyDown = useCallback((e) => {
    if (!selectedNode) return;

    switch (e.key) {
      case 'Escape':
        clearHighlight();
        setSelectedNode(null);
        break;
      case 'ArrowUp':
        navigateToParent();
        e.preventDefault();
        break;
      case 'ArrowDown':
        navigateToChild();
        e.preventDefault();
        break;
      case 'ArrowLeft':
        navigateToSibling('left');
        e.preventDefault();
        break;
      case 'ArrowRight':
        navigateToSibling('right');
        e.preventDefault();
        break;
      default:
        break;
    }
  }, [selectedNode, navigateToParent, navigateToChild, navigateToSibling]);

  const isLoading = loading || externalLoading;

  return (
    <div
      className="relative h-full w-full"
      onKeyDown={handleKeyDown}
      tabIndex={0}
      role="region"
      aria-label="Visualização da árvore genealógica"
    >
      {isLoading && (
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


      {/* Main SVG Tree */}
      <svg
        ref={svgRef}
        className="treeei"
        width="100%"
        height="100%"
        viewBox="0 0 800 600"
        onClick={handleSvgClick}
        role="tree"
        aria-label="Árvore genealógica da família"
      >
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

    </div>
  );
};

FamilyContent.propTypes = {
  insignias: PropTypes.arrayOf(PropTypes.string),
  year: PropTypes.number,
  users: PropTypes.array,
  minYear: PropTypes.number,
  maxYear: PropTypes.number,
  loading: PropTypes.bool,
  editMode: PropTypes.bool,
  onNodeEdit: PropTypes.func,
};

export default FamilyContent;

