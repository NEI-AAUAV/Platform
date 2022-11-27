const GenericCard = (props) => {
    return (
        <div className="p-3 pt-4 mb-3" style={{
            borderWidth: "1px",
            borderStyle: "solid",
            borderColor: "#FC8551",
            borderRadius: "10px"
        }}>
            {props.children}
        </div>
    );
}

export default GenericCard;
