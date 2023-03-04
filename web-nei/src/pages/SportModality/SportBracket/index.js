import "./index.css";
import * as d3 from "d3";
import { useEffect } from "react";
import { renderToStaticMarkup } from "react-dom/server";

const SportMatch = ({
  id,
  x,
  y,
  team1,
  team2,
  score1,
  score2,
  live,
  horizontal,
}) => (
  <g
    transform={`translate(${y - 160},${x - 35})`}
    className={"match " + (live ? "-open" : "-pending")}
    data-identifier="16"
    data-match-id="288716770"
  >
    <defs>
      <clipPath id="match-clippath-8">
        <rect x="14" y="0" width="280" height="70" rx="10" ry="10"></rect>
      </clipPath>
    </defs>
    <text
      x="0"
      y="35"
      dy="6"
      width="24"
      textAnchor="middle"
      className="match--identifier"
    >
      {id}
    </text>
    {live && (
      <rect
        x="14"
        y="0"
        width="284"
        height="74"
        rx="10"
        ry="10"
        className="match--wrapper-background -underway"
      ></rect>
    )}
    <rect
      x="16"
      y="2"
      width="280"
      height="70"
      rx="10"
      ry="10"
      className="match--base-background"
    ></rect>

    {horizontal ? (
      <svg
        x="16"
        y="2"
        className="match--player"
        data-participant-id="179891148"
      >
        <text
          x="90"
          y="55"
          dy="7"
          textAnchor="end"
          className="match--team-name"
        ></text>
        <image href="/NEI_2_white.png" x="25" y="-6" height="82" width="82" />

        <text
          x="140"
          y="35"
          dy="8"
          textAnchor="middle"
          className="match--score"
        >
          {score1} - {score2}
        </text>

        <image href="/nei.png" x="173" y="-6" height="82" width="82" />
        <text
          x="190"
          y="55"
          dy="7"
          textAnchor="start"
          className="match--team-name"
        ></text>
      </svg>
    ) : (
      <svg
        x="16"
        y="2"
        className="match--player"
        data-participant-id="179891148"
      >
        <text x="50" y="15" dy="7" className="match--team-name">
          {team1}
        </text>
        <image href="/NEI_2_white.png" x="7" y="3" height="40" width="40" />

        <text
          x="260"
          y="15"
          dy="8"
          textAnchor="middle"
          className="match--score"
        >
          {score1}
        </text>
        <text
          x="260"
          y="50"
          dy="8"
          textAnchor="middle"
          className="match--score"
        >
          {score2}
        </text>

        <image href="/NEET.png" x="7" y="33" height="40" width="40" />
        <text x="50" y="50" dy="7" className="match--team-name">
          {team2}
        </text>
      </svg>
    )}

    {/* <text x="211" y="59" width="21" height="25" textAnchor="middle" className="match--fa-icon" data-tooltip="Report Scores"></text> */}
  </g>
);

