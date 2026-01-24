import * as d3 from "d3";

import femalePic from "assets/default_profile/female.svg";
import malePic from "assets/default_profile/male.svg";
import otherPic from "assets/default_profile/other.svg";
import nei from "assets/icons/nei.svg";
import aettua from "assets/icons/aettua.svg";
import anzol from "assets/icons/anzol.svg";
import sal from "assets/icons/sal.svg";
import rol from "assets/icons/rol.svg";
import lenco from "assets/icons/lenco.svg";
import pa from "assets/icons/pa.svg";
import aauav from "assets/icons/aauav.svg";
import heartBorder from "assets/icons/heart_border.svg";
import faina from "assets/icons/faina.svg";
import {
  separateName,
  getFainaHierarchy,
  showLabelFaina,
  labelFamilies,
  formatYear
} from "./utils";

// Dynamic year bounds - set via buildTree options
let currentMinYear = 8;
let currentMaxYear = 25;

export const colors = [
  "#006600",
  "#00ace6",
  "#D44566",
  "#ffd11a",
  "#3DD674",
  "#FFBD50",
  "#a2b627",
  "#BAA424",
  "#eead2d",
  "#19829D",
  "#808080",
  "#BB526B",
  "#ff0000",
  "#fc719e",
  "#8142A8",
  "#e67300",
  "#0000e6",
  "#938ED8",
];

export const organizations = {
  NEI: {
    name: "NEI",
    insignia: nei,
  },
  AETTUA: {
    name: "AETTUA",
    insignia: aettua,
  },
  AAUAv: {
    name: "AAUAv",
    insignia: aauav,
  },
  "Faina Académica": {
    name: "Faina Académica",
    insignia: faina
  },
  "Salgadíssima Trindade": {
    name: "Salgadíssima Trindade",
    insignia: faina
  },
  "Conselho de Cagaréus": {
    name: "Conselho de Cagaréus",
    insignia: faina
  },
  CF: {
    name: "Comissão de Faina",
    insignia: anzol,
    changeColor: true,
  },
  CS: {
    name: "Conselho do Salgado",
    insignia: sal,
    changeColor: true,
  },
  escrivao: {
    name: "Mestre Escrivão",
    insignia: rol,
    changeColor: true,
  },
  pescador: {
    name: "Mestre Pescador",
    insignia: lenco,
    changeColor: true,
  },
  salgado: {
    name: "Mestre do Salgado",
    insignia: pa,
    changeColor: true,
  },
};

// threshold to show photos
const zoomThreshold = 1;
let lastTransform = d3.zoomIdentity.scale(0.5);
let svg, zoom, groups, labels, fainaLabels;
export let searchData = [];

// Export root node for breadcrumbs and external access (use getTreeRoot() to access)
let _treeRoot = null;
export const getTreeRoot = () => _treeRoot;

// Store node map for quick lookup by ID
const nodeMap = new Map();

// Callbacks for node interactions
let onNodeSelectCallback = null;
let onNodeHoverCallback = null;
let onNodeEditCallback = null;
let onNodeViewProfileCallback = null;
let isEditMode = false;



/**
 * Build the family tree visualization
 * @param {Array} users - User data from API (required)
 * @param {Object} [options] - Build options
 * @param {number} [options.minYear] - Minimum year from API
 * @param {number} [options.maxYear] - Maximum year from API
 * @param {Function} [options.onNodeSelect] - Callback when node is clicked
 * @param {Function} [options.onNodeHover] - Callback when node is hovered
 * @param {boolean} [options.editMode] - Whether tree is in edit mode
 * @param {Function} [options.onNodeEdit] - Callback when node is clicked in edit mode
 */
