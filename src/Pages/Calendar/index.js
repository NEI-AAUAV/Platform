import React, {useEffect, useState} from "react";
import NEICalendar from "./NEICalendar";
import FilterSelect from "../../Components/FilterSelect";

const Calendar = () => {

    const [filters, setFilters] = useState([]);
    const [selection, setSelection] = useState([]);    

    return (
        <div>
            <h1 className="text-center mb-5">Calendário</h1>

            <FilterSelect 
                filterList={filters}
                activeFilters={selection}
                handler={setSelection}
            />

            <NEICalendar 
                selection={selection}
                setInitialCategories={(fs) => {
                    setFilters(fs);
                    setSelection(fs);
                }}
            />
        </div>
    );
}

export default Calendar;