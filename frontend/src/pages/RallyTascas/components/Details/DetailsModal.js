import React from "react";
import { Modal, Text, Button, Row } from "@nextui-org/react";

function DetailsModal(props) {
  let visible = props.visible;

  const closeHandler = () => {
    props.setVisible(false);
  };

  return (
    <Modal
      aria-label="modalDetails"
      closeButton
      aria-labelledby="modal-title"
      open={visible}
      onClose={closeHandler}
      width="700px"
      css={styles.container}
    >
      <Modal.Header>
        <Text id="modal-title" color="var(--column-color)" size={18}>
          Detalhes de
          <Text b color="var(--column-color)" size={18}>
            {" "}
            {props.selectedTeam.teamName}
          </Text>
        </Text>
      </Modal.Header>
      <Modal.Body>
        <Row css={styles.row}>
          <Text
            color="var(--column-color)"
            css={{ fontWeight: "bold" }}
            size={18}
          >
            Nome da Equipa:
          </Text>
          <Text color="var(--column-color)" size={18}>
            {props.selectedTeam.teamName}
          </Text>
        </Row>
        <Row css={styles.row}>
          <Text
            color="var(--column-color)"
            css={{ fontWeight: "bold" }}
            size={18}
          >
            Pontuação
          </Text>
          <Text color="var(--column-color)" size={18}>
            {props.selectedTeam.total}
          </Text>
        </Row>
        <Row>
          <Text color="var(--column-color)" size={18}>
            Checkpoints
          </Text>
        </Row>
        {props.selectedTeam.scores.map((checkpoint) => (
          <Row key={checkpoint.id} css={styles.rowPoints}>
            <Text
              color="var(--column-color)"
              css={{ fontWeight: "bold" }}
              size={18}
            >
              P{checkpoint.id} - {checkpoint.name}
            </Text>
            <Text color="var(--column-color)" size={18}>
              {checkpoint.score} Pontos
            </Text>
          </Row>
        ))}
      </Modal.Body>
      <Modal.Footer>
        <Button auto bordered color="error" onClick={closeHandler} size="sm">
          Fechar
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default DetailsModal;

const styles = {
  container: {
    height: "auto",
    borderRadius: "0.5rem",
    padding: "1rem",
    marginLeft: "20px",
    marginRight: "20px",
    backgroundColor: "var(--background-modal)",
    "@media (min-width: 320px)": {
      width: "80%",
      marginLeft: "auto",
      marginRight: "auto",
    },
    "@media (min-width: 481px)": {
      width: "90%",
      marginLeft: "auto",
      marginRight: "auto",
    },
    "@media (min-width: 768px)": {
      width: "100%",
      marginLeft: "auto",
      marginRight: "auto",
    },
  },

  row: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: "1rem",
    paddingRight: "0.5rem",
    zIndex: 1,
  },

  rowPoints: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: "1rem",
    paddingRight: "0.5rem",
    zIndex: 1,
    border: "1px solid #18191a",
    borderRadius: "0.5rem",
    padding: "1rem",
  },
};
