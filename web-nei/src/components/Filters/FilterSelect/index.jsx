import React from "react";
import { Accordion, Button, useAccordionButton } from "react-bootstrap";
import Filters from "../";

/**
 * An accordion for selecting filters
 * 
 * Parameters:
 * - filterList                 str[]   List of available filters
 * - children                           components to render in accordion header
 * - activeFilters                      see FilterButton doc 
 * - setActiveFilters                   see FilterButton doc
 */

// react-bootstrap v2 replaced `Accordion.Toggle` by the `useAccordionButton` hook
const FiltersToggle = ({ eventKey, children, className }) => {
    const onClick = useAccordionButton(eventKey);

    return (
        <Button variant="primary" className={className} onClick={onClick}>
            {children}
        </Button>
    );
};

const FilterSelect = ({children, activeFilters, setActiveFilters, filterList, className, btnClass, listClass, allBtnClass}) => {

    return(
        <Accordion className={className}>
            { /* Accordion header,with the toggler button. Can display props.children on the right side. */ }
            <div className="d-flex flex-row justify-content-between flex-wrap mt-4">
                <FiltersToggle eventKey="filters" className="col-12 col-lg-3 col-xl-2 mr-auto mb-3">
                    Filtros
                </FiltersToggle>

                {children}
            </div>

            { /* Accordion body, contains list of filter buttons. Starts collapsed. */ }
            <Accordion.Collapse eventKey="filters">
                <Filters 
                    activeFilters={activeFilters}
                    setActiveFilters={setActiveFilters}
                    filterList={filterList}
                    btnClass={btnClass}
                    className={listClass}
                    allBtnClass={allBtnClass}
                />
            </Accordion.Collapse>
        </Accordion>
    )
}

export default FilterSelect;