import { useState, useEffect, useCallback, useRef } from "react";
import { useForm, Controller } from "react-hook-form";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";

import { Input } from "components/form";
import MaterialSymbol from "components/MaterialSymbol";
import { CloseIcon } from "assets/icons/google";

import FamilyService from "services/FamilyService";
import { organizations } from "pages/Family/data";
import RolePickerModal from "components/RolePickerModal";

import malePic from "assets/default_profile/male.svg";
import femalePic from "assets/default_profile/female.svg";

const sexOptions = [
    { value: "M", label: "Masculino" },
    { value: "F", label: "Feminino" },
];

/**
 * Split-layout modal for creating/editing family tree members
 */
const UserForm = ({ user, isOpen, onClose, onSave, initialPatrao, onAddChild, onSwitchUser, canGoBack, onBack }) => {
    // Patrão search state
    const [patraoSearch, setPatraoSearch] = useState("");
    const [debouncedSearch, setDebouncedSearch] = useState("");
    const [patraoList, setPatraoList] = useState([]);
    const [patraoLoading, setPatraoLoading] = useState(false);
    const [patraoPage, setPatraoPage] = useState(0);
    const [hasMorePatroes, setHasMorePatroes] = useState(true);
    const [selectedPatrao, setSelectedPatrao] = useState(null);
    const patraoListRef = useRef(null);

    // Pending roles for new users
    const [pendingRoles, setPendingRoles] = useState([]);

    // User roles/insignias
    const [userRoles, setUserRoles] = useState([]);
    const [rolesLoading, setRolesLoading] = useState(false);

    // Children (Pedaços)
    const [childrenList, setChildrenList] = useState([]);

    // Courses
    const [courses, setCourses] = useState([]);

    // Role picker state
    const [showRolePicker, setShowRolePicker] = useState(false);

    // Form state
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);
    const isEdit = !!user;

    const {
        register,
        handleSubmit,
        reset,
        control,
        formState: { errors, isSubmitting },
    } = useForm({
        defaultValues: {
            name: "",
            sex: "M",
            start_year: new Date().getFullYear() - 2000,
            faina_name: "",
            nmec: null,
            course_id: null,
        },
    });

    // Load Courses
    useEffect(() => {
        if (isOpen) {
            FamilyService.getCourses({ limit: 100 })
                .then(res => setCourses(res.items || []))
                .catch(console.error);
        }
    }, [isOpen]);

    // Debounce patrão search
    useEffect(() => {
        const timer = setTimeout(() => {
            setDebouncedSearch(patraoSearch);
            setPatraoPage(0); // Reset page on search change
        }, 300);
        return () => clearTimeout(timer);
    }, [patraoSearch]);

    // Load patrão list based on search and page
    const loadPatraoList = useCallback(async (resetList = false) => {
        setPatraoLoading(true);
        try {
            const limit = 50;
            const params = { limit, skip: patraoPage * limit };
            if (debouncedSearch) {
                params.search = debouncedSearch;
            }
            const response = await FamilyService.getUsers(params);

            // Filter out self if editing
            let newItems = (response.items || []).filter(
                (u) => !isEdit || (u._id || u.id) !== (user?._id || user?.id)
            );

            // Normalize IDs
            newItems = newItems.map(u => ({ ...u, _id: u._id || u.id }));

            if (resetList || patraoPage === 0) {
                setPatraoList(newItems);
            } else {
                setPatraoList(prev => {
                    // Avoid duplicates
                    const existingIds = new Set(prev.map(p => p._id));
                    const uniqueNew = newItems.filter(p => !existingIds.has(p._id));
                    return [...prev, ...uniqueNew];
                });
            }

            setHasMorePatroes(newItems.length === limit);

        } catch (err) {
            console.error("Failed to load patrões:", err);
        } finally {
            setPatraoLoading(false);
        }
    }, [debouncedSearch, isEdit, user?._id, user?.id, patraoPage]);

    useEffect(() => {
        if (isOpen) {
            loadPatraoList();
        }
    }, [isOpen, loadPatraoList]);

    // Ensure selected patrão is in the list
    useEffect(() => {
        if (selectedPatrao && patraoList.length > 0) {
            const exists = patraoList.find(p => p._id === selectedPatrao._id);
            if (!exists) {
                setPatraoList(prev => [selectedPatrao, ...prev]);
            }
        }
    }, [selectedPatrao, patraoList]);


    // Scroll to selected Patrão
    useEffect(() => {
        if (selectedPatrao && patraoListRef.current) {
            // Need a small timeout to allow DOM to update if list changed
            setTimeout(() => {
                const selectedEl = patraoListRef.current?.querySelector(
                    `[data-id="${selectedPatrao._id}"]`
                );
                if (selectedEl) {
                    selectedEl.scrollIntoView({ block: "center", behavior: "smooth" });
                }
            }, 100);
        }
    }, [selectedPatrao?.name]); // Trigger when name/id changes (loading complete) or explicit selection

    // Load user roles when editing
    useEffect(() => {
        async function loadUserRoles() {
            if (!user?._id && !user?.id) return;
            const uid = user._id || user.id;
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
        if (isOpen && isEdit) {
            loadUserRoles();
        }
    }, [isOpen, isEdit, user?._id, user?.id]);

    // Load children (Pedaços)
    useEffect(() => {
        if (isOpen && isEdit && (user?._id || user?.id)) {
            const uid = user._id || user.id;
            FamilyService.getUserChildren(uid)
                .then(setChildrenList)
                .catch(err => {
                    console.error(err);
                    setChildrenList([]);
                });
        } else {
            setChildrenList([]);
        }
    }, [isOpen, isEdit, user?._id, user?.id]);

    // Reset form
    useEffect(() => {
        if (!isOpen) return;

        if (user) {
            reset({
                name: user.name || "",
                sex: user.sex || "M",
                start_year: user.start_year || new Date().getFullYear() - 2000,
                faina_name: user.faina_name || "",

                nmec: user.nmec || null,
                course_id: user.course_id || null,
            });
            if (user.patrao_id) {
                FamilyService.getUserById(user.patrao_id)
                    .then((p) => {
                        // Normalize ID
                        const pNorm = { ...p, _id: p._id || p.id };
                        setSelectedPatrao(pNorm);
                    })
                    .catch(() =>
                        setSelectedPatrao({
                            _id: user.patrao_id,
                            name: `ID ${user.patrao_id}`,
                        })
                    );
            } else {
                setSelectedPatrao(null);
            }
        } else {
            reset({
                name: "",
                sex: "M",
                start_year: new Date().getFullYear() - 2000,
                faina_name: "",

                nmec: null,
                course_id: null,
            });

            // Handle initialPatrao for new "pedaços"
            if (initialPatrao) {
                const pNorm = { ...initialPatrao, _id: initialPatrao._id || initialPatrao.id };
                setSelectedPatrao(pNorm);
            } else {
                setSelectedPatrao(null);
            }

            setUserRoles([]);
            setPendingRoles([]);
        }

        setPatraoSearch("");
        setPatraoPage(0);
        setError(null);
        setShowRolePicker(false);
    }, [user, reset, isOpen]);

    const processSubmit = async (data, shouldClose = true) => {
        setLoading(true);
        setError(null);
        try {
            const payload = {
                ...data,
                patrao_id: selectedPatrao?._id || null,
                faina_name: data.faina_name || null,
                nmec: data.nmec || null,
                course_id: data.course_id ? parseInt(data.course_id) : null,
            };

            const uid = user?._id || user?.id;

            if (isEdit) {
                await FamilyService.updateUser(uid, payload);
            } else {
                const newUser = await FamilyService.createUser(payload);
                // Process pending roles
                if (pendingRoles.length > 0) {
                    await Promise.all(pendingRoles.map(role =>
                        FamilyService.assignRole({
                            user_id: newUser._id || newUser.id,
                            role_id: role.role_id,
                            year: role.year
                        })
                    ));
                }
            }
            onSave?.();

            if (shouldClose) {
                onClose();
            } else {
                // Reset form for next entry but keep Patrão context
                reset({
                    name: "",
                    sex: "M",
                    start_year: data.start_year, // Keep same year often useful
                    faina_name: "",
                    nmec: null,
                    course_id: data.course_id, // Keep course often useful
                });
                // Clear roles/children
                setPendingRoles([]);
                setUserRoles([]);
                setChildrenList([]);
                // selectedPatrao remains correct

                // Show brief success feedback if possible, or just ready state
                // (Optional: add toast here if system had one)
            }
        } catch (err) {
            setError(err.response?.data?.detail || err.message || "Erro ao guardar");
        } finally {
            setLoading(false);
        }
    };

    const onSubmit = (data) => processSubmit(data, true);

    const handleRemoveRole = async (roleId) => {
        if (!isEdit) {
            setPendingRoles(prev => prev.filter(r => r.tempId !== roleId));
            return;
        }
        try {
            await FamilyService.removeRole(roleId);
            setUserRoles((prev) => prev.filter((r) => r._id !== roleId));
        } catch (err) {
            alert(err.response?.data?.detail || "Erro ao remover insígnia");
        }
    };

    const handleAddRoleCallback = async (selectedNode, roleYear) => {
        // For new users, add to pending list locally
        if (!isEdit) {
            setPendingRoles(prev => [...prev, {
                tempId: Date.now(), // temp ID for UI
                role_id: selectedNode._id,
                year: roleYear,
                org_name: selectedNode.short || selectedNode.name, // Approximate display
                name: selectedNode.name
            }]);
            return;
        }

        try {
            await FamilyService.assignRole({
                user_id: user._id || user.id,
                role_id: selectedNode._id,
                year: roleYear,
            });
            const response = await FamilyService.getRolesForUser(user._id || user.id);
            setUserRoles(response.items || []);
        } catch (err) {
            alert(err.response?.data?.detail || "Erro ao adicionar insígnia");
        }
    };

    // Combine roles for display
    const displayRoles = isEdit ? userRoles : pendingRoles;

    return (
        <AnimatePresence>
            {isOpen && (
                <>
                    {/* Backdrop */}
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        className="fixed inset-0 z-40 bg-black/60 backdrop-blur-sm"
                        onClick={onClose}
                    />

                    {/* Modal Wrapper - Flexbox Centering */}
                    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
                        <motion.div
                            initial={{ opacity: 0, scale: 0.95, y: 20 }}
                            animate={{ opacity: 1, scale: 1, y: 0 }}
                            exit={{ opacity: 0, scale: 0.95, y: 20 }}
                            className="flex h-[85vh] w-full max-w-5xl flex-col overflow-hidden rounded-2xl border border-base-content/10 bg-base-200 shadow-2xl"
                            onClick={(e) => e.stopPropagation()}
                        >
                            <div className="flex min-h-0 flex-1 flex-col lg:flex-row">
                                {/* Left Panel - Patrão Picker */}
                                <div className="flex h-1/3 w-full flex-shrink-0 flex-col border-b border-base-content/10 bg-base-300/50 lg:h-auto lg:w-80 lg:border-b-0 lg:border-r">
                                    <div className="border-b border-base-content/10 p-4">
                                        <h3 className="mb-3 text-lg font-semibold">Selecionar Patrão</h3>
                                        <div className="relative">
                                            <MaterialSymbol
                                                icon="search"
                                                size={18}
                                                className="absolute left-3 top-1/2 -translate-y-1/2 text-base-content/50"
                                            />
                                            <input
                                                type="text"
                                                placeholder="Nome, ID ou nmec..."
                                                className="input input-bordered input-sm w-full pl-9"
                                                value={patraoSearch}
                                                onChange={(e) => setPatraoSearch(e.target.value)}
                                            />
                                        </div>
                                    </div>

                                    {/* Patrão List */}
                                    <div className="flex-1 overflow-y-auto" ref={patraoListRef}>
                                        <button
                                            type="button"
                                            className={classNames(
                                                "flex w-full items-center gap-3 px-4 py-3 text-left transition-colors hover:bg-base-300",
                                                {
                                                    "bg-primary/10 text-primary": selectedPatrao === null,
                                                }
                                            )}
                                            onClick={() => setSelectedPatrao(null)}
                                        >
                                            <div className="flex h-10 w-10 items-center justify-center rounded-full bg-base-300">
                                                <MaterialSymbol icon="block" size={20} />
                                            </div>
                                            <div>
                                                <div className="font-medium">Sem Patrão</div>
                                                <div className="text-sm text-base-content/60">
                                                    Membro raiz
                                                </div>
                                            </div>
                                            {selectedPatrao === null && (
                                                <MaterialSymbol
                                                    icon="check_circle"
                                                    size={20}
                                                    className="ml-auto text-primary"
                                                />
                                            )}
                                        </button>

                                        {patraoPage === 0 && patraoLoading ? (
                                            <div className="flex justify-center py-8">
                                                <span className="loading loading-spinner loading-sm"></span>
                                            </div>
                                        ) : (
                                            <>
                                                {patraoList.map((p) => (
                                                    <button
                                                        key={p._id}
                                                        data-id={p._id}
                                                        type="button"
                                                        className={classNames(
                                                            "flex w-full items-center gap-3 px-4 py-3 text-left transition-colors hover:bg-base-300",
                                                            { "bg-primary/10": selectedPatrao?._id === p._id }
                                                        )}
                                                        onClick={() => setSelectedPatrao(p)}
                                                    >
                                                        <div className="avatar">
                                                            <div className="h-10 w-10 rounded-full bg-base-300">
                                                                <img
                                                                    src={
                                                                        p.image ||
                                                                        (p.sex === "F" ? femalePic : malePic)
                                                                    }
                                                                    alt=""
                                                                />
                                                            </div>
                                                        </div>
                                                        <div className="min-w-0 flex-1">
                                                            <div className="truncate font-medium">{p.name}</div>
                                                            <div className="text-sm text-base-content/60">
                                                                {p.start_year ? 2000 + p.start_year : "-"}
                                                                {p.nmec && ` • ${p.nmec}`}
                                                            </div>
                                                        </div>
                                                        {selectedPatrao?._id === p._id && (
                                                            <MaterialSymbol
                                                                icon="check_circle"
                                                                size={20}
                                                                className="text-primary"
                                                            />
                                                        )}
                                                    </button>
                                                ))}

                                                {/* Load More / Pagination */}
                                                {hasMorePatroes && (
                                                    <div className="p-2">
                                                        <button
                                                            className={classNames("btn btn-ghost btn-sm w-full", { loading: patraoLoading })}
                                                            onClick={() => setPatraoPage(p => p + 1)}
                                                        >
                                                            Carregar mais...
                                                        </button>
                                                    </div>
                                                )}
                                            </>
                                        )}
                                    </div>
                                </div>

                                {/* Right Panel - Form */}
                                <div className="flex min-w-0 flex-1 flex-col bg-base-100">
                                    {/* Header */}
                                    <div className="flex items-center justify-between border-b border-base-content/10 p-4">
                                        <h3 className="text-lg font-bold flex items-center gap-2">
                                            {canGoBack && (
                                                <button
                                                    type="button"
                                                    className="btn btn-ghost btn-sm btn-circle"
                                                    onClick={onBack}
                                                >
                                                    <MaterialSymbol icon="arrow_back" size={20} />
                                                </button>
                                            )}
                                            {isEdit ? "Editar Membro" : "Novo Pedaço"}
                                        </h3>
                                        <button
                                            type="button"
                                            className="btn btn-ghost btn-sm btn-circle"
                                            onClick={onClose}
                                        >
                                            <CloseIcon />
                                        </button>
                                    </div>

                                    {/* Form Content */}
                                    <form
                                        onSubmit={handleSubmit(onSubmit)}
                                        className="flex min-h-0 flex-1 flex-col"
                                    >
                                        <div className="flex-1 space-y-6 overflow-y-auto p-6">
                                            {/* Name */}
                                            <Input
                                                label="Nome Completo"
                                                placeholder="Ex: João Silva"
                                                error={errors.name}
                                                {...register("name", {
                                                    required: { value: true, message: "Nome é obrigatório" },
                                                })}
                                            />

                                            {/* Sex + Year Row */}
                                            <div className="grid grid-cols-2 gap-4">
                                                <div>
                                                    <label className="label">
                                                        <span className="label-text">Sexo</span>
                                                    </label>
                                                    <Controller
                                                        name="sex"
                                                        control={control}
                                                        rules={{ required: "Sexo é obrigatório" }}
                                                        render={({ field }) => (
                                                            <div className="flex gap-2">
                                                                {sexOptions.map((opt) => (
                                                                    <button
                                                                        key={opt.value}
                                                                        type="button"
                                                                        className={classNames(
                                                                            "btn btn-sm flex-1",
                                                                            field.value === opt.value
                                                                                ? "btn-primary"
                                                                                : "btn-outline btn-neutral"
                                                                        )}
                                                                        onClick={() => field.onChange(opt.value)}
                                                                    >
                                                                        <MaterialSymbol
                                                                            icon={opt.value === "M" ? "male" : "female"}
                                                                            size={18}
                                                                        />
                                                                        {opt.label}
                                                                    </button>
                                                                ))}
                                                            </div>
                                                        )}
                                                    />
                                                </div>

                                                <Input
                                                    label="Ano de Entrada (Civil | Letivo)"
                                                    type="number"
                                                    placeholder="Ex: 24 (= 2024 | 24/25)"
                                                    error={errors.start_year}
                                                    {...register("start_year", {
                                                        required: { value: true, message: "Obrigatório" },
                                                        min: { value: 0, message: "Inválido" },
                                                        max: { value: 99, message: "2 dígitos" },
                                                        valueAsNumber: true,
                                                    })}
                                                />
                                            </div>

                                            {/* Faina Name + Nmec Row */}
                                            <div className="grid grid-cols-2 gap-4">
                                                <Input
                                                    label="Nome de Faina"
                                                    placeholder="Auto se vazio"
                                                    error={errors.faina_name}
                                                    {...register("faina_name")}
                                                />
                                                <Input
                                                    label="NMEC (Opcional)"
                                                    type="number"
                                                    {...register("nmec", { valueAsNumber: true })}
                                                />
                                            </div>

                                            {/* Course Selector */}
                                            <div className="form-control">
                                                <label className="label"><span className="label-text">Curso</span></label>
                                                <select
                                                    className="select select-bordered w-full"
                                                    {...register("course_id")}
                                                >
                                                    <option value="">Sem Curso</option>
                                                    {courses.map(course => (
                                                        <option key={course._id || course.id} value={course._id || course.id}>
                                                            {course.short} - {course.name}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>

                                            {/* Insignias Section - Show for both Edit and Create */}
                                            <div>
                                                <div className="mb-3 flex items-center justify-between border-t border-base-content/10 pt-4">
                                                    <h4 className="font-bold">Insígnias</h4>
                                                    <button
                                                        type="button"
                                                        className="btn btn-primary btn-xs gap-1"
                                                        onClick={() => setShowRolePicker(true)}
                                                    >
                                                        <MaterialSymbol icon="add" size={16} />
                                                        Adicionar
                                                    </button>
                                                </div>

                                                <div className="min-h-[60px] rounded-xl border border-dashed border-base-content/20 bg-base-200/50 p-4">
                                                    {rolesLoading ? (
                                                        <div className="flex justify-center py-2">
                                                            <span className="loading loading-spinner loading-sm"></span>
                                                        </div>
                                                    ) : displayRoles.length === 0 ? (
                                                        <p className="text-center text-sm text-base-content/50">
                                                            Nenhuma insígnia atribuída
                                                        </p>
                                                    ) : (
                                                        <div className="flex flex-wrap gap-3">
                                                            {displayRoles.map((role) => (
                                                                <div
                                                                    key={role._id || role.tempId}
                                                                    className="flex items-center gap-2 rounded-lg bg-base-100 p-2 shadow-sm ring-1 ring-base-content/10"
                                                                >
                                                                    {/* Try to show icon if available - check API icon first, then static map */}
                                                                    {(role.icon || (role.org_name && organizations[role.org_name])) && (
                                                                        <img src={role.icon || organizations[role.org_name]?.insignia} alt="" className="h-6 w-6 object-contain" />
                                                                    )}
                                                                    <div className="flex flex-col">
                                                                        <span className="text-xs font-bold leading-tight">
                                                                            {role.role_name || role.name || role.org_name || role.role_id}
                                                                        </span>
                                                                        <span className="text-[10px] text-base-content/60">Ano {role.year}</span>
                                                                    </div>
                                                                    <button
                                                                        type="button"
                                                                        className="ml-1 rounded-full p-1 text-base-content/40 hover:bg-error/10 hover:text-error"
                                                                        onClick={() => handleRemoveRole(role._id || role.tempId)}
                                                                    >
                                                                        <MaterialSymbol icon="close" size={14} />
                                                                    </button>
                                                                </div>
                                                            ))}
                                                        </div>
                                                    )}
                                                </div>
                                            </div>

                                            {/* Pedaços (Children) Section */}
                                            {isEdit && (
                                                <div className="mt-4 border-t border-base-content/10 pt-4">
                                                    <div className="mb-3 flex items-center justify-between">
                                                        <h4 className="font-bold flex items-center gap-2">
                                                            <MaterialSymbol icon="face" size={20} className="text-primary" />
                                                            Pedaços
                                                            <span className="badge badge-sm badge-ghost">{childrenList.length}</span>
                                                        </h4>
                                                        <button
                                                            type="button"
                                                            className="btn btn-outline btn-primary btn-xs gap-1"
                                                            onClick={() => onAddChild(user)}
                                                        >
                                                            <MaterialSymbol icon="person_add" size={16} />
                                                            Adicionar
                                                        </button>
                                                    </div>

                                                    {childrenList.length > 0 ? (
                                                        <div className="grid grid-cols-1 gap-2">
                                                            {childrenList.map(child => (
                                                                <div
                                                                    key={child._id || child.id}
                                                                    className="flex items-center gap-3 rounded-lg border border-base-content/10 bg-base-100 p-2 hover:bg-base-200 cursor-pointer transition-colors"
                                                                    onClick={() => onSwitchUser(child)}
                                                                >
                                                                    <div className="avatar h-8 w-8 rounded-full bg-base-300">
                                                                        <img src={child.image || (child.sex === 'F' ? femalePic : malePic)} alt="" className="rounded-full object-cover" />
                                                                    </div>
                                                                    <div className="flex-1 min-w-0">
                                                                        <div className="font-bold text-sm truncate">{child.name}</div>
                                                                        <div className="text-xs text-base-content/60 font-mono">
                                                                            Ano {child.start_year > 100 ? child.start_year % 100 : child.start_year}
                                                                        </div>
                                                                    </div>
                                                                    <MaterialSymbol icon="chevron_right" className="text-base-content/30" />
                                                                </div>
                                                            ))}
                                                        </div>
                                                    ) : (
                                                        <div className="text-center py-4 bg-base-200/30 rounded-lg border border-dashed border-base-content/10 text-sm text-base-content/50">
                                                            Não tem pedaços registados
                                                        </div>
                                                    )}
                                                </div>
                                            )}

                                            {/* Error message */}
                                            {error && (
                                                <div className="alert alert-error text-sm">
                                                    <MaterialSymbol icon="error" size={20} />
                                                    <span>{error}</span>
                                                </div>
                                            )}
                                        </div>

                                        {/* Footer */}
                                        <div className="flex flex-shrink-0 justify-end gap-3 border-t border-base-content/10 bg-base-200/50 px-6 py-4">
                                            <button
                                                type="button"
                                                className="btn btn-ghost"
                                                onClick={onClose}
                                            >
                                                Cancelar
                                            </button>

                                            {!isEdit && (
                                                <button
                                                    type="button"
                                                    className={classNames("btn btn-secondary btn-outline", {
                                                        loading: isSubmitting || loading,
                                                    })}
                                                    disabled={isSubmitting || loading}
                                                    onClick={handleSubmit((d) => processSubmit(d, false))}
                                                >
                                                    Criar e Adicionar Outro
                                                </button>
                                            )}

                                            <button
                                                type="button"
                                                className={classNames("btn btn-primary min-w-[120px]", {
                                                    loading: isSubmitting || loading,
                                                })}
                                                disabled={isSubmitting || loading}
                                                onClick={handleSubmit(onSubmit)}
                                            >
                                                {isEdit ? "Guardar" : "Criar Pedaço"}
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            {/* Role Picker Modal */}
                            <RolePickerModal
                                isOpen={showRolePicker}
                                onClose={() => setShowRolePicker(false)}
                                onSelect={handleAddRoleCallback}
                            />
                        </motion.div>
                    </div >
                </>
            )}
        </AnimatePresence >
    );
};

export default UserForm;
