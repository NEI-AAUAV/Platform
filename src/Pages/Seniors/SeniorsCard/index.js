import React from 'react';
import { Col, Image } from 'react-bootstrap';
import './index.css';

const SeniorsCard = ({name, quote, image, colSizeXs, colSizeMd, colSizeSm, colSizeLg, colSizeXl}) => {

    // default colSizes
    if (!colSizeXs) colSizeXs = 12;
    if (!colSizeSm) colSizeSm = 12;
    if (!colSizeMd) colSizeMd = 4;
    if (!colSizeLg) colSizeLg = 4;
    if (!colSizeXl) colSizeXl = 3;

    return(
        <Col sm={colSizeSm} md={colSizeMd} lg={colSizeLg} xl={colSizeXl}>
            <Image
                className="w-100"
                src={image}
            />

            <h4 className="text-bold">{name}</h4>
            {
                quote &&
                <p className="seniors-quote">"{quote}"</p>
            }
        </Col>
    );
}

export default SeniorsCard;