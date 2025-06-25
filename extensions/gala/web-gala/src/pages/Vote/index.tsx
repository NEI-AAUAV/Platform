import { FormProvider, SubmitHandler, useForm } from "react-hook-form";
import classNames from "classnames";
import { faPaperPlane } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Button from "@/components/Button";
import VoteCard from "@/components/VoteCard";
import useVotes from "@/hooks/voteHooks/useVotes";
import useVoteCast from "@/hooks/voteHooks/useVoteCast";
import useSessionUser, { State } from "@/hooks/userHooks/useSessionUser";
import { useEffect } from "react";

type FormVotes = {
  [x: number]: {
    _id: number;
    already_voted: boolean;
    option: number | null;
  };
};

type FormValues = {
  votes: FormVotes;
};

export default function Vote() {
  const { state } = useSessionUser();
  const { votes, mutate } = useVotes();

  const methods = useForm<FormValues>({
    defaultValues: { votes: {} },
  });

  useEffect(() => {
    if (!votes) return;

    methods.reset({
      votes: votes.reduce((obj: FormVotes, vote) => {
        obj[vote._id] = {
          _id: vote._id,
          already_voted: vote.already_voted !== null,
          option: vote.already_voted,
        };
        return obj;
      }, {}),
    });
  }, [votes]);

  const onSubmit: SubmitHandler<FormValues> = (data) => {
    Object.values(data.votes).forEach((vote) => {
      if (vote.option === null) return;
      if (vote.already_voted) return;
      useVoteCast(vote._id, { option: vote.option }).then(() => {
        mutate();
      });
    });
  };

  return (
    <FormProvider {...methods}>
      <form onSubmit={methods.handleSubmit(onSubmit)}>
        <h2 className="pt-20 text-center text-[3rem] font-bold sm:text-[4rem]">
          <span className="text-light-gold block font-gala">Votações</span>
        </h2>
        <div className="mx-4 mt-10 grid gap-8">
          {votes.map((vote) => (
            <VoteCard key={vote._id} vote={vote} />
          ))}
        </div>
        {state === State.REGISTERED && (
          <div className="font-gala sticky bottom-0 mt-5 px-4 pb-10 pt-5 max-w-md justify-center mx-auto">
            <Button className={classNames("w-full")} submit>
              <FontAwesomeIcon icon={faPaperPlane} /> Enviar votações
            </Button>
          </div>
        )}
      </form>
    </FormProvider>
  );
}
