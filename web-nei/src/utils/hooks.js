import { useEffect, useState } from "react";

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
        window.addEventListener('resize', handleResize);
        handleResize();
        return () => window.removeEventListener('resize', handleResize);
    }, []);

    return windowSize;
}

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
        window.addEventListener('scroll', handleScroll);
        handleScroll();
        return () => window.removeEventListener('scroll', handleScroll);
    }, []);

    return windowScroll;
}
