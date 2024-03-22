const { createThemes } = require("tw-colors");
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./pages/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
    "./app/**/*.{ts,tsx}",
    "./src/**/*.{ts,tsx}",
    "./src/**/*.{js,jsx,ts,tsx}",
    // Add the flowbite-datepicker library tailwind classes
    "./node_modules/flowbite-datepicker/**/*.{js,jsx,ts,tsx}",
  ],
  darkMode: ["class", '[data-theme="dark"]'],
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        xs: "576px",
        "2xl": "1400px",
      },
    },
    extend: {
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
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
        success: "#37AB26",
        info: "#07A2AE",
        warning: "#DCA825",
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: { height: 0 },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: 0 },
        },
        wiggle: {
          "0%": { transform: "translateX(0)" },
          "25%": { transform: "translateX(0.25em)" },
          "75%": { transform: "translateX(-0.25em)" },
          "100%": { transform: "translateX(0)" },
        },
        "accordion-down": {
          from: { height: 0 },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: 0 },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
        wiggle: "wiggle 0.2s ease-in-out 0s 2",
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
      colors: {
        success: "#37AB26",
        info: "#07A2AE",
        warning: "#DCA825",

        // shadcn/ui colors
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary2: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        accent2: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
    },
  },
  plugins: [
    require("tailwindcss-animate"),
    require("daisyui"),
    require("@emotion/react"),
    createThemes(
      {
        light: {
          base: {
            primary: "#F3F3F3",
            secondary: "#F9F9F9",
            100: "#F3F3F3",
            200: "#F9F9F9",
            300: "#FFFFFF",
            400: "#FFFFFF",
          },
          text: {
            primary: "#101010",
            secondary: "#404040",
            100: "#101010",
            200: "#404040",
            300: "#707070",
          },
          primary: "#12A14D",
          light: "#FFFFFF",
          error: "#E83E34",
        },
        dark: {
          base: {
            primary: "#101010",
            secondary: "#171717",
            100: "#101010",
            200: "#171717",
            300: "#1F1F1F",
            400: "#282828",
          },
          text: {
            primary: "#EFEFEF",
            secondary: "#BFBFBF",
            100: "#EFEFEF",
            200: "#BFBFBF",
            300: "#8F8F8F",
          },
          primary: "#0F8A42",
          light: "#EFEFEF",
          error: "#C82643",
        },
        light: "#FFFFFF",
        error: "#E83E34",
      },
      {
        getThemeClassName: (themeName) => `${themeName}`,
      }
    ),
  ],
  daisyui: {
    logs: false,
    themes: [
      {
        light: {
          ...require("daisyui/src/colors/themes")["[data-theme=light]"],
          primary: "#12A14D",
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
          primary: "#0F8A42",
          "primary-content": "#FFFFFF",
          secondary: "#3EAB65",
          accent: "#26AB55",

          // System
          error: "#C82643",
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
