import React, { useEffect } from "react"
import "./index.css"
import * as d3 from 'd3';

function buildGraph() {
    // set the dimensions and margins of the diagram
    var margin = { top: 90, right: 140, bottom: 100, left: 200 },
        width = 950 - margin.left - margin.right,
        height = 700 - margin.top - margin.bottom,
        separationConstant = 1;

    var treeData =
    {
        a: '&nbsp;',
        b: "Hammarby",
        score: "spelas nu",
        children: [
            {
                a: '&nbsp;',
                b: '&nbsp;',
                win: false,
                children: [
                    {
                        a: '&nbsp;',
                        b: '&nbsp;',
                        win: false,
                        children: [
                            {
                                a: 'Halmstads BK',
                                b: 'Hammarby',
                                ascore: 3,
                                bscore: 1,
                                win: false,
                            },
                            {
                                a: 'IFK Norrköping',
                                b: 'Östersunds FK',
                                win: false,
                            },
                        ]
                    },
                    {
                        a: '&nbsp;',
                        b: 'Malmö FF',
                        win: false,
                        children: [
                            {
                                a: 'Halmstads BK',
                                b: 'Hammarby',
                                win: false,
                            },
                            {
                                a: 'Malmö FF',
                                b: 'Östersunds FK',
                                ascore: 1,
                                bscore: 0,
                                win: true,
                            },
                        ]
                    },
                ]
            },
            {
                a: 'Halmstads BK',
                b: 'Hammarby',
                ascore: 0,
                bscore: 1,
                win: true,
                children: [
                    {
                        a: 'Halmstads BK',
                        b: 'Östersunds FK',
                        ascore: 3,
                        bscore: 1,
                        win: true,
                        children: [
                            {
                                a: 'Halmstads BK',
                                b: 'Hammarby',
                                ascore: 1,
                                bscore: 0,
                                win: true,
                            },
                            {
                                a: 'IFK Norrköping',
                                b: 'Östersunds FK',
                                ascore: 2,
                                bscore: 3,
                                win: true,
                            },
                        ]
                    },
                    {
                        a: 'IFK Norrköping',
                        b: 'Hammarby',
                        ascore: 2,
                        bscore: 3,
                        win: true,
                        children: [
                            {
                                a: 'Halmstads BK',
                                b: 'IFK Norrköping',
                                ascore: 0,
                                bscore: 1,
                                win: true,
                            },
                            {
                                a: 'IFK Norrköping',
                                b: 'Hammarby',
                                ascore: 1,
                                bscore: 2,
                                win: true,
                            },
                        ]
                    },
                ]
            }
        ]
    };

    // line connector between nodes
    var line = d3.line()
        .x(d => width - d.y)
        .y(d => d.x)
        .curve(d3.curveStep);

    // declares a tree layout and assigns the size
    var treemap = d3.tree()
        .size([height, width])
        .separation((a, b) => a.parent == b.parent ? 1 : separationConstant);

    //  assigns the data to a hierarchy using parent-child relationships
    var nodes = d3.hierarchy(treeData);

    // maps the node data to the tree layout
    nodes = treemap(nodes);

    var svg = d3.select("#bracket")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom);

    var g = svg.append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    // adds the links between the nodes
    var link = g.selectAll(".link")
        .data(nodes.descendants().slice(1))
        .enter().append("path")
        .attr("class", "link")
        .attr("d", d => line([d, d.parent]))
        .classed("win", d => d.data.win)

    // adds labels to the nodes
    function gameTemplate(d) {
        return '' +
            "<div class='row-bracket" + (d.data.ascore > d.data.bscore ? ' winner' : '') + "'>" +
            "<span class='cell name'>" + d.data.a + "</span>" +
            "<span class='cell score'>" + (d.data.ascore >= 0 ? d.data.ascore : '') + "</span>" +
            "</div>" +

            "<div class='row-bracket" + (d.data.bscore > d.data.ascore ? ' winner' : '') + "'>" +
            "<span class='cell name'>" + (d.data.b || '') + "</span>" +
            "<span class='cell score'>" + (d.data.bscore >= 0 ? d.data.bscore : '') + "</span>" +
            "</div>";
    }

    var labels = d3.select('#labels')
        .selectAll('div')
        .data(nodes.descendants())
        .enter()
        .append("div")
        .classed("table-bracket", true)
        .classed("played", d => (d.data.ascore || d.data.bscore))

        .style('left', d => (width - d.y + margin.left - 100) + 'px')
        .style('top', d => (d.x + (!d.data.b ? 12 : 0) + (!d.data.children ? - 4 : 0) + 10) + 'px')
        .html(d => gameTemplate(d))

    // third place
    var thrdData = {
        data: {
            a: '&nbsp;',
            b: 'Halmstad BK',
        }
    };

    var thrd = d3.select('#labels').append("div")
        .classed("thirdplace", true)
        .style('position', 'absolute')
        .style('left', width - 175 + 'px')
        .style('top', (height) / 2 + margin.top - 48 + 'px')

    thrd
        .append("div")
        .classed("title", true)
        .html('Tredjeplats');

    thrd
        .append("div")
        .classed("content", true)
        .html(d => gameTemplate(thrdData));
}

const SportsBracket = (props) => {

    useEffect(() => {
        buildGraph()
    }, [])

    return (
        <>
            <div id="container">
                <svg id="bracket"></svg>
                <div id="labels"></div>
            </div>

            <svg>
                
            </svg>
        </>
    );
}

export default SportsBracket;
