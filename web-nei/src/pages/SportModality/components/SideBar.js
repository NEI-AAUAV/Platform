import { useState } from 'react';
import './SideBar.css';

const SideBar = () => {

    const [active, setActive] = useState("futsalM");

    const selectChange = (value) => {
        switch (value) {
            case "futsalM":
                setActive("futsalM");
                break;
            case "futsalF":
                setActive("futsalF");
                break;
            case "andebol":
                setActive("andebol");
                break;
            case "basquetebol":
                setActive("basquetebol");
                break;
            case "futebol":
                setActive("futebol");
                break;
            default:
                return;
        }
    };

    return (
        <div className='side-bar'>
            <h4 className='side-bar-header'>Modalidades</h4>
            <div className='side-bar-item'>
                <p>2019 ____________________</p>
                <ul>
                    <li className={active === "futsalM" ? "side-bar-item-active" : "side-bar-list-item"} onClick={() => selectChange("futsalM")}>Futsal Masculino</li>
                    <li className={active === "futsalF" ? "side-bar-item-active" : "side-bar-list-item"} onClick={() => selectChange("futsalF")}>Futsal Feminino</li>
                    <li className={active === "andebol" ? "side-bar-item-active" : "side-bar-list-item"} onClick={() => selectChange("andebol")}>Andebol</li>
                    <li className={active === "basquetebol" ? "side-bar-item-active" : "side-bar-list-item"}onClick={() => selectChange("basquetebol")}>Basquetebol</li>
                    <li className={active === "futebol" ? "side-bar-item-active" : "side-bar-list-item"} onClick={() => selectChange("futebol")}>Futebol</li>
                </ul>
            </div>
            <div className='side-bar-item'>
                <p>2020 ____________________</p>
                <ul>
                    <li>Futsal Masculino</li>
                    <li>Basquetebol</li>
                </ul>
            </div>
        </div>
    )
}

export default SideBar;