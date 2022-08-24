import Select from 'react-select';


const colourStyles = {
    color: "blue",

    singleValue: (styles) => ({
        ...styles,
        color: 'var(--text-primary)',
    }),
    control: (styles) => ({
        ...styles,
        backgroundColor: 'var(--background)',
    }),
    menu: (styles) => ({
        ...styles,
        backgroundColor: 'var(--background)',
        border: "1px solid hsl(0, 0%, 80%)"
    }),
    option: (styles, { isFocused, isSelected }) => ({
        ...styles,
        backgroundColor: isSelected
            ? "blue"
            : isFocused
                ? "green"
                : "var(--background)",

        color: 'var(--text-primary)',

        ':active': {
            ...styles[':active'],
            backgroundColor: isSelected ? undefined : "red",
        },
    }),
};

export default (props) => (
    <Select
        {...props}
        styles={colourStyles}
    />
);