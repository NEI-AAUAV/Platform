import { useEffect, useState, Fragment } from "react";
import Typist from "react-typist";

import PageNav from "../../components/PageNav";
import service from "services/NEIService";
import Document from "components/Document";

import CheckboxDropdown from "components/CheckboxDropdown";

import data from "./data";

import { faPlayCircle } from "@fortawesome/free-solid-svg-icons";

import { Row, Spinner } from "react-bootstrap";
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
        <CheckboxDropdown className="btn-sm m-1" values={tags} onChange={setTags}>
          Filter <FilterIcon />
        </CheckboxDropdown>
      </div>

      {/* Videos list */}
      <Row>
        {(loading || loadingCategories) && (
          <Spinner
            animation="grow"
            variant="primary"
            className="mx-auto mb-3"
            title="A carregar..."
          />
        )}
        {!loading &&
          videos.map((video, index) => {
            const candidates = categories.filter((c) => c.id == video.tag);
            let tag = [];
            if (candidates.length > 0) {
              tag = {
                name: candidates[0].name,
                color: candidates[0].color,
                className: "",
              };
            }

            return (
              <Fragment key={index}>
                <Document
                  name={video.title}
                  description={video.subtitle}
                  link={"/videos/" + video.id}
                  blank={false}
                  icon={faPlayCircle}
                  image={video.image}
                  className="col-lg-6 col-xl-4 slideUpFade p-2"
                  tags={tag ? [tag] : []}
                />
              </Fragment>
            );
          })}
      </Row>
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
