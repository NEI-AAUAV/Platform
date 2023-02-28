const CardMerch = (props) => {
  return (
    <>
      <div className="flex flex-col rounded justify-center items-center bg-primary p-3 shadow hover:scale-105 transition ease-in duration-100">
        <img src={props.img} className="max-h-48" />
        <h2>{props.title}</h2>
        <div className="flex flex-row justify-center items-center">
          <h3 className="text-2xl font-bold">{props.price}</h3>
        </div>
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