export function buildTree(users, options = {}) {
  // Update dynamic year bounds from API
  if (options.minYear !== undefined) currentMinYear = options.minYear;
  if (options.maxYear !== undefined) currentMaxYear = options.maxYear;

  // Store callbacks
  onNodeSelectCallback = options.onNodeSelect || null;
  onNodeHoverCallback = options.onNodeHover || null;
  onNodeEditCallback = options.onNodeEdit || null;
  onNodeViewProfileCallback = options.onNodeViewProfile || null;
  isEditMode = options.editMode || false;

  // Require users data from API
  if (!users || !Array.isArray(users) || users.length === 0) {
    console.warn("buildTree: No users data provided");
    return;
  }

  const userData = users;

  const assignInsignias = () => {
    const insignias = ["nei", "aettua"];
    // Use crypto.getRandomValues for cryptographically secure random number
    const array = new Uint32Array(1);
    crypto.getRandomValues(array);
    const i = array[0] % (insignias.length * 2);
    return insignias.slice(i);
  };

  for (const elem of userData) {
    // Create faina names
    elem.names = separateName(elem.name);
    if (elem.faina && elem.faina[0]?.name) {
      elem.fainaNames = separateName(
        getFainaHierarchy(elem, currentMaxYear) +
        " " +
        (elem.faina.find((f) => f.year === currentMaxYear)?.name ||
          elem.faina[0].name)
      );
    }

    // Create organizations
    // Create organizations with metadata
    const insigniasMap = new Map();
    elem.organizations?.forEach((o) => {
      // console.log("Processing Org:", o.name, o); // Debug Filter
      // Skip hidden roles in Tree
      if (o.hidden === true) return;

      // Determine the grouping ID (for sidebar filtering) and display title
      // Priority: org_name (short code like "NEI", "CF") > role_name (full name) > name > role_id
      let id = o.name; // o.name comes from org_name in flattenTree
      let roleTitle = o.role_name || o.role || o.name;

      // If id looks like a role_id path (starts with "."), use role_name as fallback for ID
      if (id?.startsWith(".")) {
        id = o.role_name || o.role || id;
      }

      // Logic for ST sub-roles (special handling for Salgadíssima Trindade)
      if (o.name === "ST" || id === "ST" || o.role_id === "ST") {
        const roleMap = {
          "Mestre Escrivão": "escrivao",
          "Mestre Pescador": "pescador",
          "Mestre do Salgado": "salgado",
        };
        if (roleMap[o.role]) {
          id = roleMap[o.role];
          roleTitle = o.role;
        } else if (roleMap[o.role_name]) {
          id = roleMap[o.role_name];
          roleTitle = o.role_name;
        }
      }

      // Consolidate NEI sub-role short codes (like "RF") under "NEI"
      // These are role shorts that should not appear as separate insignia entries
      // Check by looking at role_id prefix for NEI roles (.2.*)
      if (o.role_id?.startsWith(".2.") && id !== "NEI") {
        id = "NEI";
      }

      if (!id) return;

      if (!insigniasMap.has(id)) {
        insigniasMap.set(id, {
          id: id,
          roles: [],
          format: o.year_display_format || "civil",
          icon: o.icon, // Capture icon from API for dynamic insignias
          orgName: o.name // Store original org_name for sidebar filtering
        });
      }

      insigniasMap.get(id).roles.push({
        title: roleTitle,
        parentOrg: o.parent_org_name,
        year: o.year,
        format: o.year_display_format || "civil"
      });
    });

    elem.insignias = Array.from(insigniasMap.values()).map(val => {
      // Sort roles by year descending? or keep as is? 
      // Keep order
      return val;
    });
  }

  const dataStructure = d3
    .stratify()
    .id((d) => d.id)
    .parentId((d) => d.parent)(userData);

  // label all nodes with their family id and depth
  labelFamilies(dataStructure);

  // sort head families according to the family depth
  // sort like a normal distribution
  dataStructure.children = dataStructure.children
    .slice()
    .filter((a) => a.children || a.data.start_year > 14) // TODO: do something
    .sort(
      (a, b) =>
        a.family_depth - b.family_depth || a.family_count - b.family_count
    )
    .reduceRight((acc, val, i) => {
      return i % 2 === 0 ? [...acc, val] : [val, ...acc];
    }, []);

  const treeStructure = d3
    .tree()
    // .size(view)
    .nodeSize([100, 150])
    .separation(function (a, b) {
      return a.family !== b.family ? 4 : a.parent !== b.parent ? 1.25 : 1;
    });

  const root = treeStructure(dataStructure);

  // Store root for external access
  _treeRoot = root;

  // Build node map for quick lookup
  nodeMap.clear();
  root.descendants().forEach(node => {
    if (node.data.id !== undefined) {
      nodeMap.set(node.data.id, node);
    }
  });

  // clean svg
  d3.select("svg.treeei").selectAll("*:not(defs, defs *)").remove();

  zoom = d3
    .zoom()
    .scaleExtent([0.3, 3])
    .on("zoom", ({ transform }) => zoomed(transform));

  svg = d3.select("svg.treeei").call(zoom).append("g");

  function zoomed(transform) {
    const n = transform.k > zoomThreshold;
    const o = lastTransform.k > zoomThreshold;
    if (n !== o) {
      updateNodes(n);
    }
    svg.attr("transform", transform);
    lastTransform = transform;
  }

  groups = svg
    .append("g")
    .attr("class", "nodes")
    .selectAll("g")
    .data(root.descendants().slice(1))
    .enter()
    .append("g");

  // links
  groups
    .filter((d) => d.parent !== root)
    .append("path")
    .attr("marker-start", "url(#dot)")
    .attr("d", function (d) {
      const sx = d.parent.x,
        sy = d.parent.y + 68,
        tx = d.x,
        ty = d.y,
        hy = 0.5 * (ty - sy),
        off = 5;

      let dir = sx - tx > 0 ? -1 : sx - tx < 0 ? 1 : 0;

      const p =
        `M${sx},${sy}` +
        `v${hy - off - 10}` +
        `c0,${off} 0,${off} ${off * dir},${off}` +
        `h${tx - sx - 3 * off * dir}` +
        `c${2 * off * dir},0 ${2 * off * dir},0 ${2 * off * dir},${2 * off}` +
        `L${tx},${ty}`;

      return p;
    })
    .attr("stroke-dasharray", function () {
      let length = d3.select(this).node().getTotalLength();
      return length + " " + length;
    })
    .attr("stroke-dashoffset", function () {
      return d3.select(this).node().getTotalLength();
    })
    .transition()
    .duration(3000)
    .ease(d3.easeLinear)
    .attr("stroke-dashoffset", 0);

  const nodes = groups
    .append("g")
    .attr("class", "node")
    .attr("transform", (d) => `translate(${d.x},${d.y})`);

  const resolveNodeImage = (img) => {
    if (!img) return null;
    // If API returns full URL (R2), use as-is
    if (img.startsWith("http://") || img.startsWith("https://")) return img;
    // Fallback to legacy static path
    return import.meta.env.BASE_URL + "treeei/optimized/" + img + ".jpeg";
  };

  // Pre-validate image URLs before creating SVG patterns
  const defs = d3.select("defs");
  const nodesWithImages = root.descendants().slice(1).filter((d) => !!d.data.image);
  const validateImage = (url) => {
    return new Promise((resolve) => {
      const img = new window.Image();
      img.onload = () => resolve(true);
      img.onerror = () => resolve(false);
      img.src = url;
    });
  };

  // Async validation and pattern creation
  (async () => {
    for (const d of nodesWithImages) {
      const url = resolveNodeImage(d.data.image);
      const ok = await validateImage(url);
      if (ok) {
        const pattern = defs.append("pattern")
          .attr("class", "image")
          .attr("id", d.data.id)
          .attr("width", 1)
          .attr("height", 1)
          .attr("patternContentUnits", "objectBoundingBox");
        pattern.append("image")
          .attr("xlink:xlink:href", url)
          .attr("height", 1)
          .attr("width", 1)
          .attr("preserveAspectRatio", "xMidYMid slice");
      } else {
        // If image fails, clear image so fallback is used
        d.data.image = null;
      }
    }
  })();

  const getNodeImageId = (d) => {
    if (d.data.image) return d.data.id;
    if (d.data.sex === "M") return "default_male";
    if (d.data.sex === "F") return "default_female";
    return "default_other";
  };

  // circle with the person image
  const nodesProfilePic = nodes
    .append("circle")
    .attr("class", "profile-pic")
    .attr("cx", 0)
    .attr("cy", 0)
    .attr("r", 10)
    .style("fill", (d) => `url(#${getNodeImageId(d)})`);

  // Collect unique icon URLs from all insignias for dynamic pattern creation
  const dynamicIconUrls = new Set();
  root.descendants().forEach(node => {
    if (node.data.insignias) {
      node.data.insignias.forEach(ins => {
        if (ins.icon) {
          dynamicIconUrls.add(ins.icon);
        }
      });
    }
  });

  // Create dynamic patterns for backend icon URLs
  // Use a sanitized version of the URL as the pattern ID
  const sanitizeId = (url) => url.replace(/[^a-zA-Z0-9]/g, '_');

  d3.select("defs")
    .selectAll("pattern.dynamic-icon")
    .data(Array.from(dynamicIconUrls))
    .enter()
    .append("pattern")
    .attr("class", "dynamic-icon")
    .attr("id", d => `icon_${sanitizeId(d)}`)
    .attr("width", 1)
    .attr("height", 1)
    .attr("patternContentUnits", "objectBoundingBox")
    .append("image")
    .attr("xlink:href", d => d)
    .attr("height", 1)
    .attr("width", 1)
    .attr("preserveAspectRatio", "xMidYMid slice");

  // Helper to get pattern ID for an insignia
  const getInsigniaPatternId = (ins) => {
    // If has dynamic icon from backend, use that pattern
    if (ins.icon) {
      return `icon_${sanitizeId(ins.icon)}`;
    }
    // Fallback to static pattern by ID (for backward compatibility)
    return ins.id;
  };

  nodes
    .insert("g", "circle.profile-pic")
    .attr("class", "insignias")
    .selectAll("rect")
    .data((d) => d.data.insignias)
    .enter()
    .append("rect")
    .attr("class", (d) => `insignia ${d.id}`)
    .attr("x", -5)
    .attr("y", -5)
    .style("opacity", 0)
    .attr("width", 10)
    .attr("height", 10)
    .style("fill", (d) => {
      // Use dynamic icon pattern if available, otherwise fallback to static
      return `url(#${getInsigniaPatternId(d)})`;
    })
    .append("title")
    .text(function (d) {
      // Get the insignia id to check for redundancy
      const insigniaId = d.id;

      return d.roles.map(r => {
        // Only show parentOrg if it's different from the main org (insignia id)
        // This avoids redundancy like "Consoante (NEI)" when the insignia is already NEI
        // But keeps useful context like "Vogal (Direção)" for AETTUA sub-sections
        const shouldShowParent = r.parentOrg && r.parentOrg !== insigniaId;
        const parentContext = shouldShowParent ? ` (${r.parentOrg})` : "";
        return `${r.title}${parentContext} (${formatYear(r.year, r.format)})`;
      }).join('\n');
    });

  // circle with the gradient year color
  const nodesProfileGrad = nodes
    .append("circle")
    .attr("class", "profile-grad")
    .attr("cx", 0)
    .attr("cy", 0)
    .attr("r", 10)
    .attr("opacity", 1)
    .style("cursor", "pointer")
    .style("fill", (d) => colors[d.data.start_year % colors.length])
    .on("click", function (event, d) {
      event.stopPropagation();

      // Edit Mode Action
      if (isEditMode) {
        if (onNodeEditCallback) {
          onNodeEditCallback(d.data);
        }
        return;
      }

      // Trigger node selection callback for highlighting/breadcrumbs
      if (onNodeSelectCallback && d.data.id) {
        onNodeSelectCallback(d.data.id);
      }

      // Toggle insignias display
      let parent = this.parentElement;
      let active = parent.classList.contains("active");
      let x, y, o;

      if (active) {
        parent.classList.remove("active");
        x = y = (_) => -5;
        o = 0;
      } else {
        parent.classList.add("active");
        x = (i) => Math.cos(((-i + 1) / 5) * Math.PI) * 30 - 5;
        y = (i) => Math.sin(((-i + 1) / 5) * Math.PI) * 30 - 5;
        o = 1;
      }

      d3.select(parent)
        .select("g.insignias")
        .selectAll("rect.insignia")
        .transition()
        .attr("x", (d, i) => x(i))
        .attr("y", (d, i) => y(i))
        .style("opacity", o)
        .ease(d3.easeBackOut.overshoot(2));
    });

  // border with the year color
  const nodesProfileBorder = nodes
    .insert("circle", "circle")
    .attr("class", "profile-border")
    .attr("cx", 0)
    .attr("cy", 0)
    .attr("r", 12);

  const nodesHeartBorder = nodes
    .filter((d) => d.data.nmec === 76368)
    .insert("circle")
    .attr("r", 24)
    .style("filter", `brightness(1.3)`)
    .style("fill", `url(#heart_border)`);

  // Profile view button - positioned to the left of node
  const profileButtons = nodes
    .append("g")
    .attr("class", "profile-btn")
    .attr("transform", "translate(-26, 0)")
    .style("cursor", "pointer")
    .style("opacity", 0)
    .on("click", function (event, d) {
      event.stopPropagation();
      if (onNodeViewProfileCallback && d.data.id) {
        onNodeViewProfileCallback(d.data);
      }
    })
    .on("mouseenter", function () {
      // Keep button visible when hovering over it
      d3.select(this).style("opacity", 1);
      // Simple scale up on hover
      d3.select(this).select("path")
        .transition()
        .duration(150)
        .attr("transform", "translate(-6, -6) scale(0.55)");
    })
    .on("mouseleave", function () {
      // Reset scale
      d3.select(this).select("path")
        .transition()
        .duration(150)
        .attr("transform", "translate(-6, -6) scale(0.5)");
    });

  // Invisible hover bridge - creates a hover area between node and button
  profileButtons
    .append("rect")
    .attr("class", "hover-bridge")
    .attr("x", -12)
    .attr("y", -12)
    .attr("width", 38)
    .attr("height", 24)
    .attr("fill", "transparent")
    .style("pointer-events", "all");

  // Button icon - just the eye icon in black with white outline
  profileButtons
    .append("path")
    .attr("d", "M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z")
    .attr("transform", "translate(-6, -6) scale(0.5)")
    .attr("fill", "#000")
    .attr("stroke", "#fff")
    .attr("stroke-width", 2)
    .style("filter", "drop-shadow(0 2px 4px rgba(255,255,255,0.9))")
    .style("pointer-events", "none");

  // Add hover handlers to nodes to show/hide profile button AND insignias
  nodes
    .on("mouseenter", function (event, d) {
      const parent = this;

      // Show profile button
      d3.select(this).select(".profile-btn")
        .transition()
        .duration(200)
        .style("opacity", 1);

      // Show insignias automatically on hover
      if (!parent.classList.contains("active")) {
        const x = (i) => Math.cos(((-i + 1) / 5) * Math.PI) * 30 - 5;
        const y = (i) => Math.sin(((-i + 1) / 5) * Math.PI) * 30 - 5;

        d3.select(parent)
          .select("g.insignias")
          .selectAll("rect.insignia")
          .transition()
          .duration(300)
          .attr("x", (d, i) => x(i))
          .attr("y", (d, i) => y(i))
          .style("opacity", 1)
          .ease(d3.easeBackOut.overshoot(2));
      }

      // Also trigger existing hover callback
      if (onNodeHoverCallback && d.data.id) {
        onNodeHoverCallback(d.data.id, true);
      }
    })
    .on("mouseleave", function (event, d) {
      const parent = this;

      // Hide profile button
      d3.select(this).select(".profile-btn")
        .transition()
        .duration(200)
        .style("opacity", 0);

      // Hide insignias if not clicked/active
      if (!parent.classList.contains("active")) {
        d3.select(parent)
          .select("g.insignias")
          .selectAll("rect.insignia")
          .transition()
          .duration(200)
          .attr("x", -5)
          .attr("y", -5)
          .style("opacity", 0);
      }

      // Also trigger existing hover callback
      if (onNodeHoverCallback && d.data.id) {
        onNodeHoverCallback(d.data.id, false);
      }
    });

  labels = groups
    .append("g")
    .attr("class", "label")
    .attr("transform", (d) => `translate(${d.x},${d.y + 18})`);

  fainaLabels = labels
    .filter((d) => d.data.fainaNames)
    .classed("label-faina", true);

  // nodes' names
  labels
    .append("text")
    .attr("x", 0)
    .attr("y", 0)
    .attr("text-anchor", "middle")
    .append("tspan")
    .attr("x", 0)
    .attr("dy", "1.2em")
    .text((d) => d.data.names.tname1)
    .append("tspan")
    .attr("x", 0)
    .attr("dy", "1.2em")
    .text((d) => d.data.names.tname2);

  // nodes' faina names
  fainaLabels
    .append("text")
    .classed("text-faina", true)
    .attr("x", 0)
    .attr("y", 0)
    .attr("text-anchor", "middle")
    .append("tspan")
    .attr("x", 0)
    .attr("dy", "1.2em")
    .text((d) => d.data.fainaNames.tname1)
    .append("tspan")
    .attr("x", 0)
    .attr("dy", "1.2em")
    .text((d) => d.data.fainaNames.tname2);

  const labelsTooltips = groups
    .filter((d) => d.data.names.isTruncated)
    .append("g")
    .attr("class", "label label-tooltip")
    .attr("transform", (d) => `translate(${d.x},${d.y + 18})`)
    .attr("opacity", "0")
    .on("mouseover", function () {
      d3.select(this).transition().duration(200).attr("opacity", 1);
    })
    .on("mouseout", function () {
      d3.select(this).transition().delay(200).duration(400).attr("opacity", 0);
    });

  labelsTooltips
    .append("text")
    .attr("x", 0)
    .attr("y", 0)
    .attr("text-anchor", "middle")
    .append("tspan")
    .attr("x", 0)
    .attr("dy", "1.2em")
    .text((d) => d.data.names.name1)
    .append("tspan")
    .attr("x", 0)
    .attr("dy", "1.2em")
    .text((d) => d.data.names.name2);

  labelsTooltips
    .insert("rect", "text")
    .attr("fill", "white")
    .attr("width", function () {
      return this.nextSibling.getBBox().width + 10;
    })
    .attr("height", function () {
      return this.nextSibling.getBBox().height;
    })
    .attr("x", function () {
      return this.nextSibling.getBBox().x - 5;
    })
    .attr("y", function () {
      return this.nextSibling.getBBox().y;
    });

  // Populate searchData
  searchData = [];
  groups.each((node) =>
    searchData.push({
      id: node.id,
      nmec: node.data.nmec,
      name: node.data.name,
      color: colors[node.data.start_year % colors.length],
      x: node.x,
      y: node.y,
    })
  );

  function updateNodes(close) {
    nodesProfilePic
      .style("fill", (d) => (close ? `url(#${getNodeImageId(d)})` : "none"))
      .transition()
      .duration(300)
      .attr("r", close ? 18 : 10);

    nodesProfileGrad
      .attr("opacity", (d) => (close ? (d.data.image ? 0 : 0.4) : 1))
      .transition()
      .duration(300)
      .attr("r", close ? 18 : 10);

    nodesProfileBorder
      .style("stroke", (d) =>
        close ? colors[d.data.start_year % colors.length] : "silver"
      )
      .transition()
      .duration(300)
      .attr("r", close ? 20 : 12);

    nodesHeartBorder
      .transition()
      .delay(close ? 200 : 0)
      .duration(close ? 400 : 0)
      .ease(d3.easeCubicOut)
      .style("opacity", (d) => (close ? 1 : 0));

    labels
      .classed("label-small", close)
      .transition()
      .duration(300)
      .attr("transform", (d) => `translate(${d.x},${d.y + (close ? 26 : 18)})`);

    labelsTooltips
      .classed("label-small", close)
      .transition()
      .duration(300)
      .attr("transform", (d) => `translate(${d.x},${d.y + (close ? 26 : 18)})`);

    // Profile buttons - position relative to node size when zoomed
    profileButtons
      .transition()
      .duration(300)
      .attr("transform", close ? "translate(-32, 0)" : "translate(-26, 0)");
  }

  updateNodes(false);

  // constrain tree
  const { width, height, x, y } = svg.node().getBBox();

  const padY = 256,
    padX = 768,
    x0 = x - 1.5 * padX,
    y0 = y - padY,
    x1 = x + width + padX,
    y1 = y + height + padY;

  zoom.translateExtent([
    [x0, y0],
    [x1, y1],
  ]);
}

