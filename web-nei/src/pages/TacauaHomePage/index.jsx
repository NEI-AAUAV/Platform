import React from "react";
import { useState, useEffect, useRef, useLayoutEffect} from 'react';
import { useUserStore } from "stores/useUserStore";
import Typist from "react-typist";
import backgroundImg from "../Sports/img/unknown2.png";
import nei from "../Sports/img/nei.png";
import { SportsCard,CardHall,GameCard,Carousel } from "components";

//react query


export function Component() {

    const [width, setWidth] = useState(window.innerWidth);

    useEffect(() =>{
        const handleWindowSize = () => {
            setWidth(window.innerWidth);
        };

        window.addEventListener('resize',handleWindowSize);

        return () => {
            window.removeEventListener('resize',handleWindowSize);
        };
    }, []);


    const cardHallRef = useRef(null);
    const cardGameRef = useRef(null);
    const cardSportref = useRef(null);

    const [cardHallwidth, setCardHallwidth] = useState(0);
    const [cardGamewidth, setCardGamewidth] = useState(0);
    const [cardSportwidth, setCardSportwidth] = useState(0);

    useLayoutEffect(() => {
        setCardHallwidth(cardHallRef.current.offsetWidth);
        setCardGamewidth(cardGameRef.current.offsetWidth);
        setCardSportwidth(cardSportref.current.offsetWidth);
    }, []);

    
    
    
    if(width >= 1024){

        return (
            <div className="grid gap-16 place-content-center place-items-center space-y-3">
                <div>
                    <span className="text-3xl font-bold "><Typist>Taça UA</Typist></span>
                    <span className="text-2xl">2022/23</span>
                </div>
                    <div className="relative bg-gradient-to-b rounded-[20px] from-[#7a7876] to-[#000000]">
                        <img className="object-cover rounded-[20px] mix-blend-overlay" src={backgroundImg}/>
                        <div className="grid absolute m-8 top-0 backdrop-blur-md backdrop-brightness-50 w-1/3 h-1/3 bg-transparent rounded-[20px] p-8">
                            <div className="text-2xl font-bold place-self-center"><p>Junta-te ao <t className="text-primary">mágico EI</t></p></div>
                            <div className="grid gap-1 py-8">
                                <p className="font-bold">A Taça UA está de volta!</p>
                                <p>Inscreve-te neste formulário e vem defender o teu curso numa das modalidades existentes.</p>
                                <p>Esperamos ver te brilhar por EI.</p>
                            </div>
                            <button class="btn btn-primary place-self-center">Instcrever</button>
                        </div>
                        <div className="absolute flex top-1/2 flex-wrap gap-8 [&>*]:grow [&>*]:shrink [&>*]:basis-96 [&>*]:flex [&>*]:justify-center [&>*>*]:grow [&>*>*]:shrink p-4">
                            <div>
                                <SportsCard refe={cardSportref}
                                modality={{
                                    image:
                                    "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                                    sport: "Atletismo",
                                    frame: "Masculino",
                                    type: "Coletivo",
                                    competitions: [
                                    {
                                        name: "Fase de Grupos",
                                        division: 1,
                                        id: 1,
                                    },
                                    {
                                        name: "Playoffs",
                                        division: 2,
                                        id: 2,
                                    },
                                    ],
                                }}
                                />
                            </div>
                            <div>
                                <SportsCard
                                modality={{
                                    image:
                                    "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                                    sport: "Andebol",
                                    frame: "Masculino",
                                    type: "Coletivo",
                                    competitions: [
                                    {
                                        name: "Fase de Grupos",
                                        division: 2,
                                        id: 1,
                                    },
                                    {
                                        name: "Playoffs",
                                        division: 2,
                                        id: 2,
                                    },
                                    ],
                                }}
                                />
                            </div>
                            <div>
                                <SportsCard
                                modality={{
                                    image:
                                    "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                                    sport: "Basquetebol",
                                    frame: "Masculino",
                                    type: "Coletivo",
                                    competitions: [
                                    {
                                        name: "Fase de Grupos",
                                        division: 10,
                                        id: 1,
                                    },
                                    {
                                        name: "Playoffs",
                                        division: 2,
                                        id: 2,
                                    },
                                    ],
                                }}
                                />
                            </div>
                            <div>
                                <SportsCard
                                modality={{
                                    image:
                                    "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                                    sport: "Futsal",
                                    frame: "Masculino",
                                    type: "Coletivo",
                                    competitions: [
                                    {
                                        name: "Fase de Bananas",
                                        division: 1,
                                        id: 1,
                                    },
                                    {
                                        name: "Playoffs",
                                        division: 2,
                                        id: 2,
                                    },
                                    ],
                                }}
                                />
                            </div>
                            <div>
                                <SportsCard
                                modality={{
                                    image:
                                    "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                                    sport: "Futebol 7",
                                    frame: "Monkey",
                                    type: "Coletivo",
                                    competitions: [
                                    {
                                        name: "Ooga Booga",
                                        division: 1,
                                        id: 1,
                                    },
                                    {
                                        name: "Aaa ooh",
                                        division: 2,
                                        id: 2,
                                    },
                                    ],
                                }}
                                />
                            </div>
                        </div>
                    </div>
                    <div className="grid gap-8 w-full p-8 bg-base-200 rounded-[20px] place-content-center place-items-center">
                        <div class="flex gap-3 bg-base-100 rounded-full p-3">
                            <button class="btn btn-primary place-self-center">Últimos Jogos</button>
                            <button class="btn btn-neutral place-self-center">Próximos Jogos</button>
                        </div>
                        <Carousel width={cardGamewidth} buttons={true}>
                            <GameCard refe={cardGameRef} props={{
                                sport:"Futsal",
                                live:1,
                                type:"Masculino",
                                date:"1 Janeiro",
                                score1:"10",
                                score2:"11",
                                team1:"Informatica",
                                team2:"Linguas",
                                penalti1:"1",
                                penalti2:"2",
                                img1:nei,
                                img2:nei
                            }}
                            />
                            <GameCard props={{
                                sport:"Futsal",
                                live:1,
                                type:"Masculino",
                                date:"1 Janeiro",
                                score1:"10",
                                score2:"11",
                                team1:"Informatica",
                                team2:"Linguas",
                                penalti1:"1",
                                penalti2:"2",
                                img1:nei,
                                img2:nei
                            }}
                            />
                            <GameCard props={{
                                sport:"Futsal",
                                live:1,
                                type:"Masculino",
                                date:"1 Janeiro",
                                score1:"10",
                                score2:"11",
                                team1:"Informatica",
                                team2:"Linguas",
                                penalti1:"1",
                                penalti2:"2",
                                img1:nei,
                                img2:nei
                            }}
                            />
                        </Carousel>
                    </div>
                    <div className="grid gap-8 w-full p-8 bg-base-200 rounded-[20px]">
                        <h4 className="place-self-center font-bold text-2xl">Deti Hall</h4>
                        <Carousel width={cardHallwidth} buttons={true}>
                            <CardHall place={3} width={width} refe={cardHallRef}
                            modality={{
                            image:
                            "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                            sport: "Voleibol 4x4 Femenino",
                            frame: "Masculino",
                            type: "Coletivo",
                            competitions: [
                            {
                                name: "Fase de Grupos",
                                division: 2,
                                id: 1,
                            },
                            {
                                name: "Playoffs",
                                division: 2,
                                id: 2,
                            },
                            ],
                            }}/>
                            <CardHall place={3} width={width}
                            modality={{
                            image:
                            "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                            sport: "Voleibol 4x4 Femenino",
                            frame: "Masculino",
                            type: "Coletivo",
                            competitions: [
                            {
                                name: "Fase de Grupos",
                                division: 2,
                                id: 1,
                            },
                            {
                                name: "Playoffs",
                                division: 2,
                                id: 2,
                            },
                            ],
                            }}/>
                            <CardHall place={3} width={width}
                            modality={{
                            image:
                            "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                            sport: "Voleibol 4x4 Femenino",
                            frame: "Masculino",
                            type: "Coletivo",
                            competitions: [
                            {
                                name: "Fase de Grupos",
                                division: 2,
                                id: 1,
                            },
                            {
                                name: "Playoffs",
                                division: 2,
                                id: 2,
                            },
                            ],
                            }}/>
                            <CardHall place={2} width={width}
                            modality={{
                            image:
                            "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                            sport: "Voleibol 4x4 Femenino",
                            frame: "Masculino",
                            type: "Coletivo",
                            competitions: [
                            {
                                name: "Fase de Grupos",
                                division: 2,
                                id: 1,
                            },
                            {
                                name: "Playoffs",
                                division: 2,
                                id: 2,
                            },
                            ],
                            }}/>
                            <CardHall place={1} width={width}
                                        modality={{
                                        image:
                                        "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                                        sport: "Voleibol 4x4 Femenino",
                                        frame: "Masculino",
                                        type: "Coletivo",
                                        competitions: [
                                        {
                                            name: "Fase de Grupos",
                                            division: 2,
                                            id: 1,
                                        },
                                        {
                                            name: "Playoffs",
                                            division: 2,
                                            id: 2,
                                        },
                                        ],
                                    }}/>
                            <CardHall place={2} width={width}
                                        modality={{
                                        image:
                                        "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                                        sport: "Voleibol 4x4 Femenino",
                                        frame: "Masculino",
                                        type: "Coletivo",
                                        competitions: [
                                        {
                                            name: "Fase de Grupos",
                                            division: 2,
                                            id: 1,
                                        },
                                        {
                                            name: "Playoffs",
                                            division: 2,
                                            id: 2,
                                        },
                                        ],
                                    }}/>
                            <CardHall place={2} width={width}
                                        modality={{
                                        image:
                                        "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                                        sport: "Voleibol 4x4 Femenino",
                                        frame: "Masculino",
                                        type: "Coletivo",
                                        competitions: [
                                        {
                                            name: "Fase de Grupos",
                                            division: 2,
                                            id: 1,
                                        },
                                        {
                                            name: "Playoffs",
                                            division: 2,
                                            id: 2,
                                        },
                                        ],
                                    }}/>
                        </Carousel>
                    </div>
            </div>
        );
    }else{
        return(
            <div className="grid gap-6 place-content-center place-items-center space-y-3 w-full">
                <div className="relative bg-gradient-to-b rounded-[20px] from-[#7a7876] to-[#000000] w-full h-[650px]">
                        <img className="object-cover rounded-[20px] mix-blend-overlay h-96 h-[650px]" src={backgroundImg}/>
                        <div className="grid absolute m-5 top-0 backdrop-blur-md backdrop-brightness-50 w-100% bg-transparent rounded-[20px] p-8">
                            <div className="text-2xl font-bold place-self-center"><p>Junta-te ao <t className="text-primary">mágico EI</t></p></div>
                            <div className="grid gap-1 py-8">
                                <p className="font-bold">A Taça UA está de volta!</p>
                                <p>Inscreve-te neste formulário e vem defender o teu curso numa das modalidades existentes.</p>
                                <p>Esperamos ver te brilhar por EI.</p>
                            </div>
                            <button class="btn btn-primary place-self-center">Instcrever</button>
                        </div>
                        <div className="absolute top-[55%] w-full p-8">
                        <Carousel width={cardSportwidth} buttons={false}>
                                <SportsCard className={"w-full"} refe={cardSportref}
                                modality={{
                                    image:
                                    "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                                    sport: "Futsal",
                                    frame: "Masculino",
                                    type: "Coletivo",
                                    competitions: [
                                    {
                                        name: "Fase de Bananas",
                                        division: 1,
                                        id: 1,
                                    },
                                    {
                                        name: "Playoffs",
                                        division: 2,
                                        id: 2,
                                    },
                                    ],
                                }}
                                />
                                <SportsCard className={"w-full"}
                                modality={{
                                    image:
                                    "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                                    sport: "Futebol 7",
                                    frame: "Monkey",
                                    type: "Coletivo",
                                    competitions: [
                                    {
                                        name: "Ooga Booga",
                                        division: 1,
                                        id: 1,
                                    },
                                    {
                                        name: "Aaa ooh",
                                        division: 2,
                                        id: 2,
                                    },
                                    ],
                                }}
                                />
                        </Carousel>
                        </div>
                </div>
                <div className="grid gap-8 w-full p-4 bg-base-200 rounded-[20px] place-content-center place-items-center">
                        <div class="flex gap-3 bg-base-100 rounded-full p-3">
                            <button class="btn btn-primary place-self-center">Últimos Jogos</button>
                            <button class="btn btn-neutral place-self-center">Próximos Jogos</button>
                        </div>
                        <div className="grid gap-2">
                            <GameCard refe={cardGameRef} props={{
                                sport:"Futsal",
                                live:1,
                                type:"Masculino",
                                date:"1 Janeiro",
                                score1:"10",
                                score2:"11",
                                team1:"Informatica",
                                team2:"Linguas",
                                penalti1:"1",
                                penalti2:"2",
                                img1:nei,
                                img2:nei
                            }}
                            />
                            <GameCard props={{
                                sport:"Futsal",
                                live:1,
                                type:"Masculino",
                                date:"1 Janeiro",
                                score1:"10",
                                score2:"11",
                                team1:"Informatica",
                                team2:"Linguas",
                                penalti1:"1",
                                penalti2:"2",
                                img1:nei,
                                img2:nei
                            }}
                            />
                            <GameCard props={{
                                sport:"Futsal",
                                live:1,
                                type:"Masculino",
                                date:"1 Janeiro",
                                score1:"10",
                                score2:"11",
                                team1:"Informatica",
                                team2:"Linguas",
                                penalti1:"1",
                                penalti2:"2",
                                img1:nei,
                                img2:nei
                            }}
                            />
                        </div> 
                </div>
                <div className="grid gap-8 w-full p-6 bg-base-200 rounded-[20px]">
                        <h4 className="place-self-center font-bold text-2xl">Deti Hall</h4>
                        <Carousel width={cardHallwidth} buttons={false}>
                            <CardHall place={3} width={width} refe={cardHallRef}
                            modality={{
                            image:
                            "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                            sport: "Voleibol 4x4 Femenino",
                            frame: "Masculino",
                            type: "Coletivo",
                            competitions: [
                            {
                                name: "Fase de Grupos",
                                division: 2,
                                id: 1,
                            },
                            {
                                name: "Playoffs",
                                division: 2,
                                id: 2,
                            },
                            ],
                            }}/>
                            <CardHall place={3} width={width}
                            modality={{
                            image:
                            "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                            sport: "Voleibol 4x4 Femenino",
                            frame: "Masculino",
                            type: "Coletivo",
                            competitions: [
                            {
                                name: "Fase de Grupos",
                                division: 2,
                                id: 1,
                            },
                            {
                                name: "Playoffs",
                                division: 2,
                                id: 2,
                            },
                            ],
                            }}/>
                            <CardHall place={3} width={width}
                            modality={{
                            image:
                            "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                            sport: "Voleibol 4x4 Femenino",
                            frame: "Masculino",
                            type: "Coletivo",
                            competitions: [
                            {
                                name: "Fase de Grupos",
                                division: 2,
                                id: 1,
                            },
                            {
                                name: "Playoffs",
                                division: 2,
                                id: 2,
                            },
                            ],
                            }}/>
                            <CardHall place={2} width={width}
                            modality={{
                            image:
                            "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                            sport: "Voleibol 4x4 Femenino",
                            frame: "Masculino",
                            type: "Coletivo",
                            competitions: [
                            {
                                name: "Fase de Grupos",
                                division: 2,
                                id: 1,
                            },
                            {
                                name: "Playoffs",
                                division: 2,
                                id: 2,
                            },
                            ],
                            }}/>
                            <CardHall place={1} width={width}
                                        modality={{
                                        image:
                                        "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                                        sport: "Voleibol 4x4 Femenino",
                                        frame: "Masculino",
                                        type: "Coletivo",
                                        competitions: [
                                        {
                                            name: "Fase de Grupos",
                                            division: 2,
                                            id: 1,
                                        },
                                        {
                                            name: "Playoffs",
                                            division: 2,
                                            id: 2,
                                        },
                                        ],
                                    }}/>
                            <CardHall place={2} width={width}
                                        modality={{
                                        image:
                                        "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                                        sport: "Voleibol 4x4 Femenino",
                                        frame: "Masculino",
                                        type: "Coletivo",
                                        competitions: [
                                        {
                                            name: "Fase de Grupos",
                                            division: 2,
                                            id: 1,
                                        },
                                        {
                                            name: "Playoffs",
                                            division: 2,
                                            id: 2,
                                        },
                                        ],
                                    }}/>
                            <CardHall place={2} width={width}
                                        modality={{
                                        image:
                                        "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                                        sport: "Voleibol 4x4 Femenino",
                                        frame: "Masculino",
                                        type: "Coletivo",
                                        competitions: [
                                        {
                                            name: "Fase de Grupos",
                                            division: 2,
                                            id: 1,
                                        },
                                        {
                                            name: "Playoffs",
                                            division: 2,
                                            id: 2,
                                        },
                                        ],
                                    }}/>
                        </Carousel>
                    </div>
            </div>
        );

    }
}
