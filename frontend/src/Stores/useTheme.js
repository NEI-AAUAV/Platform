import create from 'zustand';

const defaultDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

export const useTheme = create((set) => ({
    theme: defaultDark ? 'light' : 'dark',
    setTheme: (theme) => set(() => ({ theme })),
}))
