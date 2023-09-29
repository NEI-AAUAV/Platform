import React, { useState, useRef, useLayoutEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";


const Carousel = ({ children,width }) => {

    const [current , setCurrent] = useState(0);

    const previousSlide = () => {
        if(current ===0) setCurrent(children.length - 1);
        else setCurrent(current-1);
        console.log(current)
    };

    const nextSlide = () => {
        if(current === children.length - 1) setCurrent(0);
        else setCurrent(current+1);
    };

    let button1;
    if(current ===0){
        button1 = <div></div>;
    }else{
        button1 = <button onClick={previousSlide} className="pointer-events-auto">
        <svg xmlns="http://www.w3.org/2000/svg" width="21" height="36" viewBox="0 0 21 36" fill="white" transform="scale(-1,1)">
<path d="M19.7257 19.8482C20.2049 19.3124 20.4444 18.6964 20.4444 17.9999C20.4444 17.3035 20.2049 16.6874 19.7257 16.1517L4.39236 0.723153C3.85995 0.24101 3.24769 -6.10352e-05 2.55556 -6.10352e-05C1.86343 -6.10352e-05 1.25116 0.24101 0.71875 0.723153C0.239583 1.25887 0 1.87494 0 2.57137C0 3.2678 0.239583 3.88387 0.71875 4.41958L14.2951 17.9999L0.71875 31.5803C0.239583 32.116 0 32.7321 0 33.4285C0 34.1249 0.239583 34.741 0.71875 35.2767C1.25116 35.7589 1.86343 35.9999 2.55556 35.9999C3.24769 35.9999 3.85995 35.7589 4.39236 35.2767L19.7257 19.8482Z" fill="⁠efEFEF"/>
</svg>
        </button>
    }

    return (
        <div className="overflow-hidden">
        <div className="relative">
            <motion.div
             className="flex gap-8"
             animate={{x:current*(-width-16)}}
            >
                {children}
            </motion.div>
            <div className="absolute top-0 h-full w-full justify-between items-center flex text-white px-10 text-3xl pointer-events-none">
                {button1}
                <button onClick={nextSlide} className="pointer-events-auto">
                    <svg xmlns="http://www.w3.org/2000/svg" width="21" height="36" viewBox="0 0 21 36" fill="white">
                    <path d="M19.7257 19.8482C20.2049 19.3124 20.4444 18.6964 20.4444 17.9999C20.4444 17.3035 20.2049 16.6874 19.7257 16.1517L4.39236 0.723153C3.85995 0.24101 3.24769 -6.10352e-05 2.55556 -6.10352e-05C1.86343 -6.10352e-05 1.25116 0.24101 0.71875 0.723153C0.239583 1.25887 0 1.87494 0 2.57137C0 3.2678 0.239583 3.88387 0.71875 4.41958L14.2951 17.9999L0.71875 31.5803C0.239583 32.116 0 32.7321 0 33.4285C0 34.1249 0.239583 34.741 0.71875 35.2767C1.25116 35.7589 1.86343 35.9999 2.55556 35.9999C3.24769 35.9999 3.85995 35.7589 4.39236 35.2767L19.7257 19.8482Z" fill="⁠efEFEF"/>
                    </svg>  
                </button>
        </div>
        </div>
            <div className="flex justify-center py-5 gap-2 w-full">
                {children.map((s,i) =>{
                    return(
                        <button
                        onClick={() => {
                            setCurrent(i);
                        }}
                        className={`rounded-full w-3 h-3 ${i==current?'bg-white':'bg-gray-400'}`}
                        ></button>
                    )
                })}
            </div>
        </div>
    )
}

export default Carousel