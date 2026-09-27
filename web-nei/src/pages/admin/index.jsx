import React from "react";
import { useSearchParams } from "react-router-dom";
import UsersAndGroups from "./sections/UsersAndGroups";
import Content from "./sections/Content";
import ArraialSettings from "./sections/ArraialSettings";
import Activity from "./sections/Activity";
import SystemStatus from "./sections/SystemStatus";
import AccountInfo from "./sections/AccountInfo";

const TABS = [
  { id: "users", label: "Users & roles", Section: UsersAndGroups },
  { id: "content", label: "Content", Section: Content },
  { id: "arraial", label: "Arraial", Section: ArraialSettings },
  { id: "activity", label: "Activity", Section: Activity },
  { id: "system", label: "System", Section: SystemStatus },
  { id: "account", label: "Your account", Section: AccountInfo },
];

export function Component() {
  const [searchParams, setSearchParams] = useSearchParams();
  const tabRefs = React.useRef({});
  const active = TABS.find((t) => t.id === searchParams.get("tab")) ?? TABS[0];

  const select = (id) => {
    setSearchParams({ tab: id }, { replace: true });
    tabRefs.current[id]?.focus();
  };

  const onKeyDown = (event) => {
    const index = TABS.findIndex((t) => t.id === active.id);
    if (event.key === "ArrowRight") select(TABS[(index + 1) % TABS.length].id);
    if (event.key === "ArrowLeft") select(TABS[(index - 1 + TABS.length) % TABS.length].id);
  };

  const { Section } = active;

  return (
    <div className="mx-auto w-full max-w-5xl p-4">
      <h1>Admin</h1>

      <div role="tablist" aria-label="Admin sections" className="tabs tabs-boxed my-4 inline-flex flex-wrap" onKeyDown={onKeyDown}>
        {TABS.map((tab) => {
          const selected = tab.id === active.id;
          return (
            <button
              key={tab.id}
              ref={(el) => {
                tabRefs.current[tab.id] = el;
              }}
              id={`admin-tab-${tab.id}`}
              role="tab"
              type="button"
              aria-selected={selected}
              aria-controls={`admin-panel-${tab.id}`}
              tabIndex={selected ? 0 : -1}
              className={`tab ${selected ? "tab-active" : ""}`}
              onClick={() => select(tab.id)}
            >
              {tab.label}
            </button>
          );
        })}
      </div>

      <div
        role="tabpanel"
        id={`admin-panel-${active.id}`}
        aria-labelledby={`admin-tab-${active.id}`}
      >
        <Section />
      </div>
    </div>
  );
}