function buildBracket() {
  let treeDataRaw = [
    {
      id: 1,
      pid1: null,
      pid2: null,
      team1: "Eng. Informatica",
      team2: "Eng. Mecanica",
      score1: 10,
      score2: 1,
    },
    {
      id: 2,
      pid1: null,
      pid2: null,
      team1: "Eng. Materiais",
      team2: "Eng. Mecanica",
      score1: 11,
      score2: 2,
    },
    {
      id: 3,
      pid1: null,
      pid2: null,
      team1: "Eng. Informatica",
      team2: "Eng. Mecanica",
      score1: 21,
      score2: 12,
    },
    {
      id: 4,
      pid1: null,
      pid2: null,
      team1: "Ciências Biomédica",
      team2: "Eng. Mecanica",
      score1: 2,
      score2: 12,
    },
    {
      id: 5,
      pid1: 1,
      pid2: 2,
      team1: "EGI",
      team2: "Biologia",
      score1: 3,
      score2: 5,
    },
    {
      id: 6,
      pid1: 3,
      pid2: 4,
      team1: "Geologia",
      team2: "MOG",
      score1: 0,
      score2: 1,
    },
    {
      id: 7,
      pid1: 5,
      pid2: 6,
      parentId: null,
      team1: "Eng. quimica",
      team2: "ESSUA",
      score1: 2,
      score2: 1,
    },
  ];

  treeDataRaw = treeDataRaw.reduce((a, m) => ({ ...a, [m.id]: m }), {});

  Object.entries(treeDataRaw).map(([id, match]) => {
    if (match.pid1) treeDataRaw[match.pid1]["parentId"] = +id;
    if (match.pid2) treeDataRaw[match.pid2]["parentId"] = +id;
  });

  const treeData = d3
    .stratify()
    .id((d) => d.id)
    .parentId((d) => d.parentId)(Object.values(treeDataRaw));

  // Set the dimensions and margins of the diagram
  const margin = { top: 20, right: 90, bottom: 30, left: 90 },
    width = 900 - margin.left - margin.right,
    height = 942 - margin.top - margin.bottom;

  // Declares a tree layout and assigns the size
  const treemap = d3.tree().size([height, width]);

  //  assigns the data to a hierarchy using parent-child relationships
  let nodes = d3.hierarchy(treeData, (d) => d.children);

  // Maps the node data to the tree layout
  nodes = treemap(nodes);

  // Append the svg object to the body of the page
  // Appends a 'group' element to 'svg'
  // Moves the 'group' element to the top left margin
  const svg = d3
      .select("svg.bracket-svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom),
    g = svg
      .append("g")
      .attr(
        "transform",
        "translate(" +
          (width + margin.left) +
          "," +
          margin.top +
          ") scale(-1, 1)"
      );

  // Adds the links between the nodes
  const link = g
    .selectAll(".link")
    .data(nodes.descendants().slice(1))
    .enter()
    .append("path")
    .attr("class", "link")
    .style("stroke", (d) => d.data.level)
    .attr("d", (d) =>
      d3
        .line()
        .x((p) => p[0])
        .y((p) => p[1])
        .curve(d3.curveStep)([
        [d.y - 150, d.x],
        [d.parent.y + 170, d.parent.x],
      ])
    );

  // Adds each node as a group
  const node = g
    .selectAll(".node")
    .data(nodes.descendants())
    .enter()
    .append("g")
    .attr(
      "class",
      (d) => "node" + (d.children ? " node--internal" : " node--leaf")
    )
    .attr("transform", "scale(-1, 1)")
    .each(function (d) {
      d3.select(this).html(
        renderToStaticMarkup(
          <SportMatch
            id="3"
            team1="NMec"
            team2="NEI"
            score1="20"
            score2="90"
            x={d.x}
            y={-d.y}
          />
        )
      );
    });

  // // Adds the circle to the node
  // node.append("circle")
  //   .attr("r", 10)
  //   .style("stroke", "white")
  //   .style("fill", "black");

  // // Adds the text to the node
  // node.append("text")
  //   .attr("dy", ".35em")
  //   .attr("x", d => d.children ? (d.data.value + 5) * -1 : d.data.value + 5)
  //   .attr("y", d => d.children && d.depth !== 0 ? -(d.data.value + 5) : d)
  //   .style("text-anchor", d => d.children ? "end" : "start")
  //   .text(d => d.data.name);
}

const SportBracket = () => {
  useEffect(() => {
    buildBracket();
  }, []);

  return (
    <>
      <svg
        className="bracket-svg"
        width="900"
        height="942"
        viewBox="0 0 900 942"
      >
        <g className="parent">
          <g>
            {/* <SportMatch id="0" team1="NAE-ESSUA" team2="NAE-ISCA" score1="10" score2="0" x={0} y={350} horizontal />
            <SportMatch id="1" team1="Eng. Informática" team2="EET" score1="2" score2="9" x={350} y={350} live />
            <SportMatch id="2" team1="NEEET" team2="NAE-ISCA" score1="5" score2="0" x={700} y={500} live horizontal />
            <SportMatch id="3" team1="NMec" team2="NEI" score1="20" score2="90" x={700} y={350} /> */}

            {/* <g transform="translate(488 260)" className="match -open " data-identifier="7" data-match-id="288716761">
              <defs>
                <clipPath id="match-clippath-7">
                  <rect x="26" y="30" width="200" height="45" rx="10" ry="10">
                  </rect>
                </clipPath>
              </defs>
              <a className="match--station-link">
                <rect x="26" y="11" rx="10" ry="10" width="200" height="25" className="match--station-background">
                </rect>
                <text x="126" y="24" width="200" height="20" textAnchor="middle" className="match--station">
                  <tspan dx="4" className="match--fa-icon"></tspan>
                  <tspan dx="4">Sun  9:09 pm WEST</tspan>
                </text>
              </a>
              <text x="11" y="56" width="24" height="10" textAnchor="middle" className="match--identifier">7</text>
              <rect x="24" y="28" width="204" height="49" rx="10" ry="10" className="match--wrapper-background -underway">
              </rect>
              <rect x="26" y="30" width="200" height="45" rx="10" ry="10" className="match--base-background">
              </rect>
              <g clip-path="url(#match-clippath-7)">
                <svg x="0" y="30" className="match--player" data-participant-id="179891156">
                  <title>golf</title>
                  <defs>
                    <clipPath id="clipPath6193537">
                      <rect x="50" y="0" width="143" height="22">
                      </rect>
                    </clipPath>
                    <clipPath id="portraitClipPath6193537">
                      <path>
                      </path>
                    </clipPath>
                  </defs>
                  <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                  </path>
                  <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                  </path>
                  <text x="38" y="14" width="10" height="12" textAnchor="middle" className="match--seed">2</text>
                  <text clip-path="url(#clipPath6193537)" x="55" y="15" width="147" height="12" textAnchor="start" className="match--team-name ">golf</text>
                </svg>
                <svg x="0" y="53" className="match--player" data-participant-id="179891155">
                  <title>catia</title>
                  <defs>
                    <clipPath id="clipPath7651391">
                      <rect x="50" y="0" width="143" height="22">
                      </rect>
                    </clipPath>
                    <clipPath id="portraitClipPath7651391">
                      <path>
                      </path>
                    </clipPath>
                  </defs>
                  <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                  </path>
                  <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                  </path>
                  <text x="38" y="14" width="10" height="12" textAnchor="middle" className="match--seed">7</text>
                  <text clip-path="url(#clipPath7651391)" x="55" y="15" width="147" height="12" textAnchor="start" className="match--team-name ">catia</text>
                  <line x1="26" y1="-0.5" x2="197" y2="-0.5" className="match--player-divider">
                  </line>
                </svg>
              </g>
              <text x="211" y="59" width="21" height="25" textAnchor="middle" className="match--fa-icon" data-tooltip="Report Scores"></text>
            </g>
            <g transform="translate(244 260)" className="match -complete " data-identifier="6" data-match-id="288716760">
              <defs>
                <clipPath id="match-clippath-6">
                  <rect x="26" y="30" width="200" height="45" rx="10" ry="10">
                  </rect>
                </clipPath>
              </defs>
              <text x="11" y="56" width="24" height="10" textAnchor="middle" className="match--identifier">6</text>
              <rect x="24" y="28" width="204" height="49" rx="10" ry="10" className="match--wrapper-background ">
              </rect>
              <rect x="26" y="30" width="200" height="45" rx="10" ry="10" className="match--base-background">
              </rect>
              <g clip-path="url(#match-clippath-6)">
                <svg x="0" y="30" className="match--player" data-participant-id="179891163">
                  <title>miro</title>
                  <defs>
                    <clipPath id="clipPath7234531">
                      <rect x="50" y="0" width="143" height="22">
                      </rect>
                    </clipPath>
                    <clipPath id="portraitClipPath7234531">
                      <path>
                      </path>
                    </clipPath>
                  </defs>
                  <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                  </path>
                  <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                  </path>
                  <text x="38" y="14" width="10" height="12" textAnchor="middle" className="match--seed">3</text>
                  <text clip-path="url(#clipPath7234531)" x="55" y="15" width="147" height="12" textAnchor="start" className="match--team-name ">miro</text>
                  <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background ">
                  </path>
                  <text x="211" y="15" width="21" height="12" textAnchor="middle" className="match--player-score ">0</text>
                </svg>
                <svg x="0" y="53" className="match--player" data-participant-id="179891160">
                  <title>carlota</title>
                  <defs>
                    <clipPath id="clipPath8701629">
                      <rect x="50" y="0" width="143" height="22">
                      </rect>
                    </clipPath>
                    <clipPath id="portraitClipPath8701629">
                      <path>
                      </path>
                    </clipPath>
                  </defs>
                  <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                  </path>
                  <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                  </path>
                  <text x="38" y="14" width="10" height="12" textAnchor="middle" className="match--seed">8</text>
                  <text clip-path="url(#clipPath8701629)" x="55" y="15" width="147" height="12" textAnchor="start" className="match--team-name  -winner">carlota</text>
                  <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background -winner">
                  </path>
                  <text x="211" y="15" width="21" height="12" textAnchor="middle" className="match--player-score -winner">1</text>
                  <line x1="26" y1="-0.5" x2="226" y2="-0.5" className="match--player-divider">
                  </line>
                </svg>
              </g>
            </g> */}
          </g>
          <g className="round-headers">
            <svg className="round-header" y="0">
              <g className="round-header-label -editable">
                <text y="25">Round 1</text>
              </g>
            </svg>
            <svg className="round-header" y="222.1065573770492">
              <g className="round-header-label -editable">
                <text y="25">Round 2</text>
              </g>
            </svg>
          </g>
        </g>
      </svg>
    </>
  );
};

export default SportBracket;
