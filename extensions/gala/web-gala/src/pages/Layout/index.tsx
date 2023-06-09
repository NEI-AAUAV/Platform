import { Outlet, useLocation } from "react-router-dom";
import Navbar from "@/components/Navbar";
import config from "@/config";

const backgrounds = {
  home: {
<<<<<<< HEAD
    backgroundImage: "url('http://localhost/gala/home-background.png')",
=======
    backgroundImage: `url('${config.BASE_URL}/gala/public/home-background.png')`,
>>>>>>> cde63fcda5b774c8ea340efbf857ef0ede3d3a4d
    backgroundSize: "cover",
    backgroundPosition: "center",
  },
  notHome: {
<<<<<<< HEAD
    backgroundImage:
      "url('http://localhost/gala/not-home-background.png')",
=======
    backgroundImage: `url('${config.BASE_URL}/gala/public/not-home-background.png')`,
>>>>>>> cde63fcda5b774c8ea340efbf857ef0ede3d3a4d
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
