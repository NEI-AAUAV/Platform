import config from "config";

const specialData = [
  config.ENABLE_GALA && {
    name: "Jantar de Gala",
    link: config.WEB_GALA_URL,
  },
  config.ENABLE_RALLY && {
    name: "Rally Tascas",
    link: config.WEB_RALLY_URL,
  },
];

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
        name: "Família de Faina",
        link: "/family",
      },
      {
        name: "Diário do Tux",
        link: "/tux",
        disabled: config.PRODUCTION,
      },
      {
        name: "Código de Faina",
        link: import.meta.env.BASE_URL + "faina-assets/CodigoFaina.pdf",
        external: true,
      },
    ],
  },
  {
    name: "Taça UA",
    dropdown: [
      {
        name: "Cancioneiro",
        link: import.meta.env.BASE_URL + "tacaua-assets/CancioneiroClaque.pdf",
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
].filter(Boolean);

const dataCompacted = (size) => {
  const items = [...data];
  const otherItems = items.splice(size - 1);

  if (otherItems.length !== 0) {
    items.push({
      name: "Outro",
      dropdown: otherItems,
    });
  }
  return items;
};

export { data, dataCompacted };
