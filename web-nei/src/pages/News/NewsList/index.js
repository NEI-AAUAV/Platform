import { useState, memo, Fragment, useEffect } from "react";
import {
  BrowserRouter as Router,
  useParams,
  useNavigate,
} from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";
import logo from "assets/images/logo.png";

const text = `
Contrary to popular belief, Lorem Ipsum is not simply random text. It has
roots in a piece of classical Latin literature from 45 BC, making it over
2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney
College in Virginia, looked up one of the more obscure Latin words,
consectetur, from a Lorem Ipsum passage, and going through the cites of
the word in classical literature, discovered the undoubtable source. Lorem
Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et
Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This
book is a treatise on the theory of ethics, very popular during the
Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit
amet..", comes from a line in section 1.10.32. The standard chunk of Lorem
Ipsum used since the 1500s is reproduced below for those interested.
Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by
Cicero are also reproduced in their exact original form, accompanied by
English versions from the 1914 translation by H. Rackham. Where can I get
some? There are many variations of passages of Lorem Ipsum available, but
the majority have suffered alteration in some form, by injected humour, or
randomised words which don't look even slightly believable. If you are
going to use a passage of Lorem Ipsum, you need to be sure there isn't
anything embarrassing hidden in the middle of text. All the Lorem Ipsum
generators on the Internet tend to repeat predefined chunks as necessary,
making this the first true generator on the Internet. It uses a dictionary
of over 200 Latin words, combined with a handful of model sentence
structures, to generate Lorem Ipsum which looks reasonable. The generated
Lorem Ipsum is therefore always free from repetition, injected humour, or
non-characteristic words etc.
`;

const cardData = [
  // Photo by ivan Torres on Unsplash
  {
    id: "c",
    image:
      "https://uploads.codesandbox.io/uploads/user/6480904d-d79b-484b-9f16-8d5a3eff77e3/J-By-g.jpg",
    category: "Pizza",
    title: "5 Food Apps Delivering the Best of Your City",
    pointOfInterest: 80,
    backgroundColor: "#814A0E",
    text,
  },
  // Photo by Dennis Brendel on Unsplash
  {
    id: "f",
    image:
      "https://images.pexels.com/photos/276092/pexels-photo-276092.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    category: "How to",
    title: "Arrange Your Apple Devices for the Gram",
    pointOfInterest: 120,
    backgroundColor: "#959684",
    text,
  },
  // Photo by Alessandra Caretto on Unsplash
  {
    id: "a",
    image:
      "https://uploads.codesandbox.io/uploads/user/6480904d-d79b-484b-9f16-8d5a3eff77e3/zRYi-a.jpg",
    category: "Pedal Power",
    title: "Map Apps for the Superior Mode of Transport",
    pointOfInterest: 260,
    backgroundColor: "#5DBCD2",
    text,
  },
  // Photo by Taneli Lahtinen on Unsplash
  {
    id: "g",
    image:
      "https://media.istockphoto.com/id/1287021364/photo/wide-angle-blue-celebration-bokeh-background.jpg?b=1&s=170667a&w=0&k=20&c=SLOK2idjHdYVZFB14wbWWjh-LvGv7biFyrSyUWBqmLU=",
    category: "Holidays",
    title: "Our Pick of Apps to Help You Escape From Apps",
    pointOfInterest: 200,
    backgroundColor: "#8F986D",
    text,
  },
  // Photo by Simone Hutsch on Unsplash
  {
    id: "d",
    image:
      "https://images.unsplash.com/photo-1553095066-5014bc7b7f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8d2FsbCUyMGJhY2tncm91bmR8ZW58MHx8MHx8&w=1000&q=80",
    category: "Photography",
    title: "The Latest Ultra-Specific Photography Editing Apps",
    pointOfInterest: 150,
    backgroundColor: "#FA6779",
    text,
  },
  // Photo by Siora Photography on Unsplash
  {
    id: "h",
    image:
      "https://uploads.codesandbox.io/uploads/user/6480904d-d79b-484b-9f16-8d5a3eff77e3/SPE0-f.jpg",
    category: "They're all the same",
    title: "100 Cupcake Apps for the Cupcake Connoisseur",
    pointOfInterest: 60,
    backgroundColor: "#282F49",
    text,
  },
  // Photo by Yerlin Matu on Unsplash
  {
    id: "e",
    image:
      "https://images.unsplash.com/photo-1483232539664-d89822fb5d3e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80",
    category: "Cats",
    title: "Yes, They Are Sociopaths",
    pointOfInterest: 200,
    backgroundColor: "#AC7441",
    text,
  },
  // Photo by Ali Abdul Rahman on Unsplash
  {
    id: "b",
    image: logo,
    category: "Holidays",
    title: "Seriously the Only Escape is the Stratosphere",
    pointOfInterest: 260,
    backgroundColor: "#CC555B",
    text,
  },
];

