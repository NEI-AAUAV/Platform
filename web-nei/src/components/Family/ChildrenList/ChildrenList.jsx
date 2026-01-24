/**
 * ChildrenList - Component for displaying a user's node children (pedaços)
 */

import React from "react";
import PropTypes from "prop-types";
import MaterialSymbol from "components/MaterialSymbol";
import Avatar from "components/Avatar";

const ChildrenList = ({
    children = [],
    onAddChild,
    onSelectChild,
    addButtonLabel = "Adicionar",
    emptyMessage = "Não tem pedaços registados"
}) => {
    return (
        <div className="mt-4 border-t border-base-content/10 pt-4">
            <div className="mb-3 flex items-center justify-between">
                <h4 className="font-bold flex items-center gap-2">
                    <MaterialSymbol icon="face" size={20} className="text-primary" />
                    Pedaços
                    <span className="badge badge-sm badge-ghost">{children.length}</span>
                </h4>
                {onAddChild && (
                    <button
                        type="button"
                        className="btn btn-outline btn-primary btn-xs gap-1"
                        onClick={onAddChild}
                    >
                        <MaterialSymbol icon="person_add" size={16} />
                        {addButtonLabel}
                    </button>
                )}
            </div>

            {children.length > 0 ? (
                <div className="grid grid-cols-1 gap-2">
                    {children.map(child => (
                        <button
                            type="button"
                            key={child.id}
                            className="flex w-full items-center gap-3 rounded-lg border border-base-content/10 bg-base-100 p-2 hover:bg-base-200 cursor-pointer transition-colors text-left"
                            onClick={() => onSelectChild?.(child)}
                        >
                            <div className="avatar h-8 w-8 rounded-full bg-base-300">
                                <Avatar
                                    image={child.image}
                                    sex={child.sex}
                                    alt={child.name || ''}
                                    className="h-8 w-8 rounded-full object-cover"
                                />
                            </div>
                            <div className="flex-1 min-w-0">
                                <div className="font-bold text-sm truncate">{child.name}</div>
                                <div className="text-xs text-base-content/60 font-mono">
                                    Ano {child.start_year > 100 ? child.start_year % 100 : child.start_year}
                                </div>
                            </div>
                            {onSelectChild && (
                                <MaterialSymbol icon="chevron_right" className="text-base-content/30" />
                            )}
                        </button>
                    ))}
                </div>
            ) : (
                <div className="text-center py-4 bg-base-200/30 rounded-lg border border-dashed border-base-content/10 text-sm text-base-content/50">
                    {emptyMessage}
                </div>
            )}
        </div>
    );
};

ChildrenList.propTypes = {
    children: PropTypes.arrayOf(PropTypes.shape({
        id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
        name: PropTypes.string,
        image: PropTypes.string,
        sex: PropTypes.oneOf(["M", "F"]),
        start_year: PropTypes.number,
    })),
    onAddChild: PropTypes.func,
    onSelectChild: PropTypes.func,
    addButtonLabel: PropTypes.string,
    emptyMessage: PropTypes.string,
};

export default ChildrenList;

