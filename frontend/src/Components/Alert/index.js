import React, {useState, useEffect} from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faInfoCircle, faExclamationCircle, faTimes } from '@fortawesome/free-solid-svg-icons';

/**
 * alert    Object      {text: str, type:Enum(info, alert - Optional)}
 * setAlert Method      Sets alert to null when user clicks close button
 * @param {*} param0 
 * @returns 
 */
const Alert = ({alert, setAlert}) => {
    const [cssclass, setCssClass] = useState('primary');
    const [icon, setIcon] = useState(faInfoCircle);

    useEffect(() => {
        switch(alert.type) {
            case 'info':
                setCssClass('primary');
                setIcon(faInfoCircle);
                break;
            case 'alert':
                setCssClass('danger');
                setIcon(faExclamationCircle);
        }
    }, [alert.type]);

    if (!alert.type) 
        return (<div></div>)

    return (
        <div class={`d-flex flex-row text-${cssclass} bg-outline-${cssclass} mx-auto p-2 font-weight-bold animation`}>
            <FontAwesomeIcon icon={icon} className="mr-2 my-auto"/>
            <p class="col mb-0">{alert.text}</p>
            {
                setAlert &&
                <FontAwesomeIcon icon={faTimes} size="xs" className="ml-3 link my-auto" onClick={() => {setAlert({...alert, type:null})}}/>
            }
        </div>
    );
}

export default Alert;