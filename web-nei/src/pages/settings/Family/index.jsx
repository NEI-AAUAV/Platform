import { useState, useEffect, useCallback, useMemo, useRef } from "react";
import { Navigate } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import classNames from "classnames";

import MaterialSymbol from "components/MaterialSymbol";

import FamilyService from "services/FamilyService";
import UserForm from "./UserForm";
import RolePickerModal from "components/RolePickerModal";
import BulkEditModal from "./BulkEditModal";
import BulkDeleteModal from "./BulkDeleteModal";
import OrphanModal from "./OrphanModal";

import RoleManagerModal from "components/RoleManagerModal";
import CourseManagerModal from "components/CourseManagerModal";
import { organizations, colors } from "pages/Family/data";
import { useUserStore } from "stores/useUserStore";

import malePic from "assets/default_profile/male.svg";
import femalePic from "assets/default_profile/female.svg";

/**
 * Family Admin Interface - /settings/family
 * CRUD operations for family tree members
 * Requires manager-family or admin scope
 */
export function Component() {
  // Check authorization - useUserStore must be called unconditionally
  const { scopes, sessionLoading } = useUserStore((state) => state);

  // All hooks must be declared unconditionally (React rules of hooks)
  const [users, setUsers] = useState([]);
  const [allUsers, setAllUsers] = useState([]); // For patrão name lookup
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Filters
  const [search, setSearch] = useState("");
  const [debouncedSearch, setDebouncedSearch] = useState("");
  const [yearFilter, setYearFilter] = useState("");

  // Role Filter State
  const [roleFilterId, setRoleFilterId] = useState(null);
  const [roleFilterName, setRoleFilterName] = useState(null);
  const [showRoleFilterModal, setShowRoleFilterModal] = useState(false);

  // Sort State
  const [sortBy, setSortBy] = useState("name");
  const [sortOrder, setSortOrder] = useState("asc");

  const [page, setPage] = useState(0);
  const [total, setTotal] = useState(0);
  const limit = 20;

  // Modal states
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingUser, setEditingUser] = useState(null);
  const [deleteModal, setDeleteModal] = useState(null);
  const [deleting, setDeleting] = useState(false);
  const [showRoleManager, setShowRoleManager] = useState(false);
  const [showCourseManager, setShowCourseManager] = useState(false);
  const [initialPatrao, setInitialPatrao] = useState(null);
  const [history, setHistory] = useState([]);

  // Bulk selection state
  const [selectedIds, setSelectedIds] = useState(new Set());
  const [showBulkEdit, setShowBulkEdit] = useState(false);
  const [showBulkDelete, setShowBulkDelete] = useState(false);

  // Orphan modal state
  const [showOrphanModal, setShowOrphanModal] = useState(false);
  const [orphanChildren, setOrphanChildren] = useState([]);

  // Compute access first (no early return yet - hooks must come first)
  const hasAccess = !sessionLoading && (scopes?.includes("manager-family") || scopes?.includes("admin"));

  // Debounce search
  useEffect(() => {
    if (!hasAccess) return; // Don't run if no access
    const timer = setTimeout(() => {
      setDebouncedSearch(search);
      setPage(0);
    }, 300);
    return () => clearTimeout(timer);
  }, [search, hasAccess]);

  // Load initial data (users lookup for patrões cache)
  useEffect(() => {
    if (!hasAccess) return; // Don't run if no access
    async function loadInitialData() {
      try {
        // Fetch a large number of users to populate the Patrão map
        const usersRes = await FamilyService.getUsers({ limit: 1000 });
        setAllUsers(usersRes.items || []);
      } catch (err) {
        console.error("Failed to load initial data:", err);
      }
    }
    loadInitialData();
  }, [hasAccess]);

  // Create patrão lookup map
  // Robustly handle both _id and id fields
  const userMap = useMemo(() => {
    const map = {};
    allUsers.forEach((u) => {
      if (u._id) map[u._id] = u;
      if (u.id) map[u.id] = u;
    });
    return map;
  }, [allUsers]);

  // Load users with filters
  const fetchUsers = useCallback(async () => {
    if (!hasAccess) return; // Don't run if no access
    setLoading(true);
    setError(null);
    try {
      const params = { skip: page * limit, limit };
      if (debouncedSearch) params.search = debouncedSearch;
      if (yearFilter !== "") params.year = parseInt(yearFilter);
      if (roleFilterId) params.role_id = roleFilterId;
      if (sortBy) {
        params.sort_by = sortBy;
        params.order = sortOrder;
      }

      const response = await FamilyService.getUsers(params);
      setUsers(response.items || []);
      setTotal(response.total || 0);
    } catch (err) {
      console.error("Failed to load users:", err);
      setError("Erro ao carregar membros");
    } finally {
      setLoading(false);
    }
  }, [page, debouncedSearch, yearFilter, roleFilterId, sortBy, sortOrder, hasAccess]);

  useEffect(() => {
    if (!hasAccess) return;
    fetchUsers();
  }, [fetchUsers, hasAccess]);

  // Fetch missing Patrões
  useEffect(() => {
    if (!hasAccess) return;
    if (!users.length) return;

    const missingIds = new Set();
    users.forEach(u => {
      if (u.patrao_id && !userMap[u.patrao_id]) {
        missingIds.add(u.patrao_id);
      }
    });

    if (missingIds.size > 0) {
      const fetchMissing = async () => {
        try {
          // Fetch each missing ID individually (not optimal but ensures correctness)
          // In production, backend should support keys list.
          const promises = Array.from(missingIds).map(id =>
            FamilyService.getUserById(id).catch(() => null)
          );
          const results = await Promise.all(promises);
          const found = results.filter(u => u);

          if (found.length > 0) {
            setAllUsers(prev => [...prev, ...found]);
          }
        } catch (err) {
          console.error("Failed to fetch missing patrões", err);
        }
      };
      fetchMissing();
    }
  }, [users, userMap, hasAccess]);

  // Authorization check - AFTER all hooks
  // Wait for session to load before checking
  if (sessionLoading) {
    return null;
  }

  // Redirect if user doesn't have required scope
  if (!hasAccess) {
    return <Navigate to="/forbidden" replace />;
  }


  const handleAdd = () => {
    setEditingUser(null);
    setInitialPatrao(null);
    setHistory([]);
    setIsFormOpen(true);
  };

  const handleEdit = (user) => {
    setEditingUser(user);
    setInitialPatrao(null);
    setHistory([]);
    setIsFormOpen(true);
  };

  const handleNavigateUser = (user) => {
    setHistory(prev => [...prev, editingUser]);
    setEditingUser(user);
    setInitialPatrao(null);
  };

  const handleNavigateBack = () => {
    if (history.length === 0) return;
    const prev = history[history.length - 1];
    const newHistory = history.slice(0, -1);
    setHistory(newHistory);
    setEditingUser(prev);
    // If we are going back to "Create User" (prev is null), ensure initialPatrao is cleared? 
    // Actually if prev (User A) creates child (Target), history has User A. 
    // Going back restores User A. State logic seems fine.
    if (!prev) setInitialPatrao(null);
  };

  const handleCreateChild = (patrao) => {
    if (editingUser) {
      // Save current user to history so we can go back
      setHistory(prev => [...prev, editingUser]);
    }
    setEditingUser(null);
    setInitialPatrao(patrao);
    setIsFormOpen(true);
  };

  const toggleSort = (field) => {
    if (sortBy === field) {
      setSortOrder(prev => prev === "asc" ? "desc" : "asc");
    } else {
      setSortBy(field);
      setSortOrder("asc");
    }
    setPage(0);
  };

  // Sort Icon Helper
  const SortIcon = ({ field }) => {
    if (sortBy !== field) return <MaterialSymbol icon="unfold_more" size={16} className="text-base-content/20" />;
    return <MaterialSymbol icon={sortOrder === "asc" ? "expand_less" : "expand_more"} size={16} className="text-active" />;
  };

  // Check if user has children before deleting
  const handleDeleteRequest = async (user) => {
    try {
      const children = await FamilyService.getUserChildren(user._id);
      if (children && children.length > 0) {
        setOrphanChildren(children);
        setDeleteModal(user);
        setShowOrphanModal(true);
      } else {
        setDeleteModal(user);
        setShowOrphanModal(false);
      }
    } catch (err) {
      // If can't check children, proceed with simple delete modal
      setDeleteModal(user);
      setShowOrphanModal(false);
    }
  };

  const handleDelete = async () => {
    if (!deleteModal) return;
    setDeleting(true);
    try {
      await FamilyService.deleteUser(deleteModal._id);
      setDeleteModal(null);
      setShowOrphanModal(false);
      setOrphanChildren([]);
      fetchUsers();
      // Refresh lookup
      const response = await FamilyService.getUsers({ limit: 1000 });
      setAllUsers(response.items || []);
    } catch (err) {
      alert(err.response?.data?.detail || "Erro ao eliminar");
    } finally {
      setDeleting(false);
    }
  };

  // Re-parent children then delete
  const handleReparentAndDelete = async (newPatraoId) => {
    if (!deleteModal || !orphanChildren.length) return;
    setDeleting(true);
    try {
      // Update each child to new patron
      await Promise.all(orphanChildren.map(child =>
        FamilyService.updateUser(child._id, { ...child, patrao_id: newPatraoId })
      ));
      // Now delete the original user
      await FamilyService.deleteUser(deleteModal._id);
      setDeleteModal(null);
      setShowOrphanModal(false);
      setOrphanChildren([]);
      fetchUsers();
      const response = await FamilyService.getUsers({ limit: 1000 });
      setAllUsers(response.items || []);
    } catch (err) {
      alert(err.response?.data?.detail || "Erro ao processar");
    } finally {
      setDeleting(false);
    }
  };

  // Bulk selection handlers
  const toggleSelectUser = (userId) => {
    setSelectedIds(prev => {
      const next = new Set(prev);
      if (next.has(userId)) {
        next.delete(userId);
      } else {
        next.add(userId);
      }
      return next;
    });
  };

  // Check if all users on current page are selected
  const allCurrentPageSelected = useMemo(() => {
    if (users.length === 0) return false;
    return users.every(u => selectedIds.has(u._id));
  }, [users, selectedIds]);

  // Check if some (but not all) users on current page are selected
  const someCurrentPageSelected = useMemo(() => {
    if (users.length === 0) return false;
    const selectedCount = users.filter(u => selectedIds.has(u._id)).length;
    return selectedCount > 0 && selectedCount < users.length;
  }, [users, selectedIds]);

  const toggleSelectAll = () => {
    setSelectedIds(prev => {
      const next = new Set(prev);
      if (allCurrentPageSelected) {
        // Deselect all on current page
        users.forEach(u => next.delete(u._id));
      } else {
        // Select all on current page
        users.forEach(u => next.add(u._id));
      }
      return next;
    });
  };

  const clearAllSelections = () => {
    setSelectedIds(new Set());
  };

  const selectedUsers = useMemo(() =>
    users.filter(u => selectedIds.has(u._id)),
    [users, selectedIds]
  );

  const handleBulkDelete = () => {
    // Open bulk delete modal instead of window.confirm
    setShowBulkDelete(true);
  };

  const handleBulkDeleteComplete = async () => {
    setSelectedIds(new Set());
    await fetchUsers();
    try {
      const response = await FamilyService.getUsers({ limit: 1000 });
      setAllUsers(response.items || []);
    } catch (err) {
      console.error("Failed to refresh users", err);
    }
  };

  const handleSave = async () => {
    await fetchUsers();
    // Refresh cache partly
    try {
      const response = await FamilyService.getUsers({ limit: 1000 });
      setAllUsers(response.items || []);
    } catch { }
  };

  const totalPages = Math.ceil(total / limit);

  // Dynamic years from DB
  const [years, setYears] = useState([]);

  useEffect(() => {
    FamilyService.getYears()
      .then(data => setYears(data || []))
      .catch(err => console.error("Failed to load years", err));
  }, []);

  // Helper to format year
  const formatYear = (y, fmt) => {
    if (!y && y !== 0) return "-";

    // Academic Format: 23/24
    if (fmt === "academic") {
      const yearNum = parseInt(y);
      const yy = yearNum % 100;
      const next = (yy + 1) % 100;
      return `${yy.toString().padStart(2, "0")}/${next.toString().padStart(2, '0')}`;
    }

    // Civil Format (Default)
    if (y < 100) return `20${y.toString().padStart(2, "0")}`;
    return y;
  };

  // Custom Year Dropdown logic
  const [yearDropdownOpen, setYearDropdownOpen] = useState(false);
  const yearDropdownRef = useRef(null);

  useEffect(() => {
    function handleClickOutside(event) {
      if (yearDropdownRef.current && !yearDropdownRef.current.contains(event.target)) {
        setYearDropdownOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);


  return (
    <div className="mx-auto w-full max-w-7xl px-4 py-8">
      {/* Header */}
      <div className="mb-8 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-3xl font-bold">Gestão da Família</h1>
          <p className="mt-1 text-base-content/70">
            Adicionar, editar e remover membros da árvore
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <button className="btn btn-ghost btn-square" onClick={() => setShowRoleManager(true)} title="Gerir Insígnias/Roles">
            <MaterialSymbol icon="settings_account_box" size={20} />
          </button>
          <button className="btn btn-ghost btn-square" onClick={() => setShowCourseManager(true)} title="Gerir Cursos">
            <MaterialSymbol icon="school" size={20} />
          </button>
          <button className="btn btn-primary gap-2" onClick={handleAdd}>
            <MaterialSymbol icon="person_add" size={20} />
            Novo Membro
          </button>
        </div>
      </div>

      {/* Filters Bar */}
      <div className="mb-6 grid grid-cols-1 gap-4 rounded-xl border border-base-content/10 bg-base-100 p-4 shadow-sm md:grid-cols-4">
        {/* Search */}
        <div className="relative md:col-span-2">
          <MaterialSymbol icon="search" size={20} className="absolute left-3 top-1/2 -translate-y-1/2 text-base-content/50" />
          <input
            type="text"
            placeholder="Pesquisar por nome, ID ou nmec..."
            className="input input-bordered w-full pl-10"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
          {search && (
            <button
              className="btn btn-ghost btn-sm btn-circle absolute right-2 top-1/2 -translate-y-1/2"
              onClick={() => setSearch("")}
            >
              <MaterialSymbol icon="close" size={16} />
            </button>
          )}
        </div>

        {/* Year Filter - Custom Dropdown with Colors */}
        <div className="relative" ref={yearDropdownRef}>
          <button
            className="btn btn-outline border-base-content/20 bg-base-100 font-normal w-full justify-between"
            onClick={() => setYearDropdownOpen(!yearDropdownOpen)}
          >
            <div className="flex items-center gap-2">
              {yearFilter === "" ? (
                <span>Todos os Anos</span>
              ) : (
                <>
                  <div
                    className="h-3 w-3 rounded-full"
                    style={{ backgroundColor: colors[parseInt(yearFilter) % colors.length] }}
                  />
                  <span>Ano {formatYear(parseInt(yearFilter))} ({formatYear(parseInt(yearFilter), 'academic')})</span>
                </>
              )}
            </div>
            <MaterialSymbol icon="arrow_drop_down" size={24} className="text-base-content/50" />
          </button>

          {yearDropdownOpen && (
            <div className="absolute top-full left-0 mt-2 w-full z-20 max-h-60 overflow-y-auto rounded-xl border border-base-content/10 bg-base-100 shadow-xl p-1">
              <button
                className="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-left hover:bg-base-200"
                onClick={() => {
                  setYearFilter("");
                  setPage(0);
                  setYearDropdownOpen(false);
                }}
              >
                <span>Todos os Anos</span>
              </button>
              {years.map(y => (
                <button
                  key={y}
                  className="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-left hover:bg-base-200"
                  onClick={() => {
                    setYearFilter(y.toString());
                    setPage(0);
                    setYearDropdownOpen(false);
                  }}
                >
                  <div
                    className="h-4 w-4 rounded-full ring-1 ring-base-content/10"
                    style={{ backgroundColor: colors[y % colors.length] }}
                  />
                  <span>Ano {formatYear(y)} ({formatYear(y, 'academic')})</span>
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Role Filter Button */}
        <div className="dropdown w-full">
          <button
            className="btn btn-outline border-base-content/20 bg-base-100 font-normal w-full justify-between hover:bg-base-100 hover:text-base-content hover:border-base-content/40"
            onClick={() => setShowRoleFilterModal(true)}
          >
            <span className={classNames("truncate", !roleFilterId && "text-base-content/50")}>
              {roleFilterName || "Filtrar por Insígnia"}
            </span>
            {roleFilterId ? (
              <div
                className="ml-2 flex h-5 w-5 items-center justify-center rounded-full bg-base-content/10 hover:bg-base-content/20"
                onClick={(e) => {
                  e.stopPropagation();
                  setRoleFilterId(null);
                  setRoleFilterName(null);
                  setPage(0);
                }}
              >
                <MaterialSymbol icon="close" size={14} />
              </div>
            ) : (
              <MaterialSymbol icon="arrow_drop_down" size={24} className="text-base-content/50" />
            )}
          </button>
        </div>
      </div>

      {/* Error */}
      {
        error && (
          <div className="alert alert-error mb-6">
            <span>{error}</span>
            <button className="btn btn-sm" onClick={fetchUsers}>
              Tentar novamente
            </button>
          </div>
        )
      }

      {/* Loading */}
      {
        loading ? (
          <div className="flex justify-center py-12">
            <span className="loading loading-spinner loading-lg text-primary"></span>
          </div>
        ) : (
          <>
            {/* Bulk Action Toolbar */}
            {selectedIds.size > 0 && (
              <div className="mb-4 flex items-center gap-3 rounded-lg bg-primary/10 border border-primary/20 px-4 py-3">
                <span className="font-medium text-primary">
                  {selectedIds.size} membro(s) selecionado(s)
                  {selectedIds.size > users.length && (
                    <span className="text-xs text-base-content/60 ml-1">
                      (incluindo outras páginas)
                    </span>
                  )}
                </span>
                <div className="flex-1" />
                <button
                  className="btn btn-sm btn-ghost gap-1"
                  onClick={() => setShowBulkEdit(true)}
                >
                  <MaterialSymbol icon="edit" size={16} />
                  Editar
                </button>
                <button
                  className="btn btn-sm btn-error btn-ghost gap-1"
                  onClick={handleBulkDelete}
                >
                  <MaterialSymbol icon="delete" size={16} />
                  Eliminar
                </button>
                <button
                  className="btn btn-sm btn-ghost"
                  onClick={clearAllSelections}
                >
                  Limpar seleção
                </button>
              </div>
            )}

            {/* User Table */}
            <div className="overflow-x-auto rounded-xl border border-base-content/10 bg-base-100">
              <table className="table min-w-[850px] w-full">
                <thead className="bg-base-200/50">
                  <tr className="border-base-content/10">
                    <th className="w-10">
                      <input
                        type="checkbox"
                        className={classNames("checkbox checkbox-sm", {
                          "checkbox-primary": someCurrentPageSelected
                        })}
                        checked={allCurrentPageSelected}
                        ref={el => {
                          if (el) el.indeterminate = someCurrentPageSelected;
                        }}
                        onChange={toggleSelectAll}
                        title={allCurrentPageSelected ? "Desselecionar página" : "Selecionar página"}
                      />
                    </th>
                    <th className="w-[28%] cursor-pointer hover:bg-base-200" onClick={() => toggleSort("name")}>
                      <div className="flex items-center gap-2">Membro (ID) <SortIcon field="name" /></div>
                    </th>
                    <th className="w-[18%] cursor-pointer hover:bg-base-200" onClick={() => toggleSort("patrao_id")}>
                      <div className="flex items-center gap-2">Patrão <SortIcon field="patrao_id" /></div>
                    </th>
                    <th className="w-[10%] text-center cursor-pointer hover:bg-base-200" onClick={() => toggleSort("year")}>
                      <div className="flex items-center justify-center gap-2">Ano <SortIcon field="year" /></div>
                    </th>
                    <th className="w-[28%]">Insígnias</th>
                    <th className="w-[10%] text-right">Ações</th>
                  </tr>
                </thead>
                <tbody>
                  {users.length === 0 ? (
                    <tr>
                      <td colSpan={6} className="py-12 text-center text-base-content/50">
                        Nenhum membro encontrado.
                      </td>
                    </tr>
                  ) : (
                    users.map((user) => {
                      const patrao = user.patrao_id ? (userMap[user.patrao_id] || null) : null;
                      const userColor = colors[user.start_year % colors.length] || "#ccc";
                      const userRoles = user.user_roles || [];
                      const isSelected = selectedIds.has(user._id);

                      return (
                        <tr
                          key={user._id}
                          className={classNames(
                            "border-base-content/5 transition-colors hover:bg-base-200/50",
                            isSelected && "bg-primary/5"
                          )}
                        >
                          {/* Checkbox */}
                          <td>
                            <input
                              type="checkbox"
                              className="checkbox checkbox-sm"
                              checked={isSelected}
                              onChange={() => toggleSelectUser(user._id)}
                            />
                          </td>
                          {/* Member + ID */}
                          <td>
                            <div className="flex items-center gap-3">
                              <div className="avatar placeholder">
                                <div
                                  className="h-10 w-10 rounded-full bg-base-300 ring-2 ring-offset-2 ring-offset-base-100"
                                  style={{
                                    backgroundColor: userColor,
                                    "--tw-ring-color": userColor
                                  }}
                                >
                                  <img
                                    src={user.image || (user.sex === "F" ? femalePic : malePic)}
                                    alt=""
                                    className="object-cover"
                                  />
                                </div>
                              </div>
                              <div className="min-w-0">
                                <div className="flex items-baseline gap-2">
                                  <div className="truncate font-bold">{user.name}</div>
                                  <span className="text-xs text-base-content/40 font-mono">#{user._id}</span>
                                </div>
                                <div className="flex items-center gap-2 text-sm text-base-content/60">
                                  {user.faina_name && <span>{user.faina_name}</span>}
                                  {user.nmec && (
                                    <span className="badge badge-ghost badge-xs">
                                      {user.nmec}
                                    </span>
                                  )}
                                </div>
                              </div>
                            </div>
                          </td>

                          {/* Patrão */}
                          <td>
                            {patrao ? (
                              <div className="flex items-center gap-2">
                                <div className="avatar placeholder h-6 w-6 rounded-full bg-base-300">
                                  <img
                                    src={patrao.image || (patrao.sex === 'F' ? femalePic : malePic)}
                                    alt=""
                                    className="rounded-full"
                                  />
                                </div>
                                <span className="truncate font-medium">{patrao.name}</span>
                              </div>
                            ) : user.patrao_id ? (
                              <span className="text-error text-xs" title={`ID: ${user.patrao_id}`}>
                                {`ID: ${user.patrao_id}`} <span className="opacity-50">(Fetching...)</span>
                              </span>
                            ) : (
                              <span className="text-base-content/30 italic">Raiz</span>
                            )}
                          </td>

                          {/* Year */}
                          <td className="text-center font-mono text-sm">
                            {formatYear(user.start_year)}
                          </td>

                          {/* Insignias */}
                          <td>
                            <div className="flex flex-wrap gap-1">
                              {(userRoles.length === 0 || userRoles.every(r => r.hidden)) && <span className="text-xs text-base-content/30">-</span>}
                              {userRoles.filter(role => !role.hidden).map((role, idx) => {
                                // Try to find matching logo
                                let logo = null;
                                if (role.icon) {
                                  logo = role.icon;
                                } else if (role.org_name && organizations[role.org_name]) {
                                  logo = organizations[role.org_name].insignia;
                                }

                                const roleTitle = role.role_name || role.name || role.org_name || "Cargo";
                                const tooltip = `${roleTitle} (${formatYear(role.year, role.year_display_format)})`;

                                return (
                                  <div
                                    key={`${role.role_id}_${idx}`}
                                    className="tooltip tooltip-primary"
                                    data-tip={tooltip}
                                  >
                                    {logo ? (
                                      <img
                                        src={logo}
                                        alt={roleTitle}
                                        className="h-6 w-6 object-contain hover:scale-110 transition-transform"
                                        onError={(e) => {
                                          // Fallback if image fails
                                          e.target.style.display = 'none';
                                          e.target.parentElement.innerHTML = `<span class="badge badge-sm badge-outline text-[10px] whitespace-nowrap">${role.org_name || role.role_id || "?"}</span>`;
                                        }}
                                      />
                                    ) : (
                                      <span className="badge badge-sm badge-outline text-[10px] whitespace-nowrap">
                                        {role.org_name || role.role_id || "?"}
                                      </span>
                                    )}
                                  </div>
                                );
                              })}
                            </div>
                          </td>

                          {/* Actions */}
                          <td className="text-right">
                            <div className="flex justify-end gap-2">
                              <button
                                className="btn btn-ghost btn-xs btn-square"
                                onClick={() => handleEdit(user)}
                                title="Editar"
                              >
                                <MaterialSymbol icon="edit" size={16} />
                              </button>
                              <button
                                className="btn btn-ghost btn-xs btn-square text-error"
                                onClick={() => handleDeleteRequest(user)}
                                title="Eliminar"
                              >
                                <MaterialSymbol icon="delete" size={16} />
                              </button>
                            </div>
                          </td>
                        </tr>
                      );
                    })
                  )}
                </tbody>
              </table>
            </div>

            {/* Pagination */}
            <div className="mt-4 flex flex-col items-center justify-between gap-4 sm:flex-row">
              <div className="text-sm text-base-content/60">
                A mostrar {users.length} de {total} membros
              </div>
              <div className="join">
                <button
                  className="btn join-item btn-sm"
                  disabled={page === 0}
                  onClick={() => setPage((p) => Math.max(0, p - 1))}
                >
                  Anterior
                </button>
                <button className="btn join-item btn-sm no-animation cursor-default">
                  Página {page + 1} de {totalPages || 1}
                </button>
                <button
                  className="btn join-item btn-sm"
                  disabled={page >= totalPages - 1}
                  onClick={() => setPage((p) => p + 1)}
                >
                  Próximo
                </button>
              </div>
            </div>
          </>
        )
      }

      {/* User Form Modal */}
      <UserForm
        user={editingUser}
        isOpen={isFormOpen}
        onClose={() => setIsFormOpen(false)}
        onSave={handleSave}
        initialPatrao={initialPatrao}
        onAddChild={handleCreateChild}
        onSwitchUser={handleNavigateUser}
        canGoBack={history.length > 0}
        onBack={handleNavigateBack}
      />

      {/* Role Manager */}
      <RoleManagerModal
        isOpen={showRoleManager}
        onClose={() => setShowRoleManager(false)}
      />

      {/* Course Manager */}
      <CourseManagerModal
        isOpen={showCourseManager}
        onClose={() => setShowCourseManager(false)}
      />

      {/* Delete Confirmation */}
      <AnimatePresence>
        {deleteModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4 backdrop-blur-sm">
            <motion.div
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.9 }}
              className="w-full max-w-sm rounded-xl bg-base-100 p-6 shadow-xl"
            >
              <h3 className="text-lg font-bold">Eliminar Membro?</h3>
              <p className="py-4">
                Tem a certeza que deseja eliminar <b>{deleteModal.name}</b>?
                <br />
                <span className="text-sm text-warning mt-2 block bg-warning/10 p-2 rounded">
                  <MaterialSymbol icon="warning" className="align-bottom mr-1" size={16} />
                  Atenção: Os afilhados ficarão órfãos!
                </span>
              </p>
              <div className="flex justify-end gap-3">
                <button
                  className="btn btn-ghost"
                  onClick={() => setDeleteModal(null)}
                  disabled={deleting}
                >
                  Cancelar
                </button>
                <button
                  className={classNames("btn btn-error", { loading: deleting })}
                  onClick={handleDelete}
                >
                  Eliminar
                </button>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>

      {/* Role Picker Modal for Filter */}
      <RolePickerModal
        isOpen={showRoleFilterModal}
        onClose={() => setShowRoleFilterModal(false)}
        hideYear={false}
        onSelect={(node) => {
          setRoleFilterId(node._id);
          setRoleFilterName(node.name);
          setPage(0);
        }}
      />

      {/* Bulk Edit Modal */}
      <BulkEditModal
        isOpen={showBulkEdit}
        onClose={() => setShowBulkEdit(false)}
        selectedUsers={selectedUsers}
        onComplete={() => {
          setSelectedIds(new Set());
          fetchUsers();
        }}
      />

      {/* Bulk Delete Modal */}
      <BulkDeleteModal
        isOpen={showBulkDelete}
        onClose={() => setShowBulkDelete(false)}
        selectedUsers={selectedUsers}
        onComplete={handleBulkDeleteComplete}
      />

      {/* Orphan Modal - shown when deleting user with children */}
      <OrphanModal
        isOpen={showOrphanModal && !!deleteModal}
        onClose={() => {
          setShowOrphanModal(false);
          setDeleteModal(null);
          setOrphanChildren([]);
        }}
        userToDelete={deleteModal}
        children={orphanChildren}
        onConfirmDelete={handleDelete}
        onReparent={handleReparentAndDelete}
      />

    </div >
  );
}
