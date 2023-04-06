module.exports = {
  mode: "jit",
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
    // Add the flowbite-datepicker library tailwind classes
    "./node_modules/flowbite-datepicker/**/*.{js,jsx,ts,tsx}",
  ],
  darkMode: ["class", '[data-theme="dark"]'],
  theme: {
    extend: {
      screens: {
        xs: "576px",
      },
      transitionDuration: {
        DEFAULT: "250ms",
      },
      transitionProperty: {
        background: "color, background-color",
        size: "margin, padding, height, width, color, background-color, transform",
        hover: "box-shadow, transform, filter",
      },
      width: {
        "1/7": "14.2857%",
      },
      keyframes: {
        wiggle: {
          "0%": { transform: "translateX(0)" },
          "25%": { transform: "translateX(0.25em)" },
          "75%": { transform: "translateX(-0.25em)" },
          "100%": { transform: "translateX(0)" },
        },
      },
      animation: {
        wiggle: "wiggle 0.2s ease-in-out 0s 2",
      },
      colors: {
        // Primary
        primary: {
          DEFAULT: "#26AB55",
          100: "#C5EACE",
          200: "#9FDDB0",
          300: "#76D090",
          400: "#55C577",
          500: "#2FBA5F",
          600: "#26AB55",
          700: "#1A9849",
          800: "#0D873E",
          900: "#006729",
        },
        // Danger
        danger: {
          DEFAULT: "#E83E34",
          100: "#FFCED2",
          200: "#F19C9A",
          300: "#E77573",
          400: "#F1564F",
          500: "#F64734",
          600: "#E83E34",
          700: "#D6342E",
          800: "#C92D27",
          900: "#BA221B",
        },
        // Warning
        warning: {
          DEFAULT: "#DCA825",
          100: "#F3E7B5",
          200: "#EBD885",
          300: "#E4CA58",
          400: "#E0BE3A",
          500: "#DCB42B",
          600: "#DCA825",
          700: "#DB971F",
          800: "#D9881A",
          900: "#D66E14",
        },
        // Info
        info: {
          DEFAULT: "#07A2AE",
          100: "#B0E7EA",
          200: "#7ED8DD",
          300: "#4CC8D0",
          400: "#28BCC7",
          500: "#05BIC0",
          600: "#07A2AE",
          700: "#0B8D95",
          800: "#0C797E",
          900: "#095655",
        },
        // Success
        success: {
          DEFAULT: "#37AB26",
          100: "#C9EAC3",
          200: "#A5DC9D",
          300: "#7FD073",
          400: "#61C553",
          500: "#42BA2F",
          600: "#37AB26",
          700: "#289819",
          800: "#178708",
          900: "#006800",
        },
        // Base
        base: {
          primary: "var(--ds-base-primary)",
          secondary: "var(--ds-base-secondary)",
        },
      },
    },
  },
  variants: {},
  plugins: [require("daisyui"), require("@emotion/react")],
  daisyui: {
    logs: false,
    themes: [
      {
        light: {
          ...require("daisyui/src/colors/themes")["[data-theme=light]"],
          primary: "#26AB55",
          accent: "#26AB55",
          error: "#E83E34",
          warning: "#DCA825",
          info: "#07A2AE",
          success: "#37AB26",
          // Base
          "base-100": "#EBEBEB",
          "base-200": "#F2F2F2",
          "base-300": "#FBFBFB",
          "--ds-base-primary": "#EBEBEB",
          "--ds-base-secondary": "#F2F2F2",
          // Content
          "primary-content": "#141414",
          "base-content": "#2A2A2A",
          "secondary-content": "#666666",
          "neutral-content": "#AAAAAA",
        },
      },
      {
        dark: {
          ...require("daisyui/src/colors/themes")["[data-theme=dark]"],
          primary: "#26AB55",
          accent: "#26AB55",
          error: "#E83E34",
          warning: "#DCA825",
          info: "#07A2AE",
          success: "#37AB26",
          // Base
          "base-100": "#141414",
          "base-200": "#161616",
          "base-300": "#1A1A1A",
          "--ds-base-primary": "#141414",
          "--ds-base-secondary": "#161616",
          // Content
          "primary-content": "#FFFFFF",
          "base-content": "#F0F0F0",
          "secondary-content": "#909090",
          "neutral-content": "#7A7A7A",
        },
      },
    ],
  },
};
