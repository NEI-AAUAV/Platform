/**
 * OrphanModal - Warning modal when deleting member with children
 * 
 * Offers options to:
 * - Delete anyway (children become orphans/roots)
 * - Re-parent children to another patrão
 * - Cancel
 */

import React, { useState, useEffect, useCallback } from "react";
import PropTypes from "prop-types";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";

import MaterialSymbol from "components/MaterialSymbol";
import FamilyService from "services/FamilyService";
import { colors } from "pages/Family/data";

import Avatar from "components/Avatar";

const OrphanModal = ({
    isOpen,
    onClose,
    userToDelete,
    orphanChildren = [],
    onConfirmDelete,
    onReparent
}) => {
    const [action, setAction] = useState("delete"); // delete, reparent
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);

    // Patrão picker state
    const [patraoSearch, setPatraoSearch] = useState("");
    const [patraoList, setPatraoList] = useState([]);
    const [patraoLoading, setPatraoLoading] = useState(false);
    const [selectedPatrao, setSelectedPatrao] = useState(null);

    // Reset state when opening
    useEffect(() => {
        if (isOpen) {
            setAction("delete");
            setSelectedPatrao(null);
            setPatraoSearch("");
            setError(null);
        }
    }, [isOpen]);

    // Load patrão candidates
    const loadPatroes = useCallback(async () => {
        setPatraoLoading(true);
        try {
            const params = { limit: 50 };
            if (patraoSearch) params.search = patraoSearch;

            const response = await FamilyService.getUsers(params);

            // Filter out the user being deleted and all orphan children
            const excludeIds = new Set([
                userToDelete?._id,
                ...orphanChildren.map(c => c._id || c.id)
            ]);

            const filtered = (response.items || []).filter(u => !excludeIds.has(u._id));
            setPatraoList(filtered);

        } catch (err) {
            console.error("Failed to load patrões:", err);
        } finally {
            setPatraoLoading(false);
        }
    }, [patraoSearch, userToDelete?._id, orphanChildren]);

    useEffect(() => {
        if (isOpen && action === "reparent") {
            loadPatroes();
        }
    }, [isOpen, action, loadPatroes]);

    const handleConfirm = async () => {
        setLoading(true);
        setError(null);

        try {
            if (action === "delete") {
                await onConfirmDelete?.();
            } else if (action === "reparent" && selectedPatrao) {
                await onReparent?.(selectedPatrao._id);
            }
            onClose();
        } catch (err) {
            setError(err.message || "Erro ao processar");
        } finally {
            setLoading(false);
        }
    };

    const canConfirm = () => {
        if (action === "delete") return true;
        if (action === "reparent") return !!selectedPatrao;
        return false;
    };

    if (!userToDelete) return null;

    return (
        <AnimatePresence>
            {isOpen && (
                <>
                    {/* Backdrop */}
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm"
                        onClick={onClose}
                    />

                    {/* Modal */}
                    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
                        <motion.div
                            initial={{ opacity: 0, scale: 0.95, y: 20 }}
                            animate={{ opacity: 1, scale: 1, y: 0 }}
                            exit={{ opacity: 0, scale: 0.95, y: 20 }}
                            className="w-full max-w-md rounded-2xl border border-base-content/10 bg-base-100 shadow-2xl"
                            onClick={(e) => e.stopPropagation()}
                        >
                            {/* Header */}
                            <div className="flex items-center gap-3 border-b border-base-content/10 p-4 bg-warning/10">
                                <MaterialSymbol icon="warning" size={28} className="text-warning" />
                                <div>
                                    <h3 className="text-lg font-bold">Membro com Pedaços</h3>
                                    <p className="text-sm text-base-content/70">
                                        {orphanChildren.length} pedaço(s) ficarão órfãos
                                    </p>
                                </div>
                            </div>

                            {/* Content */}
                            <div className="p-6 space-y-4">
                                {/* User being deleted */}
                                <div className="flex items-center gap-3 p-3 bg-error/10 rounded-lg">
                                    <div
                                        className="w-10 h-10 rounded-full flex items-center justify-center"
                                        style={{ backgroundColor: colors[userToDelete.start_year % colors.length] }}
                                    >
                                        <Avatar
                                            image={userToDelete.image}
                                            sex={userToDelete.sex}
                                            alt={userToDelete.name || ''}
                                            className="w-10 h-10 rounded-full object-cover"
                                        />
                                    </div>
                                    <div>
                                        <div className="font-bold">{userToDelete.name}</div>
                                        <div className="text-sm text-base-content/60">A eliminar</div>
                                    </div>
                                </div>

                                {/* Orphan children preview */}
                                <div>
                                    <div className="label">
                                        <span className="label-text font-bold">Pedaços afetados:</span>
                                    </div>
                                    <div className="flex flex-wrap gap-2 max-h-24 overflow-y-auto p-2 bg-base-200 rounded-lg">
                                        {orphanChildren.map(child => (
                                            <div
                                                key={child._id || child.id}
                                                className="flex items-center gap-1 px-2 py-1 bg-base-100 rounded-lg text-xs"
                                            >
                                                <div
                                                    className="w-4 h-4 rounded-full"
                                                    style={{ backgroundColor: colors[(child.start_year || 0) % colors.length] }}
                                                />
                                                <span className="truncate max-w-[100px]">{child.name}</span>
                                            </div>
                                        ))}
                                    </div>
                                </div>

                                {/* Action selector */}
                                <div className="space-y-2">
                                    <div className="label">
                                        <span className="label-text font-bold">O que fazer com os pedaços?</span>
                                    </div>

                                    <label className={classNames(
                                        "flex items-center gap-3 p-3 rounded-lg border cursor-pointer transition-colors",
                                        action === "delete"
                                            ? "border-error bg-error/10"
                                            : "border-base-content/20 hover:bg-base-200"
                                    )}>
                                        <input
                                            type="radio"
                                            name="action"
                                            className="radio radio-error"
                                            checked={action === "delete"}
                                            onChange={() => setAction("delete")}
                                            aria-label="Eliminar de qualquer forma"
                                        />
                                        <div>
                                            <div className="font-medium">Eliminar de qualquer forma</div>
                                            <div className="text-xs text-base-content/60">
                                                Os pedaços passam a ser raízes (sem patrão)
                                            </div>
                                        </div>
                                    </label>

                                    <label className={classNames(
                                        "flex items-center gap-3 p-3 rounded-lg border cursor-pointer transition-colors",
                                        action === "reparent"
                                            ? "border-success bg-success/10"
                                            : "border-base-content/20 hover:bg-base-200"
                                    )}>
                                        <input
                                            type="radio"
                                            name="action"
                                            className="radio radio-success"
                                            checked={action === "reparent"}
                                            onChange={() => setAction("reparent")}
                                            aria-label="Transferir para outro patrão"
                                        />
                                        <div>
                                            <div className="font-medium">Transferir para outro patrão</div>
                                            <div className="text-xs text-base-content/60">
                                                Escolher novo patrão para os pedaços
                                            </div>
                                        </div>
                                    </label>
                                </div>

                                {/* Patrão selector (if reparent) */}
                                {action === "reparent" && (
                                    <div className="space-y-2">
                                        <div className="relative">
                                            <MaterialSymbol
                                                icon="search"
                                                size={18}
                                                className="absolute left-3 top-1/2 -translate-y-1/2 text-base-content/50"
                                            />
                                            <input
                                                type="text"
                                                placeholder="Procurar novo patrão..."
                                                className="input input-bordered input-sm w-full pl-9"
                                                value={patraoSearch}
                                                onChange={(e) => setPatraoSearch(e.target.value)}
                                            />
                                        </div>

                                        <div className="max-h-40 overflow-y-auto rounded-lg border border-base-content/10">
                                            {(() => {
                                                if (patraoLoading) {
                                                    return (
                                                        <div className="flex justify-center py-4">
                                                            <span className="loading loading-spinner loading-sm"></span>
                                                        </div>
                                                    );
                                                }
                                                if (patraoList.length === 0) {
                                                    return (
                                                        <div className="py-4 text-center text-sm text-base-content/50">
                                                            Nenhum resultado
                                                        </div>
                                                    );
                                                }
                                                return (
                                                    <>
                                                        {patraoList.map(p => (
                                                            <button
                                                                key={p._id}
                                                                type="button"
                                                                className={classNames(
                                                                    "flex w-full items-center gap-2 px-3 py-2 text-left transition-colors hover:bg-base-200",
                                                                    selectedPatrao?._id === p._id && "bg-success/10"
                                                                )}
                                                                onClick={() => setSelectedPatrao(p)}
                                                                aria-label={`Selecionar ${p.name}`}
                                                            >
                                                                <div
                                                                    className="w-6 h-6 rounded-full"
                                                                    style={{ backgroundColor: colors[(p.start_year || 0) % colors.length] }}
                                                                >
                                                                    <Avatar
                                                                        image={p.image}
                                                                        sex={p.sex}
                                                                        alt={p.name || ''}
                                                                        className="w-6 h-6 rounded-full object-cover"
                                                                    />
                                                                </div>
                                                                <span className="truncate font-medium">{p.name}</span>
                                                                {selectedPatrao?._id === p._id && (
                                                                    <MaterialSymbol icon="check_circle" size={16} className="ml-auto text-success" />
                                                                )}
                                                            </button>
                                                        ))}
                                                    </>
                                                );
                                            })()}
                                        </div>
                                    </div>
                                )}

                                {/* Error */}
                                {error && (
                                    <div className="alert alert-error text-sm">
                                        <MaterialSymbol icon="error" size={20} />
                                        <span>{error}</span>
                                    </div>
                                )}
                            </div>

                            {/* Footer */}
                            <div className="flex justify-end gap-3 border-t border-base-content/10 px-6 py-4">
                                <button
                                    type="button"
                                    className="btn btn-ghost"
                                    onClick={onClose}
                                    disabled={loading}
                                >
                                    Cancelar
                                </button>
                                <button
                                    type="button"
                                    className={classNames(
                                        "btn",
                                        action === "delete" ? "btn-error" : "btn-success",
                                        { loading }
                                    )}
                                    onClick={handleConfirm}
                                    disabled={!canConfirm() || loading}
                                >
                                    {action === "delete" ? "Eliminar" : "Transferir e Eliminar"}
                                </button>
                            </div>
                        </motion.div>
                    </div>
                </>
            )}
        </AnimatePresence>
    );
};

OrphanModal.propTypes = {
    isOpen: PropTypes.bool.isRequired,
    onClose: PropTypes.func.isRequired,
    userToDelete: PropTypes.object,
    orphanChildren: PropTypes.array,
    onConfirmDelete: PropTypes.func,
    onReparent: PropTypes.func,
};

export default OrphanModal;
