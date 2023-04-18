import React, { useState, useEffect, useMemo } from "react";
import { Spinner } from "react-bootstrap";
import { motion } from "framer-motion";

import Tabs from "components/Tabs";

import Typist from "react-typist";

import { DownloadIcon } from "assets/icons/google";

import service from "services/NEIService";

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
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
  },
};

const RGM = () => {
  const [docs, setDocs] = useState(null);
  const [tab, setTab] = useState(null);
  const [mandates, setMandates] = useState([]);

  const [loading, setLoading] = useState(true);

  /**
   * Get existent mandates from API
   */
  useEffect(() => {
    setLoading(true);
    service
      .getRGMMandates()
      .then(({ data }) => {
        data.sort().reverse();
        setMandates(data);
        setTab(data[0]);
        setLoading(false);
      })
      .catch(() => {
        // window.location.href = "/404";
      });
  }, []);

  useEffect(() => {
    if (!tab) return;
    setLoading(true);
    setDocs(null);
    service
      .getRGM({ mandate: tab })
      .then((data) => {
        setDocs(data);
        setLoading(false);
      })
      .catch(() => {
        // window.location.href = "/404";
      });
  }, [tab]);

  const changeTab = (t) => {
    // Change tab and simulate loading from API
    // This is done to avoid the user seeing the animation of the documents changing???? nah
    setLoading(true);
    setTab(t);
    setTimeout(function () {
      setLoading(false);
    }, 300);
  };

  function customRender(tab) {
    const t = tab.split("/");
    return (
      <>
        {t[0]}
        {t[1] && <small className="opacity-60">/{t[1]}</small>}
      </>
    );
  }

  const ataNumber = docs
    ?.filter((d) => d.category === "ATA")
    .reduce((o, d, i) => ({ ...o, [d.id]: i + 1 }), {});

  return (
    <div className="d-flex flex-column flex-wrap">
      <div style={{ whiteSpace: "pre", overflowWrap: "break-word" }}>
        <h2 className="mb-5 text-center">
          <Typist>Arquivo da Mesa da RGM</Typist>
        </h2>
      </div>
      <Tabs
        tabs={mandates.sort().reverse()}
        value={tab}
        onChange={changeTab}
        renderTab={customRender}
        className="my-8"
      />
      {!!loading && (
        <Spinner
          animation="grow"
          variant="primary"
          className="mx-auto mb-3"
          title="A carregar..."
        />
      )}
      {!loading && (
        <table className="m-auto table w-full max-w-4xl">
          <thead>
            <tr>
              {/* <th></th> */}
              <th>Título</th>
              <th className="hidden text-center xs:table-cell">Data</th>
              <th className="text-center">Documento</th>
            </tr>
          </thead>
          {docs && (
            <motion.tbody
              variants={container}
              initial="hidden"
              animate="visible"
            >
              {docs.map((doc, index) => (
                <motion.tr key={index} variants={item}>
                  <td>
                    <p className="font-bold">
                      {doc?.category}{" "}
                      {!!ataNumber[doc?.id]
                        ? `Número ${ataNumber[doc?.id]}`
                        : doc.mandate}
                    </p>
                    <p className="hidden whitespace-pre-wrap text-sm text-base-content/80 sm:block">
                      {doc?.title}
                    </p>
                  </td>
                  <td className="hidden text-center xs:table-cell">
                    {!!doc?.date &&
                      new Date(doc.date).toLocaleDateString("pt-PT", {
                        year: "numeric",
                        month: "numeric",
                        day: "numeric",
                      })}
                  </td>
                  <td className="text-center">
                    <a href={doc?.file} target="_blank" rel="noreferrer">
                      <button className="btn-xs btn mb-3 ml-0 flex-nowrap">
                        <DownloadIcon />
                        <span className="ml-1">Descarregar</span>
                      </button>
                    </a>
                  </td>
                </motion.tr>
              ))}
            </motion.tbody>
          )}
        </table>
      )}
    </div>
  );
};

export default RGM;
