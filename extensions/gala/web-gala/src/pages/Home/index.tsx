import { Link } from "react-router-dom";
import homeBackground from "@/assets/home-background.png";
import Background from "@/components/Background";

export default function Home() {
  return (
    <>
      <Background src={homeBackground} />
      <div className="absolute inset-0 flex justify-center items-center">
        <div className="flex flex-col items-center text-center mx-4">
          <h1 className="text-[2.5rem] sm:text-[4rem] font-bold leading-tight">
            O Melhor Jantar de Gala
          </h1>
          <h6 className="text-[1.75rem] sm:text-5xl">está ai à porta</h6>
          <Link
            className="bg-black/70 backdrop-blur text-white sm:text-[1.25rem] font-bold px-8 py-4 rounded-full mt-12"
            to="/tables"
          >
            Reservar Lugar
          </Link>
        </div>
      </div>
    </>
  );
}
