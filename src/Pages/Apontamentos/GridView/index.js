import React from 'react';
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


const GridView = ({data, setSelected}) => {

    
    return(
        <div className="d-flex flex-row flex-wrap col-12">
            {
                data.map(
                    apontamento => 
                    <Document
                        name={apontamento.name}
                        description={apontamento.subjectName}
                        className="col-xl-4 link"
                        size="2x"
                        icon={getIcon(apontamento.location)}
                        onClick={() => setSelected(apontamento)}
                        title="Detalhes"
                    />
                )
            }
        </div>
    );
}

export default GridView;