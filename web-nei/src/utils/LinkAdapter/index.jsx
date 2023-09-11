import { Link } from "react-router-dom";

const LinkAdapter = ({ to, external, children, ...props }) => {
    if (!to || to.startsWith('http') || external)
        return (
            <a href={to} target="_blank" rel="noopener noreferer" {...props}>
                {children}
            </a>
        )
    return (
        <Link to={to} {...props}>
            {children}
        </Link>
    )
}

export default LinkAdapter;
