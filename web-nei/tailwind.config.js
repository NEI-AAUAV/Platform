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
          DEFAULT: "#0D873E",
          100: "#CBF9CC",
          200: "#9BF3A4",
          300: "#64DB7C",
          400: "#3AB760",
          500: "#0D873E",
          600: "#09743E",
          700: "#06613C",
          800: "#044E38",
          900: "#024034",
        },
        // Success
        success: {
          DEFAULT: "#37AB26",
          100: "#E0FBD6",
          200: "#BDF7AF",
          300: "#8CE783",
          400: "#5FD05F",
          500: "#31B23C",
          600: "#239938",
          700: "#188034",
          800: "#0F672E",
          900: "#09552B",
        },
        // Info
        info: {
          DEFAULT: "#07A2AE",
          100: "#D0E6FB",
          200: "#A2CBF8",
          300: "#71A6EA",
          400: "#4B83D6",
          500: "#1A55BC",
          600: "#1341A1",
          700: "#0D3087",
          800: "#08216D",
          900: "#04175A",
        },
        // Warning
        warning: {
          DEFAULT: "#DCA825",
          100: "#FEF8CB",
          200: "#FEEE98",
          300: "#FCE265",
          400: "#FAD53E",
          500: "#F7C100",
          600: "#D4A100",
          700: "#B18200",
          800: "#8F6600",
          900: "#765100",
        },
        // Error
        error: {
          DEFAULT: "#E83E34",
          100: "#FCD4D8",
          200: "#FAAABA",
          300: "#F17EA0",
          400: "#E35B92",
          500: "#D12B7E",
          600: "#B31F78",
          700: "#96156F",
          800: "#790D63",
          900: "#64085B",
        },

        // Neutral
        // neutral: "var(--ds-neutral)",
        // "neutral-focus": "var(--ds-neutral-focus)",
        // "neutral-content": "var(--ds-neutral-content)",

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
          "primary-content": "#141414",
          secondary: "#3EAB65",
          accent: "#26AB55",

          // System
          error: "#E83E34",
          "error-content": "#64085B",
          warning: "#FEF8CB",
          "warning-content": "#765100",
          info: "#D0E6FB",
          "info-content": "#04175A",
          success: "#E0FBD6",
          "success-content": "#09552B",

          // Neutral
          // neutral: "#FFFFFF",
          // "neutral-focus": "#F9F9F9",
          // "neutral-content": "#777777",

          // Base
          "base-100": "#F3F3F3",
          "base-200": "#F9F9F9",
          "base-300": "#FFFFFF",
          "--ds-base-primary": "#F3F3F3",
          "--ds-base-secondary": "#F9F9F9",
          "base-content": "#101010",

          // Content
          "secondary-content": "#ffffff",
        },
      },
      {
        dark: {
          ...require("daisyui/src/colors/themes")["[data-theme=dark]"],
          primary: "#26AB55",
          "primary-content": "#FFFFFF",
          secondary: "#3EAB65",
          accent: "#26AB55",
          // System
          error: "#E83E34",
          "error-content": "#64085B",
          warning: "#FEF8CB",
          "warning-content": "#765100",
          info: "#D0E6FB",
          "info-content": "#04175A",
          success: "#E0FBD6",
          "success-content": "#09552B",

          // Neutral
          // neutral: "#262626",
          // "neutral-focus": "#1F1F1F",
          // "neutral-content": "#B0B0B0",
          // Base
          "base-100": "#101010",
          "base-200": "#171717",
          "base-300": "#1F1F1F",
          "--ds-base-primary": "#101010",
          "--ds-base-secondary": "#171717",
          "base-content": "#EFEFEF",
          // Content
          "secondary-content": "#ffffff",
        },
      },
    ],
  },
};
