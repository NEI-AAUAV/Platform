/**
 * useFamilyTree - Hook for loading family tree data from API
 * 
 * Handles loading, error states, and data transformation.
 * Replaces the static db.json import.
 */

import { useState, useEffect, useCallback } from "react";
import FamilyService from "services/FamilyService";

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

    const fetchData = useCallback(async () => {
        setLoading(true);
        setError(null);

        try {
            // FamilyService returns data directly (client.jsx extracts response.data)
            // API returns { roots: [...], total_users: N }
            const data = await FamilyService.getTree(options);
            const flatUsers = flattenTree(data.roots || data);
            setUsers(flatUsers);
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

    return { users, loading, error, refetch: fetchData };
}

/**
 * Flatten nested tree structure into array for D3 stratify
 * @param {Object} tree - Nested tree from API
 * @returns {Array} Flat array of users with parent references
 */
function flattenTree(tree) {
    const users = [];

    function traverse(node, parentId = null) {
        // Create user object matching expected format
        const user = {
            id: node._id,
            parent: parentId,
            name: node.name,
            faina_name: node.faina_name,
            sex: node.sex,
            start_year: node.start_year,
            end_year: node.end_year,
            nmec: node.nmec,
            course_id: node.course_id,
            image: node.image || null,
            // Map user_roles to organizations format expected by D3
            organizations: node.user_roles?.map(role => ({
                name: role.role_id?.split("/").pop() || role.role_id,
                year: role.year,
                role: role.role_name,
            })) || [],
            // Map faina data if available
            faina: node.faina_name ? [{
                name: node.faina_name,
                year: node.start_year + 1,
            }] : null,
        };

        users.push(user);

        // Process children
        if (node.children && node.children.length > 0) {
            for (const child of node.children) {
                traverse(child, node._id);
            }
        }
    }

    // Handle array of roots or single tree
    if (Array.isArray(tree)) {
        // Add virtual root node
        users.push({ id: 0, parent: null, name: "Root" });
        for (const root of tree) {
            traverse(root, 0);
        }
    } else if (tree) {
        traverse(tree, null);
    }

    return users;
}

export default useFamilyTree;
