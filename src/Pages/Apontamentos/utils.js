function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1).toLowerCase();
}

// Reduce number of names in big ones
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

// Difference between dates
let today = new Date();

var monthsPassed = (d) => {
    let months = (today.getFullYear() - d.getFullYear()) * 12;
    months -= d.getMonth();
    months += today.getMonth();
    return months;
}
export {authorNameProcessing, monthsPassed};
