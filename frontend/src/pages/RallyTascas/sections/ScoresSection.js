import React from "react";
import { Col, Row, Table, Tooltip } from "@nextui-org/react";
import { IconButton } from "../components/Customized";
import { EyeIcon } from "../components/Icons/EyeIcon";
import { EditIcon } from "../components/Icons/EditIcon";
import DetailsModal from "../components/Details/DetailsModal";
import EditDetails from "../components/EditDetails/EditDetails";
import StaffModal from "../components/StaffModal/StaffModal";
import "./ScoresSection.css";

const columns = [
  {
    key: "position",
    label: "#",
  },
  {
    key: "teamName",
    label: "Team",
  },
  {
    key: "lastCheckPoint",
    label: "Last Checkpoint",
  },
  {
    key: "total",
    label: "Total Score",
  },
  {
    key: "icons",
    label: "",
  },
];

const rows = [
  {
    id: 1,
    position: "1º",
    teamName: "Pretty Big Name",
    lastCheckPoint: "350 Pts",
    timeOfCheckpoint: "23:42:22",
    total: "350 Pts",
    scores: [
      {
        id: 1,
        name: "DETI",
        score: 100,
        time: "23:42:22",
      },
      {
        id: 2,
        name: "Reitoria",
        score: 50,
        time: "23:42:22",
      },
      {
        id: 3,
        name: "DECA",
        score: 25,
        time: "23:42:22",
      },
      {
        id: 4,
        name: "AFFUAV",
        score: 25,
        time: "23:42:22",
      },
      {
        id: 5,
        name: "Teatro Aveirense",
        score: 100,
        time: "23:42:22",
      },
      {
        id: 6,
        name: "Câmara Municipal",
        score: 50,
        time: "23:42:22",
      },
      {
        id: 7,
        name: "Santos Bar",
        score: -100,
        time: "23:42:22",
      },
      {
        id: 8,
        name: "Bar do Estudante",
        score: 50,
        time: "23:42:22",
      },
    ],
  },
  {
    id: 2,
    position: "2º",
    teamName: "Team 2",
    lastCheckPoint: "250 Pts",
    timeOfCheckpoint: "00:12:58",
    total: "250 Pts",
    scores: [
      {
        id: 1,
        name: "DETI",
        score: 100,
        time: "23:42:22",
      },
      {
        id: 2,
        name: "Reitoria",
        score: 50,
        time: "23:42:22",
      },
      {
        id: 3,
        name: "DECA",
        score: 25,
        time: "23:42:22",
      },
      {
        id: 4,
        name: "AFFUAV",
        score: 25,
        time: "23:42:22",
      },
      {
        id: 5,
        name: "Teatro Aveirense",
        score: 100,
        time: "23:42:22",
      },
      {
        id: 6,
        name: "Câmara Municipal",
        score: 50,
        time: "23:42:22",
      },
      {
        id: 7,
        name: "Santos Bar",
        score: -100,
        time: "23:42:22",
      },
      {
        id: 8,
        name: "Bar do Estudante",
        score: 50,
        time: "23:42:22",
      },
    ],
  },
  {
    id: 3,
    position: "3º",
    teamName: "Team 3",
    lastCheckPoint: "190 Pts",
    timeOfCheckpoint: "00:22:30",
    total: "190 Pts",
    scores: [
      {
        id: 1,
        name: "DETI",
        score: 100,
        time: "23:42:22",
      },
      {
        id: 2,
        name: "Reitoria",
        score: 50,
        time: "23:42:22",
      },
      {
        id: 3,
        name: "DECA",
        score: 25,
        time: "23:42:22",
      },
      {
        id: 4,
        name: "AFFUAV",
        score: 25,
        time: "23:42:22",
      },
      {
        id: 5,
        name: "Teatro Aveirense",
        score: 100,
        time: "23:42:22",
      },
      {
        id: 6,
        name: "Câmara Municipal",
        score: 50,
        time: "23:42:22",
      },
      {
        id: 7,
        name: "Santos Bar",
        score: -100,
        time: "23:42:22",
      },
      {
        id: 8,
        name: "Bar do Estudante",
        score: 50,
        time: "23:42:22",
      },
    ],
  },
  {
    id: 4,
    position: "4º",
    teamName: "Team 4",
    lastCheckPoint: "175 Pts",
    timeOfCheckpoint: "00:30:02",
    total: "175 Pts",
    scores: [
      {
        id: 1,
        name: "DETI",
        score: 100,
        time: "23:42:22",
      },
      {
        id: 2,
        name: "Reitoria",
        score: 50,
        time: "23:42:22",
      },
      {
        id: 3,
        name: "DECA",
        score: 25,
        time: "23:42:22",
      },
      {
        id: 4,
        name: "AFFUAV",
        score: 25,
        time: "23:42:22",
      },
      {
        id: 5,
        name: "Teatro Aveirense",
        score: 100,
        time: "23:42:22",
      },
      {
        id: 6,
        name: "Câmara Municipal",
        score: 50,
        time: "23:42:22",
      },
      {
        id: 7,
        name: "Santos Bar",
        score: -100,
        time: "23:42:22",
      },
      {
        id: 8,
        name: "Bar do Estudante",
        score: 50,
        time: "23:42:22",
      },
    ],
  },
];

