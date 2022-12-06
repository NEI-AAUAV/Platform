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
import service from 'services/RallyTascasService';

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


function InfoTable() {
  const [checkpoints, setCheckpoints] = useState([]);
  const [teams, setTeams] = useState([]);
  const [myTeam, setMyTeam] = useState(null);
  const [mobile, setMobile] = useState(false);
  const [visibleDetails, setVisibleDetails] = useState(false);
  const [editDetails, setEditDetails] = useState(false);
  const [staffModal, setStaffModal] = useState(false);
  const [selectedTeam, setSelectedTeam] = useState(null);

  const { isStaff, isAdmin, token } = useRallyAuth(state => state);

  const detailsModalHandler = () => {
    setVisibleDetails(true);
  };

  function fetchEverything() {
    if (isAdmin) {
      service.getCheckpointTeams()
        .then((data) => {
          setTeams(
            data.sort((a, b) => a.classification - b.classification)
          );
          setSelectedTeam(data.find(t => selectedTeam?.id === t.id));
        })
    } else {
      service.getTeams()
        .then((data) => {
          setTeams(
            data.sort((a, b) => a.classification - b.classification)
          );
          setSelectedTeam(data.find(t => selectedTeam?.id === t.id));
        })
    }

    if (!isStaff && !isAdmin && !!token) {
      service.getOwnTeam()
        .then((data) => setMyTeam(data))
    }
  }

  useEffect(() => {
    service.getCheckpoints()
      .then((data) => setCheckpoints(data));

    fetchEverything();
    const intervalId = setInterval(fetchEverything, 30_000);

    function handleResize() {
      setMobile(window.innerWidth < 650)
    }
    handleResize();
    window.addEventListener('resize', handleResize);
    return (() => {
      window.removeEventListener('resize', handleResize);
      clearInterval(intervalId);
    });
  }, [])

  const editModalHandler = () => {
    setEditDetails(true);
  };

  const staffModalHandler = () => {
    setStaffModal(true);
  };

  const renderCell = (team, columnKey) => {
    let cellValue = team[columnKey];
    switch (columnKey) {
      case "classification":
        if (cellValue === -1) cellValue = team.id;
        return cellValue + suffix_for_ordinal(cellValue)
      case "total":
        return `${cellValue} pts`
      case "times":
        const cp = checkpoints.find(c => c.id === cellValue.length);
        return (
          <>
            <Col>{cp ? `${cp.id} - ${cp.name}` : '---'}</Col>
            <Col>{cellValue.at(-1)?.split('T').at(-1).slice(0, 8) || '---'}</Col>
          </>
        );
      case "icons":
        const staffCanEdit = isStaff - 1 === team.times.length;
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
                    Ver Detalhes
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
                <Tooltip content="Staff Modal" css={staffCanEdit ? {} : { d: 'none' }}>
                  <IconButton css={staffCanEdit ? {} : { opacity: '0.2 !important', cursor: 'default !important' }}>
                    <EditIcon
                      size={20}
                      fill="#FFFFFF"
                      onClick={() => {
                        if (staffCanEdit) {
                          setSelectedTeam(team);
                          staffModalHandler();
                        }
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
        team={myTeam}
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
          items={checkpoints.length > 0 ? teams : []}
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
          reload={fetchEverything}
        />
      )}

      {staffModal && (
        <StaffModal
          visible={staffModal}
          setVisible={setStaffModal}
          team={selectedTeam}
          checkpoints={checkpoints}
          reload={fetchEverything}
        />
      )}
    </>
  );
}

export default InfoTable;
