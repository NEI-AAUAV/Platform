const data = [
    {
        'name': 'Notícias',
        'link': '/noticias'
    },
    {
        'name': 'Estudo',
        'dropdown': [
            {
                'name': 'Apontamentos',
                'link': '/apontamentos'
            },
            {
                'name': 'Vídeos',
                'link': '/videos'
            }
        ]
    },
    {
        'name': 'Calendário',
        'link': '/calendario'
    },
    {
        'name': 'NEI',
        'dropdown': [
            {
                'name': 'História',
                'link': '/historia'
            },
            {
                'name': 'Equipa',
                'link': '/equipa'
            },
            {
                'name': 'Novos alunos',
                'link': 'https://www.ua.pt/pt/deti',
                'external': true
            },
        ]
    },
    {
        'name': 'RGM',
        'dropdown': [
            {
                'name': 'PAOs',
                'link': '/rgm/pao'
            },
            {
                'name': 'RACs',
                'link': '/rgm/rac'
            },
            {
                'name': 'Atas',
                'link': '/rgm/atas'
            }
        ]
    },
    {
        'name': 'Merchandising',
        'link': '/merch'
    },
    {
        'name': 'Faina',
        'dropdown': [
            {
                'name': 'Comissões de Faina',
                'link': '/faina'
            },
            {
                'name': 'Código de Faina',
                'link': process.env.REACT_APP_STATIC + '/faina/CodigoFaina.pdf',
                'external': true
            }
        ]
    },
    {
        'name': 'Finalistas',
        'dropdown': [
            {
                'name': 'Licenciatura',
                'link': '/seniors/LEI'
            },
            {
                'name': 'Mestrado',
                'link': '/seniors/MEI'
            }
        ]
    },
    {
        'name': 'Estágios',
        'link': '/estagios'
    },
    {
        'name': 'Parceiros',
        'link': '/parceiros'
    },
]

export default data;