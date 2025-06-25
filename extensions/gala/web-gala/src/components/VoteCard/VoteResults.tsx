import GalaService from "@/services/GalaService";
import React, { useEffect } from "react";

function VoteResults() {
  const [data, setData] = React.useState<Vote[]>([]);

  useEffect(() => {
    // Function to fetch data
    const fetchData = () => {
      GalaService.vote
        .listCategories()
        .then((res) => {
          setData(res);
        })
        .catch((err) => {
          console.error(err);
        });
    };

    // Fetch data initially
    fetchData();

    // Set up interval to fetch data every 2.5 seconds
    const interval = setInterval(fetchData, 2500);

    // Cleanup interval on component unmount
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="py-20 flex flex-col items-center">
      <h1 className="text-3xl font-bold mb-4 text-dark-gold">Vote Results</h1>
      <table className="w-full my-20 text-light-gold text-center  rounded-lg overflow-hidden">
        <thead className="bg-dark-gold text-black">
          <tr>
            <th className="p-2">Category</th>
            <th className="p-2">Options</th>
            <th className="p-2">Results</th>
          </tr>
        </thead>
        <tbody>
          {data.map((item) => (
            <tr key={item._id} className="odd:bg-black/20 even:bg-black/10 border-b border-dark-gold">
              <td className="p-2 border-r border-dark-gold">{item.category}</td>
              <td className="p-2 border-r border-dark-gold">
                <ul className="divide-y divide-dark-gold">
                  {item.options.map((option, index) => (
                    <li key={index} className="py-1">{option}</li>
                  ))}
                </ul>
              </td>
              <td className="p-2">
                <ul className="divide-y divide-dark-gold">
                  {item.scores.map((score, index) => (
                    <li key={index} className="py-1">{score}</li>
                  ))}
                </ul>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
export default VoteResults;
