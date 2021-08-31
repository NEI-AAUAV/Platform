import React from 'react';
import { Col, Image } from 'react-bootstrap';
import './index.css';

const SeniorsCard = ({name, quote, image, colSizeXs, colSizeMd, colSizeSm}) => {

    // default colSizes
    if (!colSizeXs) colSizeXs = 12;
    if (!colSizeSm) colSizeSm = 12;
    if (!colSizeMd) colSizeMd = 4;

    return(
        <Col sm={colSizeSm} md={colSizeMd}>
            <Image
                //src={process.env.REACT_APP_STATIC + image}
                src={"../../public" + image}
            />

            <h4 className="text-bold">{name}</h4>
            <p className="seniors-quote">"{quote}"</p>
        </Col>
    );
}

export default SeniorsCard;