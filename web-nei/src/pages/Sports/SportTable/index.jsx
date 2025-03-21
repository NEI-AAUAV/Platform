import React from "react";
import "./index.css";

const SportTable = (props) => {
  const data = [
    ["test", "tes2t1", "test2"],
    ["test6", "test7", "test8"],
    ["test9", "test10", "test11"],
  ];

  return (
    <Table
      responsive
      className={"text-center mb-5 border tablecss"}
      //style={{animationDelay: props.animKey ? props.animKey*0.2+"s" : "0"}}
    >
      {data.map((row, index) => {
        return (
          <tr key={index}>
            {row.map((col) => (
              <td>{col}</td>
            ))}
          </tr>
        );
      })}
    </Table>
  );
};

export default SportTable;
