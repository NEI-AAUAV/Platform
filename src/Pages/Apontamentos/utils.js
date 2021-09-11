function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1).toLowerCase();
}

var authorNameProcessing = (name) => {
    if (!name)
        return ""
    let namesp = name.split(" ");
    // If only one name, return it
    if (namesp.length==1)
        return capitalizeFirstLetter(name);
    // Otherwise, return first and last
    return capitalizeFirstLetter(namesp[0]) + " " + capitalizeFirstLetter(namesp[namesp.length-1]);
}

export default authorNameProcessing;