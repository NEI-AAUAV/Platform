import React, { useEffect, useState } from "react";
import classname from "classname";

import NEICalendar from "./NEICalendar";
import Filters from "../../components/Filters";
import Typist from 'react-typist';
import Calendar2 from "components/Calendar2"
import Calendar1 from "components/Calendar1"


const LABELS = [
    { key: "1A", name: "1º Ano" },
    { key: "2A", name: "2º Ano" },
    { key: "3A", name: "3º Ano" },
    { key: "MEI", name: "MEI" },
    { key: "", name: "Calendário Escolar" },
]


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


            <h3 className="mb-4 font-semibold text-gray-900 dark:text-white">Identification</h3>
            <ul className="items-center w-full text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-lg sm:flex dark:bg-gray-700 dark:border-gray-600 dark:text-white">
                {
                    LABELS.map(({ key, name }, index) => (
                        <li className={classname("w-full dark:border-gray-600", { "border-b border-gray-200 sm:border-b-0 sm:border-r": index + 1 === LABELS.length })}>
                            <div className="form-control">
                                <label className="cursor-pointer label !justify-start">
                                    <input type="checkbox" checked="checked" className="checkbox" />
                                    <span className="label-text px-2">{name}</span>
                                </label>
                            </div>
                        </li>
                    ))
                }
            </ul>

            <ul className="grid w-full gap-6 md:grid-cols-3">
                {
                    LABELS.map(({ key, name }, index) => (
                        <li key={index}>
                            <input type="checkbox" id={`check-${key}`} value="" className="hidden peer" required="" />
                            <label for={`check-${key}`} className="inline-flex items-center justify-between w-full p-5 text-gray-500 bg-white border-2 border-gray-200 rounded-lg cursor-pointer dark:hover:text-gray-300 dark:border-gray-700 peer-checked:border-blue-600 hover:text-gray-600 dark:peer-checked:text-gray-300 peer-checked:text-gray-600 hover:bg-gray-50 dark:text-gray-400 dark:bg-gray-800 dark:hover:bg-gray-700">
                                <div className="block">
                                    <div className="w-full text-lg font-semibold">{name}</div>
                                    <div className="w-full text-sm">A JavaScript library for building user interfaces.</div>
                                </div>
                            </label>
                        </li>
                    ))
                }
            </ul>


            <div className="col-12 d-flex flex-row flex-wrap my-5">
                <div
                    className="mb-2 col-12 col-md-4 d-flex"
                    style={{
                        animationDelay: animationBase + animationIncrement * 0 + "s",
                    }}
                >
                    <p className="slideUpFade col-12 text-primary mb-3 my-md-auto ml-auto pr-3 text-center text-md-right">Categorias</p>
                </div>
                <Filters
                    filterList={filters}
                    activeFilters={selection}
                    setActiveFilters={setSelection}
                    className="slideUpFade mr-auto col-12 col-md-8 d-flex flex-row flex-wrap"
                    btnClassName="mx-auto mr-md-2 ml-md-0 mb-2"
                    style={{
                        animationDelay: animationBase + animationIncrement * 1 + "s",
                    }}
                />
            </div>

            <NEICalendar
                selection={selection}
                setInitialCategories={(fs) => {
                    setFilters(fs);
                    setSelection(fs.map(f => f['filter']));
                }}
                className="slideUpFade"
                style={{
                    animationDelay: animationBase + animationIncrement * 2 + "s",
                }}
            />


            {/* <Calendar2 ></Calendar2> */}
            <Calendar1 ></Calendar1>
        </div>
    );
}

export default Calendar;