import Avatar from "@/components/Avatar";
import useNEIUser from "@/hooks/useNEIUser";

type GuestProps = {
  id: number | null;
};

export default function Guest({ id }: GuestProps) {
  const { neiUser } = useNEIUser(id);
  return (
    <div className="flex items-center gap-2">
      <Avatar id={id} className="w-8" />
      <span>{`${neiUser?.name} ${neiUser?.surname}`}</span>
    </div>
  );
}
