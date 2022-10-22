import React from 'react';
import Document from "../../../components/Document";

import { 
    faFilePdf,
    faFolder
} from '@fortawesome/free-solid-svg-icons';

import {authorNameProcessing, monthsPassed} from '../utils';

const getIcon = (url) => {
    if (url.indexOf(".zip")>=0) {
        return faFolder;
    }
    return faFilePdf;
}

// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);

const GridView = ({data, setSelected}) => {
    
    return(
        <div className="d-flex flex-row flex-wrap col-12 mx-0 p-0">
            {
                data.map(
                    (apontamento, i) => 
                    <Document
                        name={apontamento.name}
                        description={
                            apontamento.authorName 
                                ? 
                                apontamento.subjectName + "<br/>por " + authorNameProcessing(apontamento.authorName)
                                : 
                                apontamento.subjectName
                        }
                        className="col-xl-4 link slideUpFade"
                        style={{animationDelay: (animationBase + (i*animationIncrement)) + "s"}}
                        size="2x"
                        icon={apontamento.type_icon_display.split(" ")}
                        onClick={() => setSelected(apontamento)}
                        title="Detalhes"
                        tags={(() => {
                            var tags = [];
                            monthsPassed(new Date(apontamento.createdAt)) < 3 && tags.push({"name": "Novo!", "className": "tag-new"});
                            apontamento.summary=="1" && tags.push({"name": "Resumos", "className": "tag-summary"});
                            apontamento.tests=="1" && tags.push({"name": "Testes e exames", "className": "tag-tests"});
                            apontamento.bibliography=="1" && tags.push({"name": "Bibliografia", "className": "tag-biblio"});
                            apontamento.slides=="1" && tags.push({"name": "Slides", "className": "tag-slides"});
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