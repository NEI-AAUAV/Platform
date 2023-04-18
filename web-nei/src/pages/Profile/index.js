import { useState, useEffect } from "react";
import UserProfile from "./UserProfile";
import UserEmail from "./UserEmail";
import UserConfig from "./UserConfig";


function Profile() {

  return (
    <div className="rounded-box m-auto flex h-fit w-full flex-col bg-base-200 px-3 py-8 align-middle shadow-secondary drop-shadow-md xs:px-14 xs:max-w-lg">
      <div className="mb-6 text-center text-3xl">Editar Perfil</div>

      <UserProfile />
      <div className="divider"></div>

      <UserEmail />
      {/* <div className="divider"></div>
      <UserConfig /> */}
    </div>
  );
}

export default Profile;
