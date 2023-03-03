const CardMerch = ({ img, title, price }) => {
  const priceFormatted = price.toLocaleString("pt-PT", {
    style: "currency",
    currency: "EUR",
  });

  return (
    <>
      <div className="flex flex-col rounded justify-center items-center bg-base-200 p-3 shadow hover:scale-105 transition ease-in duration-100">
        <img
          src={img}
          className="max-w-full block object-cover object-center "
        />
        <h2>{title}</h2>
        <div className="flex flex-row justify-center items-center">
          <h3 className="text-2xl font-bold">{priceFormatted}</h3>
        </div>
        {/* I dont know if the button is going to stay but ill keep it for now */}
        <div className="flex flex-row justify-center items-center">
          <a href="#">
            <button className="btn btn-outline btn-secondary font-bold py-2 px-4 rounded">
              Comprar
            </button>
          </a>
        </div>
      </div>
    </>
  );
};

export default CardMerch;
