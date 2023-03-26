/**
 * Card component for merchandising
 *
 * @param {string} img - Image URL
 * @param {string} title - Merch title
 * @param {number} price - Merch price
 * @param {string} className - Additional classes to be added to the component
 *
 * @returns {JSX.Element}
 *
 * @example
 * <CardMerch img="https://i.imgur.com/3ZQ3Z9C.png" title="Merch Title" price={10} />
 */

const CardMerch = ({ img, title, price, className }) => {
  // price should be a number
  const formattedPrice = price.toLocaleString("pt-PT", {
    style: "currency",
    currency: "EUR",
  });

  return (
    <>
      <div
        className={`flex flex-col max-w-md w-fit rounded justify-center items-center bg-base-200 p-6 shadow-md my-2 ${className}`}
      >
        <img
          src={img}
          className="max-w-sm max-h-96 block object-cover object-center hover:scale-110 transition ease-in duration-150 p-6 "
          alt="Imagem Disponível em Breve"
        />
        <div className="card-body justify-end">
          <h1>{title}</h1>
          <div className="flex justify-center items-center">
            <h3 className="text-lg font-medium">Preço: {formattedPrice}</h3>
          </div>
        </div>
      </div>
    </>
  );
};

export default CardMerch;
