/**
 * Breadcrumbs - Shows navigation path from root to selected node
 * 
 * Displays clickable ancestors chain for easy navigation.
 */

import React from "react";
import PropTypes from "prop-types";
import classNames from "classnames";
import { getAncestors, NodeShape } from "../utils";
import MaterialSymbol from "components/MaterialSymbol";

const Breadcrumbs = ({
    selectedNode,
    onNavigate,
    className
}) => {
    if (!selectedNode || selectedNode.data?.id === 0) return null;

    const ancestors = getAncestors(selectedNode);
    const items = [...ancestors, selectedNode];

    const handleClick = (node, e) => {
        e.preventDefault();
        onNavigate?.(node);
    };

    return (
        <div
            className={classNames(
                "absolute top-4 left-4 right-4 z-10",
                "flex items-center gap-1 flex-wrap",
                "text-sm font-medium",
                className
            )}
        >
            {/* Root indicator */}
            <button
                className="flex items-center gap-1 px-2 py-1 rounded-lg bg-base-200/80 backdrop-blur-sm hover:bg-base-300 transition-colors"
                onClick={(e) => handleClick(null, e)}
                title="Ir para raiz"
            >
                <MaterialSymbol icon="home" size={16} />
                <span>Raiz</span>
            </button>

            {items.map((node, index) => (
                <React.Fragment key={node.data?.id || index}>
                    <MaterialSymbol
                        icon="chevron_right"
                        size={16}
                        className="text-base-content/40"
                    />
                    <button
                        className={classNames(
                            "flex items-center gap-1 px-2 py-1 rounded-lg backdrop-blur-sm transition-colors max-w-[150px]",
                            index === items.length - 1
                                ? "bg-primary/20 text-primary font-bold"
                                : "bg-base-200/80 hover:bg-base-300"
                        )}
                        onClick={(e) => handleClick(node, e)}
                        title={node.data?.name}
                    >
                        <span className="truncate">{node.data?.name || `#${node.data?.id}`}</span>
                    </button>
                </React.Fragment>
            ))}
        </div>
    );
};

Breadcrumbs.propTypes = {
    selectedNode: NodeShape,
    onNavigate: PropTypes.func,
    className: PropTypes.string,
};

export default Breadcrumbs;
