import NEIService from "services/NEIService";
import { z } from "zod";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import {
  Form,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "components/ui/form";
import { Input } from "components/ui/input";
import { Button } from "components/ui/button";
import { useNavigate, useSearchParams } from "react-router-dom";
import { useMutation } from "react-query";
import { cn } from "lib/utils";

const formSchema = z
  .object({
    password: z.string().min(1, { message: "A password não pode estar vazia" }),
    passwordConfirmation: z
      .string()
      .min(1, { message: "A password não pode estar vazia" }),
  })
  .refine((data) => data.password === data.passwordConfirmation, {
    message: "As passwords não coincidem",
    path: ["passwordConfirmation"],
  });

type FormType = z.infer<typeof formSchema>;

export function Component() {
  const form = useForm<FormType>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      password: "",
      passwordConfirmation: "",
    },
  });
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const token = searchParams.get("token");
  const { mutate, isError, isSuccess, isLoading, error } = useMutation({
    mutationKey: ["magic", token],
    mutationFn: NEIService.magicLink,
  });
  const onSubmit = (data: FormType) => {
    mutate({ password: data.password, token });
  };
  if (isSuccess) {
    navigate("/");
  }
  console.log(error);
  return (
    <>
      <div className="z-10 m-auto flex h-fit max-w-[80%] flex-col rounded-2xl bg-base-200 p-16 align-middle shadow-secondary drop-shadow-lg sm:max-w-md">
        <h1 className="mb-4 text-center text-3xl">Criar palavra-passe</h1>
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)}>
            <FormField
              control={form.control}
              name="password"
              render={({ field }) => (
                <>
                  <FormItem className="">
                    <FormLabel className="text-xl">Password</FormLabel>
                    <Input
                      className="text-md rounded-3xl px-5 py-6"
                      type="password"
                      placeholder="Password"
                      {...field}
                    />
                  </FormItem>
                  <FormMessage className="mt-2" />
                </>
              )}
            />
            <FormField
              control={form.control}
              name="passwordConfirmation"
              render={({ field }) => (
                <>
                  <FormItem className="mt-6">
                    <FormLabel className="text-xl">
                      Confirmar Password
                    </FormLabel>
                    <Input
                      className="text-md rounded-3xl px-5 py-6"
                      type="password"
                      placeholder="Confirmar password"
                      {...field}
                    />
                  </FormItem>
                  <FormMessage className="mt-2" />
                </>
              )}
            />
            <div className="flex justify-center">
              <Button
                type="submit"
                variant={"default"}
                className={cn(
                  "mt-10 rounded-3xl bg-[#0F8A42] p-6 text-lg text-white",
                  {
                    "disabled brightness-90": isLoading,
                  }
                )}
              >
                Criar palavra-passe
              </Button>
            </div>
            {isError && (
              <p className="mt-5 text-center text-red-600">
                Algo correu mal!
                {typeof error === "object" &&
                  error &&
                  "response" in error &&
                  typeof error.response === "object" &&
                  error.response &&
                  "status" in error.response &&
                  typeof error.response.status === "number" &&
                  error.response.status &&
                  (400 <= error.response.status &&
                  error.response.status < 500 ? (
                    <>
                      <br />
                      Contacte um administrador
                    </>
                  ) : (
                    500 <= error.response.status &&
                    error.response.status < 600 && (
                      <>
                        <br />
                        Erro de servidor
                      </>
                    )
                  ))}
              </p>
            )}
          </form>
        </Form>
      </div>
    </>
  );
}
