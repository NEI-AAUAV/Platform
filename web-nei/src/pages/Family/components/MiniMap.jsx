/**
 * MiniMap - Overview navigation component for family tree
 * 
 * Displays a small thumbnail of the entire tree with viewport indicator.
 * Click to navigate the main tree view.
 */

import React, { useEffect, useRef, useCallback } from "react";
import PropTypes from "prop-types";
import * as d3 from "d3";
import classNames from "classnames";

const MiniMap = ({
    mainSvg,
    treeGroup,
    width = 200,
    height = 150,
    className
}) => {
    const miniMapRef = useRef(null);

    // Draw mini-map after initial render
    useEffect(() => {
        if (!mainSvg || !miniMapRef.current) return;

        // Wait a bit for D3 to finish rendering
        const timer = setTimeout(() => {
            try {
                const mainGroup = mainSvg.querySelector("g");
                if (!mainGroup) return;

                const bounds = mainGroup.getBBox();
                if (!bounds || bounds.width === 0) return;

                // Calculate scale to fit tree in mini-map
                const padding = 15;
                const scale = Math.min(
                    (width - padding * 2) / bounds.width,
                    (height - padding * 2) / bounds.height
                );

                // Draw on mini-map
                const miniSvg = d3.select(miniMapRef.current);
                miniSvg.selectAll("*").remove();

                // Background
                miniSvg.append("rect")
                    .attr("width", width)
                    .attr("height", height)
                    .attr("fill", "hsl(var(--b2))")
                    .attr("rx", 8);

                const miniGroup = miniSvg
                    .append("g")
                    .attr("transform", `translate(${padding - bounds.x * scale}, ${padding - bounds.y * scale}) scale(${scale})`);

                // Draw paths (links between nodes)
                mainGroup.querySelectorAll("path:not(.animated-lineage-path)").forEach(path => {
                    const d = path.getAttribute("d");
                    if (d) {
                        miniGroup.append("path")
                            .attr("d", d)
                            .attr("fill", "none")
                            .attr("stroke", "hsl(var(--bc) / 0.3)")
                            .attr("stroke-width", 1 / scale);
                    }
                });

                // Draw nodes as circles - look for g.node elements
                mainGroup.querySelectorAll("g.node").forEach(nodeG => {
                    const transform = nodeG.getAttribute("transform");
                    if (transform) {
                        const match = transform.match(/translate\(\s*([^,]+)\s*,\s*([^)]+)\s*\)/);
                        if (match) {
                            const cx = parseFloat(match[1]);
                            const cy = parseFloat(match[2]);

                            // Get color from the profile-grad circle
                            const gradCircle = nodeG.querySelector("circle.profile-grad");
                            const fill = gradCircle ? gradCircle.style.fill : "hsl(var(--p))";

                            miniGroup.append("circle")
                                .attr("cx", cx)
                                .attr("cy", cy)
                                .attr("r", 12)
                                .attr("fill", fill)
                                .attr("opacity", 0.8);
                        }
                    }
                });

            } catch (e) {
                console.error("MiniMap error:", e);
            }
        }, 500);

        return () => clearTimeout(timer);
    }, [mainSvg, treeGroup, width, height]);

    // Handle click to navigate
    const handleClick = useCallback((e) => {
        if (!mainSvg) return;

        try {
            const mainGroup = mainSvg.querySelector("g");
            if (!mainGroup) return;

            const bounds = mainGroup.getBBox();
            const rect = miniMapRef.current.getBoundingClientRect();
            const clickX = e.clientX - rect.left;
            const clickY = e.clientY - rect.top;

            const padding = 15;
            const scale = Math.min(
                (width - padding * 2) / bounds.width,
                (height - padding * 2) / bounds.height
            );

            // Convert to tree coordinates
            const treeX = bounds.x + (clickX - padding) / scale;
            const treeY = bounds.y + (clickY - padding) / scale;

            // Navigate to that point
            const svg = d3.select(mainSvg);
            const svgRect = mainSvg.getBoundingClientRect();
            const transform = d3.zoomTransform(mainSvg);

            const newX = svgRect.width / 2 - treeX * transform.k;
            const newY = svgRect.height / 2 - treeY * transform.k;

            svg.transition()
                .duration(300)
                .call(
                    d3.zoom().transform,
                    d3.zoomIdentity.translate(newX, newY).scale(transform.k)
                );
        } catch (e) {
            console.error("MiniMap click error:", e);
        }
    }, [mainSvg, width, height]);

    return (
        <div
            className={classNames(
                "absolute bottom-4 right-4 rounded-xl border-2 border-base-content/20 bg-base-100 shadow-xl overflow-hidden cursor-pointer z-30",
                className
            )}
            onClick={handleClick}
            title="Clique para navegar"
        >
            <svg
                ref={miniMapRef}
                width={width}
                height={height}
                className="block"
            />
            {/* Label */}
            <div className="absolute top-1 left-2 text-[10px] font-bold text-base-content/40 uppercase tracking-wide">
                Mapa
            </div>
        </div>
    );
};

MiniMap.propTypes = {
    mainSvg: PropTypes.object,
    treeGroup: PropTypes.object,
    width: PropTypes.number,
    height: PropTypes.number,
    className: PropTypes.string,
};

export default MiniMap;
