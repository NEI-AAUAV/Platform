import React, { useState, useEffect } from "react";
import NewsList from "./NewsList";
import PageNav from "../../components/PageNav";
import FilterSelect from "../../components/Filters/FilterSelect";
import Typist from 'react-typist';
import axios from "axios";
import { Spinner } from 'react-bootstrap';

const News = () => {

    const [isLoading, setIsLoading] = useState(true);       // used to change message when no news are available
    const [news, setNews] = useState([]);                   // list of news articles
    const [newsTypes, setNewsTypes] = useState([]);         // list of all news categories
    const [whitelist, setWhitelist] = useState([]);         // list of currently active categories
    const [currPage, setCurrPage] = useState(1);            // current page
    const [totalPages, setTotalPages] = useState(1);        // total number of pages

    const getNews = async (p_num, api) => {

        const config = {
            method: 'get',
            url: process.env.REACT_APP_API + api + "page=" + p_num
        }

        let res = await axios(config);
        setIsLoading(false);

        if ('data' in res.data) {
            setCurrPage(p_num);
            setTotalPages(res.data["page"].pagesNumber);
            setNews(res.data['data']);
        }
    }

    /** Get given news page from API */
    const fetchPage = (p_num) => {
        //console.log("currPage: " + currPage + ", new_page: " + p_num);

        // check if there are no categories selected
        if (whitelist.length == 0) {
            setNews([]);
            return;
        }

        // build string for api request
        if (window.location.search)
            var api = "/news/" + window.location.search + "&";
        else
            var api = "/news/?";

        if (whitelist != newsTypes) {
            whitelist.forEach(v => {
                api = api + "category[]=" + v + "&";
            });
        }

        setIsLoading(true);
        setNews([]);

        getNews(p_num, api);
    };

    // Get initial news page from API when component renders, and when selected filters change
    useEffect(() => { fetchPage(1) }, [whitelist]);

    const getCategories = async () => {

        const config = {
            method: 'get',
            url: process.env.REACT_APP_API + "/news/categories/"
        }

        let res = await axios(config)

        console.log(res.data)
        if ('data' in res.data) {
            var cats = [];
            res.data['data'].forEach(c => cats.push(c.category));
            setNewsTypes(cats);
            setWhitelist(cats);
        }
    }

    // Get categories from API when component renders
    useEffect(() => {
        getCategories();
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
                <PageNav className="col-12 col-lg ml-auto p-0" page={currPage} total={totalPages} handler={fetchPage}></PageNav>
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