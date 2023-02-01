
import { Link } from "react-router-dom";

const LinkAdapter = ({ to, children, ...props }) => {
    if (!to || to?.startsWith('http'))
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
