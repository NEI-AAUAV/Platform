import { useState, useEffect } from "react";
import { useLoading } from "utils/hooks";
import { useUserStore } from "stores/useUserStore";

import service from "services/NEIService";

const Status = {
  edited: 1,
  loading: 2,
  success: 3,
  error: 4,
};

function SettingsAccount() {
  // Define state variables for form inputs
  const [errors, setErrors] = useState({});
  const [response, setResponse] = useLoading({ status: null });
  const { name, surname } = useUserStore((state) => state);
  let form = {
    image: null,
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

export default SettingsAccount;
