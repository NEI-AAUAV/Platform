import React, { useState, useEffect } from "react";

/**
 * alert    Object      {text: str, type:Enum(info, alert - Optional)}
 * setAlert Method      Sets alert to null when user clicks close button
 * @param {*} param0
 * @returns
 */
const Alert = ({ alert, setAlert }) => {
  const [cssclass, setCssClass] = useState("primary");

  useEffect(() => {
    switch (alert.type) {
      case "info":
        setCssClass("primary");
        break;
      case "alert":
        setCssClass("danger");
    }
  }, [alert.type]);

  if (!alert.type) return null;

  return (
    <div
      className={`d-flex flex-row text-${cssclass} bg-outline-${cssclass} font-weight-bold animation mx-auto p-2`}
    >
      <p className="col mb-0">{alert.text}</p>
    </div>
  );
};

export default Alert;
