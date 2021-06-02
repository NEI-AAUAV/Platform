import React, { useState, useEffect } from "react";
import { Button, Row, Col, Container } from "react-bootstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faLightbulb, faFutbol } from "@fortawesome/free-regular-svg-icons";
import { faHistory, faUsers } from "@fortawesome/free-solid-svg-icons";
import NewsList from "../News/NewsList";
import "./index.css";

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


    return (
        <div>
            <div className="section full-width">
                <Container>
                    <Row>
                        <Col md="12" lg="7" className="home-main-header">
                            <h1 className="mb-5">Bem-Vindo ao</h1>
                            <h1>Núcleo de Estudantes de Informática</h1>
                        </Col>
                        <Col>
                            bash terminal goes here
                        </Col>
                    </Row>
                </Container>
            </div>

            <div className="section-dark text-center full-width">
                <Container>
                    <h1 className="header-dark mb-4">Notícias</h1>
                    <NewsList news={news} loading={isLoading}></NewsList>
                    <Button
                        variant="outline-dark"
                        className="rounded-pill"
                        size="lg"
                        href="/noticias"
                        >Ver Todas
                    </Button>
                </Container>
            </div>

            <div className="section full-width text-center">
                <Container>
                    <h1 className="mb-3">NEI</h1>
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
                            { /* O título e a descrição não parecem bater certo,
                                o título refere-se à faina mas a descrição parece estar mais relacionada com as equipas do NEI */ }
                            <h3>Comissões de Faina</h3>
                            <p className="text-secondary">
                                Desde 2013 existiram várias coordenações, podes aqui ver quem ao longo destes anos trabalhou para tornar o NEI naquilo que é hoje, um núcleo virado para os estudantes e que ajuda os estudantes!
                            </p>
                            <a className="font-weight-bold" href="/equipa">Ver equipas</a>
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
                            <a className="font-weight-bold" href="#">Mais informações</a> { /* TODO */ }
                        </Col>
                    </Row>
                </Container>
            </div> 
        </div>
    );
}

export default Homepage;