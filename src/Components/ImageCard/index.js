import React from "react";
import { Card } from "react-bootstrap";
import './index.css';

const ImageCard = (props) => {
    /* Prop list:
    **  preTitle (optional): plain text on top
    **  title: large colored anchor text in middle
    **  text: plain text on bottom
    **  image: card image
    **  anchor: link associated with image and title
    **  darkMode (optional): set to a non-false value (e.g. "on" or True) to use a dark color scheme
    **  animKey (optional): integer that increases delay on entrance animation
    */

    var color_class = "";
    if (props.darkMode) {
        color_class = " dark"
    }

    return(
        <Card
            className={"text-center mb-5 image-card animation" + color_class}
            style={{animationDelay: props.animKey ? props.animKey*0.2+"s" : "0"}}
        >
            {
                props.image &&
                <a href={props.anchor}>
                    <Card.Img variant="top img-fluid" src={props.image} />
                </a>
            }

            <div className={"plus-button" + color_class}>
                <span><a href={props.anchor} target="_blank">+</a></span>
            </div>

            <Card.Body className={color_class}>
                {props.preTitle && <p className="mb-4">{props.preTitle}</p> }
                <Card.Title><a href={props.anchor}>{props.title}</a></Card.Title>
                <Card.Text><small>{props.text}</small></Card.Text>
            </Card.Body>
        </Card>
    );
}

export default ImageCard;