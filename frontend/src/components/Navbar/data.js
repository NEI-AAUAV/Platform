import config from "config";

const data = [
  {
    name: "Notícias",
    link: "/noticias",
  },
  {
    name: "Estudo",
    dropdown: [
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
    name: "Calendário",
    link: "/calendario",
  },
  {
    name: "NEI",
    dropdown: [
      {
        name: "História",
        link: "/historia",
      },
      {
        name: "Equipa",
        link: "/equipa",
      },
      {
        name: "Novos alunos",
        link: "https://www.ua.pt/pt/deti",
        external: true,
      },
    ],
  },
  {
    name: "RGM",
    dropdown: [
      {
        name: "PAOs",
        link: "/rgm/pao",
      },
      {
        name: "RACs",
        link: "/rgm/rac",
      },
      {
        name: "Atas",
        link: "/rgm/atas",
      },
    ],
  },
  {
    name: "Merchandising",
    link: "/merch",
  },
  !config.PRODUCTION && {
    name: "Desporto",
    dropdown: [
      {
        name: "Taça UA",
        link: "/desporto",
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
        name: "Código de Faina",
        link: process.env.PUBLIC_URL + "/faina/CodigoFaina.pdf",
        external: true,
      },
      {
        name: "Famílias de Faina",
        link: "/familias",
      },
    ],
  },
  {
    name: "Finalistas",
    dropdown: [
      {
        name: "Licenciatura",
        link: "/seniors/LEI",
      },
      {
        name: "Mestrado",
        link: "/seniors/MEI",
      },
    ],
  },
  // {
  //   name: "Estágios",
  //   link: "/estagios",
  // },
  {
    name: "Parceiros",
    link: "/parceiros",
  },
  // {
  //   name: "Rally Tascas",
  //   link: "/breakthebars",
  // },
];

export default data;
