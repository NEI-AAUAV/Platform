import { useState, useEffect } from "react";
import { createPortal } from "react-dom";
import { useForm, Controller } from "react-hook-form";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";

import { Input } from "components/form";
import MaterialSymbol from "components/MaterialSymbol";
import { CloseIcon } from "assets/icons/google";
import { useToast } from "components/ui/use-toast";
import { Toaster } from "components/ui/toaster";
import { useBodyScrollLock } from "components/Modal";

import FamilyService from "services/FamilyService";
import { PatraoPicker, ChildrenList, RoleDisplay, RolePickerModal } from "components/Family";
import { getErrorMessage, isErrorStatus } from "utils/error";

import Avatar from "components/Avatar";

const sexOptions = [
    { value: "M", label: "Masculino" },
    { value: "F", label: "Feminino" },
];

/**
 * Split-layout modal for creating/editing family tree members
 */
const UserForm = ({ user, isOpen, onClose, onSave, onDelete, initialPatrao, onAddChild, onSwitchUser, canGoBack, onBack }) => {
    const { toast } = useToast();
    // Check if image upload is available (R2 configured) by probing backend on mount
    const [imageUploadAvailable, setImageUploadAvailable] = useState(true);
    useEffect(() => {
        if (!isOpen) return;
        // Try a HEAD request to the upload endpoint to check if enabled
        const check = async () => {
            try {
                // Use a dummy user id (1) and expect 405 or 401 if enabled, 503 if not
                await FamilyService.updateUserImage(1, undefined, { remove: false });
            } catch (err) {
                if (isErrorStatus(err, 503)) {
                    setImageUploadAvailable(false);
                } else {
                    setImageUploadAvailable(true);
                }
            }
        };
        check();
    }, [isOpen]);

    // Patrão state
    const [selectedPatrao, setSelectedPatrao] = useState(null);

    // Pending roles for new users
    const [pendingRoles, setPendingRoles] = useState([]);

    // Image state
    const [preview, setPreview] = useState(null);
    const [imageFile, setImageFile] = useState(null);
    const [removeImage, setRemoveImage] = useState(false);
    const [imageUpdating, setImageUpdating] = useState(false);

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
    const [deleting, setDeleting] = useState(false);
    const [error, setError] = useState(null);

    // Lock body scroll when modal is open
    useBodyScrollLock(isOpen);
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
            end_year: null,
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
        if (isOpen && isEdit) {
            loadUserRoles();
        }
    }, [isOpen, isEdit, user?.id]);

    // Load children (Pedaços)
    useEffect(() => {
        if (isOpen && isEdit && user?.id) {
            const uid = user.id;
            FamilyService.getUserChildren(uid)
                .then(setChildrenList)
                .catch(err => {
                    console.error(err);
                    setChildrenList([]);
                });
        } else {
            setChildrenList([]);
        }
    }, [isOpen, isEdit, user?.id]);

    // Reset form
    useEffect(() => {
        if (!isOpen) return;

        if (user) {
            reset({
                name: user.name || "",
                sex: user.sex || "M",
                start_year: user.start_year ?? (new Date().getFullYear() - 2000),
                end_year: user.end_year ?? null,
                faina_name: user.faina_name || "",

                nmec: user.nmec || null,
                course_id: user.course_id || null,
            });
            if (user.patrao_id) {
                FamilyService.getUserById(user.patrao_id)
                    .then((p) => {
                        setSelectedPatrao(p);
                    })
                    .catch(() =>
                        setSelectedPatrao({
                            id: user.patrao_id,
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
                end_year: null,
                faina_name: "",

                nmec: null,
                course_id: null,
            });

            // Handle initialPatrao for new "pedaços"
            if (initialPatrao) {
                setSelectedPatrao(initialPatrao);
            } else {
                setSelectedPatrao(null);
            }

            setUserRoles([]);
            setPendingRoles([]);
        }

        setError(null);
        setShowRolePicker(false);
    }, [user, reset, isOpen]);

    const processSubmit = async (data, shouldClose = true) => {
        setLoading(true);
        setError(null);
        try {
            const payload = {
                ...data,
                patrao_id: selectedPatrao?.id || null,
                faina_name: data.faina_name || null,
                nmec: data.nmec || null,
                course_id: data.course_id ? parseInt(data.course_id) : null,
            };

            const uid = user?.id;

            if (isEdit) {
                await FamilyService.updateUser(uid, payload);
            } else {
                const newUser = await FamilyService.createUser(payload);
                // Process pending roles
                if (pendingRoles.length > 0) {
                    await Promise.all(pendingRoles.map(role =>
                        FamilyService.assignRole({
                            user_id: newUser.id,
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
                    end_year: null,
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
            const errorMessage = getErrorMessage(err, "Erro ao guardar");
            console.error("[UserForm] Save error:", err.response?.data || err);
            setError(errorMessage);
        } finally {
            setLoading(false);
        }
    };

    const onSubmit = (data) => processSubmit(data, true);

    const handleImageInputChange = (e) => {
        const file = e.target.files?.[0] || null;
        if (!file) {
            setImageFile(null);
            setPreview(null);
            return;
        }
        // Basic size validation (2MB)
        const maxSize = 2 * 1024 * 1024;
        if (file.size > maxSize) {
            alert("Imagem demasiado grande (máx. 2MB)");
            e.target.value = "";
            setImageFile(null);
            setPreview(null);
            return;
        }
        setRemoveImage(false);
        setImageFile(file);
        setPreview(URL.createObjectURL(file));
    };

    const handleUpdatePhoto = async () => {
        if (!isEdit || (!imageFile && !removeImage)) return;
        const uid = user?.id;
        setImageUpdating(true);
        setError(null);
        try {
            const updated = await FamilyService.updateUserImage(uid, imageFile || undefined, { remove: !!removeImage });
            // Clear preview and file selection
            setPreview(null);
            setImageFile(null);
            setRemoveImage(false);

            // Update the local user object
            if (user && updated?.image !== undefined) {
                user.image = updated.image;
            }

            // Notify parent so lists refresh
            await onSave?.();

            toast({
                title: removeImage ? "Foto removida" : "Foto atualizada",
                description: removeImage ? "A foto do membro foi removida." : "Upload concluído com sucesso.",
            });
        } catch (err) {
            const errorMessage = getErrorMessage(err, "Erro ao atualizar foto");
            toast({
                title: "Erro ao atualizar foto",
                description: errorMessage,
                variant: "destructive",
            });
        } finally {
            setImageUpdating(false);
        }
    };

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
                tempId: Date.now(), // temp ID for UI
                role_id: selectedNode.id,
                year: roleYear,
                org_name: selectedNode.short || selectedNode.name, // Approximate display
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

    // Combine roles for display
    const displayRoles = isEdit ? userRoles : pendingRoles;

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

                    {/* Modal Wrapper - Flexbox Centering */}
                    <div className="fixed inset-0 z-[110] flex items-center justify-center p-4">
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
                                    <PatraoPicker
                                        selectedPatrao={selectedPatrao}
                                        onSelect={setSelectedPatrao}
                                        excludeIds={isEdit && user?.id ? [user.id] : []}
                                    />
                                </div>

                                {/* Right Panel - Form */}
                                <div className="flex min-h-0 min-w-0 flex-1 flex-col overflow-hidden bg-base-100">
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
                                        className="flex min-h-0 flex-1 flex-col overflow-hidden"
                                    >
                                        <div className="min-h-0 flex-1 space-y-6 overflow-y-auto p-6" style={{ WebkitOverflowScrolling: 'touch' }}>
                                            {/* Photo Section */}
                                            {isEdit && (
                                                <div className="rounded-xl border border-base-content/10 bg-base-200/50 p-4">
                                                    <div className="mb-3 flex items-center justify-between">
                                                        <h4 className="font-bold flex items-center gap-2">
                                                            <MaterialSymbol icon="photo_camera" size={18} />
                                                            Foto do Membro
                                                        </h4>
                                                        <span className="text-xs text-base-content/50">Máx. 2MB • redimensiona para 1200px</span>
                                                    </div>
                                                    <div className="flex items-center gap-4">
                                                        <div className="avatar">
                                                            <div className="h-16 w-16 rounded-full ring-2 ring-offset-2 ring-offset-base-100 ring-base-content/10 bg-base-300 overflow-hidden">
                                                                <Avatar
                                                                    image={preview ?? user?.image}
                                                                    sex={user?.sex}
                                                                    alt={user?.name || 'preview'}
                                                                    className="h-16 w-16 object-cover"
                                                                />
                                                            </div>
                                                        </div>
                                                        {imageUploadAvailable ? (
                                                            <>
                                                                <div className="flex-1 flex flex-col gap-2">
                                                                    <input
                                                                        type="file"
                                                                        accept="image/*"
                                                                        className="file-input file-input-bordered file-input-sm w-full max-w-xs"
                                                                        onChange={handleImageInputChange}
                                                                        disabled={removeImage}
                                                                    />
                                                                    <label className="label cursor-pointer w-fit">
                                                                        <input
                                                                            type="checkbox"
                                                                            className="checkbox checkbox-sm mr-2"
                                                                            checked={removeImage}
                                                                            onChange={(e) => {
                                                                                setRemoveImage(e.target.checked);
                                                                                if (e.target.checked) {
                                                                                    setImageFile(null);
                                                                                    setPreview(null);
                                                                                }
                                                                            }}
                                                                        />
                                                                        <span className="label-text">Remover foto</span>
                                                                    </label>
                                                                </div>
                                                                <div>
                                                                    <button
                                                                        type="button"
                                                                        className={classNames("btn btn-primary btn-sm", { loading: imageUpdating })}
                                                                        disabled={imageUpdating || (!imageFile && !removeImage)}
                                                                        onClick={handleUpdatePhoto}
                                                                    >
                                                                        Guardar Foto
                                                                    </button>
                                                                </div>
                                                            </>
                                                        ) : (
                                                            <div className="flex-1 flex flex-col gap-2">
                                                                <div className="flex items-center gap-2 rounded-lg bg-base-300/60 px-3 py-2 text-base-content/70 text-sm border border-dashed border-base-content/10">
                                                                    <MaterialSymbol icon="cloud_off" size={18} className="opacity-60" />
                                                                    <span>Upload de fotos desativado (sem armazenamento configurado)</span>
                                                                </div>
                                                            </div>
                                                        )}
                                                    </div>
                                                </div>
                                            )}
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
                                            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                                <div>
                                                    <div className="label">
                                                        <span className="label-text">Sexo</span>
                                                    </div>
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

                                            {/* End Year */}
                                            <Input
                                                label="Ano de Saída (Opcional)"
                                                type="number"
                                                placeholder="Deixar vazio se ainda ativo"
                                                error={errors.end_year}
                                                {...register("end_year", {
                                                    min: { value: 0, message: "Inválido" },
                                                    max: { value: 99, message: "2 dígitos" },
                                                    valueAsNumber: true,
                                                    setValueAs: (v) => (v === "" || Number.isNaN(v) ? null : v),
                                                })}
                                            />

                                            {/* Faina Name + Nmec Row */}
                                            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
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
                                                <label className="label" htmlFor="course-select"><span className="label-text">Curso</span></label>
                                                <select
                                                    id="course-select"
                                                    className="select select-bordered w-full"
                                                    {...register("course_id")}
                                                >
                                                    <option value="">Sem Curso</option>
                                                    {courses.map(course => (
                                                        <option key={course.id} value={course.id}>
                                                            {course.short} - {course.name}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>

                                            {/* Insignias Section - Show for both Edit and Create */}
                                            <RoleDisplay
                                                roles={displayRoles}
                                                loading={rolesLoading}
                                                onAdd={() => setShowRolePicker(true)}
                                                onRemove={handleRemoveRole}
                                            />

                                            {/* Pedaços (Children) Section */}
                                            {isEdit && (
                                                <ChildrenList
                                                    children={childrenList}
                                                    onAddChild={() => onAddChild(user)}
                                                    onSelectChild={onSwitchUser}
                                                />
                                            )}

                                        </div>

                                        {/* Error message - OUTSIDE scroll area for visibility */}
                                        {error && (
                                            <div className="mx-6 mb-2 alert alert-error text-sm shadow-lg">
                                                <MaterialSymbol icon="error" size={20} />
                                                <span>{error}</span>
                                            </div>
                                        )}

                                        {/* Footer */}
                                        <div className="flex flex-shrink-0 items-center gap-3 border-t border-base-content/10 bg-base-200/50 px-6 py-4">
                                            {/* Delete button - left side */}
                                            {isEdit && onDelete && (
                                                <button
                                                    type="button"
                                                    className={classNames("btn btn-error btn-outline gap-1", {
                                                        loading: deleting,
                                                    })}
                                                    disabled={deleting || isSubmitting || loading}
                                                    onClick={async () => {
                                                        if (window.confirm(`Tens a certeza que queres eliminar "${user?.name || 'este membro'}"?`)) {
                                                            setDeleting(true);
                                                            try {
                                                                await onDelete(user);
                                                            } finally {
                                                                setDeleting(false);
                                                            }
                                                        }
                                                    }}
                                                >
                                                    <MaterialSymbol icon="delete" size={18} />
                                                    Eliminar
                                                </button>
                                            )}

                                            <div className="flex-1" />

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
                    
                    {/* Toast Container - Inside Modal Portal */}
                    <Toaster />
                </>
            )}
        </AnimatePresence >,
        document.body
    );
};

export default UserForm;
