/**
 * ProfileViewModal - Read-only profile view for family tree members
 * 
 * Shows member details: name, entry year, course, and insignias with dynamic icons from backend.
 * Allows navigation to patrão and pedaços within the tree.
 */

import { useState, useEffect } from "react";
import PropTypes from "prop-types";
import { createPortal } from "react-dom";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";
import MaterialSymbol from "components/MaterialSymbol";
import { CloseIcon } from "assets/icons/google";
import FamilyService from "services/FamilyService";
import { formatYear } from "pages/Family/utils";
import { colors } from "pages/Family/data";

import malePic from "assets/default_profile/male.svg";
import femalePic from "assets/default_profile/female.svg";

/**
 * @param {Object} props
 * @param {boolean} props.isOpen - Whether modal is open
 * @param {Object} props.user - User data from tree node
 * @param {Function} props.onClose - Close handler
 * @param {Function} props.onNavigateToNode - Navigate to another node in tree (receives user ID)
 */
const ProfileViewModal = ({ isOpen, user, onClose, onNavigateToNode }) => {
    const [courses, setCourses] = useState([]);
    const [patraoData, setPatraoData] = useState(null);
    const [childrenList, setChildrenList] = useState([]);
    const [loading, setLoading] = useState(false);

    // Load courses for name lookup
    useEffect(() => {
        if (isOpen) {
            FamilyService.getCourses({ limit: 100 })
                .then(res => setCourses(res.items || []))
                .catch(console.error);
        }
    }, [isOpen]);

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

    // Load children (pedaços)
    useEffect(() => {
        if (isOpen && user?.id) {
            setLoading(true);
            FamilyService.getUserChildren(user.id)
                .then(setChildrenList)
                .catch(() => setChildrenList([]))
                .finally(() => setLoading(false));
        } else {
            setChildrenList([]);
        }
    }, [isOpen, user?.id]);

    // Lock body scroll when modal is open
    useEffect(() => {
        if (isOpen) {
            const scrollY = window.scrollY;
            document.body.style.position = 'fixed';
            document.body.style.top = `-${scrollY}px`;
            document.body.style.left = '0';
            document.body.style.right = '0';
            document.body.style.overflow = 'hidden';
            return () => {
                document.body.style.position = '';
                document.body.style.top = '';
                document.body.style.left = '';
                document.body.style.right = '';
                document.body.style.overflow = '';
                window.scrollTo(0, scrollY);
            };
        }
    }, [isOpen]);

    // Get course name from ID
    const getCourseName = (courseId) => {
        if (!courseId) return null;
        const course = courses.find(c => (c._id || c.id) === courseId);
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
                                    background: `linear-gradient(135deg, ${yearColor}20 0%, transparent 60%)`
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

                                {/* Profile photo */}
                                <div
                                    className="mb-4 h-24 w-24 rounded-full ring-4 ring-offset-2 ring-offset-base-100 overflow-hidden"
                                    style={{ ringColor: yearColor }}
                                >
                                    <img
                                        src={user.sex === "F" ? femalePic : malePic}
                                        alt=""
                                        className="h-full w-full object-cover"
                                    />
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

                                {/* Insignias - Dynamic from backend */}
                                {insignias.length > 0 && (
                                    <div>
                                        <h3 className="text-sm font-bold text-base-content/60 uppercase tracking-wide mb-3">
                                            Insígnias
                                        </h3>
                                        <div className="space-y-2">
                                            {insignias.map((ins, idx) => (
                                                <div
                                                    key={`${ins.name}-${ins.year}-${idx}`}
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
                                                            {/* Show full role context: role_name + parent org if available */}
                                                            {ins.role_name || ins.role || ins.name}
                                                            {ins.parent_org_name && (
                                                                <span className="text-base-content/50 font-normal"> ({ins.parent_org_name})</span>
                                                            )}
                                                        </div>
                                                        <div className="text-sm text-base-content/50">
                                                            {formatYear(ins.year, ins.year_display_format || "civil")}
                                                        </div>
                                                    </div>
                                                </div>
                                            ))}
                                        </div>
                                    </div>
                                )}

                                {/* Patrão */}
                                {patraoData && (
                                    <div>
                                        <h3 className="text-sm font-bold text-base-content/60 uppercase tracking-wide mb-3">
                                            Patrão
                                        </h3>
                                        <button
                                            type="button"
                                            className="flex w-full items-center gap-3 p-3 rounded-xl bg-base-200/50 hover:bg-base-200 transition-colors text-left"
                                            onClick={() => handleNavigate(patraoData._id || patraoData.id)}
                                        >
                                            <div className="avatar h-10 w-10">
                                                <img
                                                    src={patraoData.sex === "F" ? femalePic : malePic}
                                                    alt=""
                                                    className="rounded-full"
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
                                {!loading && childrenList.length > 0 && (
                                    <div>
                                        <h3 className="text-sm font-bold text-base-content/60 uppercase tracking-wide mb-3">
                                            Pedaços
                                            <span className="ml-2 badge badge-sm badge-ghost">{childrenList.length}</span>
                                        </h3>
                                        <div className="space-y-2">
                                            {childrenList.map(child => (
                                                <button
                                                    type="button"
                                                    key={child._id || child.id}
                                                    className="flex w-full items-center gap-3 p-3 rounded-xl bg-base-200/50 hover:bg-base-200 transition-colors text-left"
                                                    onClick={() => handleNavigate(child._id || child.id)}
                                                >
                                                    <div className="avatar h-10 w-10">
                                                        <img
                                                            src={child.sex === "F" ? femalePic : malePic}
                                                            alt=""
                                                            className="rounded-full"
                                                        />
                                                    </div>
                                                    <div className="flex-1 min-w-0">
                                                        <div className="font-medium truncate">{child.name}</div>
                                                        <div className="text-sm text-base-content/50">
                                                            Ano de Batismo {formatYear(child.start_year, "civil")}
                                                        </div>
                                                    </div>
                                                    <MaterialSymbol icon="arrow_forward" size={20} className="text-base-content/30" />
                                                </button>
                                            ))}
                                        </div>
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
        course_id: PropTypes.number,
        parent: PropTypes.number,
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
