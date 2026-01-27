
import { useState, useEffect } from "react";
import PropTypes from "prop-types";
import { useToast } from "components/ui/use-toast";
import { RoleDisplay, RolePickerModal } from "components/Family";
import FamilyService from "services/FamilyService";
import { getErrorMessage } from "utils/error";

export default function UserRolesManager({ user, isEdit, pendingRoles, setPendingRoles }) {
    const { toast } = useToast();
    const [userRoles, setUserRoles] = useState([]);
    const [rolesLoading, setRolesLoading] = useState(false);
    const [showRolePicker, setShowRolePicker] = useState(false);

    // Load user roles when editing
    useEffect(() => {
        async function loadUserRoles() {
            if (!user?.id) return;
            const uid = user.id;
            setRolesLoading(true);
            try {
                const response = await FamilyService.getRolesForUser(uid);
                setUserRoles(response.items || []);
            } catch (err) {
                console.error("Failed to load user roles:", err);
                setUserRoles([]);
            } finally {
                setRolesLoading(false);
            }
        }
        if (isEdit) {
            loadUserRoles();
        } else {
            setUserRoles([]);
        }
    }, [isEdit, user?.id]);

    const handleRemoveRole = async (roleId) => {
        if (!isEdit) {
            setPendingRoles(prev => prev.filter(r => r.tempId !== roleId));
            return;
        }
        try {
            await FamilyService.removeRole(roleId);
            setUserRoles((prev) => prev.filter((r) => r.id !== roleId));
            toast({
                title: "Insígnia removida",
                description: "A insígnia foi removida do membro.",
            });
        } catch (err) {
            toast({
                title: "Erro ao remover insígnia",
                description: getErrorMessage(err, "Erro ao remover insígnia"),
                variant: "destructive",
            });
        }
    };

    const handleAddRoleCallback = async (selectedNode, roleYear) => {
        // For new users, add to pending list locally
        if (!isEdit) {
            setPendingRoles(prev => [...prev, {
                tempId: Date.now(),
                role_id: selectedNode.id,
                year: roleYear,
                org_name: selectedNode.short || selectedNode.name,
                name: selectedNode.name
            }]);
            return;
        }

        try {
            await FamilyService.assignRole({
                user_id: user.id,
                role_id: selectedNode.id,
                year: roleYear,
            });
            const response = await FamilyService.getRolesForUser(user.id);
            setUserRoles(response.items || []);
            toast({
                title: "Insígnia adicionada",
                description: `A insígnia ${selectedNode.name} foi adicionada ao membro.`,
            });
        } catch (err) {
            toast({
                title: "Erro ao adicionar insígnia",
                description: getErrorMessage(err, "Erro ao adicionar insígnia"),
                variant: "destructive",
            });
        }
    };

    const displayRoles = isEdit ? userRoles : pendingRoles;

    return (
        <>
            <RoleDisplay
                roles={displayRoles}
                loading={rolesLoading}
                onAdd={() => setShowRolePicker(true)}
                onRemove={handleRemoveRole}
            />

            <RolePickerModal
                isOpen={showRolePicker}
                onClose={() => setShowRolePicker(false)}
                onSelect={handleAddRoleCallback}
                title="Atribuir Insígnia"
                requireYear={true}
                initialYear={new Date().getFullYear() - 2000}
            />
        </>
    );
}

UserRolesManager.propTypes = {
    user: PropTypes.shape({
        id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
    }),
    isEdit: PropTypes.bool,
    pendingRoles: PropTypes.array,
    setPendingRoles: PropTypes.func,
};