export function centerTree() {
  const rect = d3.select("svg.treeei").node().getBoundingClientRect();
  const { x, y, width, height } = svg.node().getBBox();

  // let offsetY =
  //   (rect.height - height * lastTransform.k) / 2 - y * lastTransform.k;
  let offsetX =
    (rect.width - width * lastTransform.k) / 2 - x * lastTransform.k;

  d3.select("svg.treeei").call(
    zoom.transform,
    d3.zoomIdentity.translate(offsetX, 0).scale(0.5)
  );
}

export function filterTree(names, end_year) {
  groups.attr("opacity", (d) => {
    if (d.data.start_year > end_year) return 0.2;
    if (names.length === 0) return 1;
    if (d.data.insignias.some((n) => names.includes(n.id))) return 1;
    return 0.2;
  });

  fainaLabels
    .filter(function (d) {
      const n = d3.select(this);
      if (showLabelFaina(d.data, end_year)) {
        const hierarchy = getFainaHierarchy(d.data, end_year);
        d.data.fainaNames = separateName(
          hierarchy +
          " " +
          (d.data.faina.find((f) => f.year === end_year)?.name ||
            d.data.faina[0].name)
        );
        n.classed("label-faina", true);
        return true;
      }
      n.classed("label-faina", false);
      return false;
    })
    .select("text.text-faina")
    .select("tspan")
    .text((d) => d.data.fainaNames.tname1)
    .append("tspan")
    .attr("x", 0)
    .attr("dy", "1.2em")
    .text((d) => d.data.fainaNames.tname2);
}

