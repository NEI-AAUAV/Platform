import Card from "react-bootstrap/Card";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faExternalLinkAlt } from "@fortawesome/free-solid-svg-icons";
import "./index.css";

const InternshipCard = (props) => {
  return (
    <div d-flex flex-column flex-wrap>
      <Card
        className={
          props.class ? `internship-card ${props.class}` : "internship-card"
        }
      >
        <Card.Body>
          <Card.Title className="card-title">{props.title}</Card.Title>
          <span classname="card-link">
            <a href={props.link} target="_blank" rel="noreferrer">
              <FontAwesomeIcon className="icon" icon={faExternalLinkAlt} />
            </a>
          </span>
          <p className="position">{props.position}</p>
          <Card.Subtitle className="mb-2 text-muted">
            {props.duration}
          </Card.Subtitle>
          <Card.Text>
            <ul className="qualities-list">
              <li>{props.quality}</li>
              {props.quality2 && <li>{props.quality2}</li>}
              {props.quality3 && <li>{props.quality3}</li>}
              {props.quality4 && <li>{props.quality4}</li>}
              {props.quality5 && <li>{props.quality5}</li>}
            </ul>
          </Card.Text>
        </Card.Body>
      </Card>
    </div>
  );
};

export default InternshipCard;
