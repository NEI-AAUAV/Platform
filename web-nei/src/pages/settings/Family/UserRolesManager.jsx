
import { useState, useEffect } from "react";
import { RoleDisplay, RolePickerModal } from "components/Family";
import FamilyService from "services/FamilyService";
import { getErrorMessage } from "utils/error";

export default function UserRolesManager({ user, isEdit, pendingRoles, setPendingRoles }) {
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
        } catch (err) {
            alert(getErrorMessage(err, "Erro ao remover insígnia"));
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
        } catch (err) {
            alert(getErrorMessage(err, "Erro ao adicionar insígnia"));
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
            />
        </>
    );
}
