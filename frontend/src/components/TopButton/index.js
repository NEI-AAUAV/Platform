

import React, { useState, useEffect } from "react";

import FloatingBtns from './FloatingBtns';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faChevronUp } from '@fortawesome/free-solid-svg-icons';


const TopButton = () => {
    // Back to top button
    const [top, setTop] = useState(true);
    useEffect(() => {
        window.addEventListener('scroll', scrollHandler);
    }, [document.documentElement.scrollTop, window.pageYOffset]);

    const scrollHandler = () => {
        var top = window.pageYOffset || document.documentElement.scrollTop;
        if (top > 100) {
            setTop(false);
        } else {
            setTop(true);
        }
    }

    return (
        <FloatingBtns location="bottomRight">
            {
                !top &&
                <button
                    className="btn btn-outline-primary btn-outline-primary-force rounded-circle mt-1 animation"
                    title="Voltar ao topo"
                    onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
                >
                    <FontAwesomeIcon icon={faChevronUp} />
                </button>
            }
            {/*
                    window.location.href.indexOf("/forms/feedback") < 0
                    &&
                    <button
                        className="btn  btn-outline-primary btn-outline-primary-force rounded-circle mt-1 animation"
                        title="Dá-nos o teu feedback!"
                        onClick={() => window.location.replace("/forms/feedback")}
                    >
                        <FontAwesomeIcon icon={faComment} />
                    </button>
                */}
        </FloatingBtns>
    );
}

export default TopButton;