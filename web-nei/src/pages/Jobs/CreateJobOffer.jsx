import React, { useState, useEffect } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useNavigate, useParams } from "react-router-dom"; // <-- Added useParams
import Typist from "react-typist";

import { jobOfferSchema } from "./schemas";
import { useToast } from "components/ui/use-toast";
// TODO import service method

export function Component() {
    const navigate = useNavigate();
    const { id } = useParams();
    const { toast } = useToast();

    const [isSubmitting, setIsSubmitting] = useState(false);
    const [isLoading, setIsLoading] = useState(!!id); // Load only if we are editing

    const isEditMode = !!id;

    const {
        register,
        handleSubmit,
        reset,
        formState: { errors },
    } = useForm({
        resolver: zodResolver(jobOfferSchema),
        defaultValues: {
            isActive: true,
        },
    });

    // fetch data in edit mode
    useEffect(() => {
        if (isEditMode) {
            // api call here
            setTimeout(() => {
                reset({
                    title: "Engenheiro de Software Junior",
                    company: "Tech Corp",
                    location: "Aveiro (Híbrido)",
                    description: "Procuramos um recém-graduado motivado para se juntar à nossa equipa de desenvolvimento backend.\n\nRequisitos:\n- Experiência com Python e APIs REST\n- Conhecimentos de bases de dados relacionais (PostgreSQL)\n- Vontade de aprender e trabalhar em equipa.",
                    expirationDate: "2026-05-30",
                    applicationUrl: "https://example.com/apply/1",
                    isActive: true,
                });
                setIsLoading(false);
            }, 600);
        }
    }, [id, isEditMode, reset]);

    const onSubmit = async (data) => {
        setIsSubmitting(true);
        try {
            if (isEditMode) {
                // TODO API call for update
                toast({
                    title: "Atualizada!",
                    description: "A oferta de emprego foi atualizada com sucesso.",
                    variant: "success",
                });
            } else {
                // TODO API call for create
                toast({
                    title: "Publicada!",
                    description: "A nova oferta de emprego foi publicada com sucesso.",
                    variant: "success",
                });
            }
            navigate("/jobs");
        } catch (error) {
            toast({
                title: "Erro",
                description: "Ocorreu um erro ao processar o pedido.",
                variant: "destructive",
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    if (isLoading) {
        return (
            <div className="flex justify-center items-center min-h-[50vh]">
                <span className="loading loading-spinner loading-lg text-primary"></span>
            </div>
        );
    }

    return (
        <div className="container mx-auto max-w-3xl py-10 px-4">
            <h2 className="text-center mb-8 text-3xl font-bold">
                {isEditMode ? (
                    <Typist>Editar Oferta</Typist>
                ) : (
                    <Typist>Publicar Nova Oferta</Typist>
                )}
            </h2>

            <form onSubmit={handleSubmit(onSubmit)} className="space-y-6 bg-base-200 p-8 rounded-xl shadow-lg">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div className="form-control w-full">
                        <label className="label"><span className="label-text font-semibold">Título da Oferta</span></label>
                        <input
                            type="text"
                            placeholder="Ex: Engenheiro de Software Fullstack"
                            className={`input input-bordered w-full ${errors.title ? "input-error" : ""}`}
                            {...register("title")}
                        />
                        {errors.title && <span className="text-error text-sm mt-1">{errors.title.message}</span>}
                    </div>

                    <div className="form-control w-full">
                        <label className="label"><span className="label-text font-semibold">Empresa</span></label>
                        <input
                            type="text"
                            placeholder="Ex: Tech Corp"
                            className={`input input-bordered w-full ${errors.company ? "input-error" : ""}`}
                            {...register("company")}
                        />
                        {errors.company && <span className="text-error text-sm mt-1">{errors.company.message}</span>}
                    </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div className="form-control w-full">
                        <label className="label"><span className="label-text font-semibold">Localização</span></label>
                        <input
                            type="text"
                            placeholder="Ex: Aveiro (Híbrido)"
                            className={`input input-bordered w-full ${errors.location ? "input-error" : ""}`}
                            {...register("location")}
                        />
                        {errors.location && <span className="text-error text-sm mt-1">{errors.location.message}</span>}
                    </div>

                    <div className="form-control w-full">
                        <label className="label"><span className="label-text font-semibold">Link de Candidatura</span></label>
                        <input
                            type="url"
                            placeholder="https://..."
                            className={`input input-bordered w-full ${errors.applicationUrl ? "input-error" : ""}`}
                            {...register("applicationUrl")}
                        />
                        {errors.applicationUrl && <span className="text-error text-sm mt-1">{errors.applicationUrl.message}</span>}
                    </div>
                </div>

                <div className="form-control w-full">
                    <label className="label"><span className="label-text font-semibold">Descrição</span></label>
                    <textarea
                        className={`textarea textarea-bordered h-32 ${errors.description ? "textarea-error" : ""}`}
                        placeholder="Detalhes da oferta, requisitos, benefícios..."
                        {...register("description")}
                    ></textarea>
                    {errors.description && <span className="text-error text-sm mt-1">{errors.description.message}</span>}
                </div>

                <div className="flex flex-col md:flex-row items-center justify-between gap-6 pt-4 border-t border-base-300">
                    <div className="form-control w-full md:w-1/2">
                        <label className="label"><span className="label-text font-semibold">Data Limite</span></label>
                        <input
                            type="date"
                            className={`input input-bordered w-full ${errors.expirationDate ? "input-error" : ""}`}
                            {...register("expirationDate")}
                        />
                        {errors.expirationDate && <span className="text-error text-sm mt-1">{errors.expirationDate.message}</span>}
                    </div>

                    <div className="form-control w-full md:w-auto flex flex-row items-center gap-4 mt-6 md:mt-0">
                        <label className="label cursor-pointer p-0">
                            <span className="label-text font-semibold mr-4">Oferta Ativa</span>
                            <input
                                type="checkbox"
                                className="toggle toggle-primary"
                                {...register("isActive")}
                            />
                        </label>
                    </div>
                </div>

                <div className="pt-6 flex justify-end">
                    <button
                        type="submit"
                        className={`btn btn-primary px-8 ${isSubmitting ? "loading" : ""}`}
                        disabled={isSubmitting}
                    >
                        {isSubmitting
                            ? "A guardar..."
                            : isEditMode
                                ? "Guardar Alterações"
                                : "Publicar Oferta"}
                    </button>
                </div>
            </form>
        </div>
    );
}