function InfoTable() {
  const [visibleDetails, setVisibleDetails] = React.useState(false);
  const [editDetails, setEditDetails] = React.useState(false);
  const [staffModal, setStaffModal] = React.useState(false);
  const [selectedTeam, setSelectedTeam] = React.useState(null);
  const detailsModalHandler = () => {
    setVisibleDetails(true);
  };

  const editModalHandler = () => {
    setEditDetails(true);
  };

  const staffModalHandler = () => {
    setStaffModal(true);
  };

  const renderCell = (team, columnKey) => {
    const cellValue = team[columnKey];
    switch (columnKey) {
      case "lastCheckPoint":
        return (
          <>
            <Col>{cellValue}</Col>
            <Col>{team.timeOfCheckpoint}</Col>
          </>
        );

      case "icons":
        return (
          <Row justify="center" align="center">
            <Col css={{ d: "flex" }}>
              <Tooltip content="Details">
                {/* Get selected team */}
                <IconButton
                  onClick={() => {
                    setSelectedTeam(team);
                    detailsModalHandler();
                  }}
                >
                  <EyeIcon size={20} fill="#FFFFFF" />
                </IconButton>
              </Tooltip>
            </Col>
            <Col css={{ d: "flex" }}>
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
            <Col css={{ d: "flex" }}>
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
          </Row>
        );
      default:
        return cellValue;
    }
  };

  return (
    <>
      <Table
        bordered
        //alter border color
        css={{
          marginTop: "20px",
          marginBottom: "8px",
          padding: "30px",
          border: "1px solid #ed7f38",
          borderRadius: "10px",
          height: "auto",
          minWidth: "100%",
          zIndex: 1,
        }}
      >
        <Table.Header columns={columns}>
          {(column) => (
            <Table.Column
              key={column.key}
              css={{
                backgroundColor: "rgba(0, 0, 0, 0.1)",
                color: "#ed7f38",
                fontWeight: "bold",
                fontSize: "1rem",
                width: `calc(100% / ${columns.length})`,
              }}
            >
              {column.label}
            </Table.Column>
          )}
        </Table.Header>
        <Table.Body
          items={rows}
          css={{
            height: "auto",
            width: "100%",
            overflow: "auto",
          }}
        >
          {(team) => (
            <Table.Row
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
                    width: `calc(100% / ${columns.length})`,
                    borderLeft: `${
                      columnKey === columns[0].key
                        ? "1px solid #ed7f38"
                        : "none"
                    }`,
                    borderRight: `${
                      columnKey === columns[columns.length - 1].key
                        ? "1px solid #ed7f38"
                        : "none"
                    }`,

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
      {/* Conditional rendering */}
      {visibleDetails && (
        <DetailsModal
          visible={visibleDetails}
          setVisible={setVisibleDetails}
          selectedTeam={selectedTeam}
        />
      )}

      {editDetails && (
        <EditDetails
          visible={editDetails}
          setVisible={setEditDetails}
          selectedTeam={selectedTeam}
        />
      )}

      {staffModal && (
        <StaffModal
          visible={staffModal}
          setVisible={setStaffModal}
          selectedTeam={selectedTeam}
        />
      )}
    </>
  );
}

export default InfoTable;
