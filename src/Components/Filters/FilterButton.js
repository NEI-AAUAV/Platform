import React, { useState, useEffect } from "react";
import { ToggleButton, ToggleButtonGroup } from "react-bootstrap";

/**
 * This component renders a filter button
 * 
 * Parameters:
 * - filter                 obj         {name: str, color: str, hover: str}
 *                                      name: Filter name
 *                                      color: Normal color
 *                                      hover: Color when hover or active
 * - activeFilters          str[]       List of active filters
 * - setActiveFilters       function    Function to change active filters list
 */
const FilterButton = ({filter, setActiveFilters, activeFilters}) => {

    const [style, setStyle] = useState({});
    const [hover, setHover] = useState(false);

    // Change color on hover and activeFilters change
    useEffect(() => {
        // If active or hover, fill
        if (hover || activeFilters.includes(filter['filter'])) {
            setStyle({
                backgroundColor: filter['color'],
                borderColor: filter['color'],
                color: '#fff'
            });
        }
        // Else, outline 
        else {
            setStyle({
                borderColor: filter['color'],
                color: filter['color']
            });
        }
    }, [activeFilters, hover]);

    return (
        filter &&
        <ToggleButtonGroup 
            type="checkbox" 
            value={activeFilters} 
            onChange={setActiveFilters} 
            className="mr-2" 
            key={filter['filter']}
            onMouseEnter={() => setHover(true)}
            onMouseLeave={() => setHover(false)}
        >
            <ToggleButton 
                variant="outline-primary pill" 
                className="rounded-pill" 
                value={filter['filter']}
                style={style}
            >
                {filter['filter']}
            </ToggleButton>
        </ToggleButtonGroup>
    );
}

export default FilterButton;