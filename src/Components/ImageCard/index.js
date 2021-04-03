import React from "react";
import { Card } from "react-bootstrap";

const ImageCard = (props) => {
    /* Prop list:
    **  pre_title (optional): plain text on top
    **  title: large colored anchor text in middle
    **  text: plain text on bottom
    **  image: card image
    **  anchor: link associated with image and title
    **  dark_mode (optional): set to true for dark color scheme
    */
    return(
        <Card className="text-center mb-4">
            <Card.Img variant="top img-fluid" src={props.image} href={props.anchor} />
            <Card.Body>
                {props.pre_title && <p1>{props.pre_title}</p1> }
                <Card.Title href={props.anchor}>{props.title}</Card.Title>
                <Card.Text>{props.text}</Card.Text>
            </Card.Body>
        </Card>
    );
}

export default ImageCard;