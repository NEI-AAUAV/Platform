const Tab = ({ children, className, selected, onClick, ...props }) => {
  const selectedClass = selected
    ? "no-animation text-primary-content shadow hover:bg-accent-focus"
    : "bg-transparent hover:bg-base-300 hover:opacity-75";
  return (
    <button
      className={`btn-sm btn gap-2 border-none bg-accent py-1 ${selectedClass} ${className}`}
      onClick={onClick}
      {...props}
    >
      {children}
    </button>
  );
};

export default Tab;