import { useState } from "react";
import React from "react";


const GameCard = ({ props }) => {

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
        <div class="card h-70 max-w-lg bg-[#262626]">
            <div class="grid grid-cols-2 pt-4 pr-4 pl-4 text-white font-bold">
                <p>{props.modalidade}</p>
                <p class="text-right">Grupo  A | Jornada 1</p>
            </div>
            <div class="grid grid-cols-3 pt-4 pb-1 text-md">
                <p className="pl-4">PAH</p>
                <p className="place-self-center">31 Março</p>
                {time}
            </div>
            <div className="rounded-b-[20px] grid grid-cols-3 bg-[#1F1F1F] pt-4">
                <div>
                    <div className="flex justify-center">
                        <img onMouseEnter={() => setIsShown(true)}
                            onMouseLeave={() => setIsShown(false)} className="max-h-[110px] transition hover:-translate-y-4 hover:max-h-[80px]" src={props.img2} />
                    </div>
                    {isShown && (
                        <div className="text-center transition -translate-y-8 font-bold text-lg">Gestao comercial</div>
                    )}
                </div>
                <div>
                    <p className="text-center text-4xl text-white font-bold">{props.score1} - {props.score2}</p>
                    <p className="text-center text-2xl font-bold">({props.penalti1}) - ({props.penalti2})</p>
                </div>
                <div>
                    <div onMouseEnter={() => setIsShown2(true)}
                            onMouseLeave={() => setIsShown2(false)} className="flex flex-col justify-center">
                        <img  className="max-h-[110px] transition hover:-translate-y-4 hover:max-h-[80px]" src={props.img2} />
                    {isShown2 && (
                        <div className="text-center transition -translate-y-8 font-bold text-lg">Tecnol. Informaçao</div>
                    )}
                    </div>
                </div>
            </div>
        </div>
    )
}

export default GameCard