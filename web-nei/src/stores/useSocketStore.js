import { create } from 'zustand';


export const useSocketStore = create((set, get) => ({
    activeUsers: 0,
    games: {
        1: { id: 1, team1: 'NEI', team2: "NEMec", score1: 2, score2: 3 }
    },

    setGame: (game) => {
        set(() => ({ games: { ...get().games, [game.id]: game } }));
    },

    setActivUsers: (activeUsers) => {
        set(() => ({ activeUsers }));
    }
}))
