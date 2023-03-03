const CardMerch = ({ img, title, price, className }) => {
  // price should be a number
  const formattedPrice = price.toLocaleString("pt-PT", {
    style: "currency",
    currency: "EUR",
  });

  return (
    <>
      <div
        className={`flex flex-col w-min rounded justify-center items-center bg-base-200 p-3 shadow hover:scale-105 transition ease-in duration-100 ${className}`}
      >
        <img
          src={img}
          className="max-w-sm max-h-96 block object-cover object-center"
        />
        <h2>{title}</h2>
        <div className="flex flex-row justify-center items-center">
          <h3 className="text-2xl font-bold">{formattedPrice}</h3>
        </div>
        {/* I don't know if the button is going to stay but i'll keep it for now */}
        <div className="flex flex-row justify-center items-center">
          <a>
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
