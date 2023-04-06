module.exports = {
    mode: 'jit',
    content: [
        "./src/**/*.{js,jsx,ts,tsx}",
    ],
    theme: {
        extend: {
            screens: {
                'xs': '576px',
            },
            transitionDuration: {
                DEFAULT: '250ms',
            },
            transitionProperty: {
                background: 'color, background-color',
                size: 'margin, padding, height, width, color, background-color, transform',
                hover: 'box-shadow, transform, filter',
            },
            width: {
                '1/7': '14.2857%',
            }
        }
    },
    variants: {},
    plugins: [require("daisyui"), require("@emotion/react")],
    daisyui: {
        themes: [
            {
                light: {
                    ...require("daisyui/src/colors/themes")["[data-theme=light]"],
                    primary: "#19a24aff",
                    secondary: "#086c2e",
                    "primary-focus": "#086c2e",
                    "base-100": "#e6e6eb",
                    "base-200": "#f0f0f5",
                    "base-300": "#f5f5fa",
                },
            },
            {
                dark: {
                    ...require("daisyui/src/colors/themes")["[data-theme=dark]"],
                    // "base-100": "#0f0f0f",
                    // "base-200": "#161616",
                    // "base-300": "#2f2f2f",
                    "base-100": "#0c0c0f",
                    "base-200": "#13131a",
                    "base-300": "#1f1f29",
                },
            },

        ],
    },
}
