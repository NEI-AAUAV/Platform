import React, { useEffect, useState } from "react";
import { Accordion, Button, ToggleButton, ToggleButtonGroup } from "react-bootstrap";
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

const FilterSelect = ({children, activeFilters, setActiveFilters, filterList, className, btnClass, listClass, allBtnClass}) => {

    return(
        <Accordion className={className}>
            { /* Accordion header,with the toggler button. Can display props.children on the right side. */ }
            <div className="d-flex justify-content-between mt-4">
                <Accordion.Toggle as={Button} variant="primary" className="mb-3" eventKey="filters">
                    Filtros
                </Accordion.Toggle>

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