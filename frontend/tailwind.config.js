module.exports = {
    content: [
        "./src/**/*.{js,jsx,ts,tsx}",
    ],
    theme: {
        extend: false,
    },
    plugins: [require("daisyui")],

    daisyui: {
        themes: [
            {
                light: {
                    ...require("daisyui/src/colors/themes")["[data-theme=light]"],
                    primary: "blue",
                    "primary-focus": "mediumblue",
                    error: "green"
                },
            },
            {
                dark: {
                    ...require("daisyui/src/colors/themes")["[data-theme=dark]"],
                    "base-100": "#0f0f0f",
                    "base-200": "#161616",
                    "base-300": "#2f2f2f"
                },
            },
        ],
    },
}
