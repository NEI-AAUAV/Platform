import Select from 'react-select';


const colourStyles = {
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
            ? "#147a26"
            : isFocused
                ? "#147a2666"
                : "var(--background)",

        color: isSelected ? '#fff': 'var(--text-primary)',

        ':active': {
            ...styles[':active'],
            backgroundColor: isSelected ? undefined : "#147a2699",
        },
    }),
};

export default (props) => (
    <Select
        {...props}
        styles={colourStyles}
    />
);