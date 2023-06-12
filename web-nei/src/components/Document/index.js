import LinkAdapter from "utils/LinkAdapter";

import { motion } from "framer-motion";

/**
 * Component for document
 *
 * Arguments
 *  name            File name
 *  description     File description
 *  link            Link for file (without base URL)
 *  blank           Open link in new tab?
 *  className       Extra classes                   (Optional)
 *  icon            Icon component                  (Optional, default PDF)
 *  iconColor       Icon color                      (Optional, default .text-primary)
 *  size            Icon size                       (Optional, default 3x)
 *  onClick         on click event handler          (Optional)
 *  title           title attribute                 (Optional)
 *  tags            pills {name: str, color: str, className: str} (Optional)
 *  image           A banner                        (Optional)
 *                  NOTE: Make sure all images have the same dimensions, otherwise the cards won't be aligned!
 *  style (Optional)
 */

/**
 *
 * @param {ReactElement} Icon optional
 * @returns
 */
const Document = ({
  name,
  description,
  link,
  className,
  Icon,
  onClick,
  title,
  tags,
  style,
  iconColor,
}) => {
  return (
    <LinkAdapter
      to={link}
      onClick={onClick}
      title={title ? title : ""}
      style={style}
      className={"no-underline " + className}
    >
      <div className="h-full rounded-md transition-hover duration-300 hover:-translate-y-1.5 hover:shadow-md hover:brightness-125">
        <div className="flex p-3 text-left">
          {!!Icon && <Icon className="min-h-[40px] min-w-[40px]" />}
          <div className="flex w-[calc(100%-40px)] flex-col pl-4">
            <h5 className="w-full overflow-hidden text-ellipsis break-keep">
              {name}
            </h5>
            <p className="overflow-hidden text-ellipsis text-sm text-base-content/50">
              {description}
            </p>
            <div className="">
              {tags &&
                tags.map((tag, index) => (
                  <span
                    key={index}
                    className={"badge my-1 ml-0 mr-2 " + tag.className}
                    style={tag.color ? { backgroundColor: tag.color } : {}}
                  >
                    {tag.name}
                  </span>
                ))}
            </div>
          </div>
        </div>
      </div>
    </LinkAdapter>
  );
};

/**
 *
 * @param {ReactElement} Icon optional
 * @returns
 */
const Document2 = ({
  name,
  description,
  link,
  className,
  Icon,
  onClick,
  title,
  tags,
  style,
  author,
  iconColor,
}) => {
  return (
    <LinkAdapter
      to={link}
      onClick={onClick}
      title={title ? title : ""}
      style={style}
      className={"p-1 no-underline " + className}
    >
      <div className="h-full cursor-pointer rounded-md border border-base-content/10 !bg-base-200 p-4 shadow-sm transition-hover duration-300 hover:-translate-y-1 hover:shadow-md hover:brightness-110">
        <div className="flex items-center text-left">
          {!!Icon && <Icon className="min-h-[30px] min-w-[30px]" />}
          <p className="ml-3 overflow-hidden text-ellipsis text-sm text-base-content/50">
            {description}
          </p>
          <div
            className="tooltip avatar ml-auto mr-1"
            data-tip={`Feito por ${author?.name || ""} ${
              author?.surname || ""
            }`}
          >
            <div className="mask mask-circle w-6">
              <img src="https://placeimg.com/192/192/people" />
            </div>
          </div>
        </div>
        <div className="flex w-[calc(100%-40px)] flex-col">
          <h5 className="mt-2 w-full overflow-hidden text-ellipsis break-keep">
            {name}
          </h5>

          <div className="mt-2 flex flex-wrap gap-2">
            {tags &&
              tags.map((tag, index) => (
                <span
                  key={index}
                  className="badge badge-sm"
                  style={tag.color ? { backgroundColor: tag.color } : {}}
                >
                  {tag.name} {tag.color}
                </span>
              ))}
          </div>
        </div>
      </div>
    </LinkAdapter>
  );
};

export default Document2;
