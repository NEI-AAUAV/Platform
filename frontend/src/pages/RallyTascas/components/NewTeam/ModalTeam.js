import React from "react";
import { Input, Modal, Text, Button } from "@nextui-org/react";

function ModalTeam(props) {
  const closeHandler = () => {
    props.setVisible(false);
  };

  return (
    <Modal
      closeButton
      aria-labelledby="modal-title"
      //este preventClose na vista de mobile que estava a fazer continuava a fechar-se a nao ser q eu alterasse um bocadinho o tamanho (nao faz sentido)
      preventClose
      open={props.visible}
      onClose={closeHandler}
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
          Criar uma nova
          <Text b color="white" size={18}>
            {" "}
            Equipa
          </Text>
        </Text>
      </Modal.Header>
      <Modal.Body>
        <Input
          clearable
          bordered
          fullWidth
          size="lg"
          placeholder="Nome da Equipa"
          status="primary"
        />
      </Modal.Body>
      <Modal.Footer
        css={{
          display: "flex",
          flexDirection: "row",
          justifyContent: "center",
        }}
      >
        <Button auto bordered color="error" onClick={closeHandler} size="sm">
          Fechar
        </Button>
        <Button auto bordered onClick={closeHandler} size="sm">
          Criar Equipa
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default ModalTeam;
