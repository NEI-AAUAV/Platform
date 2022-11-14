import React from "react";
import { Modal, Text, Button, Row } from "@nextui-org/react";
import { IconButton } from "../IconButton";
import { EditIcon } from "../EditIcon";
import EditLine from "./EditLine";

function EditDetails(props) {
  let visible = props.visible;

  const closeHandler = () => {
    props.setVisible(false);
  };

  const [editView, setEditView] = React.useState(false);

  /* const handlerEditView = (id) => {
    setEditView(true);
  }; */

  return (
    <Modal
      aria-label="modalDetails"
      closeButton
      aria-labelledby="modal-title"
      open={visible}
      onClose={closeHandler}
      width="700px"
      css={{
        height: "auto",
        borderRadius: "0.5rem",
        padding: "1rem",
        marginLeft: "20px",
        marginRight: "20px",
        backgroundColor: "#010b13",
        //decrease width on different screen sizes
        "@media (min-width: 320px)": {
          width: "80%",
          marginLeft: "10%",
          marginRight: "10%",
        },
        "@media (min-width: 481px)": {
          width: "90%",
        },
        "@media (min-width: 768px)": {
          width: "100%",
        },
      }}
    >
      <Modal.Header>
        <Text id="modal-title" color="white" size={18}>
          Detalhes de
          <Text b color="white" size={18}>
            {" "}
            {props.selectedTeam.teamName}
          </Text>
        </Text>
      </Modal.Header>
      <Modal.Body>
        <Row
          css={{
            display: "flex",
            flexDirection: "row",
            justifyContent: "space-between",
            marginBottom: "1rem",
            paddingRight: "0.5rem",
            zIndex: 1,
          }}
        >
          <Text color="white" css={{ fontWeight: "bold" }} size={18}>
            Nome da Equipa:
          </Text>
          <div
            style={{
              display: "flex",
              flexDirection: "row",
              justifyContent: "space-between",
              width: "150px",
            }}
          >
            <Text color="white" size={18}>
              {props.selectedTeam.teamName}
            </Text>
            <IconButton style={{ marginBottom: "1rem" }}>
              <EditIcon size={20} fill="#979797" />
            </IconButton>
          </div>
        </Row>
        <Row
          css={{
            display: "flex",
            flexDirection: "row",
            justifyContent: "space-between",
            marginBottom: "1rem",
            paddingRight: "0.5rem",
            zIndex: 1,
          }}
        >
          <Text color="white" css={{ fontWeight: "bold" }} size={18}>
            Pontuação
          </Text>
          <Text color="white" size={18}>
            {props.selectedTeam.total}
          </Text>
        </Row>
        <Row>
          <Text color="white" size={18}>
            Checkpoints
          </Text>
        </Row>
        {props.selectedTeam.scores.map((checkpoint) => (
          <EditLine checkpoint={checkpoint} />
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
