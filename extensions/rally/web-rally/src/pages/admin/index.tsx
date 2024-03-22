import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import { Navigate } from "react-router-dom";
import { z } from "zod";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Checkbox } from "@/components/ui/checkbox";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useMutation, useQuery } from "@tanstack/react-query";
import { TeamService, type TeamScoresUpdate } from "@/client";
import { BloodyButton } from "@/components/bloody-button";
import { SendHorizontal } from "lucide-react";
import useUser from "@/hooks/useUser";

const adminFormSchema = z.object({
  teamId: z.string().regex(/\d+/),
  extraShots: z.string().regex(/\d+/),
  pukes: z.string().regex(/\d+/),
  countDrank: z.string().regex(/\d+/),
  time: z.string().regex(/\d+/),
  answeredQuestion: z.boolean().optional(),
});

type AdminForm = z.infer<typeof adminFormSchema>;

export default function Admin() {
  const { userData, isRallyAdmin, isLoading } = useUser();
  const { data: teams } = useQuery({
    queryKey: ["teams"],
    queryFn: TeamService.getTeamsApiRallyV1TeamGet,
  });

  const {
    mutate: updateTeamCheckpoint,
    data: updateData,
    isPending: isPendingUpdate,
    isSuccess,
    isError,
    error,
  } = useMutation({
    mutationKey: ["updateTeamCheckpoint"],
    mutationFn: (checkpointData: {
      id: number;
      requestBody: TeamScoresUpdate;
    }) =>
      TeamService.addCheckpointApiRallyV1TeamIdCheckpointPut(
        checkpointData.id,
        checkpointData.requestBody,
      ),
  });

  const form = useForm<AdminForm>({
    resolver: zodResolver(adminFormSchema),
  });

  if (isLoading) {
    return <>loading...</>;
  }

  if (!isRallyAdmin) {
    return <Navigate to="/scoreboard" />;
  }

  const handleSubmit = (data: AdminForm) => {
    const team = teams?.find((team) => team.id === Number(data.teamId));
    if (team === undefined) return;

    const requestBody: TeamScoresUpdate = {
      checkpoint_id: userData?.staff_checkpoint_id,
      pukes: Number(data.pukes),
      time_score: Number(data.time),
      skips: 5 - Number(data.countDrank) - Number(data.extraShots),
      question_score: !!data.answeredQuestion,
    };
    updateTeamCheckpoint({
      id: Number(data.teamId),
      requestBody,
    });
  };
  return (
    <Form {...form}>
      <form
        className="mt-16 grid gap-8"
        onSubmit={form.handleSubmit(handleSubmit)}
      >
        <FormField
          control={form.control}
          name="teamId"
          render={({ field }) => (
            <FormItem>
              <FormLabel className="font-semibold">Equipa</FormLabel>
              <Select onValueChange={field.onChange}>
                <FormControl>
                  <SelectTrigger className="rounded-2xl border-2 border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)] p-4 py-2">
                    <SelectValue placeholder="Selecionar equipa" />
                  </SelectTrigger>
                </FormControl>
                <SelectContent className="rounded-2xl p-1">
                  {teams?.map((team) => (
                    <SelectItem
                      className="rounded-2xl"
                      key={team.id}
                      value={String(team.id)}
                    >
                      {team.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="extraShots"
          render={({ field }) => (
            <FormItem>
              <FormLabel className="font-semibold">Shots Extra</FormLabel>
              <FormControl>
                <Input
                  className="rounded-2xl border-2 border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)] p-4"
                  placeholder="0"
                  {...field}
                />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="pukes"
          render={({ field }) => (
            <FormItem>
              <FormLabel className="font-semibold">Nº de Vomitos</FormLabel>
              <FormControl>
                <Input
                  className="rounded-2xl border-2 border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)] p-4"
                  placeholder="0"
                  {...field}
                />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="countDrank"
          render={({ field }) => (
            <FormItem>
              <FormLabel className="font-semibold">
                Nº de pessoas que beberam
              </FormLabel>
              <FormControl>
                <Input
                  className="rounded-2xl border-2 border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)] p-4"
                  placeholder="0"
                  {...field}
                />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="time"
          render={({ field }) => (
            <FormItem>
              <FormLabel className="font-semibold">Tempo em Segundos</FormLabel>
              <FormControl>
                <Input
                  className="rounded-2xl border-2 border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)] p-4"
                  placeholder="0"
                  {...field}
                />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="answeredQuestion"
          render={({ field }) => (
            <FormItem>
              <div className="flex items-center gap-2">
                <FormControl>
                  <Checkbox
                    className="rounded-full"
                    checked={field.value}
                    onCheckedChange={field.onChange}
                  />
                </FormControl>
                <FormLabel className="font-semibold">
                  Responderam corretamente à pergunta.
                </FormLabel>
              </div>
              <FormMessage />
            </FormItem>
          )}
        />
        <div className="grid place-items-center gap-2">
          <BloodyButton
            blood
            type="submit"
            className="flex gap-2"
            variant={"primary"}
            disabled={isPendingUpdate}
          >
            <SendHorizontal />
            Submeter
          </BloodyButton>
          {isSuccess && (
            <span className="text-green-500">
              Equipa {updateData.name} atualizada com sucesso!
            </span>
          )}
          {isError &&
            (("body" in error &&
              typeof error.body === "object" &&
              error.body &&
              "detail" in error.body &&
              typeof error.body.detail === "string" && (
                <span className="text-red-800">{error.body.detail}</span>
              )) || (
              <span className="text-red-800">
                Something went wrong! <br /> Try again or contact an
                administrator.
              </span>
            ))}
        </div>
      </form>
    </Form>
  );
}
