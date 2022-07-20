import { createContext, useReducer } from "react";
import ThemeList from "./ThemeList";

const ThemeContext = createContext();
const ligthTheme = ThemeList.ligth;
const darkTheme = ThemeList.dark;

const themeReducer = (state, action) => {
    switch (action.type){
        case 'TOOGLE_THEME':
            localStorage.setItem(
                'theme',
                state.theme === darkTheme ? ligthTheme : darkTheme
            )
            return{
                theme: state.theme === darkTheme ? ligthTheme : darkTheme,
            };
        default:
            return state;
    }
};

const ThemeContextProvider = ({children}) => {
    const getInitialTheme = () => {
        const theme = localStorage.getItem('theme');
        const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;

        if(theme){
            return theme;
        }
        if(prefersDark){
            return darkTheme;
        }
        return ligthTheme;
    }

    const initialState = {
        theme: getInitialTheme(),
    };

    const [state, dispatch] = useReducer(themeReducer, initialState);

    const value = {
        theme: state.theme,
        toggleTheme: () => dispatch({type: 'TOGGLE_THEME'}),
    };

    return(
        <ThemeContext.Provider value={value}>
            {children}
        </ThemeContext.Provider>
    );
};

export {ThemeContextProvider};
export default ThemeContext;