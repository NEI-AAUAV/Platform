import React, { useEffect, useState } from "react";
import Particles from "react-particles";
import { loadFull } from "tsparticles";
import service from 'services/NEIService';
import { getArraialSocket } from "services/SocketService";
import { useUserStore } from "stores/useUserStore";
import config from "config";
import neiLogo from "assets/images/NEI.png";
import neectLogo from "assets/images/NEECT.png";
import neeetaLogo from "assets/images/NEEETA.png"; // used for NEEETA núcleo
import './beer-animations.css';

// Configuration constants
const POLLING_INTERVAL = Math.max(60000, (config.ARRAIAL && config.ARRAIAL.POLLING_INTERVAL) || 10000); // use longer fallback when WS is on
const LOG_PAGE_SIZE = 100;
const MILESTONE_INTERVAL = 50; // points per milestone for confetti/toast

export function Component() {
    const [ws, setWs] = useState(null);
    const [wsConnected, setWsConnected] = useState(false);
    const [enabled, setEnabled] = useState(null); // null = loading, true/false = loaded
    const [paused, setPaused] = useState(false);
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
    const [showTrends, setShowTrends] = useState(false);
    const [pointHistory, setPointHistory] = useState([]);
    const [hoveredPoint, setHoveredPoint] = useState(null);
    const [confettiActive, setConfettiActive] = useState(false);
    const [milestoneToasts, setMilestoneToasts] = useState([]); // [{ id, nucleo, milestone }]
    const prevPointsRef = React.useRef({});
    const [boosts, setBoosts] = useState({}); // { nucleo: iso8601|null }
    const hasBaselineRef = React.useRef(false);
    const initParticles = React.useCallback(async (engine) => {
        await loadFull(engine);
    }, []);

    // Listen for global confetti trigger events
    useEffect(() => {
        const onConfetti = (e) => {
            setConfettiActive(true);
            // If details provided, show toast with nucleo and milestone
            if (e?.detail && e.detail.nucleo && e.detail.milestone) {
                const id = `${Date.now()}-${Math.random().toString(36).slice(2)}`;
                const toast = { id, nucleo: e.detail.nucleo, milestone: e.detail.milestone };
                setMilestoneToasts((prev) => [...prev, toast]);
                // auto close this toast instance
                setTimeout(() => {
                    setMilestoneToasts((prev) => prev.filter((t) => t.id !== id));
                }, 6000);
            }
            // auto stop confetti after short duration
            setTimeout(() => setConfettiActive(false), 1700);
        };
        window.addEventListener('arraial:confetti', onConfetti);
        return () => window.removeEventListener('arraial:confetti', onConfetti);
    }, []);

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
                setPaused(!!cfg?.paused);
                if (cfg?.boosts) {
                    setBoosts(cfg.boosts);
                }
            } catch (e) {
                setEnabled(true); // default true if endpoint fails
            }
        };

        const fetchPoints = () => {
            service.getArraialPoints()
                .then(data => {
                    if (hasBaselineRef.current) {
                        maybeTriggerConfetti(prevPointsRef.current, data);
                    } else {
                        hasBaselineRef.current = true;
                    }
                    setPointsList(data);
                    prevPointsRef.current = Object.fromEntries((data||[]).map(p=>[p.nucleo, p.value]));
                    addPointHistoryEntry(data);
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
                    if (hasBaselineRef.current) {
                        maybeTriggerConfetti(prevPointsRef.current, data.points);
                    } else {
                        hasBaselineRef.current = true;
                    }
                    setPointsList(data.points);
                    prevPointsRef.current = Object.fromEntries((data.points||[]).map(p=>[p.nucleo, p.value]));
                    if (auth) fetchLog(0, false);
                } else if (data?.topic === 'ARRAIAL_CONFIG' && typeof data.enabled === 'boolean') {
                    setEnabled(!!data.enabled);
                    setPaused(!!data.paused);
                } else if (data?.topic === 'ARRAIAL_BOOST' && data.boosts && typeof data.boosts === 'object') {
                    setBoosts(data.boosts || {});
                    if (auth) fetchLog(0, false);
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
    }, [auth, POLLING_INTERVAL]);

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
        if (paused) {
            setError('Point updates are currently paused by an administrator.');
            return;
        }
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
                } else if (error?.response?.status === 400) {
                    setError(error.response.data?.detail || 'Invalid request. Please check your input.');
                } else if (error?.response?.status === 423) {
                    setError('Point updates are currently paused by an administrator.');
                } else if (error?.response?.status === 429) {
                    setError('Too many requests. Please wait a moment before trying again.');
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

        // Check if the value is empty or a valid whole number within limits
        if (value === '' || /^-?\d+$/.test(value)) {
            const num = parseInt(value, 10);
            if (value === '' || (num >= -1000 && num <= 1000)) {
                setNumber(value);
            }
        }
    };

    const quickAdjust = (delta) => {
        setError(null);
        // If empty, start from 0; else parse current number
        const base = number === '' ? 0 : parseInt(number, 10) || 0;
        const next = base + delta;
        setNumber(String(next));
    };

    const addPointHistoryEntry = (pointsData) => {
        const timestamp = new Date();
        const entry = {
            timestamp,
            points: pointsData.map(p => ({ nucleo: p.nucleo, value: p.value }))
        };
        setPointHistory(prev => [...prev.slice(-20), entry]); // Keep last 20 entries
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
    const EXTRA_HEADROOM_FRAC = 0.01;  // 1% headroom when multiple teams have points
    const MIN_HEADROOM_FRAC = 0.005;   // minimal gap even for single leader

    const calcHeight = (points) => {
        const maxPoints = Math.max(...pointsList.map(p => p.value), 1);
        const activeCount = pointsList.filter(p => p.value > 0).length;
        const headroom = activeCount > 1 ? EXTRA_HEADROOM_FRAC : MIN_HEADROOM_FRAC;
        const ratio = Math.max(0, Math.min(points / maxPoints, 1));
        const heightPct = Math.max(0, (1 - headroom) * ratio) * 100;
        // Return percentage; foam gap is already handled by offsetting beer body by 16px
        return `${heightPct}%`;
    };

    const renderTrendsGraph = () => {
        if (pointHistory.length < 2) return null;

        const width = 400;
        const height = 200; // Back to original height
        const padding = 40;
        const chartWidth = width - padding * 2;
        const chartHeight = height - padding * 2;

        const maxPoints = Math.max(...pointHistory.flatMap(entry => entry.points.map(p => p.value)), 1);
        const colors = { 'NEEETA': '#3B82F6', 'NEECT': '#10B981', 'NEI': '#F59E0B' };

        const getX = (index) => padding + (index / (pointHistory.length - 1)) * chartWidth;
        const getY = (value) => padding + chartHeight - (value / maxPoints) * chartHeight;
        
        const formatTime = (timestamp) => {
            const date = new Date(timestamp);
            const now = new Date();
            const diffMinutes = Math.floor((now - date) / (1000 * 60));
            
            if (diffMinutes < 1) return 'Now';
            if (diffMinutes < 60) return `${diffMinutes}m ago`;
            
            const hours = Math.floor(diffMinutes / 60);
            const minutes = diffMinutes % 60;
            return `${hours}h ${minutes}m ago`;
        };

        return (
            <div className="mt-4 p-2 sm:p-4 bg-base-100 rounded-lg">
                <h4 className="text-lg font-bold mb-3">Point Trends</h4>
                <div className="overflow-x-auto">
                    <svg width={width} height={height} className="w-full max-w-md mx-auto min-w-[400px]">
                    {/* Grid lines and y-axis labels */}
                    {[0, 0.25, 0.5, 0.75, 1].map(ratio => {
                        const value = Math.round(ratio * maxPoints);
                        const y = padding + (1 - ratio) * chartHeight; // Inverted: 0 at bottom, max at top
                        return (
                            <g key={ratio}>
                                <line
                                    x1={padding}
                                    y1={y}
                                    x2={padding + chartWidth}
                                    y2={y}
                                    stroke="currentColor"
                                    strokeOpacity="0.1"
                                />
                                {/* Y-axis labels */}
                                <text
                                    x={padding - 10}
                                    y={y + 4}
                                    fontSize="10"
                                    fill="currentColor"
                                    textAnchor="end"
                                    opacity="0.6"
                                >
                                    {value}
                                </text>
                            </g>
                        );
                    })}
                    
                    {/* Lines for each núcleo */}
                    {['NEEETA', 'NEECT', 'NEI'].map(nucleo => {
                        const points = pointHistory.map(entry => {
                            const nucleoData = entry.points.find(p => p.nucleo === nucleo);
                            return nucleoData ? nucleoData.value : 0;
                        });
                        
                        const pathData = points.map((value, index) => {
                            const x = getX(index);
                            const y = getY(value);
                            return `${index === 0 ? 'M' : 'L'} ${x} ${y}`;
                        }).join(' ');

                        return (
                            <g key={nucleo}>
                                <path
                                    d={pathData}
                                    fill="none"
                                    stroke={colors[nucleo]}
                                    strokeWidth="3"
                                    strokeLinecap="round"
                                    strokeLinejoin="round"
                                />
                                {/* Data points */}
                                {points.map((value, index) => {
                                    const entry = pointHistory[index];
                                    const time = formatTime(entry.timestamp);
                                    const isHovered = hoveredPoint?.nucleo === nucleo && hoveredPoint?.index === index;
                                    
                                    return (
                                        <g key={index}>
                                            <circle
                                                cx={getX(index)}
                                                cy={getY(value)}
                                                r={isHovered ? "6" : "4"}
                                                fill={colors[nucleo]}
                                                stroke={isHovered ? "white" : "none"}
                                                strokeWidth="2"
                                                style={{ cursor: 'pointer' }}
                                                onMouseEnter={() => setHoveredPoint({ nucleo, index, value, time })}
                                                onMouseLeave={() => setHoveredPoint(null)}
                                            />
                                            {/* Tooltip */}
                                            {isHovered && (
                                                <g>
                                                    <rect
                                                        x={getX(index) - 30}
                                                        y={getY(value) - 35}
                                                        width="60"
                                                        height="25"
                                                        fill="rgba(0,0,0,0.8)"
                                                        rx="4"
                                                    />
                                                    <text
                                                        x={getX(index)}
                                                        y={getY(value) - 20}
                                                        fontSize="10"
                                                        fill="white"
                                                        textAnchor="middle"
                                                    >
                                                        {time}
                                                    </text>
                                                </g>
                                            )}
                                        </g>
                                    );
                                })}
                            </g>
                        );
                    })}
                    
                    
                    {/* Legend */}
                    <g transform={`translate(${padding}, ${height - 20})`}>
                        {['NEEETA', 'NEECT', 'NEI'].map((nucleo, index) => (
                            <g key={nucleo} transform={`translate(${index * 80}, 0)`}>
                                <rect width="12" height="12" fill={colors[nucleo]} />
                                <text x="16" y="9" fontSize="12" fill="currentColor">{nucleo}</text>
                            </g>
                        ))}
                    </g>
                </svg>
                </div>
            </div>
        );
    };

    // Show loading state while checking if Arraial is enabled
    if (enabled === null) {
        return (
            <div className="mx-auto max-w-xl p-6 text-center">
                <h1>Arraial do DETI</h1>
                <div className="mt-3 flex items-center justify-center gap-2">
                    <span className="loading loading-spinner loading-sm"></span>
                    <span className="opacity-80">A carregar...</span>
                </div>
            </div>
        );
    }

    // Show disabled message if Arraial is disabled
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
            <div className={`relative block mx-auto w-40 sm:w-56 md:w-64 lg:w-[40vh] h-[40vh] sm:h-[48vh] md:h-[55vh] border-8 border-white border-t-0 rounded-b-[3rem]`}>
                {/* Inner content wrapper to clip beer/foam, outer stays visible for handle */}
                <div className="absolute inset-0 overflow-hidden rounded-b-[2.5rem]">
                    {/* Glass effects */}
                    <div className="glass-inner" aria-hidden="true"></div>
                    <div className="glass-rim" aria-hidden="true"></div>
                    {/* Per-núcleo logo centered in the glass (not the beer) */}
                    <div className="absolute top-[34px] left-0 right-0 bottom-[32px] flex items-center justify-center pointer-events-none z-[5]" aria-hidden="true">
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
                            <div 
                                className="absolute top-[40px] left-0 right-0 bottom-0"
                                style={{ 
                                    background: 'linear-gradient(180deg, #f9d648 0%, #f4c534 65%, #e8b82e 100%)',
                                    boxShadow: 'inset 0 2px 0 rgba(255,255,255,0.25)',
                                }} 
                                aria-hidden="true"
                            ></div>

                            {/* Rising bubbles within beer body */}
                            <div className="bubbles top-[18px]" aria-hidden="true"></div>
                            {/* Foam: white cap with texture and subtle crest */}
                            <div 
                                className="absolute top-0 left-0 right-0 h-[40px] overflow-hidden"
                                style={{ 
                                    background: 'rgba(255,255,255,0.98)', 
                                    borderTopLeftRadius: 28, 
                                    borderTopRightRadius: 28 
                                }} 
                                aria-hidden="true"
                            >
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
                        <div className="flex items-center justify-center gap-2">
                        <h2>{pointsData.nucleo}</h2>
                        </div>
                        <h3>Points: {pointsData.value}</h3>
                        {boosts?.[pointsData.nucleo] && (
                            <BoostCountdown
                                untilIso={boosts[pointsData.nucleo]}
                                nucleo={pointsData.nucleo}
                                onExpire={(n)=>{
                                    setBoosts((prev)=> ({ ...prev, [n]: null }));
                                }}
                            />
                        )}
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
        <div className="flex flex-col justify-center space-y-8 md:space-y-12 px-4 sm:px-0">
            <div className="text-center">
                <h1 className="text-2xl sm:text-3xl">Arraial do DETI</h1>
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
            
            <div className="flex flex-col md:flex-row items-center md:items-start justify-center space-y-6 md:space-y-0 md:space-x-16">
                {pointsList.map((pointsData, index) => renderPointsBar(pointsData, index))}
            </div>
            {auth ? (
                <div className="rounded-box m-auto w-full max-w-lg sm:max-w-md flex h-fit flex-col bg-base-200 px-4 sm:px-6 py-6 align-middle shadow-secondary drop-shadow-md">
                    <h3>Add/Remove Points</h3>
                    <div className="mb-2 flex items-center gap-2">
                        <span className="text-sm opacity-70">Boost 1.25x (15m):</span>
                        {['NEEETA','NEECT','NEI'].map((n)=> (
                            <button key={n} className="btn btn-xs" disabled={paused} onClick={async ()=>{
                                try {
                                    const resp = await service.activateArraialBoost(n);
                                    if (resp && resp.boosts) {
                                        setBoosts(resp.boosts);
                                    }
                                } catch(e) { /* ignore */ }
                            }}>{n}</button>
                        ))}
                    </div>
                    {paused && (
                        <div className="alert alert-warning my-2">
                            <span>Point updates are paused by an administrator.</span>
                        </div>
                    )}
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
                                disabled={paused}
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
                                disabled={paused}
                                aria-label="Enter points to add or remove"
                            />
                            {/* Quick adjust buttons - Mobile optimized */}
                            <div className="mt-2 grid grid-cols-4 gap-2">
                                <button type="button" className="btn btn-lg sm:btn-md touch-manipulation" onClick={() => quickAdjust(-5)} disabled={paused}>-5</button>
                                <button type="button" className="btn btn-lg sm:btn-md touch-manipulation" onClick={() => quickAdjust(-1)} disabled={paused}>-1</button>
                                <button type="button" className="btn btn-lg sm:btn-md touch-manipulation" onClick={() => quickAdjust(1)} disabled={paused}>+1</button>
                                <button type="button" className="btn btn-lg sm:btn-md touch-manipulation" onClick={() => quickAdjust(5)} disabled={paused}>+5</button>
                            </div>
                            {number !== '' && !/^-?\d+$/.test(number) && (
                                <p className="text-red-500">Please enter a valid whole number.</p>
                            )}
            
                            <button 
                                type="submit" 
                                disabled={paused || number === '' || number === '0' || !/^-?\d+$/.test(number) || isLoading}
                                className="btn btn-primary btn-lg sm:btn-md w-full touch-manipulation"
                            >
                                {isLoading ? 'Updating...' : 'Submit'}
                            </button>
                        </div>
                    </form>
                    {/* History & Trends */}
                    <div className="mt-4 flex flex-col items-center gap-4">
                        <div className="divider w-full">History & Trends</div>
                        <div className="flex flex-row gap-2 w-full max-w-xs">
                            <button className="btn btn-md sm:btn-sm flex-1 touch-manipulation" onClick={() => setShowTrends(!showTrends)}>
                                {showTrends ? 'Hide Trends' : 'Trends'}
                            </button>
                            <button className="btn btn-md sm:btn-sm flex-1 touch-manipulation" onClick={() => setShowHistory(!showHistory)}>
                                {showHistory ? 'Hide History' : 'History'}
                            </button>
                        </div>
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
                                        {e.event === 'BOOST_ACTIVATED' ? (
                                            <>
                                                <span>
                                                    <strong>{e.nucleo}</strong>{" "}
                                                    <span className="badge badge-warning badge-sm align-middle">1.25x Boost</span>
                                                    {e.timestamp && <span className="ml-2 opacity-60">{new Date(e.timestamp).toLocaleString()}</span>}
                                                    {e.user_email && <span className="ml-2 opacity-70">{e.user_email}</span>}
                                                </span>
                                                <button
                                                    className="btn btn-sm sm:btn-xs"
                                                    disabled={!!e.rolled_back}
                                                    onClick={() => handleRollback(e.id)}
                                                >
                                                    Undo
                                                </button>
                                            </>
                                        ) : (
                                            <>
                                                <span>
                                                    <strong>{e.nucleo}</strong>{" "}
                                                    <span className={e.delta >= 0 ? 'text-success' : 'text-error'}>
                                                        {e.delta >= 0 ? `+${e.delta}` : e.delta}
                                                    </span>{" "}
                                                    <span className="opacity-70">({e.prev_value} → {e.new_value})</span>
                                                    {e.user_email && <span className="ml-2 opacity-70">{e.user_email}</span>}
                                                    {!e.user_email && e.user_id !== null && <span className="ml-2 opacity-60">user #{e.user_id}</span>}
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
                                            </>
                                        )}
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
                    {showTrends && renderTrendsGraph()}
                </div>
            ) : null}
            {confettiActive && (
                <Particles
                    id="arraial-confetti"
                    init={initParticles}
                    options={{
                        fullScreen: { enable: true, zIndex: 999 },
                        detectRetina: true,
                        fpsLimit: 60,
                        particles: {
                            number: { value: 140 },
                            color: { value: ["#ef4444","#f59e0b","#10b981","#3b82f6","#8b5cf6","#ec4899"] },
                            shape: { type: "square" },
                            opacity: { value: 1 },
                            size: { value: { min: 3, max: 6 } },
                            life: { duration: { sync: true, value: 1.6 }, count: 1 },
                            move: {
                                enable: true,
                                gravity: { enable: true, acceleration: 15 },
                                speed: { min: 7, max: 16 },
                                decay: 0.06,
                                direction: "none",
                                outModes: { default: "destroy", bottom: "destroy" }
                            },
                            rotate: {
                                value: { min: 0, max: 360 },
                                direction: "random",
                                animation: { enable: true, speed: 30 }
                            }
                        }
                    }}
                />
            )}
            {milestoneToasts.length > 0 && (
                <div className="fixed inset-x-0 top-1/4 z-[1000] flex justify-center pointer-events-none">
                    <div className="flex flex-col gap-4">
                        {milestoneToasts.map((t) => (
                            <div key={t.id} className="pointer-events-auto animate-fade-in-down shadow-2xl rounded-2xl px-8 py-6 bg-base-100 border border-base-300 ring-2 ring-primary/50 backdrop-blur-sm flex items-center gap-4 text-xl md:text-3xl">
                                <span className="badge badge-primary text-xl md:text-3xl px-6 py-2 md:px-8 md:py-4">Shot Capacete</span>
                                <span className="font-extrabold tracking-wide">{t.nucleo}</span>
                                <span className="opacity-80">— nº {t.milestone}</span>
                            </div>
                        ))}
                    </div>
                </div>
            )}
        </div>
        
    )
}

