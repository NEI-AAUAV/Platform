import GalaService from "@/services/GalaService";
import React, { useEffect } from "react";

function VoteResults() {
  const [data, setData] = React.useState<Vote[]>([]);

  useEffect(() => {
    GalaService.vote
      .listCategories()
      .then((res) => {
        setData(res);
      })
      .catch((err) => {
        console.error(err);
      });
  }, []);

  return (
    <table className="my-20">
      <thead>
        <tr>
          <th>Category</th>
          <th>Options</th>
          <th>Results</th>
        </tr>
      </thead>
      <tbody>
        {data.map((item) => (
          <tr key={item._id}>
            <td>{item.category}</td>
            <td>
              <ul>
                {item.options.map((option, index) => (
                  <li key={index}>{option}</li>
                ))}
              </ul>
            </td>
            <td>
              <ul>
                {item.scores.map((score, index) => (
                  <li key={index}>{score}</li>
                ))}
              </ul>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

export default VoteResults;
