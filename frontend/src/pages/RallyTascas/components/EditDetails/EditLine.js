import { Input, Row, Text } from "@nextui-org/react";
import React, { useState } from "react";
import { EditIcon } from "../Icons/EditIcon";
import { IconButton } from "../Customized";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTimes, faCheck } from "@fortawesome/free-solid-svg-icons";

function EditLine(props) {
  const [isEditing, setIsEditing] = useState(false);

  const handlerEditView = () => {
    setIsEditing(true);
  };

  return (
    <Row key={props.checkpoint.id} css={styles.container}>
      <Text color="var(--column-color)" css={{ fontWeight: "bold" }} size={18}>
        P{props.checkpoint.id} - {props.checkpoint.name}
      </Text>
      <div style={styles.rightSide}>
        {!isEditing ? (
          <>
            <Text
              color="var(--column-color)"
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
            <Row css={styles.editingRow}>
              <Input
                clearable
                fullWidth
                size="lg"
                placeholder="Pontos"
                value={props.checkpoint.score}
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
  );
}

export default EditLine;

const styles = {
  container: {
    marginBottom: "1rem",
    border: "1px solid #18191a",
    borderRadius: "0.5rem",
    zIndex: 1,
    padding: "1rem",
    "@media (min-width: 320px)": {
      display: "flex",
      flexDirection: "column",
      justifyContent: "center",
      alignItems: "center",
    },
    "@media (min-width: 481px)": {
      display: "flex",
      flexDirection: "row",
      justifyContent: "space-between",
      alignItems: "center",
    },
    "@media (min-width: 768px)": {
      width: "100%",
      display: "flex",
      flexDirection: "row",
      justifyContent: "space-between",
      alignItems: "center",
    },
  },

  rightSide: {
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
    width: "150px",
    marginRight: "1rem",
  },
};
