import React from "react";
import { Button, Col, Row, Table, css, Tooltip } from "@nextui-org/react";
import { IconButton } from "./IconButton";
import { EyeIcon } from "./EyeIcon";
import { EditIcon } from "./EditIcon";

function InfoTable() {
  const columns = [
    {
      key: "position",
      label: "#",
    },
    {
      key: "teamName",
      label: "Equipa",
    },
    {
      key: "checkpoint",
      label: "P1",
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

  const rows = [
    {
      id: 1,
      position: "1º",
      teamName: "Team 1",
      checkpoint: "350 Pts",
      timeOfCheckpoint: "23:42:22",
      total: "350 Pts",
    },
    {
      id: 2,
      position: "2º",
      teamName: "Team 2",
      checkpoint: "250 Pts",
      timeOfCheckpoint: "00:12:58",
      total: "250 Pts",
    },
    {
      id: 3,
      position: "3º",
      teamName: "Team 3",
      checkpoint: "190 Pts",
      timeOfCheckpoint: "00:22:30",
      total: "190 Pts",
    },
    {
      id: 4,
      position: "4º",
      teamName: "Team 4",
      checkpoint: "175 Pts",
      timeOfCheckpoint: "00:30:02",
      total: "175 Pts",
    },
  ];

  const renderCell = (team, columnKey) => {
    const cellValue = team[columnKey];
    switch (columnKey) {
      case "checkpoint":
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
                <IconButton>
                  <EyeIcon size={20} fill="#979797" />
                </IconButton>
              </Tooltip>
            </Col>
            <Col css={{ d: "flex" }}>
              <Tooltip content="Edit Team">
                <IconButton>
                  <EditIcon size={20} fill="#979797" />
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
    <Table
      css={{
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
              backgroundColor: "#16181A",
              color: "white",
              fontWeight: "bold",
              width: `calc(100% / ${columns.length})`,
            }}
          >
            {column.label}
          </Table.Column>
        )}
      </Table.Header>
      <Table.Body items={rows}>
        {(team) => (
          <Table.Row
            //css to change the background color of the table rows
            css={{
              color: "white",
              fontSize: "0.875rem",
              fontWeight: "bold",
              "&:nth-child(even)": {
                backgroundColor: "#000711",
              },
            }}
          >
            {(columnKey) => (
              <Table.Cell>{renderCell(team, columnKey)}</Table.Cell>
            )}
          </Table.Row>
        )}
      </Table.Body>
    </Table>
  );
}

export default InfoTable;
