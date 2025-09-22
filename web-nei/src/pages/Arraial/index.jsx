import React, { useEffect, useState } from "react";
import Particles from "react-particles";
import { loadFull } from "tsparticles";
import service from 'services/NEIService';
import { useUserStore } from "stores/useUserStore";
import { LOG_PAGE_SIZE, MILESTONE_INTERVAL } from "./constants";
import useArraialRealtime from "./hooks/useArraialRealtime";
import useArraialHistory from "./hooks/useArraialHistory";
import ConnectionIndicator from "./components/ConnectionIndicator";
import PointsGlass from "./components/PointsGlass";
import TrendsGraph from "./components/TrendsGraph";
import HistoryList from "./components/HistoryList";
import AdminControls from "./components/AdminControls";
import './beer-animations.css';

const recentConfettiByNucleo = {};
const lastMilestoneByNucleo = {};

export function Component() {
    const [pointsList, setPointsList] = useState([
        {nucleo: 'NEEETA', value: 0}, 
        {nucleo: 'NEECT', value: 0}, 
        {nucleo: 'NEI', value: 0}
    ]);
    const [selectedValue, setSelectedValue] = useState('NEEETA');
    const [number, setNumber] = useState('');
    const [error, setError] = useState(null);
    const [isLoading, setIsLoading] = useState(false);
    const [showHistory, setShowHistory] = useState(false);
    const [showTrends, setShowTrends] = useState(false);
    const [pointHistory, setPointHistory] = useState([]);
    const [confettiActive, setConfettiActive] = useState(false);
    const [milestoneToasts, setMilestoneToasts] = useState([]); // [{ id, nucleo, milestone }]
    const timeoutsRef = React.useRef([]);
    const prevPointsRef = React.useRef({});
    const lastRecordedMapRef = React.useRef({});
    const lastRecordedAtRef = React.useRef(0);
    const hasBaselineRef = React.useRef(false);
    const initParticles = React.useCallback(async (engine) => {
        await loadFull(engine);
    }, []);

    const addPointHistoryEntry = React.useCallback(function(pointsData) {
        try {
            const now = Date.now();
            const MIN_INTERVAL_MS = 60 * 1000; // one minute granularity
            const currentMap = Object.fromEntries((pointsData||[]).map(p=>[p.nucleo, p.value]));
            const lastMap = lastRecordedMapRef.current || {};
            const valuesChanged = ['NEEETA','NEECT','NEI'].some(k => (currentMap[k]||0) !== (lastMap[k]||0));
            const enoughTimePassed = now - (lastRecordedAtRef.current || 0) >= MIN_INTERVAL_MS;
            const hasDecrease = ['NEEETA','NEECT','NEI'].some(k => (currentMap[k]||0) < (lastMap[k]||0));
            const isLikelyStale = hasDecrease && (now - (lastRecordedAtRef.current || 0) < 5000);

            if (isLikelyStale) {
                return;
            }
            if (!valuesChanged && !enoughTimePassed) {
                return;
            }

            lastRecordedMapRef.current = currentMap;
            lastRecordedAtRef.current = now;

            const timestamp = new Date(now);
            const entry = {
                timestamp,
                points: pointsData.map(p => ({ nucleo: p.nucleo, value: p.value }))
            };
            setPointHistory(prev => [...prev.slice(-20), entry]);
        } catch (_) { /* ignore */ }
    }, []);

    useEffect(() => {
        const onConfetti = (e) => {
            setConfettiActive(true);
            if (e?.detail && e.detail.nucleo && e.detail.milestone) {
                const id = `${Date.now()}-${Math.random().toString(36).slice(2)}`;
                const toast = { id, nucleo: e.detail.nucleo, milestone: e.detail.milestone };
                setMilestoneToasts((prev) => [...prev, toast]);
                const tId = setTimeout(() => {
                    setMilestoneToasts((prev) => prev.filter((t) => t.id !== id));
                }, 6000);
                timeoutsRef.current.push(tId);
            }
            const cId = setTimeout(() => setConfettiActive(false), 1700);
            timeoutsRef.current.push(cId);
        };
        window.addEventListener('arraial:confetti', onConfetti);
        return () => window.removeEventListener('arraial:confetti', onConfetti);
    }, []);

    useEffect(() => {
        return () => {
            timeoutsRef.current.forEach((id) => clearTimeout(id));
            timeoutsRef.current = [];
        };
    }, []);

    // filters managed by useArraialHistory
    const { scopes } = useUserStore((state) => state);
    const auth = Array.isArray(scopes) && (scopes.includes('admin') || scopes.includes('manager-arraial'));

    const handlePointsUpdate = React.useCallback((data) => {
        if (hasBaselineRef.current) {
            maybeTriggerConfetti(prevPointsRef.current, data);
        } else {
            hasBaselineRef.current = true;
        }
        setPointsList(data);
        prevPointsRef.current = Object.fromEntries((data||[]).map(p=>[p.nucleo, p.value]));
        addPointHistoryEntry(data);
    }, [addPointHistoryEntry]);

    // Hooks
    const realtime = useArraialRealtime({
        onPointsUpdate: handlePointsUpdate,
    });
    const history = useArraialHistory(auth);

    
    const handleSubmit = () => {
        if (realtime.paused) {
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
            .then(() => {
                // Rely on realtime hook (WS/poll) to update points to avoid flicker
                setNumber('');
                setError(null);
                // Immediately refresh history to reflect the new entry
                history.load(0, false);
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


    const handleRollback = async (id) => {
        setError(null);
        try {
            await service.rollbackArraial(id);
        } catch (err) {
                console.error('Failed to rollback:', err);
                setError('Failed to rollback.');
        } finally {
            history.load(0, false);
        }
    };


    const EXTRA_HEADROOM_FRAC = 0.01;  // 1% headroom when multiple teams have points
    const MIN_HEADROOM_FRAC = 0.005;   // minimal gap even for single leader

    const calcHeight = (points) => {
        const maxPoints = Math.max(...pointsList.map(p => p.value), 1);
        const activeCount = pointsList.filter(p => p.value > 0).length;
        const headroom = activeCount > 1 ? EXTRA_HEADROOM_FRAC : MIN_HEADROOM_FRAC;
        const ratio = Math.max(0, Math.min(points / maxPoints, 1));
        const heightPct = Math.max(0, (1 - headroom) * ratio) * 100;
        return `${heightPct}%`;
    };

    

    // Show loading state while checking if Arraial is enabled
    if (realtime.enabled === null) {
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
    if (!realtime.enabled) {
        return (
            <div className="mx-auto max-w-xl p-6 text-center">
                <h1>Arraial do DETI</h1>
                <p className="mt-3 opacity-80">Esta página está temporariamente desativada.</p>
            </div>
        );
    }

    const renderPointsBar = (pointsData, index) => (
        <PointsGlass
            key={index}
            pointsData={pointsData}
            pointsList={pointsList}
            boosts={realtime.boosts}
            calcHeight={calcHeight}
            BoostCountdown={BoostCountdown}
        />
    );

    return (
        <div className="flex flex-col justify-center space-y-8 md:space-y-12 px-4 sm:px-0">
            <div className="text-center">
                <h1 className="text-2xl sm:text-3xl">Arraial do DETI</h1>
                <ConnectionIndicator wsConnected={realtime.wsConnected} />
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
                <>
                    <AdminControls
                        paused={realtime.paused}
                        boosts={realtime.boosts}
                        selectedValue={selectedValue}
                        number={number}
                        isLoading={isLoading}
                        onBoost={async (n)=>{
                                try {
                                    const resp = await service.activateArraialBoost(n);
                                    if (resp && resp.boosts) {
                                        realtime.setBoosts(resp.boosts);
                                    }
                                } catch(e) { /* ignore */ }
                        }}
                        onChangeNucleo={(val)=> setSelectedValue(val)}
                        onChangePoints={(val)=> handleNumChange({ target: { value: val }})}
                        onQuickAdjust={(delta)=> quickAdjust(delta)}
                        onSubmit={handleSubmit}
                    />
                    {/* History & Trends */}
                    <div className="mt-4 flex flex-col items-center gap-4">
                        <div className="divider w-full">History & Trends</div>
                        <div className="flex flex-row gap-2 w-full max-w-xs">
                            <button 
                                className={`btn btn-md sm:btn-sm flex-1 touch-manipulation ${showTrends ? 'btn-primary' : 'btn-outline'}`}
                                onClick={() => {
                                    setShowTrends(!showTrends);
                                    if (!showTrends) setShowHistory(false); // Hide history when showing trends
                                }}
                            >
                                {showTrends ? 'Hide Trends' : 'Trends'}
                            </button>
                            <button 
                                className={`btn btn-md sm:btn-sm flex-1 touch-manipulation ${showHistory ? 'btn-primary' : 'btn-outline'}`}
                                onClick={() => {
                                    setShowHistory(!showHistory);
                                    if (!showHistory) setShowTrends(false); // Hide trends when showing history
                                }}
                            >
                                {showHistory ? 'Hide History' : 'History'}
                            </button>
                        </div>
                    </div>
                    {showHistory && (
                    <div className="mt-2 rounded bg-base-100 p-2">
                        {/* Filter bar */}
                        <div className="mb-2 grid grid-cols-2 gap-2">
                            <select className="select select-sm w-full" value={history.filterNucleo} onChange={(e)=>history.setFilterNucleo(e.target.value)}>
                              <option value="">All núcleos</option>
                              <option value="NEEETA">NEEETA</option>
                              <option value="NEECT">NEECT</option>
                              <option value="NEI">NEI</option>
                            </select>
                            <select className="select select-sm w-full" value={history.filterRolledBack} onChange={(e)=>history.setFilterRolledBack(e.target.value)}>
                              <option value="">All statuses</option>
                              <option value="false">Active</option>
                              <option value="true">Rolled back</option>
                            </select>
                        </div>

                        <HistoryList
                          log={history.log}
                          logLoading={history.logLoading}
                          nextOffset={history.nextOffset}
                          LOG_PAGE_SIZE={LOG_PAGE_SIZE}
                          onLoadMore={() => history.load(history.nextOffset || 0, true)}
                          onRollback={handleRollback}
                        />
                    </div>
                    )}
                    {showTrends && <TrendsGraph pointHistory={pointHistory} />}
                </>
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
                    const key = `${n}:${milestone}`;
                    const now = Date.now();
                    const last = recentConfettiByNucleo[key] || 0;
                    // Only trigger if this milestone is greater than any previously announced for this núcleo
                    const lastAnnounced = lastMilestoneByNucleo[n] || 0;
                    if (milestone > lastAnnounced && now - last > 3000) {
                        recentConfettiByNucleo[key] = now;
                        lastMilestoneByNucleo[n] = milestone;
                        const evt = new CustomEvent('arraial:confetti', { detail: { nucleo: n, milestone } });
                        window.dispatchEvent(evt);
                    }
                    break;
                }
            }
        }
    } catch (err) {
        console.debug("Confetti trigger error (non-critical):", err);
    }
}
