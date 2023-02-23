module.exports = {
    content: [
        "./src/**/*.{js,jsx,ts,tsx}",
    ],
    theme: {
        extend: {
            transitionDuration: {
                DEFAULT: '250ms',
            },
            transitionProperty: {
                size: 'margin, padding, height, width',
            },
            width: {
                '1/7': '14.2857%',
            }
        }
    },
    plugins: [require("daisyui")],

    daisyui: {
        themes: [
            {
                light: {
                    ...require("daisyui/src/colors/themes")["[data-theme=light]"],
                    primary: "#19a24aff",
                    secondary: "#086c2e",
                    "primary-focus": "#086c2e",
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
