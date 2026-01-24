import React from "react";
import malePic from "assets/default_profile/male.svg";
import femalePic from "assets/default_profile/female.svg";
import otherPic from "assets/default_profile/other.svg";

/**
 * Safely resolve an image URL, falling back to a default avatar when the URL
 * is missing, invalid, or uses an unexpected/unsafe scheme.
 */
function getSafeImage(image, fallback) {
  if (!image) {
    return fallback;
  }

  try {
    // Support both absolute and relative URLs
    const url = new URL(image, window.location.origin);
    const protocol = url.protocol.toLowerCase();

    // Allow common safe schemes, including blob: for local previews
    if (protocol === "http:" || protocol === "https:" || protocol === "blob:") {
      return url.href;
    }
  } catch {
    // If URL construction fails, fall back to default
    return fallback;
  }

  return fallback;
}

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
  const initialSrc = getSafeImage(image, fallback);
  const [src, setSrc] = React.useState(initialSrc);

  React.useEffect(() => {
    setSrc(getSafeImage(image, fallback));
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
