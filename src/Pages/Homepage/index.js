import React, { useState, useEffect } from "react";
import { Button, Row, Col, Container } from "react-bootstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faLightbulb, faFutbol } from "@fortawesome/free-regular-svg-icons";
import { faHistory, faUsers } from "@fortawesome/free-solid-svg-icons";
import NewsList from "../News/NewsList";
import "./index.css";
import { ReactTerminal } from "react-terminal";

const Homepage = () => {

    const [news, setNews] = useState([]);
    const [isLoading, setIsLoading] = useState(true);

    // Get first 3 news articles from API when page loads
    useEffect(() => {
        fetch(process.env.REACT_APP_API + "/news?itemsPerPage=3")
            .then(response => response.json())
            .then((response) => {
                if('data' in response) {
                    setNews(response['data']);
                    setIsLoading(false);
                }
            });
    }, []);

    const commands = {
        whoami: "jackharper",
        cd: (directory) => `changed path to ${directory}`
      };


    return (
        <div className="py-5">
            <div className="section">
                <Col xs={11} sm={10} className="mx-auto col-xxl-9">
                    <Row>
                        <Col md="12" lg="7" className="home-main-header">
                            <h1 className="mb-5">Bem-Vindo ao</h1>
                            <h1>Núcleo de Estudantes de Informática</h1>
                        </Col>
                        <Col>
                            {//bash terminal goes here
                            }
                            {
                                <ReactTerminal
                                commands={commands}
                                themes={{
                                    myCustomTheme: {
                                      themeBGColor: "#272B36",
                                      themeToolbarColor: "#DBDBDB",
                                      themeColor: "#FFFEFC",
                                      themePromptColor: "#FFFEFC"
                                    }
                                  }}
                                  theme="myCustomTheme"
                              />
                            }
                            
                        </Col>
                    </Row>
                </Col>
            </div>

            <div className="section-dark">
                <Col xs={11} sm={10} className="mx-auto col-xxl-9 text-center">
                    <h2 className="header-dark mb-4">Notícias</h2>
                    <NewsList news={news} loading={isLoading}></NewsList>
                    <Button
                        variant="outline-dark"
                        className="rounded-pill"
                        size="lg"
                        href="/noticias"
                        >Ver Todas
                    </Button>
                </Col>
            </div>

            <div className="section">
                <Col xs={11} sm={10} className="mx-auto col-xxl-9 text-center">
                    <h2 className="mb-3">NEI</h2>
                    <h4 className="text-secondary px-5 mb-5">
                        Criado a 24 de janeiro de 2013, o Núcleo de Estudantes de Informática da Associação Académica da Universidade de Aveiro (NEI-AAUAv), surgiu com o intuito de ajudar, incentivar e apoiar em diversas áreas os alunos do curso de Engenharia Informática, que havia sido recentemente criado. Desde então, têm sido inúmeras as atividades proporcionadas por este, envolvendo não só os alunos do respetivo curso, mas também toda a comunidade académica, contribuindo, desta forma, para uma melhor formação e desenvolvimento pessoal dos seus estudantes.
                    </h4>

                    <Row>
                        <Col xs="12" sm="6" lg="3" className="home-info-col mb-5">
                            <FontAwesomeIcon icon={ faHistory } size="4x" className="text-primary mb-4" />
                            <h3>História do NEI</h3>
                            <p className="text-secondary">
                                Apesar de ser relativamente recente o NEI já conta com alguns feitos de relevância que vão desde bons resultados na Taça UA nas diversas modalidades que participou como a participação e candidaturas ao ENEI.
                            </p>
                            <a className="font-weight-bold" href="/historia">Ver história</a>
                        </Col>
                        <Col xs="12" sm="6" lg="3" className="home-info-col mb-5">
                            <FontAwesomeIcon icon={ faUsers } size="4x" className="text-primary mb-4" />
                            <h3>Comissões de Faina</h3>
                            <p className="text-secondary">
                                Responsáveis por guiar a Faina do nosso curso, uma importante faceta do percurso académico com o intuito de dinamizar e integrar os novos estudantes. Encarregam-se também de organizar certos eventos lúdicos como Jantares e Festas de Curso.
                            </p>
                            <a className="font-weight-bold" href="/faina">Ver comissões</a>
                        </Col>
                        <Col xs="12" sm="6" lg="3" className="home-info-col mb-5">
                            <FontAwesomeIcon icon={ faLightbulb } size="4x" className="text-primary mb-4" />
                            <h3>Novos Alunos</h3>
                            <p className="text-secondary">
                                Estás interessado no curso? Precisas de ajuda? Temos aqui tudo o que tu precisas, todas as informações do curso. Se tiveres dúvidas, podes entrar em contacto connosco via facebook ou email!
                            </p>
                            <a className="font-weight-bold" href="http://deti-cdn.clients.ua.pt/lei/">Mais informações</a>
                        </Col>
                        <Col xs="12" sm="6" lg="3" className="home-info-col mb-5">
                            <FontAwesomeIcon icon={ faFutbol } size="4x" className="text-primary mb-4" />
                            <h3>Taça UA</h3>
                            <p className="text-secondary">
                                Sabemos que por vezes é dificil acompanhar a Taça UA sem te perderes, como não queremos que estejas fora do acontecimento, temos uma nova plataforma para acompanhares tudo o que se passa!
                            </p>
                            <a className="font-weight-bold" href="https://taca-ua-nei-pt/">Mais informações</a> { /* TODO */ }
                        </Col>
                    </Row>
                </Col>
            </div>
        </div>
    );
}

export default Homepage;