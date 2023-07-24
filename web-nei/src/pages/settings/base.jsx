export function BaseSettings({ children }) {
  return (
    <div className="rounded-box m-auto flex h-fit w-full flex-col bg-base-200 px-3 py-8 align-middle shadow-secondary drop-shadow-md xs:max-w-lg xs:px-14">
      {children}
    </div>
  );
}
