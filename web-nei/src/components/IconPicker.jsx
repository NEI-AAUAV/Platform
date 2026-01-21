/**
 * IconPicker - Visual icon selector for Role Manager
 * Shows available icons as clickable tiles, allows text input for custom paths
 */
import { useState } from "react";
import PropTypes from "prop-types";
import classNames from "classnames";
import MaterialSymbol from "components/MaterialSymbol";

// Available icons mapped to their paths - ordered by role hierarchy
const AVAILABLE_ICONS = [
    // Faina Hierarchy
    { name: "Faina", path: "/icons/faina.svg" },
    { name: "Anzol (CF)", path: "/icons/anzol.svg" },
    { name: "Sal (CS)", path: "/icons/sal.svg" },
    { name: "Pá (Salgado)", path: "/icons/pa.svg" },
    { name: "Lenço (Pescador)", path: "/icons/lenco.svg" },
    { name: "Rol (Escrivão)", path: "/icons/rol.svg" },
    // Other Organizations
    { name: "NEI", path: "/icons/nei.svg" },
    { name: "AETTUA", path: "/icons/aettua.svg" },
    { name: "AAUAv", path: "/icons/aauav.svg" },
];

export default function IconPicker({ value, onChange, inheritedIcon, inputId }) {
    const [showCustom, setShowCustom] = useState(false);
    const [customPath, setCustomPath] = useState(value || "");

    // Sanitizer to prevent XSS via dangerous URL schemes
    // Allows: relative paths under /icons/ or absolute HTTPS URLs
    const sanitizeIconPath = (rawPath) => {
        if (!rawPath) return "";
        const trimmed = rawPath.trim();

        // 1. Safe local icons: /icons/filename.svg (letters, numbers, underscores, hyphens)
        // Strictly validates structure to prevent any path traversal or injection chars
        if (trimmed.startsWith("/icons/")) {
            const iconPattern = /^\/icons\/[\w-]+\.svg$/i;
            return iconPattern.test(trimmed) ? trimmed : "";
        }

        // 2. Strict absolute HTTPS URLs
        // Uses URL constructor to parse and validate protocol
        if (trimmed.startsWith("https://")) {
            try {
                const url = new URL(trimmed);
                return url.protocol === "https:" ? trimmed : "";
            } catch (e) {
                // Invalid URL format, safe to ignore
                return "";
            }
        }

        return "";
    };

    const handleSelectIcon = (path) => {
        const safePath = sanitizeIconPath(path);
        if (!safePath) return;
        onChange(safePath);
        setCustomPath(safePath);
        setShowCustom(false);
    };

    const handleClear = () => {
        onChange("");
        setCustomPath("");
    };

    const handleCustomSubmit = () => {
        const safePath = sanitizeIconPath(customPath);
        if (safePath) {
            onChange(safePath);
            setCustomPath(safePath);
        }
        setShowCustom(false);
    };

    // Determine what icon to show in preview
    // Strict sanitization applied before rendering to satisfy security scanners
    const displayIcon = sanitizeIconPath(value || inheritedIcon);
    const isInherited = !value && inheritedIcon;

    // Helper function to get preview box border/bg classes (avoids nested ternary)
    const getPreviewBoxClasses = () => {
        if (isInherited) return "border-dashed border-base-content/20 bg-base-200/50";
        if (value) return "border-primary/30 bg-primary/5";
        return "border-base-content/10 bg-base-200";
    };

    // Helper function to render icon status text (avoids nested ternary)
    const renderIconStatus = () => {
        if (isInherited) {
            return (
                <div className="text-sm text-base-content/50">
                    <span className="italic">Herdado do parent</span>
                    <div className="text-xs font-mono opacity-60 truncate">{inheritedIcon}</div>
                </div>
            );
        }
        if (value) {
            return (
                <div className="text-sm">
                    <span className="font-medium">Ícone definido</span>
                    <div className="text-xs font-mono opacity-60 truncate">{value}</div>
                </div>
            );
        }
        return (
            <div className="text-sm text-base-content/40 italic">
                Sem ícone (herdará do parent)
            </div>
        );
    };

    return (
        <div className="space-y-3" role="group" aria-labelledby={inputId}>
            {/* Hidden input to associate external label for accessibility */}
            {inputId && (
                <input
                    id={inputId}
                    type="text"
                    className="sr-only"
                    tabIndex={-1}
                    value={value || ""}
                    readOnly
                    aria-hidden="true"
                />
            )}
            {/* Current Icon Preview */}
            <div className="flex items-center gap-3">
                <div className={classNames(
                    "flex h-14 w-14 items-center justify-center rounded-xl border-2",
                    getPreviewBoxClasses()
                )}>
                    {displayIcon ? (
                        <img
                            src={displayIcon}
                            alt=""
                            className={classNames("h-8 w-8 object-contain", isInherited && "opacity-50")}
                            onError={(e) => e.target.style.display = 'none'}
                        />
                    ) : (
                        <MaterialSymbol icon="image" size={24} className="text-base-content/30" />
                    )}
                </div>
                <div className="flex-1">
                    {renderIconStatus()}
                </div>
                {value && (
                    <button
                        type="button"
                        className="btn btn-ghost btn-xs btn-circle"
                        onClick={handleClear}
                        title="Remover ícone (usará herança)"
                    >
                        <MaterialSymbol icon="close" size={16} />
                    </button>
                )}
            </div>

            {/* Icon Grid */}
            <div className="grid grid-cols-5 gap-2">
                {AVAILABLE_ICONS.map((icon) => (
                    <button
                        key={icon.path}
                        type="button"
                        onClick={() => handleSelectIcon(icon.path)}
                        className={classNames(
                            "flex flex-col items-center gap-1 rounded-lg p-2 transition-all",
                            value === icon.path
                                ? "bg-primary text-primary-content ring-2 ring-primary ring-offset-2"
                                : "bg-base-200 hover:bg-base-300"
                        )}
                        title={icon.name}
                    >
                        <img
                            src={icon.path}
                            alt={icon.name}
                            className="h-6 w-6 object-contain"
                        />
                        <span className="text-[9px] truncate w-full text-center opacity-70">
                            {icon.name}
                        </span>
                    </button>
                ))}

                {/* Custom Path Button */}
                <button
                    type="button"
                    onClick={() => setShowCustom(!showCustom)}
                    className={classNames(
                        "flex flex-col items-center gap-1 rounded-lg p-2 transition-all",
                        showCustom ? "bg-info/20" : "bg-base-200 hover:bg-base-300"
                    )}
                    title="Caminho personalizado"
                >
                    <MaterialSymbol icon="edit" size={24} className="opacity-60" />
                    <span className="text-[9px] opacity-70">Custom</span>
                </button>
            </div>

            {/* Custom Path Input */}
            {showCustom && (
                <div className="flex gap-2 animate-in slide-in-from-top-2">
                    <input
                        type="text"
                        className="input input-bordered input-sm flex-1"
                        placeholder="/icons/meu-icone.svg"
                        value={customPath}
                        onChange={(e) => setCustomPath(e.target.value)}
                        onKeyDown={(e) => e.key === 'Enter' && handleCustomSubmit()}
                    />
                    <button
                        type="button"
                        className="btn btn-sm btn-primary"
                        onClick={handleCustomSubmit}
                    >
                        OK
                    </button>
                </div>
            )}
        </div>
    );
}

IconPicker.propTypes = {
    value: PropTypes.string,
    onChange: PropTypes.func.isRequired,
    inheritedIcon: PropTypes.string,
    inputId: PropTypes.string,
};

export { AVAILABLE_ICONS };
