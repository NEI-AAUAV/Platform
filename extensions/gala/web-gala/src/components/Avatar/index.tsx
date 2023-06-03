import useNEIUser from "@/hooks/useNEIUser";
import { useUserStore } from "@/stores/useUserStore";

type AvatarProps = {
  className?: string;
  style?: React.CSSProperties;
  id?: number;
  alt?: string;
};
const defaultImage = "http://localhost/gala/public/default-profile.svg";

export default function Avatar({ className, style, id, alt }: AvatarProps) {
  let neiUser;
  const defaultImageCondition =
    id === -1 || (neiUser = useNEIUser(id).neiUser) === undefined;
  const idImage = defaultImageCondition ? defaultImage : neiUser?.image;

  const imageSrc =
    id === undefined ? useUserStore((state) => state.image) : idImage;

  return (
    <img
      src={imageSrc}
      alt={alt}
      className={`inline-block aspect-square w-8 rounded-full ${className}`}
      style={style}
    />
  );
}

Avatar.defaultProps = {
  className: "",
  style: {},
  id: undefined,
  alt: "",
};
