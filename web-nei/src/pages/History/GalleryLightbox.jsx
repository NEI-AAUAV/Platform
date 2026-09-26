import React, { useEffect, useRef, useState } from "react";

import service from "services/NEIService";
import MaterialSymbol from "components/MaterialSymbol";
import {
  Dialog,
  DialogContent,
  DialogTitle,
  DialogDescription,
} from "components/ui/dialog";

const SWIPE_THRESHOLD_PX = 50;

export default function GalleryLightbox({ milestone, onClose }) {
  const [media, setMedia] = useState(milestone?.media ?? []);
  const [loading, setLoading] = useState(false);
  const [index, setIndex] = useState(0);
  const touchStartX = useRef(null);

  useEffect(() => {
    if (!milestone) return;

    setIndex(0);
    setMedia(milestone.media);

    if (!milestone.has_drive_gallery) return;

    let cancelled = false;
    setLoading(true);
    service
      .getHistoryGallery(milestone.id)
      .then((gallery) => {
        if (!cancelled) setMedia(gallery.media);
      })
      .catch(() => {
        // Keep whatever media we already had; the gallery just won't
        // include the Drive-folder photos this time.
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });

    return () => {
      cancelled = true;
    };
  }, [milestone]);

  function goTo(delta) {
    setIndex((current) => {
      const next = current + delta;
      if (next < 0) return media.length - 1;
      if (next >= media.length) return 0;
      return next;
    });
  }

  function handleKeyDown(event) {
    if (event.key === "ArrowRight") goTo(1);
    if (event.key === "ArrowLeft") goTo(-1);
  }

  function handleTouchStart(event) {
    touchStartX.current = event.touches[0].clientX;
  }

  function handleTouchEnd(event) {
    if (touchStartX.current === null) return;
    const delta = event.changedTouches[0].clientX - touchStartX.current;
    if (Math.abs(delta) > SWIPE_THRESHOLD_PX) goTo(delta < 0 ? 1 : -1);
    touchStartX.current = null;
  }

  const current = media[index];

  return (
    <Dialog open={!!milestone} onOpenChange={(open) => !open && onClose()}>
      <DialogContent
        className="history-lightbox"
        onKeyDown={handleKeyDown}
        onTouchStart={handleTouchStart}
        onTouchEnd={handleTouchEnd}
      >
        <DialogTitle className="sr-only">
          {milestone ? `Galeria — ${milestone.title}` : "Galeria"}
        </DialogTitle>
        <DialogDescription className="sr-only">
          Use as setas do teclado ou os botões para navegar entre fotos.
        </DialogDescription>

        {loading && media.length === 0 && (
          <p className="history-lightbox__status">A carregar fotos…</p>
        )}

        {!loading && media.length === 0 && (
          <p className="history-lightbox__status">
            Sem fotos disponíveis para este marco.
          </p>
        )}

        {current && (
          <>
            <img
              className="history-lightbox__image"
              src={current.url}
              alt={current.caption || ""}
            />
            {current.caption && (
              <p className="history-lightbox__caption">{current.caption}</p>
            )}

            {media.length > 1 && (
              <>
                <button
                  type="button"
                  className="history-lightbox__nav history-lightbox__nav--prev"
                  aria-label="Foto anterior"
                  onClick={() => goTo(-1)}
                >
                  <MaterialSymbol icon="chevron_left" size={28} />
                </button>
                <button
                  type="button"
                  className="history-lightbox__nav history-lightbox__nav--next"
                  aria-label="Foto seguinte"
                  onClick={() => goTo(1)}
                >
                  <MaterialSymbol icon="chevron_right" size={28} />
                </button>
                <span className="history-lightbox__counter">
                  {index + 1} / {media.length}
                </span>
              </>
            )}
          </>
        )}
      </DialogContent>
    </Dialog>
  );
}
