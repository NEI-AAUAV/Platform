import React, { useEffect, useState } from "react";
import { Accordion, Button, ToggleButton, ToggleButtonGroup } from "react-bootstrap";
import Filters from "../";

/* An accordion for selecting filters
**
** Props:
** - filterList: all available filters
** - activeFilters: currently selected filters
** - handler: function to call with onChange
** - children: components to render in accordion header
*/
const FilterSelect = ({children, activeFilters, handler, filterList}) => {

    console.log("filterList1", filterList);

    return(
        <Accordion>
            { /* Accordion header,with the toggler button. Can display props.children on the right side. */ }
            <div className="d-flex justify-content-between mt-4">
                <Accordion.Toggle as={Button} variant="primary" className="mb-3" eventKey="1">
                    Filtros
                </Accordion.Toggle>

                {children}
            </div>

            { /* Accordion body, contains list of filter buttons. Starts collapsed. */ }
            <Accordion.Collapse eventKey="1">
                <Filters 
                    activeFilters={activeFilters}
                    handler={handler}
                    filterList={filterList}
                />
            </Accordion.Collapse>
        </Accordion>
    )
}

export default FilterSelect;