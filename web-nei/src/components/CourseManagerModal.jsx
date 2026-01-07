import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";
import MaterialSymbol from "components/MaterialSymbol";
import { CloseIcon } from "assets/icons/google";
import FamilyService from "services/FamilyService";

/**
 * Course Manager Modal
 * Allows creating, editing, and deleting courses.
 */
export default function CourseManagerModal({ isOpen, onClose }) {
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(false);
    const [selectedCourse, setSelectedCourse] = useState(null);

    // Form State
    const [formData, setFormData] = useState({
        name: "",
        short: "",
        degree: "Licenciatura",
        show: true
    });
    const [isNew, setIsNew] = useState(false);
    const [submitting, setSubmitting] = useState(false);
    const [search, setSearch] = useState("");

    // Load Courses
    const loadCourses = async () => {
        setLoading(true);
        try {
            const response = await FamilyService.getCourses({ limit: 500 }); // Load all for now
            setCourses(response.items || []);
        } catch (err) {
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        if (isOpen) {
            loadCourses();
            setSelectedCourse(null);
            setFormData({ name: "", short: "", degree: "Licenciatura", show: true });
            setIsNew(false);
            setSearch("");
        }
    }, [isOpen]);

    // Select a course to edit
    const handleSelectCourse = (course) => {
        setSelectedCourse(course);
        setIsNew(false);
        setFormData({
            name: course.name,
            short: course.short || "",
            degree: course.degree || "Licenciatura",
            show: course.show !== false // Default to true if undefined
        });
    };

    const handleCreateNew = () => {
        setSelectedCourse(null);
        setIsNew(true);
        setFormData({
            name: "",
            short: "",
            degree: "Licenciatura",
            show: true
        });
    };

    const handleSave = async (e) => {
        e.preventDefault();
        setSubmitting(true);
        try {
            if (isNew) {
                await FamilyService.createCourse(formData);
            } else {
                if (!selectedCourse) return;
                const id = selectedCourse._id || selectedCourse.id;
                await FamilyService.updateCourse(id, formData);
            }
            await loadCourses();
            // Reset
            handleCreateNew();
        } catch (err) {
            console.error(err);
            alert("Erro ao guardar curso: " + (err.response?.data?.detail || err.message));
        } finally {
            setSubmitting(false);
        }
    };

    const handleDelete = async () => {
        if (!selectedCourse || isNew) return;
        if (!window.confirm(`Tem a certeza que deseja eliminar "${selectedCourse.name}"?`)) return;

        setSubmitting(true);
        try {
            const id = selectedCourse._id || selectedCourse.id;
            await FamilyService.deleteCourse(id);
            await loadCourses();
            handleCreateNew();
        } catch (err) {
            console.error(err);
            alert("Erro ao eliminar: " + (err.response?.data?.detail || err.message));
        } finally {
            setSubmitting(false);
        }
    };

    // Filter courses
    const filteredCourses = courses.filter(c =>
        c.name.toLowerCase().includes(search.toLowerCase()) ||
        c.short.toLowerCase().includes(search.toLowerCase())
    );

    return (
        <AnimatePresence>
            {isOpen && (
                <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/40 backdrop-blur-[2px] p-6" onClick={onClose}>
                    <motion.div
                        initial={{ scale: 0.95, opacity: 0 }}
                        animate={{ scale: 1, opacity: 1 }}
                        exit={{ scale: 0.95, opacity: 0 }}
                        className="flex h-[600px] w-full max-w-4xl overflow-hidden rounded-2xl border border-base-content/10 bg-base-100 shadow-2xl"
                        onClick={(e) => e.stopPropagation()}
                    >
                        {/* Sidebar: List */}
                        <div className="flex w-2/5 flex-col border-r border-base-content/10 bg-base-200/30">
                            <div className="flex flex-col gap-2 border-b border-base-content/10 p-4">
                                <div className="flex items-center justify-between">
                                    <h3 className="font-bold">Cursos</h3>
                                    <button
                                        className="btn btn-xs btn-primary gap-1"
                                        onClick={handleCreateNew}
                                    >
                                        <MaterialSymbol icon="add" size={16} /> Novo
                                    </button>
                                </div>
                                <input
                                    type="text"
                                    className="input input-sm input-bordered w-full"
                                    placeholder="Pesquisar..."
                                    value={search}
                                    onChange={e => setSearch(e.target.value)}
                                />
                            </div>
                            <div className="flex-1 overflow-y-auto p-2">
                                {loading ? (
                                    <div className="flex justify-center p-4">
                                        <span className="loading loading-spinner"></span>
                                    </div>
                                ) : (
                                    <div className="flex flex-col gap-1">
                                        {filteredCourses.map(course => (
                                            <button
                                                key={course._id || course.id}
                                                className={classNames(
                                                    "flex w-full flex-col gap-0.5 rounded-lg px-3 py-2 text-left text-sm transition-all duration-200",
                                                    (selectedCourse?._id === course._id && !isNew)
                                                        ? "bg-primary text-primary-content shadow-md"
                                                        : "hover:bg-base-200 text-base-content/80"
                                                )}
                                                onClick={() => handleSelectCourse(course)}
                                            >
                                                <div className="flex items-center justify-between w-full">
                                                    <span className="font-bold truncate">{course.short}</span>
                                                    {!course.show && (
                                                        <MaterialSymbol icon="visibility_off" size={14} className="opacity-50" />
                                                    )}
                                                </div>
                                                <span className={classNames(
                                                    "text-xs truncate",
                                                    (selectedCourse?._id === course._id && !isNew) ? "opacity-80" : "opacity-60"
                                                )}>
                                                    {course.name}
                                                </span>
                                            </button>
                                        ))}
                                        {filteredCourses.length === 0 && (
                                            <div className="text-center p-4 opacity-50 text-xs">
                                                Nenhum curso encontrado
                                            </div>
                                        )}
                                    </div>
                                )}
                            </div>
                        </div>

                        {/* Main Content: Form */}
                        <div className="flex flex-1 flex-col">
                            <div className="flex items-center justify-between border-b border-base-content/10 p-4">
                                <h3 className="text-lg font-bold">
                                    {isNew ? "Novo Curso" : "Editar Curso"}
                                </h3>
                                <button className="btn btn-ghost btn-sm btn-circle" onClick={onClose}>
                                    <CloseIcon />
                                </button>
                            </div>

                            <div className="flex-1 overflow-y-auto p-6">
                                <form onSubmit={handleSave} className="flex flex-col gap-4 max-w-lg mx-auto">
                                    <div className="form-control">
                                        <label className="label"><span className="label-text">Nome</span></label>
                                        <input
                                            type="text"
                                            className="input input-bordered"
                                            required
                                            value={formData.name}
                                            onChange={e => setFormData({ ...formData, name: e.target.value })}
                                            placeholder="Ex: Engenharia Informática"
                                        />
                                    </div>

                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="form-control">
                                            <label className="label"><span className="label-text">Abreviatura</span></label>
                                            <input
                                                type="text"
                                                className="input input-bordered"
                                                required
                                                value={formData.short}
                                                onChange={e => setFormData({ ...formData, short: e.target.value })}
                                                placeholder="Ex: LEI"
                                            />
                                        </div>
                                        <div className="form-control">
                                            <label className="label"><span className="label-text">Grau</span></label>
                                            <select
                                                className="select select-bordered"
                                                value={formData.degree}
                                                onChange={e => setFormData({ ...formData, degree: e.target.value })}
                                            >
                                                <option value="Licenciatura">Licenciatura</option>
                                                <option value="Mestrado">Mestrado</option>
                                                <option value="Programa Doutoral">Programa Doutoral</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div className="form-control">
                                        <label className="label cursor-pointer justify-start gap-3">
                                            <input
                                                type="checkbox"
                                                className="checkbox checkbox-primary"
                                                checked={formData.show}
                                                onChange={e => setFormData({ ...formData, show: e.target.checked })}
                                            />
                                            <span className="label-text">Mostrar Visivelmente</span>
                                        </label>
                                    </div>

                                    <div className="divider"></div>

                                    <div className="flex gap-2 justify-end">
                                        {!isNew && (
                                            <button
                                                type="button"
                                                className="btn btn-error btn-outline"
                                                onClick={handleDelete}
                                                disabled={submitting}
                                            >
                                                Eliminar
                                            </button>
                                        )}
                                        <button
                                            type="submit"
                                            className="btn btn-primary"
                                            disabled={submitting}
                                        >
                                            {submitting && <span className="loading loading-spinner"></span>}
                                            Guardar
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </motion.div>
                </div>
            )}
        </AnimatePresence>
    );
}
