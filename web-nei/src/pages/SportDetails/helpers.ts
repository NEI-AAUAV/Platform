import { ModalitiesDataProps } from ".";
import { ModalityFrames, ModalitiesByYearAndFrame } from "./types";
import { Modality } from "./types";

export const organizeModalitiesByYearAndFrame = (
  data: ModalitiesDataProps
): ModalitiesByYearAndFrame => {
  return data.modalities.reduce<ModalitiesByYearAndFrame>((acc, modality) => {
    if (!acc[modality.year]) acc[modality.year] = {};
    if (!acc[modality.year][modality.sport])
      acc[modality.year][modality.sport] = [modality];
    else acc[modality.year][modality.sport].push(modality);
    return acc;
  }, {});
};

export const getCurrentModality = (
  modalityId: string,
  data: ModalitiesDataProps
): Modality => {
  const modalityId_int = parseInt(modalityId);
  return (
    data.modalities.find((modality) => modality.id === modalityId_int) ?? {
      year: 0,
      type: "",
      frame: "",
      sport: "",
      id: -1,
    }
  );
};

export const getCurrentModalityFrames = (
  currentModality: Modality,
  data: ModalitiesDataProps
): ModalityFrames[] => {
  return data.modalities
    .filter((modality) => {
      return (
        modality.sport === currentModality.sport &&
        modality.year === currentModality.year
      );
    })
    .map(({ frame, id }) => ({ frame, id }));
};
