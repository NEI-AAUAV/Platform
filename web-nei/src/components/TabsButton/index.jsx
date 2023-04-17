import Tab from "./Tab";

const TabsButton = ({ className, tabs, selected, setSelected, ...props }) => {
  const tabsNode = tabs.map((tab, index) => (
    <Tab
      key={index}
      selected={selected === index}
      onClick={() => setSelected(index)}
    >
      {tab}
    </Tab>
  ));
  return (
    <div
      className={`flex w-fit items-center space-x-1 rounded-full bg-base-200 py-1 px-2 ${className}`}
      {...props}
    >
      {tabsNode}
    </div>
  );
};

export default TabsButton;
