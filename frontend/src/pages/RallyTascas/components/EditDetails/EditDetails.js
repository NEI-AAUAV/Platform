import React, { useState } from "react";
import { Modal, Text, Button, Row, Input } from "@nextui-org/react";
import { IconButton } from "../Customized";
import { EditIcon } from "../Icons/EditIcon";
import EditLine from "./EditLine";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTimes, faCheck } from "@fortawesome/free-solid-svg-icons";

function EditDetails({visible, setVisible, team, checkpoints}) {

  const closeHandler = () => {
    document.body.style.overflow = null;
    setVisible(false);
  };

  const [isEditing, setIsEditing] = useState(false);

  const handlerEditView = () => {
    setIsEditing(true);
  };

  return (
    <Modal
      aria-label="modalDetails"
      closeButton
      aria-labelledby="modal-title"
      open={visible}
      onClose={closeHandler}
      width="700px"
      css={styles.modal}
    >
      <Modal.Header>
        <Text id="modal-title" color="var(--column-color)" size={18}>
          Detalhes de
          <Text b color="var(--column-color)" size={18}>
            {" "}
            {team.name}
          </Text>
        </Text>
      </Modal.Header>
      <Modal.Body>
        <Row css={styles.modalBody}>
          <Text
            color="var(--column-color)"
            css={{ fontWeight: "bold" }}
            size={18}
          >
            Nome da Equipa:
          </Text>
          <div style={styles.modalRow}>
            {!isEditing ? (
              <>
                <Text color="var(--column-color)" size={18}>
                  {team.name}
                </Text>
                <IconButton
                  style={{ marginBottom: "1rem", marginLeft: "1rem" }}
                  onClick={handlerEditView}
                >
                  <EditIcon size={20} fill="#979797" />
                </IconButton>
              </>
            ) : (
              <>
                <Row css={styles.editingRow}>
                  <Input
                    clearable
                    fullWidth
                    size="lg"
                    placeholder="Nome da Equipa"
                    value={team.name}
                    css={styles.input}
                  />
                  <div>
                    <FontAwesomeIcon
                      className="text-danger"
                      icon={faTimes}
                      size={"2x"}
                      onClick={() => setIsEditing(false)}
                      style={{ marginRight: "1rem" }}
                    />
                    <FontAwesomeIcon
                      className="text-primary"
                      icon={faCheck}
                      size={"2x"}
                      css={{ marginLeft: "1rem" }}
                    />
                  </div>
                </Row>
              </>
            )}
          </div>
        </Row>
        <Row css={styles.modalBody}>
          <Text
            color="var(--column-color)"
            css={{ fontWeight: "bold" }}
            size={18}
          >
            Pontuação
          </Text>
          <Text color="var(--column-color)" size={18}>
            {team.total}
          </Text>
        </Row>
        <Row>
          <Text color="var(--column-color)" size={18}>
            Checkpoints
          </Text>
        </Row>
        {checkpoints.map((checkpoint) => (
          <EditLine checkpoint={checkpoint} score={team.time_scores[checkpoint.id]} />
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

export default EditDetails;

const styles = {
  modal: {
    height: "auto",
    borderRadius: "0.5rem",
    padding: "1rem",
    marginLeft: "20px",
    marginRight: "20px",
    backgroundColor: "var(--background-modal)",
    border: "1px solid #979797",
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

  modalBody: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: "1rem",
    paddingRight: "0.5rem",
    zIndex: 1,
  },

  modalRow: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "flex-end",
    alignItems: "right",
    width: "50%",
  },

  editingRow: {
    display: "flex",
    "@media (min-width: 320px)": {
      flexDirection: "column",
      justifyContent: "center",
      alignItems: "center",
      width: "100%",
      paddingRight: 0,
    },
    "@media (min-width: 481px)": {
      flexDirection: "column",
      justifyContent: "center",
      alignItems: "center",
      width: "100%",
      paddingRight: 0,
    },
    "@media (min-width: 768px)": {
      flexDirection: "row",
      justifyContent: "flex-end",
      alignItems: "center",
      width: "100%",
    },
  },

  input: {
    backgroundColor: "black",
    color: "white",
    width: "150px",
    marginRight: "1rem",
  },
};
