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
      colors: {
        "light-gold": "#EBD5B5",
        "dark-gold": "#B6A080",
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
          primary: "#B6A080",
          secondary: "#EBD5B5",
          accent: "#B6A080",
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
