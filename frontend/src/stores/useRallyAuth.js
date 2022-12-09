import create from 'zustand';

const storage = {
    NAME: 'nm',
    TEAM_NAME: 'tn',
    TOKEN: 'tk',
    STAFF: 'is',
    ADMIN: 'ia'
}

export const useRallyAuth = create((set) => ({
    ready: !!localStorage.getItem('secret'),
    name: localStorage.getItem(storage.NAME),
    teamName: localStorage.getItem(storage.TEAM_NAME),
    token: localStorage.getItem(storage.TOKEN),
    isStaff: localStorage.getItem(storage.STAFF),
    isAdmin: !!localStorage.getItem(storage.ADMIN),

    setTeamName: (teamName) => {
        localStorage.setItem(storage.TEAM_NAME, teamName);
        set(() => ({ teamName }))
    },
    setReady: () => {
        localStorage.setItem('secret', 1);
        set(() => ({ ready: true }))
    },
    login: ({ name, access_token, staff_checkpoint_id, is_admin }) => {
        localStorage.setItem(storage.NAME, name);
        localStorage.setItem(storage.TOKEN, access_token);
        staff_checkpoint_id ?
            localStorage.setItem(storage.STAFF, staff_checkpoint_id) : localStorage.removeItem(storage.STAFF);
        is_admin ?
            localStorage.setItem(storage.ADMIN, 1) : localStorage.removeItem(storage.ADMIN);
        set(() => ({ name, token: access_token, isStaff: staff_checkpoint_id, isAdmin: is_admin }))
    },
    logout: () => {
        for (const key of Object.values(storage)) {
            localStorage.removeItem(key);
        }
        set(() => ({ name: null, teamName: null, token: null, isStaff: null, isAdmin: null }))
    },
}))
