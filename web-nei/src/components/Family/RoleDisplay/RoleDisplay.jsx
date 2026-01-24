/**
 * RoleDisplay - Component for displaying and managing user roles/insignias
 */

import React from "react";
import PropTypes from "prop-types";
import MaterialSymbol from "components/MaterialSymbol";
import { organizations } from "pages/Family/data";

const RoleDisplay = ({
    roles = [],
    loading = false,
    onAdd,
    onRemove,
    addButtonLabel = "Adicionar",
    emptyMessage = "Nenhuma insígnia atribuída",
    showAddButton = true
}) => {
    return (
        <div>
            <div className="mb-3 flex items-center justify-between border-t border-base-content/10 pt-4">
                <h4 className="font-bold">Insígnias</h4>
                {showAddButton && onAdd && (
                    <button
                        type="button"
                        className="btn btn-primary btn-xs gap-1"
                        onClick={onAdd}
                    >
                        <MaterialSymbol icon="add" size={16} />
                        {addButtonLabel}
                    </button>
                )}
            </div>

            <div className="min-h-[60px] rounded-xl border border-dashed border-base-content/20 bg-base-200/50 p-4">
                {loading ? (
                    <div className="flex justify-center py-2">
                        <span className="loading loading-spinner loading-sm"></span>
                    </div>
                ) : roles.length === 0 ? (
                    <p className="text-center text-sm text-base-content/50">
                        {emptyMessage}
                    </p>
                ) : (
                    <div className="flex flex-wrap gap-3">
                        {roles.map((role) => (
                            <div
                                key={role.id || role.tempId}
                                className="flex items-center gap-2 rounded-lg bg-base-100 p-2 shadow-sm ring-1 ring-base-content/10"
                            >
                                {/* Try to show icon if available - check API icon first, then static map */}
                                {(role.icon || (role.org_name && organizations[role.org_name])) && (
                                    <img
                                        src={role.icon || organizations[role.org_name]?.insignia}
                                        alt=""
                                        className="h-6 w-6 object-contain"
                                    />
                                )}
                                <div className="flex flex-col">
                                    <span className="text-xs font-bold leading-tight">
                                        {role.role_name || role.name || role.org_name || role.role_id}
                                        {role.parent_org_name && role.parent_org_name !== role.org_name && (
                                            <span className="font-normal text-base-content/50">
                                                {" "}({role.parent_org_name})
                                            </span>
                                        )}
                                    </span>
                                    <span className="text-[10px] text-base-content/60">Ano {role.year}</span>
                                </div>
                                {onRemove && (
                                    <button
                                        type="button"
                                        className="ml-1 rounded-full p-1 text-base-content/40 hover:bg-error/10 hover:text-error"
                                        onClick={() => onRemove(role.id || role.tempId)}
                                    >
                                        <MaterialSymbol icon="close" size={14} />
                                    </button>
                                )}
                            </div>
                        ))}
                    </div>
                )}
            </div>
        </div>
    );
};

RoleDisplay.propTypes = {
    roles: PropTypes.arrayOf(PropTypes.shape({
        id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
        tempId: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
        role_id: PropTypes.string,
        role_name: PropTypes.string,
        name: PropTypes.string,
        org_name: PropTypes.string,
        parent_org_name: PropTypes.string,
        year: PropTypes.number,
        icon: PropTypes.string,
    })),
    loading: PropTypes.bool,
    onAdd: PropTypes.func,
    onRemove: PropTypes.func,
    addButtonLabel: PropTypes.string,
    emptyMessage: PropTypes.string,
    showAddButton: PropTypes.bool,
};

export default RoleDisplay;

