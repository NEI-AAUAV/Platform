import { Button, Col, Input, Modal, Row, Text } from "@nextui-org/react";
import React from "react";
import InfoTable from "./components/InfoTable";

const RallyTascas = () => {
  const [visible, setVisible] = React.useState(false);
  const teamModalHandler = () => setVisible(true);

  const closeHandler = () => {
    setVisible(false);
    console.log("closed");
  };

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
        <Modal
          closeButton
          aria-labelledby="modal-title"
          //este preventClose na vista de mobile que estava a fazer continuava a fechar-se a nao ser q eu alterasse um bocadinho o tamanho (nao faz sentido)
          preventClose
          open={visible}
          onClose={closeHandler}
          css={{
            height: "auto",
            borderRadius: "0.5rem",
            padding: "1rem",
            marginLeft: "20px",
            marginRight: "20px",
            backgroundColor: "#010b13",
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
            <Button
              auto
              bordered
              color="error"
              onClick={closeHandler}
              size="sm"
            >
              Fechar
            </Button>
            <Button auto bordered onClick={closeHandler} size="sm">
              Criar Equipa
            </Button>
          </Modal.Footer>
        </Modal>
      </Row>
      <InfoTable />
    </Col>
  );
};

export default RallyTascas;
