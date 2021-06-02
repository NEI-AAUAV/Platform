import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import {
    Row
} from "react-bootstrap";
import Document from "../../Components/Document";
import Tabs from "../../Components/Tabs";

const validCategories = {
    'PAO': {
        'singular': 'Plano de Atividades e Orçamento',
        'plural': 'Planos de Atividades e Orçamento'
    },
    'RAC': {
        'singular': 'Relatório de Atividades e Contas',
        'plural': 'Relatórios de Atividades e Contas'
    },
    'ATAS': {
        'singular': 'Ata da RGM',
        'plural': 'Atas da RGM'
    }
};

/**
 * This component renders RGM page for a given document category
 * The category is passed on the URL (/rgm/<category>) and the valid options are summed up on variable validCategories
 */

const RGM = () => {
    // Document category is passed as parameter in URL
    let { id } = useParams();
    
    // Component state
    const [title, setTitle] = useState("");
    const [docs, setDocs] = useState([]);
    const [tab, setTab] = useState(0);
    const [loading, setLoading] = useState(true);

    // On component render...
    useEffect(() => {
        // Validate document category
        if (Object.keys(validCategories).findIndex(item => id.toLowerCase() === item.toLowerCase()) < 0) {
            window.location.href = "/404";
        }
        id = id.toUpperCase();
        setTitle(validCategories[id]['plural']);
        // Fetch API if valid
        fetch(process.env.REACT_APP_API + "/rgm?category=" + id)
            .then(res => res.json())
            .then(json => {
                if ('data' in json) {
                    setDocs(json['data']);
                    // Set tab to maximum year
                    json['data'].forEach(doc => setTab(oldTab => oldTab<doc['mandato'] ? doc['mandato'] : oldTab));
                } else {
                    window.location.href = "/404";    
                }
                setLoading(false);
            }).catch((error) => {
                window.location.href = "/404";
            });
    }, []);

    return (
        <div>
            <h1 id="title">{title}</h1>
            {
                // Only show tabs to ATAS category
                !loading && id.toUpperCase()=="ATAS" &&
                <Tabs
                    tabs={[...new Set(docs.map(doc => doc.mandato))]}
                    _default={tab}
                    onChange={setTab}
                >
                </Tabs>
            }
            {
                !loading &&
                <Row>
                    {
                        // On ATAS category, show only those which mandato match tab
                        docs.filter(doc => id.toUpperCase()!="ATAS" || doc.mandato==tab).map(
                            (doc, index, arr) => 
                            <Document 
                                name={
                                    id.toUpperCase()!="ATAS"
                                    ?
                                    id.toUpperCase() + ' ' + doc.mandato
                                    :
                                    "ATA" + ' ' + (arr.length - index) + ' '
                                }
                                description={validCategories[id.toUpperCase()]['singular'] + ' de ' + doc.mandato}
                                link={process.env.REACT_APP_UPLOADS_UNLOCK + doc.file}
                                blank={true}
                            />
                        )
                    }
                </Row>
            }
        </div>
    );
}

export default RGM;