
import React from "react";
import {FiSun, FiMoon} from "react-icons/fi"
import styled from "styled-components";

const ThemeSwitcherStyles = styled.div`
    label{
        --gap: 5px;
        --size:20px;
        height:30px;
        width: 55px;
        margin-top:5px;
        padding: 0 5px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: relative;
        cursor: pointer;
        background-color: white;
        border: 2px solid green;
        border-radius: 50px;
        z-index: 1;
        .icon{
            height: var(--size);
            width: var(--size);
            display:flex;
            align-items:center;
            justify-content:center;
        }
        svg{
            width: 75%;
            color: var(--green);
        }
    }

    input{
        width:0;
        height:0;
        display:none;
        visibility:hidden;
    }

    label::after{
        position: absolute;
        content: "";
        border-radius: 45%;
        transform: translateY(-50%);
        top: 50%;
        left:var(--gap);
        height: var(--size);
        width: var(--size);
        background-color: lightgreen;
        z-index:-1;
        transition: 0.5s ease left;
    }

    input:checked + label::after{
        left:calc(100% - var(--size) - var(--gap));
    }

`;

function ThemeSwitcher(){
    return(
        <ThemeSwitcherStyles>
            <input type="checkbox" id="switcher"/>
            <label htmlFor="switcher">
                <div className="icon">
                    <FiSun></FiSun>
                </div>
                <div className="icon">
                    <FiMoon></FiMoon>
                </div>
                
            </label>
        </ThemeSwitcherStyles>
    );
}

export default ThemeSwitcher;