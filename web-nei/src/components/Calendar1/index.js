import { useState, useEffect, Fragment } from "react";
import classname from "classname";

import { useWindowSize } from "utils/hooks";
import { AngleRightIcon } from "assets/icons/flaticon/index";


const Calendar = () => {
    const MONTH_NAMES = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];
    const DAYS = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

    const windowSize = useWindowSize();
    const [month, setMonth] = useState('');
    const [year, setYear] = useState('');
    const [numOfDays, setNumOfDays] = useState([]);
    const [blankDays, setBlankDays] = useState([]);

    const [events, setEvents] = useState([
        {
            date: new Date(2023, 1, 1),
            title: "April Fool's Day",
            theme: 'blue'
        },

        {
            date: new Date(2023, 1, 10),
            title: "Birthday",
            theme: 'red'
        },

        {
            date: new Date(2023, 1, 16),
            title: "Upcoming Event",
            theme: 'green'
        }
    ]);

    const [event, setEvent] = useState({
        title: '',
        date: '',
        theme: 'blue',
    })

    const themes = [
        {
            value: "blue",
            label: "Blue Theme"
        },
        {
            value: "red",
            label: "Red Theme"
        },
        {
            value: "yellow",
            label: "Yellow Theme"
        },
        {
            value: "green",
            label: "Green Theme"
        },
        {
            value: "purple",
            label: "Purple Theme"
        }
    ];

    const [openEventModal, setOpenEventModal] = useState(false);

    useEffect(() => {
        initDate();
        getNumOfDays();
    }, [])


    function initDate() {
        let today = new Date();
        setMonth(today.getMonth());
        setYear(today.getFullYear());
        // datepickerValue = new Date(year, month, today.getDate()).toDateString();
    }

    function isToday(date) {
        const today = new Date();
        const d = new Date(year, month, date);

        return today.toDateString() === d.toDateString();
    }

    function showEventModal(date) {
        // open the modal
        setOpenEventModal(true);
        setEvent({
            ...event, date: new Date(year, month, date).toDateString()
        })
    }

    function addEvent() {
        if (event.title == '') {
            return;
        }

        setEvents((prevEvents) => {
            return [...prevEvents, {
                date: event.date,
                title: event.title,
                theme: event.theme
            }];
        })

        console.log(events);

        // clear the form data

        setEvent({
            title: '',
            date: '',
            theme: 'blue',
        })

        //close the modal
        setOpenEventModal(false);
    }

    function getNumOfDays() {
        let daysInMonth = new Date(year, month + 1, 0).getDate();

        // find where to start calendar day of week
        let dayOfWeek = new Date(year, month).getDay();
        let blankDaysArray = [];
        for (var i = 1; i <= dayOfWeek; i++) {
            blankDaysArray.push(i);
        }

        let daysArray = [];
        for (var i = 1; i <= daysInMonth; i++) {
            daysArray.push(i);
        }

        setBlankDays(blankDaysArray);
        setNumOfDays(daysArray);
    }



    return (
        <div>
            <div className="container mx-auto py-2 md:py-24">

                <div className="bg-base-200 rounded-lg shadow overflow-hidden">
                    <div className="flex items-center justify-between py-2 px-6">
                        <div>
                            <span className="text-lg font-bold text-base-content">{MONTH_NAMES[month]}</span>
                            <span className="ml-1 text-lg text-base-content font-normal">{year}</span>
                        </div>
                        <div className="border rounded-lg px-1" style={{ paddingTop: "2px" }}>
                            <button
                                type="button"
                                className={classname("leading-none rounded-lg transition ease-in-out duration-100 inline-flex cursor-pointer hover:bg-gray-200 p-1 items-center",
                                    { 'cursor-not-allowed opacity-25': month == 0 })}
                                disabled={month == 0}
                                onClick={() => { setMonth((prevMonth) => prevMonth--); getNumOfDays() }}>
                                <svg className="h-6 w-6 text-gray-500 inline-flex leading-none" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" />
                                </svg>
                            </button>
                            <div className="border-r inline-flex h-6"></div>
                            <button
                                type="button"
                                className={classname("leading-none rounded-lg transition ease-in-out duration-100 inline-flex items-center cursor-pointer hover:bg-gray-200 p-1",
                                    { 'cursor-not-allowed opacity-25': month == 11 })}
                                disabled={month == 11}
                                onClick={() => { setMonth((prevMonth) => prevMonth++); getNumOfDays() }}>
                                <AngleRightIcon/>
                            </button>
                        </div>
                    </div>

                    <div className="-mx-1 -mb-1">
                        <div className="flex flex-wrap">
                            {
                                DAYS.map((day, index) => (
                                    <div className="w-1/7 py-2" key={index}>
                                        <div className="text-gray-600 text-sm uppercase tracking-wide font-bold text-center">{windowSize.width < 768 ? day[0] : day}</div>
                                    </div>
                                ))
                            }
                        </div>

                        <div className="flex flex-wrap border-t border-l">
                            {
                                blankDays.map((blankday) => {
                                    <div key={blankday}
                                        style={{ height: "120px" }}
                                        className="text-center border-r border-b px-2 pt-2"
                                    ></div>
                                })
                            }
                            {
                                numOfDays.map((date, dateIndex) => (
                                    <Fragment key={dateIndex}>
                                        <div style={{ height: "120px" }} className="w-1/7 text-center md:px-2 md:text-left pt-2 border-r border-b relative">
                                            <div
                                                onClick={() => showEventModal(date)}
                                                className={classname("inline-flex w-6 h-6 items-center justify-center cursor-pointer leading-none rounded-full transition ease-in-out duration-100",
                                                    { 'bg-blue-500 text-white': isToday(date), 'hover:bg-blue-200': !isToday(date) })}
                                            >{date}</div>
                                            <div style={{ height: "80px" }} className="overflow-y-auto mt-1">
                                                {
                                                    events.filter(e => new Date(e.date).toDateString() === new Date(year, month, date).toDateString()).map((event, index) => (
                                                        <div key={index}
                                                            className={classname("px-2 py-1 rounded-lg mt-1 overflow-hidden border", {
                                                                'border-blue-200 text-blue-800 bg-blue-100': event.theme === 'blue',
                                                                'border-red-200 text-red-800 bg-red-100': event.theme === 'red',
                                                                'border-yellow-200 text-yellow-800 bg-yellow-100': event.theme === 'yellow',
                                                                'border-green-200 text-green-800 bg-green-100': event.theme === 'green',
                                                                'border-purple-200 text-purple-800 bg-purple-100': event.theme === 'purple'
                                                            })}
                                                        >
                                                            <p className="text-sm truncate font-bold leading-tight">{event.title}</p>
                                                        </div>
                                                    ))
                                                }
                                            </div>
                                        </div>
                                    </Fragment>
                                ))
                            }
                        </div >
                    </div >
                </div >
            </div >

            {/* < !--Modal-- > */}
            <div style={{ backgroundColor: "rgba(0, 0, 0, 0.8)", display: "none" }} className="fixed z-40 top-0 right-0 left-0 bottom-0 h-full w-full"> {/*x-show.transition.opacity="openEventModal"*/}
                <div className="p-4 max-w-xl mx-auto relative absolute left-0 right-0 overflow-hidden mt-24">
                    <div className="shadow absolute right-0 top-0 w-10 h-10 rounded-full bg-white text-gray-500 hover:text-gray-800 inline-flex items-center justify-center cursor-pointer"
                        onClick={() => setOpenEventModal(!openEventModal)}>
                        <svg className="fill-current w-6 h-6" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                            <path
                                d="M16.192 6.344L11.949 10.586 7.707 6.344 6.293 7.758 10.535 12 6.293 16.242 7.707 17.656 11.949 13.414 16.192 17.656 17.606 16.242 13.364 12 17.606 7.758z" />
                        </svg>
                    </div>

                    <div className="shadow w-full rounded-lg bg-white overflow-hidden w-full block p-8">

                        <h2 className="font-bold text-2xl mb-6 text-gray-800 border-b pb-2">Add Event Details</h2>

                        <div className="mb-4">
                            <label className="text-gray-800 block mb-1 font-bold text-sm tracking-wide">Event title</label>
                            <input className="bg-gray-200 appearance-none border-2 border-gray-200 rounded-lg w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-blue-500" type="text" value={event.title} onChange={(e) => setEvent({ ...event, title: e.target.value })} />
                        </div>

                        <div className="mb-4">
                            <label className="text-gray-800 block mb-1 font-bold text-sm tracking-wide">Event date</label>
                            <input className="bg-gray-200 appearance-none border-2 border-gray-200 rounded-lg w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-blue-500" type="text" value={event.date} readOnly />
                        </div>

                        <div className="inline-block w-64 mb-4">
                            <label className="text-gray-800 block mb-1 font-bold text-sm tracking-wide">Select a theme</label>
                            <div className="relative">
                                <select onChange={(e) => setEvent({ ...event, theme: e.target.value })} value={event.theme} className="block appearance-none w-full bg-gray-200 border-2 border-gray-200 hover:border-gray-500 px-4 py-2 pr-8 rounded-lg leading-tight focus:outline-none focus:bg-white focus:border-blue-500 text-gray-700">
                                    {
                                        themes.map((theme, index) => <option key={index} value={theme.value}>{theme.label}</option>)
                                    }
                                </select>
                                <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                    <svg className="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" /></svg>
                                </div>
                            </div>
                        </div>

                        <div className="mt-8 text-right">
                            <button type="button" className="bg-white hover:bg-gray-100 text-gray-700 font-semibold py-2 px-4 border border-gray-300 rounded-lg shadow-sm mr-2" onClick={() => setOpenEventModal(!openEventModal)}>
                                Cancel
                            </button>
                            <button type="button" className="bg-gray-800 hover:bg-gray-700 text-white font-semibold py-2 px-4 border border-gray-700 rounded-lg shadow-sm" onClick={addEvent}>
                                Save Event
                            </button>
                        </div >
                    </div >
                </div >
            </div >
            {/* < !-- /Modal --> */}
        </div >

    )
}

export default Calendar;
