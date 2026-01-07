/**
 * BulkEditModal - Modal for editing multiple members at once
 * 
 * Features:
 * - Bulk Actions: Add Insignia, Set Course
 * - Individual View: Browse members with Next/Previous navigation
 */

import React, { useState, useEffect, useMemo } from "react";
import PropTypes from "prop-types";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";

import MaterialSymbol from "components/MaterialSymbol";
import RolePickerModal from "components/RolePickerModal";
import FamilyService from "services/FamilyService";
import { colors, organizations } from "pages/Family/data";
import { formatYear } from "pages/Family/utils";

import malePic from "assets/default_profile/male.svg";
import femalePic from "assets/default_profile/female.svg";

const BulkEditModal = ({
    isOpen,
    onClose,
    selectedUsers = [],
    onComplete,
    allUsers = [] // For patrão lookup
}) => {
    // View mode: "bulk" or "individual"
    const [viewMode, setViewMode] = useState("bulk");
    const [currentIndex, setCurrentIndex] = useState(0);

    // Bulk action state
    const [action, setAction] = useState("add_role");
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);
    const [success, setSuccess] = useState(null);

    // Role picker
    const [showRolePicker, setShowRolePicker] = useState(false);
    const [selectedRole, setSelectedRole] = useState(null);
    const [roleYear, setRoleYear] = useState(new Date().getFullYear() - 2000);

    // Course picker
    const [courses, setCourses] = useState([]);
    const [selectedCourse, setSelectedCourse] = useState("");

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
            setViewMode("bulk");
            setCurrentIndex(0);
            setAction("add_role");
            setSelectedRole(null);
            setSelectedCourse("");
            setError(null);
            setSuccess(null);
        }
    }, [isOpen]);

    // Current user in individual view
    const currentUser = useMemo(() => {
        if (selectedUsers.length === 0) return null;
        return selectedUsers[currentIndex] || selectedUsers[0];
    }, [selectedUsers, currentIndex]);

    // Navigation
    const goToNext = () => {
        if (currentIndex < selectedUsers.length - 1) {
            setCurrentIndex(currentIndex + 1);
        }
    };

    const goToPrevious = () => {
        if (currentIndex > 0) {
            setCurrentIndex(currentIndex - 1);
        }
    };

    // Get patrão info
    const getPatrao = (user) => {
        if (!user?.patrao_id) return null;
        return allUsers.find(u => u._id === user.patrao_id);
    };

    const handleApply = async () => {
        if (selectedUsers.length === 0) return;

        setLoading(true);
        setError(null);
        setSuccess(null);

        try {
            let successCount = 0;
            let errorCount = 0;

            if (action === "add_role" && selectedRole) {
                for (const user of selectedUsers) {
                    try {
                        await FamilyService.assignRole({
                            user_id: user._id,
                            role_id: selectedRole._id,
                            year: roleYear
                        });
                        successCount++;
                    } catch (err) {
                        console.error(`Failed to add role to ${user.name}:`, err);
                        errorCount++;
                    }
                }
            } else if (action === "set_course" && selectedCourse) {
                for (const user of selectedUsers) {
                    try {
                        await FamilyService.updateUser(user._id, {
                            ...user,
                            course_id: parseInt(selectedCourse)
                        });
                        successCount++;
                    } catch (err) {
                        console.error(`Failed to set course for ${user.name}:`, err);
                        errorCount++;
                    }
                }
            }

            if (errorCount === 0) {
                setSuccess(`Atualizado ${successCount} membro(s) com sucesso!`);
                setTimeout(() => {
                    onComplete?.();
                    onClose();
                }, 1500);
            } else {
                setError(`${successCount} atualizados, ${errorCount} com erro.`);
            }

        } catch (err) {
            setError(err.message || "Erro ao aplicar alterações");
        } finally {
            setLoading(false);
        }
    };

    const canApply = () => {
        if (selectedUsers.length === 0) return false;
        if (action === "add_role" && !selectedRole) return false;
        if (action === "set_course" && !selectedCourse) return false;
        return true;
    };

    // Render individual user view
    const renderIndividualView = () => {
        if (!currentUser) return null;

        const patrao = getPatrao(currentUser);
        const userRoles = currentUser.user_roles || [];

        return (
            <div className="space-y-4">
                {/* Navigation Header */}
                <div className="flex items-center justify-between bg-base-200/50 rounded-lg p-3">
                    <button
                        type="button"
                        className="btn btn-sm btn-ghost"
                        onClick={goToPrevious}
                        disabled={currentIndex === 0}
                    >
                        <MaterialSymbol icon="chevron_left" size={20} />
                        Anterior
                    </button>
                    <span className="font-medium">
                        {currentIndex + 1} de {selectedUsers.length}
                    </span>
                    <button
                        type="button"
                        className="btn btn-sm btn-ghost"
                        onClick={goToNext}
                        disabled={currentIndex >= selectedUsers.length - 1}
                    >
                        Seguinte
                        <MaterialSymbol icon="chevron_right" size={20} />
                    </button>
                </div>

                {/* User Card */}
                <div className="bg-base-200/30 rounded-xl p-4 space-y-4">
                    {/* Header with photo */}
                    <div className="flex items-center gap-4">
                        <div
                            className="avatar placeholder h-16 w-16 rounded-full ring ring-offset-2"
                            style={{
                                ringColor: colors[currentUser.start_year % colors.length],
                                backgroundColor: colors[currentUser.start_year % colors.length] + '20'
                            }}
                        >
                            <img
                                src={currentUser.image || (currentUser.sex === 'F' ? femalePic : malePic)}
                                alt=""
                                className="rounded-full object-cover"
                            />
                        </div>
                        <div className="flex-1">
                            <h3 className="text-lg font-bold">{currentUser.name}</h3>
                            <p className="text-sm text-base-content/60 font-mono">
                                ID: {currentUser._id}
                            </p>
                        </div>
                    </div>

                    {/* User Details Grid */}
                    <div className="grid grid-cols-2 gap-4 text-sm">
                        <div>
                            <span className="text-base-content/50">Ano de Entrada</span>
                            <p className="font-medium">
                                {formatYear(currentUser.start_year)} ({formatYear(currentUser.start_year, 'academic')})
                            </p>
                        </div>
                        <div>
                            <span className="text-base-content/50">Curso</span>
                            <p className="font-medium">
                                {currentUser.course?.short || currentUser.course?.name || "-"}
                            </p>
                        </div>
                        <div>
                            <span className="text-base-content/50">Patrão</span>
                            <p className="font-medium">
                                {patrao ? patrao.name : currentUser.patrao_id ? `(ID: ${currentUser.patrao_id})` : "Raiz"}
                            </p>
                        </div>
                        <div>
                            <span className="text-base-content/50">Sexo</span>
                            <p className="font-medium">
                                {currentUser.sex === 'F' ? 'Feminino' : currentUser.sex === 'M' ? 'Masculino' : '-'}
                            </p>
                        </div>
                    </div>

                    {/* Insignias */}
                    <div>
                        <span className="text-sm text-base-content/50">Insígnias</span>
                        <div className="flex flex-wrap gap-2 mt-2">
                            {userRoles.length === 0 && (
                                <span className="text-sm text-base-content/30">Nenhuma insígnia</span>
                            )}
                            {userRoles.filter(r => !r.hidden).map((role, idx) => {
                                let logo = role.icon;
                                if (!logo && role.org_name && organizations[role.org_name]) {
                                    logo = organizations[role.org_name].insignia;
                                }
                                const title = role.role_name || role.org_name || "Cargo";

                                return (
                                    <div
                                        key={`${role.role_id}_${idx}`}
                                        className="tooltip tooltip-top flex items-center gap-1 px-2 py-1 bg-base-100 rounded-lg text-xs border border-base-content/10"
                                        data-tip={`${title} (${formatYear(role.year, role.year_display_format)})`}
                                    >
                                        {logo ? (
                                            <img src={logo} alt="" className="h-4 w-4 object-contain" />
                                        ) : (
                                            <MaterialSymbol icon="badge" size={14} className="text-base-content/50" />
                                        )}
                                        <span>{title}</span>
                                    </div>
                                );
                            })}
                        </div>
                    </div>
                </div>
            </div>
        );
    };

    // Render bulk actions view
    const renderBulkView = () => (
        <div className="space-y-6">
            {/* Selected users preview */}
            <div>
                <label className="label">
                    <span className="label-text font-bold">
                        {selectedUsers.length} membro(s) selecionado(s)
                    </span>
                </label>
                <div className="flex flex-wrap gap-2 max-h-24 overflow-y-auto p-2 bg-base-200 rounded-lg">
                    {selectedUsers.slice(0, 10).map(user => (
                        <div
                            key={user._id}
                            className="flex items-center gap-1 px-2 py-1 bg-base-100 rounded-lg text-xs"
                        >
                            <div
                                className="w-4 h-4 rounded-full"
                                style={{ backgroundColor: colors[user.start_year % colors.length] }}
                            />
                            <span className="truncate max-w-[100px]">{user.name}</span>
                        </div>
                    ))}
                    {selectedUsers.length > 10 && (
                        <span className="text-xs text-base-content/50">
                            +{selectedUsers.length - 10} mais...
                        </span>
                    )}
                </div>
            </div>

            {/* Action selector */}
            <div>
                <label className="label">
                    <span className="label-text font-bold">Ação</span>
                </label>
                <select
                    className="select select-bordered w-full"
                    value={action}
                    onChange={(e) => setAction(e.target.value)}
                >
                    <option value="add_role">Adicionar Insígnia</option>
                    <option value="set_course">Definir Curso</option>
                </select>
            </div>

            {/* Action-specific fields */}
            {action === "add_role" && (
                <div className="space-y-4">
                    <div>
                        <label className="label">
                            <span className="label-text">Insígnia</span>
                        </label>
                        <button
                            type="button"
                            className="btn btn-outline w-full justify-between"
                            onClick={() => setShowRolePicker(true)}
                        >
                            {selectedRole ? selectedRole.name : "Selecionar insígnia..."}
                            <MaterialSymbol icon="chevron_right" size={20} />
                        </button>
                    </div>
                    <div>
                        <label className="label">
                            <span className="label-text">Ano (Civil)</span>
                        </label>
                        <input
                            type="number"
                            className="input input-bordered w-full"
                            value={roleYear}
                            onChange={(e) => setRoleYear(parseInt(e.target.value) || 0)}
                            min={0}
                            max={99}
                        />
                    </div>
                </div>
            )}

            {action === "set_course" && (
                <div>
                    <label className="label">
                        <span className="label-text">Curso</span>
                    </label>
                    <select
                        className="select select-bordered w-full"
                        value={selectedCourse}
                        onChange={(e) => setSelectedCourse(e.target.value)}
                    >
                        <option value="">Selecionar curso...</option>
                        {courses.map(course => (
                            <option key={course._id} value={course._id}>
                                {course.short} - {course.name}
                            </option>
                        ))}
                    </select>
                </div>
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
    );

    return (
        <AnimatePresence>
            {isOpen && (
                <>
                    {/* Backdrop */}
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        className="fixed inset-0 z-40 bg-black/60 backdrop-blur-sm"
                        onClick={onClose}
                    />

                    {/* Modal */}
                    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
                        <motion.div
                            initial={{ opacity: 0, scale: 0.95, y: 20 }}
                            animate={{ opacity: 1, scale: 1, y: 0 }}
                            exit={{ opacity: 0, scale: 0.95, y: 20 }}
                            className="w-full max-w-lg rounded-2xl border border-base-content/10 bg-base-100 shadow-2xl"
                            onClick={(e) => e.stopPropagation()}
                        >
                            {/* Header */}
                            <div className="flex items-center justify-between border-b border-base-content/10 p-4">
                                <h3 className="text-lg font-bold flex items-center gap-2">
                                    <MaterialSymbol icon="edit_note" size={24} className="text-primary" />
                                    Edição em Massa
                                </h3>
                                <button
                                    type="button"
                                    className="btn btn-ghost btn-sm btn-circle"
                                    onClick={onClose}
                                >
                                    <MaterialSymbol icon="close" size={20} />
                                </button>
                            </div>

                            {/* View Mode Toggle */}
                            <div className="px-6 pt-4">
                                <div className="tabs tabs-boxed bg-base-200/50">
                                    <button
                                        type="button"
                                        className={classNames("tab flex-1", viewMode === "bulk" && "tab-active")}
                                        onClick={() => setViewMode("bulk")}
                                    >
                                        <MaterialSymbol icon="edit" size={16} className="mr-1" />
                                        Ações em Massa
                                    </button>
                                    <button
                                        type="button"
                                        className={classNames("tab flex-1", viewMode === "individual" && "tab-active")}
                                        onClick={() => setViewMode("individual")}
                                    >
                                        <MaterialSymbol icon="person" size={16} className="mr-1" />
                                        Ver Individualmente
                                    </button>
                                </div>
                            </div>

                            {/* Content */}
                            <div className="p-6 max-h-[60vh] overflow-y-auto">
                                {viewMode === "bulk" ? renderBulkView() : renderIndividualView()}
                            </div>

                            {/* Footer */}
                            {viewMode === "bulk" && (
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
                                        className={classNames("btn btn-primary", { loading })}
                                        onClick={handleApply}
                                        disabled={!canApply() || loading}
                                    >
                                        Aplicar a {selectedUsers.length} membro(s)
                                    </button>
                                </div>
                            )}

                            {viewMode === "individual" && (
                                <div className="flex justify-between gap-3 border-t border-base-content/10 px-6 py-4">
                                    <button
                                        type="button"
                                        className="btn btn-ghost"
                                        onClick={() => setViewMode("bulk")}
                                    >
                                        <MaterialSymbol icon="arrow_back" size={18} />
                                        Voltar às Ações
                                    </button>
                                    <button
                                        type="button"
                                        className="btn btn-ghost"
                                        onClick={onClose}
                                    >
                                        Fechar
                                    </button>
                                </div>
                            )}
                        </motion.div>
                    </div>

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
            )}
        </AnimatePresence>
    );
};

BulkEditModal.propTypes = {
    isOpen: PropTypes.bool.isRequired,
    onClose: PropTypes.func.isRequired,
    selectedUsers: PropTypes.array,
    onComplete: PropTypes.func,
    allUsers: PropTypes.array,
};

export default BulkEditModal;
