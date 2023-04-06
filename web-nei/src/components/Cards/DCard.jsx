import { NewsModal } from "components/NewsModal/NewsModal";
import { motion } from "framer-motion";
import React, { useState } from "react";
/*
    Props:
        - type (string): "partner" or "news"

        - data:
            - title (string)
            - link (string)
            - image (string)
    
            - PartnerCard Data:
                - description (string)
            
            - NewsCard Data:
                - date (string)
                - tags(strings)
*/
const Badges = {
  event: ["badge badge-primary"],
  partner: ["badge badge-secondary"],
  news: ["badge badge-accent"],
};

export default function DCard(props) {
  switch (props.type) {
    case "news":
      return <NewsCard data={props.data} openModal={props.openModal} />;
    case "partner":
      return (
        <PartnerCard
          data={props}
          openModal={props.openModal}
          newsKey={props.newsKey}
        />
      );
    default:
      return <></>;
  }
}

function NewsCard(props) {
  const formatDate = (date) => {
    const d = new Date(date);
    return `${d.getDate()}/${d.getMonth() + 1}/${d.getFullYear()}`;
  };
  const data = props.data;
  const date = formatDate(data.created_at);


  const openModalCallback = () => props.openModal();
  return (
    <motion.div
      className="tooltip tooltip-primary w-96 h-96 m-4 py-4"
      data-tip="Saber mais"
      onClick={() => {
        console.log("clicked");
        openModalCallback();
      }}
    >
      <motion.div className="card rounded-xl w-96 h-96 bg-base-200 shadow-xl hover:-translate-y-2 transition duration-200 ease-in-out" >
        <motion.figure className="h-3/5"
          layoutId={`card-${data.id}`}
        >
          <img className="object-cover w-full h-full" src={data.header} alt={data.title} />
        </motion.figure>
        <div className="card-body">
          <h2 className="card-title">{data.title}</h2>
          {
            //if createdAt is from less then a month ago show "new"" badge"
            data.created_at > new Date().setMonth(new Date().getMonth() - 1) && (
              <div className="badge badge-accent">Novo</div>

            )
          }

          <p className="text-sm text-left">{date}</p>

          <div className="card-actions justify-end">
            <div
              className={
                Badges[data.category.toLowerCase()]
                  ? Badges[data.category.toLowerCase()]
                  : "badge badge-outline"
              }
            >
              {data.category}
            </div>
          </div>
        </div>
      </motion.div>
    </motion.div>
  );
}

const PartnerCard = (props) => {
  const [isSelected, setIsSelected] = useState(false);
  let { title, description, link, header, date, category } = props.data;
  return (
    <>
      <label
        className="w-96 h-96 m-4"
        htmlFor={title}
        onClick={() => {
          setIsSelected(true);
        }}
      >
        <motion.div className="card rounded-xl w-96 h-96 bg-base-200 shadow-xl hover:-translate-y-2 transition duration-200 ease-in-out">
          <figure className="h-3/5">
            <img className="object-cover w-full" src={header} alt={title} />
          </figure>
          <div className="card-body">
            <p className="text-sm text-left">{description}</p>
            <div className="card-actions justify-end"></div>
          </div>
        </motion.div>
      </label>
    </>
  );
};
