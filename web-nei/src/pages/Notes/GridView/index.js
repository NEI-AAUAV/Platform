import { Fragment } from 'react';
import Document from "../../../components/Document";

import {
    faFilePdf,
    faFolder
} from '@fortawesome/free-solid-svg-icons';

import { authorNameProcessing, monthsPassed } from '../utils';

const getIcon = (url) => {
    if (url.indexOf(".zip") >= 0) {
        return faFolder;
    }
    return faFilePdf;
}

// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);

const GridView = ({ data, setSelected }) => {

    return (
        <div className="grid grid-cols-3 mx-0 p-0">
            {
                data.map((note, i) =>
                    <Fragment key={i}>
                        <Document
                            name={note.name}
                            description={
                                note.author?.Name
                                    ?
                                    note.subject?.name + "<br/>por " + authorNameProcessing(note.author?.name)
                                    :
                                    note.subject?.name
                            }
                            className="col-xl-4 link slideUpFade"
                            style={{ animationDelay: (animationBase + (i * animationIncrement)) + "s" }}
                            size="2x"
                            icon={note.type?.icon_display.split(" ")}
                            onClick={() => setSelected(note)}
                            title="Detalhes"
                            tags={(() => {
                                var tags = [];
                                monthsPassed(new Date(note.created_at)) < 3 && tags.push({ "name": "Novo!", "className": "tag-new" });
                                note.summary == "1" && tags.push({ "name": "Resumos", "className": "tag-summary" });
                                note.tests == "1" && tags.push({ "name": "Testes e exames", "className": "tag-tests" });
                                note.bibliography == "1" && tags.push({ "name": "Bibliografia", "className": "tag-biblio" });
                                note.slides == "1" && tags.push({ "name": "Slides", "className": "tag-slides" });
                                note.exercises == "1" && tags.push({ "name": "Exercícios", "className": "tag-exercises" });
                                note.projects == "1" && tags.push({ "name": "Projetos", "className": "tag-projects" });
                                note.notebook == "1" && tags.push({ "name": "Caderno", "className": "tag-notebook" });
                                return tags;
                            })()}
                        />
                    </Fragment>
                )
            }
        </div>
    );
}

export default GridView;