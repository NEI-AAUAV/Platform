/**
 * BulkDeleteModal - Confirmation modal for deleting multiple members
 * 
 * Shows list of members to be deleted with proper confirmation.
 */

import React, { useState } from "react";
import PropTypes from "prop-types";
import classNames from "classnames";

import MaterialSymbol from "components/MaterialSymbol";
import FamilyService from "services/FamilyService";
import { getErrorMessage } from "utils/error";
import { BaseModal, ProgressBar } from "components/Modal";
import { UserListDisplay } from "components/Family";
import { useToast } from "components/ui/use-toast";

const BulkDeleteModal = ({
    isOpen,
    onClose,
    selectedUsers = [],
    onComplete
}) => {
    const { toast } = useToast();
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
                const children = await FamilyService.getUserChildren(user.id);
                if (children && children.length > 0) {
                    warnings.push({
                        user,
                        childrenCount: children.length,
                        childrenNames: children.slice(0, 3).map(c => c.name)
                    });
                }
            } catch (err) {
                // Ignore errors in check (orphan detection is best-effort)
                console.debug("Failed to check orphans for user " + user.id, err);
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
                await FamilyService.deleteUser(user.id);
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
                toast({
                    title: "Eliminação em massa concluída",
                    description: `${selectedUsers.length} membro(s) eliminados.`,
                });
            }, 500);
        } else {
            toast({
                title: "Alguns membros não foram eliminados",
                description: `${newErrors.length} membro(s) falharam na eliminação.`,
                variant: "destructive",
            });
        }
    };

    return (
        <BaseModal
            isOpen={isOpen}
            onClose={onClose}
            title="Eliminar Membros"
            subtitle="Esta ação é irreversível"
            icon="delete_forever"
            iconClassName="text-error"
            variant="error"
            maxWidth="max-w-lg"
            disableBackdropClick={loading}
            footer={
                <>
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
                </>
            }
        >
            <div className="space-y-4">
                {/* Members list */}
                <div>
                    <label className="label">
                        <span className="label-text font-bold text-error">
                            {selectedUsers.length} membro(s) serão eliminados:
                        </span>
                    </label>
                    <UserListDisplay users={selectedUsers} />
                </div>

                {/* Orphan warnings */}
                {orphanWarnings.length > 0 && (
                    <div className="alert alert-warning text-sm">
                        <MaterialSymbol icon="warning" size={20} />
                        <div>
                            <p className="font-bold">Atenção: Alguns membros têm pedaços!</p>
                            <ul className="mt-1 text-xs opacity-80">
                                {orphanWarnings.map(w => (
                                    <li key={w.user.id}>
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
                    <ProgressBar
                        current={progress.current}
                        total={progress.total}
                        label="A eliminar..."
                        className="[&>div:first-child>div:last-child]:text-error"
                    />
                )}

                {/* Errors */}
                {errors.length > 0 && (
                    <div className="alert alert-error text-sm">
                        <MaterialSymbol icon="error" size={20} />
                        <div>
                            <p className="font-bold">Alguns membros não foram eliminados:</p>
                            <ul className="mt-1 text-xs">
                                {errors.map((e) => (
                                    <li key={e.user.id}>{e.user.name}: {e.error}</li>
                                ))}
                            </ul>
                        </div>
                    </div>
                )}
            </div>
        </BaseModal>
    );
};

BulkDeleteModal.propTypes = {
    isOpen: PropTypes.bool.isRequired,
    onClose: PropTypes.func.isRequired,
    selectedUsers: PropTypes.array,
    onComplete: PropTypes.func,
};

export default BulkDeleteModal;
