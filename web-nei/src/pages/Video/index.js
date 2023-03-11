import React, { useState, useEffect } from 'react'
import { useParams } from 'react-router';
import { Link } from 'react-router-dom'
import Typist from 'react-typist';
import {
    Row, Spinner
} from "react-bootstrap";
import YoutubeEmbed from '../../components/YoutubeEmbed';
import Alert from '../../components/Alert';
import { faList } from '@fortawesome/free-solid-svg-icons';
import service from 'services/NEIService';


const Video = () => {

    // get course from URL parameters
    let { id } = useParams();

    const [video, setVideo] = useState(null);
    const [loading, setLoading] = useState(true);

    // On load, get video from API
    useEffect(() => {
        setLoading(true);

        service.getVideosById(id)
            .then((data) => {
                setVideo(data);
                setLoading(false);
            }).catch(() => {
                window.location.href = "/404";
            });
    }, []);

    return (
        <div>
            {
                !loading && video &&
                <div className="d-flex flex-column">
                    <p className="col-12 m-0 p-0 text-left small text-primary mb-3">
                        <Link to="/videos">&#10094; Voltar aos vídeos</Link>
                    </p>

                    <h2 className="text-center">
                        {video.title}
                    </h2>
                    <h4 className="text-center w-100 text-secondary">
                        {video.subtitle}
                    </h4>
                    <p className="text-secondary w-100 text-center small">
                        Atualizado a {new Date(video.created_at?.split('T').at(0)).toLocaleDateString('pt-PT', { day: 'numeric', month: 'long', year: 'numeric' })}
                    </p>

                    <YoutubeEmbed
                        embedId={video.youtube_id}
                        playlist={video.playlist === 1}
                        className="my-4 slideUpFade"
                    />

                    {
                        video.playlist == "1" &&
                        <Alert
                            alert={{
                                type: 'info',
                                text: 'Este tópico é uma lista de reprodução. Para navegares entre os vídeos utiliza o ícone no canto superior direito do reprodutor.'
                            }}
                            setAlert={null}
                        />
                    }

                </div>
            }

            <Row>
                {
                    !!loading &&
                    <Spinner animation="grow" variant="primary" className="mx-auto mb-3" title="A carregar..." />
                }
            </Row>
        </div>
    );
}

export default Video;