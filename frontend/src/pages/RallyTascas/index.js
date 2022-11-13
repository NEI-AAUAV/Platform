import { Button, Row } from "@nextui-org/react";
import React from "react";
import InfoTable from "./components/InfoTable";

const RallyTascas = () => {
  return (
    <div>
      <h2 className="text-center mb-4">Rally das Tascas |</h2>
      <Row
        css={{
          display: "flex",
          flexDirection: "row",
          justifyContent: "flex-end",
          marginBottom: "1rem",
          paddingRight: "0.5rem",
          zIndex: 1,
        }}
      >
        <Button
          css={{
            marginRight: "0.5rem",
          }}
          shadow
          color="primary"
          auto
        >
          View Map
        </Button>
        <Button shadow color="secondary" auto>
          Create Team
        </Button>
      </Row>
      <InfoTable />
    </div>
  );
};

export default RallyTascas;
