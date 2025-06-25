/** @type {import('tailwindcss').Config} */
import daisyui from "daisyui";
import headlessui from "@headlessui/tailwindcss";

export default {
  mode: "jit",
  content: ["./src/**/*.{html,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      screens: {
        xs: "576px",
      },
      fontFamily: {
        gala: ["Inter", "sans-serif"],
      },
      colors: {
        "light-gold": "#F7BBAC",
        "dark-gold": "#C58676",
      },
      backgroundImage: () => ({
        "gradient-radial":
          "radial-gradient(50% 50% at 50% 50%, var(--tw-gradient-stops))",
      }),
    },
  },
  plugins: [daisyui, headlessui],
  daisyui: {
    logs: false,
    themes: [
      {
        light: {
          primary: "#F7BBAC",
          secondary: "#C58676",
          accent: "#F7BBAC",
          neutral: "#3D4451",
          "base-100": "#FFFFFF",
          "base-200": "#FAFAFA",
          "base-content": "#000000",
          info: "#0284c7",
          success: "#198754",
          warning: "#DD8500",
          error: "#DC3545",
        },
      },
    ],
  },
};
