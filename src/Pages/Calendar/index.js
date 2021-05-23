import React, {useEffect, useState} from "react";
import NEICalendar from "./NEICalendar";
import Filters from "../../Components/Filters";

const Calendar = () => {

    const [filters, setFilters] = useState([]);
    const [selection, setSelection] = useState([]);    

    return (
        <div>
            <h1 className="text-center mb-5">Calendário</h1>

            <Filters 
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