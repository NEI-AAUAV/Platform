import React, { useEffect, useState } from "react";
import ImageCard from "components/ImageCard"
import { Col, Row } from "react-bootstrap";
import Typist from 'react-typist';
import DCard from "../../../components/Cards/DCard";
import service from 'services/NEIService';


const Partners = () => {

  const [partners, setPartners] = useState([]);
  const [banner, setBanner] = useState(undefined);

  // Get API data when component renders
  useEffect(() => {
    service.getPartners()
      .then((data) => {
        setPartners(data);
      });
    // Get partner banner
    service.getPartnersBanner()
      .then((data) => {
        setBanner(data);
      });
  }, []);

  return (
    <div>
      <h2 className="text-center mb-4"><Typist>Parceiros</Typist></h2>

      <div className="flex flex-row gap-20">
        {partners.map((partner, index) => {
          return (
            //     <div key={index}>
            //         <ImageCard
            //             image={partner.header && partner.header}
            //             title={partner.company}
            //             text={partner.description}
            //             anchor={partner.link}
            //             darkMode="on"
            //         ></ImageCard>
            //     </div>
            // );
            <DCard type="partner" key={index} data={partner} />
          );
        })}
      </div>
    </div>
  );
}

export default Partners;
