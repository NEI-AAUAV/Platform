import './index.css';
import Card from 'react-bootstrap/Card';
import InternshipCard from './InternshipCard';
import SmallInternshipCard from './SmallInternshipCard';
import { Col, Row } from 'react-bootstrap';
import Typist from 'react-typist';
import MiniInternshipCard from './MiniIntershipCard';
import MediumInternshipCard from './MediumInternshipCard';
import BigInternshipCard from './BigInternshipCard';

const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(
  process.env.REACT_APP_ANIMATION_INCREMENT
);

const Internship = () => {
    return (
        <div d-flex flex-column flex-wrap
        className="slideUpFade"
        style={{ animationDelay: animationBase + animationIncrement }}>
            <h2 className="mb-5 text-center"><Typist>Oportunidades de Estágio</Typist></h2>
            <Row>
                <Col>
                <BigInternshipCard 
                    title='TecmaFoods'
                    position='Gestão de Sistemas Informáticos & IoT'
                    duration='Estágio de verão (remoto)'
                    quality='Criação de sistema de controlo ERP (excel ou semelhante)'
                    quality2='Criação de sistema de controlo de qualidade de auditoria'
                    quality3='Aplicação para coleção de dados - estilo formulário ligado a base de dados'
                    quality4='IoT de sondas e sensores'
                    quality5='Oferecemos: subsídio de alimentação'
                    link='https://trackonperformance.com/'
                />
                </Col>
                <Col>
                <BigInternshipCard 
                    title='EatTasty'
                    duration='Contrato Full Time'
                    position='Full Stack Developer (Lisboa)'
                    quality='Experiência com frontend ou backend com JavaScript, HTML, AJAX, JSON e CSS/SASS'
                    quality2='Experiência com ExpressJS ou uma framework JavaScript Semelhante'
                    quality3='Conhecimento de base de dados NoSQL e relacionais, especialmente MongoDB, Redis e PostgreSQL'
                    quality4='Sólidos conhecimentos de especificidades e problemas de compatibilidade em browsers'
                    quality5='Benefícios oferecidos: contrato de trabalho, subsídio refeição, vales de refeição na EatTasty,
                    horário flexível, trabalho na sexta-feira até às 15h, dias de folga oferecidos nos dias de anos e dos
                    filhos, seguro de saúde e plano de benefícios Coverflex'
                    link='https://www.decisioneyes.com/'
                />
                </Col>
            </Row>
            <Row>
                <Col>
                <InternshipCard 
                    title='CheckFirst app'
                    position='IT Internships'
                    duration='Estágio de 3 ou 6 meses (remoto ou presencial, em Lisboa, com oportunidade para integrar equipa no final)'
                    quality='Operações'
                    quality2='Tecnologia'
                    quality3='Design de produto (UX/UI)'
                    quality4='Oferecemos: deslocação (caso se aplique) e subsídio de alimentação'
                    link='https://trackonperformance.com/'
                />
                </Col>
                <Col>
                <InternshipCard 
                    title='Decision Eyes'
                    duration='Estágio de Verão (com oportunidade para integrar equipa no final)'
                    position='Developer (2º ou 3º ano da licenciatura)'
                    quality='Conhecimentos de ASP.Net e SQL Server'
                    quality2='JavaScript, JQuery, html e bootstrap'
                    quality3='Oferecemos: subsídio de alimentação'
                    quality4='Desenvolver-se-à em torno de uma plataforma de questionários tendo como objetivo
                    contribuir para o desenho e desenvolvimento de novas funcionalidades'
                    link='https://www.decisioneyes.com/'
                />
                </Col>
            </Row>
            <Row>
                <Col>
                <InternshipCard 
                    title='Sensefinity'
                    position='Developers'
                    duration='Estágio profissional (Lisboa, com oportunidade de integrar equipa no final)'
                    quality='Noções de programação Cloud, Golang, JavaScript, React'
                    quality2='Conhecimentos para programar em firmware, C, C++'
                    quality3='Familiaridade com ML, Python, Golang, ELK'
                    quality4='Oferecemos: subsídio de alimentação e, caso se aplique, deslocação'
                    link='https://trackonperformance.com/'
                />
                </Col>
                <Col>
                <InternshipCard 
                    title='Sensefinity'
                    position='Developers'
                    duration='Estágio de verão (remoto ou presencial, em Lisboa, com oportunidade de integrar equipa no final)'
                    quality='Noções de programação Cloud, Golang, JavaScript, React'
                    quality2='Conhecimentos para programar em firmware, C, C++'
                    quality3='Familiaridade com ML, Python, Golang, ELK'
                    quality4='Oferecemos: subsídio de alimentação e, caso se aplique, deslocação'
                    link='https://trackonperformance.com/'
                />
                </Col>
            </Row>
            <Row>
                <Col>
                <MediumInternshipCard 
                    title='Olisipo'
                    position='Fullstack Developer'
                    duration='Contrato Full Time (Leiria e Híbrido)'
                    quality='Conhecimentos de Java, Spring, JavaScript'
                    quality2='Conhecimentos de Postgres'
                    quality3='Inglês Fluente'
                    link='https://olisipo.pt/'
                />
                </Col>
                <Col>
                <MediumInternshipCard 
                    title='Olisipo'
                    duration='Contrato Full Time (Leiria e Híbrido)'
                    position='Fullstack Developer'
                    quality='Conhecimentos de Java, Spring, JavaScript, Vue'
                    quality2='Conhecimentos de AWS'
                    quality3='Inglês Fluente'
                    link='https://olisipo.pt/'
                />
                </Col>
            </Row>
            <Row>
                <Col>
                <MediumInternshipCard 
                    title='Olisipo'
                    position='Backend Developer'
                    duration='Contrato Full Time (Aveiro e Híbrido)'
                    quality='Conhecimentos de Java, Postgres e base de dados Oracle'
                    quality2='Familiaridade com Kubernetes e Docker'
                    quality3='Inglês Fluente'
                    link='https://olisipo.pt/'
                />
                </Col>
                <Col>
                <MediumInternshipCard 
                    title='Track on Performance'
                    duration='Estágio de Verão (remoto com oportunidade para integrar equipa no final)'
                    position='WebDeveloper'
                    quality='Conhecimentos em React typescript (tsx)'
                    quality2='Interesse em ML e AWS para SaaS são um plus'
                    quality3='Oferecemos: subsídio de alimentação'
                    link='https://trackonperformance.com/'
                />
                </Col>
            </Row>
            <Row>
                <Col>
                <SmallInternshipCard 
                    title='hApi'
                    position='Developer'
                    duration='Fullstack Developer (Lisboa)'
                    quality="Desenvolvimento de aperfeiçoamento de API's REST em nodeJS e javascript"
                    quality2='Oferecemos: alimentação e prémio de produtividade, se ficar depois do estágio'
                    link='https://www.hapi.pt/'
                />
                </Col>
                <Col>
                <SmallInternshipCard 
                    title='Olisipo'
                    duration='Contrato Full Time (Aveiro e Híbrido)'
                    position='Embedded Developer'
                    quality='Conhecimentos de programação em C, C++'
                    quality2='Familiaridade com Shell Script'
                    link='https://olisipo.pt/'
                />
                </Col>
            </Row>
            <Row>
                <Col>
                <MiniInternshipCard 
                    title='Olisipo'
                    position='Frontend Developer'
                    duration='Contrato Full Time (Leiria e Híbrido)'
                    quality="Conhecimentos de JavaScript, Angular e Docker"
                    link='https://www.hapi.pt/'
                />
                </Col>
                <Col>
                <MiniInternshipCard 
                    title='Reatia'
                    duration='Estágio de Verão (remoto)'
                    position='Data Collection'
                    quality='Oferecemos: subsídio de alimentação'
                    link='https://reatia.com/en/'
                />
                </Col>
            </Row>
        </div>
    )
}

export default Internship;