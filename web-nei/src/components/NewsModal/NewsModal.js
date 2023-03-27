import { motion } from "framer-motion";

const backdrop = {
  visible: { opacity: 1 },
  hidden: { opacity: 0 },
};
const Badges = {
  event: ["badge badge-primary"],
  partner: ["badge badge-secondary"],
  news: ["badge badge-accent"],
};

const openSpring = { type: "spring", stiffness: 200, damping: 30 };
const closeSpring = { type: "spring", stiffness: 300, damping: 35 };

export const NewsModal = (props) => {
  let { title, description, link, header, date, category } = props.data;
  const mid = props.newsKey;
  return (
    <>
      <motion.div className="fixed inset-0 bg-black/50 z-50 cursor-pointer overflow-y-scroll ">
        <motion.div className="modal-box left-1/2 top-1/2 absolute -translate-y-1/2 -translate-x-1/2">
          <motion.div
            className="h-3/5"
            initial={{
              opacity: 0,
              y: 50,
            }}
            animate={{
              opacity: 1,
              y: 0,
            }}
            transition={{
              duration: 0.5,
            }}
          >
            <img className="object-cover w-full" src={header} alt={title} />
          </motion.div>
          <motion.div className="card-body">
            <h2 className="card-title">ooga booga</h2>
            {
              // if card is new show new badge
            }
            {props.type === "partner" ? (
              <p className="text-sm text-left">{description}</p>
            ) : (
              <p className="text-sm text-left">{date}</p>
            )}
            <motion.div className="card-actions justify-end">
              {props.type === "news" ? (
                <motion.div
                  className={
                    Badges[category.toLowerCase()]
                      ? Badges[category.toLowerCase()]
                      : "badge badge-outline"
                  }
                >
                  {category}
                </motion.div>
              ) : (
                <></>
              )}
            </motion.div>
          </motion.div>
        </motion.div>
      </motion.div>
    </>
  );
};
