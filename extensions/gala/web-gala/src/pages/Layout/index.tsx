import { Outlet, useLocation } from "react-router-dom";
import Navbar from "@/components/Navbar";
import config from "@/config";

const backgrounds = {
  home: {
    backgroundImage: `url('${config.BASE_URL}/gala/public/home-background.png')`,
    backgroundSize: "cover",
    backgroundPosition: "center",
  },
  notHome: {
    backgroundImage: `url('${config.BASE_URL}/gala/public/not-home-background.png')`,
    backgroundSize: "100vh",
    backgroundPosition: "top left",
  },
};

function getBackground(location: string) {
  if (location === "/") return backgrounds.home;
  return backgrounds.notHome;
}

export default function Layout() {
  const location = useLocation().pathname;
  return (
    <div
      className="min-h-screen w-screen bg-no-repeat text-base-content/70"
      style={getBackground(location)}
    >
      <Navbar />
      <Outlet />
    </div>
  );
}
