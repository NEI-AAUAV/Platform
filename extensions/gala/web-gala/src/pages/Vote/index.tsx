import classNames from "classnames";
import { faPaperPlane } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Button from "@/components/Button";
import VoteCard from "@/components/VoteCard";
import useVotes from "@/hooks/voteHooks/useVotes";

export default function Vote() {
  const { votes } = useVotes();

  return (
    <>
      <h2 className="m-20 text-center text-2xl font-bold">
        <span className="block">Vota nas categorias.</span>
      </h2>
      <div className="mx-4 my-10 grid gap-8">
        {votes.map((vote) => (
          <VoteCard vote={vote} />
        ))}

        <Button className={classNames("w-full")} submit>
          <FontAwesomeIcon icon={faPaperPlane} /> Enviar votações
        </Button>
      </div>
    </>
  );
}
