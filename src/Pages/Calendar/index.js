import React, {useEffect, useState} from "react";
import NEICalendar from "./NEICalendar";
import Filters from "../../Components/Filters";
import Typist from 'react-typist';

const Calendar = () => {

    // Animation
    const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
    const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);

    const [filters, setFilters] = useState([]);
    const [selection, setSelection] = useState([]);    

    return (
        <div>
            <h2 className="text-center">
                <Typist>Calendário</Typist>
            </h2>

            <div className="col-12 d-flex flex-row flex-wrap my-5">
                <div 
                    className="mb-2 col-12 col-md-4 d-flex"
                    style={{
                        animationDelay: animationBase + animationIncrement*0 + "s",
                    }}
                >
                    <p className="animation col-12 text-primary mb-3 my-md-auto ml-auto pr-3 text-center text-md-right">Categorias</p>
                </div>
                <Filters 
                    filterList={filters}
                    activeFilters={selection}
                    setActiveFilters={setSelection}
                    className="animation mr-auto col-12 col-md-8 d-flex flex-row flex-wrap"
                    btnClass="mx-auto mr-md-2 ml-md-0 mb-2"
                    style={{
                        animationDelay: animationBase + animationIncrement*1 + "s",
                    }}
                />
            </div>

            <NEICalendar 
                selection={selection}
                setInitialCategories={(fs) => {
                    setFilters(fs);
                    setSelection(fs.map(f => f['filter']));
                }}
                className="animation"
                style={{
                    animationDelay: animationBase + animationIncrement*2 + "s",
                }}
            />
        </div>
    );
}

export default Calendar;