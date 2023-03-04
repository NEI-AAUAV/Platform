/** @jsxRuntime classic */
/** @jsx jsx */
import { css, jsx } from '@emotion/react';
import { useState, useEffect, Fragment } from "react";
import classname from "classname";

import { useWindowSize } from "utils/hooks";
import { ArrowForwardIcon } from "assets/icons/google";

import service from "services/GoogleCalendarService";

const selection = ["[1A]", "2A", "[NEI]", "3A"];


const Calendar = () => {
    const MONTHS = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];
    const WEEK_DAYS = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

    const windowSize = useWindowSize();
    const [month, setMonth] = useState('');
    const [year, setYear] = useState('');
    const [numOfDays, setNumOfDays] = useState([]);
    const [blankDays, setBlankDays] = useState([]);

    const [calendarSince, setCalendarSince] = useState(null);
    const [calendarTo, setCalendarTo] = useState(null);

    const [events, setEvents] = useState([
        { date: new Date(2023, 1, 1), title: "April Fool's Day", theme: '187 99% 45%' },
        { date: new Date(2023, 1, 10), title: "Birthday", theme: '187 98% 20%' },
        { date: new Date(2023, 1, 16), title: "Upcoming Event", theme: '38 100% 50%' }
    ]);

    const [event, setEvent] = useState({ title: '', date: '', theme: 'blue', })

    const themes = [
        { value: "blue", label: "Blue Theme" },
        { value: "red", label: "Red Theme" },
        { value: "yellow", label: "Yellow Theme" },
        { value: "green", label: "Green Theme" },
        { value: "purple", label: "Purple Theme" }
    ];

    const [openEventModal, setOpenEventModal] = useState(false);



    // On render, initialize calendarSince and calendarTo based on current moment
    // Also initialize categories
    useEffect(() => {
        initDate();
        getNumOfDays();
        timespanChanged(new Date());
    }, []);

    useEffect(() => {
        if (calendarSince === null || calendarTo === null) {
            return;
        }
        const timeMin = `${calendarSince.getFullYear()}-${calendarSince.getMonth() + 1}-${calendarSince.getDate()}T00:00:00+01:00`;
        const timeMax = `${calendarTo.getFullYear()}-${calendarTo.getMonth() + 1}-${calendarTo.getDate()}T00:00:00+01:00`;

        service.getEvents({ timeMin, timeMax })
            .then(({ data }) => {
                console.log(data)
                let apiEvents = [];
                data.items.forEach(e => {
                    // Check that event matches selection
                    let matchAny = true;
                    let matchSelected = true;
                    // Object.entries(categoriesTypes).forEach(([key, c]) => {
                    //     c['filters'].forEach(f => {
                    //         if (e['summary'].toLowerCase().indexOf(f.toLowerCase()) >= 0) {
                    //             matchAny = true;
                    //             matchSelected = selection.indexOf(key) >= 0;
                    //         }
                    //     });
                    // });
                    // It must match any filter, if not, is considered NEI event (default) and to be showed NEI must be in selection
                    if (matchSelected == false && (matchAny && selection.indexOf('NEI') >= 0 || selection.indexOf('NEI') < 0)) {
                        return;
                    }
                    // If so, compute object to add to events list
                    const start = 'date' in e['start'] ? e['start']['date'] : e['start']['dateTime'];
                    let end = 'date' in e['end'] ? e['end']['date'] : e['end']['dateTime'];
                    if ('date' in e['end']) {
                        let endDate = new Date(end);
                        endDate = endDate.setDate(endDate.getDate() - 1);
                        end = endDate;
                    }
                    apiEvents.push({
                        'id': e['id'],
                        'title': e['summary'],
                        'start': new Date(start),
                        'end': new Date(end),
                        'allDay': 'date' in e['start']
                    });
                });
                setEvents(apiEvents);
                console.log(apiEvents)
            });
    }, [selection, calendarSince, calendarTo]);


    // On navigate, update next and prev moments and recall API
    function timespanChanged(date) {
        let next = new Date(date);
        let prev = new Date(date);

        if (date.getMonth() == 11) {
            next.setMonth(0);
            next.setYear(date.getFullYear() + 1);
            prev.setMonth(date.getMonth() - 1);
        } else if (date.getMonth() == 0) {
            next.setMonth(date.getMonth() + 1);
            prev.setMonth(11);
            prev.setYear(date.getFullYear() - 1);
        } else {
            next.setMonth(date.getMonth() + 1);
            prev.setMonth(date.getMonth() - 1);
        }

        setCalendarSince(prev);
        setCalendarTo(next);
    }

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
                            <span className="text-lg font-bold text-base-content">{MONTHS[month]}</span>
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
                                <ArrowForwardIcon />
                            </button>
                        </div>
                    </div>

                    <div className="-mx-1 -mb-1">
                        <div className="flex flex-wrap">
                            {
                                WEEK_DAYS.map((day, index) => (
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
                                                            css={css`
                                                                background-color: hsl(${event.theme});
                                                                `}
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
