import React from "react";
import { useUserStore } from "stores/useUserStore";

/**
 *
 * @param {{
 * place: int,
 * modality: {
    *  image: string,
    *  sport: string,
    *  frame: string,
    *  type: string,
    *  competitions: {
    *    name: string,
    *    division: number
    *    id: number
    *  }[]
    * },
    * className: string
    * }} props
    * @returns
    *
    * @example
    * <SportsCard
    * modality={{
    *  image: "https://i.imgur.com/4Z5wQ9M.png",
    *  sport: "Futebol 7",
    *  frame: "Masculino",
    *  type: "Equipa",
    *  competitions: [
    *   {
    *     name: "Liga Universitária",
    *     division: 1,
    *     id: 1,
    *   },
    *   {
    *     name: "Liga Universitária",
    *     division: 2,
    *     id: 2,
    *   },
    *  ],
    * }}
    * className="w-full"
    * />
    *
    */


const GRADIENTS_LIGHT = {
    1: "bg-gradient-to-br from-[#C9B03780] to-[#FFFFFF]",
    2: "bg-gradient-to-br from-[#C9C9C980] to-[#FFFFFF]",
    3: "bg-gradient-to-br from-[#C9743780] to-[#FFFFFF]",
};

const GRADIENTS_DARK = {
    1: "bg-gradient-to-br from-[#C9B03780] to-[#000000]",
    2: "bg-gradient-to-br from-[#C9C9C980] to-[#000000]",
    3: "bg-gradient-to-br from-[#C9743780] to-[#000000]",
};

const CardHall = ({ place, modality, className,width,refe }) => {
    const theme = useUserStore((state) => state.theme);
    const { image, sport } = modality;

    const gradients = theme === "light" ? GRADIENTS_LIGHT : GRADIENTS_DARK;
    const gradient = gradients[place] ?? "";

    if (width >= 1024){
        return (
            <div className={`${className} flex-none w-72`} ref={refe}>
                <div className={`flex flex-col items-center py-10 ${gradient} rounded-[20px]`}>
                    <img src="https://i.imgur.com/XLUTJiE.png"/>
                    <div className="font-bold text-xl text-center p-5">{place}º lugar</div>
                    <div className="flex flex-row font-medium text-md text-center py-1">
                        <img className="aspect-square block max-h-6" src={image} alt="sport img"/>
                        <span className="px-1">{sport}</span>
                    </div>
                    <div className="font-light text-sm text-center p-1">2022/2023</div>
                </div>
            </div>
        )

    }else{
        return(
            <div className={`${className} flex-none w-full`} ref={refe}>
                <div className={`flex items-center gap-6 ${gradient} rounded-[20px] p-5`}>
                    <img className=" w-[25%]" src="https://i.imgur.com/XLUTJiE.png"/>
                    <div>
                        <div className="font-bold text-lg pb-3">{place}º lugar</div>
                        <div className="flex flex-row font-medium text-md">
                            <img className="aspect-square block max-h-6" src={image} alt="sport img"/>
                            <span className="px-1 text-sm">{sport}</span>
                        </div>
                        <div className="font-light text-sm text-center p-1">2022/2023</div>
                    </div>
                </div>
            </div>
        );
    }
}

export default CardHall