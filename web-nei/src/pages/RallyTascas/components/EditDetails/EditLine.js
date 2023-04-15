import { Input, Row, Text, Checkbox } from "@nextui-org/react";
import React, { useState } from "react";
import { EditIcon } from "../Icons/EditIcon";
import { IconButton } from "../Customized";

import service from 'services/RallyTascasService';


const checkStyles = {
  color: 'warning',
  css: {
    marginLeft: '0.625rem',
    lineHeight: '2rem',
    '& .nextui-checkbox-mask::before': {
      background: '#ffffff22'
    },
    '&>span': {
      width: '100%',
      color: '#889096',
      fontSize: '1rem'
    }
  }
}


const EditCell = ({ isEditing, isCheckbox, label, name, score, setScore }) => (
  <div>
    <Row css={styles.editingRow}>
      {!!isEditing ? (
        !!isCheckbox ?
          <Checkbox
            aria-label="question_score_admin"
            name="question_score_admin"
            {...checkStyles}
            isSelected={score}
            onChange={(v) => setScore(scores => ({ ...scores, [name]: v }) )}
          >
            {label}
          </Checkbox>
          :
          <Input
            labelRight={label}
            clearable
            fullWidth
            size="lg"
            placeholder="0"
            value={score}
            onChange={(e) => setScore(scores => ({ ...scores, [name]: e.target.value }))}
            css={{ ...styles.input, mx: '1rem', '& input': { fontWeight: 'bold' }, maxWidth: 100 }}
          />
      ) :
        <Text
          color="white"
          size={18}
          css={{
            fontWeight: "bold",
            textAlign: "left",
          }}
        >
          {!isCheckbox ? score || 0 : score ? 'V' : 'F'} {label}
        </Text>
      }
    </Row>

  </div>
)

function EditLine({ checkpoint, team, reload }) {
  const [isEditing, setIsEditing] = useState(false);
  const id = checkpoint.id - 1;
  const initialState = {
    time_scores: team.time_scores[id],
    question_scores: team.question_scores[id],
    skips: team.skips[id],
    pukes: team.pukes[id]
  }
  const [state, setState] = useState(initialState);
  const labels = {
    time_scores: "⏱️",
    question_scores: "❓",
    skips: "⏭️",
    pukes: "🤮",
  }

  const submit = () => {
    const time_scores = [...team.time_scores];
    const question_scores = [...team.question_scores];
    const skips = [...team.skips];
    const pukes = [...team.pukes];
    time_scores[id] = state.time_scores;
    question_scores[id] = state.question_scores;
    skips[id] = state.skips;
    pukes[id] = state.pukes;

    service.updateTeam(team.id, { time_scores, question_scores, skips, pukes })
      .then(() => { reload(); setIsEditing(false); } )
  }

  return (
    <div key={checkpoint.id}>
      <div className="d-flex justify-content-between">
        <Text color="white" css={{ fontWeight: "bold" }} size={18}>
          {checkpoint.id} - {checkpoint.name}
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
            {/* <FontAwesomeIcon
              className="text-danger mx-2"
              icon={faTimes}
              size={"2x"}
              onClick={() => { setIsEditing(false); setState({ ...initialState }) }}
            />
            <FontAwesomeIcon
              className="text-primary mx-2"
              icon={faCheck}
              size={"2x"}
              onClick={submit}
            /> */}
          </div>
        }
      </div>
      <div className="d-flex flex-wrap justify-content-around w-100">
        {
          Object.keys(labels).map((name, i) =>
            <EditCell key={i}
              isCheckbox={name === 'question_scores'}
              isEditing={isEditing}
              name={name}
              score={state[name]}
              label={labels[name]}
              setScore={setState}
            />
          )
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
