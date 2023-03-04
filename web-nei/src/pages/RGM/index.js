import React, { useState, useEffect, useMemo } from "react";
import { useParams } from "react-router-dom";
import {
    Row, Spinner
} from "react-bootstrap";
import Document from "../../components/Document";

import YearTabs from "components/YearTabs";
import Box from '@mui/material/Box';
import Typist from "react-typist";

import service from 'services/NEIService';


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
        service.getRGM(id)
            .then((data) => {
                setDocs(data);
                // Set tab to maximum year
                data.forEach(doc => setTab(oldTab => oldTab < doc['mandate'] ? doc['mandate'] : oldTab));
                setLoading(false);
            }).catch(() => {
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
                id.toUpperCase() === "ATAS" &&
                <Box sx={{ maxWidth: { xs: "100%", md: "700px" }, margin: "auto", marginBottom: "50px" }}>
                    <YearTabs
                        years={[...new Set(docs.map(doc => doc.mandate))].sort((a, b) => b - a)}
                        value={tab}
                        onChange={changeTab}
                    />
                </Box>
            }
            {
                !!loading &&
                <Spinner animation="grow" variant="primary" className="mx-auto mb-3" title="A carregar..." />
            }
            {
                !loading &&
                <Row>
                    {
                        // On ATAS category, show only those which mandate match tab
                        docs.sort((a, b) => a.file.includes('2022-23') ? -1 : b.mandate - a.mandate)
                        .filter(doc => id.toUpperCase() != "ATAS" || doc.mandate == tab).map(
                            (doc, index, arr) =>
                                <div key={index}>
                                    <Document
                                        name={
                                            id.toUpperCase() === "ATAS"
                                                ?
                                                "ATA" + ' ' + (arr.length - index) + ' '
                                                :
                                                id.toUpperCase() === "PAO"
                                                ?
                                                doc.file?.split("/").pop().replace("_", " ").replace(".pdf", "").replace("20", " 20")
                                                :
                                                id.toUpperCase() + ' ' + doc.mandate
                                        }
                                        description={validCategories[id.toUpperCase()]['singular'] + ' de ' + doc.mandate}
                                        link={doc.file}
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