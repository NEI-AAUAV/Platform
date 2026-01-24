import React from "react";
import malePic from "assets/default_profile/male.svg";
import femalePic from "assets/default_profile/female.svg";
import otherPic from "assets/default_profile/other.svg";

/**
 * Avatar component for user/member images with fallback logic.
 * @param {string} image - The image URL (can be null/undefined).
 * @param {string} sex - 'M', 'F', or other/null.
 * @param {string} alt - Alt text for the image.
 * @param {string} className - Additional classes for the <img>.
 * @param {object} rest - Any other props for the <img>.
 */
export default function Avatar({ image, sex, alt = "avatar", className = "", ...rest }) {
  // Pick fallback based on sex
  const fallback = sex === "F" ? femalePic : sex === "M" ? malePic : otherPic;
  const [src, setSrc] = React.useState(image || fallback);

  React.useEffect(() => {
    setSrc(image || fallback);
  }, [image, fallback]);

  return (
    <img
      src={src}
      alt={alt}
      className={className}
      onError={() => setSrc(fallback)}
      {...rest}
    />
  );
}
