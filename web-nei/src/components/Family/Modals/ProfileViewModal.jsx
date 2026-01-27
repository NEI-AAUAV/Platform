/**
 * ProfileViewModal - Read-only profile view for family tree members
 * 
 * Shows member details: name, entry year, course, and insignias with dynamic icons from backend.
 * Allows navigation to patrão and pedaços within the tree.
 */

import { useState, useEffect } from "react";
import { useCourses, useUserChildren } from "hooks/useFamilyData";
import PropTypes from "prop-types";
import { createPortal } from "react-dom";
import { motion, AnimatePresence } from "framer-motion";
import MaterialSymbol from "components/MaterialSymbol";
import { CloseIcon } from "assets/icons/google";
import FamilyService from "services/FamilyService";
import { formatYear } from "pages/Family/utils";
import { colors } from "pages/Family/config";
import heartBorder from "assets/icons/heart_border.svg";
import Avatar from "components/Avatar";
import { ChildrenList } from "../index";
import { useBodyScrollLock } from "components/Modal";

/**
 * @param {Object} props
 * @param {boolean} props.isOpen - Whether modal is open
 * @param {Object} props.user - User data from tree node
 * @param {Function} props.onClose - Close handler
 * @param {Function} props.onNavigateToNode - Navigate to another node in tree (receives user ID)
 */
