import React, { useEffect, useState } from "react";
import { Button, ToggleButton, ToggleButtonGroup } from "react-bootstrap";

/* Filter pills
**
** Props:
** - filterList: all available filters
** - activeFilters: currently selected filters
** - handler: function to call with onChange
** - className: class text for parent element
*/
const Filters = ({activeFilters, handler, filterList, className}) => {

    console.log("filterList", filterList);

    const [toggleText, setToggleText] = useState("Nenhum");

    // update toggle button text
    useEffect( () => {
        if (activeFilters.length == filterList.length)
            setToggleText("Nenhumas");
        else
            setToggleText("Todas");
    }, [activeFilters]);

    // unselect all filters if all are selected, otherwise select all of them
    const toggleAll = () => {
        if (activeFilters.length == filterList.length)
            handler([]);
        else
            handler(filterList);
    };

    return (
        <div className={"pt-3 mb-3 " + className}>
            <Button variant="outline-success" className="mr-4" onClick={toggleAll}>
                {toggleText}
            </Button>

            {filterList.map( t => {
                return (
                    <ToggleButtonGroup type="checkbox" value={activeFilters} onChange={handler} className="mr-2" key={t}>
                        <ToggleButton variant="outline-success pill" className="rounded-pill" value={t}>
                            {t}
                        </ToggleButton>
                    </ToggleButtonGroup>
                );
            })}
        </div>
    );
}

export default Filters;