import { useState, useEffect, Fragment } from "react";
import { useParams, useNavigate } from "react-router";
import { Row, Spinner } from "react-bootstrap";
import Image from "react-bootstrap/Image";

import TextList from "../../components/TextList";
import SeniorsCard from "./SeniorsCard";
import Typist from "react-typist";

import service from "services/NEIService";

import Tabs from "components/Tabs";


// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(
  process.env.REACT_APP_ANIMATION_INCREMENT
);

const Seniors = () => {
  // Get course from URL parameters
  const navigate = useNavigate();
  const { course } = useParams();

  let animKey = 0; // Index for delaying animations

  const [people, setPeople] = useState([]);
  const [years, setYears] = useState([]);
  const [selectedYear, setSelectedYear] = useState();
  const [img, setImg] = useState();

  const [namesOnly, setNamesOnly] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!course) {
      navigate("lei");
      return;
    }
    setYears(null); // Hack to update typist title

    // Fetch list of courses to check if 'course' is valid
    service
      .getSeniorsCourse()
      .then((data) => {
        if (!data.includes(course.toUpperCase())) {
          throw new Error("Not available");
        }
      })
      .catch((e) => {
        console.error(e);
      });

    // Fetch number of years
    service
      .getSeniorsCourseYear(course)
      .then((data) => {
        var anos = data.sort((a, b) => b - a);
        if (anos.length > 0) {
          setYears(anos);
          setSelectedYear(anos[0]);
        } else {
          throw new Error("Not available");
        }
      })
      .catch((e) => {
        console.error(e);
      });
  }, [course]);

  useEffect(() => {
    if (!course) {
      navigate("lei");
      return;
    }
    if (selectedYear === undefined) return;
    setLoading(true);

    service
      .getSeniorsBy(course, selectedYear)
      .then((data) => {
        if (!data) {
          throw new Error("Not available");
        }
        setNamesOnly(
          data.students[0]["quote"] === null && data.students[0]["image"] === null
        );
        setPeople(data.students);
        setImg(
          <Image
            src={data.image}
            rounded
            fluid
            className="slideUpFade"
            style={{
              animationDelay: animationBase + animationIncrement * 0 + "s",
              marginBottom: 50,
            }}
          />
        );
        setLoading(false);
      })
      .catch(() => {
        window.location.href = "/404";
      });
  }, [selectedYear, course]);

  return (
    <div className="d-flex flex-column flex-wrap pb-5 mb-5">
      <h2 className="mb-5 text-center">
        {years && <Typist>{"Finalistas de " + course?.toUpperCase()}</Typist>}
      </h2>
  
      <Tabs
        tabs={years}
        value={selectedYear}
        onChange={setSelectedYear}
      />
      {loading ? (
        <Spinner
          animation="grow"
          variant="primary"
          className="mx-auto mb-3"
          title="A carregar..."
        />
      ) : (
        <>
          {namesOnly && <Row>{img}</Row>}
          <Row>
            {namesOnly
              ? people?.map((person, index) => (
                  <Fragment key={index}>
                    <TextList
                      colSize={3}
                      text={person.user?.name + " " + person.user?.surname}
                      className="slideUpFade"
                      style={{
                        animationDelay:
                          animationBase + animationIncrement * 0 + "s",
                      }}
                    />
                  </Fragment>
                ))
              : people?.map((person, index) => (
                  <Fragment key={index}>
                    <SeniorsCard
                      name={person.user?.name + " " + person.user?.surname}
                      quote={person.quote}
                      image={person.image}
                      colSizeXs="12"
                      colSizeSm="6"
                      colSizeLg="4"
                      colSizeXl="3"
                      className="slideUpFade"
                      style={{
                        animationDelay:
                          animationBase + animationIncrement * animKey++ + "s",
                      }}
                    />
                  </Fragment>
                ))}
          </Row>
        </>
      )}
    </div>
  );
};

export default Seniors;
