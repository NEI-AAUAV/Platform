/**
 * PatraoPicker - Reusable component for selecting a patrão (parent/mentor)
 * 
 * Features:
 * - Search by name, ID, or nmec
 * - Pagination/infinite scroll
 * - Option to select "no patrão" (root member)
 * - Auto-scrolls to selected patrão
 * - Filters out excluded users (e.g., self when editing)
 */

import React, { useState, useEffect, useCallback, useRef } from "react";
import PropTypes from "prop-types";
import classNames from "classnames";
import MaterialSymbol from "components/MaterialSymbol";
import Avatar from "components/Avatar";
import FamilyService from "services/FamilyService";

const PatraoPicker = ({
    selectedPatrao,
    onSelect,
    excludeIds = [],
    title = "Selecionar Patrão",
    placeholder = "Nome, ID ou nmec...",
    showNoPatraoOption = true,
    className = ""
}) => {
    const [search, setSearch] = useState("");
    const [debouncedSearch, setDebouncedSearch] = useState("");
    const [patraoList, setPatraoList] = useState([]);
    const [loading, setLoading] = useState(false);
    const [page, setPage] = useState(0);
    const [hasMore, setHasMore] = useState(true);
    const listRef = useRef(null);

    // Debounce search
    useEffect(() => {
        const timer = setTimeout(() => {
            setDebouncedSearch(search);
            setPage(0); // Reset page on search change
        }, 300);
        return () => clearTimeout(timer);
    }, [search]);

    // Load patrão list
    const loadPatraoList = useCallback(async (resetList = false) => {
        setLoading(true);
        try {
            const limit = 50;
            const params = { limit, skip: page * limit };
            if (debouncedSearch) {
                params.search = debouncedSearch;
            }
            const response = await FamilyService.getUsers(params);

            // Filter out excluded users
            const excludeSet = new Set(excludeIds);
            let newItems = (response.items || []).filter(
                (u) => !excludeSet.has(u.id)
            );

            if (resetList || page === 0) {
                setPatraoList(newItems);
            } else {
                setPatraoList(prev => {
                    // Avoid duplicates
                    const existingIds = new Set(prev.map(p => p.id));
                    const uniqueNew = newItems.filter(p => !existingIds.has(p.id));
                    return [...prev, ...uniqueNew];
                });
            }

            setHasMore(newItems.length === limit);
        } catch (err) {
            console.error("Failed to load patrões:", err);
        } finally {
            setLoading(false);
        }
    }, [debouncedSearch, excludeIds, page]);

    useEffect(() => {
        loadPatraoList();
    }, [loadPatraoList]);

    // Ensure selected patrão is in the list
    useEffect(() => {
        if (selectedPatrao && patraoList.length > 0) {
            const exists = patraoList.find(p => p.id === selectedPatrao.id);
            if (!exists) {
                setPatraoList(prev => [selectedPatrao, ...prev]);
            }
        }
    }, [selectedPatrao, patraoList]);

    // Scroll to selected patrão
    useEffect(() => {
        if (selectedPatrao && listRef.current) {
            setTimeout(() => {
                const selectedEl = listRef.current?.querySelector(
                    `[data-id="${selectedPatrao.id}"]`
                );
                if (selectedEl) {
                    selectedEl.scrollIntoView({ block: "center", behavior: "smooth" });
                }
            }, 100);
        }
    }, [selectedPatrao?.id]);

    return (
        <div className={`flex h-full flex-col ${className}`}>
            {/* Header with search */}
            <div className="border-b border-base-content/10 p-4">
                <h3 className="mb-3 text-lg font-semibold">{title}</h3>
                <div className="relative">
                    <MaterialSymbol
                        icon="search"
                        size={18}
                        className="absolute left-3 top-1/2 -translate-y-1/2 text-base-content/50"
                    />
                    <input
                        type="text"
                        placeholder={placeholder}
                        className="input input-bordered input-sm w-full pl-9"
                        value={search}
                        onChange={(e) => setSearch(e.target.value)}
                    />
                </div>
            </div>

            {/* List */}
            <div
                className="flex-1 overflow-y-auto overscroll-contain"
                ref={listRef}
                style={{ WebkitOverflowScrolling: 'touch', touchAction: 'pan-y' }}
            >
                {/* No Patrão Option */}
                {showNoPatraoOption && (
                    <button
                        type="button"
                        className={classNames(
                            "flex w-full items-center gap-3 px-4 py-3 text-left transition-colors hover:bg-base-300",
                            {
                                "bg-primary/10 text-primary": selectedPatrao === null,
                            }
                        )}
                        onClick={() => onSelect(null)}
                    >
                        <div className="flex h-10 w-10 items-center justify-center rounded-full bg-base-300">
                            <MaterialSymbol icon="block" size={20} />
                        </div>
                        <div>
                            <div className="font-medium">Sem Patrão</div>
                            <div className="text-sm text-base-content/60">
                                Membro raiz
                            </div>
                        </div>
                        {selectedPatrao === null && (
                            <MaterialSymbol
                                icon="check_circle"
                                size={20}
                                className="ml-auto text-primary"
                            />
                        )}
                    </button>
                )}

                {/* Loading */}
                {page === 0 && loading ? (
                    <div className="flex justify-center py-8">
                        <span className="loading loading-spinner loading-sm"></span>
                    </div>
                ) : (
                    <>
                        {/* Patrão List */}
                        {patraoList.map((p) => (
                            <button
                                key={p.id}
                                data-id={p.id}
                                type="button"
                                className={classNames(
                                    "flex w-full items-center gap-3 px-4 py-3 text-left transition-colors hover:bg-base-300",
                                    { "bg-primary/10": selectedPatrao?.id === p.id }
                                )}
                                onClick={() => onSelect(p)}
                            >
                                <div className="avatar">
                                    <div className="h-10 w-10 rounded-full bg-base-300">
                                        <Avatar
                                            image={p.photoUrl || p.image}
                                            sex={p.sex}
                                            alt={p.name || "avatar"}
                                            className="h-10 w-10 rounded-full object-cover"
                                        />
                                    </div>
                                </div>
                                <div className="min-w-0 flex-1">
                                    <div className="truncate font-medium">{p.name}</div>
                                    <div className="text-sm text-base-content/60">
                                        {p.start_year ? 2000 + p.start_year : "-"}
                                        {p.nmec && ` • ${p.nmec}`}
                                    </div>
                                </div>
                                {selectedPatrao?.id === p.id && (
                                    <MaterialSymbol
                                        icon="check_circle"
                                        size={20}
                                        className="text-primary"
                                    />
                                )}
                            </button>
                        ))}

                        {/* Load More */}
                        {hasMore && (
                            <div className="p-2">
                                <button
                                    className={classNames("btn btn-ghost btn-sm w-full", { loading })}
                                    onClick={() => setPage(p => p + 1)}
                                >
                                    Carregar mais...
                                </button>
                            </div>
                        )}
                    </>
                )}
            </div>
        </div>
    );
};

PatraoPicker.propTypes = {
    selectedPatrao: PropTypes.shape({
        id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
        name: PropTypes.string,
        image: PropTypes.string,
        photoUrl: PropTypes.string,
        sex: PropTypes.oneOf(["M", "F"]),
        start_year: PropTypes.number,
        nmec: PropTypes.number,
    }),
    onSelect: PropTypes.func.isRequired,
    excludeIds: PropTypes.arrayOf(PropTypes.oneOfType([PropTypes.string, PropTypes.number])),
    title: PropTypes.string,
    placeholder: PropTypes.string,
    showNoPatraoOption: PropTypes.bool,
    className: PropTypes.string,
};

export default PatraoPicker;

