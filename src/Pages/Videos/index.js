import React, { useEffect, useState } from "react";
import Typist from 'react-typist';

import Filters from '../../Components/Filters';
import Document from '../../Components/Document';
import PageNav from '../../Components/PageNav';

import { faPlayCircle } from '@fortawesome/free-solid-svg-icons';

import {
    Row, Spinner
} from "react-bootstrap";

const Videos = () => {

    // Animation
    const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
    const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);

    // Filters
    const [categories, setCategories] = useState([]);
    const [filters, setFilters] = useState([]);
    const [selection, setSelection] = useState([]);
    const [loadingCategories, setLoadingCategories] = useState(true);

    // Get categories from API
    useEffect(() => {
        fetch(process.env.REACT_APP_API + "/videos/categories")
            .then(response => response.json())
            .then((response) => {
                if ('data' in response) {
                    setCategories(response['data']);
                    var cats = [];
                    var catsObjs = [];
                    response['data'].forEach(c => {
                        cats.push(c.name);
                        catsObjs.push({ filter: c.name, color: c.color });
                    });
                    setSelection(cats);
                    setFilters(catsObjs);
                    setLoadingCategories(false);
                }
            });
    }, []);

    // Videos
    const [videos, setVideos] = useState([]);
    const [loading, setLoading] = useState(true);

    // Pagination
    const [pages, setPages] = useState(1);
    const [selPage, setSelPage] = useState(1);

    // When categories selected change, update videos list (get from API)
    useEffect(() => {
        setLoading(true);
        if (selection.length) {
            // Compute url with categories ids selected
            let url = process.env.REACT_APP_API + "/videos?";
            selection.forEach(s => {
                const candidates = categories.filter(c => c.name == s);
                if (candidates.length > 0) {
                    url += 'category[]= ' + candidates[0].id + '&';
                }
            });
            url += 'page=' + selPage;
            // Get data from API
            fetch(url)
                .then(response => response.json())
                .then((response) => {
                    if ('data' in response) {
                        setVideos(response['data']);
                        setPages(response['page']['pagesNumber']);
                        setSelPage(response['page']['currentPage']);
                    } else {
                        setLoading(false);
                        setPages(1);
                        setSelPage(1);
                    }
                    setLoading(false)
                }).catch((error) => {
                    console.error("Erro getting videos from API!", error);
                    setLoading(false);
                    setPages(1);
                    setSelPage(1);
                });
        } else {
            setLoading(false);
            setVideos([]);
            setPages(1);
            setSelPage(1);
        }
    }, [selection, selPage])

    return (
        <div>
            <h2 className="text-center">
                <Typist>Vídeos</Typist>
            </h2>

            {
                // Filter by category
            }
            {
                !loadingCategories &&
                <div className="col-12 d-flex flex-row flex-wrap my-5">
                    <div
                        className="mb-2 col-12 col-md-4 d-flex"
                        style={{
                            animationDelay: animationBase + animationIncrement * 0 + "s",
                        }}
                    >
                        <p className="slideUpFade col-12 text-primary mb-3 my-md-auto ml-auto pr-3 text-center text-md-right">Categorias</p>
                    </div>
                    <Filters
                        filterList={filters}
                        activeFilters={selection}
                        setActiveFilters={setSelection}
                        className="slideUpFade mr-auto col-12 col-md-8 d-flex flex-row flex-wrap"
                        btnClass="mx-auto mr-md-2 ml-md-0 mb-2"
                        style={{
                            animationDelay: animationBase + animationIncrement * 1 + "s",
                        }}
                    />
                </div>
            }

            {
                // Videos list
            }
            <Row>

                {
                    (loading || loadingCategories) &&
                    <Spinner animation="grow" variant="primary" className="mx-auto mb-3" title="A carregar..." />
                }

                {
                    !loading && videos.map(video => {

                        const candidates = categories.filter(c => c.id == video.tag);
                        let tag = [];
                        if (candidates.length > 0) {
                            tag = {
                                name: candidates[0].name,
                                color: candidates[0].color,
                                className: ""
                            }
                        }

                        return (<Document
                            name={video.title}
                            description={video.subtitle}
                            link={'/videos/' + video.id}
                            blank={false}
                            icon={faPlayCircle}
                            image={process.env.REACT_APP_STATIC + video.image}
                            className="col-lg-6 col-xl-4 slideUpFade p-2"
                            tags={tag ? [tag] : []}
                        />)
                    })
                }
            </Row>

            {
                // Pagination
            }
            <Row>
                {
                    pages > 1 &&
                    <PageNav
                        page={selPage}
                        total={pages}
                        handler={setSelPage}
                        className="mx-auto mt-3"
                    ></PageNav>
                }
            </Row>



            {
                // Error
                !loading && !loadingCategories && videos.length == 0 &&
                <div>
                    <h3 className="text-center mt-3">Nenhum vídeo encontrado</h3>
                    <h4 className="text-center">Tenta definir filtros menos restritivos</h4>
                </div>
            }



        </div>
    );
}

export default Videos;