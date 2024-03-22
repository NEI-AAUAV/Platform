import NavTabs from "@/components/nav-tabs";
import useLoginLink from "@/hooks/useLoginLink";
import { useUserStore } from "@/stores/useUserStore";
import type { CSSProperties } from "react";
import { Outlet } from "react-router-dom";

export default function MainLayout() {
  const bgStyle: CSSProperties = {
    background:
      "radial-gradient(circle at 90% 20%, rgb(255,0,0,0.12) , transparent 25%), radial-gradient(circle at 10% 50%, rgb(255,0,0,0.12) , transparent 25%) , radial-gradient(circle at 90% 80%, rgb(255,0,0,0.12), transparent 25%)",
  };

  const { sub, sessionLoading } = useUserStore((state) => state);
  const loginLink = useLoginLink();

  if (sub === undefined && !sessionLoading) {
    window.location.href = loginLink;
  }

  return (
    <div className="font-inter" style={bgStyle}>
      <div className="mx-4 min-h-screen pb-10 pt-20 text-[rgb(255,255,255,0.95)] antialiased">
        <h1 className="font-playfair text-3xl font-bold [text-wrap:balance]">
          Perdidos? Assim é o Rally Tascas
        </h1>
        <NavTabs className="mt-4" />
        <Outlet />
      </div>
    </div>
  );
}