export function changeLabels(showFainaNames) {
  fainaLabels.classed("show", showFainaNames);
}

export const patterns = [
  // Essential base patterns (profiles, special)
  { id: "heart_border", image: heartBorder },
  { id: "default_male", image: malePic },
  { id: "default_female", image: femalePic },
  { id: "default_other", image: otherPic },
  // Static fallback patterns for old data without backend icon URLs
  // These are only used when roles don't have .icon field from backend
  { id: "NEI", image: nei },
  { id: "AETTUA", image: aettua },
  { id: "AAUAv", image: aauav },
  { id: "CF", image: anzol },
  { id: "CS", image: sal },
  { id: "escrivao", image: rol },
  { id: "pescador", image: lenco },
  { id: "salgado", image: pa },
  { id: "Faina Académica", image: faina },
  { id: "ST", image: faina },
];

export const handleSearchChange = (value) => {
  if (!value) return;
  // TODO: join transitions
  d3.select("svg.treeei").call(zoom.scaleTo, 2.5);
  d3.select("svg.treeei").transition().call(zoom.translateTo, value.x, value.y);
};

/**
 * Highlight the lineage (ancestors and descendants) of a node
 * @param {number} nodeId - ID of the node to highlight
 */
export function highlightLineage(nodeId) {
  if (!groups) return;

  const node = nodeMap.get(nodeId);
  if (!node) return;

  // Collect ancestor and descendant IDs
  const ancestorIds = new Set();
  const descendantIds = new Set();

  // Walk up to get ancestors
  let current = node.parent;
  while (current && current.data.id !== 0) {
    ancestorIds.add(current.data.id);
    current = current.parent;
  }

  // Walk down to get descendants
  function collectDescendants(n) {
    if (n.children) {
      for (const child of n.children) {
        descendantIds.add(child.data.id);
        collectDescendants(child);
      }
    }
  }
  collectDescendants(node);

  // Apply highlighting classes
  groups.each(function (d) {
    const el = d3.select(this);
    const id = d.data.id;

    el.classed("highlighted-ancestor", ancestorIds.has(id));
    el.classed("highlighted-descendant", descendantIds.has(id));
    el.classed("highlighted-selected", id === nodeId);

    // Dim non-related nodes
    if (!ancestorIds.has(id) && !descendantIds.has(id) && id !== nodeId) {
      el.classed("highlighted-dimmed", true);
    } else {
      el.classed("highlighted-dimmed", false);
    }
  });
}

