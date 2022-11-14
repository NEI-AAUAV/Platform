import React from "react";
import { Table } from "react-bootstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faCheckCircle,
  faTimesCircle,
  faMinusCircle,
  faAngleUp,
  faAngleDown,
  faAngleDoubleDown,
} from "@fortawesome/free-solid-svg-icons";
import "./index.css";

const SportTable = (props) => {
  const UpArrow = <FontAwesomeIcon icon={faAngleUp} className="up" />;
  const DownArrow = <FontAwesomeIcon icon={faAngleDown} className="down" />;
  const GameDraw = <FontAwesomeIcon icon={faMinusCircle} className="draw" />;
  const GameWon = <FontAwesomeIcon icon={faCheckCircle} className="win"/>;
  const GameLost = <FontAwesomeIcon icon={faTimesCircle} className="lose"/>;
  const DoubleDownArrow = (
    <FontAwesomeIcon icon={faAngleDoubleDown} className="down" />
  );

  const header = [
    {
      head_team: "Equipa",
      head_games: "Jogos",
      head_points: "Pontos", 
      head_vict: "Vitórias",
      head_draws: "Empates", 
      head_defeats: "Derrotas", 
      head_scoredg: "Golos Marcados", 
      head_soufferedg: "Golos Sofridos", 
      head_divison: "Divisão",
      head_lastgames: "Últimos 5 jogos"
    }
  ];

  const data = [
    {
      position_team: {icon: UpArrow,pos: 1,team: "Eng. Informática"},
      games: "test",
      points: "test1",
      victories: "test2",
      draws: "test3",
      defeats: "test4",
      scored_goals: "test5",
      souffered_goals: "test6",
      divison_group: "test7",
      last_games: [GameWon,GameDraw,GameWon,GameLost,GameWon]
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
      last_games: [GameLost,GameWon,GameWon,GameDraw,GameLost]
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
      last_games: [GameDraw,GameWon,GameLost,GameDraw,GameWon]
    },
  ];

  return (
    <>
      <div className="divcss">
        <Table className={"mb-5 tablecss"}>
          <thead>
            {header.map((row,index) => 
              <tr className="tableheader" key={index}>
                <td className="headcol">{row.head_team}</td>
                <td>{row.head_games}</td>
                <td>{row.head_points}</td>
                <td>{row.head_vict}</td>
                <td>{row.head_draws}</td>
                <td>{row.head_defeats}</td>
                <td>{row.head_scoredg}</td>
                <td>{row.head_soufferedg}</td>
                <td>{row.head_divison}</td>
                <td>{row.head_lastgames}</td>
              </tr>
            )}
          </thead>
          <tbody>
            {data.map((row,index) =>
              <tr key={index}>
                <td className="headcol">
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
      </div>
    </>
  );
};

 export default SportTable;
