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
                        tags={(() => {
                            console.log(apontamento);
                            var tags = [];
                            apontamento.summary=="1" && tags.push({"name": "Resumos", "className": "tag-summary"});
                            apontamento.tests=="1" && tags.push({"name": "Testes e exames", "className": "tag-tests"});
                            apontamento.bibliography=="1" && tags.push({"name": "Bibliografia", "className": "tag-biblio"});
                            apontamento.slides=="1" && tags.push({"name": "Slides teóricos", "className": "tag-slides"});
                            apontamento.exercises=="1" && tags.push({"name": "Exercícios", "className": "tag-exercises"});
                            apontamento.projects=="1" && tags.push({"name": "Projetos", "className": "tag-projects"});
                            apontamento.notebook=="1" && tags.push({"name": "Caderno", "className": "tag-notebook"});
                            return tags;
                        })()}
                    />
                )
            }
        </div>
    );
}

export default GridView;