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
                disabled: config.PRODUCTION,
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
                disabled: config.PRODUCTION,
            },
            {
                name: "Código de Faina",
                link: process.env.PUBLIC_URL + "/faina/CodigoFaina.pdf",
                external: true,
            },
        ],
    },
    {
        name: "Notícias",
        link: "/news",
        disabled: config.PRODUCTION,
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
        disabled: config.PRODUCTION,
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
    },
    config.ENABLE_GALA && {
        name: "Jantar de Gala",
        link: config.WEB_GALA_URL,
    },
    config.ENABLE_RALLY && {
        name: "Jantar de Gala",
        link: config.WEB_RALLY_URL,
    }
].filter(Boolean);


const dataCompacted = (size) => {
    const items = [...data];
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
