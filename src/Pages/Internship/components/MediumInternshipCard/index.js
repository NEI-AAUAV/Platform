import Card from 'react-bootstrap/Card';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faExternalLinkAlt } from '@fortawesome/free-solid-svg-icons'
import './index.css';

const MediumInternshipCard = (props) => {

    return (
        <div d-flex flex-column flex-wrap>
            <Card className='medium-internship-card'>
                <Card.Body>
                    <Card.Title className='card-title'>{props.title}</Card.Title>
                    <span className='card-link'><a href={props.link}><FontAwesomeIcon className='icon' icon={faExternalLinkAlt} /></a></span>
                    <p className='position'>{props.position}</p>
                    <Card.Subtitle className="mb-2 text-muted">{props.duration}</Card.Subtitle>
                    <Card.Text> 
                    <ul className='qualities-list'>
                        <li>{props.quality}</li>
                        <li>{props.quality2}</li>
                        <li>{props.quality3}</li>
                    </ul>
                    </Card.Text>
                </Card.Body>
                </Card>
        </div>
    )
}

export default MediumInternshipCard;