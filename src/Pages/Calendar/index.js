import React, {useEffect, useState} from "react";
import NEICalendar from "./NEICalendar";
import Filters from "../../Components/Filters";

const Calendar = () => {

    const [filters, setFilters] = useState([]);
    const [selection, setSelection] = useState([]);    

    return (
        <div>
            <h1 className="text-center">Calendário</h1>

            <div className="col-12 d-flex flex-row flex-wrap my-5">
                <h6 className="text-primary mb-3 my-md-auto ml-auto pr-3 col-12 col-md-4 text-center text-md-right">Categorias</h6>
                <Filters 
                    filterList={filters}
                    activeFilters={selection}
                    setActiveFilters={setSelection}
                    className="mr-auto col-12 col-md-8 d-flex flex-row flex-wrap"
                    btnClass="mx-auto mr-md-2 ml-md-0 mb-2"
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