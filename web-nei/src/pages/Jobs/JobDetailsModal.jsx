import React from "react";
import { CloseIcon, OpenInNewIcon } from "assets/icons/google";

const JobDetailsModal = ({ job, close }) => {
    if (!job) return null;

    return (
        <div
            className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 transition-opacity"
            onClick={close}
        >
            <div
                className="modal-box relative max-w-3xl w-full bg-base-100 shadow-2xl p-0 overflow-hidden"
                onClick={(e) => e.stopPropagation()}
            >
                <div className="bg-base-200 p-6 border-b border-base-300">
                    <button
                        className="btn btn-sm btn-circle btn-ghost absolute right-4 top-4"
                        onClick={close}
                    >
                        <CloseIcon />
                    </button>

                    <h2 className="text-2xl font-bold mb-2 pr-8">{job.title}</h2>
                    <div className="flex flex-wrap items-center gap-3">
                        <span className="badge badge-primary font-semibold">{job.company}</span>
                        <span className="text-sm opacity-70 font-medium">{job.location}</span>
                    </div>
                </div>

                <div className="p-6">
                    <h3 className="text-lg font-semibold mb-3">Descrição da Oferta</h3>
                    <div className="prose max-w-none opacity-80 leading-relaxed whitespace-pre-wrap">
                        {job.description}
                    </div>

                    <div className="mt-8 flex flex-col sm:flex-row items-center justify-between gap-4 border-t border-base-300 pt-6">
                        <div className="text-sm">
                            <span className="opacity-60">Data limite de candidatura: </span>
                            <span className="font-semibold">{new Date(job.expirationDate).toLocaleDateString("pt-PT")}</span>
                        </div>

                        <a
                            href={job.applicationUrl || "#"}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="btn btn-primary w-full sm:w-auto gap-2"
                        >
                            Candidatar-me <OpenInNewIcon className="w-5 h-5" />
                        </a>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default JobDetailsModal;