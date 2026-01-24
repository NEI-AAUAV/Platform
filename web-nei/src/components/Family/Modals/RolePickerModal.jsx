import { useState, useEffect } from "react";
import { createPortal } from "react-dom";
import PropTypes from "prop-types";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";
import MaterialSymbol from "components/MaterialSymbol";
import { CloseIcon } from "assets/icons/google";
import { organizations } from "pages/Family/data";
import FamilyService from "services/FamilyService";

/**
 * Reusable Role Picker Modal
 * @param {boolean} isOpen
 * @param {function} onClose
 * @param {function} onSelect - callback(node, year)
 */
export default function RolePickerModal({ isOpen, onClose, onSelect, hideYear = false }) {
    const [roleTree, setRoleTree] = useState([]);
    const [roleYear, setRoleYear] = useState(new Date().getFullYear() - 2000);
    const [pickerPath, setPickerPath] = useState([]); // Breadcrumb path: [Node, Node]
    const [selectedRoleNode, setSelectedRoleNode] = useState(null);
    const [loading, setLoading] = useState(false);

    // Load role tree
    useEffect(() => {
        async function loadRoleTree() {
            try {
                const tree = await FamilyService.getRoleTree();
                setRoleTree(tree || []);
            } catch (err) {
                console.error("Failed to load role tree:", err);
            }
        }
        if (isOpen && roleTree.length === 0) {
            loadRoleTree();
        }
    }, [isOpen, roleTree.length]);

    // Reset on close
    useEffect(() => {
        if (!isOpen) {
            setPickerPath([]);
            setSelectedRoleNode(null);
            setLoading(false);
        }
    }, [isOpen]);

    const navigateToNode = (node) => {
        setPickerPath([...pickerPath, node]);
        setSelectedRoleNode(null);
    };

    const navigateUp = () => {
        const newPath = [...pickerPath];
        newPath.pop();
        setPickerPath(newPath);
        setSelectedRoleNode(null);
    };

    const handleSelect = async () => {
        if (!selectedRoleNode) return;
        setLoading(true);
        await onSelect(selectedRoleNode, roleYear);
        setLoading(false);
        onClose();
    };

    // Helper to find icon for a node
    // Priority: node.icon (from API) > organizations[short] > organizations[name] > special roles
    const getIconForNode = (node) => {
        // First check for dynamic icon from API (set in RoleManager)
        if (node.icon) {
            return node.icon;
        }
        // Then check static organizations map
        if (node.short && organizations[node.short]) {
            return organizations[node.short].insignia;
        }
        if (node.name && organizations[node.name]) {
            return organizations[node.name].insignia;
        }
        // Special roles handling
        const specialRoles = {
            "escrivão": "escrivao",
            "pescador": "pescador",
            "salgado": "salgado",
        };
        for (const [key, val] of Object.entries(specialRoles)) {
            if (node.name.toLowerCase().includes(key) && organizations[val]) {
                return organizations[val].insignia;
            }
        }
        return null;
    };

    const renderPickerContent = () => {
        if (roleTree.length === 0) {
            return (
                <div className="flex justify-center py-8">
                    <span className="loading loading-spinner loading-sm"></span>
                </div>
            );
        }

        let currentNodes = roleTree;
        if (pickerPath.length > 0) {
            const parent = pickerPath[pickerPath.length - 1];
            currentNodes = parent.children || [];
        }

        return (
            <div className="grid grid-cols-2 gap-3 p-1">
                {currentNodes.map((node) => {
                    const icon = getIconForNode(node);
                    const isSelected = selectedRoleNode && selectedRoleNode.id === node.id;
                    const hasChildren = node.children && node.children.length > 0;

                    return (
                        <div
                            key={node.id}
                            className={classNames(
                                "group relative flex flex-col items-center justify-center gap-3 rounded-xl border p-4 transition-all",
                                isSelected
                                    ? "border-primary bg-primary/10 ring-1 ring-primary"
                                    : "border-base-content/10 bg-base-100 hover:border-primary hover:bg-base-200"
                            )}
                        >
                            <button
                                type="button"
                                className="flex h-full w-full flex-col items-center justify-center"
                                onClick={() => {
                                    if (hasChildren) {
                                        navigateToNode(node);
                                    } else {
                                        setSelectedRoleNode(node);
                                    }
                                }}
                            >
                                <div className="h-12 w-12 flex-shrink-0">
                                    {icon ? (
                                        <img src={icon} alt="" className="h-full w-full object-contain" />
                                    ) : (
                                        <div className="flex h-full w-full items-center justify-center rounded-full bg-base-300">
                                            <MaterialSymbol icon={hasChildren ? "domain" : "badge"} size={24} className="text-base-content/50" />
                                        </div>
                                    )}
                                </div>
                                <div className="mt-3 text-center">
                                    <div className="font-medium leading-tight">{node.name}</div>
                                    {node.short && (
                                        <div className="mt-1 text-xs text-base-content/50">
                                            {node.short}
                                        </div>
                                    )}
                                </div>
                            </button>

                            {/* Selection Checkbox/Overlay for Folders */}
                            {hasChildren && (
                                <button
                                    type="button"
                                    className={classNames(
                                        "absolute top-2 right-2 flex h-6 w-6 items-center justify-center rounded-full transition-colors",
                                        isSelected ? "bg-primary text-primary-content" : "bg-base-300 text-base-content/20 hover:bg-primary/20 hover:text-primary"
                                    )}
                                    onClick={(e) => {
                                        e.stopPropagation();
                                        setSelectedRoleNode(node);
                                    }}
                                    title="Selecionar esta categoria"
                                >
                                    <MaterialSymbol icon="check" size={16} />
                                </button>
                            )}
                        </div>
                    );
                })}
            </div>
        );
    };

    return createPortal(
        <AnimatePresence>
            {isOpen && (
                <div className="fixed inset-0 z-[120] flex items-center justify-center p-6">
                    {/* Backdrop Button - Accessible way to close */}
                    <button
                        type="button"
                        className="fixed inset-0 h-full w-full cursor-default bg-black/40 backdrop-blur-[2px]"
                        onClick={onClose}
                        aria-label="Fechar modal"
                    />

                    <motion.div
                        initial={{ scale: 0.95, opacity: 0 }}
                        animate={{ scale: 1, opacity: 1 }}
                        exit={{ scale: 0.95, opacity: 0 }}
                        className="relative z-10 flex h-[550px] w-full max-w-lg flex-col rounded-2xl border border-base-content/10 bg-base-100 shadow-2xl"
                        onClick={(e) => e.stopPropagation()}
                    >
                        {/* Header */}
                        <div className="flex items-center gap-3 border-b border-base-content/10 px-6 py-4">
                            {pickerPath.length > 0 && (
                                <button className="btn btn-ghost btn-circle btn-sm -ml-2" onClick={navigateUp}>
                                    <MaterialSymbol icon="arrow_back" size={20} />
                                </button>
                            )}
                            <h3 className="text-lg font-bold">
                                {pickerPath.length === 0 ? "Escolher Filtro" : pickerPath[pickerPath.length - 1].name}
                            </h3>
                            <button

                                className="btn btn-ghost btn-sm btn-circle ml-auto"
                                onClick={onClose}
                            >
                                <CloseIcon />
                            </button>
                        </div>

                        {/* Year Selection (Conditionally visible) */}
                        {!hideYear && (
                            <div className="flex items-center justify-between border-b border-base-content/10 bg-base-200/30 px-6 py-3">
                                <span className="text-sm font-medium">Ano da Insígnia (Opcional)</span>
                                <div className="flex items-center gap-2">
                                    <button
                                        className="btn btn-ghost btn-xs text-xs font-normal"
                                        onClick={() => setRoleYear(null)}
                                        disabled={!roleYear}
                                    >
                                        Limpar
                                    </button>
                                    <input
                                        type="number"
                                        className="input input-bordered input-sm w-20 text-center"
                                        value={roleYear || ""}
                                        placeholder="-"
                                        onChange={(e) =>
                                            setRoleYear(e.target.value ? parseInt(e.target.value) : null)
                                        }
                                        min={0}
                                        max={99}
                                    />
                                    <span className="text-sm text-base-content/50">
                                        {roleYear ? `(20${roleYear} | ${roleYear}/${roleYear + 1})` : "(Todos)"}
                                    </span>
                                </div>
                            </div>
                        )}

                        {/* Picker Content */}
                        <div className="flex-1 overflow-y-auto p-4">
                            {renderPickerContent()}
                        </div>

                        {/* Footer - Show Select button if any node is selected */}
                        {selectedRoleNode && (
                            <div className="border-t border-base-content/10 px-6 py-4">
                                <button
                                    className={classNames("btn btn-primary w-full", {
                                        loading: loading,
                                    })}
                                    onClick={handleSelect}
                                >
                                    Selecionar {selectedRoleNode.label || selectedRoleNode.name}
                                    {selectedRoleNode.short ? ` (${selectedRoleNode.short})` : ""}
                                </button>
                            </div>
                        )}
                    </motion.div>
                </div>
            )}
        </AnimatePresence>,
        document.body
    );
}

RolePickerModal.propTypes = {
    isOpen: PropTypes.bool.isRequired,
    onClose: PropTypes.func.isRequired,
    onSelect: PropTypes.func.isRequired,
    hideYear: PropTypes.bool,
};