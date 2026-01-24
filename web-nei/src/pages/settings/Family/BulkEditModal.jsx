/**
 * BulkEditModal - Modal for editing multiple members at once
 * 
 * Simplified design - focuses on bulk actions without individual view
 * Actions: Add Insignia, Remove Insignia, Set Course, Set Year
 */

import React, { useState, useEffect } from "react";
import PropTypes from "prop-types";
import classNames from "classnames";

import MaterialSymbol from "components/MaterialSymbol";
import { RolePickerModal } from "components/Family";
import FamilyService from "services/FamilyService";
import { formatYear } from "pages/Family/utils";
import { getErrorMessage } from "utils/error";
import { BaseModal, useBodyScrollLock, ProgressBar } from "components/Modal";
import { UserListDisplay } from "components/Family";

const BulkEditModal = ({
    isOpen,
    onClose,
    selectedUsers = [],
    onComplete
}) => {
    // Bulk action state
    const [action, setAction] = useState("add_role");
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);
    const [success, setSuccess] = useState(null);
    const [progress, setProgress] = useState(null);

    // Role picker
    const [showRolePicker, setShowRolePicker] = useState(false);
    const [selectedRole, setSelectedRole] = useState(null);
    const [roleYear, setRoleYear] = useState(new Date().getFullYear() - 2000);

    // Course picker
    const [courses, setCourses] = useState([]);
    const [selectedCourse, setSelectedCourse] = useState("");

    // Year edit
    const [newYear, setNewYear] = useState(new Date().getFullYear() - 2000);

    // Load courses
    useEffect(() => {
        if (isOpen) {
            FamilyService.getCourses({ limit: 100 })
                .then(res => setCourses(res.items || []))
                .catch(console.error);
        }
    }, [isOpen]);

    // Reset state when opening
    useEffect(() => {
        if (isOpen) {
            setAction("add_role");
            setSelectedRole(null);
            setSelectedCourse("");
            setNewYear(new Date().getFullYear() - 2000);
            setError(null);
            setSuccess(null);
            setProgress(null);
        }
    }, [isOpen]);

    // Lock body scroll when modal is open
    useBodyScrollLock(isOpen);


    // Helper: Execute the selected action for a single user
    const executeActionForUser = async (user) => {
        if (action === "add_role" && selectedRole) {
            await FamilyService.assignRole({
                user_id: user.id,
                role_id: selectedRole.id,
                year: roleYear
            });
            return true;
        }
        if (action === "set_course" && selectedCourse) {
            await FamilyService.updateUser(user.id, {
                ...user,
                course_id: parseInt(selectedCourse)
            });
            return true;
        }
        if (action === "set_year") {
            await FamilyService.updateUser(user.id, {
                ...user,
                start_year: newYear
            });
            return true;
        }
        return false;
    };

    // Helper: Process and display results 
    const processResults = (successCount, errorCount, errorMessages) => {
        if (errorCount === 0) {
            setSuccess(`${successCount} membro(s) atualizados com sucesso!`);
            setTimeout(() => {
                onComplete?.();
                onClose();
            }, 1500);
        } else if (successCount > 0) {
            setSuccess(`${successCount} atualizados, ${errorCount} com erro.`);
            if (errorMessages.length > 0) {
                setError(errorMessages.slice(0, 3).join("; "));
            }
        } else {
            setError(errorMessages.slice(0, 3).join("; ") || "Erro ao aplicar alterações");
        }
    };

    const handleApply = async () => {
        if (selectedUsers.length === 0) return;

        setLoading(true);
        setError(null);
        setSuccess(null);
        setProgress({ current: 0, total: selectedUsers.length });

        try {
            let successCount = 0;
            let errorCount = 0;
            let errorMessages = [];

            for (let i = 0; i < selectedUsers.length; i++) {
                const user = selectedUsers[i];
                setProgress({ current: i + 1, total: selectedUsers.length });

                try {
                    const executed = await executeActionForUser(user);
                    if (executed) successCount++;
                } catch (err) {
                    console.error(`Failed action for ${user.name}:`, err);
                    errorCount++;
                    const msg = getErrorMessage(err, "Erro desconhecido");
                    if (!errorMessages.includes(msg)) {
                        errorMessages.push(msg);
                    }
                }
            }

            processResults(successCount, errorCount, errorMessages);
        } catch (err) {
            setError(getErrorMessage(err, "Erro ao aplicar alterações"));
        } finally {
            setLoading(false);
            setProgress(null);
        }
    };

    const canApply = () => {
        if (selectedUsers.length === 0) return false;
        if (action === "add_role" && !selectedRole) return false;
        if (action === "set_course" && !selectedCourse) return false;
        return true;
    };

    // Action descriptions
    const actionDescriptions = {
        add_role: "Adicionar uma insígnia a todos os membros selecionados.",
        set_course: "Definir o mesmo curso para todos os membros selecionados.",
        set_year: "Alterar o ano de entrada de todos os membros selecionados."
    };

    return (
        <>
            <BaseModal
                isOpen={isOpen}
                onClose={onClose}
                title="Edição em Massa"
                subtitle={`${selectedUsers.length} membro(s) selecionado(s)`}
                icon="edit_note"
                maxWidth="xl"
                zIndex={50}
                loading={loading}
                footer={
                    <div className="flex justify-end gap-3 w-full">
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
                            className={classNames("btn btn-primary gap-2", { loading })}
                            onClick={handleApply}
                            disabled={!canApply() || loading}
                        >
                            {loading ? (
                                <>A aplicar...</>
                            ) : (
                                <>
                                    <MaterialSymbol icon="check" size={18} />
                                    Aplicar a {selectedUsers.length} membro(s)
                                </>
                            )}
                        </button>
                    </div>
                }
            >
                <div className="space-y-6">
                    {/* Selected users preview */}
                    <UserListDisplay
                        users={selectedUsers}
                        maxDisplay={20}
                        variant="default"
                        emptyMessage="Nenhum membro selecionado"
                    />

                    {/* Action selector */}
                    <div>
                                    <div className="label">
                                        <span className="label-text font-semibold">Ação a executar</span>
                                    </div>
                                    <div className="grid grid-cols-3 gap-2">
                                        {[
                                            { value: "add_role", icon: "badge", label: "Adicionar Insígnia" },
                                            { value: "set_course", icon: "school", label: "Definir Curso" },
                                            { value: "set_year", icon: "calendar_today", label: "Alterar Ano" },
                                        ].map(opt => (
                                            <button
                                                key={opt.value}
                                                type="button"
                                                className={classNames(
                                                    "btn btn-outline h-auto py-3 flex-col gap-1",
                                                    action === opt.value && "btn-primary"
                                                )}
                                                onClick={() => setAction(opt.value)}
                                            >
                                                <MaterialSymbol icon={opt.icon} size={24} />
                                                <span className="text-xs">{opt.label}</span>
                                            </button>
                                        ))}
                                    </div>
                                    <p className="text-xs text-base-content/50 mt-2">
                                        {actionDescriptions[action]}
                                    </p>
                                </div>

                    {/* Action-specific fields */}
                    {action === "add_role" && (
                                    <div className="space-y-4 bg-base-200/30 rounded-xl p-4">
                                        <div>
                                            <label className="label" htmlFor="insignia-select">
                                                <span className="label-text">Insígnia</span>
                                            </label>
                                            <button
                                                id="insignia-select"
                                                type="button"
                                                className={classNames(
                                                    "btn w-full justify-between",
                                                    selectedRole ? "btn-primary btn-outline" : "btn-outline"
                                                )}
                                                onClick={() => setShowRolePicker(true)}
                                            >
                                                <span className="flex items-center gap-2">
                                                    {selectedRole ? (
                                                        <>
                                                            <MaterialSymbol icon="check_circle" size={18} />
                                                            {selectedRole.name}
                                                        </>
                                                    ) : (
                                                        "Selecionar insígnia..."
                                                    )}
                                                </span>
                                                <MaterialSymbol icon="chevron_right" size={20} />
                                            </button>
                                        </div>
                                        <div>
                                            <label className="label" htmlFor="role-year-input">
                                                <span className="label-text">Ano do mandato</span>
                                            </label>
                                            <div className="flex gap-2 items-center">
                                                <input
                                                    id="role-year-input"
                                                    type="number"
                                                    className="input input-bordered w-24"
                                                    value={roleYear}
                                                    onChange={(e) => setRoleYear(parseInt(e.target.value) || 0)}
                                                    min={0}
                                                    max={99}
                                                />
                                                <span className="text-sm text-base-content/60">
                                                    = {formatYear(roleYear)} ({formatYear(roleYear, 'academic')})
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                )}

                    {action === "set_course" && (
                                    <div className="bg-base-200/30 rounded-xl p-4">
                                        <label className="label" htmlFor="course-select">
                                            <span className="label-text">Curso</span>
                                        </label>
                                        <select
                                            id="course-select"
                                            className="select select-bordered w-full"
                                            value={selectedCourse}
                                            onChange={(e) => setSelectedCourse(e.target.value)}
                                        >
                                            <option value="">Selecionar curso...</option>
                                            {courses.map(course => (
                                                <option key={course.id} value={course.id}>
                                                    {course.short} - {course.name}
                                                </option>
                                            ))}
                                        </select>
                                    </div>
                                )}

                    {action === "set_year" && (
                                    <div className="bg-base-200/30 rounded-xl p-4">
                                        <label className="label" htmlFor="new-year-input">
                                            <span className="label-text">Novo ano de entrada</span>
                                        </label>
                                        <div className="flex gap-2 items-center">
                                            <input
                                                id="new-year-input"
                                                type="number"
                                                className="input input-bordered w-24"
                                                value={newYear}
                                                onChange={(e) => setNewYear(parseInt(e.target.value) || 0)}
                                                min={0}
                                                max={99}
                                            />
                                            <span className="text-sm text-base-content/60">
                                                = {formatYear(newYear)} ({formatYear(newYear, 'academic')})
                                            </span>
                                        </div>
                                        <p className="text-xs text-warning mt-2">
                                            <MaterialSymbol icon="warning" size={14} className="inline mr-1" />
                                            Isto irá alterar a cor do membro na árvore.
                                        </p>
                                    </div>
                                )}

                    {/* Progress bar */}
                    {progress && (
                        <ProgressBar
                            current={progress.current}
                            total={progress.total}
                            label="A processar..."
                            variant="primary"
                        />
                    )}

                    {/* Feedback */}
                    {error && (
                        <div className="alert alert-error text-sm">
                            <MaterialSymbol icon="error" size={20} />
                            <span>{error}</span>
                        </div>
                    )}
                    {success && (
                        <div className="alert alert-success text-sm">
                            <MaterialSymbol icon="check_circle" size={20} />
                            <span>{success}</span>
                        </div>
                    )}
                </div>
            </BaseModal>

            {/* Role Picker */}
            <RolePickerModal
                isOpen={showRolePicker}
                onClose={() => setShowRolePicker(false)}
                hideYear={true}
                onSelect={(node) => {
                    setSelectedRole(node);
                    setShowRolePicker(false);
                }}
            />
        </>
    );
};

BulkEditModal.propTypes = {
    isOpen: PropTypes.bool.isRequired,
    onClose: PropTypes.func.isRequired,
    selectedUsers: PropTypes.array,
    onComplete: PropTypes.func.isRequired,
};

export default BulkEditModal;
