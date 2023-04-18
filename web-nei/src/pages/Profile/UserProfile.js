import Datepicker from "components/Datepicker";
import { useState, useEffect } from "react";
import { LinkIcon, AddPhotoIcon, ExpandMoreIcon } from "assets/icons/google";
import { useLoading } from "utils/hooks";
import { useUserStore } from "stores/useUserStore";
import RadioDropdown from "components/RadioDropdown";

import service from "services/NEIService";

const Status = {
  edited: 1,
  loading: 2,
  success: 3,
  error: 4,
};

const genderOptions = [
  { value: "M", label: "Masculino" },
  { value: "F", label: "Feminino" },
  { value: "", label: "Não Definido" },
];

function UserProfile() {
  // Define state variables for form inputs
  const [errors, setErrors] = useState({});
  const [response, setResponse] = useLoading({ status: null });
  const { name, surname, image } = useUserStore((state) => state);
  let form = {
    image,
    name: name || "",
    surname: surname || "",
    birthdate: "",
    curriculum: null,
    gender: "",
    linkedin: "",
    github: "",
  };
  const [values, setValues] = useState(form);

  useEffect(() => {
    // call api /user/me and update useUserStore on update
  }, [])

  function clearForm() {
    setValues(form);
    setErrors(
      Object.keys(form).reduce((acc, key) => ({ ...acc, [key]: null }), {})
    );
    setResponse({ status: null });
  }

  function handleValueChange({ name, value }) {
    setResponse({ status: Status.edited });
    setValues({ ...values, [name]: value });
  }

  const handleSubmit = (event) => {
    event.preventDefault();
    console.log(values)
    const formData = new FormData(event.target);
    console.log(formData)
    if (
      [values.github, values.linkedin].every((v) => v.match(/^https?:\/\/.+/))
    ) {
    }
  };

  return (
      <form className="" onSubmit={handleSubmit}>
        <div className="mb-4 flex justify-center">
          <label
            htmlFor="profile-image"
            className="indicator avatar cursor-pointer"
          >
            <div className="relative w-36 rounded-full">
              <img
                src={
                  "	https://daisyui.com/images/stock/photo-1534528741775-53994a69daeb.jpg"
                }
                alt="Profile"
                className="rounded-full object-cover"
              />
              <div className="absolute inset-0 flex items-center justify-center bg-neutral/70 text-center text-sm font-semibold uppercase leading-normal text-neutral-content opacity-0 transition-opacity hover:opacity-100">
                Alterar <br /> Foto
              </div>
            </div>
            <span className="indicator-bottom badge indicator-item pointer-events-none mb-5 mr-5 h-10 w-10">
              <AddPhotoIcon />
            </span>
            <input
              type="file"
              id="profile-image"
              name="image"
              className="hidden"
              onChange={(e) => handleValueChange(e.target)}
              value={values.image || undefined}
            />
          </label>
        </div>
        <div className="mb-4">
          <label htmlFor="profile-name" className="label">
            <span className="label-text">Nome</span>
          </label>
          <input
            type="text"
            id="profile-name"
            name="name"
            placeholder="Nome"
            className="input-bordered input w-full"
            onChange={(e) => handleValueChange(e.target)}
            value={values.name}
          />
        </div>
        <div className="mb-4">
          <label htmlFor="profile-surname" className="label">
            <span className="label-text">Sobrenome</span>
          </label>
          <input
            type="text"
            id="profile-surname"
            name="surname"
            placeholder="Sobrenome"
            className="input-bordered input w-full"
            onChange={(e) => handleValueChange(e.target)}
            value={values.surname}
          />
        </div>
        <div className="mb-4">
          <label htmlFor="profile-birthdate" className="label">
            <span className="label-text">Data de Nascimento</span>
          </label>
          <Datepicker
            id="profile-birthdate"
            placeholder="Data de Nascimento"
            value={values.birthdate}
            onChange={(value) =>
              handleValueChange({ name: "birthdate", value })
            }
          />
        </div>
        <div className="mb-4">
          <label htmlFor="curriculum" className="label">
            <span className="label-text">Currículo</span>
          </label>
          <input
            type="file"
            name="curriculum"
            placeholder="Currículo"
            className="file-input-bordered file-input w-full"
            onChange={({ target }) =>
              handleValueChange({ name: target.name, value: target.files[0] })
            }
          />
        </div>
        <div className="mb-4">
          <label className="label">
            <span className="label-text">Gênero</span>
          </label>
          <RadioDropdown
            name="gender"
            values={genderOptions.map((o) => ({
              ...o,
              checked: values.gender === o.value,
            }))}
            onChange={(value) => handleValueChange({ name: "gender", value })}
          >
            {genderOptions.find((o) => o.value === values.gender).label}{" "}
            <ExpandMoreIcon />
          </RadioDropdown>
        </div>

        <div className="mb-4">
          <label htmlFor="linkedin" className="label">
            <span className="label-text">LinkedIn</span>
          </label>
          <div className="relative">
            <input
              type="text"
              name="linkedin"
              placeholder="LinkedIn"
              className="input-bordered input w-full pr-12"
              onChange={(e) => handleValueChange(e.target)}
              value={values.linkedin}
            />
            <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-4">
              <LinkIcon />
            </div>
          </div>
        </div>
        <div className="mb-4">
          <label htmlFor="github" className="label">
            <span className="label-text">GitHub</span>
          </label>
          <div className="relative">
            <input
              type="text"
              name="github"
              placeholder="GitHub"
              className="input-bordered input w-full pr-12"
              onChange={(e) => handleValueChange(e.target)}
              value={values.github}
            />
            <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-4">
              <LinkIcon />
            </div>
          </div>
        </div>
        {response.status === Status.edited && (
          <div className="mt-10 flex justify-between gap-3">
            <button
              className="btn-outline btn-secondary btn"
              type="button"
              onClick={clearForm}
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
