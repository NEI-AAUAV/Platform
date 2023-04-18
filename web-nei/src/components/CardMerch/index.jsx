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
    <div
      className={`relative flex h-96 w-80 flex-col items-center justify-center overflow-hidden rounded-3xl bg-base-200 pb-8 shadow-md ${className}`}
    >
      <img
        src={img}
        className=" relative  my-auto block h-full w-full object-contain object-center p-12 transition duration-150 ease-in hover:z-10 hover:scale-110 "
        alt="Imagem Disponível em Breve"
      />
      <div className="pointer-events-none absolute inset-0 flex w-full grow-0 flex-col justify-end opacity-50">
        <div className="overflow-hidden">
          <div className="h-0 w-[102.24%] origin-top-left rotate-12 bg-accent p-[10.63%]" />
        </div>
        <div className="h-1/3 w-full bg-accent" />
      </div>
      <div className="card-body absolute bottom-0 w-full">
        <h2 className="text-left text-accent-content">{title}</h2>
        <span className="text-right">
          <span className="text-md font-medium">Preço:</span>
          <span className="text-xl font-semibold"> {formattedPrice}</span>
        </span>
      </div>
    </div>
  );
};

export default CardMerch;
