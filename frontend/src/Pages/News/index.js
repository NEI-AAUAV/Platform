import React, { useState, useEffect } from "react";
import NewsList from "./NewsList";
import PageNav from "../../Components/PageNav";
import FilterSelect from "../../Components/Filters/FilterSelect";
import Typist from 'react-typist';
import {Spinner} from 'react-bootstrap';

const News = () => {

    const [isLoading, setIsLoading] = useState(true);       // used to change message when no news are available
    const [news, setNews] = useState([]);                   // list of news articles
    const [newsTypes, setNewsTypes] = useState([]);         // list of all news categories
    const [whitelist, setWhitelist] = useState([]);         // list of currently active categories
    const [currPage, setCurrPage] = useState(1);            // current page
    const [totalPages, setTotalPages] = useState(1);        // total number of pages

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
            whitelist.forEach( v => {
                api = api + "category[]=" + v + "&"; 
            });
        }        

        setIsLoading(true);
        setNews([]);

        fetch(process.env.REACT_APP_API + api + "page=" + p_num)
            .then(response => response.json())
            .then((response) => {
                setIsLoading(false);
                if('data' in response) {
                    setCurrPage(p_num);
                    setTotalPages(response["page"].pagesNumber);
                    setNews(response['data']);
                }
            });
    };

    // Get initial news page from API when component renders, and when selected filters change
    useEffect( () => {fetchPage(1)}, [whitelist]);

    // Get categories from API when component renders
    useEffect(() => {
        fetch(process.env.REACT_APP_API + "/news/categories/")
            .then(response => response.json())
            .then((response) => {
                if('data' in response) {
                    var cats = [];
                    response['data'].forEach( c => cats.push(c.category) );
                    setNewsTypes(cats);
                    setWhitelist(cats);
                }
            });
    }, []);

    return (
        <div className="d-flex flex-column flex-wrap">
            <h2 className="text-center"><Typist>Notícias</Typist></h2>

            <FilterSelect 
                accordion={true}
                filterList={newsTypes.map(nt => {return {'filter': nt}})}
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