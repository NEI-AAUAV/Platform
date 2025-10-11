import "./index.css";
import Card from "./components/InternshipCard/index";
import { Col, Row } from "react-bootstrap";

const animationBase = parseFloat(import.meta.env.VITE_ANIMATION_BASE);
const animationIncrement = parseFloat(
  import.meta.env.VITE_ANIMATION_INCREMENT
);

const Internship = () => {
  return (
    <div
      d-flex
      flex-column
      flex-wrap
      className="slideUpFade"
      style={{ animationDelay: animationBase + animationIncrement }}
    >
      <h2 className="mb-5 text-center">
        Oportunidades Olisipo Way
      </h2>
      <div className="text-center mt-5">
        <p>
          Se tens interesse nestas oportunidades, envia o teu CV atualizado e/ou
          portfolio de projetos para{" "}
          <a href="mailto:eder.alves@olisipo.pt">eder.alves@olisipo.pt</a>, e
          indica a referência das oportunidades que gostavas de integrar. Caso
          tenhas alguma dúvida, contacta-nos pelo email (
          <a href="mailto:nei@aauav.pt">nei@aauav.pt</a>) ou pelas redes sociais
          para te podermos ajudar.
        </p>
      </div>
      <Row>
        <Col>
          <Card
            class="resize-4"
            title="TecmaFoods"
            position="Gestão de Sistemas Informáticos & IoT"
            duration="Estágio de verão (remoto)"
            quality="Criação de sistema de controlo ERP (excel ou semelhante)"
            quality2="Criação de sistema de controlo de qualidade de auditoria"
            quality3="Aplicação para coleção de dados - estilo formulário ligado a base de dados"
            quality4="IoT de sondas e sensores"
            quality5="Oferecemos: subsídio de alimentação"
            link="https://tecmafoods.com/"
          />
        </Col>
        <Col>
          <Card
            class="resize-4"
            title="EatTasty"
            duration="Contrato Full Time"
            position="Full Stack Developer (Lisboa)"
            quality="Experiência com frontend ou backend com JavaScript, HTML, AJAX, JSON e CSS/SASS"
            quality2="Experiência com ExpressJS ou uma framework JavaScript Semelhante"
            quality3="Conhecimento de base de dados NoSQL e relacionais, especialmente MongoDB, Redis e PostgreSQL"
            quality4="Sólidos conhecimentos de especificidades e problemas de compatibilidade em browsers"
            quality5="Benefícios oferecidos: contrato de trabalho, subsídio refeição, vales de refeição na EatTasty,
                    horário flexível, trabalho na sexta-feira até às 15h, dias de folga oferecidos nos dias de anos e dos
                    filhos, seguro de saúde e plano de benefícios Coverflex"
            link="https://eattasty.pt/home"
          />
        </Col>
      </Row>
      <Row>
        <Col>
          <Card
            class="resize-3"
            title="CheckFirst app"
            position="IT Internships"
            duration="Estágio de 3 ou 6 meses (remoto ou presencial, em Lisboa, com oportunidade para integrar equipa no final)"
            quality="Operações"
            quality2="Tecnologia"
            quality3="Design de produto (UX/UI)"
            quality4="Oferecemos: deslocação (caso se aplique) e subsídio de alimentação"
            link="https://www.checkfirstapp.com/pt"
          />
        </Col>
        <Col>
          <Card
            class="resize-3"
            title="Decision Eyes"
            duration="Estágio de Verão (com oportunidade para integrar equipa no final)"
            position="Developer (2º ou 3º ano da licenciatura)"
            quality="Conhecimentos de ASP.Net e SQL Server"
            quality2="JavaScript, JQuery, html e bootstrap"
            quality3="Oferecemos: subsídio de alimentação"
            quality4="Desenvolver-se-à em torno de uma plataforma de questionários tendo como objetivo
                    contribuir para o desenho e desenvolvimento de novas funcionalidades"
            link="https://www.decisioneyes.com/"
          />
        </Col>
      </Row>
      <Row>
        <Col>
          <Card
            class="resize-3"
            title="Sensefinity"
            position="Developers"
            duration="Estágio profissional (Lisboa, com oportunidade de integrar equipa no final)"
            quality="Noções de programação Cloud, Golang, JavaScript, React"
            quality2="Conhecimentos para programar em firmware, C, C++"
            quality3="Familiaridade com ML, Python, Golang, ELK"
            quality4="Oferecemos: subsídio de alimentação e, caso se aplique, deslocação"
            link="https://www.sensefinity.com/"
          />
        </Col>
        <Col>
          <Card
            class="resize-3"
            title="Sensefinity"
            position="Developers"
            duration="Estágio de verão (remoto ou presencial, em Lisboa, com oportunidade de integrar equipa no final)"
            quality="Noções de programação Cloud, Golang, JavaScript, React"
            quality2="Conhecimentos para programar em firmware, C, C++"
            quality3="Familiaridade com ML, Python, Golang, ELK"
            quality4="Oferecemos: subsídio de alimentação e, caso se aplique, deslocação"
            link="https://www.sensefinity.com/"
          />
        </Col>
      </Row>
      <Row>
        <Col>
          <Card
            class="resize-2"
            title="Olisipo"
            position="Fullstack Developer"
            duration="Contrato Full Time (Leiria e Híbrido)"
            quality="Conhecimentos de Java, Spring, JavaScript"
            quality2="Conhecimentos de Postgres"
            quality3="Inglês Fluente"
            link="https://olisipo.pt/"
          />
        </Col>
        <Col>
          <Card
            class="resize-2"
            title="Olisipo"
            duration="Contrato Full Time (Leiria e Híbrido)"
            position="Fullstack Developer"
            quality="Conhecimentos de Java, Spring, JavaScript, Vue"
            quality2="Conhecimentos de AWS"
            quality3="Inglês Fluente"
            link="https://olisipo.pt/"
          />
        </Col>
      </Row>
      <Row>
        <Col>
          <Card
            class="resize-2"
            title="Olisipo"
            position="Backend Developer"
            duration="Contrato Full Time (Aveiro e Híbrido)"
            quality="Conhecimentos de Java, Postgres e base de dados Oracle"
            quality2="Familiaridade com Kubernetes e Docker"
            quality3="Inglês Fluente"
            link="https://olisipo.pt/"
          />
        </Col>
        <Col>
          <Card
            class="resize-2"
            title="Track on Performance"
            duration="Estágio de Verão (remoto com oportunidade para integrar equipa no final)"
            position="WebDeveloper"
            quality="Conhecimentos em React typescript (tsx)"
            quality2="Interesse em ML e AWS para SaaS são um plus"
            quality3="Oferecemos: subsídio de alimentação"
            link="https://trackonperformance.com/"
          />
        </Col>
      </Row>
      <Row>
        <Col>
          <Card
            class="resize-2"
            title="hApi"
            position="Developer"
            duration="Fullstack Developer (Lisboa)"
            quality="Desenvolvimento de aperfeiçoamento de API's REST em nodeJS e javascript"
            quality2="Oferecemos: alimentação e prémio de produtividade, se ficar depois do estágio"
            link="https://www.hapi.pt/"
          />
        </Col>
        <Col>
          <Card
            class="resize-2"
            title="Olisipo"
            duration="Contrato Full Time (Aveiro e Híbrido)"
            position="Embedded Developer"
            quality="Conhecimentos de programação em C, C++"
            quality2="Familiaridade com Shell Script"
            link="https://olisipo.pt/"
          />
        </Col>
      </Row>
      <Row>
        <Col>
          <Card
            class="resize-1"
            title="Olisipo"
            position="Frontend Developer"
            duration="Contrato Full Time (Leiria e Híbrido)"
            quality="Conhecimentos de JavaScript, Angular e Docker"
            link="https://olisipo.pt/"
          />
        </Col>
        <Col>
          <Card
            class="resize-1"
            title="Reatia"
            duration="Estágio de Verão (remoto)"
            position="Data Collection"
            quality="Oferecemos: subsídio de alimentação"
            link="https://reatia.com/en/"
          />
        </Col>
      </Row>
    </div>
  );
};

export default Internship;
