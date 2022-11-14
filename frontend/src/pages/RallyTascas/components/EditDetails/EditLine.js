import { Input, Row, Text } from "@nextui-org/react";
import React, { useState } from "react";
import { EditIcon } from "../EditIcon";
import { IconButton } from "../IconButton";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTimes, faCheck } from "@fortawesome/free-solid-svg-icons";

function EditLine(props) {
  const [isEditing, setIsEditing] = useState(false);

  const handlerEditView = () => {
    setIsEditing(true);
  };

  return (
    <Row
      key={props.checkpoint.id}
      css={{
        marginBottom: "1rem",
        zIndex: 1,
        "@media (min-width: 320px)": {
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          alignItems: "center",
          width: "100%",
          paddingRight: 0,
        },
        "@media (min-width: 481px)": {
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          alignItems: "center",
          width: "100%",
          paddingRight: 0,
        },
        "@media (min-width: 768px)": {
          width: "100%",
          display: "flex",
          flexDirection: "row",
          justifyContent: "space-between",
          alignItems: "center",
          paddingRight: "0.5rem",
        },
      }}
    >
      <Text color="white" css={{ fontWeight: "bold" }} size={18}>
        P{props.checkpoint.id} - {props.checkpoint.name}
      </Text>
      <div
        style={{
          display: "flex",
          flexDirection: "row",
          justifyContent: "flex-end",
          alignItems: "right",
          width: "50%",
        }}
      >
        {!isEditing ? (
          <>
            <Text
              color="white"
              size={18}
              css={{
                fontWeight: "bold",
                textAlign: "left",
              }}
            >
              {props.checkpoint.score} Pontos
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
            <Row
              css={{
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
              }}
            >
              <Input
                clearable
                fullWidth
                size="lg"
                placeholder="Nome da Equipa"
                value={props.checkpoint.score}
                css={{
                  backgroundColor: "black",
                  color: "white",
                  width: "150px",
                  marginRight: "1rem",
                }}
              />
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
            </Row>
          </>
        )}
      </div>
    </Row>
  );
}

export default EditLine;
