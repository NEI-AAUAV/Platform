import React from "react";
import { Pagination, Nav } from "react-bootstrap";
import "./index.css";

/* A pagination bar, as seen in https://react-bootstrap.github.io/components/pagination/
** 
** Props:
** - page: current active page
** - total: total number of pages
** - handler: function to call with onClick
*/
const PageNav = (props) => {

    // pass correct number to handler function
    const handlePage = (e) => {
        if (e.target.attributes.value == undefined)
            var val = e.target.parentElement.attributes.value.value;
        else
            var val = e.target.attributes.value.value;

        if (val == "prev")
            props.handler(props.page-1);
        else if (val == "next")
            props.handler(props.page/1 +1);
        else
            props.handler(val);
    }

    // create each numbered page button
    var pages = [];
    for (let i = 1; i <= props.total; i++) {
        pages.push(
            <Pagination.Item onClick={handlePage} active={i == props.page} value={i} key={i /* idk what this even does */}>
                {i}
            </Pagination.Item>
        );
    }

    return(
        <Nav>
            <Pagination>
                <Pagination.First onClick={handlePage} value={1} disabled={props.page == 1} />
                <Pagination.Prev  onClick={handlePage} value="prev" disabled={props.page == 1} />

                {
                // Not sure how to render this yet, so keeping the condition false for now
                false &&
                <Pagination.Ellipsis />
                }
                
                {pages}

                {
                // Not sure how to render this yet, so keeping the condition false for now
                false &&
                <Pagination.Ellipsis />
                }

                <Pagination.Next onClick={handlePage} value="next" disabled={props.page == props.total}/>
                <Pagination.Last onClick={handlePage} value={props.total} disabled={props.page == props.total}/>
            </Pagination>
        </Nav>
    );
};

export default PageNav;