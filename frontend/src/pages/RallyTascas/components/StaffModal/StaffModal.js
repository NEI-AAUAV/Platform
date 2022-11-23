import { Button, Input, Modal, Text } from "@nextui-org/react";
import React, { useEffect, useState } from "react";

function StaffModal(props) {
  const closeHandler = () => {
    props.setVisible(false);
  };

  const [dt, setDt] = useState(
    new Date().getHours() +
      ":" +
      new Date().getMinutes() +
      ":" +
      new Date().getSeconds()
  );

  useEffect(() => {
    const interval = setInterval(() => {
      setDt(
        new Date().getHours() +
          ":" +
          new Date().getMinutes() +
          ":" +
          new Date().getSeconds()
      );
    }, 1000);
    return () => clearInterval(interval);
  }, []);

  return (
    <Modal
      closeButton
      aria-labelledby="modal-title"
      open={props.visible}
      onClose={closeHandler}
      css={{
        height: "auto",
        borderRadius: "0.5rem",
        padding: "1rem",
        marginLeft: "20px",
        marginRight: "20px",
        backgroundColor: "var(--background-modal)",
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
        <Text id="modal-title" color="var(--column-color)" size={18}>
          Confirmar chegada ao
          <Text b color="var(--column-color)" size={18}>
            {/* Token vai dizer a q posto é q o staff pertence */} Posto X
          </Text>
        </Text>
      </Modal.Header>
      <Modal.Body>
        <Input
          clearable
          bordered
          fullWidth
          size="lg"
          placeholder="Pontos"
          status="primary"
        />
        {/* Disabled input that keeps track of current time */}
        <Input
          clearable
          bordered
          fullWidth
          size="lg"
          status="primary"
          disabled
          placeholder={dt}
        />
      </Modal.Body>
      <Modal.Footer
        css={{
          display: "flex",
          flexDirection: "row",
          justifyContent: "center",
        }}
      >
        <Button auto onClick={closeHandler} size="sm">
          Confirmar
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default StaffModal;
