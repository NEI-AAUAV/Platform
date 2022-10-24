import React from "react";
import { Table } from "react-bootstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faAngleUp,
  faAngleDown,
  faAngleDoubleDown,
} from "@fortawesome/free-solid-svg-icons";
import "./index.css";

// var clone = document.getElementsByClassName("main-table")[0].cloneNode(true);
 
// clone.classList.add("clone");
// document.getElementById("table-scroll").append(clone);
// // https://codepen.io/paulobrien/pen/gWoVzN - scrollable table

const SportTable = (props) => {
  const UpArrow = <FontAwesomeIcon icon={faAngleUp} className="up" />;
  const DownArrow = <FontAwesomeIcon icon={faAngleDown} className="down" />;
  const DoubleDownArrow = (
    <FontAwesomeIcon icon={faAngleDoubleDown} className="down" />
  );

  const header = [["","Pos", "Eq", "J", "P", "V", "E", "D", "GM", "GS", "DG"]];  // falta um elemento que é os últimos 5 jogos

  const data = [
    [
      UpArrow,
      "position1",
      "test",
      "test1",
      "test2",
      "test3",
      "test4",
      "test5",
      "test6",
      "test7",
      "test8",
    ],
    [
      DownArrow,
      "position2",
      "test9",
      "test10",
      "test11",
      "test12",
      "test13",
      "test14",
      "test15",
      "test16",
      "test17",
    ],
    [
      DoubleDownArrow,
      "position3",
      "test26",
      "test18",
      "test19",
      "test20",
      "test21",
      "test22",
      "test23",
      "test24",
      "test25",
    ],
  ];

  return (
    <>
      <Table stickyHeader className={"text-center mb-5 tablecss"}>
        {header.map((row) => {
          return (
            <tr>
              {row.map((col) => (
                <td>{col}</td>
              ))}
            </tr>
          );
        })}
        {data.map((row) => {
          return (
            <tr>
              {row.map((col) => (
                <td>{col}</td>
              ))}
            </tr>
          );
        })}
      </Table>
      <div className="legend">
        <h4>Legenda:</h4>
        <ul>
            <li><p><span>Pos-</span> Posição</p></li>
            <li><p><span>Eq-</span> Equipa</p></li>
            <li><p><span>P-</span> Pontos</p></li>
            <li><p><span>V-</span> Vitórias</p></li>
            <li><p><span>E-</span> Empates</p></li>
            <li><p><span>D-</span> Derrotas</p></li>
            <li><p><span>GM-</span> Golos Marcados</p></li>
            <li><p><span>GS-</span> Golos Sofridos</p></li>
            <li><p><span>DG-</span> Divisão do Grupo</p></li>
        </ul>
      </div>
    </>
  );
};

export default SportTable;
