import React, { useEffect, useState } from "react";
import { Button, ToggleButton, ToggleButtonGroup } from "react-bootstrap";

/* Filter pills
**
** Props:
** - filterList: all available filters
** - activeFilters: currently selected filters
** - handler: function to call with onChange
*/
const Filters = ({activeFilters, handler, filterList}) => {

    console.log("filterList", filterList);

    const [toggleText, setToggleText] = useState("Nenhum");

    // update toggle button text
    useEffect( () => {
        if (activeFilters.length == filterList.length)
            setToggleText("Nenhum");
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
        <div className="pt-3 mb-3">
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