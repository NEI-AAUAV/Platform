import { create } from 'zustand';

const defaultTheme = localStorage.getItem('th') || (window.matchMedia('(prefers-color-scheme: dark)').matches ? "dark" : "light");
document.body.setAttribute('data-theme', defaultTheme);

export const useUserStore = create((set) => ({
    theme: defaultTheme,
    name: "Jorden",
    surname: "Foreest",
    loggedIn: true,
    setTheme: (theme) => {
        localStorage.setItem('th', theme);
        document.body.setAttribute('data-theme', theme);
        set(() => ({ theme }));
    },
    login: (data) => {
        set(() => ({ loggedIn: true }));
    },
    logout: () => {
        set(() => ({ loggedIn: false }));
    }
}))
