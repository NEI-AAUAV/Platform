// example from https://bl.ocks.org/mbostock/3885705

import React, { useEffect, useState, useRef } from 'react';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faCompress, faExpand } from "@fortawesome/free-solid-svg-icons";
import * as d3 from 'd3';
import classNames from "classname";

import data from "Assets/db.json";
import femalePic from "Assets/default_profile/female.svg";
import malePic from "Assets/default_profile/male.svg";
import nei from "Assets/icons/nei.svg";
import aettua from "Assets/icons/aettua.svg";
import anzol from "Assets/icons/anzol.svg";

import './index.css';

// **************************************************
//  SVG Layout
// **************************************************
const view = [1800, 600]        // [width, height]
const trbl = [10, 10, 30, 10]   // [top, right, bottom, left] margins

const dims = [ // Adjusted dimensions [width, height]
  view[0] - trbl[1] - trbl[3],
  view[1] - trbl[0] - trbl[2],
];

// Threshold to show photos
const zoomThreshold = 1;
let lastTransform = d3.zoomIdentity.scale(0.5);
let svg, zoom;


function labelFamilies(node) {
  if (node.parent) {
    if (node.parent.id === "000") {
      node.family = node.id;      // head of the family
    } else {
      node.family = node.parent.family;
    }
  }

  if (node.children) {
    node.family_depth = 0;
    for (const n of node.children) {
      labelFamilies(n);
      node.family_depth = Math.max(node.family_depth, n.family_depth);
    }
  } else {
    node.family_depth = node.depth;
  }
}

