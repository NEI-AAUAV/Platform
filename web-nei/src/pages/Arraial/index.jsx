import React, { useEffect, useState } from "react";
import service from 'services/NEIService';
import { getArraialSocket } from "services/SocketService";
import { useUserStore } from "stores/useUserStore";
import config from "config";
import { motion } from "framer-motion";
import './wave.css';

// Configuration constants
const POLLING_INTERVAL = Math.max(60000, config.ARRAIAL.POLLING_INTERVAL || 10000); // use longer fallback when WS is on
const AUTH_USERS = config.ARRAIAL.AUTH_USERS;

export function Component() {
    const [ws, setWs] = useState(null);
    const [pointsList, setPointsList] = useState([
        {nucleo: 'NEEETA', value: 0}, 
        {nucleo: 'NEECT', value: 0}, 
        {nucleo: 'NEI', value: 0}
    ]);
    const [selectedValue, setSelectedValue] = useState('NEEETA');
    const [number, setNumber] = useState('');
    const [error, setError] = useState(null);
    const [isLoading, setIsLoading] = useState(false);
    
    const {email} = useUserStore((state) => state);
    const auth = AUTH_USERS.includes(email);

    useEffect(() => {
        const fetchPoints = () => {
            service.getArraialPoints()
                .then(data => {
                    setPointsList(data);
                    setError(null);
                })
                .catch(error => {
                    console.error('Failed to fetch points:', error);
                    setError('Failed to load points. Please try again.');
                });
        };

        // Initial fetch
        fetchPoints();

        // Subscribe to WebSocket updates
        const socket = getArraialSocket();
        setWs(socket);
        const onMessage = (event) => {
            try {
                const data = JSON.parse(event.data);
                if (data?.topic === 'ARRAIAL_POINTS' && Array.isArray(data.points)) {
                    setPointsList(data.points);
                }
            } catch (e) {
                // ignore non-JSON payloads
            }
        };
        socket.addEventListener('message', onMessage);

        // Fallback polling
        const intervalId = setInterval(fetchPoints, POLLING_INTERVAL);
        return () => {
            clearInterval(intervalId);
            socket.removeEventListener('message', onMessage);
            socket.close();
        };
    }, []);

    const handleChange = (event) => {
        setSelectedValue(event.target.value);
    };
    
    const handleSubmit = (event) => {
        event.preventDefault();
        setIsLoading(true);
        setError(null);
        
        const formdata = {
            "nucleo": selectedValue,
            "pointIncrement": parseInt(number) || 0
        };
        
        service.updateArraialPoints(formdata)
            .then(data => {
                setPointsList(data);
                setNumber('');
                setError(null);
            })
            .catch(error => {
                console.error('Failed to update points:', error);
                if (error?.response?.status === 403) {
                    setError('You do not have permission to update points.');
                } else {
                    setError('Failed to update points. Please try again.');
                }
            })
            .finally(() => {
                setIsLoading(false);
            });
    }


    const handleNumChange = (event) => {
        const value = event.target.value;

        // Check if the value is empty or a valid whole number
        if (value === '' || /^-?\d+$/.test(value)) {
            setNumber(value); // Update state only if it's a non-negative whole number or empty
        }
    };


    const calculateHeight = (points) => {
        let height = Math.min((points * 1.8), 525);
        return height;
    };

    // Headroom-aware height: leave top gap when multiple teams are active
    const FOAM_GAP_PX = 16;            // visual foam thickness already reserved in layout
    const EXTRA_HEADROOM_FRAC = 0.04;  // 4% headroom when multiple teams have points
    const MIN_HEADROOM_FRAC = 0.02;    // small gap even for single leader

    const calcHeight = (points) => {
        const maxPoints = Math.max(...pointsList.map(p => p.value), 1);
        const activeCount = pointsList.filter(p => p.value > 0).length;
        const headroom = activeCount > 1 ? EXTRA_HEADROOM_FRAC : MIN_HEADROOM_FRAC;
        const ratio = Math.max(0, Math.min(points / maxPoints, 1));
        const heightPct = Math.max(0, (1 - headroom) * ratio) * 100;
        // Return percentage; foam gap is already handled by offsetting beer body by 16px
        return `${heightPct}%`;
    };

    const renderPointsBar = (pointsData, index) => (
        <div key={index} className="flex flex-col justify-center space-y-2">
            <div className="relative hidden overflow-hidden w-64 lg:w-[40vh] h-[55vh] border-8 border-white border-t-0 rounded-b-[4rem] md:block">
                <div 
                    className="absolute bottom-0 left-0 w-full transition-all duration-500" 
                    style={{ height: calcHeight(pointsData.value) }}
                >
                    <div className="relative w-full h-full">
                        {/* Beer body starts below foam */}
                        <div style={{ position:'absolute', top:16, left:0, right:0, bottom:0, 
                            background: 'linear-gradient(180deg, #f9d648 0%, #f4c534 65%, #e8b82e 100%)',
                            boxShadow: 'inset 0 2px 0 rgba(255,255,255,0.25)'
                        }} aria-hidden="true"></div>
                        {/* Rising bubbles within beer body */}
                        <div className="bubbles" style={{ top:16 }} aria-hidden="true"></div>
                        {/* Foam: white cap with texture and subtle crest */}
                        <div style={{ position:'absolute', top:0, left:0, right:0, height:16, background:'rgba(255,255,255,0.98)', borderTopLeftRadius:28, borderTopRightRadius:28, overflow:'hidden' }} aria-hidden="true">
                            <div className="foam-texture" />
                            <div className="foam-shadow" />
                        </div>
                        
                    </div>
                </div> 
            </div>                        
            
            <div className="text-center">
                {pointsList.length !== 0 ? (
                    <div>
                        <h2>{pointsData.nucleo}</h2>
                        <h3>Points: {pointsData.value}</h3>
                    </div>
                ) : (
                    <div>
                        <h2>Loading...</h2>
                    </div>   
                )}
            </div>
        </div>
    );

    return (
        <div className="flex flex-col justify-center space-y-16">
            <h1 className="text-center">
                Arraial do DETI
            </h1>
            
            {error && (
                <div className="alert alert-error max-w-md mx-auto">
                    <span>{error}</span>
                </div>
            )}
            
            <div className="flex flex-col md:flex-row justify-center space-x-16">
                {pointsList.map((pointsData, index) => renderPointsBar(pointsData, index))}
            </div>
            {auth ? (
                <div className="rounded-box m-auto flex h-fit max-w-lg flex-col bg-base-200 px-3 py-8 align-middle shadow-secondary drop-shadow-md xs:px-14 sm:max-w-md">
                    <h3>Add/Remove Points</h3>
                    <form onSubmit={handleSubmit}>
                        <div className="flex flex-col space-y-2">
                            <label htmlFor="nucleo-select" className="label">
                                <span className="label-text">Núcleo:</span>
                            </label>
                            <select 
                                id="nucleo-select"
                                className="text-lg bg-neutral-700 h-8 w-full text-center rounded" 
                                value={selectedValue} 
                                onChange={handleChange}
                                aria-label="Select núcleo"
                            >
                                <option value="NEEETA">NEEETA</option>
                                <option value="NEECT">NEECT</option>
                                <option value="NEI">NEI</option>
                            </select>
                            
                            <label htmlFor="points-input" className="label">
                                <span className="label-text">Points:</span>
                            </label>
                            <input
                                id="points-input"
                                type="text"
                                value={number}
                                onChange={handleNumChange}
                                placeholder="0"
                                className="text-lg bg-neutral-700 h-8 w-full text-center rounded"
                                aria-label="Enter points to add or remove"
                            />
                            {number !== '' && !/^-?\d+$/.test(number) && (
                                <p className="text-red-500">Please enter a valid whole number.</p>
                            )}
            
                            <button 
                                type="submit" 
                                disabled={number === '' || number === '0' || !/^-?\d+$/.test(number) || isLoading}
                                className="btn btn-primary"
                            >
                                {isLoading ? 'Updating...' : 'Submit'}
                            </button>
                        </div>
                    </form>
                </div>
            ) : null}
        </div>
        
    )
}
