/**
 * ProgressBar - Component for showing progress of bulk operations
 */

import React from "react";
import PropTypes from "prop-types";

const ProgressBar = ({
    current = 0,
    total = 0,
    label = "",
    showPercentage = true,
    className = ""
}) => {
    const percent = total > 0 ? Math.round((current / total) * 100) : 0;

    return (
        <div className={`space-y-2 ${className}`}>
            {label && (
                <div className="flex items-center justify-between text-sm">
                    <span className="font-medium">{label}</span>
                    {showPercentage && (
                        <span className="text-base-content/60">
                            {current} / {total} ({percent}%)
                        </span>
                    )}
                </div>
            )}
            <div className="w-full bg-base-200 rounded-full h-2 overflow-hidden">
                <div
                    className="h-full bg-primary transition-all duration-300 ease-out"
                    style={{ width: `${percent}%` }}
                />
            </div>
        </div>
    );
};

ProgressBar.propTypes = {
    current: PropTypes.number.isRequired,
    total: PropTypes.number.isRequired,
    label: PropTypes.string,
    showPercentage: PropTypes.bool,
    className: PropTypes.string,
};

export default ProgressBar;

