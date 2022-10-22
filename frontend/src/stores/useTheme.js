import create from 'zustand';

const defaultTheme = localStorage.getItem('theme') || (window.matchMedia('(prefers-color-scheme: dark)').matches ? "dark" : "light");
document.body.setAttribute('data-theme', defaultTheme);

export const useTheme = create((set) => ({
    theme: defaultTheme,
    setTheme: (theme) => {
        localStorage.setItem('theme', theme);
        document.body.setAttribute('data-theme', theme)
        set(() => ({ theme }))
    },
}))
