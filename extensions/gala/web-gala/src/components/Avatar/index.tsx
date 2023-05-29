type AvatarProps = {
  className?: string;
  style?: React.CSSProperties;
};

export default function Avatar({ className, style }: AvatarProps) {
  return (
    <div
      className={`aspect-square w-8 rounded-full bg-red-600 ${className}`}
      style={style}
    />
  );
}

Avatar.defaultProps = {
  className: "",
  style: {},
};
