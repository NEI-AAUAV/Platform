import { useEffect, useState, useCallback } from "react";
import { Link } from "react-router-dom";
import Typist from "react-typist";
import { motion } from "framer-motion";
import { debounce } from "lodash";

import PageNav from "../../components/PageNav";
import service from "services/NEIService";
import CardVideo from "components/CardVideo";

import CheckboxDropdown from "components/CheckboxDropdown";

import data from "./data";

import { FilterIcon } from "assets/icons/google";

const container = {
  hidden: { opacity: 1, scale: 0 },
  visible: {
    opacity: 1,
    scale: 1,
    transition: {
      delayChildren: 0.2,
      staggerChildren: 0.1,
    },
  },
};

const item = {
  hidden: { y: 20, opacity: 0 },
  visible: {
    y: 0,
    opacity: 1,
  },
};

const Videos = () => {
  // Filters
  const [categories, setCategories] = useState([]);
  const [tags, setTags] = useState(
    // TODO: change active state according to user information
    Object.values(data.tags).map((c) => ({ ...c, checked: true }))
  );
  const [filters, setFilters] = useState([]);
  const [selection, setSelection] = useState([]);
  const [loadingCategories, setLoadingCategories] = useState(true);

  // Videos
  const [videos, setVideos] = useState([]);
  const [loading, setLoading] = useState(true);

  // Pagination
  const [pages, setPages] = useState(1);
  const [selPage, setSelPage] = useState(1);

  const debouncedSetTags = useCallback(
    debounce(setTags, 300)
  , []);

  // Get categories from API
  useEffect(() => {
    service
      .getVideosCategories()
      .then((response) => {
        setCategories(response);
        var cats = [];
        var catsObjs = [];
        response.forEach((c) => {
          cats.push(c.name);
          catsObjs.push({ filter: c.name, color: c.color });
        });
        setSelection(cats);
        setFilters(catsObjs);
        setLoadingCategories(false);
      })
      .catch(() => {
        console.error("something went wrong...");
      });
  }, []);

  console.log(videos, tags)

  // When categories selected change, update videos list (get from API)
  useEffect(() => {
    setLoading(true);

    const params = {
      tag: [],
    };

    if (selection.length) {
      // Compute url with categories ids selected
      selection.forEach((s) => {
        const candidates = categories.filter((c) => c.name == s);
        if (candidates.length > 0) {
          params.tag.push(candidates[0].id);
        }
      });

      service.getVideos({ ...params, page: selPage }).then((response) => {
        setVideos(response.items);
        setPages(response.last);
        setSelPage(response.page);
        setLoading(false);
      });
    } else {
      setLoading(false);
      setVideos([]);
      setPages(1);
      setSelPage(1);
    }
  }, [selection, selPage, categories]);

  return (
    <div>
      <h2 className="text-center">
        <Typist>Vídeos</Typist>
      </h2>

      {/* TODO: filter videos */}
      {/* <div className="flex w-full justify-end">
        <CheckboxDropdown
          className="btn-sm m-1"
          values={tags}
          onChange={debouncedSetTags}
        >
          Filter <FilterIcon />
        </CheckboxDropdown>
      </div> */}

      {videos.length > 0 && (
        <motion.div
          className="mt-10 m-3 grid grid-cols-[repeat(auto-fit,_minmax(20rem,_1fr))] gap-6"
          variants={container}
          initial="hidden"
          animate="visible"
        >
          {videos.map((video) => (
            <motion.div key={video.id} variants={item}>
              <Link to={`/videos/${video.id}`}>
                <CardVideo video={video} />
              </Link>
            </motion.div>
          ))}
        </motion.div>
      )}

      {/* Pagination */}
      <PageNav
        currentPage={selPage}
        numPages={pages}
        handler={setSelPage}
        className="mx-auto mt-3"
      ></PageNav>
      {
        // Error
        !loading && !loadingCategories && videos.length == 0 && (
          <div>
            <h3 className="mt-3 text-center">Nenhum vídeo encontrado</h3>
            <h4 className="text-center">
              Tenta definir filtros menos restritivos
            </h4>
          </div>
        )
      }
    </div>
  );
};

export default Videos;
