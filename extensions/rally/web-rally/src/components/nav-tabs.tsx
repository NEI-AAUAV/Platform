import { Link, useLocation } from "react-router-dom";
import { BloodyButton } from "./bloody-button";
import { cn } from "@/lib/utils";
import type { ComponentProps } from "react";
import { useUserStore } from "@/stores/useUserStore";

type NavTabsProps = ComponentProps<"ul">;

export default function NavTabs({ className, ...props }: NavTabsProps) {
  const location = useLocation();
  const { scopes } = useUserStore((state) => state);
  const navigation = [
    { name: "Pontuação", href: "/scoreboard", show: true },
    { name: "Mapa", href: "/maps", show: true },
    { name: "Equipas", href: "/teams", show: true },
    {
      name: "Admin",
      href: "/admin",
      show:
        scopes !== undefined &&
        (scopes.includes("admin") || scopes.includes("manager-rally")),
    },
  ].filter((item) => item.show);
  return (
    <ul {...props} className={cn("flex gap-3", className)}>
      {navigation.map((item) => (
        <li key={item.name}>
          <Link to={item.href}>
            <BloodyButton
              blood={location.pathname === item.href}
              variant={location.pathname === item.href ? "default" : "neutral"}
            >
              {item.name}
            </BloodyButton>
          </Link>
        </li>
      ))}
    </ul>
  );
}
