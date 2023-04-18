import React, { useEffect, useState, Fragment } from "react";
import Typist from "react-typist";
import {motion} from "framer-motion";
import service from "services/NEIService";
import CardMerch from "components/CardMerch";

const container = {
  hidden: { opacity: 1, scale: 0 },
  visible: {
    opacity: 1,
    scale: 1,
    transition: {
      delayChildren: 0.3,
      staggerChildren: 0.15,
    },
  },
};

const item = {
  hidden: { y: 20, opacity: 0 },
  visible: {
    y: 0,
    opacity: 1,
  },
};

const Merchandising = () => {
  const [merchs, setMerchs] = useState(null);

  useEffect(() => {
    service.getMerch().then((data) => {
      setMerchs(data);
    });
  }, []);

  return (
    <div className="py-5">
      <h2 style={{ position: "relative" }} className="mb-5 text-center">
        <Typist>Merchandising</Typist>
      </h2>

      {merchs && (
        <motion.div
          className="mx-auto my-10 flex flex-wrap justify-center gap-10"
          variants={container}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true }}
        >
          {merchs.map((data) => (
            <motion.div key={data.id} variants={item}>
              <CardMerch
                img={data.image}
                title={data.name}
                price={data.price}
              />
            </motion.div>
          ))}
        </motion.div>
      )}

      <div className="flex justify-center">
        <a
          href="https://orders.winrestbooking.com/StoreMenu/Index/4968"
          target="_blank"
          className="btn-lg btn mx-auto"
        >
          Comprar
        </a>
      </div>
    </div>
  );
};

export default Merchandising;
