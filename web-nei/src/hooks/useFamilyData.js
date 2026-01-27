
import { useState, useEffect } from "react";
import FamilyService from "services/FamilyService";

/**
 * Hook to fetch and manage courses data
 * @returns {Object} { courses, loading, error }
 */
export function useCourses() {
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);

    useEffect(() => {
        let mounted = true;
        setLoading(true);
        FamilyService.getCourses({ limit: 100 })
            .then(res => {
                if (mounted) setCourses(res.items || []);
            })
            .catch(err => {
                console.error("Failed to load courses:", err);
                if (mounted) setError(err);
            })
            .finally(() => {
                if (mounted) setLoading(false);
            });

        return () => { mounted = false; };
    }, []);

    return { courses, loading, error };
}

/**
 * Hook to fetch children (pedaços) for a specific user
 * @param {number} userId 
 */
export function useUserChildren(userId) {
    const [children, setChildren] = useState([]);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        if (!userId) {
            setChildren([]);
            return;
        }

        let mounted = true;
        setLoading(true);
        FamilyService.getUserChildren(userId)
            .then(res => {
                if (mounted) setChildren(res || []);
            })
            .catch(err => {
                console.error(err);
                if (mounted) setChildren([]);
            })
            .finally(() => {
                if (mounted) setLoading(false);
            });

        return () => { mounted = false; };
    }, [userId]);

    return { children, loading };
}
