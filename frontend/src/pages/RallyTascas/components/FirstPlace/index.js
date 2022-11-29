import { Button, Col, Row, Tooltip } from "@nextui-org/react";
import React from "react";
import DetailsModal from "../Details/DetailsModal";
import { suffix_for_ordinal } from "../LeaderBoard"
import { EyeIcon } from "../Icons/EyeIcon";
import { IconButton } from '../Customized'


function FirstPlace({ team, mobile, checkpoints }) {
  const [visibleDetails, setVisibleDetails] = React.useState(false);
  const [selectedTeam, setSelectedTeam] = React.useState(null);
  const checkpoint = checkpoints.find(c => c.id === team.times?.length);

  const detailsModalHandler = () => {
    setVisibleDetails(true);
  };

  return (
    <div style={{overflowY: 'auto'}}>
      <Row css={{d: 'table-layout', ...styles.container, py: mobile ? "1rem" : '0.625rem', px: mobile ? "1rem" : "calc(30px + 1rem)", textAlign: 'left', flexDirection: 'row', minWidth: 436}}>
        <Col span={mobile ? 2 : 3.5}>{team.classification}{suffix_for_ordinal(team.classification)}</Col>
        <Col>{team.name}</Col>
        {
          !mobile &&
          <Col
            css={{
              marginTop: "0.8rem",
            }}
            span={6}
          >
            <p>{checkpoint ? `${checkpoint.id} - ${checkpoint.name}` : '---'}</p>
            <p>{team.times.at(-1)?.split('T').at(-1) || '---'}</p>
          </Col>
        }
        <Col span={mobile ? 2.5 : 4}>{team.total} pts</Col>
        <Col
          css={{
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
          }}
          span={mobile ? 2.5 : 7}
        >
          {
            mobile ?
              <Tooltip content="Details">
                <IconButton
                  onClick={() => {
                    setSelectedTeam(team);
                    detailsModalHandler();
                  }}
                >
                  <EyeIcon size={20} fill="#FFFFFF" />
                </IconButton>
              </Tooltip>
              :
              <Button
                onClick={() => {
                  setSelectedTeam(team);
                  detailsModalHandler();
                }}
                className="btn-icon btn-round"
                size="sm"
                css={{ ...styles.button, marginRight: 'auto' }}
              >
                Ver Equipa
              </Button>
          }
        </Col>
      </Row>
      {visibleDetails && (
        <DetailsModal
          visible={visibleDetails}
          setVisible={setVisibleDetails}
          checkpoints={checkpoints}
          team={selectedTeam}
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
