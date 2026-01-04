import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";
import MaterialSymbol from "components/MaterialSymbol";
import { CloseIcon } from "assets/icons/google";
import FamilyService from "services/FamilyService";
import { organizations } from "pages/Family/data";

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
            setSelectedNode(null);
            setFormData({ name: "", short: "", female_name: "", show: false, super_roles: "", icon: "", hidden: false });
            setIsNew(false);
        }
    }, [isOpen]);

    // Select a node to edit
    const handleSelectNode = (node) => {
        setSelectedNode(node);
        setIsNew(false);
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

                            {/* Main Content: Form */}
                            <div className="flex flex-1 flex-col">
                                <div className="flex items-center justify-between border-b border-base-content/10 p-4">
                                    <h3 className="text-lg font-bold">
                                        {isNew
                                            ? (formData.super_roles ? "Nova Sub-Insígnia" : "Nova Insígnia Raiz")
                                            : (selectedNode ? "Editar Insígnia" : "Selecione uma Insígnia")
                                        }
                                    </h3>
                                    <button className="btn btn-ghost btn-sm btn-circle" onClick={onClose}>
                                        <CloseIcon />
                                    </button>
                                </div>

                                <div className="flex-1 overflow-y-auto p-6">
                                    {!selectedNode && !isNew ? (
                                        <div className="flex h-full flex-col items-center justify-center text-base-content/30 text-center">
                                            <MaterialSymbol icon="badge" size={48} className="mb-2 opacity-50" />
                                            <p>Selecione um item da lista à esquerda<br />ou crie uma nova raiz</p>
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
                                                <label className="label"><span className="label-text">Ícone (URL / Caminho)</span></label>
                                                <div className="flex gap-2">
                                                    <input
                                                        type="text"
                                                        className="input input-bordered flex-1"
                                                        value={formData.icon || ""}
                                                        onChange={e => setFormData({ ...formData, icon: e.target.value })}
                                                        placeholder="Ex: /assets/icons/my-icon.svg"
                                                    />
                                                    {formData.icon && (
                                                        <div className="h-12 w-12 flex-shrink-0 rounded-lg border border-base-content/10 bg-base-200 p-2">
                                                            <img src={formData.icon} alt="" className="h-full w-full object-contain" onError={(e) => e.target.style.display = 'none'} />
                                                        </div>
                                                    )}
                                                </div>
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
