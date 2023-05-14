import homeBackground from "../../assets/home-background.png";
import Background from "../../components/Background";

export default function Home() {
  // TODO: Everything

  return (
    <>
      <Background src={homeBackground} />
      <div className="h-screen flex justify-center items-center">
        <h1 className="text-3xl font-semibold">Hi this is home</h1>
      </div>
    </>
  );
}
