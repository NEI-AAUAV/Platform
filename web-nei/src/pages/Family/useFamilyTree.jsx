/**
 * useFamilyTree - Hook for loading family tree data from API
 * 
 * Handles loading, error states, and data transformation.
 * Replaces the static db.json import.
 */

import { useState, useEffect, useCallback } from "react";
import FamilyService from "services/FamilyService";
import { flattenTree } from "./utils";

/**
 * @typedef {Object} FamilyTreeState
 * @property {Array} users - Array of user data for tree
 * @property {boolean} loading - Whether data is loading
 * @property {Error|null} error - Error object if fetch failed
 * @property {Function} refetch - Function to reload data
 */

/**
 * Hook to fetch family tree data from API
 * @param {Object} options - Hook options
 * @param {number} [options.depth] - Tree depth limit
 * @returns {FamilyTreeState} Tree data state
 */
export function useFamilyTree(options = {}) {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [minYear, setMinYear] = useState(null);
    const [maxYear, setMaxYear] = useState(null);

    const fetchData = useCallback(async () => {
        setLoading(true);
        setError(null);

        try {
            // FamilyService returns data directly (client.jsx extracts response.data)
            // API returns { roots: [...], total_users: N, min_year: N, max_year: N }
            const data = await FamilyService.getTree(options);
            const flatUsers = flattenTree(data.roots || data);
            setUsers(flatUsers);
            // Use nullish coalescing to ensure null instead of undefined for consistency
            setMinYear(data.min_year ?? null);
            setMaxYear(data.max_year ?? null);
        } catch (err) {
            console.error("Failed to load family tree:", err);
            setError(err);
        } finally {
            setLoading(false);
        }
    }, [options.depth]);

    useEffect(() => {
        fetchData();
    }, [fetchData]);

    return { users, loading, error, refetch: fetchData, minYear, maxYear };
}

export default useFamilyTree;
