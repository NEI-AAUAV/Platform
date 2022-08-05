import React, {useState, useEffect} from "react";

import {
    useParams
} from "react-router-dom";

import {
    Spinner
} from "react-bootstrap";

const Error404 = () => {
    let { id } = useParams();

    const [loading, setLoading] = useState(true);
    const [redirect, setRedirect] = useState(undefined);

    // On component render...
    useEffect(() => {
        setLoading(true);

        // Call /redirects API to check if it is an alias
        // Fetch API if valid
        fetch(process.env.REACT_APP_API + "/redirects/?alias=" + id)
            .then(res => res.json())
            .then(json => {
                setLoading(false);
                if ('data' in json && json['data'].length) {
                    console.log('redirect', json['data'][0]['redirect']);
                    setRedirect(json['data'][0]['redirect']);
                }
            }).catch((error) => {
                setLoading(false);
            });
    }, []);

    // On redirect set, redirect to page
    useEffect(() => {
        if (redirect) {
            window.location.href = redirect;
        }
    }, [redirect])

    return (
        <div className="d-flex flex-column flex-wrap">
            {
                loading 
                ? <Spinner animation="grow" variant="primary" className="mx-auto mb-3" title="A carregar..." />
                : redirect 
                    ? 
                        <div className="mx-auto text-center">
                            <Spinner animation="grow" variant="primary" className="mx-auto mb-3" title="A carregar..." />
                            <h1 className="word-break">A redirecionar</h1>
                            <p>para <a href={redirect}>{redirect}</a>.</p>
                            <p className="small">Se o redirecionamento não ocorrer nos próximos 5 segundos, clica <a href={redirect}>aqui</a>.</p>
                        </div>
                    :   
                        <div>
                            <h1 className="word-break">Error 404</h1>
                            <p>Ups! Parece que a página que procuras não existe. &#128517;</p>
                            <p>Se foste redirecionado desde uma ligação no nosso site ou redes sociais, por favor entra em contacto conosco para podermos averiguar o que se passou.</p>
                            <p>Entretanto, convidamos-te a conhecer o nosso site. Descobre apontamentos, os próximos eventos ou as últimas novidades de EI! &#128521;</p>
                            <a href="/"><button className="btn btn-primary">Conhece o nosso site!</button></a>
                        </div>
            }
        </div>
    );
}

export default Error404;