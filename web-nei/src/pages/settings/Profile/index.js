import { useState, useEffect } from "react";
import {
  LinkIcon,
  AddPhotoIcon,
  ExpandMoreIcon,
  DownloadIcon,
} from "assets/icons/google";
import { useNavigate } from "react-router-dom";
import { useLoading } from "utils/hooks";
import RadioDropdown from "components/RadioDropdown";
import { useForm, Controller } from "react-hook-form";
import { isEmpty } from "lodash";

import { Datepicker, Input, FileInput, Select } from "components/form";

import classNames from "classnames";

import service from "services/NEIService";
import { LinkAdapter } from "components";

import malePic from "assets/default_profile/male.svg";
import femalePic from "assets/default_profile/female.svg";
import otherPic from "assets/default_profile/other.svg";

const Status = {
  edited: 1,
  loading: 2,
  success: 3,
  error: 4,
};

const genderOptions = [
  { value: "M", label: "Masculino" },
  { value: "F", label: "Feminino" },
  { value: null, label: "Não Definido" },
];

function UserProfile() {
  // Define state variables for form inputs
  const [response, setResponse] = useLoading({ status: null });

  const [user, setUser] = useState(null);
  const navigate = useNavigate();

  const {
    register,
    handleSubmit,
    reset,
    getValues,
    setValue,
    watch,
    control,
    formState: { errors, dirtyFields, isLoading, isValid },
  } = useForm({
    mode: "onBlur",
    defaultValues: async () =>
      service.getCurrUser().then((user) => {
        setUser(user);
        return {
          name: user.name,
          surname: user.surname,
          birthdate: user.birthdate,
          gender: user.gender,
          linkedin: user.linkedin,
          github: user.github,
        };
      }),
  });

  const registerFile = (name, options = {}) => {
    return {
      ...register(name, options),
      onChange: (e) => {
        const { files, name } = e.target;
        if (files.length > 0) {
          setValue(name, files[0], { shouldDirty: true, shouldValidate: true });
        }
      },
      onBlur: (e) => {
        const { name, files } = e.target;
        if (files.length === 0) {
          setValue(name, null, { shouldDirty: true, shouldValidate: true });
        }
      },
      ref: null,
      type: "file",
    };
  };

  const watchImage = watch("image");
  const watchCurriculum = watch("curriculum");
  const watchGender = watch("gender");

  useEffect(() => {
    const previewElem = document.getElementById("profile-image-preview");

    const defaultImage = {
      M: malePic,
      F: femalePic,
      null: otherPic,
    }[watchGender || user?.gender];

    if (watchImage === undefined) {
      previewElem.src = user?.image || defaultImage;
      return;
    }
    if (watchImage === null) {
      previewElem.src = defaultImage;
      return;
    }
    const reader = new FileReader();
    reader.addEventListener("load", () => {
      const img = new Image();
      img.addEventListener("load", () => {
        previewElem.src = img.src;
      });
      img.src = reader.result;
    });
    reader.readAsDataURL(watchImage);
  }, [user, watchGender, watchImage]);

  /** Remove consecutive slashes and set protocol to https, */
  const toSecureLink = (link) => {
    link = link
      ?.replace(/^https?:/i, "")
      .replace(/\/{2,}/g, "/")
      .replace(/^\//, "");
    if (!link) return link;
    return `https://${link}`;
  };

  const onSubmit = (data) => {
    const { image, curriculum, ...rest } = data;

    // Remove undefiened values and set empty strings to null
    const user = Object.fromEntries(
      Object.entries(rest)
        .filter(([_, value]) => value !== undefined)
        .map(([key, value]) => [key, value === "" ? null : value])
    );

    const formData = new FormData();
    formData.append("user", JSON.stringify(user));
    image !== undefined && formData.append("image", image || "");
    curriculum !== undefined && formData.append("curriculum", curriculum || "");

    for (const [key, value] of formData.entries()) {
      console.log(key + ": " + value);
    }

    service
      .updateCurrUser(formData)
      .then(() => {
        // navigate(-1);
        window.location.reload();
      })
      .catch((err) => {
        setResponse({
          status: Status.error,
          message: err.message || "Erro ao atualizar perfil",
        });
      });
  };

  console.log(dirtyFields);

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <div className="mb-6 text-center text-3xl">Editar Perfil</div>

      {/* Profile Image Field */}
      <div className="mb-4 flex flex-col items-center">
        <label
          htmlFor="profile-image"
          className="indicator avatar cursor-pointer"
        >
          <div
            className={classNames(
              "relative w-36 rounded-full",
              errors.image && "border border-error"
            )}
          >
            <img
              id="profile-image-preview"
              src={
                "	https://daisyui.com/images/stock/photo-1534528741775-53994a69daeb.jpg"
              }
              alt="Profile"
              className="rounded-full object-cover"
            />
            <div className="absolute inset-0 flex items-center justify-center bg-neutral-focus/70 text-center font-semibold text-neutral-content opacity-0 transition-opacity hover:opacity-100">
              Alterar <br /> Foto
            </div>
          </div>
          <span className="indicator-bottom badge indicator-item pointer-events-none mb-5 mr-5 h-10 w-10">
            <AddPhotoIcon />
          </span>
          <input
            id="profile-image"
            className="hidden"
            accept="image/png, image/jpeg"
            {...registerFile("image", {
              validate: (file) =>
                !file ||
                file.size < 1024 * 1024 ||
                "Imagem deve ter menos de 1MB",
            })}
          />
        </label>
        {user?.image && watchImage === undefined && (
          <button
            className="link-hover link-error link mt-2 font-medium"
            onClick={() => setValue("image", null, { shouldDirty: true })}
          >
            Remover
          </button>
        )}
        {!!errors.image && (
          <p className="message-error">{errors.image?.message}</p>
        )}
      </div>

      {/* Name Field */}
      <div className="mb-4">
        <Input
          id="profile-name"
          label="Nome"
          placeholder="Nome"
          error={errors.name}
          {...register("name", {
            required: { value: true, message: "Nome é obrigatório" },
            maxLength: {
              value: 20,
              message: "Nome deve ter no máximo 20 caracteres",
            },
          })}
        />
      </div>

      {/* Surname Field */}
      <div className="mb-4">
        <Input
          id="profile-surname"
          label="Sobrenome"
          placeholder="Sobrenome"
          error={errors.surname}
          {...register("surname", {
            required: { value: true, message: "Sobrenome é obrigatório" },
            maxLength: {
              value: 20,
              message: "Sobrenome deve ter no máximo 20 caracteres",
            },
          })}
        />
      </div>

      {/* Birthdate Field */}
      <div className="mb-4">
        <Datepicker
          id="profile-birthdate"
          placeholder="Data de Nascimento"
          label="Data de Nascimento"
          error={errors.birthdate}
          {...register("birthdate")}
        />
      </div>

      {/* Gender Field */}
      <div className="mb-4">
        <label className="label">
          <span className="label-text">Gênero</span>
        </label>
        <Controller
          render={({ field }) => (
            <RadioDropdown
              options={genderOptions}
              onChange={field.onChange}
              value={field.value}
            >
              {genderOptions.find((o) => o.value === getValues().gender)?.label}{" "}
              <ExpandMoreIcon />
            </RadioDropdown>
          )}
          name="gender"
          control={control}
        />
        {!!errors.gender && (
          <p className="message-error">{errors.gender?.message}</p>
        )}
      </div>

      {/* Curriculum Field */}
      <div className="mb-4">
        {user?.curriculum && watchCurriculum === undefined ? (
          <>
            <label className="label">
              <span className="label-text">Currículo</span>
            </label>
            <div className="flex items-center gap-5">
              <LinkAdapter
                className="btn flex grow justify-between"
                to={user?.curriculum}
              >
                Descarregar Currículo
                <DownloadIcon />
              </LinkAdapter>
              <button
                className="link-hover link-error link font-medium"
                onClick={() =>
                  setValue("curriculum", null, { shouldDirty: true })
                }
              >
                Remover
              </button>
            </div>
          </>
        ) : (
          <FileInput
            id="profile-curriculum"
            label="Currículo"
            name="curriculum"
            accept="application/pdf"
            error={errors.curriculum}
            {...registerFile("curriculum", {
              validate: (file) =>
                !file ||
                file.size < 1024 * 1024 ||
                "Currículo deve ter menos de 1MB",
            })}
          />
        )}
      </div>

      {/* LinkedIn Field */}
      <div className="mb-4">
        <Input
          id="profile-linkedin"
          label="LinkedIn"
          placeholder="LinkedIn"
          error={errors.linkedin}
          icon={<LinkIcon />}
          {...register("linkedin", {
            maxLength: {
              value: 2048,
              message: "URL inválido",
            },
            setValueAs: (v) => toSecureLink(v),
          })}
          value={watch("linkedin") || ""}
        />
      </div>

      {/* GitHub Field */}
      <div className="mb-4">
        <Input
          id="profile-github"
          label="GitHub"
          placeholder="GitHub"
          error={errors.github}
          icon={<LinkIcon />}
          {...register("github", {
            maxLength: {
              value: 2048,
              message: "URL inválido",
            },
            setValueAs: (v) => toSecureLink(v),
          })}
          value={watch("github") || ""}
        />
      </div>

      {!isEmpty(dirtyFields) && (
        <div className="mt-10 flex justify-between gap-3">
          <button
            className="btn-outline btn-secondary btn"
            type="button"
            onClick={() => reset()}
          >
            Cancelar
          </button>
          <button className="btn-secondary btn" type="submit">
            Guardar Alterações
          </button>
        </div>
      )}
    </form>
  );
}

export default UserProfile;