/**
 * Clear all lineage highlighting
 */
export function clearHighlight() {
  if (!groups) return;

  groups
    .classed("highlighted-ancestor", false)
    .classed("highlighted-descendant", false)
    .classed("highlighted-selected", false)
    .classed("highlighted-dimmed", false);
}

/**
 * Build SVG path segment between two nodes (helper for animatePathToNode)
 */
function buildPathSegment(prev, current) {
  const sx = prev.x;
  const sy = prev.y + 68;
  const tx = current.x;
  const ty = current.y;
  const hy = 0.5 * (ty - sy);
  const off = 5;
  let dir = 0;
  if (sx > tx) {
    dir = -1;
  } else if (sx < tx) {
    dir = 1;
  }

  let segment = ` L${sx},${sy} v${hy - off - 10}`;

  if (dir !== 0) {
    segment += ` c0,${off} 0,${off} ${off * dir},${off}`;
    segment += ` h${tx - sx - 3 * off * dir}`;
    segment += ` c${2 * off * dir},0 ${2 * off * dir},0 ${2 * off * dir},${2 * off}`;
  }

  segment += ` L${tx},${ty}`;
  return segment;
}

/**
 * Animate a path from root to the specified node
 * Path renders BEHIND nodes and nodes glow as the line passes through
 * @param {number} nodeId - ID of the target node
 */
