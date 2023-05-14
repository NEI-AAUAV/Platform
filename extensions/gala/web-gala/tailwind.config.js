/** @type {import('tailwindcss').Config} */
import daisyui from "daisyui";

export default {
  mode: "jit",
  content: ["./src/**/*.{html,js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [daisyui],
  daisyui: {
    themes: [
      {
        light: {
          primary: "#0D873E",
          "primary-focus": "#3AB760",
          "primary-content": "#ffffff",

          secondary: "#F5F5F5",
          "secondary-focus": "#F5F5F5",
          "secondary-content": "#000000",

          accent: "#37CD8E",
          "accent-focus": "#2AA876",
          "accent-content": "#ffffff",

          neutral: "#3d4451",
          "neutral-focus": "#2a2e37",
          "neutral-content": "#ffffff",

          "base-100": "#ffffff",
          "base-200": "#f9fafb",
          "base-300": "#d1d5db",
          "base-content": "#1f2937",

          info: "#2094f3",
          success: "#009485",
          warning: "#ff9900",
          error: "#ff5724",
        },
      },
    ],
  },
};
