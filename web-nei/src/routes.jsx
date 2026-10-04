import React from "react";
import PropTypes from "prop-types";
import { Navigate } from "react-router-dom";

import config from "config";

import Layout, { FullLayout } from "./layouts/Layout";
import { useUserStore } from "stores/useUserStore";
import { lazyRoute } from "utils/lazyRoute";

const isProd = config.PRODUCTION;

function ProtectedRoute({
  children,
  loggedIn = true,
  redirect = "/auth/login",
  adminOnly = false,
  requiredScopes = [],
  notFoundRedirect = false,
}) {
  const { sessionLoading, token, scopes } = useUserStore((state) => state);

  if (sessionLoading) return null;

  if (!!token !== loggedIn) return <Navigate to={redirect} />;

  if (adminOnly && (!scopes?.includes("admin"))) {
    return <Navigate to="/forbidden" />;
  }

  // Check required scopes (user must have at least one of the required scopes)
  if (requiredScopes.length > 0) {
    const hasScope = requiredScopes.some(s => scopes?.includes(s));
    if (!hasScope) {
      // Redirect to 404 to hide existence of page, or /forbidden to show access denied
      return <Navigate to={notFoundRedirect ? "/page-not-found" : "/forbidden"} replace />;
    }
  }

  return children;
}

ProtectedRoute.propTypes = {
  children: PropTypes.node,
  loggedIn: PropTypes.bool,
  redirect: PropTypes.string,
  adminOnly: PropTypes.bool,
  requiredScopes: PropTypes.arrayOf(PropTypes.string),
  notFoundRedirect: PropTypes.bool,
};

const routes = [
  {
    path: "/",
    element: <Layout />,
    children: [
      { path: "/", lazy: lazyRoute(() => import("./pages/Homepage")) },
      { path: "/notes", lazy: lazyRoute(() => import("./pages/Notes")) },
      { path: "/calendar", lazy: lazyRoute(() => import("./pages/Calendar")) },
      { path: "/videos", lazy: lazyRoute(() => import("./pages/Videos")) },
      { path: "/videos/:id", lazy: lazyRoute(() => import("./pages/Video")) },
      { path: "/teams", lazy: lazyRoute(() => import("./pages/Team")) },
      { path: "/rgm", lazy: lazyRoute(() => import("./pages/RGM")) },
      !isProd && {
        path: "/news/:id?",
        lazy: lazyRoute(() => import("./pages/News/NewsList")),
      },
      !isProd && { path: "/history", lazy: lazyRoute(() => import("./pages/History")) },
      !isProd && {
        path: "/seniors/:course?",
        lazy: lazyRoute(() => import("./pages/Seniors")),
      },
      { path: "/faina", lazy: lazyRoute(() => import("./pages/Faina")) },
      !isProd && {
        path: "/taca-ua",
        lazy: lazyRoute(() => import("./pages/TacauaHomePage")),
      },
      !isProd && {
        path: "/taca-ua/:modalityId/:tab/:competitionId?",
        lazy: lazyRoute(() => import("./pages/SportDetails")),
      },
      !isProd && {
        path: "/components",
        lazy: lazyRoute(() => import("./pages/Components")),
      },
      !isProd && { path: "/WSTest", lazy: lazyRoute(() => import("./pages/WSTest")) },
      !isProd && {
        path: "/WStacaua-admin-demo",
        lazy: lazyRoute(() => import("./pages/TacauaAdminDemo")),
      },
      { path: "/auth/verify", lazy: lazyRoute(() => import("./pages/auth/EmailVerify")) },
      { path: "/auth/reset", lazy: lazyRoute(() => import("./pages/auth/ResetPassword")) },
      { path: "/auth/magic", lazy: lazyRoute(() => import("./pages/auth/MagicLink")) },
      // These must be here and not behind the auth checks, because if they aren't
      // the router would automatically redirect to the homepage after login, and
      // the redirection logic wouldn't work.
      { path: "/auth/login", lazy: lazyRoute(() => import("./pages/auth/Login")) },
      { path: "/auth/register", lazy: lazyRoute(() => import("./pages/auth/Register")) },
      { path: "/auth/oidc/return", lazy: lazyRoute(() => import("./pages/auth/OidcCallback")) },
      { path: "/forbidden", lazy: lazyRoute(() => import("./pages/Error403")) },
      { path: "/arraial", lazy: lazyRoute(() => import("./pages/Arraial")) },
      // { path: "/estagios", element: <Internship /> },
      // { path: "/forms/feedback", element: <FeedbackForm /> },
      { path: "/*", lazy: lazyRoute(() => import("./pages/Error404")) },
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
        lazy: lazyRoute(() => import("./pages/settings/Profile")),
      },
      !isProd && {
        path: "/settings/account",
        lazy: lazyRoute(() => import("./pages/settings/Account")),
      },
    ],
  },
  // Family Manager - requires manager-family or admin scope
  {
    path: "/",
    element: (
      <ProtectedRoute requiredScopes={["manager-family", "admin"]}>
        <Layout />
      </ProtectedRoute>
    ),
    children: [
      {
        path: "/settings/family",
        lazy: lazyRoute(() => import("./pages/settings/Family")),
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
        path: "/admin",
        lazy: lazyRoute(() => import("./pages/admin")),
      },
      {
        path: "/admin/roles",
        element: <Navigate to="/admin" replace />,
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
        lazy: lazyRoute(() => import("./pages/auth/ForgotPassword")),
      },
    ],
  },
  {
    path: "/",
    element: <FullLayout />,
    children: [{ path: "/family", lazy: lazyRoute(() => import("./pages/Family")) }],
  },
];

export default routes;
