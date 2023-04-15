import config from "config";

const data = [
    {
        name: "Notícias",
        link: "/news",
    },
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
                disabled: true,
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
                disabled: true,
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
        name: "Famílias",
        link: "/family",
    },
    {
        name: "Finalistas",
        link: "/seniors",
        disabled: true,
    },
    // {
    //   name: "Estágios",
    //   link: "/estagios",
    // },
    !config.PRODUCTION && {
        name: "Components",
        link: "/components",
    },
    !config.PRODUCTION && {
        name: "Test",
        link: "/WSTest",
    },
    !config.PRODUCTION && {
        name: "TacauaAdminDemo",
        link: "/WStacaua-admin-demo",
    }
];


const dataCompacted = (size) => {
    const items = data.filter(Boolean);
    const otherItems = items.splice(size - 1);

    if (otherItems.length !== 0) {
        items.push({
            name: "Outro",
            dropdown: otherItems
        });
    }

    return items;
}

export { data, dataCompacted };