export function animatePathToNode(nodeId) {
  if (!svg || !groups) return;

  const node = nodeMap.get(nodeId);
  if (!node) return;

  // Get path from root to node (skip virtual root with id=0)
  const pathNodes = [];
  let current = node;
  while (current && current.data.id !== 0) {
    pathNodes.unshift(current);
    current = current.parent;
  }

  if (pathNodes.length === 0) return;

  // Remove any existing animated path and glow effects
  svg.selectAll(".animated-lineage-path").remove();
  groups.selectAll(".node").classed("node-glow", false);

  // Build path data following tree link structure
  let pathData = `M${pathNodes[0].x},${pathNodes[0].y}`;
  for (let i = 1; i < pathNodes.length; i++) {
    pathData += buildPathSegment(pathNodes[i - 1], pathNodes[i]);
  }

  // INSERT path at the BEGINNING of svg group so it renders BEHIND nodes
  const animatedPath = svg.insert("path", ":first-child")
    .attr("class", "animated-lineage-path")
    .attr("d", pathData)
    .attr("fill", "none")
    .attr("stroke", "#22c55e")  // Bright green
    .attr("stroke-width", 5)
    .attr("stroke-linecap", "round")
    .attr("stroke-linejoin", "round")
    .style("filter", "drop-shadow(0 0 8px rgba(34, 197, 94, 0.9))");

  // Calculate animation timing per node
  const pathLength = animatedPath.node().getTotalLength();
  const animDuration = 1500;  // Total animation time in ms
  const nodeDelay = animDuration / pathNodes.length;

  // Animate the path
  animatedPath
    .attr("stroke-dasharray", pathLength)
    .attr("stroke-dashoffset", pathLength)
    .transition()
    .duration(animDuration)
    .ease(d3.easeLinear)
    .attr("stroke-dashoffset", 0)
    .on("end", function () {
      // Fade out path after delay
      d3.select(this)
        .transition()
        .delay(3000)
        .duration(500)
        .style("opacity", 0)
        .remove();

      // Remove glow from all nodes after fade
      setTimeout(() => {
        groups.selectAll(".node").classed("node-glow", false);
      }, 3500);
    });

  // Add sequential glow effect to nodes along the path
  pathNodes.forEach((pathNode, index) => {
    setTimeout(() => {
      // Find the node group and add glow class
      groups.selectAll(".node")
        .filter(d => d.data.id === pathNode.data.id)
        .classed("node-glow", true);
    }, index * nodeDelay);
  });
}



/**
 * Get a node from the tree by ID
 * @param {number} nodeId - ID of the node
 * @returns {Object|null} D3 hierarchy node or null
 */
export function getNodeById(nodeId) {
  return nodeMap.get(nodeId) || null;
}

/**
 * Navigate (zoom/pan) to a specific node
 * @param {Object} node - D3 hierarchy node
 */
export function navigateToNode(node) {
  if (!node || !zoom) return;

  d3.select("svg.treeei").call(zoom.scaleTo, 2);
  d3.select("svg.treeei")
    .transition()
    .duration(500)
    .call(zoom.translateTo, node.x, node.y);
}

/**
 * Get SVG and group elements for external components (e.g., MiniMap)
 * @returns {Object} { svgElement, groupElement }
 */
export function getSvgElements() {
  const svgElement = document.querySelector("svg.treeei");
  const groupElement = svgElement?.querySelector("g");
  return {
    svgElement,
    groupElement,
  };
}
