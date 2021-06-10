import React from 'react';
import "./index.css";
import Document from "../../../Components/Document";

import { 
    faFilePdf,
    faFolder
} from '@fortawesome/free-solid-svg-icons';

const getIcon = (url) => {
    if (url.indexOf(".zip")>=0) {
        return faFolder;
    }
    return faFilePdf;
}


/** Takes a single prop: data, a list of objects containing the following properties:
 *  - id
    - name: the name of the file
    - subjectShort: abbreviation of subject name (e.g. "FP")
    - subjectName: full subject name
    - summary, tests, bibliography, slides, exercises, projects, notebook:
        The string "0" or "1", representing if the notes belong in the category 
 */
const GridView = ({data}) => {

    
    return(
        <div className="d-flex flex-row flex-wrap col-12">
            {
                data.map(
                    apontamento => 
                    <Document
                        name={apontamento.name}
                        blank={true}
                        link={process.env.REACT_APP_UPLOADS_UNLOCK + apontamento.location}
                        description={apontamento.subjectName}
                        className="col-xl-4"
                        size="2x"
                        icon={getIcon(apontamento.location)}
                    />
                )
            }
        </div>
    );
}

export default GridView;