import { Button, Col, Row } from "@nextui-org/react";
import React from "react";
import DetailsModal from "../Details/DetailsModal";

function FirstPlace(props) {
  const [visibleDetails, setVisibleDetails] = React.useState(false);
  const [selectedTeam, setSelectedTeam] = React.useState(null);

  const detailsModalHandler = () => {
    setVisibleDetails(true);
  };

  return (
    <>
      <Row
        style={{
          backgroundColor: "rgba(252, 133, 81, 0.3)",
          color: "white",
          border: "1px solid #FC8551",
          borderRadius: "10px",
          fontSize: "1rem",
          fontWeight: "bold",
          paddingLeft: "1rem",
          marginTop: "3rem",
          marginBottom: "1rem",
          display: "flex",
          flexDirection: "row",
          justifyContent: "space-around",
          alignItems: "center",
        }}
      >
        <Col>{props.selectedTeam.position}</Col>
        <Col>{props.selectedTeam.teamName}</Col>
        <Col
          css={{
            marginTop: "0.8rem",
          }}
        >
          <p>{props.selectedTeam.lastCheckPoint}</p>
          <p>{props.selectedTeam.timeOfCheckpoint}</p>
        </Col>
        <Col>{props.selectedTeam.total}</Col>
        <Col>
          <Button
            onClick={() => {
              setSelectedTeam(props.selectedTeam);
              detailsModalHandler();
            }}
            className="btn-icon btn-round"
            size="sm"
            css={{
              backgroundColor: "#ed7f38",
              color: "black",
              fontWeight: "bold",
              padding: "0",
              margin: "0",
            }}
          >
            Ver Equipa
          </Button>
        </Col>
      </Row>
      {visibleDetails && (
        <DetailsModal
          visible={visibleDetails}
          setVisible={setVisibleDetails}
          selectedTeam={selectedTeam}
        />
      )}
    </>
  );
}

export default FirstPlace;
