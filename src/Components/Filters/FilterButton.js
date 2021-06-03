import React, { useState, useEffect } from "react";
import { ToggleButton, ToggleButtonGroup } from "react-bootstrap";

/**
 * This component renders a filter button
 * 
 * Parameters:
 * - filter                 obj         {filter: str, color: str, hover: str}
 *                                          filter: Filter name (required)
 *                                          color: Normal color (optional, if missing .primary will be applied)
 * - activeFilters          str[]       List of active filters
 * - setActiveFilters       function    Function to change active filters list
 * - btnClass               str         Class for button
 */
const FilterButton = ({filter, setActiveFilters, activeFilters, btnClass}) => {

    const [style, setStyle] = useState({});
    const [hover, setHover] = useState(false);

    // Change color on hover and activeFilters change
    useEffect(() => {
        // If filter does not have color, ignore (default .primary will be applied)
        if (!('color' in filter)) {
            return;
        }
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
            className={btnClass}
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