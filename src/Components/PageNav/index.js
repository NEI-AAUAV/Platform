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

    var pages = [];
    for (let i = 1; i <= props.total; i++) {
        pages.push(
            <Pagination.Item onClick={props.handler} active={i == props.page} value={i} key={i /* idk what this even does */}>
                {i}
            </Pagination.Item>
        );
    }

    return(
        <Nav>
            <Pagination>
                <Pagination.First onClick={props.handler} value={1} disabled={props.page == 1} />
                <Pagination.Prev  onClick={props.handler} value="prev" disabled={props.page == 1} />

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

                <Pagination.Next onClick={props.handler} value="next" disabled={props.page == props.total}/>
                <Pagination.Last onClick={props.handler} value={props.total} disabled={props.page == props.total}/>
            </Pagination>
        </Nav>
    );
};

export default PageNav;