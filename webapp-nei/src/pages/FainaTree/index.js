// example from https://bl.ocks.org/mbostock/3885705

import React, { useEffect, useState } from 'react';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faCompress, faExpand,
  faSitemap, faGripHorizontal,
  faChevronDown, faChevronUp,
  faArrowUp, faArrowDown,
  faAngleLeft, faAngleRight,
} from "@fortawesome/free-solid-svg-icons";

import * as d3 from 'd3';
import classNames from "classname";

import Box from '@mui/material/Box';
import TextField from '@mui/material/TextField';
import Autocomplete from '@mui/material/Autocomplete';

import { useTheme } from "stores/useTheme";

import data from "assets/db.json";
import femalePic from "assets/default_profile/female.svg";
import malePic from "assets/default_profile/male.svg";
import nei from "assets/icons/nei.svg";
import aettua from "assets/icons/aettua.svg";
import anzol from "assets/icons/anzol.svg";
import sal from "assets/icons/sal.svg";
import rol from "assets/icons/rol.svg";
import lenco from "assets/icons/lenco.svg";
import pa from "assets/icons/pa.svg";
import heartBorder from "assets/icons/heart_border.svg";

import './index.css';


const MIN_YEAR = 8, MAX_YEAR = 21;
const colors = [
  '#006600', '#00ace6', '#D44566', '#ffd11a', '#3DD674', '#FFBD50', '#a2b627', '#BAA424', '#eead2d', '#19829D',
  '#808080', '#BB526B', '#ff0000', '#fc719e', '#8142A8', '#e67300', '#0000e6', '#938ED8'
]
const organizations = {
  NEI: {
    name: "NEI",
    insignia: nei,
  },
  AETTUA: {
    name: "AETTUA",
    insignia: aettua,
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
}

const Modes = {
  TREE: 1,
  YEAR: 2
}


// threshold to show photos
const zoomThreshold = 1;
let lastTransform = d3.zoomIdentity.scale(0.5);
let svg, zoom, groups, labels, fainaLabels;
let searchData = [];

function separateName(name) {
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


function getFainaHierarchy({ sex, start_year, organizations }, end_year) {
  if (organizations)
    for (const o of organizations) {
      if (o.name === "CF" && o.year === end_year && o.role) return o.role;
      if (o.name === "ST" && o.year === end_year) return o.role;
    }

  const maleHierarchies = ["Junco", "Moço", "Marnoto", "Mestre"];
  const femaleHierarchies = ["Caniça", "Moça", "Salineira", "Mestre"];

  const index = Math.min(end_year - start_year - 1, 3);
  return (sex === "M") ? maleHierarchies[index] : femaleHierarchies[index];
}


function showLabelFaina({ fainaNames, start_year }, end_year) {
  if (fainaNames && start_year + 1 <= end_year) {
    return true;
  }
  return false;
}


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


function buildTree() {
  const assignInsignias = () => {
    const insignias = ["nei", "aettua"];
    const i = Math.floor(Math.random() * insignias.length * 2);
    return insignias.slice(i);
  }

  for (const elem of data.users) {
    // Create faina names
    elem.names = separateName(elem.name);
    if (elem.faina && elem.faina[0]?.name) {
      elem.fainaNames = separateName(
        getFainaHierarchy(elem, MAX_YEAR) + " " + elem.faina?.[0].name);
    }

    // Create organizations
    elem.insignias = elem.organizations?.map(o => {
      if (o.name !== "ST")
        return o.name;
      return {
        "Mestre Escrivão": "escrivao",
        "Mestre Pescador": "pescador",
        "Mestre do Salgado": "salgado"
      }[o.role];
    }).filter((v, i, a) => a.indexOf(v) === i) || [];
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
    .filter((a) => a.children || a.data.start_year > 14)  // TODO: do something
    .sort((a, b) => a.family_depth - b.family_depth || a.family_count - b.family_count)
    .reduceRight((acc, val, i) => {
      return i % 2 === 0 ? [...acc, val] : [val, ...acc];
    }, []);

  const treeStructure = d3.tree()
    // .size(view)
    .nodeSize([100, 150])
    .separation(function (a, b) {
      return a.family !== b.family ? 4 : a.parent !== b.parent ? 1.25 : 1;
    });

  const root = treeStructure(dataStructure);

  // clean svg
  d3.select("svg.treeei")
    .selectAll("*:not(defs, defs *)")
    .remove();

  zoom = d3.zoom()
    .scaleExtent([0.3, 3])
    .on("zoom", ({ transform }) => zoomed(transform));

  svg = d3.select("svg.treeei")
    .call(zoom)
    .append("g")

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
    .filter(d => d.parent !== root)
    .append("path")
    .style("stroke", "silver")
    .attr('marker-start', 'url(#dot)')
    .attr("d", function (d) {
      const sx = d.parent.x,
        sy = d.parent.y + 68,
        tx = d.x,
        ty = d.y,
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
    .duration(3000)
    .ease(d3.easeLinear)
    .attr("stroke-dashoffset", 0);

  const nodes = groups
    .append("g")
    .attr("class", "node")
    .attr("transform", d => `translate(${d.x},${d.y})`);

  // node images
  d3.select("defs")
    .selectAll("pattern.image")
    .data(root.descendants().slice(1).filter(d => !!d.data.image))
    .enter()
    .append("pattern")
    .attr("id", d => d.data.id)
    .attr('width', 1)
    .attr('height', 1)
    .attr('patternContentUnits', 'objectBoundingBox')
    .append("image")
    .attr("xlink:xlink:href", d => process.env.PUBLIC_URL + '/treeei/optimized/' + d.data.image + '.jpeg')
    .attr("height", 1)
    .attr("width", 1)
    .attr("preserveAspectRatio", "xMidYMid slice");

  const getNodeImageId = (d) => {
    return d.data.image ? d.data.id :
      d.data.sex === "M" ? "default_male" : "default_female";
  }

  // circle with the person image
  const nodesProfilePic = nodes
    .append("circle")
    .attr("class", "profile-pic")
    .attr("cx", 0)
    .attr("cy", 0)
    .attr("r", 10)
    .style("fill", d => `url(#${getNodeImageId(d)})`);

  nodes
    .insert("g", "circle.profile-pic")
    .attr("class", "insignias")
    .selectAll("rect")
    .data(d => d.data.insignias)
    .enter().append("rect")
    .attr("class", d => `insignia ${d}`)
    .attr("x", -5)
    .attr("y", -5)
    .style("opacity", 0)
    .attr("width", 10)
    .attr("height", 10)
    .style("fill", d => `url(#${d})`);

  // circle with the gradient year color
  const nodesProfileGrad = nodes
    .append("circle")
    .attr("class", "profile-grad")
    .attr("cx", 0)
    .attr("cy", 0)
    .attr("r", 10)
    .attr("opacity", 1)
    .style("cursor", d => d.data.insignias?.length > 0 ? "pointer" : "default")
    .style("fill", d => colors[d.data.start_year % colors.length])
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
  const nodesProfileBorder = nodes
    .insert("circle", "circle")
    .attr("class", "profile-border")
    .attr("cx", 0)
    .attr("cy", 0)
    .attr("r", 12)

  const nodesHeartBorder = nodes
    .filter(d => d.data.nmec === 76368)
    .insert("circle")
    .attr("r", 24)
    .style("filter", `brightness(1.3)`)
    .style("fill", `url(#heart_border)`);

  labels = groups
    .append("g")
    .attr("class", "label")
    .attr("transform", d => `translate(${d.x},${d.y + 18})`);

  fainaLabels = labels
    .filter(d => d.data.fainaNames)
    .classed("label-faina", true)

  // nodes' names
  labels
    .append("text")
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

  // nodes' faina names
  fainaLabels
    .append("text")
    .classed("text-faina", true)
    .attr("x", 0)
    .attr("y", 0)
    .attr("text-anchor", "middle")
    .append("tspan")
    .attr('x', 0)
    .attr('dy', '1.2em')
    .text(d => d.data.fainaNames.tname1)
    .append("tspan")
    .attr('x', 0)
    .attr('dy', '1.2em')
    .text(d => d.data.fainaNames.tname2);

  const labelsTooltips = groups
    .filter(d => d.data.names.isTruncated)
    .append("g")
    .attr("class", "label label-tooltip")
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

  labelsTooltips
    .append("text")
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
      x: node.x, y: node.y
    })
  )

  function updateNodes(close) {
    nodesProfilePic
      .style("fill", d => close ? `url(#${getNodeImageId(d)})` : "none")
      .transition().duration(300)
      .attr("r", close ? 18 : 10);

    nodesProfileGrad
      .attr("opacity", d => close ? (d.data.image ? 0 : 0.4) : 1)
      .transition().duration(300)
      .attr("r", close ? 18 : 10);

    nodesProfileBorder
      .style("stroke", d => close ? colors[d.data.start_year % colors.length] : "silver")
      .transition().duration(300)
      .attr("r", close ? 20 : 12);

    nodesHeartBorder
      .transition()
      .delay(close ? 200 : 0)
      .duration(close ? 400 : 0)
      .ease(d3.easeCubicOut)
      .style("opacity", d => close ? 1 : 0)

    labels
      .classed('label-small', close)
      .transition().duration(300)
      .attr("transform", d => `translate(${d.x},${d.y + (close ? 26 : 18)})`);

    labelsTooltips
      .classed('label-small', close)
      .transition().duration(300)
      .attr("transform", d => `translate(${d.x},${d.y + (close ? 26 : 18)})`);
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

  zoom.translateExtent([[x0, y0], [x1, y1]]);
}


function centerTree() {
  const rect = d3.select("svg.treeei").node().getBoundingClientRect();
  const { x, y, width, height } = svg.node().getBBox();

  let offsetY = (rect.height - height * lastTransform.k) / 2 - y * lastTransform.k;
  let offsetX = (rect.width - width * lastTransform.k) / 2 - x * lastTransform.k;

  d3.select("svg.treeei").call(zoom.transform, d3.zoomIdentity.translate(offsetX, offsetY).scale(0.5));
}


function filterTree(names, end_year) {
  groups
    .attr("opacity", d => {
      if (d.data.start_year > end_year)
        return 0.2;
      if (names.length === 0)
        return 1;
      if (d.data.insignias.some(n => names.includes(n)))
        return 1;
      return 0.2;
    });

  fainaLabels
    .filter(function (d) {
      const n = d3.select(this);
      if (showLabelFaina(d.data, end_year)) {
        const hierarchy = getFainaHierarchy(d.data, end_year);
        d.data.fainaNames = separateName(
          hierarchy + " " + d.data.faina?.[0].name)
        n.classed("label-faina", true);
        return true;
      }
      n.classed("label-faina", false);
      return false;
    })
    .select('text.text-faina')
    .select("tspan")
    .text(d => d.data.fainaNames.tname1)
    .append("tspan")
    .attr('x', 0)
    .attr('dy', '1.2em')
    .text(d => d.data.fainaNames.tname2);
}

function changeLabels(showFainaNames) {
  fainaLabels
    .classed("show", showFainaNames);
}


function FainaTree() {
  const [auth, setAuth] = useState(!!localStorage.getItem('treeei'));
  const [pass, setPass] = useState("");
  const [showInfo, setShowInfo] = useState(false);
  const [expanded, setExpanded] = useState(false);
  const [mode, setMode] = useState(Modes.TREE);
  const [endYear, setEndYear] = useState(MAX_YEAR);
  const [insignias, setInsignias] = useState([]);
  const [year, setYear] = useState(MAX_YEAR);
  const [fainaNames, setFainaNames] = useState(false);
  const theme = useTheme(state => state.theme);

  const validatePass = () => {
    if (pass.toLowerCase() === 'ei2022') {
      localStorage.setItem('treeei', true);
      setAuth(true);
    }
  }

  const toggleShowInfo = () => {
    setShowInfo(!showInfo);
  }

  const toggleExpand = () => {
    setExpanded(!expanded);
  }

  const toggleMode = () => {
    setMode(mode === Modes.TREE ? Modes.FAINA : Modes.TREE);
  }

  const toggeFainaNames = () => {
    changeLabels(!fainaNames);
    setFainaNames(!fainaNames);
  }

  const toggleInsignias = (name) => {
    const i = insignias.indexOf(name);

    if (i !== -1)
      insignias.splice(i, 1);
    else
      insignias.push(name);

    setInsignias([...insignias]);
  }


  const handleSearchChange = (event, value) => {
    if (!value) return;
    // TODO: join transitions
    d3.select("svg.treeei").call(zoom.scaleTo, 2.5);
    d3.select("svg.treeei").transition().call(zoom.translateTo, value.x, value.y);
  }

  useEffect(() => {
    if (auth) {

      buildTree();
      centerTree();
    }
  }, [auth])

  useEffect(() => {
    if (auth)
      filterTree(insignias, year);
  }, [insignias, year, auth])

  if (auth) {
    return (
      <div id="treeei" className={classNames("d-flex flex-grow-1", { "expand": expanded })}>
        <div className='side-bar'>
          <button className='side-bar-button' onClick={toggleShowInfo}>
            <span>
              <FontAwesomeIcon
                icon={showInfo ? faAngleLeft : faAngleRight}
                size={"sm"} />
            </span>
          </button>
          <div className={classNames("side-bar-body", { "hide": !showInfo })}>
            <div className='side-bar-content'>
              <div className='mb-3'>
                <div className="d-flex align-items-center justify-content-around" style={{ minHeight: 32 }}>
                  <FontAwesomeIcon
                    onClick={toggleExpand}
                    className="menu-icon"
                    icon={expanded ? faCompress : faExpand}
                    size="lg" />
                  <FontAwesomeIcon
                    style={{ cursor: "not-allowed", opacity: 0.25 }}
                    onClick={toggleMode}
                    className="menu-icon"
                    icon={mode === Modes.TREE ? faGripHorizontal : faSitemap}
                    size={mode === Modes.TREE ? "2x" : "lg"} />
                </div>
              </div>


              <h4>Procurar</h4>
              <Autocomplete
                id="country-select-demo"
                sx={{ width: 200 }}
                options={searchData}
                onChange={handleSearchChange}
                autoHighlight
                freeSolo
                getOptionLabel={(option) => `${option.name}`}
                renderOption={(props, option) => (
                  <Box {...props} key={`${option.id}`} component="li">
                    <div className="color-bullet" style={{ backgroundColor: option.color }}></div>
                    {option.name}
                  </Box>
                )}
                renderInput={(params) => (
                  <TextField
                    {...params}
                    sx={{
                      mt: 1, flex: 1,
                      '& legend': { display: 'none' },
                      '& fieldset': { top: 0, borderColor: 'var(--border) !important' },
                      '& .MuiOutlinedInput-root': { padding: '4px', color: 'var(--text-primary)' },
                    }}
                    placeholder="Nome..."
                    InputLabelProps={{ className: "autocompleteLabel" }}
                    inputProps={{
                      ...params.inputProps,
                      autoComplete: 'off', // disable autocomplete and autofill
                    }}
                  />
                )}
              />

              <h4>Nomes</h4>
              <div className="mt-3">
                <div className="mb-2"
                  style={{ fontWeight: fainaNames ? 400 : 300, opacity: fainaNames ? 1 : 0.7, cursor: "pointer" }}
                  onClick={toggeFainaNames}
                >
                  Mostrar nomes de faina
                </div>
              </div>

              <h4>Matrículas</h4>
              <div className='d-flex justify-content-between my-3 p-1'>
                <div className='mr-3'>
                  <div style={{ marginBottom: "0.2em" }}>
                    <FontAwesomeIcon
                      onClick={() => setEndYear((endYear) => Math.max(--endYear, MIN_YEAR + 9))}
                      style={endYear === MIN_YEAR + 9 ? { opacity: 0.5 } : { cursor: "pointer" }}
                      icon={faArrowUp}
                      size="sm" />
                  </div>
                  {
                    [...Array(5).keys()].map(i => endYear - 9 + i).map(i => (
                      <div key={i} className={classNames("color-legend", { "inactive": i > year })}
                        onClick={() => setYear(i)}
                      >
                        <div className="color-bullet"
                          style={{ backgroundColor: colors[(i) % colors.length] }}></div>
                        {2000 + i}
                      </div>
                    ))
                  }
                </div>
                <div className='mr-3'>
                  {
                    [...Array(5).keys()].map(i => endYear - 4 + i).map(i => (
                      <div key={i} className={classNames("color-legend", { "inactive": i > year })}
                        onClick={() => setYear(i)}
                      >
                        <div className="color-bullet"
                          style={{ backgroundColor: colors[(i) % colors.length] }}></div>
                        {2000 + i}
                      </div>
                    ))
                  }
                  <div style={{ marginBottom: "0.2em" }}>
                    <FontAwesomeIcon
                      onClick={() => setEndYear((endYear) => Math.min(++endYear, MAX_YEAR))}
                      style={endYear === MAX_YEAR ? { opacity: 0.5 } : { cursor: "pointer" }}
                      icon={faArrowDown}
                      size="sm" />
                  </div>
                </div>

              </div>
              <h4>Insígnias</h4>
              <div className="mr-auto mt-3">
                {
                  Object.entries(organizations).map(([key, org]) => (
                    <div key={key} className={classNames("insignia", { "inactive": insignias.length !== 0 && !insignias.includes(key) })}
                      onClick={() => toggleInsignias(key)}>
                      <img src={org.insignia} style={org.changeColor && theme === "dark" ? { filter: "invert(1)" } : {}} />
                      <div>{org.name}</div>
                    </div>
                  ))
                }
              </div>
            </div>
          </div>
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
            <pattern id="heart_border" width="1" height="1" patternContentUnits="objectBoundingBox">
              <image xlinkHref={heartBorder} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
            </pattern>
            <pattern id="default_male" width="1" height="1" patternContentUnits="objectBoundingBox">
              <image xlinkHref={malePic} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
            </pattern>
            <pattern id="default_female" width="1" height="1" patternContentUnits="objectBoundingBox">
              <image xlinkHref={femalePic} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
            </pattern>
            <pattern id="NEI" width="1" height="1" patternContentUnits="objectBoundingBox">
              <image xlinkHref={nei} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
            </pattern>
            <pattern id="AETTUA" width="1" height="1" patternContentUnits="objectBoundingBox">
              <image xlinkHref={aettua} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
            </pattern>
            <pattern id="CF" width="1" height="1" patternContentUnits="objectBoundingBox">
              <image xlinkHref={anzol} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
            </pattern>
            <pattern id="CS" width="1" height="1" patternContentUnits="objectBoundingBox">
              <image xlinkHref={sal} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
            </pattern>
            <pattern id="escrivao" width="1" height="1" patternContentUnits="objectBoundingBox">
              <image xlinkHref={rol} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
            </pattern>
            <pattern id="pescador" width="1" height="1" patternContentUnits="objectBoundingBox">
              <image xlinkHref={lenco} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
            </pattern>
            <pattern id="salgado" width="1" height="1" patternContentUnits="objectBoundingBox">
              <image xlinkHref={pa} height="1" width="1" preserveAspectRatio="xMinYMin slice"></image>
            </pattern>
          </defs>
          <text x="100" y="100" style={{ font: "bold 300px sans-serif" }}>djfldsk</text>
        </svg>
      </div>
    )
  }

  return (
    <div style={{ display: "flex", zIndex: 1000, justifyContent: "center", alignItems: "center", flexDirection: "column", height: "80vh" }}>
      <div style={{ display: "flex", justifyContent: "center" }}>
        <TextField id="pass" placeholder="Password" type="password" label={null} variant="outlined"
          sx={{
            mt: 1, flex: 1,
            '& legend': { display: 'none' },
            '& fieldset': { top: 0, borderColor: 'var(--border) !important' },
            '& .MuiInputBase-input': { p: 1 },
            '& .MuiOutlinedInput-root': { padding: '4px', color: 'var(--text-primary)', },
          }}
          onChange={(e) => setPass(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && validatePass()}
          value={pass}
        />
      </div>
    </div>
  )
}

export default FainaTree;
