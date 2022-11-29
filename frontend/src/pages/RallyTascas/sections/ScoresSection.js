import React, { useState, useEffect, useCallback } from "react";
import { Button, Col, Row, Table, Tooltip } from "@nextui-org/react";
import { IconButton } from "../components/Customized";
import { EyeIcon } from "../components/Icons/EyeIcon";
import { EditIcon } from "../components/Icons/EditIcon";
import DetailsModal from "../components/Details/DetailsModal";
import EditDetails from "../components/EditDetails/EditDetails";
import StaffModal from "../components/StaffModal/StaffModal";
import "./ScoresSection.css";
import FirstPlace from "../components/FirstPlace";
import { suffix_for_ordinal } from "../components/LeaderBoard"

import { useRallyAuth } from "stores/useRallyAuth";

const columns = [
  {
    key: "classification",
    label: "#",
  },
  {
    key: "name",
    label: "Equipa",
  },
  {
    key: "times",
    label: "Último Posto",
  },
  {
    key: "total",
    label: "Total",
  },
  {
    key: "icons",
    label: "",
  },
];


const checkpoints = [
  {
    name: "Tribunal",
    shot_name: "shot 1",
    description: "Uma breve descrição qualquer.",
    id: 1
  },
  {
    name: "Receção",
    shot_name: "shot 2",
    description: "Uma breve descrição qualquer.",
    id: 2
  },
  {
    name: "Cela",
    shot_name: "shot 3",
    description: "Uma breve descrição qualquer.",
    id: 3
  },
  {
    name: "Pátio",
    shot_name: "shot 4",
    description: "Uma breve descrição qualquer.",
    id: 4
  },
  {
    name: "Cantina",
    shot_name: "shot 5",
    description: "Uma breve descrição qualquer.",
    id: 5
  },
  {
    name: "WC",
    shot_name: "shot 6",
    description: "Uma breve descrição qualquer.",
    id: 6
  },
  {
    name: "Ginásio",
    shot_name: "shot 7",
    description: "Uma breve descrição qualquer.",
    id: 7
  },
  {
    name: "Enfermaria",
    shot_name: "shot 8",
    description: "Uma breve descrição qualquer.",
    id: 8
  }
]

const teams = [
  {
    name: "Não Tavas Capaz nao vinhas",
    question_scores: [false, false, false],
    time_scores: [360, 15, 0],
    times: ["2022-11-30T19:15:00", "2022-11-30T19:30:00", "2022-11-30T19:33:00"],
    pukes: [0, 0, 1],  
    skips: [0, 1, 0],  
    total: 15,
    classification: 1,
  },
  {
    name: "Equipa 2",
    question_scores: [true, false, false],
    time_scores: [360, 15, 0],
    times: ["2022-11-30T19:26:00", "2022-11-30T19:56:00", "2022-11-30T20:10:00"],
    pukes: [0, 0, 0],  
    skips: [0, 2, 1],  
    total: 13,
    classification: 2,
  },
  {
    name: "Equipa 3",
    question_scores: [true, true],
    time_scores: [0, 20],
    times: ["2022-11-30T19:40:00", "2022-11-30T20:00:00"],
    pukes: [0, 0, 1],  
    skips: [0, 0],  
    total: 3,
    classification: 3,
  },
  {
    name: "Equipa 4",
    question_scores: [false],
    time_scores: [180],
    times: ["2022-11-30T20:05:00"],
    pukes: [2],   
    skips: [1],   
    total: -12,
    classification: 5,
  },
  {
    name: "Equipa 5",
    question_scores: [],
    time_scores: [],
    times: [],
    pukes: [],
    skips: [],
    total: 0,
    classification: 4,
  },
];

