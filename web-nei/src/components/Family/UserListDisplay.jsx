/**
 * UserListDisplay - Component for displaying lists of users with avatars
 * 
 * Used in modals to show selected users, members to delete, etc.
 */

import React from "react";
import PropTypes from "prop-types";
import Avatar from "components/Avatar";
import { colors } from "pages/Family/data";

const UserListDisplay = ({
    users = [],
    maxDisplay = 20,
    showYearDot = true,
    showAvatar = true,
    className = "",
    itemClassName = "",
    variant = "default" // "default" | "compact" | "detailed"
}) => {
    if (users.length === 0) {
        return (
            <div className="text-center py-4 text-sm text-base-content/50">
                Nenhum membro selecionado
            </div>
        );
    }

    const displayedUsers = users.slice(0, maxDisplay);
    const remaining = users.length - maxDisplay;

    const variantStyles = {
        default: {
            container: "flex flex-wrap gap-2",
            item: "flex items-center gap-2 px-3 py-1.5 bg-base-100 rounded-lg text-sm border border-base-content/5",
            avatar: "w-5 h-5",
            yearDot: "w-3 h-3"
        },
        compact: {
            container: "flex flex-wrap gap-1.5",
            item: "flex items-center gap-1.5 px-2 py-1 bg-base-100 rounded-lg text-xs border border-base-content/10",
            avatar: "w-4 h-4",
            yearDot: "w-2 h-2"
        },
        detailed: {
            container: "flex flex-col gap-2",
            item: "flex items-center gap-3 px-3 py-2 bg-base-100 rounded-lg text-sm border border-base-content/10",
            avatar: "w-8 h-8",
            yearDot: "w-3 h-3"
        }
    };

    const styles = variantStyles[variant] || variantStyles.default;

    return (
        <div className={`max-h-40 overflow-y-auto rounded-lg border border-base-content/10 bg-base-200/50 p-2 ${className}`}>
            <div className={styles.container}>
                {displayedUsers.map(user => (
                    <div
                        key={user.id}
                        className={`${styles.item} ${itemClassName}`}
                    >
                        {showAvatar && (
                            <Avatar
                                image={user.image}
                                sex={user.sex}
                                alt={user.name || ''}
                                className={`${styles.avatar} rounded-full object-cover`}
                            />
                        )}
                        <span className="truncate max-w-[120px]">{user.name}</span>
                        {showYearDot && user.start_year !== undefined && (
                            <div
                                className={`${styles.yearDot} rounded-full flex-shrink-0`}
                                style={{ backgroundColor: colors[(user.start_year || 0) % colors.length] }}
                                title={`Ano ${user.start_year}`}
                            />
                        )}
                    </div>
                ))}
                {remaining > 0 && (
                    <div className={`${styles.item} text-base-content/50`}>
                        +{remaining} mais...
                    </div>
                )}
            </div>
        </div>
    );
};

UserListDisplay.propTypes = {
    users: PropTypes.arrayOf(PropTypes.shape({
        id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
        name: PropTypes.string,
        image: PropTypes.string,
        sex: PropTypes.oneOf(["M", "F"]),
        start_year: PropTypes.number,
    })).isRequired,
    maxDisplay: PropTypes.number,
    showYearDot: PropTypes.bool,
    showAvatar: PropTypes.bool,
    className: PropTypes.string,
    itemClassName: PropTypes.string,
    variant: PropTypes.oneOf(["default", "compact", "detailed"]),
};

export default UserListDisplay;

