import React, { useEffect, useState } from "react";
import { Button } from "react-bootstrap";
import FilterButton from "./FilterButton";

/**
 * Filter pills
 * 
 * Parameters:
 * - filterList                 str[]   List of available filters
 * - className                  str     class text for parent element
 * - activeFilters                      see FilterButton doc 
 * - setActiveFilters                   see FilterButton doc
 */
const Filters = ({activeFilters, setActiveFilters, filterList, className, btnClass, allBtnClass}) => {

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
            setActiveFilters([]);
        else
            setActiveFilters(filterList.map(f => f['filter']));
    };

    return (
        <div className={className}>
            <Button variant={"outline-primary " + btnClass} className={allBtnClass} onClick={toggleAll}>
                {toggleText}
            </Button>

            {
                filterList.map( f => 
                    <FilterButton
                        filter={f} 
                        setActiveFilters={setActiveFilters}
                        activeFilters={activeFilters}
                        btnClass={btnClass}
                    />
                )
            }
        </div>
    );
}

export default Filters;