const Image = ({ image, selected, pointOfInterest = 0 }) => {
  return (
    <div 
    className="relative h-96 overflow-hidden bg-red-500"
    >
    <motion.div
      layout
      className="absolute"
      style={{width: 'calc(1024px + 80px)'}}
      animate={selected ? { top: -40, left: -40, bottom: -40 } : { top: -4, left: -4, bottom: -4 }}
    >
      <motion.img
        src={image}
        alt=""
        initial={false}
        layout
        animate={{
          width: '100%',
          height: '100%',
          objectFit: 'cover',
          objectPosition: 'center'
        }}
        // transition={closeSpring}
      />
    </motion.div>
    </div>
  );
};

function NewsList() {
  let { id } = useParams();
  const [selectedId, setSelectedId] = useState(id);
  const navigate = useNavigate();
  // Ensures layout stays always the same on refresh,
  // despite being randomly generated
  let seed = 1;

  useEffect(() => {
    setSelectedId(id);
  }, [id]);

  function sample(arr) {
    /* Generate a random number with a seed */
    function random() {
      var x = Math.sin(seed++) * 10000;
      return x - Math.floor(x);
    }
    return arr[Math.floor(random() * arr.length)];
  }

  return (
    <>
      <div className="flex flex-wrap gap-4 md:gap-8">
        {cardData.map((item) => {
          const selected = selectedId === item.id;
          return (
            <div
              key={item.id}
              className="flex h-96 grow relative"
              style={{ flexBasis: sample([340, 340, 340, 360, 360, 400, 440]) }}
            >
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: selected ? 1 : 0 }}
                transition={{ duration: 0.15 }}
                style={{
                  pointerEvents: selected ? "auto" : "none",
                }}
                className="fixed inset-0 z-40 bg-black/80 transition-opacity"
                onClick={() => navigate("/news")}
              />
              <motion.div
                className={classNames(
                  "pointer-events-none absolute block w-full",
                  {
                    "!fixed bottom-0 left-0 right-0 top-0 overflow-hidden px-1 py-40":
                      selected,
                  },
                )}
                animate={selected ? { zIndex: 40 } : { zIndex: 0 }}
                transition={{ duration: 0, delay: selected ? 0 : 0.3 }}
              >
                <motion.div
                  layout
                  transition={{ duration: 0.3 }}
                  onClick={() => navigate("/news/" + item.id)}
                  whileHover={
                    !selectedId && { transition: { duration: 0.3 }, y: -4 }
                  }
                  animate={{ height: selected ? 700 : 380, zIndex: selected ? 40 : 0 }}
                  className={classNames(
                    "relative mx-auto h-full w-full overflow-hidden rounded-2xl bg-base-300",
                    selected
                      ? "max-w-5xl"
                      : "cursor-pointer shadow-sm hover:shadow-md"
                  )}
                  style={{ pointerEvents: "auto" }}
                >
                  <Image image={item.image} selected={selected} />
                  <div className="absolute left-0 top-0 w-full bg-gradient-to-b from-black/60 to-black/0 text-white/90">
                  <motion.div
                    layout
                    initial={false}
                    animate={selected ? { padding: 30, paddingRight: 15 } : { padding: 15, paddingRight: 30 }}
                    className="max-w-[340px] box-content !pb-20"
                  >
                    <span>{item.category}</span>
                    <h3>{item.title}</h3>
                  </motion.div>
                  </div>
                  {/* <AnimatePresence>
                  {selected && <motion.div
                    layout
                    className="p-5"
                    // layoutOrigin={[0, 0]}
                    // animate={{ height: selected ? "auto" : 0 }}
                    // animate={{ padding: selected ? "35px 35px 35px 35px" : 0 }}
                    initial={{ opacity: 0, height: 0 }}
                    animate={{ opacity: 1, height: "auto" }}
                    exit={{ opacity: 0, height: 0 }}
                    transition={{ duration: 0.3 }}
                  >
                    {item.text}
                  </motion.div>}
                  </AnimatePresence> */}
                  <div style={{padding: 30}}>
                  {item.text}
                  </div>
                </motion.div>
              </motion.div>
            </div>
          );
        })}
      </div>
      <div className="h-[100vh]"></div>
    </>
  );
}

export default NewsList;
