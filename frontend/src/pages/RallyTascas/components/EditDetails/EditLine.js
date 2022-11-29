import { Input, Row, Text } from "@nextui-org/react";
import React, { useState } from "react";
import { EditIcon } from "../Icons/EditIcon";
import { IconButton } from "../Customized";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTimes, faCheck } from "@fortawesome/free-solid-svg-icons";


const EditCell = ({ isEditing, score, setIsEditing }) => (
  <div>
    <Row css={styles.editingRow}>
      {!!isEditing &&
        <Input
          clearable
          fullWidth
          size="lg"
          placeholder="0"
          value={score[1]}
          css={{ ...styles.input, mx: '1rem', '& input': { fontWeight: 'bold' } }}
        />
      }
      <Text
        color="var(--column-color)"
        size={18}
        css={{
          fontWeight: "bold",
          textAlign: "left",
        }}
      >
        {!isEditing && (score[1] || 0)} {score[0]}
      </Text>
    </Row>

  </div>
)

function EditLine({ checkpoint, team }) {
  const [isEditing, setIsEditing] = useState(false);
  const id = checkpoint.id;
  const scores = {
    "⏱️": team.time_scores[id],
    "❓": team.question_scores[id],
    "⏭️": team.pukes[id],
    "🤮": team.pukes[id],
  }

  return (
    <div key={checkpoint.id}>
      <div className="d-flex justify-content-between">
        <Text color="var(--column-color)" css={{ fontWeight: "bold" }} size={18}>
          P{checkpoint.id} - {checkpoint.name}
        </Text>
        {!isEditing ?
          <IconButton
            style={{ marginBottom: "1rem", marginLeft: "1rem" }}
            onClick={() => setIsEditing(true)}
          >
            <EditIcon size={20} fill="#979797" />
          </IconButton>
          :
          <div>
            <FontAwesomeIcon
              className="text-danger mx-2"
              icon={faTimes}
              size={"2x"}
              onClick={() => setIsEditing(false)}
            />
            <FontAwesomeIcon
              className="text-primary mx-2"
              icon={faCheck}
              size={"2x"}
            />
          </div>
        }
      </div>
      <div className="d-flex flex-wrap justify-content-around w-100">
        {
          Object.entries(scores).map((s) =>
            <EditCell isEditing={isEditing} score={s} setIsEditing={setIsEditing} />)
        }
      </div>
    </div>
  );
}

export default EditLine;

const styles = {
  editingRow: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "center",
    alignItems: "center",
    width: "100%",
  },

  input: {
    backgroundColor: "black",
    width: "150px",
    marginRight: "1rem",
  },
};
