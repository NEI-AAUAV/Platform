import React, { useState } from "react";
import ImageCard from "../../../components/ImageCard";
import { Col, Row } from "react-bootstrap";
import DCard from "components/Cards/DCard";
import { AnimatePresence } from "framer-motion";
import { NewsModal } from "components/NewsModal/NewsModal";

/* Show list of news in cards
 **
 ** Props:
 ** - news: the news list
 ** - loading: is the page still loading
 */
const NewsList = (props) => {
  const [isSelected, setSelected] = useState(null);
  return (
    <>
      <Row>
        {props.news.length == 0 && (
          <Col sm={12}>
            <h3 className="text-center mt-3">Nenhuma notícia encontrada</h3>
            <h4 className="text-center">
              Tenta definir filtros menos restritivos
            </h4>
          </Col>
        )}
        {props.news.map((article, index) => {
          return (
            /*<Col lg={4} md={6} sm={12} key={key++}>
            <ImageCard
              image={article.header}
              title={article.title}
              preTitle={article.category}
              text={article.created_at?.split("T").at(0)}
              anchor={"/noticia/" + article.id}
              animKey={animKey++}
            ></ImageCard>
          </Col>*/
            <div key={index} className="w-fit">
              <DCard
                type="news"
                data={article}
                newsKey={index}
                openModal={() => {
                  setSelected(index);
                }}
              />
            </div>
          );
        })}
      </Row>
      <AnimatePresence>
        {isSelected ? <NewsModal data={props.news[isSelected]} /> : <></>}
      </AnimatePresence>
    </>
  );
};

export default NewsList;
