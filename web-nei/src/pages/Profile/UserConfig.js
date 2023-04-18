import { useUserStore } from "stores/useUserStore";

function UserConfig() {
  const { reducedAnimation } = useUserStore((state) => state);

  return (
    <>
      <div className="form-control">
        <label className="label cursor-pointer">
          <span className="label-text">Animação reduzida</span>
          <input
            type="checkbox"
            className="toggle"
            checked={reducedAnimation}
            onChange={() => useUserStore.getState().toggleReducedAnimation()}
          />
        </label>
      </div>
    </>
  );
}

export default UserConfig;
