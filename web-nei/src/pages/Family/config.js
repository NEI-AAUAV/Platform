
import nei from "assets/icons/nei.svg";
import aettua from "assets/icons/aettua.svg";
import anzol from "assets/icons/anzol.svg";
import sal from "assets/icons/sal.svg";
import rol from "assets/icons/rol.svg";
import lenco from "assets/icons/lenco.svg";
import pa from "assets/icons/pa.svg";
import aauav from "assets/icons/aauav.svg";
import faina from "assets/icons/faina.svg";

export const colors = [
    "#006600",
    "#00ace6",
    "#D44566",
    "#ffd11a",
    "#3DD674",
    "#FFBD50",
    "#a2b627",
    "#BAA424",
    "#eead2d",
    "#19829D",
    "#808080",
    "#BB526B",
    "#ff0000",
    "#fc719e",
    "#8142A8",
    "#e67300",
    "#0000e6",
    "#938ED8",
];

export const organizations = {
    NEI: {
        name: "NEI",
        insignia: nei,
    },
    AETTUA: {
        name: "AETTUA",
        insignia: aettua,
    },
    AAUAv: {
        name: "AAUAv",
        insignia: aauav,
    },
    "Faina Académica": {
        name: "Faina Académica",
        insignia: faina
    },
    "Salgadíssima Trindade": {
        name: "Salgadíssima Trindade",
        insignia: faina
    },
    "Conselho de Cagaréus": {
        name: "Conselho de Cagaréus",
        insignia: faina
    },
    CF: {
        name: "Comissão de Faina",
        insignia: anzol,
        changeColor: true,
    },
    CS: {
        name: "Conselho do Salgado",
        insignia: sal,
        changeColor: true,
    },
    escrivao: {
        name: "Mestre Escrivão",
        insignia: rol,
        changeColor: true,
    },
    pescador: {
        name: "Mestre Pescador",
        insignia: lenco,
        changeColor: true,
    },
    salgado: {
        name: "Mestre do Salgado",
        insignia: pa,
        changeColor: true,
    },
};
