import React, {useEffect, useState} from "react";
import NEICalendar from "./NEICalendar";
import Filters from "../../Components/Filters";

const Calendar = () => {

    const [filters, setFilters] = useState([]);
    const [selection, setSelection] = useState([]);    

    return (
        <div>
            <h1 className="text-center">Calendário</h1>

            <div className="col-12 d-flex my-3">
                <h6 className="text-primary my-auto ml-auto mr-3">Categorias</h6>
                <Filters 
                    filterList={filters}
                    activeFilters={selection}
                    setActiveFilters={setSelection}
                    className="mr-auto"
                />
            </div>

            <NEICalendar 
                selection={selection}
                setInitialCategories={(fs) => {
                    setFilters(fs);
                    setSelection(fs.map(f => f['filter']));
                }}
            />
        </div>
    );
}

export default Calendar;