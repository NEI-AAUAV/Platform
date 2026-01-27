/**
 * BaseModal - Reusable modal component with common structure
 * 
 * Provides:
 * - AnimatePresence wrapper
 * - Backdrop with click-to-close
 * - Animated container
 * - Body scroll locking
 * - Common header/footer structure
 */

import React, { useEffect } from "react";
import { createPortal } from "react-dom";
import PropTypes from "prop-types";
import { motion, AnimatePresence } from "framer-motion";
import MaterialSymbol from "components/MaterialSymbol";

/**
 * Hook to lock body scroll when modal is open
 */
export function useBodyScrollLock(isOpen) {
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
}

/**
 * BaseModal component
 */
const BaseModal = ({
    isOpen,
    onClose,
    title,
    subtitle,
    icon,
    iconClassName = "text-primary",
    children,
    footer,
    maxWidth = "max-w-xl",
    zIndex = 50,
    variant = "default", // "default" | "error" | "warning"
    disableBackdropClick = false,
    className = ""
}) => {
    useBodyScrollLock(isOpen);

    const variantStyles = {
        default: {
            container: "border-base-content/10 bg-base-100",
            header: "border-base-content/10",
            iconBg: "bg-primary/20"
        },
        error: {
            container: "border-error/30 bg-base-100",
            header: "border-error/20 bg-error/5",
            iconBg: "bg-error/20"
        },
        warning: {
            container: "border-warning/30 bg-base-100",
            header: "border-warning/20 bg-warning/5",
            iconBg: "bg-warning/20"
        }
    };

    const styles = variantStyles[variant] || variantStyles.default;

    return createPortal(
        <AnimatePresence>
            {isOpen && (
                <>
                    {/* Backdrop */}
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        style={{ zIndex: zIndex - 1 }}
                        className="fixed inset-0 bg-black/60 backdrop-blur-sm"
                        onClick={disableBackdropClick ? undefined : onClose}
                    />

                    {/* Modal Container */}
                    <div style={{ zIndex }} className="fixed inset-0 flex items-center justify-center p-4">
                        <motion.div
                            initial={{ opacity: 0, scale: 0.95, y: 20 }}
                            animate={{ opacity: 1, scale: 1, y: 0 }}
                            exit={{ opacity: 0, scale: 0.95, y: 20 }}
                            className={`w-full ${maxWidth} rounded-2xl border ${styles.container} shadow-2xl ${className}`}
                            onClick={(e) => e.stopPropagation()}
                        >
                            {/* Header */}
                            {(title || icon) && (
                                <div className={`flex items-center justify-between border-b ${styles.header} p-4 rounded-t-2xl`}>
                                    <div className="flex items-center gap-3">
                                        {icon && (
                                            <div className={`flex h-10 w-10 items-center justify-center rounded-full ${styles.iconBg}`}>
                                                <MaterialSymbol icon={icon} size={24} className={iconClassName} />
                                            </div>
                                        )}
                                        <div>
                                            {title && <h3 className="text-lg font-bold">{title}</h3>}
                                            {subtitle && <p className="text-sm text-base-content/60 mt-1">{subtitle}</p>}
                                        </div>
                                    </div>
                                    <button
                                        type="button"
                                        className="btn btn-ghost btn-sm btn-circle"
                                        onClick={onClose}
                                        aria-label="Fechar modal"
                                    >
                                        <MaterialSymbol icon="close" size={20} />
                                    </button>
                                </div>
                            )}

                            {/* Content */}
                            <div className="p-6">
                                {children}
                            </div>

                            {/* Footer */}
                            {footer && (
                                <div className="flex items-center justify-end gap-3 border-t border-base-content/10 p-4 rounded-b-2xl">
                                    {footer}
                                </div>
                            )}
                        </motion.div>
                    </div>
                </>
            )}
        </AnimatePresence>,
        document.body
    );
};

BaseModal.propTypes = {
    isOpen: PropTypes.bool.isRequired,
    onClose: PropTypes.func.isRequired,
    title: PropTypes.string,
    subtitle: PropTypes.string,
    icon: PropTypes.string,
    iconClassName: PropTypes.string,
    children: PropTypes.node.isRequired,
    footer: PropTypes.node,
    maxWidth: PropTypes.string,
    zIndex: PropTypes.number,
    variant: PropTypes.oneOf(["default", "error", "warning"]),
    disableBackdropClick: PropTypes.bool,
    className: PropTypes.string,
};

export default BaseModal;

