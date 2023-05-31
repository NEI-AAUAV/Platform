import { useUserStore } from "@/stores/useUserStore";

type AvatarProps = {
  className?: string;
  style?: React.CSSProperties;
  isAuth?: boolean;
  alt?: string;
};

export default function Avatar({ className, style, isAuth, alt }: AvatarProps) {
  const imageSrc = isAuth
    ? useUserStore((state) => state.image)
    : "http://localhost/gala/public/default-profile.svg";

  return (
    <img
      src={imageSrc}
      alt={alt}
      className={`block aspect-square w-8 rounded-full ${className}`}
      style={style}
    />
  );
}

Avatar.defaultProps = {
  className: "",
  style: {},
  isAuth: true,
  alt: "",
};
