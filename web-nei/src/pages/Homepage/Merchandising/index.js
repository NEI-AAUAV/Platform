import React, { useEffect, useState, Fragment } from "react";
import "./index.css";
import Typist from "react-typist";
import config from "config";
import service from "services/NEIService";
import CardMerch from "components/CardMerch";

// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(
  process.env.REACT_APP_ANIMATION_INCREMENT
);

const Merchandising = () => {
  const [imgs, setImgs] = useState([]);

  useEffect(() => {
    service.getMerch().then((data) => {
      setImgs(
        data.map((data) => (
          <Fragment key={data.id}>
            <CardMerch img={data.image} title={data.name} price={data.price} />
          </Fragment>
        ))
      );
    });
  }, []);

  return (
    <div className="py-5">
      <h2 style={{ position: "relative" }} className="mb-5 text-center">
        <Typist>Merchandising</Typist>
      </h2>

      <div className="flex flex-wrap gap-4 mx-auto justify-center my-10">
        {imgs}
      </div>

      <div className="flex justify-center">
        <a
          href="https://orders.winrestbooking.com/StoreMenu/Index/4968"
          target="_blank"
          className="btn btn-lg mx-auto"
        >
          Comprar
        </a>
      </div>
    </div>
  );
};

export default Merchandising;
