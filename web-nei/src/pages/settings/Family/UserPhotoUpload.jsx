
import { useState, useEffect } from "react";
import PropTypes from "prop-types";
import classNames from "classnames";
import MaterialSymbol from "components/MaterialSymbol";
import Avatar from "components/Avatar";
import FamilyService from "services/FamilyService";
import { useToast } from "components/ui/use-toast";
import { getErrorMessage, isErrorStatus } from "utils/error";

export default function UserPhotoUpload({ user, isEdit, watch, register, onSave, onImageChange }) {
    const { toast } = useToast();
    const [imageUploadAvailable, setImageUploadAvailable] = useState(true);
    const [imageFile, setImageFile] = useState(null);
    const [preview, setPreview] = useState(null);
    const [removeImage, setRemoveImage] = useState(false);
    const [imageUpdating, setImageUpdating] = useState(false);

    // Watch sex for avatar fallback
    const monitoredSex = watch("sex");

    // Check availability
    useEffect(() => {
        const check = async () => {
            try {
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
    }, []);

    // Reset state when user changes
    useEffect(() => {
        setPreview(null);
        setImageFile(null);
        setRemoveImage(false);
    }, [user]);

    const handleImageInputChange = (e) => {
        const file = e.target.files?.[0] || null;
        if (!file) {
            setImageFile(null);
            setPreview(null);
            onImageChange?.(null, false);
            return;
        }
        // Basic size validation (2MB)
        const maxSize = 2 * 1024 * 1024;
        if (file.size > maxSize) {
            alert("Imagem demasiado grande (máx. 2MB)");
            e.target.value = "";
            setImageFile(null);
            setPreview(null);
            onImageChange?.(null, false);
            return;
        }
        setRemoveImage(false);
        setImageFile(file);
        setPreview(URL.createObjectURL(file));
        onImageChange?.(file, false);
    };

    const handleUpdatePhoto = async () => {
        if (!isEdit || (!imageFile && !removeImage)) return;
        const uid = user?.id;
        setImageUpdating(true);
        try {
            const updated = await FamilyService.updateUserImage(uid, imageFile || undefined, { remove: !!removeImage });
            // Clear preview
            setPreview(null);
            setImageFile(null);
            setRemoveImage(false);

            // Update local user object reference if provided
            if (user && updated?.image !== undefined) {
                user.image = updated.image;
            }

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

    return (
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
                            sex={user?.sex || monitoredSex}
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
                            {isEdit && (
                                <label className="label cursor-pointer w-fit">
                                    <input
                                        type="checkbox"
                                        className="checkbox checkbox-sm mr-2"
                                        checked={removeImage}
                                        onChange={(e) => {
                                            const checked = e.target.checked;
                                            setRemoveImage(checked);
                                            if (checked) {
                                                setImageFile(null);
                                                setPreview(null);
                                                onImageChange?.(null, true);
                                            } else {
                                                onImageChange?.(imageFile, false);
                                            }
                                        }}
                                    />
                                    <span className="label-text">Remover foto</span>
                                </label>
                            )}
                            {!isEdit && imageFile && (
                                <span className="text-xs text-success">✓ Foto será enviada ao criar o membro</span>
                            )}
                        </div>
                        {isEdit && (
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
                        )}
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
    );
}

UserPhotoUpload.propTypes = {
    user: PropTypes.shape({
        id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
        image: PropTypes.string,
        sex: PropTypes.string,
        name: PropTypes.string,
    }),
    isEdit: PropTypes.bool,
    watch: PropTypes.func,
    register: PropTypes.func,
    onSave: PropTypes.func,
    onImageChange: PropTypes.func,
};
