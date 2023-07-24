import React, { useState, useEffect } from "react";
import { useParams, Link } from "react-router-dom";
import Typist from "react-typist";
import { motion, AnimatePresence } from "framer-motion";
import { Spinner } from "react-bootstrap";
import YoutubeEmbed from "../../components/YoutubeEmbed";
import Alert from "../../components/Alert";
import service from "services/NEIService";
import { ArrowBackIcon } from "assets/icons/google";

export function Component() {
  // get course from URL parameters
  let { id } = useParams();

  const [video, setVideo] = useState(null);
  const [loading, setLoading] = useState(true);

  // On load, get video from API
  useEffect(() => {
    setLoading(true);

    service
      .getVideosById(id)
      .then((data) => {
        setVideo(data);
        setLoading(false);
      })
      .catch(() => {
        window.location.href = "/404";
      });
  }, []);

  return (
    <div>
      <Link to="/videos">
        <span className="link-primary link m-0 mb-3 flex items-center gap-2 p-0 no-underline">
          <ArrowBackIcon /> Voltar aos vídeos
        </span>
      </Link>
      {!loading && video && (
        <div className="flex flex-col justify-center">
          <h2 className="text-center">{video.title}</h2>
          <h4 className="text-center text-secondary">{video.subtitle}</h4>
          <p className="text-center text-secondary">
            Atualizado a{" "}
            {new Date(video.created_at?.split("T").at(0)).toLocaleDateString(
              "pt-PT",
              { day: "numeric", month: "long", year: "numeric" }
            )}
          </p>

          <AnimatePresence>
            <motion.div
              className="relative left-1/2 max-w-5xl -translate-x-1/2"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
            >
              <YoutubeEmbed
                embedId={video.youtube_id}
                playlist={video.playlist === 1}
                className="my-4"
              />
            </motion.div>
          </AnimatePresence>

          {video.playlist == "1" && (
            <Alert
              alert={{
                type: "info",
                text: "Este tópico é uma lista de reprodução. Para navegares entre os vídeos utiliza o ícone no canto superior direito do reprodutor.",
              }}
              setAlert={null}
            />
          )}
        </div>
      )}

      <div>
        {!!loading && (
          <Spinner
            animation="grow"
            variant="primary"
            className="mx-auto mb-3"
            title="A carregar..."
          />
        )}
      </div>
    </div>
  );
}
