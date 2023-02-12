import config from "config";

const data = [
    {
        name: "Estudo",
        dropdown: [
            {
                name: "Calendário",
                link: "/calendario",
            },
            {
                name: "Apontamentos",
                link: "/apontamentos",
            },
            {
                name: "Vídeos",
                link: "/videos",
            },
        ],
    },
    {
        name: "NEI",
        dropdown: [
            {
                name: "Equipas",
                link: "/equipa",
            },
            {
                name: "História",
                link: "/historia",
            },
            {
                name: "RGM",
                link: "/rgm",
            },
            {
                name: "Novos alunos",
                link: "https://www.ua.pt/pt/deti",
                external: true,
            },
        ],
    },
    {
        name: "Faina",
        dropdown: [
            {
                name: "Comissões de Faina",
                link: "/faina",
            },
            {
                name: "Família",
                link: "/familias",
            },
            {
                name: "Código de Faina",
                link: process.env.PUBLIC_URL + "/faina/CodigoFaina.pdf",
                external: true,
            },
        ],
    },
    !config.PRODUCTION && {
        name: "Taça UA",
        link: "/desporto",
    },
    {
        name: "Finalistas",
        link: "/seniors",
    },
    // {
    //   name: "Estágios",
    //   link: "/estagios",
    // },
    // {
    //   name: "Rally Tascas",
    //   link: "/breakthebars",
    // },
    {
        name: "Outro",
        dropdown: [
            !config.PRODUCTION && {
                name: "Components",
                link: "/components",
            },
            {
                name: "Test",
                link: "/testing",
            },
            {
                name: "TacauaAdminDemo",
                link: "/tacaua-admin-demo",
            }
        ],
    },
];

export default data;