function buildTree() {
  const separateName = (name) => {
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
  const assignInsignias = () => {
    return ["cf", "nei", "aettua"];
  }

  for (const elem of data.users) {
    elem.names = separateName(elem.name);
    elem.insignias = assignInsignias();
  }

  const dataStructure = d3.stratify()
    .id(d => d.id)
    .parentId(d => d.parent)
    (data.users);

  // label all nodes with their family id and depth
  labelFamilies(dataStructure);

  // sort head families according to the family depth
  // sort like a normal distribution
  dataStructure.children = dataStructure.children.slice()
    .sort((a, b) => a.family_depth - b.family_depth)
    .reduceRight((acc, val, i) => {
      return i % 2 === 0 ? [...acc, val] : [val, ...acc];
    }, []);

  const treeStructure = d3.tree()
    // .size(view)
    .nodeSize([100, 150])
    .separation(function (a, b) {
      return a.family != b.family ? 4 : a.parent != b.parent ? 1.25 : 1;
    });

  const root = treeStructure(dataStructure);

  d3.select("svg.treeei").selectAll("*:not(defs, defs *)").remove();

  zoom = d3.zoom()
    .scaleExtent([0.2, 2])
    .on("zoom", ({ transform }) => zoomed(transform));

  svg = d3.select("svg.treeei")
    // .attr("width", view[0] + 100)
    // .attr("height", view[1] + 100)
    .call(zoom)
    .append("g")

  function zoomed(transform) {
    const n = transform.k > zoomThreshold;
    const o = lastTransform.k > zoomThreshold;
    if (n !== o) {
      if (n) {
        // Replace with photos
        updateNodes(true);
      } else {
        // Remove images
        updateNodes(false);
      }
    }
    svg.attr("transform", transform);
    lastTransform = transform;
  }

  const links = svg.append("g")
    .attr("class", "links")
    .selectAll("path")
    .data(root.links().filter(d => d.source.data.parent != null));

  links.enter()
    .append("path")
    .style("stroke", "silver")
    .attr('marker-start', 'url(#dot)')
    .attr("d", function (d) {
      const sx = d.source.x,
        sy = d.source.y + 68,
        tx = d.target.x,
        ty = d.target.y,
        hy = 0.5 * (ty - sy),
        off = 5;

      let dir = sx - tx > 0 ? -1 : sx - tx < 0 ? 1 : 0;

      const p = ("M" + sx + "," + (sy)
        + "v" + (hy - off - 10)
        + "c" + 0 + "," + off
        + " " + 0 + "," + off
        + " " + (off * dir) + "," + off
        + "h" + (tx - sx - 3 * off * dir)
        + "c" + (2 * off * dir) + "," + 0
        + " " + (2 * off * dir) + "," + 0
        + " " + (2 * off * dir) + "," + 2 * off
        + "L" + tx + "," + ty
      );
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
    .duration(4000)
    .ease(d3.easeLinear)
    .attr("stroke-dashoffset", 0)

  const nodes = svg.append("g")
    .attr("class", "nodes")
    .selectAll("g")
    .data(root.descendants().slice(1))
    .enter()
    .append("g")
    .attr("transform", d => `translate(${d.x},${d.y})`);

  const nodesImages = d3.select("defs")
    .selectAll("pattern.image")
    .data(root.descendants().slice(1));

  nodesImages.enter()
    .append("pattern")
    .attr("id", d => d.data.id)
    .attr("class", "image")
    .attr('width', 1)
    .attr('height', 1)
    .attr('patternContentUnits', 'objectBoundingBox')
    .append("image")
    .attr("xlink:xlink:href", function (d) {
      return d.data.image ? d.data.image :
        d.data.sex === "M" ? malePic : femalePic;
    })
    .attr("height", 1)
    .attr("width", 1)
    .attr("preserveAspectRatio", "xMinYMin slice");

  // circle with the person image
  const nodesProfilePic = nodes.append("circle")
    .attr("class", "profile-pic")
    .attr("cx", 0)
    .attr("cy", 0)
    .attr("r", 10)
    .style("fill", d => `url(#${d.data.id})`);

  nodes.insert("g", "circle.profile-pic")
    .attr("class", "insignias")
    .selectAll("rect")
    .data(d => d.data.insignias)
    .enter().append("rect")
    .attr("class", "insignia")
    .attr("x", -5)
    .attr("y", -5)
    .style("opacity", 0)
    .attr("width", 10)
    .attr("height", 10)
    .style("fill", d => `url(#${d})`);
  
  // circle with the gradient year color
  const nodesProfileGrad = nodes.append("circle")
    .attr("class", "profile-grad")
    .attr("cx", 0)
    .attr("cy", 0)
    .attr("r", 10)
    .attr("opacity", 1)
    .style("cursor", d => d.data.insignias?.length > 0 ? "pointer" : "default")
    .style("fill", d => d3.schemeTableau10[(d.data.start_year - 4) % 10])
    .on("click", function (event) {
      let parent = this.parentElement;
      let active = parent.classList.contains("active");
      let x, y, o;

      if (active) {
        parent.classList.remove("active");
        x = y = (_) => -5;
        o = 0;
      } else {
        parent.classList.add("active");
        x = (i) => Math.cos((-i + 1) / 5 * Math.PI) * 30 - 5;
        y = (i) => Math.sin((-i + 1) / 5 * Math.PI) * 30 - 5;
        o = 1;
      }

      d3.select(parent)
        .select("g.insignias")
        .selectAll("rect.insignia")
        .transition()
        .attr("x", (d, i) => x(i))
        .attr("y", (d, i) => y(i))
        .style("opacity", o)
        .ease(d3.easeBackOut.overshoot(2))
    })
  
  // border with the year color 
  const nodesProfileBorder = nodes.insert("circle", "circle")
    .attr("class", "profile-border")
    .attr("cx", 0)
    .attr("cy", 0)
    .attr("r", 12)
    .style("fill", "white")
    .style("stroke", "silver")
    .style("stroke-width", 1.5)

  const labels = svg.append("g")
    .attr("class", "labels")
    .selectAll("g")
    .data(root.descendants().slice(1));

  const labelsGroups = labels.enter()
    .append("g")
    .attr("transform", d => `translate(${d.x},${d.y + 18})`)

  labelsGroups.append("text")
    .attr("x", 0)
    .attr("y", 0)
    .attr("text-anchor", "middle")
    .append("tspan")
    .attr('x', 0)
    .attr('dy', '1.2em')
    .text(d => d.data.names.tname1)
    .append("tspan")
    .attr('x', 0)
    .attr('dy', '1.2em')
    .text(d => d.data.names.tname2);

  const labelsTooltipsGroups = svg.append("g")
    .attr("class", "labels-tooltips")
    .selectAll("g")
    .data(root.descendants().slice(1))
    .enter()
    .filter(d => d.data.names.isTruncated)
    .append("g")
    .attr("transform", d => `translate(${d.x},${d.y + 18})`)
    .attr("opacity", "0")
    .on('mouseover', function () {
      d3.select(this).transition()
        .duration(200)
        .attr('opacity', 1);
    })
    .on('mouseout', function () {
      d3.select(this).transition()
        .delay(200)
        .duration(400)
        .attr('opacity', 0);
    });

  labelsTooltipsGroups.append("text")
    .attr("x", 0)
    .attr("y", 0)
    .attr("text-anchor", "middle")
    .append("tspan")
    .attr('x', 0)
    .attr('dy', '1.2em')
    .text(d => d.data.names.name1)
    .append("tspan")
    .attr('x', 0)
    .attr('dy', '1.2em')
    .text(d => d.data.names.name2);

  labelsTooltipsGroups
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
    })

  function updateNodes(close) {
    nodesProfilePic
      .style("fill", d => close ? `url(#${d.data.id})` : "none")
      .transition().duration(300)
      .attr("r", close ? 18 : 10)

    nodesProfileGrad
      .attr("opacity", d => close ? (d.data.image ? 0 : 0.3) : 1)
      .transition().duration(300)
      .attr("r", close ? 18 : 10)

    nodesProfileBorder
      .style("stroke", close ? d => d3.schemeTableau10[(d.data.start_year - 4) % 10] : "silver")
      .transition().duration(300)
      .attr("r", close ? 20 : 12)

    labelsGroups
      .transition().duration(300)
      .attr("transform", d => `translate(${d.x},${d.y + (close ? 26 : 18)})`)
      .select("text")
      .attr("class", close ? "small" : "")

    labelsTooltipsGroups
      .transition().duration(300)
      .attr("transform", d => `translate(${d.x},${d.y + (close ? 26 : 18)})`)
      .select("text")
      .attr("class", close ? "small" : "")
  }

  updateNodes(false);

  // constrain tree
  const { width, height, x, y } = svg.node().getBBox();

  const pad = 96;
  const x0 = x - pad,
    y0 = y - pad,
    x1 = x + width + pad,
    y1 = y + height + pad;

  zoom.translateExtent([[x0, y0], [x1, y1]]);
}


function centerTree() {
  const rect = d3.select("svg.treeei").node().getBoundingClientRect();
  const { x, y, width, height } = svg.node().getBBox();

  let offsetY = (rect.height - height * lastTransform.k) / 2 - y * lastTransform.k;
  let offsetX = (rect.width - width * lastTransform.k) / 2 - x * lastTransform.k;

  d3.select("svg.treeei").call(zoom.transform, d3.zoomIdentity.translate(offsetX, offsetY).scale(0.5));
}


function FainaTree() {
  const [expanded, setExpanded] = useState(false);

  const toggleExpand = () => {
    setExpanded(!expanded);
  }

  useEffect(() => {
    buildTree();
    centerTree();
  }, [])

  return (
    <div id="treeei" className={classNames("d-flex flex-grow-1", { "expand": expanded })}>
      <div className="open-expand" onClick={toggleExpand}>
        <FontAwesomeIcon icon={expanded ? faCompress : faExpand} size="lg" />
      </div>
      <svg className="treeei">
        <defs>
          <marker id="dot" viewBox="0,0,20,20" refX="10" refY="10" markerWidth="10" markerHeight="10">
            <circle cx="10" cy="10" r="4" fill="silver"></circle>
          </marker>
          <filter id="drop-shadow2" height="130%">
            <feGaussianBlur in="SourceAlpha" stdDeviation="5" result="blur"></feGaussianBlur>
            <feOffset in="blur" dx="5" dy="5" result="offsetBlur"></feOffset>
            <feMerge>
              <feMergeNode in="offsetBlur"></feMergeNode>
              <feMergeNode in="SourceGraphic"></feMergeNode>
            </feMerge>
          </filter>
          <filter id="drop-shadow" filterUnits="userSpaceOnUse" width="250%" height="250%">
            <feGaussianBlur in="SourceGraphic" stdDeviation="2" result="blur-out"></feGaussianBlur>
            {/* <feColorMatrix in="blur-out" type="hueRotate" values="180" result="color-out"></feColorMatrix> */}
            <feOffset in="color-out" dx="1" dy="1" result="the-shadow"></feOffset>
            <feOffset in="color-out" dx="-1" dy="-1" result="the-shadow"></feOffset>
            <feBlend in="SourceGraphic" in2="the-shadow" mode="normal"></feBlend>
          </filter>
          <pattern id="default_male" width="1" height="1" patternContentUnits="objectBoundingBox">
            <image xlinkHref={malePic} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
          </pattern>
          <pattern id="default_female" width="1" height="1" patternContentUnits="objectBoundingBox">
            <image xlinkHref={femalePic} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
          </pattern>
          <pattern id="nei" width="1" height="1" patternContentUnits="objectBoundingBox">
            <image xlinkHref={nei} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
          </pattern>
          <pattern id="aettua" width="1" height="1" patternContentUnits="objectBoundingBox">
            <image xlinkHref={aettua} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
          </pattern>
          <pattern id="cf" width="1" height="1" patternContentUnits="objectBoundingBox">
            <image xlinkHref={anzol} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
          </pattern>
        </defs>
      </svg>
    </div>
  )
}

export default FainaTree;
