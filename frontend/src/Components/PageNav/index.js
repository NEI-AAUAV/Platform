import React,  {useState, useEffect} from "react";
import { Pagination, Nav } from "react-bootstrap";
import "./index.css";

/* A pagination bar, as seen in https://react-bootstrap.github.io/components/pagination/
** 
** ATTENTION! This component is 1-based index (first index is 1)!
**
** Props:
** - page: current active page
** - total: total number of pages
** - handler: function to call with onClick, argument given is new page number
*/
const PageNav = ({className, ...props}) => {

    // pass correct number to handler function
    const handlePage = (e) => {
        let val;
        if (e.target.attributes.value === undefined)
            val = e.target.parentElement.attributes.value.value;
        else
            val = e.target.attributes.value.value;

        if (val === "prev")
            props.handler(props.page-1);
        else if (val === "next")
            props.handler(props.page/1 +1);
        else
            props.handler(val);
    }

    // create each numbered page button
    const [pages, setPages] = useState([]);

    useEffect(() => {
        const pagesArray = [];
        if (props.total<5) {
            for (let i = 1; i <= props.total; i++) {
                pagesArray.push(i);
            }
        } else {
            // 1 2 3 ...  X
            if (props.page<=2) {
                for (let i=1; i<=3; i++) {
                    pagesArray.push(i);
                }
                pagesArray.push(-1);
                pagesArray.push(props.total);
            // 1 ...  X-2 X-1 X
            } else if (props.page>=props.total-1) {
                pagesArray.push(1);
                pagesArray.push(-1);
                for (let i=props.total-2; i<=props.total; i++) {
                    pagesArray.push(i);
                }
            // ... X-1 X X+1 ...
            } else {
                let currentpage = parseInt(props.page);
                pagesArray.push(-1);
                pagesArray.push(currentpage-1);
                pagesArray.push(currentpage);
                pagesArray.push(currentpage+1);
                pagesArray.push(-1);
            }
        }
        setPages(pagesArray);
    }, [props.total, props.page]);
    
    return(
        <Nav className={className}>
            <Pagination className="mx-auto mx-lg-0 ml-lg-auto mr-0">
                <Pagination.First onClick={handlePage} value={1} disabled={props.page === 1} />
                <Pagination.Prev  onClick={handlePage} value="prev" disabled={props.page === 1} />

                {
                // Not sure how to render this yet, so keeping the condition false for now
                false &&
                <Pagination.Ellipsis />
                }
                
                {
                    pages.map(
                        page =>
                        page>=1 
                        ?
                        <Pagination.Item onClick={handlePage} active={page === props.page} value={page} key={page}>
                            {page}
                        </Pagination.Item>
                        :
                        <Pagination.Ellipsis />
                    )
                }

                {
                // Not sure how to render this yet, so keeping the condition false for now
                false &&
                <Pagination.Ellipsis />
                }

                <Pagination.Next onClick={handlePage} value="next" disabled={props.page === props.total}/>
                <Pagination.Last onClick={handlePage} value={props.total} disabled={props.page === props.total}/>
            </Pagination>
        </Nav>
    );
};

export default PageNav;