import { Outlet, useLocation } from "react-router-dom";
import config from "@/config";

const backgrounds = {
  home: {
    backgroundImage: `url('${config.BASE_URL}/gala/home-background.jpg')`,
    backgroundSize: "cover",
    backgroundPosition: "center",
  },
  notHome: {
    backgroundImage: `url('${config.BASE_URL}/gala/home-background.jpg')`,
    backgroundSize: "cover",
    backgroundPosition: "center",
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
      className="min-h-screen bg-no-repeat text-base-content/70"
      style={getBackground(location)}
    >
      <div className="mx-auto max-w-screen-2xl px-1">
        <Outlet />
      </div>
    </div>
  );
}
