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
      aria-label="Example table with custom cells"
      css={{
        height: "auto",
        minWidth: "100%",
      }}
      selectionMode="none"
    >
      <Table.Header columns={columns}>
        {(column) => (
          <Table.Column
            key={column.key}
            /* 
            // this css, when uncommented, makes the id occupy almost the entire width of the table
            // probably will use to scroll horizontally minus the id column
            css={{
              backgroundColor: "#F5F5F5",
              color: "#979797",
              fontSize: "0.875rem",
              fontWeight: "bold",
              padding: "0.5rem 1rem",
              textAlign: "left",
              width: "100%",
              "&:first-child": {
                borderRadius: "0.5rem 0 0 0.5rem",
              },
              "&:last-child": {
                borderRadius: "0 0.5rem 0.5rem 0",
              },
            }} */
            css={{
              backgroundColor: "#0a0a0a",
              color: "white",
              fontWeight: "bold",
            }}
          >
            {column.label}
          </Table.Column>
        )}
      </Table.Header>
      <Table.Body items={rows}>
        {(team) => (
          <Table.Row
            css={{
              color: "white",
              fontWeight: "bold",
              fontSize: "0.875rem",
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
