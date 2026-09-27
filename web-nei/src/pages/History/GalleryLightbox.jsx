import React, { useEffect, useRef, useState } from "react";

import MaterialSymbol from "components/MaterialSymbol";
import {
  Dialog,
  DialogContent,
  DialogTitle,
  DialogDescription,
} from "components/ui/dialog";

import useGallery from "./useGallery";
import useSwipe from "./useSwipe";

import "./GalleryLightbox.css";

function preload(url) {
  const image = new Image();
  image.src = url;
}

/** A requested photo that the loaded gallery doesn't have lands on the
 * first one instead. */
function resolveIndex(requested, length) {
  return requested != null && requested >= 0 && requested < length ? requested : 0;
}

function GalleryStatus({ gallery }) {
  if (gallery.status === "loading") {
    return <p className="history-lightbox__status">A carregar fotos…</p>;
  }
  if (gallery.status === "error") {
    return (
      <div className="history-lightbox__status" role="alert">
        <p>Não foi possível carregar a galeria.</p>
        <button type="button" className="history-lightbox__retry" onClick={gallery.retry}>
          <MaterialSymbol icon="refresh" size={18} />
          Tentar de novo
        </button>
      </div>
    );
  }
  return <p className="history-lightbox__status">Sem fotos disponíveis para este marco.</p>;
}

function GalleryNotice({ gallery }) {
  if (gallery.truncated) {
    return (
      <p className="history-lightbox__notice">
        A mostrar as primeiras {gallery.media.length} fotos desta galeria.
      </p>
    );
  }
  if (gallery.driveStatus === "error") {
    return (
      <p className="history-lightbox__notice">
        Algumas fotos não puderam ser carregadas agora.
      </p>
    );
  }
  return null;
}

/** `initialIndex` (0-based, or null) is only read when a gallery finishes
 * loading — deep links land on a given photo; after that the lightbox owns
 * the index and reports every change, including falling back from a photo
 * that doesn't exist, through `onIndexChange`. */
export default function GalleryLightbox({
  milestone,
  initialIndex = null,
  onIndexChange,
  onClose,
}) {
  const milestoneId = milestone?.id ?? null;
  const initialIndexRef = useRef(initialIndex);
  initialIndexRef.current = initialIndex;
  const onIndexChangeRef = useRef(onIndexChange);
  onIndexChangeRef.current = onIndexChange;

  // Tagged with its milestone, like the gallery itself: a new milestone
  // starts on its first photo with nothing marked as broken.
  const [view, setView] = useState({ milestoneId: null, index: 0, failed: new Set() });
  const own = view.milestoneId === milestoneId;
  const index = own ? view.index : 0;
  const failed = own ? view.failed : new Set();

  const gallery = useGallery(milestoneId, {
    onLoaded(media) {
      const requested = initialIndexRef.current;
      const resolved = resolveIndex(requested, media.length);
      setView({ milestoneId, index: resolved, failed: new Set() });
      if (requested != null && requested !== resolved) onIndexChangeRef.current?.(resolved);
    },
  });
  const media = gallery.status === "ready" ? gallery.media : [];
  const current = media[index];

  useEffect(() => {
    if (media.length < 2) return;
    preload(media[(index + 1) % media.length].url);
    preload(media[(index - 1 + media.length) % media.length].url);
  }, [index, media]);

  const stripRef = useRef(null);
  useEffect(() => {
    stripRef.current
      ?.querySelector('[aria-current="true"]')
      ?.scrollIntoView?.({ block: "nearest", inline: "center" });
  }, [index]);

  function show(next) {
    setView({ milestoneId, index: next, failed });
    onIndexChange?.(next);
  }

  function goTo(delta) {
    if (media.length < 2) return;
    show((index + delta + media.length) % media.length);
  }

  function markFailed(id) {
    setView((previous) => ({ ...previous, failed: new Set(previous.failed).add(id) }));
  }

  const swipe = useSwipe(goTo);

  function handleKeyDown(event) {
    if (event.key === "ArrowRight") goTo(1);
    if (event.key === "ArrowLeft") goTo(-1);
  }

  return (
    <Dialog open={!!milestone} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="history-lightbox" onKeyDown={handleKeyDown}>
        <DialogTitle className="sr-only">
          {milestone ? `Galeria — ${milestone.title}` : "Galeria"}
        </DialogTitle>
        <DialogDescription className="sr-only">
          Use as setas do teclado, deslize na foto ou use os botões para navegar entre fotos.
        </DialogDescription>

        {!current && <GalleryStatus gallery={gallery} />}

        {current && (
          <>
            <figure className="history-lightbox__stage" {...swipe}>
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
                  // The caption is the only description editors write; it is
                  // also shown below, so screen readers get it once here.
                  alt={current.caption || `Foto ${index + 1} de ${media.length}`}
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
                  <span className="history-lightbox__counter" aria-live="polite">
                    {index + 1} / {media.length}
                  </span>
                </>
              )}
            </figure>

            {current.caption && (
              <p className="history-lightbox__caption" aria-hidden="true">
                {current.caption}
              </p>
            )}

            <GalleryNotice gallery={gallery} />

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
