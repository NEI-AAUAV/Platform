type ButtonProps = {
  onClick?: () => void;
  className?: string;
  children: React.ReactNode;
  submit?: boolean;
};

export default function Button({
  onClick,
  className,
  children,
  submit,
}: ButtonProps) {
  return (
    <button
      type={submit ? "submit" : "button"}
      className={`rounded-3xl bg-gradient-to-tr from-dark-gold to-light-gold px-4 py-2 font-semibold ${className}`}
      onClick={onClick}
    >
      {children}
    </button>
  );
}

Button.defaultProps = {
  onClick: () => {},
  className: "",
  submit: false,
};
