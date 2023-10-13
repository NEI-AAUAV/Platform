import classNames from "classnames";
import { motion } from "framer-motion";

export type Props = {
  as?: React.ElementType;
  className?: classNames.Argument;
  children: React.ReactNode;
  index: number;
};

export function BaseCard({
  as = motion.div,
  className,
  children,
  index,
}: Props): JSX.Element {
  const Component = as;
  return (
    <Component
      className={classNames([
        "flex flex-col gap-4 rounded-2xl bg-base-300 p-4 transition-colors hover:bg-base-400 motion-reduce:transition-none",
        className,
      ])}
      initial="hidden"
      animate={["visible", "rest"]}
      whileHover={["visible", "hover"]}
      custom={index}
      variants={cardVariants}
    >
      {children}
    </Component>
  );
}

const cardVariants = {
  hidden: { opacity: 0, scale: 1.0 },
  visible: (i: number) => ({
    opacity: 1,
    transition: {
      delay: i * 0.05,
    },
  }),
  rest: { scale: 1.0 },
  hover: { scale: 1.1 },
};
