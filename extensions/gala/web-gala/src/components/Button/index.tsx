/* eslint-disable react/jsx-props-no-spreading */
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  onClick?: () => void;
  className?: string;
  children: React.ReactNode;
  submit?: boolean;
}

export default function Button({
  onClick,
  className,
  children,
  submit,
  ...props
}: ButtonProps) {
  return (
    <button
      type={submit ? "submit" : "button"}
      className={`rounded-3xl bg-gradient-to-tr from-dark-gold to-light-gold px-4 py-2 font-semibold hover:saturate-150 ${className}`}
      onClick={onClick}
      {...props}
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
