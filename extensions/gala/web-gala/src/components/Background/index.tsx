type BackgroundProps = {
  src: string;
};

export default function Background({ src }: BackgroundProps) {
  return (
    <img
      className="absolute inset-0 h-screen w-screen object-cover object-bottom"
      src={src}
      alt=""
    />
  );
}
