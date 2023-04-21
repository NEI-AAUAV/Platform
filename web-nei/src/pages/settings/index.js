import Profile from "./Profile";
import Family from "./Family";
import Account from "./Account";

const Settings = ({ children }) => (
  <div className="rounded-box m-auto flex h-fit w-full flex-col bg-base-200 px-3 py-8 align-middle shadow-secondary drop-shadow-md xs:max-w-lg xs:px-14">
    {children}
  </div>
);

export const SettingsProfile = () => (
  <Settings>
    <Profile />
  </Settings>
);

export const SettingsFamily = () => (
  <Settings>
    <Family />
  </Settings>
);

export const SettingsAccount = () => (
  <Settings>
    <Account />
  </Settings>
);