function InfoTable() {
  const [mobile, setMobile] = useState(false);
  const [visibleDetails, setVisibleDetails] = React.useState(false);
  const [editDetails, setEditDetails] = React.useState(false);
  const [staffModal, setStaffModal] = React.useState(false);
  const [selectedTeam, setSelectedTeam] = React.useState(null);

  const { isStaff, isAdmin } = useRallyAuth(state => state);

  const detailsModalHandler = () => {
    setVisibleDetails(true);
  };

  useEffect(() => {
    function handleResize() {
      setMobile(window.innerWidth < 650)
    }
    handleResize();
    window.addEventListener('resize', handleResize);
    return (() => {
      window.removeEventListener('resize', handleResize)
    });
  }, [])

  const editModalHandler = () => {
    setEditDetails(true);
  };

  const staffModalHandler = () => {
    setStaffModal(true);
  };

  const renderCell = (team, columnKey) => {
    const cellValue = team[columnKey];
    switch (columnKey) {
      case "classification":
        return cellValue + suffix_for_ordinal(cellValue)
      case "total":
        return `${cellValue} pts`
      case "times":
        const cp = checkpoints.find(c => c.id === cellValue.length);
        return (
          <>
            <Col>{cp ? `${cp.id} - ${cp.name}` : '---'}</Col>
            <Col>{cellValue.at(-1)?.split('T').at(-1) || '---'}</Col>
          </>
        );

      case "icons":
        return (
          <Row justify="center" align="center">
            <Col css={{ d: "flex", m: 10 }}>
              {
                mobile ?
                  <Tooltip content="Details">
                    <IconButton
                      onClick={() => {
                        setSelectedTeam(team);
                        detailsModalHandler();
                      }}
                    >
                      <EyeIcon size={20} fill="#FFFFFF" />
                    </IconButton>
                  </Tooltip>
                  :
                  <Button
                    onClick={() => {
                      setSelectedTeam(team);
                      detailsModalHandler();
                    }}
                    className="btn-icon btn-round"
                    size="sm"
                    css={{
                      backgroundColor: "#ed7f38",
                      color: "black",
                      fontWeight: "bold",
                      padding: "0",
                      margin: "0",
                      //  active and hover background color red
                      "&:hover": {
                        backgroundColor: "#FF4646",
                      },
                    }}
                  >
                    Ver Equipa
                  </Button>
              }
            </Col>
            {
              !!isAdmin &&
              <Col css={{ d: "flex", m: 10 }}>
                <Tooltip content="Edit Team">
                  <IconButton>
                    <EditIcon
                      size={20}
                      fill="#FFFFFF"
                      onClick={() => {
                        setSelectedTeam(team);
                        editModalHandler();
                      }}
                    />
                  </IconButton>
                </Tooltip>
              </Col>
            }
            {
              !!isStaff &&
              <Col css={{ d: "flex", m: 10 }}>
                <Tooltip content="Staff Modal">
                  <IconButton>
                    <EditIcon
                      size={20}
                      fill="#FFFFFF"
                      onClick={() => {
                        setSelectedTeam(team);
                        staffModalHandler();
                      }}
                    />
                  </IconButton>
                </Tooltip>
              </Col>
            }
          </Row>
        );
      default:
        return cellValue;
    }
  };

  return (
    <>
      <FirstPlace
        team={teams[0]}
        mobile={mobile}
        checkpoints={checkpoints}
      />
      <Table
        bordered
        css={{
          marginTop: "20px",
          marginBottom: "8px",
          border: "1px solid #ed7f38",
          borderRadius: "10px",
          height: "auto",
          minWidth: "100%",
          zIndex: 1,
          borderSpacing: "0 20px",
          paddingBottom: 0,
          padding: 5,
          tableLayout: 'auto',
          '@xs': {
            padding: 30,
            paddingBottom: 0,
          },
        }}
      >
        <Table.Header columns={mobile ? columns.filter((_, i) => i !== 2) : columns}>
          {(column) => (
            <Table.Column
              key={column.key}
              css={{
                backgroundColor: "transparent",
                color: "#ed7f38",
                fontWeight: "bold",
                fontSize: "1rem",
                width: column.key === 'classification' || (column.key === 'icons' && mobile)
                  ? "10%"
                  : 'max-content',
              }}
            >
              {column.label}
            </Table.Column>
          )}
        </Table.Header>
        <Table.Body
          items={teams.sort((a, b) => a.classification - b.classification)}
          css={{
            height: "auto",
            width: "100%",
            overflow: "auto",
            transform: "translateY(-20px)",
          }}
        >
          {(team) => (
            <Table.Row
              key={team.name}
              css={{
                color: "var(--column-color)",
                fontSize: "0.875rem",
                fontWeight: "bold",
                "&:nth-child(even)": {
                  backgroundColor: "rgba(0, 0, 0, 0.1)",
                },
              }}
            >
              {(columnKey) => (
                <Table.Cell
                  css={{
                    width: columnKey === 'classification' || (columnKey === 'icons' && mobile)
                      ? "10%"
                      : 'max-content',
                    borderLeft: columnKey === columns.at(0).key
                      ? "1px solid #ed7f38"
                      : "none",
                    borderRight: columnKey === columns.at(-1).key
                      ? "1px solid #ed7f38"
                      : "none",

                    "&:first-child": {
                      borderTopLeftRadius: "10px",
                      borderBottomLeftRadius: "10px",
                    },

                    "&:last-child": {
                      borderTopRightRadius: "10px",
                      borderBottomRightRadius: "10px",
                    },

                    borderTop: "1px solid #ed7f38",
                    borderBottom: "1px solid #ed7f38",
                  }}
                >
                  {renderCell(team, columnKey)}
                </Table.Cell>
              )}
            </Table.Row>
          )}
        </Table.Body>
      </Table>
      {visibleDetails && (
        <DetailsModal
          visible={visibleDetails}
          setVisible={setVisibleDetails}
          team={selectedTeam}
          checkpoints={checkpoints}
        />
      )}

      {editDetails && (
        <EditDetails
          visible={editDetails}
          setVisible={setEditDetails}
          team={selectedTeam}
          checkpoints={checkpoints}
        />
      )}

      {staffModal && (
        <StaffModal
          visible={staffModal}
          setVisible={setStaffModal}
          team={selectedTeam}
          checkpoints={checkpoints}
        />
      )}
    </>
  );
}

export default InfoTable;
