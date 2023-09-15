import { useState, Fragment } from "react";
import classNames from "classnames";
import {
  Document,
  MockupTerminal,
  MultipleRangeInput,
  CardMerch,
  GameCard,
  SportsCard,
  CardHall,
} from "components";

import { CalendarViewMonthIcon, ViewAgendaIcon } from "assets/icons/google";


const props = {
  'place':1
}

export function Component() {
  const [btnActive, setBtnActive] = useState(true);
  return (
    <div>
      <CardHall place={3}
                modality={{
                image:
                  "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                sport: "Voleibol 4x4 Femenino",
                frame: "Masculino",
                type: "Coletivo",
                competitions: [
                  {
                    name: "Fase de Grupos",
                    division: 2,
                    id: 1,
                  },
                  {
                    name: "Playoffs",
                    division: 2,
                    id: 2,
                  },
                ],
              }}></CardHall>
      <CardHall place={1}
                modality={{
                image:
                  "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                sport: "Voleibol 4x4 Femenino",
                frame: "Masculino",
                type: "Coletivo",
                competitions: [
                  {
                    name: "Fase de Grupos",
                    division: 2,
                    id: 1,
                  },
                  {
                    name: "Playoffs",
                    division: 2,
                    id: 2,
                  },
                ],
              }}></CardHall>
      <CardHall place={2}
                modality={{
                image:
                  "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                sport: "Voleibol 4x4 Femenino",
                frame: "Masculino",
                type: "Coletivo",
                competitions: [
                  {
                    name: "Fase de Grupos",
                    division: 2,
                    id: 1,
                  },
                  {
                    name: "Playoffs",
                    division: 2,
                    id: 2,
                  },
                ],
              }}></CardHall>
      <h1>Daisy UI Color Names</h1>
      <div className="overflow-y-auto">
        <table className="flex flex-start p-6 w-fit">
          {[
            [
              { name: "primary", key: "p", required: true },
              { name: "primary-focus", key: "pf" },
              { name: "primary-content", key: "pc" },
              { name: "secondary", key: "s", required: true },
              { name: "secondary-focus", key: "sf" },
              { name: "secondary-content", key: "sc" },
            ],
            [
              { name: "accent", key: "a", required: true },
              { name: "accent-focus", key: "af" },
              { name: "accent-content", key: "ac" },
              { name: "neutral", key: "n", required: true },
              { name: "neutral-focus", key: "nf" },
              { name: "neutral-content", key: "nc" },
            ],
            [
              { name: "base-100", key: "b1", required: true },
              { name: "base-200", key: "b2" },
              { name: "base-300", key: "b3" },
              { name: "base-content", key: "bc" },
              { name: "info", key: "in" },
              { name: "info-content", key: "inc" },
            ],
            [
              { name: "success", key: "su" },
              { name: "success-content", key: "suc" },
              { name: "warning", key: "wa" },
              { name: "warning-content", key: "wac" },
              { name: "error", key: "er" },
              { name: "error-content", key: "erc" },
            ],
          ].map((colors) => (
            <Fragment key={colors.map((color) => color.key).join("")}>
              <tbody className="min-w-[425px] flex flex-col">
                {colors.map(({ name, key, required }) => (
                  <Fragment key={key}>
                    <tr className="flex grow">
                      <td className="w-1/2">
                        <span className="ml-2 font-mono font-bold">{name}</span>
                        <br />
                        <span
                          className={`badge bg-${name} w-[3rem]`}
                          style={{ backgroundColor: `hsl(var(--${key}))` }}
                        ></span>
                        <span
                          className={classNames(
                            "float-right m-2 badge badge-sm",
                            {
                              "badge-ghost": !required,
                            }
                          )}
                        >
                          {required ? "required" : "optional"}
                        </span>
                      </td>
                      <td className="w-1/2">
                        <span className="text-xs opacity-60 font-mono">
                          CSS var: <code>hsl(var(--{key}))</code>
                        </span>
                        <br />
                        <span className="font-mono text-xs opacity-60">
                          Class: <code>bg-{name}</code>
                        </span>
                      </td>
                    </tr>
                  </Fragment>
                ))}
              </tbody>
            </Fragment>
          ))}
        </table>
      </div>

      <h1>NEI Components</h1>
      <div className="p-6">
        <MockupTerminal />
        <MultipleRangeInput size="sm" />
        <Document
          name={"Documento"}
          description={"Documento muito importante"}
          // link={}
          blank={false}
          className="col-lg-6 col-xl-4 slideUpFade p-2"
        />
        <div className="btn-group m-1">
          <button
            onClick={() => setBtnActive(false)}
            className={classNames("btn btn-sm gap-2", {
              "btn-active": !btnActive,
            })}
          >
            <CalendarViewMonthIcon /> Mês
          </button>
          <button
            onClick={() => setBtnActive(true)}
            className={classNames("btn btn-sm gap-2", {
              "btn-active": btnActive,
            })}
          >
            <ViewAgendaIcon /> Agenda
          </button>
        </div>
        <CardMerch
          img="https://nei.web.ua.pt/nei/static/merch/sweat.png"
          title="Sweat"
          price={18}
        />
        <CardMerch
          img="https://nei.web.ua.pt/nei/static/merch/casaco.png"
          title="Casaco"
          price={16}
        />
        <CardMerch
          img="https://nei.web.ua.pt/nei/static/merch/scarf.png"
          title="Cachecol"
          price={3}
        />

        <h2>Sports Card Test</h2>
        <div className="flex flex-wrap gap-8 [&>*]:grow [&>*]:shrink [&>*]:basis-96 [&>*]:flex [&>*]:justify-center [&>*>*]:grow [&>*>*]:shrink rounded-xl bg-base-200 p-4">
          <div>
            <SportsCard
              modality={{
                image:
                  "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                sport: "Atletismo",
                frame: "Masculino",
                type: "Coletivo",
                competitions: [
                  {
                    name: "Fase de Grupos",
                    division: 1,
                    id: 1,
                  },
                  {
                    name: "Playoffs",
                    division: 2,
                    id: 2,
                  },
                ],
              }}
            />
          </div>
          <div>
            <SportsCard
              modality={{
                image:
                  "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                sport: "Andebol",
                frame: "Masculino",
                type: "Coletivo",
                competitions: [
                  {
                    name: "Fase de Grupos",
                    division: 2,
                    id: 1,
                  },
                  {
                    name: "Playoffs",
                    division: 2,
                    id: 2,
                  },
                ],
              }}
            />
          </div>
          <div>
            <SportsCard
              modality={{
                image:
                  "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                sport: "Basquetebol",
                frame: "Masculino",
                type: "Coletivo",
                competitions: [
                  {
                    name: "Fase de Grupos",
                    division: 10,
                    id: 1,
                  },
                  {
                    name: "Playoffs",
                    division: 2,
                    id: 2,
                  },
                ],
              }}
            />
          </div>
          <div>
            <SportsCard
              modality={{
                image:
                  "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                sport: "Futsal",
                frame: "Masculino",
                type: "Coletivo",
                competitions: [
                  {
                    name: "Fase de Bananas",
                    division: 1,
                    id: 1,
                  },
                  {
                    name: "Playoffs",
                    division: 2,
                    id: 2,
                  },
                ],
              }}
            />
          </div>
          <div>
            <SportsCard
              modality={{
                image:
                  "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                sport: "Futebol 7",
                frame: "Monkey",
                type: "Coletivo",
                competitions: [
                  {
                    name: "Ooga Booga",
                    division: 1,
                    id: 1,
                  },
                  {
                    name: "Aaa ooh",
                    division: 2,
                    id: 2,
                  },
                ],
              }}
            />
          </div>
          <div>
            <SportsCard
              modality={{
                image:
                  "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                sport: "Voleibol 4x4",
                frame: "Masculino",
                type: "Coletivo",
                competitions: [
                  {
                    name: "Fase de Grupos",
                    division: 1,
                    id: 1,
                  },
                  {
                    name: "Playoffs",
                    division: 2,
                    id: 2,
                  },
                ],
              }}
            />
          </div>
          <div>
            <SportsCard
              modality={{
                image:
                  "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                sport: "E-Sports LOL",
                frame: "Masculino",
                type: "Coletivo",
                competitions: [
                  {
                    name: "Fase de Grupos",
                    division: 1,
                    id: 1,
                  },
                  {
                    name: "Playoffs",
                    division: 2,
                    id: 2,
                  },
                ],
              }}
            />
          </div>
          <div>
            <SportsCard
              modality={{
                image:
                  "https://cdn.discordapp.com/attachments/1079366558759014493/1092206368762642452/image.png",
                sport: "E-Sports CS:GO",
                frame: "Masculino",
                type: "Coletivo",
                competitions: [
                  {
                    name: "Fase de Grupos",
                    division: 1,
                    id: 1,
                  },
                  {
                    name: "Playoffs",
                    division: 2,
                    id: 2,
                  },
                ],
              }}
            />
          </div>
        </div>
      </div>

      <h1>DaisyUI Components</h1>
      <div className="rounded-box bg-base-100 border-base-content/5 text-base-content not-prose grid gap-3 border p-6">
        <div className="grid grid-cols-2 gap-2 md:grid-cols-4">
          <button className="btn">Default</button>
          <button className="btn btn-primary">Primary</button>
          <button className="btn btn-secondary">Secondary</button>
          <button className="btn btn-accent">Accent</button>
          <button className="btn btn-info">Info</button>
          <button className="btn btn-success">Success</button>
          <button className="btn btn-warning">Warning</button>
          <button className="btn btn-error">Error</button>
          <button className="btn bg-gradient-to-r from-secondary to-error">
            Secondary Error
          </button>
        </div>
        <div className="grid grid-cols-2 gap-2 md:grid-cols-4">
          <button className="btn btn-outline">Default</button>
          <button className="btn btn-outline btn-primary">Primary</button>
          <button className="btn btn-outline btn-secondary">Secondary</button>
          <button className="btn btn-outline btn-accent">Accent</button>
          <button className="btn btn-outline btn-info">Info</button>
          <button className="btn btn-outline btn-success">Success</button>
          <button className="btn btn-outline btn-warning">Warning</button>
          <button className="btn btn-outline btn-error">Error</button>
        </div>
        <div className="grid grid-cols-2 place-items-center gap-2 md:grid-cols-4">
          <span className="badge">Default</span>
          <span className="badge badge-primary">Primary</span>
          <span className="badge badge-secondary">Secondary</span>
          <span className="badge badge-accent">Accent</span>
          <span className="badge badge-info">Info</span>
          <span className="badge badge-success">Success</span>
          <span className="badge badge-warning">Warning</span>
          <span className="badge badge-error">Error</span>
        </div>
        <div className="grid grid-cols-2 place-items-center gap-2 md:grid-cols-4">
          <span className="badge badge-outline">Default</span>
          <span className="badge badge-outline badge-primary">Primary</span>
          <span className="badge badge-outline badge-secondary">Secondary</span>
          <span className="badge badge-outline badge-accent">Accent</span>
          <span className="badge badge-outline badge-info">Info</span>
          <span className="badge badge-outline badge-success">Success</span>
          <span className="badge badge-outline badge-warning">Warning</span>
          <span className="badge badge-outline badge-error">Error</span>
        </div>
        <div className="flex flex-col gap-3">
          <div className="flex flex-col gap-3 md:flex-row">
            <div className="md:w-1/2">
              <div className="tabs">
                <button className="tab tab-lifted">Tab</button>
                <button className="tab tab-lifted tab-active">Tab</button>
                <button className="tab tab-lifted">Tab</button>
              </div>
              <div className="flex flex-col">
                <span className="link">I'm a simple link</span>
                <span className="link link-primary">I'm a simple link</span>
                <span className="link link-secondary">I'm a simple link</span>
                <span className="link link-accent">I'm a simple link</span>
              </div>
            </div>
            <div className="flex flex-col gap-3 md:w-1/2">
              <progress value="20" max="100" className="progress">
                Default
              </progress>
              <progress
                value="25"
                max="100"
                className="progress progress-primary"
              >
                Primary
              </progress>
              <progress
                value="30"
                max="100"
                className="progress progress-secondary"
              >
                Secondary
              </progress>
              <progress
                value="40"
                max="100"
                className="progress progress-accent"
              >
                Accent
              </progress>
              <progress value="45" max="100" className="progress progress-info">
                Info
              </progress>
              <progress
                value="55"
                max="100"
                className="progress progress-success"
              >
                Success
              </progress>
              <progress
                value="70"
                max="100"
                className="progress progress-warning"
              >
                Warning
              </progress>
              <progress
                value="90"
                max="100"
                className="progress progress-error"
              >
                Error
              </progress>
            </div>
          </div>
          <div className="flex flex-col gap-3 md:flex-row">
            <div className="stats bg-base-300 border-base-300 border md:w-1/2">
              <div className="stat">
                <div className="stat-title">Total Page Views</div>
                <div className="stat-value">89,400</div>
                <div className="stat-desc">21% more than last month</div>
              </div>
            </div>
            <div className="flex flex-wrap items-center justify-center gap-3 md:w-1/2">
              <div
                className="radial-progress"
                style={{ "--value": 60, "--size": "3.5rem" }}
              >
                60%
              </div>
              <div
                className="radial-progress"
                style={{ "--value": 75, "--size": "3.5rem" }}
              >
                75%
              </div>
              <div
                className="radial-progress"
                style={{ "--value": 90, "--size": "3.5rem" }}
              >
                90%
              </div>
            </div>
          </div>
        </div>
        <div className="flex flex-col gap-3">
          <div className="flex flex-col gap-3 md:flex-row">
            <div className="md:w-1/2">
              <div>
                <input type="checkbox" className="toggle" />
                <input type="checkbox" className="toggle toggle-primary" />
                <input type="checkbox" className="toggle toggle-secondary" />
                <input type="checkbox" className="toggle toggle-accent" />
              </div>
              <div>
                <input type="checkbox" className="checkbox" />
                <input type="checkbox" className="checkbox checkbox-primary" />
                <input
                  type="checkbox"
                  className="checkbox checkbox-secondary"
                />
                <input type="checkbox" className="checkbox checkbox-accent" />
              </div>
              <div>
                <input type="radio" name="radio-1" className="radio" />
                <input
                  type="radio"
                  name="radio-1"
                  className="radio radio-primary"
                />
                <input
                  type="radio"
                  name="radio-1"
                  className="radio radio-secondary"
                />
                <input
                  type="radio"
                  name="radio-1"
                  className="radio radio-accent"
                />
              </div>
            </div>
            <div className="md:w-1/2">
              <input
                type="range"
                min="0"
                max="100"
                className="range range-xs"
              />
              <input
                type="range"
                min="0"
                max="100"
                className="range range-xs range-primary"
              />
              <input
                type="range"
                min="0"
                max="100"
                className="range range-xs range-secondary"
              />
              <input
                type="range"
                min="0"
                max="100"
                className="range range-xs range-accent"
              />
            </div>
          </div>
          <div className="flex flex-col gap-3 md:flex-row">
            <div className="flex flex-col gap-3 md:w-1/2">
              <input
                type="text"
                placeholder="Default"
                className="input input-bordered w-full"
              />
              <input
                type="text"
                placeholder="Primary"
                className="input input-primary input-bordered w-full"
              />
              <input
                type="text"
                placeholder="Secondary"
                className="input input-secondary input-bordered w-full"
              />
              <input
                type="text"
                placeholder="Accent"
                className="input input-accent input-bordered w-full"
              />
            </div>
            <div className="flex flex-col gap-3 md:w-1/2">
              <input
                type="text"
                placeholder="Info"
                className="input input-info input-bordered w-full"
              />
              <input
                type="text"
                placeholder="Success"
                className="input input-success input-bordered w-full"
              />
              <input
                type="text"
                placeholder="Warning"
                className="input input-warning input-bordered w-full"
              />
              <input
                type="text"
                placeholder="Error"
                className="input input-error input-bordered w-full"
              />
            </div>
          </div>
          <div className="flex gap-3">
            <div className="flex flex-grow flex-col gap-3">
              <div className="text-4xl font-bold">Text Size 1</div>
              <div className="text-3xl font-bold">Text Size 2</div>
              <div className="text-2xl font-bold">Text Size 3</div>
              <div className="text-xl font-bold">Text Size 4</div>
              <div className="text-lg font-bold">Text Size 5</div>
              <div className="text-sm font-bold">Text Size 6</div>
              <div className="text-xs font-bold">Text Size 7</div>
            </div>
            <ul className="steps steps-vertical">
              <li className="step step-primary">Step 1</li>
              <li className="step step-primary">Step 2</li>
              <li className="step">Step 3</li>
              <li className="step">Step 4</li>
            </ul>
          </div>
        </div>
        <div className="flex flex-col gap-3">
          <div className="alert">
            <div>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                className="stroke-info h-6 w-6 flex-shrink-0"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth="2"
                  d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                ></path>
              </svg>
              <span>12 unread messages. Tap to see.</span>
            </div>
          </div>
          <div className="alert alert-info">
            <div>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                className="h-6 w-6 flex-shrink-0 stroke-current"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth="2"
                  d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                ></path>
              </svg>
              <span>New software update available.</span>
            </div>
          </div>
          <div className="alert alert-success">
            <div>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="h-6 w-6 flex-shrink-0 stroke-current"
                fill="none"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth="2"
                  d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                ></path>
              </svg>
              <span>Your purchase has been confirmed!</span>
            </div>
          </div>
          <div className="alert alert-warning">
            <div>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="h-6 w-6 flex-shrink-0 stroke-current"
                fill="none"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth="2"
                  d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
                ></path>
              </svg>
              <span>Warning: Invalid email address!</span>
            </div>
          </div>
          <div className="alert alert-error">
            <div>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="h-6 w-6 flex-shrink-0 stroke-current"
                fill="none"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth="2"
                  d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"
                ></path>
              </svg>
              <span>Error! Task failed successfully.</span>
            </div>
          </div>
        </div>
        <div
          id="component-demo"
          className="flex w-full grid-flow-row grid-cols-12 items-center gap-4 overflow-y-hidden overflow-x-scroll px-10 pt-1 pb-10 xl:grid xl:overflow-x-auto xl:px-4 svelte-1n6ue57"
        >
          <div className="bg-base-100 rounded-box col-span-3 row-span-3 mx-2 grid w-72 flex-shrink-0 place-items-center items-center gap-4 p-4 py-8 shadow-xl xl:mx-0 xl:w-full svelte-1n6ue57">
            <div className="dropdown">
              <div tabIndex="0">
                <div className="online avatar">
                  <div className="mask mask-squircle bg-base-content h-24 w-24 bg-opacity-10 p-px">
                    <img
                      src="/tailwind-css-component-profile-1@94w.jpg"
                      width="94"
                      height="94"
                      alt="Avatar Tailwind CSS Component"
                      className="mask mask-squircle"
                    />
                  </div>
                </div>
              </div>
            </div>{" "}
            <div>
              <div className="dropdown w-full">
                <div tabIndex="0">
                  <div className="text-center">
                    <div className="text-lg font-extrabold">Betsy Braddock</div>
                    <div className="text-base-content/70 my-3 text-sm">
                      Strategic Art Manager
                      <br />
                      Global Illustration Observer
                      <br />
                      Business Alignment Developer
                    </div>
                  </div>
                </div>
              </div>{" "}
              <div className="dropdown w-full">
                <div tabIndex="0">
                  <div className="mt-2 text-center">
                    <div className="badge badge-ghost">Design</div>{" "}
                    <div className="badge badge-ghost">Art</div>{" "}
                    <div className="badge badge-ghost">Illustration</div>
                  </div>
                </div>
              </div>
            </div>{" "}
            <div className="dropdown dropdown-top">
              <div tabIndex="0">
                <div className="btn-group">
                  <button className="btn btn-accent btn-sm">Follow</button>{" "}
                  <button
                    aria-label="button component"
                    className="btn btn-accent btn-square btn-sm"
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      className="h-6 w-6 stroke-current"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth="2"
                        d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"
                      ></path>
                    </svg>
                  </button>
                </div>
              </div>
            </div>
          </div>{" "}
          <div className="bg-base-100 rounded-box col-span-3 row-span-3 mx-2 flex w-72 flex-shrink-0 flex-col justify-center gap-4 p-4 shadow-xl xl:mx-0 xl:w-full svelte-1n6ue57">
            <div className="px-6 pt-6">
              <div className="text-xl font-extrabold">Superpower settings</div>{" "}
              <div className="text-base-content/70 my-4 text-xs">
                Enable your favorite superpowers. Terms and conditions apply
              </div>{" "}
              <div className="dropdown w-full flex-1">
                <div tabIndex="0">
                  <div className="form-control">
                    <label className="label cursor-pointer">
                      <span className="label-text">Enable teleportation</span>{" "}
                      <input
                        type="checkbox"
                        className="toggle toggle-primary"
                      />
                    </label>
                  </div>{" "}
                  <div className="form-control">
                    <label className="label cursor-pointer">
                      <span className="label-text">Enable time travel</span>{" "}
                      <input
                        type="checkbox"
                        className="toggle toggle-secondary"
                      />
                    </label>
                  </div>{" "}
                  <div className="form-control">
                    <label className="label cursor-pointer">
                      <span className="label-text">Enable laser eyes</span>{" "}
                      <input type="checkbox" className="toggle toggle-accent" />
                    </label>
                  </div>{" "}
                  <div className="form-control">
                    <label className="label cursor-pointer">
                      <span className="label-text">Enable immortality</span>{" "}
                      <input type="checkbox" className="toggle" />
                    </label>
                  </div>
                </div>
              </div>
            </div>{" "}
            <div className="form-control">
              <div className="dropdown dropdown-top dropdown-end">
                <div tabIndex="0">
                  <button className="btn btn-secondary btn-block space-x-2">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      className="h-6 w-6 stroke-current"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth="2"
                        d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                      ></path>
                    </svg>{" "}
                    <span>Apply settings</span>
                  </button>
                </div>
              </div>
            </div>
          </div>{" "}
          <div className="card card-compact xl:card-normal bg-base-100 col-span-3 row-span-4 mx-2 w-72 flex-shrink-0 overflow-visible shadow-xl xl:mx-0 xl:w-auto svelte-1n6ue57">
            <div className="dropdown">
              <div tabIndex="0">
                <figure>
                  <img
                    src="/tailwind-css-component-card-1.jpg"
                    width="300"
                    height="187"
                    alt="Card Tailwind CSS Component"
                    className="rounded-t-box"
                  />
                </figure>
              </div>
            </div>{" "}
            <div className="card-body">
              <div className="card-title flex items-center font-extrabold">
                Card Component
                <div className="dropdown dropdown-top dropdown-end">
                  <div tabIndex="0">
                    <div
                      tabIndex="0"
                      className="btn btn-ghost text-info btn-xs btn-circle mx-1 inline-block"
                    >
                      <svg
                        width="20"
                        height="20"
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        className="inline h-5 w-5 stroke-current"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth="2"
                          d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                        ></path>
                      </svg>
                    </div>
                  </div>
                </div>
              </div>{" "}
              <div className="dropdown w-full">
                <div tabIndex="0">
                  <div className="mb-2">
                    <div className="badge badge-ghost">May 14th</div>
                  </div>
                </div>
              </div>{" "}
              <p className="text-base-content text-sm text-opacity-80">
                Use card component to easily show blog posts, products,
                features, items and more.
              </p>{" "}
              <div className="card-actions justify-end">
                <div className="dropdown dropdown-top dropdown-end">
                  <div tabIndex="0">
                    <button className="btn btn-primary">Get Started</button>
                  </div>
                </div>
              </div>
            </div>
          </div>{" "}
          <div className="col-span-3 row-span-3 mx-2 flex w-72 flex-shrink-0 flex-col xl:mx-0 xl:w-full svelte-1n6ue57">
            <div className="dropdown">
              <div tabIndex="0" className="bg-opacity-100">
                <div className="tabs w-full flex-grow-0">
                  <button className="tab tab-lifted tab-active tab-border-none tab-lg flex-1">
                    Stats
                  </button>{" "}
                  <button className="tab tab-lifted tab-border-none tab-lg flex-1">
                    Info
                  </button>{" "}
                  <button className="tab tab-lifted tab-border-none tab-lg flex-1">
                    Options
                  </button>
                </div>
              </div>
            </div>{" "}
            <div className="bg-base-100 grid w-full flex-grow gap-3 rounded-xl rounded-tl-none p-6 shadow-xl">
              <div className="flex items-center space-x-2">
                <div className="dropdown">
                  <div tabIndex="0">
                    <div className="online avatar">
                      <div className="mask mask-hexagon bg-base-content h-16 w-16 bg-opacity-10 p-px">
                        <img
                          src="/tailwind-css-component-profile-5@56w.png"
                          alt="Avatar Tailwind CSS Component"
                          className="mask mask-hexagon"
                        />
                      </div>
                    </div>
                  </div>
                </div>{" "}
                <div>
                  <div className="text-lg font-extrabold">Beatrice Thurman</div>{" "}
                  <div className="text-base-content/70 text-sm">
                    220 Followers
                  </div>
                </div>
              </div>{" "}
              <div className="dropdown">
                <div tabIndex="0">
                  <div className="divider text-base-content/60 m-0">
                    Reports
                  </div>
                </div>
              </div>{" "}
              <div className="text-lg font-extrabold">Audience Report</div>{" "}
              <div className="grid gap-3">
                <div className="dropdown dropdown-top">
                  <div tabIndex="0">
                    <div className="flex items-center p-1">
                      <span className="text-base-content/70 w-48 text-xs">
                        Search Engines
                      </span>{" "}
                      <progress
                        max="100"
                        value="50"
                        className="progress progress-success"
                      ></progress>
                    </div>{" "}
                    <div className="flex items-center p-1">
                      <span className="text-base-content/70 w-48 text-xs">
                        Direct
                      </span>{" "}
                      <progress
                        max="100"
                        value="30"
                        className="progress progress-primary"
                      ></progress>
                    </div>{" "}
                    <div className="flex items-center p-1">
                      <span className="text-base-content/70 w-48 text-xs">
                        Social Media
                      </span>{" "}
                      <progress
                        max="100"
                        value="70"
                        className="progress progress-secondary"
                      ></progress>
                    </div>{" "}
                    <div className="flex items-center p-1">
                      <span className="text-base-content/70 w-48 text-xs">
                        Emails
                      </span>{" "}
                      <progress
                        max="100"
                        value="90"
                        className="progress progress-accent"
                      ></progress>
                    </div>{" "}
                    <div className="flex items-center p-1">
                      <span className="text-base-content/70 w-48 text-xs">
                        Ad campaigns
                      </span>{" "}
                      <progress
                        max="100"
                        value="65"
                        className="progress progress-warning"
                      ></progress>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>{" "}
          <div className="col-span-3 row-span-1 mx-2 flex w-72 flex-shrink-0 flex-col justify-center xl:mx-0 xl:w-auto svelte-1n6ue57">
            <div className="dropdown dropdown-end w-full">
              <div tabIndex="0">
                <div className="flex items-center justify-between">
                  <div className="online avatar">
                    <div className="mask mask-squircle bg-base-100 h-16 w-16 p-1">
                      <img
                        src="/tailwind-css-component-profile-3@56w.png"
                        alt="Avatar Tailwind CSS Component"
                        className="mask mask-squircle"
                      />
                    </div>
                  </div>{" "}
                  <div className="online avatar">
                    <div className="mask mask-squircle bg-base-100 h-16 w-16 p-1">
                      <img
                        src="/tailwind-css-component-profile-2@56w.png"
                        alt="Avatar Tailwind CSS Component"
                        className="mask mask-squircle"
                      />
                    </div>
                  </div>{" "}
                  <div className="avatar offline">
                    <div className="mask mask-squircle bg-base-100 h-16 w-16 p-1">
                      <img
                        src="/tailwind-css-component-profile-4@56w.png"
                        alt="Avatar Tailwind CSS Component"
                        className="mask mask-squircle"
                      />
                    </div>
                  </div>{" "}
                  <div className="avatar">
                    <div className="mask mask-squircle bg-base-100 h-16 w-16 p-1">
                      <img
                        src="/tailwind-css-component-profile-5@56w.png"
                        alt="Avatar Tailwind CSS Component"
                        className="mask mask-squircle"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>{" "}
          <div className="bg-base-100 text-base-content rounded-box col-span-3 row-span-4 mx-2 grid w-72 flex-shrink-0 shadow-xl xl:mx-0 xl:w-auto xl:place-self-stretch svelte-1n6ue57">
            <div className="grid w-full grid-cols-1 gap-4 p-4">
              <div className="dropdown">
                <div tabIndex="0">
                  <div className="grid w-full grid-cols-2 gap-4">
                    <button className="btn btn-block">Neutral</button>{" "}
                    <button className="btn btn-primary btn-block">
                      primary
                    </button>{" "}
                    <button className="btn btn-secondary btn-block">
                      secondary
                    </button>{" "}
                    <button className="btn btn-accent btn-block">accent</button>{" "}
                    <button className="btn btn-info btn-block">info</button>{" "}
                    <button className="btn btn-success btn-block">
                      success
                    </button>
                  </div>
                </div>
              </div>{" "}
              <div className="dropdown dropdown-top">
                <div tabIndex="0">
                  <div className="grid w-full grid-cols-2 gap-4">
                    <button className="btn btn-warning btn-block">
                      warning
                    </button>{" "}
                    <button className="btn btn-error btn-block">error</button>{" "}
                    <button className="btn btn-outline btn-block">
                      outline
                    </button>{" "}
                    <button className="btn btn-outline btn-primary btn-block">
                      primary
                    </button>{" "}
                    <button className="btn btn-outline btn-secondary btn-block">
                      secondary
                    </button>{" "}
                    <button className="btn btn-outline btn-accent btn-block">
                      accent
                    </button>{" "}
                    <button className="btn btn-ghost btn-block">ghost</button>{" "}
                    <button className="btn btn-link btn-block">link</button>
                  </div>
                </div>
              </div>
            </div>
          </div>{" "}
          <div className="col-span-3 row-span-2 mx-2 grid w-72 flex-shrink-0 gap-4 xl:mx-0 xl:w-auto svelte-1n6ue57">
            <div className="dropdown dropdown-end dropdown-top">
              <div tabIndex="0">
                <div className="grid gap-4">
                  <div className="btn-group flex">
                    <button className="btn flex-1">1</button>{" "}
                    <button className="btn btn-active flex-1">2</button>{" "}
                    <button className="btn flex-1">3</button>{" "}
                    <button className="btn flex-1">4</button>{" "}
                    <button className="btn flex-1">5</button>
                  </div>{" "}
                  <div className="btn-group flex">
                    <button className="btn btn-outline flex-1">1</button>{" "}
                    <button className="btn btn-outline flex-1">2</button>{" "}
                    <button className="btn btn-outline flex-1">3</button>{" "}
                    <button className="btn btn-outline flex-1">4</button>{" "}
                    <button className="btn btn-outline flex-1">5</button>
                  </div>
                </div>
              </div>
            </div>{" "}
            <div className="dropdown dropdown-end dropdown-top">
              <div tabIndex="0">
                <div className="tabs tabs-boxed items-center">
                  <button className="tab flex-1">Tab 1</button>{" "}
                  <button className="tab tab-active flex-1">Tab 2</button>{" "}
                  <button className="tab flex-1">Tab 3</button>
                </div>
              </div>
            </div>
          </div>{" "}
          <div className="bg-base-100 text-base-content rounded-box col-span-3 row-span-3 mx-2 grid w-72 flex-shrink-0 items-stretch shadow-xl xl:mx-0 xl:w-auto xl:place-self-stretch svelte-1n6ue57">
            <div className="grid place-content-center gap-4 p-4">
              <div className="dropdown dropdown-end">
                <div tabIndex="0">
                  <div className="alert flex-col space-y-2">
                    <div className="flex-1">
                      <span className="mx-3 text-sm">
                        Lorem ipsum dolor sit amet, consectetur adip!
                      </span>
                    </div>{" "}
                    <div className="flex-none">
                      <button className="btn btn-primary btn-outline btn-sm mr-2">
                        Cancel
                      </button>{" "}
                      <button className="btn btn-primary btn-sm">Apply</button>
                    </div>
                  </div>
                </div>
              </div>{" "}
              <div className="dropdown dropdown-end dropdown-top">
                <div tabIndex="0">
                  <div className="alert alert-info">
                    <div className="flex-1">
                      <svg
                        width="20"
                        height="20"
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        className="mx-2 h-6 w-6 stroke-current"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth="2"
                          d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                        ></path>
                      </svg>{" "}
                      <span className="text-sm">
                        Lorem ipsum dolor sit amet, consectetur adip!
                      </span>
                    </div>
                  </div>
                </div>
              </div>{" "}
              <div className="dropdown dropdown-end dropdown-top">
                <div tabIndex="0">
                  <div className="alert alert-success">
                    <div className="flex-1">
                      <svg
                        width="20"
                        height="20"
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        className="mx-2 h-6 w-6 stroke-current"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth="2"
                          d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"
                        ></path>
                      </svg>{" "}
                      <span className="text-sm">
                        Lorem ipsum dolor sit amet, consectetur adip!
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>{" "}
          <div className="col-span-3 row-span-2 mx-2 grid w-72 flex-shrink-0 gap-4 xl:mx-0 xl:w-auto xl:place-self-stretch svelte-1n6ue57">
            <div className="bg-base-100 text-base-content rounded-box shadow-xl">
              <div className="dropdown dropdown-end w-full">
                <div tabIndex="0">
                  <ul className="menu overflow-visible p-3">
                    <li className="menu-title">
                      <span>Menu Title</span>
                    </li>{" "}
                    <li>
                      <button>
                        <svg
                          width="20"
                          height="20"
                          xmlns="http://www.w3.org/2000/svg"
                          fill="none"
                          viewBox="0 0 24 24"
                          className="mr-2 inline-block h-5 w-5 stroke-current"
                        >
                          <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth="2"
                            d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01"
                          ></path>
                        </svg>
                        Menu Item 1
                      </button>
                    </li>{" "}
                    <li>
                      <button>
                        <svg
                          width="20"
                          height="20"
                          xmlns="http://www.w3.org/2000/svg"
                          fill="none"
                          viewBox="0 0 24 24"
                          className="mr-2 inline-block h-5 w-5 stroke-current"
                        >
                          <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth="2"
                            d="M13 10V3L4 14h7v7l9-11h-7z"
                          ></path>
                        </svg>
                        Menu Item 2
                      </button>
                    </li>{" "}
                    <li>
                      <button>
                        <svg
                          width="20"
                          height="20"
                          xmlns="http://www.w3.org/2000/svg"
                          fill="none"
                          viewBox="0 0 24 24"
                          className="mr-2 inline-block h-5 w-5 stroke-current"
                        >
                          <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth="2"
                            d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"
                          ></path>
                        </svg>
                        Menu Item 3
                        <div className="badge badge-success">new</div>
                      </button>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>{" "}
          <div className="col-span-3 row-span-1 mx-2 grid w-72 flex-shrink-0 gap-4 xl:mx-0 xl:w-auto svelte-1n6ue57">
            <div className="bg-base-100 text-base-content rounded-box shadow-xl">
              <div className="dropdown dropdown-end dropdown-top w-full">
                <div tabIndex="0">
                  <div className="flex justify-center gap-8 p-4">
                    <label aria-label="checkbox CSS component">
                      <input type="checkbox" className="checkbox" />
                    </label>{" "}
                    <label aria-label="checkbox CSS component">
                      <input
                        type="checkbox"
                        className="checkbox checkbox-primary"
                      />
                    </label>{" "}
                    <label aria-label="checkbox CSS component">
                      <input
                        type="checkbox"
                        className="checkbox checkbox-secondary"
                      />
                    </label>{" "}
                    <label aria-label="checkbox CSS component">
                      <input
                        type="checkbox"
                        className="checkbox checkbox-accent"
                      />
                    </label>
                  </div>
                </div>
              </div>{" "}
              <div className="dropdown dropdown-end w-full">
                <div tabIndex="0">
                  <div className="rating rating-lg rating-half w-full justify-center px-4 pb-4">
                    <input
                      type="radio"
                      aria-label="Rating reset"
                      name="rating-10"
                      className="rating-hidden"
                    />{" "}
                    <input
                      type="radio"
                      aria-label="Rating half star"
                      name="rating-10"
                      className="mask mask-star-2 mask-half-1 bg-green-500"
                    />{" "}
                    <input
                      type="radio"
                      aria-label="Rating 1 star"
                      name="rating-10"
                      className="mask mask-star-2 mask-half-2 bg-green-500"
                    />{" "}
                    <div className="w-1"></div>{" "}
                    <input
                      type="radio"
                      aria-label="Rating 1 and half star"
                      name="rating-10"
                      className="mask mask-star-2 mask-half-1 bg-green-500"
                    />{" "}
                    <input
                      type="radio"
                      aria-label="Rating 2 star"
                      name="rating-10"
                      className="mask mask-star-2 mask-half-2 bg-green-500"
                    />{" "}
                    <div className="w-1"></div>{" "}
                    <input
                      type="radio"
                      aria-label="Rating 2 and half star"
                      name="rating-10"
                      className="mask mask-star-2 mask-half-1 bg-green-500"
                    />{" "}
                    <input
                      type="radio"
                      aria-label="Rating 3 star"
                      name="rating-10"
                      className="mask mask-star-2 mask-half-2 bg-green-500"
                    />{" "}
                    <div className="w-1"></div>{" "}
                    <input
                      type="radio"
                      aria-label="Rating 3 and half star"
                      name="rating-10"
                      className="mask mask-star-2 mask-half-1 bg-green-500"
                    />{" "}
                    <input
                      type="radio"
                      aria-label="Rating 4 star"
                      name="rating-10"
                      className="mask mask-star-2 mask-half-2 bg-green-500"
                    />{" "}
                    <div className="w-1"></div>{" "}
                    <input
                      type="radio"
                      aria-label="Rating 4 and half star"
                      name="rating-10"
                      className="mask mask-star-2 mask-half-1 bg-green-500"
                    />{" "}
                    <input
                      type="radio"
                      aria-label="Rating 5 star"
                      name="rating-10"
                      className="mask mask-star-2 mask-half-2 bg-green-500"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>{" "}
          <div className="col-span-3 row-span-1 mx-2 grid w-72 flex-shrink-0 gap-4 xl:mx-0 xl:w-auto svelte-1n6ue57">
            <div className="bg-neutral text-neutral-content rounded-box flex items-center shadow-xl">
              <div className="dropdown dropdown-top">
                <div tabIndex="0">
                  <div className="breadcrumbs px-4 text-sm">
                    <ul>
                      <li>
                        <a href="/">
                          <svg
                            width="20"
                            height="20"
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            className="mr-2 h-4 w-4 stroke-current"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth="2"
                              d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"
                            ></path>
                          </svg>
                          Documents
                        </a>
                      </li>{" "}
                      <li>
                        <a href="/">
                          <svg
                            width="20"
                            height="20"
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            className="mr-2 h-4 w-4 stroke-current"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth="2"
                              d="M9 13h6m-3-3v6m5 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                            ></path>
                          </svg>
                          Add Document
                        </a>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>{" "}
            <div className="bg-accent text-accent-content rounded-box flex items-center p-4 shadow-xl">
              <div className="flex-1 px-2">
                <h2 className="text-3xl font-extrabold">4,600</h2>{" "}
                <p className="text-sm text-opacity-80">Page views</p>
              </div>{" "}
              <div className="flex-0">
                <div className="dropdown dropdown-top dropdown-end">
                  <div tabIndex="0">
                    <div className="flex space-x-1">
                      <button
                        aria-label="button component"
                        className="btn btn-ghost btn-square"
                      >
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          fill="none"
                          viewBox="0 0 24 24"
                          className="inline-block h-6 w-6 stroke-current"
                        >
                          <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth="2"
                            d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                          ></path>
                          <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth="2"
                            d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                          ></path>
                        </svg>
                      </button>{" "}
                      <button
                        aria-label="button component"
                        className="btn btn-ghost btn-square"
                      >
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          fill="none"
                          viewBox="0 0 24 24"
                          className="inline-block h-6 w-6 stroke-current"
                        >
                          <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth="2"
                            d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"
                          ></path>
                        </svg>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>{" "}
          <div className="card bg-base-100 col-span-3 row-span-1 mx-2 w-72 flex-shrink-0 overflow-visible shadow-lg xl:mx-0 xl:w-auto xl:place-self-stretch svelte-1n6ue57">
            <div className="card-body flex-row items-center space-x-4 px-4">
              <div className="flex-1">
                <h2 className="card-title mb-0 flex">
                  <div className="dropdown dropdown-top">
                    <div tabIndex="0">
                      <button
                        aria-label="loading button"
                        className="btn btn-ghost loading btn-sm btn-circle"
                      ></button>
                    </div>
                  </div>
                  Downloading...
                </h2>{" "}
                <div className="dropdown dropdown-top w-full">
                  <div tabIndex="0">
                    <progress
                      value="70"
                      max="100"
                      className="progress progress-secondary"
                    ></progress>
                  </div>
                </div>
              </div>{" "}
              <div className="flex-0">
                <div className="dropdown dropdown-top dropdown-end">
                  <div tabIndex="0">
                    <button
                      aria-label="circle button component"
                      className="btn btn-circle"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        className="inline-block h-6 w-6 stroke-current"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth="2"
                          d="M6 18L18 6M6 6l12 12"
                        ></path>
                      </svg>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
