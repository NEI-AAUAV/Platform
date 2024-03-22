import { useEffect, useState } from "react";

export default function TeamImage({ teamId }: { teamId: number }) {
  const [image, setImage] = useState<null | string>(null);
  useEffect(() => {
    import(`@/public/team-images/team-${teamId}.png`)
      .then((image) => setImage(image.default))
      .catch(() => setImage(null));
  });

  return (
    <div className="grid aspect-square place-items-center overflow-hidden rounded-lg border border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)]">
      <img
        className="h-full object-cover object-top pt-4 text-center font-light"
        src={image ?? ""}
        alt="Picture"
      />
    </div>
  );
}
