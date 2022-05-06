import Card from 'react-bootstrap/Card';
import { useState } from 'react';

const SmallInternshipCard = (props) => {
    const [nullValue, setNullValue] = useState("");

    return (
        <div d-flex flex-column flex-wrap>
            <Card className='internship-card' style={{ width: '33rem', height: '16rem' }}>
                <Card.Body>
                    <Card.Title className='card-title'>{props.title}</Card.Title>
                    <span classname='card-link'><a href={props.link}>Ver Mais</a></span>
                    <p className='position'>{props.position}</p>
                    <Card.Subtitle className="mb-2 text-muted">{props.duration}</Card.Subtitle>
                    <Card.Text> 
                    <ul className='qualities-list'>
                        <li>{props.quality}</li>
                        <li>{props.quality2}</li>
                    </ul>
                    </Card.Text>
                </Card.Body>
                </Card>
        </div>
    )
}

export default SmallInternshipCard;