import React, { Fragment } from "react";

const CardVideo = ({ video, className }) => {
  return (
    <div
      className={`flex max-w-2xl transform flex-col rounded-xl bg-base-200 shadow-md duration-100 ease-out hover:-translate-y-1 hover:shadow-lg ${className}`}
    >
      <img
        className="aspect-{640/420} w-full cursor-pointer rounded-t-xl object-cover object-center"
        src={video.image}
      />
      <div className="m-4">
        <h2 className="font-bold">{video.title}</h2>

        <div className="flex justify-end gap-1">
          <h5 className="mr-auto font-semibold text-primary">
            {video.subtitle}
          </h5>
          {video.tags.map((tag) => {
            return (
              <Fragment key={tag.id}>
                <span
                  className="badge m-0 border-0 p-3 font-bold text-white"
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
  );
};

export default CardVideo;
