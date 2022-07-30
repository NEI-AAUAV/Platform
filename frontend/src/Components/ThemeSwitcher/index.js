
import React, { useState } from "react";
import { FiSun, FiMoon } from "react-icons/fi"
import styled from "styled-components";

import { useTheme } from "Stores/useTheme";

const ThemeSwitcherStyles = styled.div`
    label{
        --gap: 5px;
        --size:25px;
        height:40px;
        width: 60px;
        margin-top:5px;
        padding: 0 5px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: relative;
        cursor: pointer;
        background-color: var(--background);
        border: 2px solid green;
        border-radius: 45px;
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
            color: var(--text-secondary);
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
        background-color: #228B22;
        z-index:-1;
        transition: 0.5s ease left;
    }

    input:checked + label::after{
        left:calc(100% - var(--size) - var(--gap));
    }

`;

function ThemeSwitcher() {

    const theme = localStorage.getItem('theme', useTheme(state => state.theme));

    const toggleTheme = () => {
        useTheme.getState().setTheme(theme === "light" ? "dark" : "light");
        localStorage.setItem('theme', (theme === "light" ? "dark" : "light"))
    }

    console.log(localStorage)

    return (
        <ThemeSwitcherStyles>
            <input value={theme} onChange={toggleTheme} type="checkbox" id="switcher" />
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