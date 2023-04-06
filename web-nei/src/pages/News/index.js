import React, { useState, useEffect } from "react";
import NewsList from "./NewsList";
import PageNav from "../../components/PageNav";
import FilterSelect from "../../components/Filters/FilterSelect";
import Typist from 'react-typist';
import { Spinner } from 'react-bootstrap';
import service from 'services/NEIService';


const News = () => {

    const [isLoading, setIsLoading] = useState(true);       // used to change message when no news are available
    const [news, setNews] = useState([]);                   // list of news articles
    const [newsTypes, setNewsTypes] = useState([]);         // list of all news categories
    const [whitelist, setWhitelist] = useState([]);         // list of currently active categories
    const [currPage, setCurrPage] = useState(1);            // current page
    const [totalPages, setTotalPages] = useState(1);        // total number of pages

    const getNews = async (p_num, newsTypes) => {
        service.getNews({ page: p_num, category: newsTypes, size: 9 })
            .then((data) => {
                setIsLoading(false);
                setCurrPage(p_num);
                setTotalPages(data.last);
                setNews(data.items || []);
            })
    }

    /** Get given news page from API */
    const fetchPage = (p_num) => {

        // check if there are no categories selected
        if (whitelist.length == 0) {
            setNews([]);
            return;
        }

        setIsLoading(true);
        setNews([]);

        getNews(p_num, newsTypes);
    };

    // Get initial news page from API when component renders, and when selected filters change
    useEffect(() => { fetchPage(1) }, [whitelist]);

    // Get categories from API when component renders
    useEffect(() => {
        service.getNewsCategories()
            .then(data => {
                var cats = [];
                data.data?.forEach(c => cats.push(c));
                setNewsTypes(cats);
                setWhitelist(cats);
            })
    }, []);

    return (
        <div className="d-flex flex-column flex-wrap">
            <h2 className="text-center"><Typist>Notícias</Typist></h2>

            <FilterSelect
                accordion={true}
                filterList={newsTypes.map(nt => { return { 'filter': nt } })}
                activeFilters={whitelist}
                setActiveFilters={setWhitelist}
                className="mb-3"
                btnClass="mr-2"
            >
                <PageNav className="col-12 col-lg ml-auto p-0" currentPage={currPage} numPages={totalPages} handler={fetchPage}></PageNav>
            </FilterSelect>
            {
                isLoading
                    ?
                    <Spinner animation="grow" variant="primary" className="mx-auto" title="A carregar..." />
                    :
                    <NewsList news={news} loading={isLoading}></NewsList>
            }
        </div>
    );
}

export default News;
