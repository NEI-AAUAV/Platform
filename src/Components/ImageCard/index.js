import React from "react";
import { Card } from "react-bootstrap";
import './index.css';

const ImageCard = (props) => {
    /* Prop list:
    **  pre_title (optional): plain text on top
    **  title: large colored anchor text in middle
    **  text: plain text on bottom
    **  image: card image
    **  anchor: link associated with image and title
    **  dark_mode (optional): set to a non-false value (e.g. "on" or True) to use a dark color scheme
    */

    var color_class = "";
    if (props.dark_mode) {
        color_class = " dark"
    }

    return(
        <Card className={"text-center mb-5 image-card" + color_class}>
            <a href={props.anchor}>
            <Card.Img variant="top img-fluid" src={props.image} />
            </a>

            <div className={"plus-button" + color_class}>
                <span><a href={props.anchor}>+</a></span>
            </div>

            <Card.Body className={color_class}>
                {props.pre_title && <p1>{props.pre_title}</p1> }
                <Card.Title><a href={props.anchor}>{props.title}</a></Card.Title>
                <Card.Text><small>{props.text}</small></Card.Text>
            </Card.Body>
        </Card>
    );
}

export default ImageCard;