const ProfileViewModal = ({ isOpen, user, onClose, onNavigateToNode }) => {
    const { courses } = useCourses();
    const { children: childrenList, loading } = useUserChildren(isOpen ? user?.id : null);
    const [patraoData, setPatraoData] = useState(null);

    // Load patrão data if user has one
    useEffect(() => {
        if (isOpen && user?.parent) {
            FamilyService.getUserById(user.parent)
                .then(setPatraoData)
                .catch(() => setPatraoData(null));
        } else {
            setPatraoData(null);
        }
    }, [isOpen, user?.parent]);



    // Lock body scroll when modal is open
    useBodyScrollLock(isOpen);

    // Get course name from ID
    const getCourseName = (courseId) => {
        if (!courseId) return null;
        const course = courses.find(c => c.id === courseId);
        return course ? `${course.short} - ${course.name}` : null;
    };

    // Get formatted entry year
    const getEntryYear = () => {
        if (!user?.start_year) return "-";
        return formatYear(user.start_year, "civil");
    };

    // Get user insignias (from organizations array which has dynamic icon from backend)
    const getUserInsignias = () => {
        if (!user?.organizations) return [];
        // Filter out hidden and group by role
        return user.organizations.filter(org => !org.hidden);
    };

    const handleNavigate = (userId) => {
        onClose();
        if (onNavigateToNode) {
            onNavigateToNode(userId);
        }
    };

    if (!user) return null;

    const yearColor = colors[(user.start_year || 0) % colors.length];
    const courseName = getCourseName(user.course_id);
    const insignias = getUserInsignias();

    // Group insignias by organization (name)
    const groupedByOrg = insignias.reduce((acc, ins) => {
        const org = ins.name || "Outros";
        if (!acc[org]) acc[org] = [];
        acc[org].push(ins);
        return acc;
    }, {});

    const hasInsigniasSection = Object.keys(groupedByOrg).length > 0;
    const hasPatraoSection = Boolean(patraoData);
    const hasChildrenSection = !loading && childrenList.length > 0;

    return createPortal(
        <AnimatePresence>
            {isOpen && (
                <>
                    {/* Backdrop */}
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        className="fixed inset-0 z-[100] bg-black/60 backdrop-blur-sm"
                        onClick={onClose}
                    />

                    {/* Modal */}
                    <div className="fixed inset-0 z-[110] flex items-center justify-center p-4">
                        <motion.div
                            initial={{ opacity: 0, scale: 0.95, y: 20 }}
                            animate={{ opacity: 1, scale: 1, y: 0 }}
                            exit={{ opacity: 0, scale: 0.95, y: 20 }}
                            className="relative flex max-h-[85vh] w-full max-w-lg flex-col overflow-hidden rounded-2xl border border-base-content/10 bg-base-100 shadow-2xl"
                            onClick={(e) => e.stopPropagation()}
                        >
                            {/* Header with profile */}
                            <div
                                className="relative flex flex-col items-center px-6 pt-8 pb-6"
                                style={{
                                    background: `linear-gradient(135deg, ${yearColor}25 0%, ${yearColor}08 50%, transparent 100%)`
                                }}
                            >
                                {/* Close button */}
                                <button
                                    type="button"
                                    className="btn btn-ghost btn-sm btn-circle absolute right-4 top-4"
                                    onClick={onClose}
                                >
                                    <CloseIcon />
                                </button>

                                {/* Profile Photo Container with Special Overlay */}
                                <div className="relative mb-4 flex justify-center items-center">

                                    {/* Special Heart Border Overlay */}
                                    {user.nmec === 76368 && (
                                        <div
                                            className="absolute pointer-events-none"
                                            style={{
                                                width: '130%',  // Larger than the photo
                                                height: '130%',
                                                backgroundImage: `url(${heartBorder})`,
                                                backgroundSize: 'contain',
                                                backgroundPosition: 'center',
                                                backgroundRepeat: 'no-repeat',
                                                filter: 'brightness(1.3) drop-shadow(0 2px 4px rgba(0,0,0,0.2))',
                                                zIndex: 10,  // On top of photo border
                                            }}
                                        />
                                    )}

                                    {/* Standard Photo with Year Color Ring */}
                                    <div
                                        className="h-24 w-24 rounded-full overflow-hidden"
                                        style={{
                                            border: `4px solid ${yearColor}`,
                                            boxShadow: `0 0 0 2px hsl(var(--b1))`
                                        }}
                                    >
                                        <Avatar
                                            image={user.image}
                                            sex={user.sex}
                                            alt={user.name || "avatar"}
                                            className="h-24 w-24 object-cover"
                                        />
                                    </div>
                                </div>

                                {/* Name */}
                                <h2 className="text-xl font-bold text-center">{user.name}</h2>

                                {/* Entry year badge */}
                                <div
                                    className="mt-2 px-3 py-1 rounded-full text-sm font-medium"
                                    style={{
                                        backgroundColor: `${yearColor}30`,
                                        color: yearColor
                                    }}
                                >
                                    Ano de Batismo {getEntryYear()}
                                </div>

                                {/* Exit year badge - if user has left */}
                                {user.end_year != null && (
                                    <div
                                        className="mt-1 px-3 py-1 rounded-full text-sm font-medium"
                                        style={{
                                            backgroundColor: `${yearColor}20`,
                                            color: yearColor
                                        }}
                                    >
                                        Ano de Saída {formatYear(user.end_year, "civil")}
                                    </div>
                                )}
                            </div>

                            {/* Scrollable content */}
                            <div className="flex-1 overflow-y-auto p-6 space-y-6" style={{ WebkitOverflowScrolling: 'touch' }}>
                                {/* Course */}
                                {courseName && (
                                    <div className="flex items-center gap-3">
                                        <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-base-200">
                                            <MaterialSymbol icon="school" size={20} className="text-base-content/60" />
                                        </div>
                                        <div>
                                            <div className="text-xs text-base-content/50 uppercase tracking-wide">Curso</div>
                                            <div className="font-medium">{courseName}</div>
                                        </div>
                                    </div>
                                )}

                                {/* Insignias - Grouped by organization (with hierarchy if parent_org_name) */}
                                {hasInsigniasSection && (
                                    <div>
                                        <div className="mb-3 flex items-center justify-between">
                                            <h4 className="font-bold flex items-center gap-2">
                                                <MaterialSymbol icon="military_tech" size={20} className="text-primary" />
                                                Insígnias
                                                <span className="badge badge-sm badge-ghost">{insignias.length}</span>
                                            </h4>
                                        </div>
                                        <div className="space-y-4">
                                            {Object.entries(groupedByOrg).map(([org, items]) => {
                                                // Find parent org name if any of the items have it and it's different from org
                                                const parentOrg = items.find(ins => ins.parent_org_name && ins.parent_org_name !== org)?.parent_org_name;
                                                return (
                                                    <div key={org}>
                                                        <div className="font-semibold text-base-content/80 mb-2">
                                                            {parentOrg ? `${parentOrg} › ${org}` : org}
                                                        </div>
                                                        <div className="space-y-2">
                                                            {items.map((ins, idx) => (
                                                                <div
                                                                    key={`${ins.role_name || ins.role || ins.name}-${ins.year}-${idx}`}
                                                                    className="flex items-center gap-3 p-3 rounded-xl bg-base-200/50 hover:bg-base-200 transition-colors"
                                                                >
                                                                    {/* Dynamic icon from backend */}
                                                                    <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-base-300 flex-shrink-0">
                                                                        {ins.icon ? (
                                                                            <img
                                                                                src={ins.icon}
                                                                                alt=""
                                                                                className="h-6 w-6 object-contain"
                                                                            />
                                                                        ) : (
                                                                            <MaterialSymbol
                                                                                icon="badge"
                                                                                size={20}
                                                                                className="text-base-content/50"
                                                                            />
                                                                        )}
                                                                    </div>
                                                                    <div className="flex-1 min-w-0">
                                                                        <div className="font-medium truncate">
                                                                            {ins.role_name || ins.role || ins.name}
                                                                        </div>
                                                                        <div className="text-sm text-base-content/50">
                                                                            {formatYear(ins.year, ins.year_display_format || "civil")}
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            ))}
                                                        </div>
                                                    </div>
                                                );
                                            })}
                                        </div>
                                    </div>
                                )}

                                {/* Patrão */}
                                {patraoData && (
                                    <div className={`mt-4 ${hasInsigniasSection ? "border-t border-base-content/10 pt-4" : ""}`}>
                                        <div className="mb-3 flex items-center justify-between">
                                            <h4 className="font-bold flex items-center gap-2">
                                                <MaterialSymbol icon="workspace_premium" size={20} className="text-primary" />
                                                Patrão
                                            </h4>
                                        </div>
                                        <button
                                            type="button"
                                            className="flex w-full items-center gap-3 p-3 rounded-xl bg-base-200/50 hover:bg-base-200 transition-colors text-left"
                                            onClick={() => handleNavigate(patraoData.id)}
                                        >
                                            <div className="avatar h-10 w-10">
                                                <Avatar
                                                    image={patraoData.image}
                                                    sex={patraoData.sex}
                                                    alt={patraoData.name || "avatar"}
                                                    className="h-10 w-10 rounded-full object-cover"
                                                />
                                            </div>
                                            <div className="flex-1 min-w-0">
                                                <div className="font-medium truncate">{patraoData.name}</div>
                                                <div className="text-sm text-base-content/50">
                                                    Ano de Batismo {formatYear(patraoData.start_year, "civil")}
                                                </div>
                                            </div>
                                            <MaterialSymbol icon="arrow_forward" size={20} className="text-base-content/30" />
                                        </button>
                                    </div>
                                )}

                                {/* Pedaços (Children) */}
                                {hasChildrenSection && (
                                    <div className={`mt-4 ${(hasInsigniasSection || hasPatraoSection) ? "border-t border-base-content/10 pt-4" : ""}`}>
                                        <ChildrenList
                                            childrenData={childrenList}
                                            onAddChild={null}
                                            onSelectChild={(child) => handleNavigate(child.id)}
                                            addButtonLabel=""
                                            emptyMessage=""
                                        />
                                    </div>
                                )}

                                {loading && (
                                    <div className="flex justify-center py-4">
                                        <span className="loading loading-spinner loading-sm"></span>
                                    </div>
                                )}
                            </div>
                        </motion.div>
                    </div>
                </>
            )}
        </AnimatePresence>,
        document.body
    );
};

ProfileViewModal.propTypes = {
    isOpen: PropTypes.bool.isRequired,
    user: PropTypes.shape({
        id: PropTypes.number,
        name: PropTypes.string,
        sex: PropTypes.oneOf(["M", "F"]),
        start_year: PropTypes.number,
        end_year: PropTypes.number,
        course_id: PropTypes.number,
        parent: PropTypes.number,
        nmec: PropTypes.number,
        image: PropTypes.string,
        organizations: PropTypes.arrayOf(PropTypes.shape({
            name: PropTypes.string,
            role: PropTypes.string,
            role_name: PropTypes.string,
            parent_org_name: PropTypes.string,
            year: PropTypes.number,
            icon: PropTypes.string,
            year_display_format: PropTypes.string,
            hidden: PropTypes.bool,
        })),
    }),
    onClose: PropTypes.func.isRequired,
    onNavigateToNode: PropTypes.func,
};

export default ProfileViewModal;

