import React, { useState, useEffect, useMemo } from "react";
import { useParams } from "react-router-dom";
import {
    Row, Spinner
} from "react-bootstrap";
import Document from "../../Components/Document";
import Tabs from "../../Components/Tabs";
import Typist from "react-typist";

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

// Animation
const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
const animationIncrement = parseFloat(process.env.REACT_APP_ANIMATION_INCREMENT);


/**
 * This component renders RGM page for a given document category
 * The category is passed on the URL (/rgm/<category>) and the valid options are summed up on variable validCategories
 */

const RGM = () => {
    // Document category is passed as parameter in URL
    let { id } = useParams();

    // Component state
    const [title, setTitle] = useState();
    const [docs, setDocs] = useState([]);
    const [tab, setTab] = useState(0);
    const [loading, setLoading] = useState(true);

    // On component render...
    useEffect(() => {
        setLoading(true);
        setDocs([]);
        
        // Validate document category
        if (Object.keys(validCategories).findIndex(item => id.toLowerCase() === item.toLowerCase()) < 0) {
            window.location.href = "/404";
        }
        id = id.toUpperCase();
        setTitle(validCategories[id]['plural']);
        // Fetch API if valid
        fetch(process.env.REACT_APP_API + "/rgm/?category=" + id)
            .then(res => res.json())
            .then(json => {
                if ('data' in json) {
                    setDocs(json['data']);
                    // Set tab to maximum year
                    json['data'].forEach(doc => setTab(oldTab => oldTab < doc['mandato'] ? doc['mandato'] : oldTab));
                } else {
                    window.location.href = "/404";
                }
                setLoading(false);
            }).catch((error) => {
                window.location.href = "/404";
            });
    }, [id]);

    const changeTab = (t) => {
        // Change tab and simulate loading from API
        setLoading(true);
        setTab(t);
        setTimeout(function () {
            setLoading(false);
        }, 300);
    }

    return (
        <div className="d-flex flex-column flex-wrap">
            <div style={{ whiteSpace: 'pre', overflowWrap: 'break-word' }}>
                <h2 className="text-center mb-5">
                    {docs.length > 0 && <Typist>{title}</Typist>}
                </h2>
            </div>
            {
                // Only show tabs to ATAS category
                id.toUpperCase() == "ATAS" &&
                <Tabs
                    tabs={[...new Set(docs.map(doc => doc.mandato))]}
                    _default={tab}
                    onChange={changeTab}
                />
            }
            {
                loading &&
                <Spinner animation="grow" variant="primary" className="mx-auto mb-3" title="A carregar..." />
            }
            {
                !loading &&
                <Row>
                    {
                        // On ATAS category, show only those which mandato match tab
                        docs.filter(doc => id.toUpperCase() != "ATAS" || doc.mandato == tab).map(
                            (doc, index, arr) =>
                                <div key={index}>
                                    <Document
                                        name={
                                            id.toUpperCase() != "ATAS"
                                                ?
                                                id.toUpperCase() + ' ' + doc.mandato
                                                :
                                                "ATA" + ' ' + (arr.length - index) + ' '
                                        }
                                        description={validCategories[id.toUpperCase()]['singular'] + ' de ' + doc.mandato}
                                        link={process.env.REACT_APP_STATIC + doc.file}
                                        blank={true}
                                        className="col-lg-6 col-xl-3 slideUpFade"
                                        style={{
                                            animationDelay: animationBase + animationIncrement * index + "s",
                                        }}
                                    />
                                </div>
                        )
                    }
                </Row>
            }
        </div>
    );
}

export default RGM;