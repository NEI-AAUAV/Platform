import { Controller, SubmitHandler, useForm } from "react-hook-form";
import classNames from "classnames";
import { faPaperPlane } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Button from "@/components/Button";
import VoteCard from "@/components/VoteCard";
import useVotes from "@/hooks/voteHooks/useVotes";
import useVoteCast from "@/hooks/voteHooks/useVoteCast";

type FormValues = {
  votes: {
    option: string | undefined;
  }[];
};

export default function Vote() {
  const { votes } = useVotes();

  const { control, handleSubmit, setValue, getValues } = useForm<FormValues>({
    defaultValues: {
      votes: votes.map((vote) => ({
        [vote._id]: vote.already_voted ? vote.already_voted : undefined,
      })),
    },
  });

  const onSubmit: SubmitHandler<FormValues> = (data) => {
    data.votes.forEach((vote, idx) => {
      console.log(idx, { option: vote.option });
      if (vote.option === undefined) return;
      useVoteCast(idx, { option: Number(vote.option) });
    });
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <h2 className="m-20 text-center text-2xl font-bold">
        <span className="block">Vota nas categorias.</span>
      </h2>
      <div className="mx-4 my-10 grid gap-8">
        {votes.map((vote) => (
          <Controller
            key={vote._id}
            control={control}
            name={`votes.${vote._id}.option`}
            render={() => {
              return (
                <VoteCard
                  vote={vote}
                  setValue={setValue}
                  getValues={getValues}
                />
              );
            }}
          />
        ))}

        <Button className={classNames("w-full")} submit>
          <FontAwesomeIcon icon={faPaperPlane} /> Enviar votações
        </Button>
      </div>
    </form>
  );
}