function BoostCountdown({ untilIso, asBadge = false, nucleo, onExpire }) {
    const [remaining, setRemaining] = useState('');
    useEffect(() => {
        const parseRemaining = () => {
            try {
                const end = new Date(untilIso).getTime();
                const now = Date.now();
                const diff = Math.floor((end - now) / 1000);
                if (diff <= 0) {
                    setRemaining('');
                    if (onExpire && typeof onExpire === 'function') {
                        onExpire(nucleo);
                    }
                    return;
                }
                const m = Math.floor(diff / 60);
                const s = diff % 60;
                setRemaining(`${m}:${String(s).padStart(2, '0')}`);
            } catch (_) {
                setRemaining('');
            }
        };
        parseRemaining();
        const id = setInterval(parseRemaining, 1000);
        return () => clearInterval(id);
    }, [untilIso, nucleo, onExpire]);

    if (!untilIso || !remaining) return null;
    if (asBadge) {
        return (
            <span className="badge badge-primary badge-sm">1.25x {remaining}</span>
        );
    }
    return (
        <div className="mt-2 flex justify-center">
            <span className="badge badge-primary badge-lg gap-2 px-4">
                1.25x
                <span className="opacity-90">{remaining}</span>
            </span>
        </div>
    );
}

function maybeTriggerConfetti(prevMap, nextList) {
    try {
        const nextMap = Object.fromEntries((nextList||[]).map(p=>[p.nucleo, p.value]));
        const nucs = Object.keys(nextMap);
        for (const n of nucs) {
            const prev = Number.isFinite(prevMap?.[n]) ? prevMap[n] : 0;
            const next = nextMap[n] ?? 0;
            if (next > prev) {
                const prevBucket = Math.floor(prev / MILESTONE_INTERVAL);
                const nextBucket = Math.floor(next / MILESTONE_INTERVAL);
                if (nextBucket > prevBucket) {
                    const milestone = nextBucket * MILESTONE_INTERVAL;
                    const evt = new CustomEvent('arraial:confetti', { detail: { nucleo: n, milestone } });
                    window.dispatchEvent(evt);
                    break;
                }
            }
        }
    } catch (err) {
        // Confetti is non-critical UI enhancement, so we silently ignore errors
        console.debug("Confetti trigger error (non-critical):", err);
    }
}
