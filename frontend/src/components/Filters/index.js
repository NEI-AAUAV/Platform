import React, { useEffect, useState } from "react";
import { Button } from "react-bootstrap";
import FilterButton from "./FilterButton";

/**
 * Filter pills
 * 
 * Parameters:
 * - filterList                 obj[]   List of available filters
 *                              { 'filter': key:str, 'color': colorCodeDefault:str, 'hover': colorCodeHover:str }
 *                                          filter: Filter name (required)
 *                                          color: Normal color (optional, if missing .primary will be applied)
 * - className                  str     class text for parent element
 * - style                      obj     styles for parent element
 * - activeFilters                      see FilterButton doc 
 * - setActiveFilters                   see FilterButton doc
 */
const Filters = ({ activeFilters, setActiveFilters, filterList, className, btnClass, allBtnClass, style }) => {

    const [toggleText, setToggleText] = useState("Nenhum");

    // update toggle button text
    useEffect(() => {
        if (activeFilters.length == filterList.length)
            setToggleText("Nenhumas");
        else
            setToggleText("Todas");
    }, [activeFilters]);

    // unselect all filters if all are selected, otherwise select all of them
    const toggleAll = () => {
        if (activeFilters.length == filterList.length)
            setActiveFilters([]);
        else
            setActiveFilters(filterList.map(f => f['filter']));
    };

    return (
        <div
            className={className}
            style={style}
        >
            {
                filterList.length > 1 &&
                <Button variant={"outline-primary " + btnClass} className={allBtnClass + " p-2"} onClick={toggleAll}>
                    {toggleText}
                </Button>
            }

            {
                filterList.map((f, index) =>
                    <React.Fragment key={index}>
                        <FilterButton
                            filter={f}
                            setActiveFilters={setActiveFilters}
                            activeFilters={activeFilters}
                            btnClass={btnClass + " " + allBtnClass}
                        />
                    </React.Fragment>
                )
            }
        </div>
    );
}

export default Filters;