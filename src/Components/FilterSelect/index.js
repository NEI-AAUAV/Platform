import React, { useEffect, useState } from "react";
import { Accordion, Button, ToggleButton, ToggleButtonGroup } from "react-bootstrap";

/* An accordion for selecting filters
**
** Props:
** - filterList: all available filters
** - activeFilters: currently selected filters
** - handler: function to call with onChange
** - children: components to render in accordion header
*/
const FilterSelect = (props) => {

    const [toggleText, setToggleText] = useState("Nenhum");

    // unselect all filters if all are selected, otherwise select all of them
    const toggleAll = () => {
        if (props.activeFilters.length == props.filterList.length)
            props.handler([]);
        else
            props.handler(props.filterList);
    };

    // update toggle button text
    useEffect( () => {
        if (props.activeFilters.length == props.filterList.length)
            setToggleText("Nenhum");
        else
            setToggleText("Todas");
    }, [props.activeFilters]);

    return(
        <Accordion>
            { /* Accordion header,with the toggler button. Can display props.children on the right side. */ }
            <div className="d-flex justify-content-between mt-4">
                <Accordion.Toggle as={Button} variant="success" className="mb-3" eventKey="1">
                    Filtros
                </Accordion.Toggle>

                {props.children}
            </div>

            { /* Accordion body, contains list of filter buttons. Starts collapsed. */ }
            <Accordion.Collapse eventKey="1">
                <div className="pt-3 mb-3 border-top">
                    <Button variant="outline-success" className="mr-4" onClick={toggleAll}>
                        {toggleText}
                    </Button>

                    {props.filterList.map( t => {
                        return (
                            <ToggleButtonGroup type="checkbox" value={props.activeFilters} onChange={props.handler} className="mr-2" key={t}>
                                <ToggleButton variant="outline-success pill" className="rounded-pill" value={t}>
                                    {t}
                                </ToggleButton>
                            </ToggleButtonGroup>
                        );
                    })}
                </div>
            </Accordion.Collapse>
        </Accordion>
    )
}

export default FilterSelect;