import React, { useEffect, useState, Fragment } from "react";
import Typist from 'react-typist';

import Filters from '../../components/Filters';
import Document from '../../components/Document';
import PageNav from '../../components/PageNav';
import service from 'services/NEIService';

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
        service.getVideosCategories()
            .then(response => {
                setCategories(response);
                var cats = [];
                var catsObjs = [];
                response.forEach(c => {
                    cats.push(c.name);
                    catsObjs.push({ filter: c.name, color: c.color });
                });
                setSelection(cats);
                setFilters(catsObjs);
                setLoadingCategories(false);
            })
            .catch(() => {
                console.error("something went wrong...")
            })

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

        const params = {
            tag: []
        }

        if (selection.length) {
            // Compute url with categories ids selected
            selection.forEach(s => {
                const candidates = categories.filter(c => c.name == s);
                if (candidates.length > 0) {
                    params.tag.push(candidates[0].id);
                }
            });

            service.getVideos({ ...params, page: selPage })
                .then((response) => {
                    setVideos(response.items);
                    setPages(response.last)
                    setSelPage(response.page)
                    setLoading(false);
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
                    !loading && videos.map((video, index) => {

                        const candidates = categories.filter(c => c.id == video.tag);
                        let tag = [];
                        if (candidates.length > 0) {
                            tag = {
                                name: candidates[0].name,
                                color: candidates[0].color,
                                className: ""
                            }
                        }

                        return (<Fragment key={index}>
                            <Document
                                name={video.title}
                                description={video.subtitle}
                                link={'/videos/' + video.id}
                                blank={false}
                                icon={faPlayCircle}
                                image={video.image}
                                className="col-lg-6 col-xl-4 slideUpFade p-2"
                                tags={tag ? [tag] : []}
                            />
                        </Fragment>)
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