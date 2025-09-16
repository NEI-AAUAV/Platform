import React, { useEffect, useState } from "react";
import service from 'services/NEIService';
import { getArraialSocket } from "services/SocketService";
import { useUserStore } from "stores/useUserStore";
import config from "config";
import neiLogo from "assets/images/NEI.png";
import neectLogo from "assets/images/NEECT.png";
import neeetaLogo from "assets/images/NEEETA.png"; // used for NEEETA núcleo
import './wave.css';

// Configuration constants
const POLLING_INTERVAL = Math.max(60000, (config.ARRAIAL && config.ARRAIAL.POLLING_INTERVAL) || 10000); // use longer fallback when WS is on
const LOG_PAGE_SIZE = 100;

export function Component() {
    const [ws, setWs] = useState(null);
    const [wsConnected, setWsConnected] = useState(false);
    const [enabled, setEnabled] = useState(true);
    const [pointsList, setPointsList] = useState([
        {nucleo: 'NEEETA', value: 0}, 
        {nucleo: 'NEECT', value: 0}, 
        {nucleo: 'NEI', value: 0}
    ]);
    const [selectedValue, setSelectedValue] = useState('NEEETA');
    const [number, setNumber] = useState('');
    const [error, setError] = useState(null);
    const [isLoading, setIsLoading] = useState(false);
    const [log, setLog] = useState([]);
    const [logLoading, setLogLoading] = useState(false);
    const [showHistory, setShowHistory] = useState(false);
    const [nextOffset, setNextOffset] = useState(null);

    // History filters (user id removed)
    const [filterNucleo, setFilterNucleo] = useState('');
    const [filterRolledBack, setFilterRolledBack] = useState(''); // '', 'true', 'false'
    
    const { email, scopes } = useUserStore((state) => state);
    const auth = Array.isArray(scopes) && (scopes.includes('admin') || scopes.includes('manager-arraial'));

    useEffect(() => {
        const initConfig = async () => {
            try {
                const cfg = await service.getArraialConfig();
                setEnabled(!!cfg?.enabled);
            } catch (e) {
                setEnabled(true); // default true if endpoint fails
            }
        };

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

        const fetchLog = (offset = 0, append = false) => {
            if (!auth) return;
            setLogLoading(true);
            const filters = {};
            if (filterNucleo) filters.nucleo = filterNucleo;
            if (filterRolledBack === 'true') filters.rolled_back = true;
            if (filterRolledBack === 'false') filters.rolled_back = false;
            service.getArraialLog(LOG_PAGE_SIZE, offset, filters)
                .then(({ items, next_offset }) => {
                    setLog((prev) => append ? [...prev, ...(items || [])] : (items || []));
                    setNextOffset(next_offset ?? null);
                })
                .catch(err => console.error('Failed to load history:', err))
                .finally(() => setLogLoading(false));
        }

        // Initial fetch
        initConfig();
        fetchPoints();
        fetchLog(0, false);

        // Subscribe to WebSocket updates
        const socket = getArraialSocket();
        setWs(socket);
        const onMessage = (event) => {
            try {
                const data = JSON.parse(event.data);
                if (data?.topic === 'ARRAIAL_POINTS' && Array.isArray(data.points)) {
                    setPointsList(data.points);
                    if (auth) fetchLog(0, false);
                } else if (data?.topic === 'ARRAIAL_CONFIG' && typeof data.enabled === 'boolean') {
                    setEnabled(!!data.enabled);
                }
            } catch (e) {
                // ignore non-JSON payloads
            }
        };
        const onOpen = () => setWsConnected(true);
        const onClose = () => setWsConnected(false);
        const onError = () => setWsConnected(false);

        socket.addEventListener('message', onMessage);
        socket.addEventListener('open', onOpen);
        socket.addEventListener('close', onClose);
        socket.addEventListener('error', onError);

        // Set initial connection state
        setWsConnected(socket.readyState === WebSocket.OPEN);

        // Fallback polling
        const intervalId = setInterval(fetchPoints, POLLING_INTERVAL);
        return () => {
            clearInterval(intervalId);
            socket.removeEventListener('message', onMessage);
            socket.removeEventListener('open', onOpen);
            socket.removeEventListener('close', onClose);
            socket.removeEventListener('error', onError);
        };
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [auth]);

    // Refetch log when filters change (reset to first page)
    useEffect(() => {
        if (!auth) return;
        setLogLoading(true);
        const filters = {};
        if (filterNucleo) filters.nucleo = filterNucleo;
        if (filterRolledBack === 'true') filters.rolled_back = true;
        if (filterRolledBack === 'false') filters.rolled_back = false;
        service.getArraialLog(LOG_PAGE_SIZE, 0, filters)
          .then(({ items, next_offset }) => {
            setLog(items || []);
            setNextOffset(next_offset ?? null);
          })
          .catch(() => {})
          .finally(() => setLogLoading(false));
    }, [auth, filterNucleo, filterRolledBack]);

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

    const quickAdjust = (delta) => {
        setError(null);
        // If empty, start from 0; else parse current number
        const base = number === '' ? 0 : parseInt(number, 10) || 0;
        const next = base + delta;
        setNumber(String(next));
    };

    const handleRollback = (id) => {
        setError(null);
        setLogLoading(true);
        service.rollbackArraial(id)
            .then(() => {
                const filters = {};
                if (filterNucleo) filters.nucleo = filterNucleo;
                if (filterRolledBack === 'true') filters.rolled_back = true;
                if (filterRolledBack === 'false') filters.rolled_back = false;
                return service.getArraialLog(LOG_PAGE_SIZE, 0, filters).then(({items, next_offset}) => { setLog(items||[]); setNextOffset(next_offset??null); })
            })
            .catch(err => {
                console.error('Failed to rollback:', err);
                setError('Failed to rollback.');
            })
            .finally(() => setLogLoading(false));
    };


    // Headroom-aware height: leave top gap when multiple teams are active
    const FOAM_GAP_PX = 18;            // visual foam thickness already reserved in layout
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

    if (!enabled) {
        return (
            <div className="mx-auto max-w-xl p-6 text-center">
                <h1>Arraial do DETI</h1>
                <p className="mt-3 opacity-80">Esta página está temporariamente desativada.</p>
            </div>
        );
    }

    const renderPointsBar = (pointsData, index) => (
        <div key={index} className="flex flex-col justify-center items-center space-y-2">
            <div className="relative block mx-auto w-40 sm:w-56 md:w-64 lg:w-[40vh] h-[40vh] sm:h-[48vh] md:h-[55vh] border-8 border-white border-t-0 rounded-b-[3rem]">
                {/* Inner content wrapper to clip beer/foam, outer stays visible for handle */}
                <div className="absolute inset-0 overflow-hidden rounded-b-[2.5rem]">
                    {/* Glass effects */}
                    <div className="glass-inner" aria-hidden="true"></div>
                    <div className="glass-rim" aria-hidden="true"></div>
                    {/* Per-núcleo logo centered in the glass (not the beer) */}
                    <div style={{ position:'absolute', top:34, left:0, right:0, bottom:32, display:'flex', alignItems:'center', justifyContent:'center', pointerEvents:'none', zIndex:5 }} aria-hidden="true">
                        <img
                            src={
                                pointsData.nucleo === 'NEECT' ? neectLogo :
                                pointsData.nucleo === 'NEEETA' ? neeetaLogo :
                                neiLogo
                            }
                            alt={pointsData.nucleo}
                            style={{ maxWidth:'42%', maxHeight:'42%', opacity:0.75 }}
                        />
                    </div>
                    <div 
                        className="absolute bottom-0 left-0 w-full transition-all duration-500" 
                        style={{ height: calcHeight(pointsData.value), overflow: 'hidden' }}
                    >
                        <div className="relative w-full h-full">
                            {/* Beer body starts below foam */}
                            <div style={{ position:'absolute', top:28, left:0, right:0, bottom:0, 
                                background: 'linear-gradient(180deg, #f9d648 0%, #f4c534 65%, #e8b82e 100%)',
                                boxShadow: 'inset 0 2px 0 rgba(255,255,255,0.25)',
                            }} aria-hidden="true"></div>

                            {/* Rising bubbles within beer body */}
                            <div className="bubbles" style={{ top:18 }} aria-hidden="true"></div>
                            {/* Foam: white cap with texture and subtle crest */}
                            <div style={{ position:'absolute', top:0, left:0, right:0, height:28, background:'rgba(255,255,255,0.98)', borderTopLeftRadius:28, borderTopRightRadius:28, overflow:'hidden' }} aria-hidden="true">
                                <div className="foam-texture" />
                                <div className="foam-shadow" />
                            </div>

                            {/* Glass overlays above beer */}
                            <div className="beer-vignette" aria-hidden="true"></div>
                            <div className="glass-shadow" aria-hidden="true"></div>
                            <div className="glass-base-highlight" aria-hidden="true"></div>
                            <div className="glass-glare-left" aria-hidden="true"></div>
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
        <div className="flex flex-col justify-center space-y-12 md:space-y-16">
            <div className="text-center">
                <h1>Arraial do DETI</h1>
                {/* Live connection indicator */}
                <div className="flex items-center justify-center gap-2 mt-2">
                    <div className={`w-2 h-2 rounded-full ${
                        wsConnected ? 'bg-green-500' : 'bg-red-500'
                    }`}></div>
                    <span className="text-xs opacity-70">
                        {wsConnected ? 'Live' : 'Offline'}
                    </span>
                </div>
            </div>
            
            {error && (
                <div className="alert alert-error max-w-md mx-auto">
                    <span>{error}</span>
                </div>
            )}
            
            <div className="flex flex-col md:flex-row items-center md:items-start justify-center space-y-10 md:space-y-0 md:space-x-16">
                {pointsList.map((pointsData, index) => renderPointsBar(pointsData, index))}
            </div>
            {auth ? (
                <div className="rounded-box m-auto w-full max-w-lg sm:max-w-md flex h-fit flex-col bg-base-200 px-4 sm:px-6 py-6 align-middle shadow-secondary drop-shadow-md">
                    <h3>Add/Remove Points</h3>
                    <form onSubmit={handleSubmit}>
                        <div className="flex flex-col space-y-2">
                            <label htmlFor="nucleo-select" className="label">
                                <span className="label-text">Núcleo:</span>
                            </label>
                            <select 
                                id="nucleo-select"
                                className="text-lg bg-neutral-700 h-12 sm:h-10 w-full text-center rounded"
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
                                className="text-lg bg-neutral-700 h-12 sm:h-10 w-full text-center rounded"
                                aria-label="Enter points to add or remove"
                            />
                            {/* Quick adjust buttons */}
                            <div className="mt-2 grid grid-cols-4 gap-2">
                                <button type="button" className="btn btn-md sm:btn-sm" onClick={() => quickAdjust(-5)}>-5</button>
                                <button type="button" className="btn btn-md sm:btn-sm" onClick={() => quickAdjust(-1)}>-1</button>
                                <button type="button" className="btn btn-md sm:btn-sm" onClick={() => quickAdjust(1)}>+1</button>
                                <button type="button" className="btn btn-md sm:btn-sm" onClick={() => quickAdjust(5)}>+5</button>
                            </div>
                            {number !== '' && !/^-?\d+$/.test(number) && (
                                <p className="text-red-500">Please enter a valid whole number.</p>
                            )}
            
                            <button 
                                type="submit" 
                                disabled={number === '' || number === '0' || !/^-?\d+$/.test(number) || isLoading}
                                className="btn btn-primary btn-md sm:btn-sm"
                            >
                                {isLoading ? 'Updating...' : 'Submit'}
                            </button>
                        </div>
                    </form>
                    {/* History */}
                    <div className="mt-4 flex items-center justify-between">
                        <div className="divider m-0 flex-1">History</div>
                        <button className="btn btn-md sm:btn-sm ml-3" onClick={() => setShowHistory(!showHistory)}>
                            {showHistory ? 'Hide' : 'Show'}
                        </button>
                    </div>
                    {showHistory && (
                    <div className="mt-2 rounded bg-base-100 p-2">
                        {/* Filter bar */}
                        <div className="mb-2 grid grid-cols-2 gap-2">
                            <select className="select select-sm w-full" value={filterNucleo} onChange={(e)=>setFilterNucleo(e.target.value)}>
                              <option value="">All núcleos</option>
                              <option value="NEEETA">NEEETA</option>
                              <option value="NEECT">NEECT</option>
                              <option value="NEI">NEI</option>
                            </select>
                            <select className="select select-sm w-full" value={filterRolledBack} onChange={(e)=>setFilterRolledBack(e.target.value)}>
                              <option value="">All statuses</option>
                              <option value="false">Active</option>
                              <option value="true">Rolled back</option>
                            </select>
                        </div>

                        <div className="max-h-64 overflow-auto rounded">
                        {logLoading ? (
                            <div className="text-sm opacity-70 p-2">Loading…</div>
                        ) : log.length === 0 ? (
                            <div className="text-sm opacity-70 p-2">No changes.</div>
                        ) : (
                            <>
                            <ul className="space-y-1 text-sm">
                                {log.map((e) => (
                                    <li key={e.id} className="flex items-center justify-between rounded px-2 py-1 hover:bg-base-200">
                                        <span>
                                            <strong>{e.nucleo}</strong>
                                            {" "}
                                            <span className={e.delta >= 0 ? 'text-success' : 'text-error'}>
                                                {e.delta >= 0 ? `+${e.delta}` : e.delta}
                                            </span>
                                            {" "}
                                            <span className="opacity-70">({e.prev_value} → {e.new_value})</span>
                                            {e.user_email && <span className="ml-2 opacity-70">{e.user_email}</span>}
                                            {!e.user_email && e.user_id != null && <span className="ml-2 opacity-60">user #{e.user_id}</span>}
                                            {e.timestamp && <span className="ml-2 opacity-60">{new Date(e.timestamp).toLocaleString()}</span>}
                                            {e.rolled_back && <span className="ml-2 badge badge-outline">rolled back</span>}
                                        </span>
                                        <button
                                            className="btn btn-sm sm:btn-xs"
                                            disabled={!!e.rolled_back}
                                            onClick={() => handleRollback(e.id)}
                                        >
                                            Undo
                                        </button>
                                    </li>
                                ))}
                            </ul>
                            {nextOffset != null && log.length >= LOG_PAGE_SIZE && (
                              <div className="mt-2 flex justify-center">
                                <button className="btn btn-xs" disabled={logLoading} onClick={()=>{
                                  const filters = {};
                                  if (filterNucleo) filters.nucleo = filterNucleo;
                                  if (filterRolledBack === 'true') filters.rolled_back = true;
                                  if (filterRolledBack === 'false') filters.rolled_back = false;
                                  service.getArraialLog(LOG_PAGE_SIZE, nextOffset||0, filters)
                                    .then(({items, next_offset})=>{ setLog((prev)=>[...prev, ...(items||[])]); setNextOffset(next_offset??null); });
                                }}>Load more</button>
                              </div>
                            )}
                            </>
                        )}
                        </div>
                    </div>
                    )}
                </div>
            ) : null}
        </div>
        
    )
}
