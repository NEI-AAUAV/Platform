import React, { useState, useEffect } from "react";
import { Button, Row, Col, Spinner } from "react-bootstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faLightbulb, faFutbol } from "@fortawesome/free-regular-svg-icons";
import { faHistory, faUsers } from "@fortawesome/free-solid-svg-icons";
import Typist from 'react-typist';
import { ReactTerminal } from "react-terminal-component";
import Particles from "react-tsparticles";

import service from 'services/NEIService';
import MockupTerminal from 'components/MockupTerminal';
import ReactLogo from 'assets/images/theming-gradient.svg';
// import backgroundAvif from 'assets/images/theming-gradient.png';
import { ReactComponent as BackgroundImage } from 'assets/images/theming-gradient.svg';

import terminalstate from "./terminalconf";
import backgroundconfig from "./backgroundconfig";
import NewsList from "../News/NewsList";
import "./index.css";

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

    return (
        <>
            {/* <img alt="background" className="w-screen h-screen" src={'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 96 96"><g opacity=".3" filter="url(#a)"><path fill="hsl(var(--p))" opacity=".5" d="M35.3 44.6c-.5 1.8-2.5 2.7-2.8 4.8 0 .5-.6 1.5-2.5 1.3-1.8 1.1-7.6-1-9 .8-1 1.3-2.1 3.1-1.7 5.5.3 1.9 1.3 3.8 2.3 5.4 1.5 2.3 3.3 4.5 5.2 6.2 6.2 5.5 13.5 6.919.7 7 7.6 0 14.1-3 19.7-7.9 2.2-2 4.3-4.3 5.9-7.3 1.4-2.7.6-5.7 3.59 0 1.1-4.1 1.8-8.7 1.3-13.7-.3-3.7-1.97.4-4.1-10.7-2.94.56.9-7-10.8-7.3-2.3-.1-5 .8-5.14.2 0 2.5 1 5.4 1.78.05.7 1.1 4.2.05.1-1.8 1.54.5 1.9-6.9 2.3-3 .3-6.3-.4-9.5-.6-1.8-.1-3.3.8-4.6 1.9-1.092"/></g><g opacity=".3" filter="url(#b)"><path fill="hsl(var(--s))" opacity=".5" d="M35.3 44.6c-.5 1.8-2.5 2.7-2.8 4.8 0 .5-.6 1.5-2.5 1.3-1.8 1.1-7.6-1-9 .8-1 1.3-2.1 3.1-1.7 5.5.3 1.9 1.3 3.8 2.3 5.4 1.5 2.3 3.3 4.5 5.2 6.2 6.2 5.5 13.5 6.919.7 7 7.6 0 14.1-3 19.7-7.9 2.2-2 4.3-4.3 5.9-7.3 1.4-2.7.6-5.7 3.59 0 1.1-4.1 1.8-8.7 1.3-13.7-.3-3.7-1.97.4-4.1-10.7-2.94.56.9-7-10.8-7.3-2.3-.1-5 .8-5.14.2 0 2.5 1 5.4 1.78.05.7 1.1 4.2.05.1-1.8 1.54.5 1.9-6.9 2.3-3 .3-6.3-.4-9.5-.6-1.8-.1-3.3.8-4.6 1.9-1.092"/></g><defs><filter id="a" x="0" y="0" width="96" height="96" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur stdDeviation="10" result="effect1_foregroundBlur_577_931"/></filter><filter id="b" x="0" y="0" width="96" height="96" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB"><feFlood flood-opacity="0" result="BackgroundImageFix"/><feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape"/><feGaussianBlur stdDeviation="10" result="effect1_foregroundBlur_577_931"/></filter></defs></svg>'} ></img>
            <div className="w-screen h-screen flex-none flex justify-end" style={{backgroundImage: `url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 96'%3E%3Cg opacity='.3' filter='url(%23a)'%3E%3Cpath fill='red' opacity='.5' d='M35.3 44.6c-.5 1.8-2.5 2.7-2.8 4.8 0 .5-.6 1.5-2.5 1.3-1.8 1.1-7.6-1-9 .8-1 1.3-2.1 3.1-1.7 5.5.3 1.9 1.3 3.8 2.3 5.4 1.5 2.3 3.3 4.5 5.2 6.2 6.2 5.5 13.5 6.919.7 7 7.6 0 14.1-3 19.7-7.9 2.2-2 4.3-4.3 5.9-7.3 1.4-2.7.6-5.7 3.59 0 1.1-4.1 1.8-8.7 1.3-13.7-.3-3.7-1.97.4-4.1-10.7-2.94.56.9-7-10.8-7.3-2.3-.1-5 .8-5.14.2 0 2.5 1 5.4 1.78.05.7 1.1 4.2.05.1-1.8 1.54.5 1.9-6.9 2.3-3 .3-6.3-.4-9.5-.6-1.8-.1-3.3.8-4.6 1.9-1.092'/%3E%3C/g%3E%3Cg opacity='.3' filter='url(%23b)'%3E%3Cpath fill='red' opacity='.5' d='M35.3 44.6c-.5 1.8-2.5 2.7-2.8 4.8 0 .5-.6 1.5-2.5 1.3-1.8 1.1-7.6-1-9 .8-1 1.3-2.1 3.1-1.7 5.5.3 1.9 1.3 3.8 2.3 5.4 1.5 2.3 3.3 4.5 5.2 6.2 6.2 5.5 13.5 6.919.7 7 7.6 0 14.1-3 19.7-7.9 2.2-2 4.3-4.3 5.9-7.3 1.4-2.7.6-5.7 3.59 0 1.1-4.1 1.8-8.7 1.3-13.7-.3-3.7-1.97.4-4.1-10.7-2.94.56.9-7-10.8-7.3-2.3-.1-5 .8-5.14.2 0 2.5 1 5.4 1.78.05.7 1.1 4.2.05.1-1.8 1.54.5 1.9-6.9 2.3-3 .3-6.3-.4-9.5-.6-1.8-.1-3.3.8-4.6 1.9-1.092'/%3E%3C/g%3E%3Cdefs%3E%3Cfilter id='a' x='0' y='0' width='96' height='96' filterUnits='userSpaceOnUse' color-interpolation-filters='sRGB'%3E%3CfeFlood flood-opacity='0' result='BackgroundImageFix'/%3E%3CfeBlend in='SourceGraphic' in2='BackgroundImageFix' result='shape'/%3E%3CfeGaussianBlur stdDeviation='10' result='effect1_foregroundBlur_577_931'/%3E%3C/filter%3E%3Cfilter id='b' x='0' y='0' width='96' height='96' filterUnits='userSpaceOnUse' color-interpolation-filters='sRGB'%3E%3CfeFlood flood-opacity='0' result='BackgroundImageFix'/%3E%3CfeBlend in='SourceGraphic' in2='BackgroundImageFix' result='shape'/%3E%3CfeGaussianBlur stdDeviation='10' result='effect1_foregroundBlur_577_931'/%3E%3C/filter%3E%3C/defs%3E%3C/svg%3E")`}}></div> */}
            {/* <div class="w-screen h-screen flex-none flex justify-end">
                <picture>
                    <img src={background} alt="" class="w-[90rem] flex-none max-w-none hidden dark:block" decoding="async" />
                    <source srcset={backgroundAvif} type="image/png" />
                </picture>
            </div> */}

            {/* <BackgroundImage className="w-[10rem] md:w-[30rem] lg:w-[60rem]" /> */}

            <div class="gradient-blur absolute z-0 right-0 transition-size duration-500"></div>

            <Particles
                id="tsparticles"
                options={backgroundconfig}
                className="absolute"
            />

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 mb-72">
                <div>
                    <h1 className="d-none d-md-block">
                        <Typist>
                            Bem-vindo ao
                            <br /><br />
                            <b>Núcleo de Estudantes de Informática</b>
                            <br />
                            da AAUAv
                        </Typist>
                    </h1>
                </div>
                <div className="slideUpFade" style={{ animationDelay: animationBase + 1 * animationIncrement }}>
                    <MockupTerminal />
                </div>
            </div>

            {
                !!banner &&
                <Col xs={11} sm={10} className="mx-auto col-xxl-9 my-3">
                    <a href={banner.banner_url} target="_blank">
                        <img
                            src={banner.banner_image}
                            className="w-100"
                        />
                        <p className="mb-0 text-primary text-center small">O NEI é apoiado pela {banner.company}</p>
                    </a>
                </Col>
            }

            <div className="section-dark">
                <Col xs={11} sm={10} className="d-flex flex-column flex-wrap mx-auto col-xxl-9 text-center">
                    <h2 className="header-dark mb-4">Notícias</h2>
                    {
                        !!isLoading
                            ?
                            <Spinner animation="grow" variant="primary" className="mx-auto mb-3" title="A carregar..." />
                            :
                            <NewsList news={news}></NewsList>
                    }
                    <Button
                        variant="outline-dark"
                        className="rounded-pill mx-auto"
                        size="lg"
                        href="/noticias"
                    >Ver Todas
                    </Button>
                </Col>
            </div>

            <div className="section">
                <Col xs={11} sm={10} className="mx-auto col-xxl-9 text-center">
                    <h2 className="mb-3">NEI</h2>
                    <h4 className="text-secondary px-lg-5 mb-5">
                        Criado a 24 de janeiro de 2013, o Núcleo de Estudantes de Informática da Associação Académica da Universidade de Aveiro (NEI-AAUAv), surgiu com o intuito de ajudar, incentivar e apoiar em diversas áreas os alunos do curso de Engenharia Informática, que havia sido recentemente criado. Desde então, têm sido inúmeras as atividades proporcionadas por este, envolvendo não só os alunos do respetivo curso, mas também toda a comunidade académica, contribuindo, desta forma, para uma melhor formação e desenvolvimento pessoal dos seus estudantes.
                    </h4>

                    <Row>
                        <Col xs="12" sm="6" lg="3" className="home-info-col mb-5">
                            <FontAwesomeIcon icon={faHistory} size="4x" className="text-primary mb-4" />
                            <h3>História do NEI</h3>
                            <p className="text-secondary flex-grow-1">
                                Apesar de ser relativamente recente o NEI já conta com alguns feitos de relevância que vão desde bons resultados na Taça UA nas diversas modalidades que participou como a participação e candidaturas ao ENEI.
                            </p>
                            <a className="font-weight-bold" href="/historia">Ver história</a>
                        </Col>
                        <Col xs="12" sm="6" lg="3" className="home-info-col mb-5">
                            <FontAwesomeIcon icon={faUsers} size="4x" className="text-primary mb-4" />
                            <h3>Comissões de Faina</h3>
                            <p className="text-secondary flex-grow-1">
                                Responsáveis por guiar a Faina do nosso curso, uma importante faceta do percurso académico com o intuito de dinamizar e integrar os novos estudantes. Encarregam-se também de organizar certos eventos lúdicos como Jantares e Festas de Curso.
                            </p>
                            <a className="font-weight-bold" href="/faina">Ver comissões</a>
                        </Col>
                        <Col xs="12" sm="6" lg="3" className="home-info-col mb-5">
                            <FontAwesomeIcon icon={faLightbulb} size="4x" className="text-primary mb-4" />
                            <h3>Novos Alunos</h3>
                            <p className="text-secondary flex-grow-1">
                                Estás interessado no curso? Precisas de ajuda? Temos aqui tudo o que tu precisas, todas as informações do curso. Se tiveres dúvidas, podes entrar em contacto connosco via facebook ou email!
                            </p>
                            <a className="font-weight-bold" href="http://deti-cdn.clients.ua.pt/lei/">Mais informações</a>
                        </Col>
                        <Col xs="12" sm="6" lg="3" className="home-info-col mb-5">
                            <FontAwesomeIcon icon={faFutbol} size="4x" className="text-primary mb-4" />
                            <h3>Taça UA</h3>
                            <p className="text-secondary flex-grow-1">
                                Sabemos que por vezes é dificil acompanhar a Taça UA sem te perderes, como não queremos que estejas fora do acontecimento, temos uma nova plataforma para acompanhares tudo o que se passa!
                            </p>
                            <p className="font-weight-bold text-secondary mb-0">Brevemente disponível</p>
                        </Col>
                    </Row>
                </Col>
            </div>
        </>
    );
}

export default Homepage;