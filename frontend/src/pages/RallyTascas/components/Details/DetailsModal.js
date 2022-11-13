import React from "react";
import { Modal, Text, Button, Row } from "@nextui-org/react";

function DetailsModal(props) {
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
            NOME DA EQUIPA
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
          <Text color="white" size={18}>
            NOME DA EQUIPA
          </Text>
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
            631 Pontos
          </Text>
        </Row>
        <Row>
          <Text color="white" size={18}>
            Checkpoints
          </Text>
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
            P1 - DETI
          </Text>
          <Text color="white" size={18}>
            120 Pontos
          </Text>
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
            P2 - Reitoria
          </Text>
          <Text color="white" size={18}>
            100 Pontos
          </Text>
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
            P3 - FITUA
          </Text>
          <Text color="white" size={18}>
            120 Pontos
          </Text>
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
            P4 - AFFUAV
          </Text>
          <Text color="white" size={18}>
            200 Pontos
          </Text>
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
            P5 - Teatro Aveirense
          </Text>
          <Text color="white" size={18}>
            35 Pontos
          </Text>
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
            P6 - Câmara Municipal
          </Text>
          <Text color="white" size={18}>
            100 Pontos
          </Text>
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
            P7 - Santos
          </Text>
          <Text color="white" size={18}>
            -54 Pontos
          </Text>
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
            P8 - Bar do Estudante
          </Text>
          <Text color="white" size={18}>
            10 Pontos
          </Text>
        </Row>
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
