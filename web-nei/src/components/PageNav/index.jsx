import React from "react";
import classNames from "classnames";
import "./index.css";

/* A pagination bar, as seen in https://daisyui.com/components/pagination/
** 
** ATTENTION! This component is 1-based index (first index is 1)!
**
** Props:
** - numPages: total number of pages
** - currentPage: current active page
** - pageDelta: number of surrounding pages to render (default 1)
** - handler: function to call with onClick, argument given is new page number
** - className: extra styles to be applied (optional)
*/
const PageNav = ({ numPages, currentPage, pageDelta = 2, handler, className }) => {
    // Don't render anything if there aren't pages to be paginated
    if (numPages === 1) {
        return null;
    }

    return (
        <div className={classNames("flex justify-center", className)}>
            <div className="btn-group">
                {/* Previous page button, only shown if not on the first page */}
                {currentPage > 1 && <button
                    className="btn"
                    onClick={() => handler(currentPage - 1)}
                >
                    «
                </button>}
                {/* First page button, always shown */}
                <button
                    className={classNames("btn", currentPage === 1 && "btn-active")}
                    onClick={() => handler(1)}
                >
                    1
                </button>
                {
                    // List generator for buttons and ellipsis, the algorithm starts by
                    // generating 2 * pageDelta elements, these will be the surrounding
                    // pages that will be shown, plus 3 extra elements, one for the current
                    // page and one for each side ellipsis that might be needed.
                    Array(2 * pageDelta + 3).fill().map((_, idx) => {
                        // The page of the current button is calculated by starting at the
                        // left side of the visible range, which is the current page minus
                        // the number of surrounding to be shown and minus the ellipsis that
                        // might appear. Then the index of the current iteration is added to
                        // get the true page of the button.
                        const page = currentPage - pageDelta - 1 + idx;

                        // If the page doesn't exist (is out of the range of pages) or is the
                        // first or last page, then no element is rendered).
                        if (page <= 1 || page >= numPages) return null;

                        // If the button wasn't culled previously and is the first iteration or
                        // last of the algorithm then it's an ellipsis.
                        if (idx === 0 || idx === 2 * pageDelta + 2)
                            return <button key={page} className="btn btn-disabled hidden sm:flex">...</button>;

                        const distance = Math.abs(currentPage - page);

                        // Otherwise render a normal page button.
                        return <button
                            key={page}
                            className={classNames(
                                "btn",
                                page === currentPage && "btn-active",
                                // Hide pages that aren't immediately adjacent in small screens
                                (page !== currentPage && distance > 1) && "hidden xs:flex"
                            )}
                            onClick={() => handler(page)}
                        >
                            {page}
                        </button>;
                    })
                }
                {/* Last page button, always shown */}
                <button
                    className={classNames("btn", currentPage === numPages && "btn-active")}
                    onClick={() => handler(numPages)}
                >
                    {numPages}
                </button>
                {/* Next page button, only shown if not on the last page */}
                {currentPage !== numPages && <button
                    className="btn"
                    onClick={() => handler(currentPage + 1)}
                >
                    »
                </button>}
            </div>
        </div>
    );
};

export default PageNav;
