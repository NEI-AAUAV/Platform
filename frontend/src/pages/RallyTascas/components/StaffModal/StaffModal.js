import { Button, Input, Modal, Text, Checkbox, Loading } from "@nextui-org/react";
import React, { useEffect, useState } from "react";
import { useRallyAuth } from "stores/useRallyAuth";
import service from "services/RallyTascasService";


function StaffModal({ visible, setVisible, team, reload }) {
  const [dt, setDt] = useState("");
  const [loading, setLoading] = useState(false);
  const [state, setState] = useState({
    'question_score': false,
    'time_score': '',
    'skips': '',
    'pukes': '',
  })
  const { isStaff } = useRallyAuth(state => state);

  const closeHandler = () => {
    document.body.style.overflow = null;
    setVisible(false);
  };

  const handleChange = (e) => {
    const { value, name } = e.target;
    setState({ ...state, [name]: value });
  }

  const submit = () => {
    setLoading(true);

    const data = {...state};
    Object.keys(data)
      .forEach((k) => data[k] === '' && delete data[k]);
    
    service.updateTeamCheckpoint(team.id, data)
      .then(() => {
        setLoading(false);
        closeHandler();
        reload()
      });
  }

  useEffect(() => {
    function setCurrTime() {
      const date = new Date();
      const times = [date.getHours(), date.getMinutes(), date.getSeconds()];
      setDt(
        times.map(t => ('00' + t).slice(-2)).join(':')
      );
    }
    setCurrTime();
    const interval = setInterval(setCurrTime, 1000);
    return () => clearInterval(interval);
  }, []);

  return (
    <Modal
      closeButton
      aria-labelledby="modal-title"
      open={visible}
      onClose={closeHandler}
      css={{
        height: "auto",
        borderRadius: "0.5rem",
        padding: "1rem",
        margin: "0 0.5rem",
        backgroundColor: "#010b13",
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
          Confirmar chegada de{' '}
          <Text b color="var(--column-color)" size={18}>
            {team.name}
          </Text>
          {' ao '}
          <Text b color="var(--column-color)" size={18}>
            Posto {isStaff}
          </Text>
        </Text>
      </Modal.Header>
      <Modal.Body>
        <Input
          type="number"
          labelRight="⏱️"
          aria-label="time_score"
          name="time_score"
          {...inputStyles}
          value={state.time_score}
          onChange={handleChange}
          placeholder="Desafio"
        />
        <Checkbox
          aria-label="question_score"
          name="question_score"
          {...checkStyles}
          isSelected={state.question_score}
          onChange={(v) => setState({ ...state, question_score: v })}>
          Pergunta<span style={{marginLeft: 'auto', marginRight: '0.75rem'}}>❓</span>
        </Checkbox>
        <Input
          type="number"
          labelRight="⏭️"
          aria-label="skips"
          name="skips"
          {...inputStyles}
          value={state.skips}
          onChange={handleChange}
          placeholder="Pass"
        />
        <Input
          type="number"
          min={0}
          labelRight="🤮"
          aria-label="pukes"
          name="pukes"
          {...inputStyles}
          value={state.pukes}
          onChange={handleChange}
          placeholder="Grego"
        />
        {/* Disabled input that keeps track of current time */}
        <Input
          aria-label="time"
          {...inputStyles}
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
        <Button auto onClick={submit} size="sm" color="warning">
          {loading ? <Loading /> : <b>Confirmar</b>}
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default StaffModal;


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

const inputStyles = {
  bordered: true,
  fullWidth: true,
  size: 'lg',
  status: 'warning',
  css: {
    '& label>span': {
      paddingLeft: "0.5rem",
      background: '#ffffff22'
    }
  }
}
