import React, { useState, useEffect } from "react";

import { motion } from "framer-motion";

import {
  TuneIcon,
  CloseIcon,
  FullScreenIcon,
  FullScreenExitIcon,
} from "assets/icons/google";

import classNames from "classnames";

import { useFamilyTree } from "./useFamilyTree";

import FamilyContent from "./FamilyContent";
import FamilySidebar from "./FamilySidebar";
import UserForm from "../settings/Family/UserForm";
import ProfileViewModal from "components/ProfileViewModal";
import { useUserStore } from "stores/useUserStore";
import { getErrorMessage } from "utils/error";
import MaterialSymbol from "components/MaterialSymbol";
import FamilyService from "services/FamilyService";
import { getNodeById, navigateToNode, highlightLineage } from "./data";
import "./index.css";

export function Component() {
  const [expanded, setExpanded] = useState(false);
  const [sidebarOpened, setSidebarOpened] = useState(window.innerWidth >= 768);

  const [insignias, setInsignias] = useState([]);
  const [year, setYear] = useState(null); // Will be set to maxYear when data loads

  // Edit Mode State
  const [editMode, setEditMode] = useState(false);
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingUser, setEditingUser] = useState(null);

  // Profile View State
  const [isProfileOpen, setIsProfileOpen] = useState(false);
  const [profileUser, setProfileUser] = useState(null);

  const { scopes, sessionLoading } = useUserStore((state) => state);

  // Check authorization
  const canEdit = !sessionLoading && (scopes?.includes("manager-family") || scopes?.includes("admin"));

  // Fetch data from API - includes minYear/maxYear
  const { minYear, maxYear, loading, users, refetch } = useFamilyTree();

  // Initialize year to maxYear when data loads
  useEffect(() => {
    if (maxYear !== null && year === null) {
      setYear(maxYear);
    }
  }, [maxYear, year]);

  // Handle node edit request from Tree
  const handleNodeEdit = (nodeData) => {
    if (!editMode || !canEdit) return;
    // Map D3 node data to UserForm format
    const userForForm = {
      _id: nodeData.id,
      name: nodeData.name,
      sex: nodeData.sex,
      start_year: nodeData.start_year,
      faina_name: nodeData.faina_name,
      nmec: nodeData.nmec,
      patrao_id: nodeData.parent,
      course_id: nodeData.course_id,
      image: nodeData.image,
      user_roles: nodeData.user_roles || nodeData.organizations || [],
    };
    setEditingUser(userForForm);
    setIsFormOpen(true);
  };

  const handleSave = () => {
    setIsFormOpen(false);
    refetch(); // Reload tree data
  };

  const handleDelete = async (user) => {
    try {
      // Check for orphaned children first
      const children = await FamilyService.getUserChildren(user._id);
      if (children && children.length > 0) {
        const childNames = children.map(c => c.name).join(", ");
        const confirmed = window.confirm(
          `Atenção: ${user.name} tem ${children.length} pedaço(s): ${childNames}.\n\nAo eliminar, estes ficarão órfãos. Deseja continuar?`
        );
        if (!confirmed) return;
      }

      await FamilyService.deleteUser(user._id);
      setIsFormOpen(false);
      refetch(); // Reload tree data
    } catch (err) {
      console.error("Failed to delete user:", err);
      alert("Erro ao eliminar utilizador: " + getErrorMessage(err, "Erro desconhecido"));
    }
  };

  // Handle profile view request from Tree
  const handleNodeViewProfile = (nodeData) => {
    setProfileUser(nodeData);
    setIsProfileOpen(true);
  };

  // Navigate to a node in the tree (for profile modal navigation)
  const handleNavigateToNode = (userId) => {
    const node = getNodeById(userId);
    if (node) {
      navigateToNode(node);
      highlightLineage(userId);
    }
  };

  // Helper: Render sidebar toggle buttons (reduces cognitive complexity)
  const renderSidebarToggles = () => (
    <>
      <div className="tooltip tooltip-right" data-tip={sidebarOpened ? "Fechar filtros" : "Abrir filtros"}>
        <label className="pointer-events-auto swap-rotate swap btn-sm btn-circle btn">
          <input
            type="checkbox"
            checked={sidebarOpened}
            onChange={(e) => setSidebarOpened(e.target.checked)}
          />
          <CloseIcon className="swap-on" />
          <TuneIcon className="swap-off" />
        </label>
      </div>
      <div className="tooltip tooltip-right" data-tip={expanded ? "Sair de ecrã inteiro" : "Ecrã inteiro"}>
        <label className="pointer-events-auto swap-rotate swap btn-sm btn-circle btn">
          <input
            type="checkbox"
            checked={expanded}
            onChange={(e) => setExpanded(e.target.checked)}
          />
          <FullScreenExitIcon className="swap-on" />
          <FullScreenIcon className="swap-off" />
        </label>
      </div>

      {/* Edit Mode Toggle */}
      {canEdit && (
        <div className="tooltip tooltip-right" data-tip={editMode ? "Desativar edição" : "Editar nós da árvore"}>
          <button
            className={classNames(
              "pointer-events-auto btn btn-sm btn-circle transition-all",
              editMode ? "btn-warning" : "btn-ghost"
            )}
            onClick={() => setEditMode(!editMode)}
          >
            <MaterialSymbol icon={editMode ? "edit_off" : "edit_square"} size={18} />
          </button>
        </div>
      )}

      {/* Link to Management Page */}
      {canEdit && (
        <div className="tooltip tooltip-right" data-tip="Gestão de Família">
          <a
            href="/settings/family"
            className="pointer-events-auto btn btn-sm btn-circle btn-ghost"
          >
            <MaterialSymbol icon="settings" size={18} />
          </a>
        </div>
      )}
    </>
  );

  return (
    <motion.div
      className="w-full"
      id="treeei"
      animate={expanded ? "expand" : "normal"}
      transition={{ duration: 0.15 }}
      variants={{
        expand: {
          y: -80,
          height: window.innerHeight,
          zIndex: 1000
        },
        normal: {
          y: 0,
          height: window.innerHeight - 144, // 144 = navbar + footer
          zIndex: 0,
          transition: {
            duration: 0.15,
            zIndex: { delay: 0.15 },
          },
        },
      }}
    >
      {/* Edit Mode Floating Indicator */}
      {editMode && canEdit && (
        <div className="absolute top-4 left-1/2 -translate-x-1/2 z-30 flex items-center gap-2 sm:gap-3 rounded-full bg-warning px-3 sm:px-4 py-2 text-warning-content shadow-lg">
          <MaterialSymbol icon="edit" size={18} />
          <span className="font-medium text-sm hidden sm:inline">Clique num nó para editar</span>
          <div className="h-4 w-px bg-warning-content/30 hidden sm:block" />
          <button
            className="btn btn-xs btn-ghost hover:bg-warning-content/20 gap-1"
            onClick={() => {
              setEditingUser(null); // null = create mode
              setIsFormOpen(true);
            }}
            title="Adicionar novo membro"
          >
            <MaterialSymbol icon="person_add" size={16} />
            <span className="hidden sm:inline">Novo</span>
          </button>
          <button
            className="btn btn-xs btn-circle btn-ghost hover:bg-warning-content/20"
            onClick={() => setEditMode(false)}
            title="Sair do modo de edição"
          >
            <MaterialSymbol icon="close" size={14} />
          </button>
        </div>
      )}

      {loading ? (
        <div className="flex h-full w-full items-center justify-center bg-base-100">
          <div className="flex flex-col items-center gap-4">
            <span className="loading loading-spinner loading-lg text-primary"></span>
            <p className="text-lg font-medium text-base-content/70 animate-pulse">A carregar árvore genealógica...</p>
          </div>
        </div>
      ) : (
        <div className="drawer h-full">
          <input
            type="checkbox"
            className="drawer-toggle"
            checked={sidebarOpened}
            onChange={(e) => setSidebarOpened(e.target.checked)}
          />
          <div className="drawer-content !overflow-hidden">
            <FamilyContent
              insignias={insignias}
              year={year}
              users={users}
              loading={loading}
              minYear={minYear}
              maxYear={maxYear}
              // Edit Props
              editMode={editMode && canEdit}
              onNodeEdit={handleNodeEdit}
              onNodeViewProfile={handleNodeViewProfile}
            />
          </div>
          <div
            className={classNames(
              "drawer-side pointer-events-none relative !flex h-full !overflow-hidden py-5",
              { "px-1": sidebarOpened }
            )}
          >
            <div className="drawer-overlay hidden" />
            <div
              className={classNames(
                "rounded-l-box relative mr-12 !flex h-full w-80 text-base-content !transition-transform",
                sidebarOpened
                  ? "pointer-events-auto border border-r-0 border-base-content/10 bg-base-200 shadow-[0_1px_3px_-1px_rgba(0,0,0,0.1)]"
                  : "bg-transparent"
              )}
            >
              <div className="rounded-box my-2 ml-2 flex w-full min-h-0 flex-col border-base-content/10 bg-base-300">
                <div className="min-h-0 flex-1 overflow-y-auto" style={{ WebkitOverflowScrolling: 'touch' }}>
                  <FamilySidebar
                    insignias={insignias}
                    year={year}
                    setInsignias={setInsignias}
                    setYear={setYear}
                    minYear={minYear}
                    maxYear={maxYear}
                    users={users}
                  />
                </div>
              </div>
              <div
                className={classNames(
                  "rounded-r-box absolute left-full -top-px -bottom-px flex w-12 flex-col items-center gap-3 py-3",
                  sidebarOpened
                    ? "border  border-l-0 border-base-content/10 bg-base-200 shadow-[1px_1px_3px_-1px_rgba(0,0,0,0.1)]"
                    : "bg-transparent"
                )}
              >
                {renderSidebarToggles()}
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Reused User Modal */}
      {canEdit && (
        <UserForm
          isOpen={isFormOpen}
          user={editingUser}
          onClose={() => setIsFormOpen(false)}
          onSave={handleSave}
          onDelete={handleDelete}
          initialPatrao={null}
          canGoBack={false}
          onBack={() => { }}
        />
      )}

      {/* Profile View Modal - Available to all users */}
      <ProfileViewModal
        isOpen={isProfileOpen}
        user={profileUser}
        onClose={() => setIsProfileOpen(false)}
        onNavigateToNode={handleNavigateToNode}
      />
    </motion.div>
  );
}
