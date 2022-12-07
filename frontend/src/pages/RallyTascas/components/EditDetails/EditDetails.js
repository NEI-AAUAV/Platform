import React, { useState } from "react";
import { Modal, Text, Button, Row, Dropdown } from "@nextui-org/react";
import { IconButton } from "../Customized";
import { EditIcon } from "../Icons/EditIcon";
import EditLine from "./EditLine";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTimes, faCheck } from "@fortawesome/free-solid-svg-icons";

import service from 'services/RallyTascasService';

function EditDetails({ visible, setVisible, team, checkpoints, reload }) {
  const [isEditing, setIsEditing] = useState(false);
  const initialState = [team?.card1, team?.card2, team?.card3]
  const [cards, setCards] = useState(initialState);
  
  const closeHandler = () => {
    document.body.style.overflow = null;
    setVisible(false);
  };

  if (!team) {
    closeHandler();
    return null;
  }

  const submit = () => {
    service.updateTeam(team.id, { card1: cards[0], card2: cards[1], card3: cards[2] })
      .then(() => { reload(); setIsEditing(false); })
  }

  return (
    <Modal
      aria-label="modalDetails"
      closeButton
      aria-labelledby="modal-title"
      open={visible}
      onClose={closeHandler}
      width="700px"
      css={{
        ...styles.modal,
        margin: '0.5rem',
        width: 'unset',
        '& .nextui-modal-body': {
          px: 0,
        },
        '@xs': {
          '& .nextui-modal-body': {
            px: 'inherit',
          }
        },
      }}
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
            color="var(--nextui-colors-error)"
            css={{ fontWeight: "bold" }}
            size={18}
          >
            Pontuação
          </Text>
          <Text color="var(--column-color)" size={18}>
            {team.total}
          </Text>
        </Row>
        <Row css={styles.modalBody}>
          <Text
            color="var(--nextui-colors-error)"
            css={{ fontWeight: "bold" }}
            size={18}
          >
            Cartas:
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
                onClick={() => { setIsEditing(false); setCards([...initialState]) }}
              />
              <FontAwesomeIcon
                className="text-primary mx-2"
                icon={faCheck}
                size={"2x"}
                onClick={submit}
              />
            </div>
          }
        </Row>
        <Row css={styles.modalBody} className="flex-sm-row flex-column align-items-center">
          {[1, 2, 3].map((i) =>
            <div key={i} className="text-center mb-2">
              <div className="text-white mb-2">
                {
                  ["Pergunta-Pass❔", "Desafio-pass🎯", "Grego-Pass🤮"][i - 1]
                }
              </div>
              <div>
                {!!isEditing ?
                  <Dropdown>
                    <Dropdown.Button flat color="error" css={{ tt: "capitalize", fontWeight: 'bold', marginLeft: 8 }}>
                      {cards[i - 1] == -1 ? 'Ausente' :
                        cards[i - 1] == 0 ? 'Por Ativar' :
                          `Ativada em P${cards[i - 1]}`}
                    </Dropdown.Button>
                    <Dropdown.Menu
                      color="error"
                      aria-label="Cards selection"
                      disallowEmptySelection
                      selectionMode="single"
                      selectedKeys={[cards[i - 1]]}
                      onSelectionChange={(k) => setCards(prevCards => { prevCards[i - 1] = k.currentKey; return [...prevCards]; })}
                      css={{ fontFamily: 'monospace' }}
                    >
                      <Dropdown.Item key={-1} css={{ padding: '0.3rem 0', height: 'auto' }} textValue="none">
                        Ausente
                      </Dropdown.Item>
                      <Dropdown.Item key={0} css={{ padding: '0.3rem 0', height: 'auto' }} textValue="none">
                        Por Ativar
                      </Dropdown.Item>
                      {
                        Array.from({ length: 8 }, (_, i) => i + 1).map((index) =>
                          <Dropdown.Item key={index} css={{ padding: '0.3rem 0', height: 'auto' }} textValue="none">
                            Ativada em P{index}
                          </Dropdown.Item>
                        )
                      }
                    </Dropdown.Menu>
                  </Dropdown>
                  :
                  <Text
                    color="var(--column-color)"
                  >
                    {team[`card${i}`] === -1 ? 'Ausente' :
                      team[`card${i}`] === 0 ? 'Por Ativar' :
                        `Ativada em P${team[`card${i}`]}`}
                  </Text>
                }
              </div>
            </div>
          )}
        </Row>
        <Row>
          <Text color="var(--nextui-colors-error)"
            css={{ fontWeight: "bold" }}
            size={18}
          >
            Checkpoints
          </Text>
        </Row>
        {checkpoints.map((checkpoint, i) => (
          i < team?.times.length && <EditLine reload={reload} key={i} checkpoint={checkpoint} team={team} />
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
    backgroundColor: "#010b13",
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
