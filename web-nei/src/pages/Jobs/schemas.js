import * as z from "zod";

export const jobOfferSchema = z.object({
    title: z.string().min(5, { message: "O título deve ter pelo menos 5 caracteres." }),
    company: z.string().min(2, { message: "O nome da empresa é obrigatório." }),
    location: z.string().min(2, { message: "A localização é obrigatória." }),
    description: z.string().min(20, { message: "A descrição deve ser mais detalhada." }),
    applicationUrl: z.string().url({ message: "O link de candidatura deve ser válido." }),
    expirationDate: z.string().min(1, { message: "A data de expiração da oferta é obrigatória." }),
    isActive: z.boolean().default(true),
});