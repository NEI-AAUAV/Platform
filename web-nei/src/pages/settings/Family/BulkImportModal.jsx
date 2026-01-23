/**
 * BulkImportModal - Modal for importing multiple members via CSV
 * 
 * Features:
 * - CSV template download with column selection
 * - Instructions visible in UI
 * - Patrao search by name, nmec, ID
 * - File upload with drag-and-drop
 * - Preview table with inline editing
 * - Add rows manually in browser
 * - Patrao picker for ambiguous names
 * - Post-import insignia assignment (individual)
 */

import React, { useState, useEffect, useRef, useCallback, useMemo } from "react";
import PropTypes from "prop-types";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";

import MaterialSymbol from "components/MaterialSymbol";
import FamilyService from "services/FamilyService";
import RolePickerModal from "components/RolePickerModal";
import Papa from "papaparse";
import * as XLSX from "xlsx";
import { colors } from "pages/Family/data";

import Avatar from "components/Avatar";

// CSV Headers
const REQUIRED_HEADERS = ["name", "sex", "start_year"];
const OPTIONAL_HEADERS = [
    { key: "nmec", label: "Nmec", description: "Numero mecanografico" },
    { key: "faina_name", label: "Nome de Faina", description: "Apelido ou alcunha" },
    { key: "patrao", label: "Patrao", description: "Nome, nmec ou ID do patrao" },
];

// Create empty row for manual entry
const createEmptyRow = (idx = 0) => ({
    name: "",
    sex: "M",
    start_year: new Date().getFullYear() - 2000,
    nmec: null,
    faina_name: "",
    patrao_id: null,
    patrao_input: "",
    patrao_resolved: true,
    patrao_user: null,
    _rowIndex: idx,
    _key: `manual-${Date.now()}-${idx}`,
    _isNew: true,
});

