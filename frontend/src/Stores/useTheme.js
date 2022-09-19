import create from 'zustand';

const defaultTheme = localStorage.getItem('theme') || (window.matchMedia('(prefers-color-scheme: dark)').matches ? "dark" : "light");


export const useTheme = create((set) => ({
    theme: defaultTheme,
    setTheme: (theme) => {
        localStorage.setItem('theme', theme);
        set(() => ({ theme }))
    },
}))
