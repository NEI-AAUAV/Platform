import React, { useEffect, useRef, useState } from "react";

import service from "services/NEIService";
import MaterialSymbol from "components/MaterialSymbol";
import {
  Dialog,
  DialogContent,
  DialogTitle,
  DialogDescription,
} from "components/ui/dialog";

import "./GalleryLightbox.css";

const SWIPE_THRESHOLD_PX = 50;

function preload(url) {
  const image = new Image();
  image.src = url;
}

/** `initialIndex` is only read when a milestone opens (deep links land on
 * a given photo); after that the lightbox owns the index and reports every
 * change through `onIndexChange`. */
export default function GalleryLightbox({
  milestone,
  initialIndex = 0,
  onIndexChange,
  onClose,
}) {
  const [media, setMedia] = useState(milestone?.media ?? []);
  const [loading, setLoading] = useState(false);
  const [index, setIndex] = useState(initialIndex);
  const [failed, setFailed] = useState(() => new Set());
  const touchStartX = useRef(null);
  const stripRef = useRef(null);
  const initialIndexRef = useRef(initialIndex);
  initialIndexRef.current = initialIndex;

  useEffect(() => {
    if (!milestone) return undefined;

    setIndex(initialIndexRef.current);
    setMedia(milestone.media);
    setFailed(new Set());

    if (!milestone.has_drive_gallery) return undefined;

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

  // A deep link can point past the photos known before the Drive folder
  // loads; once everything is in, fall back to the first photo.
  useEffect(() => {
    if (!loading && media.length > 0 && index >= media.length) setIndex(0);
  }, [loading, media.length, index]);

  useEffect(() => {
    if (media.length < 2) return;
    preload(media[(index + 1) % media.length].url);
    preload(media[(index - 1 + media.length) % media.length].url);
  }, [index, media]);

  useEffect(() => {
    stripRef.current
      ?.querySelector('[aria-current="true"]')
      ?.scrollIntoView?.({ block: "nearest", inline: "center" });
  }, [index]);

  function show(next) {
    setIndex(next);
    onIndexChange?.(next);
  }

  function goTo(delta) {
    if (media.length === 0) return;
    show((index + delta + media.length) % media.length);
  }

  function markFailed(id) {
    setFailed((current) => new Set(current).add(id));
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

        {loading && !current && (
          <p className="history-lightbox__status">A carregar fotos…</p>
        )}

        {!loading && media.length === 0 && (
          <p className="history-lightbox__status">
            Sem fotos disponíveis para este marco.
          </p>
        )}

        {current && (
          <>
            <figure className="history-lightbox__stage">
              {failed.has(current.id) ? (
                <div className="history-lightbox__broken" role="img" aria-label="Foto indisponível">
                  <MaterialSymbol icon="broken_image" size={40} />
                  <span>Foto indisponível</span>
                </div>
              ) : (
                <img
                  key={current.id}
                  className="history-lightbox__image"
                  src={current.url}
                  alt={current.caption || ""}
                  width={current.width || undefined}
                  height={current.height || undefined}
                  style={
                    current.width && current.height
                      ? { aspectRatio: `${current.width} / ${current.height}` }
                      : undefined
                  }
                  onError={() => markFailed(current.id)}
                />
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
            </figure>

            {current.caption && (
              <p className="history-lightbox__caption">{current.caption}</p>
            )}

            {loading && (
              <p className="history-lightbox__loading-more" role="status">
                A carregar mais fotos…
              </p>
            )}

            {media.length > 1 && (
              <ol className="history-lightbox__strip" ref={stripRef}>
                {media.map((item, i) => (
                  <li key={item.id}>
                    <button
                      type="button"
                      className="history-lightbox__thumb"
                      aria-label={`Foto ${i + 1}`}
                      aria-current={i === index ? "true" : undefined}
                      onClick={() => show(i)}
                    >
                      <img
                        src={item.thumb}
                        alt=""
                        width={72}
                        height={72}
                        loading="lazy"
                        decoding="async"
                        onError={(e) => {
                          e.currentTarget.style.visibility = "hidden";
                        }}
                      />
                    </button>
                  </li>
                ))}
              </ol>
            )}
          </>
        )}
      </DialogContent>
    </Dialog>
  );
}
