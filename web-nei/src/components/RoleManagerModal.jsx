import { useState, useEffect, useMemo } from "react";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";
import MaterialSymbol from "components/MaterialSymbol";
import { CloseIcon } from "assets/icons/google";
import FamilyService from "services/FamilyService";
import { organizations, colors } from "pages/Family/data";
import { formatYear } from "pages/Family/utils";
import IconPicker from "components/IconPicker";

import malePic from "assets/default_profile/male.svg";
import femalePic from "assets/default_profile/female.svg";

/**
 * Role Manager Modal
 * Allows creating, editing, and deleting roles in the hierarchy.
 */
export default function RoleManagerModal({ isOpen, onClose }) {
    const [roleTree, setRoleTree] = useState([]);
    const [loading, setLoading] = useState(false);
    const [selectedNode, setSelectedNode] = useState(null);

    // Form State
    const [formData, setFormData] = useState({
        name: "",
        short: "",
        female_name: "",
        show: false,
        super_roles: "",
        year_display_format: "civil"
    });
    const [isNew, setIsNew] = useState(false);
    const [submitting, setSubmitting] = useState(false);

    // Tab and Members State
    const [activeTab, setActiveTab] = useState("edit"); // "edit" or "members"
    const [roleMembers, setRoleMembers] = useState([]);
    const [membersLoading, setMembersLoading] = useState(false);
    const [memberYearFilter, setMemberYearFilter] = useState(null);
    const [availableYears, setAvailableYears] = useState([]);

    // Load Tree
    const loadTree = async () => {
        setLoading(true);
        try {
            const tree = await FamilyService.getRoleTree();
            setRoleTree(tree || []);
        } catch (err) {
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        if (isOpen) {
            loadTree();
            loadAvailableYears();
            setSelectedNode(null);
            setFormData({ name: "", short: "", female_name: "", show: false, super_roles: "", icon: "", hidden: false });
            setIsNew(false);
            setActiveTab("edit");
            setRoleMembers([]);
        }
    }, [isOpen]);

    // Load available years for filter
    const loadAvailableYears = async () => {
        try {
            const years = await FamilyService.getYears();
            setAvailableYears(years || []);
        } catch (err) {
            console.error("Failed to load years:", err);
        }
    };

    // Fetch members who have a specific role
    const fetchRoleMembers = async (roleId, year = null) => {
        if (!roleId) return;
        setMembersLoading(true);
        try {
            const params = { role_id: roleId };
            if (year !== null) params.year = year;
            const response = await FamilyService.getUserRolesWithDetails(params);
            // Handle both array and paginated {items: []} response formats
            const members = Array.isArray(response) ? response : (response?.items || []);
            setRoleMembers(members);
        } catch (err) {
            console.error("Failed to load role members:", err);
            setRoleMembers([]);
        } finally {
            setMembersLoading(false);
        }
    };

    // Reload members when year filter changes
    useEffect(() => {
        if (selectedNode && !isNew && activeTab === "members") {
            fetchRoleMembers(selectedNode._id, memberYearFilter);
        }
    }, [memberYearFilter, activeTab]);

    // Select a node to edit
    const handleSelectNode = (node) => {
        setSelectedNode(node);
        setIsNew(false);
        setActiveTab("edit");
        setMemberYearFilter(null);
        setFormData({
            name: node.name,
            short: node.short || "",
            female_name: node.female_name || "",
            show: node.show || false,
            super_roles: node.super_roles || "",
            year_display_format: node.year_display_format || "civil",
            icon: node.icon || "",
            hidden: node.hidden || false
        });
        // Pre-fetch members
        fetchRoleMembers(node._id, null);
    };

    // Handle removing a role from a member
    const handleRemoveRoleFromMember = async (userRoleId) => {
        if (!window.confirm("Remover esta insígnia do membro?")) return;
        try {
            await FamilyService.removeRole(userRoleId);
            // Refresh members list
            fetchRoleMembers(selectedNode._id, memberYearFilter);
        } catch (err) {
            alert("Erro ao remover: " + (err.response?.data?.detail || err.message));
        }
    };

    const handleCreateRoot = () => {
        setSelectedNode(null); // No parent
        setIsNew(true);
        setFormData({
            name: "",
            short: "",
            female_name: "",
            show: true,
            super_roles: "", // Root
            year_display_format: "civil",
            icon: "",
            hidden: false
        });
    };

    const handleAddChild = () => {
        if (!selectedNode) return;
        const parentId = selectedNode._id;
        // setIsNew(true); // Don't unselect parent, just switch logic?
        // Actually, distinct mode.
        // Let's keep selectedNode as the "Active Context".
        // But we are creating a NEW node under it.

        // Better UX: 
        // Select a node -> See Details.
        // Button "Add Child" -> Clears form, sets mode to New, sets super_roles to selectedNode._id
        setIsNew(true);
        setFormData({
            name: "",
            short: "",
            female_name: "",
            show: true,
            super_roles: parentId,
            year_display_format: selectedNode.year_display_format || "civil",
            icon: "",
            hidden: false
        });
    };

    const handleSave = async (e) => {
        e.preventDefault();
        setSubmitting(true);
        try {
            if (isNew) {
                await FamilyService.createRole(formData);
                // toast.success("Role created");
            } else {
                if (!selectedNode) return;
                await FamilyService.updateRole(selectedNode._id, formData);
                // toast.success("Role updated");
            }
            await loadTree();
            // Reset form if new, or keep editing if update? 
            if (isNew) {
                // Maybe select the new node? Complex to find.
                // Just reset to empty.
                setFormData({ name: "", short: "", female_name: "", show: false, super_roles: "", year_display_format: "civil", icon: "", hidden: false });
                setIsNew(false);
                setSelectedNode(null);
            }
        } catch (err) {
            console.error(err);
            alert("Erro ao guardar role: " + (err.response?.data?.detail || err.message));
        } finally {
            setSubmitting(false);
        }
    };

    const handleDelete = async () => {
        if (!selectedNode || isNew) return;
        if (!window.confirm(`Tem a certeza que deseja eliminar "${selectedNode.name}"?`)) return;

        setSubmitting(true);
        try {
            await FamilyService.deleteRole(selectedNode._id);
            await loadTree();
            setSelectedNode(null);
            setIsNew(false);
        } catch (err) {
            console.error(err);
            alert("Erro ao eliminar: " + (err.response?.data?.detail || err.message));
        } finally {
            setSubmitting(false);
        }
    };

    // Helper to find role name by ID
    const findRoleName = (nodes, id) => {
        for (const node of nodes) {
            if (node._id === id) return node.name;
            if (node.children) {
                const found = findRoleName(node.children, id);
                if (found) return found;
            }
        }
        return null;
    };

    // Recursive Tree Renderer
    const renderTree = (nodes, depth = 0) => {
        return (
            <div className="flex flex-col gap-0.5 relative">
                {/* Vertical Line for Depth > 0 */}
                {depth > 0 && (
                    <div
                        className="absolute left-[0.25rem] top-0 bottom-0 w-px bg-base-content/10"
                        style={{ left: "-0.75rem" }}
                    />
                )}

                {nodes.map(node => {
                    const isSelected = selectedNode?._id === node._id && !isNew;
                    const isParentOfNew = isNew && formData.super_roles === node._id;
                    const hasChildren = node.children && node.children.length > 0;

                    // Determine Icon
                    let IconComponent = null;
                    let imgSrc = null;

                    if (node.icon) {
                        imgSrc = node.icon;
                    } else if (organizations[node.name]) {
                        imgSrc = organizations[node.name].insignia;
                    } else if (organizations[node.short]) {
                        imgSrc = organizations[node.short].insignia;
                    } else {
                        IconComponent = hasChildren ? "folder" : "badge";
                    }

                    return (
                        <div key={node._id} className="relative">
                            <button
                                className={classNames(
                                    "flex w-full items-center gap-3 rounded-lg px-2 py-2 text-left text-sm transition-all duration-200",
                                    isSelected
                                        ? "bg-primary text-primary-content shadow-md font-medium"
                                        : "hover:bg-base-200 text-base-content/80",
                                    isParentOfNew ? "bg-base-200 outline outline-2 outline-base-300" : ""
                                )}
                                onClick={() => handleSelectNode(node)}
                            >
                                <div className={classNames(
                                    "flex h-6 w-6 items-center justify-center rounded-full",
                                    isSelected ? "bg-white/20" : "bg-base-content/5"
                                )}>
                                    {imgSrc ? (
                                        <img src={imgSrc} alt="" className="h-4 w-4 object-contain" />
                                    ) : (
                                        <MaterialSymbol
                                            icon={IconComponent}
                                            size={16}
                                            className={isSelected ? "text-primary-content" : "text-base-content/50"}
                                        />
                                    )}
                                </div>
                                <span className="truncate">{node.name}</span>
                                {hasChildren && (
                                    <span className="ml-auto text-[10px] opacity-60">
                                        {node.children.length}
                                    </span>
                                )}
                            </button>

                            {hasChildren && (
                                <div className="ml-4 pl-2 border-l border-base-content/10 mt-1">
                                    {renderTree(node.children, depth + 1)}
                                </div>
                            )}
                        </div>
                    );
                })}
            </div>
        );
    };

    return (
        <AnimatePresence>
            {isOpen && (
                <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/40 backdrop-blur-[2px] p-6" onClick={onClose}>
                    <motion.div
                        initial={{ scale: 0.95, opacity: 0 }}
                        animate={{ scale: 1, opacity: 1 }}
                        exit={{ scale: 0.95, opacity: 0 }}
                        className="flex h-[90vh] w-full max-w-5xl flex-col overflow-hidden rounded-2xl border border-base-content/10 bg-base-100 shadow-2xl"
                        onClick={(e) => e.stopPropagation()}
                    >
                        <div className="flex min-h-0 flex-1 flex-col lg:flex-row">
                            {/* Sidebar: Tree */}
                            <div className="flex h-1/3 w-full flex-col border-b border-base-content/10 bg-base-200/30 lg:h-auto lg:w-1/3 lg:border-b-0 lg:border-r">
                                <div className="flex items-center justify-between border-b border-base-content/10 p-4">
                                    <h3 className="font-bold">Hierarquia</h3>
                                    <button className="btn btn-ghost btn-xs" onClick={handleCreateRoot}>
                                        <MaterialSymbol icon="add_circle" /> Raiz
                                    </button>
                                </div>
                                <div className="flex-1 overflow-y-auto p-2">
                                    {loading ? (
                                        <div className="flex justify-center p-4">
                                            <span className="loading loading-spinner"></span>
                                        </div>
                                    ) : (
                                        renderTree(roleTree)
                                    )}
                                </div>
                            </div>

                            {/* Main Content: Form or Members */}
                            <div className="flex flex-1 flex-col">
                                <div className="flex items-center justify-between border-b border-base-content/10 p-4">
                                    <h3 className="text-lg font-bold">
                                        {isNew
                                            ? (formData.super_roles ? "Nova Sub-Insígnia" : "Nova Insígnia Raiz")
                                            : (selectedNode ? selectedNode.name : "Selecione uma Insígnia")
                                        }
                                    </h3>
                                    <button className="btn btn-ghost btn-sm btn-circle" onClick={onClose}>
                                        <CloseIcon />
                                    </button>
                                </div>

                                {/* Tab Toggle - only show when editing existing role */}
                                {selectedNode && !isNew && (
                                    <div className="flex border-b border-base-content/10 px-4">
                                        <button
                                            type="button"
                                            className={classNames(
                                                "px-4 py-3 text-sm font-medium border-b-2 transition-colors",
                                                activeTab === "edit"
                                                    ? "border-primary text-primary"
                                                    : "border-transparent text-base-content/50 hover:text-base-content"
                                            )}
                                            onClick={() => setActiveTab("edit")}
                                        >
                                            <MaterialSymbol icon="edit" size={16} className="mr-1" />
                                            Editar
                                        </button>
                                        <button
                                            type="button"
                                            className={classNames(
                                                "px-4 py-3 text-sm font-medium border-b-2 transition-colors flex items-center gap-1",
                                                activeTab === "members"
                                                    ? "border-primary text-primary"
                                                    : "border-transparent text-base-content/50 hover:text-base-content"
                                            )}
                                            onClick={() => setActiveTab("members")}
                                        >
                                            <MaterialSymbol icon="group" size={16} />
                                            Membros
                                            {roleMembers.length > 0 && (
                                                <span className="badge badge-sm badge-primary">{roleMembers.length}</span>
                                            )}
                                        </button>
                                    </div>
                                )}

                                <div className="flex-1 overflow-y-auto p-6">
                                    {!selectedNode && !isNew ? (
                                        <div className="flex h-full flex-col items-center justify-center text-base-content/30 text-center">
                                            <MaterialSymbol icon="badge" size={48} className="mb-2 opacity-50" />
                                            <p>Selecione um item da lista à esquerda<br />ou crie uma nova raiz</p>
                                        </div>
                                    ) : activeTab === "members" && selectedNode && !isNew ? (
                                        /* Members List View */
                                        <div className="space-y-4">
                                            {/* Year Filter */}
                                            <div className="flex items-center justify-between">
                                                <h4 className="font-medium">Membros com esta insígnia</h4>
                                                <select
                                                    className="select select-bordered select-sm w-32"
                                                    value={memberYearFilter || ""}
                                                    onChange={(e) => setMemberYearFilter(e.target.value ? parseInt(e.target.value) : null)}
                                                >
                                                    <option value="">Todos os anos</option>
                                                    {availableYears.map(y => (
                                                        <option key={y} value={y}>Ano {formatYear(y)}</option>
                                                    ))}
                                                </select>
                                            </div>

                                            {/* Members List */}
                                            {membersLoading ? (
                                                <div className="flex justify-center py-8">
                                                    <span className="loading loading-spinner"></span>
                                                </div>
                                            ) : roleMembers.length === 0 ? (
                                                <div className="text-center py-8 text-base-content/40">
                                                    <MaterialSymbol icon="person_off" size={32} className="mb-2" />
                                                    <p>Nenhum membro encontrado</p>
                                                </div>
                                            ) : (
                                                <div className="space-y-2">
                                                    {roleMembers.map((member, idx) => (
                                                        <div
                                                            key={member._id || idx}
                                                            className="flex items-center gap-3 p-3 bg-base-200/50 rounded-lg hover:bg-base-200"
                                                        >
                                                            <div
                                                                className="avatar placeholder h-10 w-10 rounded-full ring-2 ring-offset-1"
                                                                style={{
                                                                    ringColor: colors[(member.user?.start_year || 0) % colors.length]
                                                                }}
                                                            >
                                                                <img
                                                                    src={member.user?.image || (member.user?.sex === 'F' ? femalePic : malePic)}
                                                                    alt=""
                                                                    className="rounded-full object-cover"
                                                                />
                                                            </div>
                                                            <div className="flex-1 min-w-0">
                                                                <div className="font-medium truncate">
                                                                    {member.user?.name || `User ${member.user_id}`}
                                                                </div>
                                                                <div className="text-xs text-base-content/50">
                                                                    Ano {formatYear(member.year, selectedNode.year_display_format || "civil")}
                                                                    {member.user?.start_year && (
                                                                        <span> · Entrada {formatYear(member.user.start_year)}</span>
                                                                    )}
                                                                </div>
                                                            </div>
                                                            <button
                                                                type="button"
                                                                className="btn btn-ghost btn-xs btn-error"
                                                                onClick={() => handleRemoveRoleFromMember(member._id)}
                                                                title="Remover insígnia"
                                                            >
                                                                <MaterialSymbol icon="close" size={16} />
                                                            </button>
                                                        </div>
                                                    ))}
                                                </div>
                                            )}
                                        </div>
                                    ) : (
                                        <form onSubmit={handleSave} className="flex flex-col gap-4 max-w-lg mx-auto">
                                            <div className="form-control">
                                                <label className="label"><span className="label-text">Nome</span></label>
                                                <input
                                                    type="text"
                                                    className="input input-bordered"
                                                    required
                                                    value={formData.name}
                                                    onChange={e => setFormData({ ...formData, name: e.target.value })}
                                                    placeholder="Ex: Direção, Presidente, Vogal..."
                                                />
                                            </div>

                                            <div className="grid grid-cols-2 gap-4">
                                                <div className="form-control">
                                                    <label className="label"><span className="label-text">Abreviatura (Curto)</span></label>
                                                    <input
                                                        type="text"
                                                        className="input input-bordered"
                                                        value={formData.short}
                                                        onChange={e => setFormData({ ...formData, short: e.target.value })}
                                                        placeholder="Ex: PRES, NEI..."
                                                    />
                                                </div>
                                                <div className="form-control">
                                                    <label className="label">
                                                        <span className="label-text">Mostrar na Lista Principal</span>
                                                        <div className="tooltip tooltip-left" data-tip="Se ativo, aparece como filtro principal na lista de membros">
                                                            <MaterialSymbol icon="info" size={16} className="text-base-content/40 cursor-help" />
                                                        </div>
                                                    </label>
                                                    <label className="label cursor-pointer justify-start gap-3 rounded-lg border border-base-content/20 p-3">
                                                        <input
                                                            type="checkbox"
                                                            className="toggle toggle-primary"
                                                            checked={formData.show}
                                                            onChange={e => setFormData({ ...formData, show: e.target.checked })}
                                                        />
                                                        <span className="label-text">{formData.show ? "Sim" : "Não"}</span>
                                                    </label>
                                                </div>
                                            </div>

                                            <div className="form-control">
                                                <label className="label"><span className="label-text">Ícone</span></label>
                                                <IconPicker
                                                    value={formData.icon || ""}
                                                    onChange={(newIcon) => setFormData({ ...formData, icon: newIcon })}
                                                    inheritedIcon={selectedNode?.icon || null}
                                                />
                                            </div>

                                            <div className="grid grid-cols-2 gap-4">
                                                <div className="form-control">
                                                    <label className="label">
                                                        <span className="label-text">Ocultar em Visualizações</span>
                                                        <div className="tooltip tooltip-left" data-tip="Oculta esta insígnia na Árvore e Tabela (mas mantém o registo)">
                                                            <MaterialSymbol icon="visibility_off" size={16} className="text-base-content/40 cursor-help" />
                                                        </div>
                                                    </label>
                                                    <label className="label cursor-pointer justify-start gap-3 rounded-lg border border-base-content/20 p-3">
                                                        <input
                                                            type="checkbox"
                                                            className="toggle toggle-error"
                                                            checked={formData.hidden || false}
                                                            onChange={e => setFormData({ ...formData, hidden: e.target.checked })}
                                                        />
                                                        <span className="label-text">{formData.hidden ? "Oculto" : "Visível"}</span>
                                                    </label>
                                                </div>

                                                <div className="form-control">
                                                    <label className="label"><span className="label-text">Formato de Ano</span></label>
                                                    <select
                                                        className="select select-bordered w-full"
                                                        value={formData.year_display_format}
                                                        onChange={e => setFormData({ ...formData, year_display_format: e.target.value })}
                                                    >
                                                        <option value="civil">Ano Civil (ex: 2023)</option>
                                                        <option value="academic">Ano Letivo (ex: 23/24)</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div className="form-control">
                                                <label className="label"><span className="label-text">Variante Feminina (Opcional)</span></label>
                                                <input
                                                    type="text"
                                                    className="input input-bordered"
                                                    value={formData.female_name}
                                                    onChange={e => setFormData({ ...formData, female_name: e.target.value })}
                                                    placeholder="Ex: Presidenta..."
                                                />
                                            </div>

                                            <div className="form-control">
                                                <label className="label"><span className="label-text text-base-content/50">Pertence a (Auto)</span></label>
                                                <div className="flex items-center gap-2 rounded-lg border border-dashed border-base-content/20 bg-base-200/50 px-4 py-3 text-sm">
                                                    {formData.super_roles ? (
                                                        <>
                                                            <MaterialSymbol icon="subdirectory_arrow_right" className="text-base-content/40" />
                                                            <span className="font-bold">
                                                                {findRoleName(roleTree, formData.super_roles) || "Desconhecido"}
                                                            </span>
                                                            <span className="text-xs opacity-50 font-mono ml-2">({formData.super_roles})</span>
                                                        </>
                                                    ) : (
                                                        <span className="italic opacity-50">Raiz (Principal)</span>
                                                    )}
                                                </div>
                                            </div>

                                            <div className="divider"></div>

                                            <div className="flex items-center gap-3">
                                                <button
                                                    type="submit"
                                                    className={classNames("btn btn-primary flex-1", { loading: submitting })}
                                                >
                                                    {isNew ? "Criar" : "Guardar Alterações"}
                                                </button>

                                                {!isNew && (
                                                    <>
                                                        <button
                                                            type="button"
                                                            className="btn btn-neutral"
                                                            onClick={handleAddChild}
                                                        >
                                                            <MaterialSymbol icon="subdirectory_arrow_right" />
                                                            Adicionar Sub-Insígnia
                                                        </button>
                                                        <button
                                                            type="button"
                                                            className="btn btn-error btn-outline"
                                                            onClick={handleDelete}
                                                            disabled={submitting}
                                                        >
                                                            <MaterialSymbol icon="delete" />
                                                        </button>
                                                    </>
                                                )}
                                                {isNew && (
                                                    <button
                                                        type="button"
                                                        className="btn btn-ghost"
                                                        onClick={() => {
                                                            setIsNew(false);
                                                            setSelectedNode(null); // Or go back to previous selection?
                                                        }}
                                                    >
                                                        Cancelar
                                                    </button>
                                                )}
                                            </div>
                                        </form>
                                    )}
                                </div>
                            </div>
                        </div>
                    </motion.div>
                </div>
            )}
        </AnimatePresence>
    );
}
