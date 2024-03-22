import { useEffect, useState, useRef, useCallback } from "react";
import config from "config";

export const useWindowSize = () => {
  const [windowSize, setWindowSize] = useState({
    width: undefined,
    height: undefined,
  });

  useEffect(() => {
    function handleResize() {
      setWindowSize({
        width: window.innerWidth,
        height: window.innerHeight,
      });
    }
    window.addEventListener("resize", handleResize);
    handleResize();
    return () => window.removeEventListener("resize", handleResize);
  }, []);

  return windowSize;
};

export const useWindowScroll = () => {
  const [windowScroll, setWindowScroll] = useState({
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
};

export const useReCaptcha = () => {
  const [reCaptchaLoaded, setReCaptchaLoaded] = useState(false);

  useEffect(() => {
    function reCaptchaLoad() {
      setReCaptchaLoaded(true);
    }

    // Check that we aren't in a worker or that the reCaptcha was already loaded
    if (typeof window === "undefined" || reCaptchaLoaded) return;

    // Check that the reCaptcha wasn't already loaded by someone else
    if (window.grecaptcha) {
      setReCaptchaLoaded(true);
      return;
    }

    // Create a new script node for the reCaptcha script
    const script = document.createElement("script");
    script.async = true; // Don't stall the page load
    script.src = `${config.GOOGLE_RECAPTCHA_CDN}?render=${config.GOOGLE_RECAPTCHA_KEY}`;
    script.addEventListener("load", reCaptchaLoad);
    // Add the script node to the DOM
    document.body.appendChild(script);

    // Remove the event listener in order to not leak memory
    return () => window.removeEventListener("load", reCaptchaLoad);
  }, [reCaptchaLoaded]);

  // Get token
  const generateReCaptchaToken = (action) => {
    return new Promise((resolve, reject) => {
      if (!reCaptchaLoaded) return reject(new Error("ReCaptcha not loaded"));

      if (typeof window === "undefined" || !window.grecaptcha) {
        setReCaptchaLoaded(false);
        return reject(new Error("ReCaptcha not loaded"));
      }

      window.grecaptcha.ready(() => {
        window.grecaptcha
          .execute(config.GOOGLE_RECAPTCHA_KEY, { action })
          .then(resolve);
      });
    });
  };

  return { reCaptchaLoaded, generateReCaptchaToken };
};

/**
 * Set loading to false only after 1 second has elapsed since
 * the last time loading was set to true.
 *
 * TODO: this should be useDebouncedUpdateState
 */
export const useLoading = (value) => {
  let startTime = Date.now();
  let remainingTime = useRef(0);
  const [loading, setLoading] = useState(null);
  const [deferLoading, setDeferLoading] = useState(value);

  useEffect(() => {
    if (loading === null) {
      return;
    }
    let timeoutId = setTimeout(() => {
      setDeferLoading(loading);
      setLoading(null);
    }, remainingTime.current);

    return () => {
      clearTimeout(timeoutId);
    };
  }, [loading]);

  function setLoadingWithDelay(value, delay = 0) {
    remainingTime.current = Math.max(0, delay - (Date.now() - startTime));
    startTime = Date.now();
    setLoading(value);
  }

  return [deferLoading, setLoadingWithDelay];
};

function useDebouncedState(initialState, delay) {
  const [state, setState] = useState(initialState);
  const [timerId, setTimerId] = useState(null);

  const debounce = useCallback(
    (callback, delay) => {
      return (...args) => {
        if (timerId) {
          clearTimeout(timerId);
        }
        setTimerId(
          setTimeout(() => {
            callback(...args);
            setTimerId(null);
          }, delay)
        );
      };
    },
    [timerId]
  );

  const debouncedSetState = debounce(setState, delay);

  useEffect(() => {
    return () => {
      if (timerId) {
        clearTimeout(timerId);
      }
    };
  }, [timerId]);

  return [state, debouncedSetState];
}
