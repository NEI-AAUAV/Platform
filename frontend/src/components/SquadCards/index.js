import React from "react";
import { Card } from "react-bootstrap";
import './index.css';

const SquadCard = (props) => {
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

  return (
    <Card
      className={"text-center img-card" + color_class}
      
    >
      {props.image && (
        <a href={props.anchor} target="_blank" rel="noreferrer noopener">
          <Card.Img variant="top img-fluid" src={props.image} />
        </a>
      )}

      <Card.Body className={color_class}>
        {props.preTitle && <p>{props.preTitle}</p>}
        <Card.Title>
          <a href={props.anchor} target="_blank" rel="noreferrer noopener">{props.title}</a>
        </Card.Title>
        <Card.Text>
          <small>{props.text}</small>
        </Card.Text>
      </Card.Body>
    </Card>
  );
}

export default SquadCard;