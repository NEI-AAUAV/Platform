/**
 * Family Tree Utilities
 * 
 * Shared helpers for tree data manipulation.
 * Consolidates duplicate code from useFamilyTree.jsx and FamilyContent.
 */

import PropTypes from 'prop-types';

/**
 * Flatten nested tree structure into array for D3 stratify
 * @param {Array|Object} tree - Nested tree from API (roots array or single tree)
 * @returns {Array} Flat array of users with parent references
 */
export function flattenTree(tree) {
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
            organizations: node.user_roles?.map(role => {
                // Determine the display name - prefer readable names over role_id paths
                let orgName = role.org_name;
                if (!orgName || (typeof orgName === 'string' && orgName.startsWith('.'))) {
                    orgName = role.role_name || role.org_name || role.role_id;
                }

                return {
                    name: orgName,
                    year: role.year,
                    role: role.role_name || role.role_id,
                    role_name: role.role_name,
                    role_id: role.role_id, // Keep for debugging
                    year_display_format: role.year_display_format,
                    hidden: role.hidden,
                    icon: role.icon
                };
            }) || [],
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

/**
 * Get ancestors of a node (path from root to node)
 * @param {Object} node - D3 hierarchy node
 * @returns {Array} Array of ancestor nodes from root to parent
 */
export function getAncestors(node) {
    const ancestors = [];
    let current = node?.parent;
    while (current && current.data.id !== 0) {
        ancestors.unshift(current);
        current = current.parent;
    }
    return ancestors;
}

/**
 * Get all descendants of a node (recursive)
 * @param {Object} node - D3 hierarchy node
 * @returns {Array} Array of all descendant nodes
 */
export function getDescendants(node) {
    const descendants = [];

    function collect(n) {
        if (n.children) {
            for (const child of n.children) {
                descendants.push(child);
                collect(child);
            }
        }
    }

    collect(node);
    return descendants;
}

/**
 * Check if assigning patrão would create a cycle
 * @param {number} userId - ID of the user being edited
 * @param {number} patraoId - ID of potential patrão 
 * @param {Array} allUsers - All users array with parent references
 * @returns {boolean} True if cycle would be created
 */
export function wouldCreateCycle(userId, patraoId, allUsers) {
    if (!patraoId || !userId) return false;
    if (patraoId === userId) return true;

    // Build quick lookup
    const userMap = {};
    allUsers.forEach(u => {
        userMap[u._id || u.id] = u;
    });

    // Walk up from patraoId to see if we reach userId
    let current = userMap[patraoId];
    const visited = new Set();

    while (current?.patrao_id) {
        if (visited.has(current._id || current.id)) break; // Already a cycle exists
        visited.add(current._id || current.id);

        if (current.patrao_id === userId) {
            return true; // Would create cycle
        }
        current = userMap[current.patrao_id];
    }

    return false;
}

/**
 * Calculate suggested patrões based on year
 * Suggests members who entered >= 3 years before the given year
 * @param {number} startYear - User's start year
 * @param {Array} allUsers - All users to filter
 * @returns {Array} Filtered and sorted list of suggested patrões
 */
export function getSuggestedPatroes(startYear, allUsers) {
    if (!startYear || !allUsers) return [];

    const minPatraoYear = startYear - 3;

    return allUsers
        .filter(u => u.start_year && u.start_year <= minPatraoYear)
        .sort((a, b) => b.start_year - a.start_year); // Most recent first
}

/**
 * Format year for display
 * @param {number} y - Year (2-digit format like 24)
 * @param {string} fmt - Format type: 'civil' or 'academic'
 * @returns {string} Formatted year string
 */
export function formatYear(y, fmt = 'civil') {
    if (!y && y !== 0) return "-";

    if (fmt === "academic") {
        const yearNum = parseInt(y);
        const yy = yearNum % 100;
        const next = (yy + 1) % 100;
        return `${yy.toString().padStart(2, "0")}/${next.toString().padStart(2, '0')}`;
    }

    if (y < 100) return `20${y.toString().padStart(2, "0")}`;
    return y.toString();
}

// PropTypes definitions for documentation
export const UserShape = PropTypes.shape({
    id: PropTypes.number,
    _id: PropTypes.number,
    parent: PropTypes.number,
    name: PropTypes.string.isRequired,
    sex: PropTypes.oneOf(['M', 'F']),
    start_year: PropTypes.number,
    faina_name: PropTypes.string,
    nmec: PropTypes.number,
    image: PropTypes.string,
    organizations: PropTypes.array,
});

export const NodeShape = PropTypes.shape({
    x: PropTypes.number,
    y: PropTypes.number,
    data: UserShape,
    parent: PropTypes.object,
    children: PropTypes.array,
});

/**
 * Split name into two lines for tree display
 * @param {string} name - Full name
 * @returns {Object} { name1, name2, isTruncated, tname1, tname2 }
 */
export function separateName(name) {
    const maxChars = 15,
        middleIndex = Math.ceil(name.length / 2);

    let name1 = name.slice(0, middleIndex).split(" "),
        name2 = name.slice(middleIndex).split(" "),
        nameMid = name1.slice(-1)[0] + name2.slice(0, 1)[0];

    name1 = name1.slice(0, -1).join(" ");
    name2 = name2.slice(1).join(" ");

    if (name1.length >= name2.length) {
        name2 = (nameMid + " " + name2).trim();
    } else {
        name1 = (name1 + " " + nameMid).trim();
    }

    let isTruncated = false,
        tname1 = name1,
        tname2 = name2;

    if (name1.length > maxChars) {
        isTruncated = true;
        tname1 = name1.slice(0, maxChars - 3) + "...";
    }
    if (name2.length > maxChars) {
        isTruncated = true;
        tname2 = name2.slice(0, maxChars - 3) + "...";
    }

    return { name1, name2, isTruncated, tname1, tname2 };
}

export function getFainaHierarchy({ sex, start_year, organizations }, end_year) {
    if (organizations)
        for (const o of organizations) {
            if (o.name === "CF" && o.year === end_year && o.role) return o.role;
            if (o.name === "ST" && o.year === end_year) return o.role;
        }

    const maleHierarchies = ["Junco", "Moço", "Marnoto", "Mestre"];
    const femaleHierarchies = ["Caniça", "Moça", "Salineira", "Mestre"];

    const index = Math.min(end_year - start_year - 1, 3);
    return sex === "M" ? maleHierarchies[index] : femaleHierarchies[index];
}

export function showLabelFaina({ fainaNames, start_year }, end_year) {
    if (fainaNames && start_year + 1 <= end_year) {
        return true;
    }
    return false;
}

export function labelFamilies(node) {
    if (node.parent) {
        if (node.parent.id === 0) {
            node.family = node.id; // head of the family
        } else {
            node.family = node.parent.family;
        }
    }

    if (node.children && node.children.length > 0) {
        node.family_depth = 0;
        node.family_count = 0;
        for (const n of node.children) {
            labelFamilies(n);
            node.family_depth = Math.max(node.family_depth, n.family_depth);
            node.family_count += n.family_count;
        }
    } else {
        node.family_depth = node.depth;
        node.family_count = 1;
    }
}
