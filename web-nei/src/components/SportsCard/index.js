const SportsCard = ({ sport, frame, type, image, className }) => {
  return (
    <div className={`bg-secondary ${className}`}>
      <div className="flex">
        <img
          className="aspect-square block max-h-full"
          src={image}
          alt="sport img"
        />
        <p></p>
        <span className="ms-auto"></span>
      </div>
      <hr />
      <div></div>
    </div>
  );
};

export default SportsCard;
