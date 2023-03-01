import React, { useState, useEffect, useCallback } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faLightbulb, faFutbol } from "@fortawesome/free-regular-svg-icons";
import { faHistory, faUsers } from "@fortawesome/free-solid-svg-icons";

import Particles from "react-particles";
import { loadFull } from "tsparticles";
import { loadPolygonMaskPlugin } from "tsparticles-plugin-polygon-mask";
import { loadParticlesRepulseInteraction } from "tsparticles-interaction-particles-repulse";

import service from 'services/NEIService';
import MockupTerminal from 'components/MockupTerminal';

import ReactLogo from 'assets/images/theming-gradient.svg';
// import backgroundAvif from 'assets/images/theming-gradient.png';
import { ReactComponent as BackgroundImage } from 'assets/images/theming-gradient.svg';

import NewsList from "../News/NewsList";
import terminalConf from "./terminal.conf";
import particlesConf1 from "./particles1.config";
import particlesConf2 from "./particles2.config";

import "./index.css";
// import bg from 'assets/images/nei-white.svg';
// import bg2 from 'assets/images/nei-outline2.svg';

// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);

const Homepage = () => {
    const [news, setNews] = useState([]);
    const [isLoading, setIsLoading] = useState(true);

    const [banner, setBanner] = useState(undefined);

    useEffect(() => {
        // Get first 3 news articles from API when page loads
        service.getNews({ size: 3 })
            .then((data) => {
                setNews(data.items || []);
                setIsLoading(false);
            });

        // Get partner banner
        service.getPartnersBanner()
            .then((data) => {
                setBanner(data);
            });
    }, []);

    const particlesInit = useCallback(async (engine) => {
        await loadPolygonMaskPlugin(engine); // awaitable
        await loadParticlesRepulseInteraction(engine);
        await loadFull(engine);
    }, [])

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
            <div className="gradient-blur absolute top-[-50px] transition-size duration-500" />
            <div className="gradient-blur absolute bottom-0 right-[-150px] transition-size duration-500" />


            {/* <img className="absolute left-0 w-[850px]" style={{filter: "brightness(0.1) invert(1)", opacity: 0.2}} src={bg} />
            <img className="absolute left-0 w-[850px]" src={bg2} /> */}


            <div className="grid grid-cols-1 lg:grid-cols-2 gap-4 mt-10 lg:mt-20 mb-72">
                <div className="flex flex-col justify-between">
                    <div className="relative hidden lg:block top-[-80px] transition-opacity opacity-0 lg:opacity-80">
                        <Particles className="absolute w-[500px] h-[500px]" id="particles1" options={particlesConf1} init={particlesInit} />
                        <Particles className="absolute w-[500px] h-[500px]" id="particles2" options={particlesConf2} init={particlesInit} />
                    </div>
                    <div className="relative z-1 text-4xl lg:text-5xl leading-tight">
                        <span className="text-3xl lg:text-4xl">Bem-vindo ao</span>
                        <br />
                        <span className="font-extrabold">Núcleo de Estudantes de{' '}</span>
                        <span className="drop-shadow-lg font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-success to-[#548786]">Informática</span>{' '}
                        <span className="font-extrabold">da AAUAv</span>
                    </div>
                </div>
                <div className="slideUpFade" style={{ animationDelay: animationBase + 1 * animationIncrement }}>
                    <MockupTerminal />
                </div>
            </div>

            {
                !!banner &&
                <div xs={11} sm={10} className="mx-auto col-xxl-9 my-3">
                    <a href={banner.banner_url} target="_blank">
                        <img
                            src={banner.banner_image}
                            className="w-100"
                        />
                        <p className="mb-0 text-primary text-center small">O NEI é apoiado pela {banner.company}</p>
                    </a>
                </div>
            }

            <div className="section-dark">
                <div xs={11} sm={10} className="d-flex flex-column flex-wrap mx-auto col-xxl-9 text-center">
                    <h2 className="header-dark mb-4">Notícias</h2>
                    {
                        !!isLoading
                            ?
                            <div animation="grow" variant="primary" className="mx-auto mb-3 loading" title="A carregar..." />
                            :
                            <NewsList news={news}></NewsList>
                    }
                    <div
                        variant="outline-dark"
                        className="btn rounded-pill mx-auto"
                        size="lg"
                        href="/noticias"
                    >Ver Todas
                    </div>
                </div>
            </div>

            <div className="section">
                <div xs={11} sm={10} className="mx-auto col-xxl-9 text-center">
                    <h2 className="mb-3">NEI</h2>
                    <h4 className="text-secondary px-lg-5 mb-5">
                        Criado a 24 de janeiro de 2013, o Núcleo de Estudantes de Informática da Associação Académica da Universidade de Aveiro (NEI-AAUAv), surgiu com o intuito de ajudar, incentivar e apoiar em diversas áreas os alunos do curso de Engenharia Informática, que havia sido recentemente criado. Desde então, têm sido inúmeras as atividades proporcionadas por este, envolvendo não só os alunos do respetivo curso, mas também toda a comunidade académica, contribuindo, desta forma, para uma melhor formação e desenvolvimento pessoal dos seus estudantes.
                    </h4>

                    <div>
                        <div xs="12" sm="6" lg="3" className="mb-5">
                            <FontAwesomeIcon icon={faHistory} size="4x" className="text-primary mb-4" />
                            <h3>História do NEI</h3>
                            <p className="text-secondary flex-grow-1">
                                Apesar de ser relativamente recente o NEI já conta com alguns feitos de relevância que vão desde bons resultados na Taça UA nas diversas modalidades que participou como a participação e candidaturas ao ENEI.
                            </p>
                            <a className="font-weight-bold" href="/historia">Ver história</a>
                        </div>
                        <div xs="12" sm="6" lg="3" className="mb-5">
                            <FontAwesomeIcon icon={faUsers} size="4x" className="text-primary mb-4" />
                            <h3>Comissões de Faina</h3>
                            <p className="text-secondary flex-grow-1">
                                Responsáveis por guiar a Faina do nosso curso, uma importante faceta do percurso académico com o intuito de dinamizar e integrar os novos estudantes. Encarregam-se também de organizar certos eventos lúdicos como Jantares e Festas de Curso.
                            </p>
                            <a className="font-weight-bold" href="/faina">Ver comissões</a>
                        </div>
                        <div xs="12" sm="6" lg="3" className="mb-5">
                            <FontAwesomeIcon icon={faLightbulb} size="4x" className="text-primary mb-4" />
                            <h3>Novos Alunos</h3>
                            <p className="text-secondary flex-grow-1">
                                Estás interessado no curso? Precisas de ajuda? Temos aqui tudo o que tu precisas, todas as informações do curso. Se tiveres dúvidas, podes entrar em contacto connosco via facebook ou email!
                            </p>
                            <a className="font-weight-bold" href="http://deti-cdn.clients.ua.pt/lei/">Mais informações</a>
                        </div>
                        <div xs="12" sm="6" lg="3" className="mb-5">
                            <FontAwesomeIcon icon={faFutbol} size="4x" className="text-primary mb-4" />
                            <h3>Taça UA</h3>
                            <p className="text-secondary flex-grow-1">
                                Sabemos que por vezes é dificil acompanhar a Taça UA sem te perderes, como não queremos que estejas fora do acontecimento, temos uma nova plataforma para acompanhares tudo o que se passa!
                            </p>
                            <p className="font-weight-bold text-secondary mb-0">Brevemente disponível</p>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}

export default Homepage;