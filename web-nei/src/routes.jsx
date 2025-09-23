import React from "react";
import { Navigate } from "react-router-dom";

import config from "config";

import Layout, { FullLayout, CleanLayout } from "./layouts/Layout";
import { useUserStore } from "stores/useUserStore";

const isProd = config.PRODUCTION;

function ProtectedRoute({
  children,
  loggedIn = true,
  redirect = "/auth/login",
  adminOnly = false,
}) {
  const { sessionLoading, token, scopes } = useUserStore((state) => state);

  if (sessionLoading) return null;

  if (!!token !== loggedIn) return <Navigate to={redirect} />;

  if (adminOnly && (!scopes || !scopes.includes("admin"))) {
    return <Navigate to="/forbidden" />;
  }

  return children;
}

const routes = [
  {
    path: "/",
    element: <Layout />,
    children: [
      { path: "/", lazy: () => import("./pages/Homepage") },
      { path: "/notes", lazy: () => import("./pages/Notes") },
      { path: "/calendar", lazy: () => import("./pages/Calendar") },
      { path: "/videos", lazy: () => import("./pages/Videos") },
      { path: "/videos/:id", lazy: () => import("./pages/Video") },
      { path: "/teams", lazy: () => import("./pages/Team") },
      { path: "/rgm", lazy: () => import("./pages/RGM") },
      !isProd && {
        path: "/news/:id?",
        lazy: () => import("./pages/News/NewsList"),
      },
      !isProd && { path: "/history", lazy: () => import("./pages/History") },
      !isProd && {
        path: "/seniors/:course?",
        lazy: () => import("./pages/Seniors"),
      },
      { path: "/faina", lazy: () => import("./pages/Faina") },
      !isProd && {
        path: "/taca-ua",
        lazy: () => import("./pages/TacauaHomePage"),
      },
      !isProd && {
        path: "/taca-ua/:modalityId/:tab/:competitionId?",
        lazy: () => import("./pages/SportDetails"),
      },
      !isProd && {
        path: "/components",
        lazy: () => import("./pages/Components"),
      },
      !isProd && { path: "/WSTest", lazy: () => import("./pages/WSTest") },
      !isProd && {
        path: "/WStacaua-admin-demo",
        lazy: () => import("./pages/TacauaAdminDemo"),
      },
      { path: "/auth/verify", lazy: () => import("./pages/auth/EmailVerify") },
      { path: "/auth/reset", lazy: () => import("./pages/auth/ResetPassword") },
      { path: "/auth/magic", lazy: () => import("./pages/auth/MagicLink") },
      // These must be here and not behind the auth checks, because if they aren't
      // the router would automatically redirect to the homepage after login, and
      // the redirection logic wouldn't work.
      { path: "/auth/login", lazy: () => import("./pages/auth/Login") },
      { path: "/auth/register", lazy: () => import("./pages/auth/Register") },
      { path: "/forbidden", lazy: () => import("./pages/Error403") },
      { path: "/arraial", lazy: () => import("./pages/Arraial") },
      // { path: "/estagios", element: <Internship /> },
      // { path: "/forms/feedback", element: <FeedbackForm /> },
      { path: "/*", lazy: () => import("./pages/Error404") },
    ],
  },
  {
    path: "/",
    element: (
      <ProtectedRoute>
        <Layout />
      </ProtectedRoute>
    ),
    children: [
      {
        path: "/settings/profile",
        lazy: () => import("./pages/settings/Profile"),
      },
      !isProd && {
        path: "/settings/family",
        lazy: () => import("./pages/settings/Family"),
      },
      !isProd && {
        path: "/settings/account",
        lazy: () => import("./pages/settings/Account"),
      },
    ],
  },
  {
    path: "/",
    element: (
      <ProtectedRoute adminOnly>
        <Layout />
      </ProtectedRoute>
    ),
    children: [
      {
        path: "/admin/roles",
        lazy: () => import("./pages/admin/Roles"),
      },
    ],
  },
  {
    path: "/",
    element: (
      <ProtectedRoute loggedIn={false} redirect="/">
        <Layout />
      </ProtectedRoute>
    ),
    children: [
      {
        path: "/auth/forgot",
        lazy: () => import("./pages/auth/ForgotPassword"),
      },
    ],
  },
  {
    path: "/",
    element: <FullLayout />,
    children: [{ path: "/family", lazy: () => import("./pages/Family") }],
  },
  // {
  //   path: "/",
  //   element: <CleanLayout />,
  //   children: [
  //     { path: "/breakthebars", element: <RallyTascas />, children: rallyTascasRoutes },
  //   ],
  // },
];

export default routes;