const BulkImportModal = ({
    isOpen,
    onClose,
    onComplete,
    allUsers = [],
}) => {
    // Steps: "upload" | "preview" | "assign" | "results"
    const [step, setStep] = useState("upload");
    const [file, setFile] = useState(null);
    const [parsedData, setParsedData] = useState([]);
    const [errors, setErrors] = useState([]);
    const [warnings, setWarnings] = useState([]);
    const [loading, setLoading] = useState(false);
    const [results, setResults] = useState(null);
    // Removed dry run and atomic mode - import always executes directly
    const [dragActive, setDragActive] = useState(false);

    // Patrao search
    const [patraoSearch, setPatraoSearch] = useState("");

    // Editing state
    const [editingCell, setEditingCell] = useState(null);
    const [editValue, setEditValue] = useState("");

    // Patrao picker
    const [patraoPickerRow, setPatraoPickerRow] = useState(null);

    // Individual role assignment - now supports multiple roles per user
    const [showRolePicker, setShowRolePicker] = useState(false);
    const [rolePickerUserIdx, setRolePickerUserIdx] = useState(null);
    const [userRoles, setUserRoles] = useState({}); // { userIdx: [{ role, year }, ...] }
    const [assigningRoles, setAssigningRoles] = useState(false);

    // Template column selection
    const [templateColumns, setTemplateColumns] = useState({
        nmec: true,
        faina_name: false,
        patrao: true,
    });

    const fileInputRef = useRef(null);

    // Create lookup map for patrao resolution
    const userMap = useMemo(() => {
        const map = { byId: {}, byName: {}, byNmec: {} };
        allUsers.forEach(u => {
            if (u._id) map.byId[u._id] = u;
            const nameLower = (u.name || "").toLowerCase().trim();
            if (nameLower) {
                if (!map.byName[nameLower]) map.byName[nameLower] = [];
                map.byName[nameLower].push(u);
            }
            if (u.nmec) map.byNmec[u.nmec] = u;
        });
        return map;
    }, [allUsers]);

    // Enhanced patrao search - by name, nmec, or ID
    const patraoSearchResults = useMemo(() => {
        if (!patraoSearch.trim()) return allUsers.slice(0, 8);
        const query = patraoSearch.toLowerCase().trim();
        const queryNum = parseInt(query);

        return allUsers
            .filter(u => {
                if (u.name?.toLowerCase().includes(query)) return true;
                if (u.faina_name?.toLowerCase().includes(query)) return true;
                if (!isNaN(queryNum) && u.nmec?.toString().includes(query)) return true;
                if (!isNaN(queryNum) && u._id === queryNum) return true;
                return false;
            })
            .slice(0, 12);
    }, [patraoSearch, allUsers]);

    // Reset state when opening
    useEffect(() => {
        if (isOpen) {
            setStep("upload");
            setFile(null);
            setParsedData([]);
            setErrors([]);
            setLoading(false);
            setResults(null);
            setPatraoSearch("");
            setEditingCell(null);
            setUserRoles({});
            setTemplateColumns({ nmec: true, faina_name: false, patrao: true });
            setWarnings([]);
        }
    }, [isOpen]);

    // Lock body scroll
    useEffect(() => {
        if (isOpen) {
            const scrollY = window.scrollY;
            document.body.style.position = 'fixed';
            document.body.style.top = `-${scrollY}px`;
            document.body.style.left = '0';
            document.body.style.right = '0';
            document.body.style.overflow = 'hidden';
            return () => {
                document.body.style.position = '';
                document.body.style.top = '';
                document.body.style.left = '';
                document.body.style.right = '';
                document.body.style.overflow = '';
                window.scrollTo(0, scrollY);
            };
        }
    }, [isOpen]);

    // Resolve patrao from name, nmec, or ID
    const resolvePatrao = useCallback((value) => {
        if (!value) return { id: null, resolved: true, user: null };

        const trimmed = value.toString().trim();
        if (!trimmed) return { id: null, resolved: true, user: null };

        // DEBUG: Log resolution attempt
        console.log(`[resolvePatrao] Trying to resolve: "${trimmed}"`);
        console.log(`[resolvePatrao] allUsers count: ${allUsers.length}`);
        console.log(`[resolvePatrao] userMap.byName keys sample:`, Object.keys(userMap.byName).slice(0, 10));

        // Try as nmec or ID first
        const asNum = parseInt(trimmed);
        if (!isNaN(asNum)) {
            if (userMap.byNmec[asNum]) {
                console.log(`[resolvePatrao] Found by nmec: ${asNum}`);
                return { id: userMap.byNmec[asNum]._id, resolved: true, user: userMap.byNmec[asNum] };
            }
            if (userMap.byId[asNum]) {
                console.log(`[resolvePatrao] Found by ID: ${asNum}`);
                return { id: asNum, resolved: true, user: userMap.byId[asNum] };
            }
        }

        // Try exact name match
        const nameLower = trimmed.toLowerCase();
        const matches = userMap.byName[nameLower];
        console.log(`[resolvePatrao] Exact name match for "${nameLower}":`, matches);
        if (matches?.length === 1) {
            console.log(`[resolvePatrao] Found exact name match: ${matches[0].name}`);
            return { id: matches[0]._id, resolved: true, user: matches[0] };
        } else if (matches?.length > 1) {
            console.log(`[resolvePatrao] Ambiguous: ${matches.length} matches`);
            return { id: null, resolved: false, ambiguous: true, matches };
        }

        // Partial match
        const partial = allUsers.filter(u => u.name?.toLowerCase().includes(nameLower));
        console.log(`[resolvePatrao] Partial matches for "${nameLower}":`, partial.length);
        if (partial.length === 1) {
            console.log(`[resolvePatrao] Found partial match: ${partial[0].name}`);
            return { id: partial[0]._id, resolved: true, user: partial[0] };
        } else if (partial.length > 1) {
            console.log(`[resolvePatrao] Ambiguous partial: ${partial.length} matches`);
            return { id: null, resolved: false, ambiguous: true, matches: partial.slice(0, 5) };
        }

        console.log(`[resolvePatrao] NOT FOUND: "${trimmed}"`);
        return { id: null, resolved: false, notFound: true };
    }, [userMap, allUsers]);

    // Download CSV template with UTF-8 BOM
    const handleDownloadTemplate = () => {
        const BOM = "\uFEFF";
        const headers = [...REQUIRED_HEADERS];
        OPTIONAL_HEADERS.forEach(h => {
            if (templateColumns[h.key]) headers.push(h.key);
        });

        const exampleRow = {
            name: "Joao Silva",
            sex: "M",
            start_year: "24",
            nmec: "12345",
            faina_name: "Silva",
            patrao: "Maria Costa",
        };

        const exampleData = headers.map(h => exampleRow[h] || "").join(",");
        const csvContent = BOM + headers.join(",") + "\n" + exampleData;

        const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8" });
        const link = document.createElement("a");
        link.href = URL.createObjectURL(blob);
        link.download = "template_membros.csv";
        link.click();
        URL.revokeObjectURL(link.href);
    };

    // Process parsed rows (common for CSV and Excel)
    const processParsedData = useCallback((rawRows) => {
        if (!rawRows || rawRows.length === 0) {
            return { data: [], errors: [{ row: 0, message: "Ficheiro vazio" }] };
        }

        // Normalize headers (keys) to handle case sensitivity
        // Check missing headers
        const firstRow = rawRows[0];
        const headers = Object.keys(firstRow).map(h => h.trim().toLowerCase());
        const requiredHeaders = ["name", "sex", "start_year"];
        const missingHeaders = requiredHeaders.filter(h => !headers.includes(h));

        if (missingHeaders.length > 0) {
            return { data: [], errors: [{ row: 0, message: `Colunas obrigatorias em falta: ${missingHeaders.join(", ")}` }] };
        }

        const data = [];
        const parseErrors = [];
        const seenNames = new Set();
        const localWarnings = [];

        rawRows.forEach((raw, i) => {
            // Normalize row keys
            const row = {};
            Object.keys(raw).forEach(k => {
                row[k.trim().toLowerCase()] = (raw[k] || "").toString().trim();
            });

            // Skip empty rows
            if (!row.name && !row.sex && !row.start_year) return;

            // Existing validation
            const rowErrors = [];
            if (!row.name) rowErrors.push("nome em falta");
            if (!row.sex || !["M", "F"].includes(row.sex.toUpperCase())) rowErrors.push("sexo invalido (M/F)");
            if (!row.start_year || isNaN(parseInt(row.start_year))) rowErrors.push("ano invalido");

            // Check duplicate names (frontend side)
            const nameLower = (row.name || "").toLowerCase();
            if (nameLower) {
                if (seenNames.has(nameLower)) {
                    localWarnings.push(`Linha ${i + 1}: Nome duplicado "${row.name}"`);
                }
                seenNames.add(nameLower);
            }

            const patraoValue = row.patrao || row.patrao_id || row.patrao_name || "";
            const patraoResult = resolvePatrao(patraoValue);

            const parsed = {
                name: row.name || "",
                sex: (row.sex || "").toUpperCase(),
                start_year: parseInt(row.start_year) || 0,
                nmec: row.nmec ? parseInt(row.nmec) : null,
                faina_name: row.faina_name || null,
                patrao_id: patraoResult.id,
                patrao_input: patraoValue,
                patrao_resolved: patraoResult.resolved,
                patrao_user: patraoResult.user,
                patrao_ambiguous: patraoResult.ambiguous,
                patrao_matches: patraoResult.matches,
                course_id: row.course_id ? parseInt(row.course_id) : null,
                _rowIndex: i,
                _key: `row-${i}-${Date.now()}`,
            };

            if (rowErrors.length > 0) {
                parseErrors.push({ row: i, message: rowErrors.join(", "), data: parsed });
            }

            data.push(parsed);
        });

        // Update warnings state
        if (localWarnings.length > 0) {
            setWarnings(prev => [...prev, ...localWarnings]);
        }

        return { data, errors: parseErrors };

    }, [resolvePatrao]);

    // Handle file processing (CSV or Excel)
    const processFile = (selectedFile) => {
        setFile(selectedFile);
        setWarnings([]); // Clear warnings

        const isExcel = selectedFile.name.endsWith(".xlsx") || selectedFile.name.endsWith(".xls");

        if (isExcel) {
            const reader = new FileReader();
            reader.onload = (e) => {
                const data = new Uint8Array(e.target.result);
                const workbook = XLSX.read(data, { type: "array" });
                const firstSheet = workbook.Sheets[workbook.SheetNames[0]];
                const jsonData = XLSX.utils.sheet_to_json(firstSheet, { defval: "" });

                const { data: parsed, errors: parseErrors } = processParsedData(jsonData);
                setParsedData(parsed);
                setErrors(parseErrors);
                if (parsed.length > 0) setStep("preview");
            };
            reader.readAsArrayBuffer(selectedFile);
        } else {
            // Assume CSV
            Papa.parse(selectedFile, {
                header: true,
                skipEmptyLines: true,
                complete: (results) => {
                    const { data: parsed, errors: parseErrors } = processParsedData(results.data);
                    setParsedData(parsed);
                    setErrors(parseErrors);
                    if (parsed.length > 0) setStep("preview");
                },
                error: (err) => {
                    setErrors([{ row: 0, message: "Erro ao ler CSV: " + err.message }]);
                }
            });
        }
    };

    // Handle file selection
    const handleFileChange = (e) => {
        const selectedFile = e.target.files?.[0];
        if (selectedFile) {
            processFile(selectedFile);
        }
    };

    // Drag and drop
    const handleDrag = (e) => {
        e.preventDefault();
        e.stopPropagation();
        setDragActive(e.type === "dragenter" || e.type === "dragover");
    };

    const handleDrop = (e) => {
        e.preventDefault();
        e.stopPropagation();
        setDragActive(false);
        const droppedFile = e.dataTransfer.files?.[0];
        if (droppedFile && (droppedFile.name.endsWith(".csv") || droppedFile.name.endsWith(".xls") || droppedFile.name.endsWith(".xlsx"))) {
            processFile(droppedFile);
        }
    };

    // Remove row
    const handleRemoveRow = (index) => {
        setParsedData(prev => prev.filter((_, i) => i !== index));
        setErrors(prev => prev.filter(e => e.row !== parsedData[index]?._rowIndex));
    };

    // Add new row manually
    const handleAddRow = () => {
        setParsedData(prev => [...prev, createEmptyRow(prev.length)]);
    };

    // Start manual entry (go to preview with empty row)
    const handleStartManualEntry = () => {
        setParsedData([createEmptyRow(0)]);
        setStep("preview");
    };

    // Update row field
    const updateRowField = (idx, field, value) => {
        setParsedData(prev => {
            const updated = [...prev];
            const row = { ...updated[idx] };

            if (field === "patrao") {
                const result = resolvePatrao(value);
                row.patrao_id = result.id;
                row.patrao_input = value;
                row.patrao_resolved = result.resolved;
                row.patrao_user = result.user;
                row.patrao_ambiguous = result.ambiguous;
                row.patrao_matches = result.matches;
            } else if (field === "start_year" || field === "nmec") {
                row[field] = value ? parseInt(value) : null;
            } else if (field === "sex") {
                row[field] = value.toUpperCase();
            } else {
                row[field] = value;
            }

            updated[idx] = row;
            return updated;
        });
    };

    // Start editing a cell
    const startEdit = (rowIdx, field, currentValue) => {
        setEditingCell({ rowIdx, field });
        setEditValue(currentValue || "");
    };

    // Save cell edit
    const saveEdit = () => {
        if (!editingCell) return;
        updateRowField(editingCell.rowIdx, editingCell.field, editValue);
        setEditingCell(null);
        setEditValue("");
    };

    // Set patrao from picker
    const setPatrao = (rowIdx, user) => {
        setParsedData(prev => {
            const updated = [...prev];
            const row = { ...updated[rowIdx] };
            row.patrao_id = user?._id || null;
            row.patrao_input = user?.name || "";
            row.patrao_resolved = true;
            row.patrao_user = user || null;
            row.patrao_ambiguous = false;
            row.patrao_matches = null;
            updated[rowIdx] = row;
            return updated;
        });
        setPatraoPickerRow(null);
        setPatraoSearch("");
    };

    // Check row validity
    const getRowError = (rowIdx) => {
        const row = parsedData[rowIdx];
        if (!row) return null;

        // Check if required fields are filled
        if (!row.name?.trim()) return { message: "nome em falta" };
        if (!["M", "F"].includes(row.sex)) return { message: "sexo invalido" };
        if (!row.start_year || row.start_year < 0 || row.start_year > 99) return { message: "ano invalido" };

        // Check unresolved patrao
        if (row.patrao_input && !row.patrao_resolved) {
            return { message: row.patrao_ambiguous ? "Patrao ambiguo" : "Patrao nao encontrado" };
        }

        // Check base errors from parsing
        const baseError = errors.find(e => e.row === row._rowIndex);
        if (baseError) return baseError;

        return null;
    };

    // Submit to backend
    const handleSubmit = async () => {
        const validRows = parsedData.filter((_, i) => !getRowError(i));
        if (validRows.length === 0) return;

        setLoading(true);
        try {
            const usersToCreate = validRows.map(r => ({
                name: r.name,
                sex: r.sex,
                start_year: r.start_year,
                nmec: r.nmec,
                faina_name: r.faina_name || null,
                patrao_id: r.patrao_id,
                course_id: r.course_id,
            }));

            const response = await FamilyService.bulkCreateUsers(usersToCreate);
            setResults(response);

            // Add backend warnings to state
            if (response.warnings && response.warnings.length > 0) {
                setWarnings(prev => [...prev, ...response.warnings]);
            }

            if (response.total_created > 0) {
                setStep("assign");
            } else {
                setStep("results");
            }

            onComplete?.();
        } catch (err) {
            console.error("Bulk import failed:", err);
            setResults({
                created: [],
                errors: [{ row: 0, message: err.response?.data?.detail || "Erro ao importar" }],
                total_submitted: validRows.length,
                total_created: 0,
                total_errors: validRows.length,
            });
            setStep("results");
        } finally {
            setLoading(false);
        }
    };

    // Assign individual roles (supports multiple per user)
    const handleAssignRoles = async () => {
        if (!results?.created?.length) return;

        setAssigningRoles(true);
        let successCount = 0;

        try {
            for (let i = 0; i < results.created.length; i++) {
                const user = results.created[i];
                const roles = userRoles[i] || [];

                for (const roleInfo of roles) {
                    if (roleInfo?.role) {
                        try {
                            await FamilyService.assignRole({
                                user_id: user._id,
                                role_id: roleInfo.role._id,
                                year: roleInfo.year || new Date().getFullYear() - 2000
                            });
                            successCount++;
                        } catch (err) {
                            console.error(`Failed to assign role ${roleInfo.role.name} to ${user.name}`, err);
                        }
                    }
                }
            }
            setResults(prev => ({ ...prev, rolesAssigned: successCount }));
        } finally {
            setAssigningRoles(false);
            setStep("results");
        }
    };

    // Add role to user
    const addRoleToUser = (userIdx, role, year) => {
        setUserRoles(prev => {
            const roles = prev[userIdx] || [];
            // Prevent duplicates
            if (roles.some(r => r.role._id === role._id)) return prev;
            return { ...prev, [userIdx]: [...roles, { role, year }] };
        });
    };

    // Remove role from user  
    const removeRoleFromUser = (userIdx, roleIdx) => {
        setUserRoles(prev => {
            const roles = prev[userIdx] || [];
            return { ...prev, [userIdx]: roles.filter((_, i) => i !== roleIdx) };
        });
    };

    // Total roles selected
    const totalRolesSelected = Object.values(userRoles).reduce((sum, roles) => sum + (roles?.length || 0), 0);

    const validRows = parsedData.filter((_, i) => !getRowError(i));
    const invalidRows = parsedData.filter((_, i) => getRowError(i));

    // Render upload step
    const renderUploadStep = () => (
        <div className="space-y-8">
            <div className="text-center">
                <h4 className="text-lg font-semibold mb-2">Importação de Membros</h4>
                <p className="text-base-content/60">Utiliza as ferramentas de apoio antes de carregar os dados</p>
            </div>

            {/* Tools section - Template and Search - NOW FIRST */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Template download */}
                <div className="rounded-xl border border-base-content/10 p-5 bg-base-100">
                    <div className="flex items-start gap-4">
                        <div className="w-12 h-12 rounded-xl bg-primary/10 text-primary flex items-center justify-center shrink-0">
                            <MaterialSymbol icon="description" size={24} />
                        </div>
                        <div className="flex-1 min-w-0">
                            <h5 className="font-semibold mb-1">Passo 1: Obter Modelo CSV</h5>
                            <p className="text-sm text-base-content/60 mb-4">
                                Descarrega o modelo oficial para preencher no Excel/Sheets.
                            </p>

                            {/* Instructions */}
                            <div className="bg-base-200/50 rounded-lg p-3 mb-4 space-y-2 text-sm">
                                <p><strong className="text-primary">Colunas Obrigatórias:</strong><br />name, sex (M/F), start_year (ex: 24)</p>
                                <p><strong className="text-primary">Patrão:</strong><br />Pode usar o Nome, NMEC ou ID interno.</p>
                                <p className="text-xs text-base-content/50 mt-2">Nota: Ao guardar, escolhe formato CSV UTF-8.</p>
                            </div>

                            {/* Column checkboxes */}
                            <div className="mb-4">
                                <p className="text-sm font-medium mb-2">Incluir colunas opcionais:</p>
                                <div className="flex flex-wrap gap-3">
                                    {OPTIONAL_HEADERS.map(h => (
                                        <label key={h.key} className="flex items-center gap-2 cursor-pointer">
                                            <input
                                                type="checkbox"
                                                className="checkbox checkbox-sm checkbox-primary"
                                                checked={templateColumns[h.key]}
                                                onChange={(e) => setTemplateColumns(prev => ({
                                                    ...prev,
                                                    [h.key]: e.target.checked
                                                }))}
                                            />
                                            <span className="text-sm" title={h.description}>{h.label}</span>
                                        </label>
                                    ))}
                                </div>
                            </div>

                            <button
                                type="button"
                                className="btn btn-primary btn-sm gap-2 w-full"
                                onClick={handleDownloadTemplate}
                            >
                                <MaterialSymbol icon="download" size={18} />
                                Descarregar Modelo
                            </button>
                        </div>
                    </div>
                </div>

                {/* Patrao search */}
                <div className="rounded-xl border border-base-content/10 p-5 bg-base-100">
                    <div className="flex items-start gap-4">
                        <div className="w-12 h-12 rounded-xl bg-secondary/10 text-secondary flex items-center justify-center shrink-0">
                            <MaterialSymbol icon="person_search" size={24} />
                        </div>
                        <div className="flex-1 min-w-0">
                            <h5 className="font-semibold mb-1">Ajuda: Encontrar Patrão</h5>
                            <p className="text-sm text-base-content/60 mb-4">
                                Pesquisa aqui para saberes exatamente que ID ou NMEC colocar no Excel.
                            </p>

                            <input
                                type="text"
                                placeholder="Pesquisar por nome ou nmec..."
                                className="input input-bordered w-full mb-3"
                                value={patraoSearch}
                                onChange={(e) => setPatraoSearch(e.target.value)}
                            />

                            {patraoSearch && patraoSearchResults.length > 0 && (
                                <div className="max-h-64 overflow-y-auto space-y-2 pr-1 custom-scrollbar">
                                    {patraoSearchResults.map(u => (
                                        <div key={u._id} className="flex items-center gap-3 bg-base-200/50 rounded-xl px-3 py-2 text-sm">
                                            <div
                                                className="w-8 h-8 rounded-full overflow-hidden border-2 shrink-0"
                                                style={{ borderColor: colors[u.start_year % colors.length] }}
                                            >
                                                <Avatar
                                                    src={u.image}
                                                    sex={u.sex}
                                                    alt={u.name || ''}
                                                    className="w-full h-full object-cover"
                                                    size={32}
                                                />
                                            </div>
                                            <div className="flex-1 min-w-0">
                                                <p className="font-medium truncate">{u.name}</p>
                                                <p className="text-xs text-base-content/50">
                                                    #{u.nmec || '?'} · Ano {u.start_year}
                                                </p>
                                            </div>
                                            <div className="flex flex-col items-end gap-1">
                                                <button
                                                    className="badge badge-primary badge-outline font-mono font-bold hover:bg-primary hover:text-primary-content cursor-pointer transition-colors"
                                                    onClick={() => {
                                                        navigator.clipboard.writeText(u._id);
                                                        // Optional: show toast
                                                    }}
                                                    title="Copiar ID"
                                                >
                                                    ID: {u._id}
                                                </button>
                                                {u.nmec && (
                                                    <span className="text-[10px] text-base-content/40 font-mono">
                                                        NMEC: {u.nmec}
                                                    </span>
                                                )}
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            )}

                            {patraoSearch && patraoSearchResults.length === 0 && (
                                <p className="text-sm text-base-content/50 text-center py-4 bg-base-200/30 rounded-lg">
                                    Nenhum membro encontrado com esse nome.
                                </p>
                            )}

                            {!patraoSearch && (
                                <div className="text-center py-8 opacity-30">
                                    <MaterialSymbol icon="search" size={48} className="mx-auto mb-2" />
                                    <p className="text-xs">Os resultados aparecerão aqui</p>
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            </div>

            {/* Divider */}
            <div className="flex items-center gap-4">
                <div className="flex-1 h-px bg-base-content/10" />
                <span className="text-sm text-base-content/40 font-medium">Passo 2: Carregar Dados</span>
                <div className="flex-1 h-px bg-base-content/10" />
            </div>

            {/* Two main options */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Upload CSV option */}
                <div
                    className={classNames(
                        "relative rounded-2xl p-6 transition-all cursor-pointer group",
                        "border-2 hover:border-primary hover:shadow-lg",
                        dragActive ? "border-primary bg-primary/10 shadow-lg" : "border-base-content/10 bg-base-200/30"
                    )}
                    onClick={() => fileInputRef.current?.click()}
                    onDragEnter={handleDrag}
                    onDragLeave={handleDrag}
                    onDragOver={handleDrag}
                    onDrop={handleDrop}
                >
                    <input ref={fileInputRef} type="file" accept=".csv, .xlsx, .xls" className="hidden" onChange={handleFileChange} />

                    <div className="flex flex-col items-center text-center">
                        <div className={classNames(
                            "w-16 h-16 rounded-2xl flex items-center justify-center mb-4 transition-colors",
                            dragActive ? "bg-primary text-primary-content" : "bg-base-200 text-base-content/50 group-hover:bg-primary group-hover:text-primary-content"
                        )}>
                            <MaterialSymbol icon="upload_file" size={32} />
                        </div>
                        <h5 className="font-semibold text-lg mb-1">Carregar Ficheiro</h5>
                        <p className="text-sm text-base-content/60">
                            {dragActive ? "Larga o ficheiro aqui!" : "Tem o ficheiro pronto? Clique para carregar ou arraste-o."}
                        </p>
                        <p className="text-xs text-base-content/40 mt-1">Suporta .csv, .xlsx</p>
                    </div>
                </div>

                {/* Manual entry option */}
                <div
                    className="relative rounded-2xl p-6 border-2 border-base-content/10 bg-base-200/30 hover:border-primary hover:shadow-lg transition-all cursor-pointer group"
                    onClick={handleStartManualEntry}
                >
                    <div className="flex flex-col items-center text-center">
                        <div className="w-16 h-16 rounded-2xl bg-base-200 text-base-content/50 flex items-center justify-center mb-4 group-hover:bg-primary group-hover:text-primary-content transition-colors">
                            <MaterialSymbol icon="edit_note" size={32} />
                        </div>
                        <h5 className="font-semibold text-lg mb-1">Preencher Manualmente</h5>
                        <p className="text-sm text-base-content/60">Não tem ficheiro? Adicione os membros um a um agora.</p>
                    </div>
                </div>
            </div>



            {/* Parse errors */}
            {errors.length > 0 && parsedData.length === 0 && (
                <div className="alert alert-error">
                    <MaterialSymbol icon="error" size={24} />
                    <span className="font-medium">{errors[0]?.message}</span>
                </div>
            )}
        </div>
    );


    // Render preview step (with inline editing)
    const renderPreviewStep = () => (
        <div className="space-y-4">
            {/* Summary */}
            <div className="flex items-center justify-between bg-base-200/50 rounded-lg p-3">
                <div className="flex items-center gap-4">
                    <span className="text-sm">
                        <span className="font-bold text-success">{validRows.length}</span> validos
                    </span>
                    {invalidRows.length > 0 && (
                        <span className="text-sm">
                            <span className="font-bold text-error">{invalidRows.length}</span> a corrigir
                        </span>
                    )}
                </div>
                <button
                    type="button"
                    className="btn btn-ghost btn-xs"
                    onClick={() => {
                        setStep("upload");
                        setFile(null);
                        setParsedData([]);
                        setErrors([]);
                    }}
                >
                    <MaterialSymbol icon="arrow_back" size={16} />
                    Voltar
                </button>
            </div>

            {/* Editable data table */}
            <div className="overflow-x-auto max-h-[40vh] overflow-y-auto border border-base-content/10 rounded-lg">
                <table className="table table-xs w-full">
                    <thead className="bg-base-200 sticky top-0">
                        <tr>
                            <th className="w-8"></th>
                            <th>Nome</th>
                            <th className="w-14">Sexo</th>
                            <th className="w-16">Ano</th>
                            <th className="w-24">Nmec</th>
                            <th className="w-32">Faina</th>
                            <th>Patrao</th>
                            <th className="w-8"></th>
                        </tr>
                    </thead>
                    <tbody>
                        {parsedData.map((row, idx) => {
                            const rowError = getRowError(idx);
                            const isPatraoError = row.patrao_input && !row.patrao_resolved;

                            return (
                                <tr key={row._key} className={classNames("hover", rowError && "bg-error/10")}>
                                    <td>
                                        {rowError ? (
                                            <div className="tooltip tooltip-right" data-tip={rowError.message}>
                                                <MaterialSymbol icon="error" size={16} className="text-error" />
                                            </div>
                                        ) : (
                                            <MaterialSymbol icon="check_circle" size={16} className="text-success" />
                                        )}
                                    </td>

                                    {/* Editable cells */}
                                    <td className="cursor-pointer hover:bg-base-200" onClick={() => startEdit(idx, "name", row.name)}>
                                        {editingCell?.rowIdx === idx && editingCell?.field === "name" ? (
                                            <input type="text" className="input input-xs input-bordered w-full" value={editValue} onChange={(e) => setEditValue(e.target.value)} onBlur={saveEdit} onKeyDown={(e) => e.key === "Enter" && saveEdit()} autoFocus />
                                        ) : (
                                            <span className="truncate max-w-[150px] block">{row.name || <span className="text-base-content/30">Nome</span>}</span>
                                        )}
                                    </td>

                                    <td className="cursor-pointer hover:bg-base-200" onClick={() => startEdit(idx, "sex", row.sex)}>
                                        {editingCell?.rowIdx === idx && editingCell?.field === "sex" ? (
                                            <select className="select select-xs select-bordered" value={editValue} onChange={(e) => setEditValue(e.target.value)} onBlur={saveEdit} autoFocus>
                                                <option value="M">M</option>
                                                <option value="F">F</option>
                                            </select>
                                        ) : row.sex}
                                    </td>

                                    <td className="cursor-pointer hover:bg-base-200" onClick={() => startEdit(idx, "start_year", row.start_year?.toString())}>
                                        {editingCell?.rowIdx === idx && editingCell?.field === "start_year" ? (
                                            <input type="number" className="input input-xs input-bordered w-14" value={editValue} onChange={(e) => setEditValue(e.target.value)} onBlur={saveEdit} onKeyDown={(e) => e.key === "Enter" && saveEdit()} min={0} max={99} autoFocus />
                                        ) : row.start_year}
                                    </td>

                                    <td className="cursor-pointer hover:bg-base-200 font-mono text-xs" onClick={() => startEdit(idx, "nmec", row.nmec?.toString() || "")}>
                                        {editingCell?.rowIdx === idx && editingCell?.field === "nmec" ? (
                                            <input type="number" className="input input-xs input-bordered w-20" value={editValue} onChange={(e) => setEditValue(e.target.value)} onBlur={saveEdit} onKeyDown={(e) => e.key === "Enter" && saveEdit()} autoFocus />
                                        ) : (row.nmec || <span className="text-base-content/30">-</span>)}
                                    </td>

                                    <td className="cursor-pointer hover:bg-base-200" onClick={() => startEdit(idx, "faina_name", row.faina_name || "")}>
                                        {editingCell?.rowIdx === idx && editingCell?.field === "faina_name" ? (
                                            <input type="text" className="input input-xs input-bordered w-full" value={editValue} onChange={(e) => setEditValue(e.target.value)} onBlur={saveEdit} onKeyDown={(e) => e.key === "Enter" && saveEdit()} autoFocus />
                                        ) : (row.faina_name || <span className="text-base-content/30">-</span>)}
                                    </td>

                                    <td className={classNames(isPatraoError && "text-error")}>
                                        <div className="flex items-center gap-1">
                                            {row.patrao_resolved && row.patrao_user ? (
                                                <button type="button" className="flex items-center gap-1 px-2 py-0.5 bg-base-200 rounded-lg text-xs hover:bg-base-300" onClick={() => setPatraoPickerRow(idx)}>
                                                    <div className="w-5 h-5 rounded-full overflow-hidden" style={{ borderColor: colors[row.patrao_user.start_year % colors.length] }}>
                                                        <Avatar
                                                            src={row.patrao_user?.image}
                                                            sex={row.patrao_user?.sex}
                                                            alt={row.patrao_user?.name || ''}
                                                            className="w-full h-full object-cover"
                                                            size={32}
                                                        />
                                                    </div>
                                                    <span className="truncate max-w-[80px]">{row.patrao_user.name}</span>
                                                </button>
                                            ) : row.patrao_input ? (
                                                <button type="button" className="btn btn-xs btn-error btn-outline" onClick={() => setPatraoPickerRow(idx)}>
                                                    Escolher
                                                </button>
                                            ) : (
                                                <button type="button" className="btn btn-xs btn-ghost" onClick={() => setPatraoPickerRow(idx)}>
                                                    <MaterialSymbol icon="person_search" size={14} />
                                                </button>
                                            )}
                                        </div>
                                    </td>

                                    <td>
                                        <button type="button" className="btn btn-ghost btn-xs btn-circle" onClick={() => handleRemoveRow(idx)} title="Remover">
                                            <MaterialSymbol icon="close" size={14} />
                                        </button>
                                    </td>
                                </tr>
                            );
                        })}
                    </tbody>
                </table>
            </div>

            {/* Add row button */}
            <button type="button" className="btn btn-ghost btn-sm gap-2" onClick={handleAddRow}>
                <MaterialSymbol icon="add" size={18} />
                Adicionar linha
            </button>

            <p className="text-xs text-base-content/50 text-center">
                Clica numa celula para editar. Corrige patroes nao resolvidos antes de importar.
            </p>
        </div>
    );

    // Render assign step (individual roles)
    const renderAssignStep = () => (
        <div className="space-y-4">
            <div className="bg-success/10 rounded-xl p-4 text-center">
                <MaterialSymbol icon="check_circle" size={40} className="text-success" />
                <h3 className="font-bold text-lg mt-2">{results?.total_created} membro(s) criado(s)!</h3>
                <p className="text-sm text-base-content/60 mt-1">Atribui insígnias individualmente (opcional)</p>
            </div>

            <div className="max-h-60 overflow-y-auto space-y-2">
                {results?.created?.map((user, idx) => (
                    <div key={user._id} className="flex items-center gap-3 p-3 bg-base-200/50 rounded-xl">
                        <div
                            className="w-10 h-10 rounded-full overflow-hidden border-2"
                            style={{ borderColor: colors[user.start_year % colors.length] }}
                        >
                            <Avatar
                                src={user.image}
                                sex={user.sex}
                                alt={user.name || ''}
                                className="w-full h-full object-cover"
                                size={40}
                            />
                        </div>
                        <div className="flex-1 min-w-0">
                            <p className="font-medium truncate">{user.name}</p>
                            <p className="text-xs text-base-content/50">Ano {user.start_year}</p>

                            {/* Role chips */}
                            <div className="flex flex-wrap gap-1 mt-2">
                                {(userRoles[idx] || []).map((r, rIdx) => (
                                    <span key={rIdx} className="inline-flex items-center gap-1 bg-primary/20 text-primary px-2 py-0.5 rounded-full text-xs">
                                        {r.role.name} ({r.year})
                                        <button
                                            type="button"
                                            className="hover:bg-primary/30 rounded-full p-0.5"
                                            onClick={() => removeRoleFromUser(idx, rIdx)}
                                        >
                                            <MaterialSymbol icon="close" size={12} />
                                        </button>
                                    </span>
                                ))}
                            </div>
                        </div>
                        <button
                            type="button"
                            className="btn btn-sm btn-ghost gap-1"
                            onClick={() => { setRolePickerUserIdx(idx); setShowRolePicker(true); }}
                        >
                            <MaterialSymbol icon="add" size={16} />
                            Insignia
                        </button>
                    </div>
                ))}
            </div>
        </div>
    );

    // Export errors to CSV
    const handleExportErrors = () => {
        if (!results?.errors?.length) return;

        const BOM = "\uFEFF";
        const headers = ["row", "name", "error"];
        const rows = results.errors.map(e => {
            const rowIdx = e.row + 1;
            const name = e.data?.name || `Linha ${rowIdx}`;
            const msg = e.message.replace(/"/g, '""');
            return `${rowIdx},"${name}","${msg}"`;
        });

        const csvContent = BOM + headers.join(",") + "\n" + rows.join("\n");
        const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8" });
        const link = document.createElement("a");
        link.href = URL.createObjectURL(blob);
        link.download = "erros_importacao.csv";
        link.click();
        URL.revokeObjectURL(link.href);
    };

    // Render results step with preview
    const renderResultsStep = () => (
        <div className="space-y-6">
            {/* Summary */}
            <div className={classNames("rounded-xl p-6 text-center border-2",
                results?.total_errors === 0 && warnings.length === 0 ? "bg-success/5 border-success/10" :
                    results?.total_errors === 0 ? "bg-warning/5 border-warning/10" : "bg-error/5 border-error/10"
            )}>
                <div className="flex justify-center mb-3">
                    {results?.total_errors > 0 ? (
                        <MaterialSymbol icon="error" size={48} className="text-error" />
                    ) : warnings.length > 0 ? (
                        <MaterialSymbol icon="warning" size={48} className="text-warning" />
                    ) : (
                        <MaterialSymbol icon="check_circle" size={48} className="text-success" />
                    )}
                </div>

                <h3 className="text-xl font-bold">
                    {results?.total_created > 0 ? "Importação Concluída" : "Importação Falhou"}
                </h3>

                <div className="flex flex-wrap justify-center gap-4 mt-2 text-sm">
                    {results?.total_created > 0 && (
                        <span className="text-success font-medium">
                            Criou {results.total_created} membro(s)
                        </span>
                    )}
                    {warnings.length > 0 && (
                        <span className="text-warning font-medium">
                            {warnings.length} aviso(s)
                        </span>
                    )}
                    {results?.total_errors > 0 && (
                        <span className="text-error font-medium">
                            {results.total_errors} erro(s)
                        </span>
                    )}
                </div>

                {results?.rolesAssigned > 0 && <p className="text-success text-sm mt-1">{results.rolesAssigned} insignia(s) atribuida(s)</p>}
            </div>

            {/* Warnings */}
            {warnings.length > 0 && (
                <div className="collapse collapse-arrow border border-warning/20 bg-warning/5 rounded-xl">
                    <input type="checkbox" />
                    <div className="collapse-title font-medium flex items-center gap-2 text-warning">
                        <MaterialSymbol icon="warning" size={20} />
                        Avisos ({warnings.length})
                    </div>
                    <div className="collapse-content">
                        <div className="max-h-32 overflow-y-auto space-y-1 pr-2">
                            {warnings.map((w, i) => (
                                <div key={i} className="text-sm p-2 rounded bg-warning/10 border border-warning/10">
                                    {w}
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            )}

            {/* Preview - Table view */}
            {results?.created?.length > 0 && (
                <div>
                    <h4 className="font-medium mb-3 flex items-center gap-2">
                        <MaterialSymbol icon="table_rows" size={20} className="text-primary" />
                        Membros Criados
                    </h4>
                    <div className="overflow-x-auto border border-base-content/10 rounded-lg">
                        <table className="table table-sm w-full">
                            <thead className="bg-base-200">
                                <tr>
                                    <th>Nome</th>
                                    <th>Sexo</th>
                                    <th>Ano</th>
                                    <th>Nmec</th>
                                    <th>Patrao</th>
                                    <th>Insignias</th>
                                </tr>
                            </thead>
                            <tbody>
                                {results.created.slice(0, 5).map((user, idx) => {
                                    const patrao = user.patrao_id ? allUsers.find(u => u._id === user.patrao_id) : null;
                                    const roles = userRoles[idx] || [];
                                    return (
                                        <tr key={user._id || idx}>
                                            <td className="font-medium">{user.name}</td>
                                            <td>{user.sex}</td>
                                            <td>{user.start_year}</td>
                                            <td className="font-mono text-xs">{user.nmec || "-"}</td>
                                            <td>{patrao?.name || "-"}</td>
                                            <td>
                                                {roles.length > 0 ? (
                                                    <div className="flex flex-wrap gap-1">
                                                        {roles.map((r, i) => (
                                                            <span key={i} className="badge badge-primary badge-sm">{r.role.name}</span>
                                                        ))}
                                                    </div>
                                                ) : "-"}
                                            </td>
                                        </tr>
                                    );
                                })}
                            </tbody>
                        </table>
                        {results.created.length > 5 && (
                            <p className="text-xs text-center text-base-content/50 py-2">+ {results.created.length - 5} mais...</p>
                        )}
                    </div>
                </div>
            )}



            {/* Errors */}
            {results?.errors?.length > 0 && (
                <div>
                    <div className="flex items-center justify-between mb-2">
                        <h4 className="font-medium text-error flex items-center gap-2">
                            <MaterialSymbol icon="error" size={20} />
                            Erros ({results.errors.length})
                        </h4>
                        <button
                            onClick={handleExportErrors}
                            className="btn btn-xs btn-outline btn-error gap-1"
                        >
                            <MaterialSymbol icon="download" size={14} />
                            Exportar CSV
                        </button>
                    </div>
                    <div className="max-h-32 overflow-y-auto space-y-1 border border-error/20 rounded-lg p-2 bg-error/5">
                        {results.errors.map((err, i) => (
                            <div key={i} className="text-sm p-2 rounded hover:bg-white/50 flex gap-2">
                                <span className="font-mono text-xs font-bold opacity-50 shrink-0">L{err.row + 1}</span>
                                <span>{err.message}</span>
                            </div>
                        ))}
                    </div>
                </div>
            )}
        </div>
    );

    // Patrao picker modal
    const renderPatraoPicker = () => {
        if (patraoPickerRow === null) return null;
        const row = parsedData[patraoPickerRow];
        if (!row) return null;

        const searchResults = patraoSearch ? patraoSearchResults : (row.patrao_matches || allUsers.slice(0, 10));

        return (
            <div className="fixed inset-0 z-[60] flex items-center justify-center p-4">
                <div className="absolute inset-0 bg-black/50" onClick={() => setPatraoPickerRow(null)} />
                <motion.div
                    initial={{ opacity: 0, scale: 0.95 }}
                    animate={{ opacity: 1, scale: 1 }}
                    className="relative bg-base-100 rounded-2xl shadow-2xl w-full max-w-lg overflow-hidden"
                >
                    <div className="p-4 border-b border-base-content/10">
                        <h4 className="font-bold">Escolher Patrão para "{row.name}"</h4>
                        <p className="text-xs text-base-content/60">Pesquisa por nome, nmec ou ID</p>
                    </div>

                    <div className="p-4">
                        <div className="relative">
                            <MaterialSymbol icon="search" size={18} className="absolute left-3 top-1/2 -translate-y-1/2 text-base-content/40" />
                            <input
                                type="text"
                                placeholder="Pesquisar..."
                                className="input input-bordered w-full pl-10"
                                value={patraoSearch}
                                onChange={(e) => setPatraoSearch(e.target.value)}
                                autoFocus
                            />
                        </div>
                    </div>

                    <div className="max-h-64 overflow-y-auto px-4 pb-4 space-y-1">
                        {searchResults.map(u => (
                            <button key={u._id} type="button" className="flex items-center gap-3 w-full p-2 rounded-xl hover:bg-base-200 text-left" onClick={() => setPatrao(patraoPickerRow, u)}>
                                <div className="w-10 h-10 rounded-full overflow-hidden border-2" style={{ borderColor: colors[u.start_year % colors.length] }}>
                                    <Avatar
                                        src={u.image}
                                        sex={u.sex}
                                        alt={u.name || ''}
                                        className="w-full h-full object-cover"
                                        size={32}
                                    />
                                </div>
                                <div className="flex-1 min-w-0">
                                    <p className="font-medium truncate">{u.name}</p>
                                    <p className="text-xs text-base-content/50">{u.nmec && `#${u.nmec} · `}Ano {u.start_year}</p>
                                </div>
                                <span className="text-xs font-mono bg-base-200 px-2 py-1 rounded">ID {u._id}</span>
                            </button>
                        ))}
                        <button type="button" className="flex items-center gap-3 w-full p-2 rounded-xl hover:bg-base-200 border border-dashed border-base-content/20" onClick={() => setPatrao(patraoPickerRow, null)}>
                            <div className="w-10 h-10 rounded-full bg-base-200 flex items-center justify-center">
                                <MaterialSymbol icon="person_off" size={20} className="text-base-content/40" />
                            </div>
                            <span className="text-base-content/60">Sem patrão (raiz)</span>
                        </button>
                    </div>

                    <div className="p-4 border-t border-base-content/10">
                        <button type="button" className="btn btn-ghost w-full" onClick={() => setPatraoPickerRow(null)}>Cancelar</button>
                    </div>
                </motion.div>
            </div>
        );
    };


    return (
        <AnimatePresence>
            {isOpen && (
                <>
                    <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} className="fixed inset-0 z-40 bg-black/60 backdrop-blur-sm" onClick={onClose} />

                    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
                        <motion.div
                            initial={{ opacity: 0, scale: 0.95, y: 20 }}
                            animate={{ opacity: 1, scale: 1, y: 0 }}
                            exit={{ opacity: 0, scale: 0.95, y: 20 }}
                            className="w-full max-w-3xl rounded-2xl border border-base-content/10 bg-base-100 shadow-2xl max-h-[90vh] flex flex-col"
                            onClick={(e) => e.stopPropagation()}
                        >
                            {/* Header */}
                            <div className="flex items-center justify-between border-b border-base-content/10 p-4 shrink-0">
                                <h3 className="text-lg font-bold flex items-center gap-2">
                                    <MaterialSymbol icon="upload_file" size={24} className="text-primary" />
                                    Importar Membros
                                </h3>
                                <button type="button" className="btn btn-ghost btn-sm btn-circle" onClick={onClose}>
                                    <MaterialSymbol icon="close" size={20} />
                                </button>
                            </div>

                            {/* Progress */}
                            <div className="px-6 pt-4 shrink-0">
                                <ul className="steps steps-horizontal w-full text-xs">
                                    <li className={classNames("step", step !== "upload" && "step-primary")}>Upload</li>
                                    <li className={classNames("step", (step === "preview" || step === "assign" || step === "results") && "step-primary")}>Preview</li>
                                    <li className={classNames("step", (step === "assign" || step === "results") && "step-primary")}>Insignias</li>
                                    <li className={classNames("step", step === "results" && "step-primary")}>Resultado</li>
                                </ul>
                            </div>

                            {/* Content */}
                            <div className="p-6 overflow-y-auto flex-1">
                                {step === "upload" && renderUploadStep()}
                                {step === "preview" && renderPreviewStep()}
                                {step === "assign" && renderAssignStep()}
                                {step === "results" && renderResultsStep()}
                            </div>

                            {/* Footer */}
                            <div className="flex justify-between border-t border-base-content/10 px-6 py-4 shrink-0">
                                {/* Back button */}
                                <div>
                                    {step === "preview" && (
                                        <button type="button" className="btn btn-ghost gap-2" onClick={() => { setStep("upload"); setFile(null); setParsedData([]); setErrors([]); }}>
                                            <MaterialSymbol icon="arrow_back" size={18} />
                                            Voltar
                                        </button>
                                    )}
                                    {step === "assign" && (
                                        <button type="button" className="btn btn-ghost gap-2" onClick={() => setStep("preview")}>
                                            <MaterialSymbol icon="arrow_back" size={18} />
                                            Voltar
                                        </button>
                                    )}
                                </div>

                                {/* Action buttons */}
                                <div className="flex gap-3">
                                    {step === "results" ? (
                                        <button type="button" className="btn btn-primary" onClick={onClose}>Fechar</button>
                                    ) : step === "assign" ? (
                                        <>
                                            <button type="button" className="btn btn-ghost" onClick={() => setStep("results")}>Saltar</button>
                                            <button
                                                type="button"
                                                className={classNames("btn btn-primary gap-2", { loading: assigningRoles })}
                                                onClick={handleAssignRoles}
                                                disabled={totalRolesSelected === 0 || assigningRoles}
                                            >
                                                <MaterialSymbol icon="badge" size={18} />
                                                Atribuir {totalRolesSelected} Insignia(s)
                                            </button>
                                        </>
                                    ) : step === "preview" ? (
                                        <>
                                            <button type="button" className="btn btn-ghost" onClick={onClose} disabled={loading}>Cancelar</button>
                                            <button
                                                type="button"
                                                className={classNames("btn btn-primary gap-2", { loading })}
                                                onClick={handleSubmit}
                                                disabled={loading || validRows.length === 0}
                                            >
                                                <MaterialSymbol icon="cloud_upload" size={18} />
                                                Importar {validRows.length} membro(s)
                                            </button>
                                        </>
                                    ) : (
                                        <button type="button" className="btn btn-ghost" onClick={onClose}>Cancelar</button>
                                    )}
                                </div>
                            </div>
                        </motion.div>
                    </div>

                    {renderPatraoPicker()}

                    <RolePickerModal
                        isOpen={showRolePicker}
                        onClose={() => setShowRolePicker(false)}
                        hideYear={false}
                        onSelect={(node, year) => {
                            if (rolePickerUserIdx !== null && node) {
                                addRoleToUser(rolePickerUserIdx, node, year || new Date().getFullYear() - 2000);
                            }
                            setShowRolePicker(false);
                        }}
                    />
                </>
            )}
        </AnimatePresence>
    );
};

BulkImportModal.propTypes = {
    isOpen: PropTypes.bool.isRequired,
    onClose: PropTypes.func.isRequired,
    onComplete: PropTypes.func,
    allUsers: PropTypes.array,
};

export default BulkImportModal;
