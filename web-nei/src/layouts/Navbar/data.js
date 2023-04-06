import config from "config";

const data = [
    {
        name: "Estudo",
        dropdown: [
            {
                name: "Calendário",
                link: "/calendar",
            },
            {
                name: "Apontamentos",
                link: "/notes",
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
                link: "/teams",
            },
            {
                name: "História",
                link: "/history",
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
                name: "Diário do Tux",
                link: "/tux",
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
        link: "/taca-ua",
    },
    // {
    //   name: "Rally Tascas",
    //   link: "/breakthebars",
    // },
    {
        name: "Família",
        link: "/family",
    },
    {
        name: "Finalistas",
        link: "/seniors",
    },
    // {
    //   name: "Estágios",
    //   link: "/estagios",
    // },
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
];


const dataCompacted = (size) => {
    const items = [...data];
    const otherItems = items.splice(size - 1);
    return [
        ...items,
        {
            name: "Outro",
            dropdown: otherItems
        },
    ];
}

export { data, dataCompacted };
