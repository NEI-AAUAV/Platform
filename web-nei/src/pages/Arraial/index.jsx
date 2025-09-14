import React, { useEffect, useState } from "react";
import service from 'services/NEIService';
import { getSocket } from "services/SocketService";
import { useUserStore } from "stores/useUserStore";

import './wave.css';


export function Component() {

    const ws = getSocket();
    const [pointsList, setPointsList] = useState([{nucleo: 'NEEETA', value: 0}, {nucleo: 'NEECT', value: 0}, {nucleo: 'NEI', value: 0}])
    const [selectedValue, setSelectedValue] = useState('NEEETA');
    const [number, setNumber] = useState('');
    const auth_users = ["manager_arrail1@lmao.pt", "manager_arrail2@omega.pt", "manager_arrail3@lul.pt"]
    const {email} = useUserStore((state) => state);
    const auth = auth_users.includes(email)

    useEffect(() => {
        const fetchPoints = () => {
            service.getArraialPoints()
                .then(data => {
                    setPointsList(data)
                })
            }
        
        const intervalId = setInterval(fetchPoints, 10000); // 10000 milliseconds = 10 seconds
        return () => clearInterval(intervalId);
    }, []);

    const handleChange = (event) => {
        setSelectedValue(event.target.value);
    };
    
    const handleSubmit = () => {
        event.preventDefault(); // Prevent the default form submission
        const formdata = {
            "nucleo": selectedValue,
            "pointIncrement": number
        }
        
        service.updateArraialPoints(formdata)
        .then(data => {
            setPointsList(data)
        })
        setNumber(0)
    }


    const handleNumChange = (event) => {
        const value = event.target.value;

        // Check if the value is empty or a valid whole number
        if (value === '' || /^-?\d+$/.test(value)) {
            setNumber(value); // Update state only if it's a non-negative whole number or empty
        }
    };


    const calculateHeight = (points) => {
        let height = Math.min((points*1.8), 525)
        return height;
    };

    return (
        <div className="flex flex-col justify-center space-y-16">
            <h1 className="text-center">
                Arraial do DETI
            </h1>
            <div className="flex flex-col md:flex-row justify-center space-x-16">
                <div className="flex flex-col justify-center space-y-2">
                    <div className="relative hidden overflow-hidden w-64 lg:w-[40vh] h-[55vh] border-8 border-white border-t-0 rounded-b-[4rem] md:block">
                        <div className="absolute bottom-0 left-0 w-full bg-yellow-300 transition-all duration-500" style={{ height: calculateHeight(pointsList[0].value) }}>
                            <div className="relative w-full h-full">
                                <div className="absolute top-0 wave "></div>    
                                <div className="absolute top-0 wave wave2"></div>
                            </div>
                        </div> 
                    </div>                        
                    
                    <div className="text-center">
                        {pointsList.length !== 0 ? (
                            <div>
                                <h2>{pointsList[0].nucleo}</h2>
                                <h3>Points: {pointsList[0].value}</h3>
                            </div>
                            ) : (
                            <div>
                                <h2>
                                    Loading...
                                </h2>
                            </div>   
                            )
                        }
                    </div>
                </div>
                <div className="flex flex-col justify-center space-y-2">
                    <div className="relative hidden overflow-hidden w-64 lg:w-[40vh] h-[55vh] border-8 border-white border-t-0 rounded-b-[4rem] md:block">
                        <div className="absolute bottom-0 left-0 w-full bg-yellow-300 transition-all duration-500" style={{ height: calculateHeight(pointsList[1].value) }}>
                            <div className="relative w-full h-full">
                                <div className="absolute top-0 wave "></div>    
                                <div className="absolute top-0 wave wave2"></div>
                            </div>
                        </div> 
                    </div>                        
                    
                    <div className="text-center">
                        {pointsList.length !== 0 ? (
                            <div>
                                <h2>{pointsList[1].nucleo}</h2>
                                <h3>Points: {pointsList[1].value}</h3>
                            </div>
                            ) : (
                            <div>
                                <h2>
                                    Loading...
                                </h2>
                            </div>   
                            )
                        }
                    </div>
                </div>
                <div className="flex flex-col justify-center space-y-2">
                    <div className="relative hidden overflow-hidden w-64 lg:w-[40vh] h-[55vh] border-8 border-white border-t-0 rounded-b-[4rem] md:block">
                        <div className="absolute bottom-0 left-0 w-full bg-yellow-300 transition-all duration-500" style={{ height: calculateHeight(pointsList[2].value) }}>
                            <div className="relative w-full h-full">
                                <div className="absolute top-0 wave "></div>    
                                <div className="absolute top-0 wave wave2"></div>
                            </div>
                        </div> 
                    </div>                        
                    
                    <div className="text-center">
                        {pointsList.length !== 0 ? (
                            <div>
                                <h2>{pointsList[2].nucleo}</h2>
                                <h3>Points: {pointsList[2].value}</h3>
                            </div>
                            ) : (
                            <div>
                                <h2>
                                    Loading...
                                </h2>
                            </div>   
                            )
                        }                    
                    </div>
                </div>
            </div>
            {auth ? (
                <div className="rounded-box m-auto flex h-fit max-w-lg flex-col bg-base-200 px-3 py-8 align-middle shadow-secondary drop-shadow-md xs:px-14 sm:max-w-md">
                    <h3>Add/Remove Points</h3>
                    <form onSubmit={handleSubmit}>
                        <div className="flex flex-col space-y-2">
                            <label className="label">
                                <span className="label-text">Núcleo:</span>
                            </label>
                            <select className="text-lg bg-neutral-700 h-8 w-full text-center rounded" value={selectedValue} onChange={handleChange}>
                                <option value="NEEETA">NEEETA</option>
                                <option value="NEECT">NEECT</option>
                                <option value="NEI">NEI</option>
                            </select>
                            
                            <label className="label">
                                <span className="label-text">Points:</span>
                            </label>
                            <input
                                id="wholeNumber"
                                type="text" // Use text to control the input validation
                                value={number}
                                onChange={handleNumChange}
                                placeholder="0"
                                className="text-lg bg-neutral-700 h-8 w-full text-center rounded"
                                />
                            {number !== '' && !/^-?\d+$/.test(number) && (
                                <p style={{ color: 'red' }}>Please enter a valid whole number.</p>
                            )}
            
                            <button type="submit" disabled={number === '' || !/^-?\d+$/.test(number)}>
                                Submit
                            </button>
                        </div>
                    </form>
                </div>
            ) : null}
        </div>
        
    )
}
