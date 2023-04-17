import { useEffect, useState, Fragment } from "react";
import Typist from "react-typist";

import PageNav from "../../components/PageNav";
import service from "services/NEIService";
import CardVideo from "components/CardVideo";

import CheckboxDropdown from "components/CheckboxDropdown";

import data from "./data";

import { FilterIcon } from "assets/icons/google";

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

  // FIXME: unused
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

  // Videos
  const [videos, setVideos] = useState([]);
  const [loading, setLoading] = useState(true);

  // Pagination
  const [pages, setPages] = useState(1);
  const [selPage, setSelPage] = useState(1);

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
  }, [selection, selPage]);

  return (
    <div>
      <h2 className="text-center">
        <Typist>Vídeos</Typist>
      </h2>

      <div className="flex w-full justify-end">
        <CheckboxDropdown
          className="btn-sm m-1"
          values={tags}
          onChange={setTags}
        >
          Filter <FilterIcon />
        </CheckboxDropdown>
      </div>

      <div className="grid grid-cols-[repeat(auto-fit,_minmax(20rem,_1fr))] gap-3 mx-3">
        {videos.map((video) => {
          return (
            <Fragment key={video.id}>
              <CardVideo video={video} />
            </Fragment>
          );
        })}
      </div>
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
