import React, { Fragment } from "react";

const CardVideo = ({ video, className }) => {
  return (
    <>
      <div
        className={`flex flex-col max-w-2xl  rounded-xl bg-base-200 shadow-md my-2 hover:-translate-y-1 hover:shadow-lg transform ease-out duration-100 ${
          className ? className : ""
        }`}
      >
        <img
          className="w-full aspect-{640/420} rounded-t-xl object-cover object-center cursor-pointer"
          src={video.image}
        />
        <div className="m-4">
          <h2 className="font-bold">{video.title}</h2>

          <div className="flex justify-end gap-1">
            <h5 className="text-primary font-semibold mr-auto">
              {video.subtitle}
            </h5>
            {video.tags.map((tag) => {
              return (
                <Fragment key={tag.id}>
                  <span
                    className="badge border-0 text-primary-content font-bold p-3 m-0"
                    style={{ backgroundColor: tag.color }}
                  >
                    {tag.name}
                  </span>
                </Fragment>
              );
            })}
          </div>
        </div>
      </div>
    </>
  );
};

export default CardVideo;
