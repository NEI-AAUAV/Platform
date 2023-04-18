import React, { useState, useEffect, useCallback, useRef } from "react";

import Particles from "react-particles";
import { loadFull } from "tsparticles";
import { loadPolygonMaskPlugin } from "tsparticles-plugin-polygon-mask";
import { loadParticlesRepulseInteraction } from "tsparticles-interaction-particles-repulse";

import service from "services/NEIService";

import ReactLogo from "assets/images/theming-gradient.svg";
// import backgroundAvif from 'assets/images/theming-gradient.png';
import { ReactComponent as BackgroundImage } from "assets/images/theming-gradient.svg";

import MockupTerminal from "components/MockupTerminal";
import NewsList2 from "../News/NewsList2";
import Partners from "./Partners";
import Merchandising from "./Merchandising";
import particlesConfig from "./particles.config";
import config from "config";

import particlesConf1 from "./particles1.config";
import particlesConf2 from "./particles2.config";
import "./index.css";
// import { PlayArrowIcon } from "assets/icons/google";
import bg from "assets/images/nei.svg";
import bg2 from "assets/images/nei-outline2.svg";
import { motion } from "framer-motion";

// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(
  process.env.REACT_APP_ANIMATION_INCREMENT
);

const Homepage = () => {
  const containerRef = [useRef(null), useRef(null)];
  const [news, setNews] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Get first 3 news articles from API when page loads
    service.getNews({ size: 3 }).then((data) => {
      setNews(data.items || []);
      setIsLoading(false);
    });
  }, []);

  const particlesInit = useCallback(async (engine) => {
    await loadPolygonMaskPlugin(engine); // awaitable
    await loadParticlesRepulseInteraction(engine);
    await loadFull(engine);
  }, []);

  function pauseAnimation() {
    if (containerRef[0].current?._paused && containerRef[1].current?._paused) {
      containerRef[0].current.play();
      containerRef[1].current.play();
    } else {
      containerRef[0].current.pause();
      containerRef[1].current.pause();
    }
  }

  return (
    <>
      {/* <img alt="background" className="w-screen h-screen" src={'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 96 96"><g opacity=".3" filter="url(#a)"><path fill="hsl(var(--p))" opacity=".5" d="M35.3 44.6c-.5 1.8-2.5 2.7-2.8 4.8 0 .5-.6 1.5-2.5 1.3-1.8 1.1-7.6-1-9 .8-1 1.3-2.1 3.1-1.7 5.5.3 1.9 1.3 3.8 2.3 5.4 1.5 2.3 3.3 4.5 5.2 6.2 6.2 5.5 13.5 6.919.7 7 7.6 0 14.1-3 19.7-7.9 2.2-2 4.3-4.3 5.9-7.3 1.4-2.7.6-5.7 3.59 0 1.1-4.1 1.8-8.7 1.3-13.7-.3-3.7-1.97.4-4.1-10.7-2.94.56.9-7-10.8-7.3-2.3-.1-5 .8-5.14.2 0 2.5 1 5.4 1.78.05.7 1.1 4.2.05.1-1.8 1.54.5 1.9-6.9 2.3-3 .3-6.3-.4-9.5-.6-1.8-.1-3.3.8-4.6 1.9-1.092"/></g><g opacity=".3" filter="url(#b)"><path fill="hsl(var(--s))" opacity=".5" d="M35.3 44.6c-.5 1.8-2.5 2.7-2.8 4.8 0 .5-.6 1.5-2.5 1.3-1.8 1.1-7.6-1-9 .8-1 1.3-2.1 3.1-1.7 5.5.3 1.9 1.3 3.8 2.3 5.4 1.5 2.3 3.3 4.5 5.2 6.2 6.2 5.5 13.5 6.919.7 7 7.6 0 14.1-3 19.7-7.9 2.2-2 4.3-4.3 5.9-7.3 1.4-2.7.6-5.7 3.59 0 1.1-4.1 1.8-8.7 1.3-13.7-.3-3.7-1.97.4-4.1-10.7-2.94.56.9-7-10.8-7.3-2.3-.1-5 .8-5.14.2 0 2.5 1 5.4 1.78.05.7 1.1 4.2.05.1-1.8 1.54.5 1.9-6.9 2.3-3 .3-6.3-.4-9.5-.6-1.8-.1-3.3.8-4.6 1.9-1.092"/></g><defs><filter id="a" x="0" y="0" width="96" height="96" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur stdDeviation="10" result="effect1_foregroundBlur_577_931"/></filter><filter id="b" x="0" y="0" width="96" height="96" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur stdDeviation="10" result="effect1_foregroundBlur_577_931"/></filter></defs></svg>'} ></img>
            <div className="w-screen h-screen flex-none flex justify-end" style={{backgroundImage: `url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 96'%3E%3Cg opacity='.3' filter='url(%23a)'%3E%3Cpath fill='red' opacity='.5' d='M35.3 44.6c-.5 1.8-2.5 2.7-2.8 4.8 0 .5-.6 1.5-2.5 1.3-1.8 1.1-7.6-1-9 .8-1 1.3-2.1 3.1-1.7 5.5.3 1.9 1.3 3.8 2.3 5.4 1.5 2.3 3.3 4.5 5.2 6.2 6.2 5.5 13.5 6.919.7 7 7.6 0 14.1-3 19.7-7.9 2.2-2 4.3-4.3 5.9-7.3 1.4-2.7.6-5.7 3.59 0 1.1-4.1 1.8-8.7 1.3-13.7-.3-3.7-1.97.4-4.1-10.7-2.94.56.9-7-10.8-7.3-2.3-.1-5 .8-5.14.2 0 2.5 1 5.4 1.78.05.7 1.1 4.2.05.1-1.8 1.54.5 1.9-6.9 2.3-3 .3-6.3-.4-9.5-.6-1.8-.1-3.3.8-4.6 1.9-1.092'/%3E%3C/g%3E%3Cg opacity='.3' filter='url(%23b)'%3E%3Cpath fill='red' opacity='.5' d='M35.3 44.6c-.5 1.8-2.5 2.7-2.8 4.8 0 .5-.6 1.5-2.5 1.3-1.8 1.1-7.6-1-9 .8-1 1.3-2.1 3.1-1.7 5.5.3 1.9 1.3 3.8 2.3 5.4 1.5 2.3 3.3 4.5 5.2 6.2 6.2 5.5 13.5 6.919.7 7 7.6 0 14.1-3 19.7-7.9 2.2-2 4.3-4.3 5.9-7.3 1.4-2.7.6-5.7 3.59 0 1.1-4.1 1.8-8.7 1.3-13.7-.3-3.7-1.97.4-4.1-10.7-2.94.56.9-7-10.8-7.3-2.3-.1-5 .8-5.14.2 0 2.5 1 5.4 1.78.05.7 1.1 4.2.05.1-1.8 1.54.5 1.9-6.9 2.3-3 .3-6.3-.4-9.5-.6-1.8-.1-3.3.8-4.6 1.9-1.092'/%3E%3C/g%3E%3Cdefs%3E%3Cfilter id='a' x='0' y='0' width='96' height='96' filterUnits='userSpaceOnUse' color-interpolation-filters='sRGB'%3E%3CfeFlood flood-opacity='0' result='BackgroundImageFix'/%3E%3CfeBlend in='SourceGraphic' in2='BackgroundImageFix' result='shape'/%3E%3CfeGaussianBlur stdDeviation='10' result='effect1_foregroundBlur_577_931'/%3E%3C/filter%3E%3Cfilter id='b' x='0' y='0' width='96' height='96' filterUnits='userSpaceOnUse' color-interpolation-filters='sRGB'%3E%3CfeFlood flood-opacity='0' result='BackgroundImageFix'/%3E%3CfeBlend in='SourceGraphic' in2='BackgroundImageFix' result='shape'/%3E%3CfeGaussianBlur stdDeviation='10' result='effect1_foregroundBlur_577_931'/%3E%3C/filter%3E%3C/defs%3E%3C/svg%3E")`}}></div> */}
      {/* <div className="w-screen h-screen flex-none flex justify-end">
                <picture>
                    <img src={background} alt="" className="w-[90rem] flex-none max-w-none hidden dark:block" decoding="async" />
                    <source srcset={backgroundAvif} type="image/png" />
                </picture>
            </div> */}

      {/* <BackgroundImage className="w-[10rem] md:w-[30rem] lg:w-[60rem]" /> */}

      {/* <img className="absolute left-0 w-[850px]" style={{filter: "brightness(0.1) invert(1)", opacity: 0.2}} src={bg} />  */}

      <div className="pointer-events-none absolute inset-0 truncate">
        <div className="gradient-blur absolute left-[100px] top-[-50px] transition-size duration-500" />
        <div className="gradient-blur absolute right-[-150px] top-[50vh] transition-size duration-500" />
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 4 }}
        >
          <Particles
            className="absolute h-screen w-screen"
            options={particlesConfig}
            init={particlesInit}
          />
        </motion.div>
      </div>
      <div className="relative my-10">
        <div className="mb-72 grid grid-cols-1 gap-4 lg:mt-20 lg:grid-cols-2">
          <div className="flex flex-col justify-between">
            <div className="relative top-[-80px] hidden h-full opacity-0 transition-opacity lg:block lg:opacity-80">
              <img
                className="absolute -top-[50px] h-[600px] w-[600px]"
                src={bg}
              />
              {/* <Particles
                container={containerRef[0]}
                className="absolute h-[500px] w-[500px]"
                id="particles1"
                options={particlesConf1}
                init={particlesInit}
              /> */}
              {/* <Particles
                container={containerRef[1]}
                className="absolute h-[500px] w-[500px]"
                id="particles2"
                options={particlesConf2}
                init={particlesInit}
              /> */}
              {/* <div className="absolute top-1/2 left-0 right-0 m-auto -translate-y-1/2 ">
                <PlayArrowIcon
                  className="cursor-pointer"
                  height={"50"}
                  width={"50"}
                  onClick={pauseAnimation}
                />
              </div> */}
            </div>
            <div className="z-1 relative text-4xl leading-tight lg:text-5xl">
              <span className="text-3xl lg:text-4xl">Bem-vindo ao</span>
              <br />
              <span className="font-extrabold">Núcleo de Estudantes de </span>
              <span className="bg-gradient-to-r from-success to-[#548786] bg-clip-text font-extrabold text-transparent drop-shadow-lg">
                Informática
              </span>{" "}
              {/* <span className="font-extrabold">da AAUAv</span> */}
            </div>
          </div>
          <div
            className="slideUpFade"
            style={{ animationDelay: animationBase + 1 * animationIncrement }}
          >
            <MockupTerminal />
          </div>
        </div>

        {!!config.PRODUCTION && (
          <>
            <section className="relative left-1/2 w-screen translate-x-[-50%] bg-base-content/10 p-20 shadow-md backdrop-blur-lg">
              <Partners />
            </section>

            <section className="p-20">
              <div
                className="flex flex-col mx-auto flex-wrap text-center"
              >
                <h2 className="header-dark mb-4">Notícias</h2>
                {!!isLoading ? (
                  <div
                    animation="grow"
                    variant="primary"
                    className="loading mx-auto mb-3"
                    title="A carregar..."
                  />
                ) : (
                  <NewsList2 news={news}></NewsList2>
                )}
                <a className="btn mx-auto" href="/news">
                  Ver Todas
                </a>
              </div>
            </section>
          </>
        )}
        <section className="py-20">
          <Merchandising />
        </section>
      </div>
    </>
  );
};

export default Homepage;
