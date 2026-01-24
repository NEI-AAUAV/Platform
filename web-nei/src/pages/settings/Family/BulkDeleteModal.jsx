/**
 * BulkDeleteModal - Confirmation modal for deleting multiple members
 * 
 * Shows list of members to be deleted with proper confirmation.
 */

import React, { useState } from "react";
import PropTypes from "prop-types";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";

import MaterialSymbol from "components/MaterialSymbol";
import FamilyService from "services/FamilyService";
import { colors } from "pages/Family/data";
import { getErrorMessage } from "utils/error";

import Avatar from "components/Avatar";

const BulkDeleteModal = ({
    isOpen,
    onClose,
    selectedUsers = [],
    onComplete
}) => {
    const [confirmText, setConfirmText] = useState("");
    const [loading, setLoading] = useState(false);
    const [progress, setProgress] = useState({ current: 0, total: 0 });
    const [errors, setErrors] = useState([]);

    // Check for users with children (potential orphans)
    const [orphanWarnings, setOrphanWarnings] = useState([]);
    const [checkedOrphans, setCheckedOrphans] = useState(false);

    // Check for orphans on open
    React.useEffect(() => {
        if (isOpen && selectedUsers.length > 0 && !checkedOrphans) {
            checkForOrphans();
        }
        if (!isOpen) {
            // Reset state when closing
            setConfirmText("");
            setProgress({ current: 0, total: 0 });
            setErrors([]);
            setOrphanWarnings([]);
            setCheckedOrphans(false);
        }
    }, [isOpen, selectedUsers]);

    const checkForOrphans = async () => {
        const warnings = [];
        for (const user of selectedUsers.slice(0, 10)) { // Check first 10
            try {
                const children = await FamilyService.getUserChildren(user._id);
                if (children && children.length > 0) {
                    warnings.push({
                        user,
                        childrenCount: children.length,
                        childrenNames: children.slice(0, 3).map(c => c.name)
                    });
                }
            } catch (err) {
                // Ignore errors in check (orphan detection is best-effort)
                console.debug("Failed to check orphans for user " + user._id, err);
            }
        }
        setOrphanWarnings(warnings);
        setCheckedOrphans(true);
    };

    const confirmPhrase = "ELIMINAR";
    const canConfirm = confirmText.toUpperCase() === confirmPhrase;

    const handleDelete = async () => {
        if (!canConfirm) return;

        setLoading(true);
        setProgress({ current: 0, total: selectedUsers.length });
        setErrors([]);

        const newErrors = [];

        for (let i = 0; i < selectedUsers.length; i++) {
            const user = selectedUsers[i];
            try {
                await FamilyService.deleteUser(user._id);
                setProgress(prev => ({ ...prev, current: i + 1 }));
            } catch (err) {
                newErrors.push({
                    user,
                    error: getErrorMessage(err, "Erro desconhecido")
                });
            }
        }

        setErrors(newErrors);
        setLoading(false);

        if (newErrors.length === 0) {
            // All succeeded
            setTimeout(() => {
                onComplete?.();
                onClose();
            }, 500);
        }
    };

    const progressPercent = progress.total > 0
        ? Math.round((progress.current / progress.total) * 100)
        : 0;

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
                        onClick={!loading ? onClose : undefined}
                    />

                    {/* Modal */}
                    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
                        <motion.div
                            initial={{ opacity: 0, scale: 0.95, y: 20 }}
                            animate={{ opacity: 1, scale: 1, y: 0 }}
                            exit={{ opacity: 0, scale: 0.95, y: 20 }}
                            className="w-full max-w-lg rounded-2xl border border-error/30 bg-base-100 shadow-2xl"
                            onClick={(e) => e.stopPropagation()}
                        >
                            {/* Header */}
                            <div className="flex items-center gap-3 border-b border-error/20 bg-error/5 p-4 rounded-t-2xl">
                                <div className="flex h-10 w-10 items-center justify-center rounded-full bg-error/20">
                                    <MaterialSymbol icon="delete_forever" size={24} className="text-error" />
                                </div>
                                <div>
                                    <h3 className="text-lg font-bold text-error">Eliminar Membros</h3>
                                    <p className="text-sm text-base-content/60">
                                        Esta ação é irreversível
                                    </p>
                                </div>
                                {!loading && (
                                    <button
                                        type="button"
                                        className="btn btn-ghost btn-sm btn-circle ml-auto"
                                        onClick={onClose}
                                    >
                                        <MaterialSymbol icon="close" size={20} />
                                    </button>
                                )}
                            </div>

                            {/* Content */}
                            <div className="p-6 space-y-4">
                                {/* Members list */}
                                <div>
                                    <label className="label">
                                        <span className="label-text font-bold text-error">
                                            {selectedUsers.length} membro(s) serão eliminados:
                                        </span>
                                    </label>
                                    <div className="max-h-40 overflow-y-auto rounded-lg border border-base-content/10 bg-base-200/50 p-2">
                                        <div className="flex flex-wrap gap-2">
                                            {selectedUsers.map(user => (
                                                <div
                                                    key={user._id}
                                                    className="flex items-center gap-2 px-2 py-1 bg-base-100 rounded-lg text-sm border border-base-content/10"
                                                >
                                                    <Avatar
                                                        image={user.image}
                                                        sex={user.sex}
                                                        alt={user.name || ''}
                                                        className="w-5 h-5 rounded-full object-cover"
                                                    />
                                                    <span className="truncate max-w-[120px]">{user.name}</span>
                                                    <div
                                                        className="w-3 h-3 rounded-full flex-shrink-0"
                                                        style={{ backgroundColor: colors[user.start_year % colors.length] }}
                                                        title={`Ano ${user.start_year}`}
                                                    />
                                                </div>
                                            ))}
                                        </div>
                                    </div>
                                </div>

                                {/* Orphan warnings */}
                                {orphanWarnings.length > 0 && (
                                    <div className="alert alert-warning text-sm">
                                        <MaterialSymbol icon="warning" size={20} />
                                        <div>
                                            <p className="font-bold">Atenção: Alguns membros têm pedaços!</p>
                                            <ul className="mt-1 text-xs opacity-80">
                                                {orphanWarnings.map(w => (
                                                    <li key={w.user._id}>
                                                        {w.user.name}: {w.childrenCount} pedaço(s)
                                                        ({w.childrenNames.join(", ")}{w.childrenCount > 3 ? "..." : ""})
                                                    </li>
                                                ))}
                                            </ul>
                                            <p className="mt-1 text-xs">
                                                Os pedaços ficarão órfãos (sem patrão).
                                            </p>
                                        </div>
                                    </div>
                                )}

                                {/* Confirmation input */}
                                {!loading && errors.length === 0 && (
                                    <div>
                                        <label className="label" htmlFor="confirm-delete-input">
                                            <span className="label-text">
                                                Escreva <strong className="text-error">{confirmPhrase}</strong> para confirmar:
                                            </span>
                                        </label>
                                        <input
                                            id="confirm-delete-input"
                                            type="text"
                                            className={classNames(
                                                "input input-bordered w-full",
                                                canConfirm && "input-error"
                                            )}
                                            value={confirmText}
                                            onChange={(e) => setConfirmText(e.target.value)}
                                            placeholder={confirmPhrase}
                                            autoFocus
                                        />
                                    </div>
                                )}

                                {/* Progress */}
                                {loading && (
                                    <div className="space-y-2">
                                        <div className="flex items-center justify-between text-sm">
                                            <span>A eliminar...</span>
                                            <span>{progress.current} / {progress.total}</span>
                                        </div>
                                        <progress
                                            className="progress progress-error w-full"
                                            value={progressPercent}
                                            max="100"
                                        />
                                    </div>
                                )}

                                {/* Errors */}
                                {errors.length > 0 && (
                                    <div className="alert alert-error text-sm">
                                        <MaterialSymbol icon="error" size={20} />
                                        <div>
                                            <p className="font-bold">Alguns membros não foram eliminados:</p>
                                            <ul className="mt-1 text-xs">
                                                {errors.map((e) => (
                                                    <li key={e.user._id}>{e.user.name}: {e.error}</li>
                                                ))}
                                            </ul>
                                        </div>
                                    </div>
                                )}
                            </div>

                            {/* Footer */}
                            <div className="flex justify-end gap-3 border-t border-base-content/10 px-6 py-4">
                                {!loading && (
                                    <>
                                        <button
                                            type="button"
                                            className="btn btn-ghost"
                                            onClick={onClose}
                                        >
                                            Cancelar
                                        </button>
                                        <button
                                            type="button"
                                            className={classNames("btn btn-error", { "btn-disabled": !canConfirm })}
                                            onClick={handleDelete}
                                            disabled={!canConfirm}
                                        >
                                            <MaterialSymbol icon="delete_forever" size={18} />
                                            Eliminar {selectedUsers.length} membro(s)
                                        </button>
                                    </>
                                )}
                                {errors.length > 0 && !loading && (
                                    <button
                                        type="button"
                                        className="btn btn-primary"
                                        onClick={() => {
                                            onComplete?.();
                                            onClose();
                                        }}
                                    >
                                        Concluir
                                    </button>
                                )}
                            </div>
                        </motion.div>
                    </div>
                </>
            )}
        </AnimatePresence>
    );
};

BulkDeleteModal.propTypes = {
    isOpen: PropTypes.bool.isRequired,
    onClose: PropTypes.func.isRequired,
    selectedUsers: PropTypes.array,
    onComplete: PropTypes.func,
};

export default BulkDeleteModal;
