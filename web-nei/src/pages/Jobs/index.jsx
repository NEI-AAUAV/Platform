// src/pages/Jobs/index.jsx
import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import Typist from "react-typist";
import { Spinner } from "react-bootstrap";
import { motion, AnimatePresence } from "framer-motion";
import { useUserStore } from "stores/useUserStore";

import PageNav from "../../components/PageNav";
import JobDetailsModal from "./JobDetailsModal";
// TODO import api service

export function Component() {
    const { scopes } = useUserStore((state) => state);

    const [isLoading, setIsLoading] = useState(true);
    const [jobs, setJobs] = useState([]);
    const [currPage, setCurrPage] = useState(1);
    const [totalPages, setTotalPages] = useState(1);

    const [selectedJob, setSelectedJob] = useState(null);

    const canManageJobs = scopes?.includes("admin") || scopes?.includes("manager-jobs");

    const fetchPage = (p_num) => {
        setIsLoading(true);

        // dummy data for now -> api call goes here later on
        setTimeout(() => {
            setJobs([
                {
                    id: 1,
                    title: "Engenheiro de Software Junior",
                    company: "Tech Corp",
                    location: "Aveiro (Híbrido)",
                    description: "Procuramos um recém-graduado motivado para se juntar à nossa equipa de desenvolvimento backend. Experiência com Python e APIs REST é valorizada.",
                    expirationDate: "2026-05-30"
                },
                {
                    id: 2,
                    title: "Estágio de Verão - Frontend",
                    company: "WebSolutions",
                    location: "Remoto",
                    description: "Estágio remunerado de 3 meses focado no desenvolvimento de interfaces interativas utilizando React, Tailwind CSS e Zustand.",
                    expirationDate: "2026-06-15"
                }
            ]);
            setCurrPage(p_num);
            setTotalPages(1);
            setIsLoading(false);
        }, 800);
    };

    useEffect(() => {
        fetchPage(1);
    }, []);

    return (
        <div className="container mx-auto px-4 py-8 max-w-6xl">
            <div className="flex flex-col md:flex-row justify-between items-center mb-10 gap-4">
                <h2 className="text-3xl font-bold m-0 text-center md:text-left">
                    <Typist>Ofertas de Emprego</Typist>
                </h2>

                {canManageJobs && (
                    <Link to="/jobs/new" className="btn btn-primary shadow-md">
                        + Publicar Oferta
                    </Link>
                )}
            </div>

            {isLoading ? (
                <div className="flex justify-center my-20">
                    <Spinner animation="grow" variant="primary" title="A carregar..." />
                </div>
            ) : jobs.length === 0 ? (
                <div className="text-center py-20 bg-base-200 rounded-xl shadow-inner">
                    <p className="text-lg opacity-70">Não há ofertas disponíveis neste momento.</p>
                </div>
            ) : (
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                    {jobs.map((job) => (
                        <div key={job.id} className="card bg-base-200 shadow-xl hover:-translate-y-1 transition-transform duration-200 border border-base-300">
                            <div className="card-body">
                                <h3 className="card-title text-xl mb-0">{job.title}</h3>
                                <h4 className="text-md opacity-80 flex items-center gap-2 font-semibold">
                                    {job.company} <span className="opacity-50 font-normal text-sm">• {job.location}</span>
                                </h4>
                                <p className="py-4 opacity-80 line-clamp-3 leading-relaxed">
                                    {job.description}
                                </p>
                                <div className="card-actions justify-between items-end mt-2 pt-4 border-t border-base-300">
                                    <span className="text-sm opacity-60 font-medium">
                                        Expira a: {new Date(job.expirationDate).toLocaleDateString("pt-PT")}
                                    </span>

                                    {canManageJobs && (
                                        <Link
                                            to={`/jobs/edit/${job.id}`}
                                            className="btn btn-warning btn-sm btn-outline"
                                        >
                                            Editar
                                        </Link>
                                    )}

                                    <button
                                        className="btn btn-secondary btn-sm"
                                        onClick={() => setSelectedJob(job)}
                                    >
                                        Ver Detalhes
                                    </button>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            )}

            {totalPages > 1 && (
                <div className="flex justify-center mt-8">
                    <PageNav
                        currentPage={currPage}
                        numPages={totalPages}
                        handler={fetchPage}
                    />
                </div>
            )}

            <AnimatePresence>
                {selectedJob && (
                    <JobDetailsModal
                        key={selectedJob.id}
                        job={selectedJob}
                        close={() => setSelectedJob(null)}
                    />
                )}
            </AnimatePresence>

        </div>
    );
};