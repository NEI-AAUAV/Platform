import { useState } from "react";
import React from "react";
import classNames from "classnames";
import { useUserStore } from "stores/useUserStore";


const GRADIENTS_LIGHT = {
    "Voleibol 4x4": "bg-gradient-to-r from-[#f6d5f7] to-[#fbe9d7]",
};

const GRADIENTS_DARK = {
    Atletismo: "bg-gradient-to-r from-[#b429f9] to-[#26c5f3]",
    Andebol: "bg-gradient-to-r from-[#ff930f] to-[#fff95b]",
    Basquetebol: "bg-gradient-to-r from-[#ce653b] to-[#2b0948]",
    Futsal: "bg-gradient-to-r from-[#D22730] to-[#D19B28]",
    "Futebol 7": "bg-gradient-to-r from-[#0f971c] to-[#0c0c0c]",
    "Voleibol 4x4": "bg-gradient-to-r from-[#EF47FC] to-[#F3E2E2]",
    "E-Sports LOL": "bg-gradient-to-r from-[#C29A3F] to-[#138D9B]",
    "E-Sports CS:GO": "bg-gradient-to-r from-[#BB460C] to-[#E9B75B]",
};

const GameCard = ({ props }) => {
    const theme = useUserStore((state) => state.theme);

    const gradients = theme === "light" ? GRADIENTS_LIGHT : GRADIENTS_DARK;
    const gradient = gradients[props.sport] ?? "";

    let time;
    if (props.live) {
        time = <div className="bg-[#C82643]/[0.15] rounded-[20px] py-1 max-w-[100px] max-h-[29px] text-right place-self-end px-3 mr-2 text-sm mb-1">
            <p className="text-center text-sm text-[#C82643] font-bold">• Em direto</p>
        </div>;
    } else {
        time = <p className="place-self-end px-4">{props.time}</p>;
    }

    const [isShown, setIsShown] = useState(false);
    const [isShown2, setIsShown2] = useState(false);

    return (
        <div class="flex-none h-70 max-w-lg w-96 bg-base-300 group  rounded-b-[20px] drop-shadow-lg">
            <div class="grid grid-cols-2 pt-4 pr-4 pl-4 text-base-content font-bold">
                <p>{props.sport} {props.type}</p>
                <p class="text-right">Grupo  {props.Group} | Jornada {props.jornada}</p>
            </div>
            <div class="grid grid-cols-3 pt-4 pb-1 text-md">
                <p className="pl-4">PAH</p>
                <p className="place-self-center">{props.date}</p>
                {time}
            </div>
            <div
                className={`relative text-blue-400 border-none brightness-75 w-full scale-x-[0.25] place-self-center group-hover:brightness-110 group-hover:scale-100 h-1 ${gradient} transition transition-duration-400`}
            >
                <div
                    className={`absolute opacity-0 -inset-[1px] blur-lg ${gradient} group-hover:opacity-100 brightness-110 transition-opacity transition-duration-400 `}
                ></div>
            </div>
            <div className="rounded-b-[20px] grid grid-cols-3 bg-base-200 pt-4">
                <div onMouseEnter={() => setIsShown(true)} onMouseLeave={() => setIsShown(false)} className="flex flex-col justify-center">
                    <img className={classNames('max-h-[110px] transition ', { '-translate-y-4 max-h-[80px]': isShown })} src={props.img1} />
                    {isShown && (
                        <div className="text-center transition -translate-y-8 font-bold text-lg">{props.team1}</div>
                    )}
                </div>
                <div className="text-base-content">
                    <p className="text-center text-4xl font-bold">{props.score1} - {props.score2}</p>
                    <p className="text-center text-2xl font-bold">({props.penalti1}) - ({props.penalti2})</p>
                </div>
                <div onMouseEnter={() => setIsShown2(true)} onMouseLeave={() => setIsShown2(false)} className="flex flex-col justify-center">
                    <img className={classNames('max-h-[110px] transition ', { '-translate-y-4 max-h-[80px]': isShown2 })} src={props.img2} />
                    {isShown2 && (
                        <div className="text-center transition -translate-y-8 font-bold text-lg">{props.team2}</div>
                    )}
                </div>
            </div>
        </div>
    )
}

export default GameCard