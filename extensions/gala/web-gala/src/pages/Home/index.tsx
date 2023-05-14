import homeBackground from "@/assets/home-background.png";
import Background from "@/components/Background";
import { Link } from "react-router-dom";

export default function Home() {
  return (
    <>
      <Background src={homeBackground} />
      <div className="absolute inset-0 flex justify-center items-center">
        <div className="flex flex-col items-center">
          <h1 className="text-[4rem] font-bold leading-tight">
            O Melhor Jantar de Gala
          </h1>
          <h6 className="text-5xl">está ai á porta</h6>
          <Link
            className="bg-black/70 text-white font-bold px-8 py-4 rounded-full mt-12"
            to="/tables"
          >
            Reservar Lugar
          </Link>
        </div>
      </div>
    </>
  );
}
