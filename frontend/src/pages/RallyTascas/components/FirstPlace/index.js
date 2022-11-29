import { Button, Col, Row } from "@nextui-org/react";
import React from "react";
import DetailsModal from "../Details/DetailsModal";
import { suffix_for_ordinal } from "../LeaderBoard"


function FirstPlace({team, mobile, checkpoint}) {
  const [visibleDetails, setVisibleDetails] = React.useState(false);
  const [selectedTeam, setSelectedTeam] = React.useState(null);

  const detailsModalHandler = () => {
    setVisibleDetails(true);
  };

  return (
    <div style={{overflowY: 'auto'}}>
      <Row css={{...styles.container, py: "0.625rem", px: mobile ? "1rem" : "calc(30px + 1rem)", textAlign: 'left', flexDirection: 'row', minWidth: 375}}>
        <Col span={5}>{team.classification}{suffix_for_ordinal(team.classification)}</Col>
        <Col>{team.name}</Col>
        {
          !mobile &&
          <Col
            css={{
              marginTop: "0.8rem",
            }}
          >
            <p>{checkpoint ? `${checkpoint.id} - ${checkpoint.name}` : '---'}</p>
            <p>{team.times.at(-1)?.split('T').at(-1) || '---'}</p>
          </Col>
        }
        <Col>{team.total} pts</Col>
        <Col
          css={{
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
          }}
        >
          <Button
            onClick={() => {
              setSelectedTeam(team);
              detailsModalHandler();
            }}
            className="btn-icon btn-round"
            size="sm"
            css={{...styles.button, marginRight: 'auto'}}
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
    </div>
  );
}

export default FirstPlace;

const styles = {
  container: {
    backgroundColor: "rgba(252, 133, 81, 0.3)",
    color: "white",
    border: "1px solid #FC8551",
    borderRadius: "10px",
    fontSize: "1rem",
    fontWeight: "bold",
    marginTop: "3rem",
    marginBottom: "1rem",
    //media queries 320 column flex direction column
    "@media (min-width: 200px)": {
      display: "flex",
      flexDirection: "column",
      textAlign: "center",
    },

    "@media (min-width: 450px)": {
      display: "flex",
      flexDirection: "row",
      justifyContent: "space-around",
      alignItems: "center",
      width: "100%",
      height: "auto",
      marginTop: "3rem",
      marginBottom: "1rem",
    },
  },

  button: {
    backgroundColor: "#ed7f38",
    color: "black",
    fontWeight: "bold",
    padding: "0",
    margin: "0",
    "&:hover": {
      backgroundColor: "#FF4646",
    },
  },
};
