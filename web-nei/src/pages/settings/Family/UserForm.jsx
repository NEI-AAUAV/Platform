
import { useState, useEffect } from "react";
import { createPortal } from "react-dom";
import { useForm, Controller } from "react-hook-form";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";

import { Input } from "components/form";
import MaterialSymbol from "components/MaterialSymbol";
import { CloseIcon } from "assets/icons/google";
import { Toaster } from "components/ui/toaster";
import { useToast } from "components/ui/use-toast";
import UserPhotoUpload from "./UserPhotoUpload";
import UserRolesManager from "./UserRolesManager";
import { useUserChildren, useCourses } from "hooks/useFamilyData";
import FamilyService from "services/FamilyService";
import { useBodyScrollLock } from "components/Modal";
import { PatraoPicker, ChildrenList } from "components/Family";
import { getErrorMessage } from "utils/error";

const sexOptions = [
    { value: "M", label: "Masculino" },
    { value: "F", label: "Feminino" },
];

/**
 * Split-layout modal for creating/editing family tree members
 */
const UserForm = ({ user, isOpen, onClose, onSave, onDelete, initialPatrao, onAddChild, onSwitchUser, canGoBack, onBack }) => {
    const { toast } = useToast();
    // Patrão state
    const [selectedPatrao, setSelectedPatrao] = useState(null);

    // Pending roles for new users
    const [pendingRoles, setPendingRoles] = useState([]);

    // Children (Pedaços)
    const isEdit = !!user;
    const { children: childrenList } = useUserChildren(isOpen && isEdit ? user?.id : null);

    // Courses
    const { courses } = useCourses();

    // Form state
    const [loading, setLoading] = useState(false);
    const [deleting, setDeleting] = useState(false);
    const [error, setError] = useState(null);

    // Image state lifted for submission
    const [imageFile, setImageFile] = useState(null);
    const [uploadKey, setUploadKey] = useState(0);

    // Lock body scroll when modal is open
    useBodyScrollLock(isOpen);

    const {
        register,
        handleSubmit,
        reset,
        control,
        watch,
        formState: { errors },
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

            setPendingRoles([]);
        }

        setError(null);
        setImageFile(null);
        setUploadKey(prev => prev + 1);
    }, [user, reset, isOpen, initialPatrao]);

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

                toast({
                    title: "Membro atualizado",
                    description: `Os dados de ${user?.name || "membro"} foram atualizados com sucesso.`,
                });
            } else {
                const newUser = await FamilyService.createUser(payload);

                // Upload photo if provided
                if (imageFile) {
                    try {
                        await FamilyService.updateUserImage(newUser.id, imageFile);
                    } catch (photoErr) {
                        console.error("Failed to upload photo for new user:", photoErr);
                    }
                }

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

                toast({
                    title: "Membro criado",
                    description: `O membro ${newUser.name} foi criado com sucesso.`,
                });
            }
            onSave?.();

            if (shouldClose) {
                onClose();
            } else {
                reset({
                    name: "",
                    sex: "M",
                    start_year: data.start_year,
                    end_year: null,
                    faina_name: "",
                    nmec: null,
                    course_id: data.course_id,
                });
                setPendingRoles([]);
                setImageFile(null);
                setUploadKey(prev => prev + 1);
            }
        } catch (err) {
            const errorMessage = getErrorMessage(err, "Erro ao guardar");
            setError(errorMessage);
        } finally {
            setLoading(false);
        }
    };

    const onSubmit = (data) => processSubmit(data, true);

    return createPortal(
        <AnimatePresence>
            {isOpen && (
                <>
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        className="fixed inset-0 z-[100] bg-black/60 backdrop-blur-sm"
                        onClick={onClose}
                    />

                    <div className="fixed inset-0 z-[110] flex items-center justify-center p-4">
                        <motion.div
                            initial={{ opacity: 0, scale: 0.95, y: 20 }}
                            animate={{ opacity: 1, scale: 1, y: 0 }}
                            exit={{ opacity: 0, scale: 0.95, y: 20 }}
                            className="flex h-[85vh] w-full max-w-5xl flex-col overflow-hidden rounded-2xl border border-base-content/10 bg-base-200 shadow-2xl"
                            onClick={(e) => e.stopPropagation()}
                        >
                            <div className="flex min-h-0 flex-1 flex-col lg:flex-row">
                                <div className="flex h-1/3 w-full flex-shrink-0 flex-col border-b border-base-content/10 bg-base-300/50 lg:h-auto lg:w-80 lg:border-b-0 lg:border-r">
                                    <PatraoPicker
                                        selectedPatrao={selectedPatrao}
                                        onSelect={setSelectedPatrao}
                                        excludeIds={isEdit && user?.id ? [user.id] : []}
                                    />
                                </div>

                                <div className="flex min-h-0 min-w-0 flex-1 flex-col overflow-hidden bg-base-100">
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

                                    <form
                                        onSubmit={handleSubmit(onSubmit)}
                                        className="flex min-h-0 flex-1 flex-col overflow-hidden"
                                    >
                                        <div className="min-h-0 flex-1 space-y-6 overflow-y-auto p-6" style={{ WebkitOverflowScrolling: 'touch' }}>
                                            <UserPhotoUpload
                                                key={uploadKey}
                                                user={user}
                                                isEdit={isEdit}
                                                watch={watch}
                                                onSave={onSave}
                                                onImageChange={(file) => setImageFile(file)}
                                            />

                                            <Input
                                                label="Nome Completo"
                                                placeholder="Ex: João Silva"
                                                error={errors.name}
                                                {...register("name", {
                                                    required: { value: true, message: "Nome é obrigatório" },
                                                })}
                                            />

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

                                            <UserRolesManager
                                                user={user}
                                                isEdit={isEdit}
                                                pendingRoles={pendingRoles}
                                                setPendingRoles={setPendingRoles}
                                            />

                                            {isEdit && (
                                                <ChildrenList
                                                    childrenData={childrenList}
                                                    onAddChild={() => onAddChild(user)}
                                                    onSelectChild={onSwitchUser}
                                                />
                                            )}
                                        </div>

                                        {error && (
                                            <div className="mx-6 mb-2 alert alert-error text-sm shadow-lg">
                                                <MaterialSymbol icon="error" size={20} />
                                                <span>{error}</span>
                                            </div>
                                        )}

                                        <div className="flex flex-shrink-0 items-center gap-3 border-t border-base-content/10 bg-base-200/50 px-6 py-4">
                                            {isEdit && onDelete && (
                                                <button
                                                    type="button"
                                                    className={classNames("btn btn-error btn-outline gap-1", {
                                                        loading: deleting,
                                                    })}
                                                    disabled={deleting}
                                                    onClick={async () => {
                                                        if (window.confirm(`Tens a certeza que queres eliminar "${user?.name}"?`)) {
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

                                            <button type="button" className="btn btn-ghost" onClick={onClose}>
                                                Cancelar
                                            </button>

                                            {!isEdit && (
                                                <button
                                                    type="button"
                                                    className="btn btn-secondary btn-outline"
                                                    disabled={loading}
                                                    onClick={handleSubmit((d) => processSubmit(d, false))}
                                                >
                                                    Criar e Adicionar Outro
                                                </button>
                                            )}

                                            <button
                                                type="submit"
                                                className={classNames("btn btn-primary min-w-[120px]", {
                                                    loading: loading,
                                                })}
                                                disabled={loading}
                                            >
                                                {isEdit ? "Guardar" : "Criar Pedaço"}
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </motion.div>
                    </div >
                    <Toaster />
                </>
            )}
        </AnimatePresence >,
        document.body
    );
};

export default UserForm;
