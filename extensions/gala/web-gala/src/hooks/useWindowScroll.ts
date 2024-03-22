import { useEffect, useState } from "react";

export default function useWindowScroll() {
  const [windowScroll, setWindowScroll] = useState<{ x?: number; y?: number }>({
    x: undefined,
    y: undefined,
  });

  useEffect(() => {
    function handleScroll() {
      setWindowScroll({
        x: window.pageXOffset,
        y: window.pageYOffset,
      });
    }
    window.addEventListener("scroll", handleScroll);
    handleScroll();
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return windowScroll;
}
