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

  const header = [["Equipa", "Jogos", "Pontos", "Vitórias", "Empates", "Derrotas", "Golos Marcados", "Golos Sofridos", "Divisão","Últimos 5 jogos"]];  // falta um elemento que é os últimos 5 jogos

  const data = [
    {
      position_team: {icon: UpArrow,pos: 1,team: "Engenharia Informática"},
      games: "test",
      points: "test1",
      victories: "test2",
      draws: "test3",
      defeats: "test4",
      scored_goals: "test5",
      souffered_goals: "test6",
      divison_group: "test7",
      last_games:"test8"
    },
    {
      position_team: {icon: DownArrow,pos: 2,team: "Matemática"},
      games: "test9",
      points: "test10",
      victories: "test11",
      draws: "test12",
      defeats: "test13",
      scored_goals: "test14",
      souffered_goals: "test15",
      divison_group: "test16",
      last_games: "test17"
    },
    {
      position_team: {icon: DoubleDownArrow,pos: 3,team: "Biologia"},
      games: "test18",
      points: "test19",
      victories: "test20",
      draws: "test21",
      defeats: "test22",
      scored_goals: "test23",
      souffered_goals: "test24",
      divison_group: "test25",
      last_games: "test26",
    },
  ];

  return (
    <>
      <Table className={"text-center mb-5"} style={{overflowX:"auto"}}>
        <thead>
          {header.map((row) => {
            return (
              <tr className={"tableheader"}>
                {row.map((col) => (
                  <td>{col}</td>
                ))}
              </tr>
            );
          })}
        </thead>
        <tbody>
          {data.map((row) =>
            <tr>
              <td>
                <span className="iconcss">{row.position_team.icon}</span>
                <span className="positioncss">{row.position_team.pos}</span>
                <span className="teamnamecss">{row.position_team.team}</span>
              </td>
              <td>{row.games}</td>
              <td>{row.points}</td>
              <td>{row.victories}</td>
              <td>{row.draws}</td>
              <td>{row.defeats}</td>
              <td>{row.scored_goals}</td>
              <td>{row.souffered_goals}</td>
              <td>{row.divison_group}</td>
              <td>{row.last_games}</td>
            </tr>
          )}
        </tbody>
      </Table>
      {/* <div className="legend">
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
      </div> */}
    </>
  );
};

 export default SportTable;
