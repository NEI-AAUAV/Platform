import './TopBar.css';
import Dropdown from 'react-bootstrap/Dropdown';
import img from './football.png';
import { useState } from 'react';

const TopBar = () => {

    const [active, setActive] = useState("jogos");

    const selectChange = (value) => {
        switch (value) {
            case "jogos":
                setActive("jogos");
                break;
            case "classificacao":
                setActive("classificacao");
                break;
            case "equipa":
                setActive("equipa");
                break;
            default:
                return;
        }
    };

    return (
        <div className='top-bar'>
            <div className='top-bar-items'>
                <div className='top-bar-image-wrapper'>
                    <img src={img}></img>
                </div>
                <div className='top-bar-items-header'>
                    <h3>Futsal Masculino</h3>
                    <Dropdown className='top-bar-items-header-dropdown' style={{outline: 'none'}}>
                        <Dropdown.Toggle id="dropdown-basic" style={{border: 'none', background: 'none', color:'#000'}}>
                            2019
                        </Dropdown.Toggle>

                        <Dropdown.Menu>
                            <Dropdown.Item>2019</Dropdown.Item>
                            <Dropdown.Item>2020</Dropdown.Item>
                        </Dropdown.Menu>
                    </Dropdown>
                </div>
            </div>
            <div className='top-bar-items-list'>
                <ul>
                    <li className={active === "jogos" ? "top-bar-item-active" : "top-bar-list-item"} onClick={() => selectChange("jogos")}>Jogos</li>
                    <li className={active === "classificacao" ? "top-bar-item-active" : "top-bar-list-item"} onClick={() => selectChange("classificacao")}>Classificações</li>
                    <li className={active === "equipa" ? "top-bar-item-active" : "top-bar-list-item"} onClick={() => selectChange("equipa")}>Equipa</li>
                </ul>
            </div>
        </div>
    )
}

export default TopBar;