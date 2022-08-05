import React, { useState, useEffect } from 'react'
import { useParams } from 'react-router';
import Typist from 'react-typist';
import {
    Row, Spinner
} from "react-bootstrap";
import YoutubeEmbed from '../../Components/YoutubeEmbed';
import Alert from '../../Components/Alert';
import { faList } from '@fortawesome/free-solid-svg-icons';


const Video = () => {

    // get course from URL parameters
    let {id} = useParams();

    const [video, setVideo] = useState(null);
    const [loading, setLoading] = useState(true);

    // On load, get video from API
    useEffect(() => {
        setLoading(true);

        fetch(process.env.REACT_APP_API + "/videos/?video=" + id)
            .then((response) => response.json())
            .then((response) => {
                console.log("GOT RESPONSE", response);
                if ('data' in response) {
                    setVideo(response['data']);
                } else {
                    window.location.href = "/404";
                }
                setLoading(false);
            }).catch((error) => {
                window.location.href = "/404";
            });
    }, []);
    
    return (
        <div>
            {
                !loading && video &&
                <div className="d-flex flex-column">
                    <p className="col-12 m-0 p-0 text-left small text-primary mb-3">
                        <a className="" href="/videos">&#10094; Voltar aos vídeos</a>
                    </p>

                    <h2 className="text-center">
                        {video.title}
                    </h2>
                    <h4 className="text-center w-100 text-secondary">
                        {video.subtitle}
                    </h4>
                    <p className="text-secondary w-100 text-center small">
                        Atualizado a {new Date(video.created.replace(/-/g, "/")).toLocaleDateString('pt-PT', {day: 'numeric', month: 'long', year: 'numeric'})}
                    </p>

                    <YoutubeEmbed 
                        embedId={video.ytId} 
                        playlist={video.playlist==="1"}
                        className="my-4 slideUpFade"
                    />

                    {
                        video.playlist=="1" &&
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
                    loading &&
                    <Spinner animation="grow" variant="primary" className="mx-auto mb-3" title="A carregar..." />
                }
            </Row>
        </div>
    );
}

export default Video;