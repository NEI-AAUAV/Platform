/** @type {import('tailwindcss').Config} */
import daisyui from "daisyui";

export default {
  mode: "jit",
  content: ["./src/**/*.{html,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        "light-gold": "#EBD5B5",
        "dark-gold": "#B6A080",
      },
    },
  },
  plugins: [daisyui],
  daisyui: {
    themes: [
      {
        light: {
          primary: "#B6A080",
          secondary: "#EBD5B5",
          accent: "#B6A080",
          neutral: "#3D4451",
          "base-100": "#FFFFFF",
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
