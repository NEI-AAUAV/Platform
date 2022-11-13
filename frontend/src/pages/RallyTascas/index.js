import { Button, Col, Row } from "@nextui-org/react";
import React from "react";
import InfoTable from "./components/InfoTable";
import ModalTeam from "./components/NewTeam/ModalTeam";

const RallyTascas = () => {
  const [visible, setVisible] = React.useState(false);
  const teamModalHandler = () => setVisible(true);

  return (
    <Col>
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
          Ver Mapa
        </Button>
        <Button shadow color="secondary" auto onClick={teamModalHandler}>
          Criar Equipa
        </Button>
        <ModalTeam visible={visible} setVisible={setVisible} />
      </Row>
      <InfoTable />
    </Col>
  );
};

export default RallyTascas;
