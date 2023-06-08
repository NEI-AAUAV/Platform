--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: nei; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA nei;


ALTER SCHEMA nei OWNER TO postgres;

--
-- Name: category_enum; Type: TYPE; Schema: nei; Owner: postgres
--

CREATE TYPE nei.category_enum AS ENUM (
    'EVENT',
    'NEWS',
    'PARCERIA'
);


ALTER TYPE nei.category_enum OWNER TO postgres;

--
-- Name: gender_enum; Type: TYPE; Schema: nei; Owner: postgres
--

CREATE TYPE nei.gender_enum AS ENUM (
    'MALE',
    'FEMALE'
);


ALTER TYPE nei.gender_enum OWNER TO postgres;

--
-- Name: scope_enum; Type: TYPE; Schema: nei; Owner: postgres
--

CREATE TYPE nei.scope_enum AS ENUM (
    'ADMIN',
    'MANAGER_NEI',
    'MANAGER_TACAUA',
    'MANAGER_FAMILY',
    'DEFAULT'
);


ALTER TYPE nei.scope_enum OWNER TO postgres;

--
-- Name: status_enum; Type: TYPE; Schema: nei; Owner: postgres
--

CREATE TYPE nei.status_enum AS ENUM (
    'ACTIVE',
    'INACTIVE'
);


ALTER TYPE nei.status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: course; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.course (
    code integer NOT NULL,
    name character varying(128) NOT NULL,
    short character varying(8),
    discontinued smallint
);


ALTER TABLE nei.course OWNER TO postgres;

--
-- Name: device_login; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.device_login (
    user_id integer NOT NULL,
    session_id integer NOT NULL,
    refreshed_at timestamp without time zone NOT NULL,
    expires_at timestamp without time zone NOT NULL
);


ALTER TABLE nei.device_login OWNER TO postgres;

--
-- Name: faina; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.faina (
    id integer NOT NULL,
    image character varying(2048),
    mandate character varying(7)
);


ALTER TABLE nei.faina OWNER TO postgres;

--
-- Name: faina_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.faina_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.faina_id_seq OWNER TO postgres;

--
-- Name: faina_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.faina_id_seq OWNED BY nei.faina.id;


--
-- Name: faina_member; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.faina_member (
    id integer NOT NULL,
    member_id integer,
    faina_id integer,
    role_id integer
);


ALTER TABLE nei.faina_member OWNER TO postgres;

--
-- Name: faina_member_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.faina_member_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.faina_member_id_seq OWNER TO postgres;

--
-- Name: faina_member_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.faina_member_id_seq OWNED BY nei.faina_member.id;


--
-- Name: faina_role; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.faina_role (
    id integer NOT NULL,
    name character varying(20),
    weight integer
);


ALTER TABLE nei.faina_role OWNER TO postgres;

--
-- Name: faina_role_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.faina_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.faina_role_id_seq OWNER TO postgres;

--
-- Name: faina_role_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.faina_role_id_seq OWNED BY nei.faina_role.id;


--
-- Name: history; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.history (
    moment date NOT NULL,
    title character varying(120),
    body text,
    image character varying(2048)
);


ALTER TABLE nei.history OWNER TO postgres;

--
-- Name: merch; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.merch (
    id integer NOT NULL,
    name character varying(256),
    image character varying(2048),
    price double precision,
    number_of_items integer,
    discontinued boolean
);


ALTER TABLE nei.merch OWNER TO postgres;

--
-- Name: merch_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.merch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.merch_id_seq OWNER TO postgres;

--
-- Name: merch_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.merch_id_seq OWNED BY nei.merch.id;


--
-- Name: news; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.news (
    id integer NOT NULL,
    header character varying(2048),
    status nei.status_enum,
    title character varying(256),
    category nei.category_enum,
    content character varying(20000),
    published_by integer,
    created_at timestamp without time zone,
    last_change_at timestamp without time zone,
    changed_by integer,
    author_id integer
);


ALTER TABLE nei.news OWNER TO postgres;

--
-- Name: news_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.news_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.news_id_seq OWNER TO postgres;

--
-- Name: news_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.news_id_seq OWNED BY nei.news.id;


--
-- Name: note; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.note (
    id integer NOT NULL,
    author_id integer,
    subject_id integer,
    teacher_id integer,
    name character varying(256),
    location character varying(2048),
    year smallint,
    summary smallint,
    tests smallint,
    bibliography smallint,
    slides smallint,
    exercises smallint,
    projects smallint,
    notebook smallint,
    content text,
    created_at timestamp without time zone,
    size integer
);


ALTER TABLE nei.note OWNER TO postgres;

--
-- Name: note_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.note_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.note_id_seq OWNER TO postgres;

--
-- Name: note_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.note_id_seq OWNED BY nei.note.id;


--
-- Name: partner; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.partner (
    id integer NOT NULL,
    header character varying(2048),
    company character varying(256),
    description text,
    content character varying(256),
    link character varying(256),
    banner_url character varying(256),
    banner_image character varying(2048),
    banner_until timestamp without time zone
);


ALTER TABLE nei.partner OWNER TO postgres;

--
-- Name: partner_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.partner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.partner_id_seq OWNER TO postgres;

--
-- Name: partner_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.partner_id_seq OWNED BY nei.partner.id;


--
-- Name: redirect; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.redirect (
    id integer NOT NULL,
    alias character varying(256),
    redirect character varying(2048)
);


ALTER TABLE nei.redirect OWNER TO postgres;

--
-- Name: redirect_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.redirect_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.redirect_id_seq OWNER TO postgres;

--
-- Name: redirect_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.redirect_id_seq OWNED BY nei.redirect.id;


--
-- Name: rgm; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.rgm (
    id integer NOT NULL,
    category character varying(3),
    mandate character varying(7) NOT NULL,
    date timestamp without time zone,
    title character varying(264),
    file character varying(2048)
);


ALTER TABLE nei.rgm OWNER TO postgres;

--
-- Name: rgm_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.rgm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.rgm_id_seq OWNER TO postgres;

--
-- Name: rgm_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.rgm_id_seq OWNED BY nei.rgm.id;


--
-- Name: senior; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.senior (
    id integer NOT NULL,
    year integer,
    course character varying(6),
    image character varying(2048)
);


ALTER TABLE nei.senior OWNER TO postgres;

--
-- Name: senior_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.senior_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.senior_id_seq OWNER TO postgres;

--
-- Name: senior_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.senior_id_seq OWNED BY nei.senior.id;


--
-- Name: senior_student; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.senior_student (
    senior_id integer NOT NULL,
    user_id integer NOT NULL,
    quote character varying(280),
    image character varying(2048)
);


ALTER TABLE nei.senior_student OWNER TO postgres;

--
-- Name: subject; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.subject (
    code integer NOT NULL,
    course_id integer,
    curricular_year integer NOT NULL,
    name character varying(128) NOT NULL,
    short character varying(8) NOT NULL,
    discontinued boolean,
    optional boolean
);


ALTER TABLE nei.subject OWNER TO postgres;

--
-- Name: teacher; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.teacher (
    id integer NOT NULL,
    name character varying(100),
    personal_page character varying(256)
);


ALTER TABLE nei.teacher OWNER TO postgres;

--
-- Name: teacher_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.teacher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.teacher_id_seq OWNER TO postgres;

--
-- Name: teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.teacher_id_seq OWNED BY nei.teacher.id;


--
-- Name: team_colaborator; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.team_colaborator (
    user_id integer NOT NULL,
    mandate character varying(7) NOT NULL
);


ALTER TABLE nei.team_colaborator OWNER TO postgres;

--
-- Name: team_member; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.team_member (
    id integer NOT NULL,
    header character varying(2048),
    mandate character varying(7),
    user_id integer,
    role_id integer
);


ALTER TABLE nei.team_member OWNER TO postgres;

--
-- Name: team_member_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.team_member_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.team_member_id_seq OWNER TO postgres;

--
-- Name: team_member_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.team_member_id_seq OWNED BY nei.team_member.id;


--
-- Name: team_role; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.team_role (
    id integer NOT NULL,
    name character varying(120),
    weight integer
);


ALTER TABLE nei.team_role OWNER TO postgres;

--
-- Name: team_role_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.team_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.team_role_id_seq OWNER TO postgres;

--
-- Name: team_role_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.team_role_id_seq OWNED BY nei.team_role.id;


--
-- Name: user; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei."user" (
    id integer NOT NULL,
    iupi character varying(36),
    nmec integer,
    hashed_password text,
    name character varying(20) NOT NULL,
    surname character varying(20) NOT NULL,
    gender nei.gender_enum,
    image character varying(2048),
    curriculum character varying(2048),
    linkedin character varying(2048),
    github character varying(2048),
    scopes nei.scope_enum[],
    updated_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    birthday date
);


ALTER TABLE nei."user" OWNER TO postgres;

--
-- Name: user_academic_details; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.user_academic_details (
    id integer NOT NULL,
    user_id integer NOT NULL,
    course_id integer NOT NULL,
    curricular_year integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE nei.user_academic_details OWNER TO postgres;

--
-- Name: user_academic_details__subjects; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.user_academic_details__subjects (
    user_academic_details_id integer NOT NULL,
    subject integer NOT NULL
);


ALTER TABLE nei.user_academic_details__subjects OWNER TO postgres;

--
-- Name: user_academic_details_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.user_academic_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.user_academic_details_id_seq OWNER TO postgres;

--
-- Name: user_academic_details_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.user_academic_details_id_seq OWNED BY nei.user_academic_details.id;


--
-- Name: user_email; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.user_email (
    email text NOT NULL,
    user_id integer NOT NULL,
    active boolean NOT NULL
);


ALTER TABLE nei.user_email OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.user_id_seq OWNED BY nei."user".id;


--
-- Name: video; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.video (
    id integer NOT NULL,
    youtube_id character varying(256),
    title character varying(256),
    subtitle character varying(256),
    image character varying(2048),
    created_at timestamp without time zone,
    playlist smallint
);


ALTER TABLE nei.video OWNER TO postgres;

--
-- Name: video__video_tags; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.video__video_tags (
    video_id integer NOT NULL,
    video_tag_id integer NOT NULL
);


ALTER TABLE nei.video__video_tags OWNER TO postgres;

--
-- Name: video_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.video_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.video_id_seq OWNER TO postgres;

--
-- Name: video_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.video_id_seq OWNED BY nei.video.id;


--
-- Name: video_tag; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.video_tag (
    id integer NOT NULL,
    name character varying(256),
    color character varying(18)
);


ALTER TABLE nei.video_tag OWNER TO postgres;

--
-- Name: video_tag_id_seq; Type: SEQUENCE; Schema: nei; Owner: postgres
--

CREATE SEQUENCE nei.video_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nei.video_tag_id_seq OWNER TO postgres;

--
-- Name: video_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: nei; Owner: postgres
--

ALTER SEQUENCE nei.video_tag_id_seq OWNED BY nei.video_tag.id;


--
-- Name: faina id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.faina ALTER COLUMN id SET DEFAULT nextval('nei.faina_id_seq'::regclass);


--
-- Name: faina_member id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.faina_member ALTER COLUMN id SET DEFAULT nextval('nei.faina_member_id_seq'::regclass);


--
-- Name: faina_role id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.faina_role ALTER COLUMN id SET DEFAULT nextval('nei.faina_role_id_seq'::regclass);


--
-- Name: merch id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.merch ALTER COLUMN id SET DEFAULT nextval('nei.merch_id_seq'::regclass);


--
-- Name: news id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.news ALTER COLUMN id SET DEFAULT nextval('nei.news_id_seq'::regclass);


--
-- Name: note id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.note ALTER COLUMN id SET DEFAULT nextval('nei.note_id_seq'::regclass);


--
-- Name: partner id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.partner ALTER COLUMN id SET DEFAULT nextval('nei.partner_id_seq'::regclass);


--
-- Name: redirect id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.redirect ALTER COLUMN id SET DEFAULT nextval('nei.redirect_id_seq'::regclass);


--
-- Name: rgm id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.rgm ALTER COLUMN id SET DEFAULT nextval('nei.rgm_id_seq'::regclass);


--
-- Name: senior id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.senior ALTER COLUMN id SET DEFAULT nextval('nei.senior_id_seq'::regclass);


--
-- Name: teacher id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.teacher ALTER COLUMN id SET DEFAULT nextval('nei.teacher_id_seq'::regclass);


--
-- Name: team_member id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.team_member ALTER COLUMN id SET DEFAULT nextval('nei.team_member_id_seq'::regclass);


--
-- Name: team_role id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.team_role ALTER COLUMN id SET DEFAULT nextval('nei.team_role_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei."user" ALTER COLUMN id SET DEFAULT nextval('nei.user_id_seq'::regclass);


--
-- Name: user_academic_details id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.user_academic_details ALTER COLUMN id SET DEFAULT nextval('nei.user_academic_details_id_seq'::regclass);


--
-- Name: video id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.video ALTER COLUMN id SET DEFAULT nextval('nei.video_id_seq'::regclass);


--
-- Name: video_tag id; Type: DEFAULT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.video_tag ALTER COLUMN id SET DEFAULT nextval('nei.video_tag_id_seq'::regclass);


--
-- Data for Name: course; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.course (code, name, short, discontinued) VALUES
	(9263, 'MESTRADO EM ENGENHARIA INFORMÁTICA (2º CICLO)', 'MEI', 0),
	(8295, 'LICENCIATURA EM ENGENHARIA INFORMÁTICA (1º CICLO)', NULL, 0),
	(8246, 'LICENCIATURA EM DESIGN (1º CICLO)', NULL, 0),
	(9281, 'MESTRADO EM CIBERSEGURANÇA (2º CICLO)', NULL, 0);


--
-- Data for Name: device_login; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.device_login (user_id, session_id, refreshed_at, expires_at) VALUES
	(196, 1683322058, '2023-05-05 21:27:38.082439', '2023-05-12 21:27:38.082439'),
	(196, 1683652585, '2023-05-15 15:52:05.821302', '2023-05-16 17:16:25.010785'),
	(217, 1684247256, '2023-05-16 14:27:36.13233', '2023-05-23 14:27:36.13233'),
	(135, 1684248407, '2023-05-16 14:46:47.946981', '2023-05-23 14:46:47.946981'),
	(197, 1682181380, '2023-04-22 16:37:24.871257', '2023-04-29 16:36:20.014698'),
	(74, 1682186956, '2023-04-22 18:09:21.092469', '2023-04-29 18:09:16.200903'),
	(154, 1682193688, '2023-04-22 20:01:41.131164', '2023-04-29 20:01:28.482049'),
	(74, 1684111548, '2023-05-17 15:55:20.314179', '2023-05-22 00:45:48.666116'),
	(207, 1683328653, '2023-05-05 23:27:20.848772', '2023-05-12 23:17:33.44686'),
	(135, 1682288299, '2023-04-23 22:19:33.824833', '2023-04-30 22:18:19.979988'),
	(208, 1683410112, '2023-05-06 21:55:12.433744', '2023-05-13 21:55:12.433744'),
	(192, 1682433158, '2023-04-25 14:32:56.222039', '2023-05-02 14:32:38.584483'),
	(200, 1682433166, '2023-04-25 14:33:26.262519', '2023-05-02 14:32:46.432219'),
	(208, 1683410235, '2023-05-06 22:01:16.469206', '2023-05-13 21:57:15.058267'),
	(111, 1683476562, '2023-05-07 16:22:42.176469', '2023-05-14 16:22:42.176469'),
	(168, 1682882592, '2023-04-30 19:24:51.565324', '2023-05-07 19:23:12.718096'),
	(74, 1682933455, '2023-05-01 09:30:55.587738', '2023-05-08 09:30:55.587738'),
	(74, 1682933458, '2023-05-01 09:30:58.167224', '2023-05-08 09:30:58.167224'),
	(201, 1682975353, '2023-05-01 21:09:13.049512', '2023-05-08 21:09:13.049512'),
	(157, 1683063971, '2023-05-02 21:46:11.418587', '2023-05-09 21:46:11.418587'),
	(202, 1683155600, '2023-05-03 23:13:43.785368', '2023-05-10 23:13:20.632884'),
	(191, 1683221438, '2023-05-04 17:30:38.188123', '2023-05-11 17:30:38.188123'),
	(203, 1683233162, '2023-05-04 20:46:02.740185', '2023-05-11 20:46:02.740185'),
	(204, 1683285282, '2023-05-08 15:46:12.616773', '2023-05-12 11:14:42.714705'),
	(197, 1683241446, '2023-05-04 23:04:23.796922', '2023-05-11 23:04:06.030136'),
	(157, 1685844745, '2023-06-04 02:30:59.124303', '2023-06-11 02:12:25.156001'),
	(221, 1685844745, '2023-06-04 02:45:54.970485', '2023-06-11 02:12:25.52893'),
	(206, 1683296156, '2023-05-05 14:16:00.355514', '2023-05-12 14:15:56.915776'),
	(74, 1684528485, '2023-05-19 23:36:08.256128', '2023-05-26 20:34:45.709897'),
	(183, 1683675347, '2023-05-09 23:35:47.795805', '2023-05-16 23:35:47.795805'),
	(160, 1684528471, '2023-05-20 13:30:31.398439', '2023-05-26 20:34:31.357025'),
	(209, 1683733525, '2023-05-10 15:45:48.670062', '2023-05-17 15:45:25.206461'),
	(210, 1683743786, '2023-05-10 18:36:26.545818', '2023-05-17 18:36:26.545818'),
	(129, 1684679128, '2023-05-21 14:25:28.673331', '2023-05-28 14:25:28.673331'),
	(207, 1683321789, '2023-05-05 21:23:09.915395', '2023-05-12 21:23:09.915395'),
	(83, 1684759105, '2023-05-22 12:38:25.777488', '2023-05-29 12:38:25.777488'),
	(144, 1683802476, '2023-05-11 10:54:36.973211', '2023-05-18 10:54:36.973211'),
	(179, 1683321905, '2023-05-05 21:25:05.607086', '2023-05-12 21:25:05.607086'),
	(144, 1683814756, '2023-05-11 14:19:16.030954', '2023-05-18 14:19:16.030954'),
	(144, 1683826620, '2023-05-11 17:37:00.762091', '2023-05-18 17:37:00.762091'),
	(212, 1683826648, '2023-05-11 17:37:28.881861', '2023-05-18 17:37:28.881861'),
	(212, 1683826667, '2023-05-11 17:37:47.697132', '2023-05-18 17:37:47.697132'),
	(196, 1683321995, '2023-05-05 21:26:35.402408', '2023-05-12 21:26:35.402408'),
	(196, 1683322105, '2023-05-11 23:44:47.646796', '2023-05-12 21:28:25.835754'),
	(83, 1684759109, '2023-05-22 12:38:29.022246', '2023-05-29 12:38:29.022246'),
	(205, 1683328604, '2023-05-12 16:12:49.637526', '2023-05-12 23:16:44.283907'),
	(74, 1685850146, '2023-06-04 03:42:26.080704', '2023-06-11 03:42:26.080704'),
	(218, 1684777945, '2023-05-22 17:55:44.843483', '2023-05-29 17:52:25.692643'),
	(213, 1683933360, '2023-05-12 23:19:25.955775', '2023-05-19 23:16:00.130576'),
	(219, 1684953346, '2023-05-24 18:35:46.574425', '2023-05-31 18:35:46.574425'),
	(154, 1685290489, '2023-05-28 16:16:30.511988', '2023-06-04 16:14:49.348309'),
	(219, 1684953351, '2023-05-30 12:52:14.337398', '2023-05-31 18:35:51.826886'),
	(220, 1685459217, '2023-05-30 15:06:57.254504', '2023-06-06 15:06:57.254504'),
	(201, 1684016762, '2023-05-13 23:02:39.507623', '2023-05-20 22:26:02.126543'),
	(214, 1684084908, '2023-05-14 17:21:48.452126', '2023-05-21 17:21:48.452126'),
	(215, 1684085190, '2023-05-14 17:26:30.296772', '2023-05-21 17:26:30.296772'),
	(215, 1684085240, '2023-05-14 17:31:55.166351', '2023-05-21 17:27:20.94478'),
	(208, 1685572784, '2023-05-31 22:39:49.304896', '2023-06-07 22:39:44.204763'),
	(207, 1685744042, '2023-06-02 22:14:02.025988', '2023-06-09 22:14:02.025988'),
	(43, 1685550293, '2023-06-03 16:53:44.930741', '2023-06-07 16:24:53.533999'),
	(216, 1684109730, '2023-05-15 00:15:30.197733', '2023-05-22 00:15:30.197733'),
	(74, 1684111529, '2023-05-15 00:45:29.798841', '2023-05-22 00:45:29.798841'),
	(74, 1684111537, '2023-05-15 00:45:37.812115', '2023-05-22 00:45:37.812115'),
	(196, 1685844744, '2023-06-04 02:23:08.852512', '2023-06-11 02:12:24.411389');


--
-- Data for Name: faina; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.faina (id, image, mandate) VALUES
	(1, NULL, '2012/13'),
	(2, NULL, '2013/14'),
	(3, NULL, '2014/15'),
	(4, NULL, '2015/16'),
	(5, NULL, '2016/17'),
	(6, NULL, '2017/18'),
	(7, '/faina/2018.jpg', '2018/19'),
	(8, '/faina/2019.jpg', '2019/20'),
	(9, '/faina/2020.jpg', '2020/21'),
	(10, '/faina/2021.jpg', '2021/22');


--
-- Data for Name: faina_member; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.faina_member (id, member_id, faina_id, role_id) VALUES
	(1, 39, 1, 10),
	(2, 80, 1, 7),
	(3, 25, 1, 5),
	(4, 29, 1, 5),
	(5, 151, 1, 5),
	(6, 58, 1, 6),
	(7, 113, 1, 6),
	(8, 108, 1, 6),
	(9, 38, 1, 3),
	(10, 82, 1, 3),
	(11, 99, 1, 3),
	(12, 113, 2, 10),
	(13, 108, 2, 7),
	(14, 44, 2, 5),
	(15, 82, 2, 5),
	(16, 99, 2, 5),
	(17, 115, 2, 5),
	(18, 20, 2, 4),
	(19, 71, 2, 3),
	(20, 78, 2, 3),
	(21, 85, 2, 2),
	(22, 110, 2, 1),
	(23, 99, 3, 10),
	(24, 16, 3, 7),
	(25, 44, 3, 7),
	(26, 115, 3, 7),
	(27, 78, 3, 5),
	(28, 21, 3, 4),
	(29, 66, 3, 3),
	(30, 79, 3, 3),
	(31, 85, 3, 4),
	(32, 110, 3, 3),
	(33, 116, 3, 4),
	(34, 78, 4, 10),
	(35, 6, 4, 7),
	(36, 42, 4, 7),
	(37, 50, 4, 7),
	(38, 152, 4, 5),
	(39, 13, 4, 5),
	(40, 26, 4, 5),
	(41, 88, 4, 5),
	(42, 12, 4, 3),
	(43, 3, 4, 1),
	(44, 64, 4, 1),
	(45, 50, 5, 10),
	(46, 152, 5, 7),
	(47, 12, 5, 5),
	(48, 28, 5, 6),
	(49, 95, 5, 5),
	(50, 64, 5, 3),
	(51, 81, 5, 3),
	(52, 91, 5, 2),
	(53, 24, 5, 1),
	(54, 119, 5, 1),
	(55, 12, 6, 10),
	(56, 32, 6, 7),
	(57, 91, 6, 4),
	(58, 24, 6, 3),
	(59, 19, 6, 4),
	(60, 30, 6, 3),
	(61, 33, 6, 3),
	(62, 57, 6, 3),
	(63, 119, 6, 3),
	(64, 117, 6, 1),
	(65, 91, 7, 9),
	(66, 57, 7, 5),
	(67, 73, 7, 5),
	(68, 70, 7, 5),
	(69, 22, 7, 3),
	(70, 48, 7, 3),
	(71, 75, 7, 3),
	(72, 114, 7, 4),
	(73, 8, 7, 1),
	(74, 15, 7, 2),
	(75, 120, 7, 1),
	(76, 57, 8, 10),
	(77, 61, 8, 7),
	(78, 73, 8, 7),
	(79, 70, 8, 7),
	(80, 15, 8, 4),
	(81, 77, 8, 3),
	(82, 84, 8, 4),
	(83, 120, 8, 3),
	(84, 27, 8, 1),
	(85, 43, 8, 1),
	(86, 93, 8, 1),
	(87, 73, 9, 10),
	(88, 61, 9, 7),
	(89, 70, 9, 7),
	(90, 15, 9, 6),
	(91, 77, 9, 5),
	(92, 43, 9, 3),
	(93, 93, 9, 3),
	(94, 104, 9, 3),
	(95, 123, 9, 1),
	(96, 129, 9, 1),
	(97, 134, 9, 1),
	(98, 15, 10, 10),
	(99, 43, 10, 5),
	(100, 77, 10, 7),
	(101, 93, 10, 5),
	(102, 104, 10, 5),
	(103, 123, 10, 3),
	(104, 129, 10, 3),
	(105, 133, 10, 3),
	(106, 134, 10, 3),
	(107, 130, 10, 4);


--
-- Data for Name: faina_role; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.faina_role (id, name, weight) VALUES
	(1, 'Junco', 1),
	(2, 'Caniça', 1),
	(3, 'Moço', 2),
	(4, 'Moça', 2),
	(5, 'Marnoto', 4),
	(6, 'Salineira', 3),
	(7, 'Mestre', 5),
	(8, 'Arrais', 6),
	(9, 'Varina', 6),
	(10, 'Mestre de Curso', 6);


--
-- Data for Name: history; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.history (moment, title, body, image) VALUES
	('2018-04-30', 'Elaboração de Candidatura para o Encontro Nacional de Estudantes de Informática 2019', 'Entrega de uma candidatura conjunta (NEI+AETTUA) para a organização do Encontro Nacional de Estudantes de Informática 2019. Esta candidatura teve a concorrência de uma candidatura conjunta do ISCAC Junior Solutions e Junisec, constituída por alunos do Politécnico de Coimbra, que acabaram por ser a candidatura vencedora.', '/history/20180430.png'),
	('2019-03-09', '1ª Edição ThinkTwice', 'A primeira edição do evento, realizada em 2019, teve lugar no Auditório Mestre Hélder Castanheira da Universidade de Aveiro e contou com uma duração de 24 horas para a resolução de 30 desafios colocados, que continham diferentes graus de dificuldade. O evento contou com a participação de 34 estudantes, perfazendo um total de 12 equipas.', '/history/20190309.jpg'),
	('2019-06-12', '2º Lugar Futsal', 'Num jogo em que se fizeram das tripas coração, o NEI defrontou a equipa de EGI num jogo que veio a perder, foi um jogo bastante disputado, contudo, acabou por ganhar EGI remetendo o NEI para o 2º lugar.', '/history/20190612.jpg'),
	('2019-06-30', 'Candidatura ENEI 2020', 'Entrega de uma candidatura conjunta (NEI+NEECT+AETTUA) para a organização do Encontro Nacional de Estudantes de Informática 2019. Esta candidatura teve a concorrência de uma candidatura conjunta da CESIUM, constituída por alunos da Universidade do Minho, que acabaram por ser a candidatura vencedora.', '/history/20190630.png'),
	('2020-03-06', '2ª Edição ThinkTwice', 'A edição de 2020 contou com a participação de 57 participantes divididos em 19 equipas, com 40 desafios de algoritmia de várias dificuldades para serem resolvidos em 40 horas, tendo lugar nas instalações da Casa do Estudante da Universidade de Aveiro. Esta edição contou ainda com 2 workshops e um momento de networking com as empresas patrocinadoras do evento.', '/history/20200306.jpg'),
	('2021-05-07', '3ª Edição ThinkTwice', 'Devido ao contexto pandémico que se vivia a 3ª edição foi 100% online através de plataformas como o Discord e a Twitch, de 7 a 9 de maio. Nesta edição as 11 equipas participantes puderam escolher participar em uma de três tipos de competição: desafios de algoritmia, projeto de gamificação e projeto de cibersegurança. O evento contou ainda com 4 workshops e uma sessão de networking com as empresas patrocinadoras.', '/history/20210507.png');


--
-- Data for Name: merch; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.merch (id, name, image, price, number_of_items, discontinued) VALUES
	(1, 'Emblema de curso', '/merch/emblema.png', 2.5, 0, false),
	(2, 'Cachecol de curso', '/merch/scarf.png', 3.5, 0, true),
	(3, 'Casaco de curso', '/merch/casaco.png', 16.5, 0, true),
	(4, 'Sweat de curso', '/merch/sweat.png', 18, 0, false),
	(5, 'Emblema NEI', '/merch/emblemanei.png', 2.5, 0, false);


--
-- Data for Name: news; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.news (id, header, status, title, category, content, published_by, created_at, last_change_at, changed_by, author_id) VALUES
	(1, '/news/6aniversario.jpg', 'ACTIVE', '6º Aniversário NEI', 'EVENT', 'Fez 6 anos, no passado dia 24 de Janeiro, que se formou o Núcleo de Estudantes de Informática. Para celebrar o 6º aniversário do NEI, convidamos todos os nossos alunos, colegas e amigos a juntarem-se a nós num jantar repleto de surpresas. O jantar realizar-se-á no dia 28 de fevereiro no restaurante \Monte Alentejano\ - Rua de São Sebastião 27A - pelas 20h00 tendo um custo de 11 euros por pessoa. Contamos com a presença de todos para apagarmos as velas e comermos o bolo, porque alegria e diversão já têm presença marcada!<hr><b>Ementa</b><ul><li>Carne de porco à alentejana/ opção vegetariana</li><li>Bebida à descrição</li><li>Champanhe</li><li>Bolo</li></ul>  Nota: Caso pretendas opção vegetariana deves comunicar ao NEI por mensagem privada no facebook ou então via email.<hr><b>Informações</b><br>Inscrições até dia 21 de fevereiro sendo que as mesmas estão limitadas a 100 pessoas.<br>&#9888;&#65039; A inscrição só será validada após o pagamento junto de um elemento do NEI até dia 22 de fevereiro às 16horas!<br>+info: nei@aauav.pt ou pela nossa página de Facebook<br><hr><b>Logins</b><br>Caso não saibas o teu login contacta: <a href=\https://www.facebook.com/ruicoelho43\>Rui Coelho</a> ou então diretamente com o <a href=\https://www.facebook.com/nei.aauav/\>NEI</a>, podes ainda mandar mail para o NEI, nei@aauav.pt.', 111, '2019-01-18 00:00:00', NULL, NULL, 1),
	(2, '/news/rgm1.png', 'ACTIVE', 'Convocatória RGM Extraordinária', 'EVENT', 'De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos Núcleos da Associação Académica da Universidade de Aveiro, convocam-se todos os membros da Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática para uma Reunião Geral de Membros Extraordinária, que se realizará no dia 14 do mês de Fevereiro de 2019, na sala 102 do Departamento de Eletrónica, Telecomunicações e Informática da Universidade de Aveiro, pelas 18 horas, com a seguinte ordem de trabalhos:  <br><br>1. Aprovação da Ata da RGM anterior;   <br>2. Informações;   <br>3. Apresentação do Plano de Atividades e Orçamento;  <br>4. Aprovação do Plano de Atividades e Orçamentos;  <br>5. Outros assuntos.   <br><br>Mais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI.<br><br><div style=\text-align:center\>Aveiro, 11 de janeiro de 2019<br>David Augusto de Sousa Fernandes<br>Presidente da Mesa da Reunião Geral de Membros<br>Núcleo de Estudantes de Informática da AAUAv <br></div><hr>Links úteis:<br><a href=\https://nei.web.ua.pt/scripts/unlock.php?url=upload/documents/RGM_ATAS/2018/RGM_10jan2019.pdf\ target=\_blank\>Ata da RGM anterior</a><br><a href=\https://nei.web.ua.pt/upload/documents/CONV_ATAS/2019/1RGM.pdf\ target=\_blank\>Documento da convocatória</a> ', 111, '2019-02-11 00:00:00', NULL, NULL, 1),
	(3, '/news/rgm2.png', 'ACTIVE', 'Convocatória RGM Extraordinária', 'EVENT', 'De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos  Núcleos  da  Associação Académica  da  Universidade  de  Aveiro,  convocam-se  todos  os membros  da  Licenciatura  em  Engenharia  Informática  e  Mestrado  em  Engenharia  Informática para uma Reunião Geral de MembrosExtraordinária, que se realizará no dia 1do mês de Abrilde 2019,   na   sala   102   do   Departamento   de   Eletrónica,   Telecomunicações   e   Informática   da Universidade de Aveiro, pelas 17:45horas, com a seguinte ordem de trabalhos: <br><br>1. Aprovação da Ata da RGM anterior;   <br>2. Informações;   <br>3. Discussão sobre o tema da barraca;  <br>4. Orçamento Participativo 2019;  <br>5. Outros assuntos.   <br><br>Se   à   hora   indicada   não   existir   quórum,   a   Assembleia   iniciar-se-á   meia   hora   depois, independentemente do número de membros presentes, no mesmo local, e com a mesma ordem de trabalhos.<br>Mais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI (https://nei.web.ua.pt).<br><br><div style=\text-align:center\>Aveiro, 28 de Março de 2019<br>David Augusto de Sousa Fernandes<br>Presidente da Mesa da Reunião Geral de Membros<br>Núcleo de Estudantes de Informática da AAUAv <br></div><hr>', 111, '2019-03-28 00:00:00', NULL, NULL, 1),
	(4, '/news/idpimage.png', 'ACTIVE', 'Integração IDP', 'NEWS', 'Recentemente foi feito um update no site que permite agora aos alunos de Engenharia Informática, quer mestrado, quer licenciatura, iniciar sessão no site  <a href=\https://nei.web.ua.pt\>nei.web.ua.pt</a> através do idp. <br>Esta alteração tem por consequência direta que a gestão de passwords deixa de estar diretamente ligada ao NEI passando assim, deste modo, qualquer password que seja perdida ou seja necessária alterar, responsabilidade do IDP da UA.<br><hr><h5 style=\text-align: center\><strong>Implicações diretas</strong></h5><br>Todas as funcionalidades do site se mantém e esta alteração em nada afeta o normal workflow do site, os apontamentos vão continuar na mesma disponíveis e em breve irão sofrer um update sendo corrigidas eventuais falhas nos atuais e adicionados mais alguns apontamentos No que diz respeito aos jantares de curso, a inscrição para estes também será feita via login através do IDP.<br>De forma genérica o IDP veio simplificar a forma como acedemos às plataformas do NEI, usando assim o Utilizador Universal da Universidade de Aveiro para fazer o login.<br>É de frisar que <strong>apenas</strong> os estudantes dos cursos  <strong>Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática  </strong>têm acesso ao site, todos os outros irão receber uma mensagem de erro quando fazem login e serão redirecionados para a homepage, não tendo, assim, acesso à informação e funcionalidades que necessitam de autenticação.<hr><h5 style=\text-align: center\><strong>Falha nos acessos</strong></h5><br>Existe a possibilidade de alguns alunos não terem acesso caso ainda não tivessem sido registados na versão antiga do site, assim, caso não consigas aceder por favor entra em contacto connosco via email para o <a href=\mailto:nei@aauav.pt?Subject=Acesso%20NEI\ target=\_top\>NEI</a> ou via facebook por mensagem direta para o <a href=\https://www.facebook.com/nei.aauav/\>NEI</a> ou então diretamente com o <a href=\https://www.facebook.com/ruicoelho43\>Rui Coelho</a>.<br>', 111, '2019-05-15 00:00:00', NULL, NULL, 1),
	(5, '/news/florinhas.jpg', 'ACTIVE', 'Entrega de t-shirts à Florinhas de Vouga', 'NEWS', 'Hoje procedemos à entrega de mais de 200 t-shirts em bom estado que nos sobraram ao longo dos anos às Florinhas Do Vouga, possibilitando assim roupa a quem mais precisa.<br>A IPSS – Florinhas do Vouga é uma Instituição Diocesana de Superior Interesse Social, fundada em 6 de Outubro de 1940 por iniciativa do Bispo D. João Evangelista de Lima Vidal, a quem se deve a criação de obras similares, as Florinhas da Rua em Lisboa e as Florinhas da Neve em Vila Real.<br>A Instituição desenvolve a sua intervenção na cidade de Aveiro, mais concretamente na freguesia da Glória, onde se situa um dos Bairros Sociais mais problemáticos da cidade (Bairro de Santiago), dando também resposta, sempre que necessário, às solicitações das freguesias limítrofes e outras, algumas delas fora do Concelho.<br>No desenvolvimento da sua actividade mantém com o CDSSS de Aveiro Acordos de Cooperação nas áreas da Infância e Juventude; População Idosa; Família e Comunidade e Toxicodependência.<br>É Entidade aderente do Núcleo Local de Inserção no âmbito do Rendimento Social de Inserção, parceira do CLAS, assumindo com os diferentes Organismos e Instituições uma parceria activa.<br>O desenvolvimento das respostas decorreu até Agosto de 2008 em equipamentos dispersos na freguesia da Glória e Vera Cruz, o que levou a Instituição a construir um edifício de raiz na freguesia da Glória, espaço onde passou a ter condições para concentrar parte das respostas que desenvolvia (nomeadamente Estabelecimento de Educação Pré-Escolar, CATL e SAD), assumir novas respostas (Creche), dar continuidade ao trabalho desenvolvido e garantir uma melhoria substancial na qualidade dos serviços prestados, encontrando-se neste momento num processo de implementação de Sistema de Gestão de Qualidade com vista à certificação.<br>A presença de famílias numerosas, multiproblemáticas, sem rendimentos de trabalho, quase que limitadas a rendimentos provenientes de prestações sociais, famílias com fortes vulnerabilidades, levaram a Instituição a ser mediadora no Programa Comunitário de Ajuda a Carenciados e a procurar sinergias capazes de optimizar os seus recursos existentes e dar resposta à emergência social, são exemplos disso a acção “Mercearia e Companhia”, que apoia mensalmente cerca de 200 famílias em géneros alimentares, vestuário e outros e a “Ceia com Calor” que distribui diariamente um suplemento alimentar aos Sem-abrigo de Aveiro.<br>É de salientar que as famílias que usufruem de Respostas Socais tipificadas, face às suas vulnerabilidades acabam por não conseguir assumir o pagamento das mensalidades mínimas que deveriam pagar pela prestação dos serviços que lhe são garantidos pela Instituição, o que exige um maior esforço por parte desta.<br>Em termos globais, a Instituição tem assumido uma estratégia de efectiva prevenção, promoção e inclusão da população alvo.<br><strong>Se tiveres roupa ou produtos de higiene a mais e queres ajudar as Florinhas por favor dirige-te à instituição e entrega as mesmas!</strong><br>Fica a conhecer mais sobre esta instituição: http://www.florinhasdovouga.pt', 65, '2019-09-11 00:00:00', NULL, NULL, 1),
	(6, '/news/rgm3.png', 'ACTIVE', 'Convocatória RGM Extraordinária', 'EVENT', 'De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos Núcleos da Associação Académica da Universidade de Aveiro, convocam-se todos os membros da Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática para uma Reunião Geral de Membros Extraordinária, que se realizará no dia 24 do mês de Setembro de 2019, na sala 102 do Departamento de Eletrónica, Telecomunicações e Informática da Universidade de Aveiro, pelas 18:00 horas, com a seguinte ordem de trabalhos: <br><br>1. Aprovação da Ata da RGM anterior; <br>2. Informações; <br>3. Pitch Bootcamp; <br>4. Taça UA; <br>5. Programa de Integração; <br>6. Outros assuntos. <br><br>Se à hora indicada não existir quórum, a Assembleia iniciar-se-á meia hora depois, independentemente do número de membros presentes, no mesmo local, e com a mesma ordem de trabalhos.<br>Mais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI (https://nei.web.ua.pt), sendo necessário fazer login na plataforma para ter acesso à mesma.<br><br><div style=\text-align:center\>David Augusto de Sousa Fernandes<br>Aveiro, 20 de setembro de 2019<br>Presidente da Mesa da Reunião Geral de Membros<br>Núcleo de Estudantes de Informática da AAUAv <br></div><hr>', 65, '2019-09-20 00:00:00', NULL, NULL, 1),
	(7, '/news/newNEI.png', 'ACTIVE', 'Lançamento do novo portal do NEI', 'NEWS', 'Passado um cerca de um ano após o lançamento da versão anterior do portal do NEI, lançamos agora uma versão renovada do mesmo com um desgin mais atrativo utilizando react para a sua criação.<br>Esta nova versão do site conta com algumas novas features:<ol>  <li>Podes agora ter uma foto utilizando o gravatar, fizemos a integração com o mesmo.</li>  <li>Podes associar o teu CV, linkedin e conta git ao teu perfil.</li>  <li>Vais poder acompanhar tudo o que se passa na taça UA com as equipas do NEI a partir da plataforma de desporto que em breve será colocada online.</li>  <li>Existe uma secção que vai permitir aos alunos interessados no curso encontrar informação sobre o mesmo mais facilmente.</li>  <li>Podes encontrar a composição de todas as coordenações na página dedicada à equipa.</li>  <li>Podes encontrar a composição de todas as comissões de faina na página dedicada à equipa.</li>  <li>Integração dos eventos criados no facebook.</li>  <li>Podes ver todas as tuas compras de Merchandising.</li>  <li>Possibilidade de divulgar os projetos no site do NEI todos os projetos que fazes, estes não precisam de ser apenas projetos universitários, podem ser também projetos pessoais. Esta função ainda não está ativa mas em breve terás novidades.</li>  <li>Foi redesenhada a página dos apontamentos sendo agora mais fácil encontrares os apontamentos que precisas, podes pesquisar diretamente ou utilizar diferentes sorts de modo a que fiquem ordenados a teu gosto.</li></ol> À semelhança da anterior versão do website do NEI continuamos a ter a integração do IPD da UA fazendo assim a gestão de acessos ao website mais facilmente. Caso tenhas algum problema com o teu login entra em contacto conosco para resolvermos essa situação.<br>Da mesma que o IDP se manteve, todas as funcionalidades anteriores foram mantidas, apenas remodelamos a imagem. Quanto às funcionalidades existentes, fizemos uma pequena alteração nas atas da RGM, as mesmas passam agora apenas a estarem disponíveis para os membros do curso.Chamamos para a atenção do facto de que, na anterior versão todas as opções existentes no site apareciam logo sem login e posteriormente é que era pedido o mesmo, alteramos isso, agora só aparecem todas as opções após login.<hr>Caso encontres algum bug por favor informa o NEI de modo a que este possa ser corrigido!', 111, '2019-07-22 00:00:00', '2019-09-06 00:00:00', 111, 1),
	(8, '/news/mecvsei.jpg', 'ACTIVE', 'Engenharia Mecânica vs Engenharia Informática (3-2)', 'EVENT', 'Apesar da derrota frente a Engenharia Mecânica por 3-2 num jogo bastante efusivo tivemos as bancadas cheias.<br>Mostramos hoje, novamente, que não é por acaso que ganhamos o prémio de melhor claque da época 2018/2019<br>Podes ver as fotos do jogo no nosso facebook:<br><br><iframe src=\https://www.facebook.com/plugins/post.php?href=https%3A%2F%2Fwww.facebook.com%2Fmedia%2Fset%2F%3Fset%3Da.2657806134483446%26type%3D3&width=500\ width=\500\ height=\650\ align=\middle\ style=\border:none;overflow:hidden\ scrolling=\no\ frameborder=\0\ allowTransparency=\true\ allow=\encrypted-media\></iframe>', 111, '2019-10-17 00:00:00', NULL, NULL, 1),
	(9, '/news/melhorclaque.jpg', 'ACTIVE', 'Melhor Claque 2018/2019', 'NEWS', 'No passado domingo, dia 13 de outubro, decorreu a gala <strong>Academia de Ouro</strong> organizada pela Associação Académica da Universidade de Aveiro.<br>Esta gala visa distinguir personalidades que se destacaram na época de 2018/2019 e dar a conhecer a nova época.<br>O curso de Engenharia Informática foi nomeado para melhor claque e acabou por vencer trazendo para o DETI um prémio que faltava no palmarés.<br>O troféu encontra-se agora exposto junto da porta que dá acesso ao aquário.<br>Resalvamos que esteve ainda nomeado o Bruno Barbosa para melhor jogador mas infelizmente não ganhou o prémio.<br>', 111, '2019-10-17 00:00:00', NULL, NULL, 1),
	(10, '/news/boxburger.png', 'ACTIVE', 'Aproveita o teu desconto de 25%', 'PARCERIA', 'Façam como a Flávia e o Luís e comam no Box Burger.<br>Agora qualquer estudante de Engenharia Informática tem desconto de 25%. Basta apresentarem o cartão de estudante e informar que são de Engenharia Informática.<br>Do que estás à espera? Aproveita!', 111, '2019-10-17 00:00:00', NULL, NULL, 1),
	(11, '/news/rally.jpg', 'ACTIVE', 'Aveiro Horror Story | Rally Tascas #2', 'EVENT', 'És aquele que boceja nos filmes de terror? Adormeceste enquanto dava a parte mais tramada do filme? Este Rally Tascas é para ti!<br>Vem pôr à prova a tua capacidade de engolir o medo no próximo dia 31, e habilita-te a ganhar um prémio!<br>O último Rally foi só o trailer... desta vez vens viver um episódio de terror!<br><br>Não percas a oportunidade e inscreve-te <a href=\https://nei.web.ua.pt/links/irally\ target=\_blank\>aqui!</a><br><br>Consulta o Regulamento <a href=\https://nei.web.ua.pt/links/rally\ target=\_blank\> aqui!</a>', 111, '2019-10-17 00:00:00', NULL, NULL, 1),
	(12, '/news/sessfp.jpg', 'ACTIVE', '1ª Sessão de Dúvidas // Fundamentos de Programação', 'EVENT', 'O NEI está a organizar uma sessão de dúvidas que te vai ajudar a preparar de uma melhor forma para os teus exames da unidade curricular de Fundamentos da Porgramação.<br>A sessão vai ter lugar no dia 22 de outubro e ocorrerá no DETI entre as 18-22h.<br>É importante trazeres o teu material de estudo e o teu computador pessoal uma vez que nem todas as salas têm computadores à disposição.<br>As salas ainda não foram atribuídas, serão no dia do evento, está atento ao <a href=\https://www.facebook.com/events/493810694797695/\>nosso facebook!</a><br>', 111, '2019-10-18 00:00:00', NULL, NULL, 1),
	(13, '/news/newNEI.png', 'ACTIVE', 'PWA NEI', 'NEWS', 'Agora o site do NEI já possui uma PWA, basta aceder ao site e carregar na notificação para fazer download da mesma.<br>Fica atento, em breve, terás novidades sobre uma plataforma para a Taça UA! Vais poder acompanhar tudo o que se passa e inclusivé ver os resultados do teu curso em direto.<br><img src=\https://nei.web.ua.pt/upload/NEI/pwa.jpg\ height=\400\/><img src=\https://nei.web.ua.pt/upload/NEI/pwa2.jpg\ height=\400\/>', 111, '2019-10-21 00:00:00', NULL, NULL, 1),
	(14, '/news/const_cv.png', 'ACTIVE', 'Como construir um bom CV? by Olisipo', 'EVENT', 'Dada a competitividade atual do mercado de trabalho, apresentar um bom currículo torna-se cada vez mais indispensável. Desta forma, o NEI e o NEECT organizaram um workshop chamado \Como construir um bom CV?\, com o apoio da Olisipo. <br>Informações relevantes:<br><ul> <li> 7 de Novembro pelas 18h no DETI (Sala 102)</li> <li> Participação Gratuita</li> <li> INSCRIÇÕES OBRIGATÓRIAS</li> <li> INSCRIÇÕES LIMITADAS</li> <li> Inscrições <a href=\https://docs.google.com/forms/d/e/1FAIpQLSf4e3ZnHdp4INHrFgVCaXQv3pvVgkXrWN_U39s94X7Hvd98XA/viewform\ target=\_blank\>aqui</a></li></ul>  <br> Nesta atividade serão abordados diversos tópicos relativos à importância de um bom currículo e quais as formas corretas de o apresentar.', 111, '2019-11-02 00:00:00', NULL, 111, 1),
	(15, '/news/apontamentos.png', 'ACTIVE', 'Apontamentos que já não precisas? Há quem precise!', 'NEWS', 'Tens apontamentos, resoluções ou qualquer outro material de estudo que já não precisas?Vem promover a inter-ajuda e entrega-os na sala do NEI (132) ou digitaliza-os e envia para nei@aauav.pt.Estarás a contribuir para uma base de dados de apontamentos mais sólida, organizada e completa para o nosso curso!Os alunos de informática agradecem!', 94, '2020-01-29 00:00:00', NULL, NULL, 1),
	(16, '/news/nei_aniv.png', 'ACTIVE', '7º ANIVERSÁRIO DO NEI', 'EVENT', 'Foi no dia 25, há 7 anos atrás, que o TEU núcleo foi criado. Na altura chamado de Núcleo de Estudantes de Sistemas de Informação, mudou para o seu nome atual em 2014.Dos marcos do núcleo ao longo da sua história destacam-se o ENEI em 2014, o Think Twice em 2019 e as diversas presenças nas atividades em grande escala da AAUAv.Parabéns a todos os que contribuíram para o NEI que hoje temos!', 94, '2020-01-29 00:00:00', NULL, NULL, 1),
	(17, '/news/delloitte_consultantforaday.png', 'ACTIVE', 'Queres ser consultor por um dia? A Deloitte dá-te essa oportunidade', 'EVENT', 'A Deloitte Portugal está a organizar o evento “Be a Consultant for a Day | Open House Porto”. Esta iniciativa dá-te acesso a um dia com várias experiências de desenvolvimento de competências e terás ainda a oportunidade de conhecer melhor as áreas de negócio integradas em consultoria tecnológica.O evento irá decorrer no Deloitte Studio do Porto e contará com alunos de várias Universidades da região Norte (Coimbra, Aveiro, Porto e Minho).', 94, '2020-01-29 00:00:00', NULL, NULL, 1),
	(18, '/news/pub_rgm.png', 'ACTIVE', 'Primeira RGM Ordinária', 'EVENT', 'Convocam-se todos os membros de LEI e MEI para a 1ª RGM ordinária com a seguinte ordem de trabalhos:<br><br>1. Aprovação da ata da RGM anterior;<br>2. Apresentação do Plano de Atividades e Orçamento;<br>3. Aprovação do Plano de Atividades e Orçamento;<br>4. Discução relativa à modalidade do Evento do Aniversário do NEI;<br>5. Colaboradores do NEI;<br>6. Informações relativas à Barraca do Enterro 2020;<br>7. Discussão sobre as Unidades Curriculares do 1º Semestre;<br>8. Outros assuntos.<br><br>Link para o Plano de Atividades e Orçamento (PAO):<br>https://nei.web.ua.pt/upload/documents/PAO/2020/PAO_2020_NEI.pdf<br><br>Na RGM serão discutidos assuntos relativos a TODOS os estudantes de informática.<br>Sendo assim, apelamos à participação de TODOS!', 94, '2020-02-18 00:00:00', '2020-02-18 00:00:00', 94, 1),
	(19, '/news/colaboradores.jpg', 'ACTIVE', 'Vem ser nosso Colaborador!', 'EVENT', 'És um estudante ativo?<br>Procuras aprender novas competências e desenvolver novas?<br>Gostavas de ajudar o teu núcleo a proporcionar as melhores atividades da Universidade?<br>Se respondeste sim a pelo menos uma destas questões clica <a href=\https://forms.gle/3y5JZfNvN7rBjFZT8\ target=\_blank\>aqui</a><br>E preenche o formulário!<br>Sendo um colaborador do NEI vais poder desenvolver várias capacidades, sendo que maioria delas não são abordadas nas Unidades Curriculares!<br>Vais fazer amizades e a cima de tudo vais te divertir!<br>Junta-te a nós e ajuda o NEI a desenvolver as melhores atividades possíveis!', 94, '2020-02-19 00:00:00', NULL, NULL, 1),
	(20, '/news/dia-syone.jpg', 'ACTIVE', 'Dia da Syone', 'EVENT', 'A Syone é uma empresa portuguesa provedora de Open Software Solutions.<br/>Neste dia podes participar num workshop, almoço gratuito e num mini-hackathon com prémios! <i class=\fa fa-trophy\ style=\color: gold\></i><br/>Garante já a tua presença através do <a href=\https://forms.gle/62yYsFiiiZXoTiaR8\ target=\_blank\>formulário</a>.<br/>O evento está limitado a 30 pessoas!', 94, '2020-02-26 00:00:00', NULL, NULL, 1),
	(21, '/news/roundtable.jpg', 'ACTIVE', 'Round Table - Bolsas de Investigação', 'EVENT', 'Gostavas de estudar e de ao mesmo tempo desenvolver trabalho de investigação? E se com isto tiveres acesso a uma bolsa?<br/>Aparece nesta round table com os docentes responsáveis pelas bolsas de investigação e vem esclarecer todas as tuas dúvidas!', 94, '2020-02-26 00:00:00', '2020-03-01 00:00:00', 94, 1),
	(22, '/news/jogos-marco.jpg', 'ACTIVE', 'Calendário dos Jogos de março', 'EVENT', 'Não percas os jogos do teu curso na Taça UA para o mês de março!<br/>Aparece ao máximo de jogos possível para apoiares o teu curso em todas as modalidades.<br/>Vem encher a bancada e fazer parte da melhor claque da UA! Contamos contigo e o teu magnifico apoio!', 94, '2020-03-01 00:00:00', NULL, NULL, 1),
	(23, '/news/hackathome.png', 'ACTIVE', 'HackatHome', 'EVENT', 'Tens andado aborrecido nesta quarentena? É contigo em mente que decidimos contornar esta triste situação e organizar um HackatHome!<br/>O HackatHome é uma competição de programação online promovida pelo NEI que consiste na resolução de uma coleção de desafios de programação.<br/>A partir desta quarta feira, e todas as quartas durante as próximas 12 semanas(!), será disponibilizado um desafio, o qual os participantes têm até à quarta-feira seguinte para resolver (1 semana).<br/>Toda a competição assentará na plataforma GitHub Classroom, utilizada para requisitar e submeter os desafios. As pontuações são atribuídas por desafio, e ganha o participante com mais pontos acumulados ao final das 12 semanas!<br/>Não há processo de inscrição, apenas tens de estar atento à divulgação dos links dos desafios nos meios de comunicação do NEI, resolver e submeter através da tua conta GitHub!<br/>Além do prémio do vencedor, será também premiado um participante aleatório! Interessante não? &#129300;<br/>Consulta o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_HackatHome.pdf\ target=\_blank\>regulamento</a>!<br/>E prepara-te para a competição! &#128170;<br/><h2><b>Desafios</b></h2><h4><a href=\https://bit.ly/3bJBNaA\ target=\_blank\>Desafio 1</a></h4><h4><a href=\https://bit.ly/2Rnuy03\ target=\_blank\>Desafio 2</a></h4><h4><a href=\https://bit.ly/2wKmZJW\ target=\_blank\>Desafio 3</a></h4><h4><a href=\http://tiny.cc/Desafio4\ target=\_blank\>Desafio 4</a></h4><h4><a href=\http://tiny.cc/DESAFIO5\ target=\_blank\>Desafio 5</a></h4><h4><a href=\http://tiny.cc/Desafio6\ target=\_blank\>Desafio 6</a></h4><h4><a href=\http://tiny.cc/Desafio7\ target=\_blank\>Desafio 7</a></h4>', 94, '2020-03-30 00:00:00', '2020-05-13 00:00:00', 94, 1),
	(24, '/news/pleiathome.png', 'ACTIVE', 'PLEIATHOME', 'EVENT', 'O PL<b style=\color: #59CD00\>EI</b>ATHOME é um conjunto de mini-torneios de jogos online que se vão desenrolar ao longo do semestre. As equipas acumulam \pontos PLEIATHOME\ ao longo dos mini-torneios, sendo que os vencedores finais ganham prémios!<br/>Organiza a tua equipa e vai participar em mais uma saga AtHome do NEI!Podes consultar o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_PLEIATHOME.pdf\ target=\_blank\>regulamento</a> do evento.<br/><br/><b><big>FIRST TOURNAMENT</big></b><br/>KABOOM!! Chegou o primeiro torneio da competição PL<b style=\color: #59CD00\>EI</b>ATHOME, com o jogo Bombtag!<br/>O mini-torneio terá início dia 10 de abril pelas 19h, inscreve-te neste <a href=\https://bit.ly/3dXrAsU\ target=\_blank\>formulário</a> do Kaboom.<br/>E consulta o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_Kaboom.pdf\ target=\_blank\>regulamento</a> do Kaboom.<br/>Vamos lá!<br/><br/><b><big>SECOND TOURNAMENT</big></b><br/>SpeedTux &#128039;&#128168; Chegou o segundo torneio PL<b style=\color: #59CD00\>EI</b>ATHOME, com o clássico SuperTux!<br/>O mini-torneio terá início dia 24 de abril, pelas 19h. Inscreve-te neste <a href=\https://bit.ly/34ClZE3\ target=\_blank\>formulário</a> até às 12h desse mesmo dia. E consulta o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_SpeedTux.pdf\ target=\_blank\>regulamento</a> do SpeedTux.<br/>Estás à altura? &#128170;<br/><br/><b><big>THIRD TOURNAMENT</big></b><br/>Races à La Kart! Chegou mais um torneio PL<b style=\color: #59CD00\>EI</b>ATHOME, com o famoso TrackMania!<br/>O mini-torneio terá início dia 8 de maio (sexta-feira) pelas 19h, inscreve-te no <a href=\tiny.cc/racesalakart\ target=\_blank\>formulário</a> e consulta o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_Races_a_la_KART.pdf\ target=\_blank\>regulamento</a>.<br/>Descobre se és o mais rápido! &#127988;', 94, '2020-04-06 00:00:00', '2020-05-04 00:00:00', 94, 1),
	(25, '/news/nei_lol.png', 'ACTIVE', 'Torneio Nacional de LoL', 'EVENT', 'Como a vida não é só trabalho, vem divertir-te a jogar e representar a Universidade de Aveiro em simultâneo! O NEEEC-FEUP está a organizar um torneio de League of Legends inter-universidades a nível nacional, e a UA está apta para participar.<br/>Existirá uma ronda de qualificação em Aveiro para determinar as 2 equipas que participam nacionalmente. O torneio é de inscrição gratuita e garante prémios para as equipas que conquistem o 1º e 2º lugar!<br/>Forma equipa e mostra o que vales!<br/><a href=\http://tiny.cc/torneioLOL\ target=\_blank\>Inscreve-te</a>!', 94, '2020-05-13 00:00:00', NULL, NULL, 1),
	(26, '/news/202122/96.jpg', 'ACTIVE', 'Roots Beach Club', 'EVENT', '<p>A primeira semana de aulas vai terminar em grande!</p><p>Na sexta-feira vem ao Roots Beach Club para uma beach party incrível.</p><p>A pulseira do evento garante o transporte desde Aveiro até à Praia da Barra, um teste antigénio à covid e a entrada no bar com uma bebida incluída!</p><p>Reserva a tua pulseira terça feira das 16h às 19h na sala 4.1.32.</p>', 83, '2021-10-10 00:00:00', NULL, NULL, 1);


--
-- Data for Name: note; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.note (id, author_id, subject_id, teacher_id, name, location, year, summary, tests, bibliography, slides, exercises, projects, notebook, content, created_at, size) VALUES
	(1, NULL, 40337, 5, 'MPEI Exemplo Teste 2014', '/notes/segundo_ano/primeiro_semestre/mpei/MP_Exemplo_Teste.pdf', 2014, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
	(2, 101, 40337, 4, 'Diversos - 2017/2018 (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/RafaelDireito_2017_2018_MPEI.zip', 2017, 1, 0, 1, 1, 1, 0, 0, NULL, '2021-06-14 19:17:30', 35),
	(3, 19, 40337, 5, 'Resumos Teóricos (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/Resumos_Teoricas.zip', 2014, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos_Teóricas</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 8),
	(4, 49, 40379, 27, 'Resumos FP 2018/2019 (zip)', '/notes/primeiro_ano/primeiro_semestre/fp/Goncalo_FP.zip', 2018, 1, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aulas Práticas</dt><dd><dd>148 pastas</dd><dd>132 ficheiros</dd><dd></dl><dl><dt>Resumos</dt><dd><dd>1 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Testes para praticar</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Visualize Cod...</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 30),
	(5, 101, 40379, NULL, 'Material FP 2016/2017 (zip)', '/notes/primeiro_ano/primeiro_semestre/fp/RafaelDireito_FP_16_17.zip', 2016, 1, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>34 pastas</dd><dd>30 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 14),
	(6, NULL, 40379, NULL, 'Resoluções 18/19', '/notes/primeiro_ano/primeiro_semestre/fp/resolucoes18_19.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>18-19</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(7, NULL, 40380, 8, 'Apontamentos Globais', '/notes/primeiro_ano/primeiro_semestre/itw/apontamentos001.pdf', NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 3),
	(8, NULL, 40381, NULL, 'Questões de SO (zip)', '/notes/segundo_ano/primeiro_semestre/so/Questões.zip', 2015, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Quest?es</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(9, 101, 40381, 1, 'Diversos - 2017/2018 (zip)', '/notes/segundo_ano/primeiro_semestre/so/RafaelDireito_2017_2018_SO.zip', 2017, 1, 0, 0, 1, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>46 pastas</dd><dd>43 ficheiros</dd><dd></dl><dl><dt>Rafael_Diteit...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 35),
	(10, 66, 40383, 12, 'Apontamentos Diversos (zip)', '/notes/segundo_ano/segundo_semestre/pds/JoaoAlegria_PDS.zip', 2015, 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_R...</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>JoaoAlegria_E...</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 6),
	(11, 66, 40383, 12, 'Resumos de 2015/2016', '/notes/segundo_ano/segundo_semestre/pds/pds_apontamentos_001.pdf', 2015, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 4),
	(12, NULL, 40383, NULL, 'Apontamentos genéricos I', '/notes/segundo_ano/segundo_semestre/pds/pds_apontamentos_002.pdf', NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
	(13, NULL, 40383, NULL, 'Apontamentos genéricos II', '/notes/segundo_ano/segundo_semestre/pds/pds_apontamentos_003.pdf', NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
	(14, 54, 40385, 12, 'Diversos - CBD Prof. JLO (zip)', '/notes/terceiro_ano/primeiro_semestre/cbd/InesCorreia_CBD(CC_JLO).zip', NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>InesCorreia_C...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2),
	(15, 10, 40431, 13, 'MAS 2014/2015 (zip)', '/notes/primeiro_ano/segundo_semestre/mas/BarbaraJael_14_15_MAS.zip', 2014, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>resumo-mas.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 14),
	(16, 40, 40431, 13, 'Preparação para Exame Final de MAS', '/notes/primeiro_ano/segundo_semestre/mas/Duarte_MAS.pdf', 2018, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
	(17, 101, 40431, 13, 'MAS 2016/2017 (zip)', '/notes/primeiro_ano/segundo_semestre/mas/RafaelDireito_2016_2017_MAS.zip', 2016, 1, 0, 1, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 19),
	(18, 15, 40431, 13, 'Resumos_MAS', '/notes/primeiro_ano/segundo_semestre/mas/Resumos_MAS_Carina.zip', 2017, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>MAS_Resumos.pdf</dt><dd><dd></dl><dl><dt>MAS_Resumos2.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 8),
	(19, NULL, 40432, NULL, 'Resolução das fichas (zip)', '/notes/segundo_ano/primeiro_semestre/smu/Resoluçao_das_fichas.zip', NULL, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resoluçao das fichas</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 27),
	(20, NULL, 40432, NULL, 'Resumos (zip)', '/notes/segundo_ano/primeiro_semestre/smu/Resumo.zip', NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 116),
	(21, 10, 40432, 26, 'Resumos de 2013/2014', '/notes/segundo_ano/primeiro_semestre/smu/smu_apontamentos_001.pdf', 2013, 1, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 11),
	(22, 19, 40432, 15, 'Resumos de 2016/2017', '/notes/segundo_ano/primeiro_semestre/smu/smu_apontamentos_002.pdf', 2016, 1, 1, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 2),
	(23, 111, 40432, 15, 'Resumos de 2017/2018', '/notes/segundo_ano/primeiro_semestre/smu/smu_apontamentos_003.pdf', 2017, 1, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 7),
	(24, NULL, 40432, NULL, 'Resumos 2018/19', '/notes/segundo_ano/primeiro_semestre/smu/SMU_Resumos.pdf', NULL, 1, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 4),
	(25, NULL, 40433, NULL, 'Resumos (zip)', '/notes/segundo_ano/primeiro_semestre/rs/Resumo.zip', NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 24),
	(26, 10, 40433, 16, 'Caderno', '/notes/segundo_ano/primeiro_semestre/rs/rs_apontamentos_001.pdf', 2014, 1, 0, 0, 0, 1, 0, 1, NULL, '2021-06-14 19:17:30', 6),
	(27, 15, 40436, 31, 'Resumos_POO', '/notes/primeiro_ano/segundo_semestre/poo/Carina_POO_Resumos.zip', 2017, 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>POO_Resumos_OT.pdf</dt><dd><dd></dl><dl><dt>POO_Resumos.pdf</dt><dd><dd></dl><dl><dt>POO_resumos_v2.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 6),
	(28, 49, 40436, 28, 'Resumos POO 2018/2019 (zip)', '/notes/primeiro_ano/segundo_semestre/poo/Goncalo_POO.zip', 2018, 1, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Apontamentos</dt><dd><dd>1 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Aulas Práticas</dt><dd><dd>17 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 4),
	(29, 101, 40436, NULL, 'Diversos - Prática e Teórica (zip)', '/notes/primeiro_ano/segundo_semestre/poo/RafaelDireito_2016_2017_POO.zip', 2016, 1, 1, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>495 pastas</dd><dd>492 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 43),
	(30, NULL, 40436, NULL, 'Resumos Teóricos (zip)', '/notes/primeiro_ano/segundo_semestre/poo/Resumos.zip', NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 22),
	(31, 19, 40437, 17, 'Resumos de 2016/2017', '/notes/segundo_ano/primeiro_semestre/aed/aed_apontamentos_001.pdf', 2016, 1, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 5),
	(32, NULL, 40437, NULL, 'Bibliografia (zip)', '/notes/segundo_ano/primeiro_semestre/aed/bibliografia.zip', NULL, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Linguagem C -...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 33),
	(33, 66, 40751, NULL, 'Resumos 2016/2017', '/notes/mestrado/aa/aa_apontamentos_001.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
	(34, 66, 40752, NULL, 'Exames 2017/2018', '/notes/mestrado/tai/tai_apontamentos_001.pdf', 2017, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
	(35, 66, 40752, NULL, 'Teste Modelo 2016/2017', '/notes/mestrado/tai/tai_apontamentos_002.pdf', 2016, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 3),
	(36, 66, 40752, NULL, 'Ficha de Exercícios 1 - 2016/2017', '/notes/mestrado/tai/tai_apontamentos_003.pdf', 2016, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 5),
	(37, 66, 40752, NULL, 'Ficha de Exercícios 2 - 2016/2017', '/notes/mestrado/tai/tai_apontamentos_004.pdf', 2016, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 3),
	(38, 66, 40753, NULL, 'Resumos 2016/2017', '/notes/mestrado/cle/cle_apontamentos_001.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 12),
	(39, 66, 40756, NULL, 'Resumos 2016/2017', '/notes/mestrado/gic/gic_apontamentos_001.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 12),
	(40, 19, 40846, 30, 'Resumos 2017/2018', '/notes/terceiro_ano/primeiro_semestre/ia/ia_apontamentos_002.pdf', 2017, 1, 1, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 6),
	(41, NULL, 41469, 10, 'Aulas Teóricas (zip)', '/notes/segundo_ano/segundo_semestre/c/Aulas_Teóricas.zip', 2015, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aulas Teóricas</dt><dd><dd>41 pastas</dd><dd>27 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 6),
	(42, NULL, 41469, NULL, 'Guião de preparacao para o teste prático (zip)', '/notes/segundo_ano/segundo_semestre/c/Guião_de_preparacao_para_o_teste_pratico.zip', NULL, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Gui?o de prep...</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(43, NULL, 41549, NULL, 'Apontamentos Diversos (zip)', '/notes/segundo_ano/segundo_semestre/ihc/Apontamentos.zip', NULL, 1, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Apontamentos</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 16),
	(44, 66, 41549, 9, 'Avaliação Heurística', '/notes/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_001.pdf', 2014, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
	(45, 10, 41549, 9, 'Resumos de 2014/2015', '/notes/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_002.pdf', 2014, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 3),
	(46, NULL, 41549, 9, 'Resolução de fichas (zip)', '/notes/segundo_ano/segundo_semestre/ihc/Resolução_de_fichas.zip', NULL, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resoluç?o de fichas</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 14),
	(47, 10, 41791, NULL, 'Apontamentos EF (zip)', '/notes/primeiro_ano/primeiro_semestre/ef/BarbaraJael_EF.zip', 2014, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>BarbaraJael_1...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 4),
	(48, 101, 41791, 24, 'Exercícios 2017/2018', '/notes/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_001.pdf', 2017, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
	(49, 101, 41791, NULL, 'Exercícios 2016/17', '/notes/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_002.pdf', 2016, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 7),
	(50, 49, 41791, 29, 'Resumos EF 2018/2019 (zip)', '/notes/primeiro_ano/primeiro_semestre/ef/Goncalo_EF.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Documento_Obt...pdf</dt><dd><dd></dl><dl><dt>Documento_Tra...pdf</dt><dd><dd></dl><dl><dt>P4_7-12.pdf</dt><dd><dd></dl><dl><dt>PL1_Ótica.pdf</dt><dd><dd></dl><dl><dt>PL2_Pêndulo E...pdf</dt><dd><dd></dl><dl><dt>PL2_Pêndulo E...jpg</dt><dd><dd></dl><dl><dt>PL2_Pêndulo E...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração.pdf</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL4_Relatório.pdf</dt><dd><dd></dl><dl><dt>PL_Pauta Final.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 5),
	(51, 96, 41791, 29, 'Exercícios 2018/19', '/notes/primeiro_ano/primeiro_semestre/ef/Pedro_Oliveira_2018_2019.zip', 2018, 0, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pedro Oliveira</dt><dd><dd>6 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 28),
	(52, 96, 42502, 6, 'Apontamentos e Resoluções (zip)', '/notes/primeiro_ano/segundo_semestre/iac/PedroOliveira.zip', 2017, 0, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pedro Oliveira</dt><dd><dd>10 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 23),
	(53, 19, 42532, 7, 'Caderno - 2016/2017', '/notes/segundo_ano/segundo_semestre/bd/bd_apontamentos_001.pdf', 2016, 1, 0, 0, 0, 1, 0, 1, NULL, '2021-06-14 19:17:30', 2),
	(54, 66, 42532, 7, 'Resumos - 2014/2015', '/notes/segundo_ano/segundo_semestre/bd/bd_apontamentos_002.pdf', 2014, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
	(55, NULL, 42532, 7, 'Resumos globais', '/notes/segundo_ano/segundo_semestre/bd/BD_Resumos.pdf', NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 8),
	(56, NULL, 42532, 7, 'Slides das Aulas Teóricas (zip)', '/notes/segundo_ano/segundo_semestre/bd/Slides_Teoricas.zip', 2014, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides_Teoricas</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 21),
	(57, NULL, 42573, NULL, 'Outros Resumos (zip)', '/notes/terceiro_ano/primeiro_semestre/sio/Outros_Resumos.zip', NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Outros Resumos</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 3),
	(58, NULL, 42573, NULL, 'Resumo geral de segurança I', '/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_001.pdf', NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
	(59, NULL, 42573, NULL, 'Resumo geral de segurança II', '/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_002.pdf', NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
	(60, 10, 42573, 3, 'Resumos de 2015/2016', '/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_003.pdf', 2015, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 8),
	(61, NULL, 42573, NULL, 'Resumo geral de segurança III', '/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_004.pdf', NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
	(62, NULL, 42573, NULL, 'Apontamentos genéricos', '/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_005.pdf', NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
	(63, 19, 42709, 23, 'Resumos de ALGA (zip)', '/notes/primeiro_ano/primeiro_semestre/alga/Carolina_Albuquerque_ALGA.zip', 2015, 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>ALGA - Resumo...pdf</dt><dd><dd></dl><dl><dt>Exemplos da i...pdf</dt><dd><dd></dl><dl><dt>Exemplos de m...pdf</dt><dd><dd></dl><dl><dt>Exemplos de m...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 59),
	(64, 36, 42709, 23, 'ALGA 2017/2018 (zip)', '/notes/primeiro_ano/primeiro_semestre/alga/DiogoSilva_17_18_ALGA.zip', 2017, 0, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>DiogoSilva_17...</dt><dd><dd>0 pastas</dd><dd>26 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 21),
	(65, 49, 42709, 19, 'Resumos ALGA 2018/2019 (zip)', '/notes/primeiro_ano/primeiro_semestre/alga/Goncalo_ALGA.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_Matrizes e ...pdf</dt><dd><dd></dl><dl><dt>2_Determinantes.pdf</dt><dd><dd></dl><dl><dt>3_Vetores, re...pdf</dt><dd><dd></dl><dl><dt>4_Espaços vet...pdf</dt><dd><dd></dl><dl><dt>5_Valores e v...pdf</dt><dd><dd></dl><dl><dt>6_Cónicas e q...pdf</dt><dd><dd></dl><dl><dt>7_Aplicações ...pdf</dt><dd><dd></dl><dl><dt>Complemento_C...pdf</dt><dd><dd></dl><dl><dt>Complemento_C...pdf</dt><dd><dd></dl><dl><dt>Resumo Teste ...pdf</dt><dd><dd></dl><dl><dt>Resumo Teste ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 41),
	(66, 94, 42728, 21, 'Resumos 2016/2017', '/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_001.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 16),
	(67, 111, 42728, 21, 'Resumos 2016/2017', '/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_002.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 5),
	(346, 104, 41469, 10, 'Práticas e projeto C', 'https://github.com/Rui-FMF/C', 2019, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(68, 101, 42728, 21, 'Teste Primitivas 2016/2017', '/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_003.pdf', 2016, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
	(69, 101, 42728, 21, 'Exercícios 2016/2017', '/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_004.pdf', 2016, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 5),
	(70, 101, 42728, 21, 'Resumos 2016/2017', '/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_005.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 11),
	(71, 101, 42728, 21, 'Fichas 2016/2017', '/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_006.pdf', 2016, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 22),
	(72, 36, 42728, 21, 'CI 2017/2018 (zip)', '/notes/primeiro_ano/primeiro_semestre/c1/DiogoSilva_17_18_C1.zip', 2017, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>28821701_4498...jpg</dt><dd><dd></dl><dl><dt>28768155_4497...jpg</dt><dd><dd></dl><dl><dt>28927694_4497...jpg</dt><dd><dd></dl><dl><dt>28821773_4497...jpg</dt><dd><dd></dl><dl><dt>28876807_4497...jpg</dt><dd><dd></dl><dl><dt>28879472_4497...jpg</dt><dd><dd></dl><dl><dt>28822131_4497...jpg</dt><dd><dd></dl><dl><dt>28768108_4497...jpg</dt><dd><dd></dl><dl><dt>28811040_4497...jpg</dt><dd><dd></dl><dl><dt>28943154_4497...jpg</dt><dd><dd></dl><dl><dt>28879660_4497...jpg</dt><dd><dd></dl><dl><dt>28876653_4497...jpg</dt><dd><dd></dl><dl><dt>28768432_4497...jpg</dt><dd><dd></dl><dl><dt>28768056_4497...jpg</dt><dd><dd></dl><dl><dt>28877054_4497...jpg</dt><dd><dd></dl><dl><dt>28768634_4497...jpg</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2),
	(73, 49, 42728, 18, 'Resumos Cálculo I 2018/2019 (zip)', '/notes/primeiro_ano/primeiro_semestre/c1/Goncalo_C1.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>0_Formulário_...pdf</dt><dd><dd></dl><dl><dt>0_FORMULÁRIO_...pdf</dt><dd><dd></dl><dl><dt>0_Revisões se...pdf</dt><dd><dd></dl><dl><dt>1_Funções tri...pdf</dt><dd><dd></dl><dl><dt>2_Teoremas do...pdf</dt><dd><dd></dl><dl><dt>3_Integrais i...pdf</dt><dd><dd></dl><dl><dt>4_Integrais d...pdf</dt><dd><dd></dl><dl><dt>5_Integrais i...pdf</dt><dd><dd></dl><dl><dt>6_Séries numé...pdf</dt><dd><dd></dl><dl><dt>Formulário_Sé...pdf</dt><dd><dd></dl><dl><dt>Resumo_Integr...pdf</dt><dd><dd></dl><dl><dt>Tópicos_Teste 1.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 24),
	(74, 94, 42729, 22, 'Caderno de 2016/2017', '/notes/primeiro_ano/segundo_semestre/c2/calculoii_apontamentos_003.pdf', 2016, 0, 0, 0, 0, 0, 0, 1, NULL, '2021-06-14 19:17:30', 18),
	(75, 49, 42729, 19, 'Resumos Cálculo II 2018/2019 (zip)', '/notes/primeiro_ano/segundo_semestre/c2/Goncalo_C2.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>0_Revisões.pdf</dt><dd><dd></dl><dl><dt>1_Séries de p...pdf</dt><dd><dd></dl><dl><dt>2_Sucessões e...pdf</dt><dd><dd></dl><dl><dt>3.1_Funções r...pdf</dt><dd><dd></dl><dl><dt>3.2_Funções r...pdf</dt><dd><dd></dl><dl><dt>4_Equações di...pdf</dt><dd><dd></dl><dl><dt>5_Transformad...pdf</dt><dd><dd></dl><dl><dt>Detalhes para...pdf</dt><dd><dd></dl><dl><dt>Detalhes para...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 21),
	(76, 66, 44156, 9, 'Resumos 2016/2017', '/notes/mestrado/vi/vi_apontamentos_001.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 4),
	(77, 66, 44130, 25, 'Resumos por capítulo (zip)', '/notes/mestrado/ws/JoaoAlegria_ResumosPorCapítulo.zip', 2016, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_R...</dt><dd><dd>0 pastas</dd><dd>10 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 8),
	(78, 66, 44130, 25, 'Resumos 2016/2017', '/notes/mestrado/ws/web_semantica_apontamentos_001.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 9),
	(79, 54, 45424, NULL, 'Apontamentos Diversos', '/notes/terceiro_ano/primeiro_semestre/icm/Inês_Correia_ICM.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
	(80, 54, 45426, 13, 'Apontamentos Diversos', '/notes/terceiro_ano/segundo_semestre/tqs/Inês_Correia_TQS.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 14),
	(81, NULL, 45426, 13, 'Resumos (zip)', '/notes/terceiro_ano/segundo_semestre/tqs/resumos.zip', 2016, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos_chave</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 22),
	(82, 66, 45426, 13, 'Resumos 2015/2016', '/notes/terceiro_ano/segundo_semestre/tqs/tqs_apontamentos_002.pdf', 2015, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 3),
	(83, 66, 45587, 26, 'Resumos 2017/2018 - I', '/notes/mestrado/ed/ed_dm_apontamentos_001.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 36),
	(84, 66, 45587, 26, 'Resumos 2017/2018 - II', '/notes/mestrado/ed/ed_dm_apontamentos_002.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 48),
	(85, 49, 47166, 20, 'Resumos MD 2018/2019 (zip)', '/notes/primeiro_ano/segundo_semestre/md/Goncalo_MD.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1.1_Lógica pr...pdf</dt><dd><dd></dl><dl><dt>1.2_Conjuntos.pdf</dt><dd><dd></dl><dl><dt>1.3_Relações ...pdf</dt><dd><dd></dl><dl><dt>1.4_Funções.pdf</dt><dd><dd></dl><dl><dt>1.5_Relações ...pdf</dt><dd><dd></dl><dl><dt>1.6_Lógica de...pdf</dt><dd><dd></dl><dl><dt>2_Contextos e...pdf</dt><dd><dd></dl><dl><dt>3_Princípios ...pdf</dt><dd><dd></dl><dl><dt>4_Permutações.pdf</dt><dd><dd></dl><dl><dt>5_Agrupamento...pdf</dt><dd><dd></dl><dl><dt>6_Recorrência...pdf</dt><dd><dd></dl><dl><dt>7_Elementos d...pdf</dt><dd><dd></dl><dl><dt>Detalhes capí...pdf</dt><dd><dd></dl><dl><dt>Detalhes capí...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 27),
	(86, 15, 47166, NULL, 'Resumos 2017/2018', '/notes/primeiro_ano/segundo_semestre/md/MD_Capitulo5.pdf', 2017, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 4),
	(87, 101, 47166, NULL, 'RafaelDireito_2016_2017_MD.zip', '/notes/primeiro_ano/segundo_semestre/mdmorphine/RafaelDireito_2016_2017_MD.zip', 2016, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>11 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 24),
	(88, 101, 47166, NULL, 'RafaelDireito_MD_16_17_Apontamentos (zip)', '/notes/primeiro_ano/segundo_semestre/md/RafaelDireito_MD_16_17_Apontamentos.zip', 2016, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 4),
	(89, 36, 40337, 4, 'DS_MPEI_18_19_Testes (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Testes.zip', 2018, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Enunciados</dt><dd><dd>5 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>Teste 1 2015</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Teste 2 2015</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Teste 2 2017</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 23),
	(115, 36, 40383, 12, 'DS_PDS_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_SlidesTeoricos.zip', 2018, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>PDS_0.pdf</dt><dd><dd></dl><dl><dt>PDS_09_Lambda...pdf</dt><dd><dd></dl><dl><dt>PDS_1_Softwar...pdf</dt><dd><dd></dl><dl><dt>PDS_2_GRASP.pdf</dt><dd><dd></dl><dl><dt>PDS_3_Pattern...pdf</dt><dd><dd></dl><dl><dt>PDS_4_Creatio...pdf</dt><dd><dd></dl><dl><dt>PDS_5_Structu...pdf</dt><dd><dd></dl><dl><dt>PDS_6_Behavio...pdf</dt><dd><dd></dl><dl><dt>PDS_7_Softwar...pdf</dt><dd><dd></dl><dl><dt>PDS_8_Reflection.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 81),
	(90, 36, 40337, 4, 'DS_MPEI_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_SlidesTeoricos.zip', 2018, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>MPEI-2017-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2017-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 27),
	(91, 36, 40337, 4, 'DS_MPEI_18_19_Resumos (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Resumos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo1</dt><dd><dd>0 pastas</dd><dd>39 ficheiros</dd><dd></dl><dl><dt>Resumo2</dt><dd><dd>0 pastas</dd><dd>24 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 209),
	(92, 36, 40337, 4, 'DS_MPEI_18_19_Projeto (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Projeto.zip', 2018, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>mpei.pptx</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 16),
	(93, 36, 40337, 4, 'DS_MPEI_18_19_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Praticas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P01</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>P02</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P03</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>P04</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>P05</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P06</dt><dd><dd>0 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>P07</dt><dd><dd>0 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>P08</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>Remakes</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 9),
	(94, 36, 40337, 4, 'DS_MPEI_18_19_Livros (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Livros.zip', 2018, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>estatistica-f...pdf</dt><dd><dd></dl><dl><dt>Livro.pdf</dt><dd><dd></dl><dl><dt>matlabnuminst...pdf</dt><dd><dd></dl><dl><dt>MATLAB_Starte...pdf</dt><dd><dd></dl><dl><dt>pt.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 6),
	(95, 36, 40337, 4, 'DS_MPEI_18_19_Exercicios (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Exercicios.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>2</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>3</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Slides Exercicios</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 37),
	(96, 49, 40380, 8, 'Goncalo_ITW_18_19_Testes (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Testes.zip', 2018, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P7 05_Nov_201...</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>Teste teórico 1.zip</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(97, 49, 40380, 8, 'Goncalo_ITW_18_19_Resumos (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Resumos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>ITW _ BOOTSTRAP.pdf</dt><dd><dd></dl><dl><dt>ITW _ CSS.pdf</dt><dd><dd></dl><dl><dt>ITW _ HTML.pdf</dt><dd><dd></dl><dl><dt>ITW _ JAVASCRIPT.pdf</dt><dd><dd></dl><dl><dt>JAVACRIPT _ E...pdf</dt><dd><dd></dl><dl><dt>JAVACRIPT _P6...pdf</dt><dd><dd></dl><dl><dt>Resumo_T10_Kn...pdf</dt><dd><dd></dl><dl><dt>Resumo_T11_Du...pdf</dt><dd><dd></dl><dl><dt>Resumo_T8_jQu...pdf</dt><dd><dd></dl><dl><dt>Resumo_T9_Goo...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 12),
	(98, 49, 40380, 8, 'Goncalo_ITW_18_19_Projeto (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Projeto.zip', 2018, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>P11 03_Nov_20...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>PROJETO</dt><dd><dd>147 pastas</dd><dd>147 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 33),
	(99, 49, 40380, 8, 'Goncalo_ITW_18_19_Praticas (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Praticas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P1 24_Set_2018</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P10 26_Nov_20...</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P11 03_Nov_20...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>P2 01_Out_2018</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>P3 08_Out_2018</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P4 15_Out_2018</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>P5 22_Out_2018</dt><dd><dd>1 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>P6 29_Out_2018</dt><dd><dd>1 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>P7 05_Nov_201...</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>P8 12_Nov_2018</dt><dd><dd>0 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>P9 19_Nov_201...</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 30),
	(100, 101, 40380, 8, 'RafaelDireito_ITW_18_19_Testes (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Testes.zip', 2016, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bootstrap+Tes...rar</dt><dd><dd></dl><dl><dt>Teste Prático ITW</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>Teste Teórico 2</dt><dd><dd>0 pastas</dd><dd>20 ficheiros</dd><dd></dl><dl><dt>Teste_Prático_ITW</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>Teste_Prático...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>ITW-Teste Teórico</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>ITW_Teste</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 9),
	(101, 101, 40380, 8, 'RafaelDireito_ITW_18_19_Slides (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Slides.zip', 2016, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aula 1 - Apre...pdf</dt><dd><dd></dl><dl><dt>Aula 1 -Intro...pdf</dt><dd><dd></dl><dl><dt>Aula 10 - Goo...pdf</dt><dd><dd></dl><dl><dt>Aula 11 - ITW...pdf</dt><dd><dd></dl><dl><dt>Aula 11 - Tra...pdf</dt><dd><dd></dl><dl><dt>Aula 2 - Form...pdf</dt><dd><dd></dl><dl><dt>Aula 3 - CSS.pdf</dt><dd><dd></dl><dl><dt>Aula 4 -Twitt...pdf</dt><dd><dd></dl><dl><dt>Aula 5 -Javas...pdf</dt><dd><dd></dl><dl><dt>Aula 7 -Javas...pdf</dt><dd><dd></dl><dl><dt>Aula 8 -JQuery.pdf</dt><dd><dd></dl><dl><dt>Aula 9 -JQuer...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 19),
	(116, 36, 40383, 12, 'DS_PDS_18_19_Resumos (zip)', '/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Resumos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo 1</dt><dd><dd>0 pastas</dd><dd>35 ficheiros</dd><dd></dl><dl><dt>Resumo 2</dt><dd><dd>0 pastas</dd><dd>25 ficheiros</dd><dd></dl><dl><dt>Resumo 3</dt><dd><dd>0 pastas</dd><dd>25 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 185),
	(118, NULL, 40431, NULL, 'MAS_18_19_Bibliografia (zip)', '/notes/primeiro_ano/segundo_semestre/mas/MAS_18_19_Bibliografia.zip', NULL, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bibliografia_...pdf</dt><dd><dd></dl><dl><dt>Bibliografia_...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 6),
	(102, 101, 40380, 8, 'RafaelDireito_ITW_18_19_Praticas (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Praticas.zip', 2016, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aula 8</dt><dd><dd>3 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Aula5-Js</dt><dd><dd>1 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>Aulas Práticas</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>Bilhete-Aviao</dt><dd><dd>6 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Calculadora-JS</dt><dd><dd>2 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Concerto- GER...</dt><dd><dd>3 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>Concerto-Jquery</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Concerto-Jque...</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Concerto-JS</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Conferencia</dt><dd><dd>6 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Gráficos</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>ITW java</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>ITW-Bootstrap_1</dt><dd><dd>20 pastas</dd><dd>26 ficheiros</dd><dd></dl><dl><dt>ITW_jQuery</dt><dd><dd>3 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Links de Apoi...txt</dt><dd><dd></dl><dl><dt>Mapa</dt><dd><dd>3 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Treino-ITW-2</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Weather</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>GitHub-  stor.txt</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 18),
	(103, 36, 40381, 1, 'DS_SO_18_19_Testes (zip)', '/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Testes.zip', 2018, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Enunciados</dt><dd><dd>1 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Teorico-Pratico</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Teste 2015</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Teste 2017</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 46),
	(104, 36, 40381, 1, 'DS_SO_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_SlidesTeoricos.zip', 2018, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>sop_1819_0918...pdf</dt><dd><dd></dl><dl><dt>sop_1819_1002...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1023...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1030...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1106...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1120...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1127...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1204...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1211...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1218...ppt</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 11),
	(105, 36, 40381, 1, 'DS_SO_18_19_ResumosTeoricos (zip)', '/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_ResumosTeoricos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Teorico</dt><dd><dd>0 pastas</dd><dd>43 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 157),
	(106, 36, 40381, 1, 'DS_SO_18_19_ResumosPraticos (zip)', '/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_ResumosPraticos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pratico</dt><dd><dd>0 pastas</dd><dd>38 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 122),
	(107, 36, 40381, 1, 'DS_SO_18_19_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Praticas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P01</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P02</dt><dd><dd>1 pastas</dd><dd>24 ficheiros</dd><dd></dl><dl><dt>P03</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P04</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>P05</dt><dd><dd>2 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>P06</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P07</dt><dd><dd>0 pastas</dd><dd>10 ficheiros</dd><dd></dl><dl><dt>P08</dt><dd><dd>1 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P09</dt><dd><dd>7 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P10</dt><dd><dd>3 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>P11</dt><dd><dd>1 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Remakes</dt><dd><dd>24 pastas</dd><dd>18 ficheiros</dd><dd></dl><dl><dt>Remakes2</dt><dd><dd>9 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 5),
	(108, 36, 40381, 1, 'DS_SO_18_19_Fichas (zip)', '/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Fichas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Enunciados</dt><dd><dd>10 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Ficha 1</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>Ficha 2</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Ficha 3</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Ficha NEI 1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Ficha NEI 2</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Ficha NEI 4</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 51),
	(109, NULL, 40382, NULL, 'CD_18_19_Livros (zip)', '/notes/segundo_ano/segundo_semestre/cd/CD_18_19_Livros.zip', NULL, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Distributed_S...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 19),
	(110, 36, 40382, 2, 'DS_CD_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_SlidesTeoricos.zip', 2018, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aula 1.pdf</dt><dd><dd></dl><dl><dt>Aula 2.pdf</dt><dd><dd></dl><dl><dt>Aula 3.pdf</dt><dd><dd></dl><dl><dt>Aula 4.pdf</dt><dd><dd></dl><dl><dt>Aula 6.pdf</dt><dd><dd></dl><dl><dt>Aula 7.pdf</dt><dd><dd></dl><dl><dt>Aula 8.pdf</dt><dd><dd></dl><dl><dt>Cloud Computing.pdf</dt><dd><dd></dl><dl><dt>Flask.pdf</dt><dd><dd></dl><dl><dt>Syllabus.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 32),
	(111, 36, 40382, 2, 'DS_CD_18_19_Resumos (zip)', '/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Resumos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>CDresumoch6.docx</dt><dd><dd></dl><dl><dt>CDresumoch6.pdf</dt><dd><dd></dl><dl><dt>CDresumoch7.docx</dt><dd><dd></dl><dl><dt>CDresumoch7.pdf</dt><dd><dd></dl><dl><dt>CDresumoch8.docx</dt><dd><dd></dl><dl><dt>GIT 101.pdf</dt><dd><dd></dl><dl><dt>Resumo Ch1-4</dt><dd><dd>0 pastas</dd><dd>104 ficheiros</dd><dd></dl><dl><dt>Resumos Ch5-8</dt><dd><dd>0 pastas</dd><dd>34 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 309),
	(112, 36, 40382, 2, 'DS_CD_18_19_Projetos (zip)', '/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Projetos.zip', 2018, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>Projeto 1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Projeto 2</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(113, 36, 40382, 2, 'DS_CD_18_19_Praticas (zip)', '/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Praticas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P01</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>P02</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P03</dt><dd><dd>36 pastas</dd><dd>36 ficheiros</dd><dd></dl><dl><dt>P04</dt><dd><dd>6 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 3),
	(114, 36, 40383, 12, 'DS_PDS_18_19_Testes (zip)', '/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Testes.zip', 2018, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Teste 2019</dt><dd><dd>0 pastas</dd><dd>26 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(117, 36, 40383, 12, 'DS_PDS_18_19_Praticas (zip)', '/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Praticas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Guioes</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>pds_2019_g22</dt><dd><dd>70 pastas</dd><dd>61 ficheiros</dd><dd></dl><dl><dt>PraticasRemade</dt><dd><dd>277 pastas</dd><dd>276 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 6),
	(119, NULL, 40431, 13, 'MAS_18_19_Topicos_Estudo_Exame (zip)', '/notes/primeiro_ano/segundo_semestre/mas/MAS_18_19_Topicos_Estudo_Exame.zip', 2018, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>MAS 201819 - ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(120, 49, 40431, 13, 'Goncalo_MAS_18_19_Resumos (zip)', '/notes/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Resumos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1. O que é qu...pdf</dt><dd><dd></dl><dl><dt>2. Modelos de...pdf</dt><dd><dd></dl><dl><dt>3. Modelos no...pdf</dt><dd><dd></dl><dl><dt>MAA_Resumos.pdf</dt><dd><dd></dl><dl><dt>Post-it.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 10),
	(121, 49, 40431, 13, 'Goncalo_MAS_18_19_Projeto (zip)', '/notes/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Projeto.zip', 2018, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>AMS-E3-Visao ...docx</dt><dd><dd></dl><dl><dt>Apresentacion...pdf</dt><dd><dd></dl><dl><dt>Apresentaç?o ...odt</dt><dd><dd></dl><dl><dt>CalEntregas.png</dt><dd><dd></dl><dl><dt>Elaboration 1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Gui?o.pdf</dt><dd><dd></dl><dl><dt>Inception1</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>JMeter</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>MAS - Projeto...pdf</dt><dd><dd></dl><dl><dt>MicroSite</dt><dd><dd>24 pastas</dd><dd>20 ficheiros</dd><dd></dl><dl><dt>Projeto.zip</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 22),
	(122, 49, 40431, 13, 'Goncalo_MAS_18_19_Praticas (zip)', '/notes/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Praticas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Lab1</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>Lab2</dt><dd><dd>1 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Lab3</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>Lab5</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Lab6</dt><dd><dd>1 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>Lab7</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>MAS_Práticas-...zip</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 46),
	(123, 101, 40432, 15, 'RafaelDireito_SMU_17_18_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Praticas.zip', 2017, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P</dt><dd><dd>11 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>12 pastas</dd><dd>12 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 40),
	(124, 101, 40432, 15, 'RafaelDireito_SMU_17_18_TP (zip)', '/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_TP.zip', 2017, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>TP</dt><dd><dd>0 pastas</dd><dd>10 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 68),
	(125, 101, 40432, 15, 'RafaelDireito_SMU_17_18_Prep2Test (zip)', '/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Prep2Teste.zip', 2017, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Prep2Teste</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 3),
	(126, 101, 40432, 15, 'RafaelDireito_SMU_17_18_Bibliografia (zip)', '/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Bibliografia.zip', 2017, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bibliografia</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 54),
	(127, 36, 40432, 14, 'DS_SMU_18_19_Fichas (zip)', '/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Fichas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>12 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>13 pastas</dd><dd>13 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 113),
	(128, 36, 40432, 14, 'DS_SMU_18_19_Livros (zip)', '/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Livros.zip', 2018, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Livros</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 54),
	(129, 36, 40432, 14, 'DS_SMU_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_SlidesTeoricos.zip', 2018, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Teoricos</dt><dd><dd>1 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>2 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 30),
	(130, 36, 40432, 14, 'DS_SMU_18_19_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Praticas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Praticas</dt><dd><dd>19 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>20 pastas</dd><dd>20 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 26),
	(131, 36, 40432, 14, 'DS_SMU_18_19_Resumos (zip)', '/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Resumos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 181),
	(132, 36, 40432, 14, 'DS_SMU_18_19_Testes (zip)', '/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Testes.zip', 2018, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>8 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>9 pastas</dd><dd>9 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 60),
	(133, 36, 40433, 16, 'DS_RS_18_19_Testes (zip)', '/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Testes.zip', 2018, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>16 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>17 pastas</dd><dd>17 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 130),
	(134, 36, 40433, 16, 'DS_RS_18_19_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Praticas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Praticas</dt><dd><dd>2 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2),
	(135, 36, 40433, 16, 'DS_RS_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_SlidesTeoricos.zip', 2018, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Teoricos</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 10),
	(136, 36, 40433, 16, 'DS_RS_18_19_Resumos (zip)', '/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Resumos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(137, 36, 40437, 11, 'DS_AED_18_19_Resumos (zip)', '/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Resumos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 271),
	(138, 36, 40437, 11, 'DS_AED_18_19_Livros (zip)', '/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Livros.zip', 2018, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Livros</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 20),
	(325, 104, 40437, 11, 'Projetos AED', 'https://github.com/Rui-FMF/AED', 2019, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(328, 104, 40381, 1, 'Projetos SO', 'https://github.com/Rui-FMF/SO', 2019, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(139, 36, 40437, 11, 'DS_AED_18_19_Testes (zip)', '/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Testes.zip', 2018, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>24 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>25 pastas</dd><dd>25 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 94),
	(140, 36, 40437, 11, 'DS_AED_18_19_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Praticas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pr?Çáticas</dt><dd><dd>21 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>20 pastas</dd><dd>20 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 20),
	(141, 36, 40437, 11, 'DS_AED_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_SlidesTeoricos.zip', 2018, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Te?óricos</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2),
	(142, 36, 40437, 11, 'DS_AED_18_19_Fichas (zip)', '/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Fichas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 16),
	(143, 101, 40437, 31, 'RafaelDireito_AED_17_18_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Praticas.zip', 2017, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P</dt><dd><dd>4 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>5 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(144, 101, 40437, 31, 'RafaelDireito_AED_17_18_Testes (zip)', '/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Testes.zip', 2017, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(145, 101, 40437, 31, 'RafaelDireito_AED_17_18_Books (zip)', '/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Praticas.zip', 2017, 0, 0, 1, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', NULL),
	(146, 101, 40437, 31, 'RafaelDireito_AED_17_18_LearningC (zip)', '/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_LearningC.zip', 2017, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>LearningC</dt><dd><dd>0 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(147, 101, 40437, 31, 'RafaelDireito_AED_17_18_AED (pdf)', '/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_AED.pdf', 2017, 0, 0, 0, 1, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
	(148, 36, 41469, 10, 'DS_Compiladores_18_19_Praticas (zip)', '/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Praticas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Praticas</dt><dd><dd>35 pastas</dd><dd>32 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>31 pastas</dd><dd>31 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(149, 36, 41469, 10, 'DS_Compiladores_18_19_Fichas (zip)', '/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Fichas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 42),
	(150, 36, 41469, 10, 'DS_Compiladores_18_19_Testes (zip)', '/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Testes.zip', 2018, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 33),
	(151, 36, 41469, 10, 'DS_Compiladores_18_19_Resumos (zip)', '/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Resumos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 242),
	(152, 36, 41469, 10, 'DS_Compiladores_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_SlidesTeoricos.zip', 2018, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Te?óricos</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 4),
	(153, 36, 41549, 9, 'DS_IHC_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_SlidesTeoricos.zip', 2018, 0, 0, 0, 1, 0, 0, 0, NULL, '2021-06-14 19:17:30', NULL),
	(154, 36, 41549, 9, 'DS_IHC_18_19_Fichas (zip)', '/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_Fichas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>5 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>6 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 51),
	(155, 36, 41549, 9, 'DS_IHC_18_19_Projetos (zip)', '/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_Projetos.zip', 2018, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>Projetos</dt><dd><dd>5 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>6 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 90),
	(156, 36, 41549, 9, 'DS_IHC_18_19_Testes (zip)', '/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_SlidesTeoricos.zip', 2018, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', NULL),
	(157, NULL, 40846, NULL, 'Resumos (zip)', '/notes/terceiro_ano/primeiro_semestre/ia/resumo.zip', NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo.pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(158, 36, 41791, 24, 'DS_EF_17_18_Resumos (zip)', '/notes/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Resumos.zip', 2017, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 4),
	(159, 36, 41791, 24, 'DS_EF_17_18_Exercicios (zip)', '/notes/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Exercicios.zip', 2017, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Exerci?ücios</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 3),
	(160, 36, 41791, 24, 'DS_EF_17_18_Exames (zip)', '/notes/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Exames.zip', 2017, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Exames</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2),
	(161, NULL, 42502, 6, 'Exames (zip)', '/notes/primeiro_ano/segundo_semestre/iac/exames.zip', NULL, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>iac_apontamen...pdf</dt><dd><dd></dl><dl><dt>iac_apontamen...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(162, 49, 42502, 6, 'Goncalo_IAC_18_19_Praticas (zip)', '/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Praticas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pr?íticas</dt><dd><dd>113 pastas</dd><dd>111 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>113 pastas</dd><dd>113 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 44),
	(163, 49, 42502, 6, 'Goncalo_IAC_18_19_Resumos (zip)', '/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Resumos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 17),
	(164, 49, 42502, 6, 'Goncalo_IAC_18_19_Apontamentos (zip)', '/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Apontamentos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Apontamentos</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 3),
	(165, 49, 42502, 6, 'Goncalo_IAC_18_19_Bibliografia (zip)', '/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Bibliografia.zip', 2018, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bibliografia ...pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Bibliografia ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 18),
	(166, 49, 42502, 6, 'Goncalo_IAC_18_19_Testes (zip)', '/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Testes.zip', 2018, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2),
	(167, 101, 42502, 6, 'RafaelDireito_IAC_16_17_Testes (zip)', '/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Testes.zip', 2016, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 3),
	(168, 101, 42502, 6, 'RafaelDireito_IAC_16_17_Teorica (zip)', '/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Teorica.zip', 2016, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Te?órica</dt><dd><dd>0 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 14),
	(169, 101, 42502, 6, 'RafaelDireito_IAC_16_17_FolhasPraticas (zip)', '/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_FolhasPraticas.zip', 2016, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>FolhasPr?Çáticas</dt><dd><dd>0 pastas</dd><dd>16 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 13),
	(170, 101, 42502, 6, 'RafaelDireito_IAC_16_17_ExerciciosResolvidos (zip)', '/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_ExerciciosResolvidos.zip', 2016, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>ExerciciosResolvidos</dt><dd><dd>6 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>7 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(171, 101, 42502, 6, 'RafaelDireito_IAC_16_17_Resumos (zip)', '/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Resumos.zip', 2016, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDireito...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 10),
	(172, 101, 42502, 6, 'RafaelDireito_IAC_16_17_DossiePedagogicov2 (zip)', '/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_DossiePedagogicov2.zip', 2016, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>DossiePedagog...pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(173, 36, 42532, 7, 'DS_BD_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/segundo_semestre/bd/DS_BD_18_19_SlidesTeoricos.zip', 2018, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Te?óricos</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 30),
	(174, 36, 42532, 7, 'DS_BD_18_19_Resumos (zip)', '/notes/segundo_ano/segundo_semestre/bd/DS_BD_18_19_Resumos.zip', 2018, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>2 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 144),
	(175, 36, 42532, 7, 'DS_BD_18_19_Praticas (zip)', '/notes/segundo_ano/segundo_semestre/bd/DS_BD_18_19_Praticas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pr?Çáticas</dt><dd><dd>48 pastas</dd><dd>34 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>45 pastas</dd><dd>45 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 81),
	(176, NULL, 42532, NULL, 'Resumos Diversos (zip)', '/notes/segundo_ano/segundo_semestre/bd/Resumos.zip', NULL, 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
	(177, 19, 41791, 24, 'Resumos EF', '/notes/primeiro_ano/primeiro_semestre/ef/CarolinaAlbuquerque_EF_Resumo.pdf', 2015, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 8),
	(178, 19, 41791, 24, 'Resolução Fichas EF', '/notes/primeiro_ano/primeiro_semestre/ef/CarolinaAlbuquerque_EF_ResolucoesFichas.zip', 2015, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>CarolinaAlbuq...</dt><dd><dd>6 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 169),
	(179, 66, 42573, NULL, 'Exames SIO resolvidos', '/notes/terceiro_ano/primeiro_semestre/sio/JoaoAlegria_Exames.zip', 2016, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_Exames</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 13),
	(180, 66, 42573, NULL, 'Resumos SIO', '/notes/terceiro_ano/primeiro_semestre/sio/JoaoAlegria_Resumos.zip', 2016, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_Resumos</dt><dd><dd>1 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 20),
	(181, 101, 42709, 23, 'Exames e testes ALGA', '/notes/primeiro_ano/primeiro_semestre/alga/Rafael_Direito_Exames.zip', 2016, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 9),
	(182, 101, 42709, 23, 'Fichas resolvidas ALGA', '/notes/primeiro_ano/primeiro_semestre/alga/RafaelDireito_Fichas.pdf', 2016, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 15),
	(183, 101, 42709, 23, 'Resumos ALGA ', '/notes/primeiro_ano/primeiro_semestre/alga/RafelDireito_Resumos.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 8),
	(184, 19, 42728, 19, 'Caderno de cálculo', '/notes/primeiro_ano/primeiro_semestre/c1/CarolinaAlbuquerque_C1_caderno.pdf', 2015, 0, 0, 0, 0, 0, 0, 1, NULL, '2021-06-14 19:17:30', 11),
	(185, 96, 42729, 19, 'Fichas resolvidas CII', '/notes/primeiro_ano/segundo_semestre/c2/PedroOliveira_Fichas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Ficha1</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>Ficha2</dt><dd><dd>0 pastas</dd><dd>15 ficheiros</dd><dd></dl><dl><dt>Ficha3</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>ficha3-part2.pdf</dt><dd><dd></dl><dl><dt>ficha3.pdf</dt><dd><dd></dl><dl><dt>Ficha4_000001.pdf</dt><dd><dd></dl><dl><dt>Ficha5_000001.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 110),
	(186, 96, 42729, 19, 'Testes CII', '/notes/primeiro_ano/segundo_semestre/c2/PedroOliveira_testes-resol.zip', 2018, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>testes-resol</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 24),
	(187, 54, 45424, NULL, 'Apontamentos Gerais ICM', '/notes/terceiro_ano/primeiro_semestre/icm/Resumo Geral Android.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 3),
	(331, 104, 40383, 12, 'Guiões e Exame P, Projeto T', 'https://github.com/Rui-FMF/PDS', 2019, 0, 1, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(334, 104, 40382, 2, 'Práticas e Projetos CD', 'https://github.com/Rui-FMF/CD', 2019, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(337, 104, 12832, 40, 'Projeto 1 TAA', 'https://github.com/Rui-FMF/TAA_1', 2020, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(188, 96, 47166, 20, 'Resoluções material apoio MD', '/notes/primeiro_ano/segundo_semestre/md/PedroOliveira_EA.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>EA(livro nos ...</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>EA1</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>EA1(refeito)</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>EA2(Completo)</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>EA2.pdf</dt><dd><dd></dl><dl><dt>EA2ex4.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 45),
	(189, 96, 47166, 20, 'Resoluções fichas MD', '/notes/primeiro_ano/segundo_semestre/md/PedroOliveira_Fichas.zip', 2018, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Ficha1</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>ficha2.pdf</dt><dd><dd></dl><dl><dt>ficha3_000001.pdf</dt><dd><dd></dl><dl><dt>ficha4_000001.pdf</dt><dd><dd></dl><dl><dt>ficha5-cont.pdf</dt><dd><dd></dl><dl><dt>ficha5.pdf</dt><dd><dd></dl><dl><dt>Ficha6.pdf</dt><dd><dd></dl><dl><dt>ficha7(incomp...pdf</dt><dd><dd></dl><dl><dt>Ficha8_000001.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 79),
	(190, 96, 47166, 20, 'Resoluções testes MD', '/notes/primeiro_ano/segundo_semestre/md/PedroOliveira_testes.zip', 2018, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>testes</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 33),
	(191, 101, 40433, 4, 'Estudo para o exame', '/notes/segundo_ano/primeiro_semestre/rs/RafaelDireito_2017_RSexame.pdf', 2017, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 6),
	(192, NULL, 40551, NULL, 'Exercícios TPW', '/notes/terceiro_ano/segundo_semestre/tpw/Exercicios.zip', NULL, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Exercicios</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 14),
	(193, 66, 40757, NULL, 'Resumos 2016/2017', '/notes/mestrado/as/as_apontamentos_001.pdf', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
	(194, 66, 40757, NULL, 'Resumos por capítulo (zip)', '/notes/mestrado/as/JoaoAlegria_ResumosPorCapitulo.zip', 2016, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
	(195, 54, 40846, NULL, 'Exercícios IA', '/notes/terceiro_ano/primeiro_semestre/ia/Inês_Correia_IA_exercícios.pdf', NULL, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 7),
	(196, 54, 40846, NULL, 'Resumos IA', '/notes/terceiro_ano/primeiro_semestre/ia/Inês_Correia_IA_resumo.pdf', NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 9),
	(197, 130, 47166, 32, 'Caderno MD Cap. 6 e 7', '/notes/primeiro_ano/segundo_semestre/md/MarianaRosa_Caderno_Capts6e7.pdf', 2019, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, '2021-06-16 22:18:59', 20),
	(198, 130, 47166, 32, 'Resumos 1.ª Parte MD', '/notes/primeiro_ano/segundo_semestre/md/MarianaRosa_Resumos_1aParte.pdf', 2019, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:21:33', 13),
	(199, 49, 42532, 8, 'Práticas BD', '/notes/segundo_ano/segundo_semestre/bd/Goncalo_Praticas.zip', 2019, NULL, NULL, NULL, NULL, 1, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>P</dt><dd><dd>11 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:27:12', 23),
	(200, 49, 42532, 7, 'Resumos BD', '/notes/segundo_ano/segundo_semestre/bd/Goncalo_Resumos.zip', 2019, 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>TP</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:28:20', 20),
	(201, 49, 41469, 10, 'Resumos Caps. 3 e 4', '/notes/segundo_ano/segundo_semestre/c/Goncalo_TP.zip', 2019, 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>TP</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 8),
	(202, 49, 41469, 10, 'Resumos ANTLR4', '/notes/segundo_ano/segundo_semestre/c/Goncalo_ANTLR4.zip', 2019, 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>ANTLR4 Listeners.pdf</dt><dd><dd></dl><dl><dt>ANTLR4 Visitors.pdf</dt><dd><dd></dl><dl><dt>ANTLR4.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 1),
	(203, 49, 41469, 10, 'Guiões P Resolvidos', '/notes/segundo_ano/segundo_semestre/c/Goncalo_GuioesPraticos.zip', 2019, NULL, NULL, NULL, NULL, 1, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>P1_20fev2020</dt><dd><dd>1 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>P2_05fev2020</dt><dd><dd>35 pastas</dd><dd>37 ficheiros</dd><dd></dl><dl><dt>P3</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2),
	(204, 49, 41469, 10, 'Resumos Práticos', '/notes/segundo_ano/segundo_semestre/c/Goncalo_ResumosPraticos.zip', 2019, 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>1_Compiladores.pdf</dt><dd><dd></dl><dl><dt>2_ANTLR4.pdf</dt><dd><dd></dl><dl><dt>3_Análise sem...pdf</dt><dd><dd></dl><dl><dt>5_Análise sem...pdf</dt><dd><dd></dl><dl><dt>6_Geração de ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 17),
	(205, 49, 40382, 2, 'Bibliografia', '/notes/segundo_ano/segundo_semestre/cd/Bibliografia.zip', 2019, NULL, NULL, 1, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>mvsteen-distr...pdf</dt><dd><dd></dl><dl><dt>ResolucaoPerg...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 39),
	(206, 49, 40382, 2, 'Cheatsheet', '/notes/segundo_ano/segundo_semestre/cd/Goncalo_CheatSheet.pdf', 2019, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 1),
	(207, 49, 40382, 2, 'Aulas Resolvidas', '/notes/segundo_ano/segundo_semestre/cd/Goncalo_Aulas.zip', 2019, NULL, NULL, NULL, NULL, 1, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>P1_11Fev2020</dt><dd><dd>138 pastas</dd><dd>140 ficheiros</dd><dd></dl><dl><dt>P2_10Fev2020</dt><dd><dd>125 pastas</dd><dd>128 ficheiros</dd><dd></dl><dl><dt>P3_28Abr2020</dt><dd><dd>103 pastas</dd><dd>104 ficheiros</dd><dd></dl><dl><dt>P4_19Mai2020</dt><dd><dd>183 pastas</dd><dd>183 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 8),
	(208, 49, 40382, 2, 'Projeto1', '/notes/segundo_ano/segundo_semestre/cd/Goncalo_Projeto1.zip', 2019, NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>message-broke...</dt><dd><dd>260 pastas</dd><dd>268 ficheiros</dd><dd></dl><dl><dt>Projecto 1 - ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 3),
	(209, 49, 40382, 2, 'Projeto2', '/notes/segundo_ano/segundo_semestre/cd/Goncalo_Projeto2.zip', 2019, NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>distributed-o...</dt><dd><dd>7 pastas</dd><dd>22 ficheiros</dd><dd></dl><dl><dt>Projecto 2 - ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 15),
	(210, 49, 40382, 2, 'Resumos Teóricos', '/notes/segundo_ano/segundo_semestre/cd/Goncalo_TP.pdf', 2019, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 6),
	(211, 49, 41549, 9, 'Paper \Help, I am stuck...\', '/notes/segundo_ano/segundo_semestre/ihc/Goncalo_Francisca_Paper.zip', 2019, NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>92972_93102_[...pdf</dt><dd><dd></dl><dl><dt>IHC_Paper.pdf</dt><dd><dd></dl><dl><dt>Paper-selecti...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2),
	(212, 49, 41549, 9, 'Resumos (incompletos)', '/notes/segundo_ano/segundo_semestre/ihc/Goncalo_TP.pdf', 2019, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 1),
	(213, 49, 41549, 9, 'Perguntitas de preparação exame', '/notes/segundo_ano/segundo_semestre/ihc/Perguntitaspreparaçaoexame.zip', 2019, NULL, 1, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>(1) User prof...pdf</dt><dd><dd></dl><dl><dt>(2) User ... ...pdf</dt><dd><dd></dl><dl><dt>(3) User mode...pdf</dt><dd><dd></dl><dl><dt>(4) Input & O...pdf</dt><dd><dd></dl><dl><dt>(5) Usability...pdf</dt><dd><dd></dl><dl><dt>exam.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 1),
	(214, 49, 40383, 12, 'Resumos teóricos', '/notes/segundo_ano/segundo_semestre/pds/Goncalo_TP.pdf', 2019, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 11),
	(215, 49, 40383, 12, 'Projeto final: Padrões Bridge e Flyweight e Refactoring', '/notes/segundo_ano/segundo_semestre/pds/Goncalo_Projeto.zip', 2019, NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>Entrega</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 74),
	(340, 104, 41549, 9, 'Projetos e artigo IHC', 'https://github.com/Rui-FMF/IHC', 2019, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(343, 104, 45426, 13, 'Guiões P e Homework TQS', 'https://github.com/Rui-FMF/TQS', 2020, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(216, 49, 40383, 12, 'Aulas P Resolvidas', '/notes/segundo_ano/segundo_semestre/pds/Goncalo_Aulas.zip', 2019, NULL, NULL, NULL, NULL, 1, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>P1_11fev2020</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P2_03mar2020</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P3_10mar2020</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P4_17mar2020</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>P5_24mar2020</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P6_31mar2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P7_14abr2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P8_21abr2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P9_28abr2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P10_05mai2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P11_19mai29020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P12_26mai2020</dt><dd><dd>0 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>P13_02jun2020</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>pds_2020_g205</dt><dd><dd>482 pastas</dd><dd>481 ficheiros</dd><dd></dl><dl><dt>Readme.txt</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 38),
	(217, 49, 40383, 12, 'Exame final', '/notes/segundo_ano/segundo_semestre/pds/Goncalo_Exame.zip', 2019, NULL, 1, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>92972</dt><dd><dd>0 pastas</dd><dd>16 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 1),
	(218, 49, 40383, 12, 'Bibliografia', '/notes/segundo_ano/segundo_semestre/pds/Bibliografia.zip', 2019, NULL, NULL, 1, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>applying-uml-...pdf</dt><dd><dd></dl><dl><dt>DesignPatterns.pdf</dt><dd><dd></dl><dl><dt>kupdf.net_use...pdf</dt><dd><dd></dl><dl><dt>software-arch...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 159),
	(220, 49, 41549, 9, 'Projeto final \Show tracker\', 'https://github.com/gmatosferreira/show-tracker-app', 2019, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, '2021-10-18 15:00:00', NULL),
	(232, NULL, 40846, 30, 'AI: A Modern Approach', '/notes/terceiro_ano/primeiro_semestre/ia/artificial-intelligence-modern-approach.9780131038059.25368.pdf', 2020, 0, 0, 1, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 38),
	(238, 49, 40846, 30, 'Resumos', '/notes/terceiro_ano/primeiro_semestre/ia/Goncalo_IA_TP.pdf', 2020, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 3),
	(241, 49, 40846, 2, 'Notas código práticas', '/notes/terceiro_ano/primeiro_semestre/ia/Goncalo_Código_Anotado_Práticas.zip', 2020, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>BayesNet.pdf</dt><dd><dd></dl><dl><dt>ConstraintSearch.pdf</dt><dd><dd></dl><dl><dt>SearchTree.pdf</dt><dd><dd></dl><dl><dt>SemanticNetwork.pdf</dt><dd><dd></dl><dl><dt>Strips.pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 4),
	(244, 49, 40846, 2, 'Código práticas', '/notes/terceiro_ano/primeiro_semestre/ia/Goncalo_Praticas.zip', 2020, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>guiao-de-prog...</dt><dd><dd>6 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>guiao-rc-gmat...</dt><dd><dd>6 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>guiao-sobre-p...</dt><dd><dd>6 pastas</dd><dd>15 ficheiros</dd><dd></dl><dl><dt>ia-iia-tpi-1-...</dt><dd><dd>4 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>ia-iia-tpi2-g...</dt><dd><dd>1 pastas</dd><dd>10 ficheiros</dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2),
	(247, 49, 2450, 34, 'Resumos', '/notes/terceiro_ano/primeiro_semestre/ge/Goncalo_GE_TP.pdf', 2020, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 2),
	(250, 49, 2450, 34, 'Post-its', '/notes/terceiro_ano/primeiro_semestre/ge/Goncalo_Postits.zip', 2020, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_Introduçao ...pdf</dt><dd><dd></dl><dl><dt>2_Modelo de n...pdf</dt><dd><dd></dl><dl><dt>3_Modelo de n...pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 11),
	(253, 49, 40384, 12, 'Post-its', '/notes/terceiro_ano/primeiro_semestre/ies/Goncalo_Postits.zip', 2020, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_IES.pdf</dt><dd><dd></dl><dl><dt>2_Processo so...pdf</dt><dd><dd></dl><dl><dt>3_Desenvolvim...pdf</dt><dd><dd></dl><dl><dt>4_Devops.pdf</dt><dd><dd></dl><dl><dt>5_Padroes arq...pdf</dt><dd><dd></dl><dl><dt>6_Web framewo...pdf</dt><dd><dd></dl><dl><dt>8_Spring fram...pdf</dt><dd><dd></dl><dl><dt>9_Spring boot.pdf</dt><dd><dd></dl><dl><dt>10_Microserviços.pdf</dt><dd><dd></dl><dl><dt>11_Sistemas b...pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 12),
	(256, 49, 40384, 12, 'Aulas práticas', '/notes/terceiro_ano/primeiro_semestre/ies/Goncalo_Práticas.zip', 2020, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Lab1_92972.zip</dt><dd><dd></dl><dl><dt>Lab2_92972.zip</dt><dd><dd></dl><dl><dt>Lab3_92972.zip</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 3),
	(259, 49, 40384, 12, 'Resumos', '/notes/terceiro_ano/primeiro_semestre/ies/Goncalo_IES_TP.pdf', 2020, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 5),
	(262, 49, 40384, 12, 'Projeto final \Store Go\', 'https://github.com/gmatosferreira/IES_Project_G31', 2020, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', NULL),
	(265, 49, 42573, 3, 'Resumos', '/notes/terceiro_ano/primeiro_semestre/sio/Goncalo_SIO_TP.pdf', 2020, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 4),
	(268, 49, 42573, 3, 'Tópicos exame', '/notes/terceiro_ano/primeiro_semestre/sio/Goncalo_Tópicos_exame.pdf', 2020, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 2),
	(271, NULL, 42573, 3, 'Security in Computing', '/notes/terceiro_ano/primeiro_semestre/sio/security-in-computing-5-e.pdf', 2020, 0, 0, 1, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 18),
	(274, 49, 42573, 3, 'Projeto 1 \Exploração de vulnerabilidades\', '/notes/terceiro_ano/primeiro_semestre/sio/Goncalo_[SIO][Projeto 1]_Relatório.pdf', 2020, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', 1),
	(277, 49, 42573, 3, 'Projeto 4 \Forensics\', '/notes/terceiro_ano/primeiro_semestre/sio/Goncalo_[SIO][Projeto 4]_Relatório.pdf', 2020, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', 1),
	(280, 49, 42573, 3, 'Projeto 2 \Secure Media Player\', 'https://github.com/gmatosferreira/securemediaplayer', 2020, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', NULL),
	(283, 49, 40385, 12, 'Resumos', '/notes/terceiro_ano/primeiro_semestre/cbd/Goncalo_CBD_TP.pdf', 2020, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 3),
	(286, 49, 40385, 12, 'Post-its', '/notes/terceiro_ano/primeiro_semestre/cbd/Goncalo_Postits.zip', 2020, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_Foco nos dados.pdf</dt><dd><dd></dl><dl><dt>2_Modelos de ...pdf</dt><dd><dd></dl><dl><dt>3_Armazenamen...pdf</dt><dd><dd></dl><dl><dt>4_Formatos do...pdf</dt><dd><dd></dl><dl><dt>5 a 8_Tipos b...pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 6),
	(289, 49, 40385, 12, 'Práticas', '/notes/terceiro_ano/primeiro_semestre/cbd/Goncalo_Praticas.zip', 2020, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Lab-1_92972.zip</dt><dd><dd></dl><dl><dt>Lab2_92972.zip</dt><dd><dd></dl><dl><dt>92972_Lab3.zip</dt><dd><dd></dl><dl><dt>92972_Lab4.zip</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 4),
	(292, NULL, 40385, 12, 'Designing Data Intensive Applications', '/notes/terceiro_ano/primeiro_semestre/cbd/Designing Data Intensive Applications.pdf', 2020, 0, 0, 1, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 25),
	(298, 83, 42573, 3, 'Projeto 2 \Secure Media Player\', 'https://github.com/margaridasmartins/digital-rights-management', 2020, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-11-15 19:17:30', NULL),
	(304, 104, 40436, 28, 'Práticas POO', 'https://github.com/Rui-FMF/POO', 2018, 0, 1, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', NULL),
	(307, 104, 40379, 27, 'Práticas FP', 'https://github.com/Rui-FMF/FP', 2018, 0, 0, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', NULL),
	(313, 104, 42502, 6, 'Práticas IAC', 'https://github.com/Rui-FMF/IAC', 2018, 0, 0, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', NULL),
	(319, 104, 40433, 16, 'Projeto RS', 'https://github.com/Rui-FMF/RS', 2019, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(322, 104, 40337, 28, 'Práticas e projeto MPEI', 'https://github.com/Rui-FMF/MPEI', 2019, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(349, 104, 40385, 12, 'Labs CBD', 'https://github.com/Rui-FMF/CBD', 2020, 0, 0, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', NULL),
	(352, 104, 40846, 2, 'Guiões, TPI e Projeto de IA', 'https://github.com/Rui-FMF/IA', 2020, 0, 1, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(355, 104, 40384, 12, 'Labs e projeto de IES', 'https://github.com/Rui-FMF/IES', 2020, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(358, 104, 42573, 3, 'Projetos SIO', 'https://github.com/Rui-FMF/SIO', 2020, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(361, 104, 40551, 25, 'Projetos TPW', 'https://github.com/Rui-FMF/TPW', 2020, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(364, 83, 40384, 12, 'Projeto de IES', 'https://github.com/margaridasmartins/IES_Project', 2020, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(367, 83, 45426, 13, 'Guiões P e Homework TQS', 'https://github.com/margaridasmartins/TQSLabs', 2020, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
	(370, 140, 14817, 29, 'Programas MSF', '/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_Programas.zip', 2020, 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', NULL),
	(373, 140, 14817, 29, 'Exercícios resolvidos MSF', '/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_ExsResolvidos.zip', 2020, 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', NULL),
	(376, 140, 14817, 29, 'Exercícios MSF', '/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_Exercicios.zip', 2020, 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', NULL),
	(379, 140, 14817, 29, 'Guiões práticos MSF', '/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_Ps.zip', 2020, 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', NULL),
	(382, 140, 14817, 29, 'Slides teóricos MSF', '/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_TPs.zip', 2020, 0, 0, 0, 1, 0, 0, 0, NULL, '2022-01-31 20:37:14', NULL),
	(385, 140, 14817, 29, 'Formulário MSF', '/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_Form.pdf', 2020, 1, 0, 0, 0, 0, 0, 0, NULL, '2022-01-31 20:37:14', NULL);


--
-- Data for Name: partner; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.partner (id, header, company, description, content, link, banner_url, banner_image, banner_until) VALUES
	(1, '/partners/LavandariaFrame.jpg', 'Lavandaria Portuguesa', 'A Lavandaria Portuguesa encontra-se aliada ao NEI desde março de 2018, ajudando o núcleo na área desportiva com lavagens de equipamentos dos atletas que representam o curso.', NULL, 'https://www.facebook.com/alavandariaportuguesa.pt/', NULL, NULL, NULL),
	(2, '/partners/OlisipoFrame.jpg', 'Olisipo', 'Fundada em 1994, a Olisipo é a única empresa portuguesa com mais de 25 anos de experiência dedicada à Gestão de Profissionais na área das Tecnologias de Informação.\n\nSomos gestores de carreira de mais de 500 profissionais de TI e temos Talent Managers capazes de influenciar o sucesso da carreira dos nossos colaboradores e potenciar o crescimento dos nossos clientes.\n\nVem conhecer um Great Place to Work® e uma das 30 melhores empresas para trabalhar em Portugal.', NULL, 'https://bit.ly/3KVT8zs', 'https://bit.ly/3KVT8zs', '/partner/banners/Olisipo.png', '2023-01-31 23:59:59');


--
-- Data for Name: redirect; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.redirect (id, alias, redirect) VALUES
	(1, 'mapa', '/integracao/202122/peddypaper/mapa.png'),
	(2, 'glicinias', '/integracao/202122/peddypaper/glicinias.jpg'),
	(3, 'ribau', '/integracao/202122/peddypaper/congressos.jpg'),
	(4, 'forum', '/integracao/202122/peddypaper/forum.jpg'),
	(5, 'santos', '/integracao/202122/peddypaper/santos.jpg'),
	(6, 'macaca', '/integracao/202122/peddypaper/macaca.jpg'),
	(7, 'convivio', '/integracao/202122/peddypaper/convivio.jpg'),
	(8, 'be', '/integracao/202122/peddypaper/be.jpg'),
	(9, 'socorro', '/integracao/202122/guiasobrevivencia.pdf');


--
-- Data for Name: rgm; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.rgm (id, category, mandate, date, title, file) VALUES
	(1, 'ATA', '2013', '2012-12-19 00:00:00', 'Acta da Assembleia de Alunos de Licenciatura de Tecnologias e Sistemas de Informação e Mestrado de Sistemas de Informação', '/rgm/ATA/2013/ATA1.pdf'),
	(2, 'ATA', '2013', '2013-02-26 00:00:00', 'Acta da Reunião Geral de Membros do Pré-Núcleo Estudantes de Sistemas de Informação', '/rgm/ATA/2013/ATA2.pdf'),
	(3, 'ATA', '2013', '2013-10-14 00:00:00', 'Ata da Reunião Geral de Membros Extraordinária de Licenciatura em Tecnologias e Sistemas de Informação e Mestrado em Sistemas de Informação', '/rgm/ATA/2013/ATA3.pdf'),
	(4, 'ATA', '2013', '2013-11-20 00:00:00', 'Ata da Reunião Geral de Membros - Extraordinária TSI & MSI', '/rgm/ATA/2013/ATA4.pdf'),
	(5, 'ATA', '2013', '2013-12-11 00:00:00', 'Ata da Reunião Geral de Membros de Licenciatura em Tecnologias e Sistemas de Informação e Mestrado em Sistemas de Informação', '/rgm/ATA/2013/ATA5.pdf'),
	(6, 'PAO', '2013', NULL, 'Pré- Núcleo de Estudantes de Sistemas de Informação NESI', '/rgm/PAO/PAO_2013_NESI.pdf'),
	(7, 'RAC', '2013', NULL, 'Núcleo de Estudantes de Sistemas de Informação', '/rgm/RAC/RAC_2013_NESI.pdf'),
	(8, 'ATA', '2014', '2014-02-18 00:00:00', 'Ata da Reunião Geral de Membros da Licenciatura em Tecnologias e Sistemas de Informação e do Mestrado em Sistemas de Informação', '/rgm/ATA/2014/ATA1.pdf'),
	(9, 'ATA', '2014', '2014-06-02 00:00:00', 'Ata da Reunião Geral de Membros Extraordinária da Licenciatura em Tecnologias e Sistemas de Informação e do Mestrado em Sistemas de Informação', '/rgm/ATA/2014/ATA2.pdf'),
	(10, 'ATA', '2014', '2014-10-14 00:00:00', 'Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação', '/rgm/ATA/2014/ATA3.pdf'),
	(11, 'ATA', '2014', '2014-11-06 00:00:00', 'Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação', '/rgm/ATA/2014/ATA4.pdf'),
	(12, 'ATA', '2014', '2014-12-16 00:00:00', 'Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação', '/rgm/ATA/2014/ATA5.pdf'),
	(13, 'PAO', '2014', NULL, 'Núcleo de Estudantes de Sistemas de Informação', '/rgm/PAO/PAO_2014_NESI.pdf'),
	(14, 'RAC', '2014', NULL, 'Núcleo de Estudantes de Informática', '/rgm/RAC/RAC_2014_NEI.pdf'),
	(15, 'ATA', '2015', '2015-02-19 00:00:00', 'Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação', '/rgm/ATA/2015/ATA1.pdf'),
	(16, 'ATA', '2015', '2015-04-07 00:00:00', 'Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação', '/rgm/ATA/2015/ATA2.pdf'),
	(17, 'ATA', '2015', '2016-01-14 00:00:00', 'Ata da Reunião Geral de Membros Extraordinária da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação', '/rgm/ATA/2015/ATA3.pdf'),
	(18, 'PAO', '2015', NULL, 'Núcleo de Estudantes de Informática', '/rgm/PAO/PAO_2015_NEI.pdf'),
	(19, 'RAC', '2015', NULL, 'Núcleo de Estudantes de Informática', '/rgm/RAC/RAC_2015_NEI.pdf'),
	(20, 'ATA', '2016', '2016-02-18 00:00:00', 'Ata número Um do Mandato 2016: Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação', '/rgm/ATA/2016/ATA1.pdf'),
	(21, 'ATA', '2016', '2016-04-07 00:00:00', 'Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação', '/rgm/ATA/2016/ATA2.pdf'),
	(22, 'PAO', '2016', NULL, NULL, '/rgm/PAO/PAO_2016_NEI.pdf'),
	(23, 'RAC', '2016', NULL, 'Núcleo de Estudantes de Informática', '/rgm/RAC/RAC_2016_NEI.pdf'),
	(26, 'ATA', '2017', '2017-02-13 00:00:00', 'Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação', '/rgm/ATA/2017/ATA1.pdf'),
	(25, 'ATA', '2017', '2017-10-11 00:00:00', 'REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2017 ATA NÚMERO 2', '/rgm/ATA/2017/ATA2.pdf'),
	(24, 'ATA', '2017', '2018-01-10 00:00:00', 'REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2017 ATA NÚMERO 3', '/rgm/ATA/2017/ATA3.pdf'),
	(27, 'PAO', '2017', NULL, NULL, '/rgm/PAO/PAO_2017_NEI.pdf'),
	(28, 'RAC', '2017', NULL, 'NEI-AAUAv 2017', '/rgm/RAC/RAC_2017_NEI.pdf'),
	(31, 'ATA', '2018', '2018-03-13 00:00:00', NULL, '/rgm/ATA/2018/ATA1.pdf'),
	(30, 'ATA', '2018', '2018-02-15 00:00:00', NULL, '/rgm/ATA/2018/ATA2.pdf'),
	(32, 'ATA', '2018', '2018-10-18 00:00:00', NULL, '/rgm/ATA/2018/ATA3.pdf'),
	(29, 'ATA', '2018', '2019-01-10 00:00:00', NULL, '/rgm/ATA/2018/ATA4.pdf'),
	(33, 'PAO', '2018', NULL, NULL, '/rgm/PAO/PAO_2018_NEI.pdf'),
	(34, 'RAC', '2018', NULL, 'NEI-AAUAv 2018', '/rgm/RAC/RAC_2018_NEI.pdf'),
	(35, 'ATA', '2019', '2019-02-14 00:00:00', 'REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2019 ATA NÚMERO 1', '/rgm/ATA/2019/ATA1.pdf'),
	(36, 'ATA', '2019', '2019-04-01 00:00:00', 'REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2019 ATA NÚMERO 2', '/rgm/ATA/2019/ATA2.pdf'),
	(37, 'ATA', '2019', '2019-09-24 00:00:00', 'REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2019 ATA NÚMERO 3', '/rgm/ATA/2019/ATA3.pdf'),
	(38, 'ATA', '2019', '2020-01-09 00:00:00', 'REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2019 ATA NÚMERO 4', '/rgm/ATA/2019/ATA4.pdf'),
	(39, 'PAO', '2019', NULL, NULL, '/rgm/PAO/PAO_2019_NEI.pdf'),
	(40, 'RAC', '2019', NULL, 'Núcleo de Estudantes de Informática', '/rgm/RAC/RAC_2019_NEI.pdf'),
	(41, 'ATA', '2020', '2020-02-12 00:00:00', 'REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2020 ATA NÚMERO 1', '/rgm/ATA/2020/ATA1.pdf'),
	(42, 'ATA', '2020', '2021-02-11 00:00:00', 'REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2020 ATA NÚMERO 2', '/rgm/ATA/2020/ATA2.pdf'),
	(43, 'PAO', '2020', NULL, 'NEI', '/rgm/PAO/PAO_2020_NEI.pdf'),
	(44, 'RAC', '2020', NULL, 'Núcleo de Estudantes de Informática', '/rgm/RAC/RAC_2020_NEI.pdf'),
	(45, 'ATA', '2021', '2021-04-05 00:00:00', 'REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2021 ATA NÚMERO 1', '/rgm/ATA/2021/ATA1.pdf'),
	(46, 'ATA', '2021', '2022-02-01 00:00:00', 'REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2021 ATA NÚMERO 2', '/rgm/ATA/2021/ATA2.pdf'),
	(47, 'PAO', '2021', NULL, 'NEI', '/rgm/PAO/PAO_2021_NEI.pdf'),
	(48, 'RAC', '2021', NULL, 'NEI', '/rgm/RAC/RAC_2021_NEI.pdf'),
	(49, 'ATA', '2022', '2022-03-28 00:00:00', 'REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2022 ATA NÚMERO 1', '/rgm/ATA/2022/ATA1.pdf'),
	(50, 'ATA', '2022', '2022-06-20 00:00:00', 'REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2022 ATA NÚMERO 2', '/rgm/ATA/2022/ATA2.pdf'),
	(51, 'PAO', '2022', NULL, 'NEI', '/rgm/PAO/PAO_2022_NEI.pdf'),
	(52, 'RAC', '2022', NULL, 'NEI', '/rgm/RAC/RAC_2022_NEI.pdf'),
	(53, 'PAO', '2022/23', NULL, 'NEI', '/rgm/PAO/PAO_202223_NEI.pdf');


--
-- Data for Name: senior; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.senior (id, year, course, image) VALUES
	(1, 2020, 'LEI', '/seniors/lei/2020_3.jpg'),
	(2, 2020, 'MEI', '/seniors/mei/2020.jpg'),
	(3, 2021, 'LEI', NULL),
	(4, 2021, 'MEI', NULL);


--
-- Data for Name: senior_student; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.senior_student (senior_id, user_id, quote, image) VALUES
	(1, 4, NULL, NULL),
	(1, 5, NULL, NULL),
	(1, 7, NULL, NULL),
	(1, 8, NULL, NULL),
	(1, 9, NULL, NULL),
	(1, 14, NULL, NULL),
	(1, 15, NULL, NULL),
	(1, 34, NULL, NULL),
	(1, 36, NULL, NULL),
	(1, 47, NULL, NULL),
	(1, 48, NULL, NULL),
	(1, 56, NULL, NULL),
	(1, 63, NULL, NULL),
	(1, 69, NULL, NULL),
	(1, 76, NULL, NULL),
	(1, 87, NULL, NULL),
	(1, 96, NULL, NULL),
	(1, 118, NULL, NULL),
	(1, 122, NULL, NULL),
	(1, 145, NULL, NULL),
	(2, 24, NULL, '/seniors/mei/2020/24.jpg'),
	(2, 146, NULL, '/seniors/mei/2020/146.jpg'),
	(3, 18, 'Level up', '/seniors/lei/2021/18.jpg'),
	(3, 37, 'Mal posso esperar para ver o que se segue', '/seniors/lei/2021/37.jpg'),
	(3, 43, 'Já dizia a minha avó: \O meu neto não bebe álcool\', '/seniors/lei/2021/43.jpg'),
	(3, 49, NULL, '/seniors/lei/2021/49.jpg'),
	(3, 53, NULL, '/seniors/lei/2021/53.jpg'),
	(3, 67, 'Simplesmente viciado em café e futebol', '/seniors/lei/2021/67.jpg'),
	(3, 83, 'MD é fixe.', '/seniors/lei/2021/83.jpg'),
	(3, 93, 'Há tempo para tudo na vida académica!', '/seniors/lei/2021/93.jpg'),
	(3, 106, 'Melhorias = Mito', '/seniors/lei/2021/106.jpg'),
	(4, 19, '<h1>Fun fact: #EAAA00</h1>', '/seniors/mei/2021/19.jpg');


--
-- Data for Name: subject; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.subject (code, course_id, curricular_year, name, short, discontinued, optional) VALUES
	(2373, NULL, 3, 'Empreendedorismo', 'E', false, true),
	(2450, NULL, 3, 'Gestão de Empresas', 'GE', false, false),
	(9270, NULL, 3, 'Arquitectura e Gestão de Redes', 'AGR', false, true),
	(12271, NULL, 3, 'Aspetos Profissionais e Sociais da Engenharia Informática', 'APSEI', false, false),
	(12830, NULL, 3, 'Complementos Sobre Linguagens de Programação', 'CSLP', false, true),
	(12832, NULL, 3, 'Tópicos de Aprendizagem Automática', 'TAA', false, false),
	(14817, NULL, 1, 'Modelação de Sistemas Físicos', 'MSF', false, false),
	(40337, NULL, 2, 'Métodos Probabilísticos para Engenharia Informática', 'MPEI', false, false),
	(40379, NULL, 1, 'Fundamentos de Programação', 'FP', false, false),
	(40380, NULL, 1, 'Introdução às Tecnologias Web', 'ITW', false, false),
	(40381, NULL, 2, 'Sistemas Operativos', 'SO', false, false),
	(40382, NULL, 2, 'Computação Distribuída', 'CD', false, false),
	(40383, NULL, 2, 'Padrões e Desenho de Software', 'PDS', false, false),
	(40384, NULL, 3, 'Introdução à Engenharia de Software', 'IES', false, false),
	(40385, NULL, 3, 'Complementos de Bases de Dados', 'CBD', false, false),
	(40431, NULL, 1, 'Modelação e Análise de Sistemas', 'MAS', false, false),
	(40432, NULL, 2, 'Sistemas Multimédia', 'SM', false, false),
	(40433, NULL, 2, 'Redes e Serviços', 'RS', false, false),
	(40436, NULL, 1, 'Programação Orientada a Objetos', 'POO', false, false),
	(40437, NULL, 2, 'Algoritmos e Estruturas de Dados', 'AED', false, false),
	(40551, NULL, 3, 'Tecnologias e Programação Web', 'TPW', false, false),
	(40751, NULL, 4, 'Algoritmos Avançados', 'AA', false, false),
	(40752, NULL, 4, 'Teoria Algorítmica da Informação', 'TAI', false, false),
	(40753, NULL, 4, 'Computação em Larga Escala', 'CLE', false, false),
	(40756, NULL, 4, 'Gestão de Infraestruturas de Computação', 'GIC', false, false),
	(40757, NULL, 4, 'Arquiteturas de Software', 'AS', false, false),
	(40846, NULL, 3, 'Inteligência Artificial', 'IA', false, false),
	(41469, NULL, 2, 'Compiladores', 'C', false, false),
	(41549, NULL, 2, 'Interação Humano-Computador', 'IHC', false, false),
	(41791, NULL, 1, 'Elementos de Fisíca', 'EF', true, false),
	(42502, NULL, 1, 'Introdução à Arquitetura de Computadores', 'IAC', false, false),
	(42532, NULL, 2, 'Bases de Dados', 'BD', false, false),
	(42573, NULL, 3, 'Segurança Informática e Nas Organizações', 'SIO', false, false),
	(42709, NULL, 1, 'Álgebra Linear e Geometria Analítica', 'ALGA', false, false),
	(42728, NULL, 1, 'Cálculo I', 'C1', false, false),
	(42729, NULL, 1, 'Cálculo II', 'C2', false, false),
	(44156, NULL, 4, 'Visualização de Informação', 'VI', false, false),
	(44130, NULL, 4, 'Web Semântica', 'WS', false, false),
	(45424, NULL, 3, 'Introdução à Computação Móvel', 'ICM', false, false),
	(45426, NULL, 3, 'Teste e Qualidade de Software', 'TQS', false, false),
	(45587, NULL, 4, 'Exploração de Dados', 'ED', false, false),
	(47166, NULL, 1, 'Matemática Discreta', 'MD', false, false),
	(41226, NULL, 2, 'ROBÓTICA MÓVEL INTELIGENTE', '', false, false),
	(43370, NULL, 2, 'LÍNGUA CHINESA I', '', false, false),
	(49711, NULL, 2, 'PREPARAÇÃO DE DISSERTAÇÃO / ESTÁGIO', '', false, false),
	(49997, NULL, 2, 'DISSERTAÇÃO / ESTÁGIO', '', false, false),
	(41770, NULL, 2, 'REDES E SERVIÇOS', '', false, false),
	(40754, NULL, 1, 'SISTEMAS DE INFORMAÇÃO NAS ORGANIZAÇÕES', '', false, false),
	(41492, NULL, 1, 'ENGENHARIA DE SOFTWARE', '', false, false),
	(42596, NULL, 1, 'RECUPERAÇÃO DE INFORMAÇÃO', '', false, false),
	(44139, NULL, 1, 'COMPUTAÇÃO MÓVEL', '', false, false),
	(44158, NULL, 1, 'WEB SEMÂNTICA', '', false, false),
	(41010, NULL, 1, 'FUNDAMENTOS DE APRENDIZAGEM AUTOMÁTICA', '', false, false),
	(41687, NULL, 1, 'MINERAÇÃO DE DADOS EM LARGA ESCALA', '', false, false),
	(41781, NULL, 1, 'ANÁLISE E EXPLORAÇÃO DE VULNERABILIDADES', '', false, false),
	(40386, NULL, 3, 'ASPETOS PROFISSIONAIS E SOCIAIS DA ENGENHARIA INFORMÁTICA', '', false, false),
	(40387, NULL, 3, 'PROJETO EM INFORMÁTICA', '', false, false),
	(40534, NULL, 3, 'TÓPICOS DE APRENDIZAGEM AUTOMÁTICA', '', false, false),
	(41495, NULL, 3, 'ELETRÓNICA ANALÓGICA', '', false, false),
	(41769, NULL, 1, 'MODELAÇÃO DE SISTEMAS FÍSICOS', '', false, false),
	(40664, NULL, 2, 'TEORIAS DA COMUNICAÇÃO', '', false, false),
	(41652, NULL, 2, 'MATERIAIS E TECNOLOGIAS I', '', false, false),
	(41654, NULL, 2, 'DESIGN DE INTERACÇÃO', '', false, false),
	(41656, NULL, 2, 'MATERIAIS E TECNOLOGIAS II', '', false, false),
	(41658, NULL, 2, 'DESENHO E EXPRESSÃO II', '', false, false),
	(41663, NULL, 2, 'HISTÓRIA DO DESIGN PORTUGUÊS', '', false, false),
	(42484, NULL, 2, 'REPROGRAFIA', '', false, false),
	(47068, NULL, 2, 'DESENHO E EXPRESSÃO I', '', false, false),
	(49980, NULL, 2, 'PROJECTO EM DESIGN II', '', false, false),
	(49981, NULL, 2, 'PROJECTO EM DESIGN III', '', false, false),
	(41779, NULL, 1, 'SOFTWARE ROBUSTO', '', false, false),
	(41780, NULL, 1, 'CRIPTOGRAFIA APLICADA', '', false, false),
	(41782, NULL, 1, 'SEGURANÇA EM REDES DE COMUNICAÇÕES', '', false, false),
	(41783, NULL, 1, 'IDENTIFICAÇÃO, AUTENTICAÇÃO E AUTORIZAÇÃO', '', false, false),
	(41231, NULL, 1, 'INTERAÇÃO MULTIMODAL', '', false, false),
	(49705, NULL, 1, 'OPÇÃO A4', '', false, false),
	(49706, NULL, 1, 'OPÇÃO A3', '', false, false),
	(49707, NULL, 1, 'OPÇÃO B6', '', false, false),
	(49708, NULL, 1, 'OPÇÃO B5', '', false, false),
	(49709, NULL, 1, 'OPÇÃO B4', '', false, false),
	(45423, NULL, 3, 'INTRODUÇÃO À COMPUTAÇÃO GRÁFICA', '', false, false),
	(40914, NULL, 3, 'INVESTIGAÇÃO OPERACIONAL', '', false, false),
	(43948, NULL, 3, 'EMPREENDEDORISMO', '', false, false),
	(40755, NULL, 1, 'SIMULAÇÃO E OTIMIZAÇÃO', '', false, false),
	(41877, NULL, 1, 'SISTEMAS INTELIGENTES II', '', false, false),
	(41749, NULL, 2, 'PRÁTICA DE SOLDADURA', '', false, false);


--
-- Data for Name: teacher; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.teacher (id, name, personal_page) VALUES
	(1, 'José Nuno Panelas Nunes Lau', 'https://www.ua.pt/pt/p/10312826'),
	(2, 'Diogo Nuno Pereira Gomes', 'https://www.ua.pt/pt/p/10331537'),
	(3, 'João Paulo Silva Barraca', 'https://www.ua.pt/pt/p/10333322'),
	(4, 'Carlos Alberto da Costa Bastos', 'https://www.ua.pt/pt/p/10312427'),
	(5, 'Paulo Jorge dos Santos Gonçalves Ferreira', 'https://www.ua.pt/pt/p/10308388'),
	(6, 'Pedro Miguel Ribeiro Lavrador', 'https://www.ua.pt/pt/p/16606771'),
	(7, 'Carlos Manuel Azevedo Costa', 'https://www.ua.pt/pt/p/10322010'),
	(8, 'Joaquim Manuel Henriques de Sousa Pinto', 'https://www.ua.pt/pt/p/10312245'),
	(9, 'Maria Beatriz Alves de Sousa Santos', 'https://www.ua.pt/pt/p/10306666'),
	(10, 'Miguel Augusto Mendes Oliveira e Silva', 'https://www.ua.pt/pt/p/10313337'),
	(11, 'Tomás António Mendes Oliveira e Silva', 'https://www.ua.pt/pt/p/10309907'),
	(12, 'José Luis Guimarães Oliveira', 'https://www.ua.pt/pt/p/10309676'),
	(13, 'Ilídio Fernando de Castro Oliveira', 'https://www.ua.pt/pt/p/10318398'),
	(14, 'Telmo Reis Cunha', 'https://www.ua.pt/pt/p/10322185'),
	(15, 'José Manuel Neto Vieira', 'https://www.ua.pt/pt/p/10311461'),
	(16, 'António Manuel Duarte Nogueira', 'https://www.ua.pt/pt/p/10317117'),
	(17, 'Joaquim João Estrela Ribeiro Silvestre Madeira', 'https://www.ua.pt/en/p/10320092'),
	(18, 'Vera Ivanovna Kharlamova', 'https://www.ua.pt/pt/p/10317978'),
	(19, 'Isabel Alexandra Vieira Brás', 'https://www.ua.pt/pt/p/10310747'),
	(20, 'Paula Cristina Roque da Silva Rama', 'https://www.ua.pt/pt/p/10312567'),
	(21, 'António Manuel Rosa Pereira Caetano', 'https://www.ua.pt/pt/p/10312455'),
	(22, 'José Alexandre da Rocha Almeida', 'https://www.ua.pt/pt/p/10316585'),
	(23, 'Maria Raquel Rocha Pinto', 'https://www.ua.pt/pt/p/10312973'),
	(24, 'Mário Fernando dos Santos Ferreira', 'https://www.ua.pt/pt/p/10308549'),
	(25, 'Helder Troca Zagalo', 'https://www.ua.pt/pt/p/10316375'),
	(26, 'Ana Maria Perfeito Tomé', 'https://www.ua.pt/pt/p/10307429'),
	(27, 'João Manuel de Oliveira e Silva Rodrigues', 'https://www.ua.pt/pt/p/10314156'),
	(28, 'António Joaquim da Silva Teixeira', 'https://www.ua.pt/pt/p/10315017'),
	(29, 'Vitor José Babau Torres', 'https://www.ua.pt/pt/p/10307149'),
	(30, 'Luís Filipe de Seabra Lopes', 'https://www.ua.pt/pt/p/10314261'),
	(31, 'António José Ribeiro Neves', 'https://www.ua.pt/pt/p/16606785'),
	(32, 'Maria Elisa Carrancho Fernandes', 'https://www.ua.pt/pt/p/10321317'),
	(34, 'Cristina Isabel Assis de Morais Miguéns', 'https://www.ua.pt/pt/p/10333350'),
	(40, 'Pétia Georgieva Georgieva', 'https://www.ua.pt/pt/p/10321408');


--
-- Data for Name: team_colaborator; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.team_colaborator (user_id, mandate) VALUES
	(137, '2021'),
	(150, '2021'),
	(126, '2021'),
	(127, '2021'),
	(148, '2021'),
	(132, '2021'),
	(149, '2021'),
	(133, '2021'),
	(147, '2021'),
	(83, '2022'),
	(160, '2022'),
	(188, '2022'),
	(189, '2022'),
	(190, '2022'),
	(191, '2022'),
	(192, '2022'),
	(193, '2022'),
	(194, '2022'),
	(195, '2022'),
	(196, '2022'),
	(197, '2022'),
	(198, '2022'),
	(161, '2022/23'),
	(162, '2022/23'),
	(163, '2022/23'),
	(164, '2022/23'),
	(165, '2022/23'),
	(166, '2022/23'),
	(167, '2022/23'),
	(168, '2022/23'),
	(169, '2022/23'),
	(170, '2022/23'),
	(171, '2022/23'),
	(172, '2022/23'),
	(173, '2022/23'),
	(174, '2022/23'),
	(175, '2022/23'),
	(176, '2022/23'),
	(177, '2022/23'),
	(178, '2022/23'),
	(179, '2022/23'),
	(180, '2022/23'),
	(181, '2022/23'),
	(182, '2022/23'),
	(183, '2022/23'),
	(184, '2022/23'),
	(185, '2022/23'),
	(186, '2022/23'),
	(187, '2022/23'),
	(190, '2022/23'),
	(191, '2022/23'),
	(192, '2022/23'),
	(193, '2022/23'),
	(194, '2022/23'),
	(195, '2022/23'),
	(196, '2022/23'),
	(197, '2022/23');


--
-- Data for Name: team_member; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.team_member (id, header, mandate, user_id, role_id) VALUES
	(3, '/teams/2019/1.jpg', '2019', 65, 1),
	(6, '/teams/2019/2.jpg', '2019', 111, 4),
	(9, '/teams/2019/3.jpg', '2019', 56, 17),
	(12, '/teams/2019/4.jpg', '2019', 47, 18),
	(15, '/teams/2019/5.jpg', '2019', 118, 18),
	(18, '/teams/2019/6.jpg', '2019', 84, 7),
	(21, '/teams/2019/7.jpg', '2019', 102, 7),
	(24, '/teams/2019/8.jpg', '2019', 75, 7),
	(27, '/teams/2019/9.jpg', '2019', 53, 15),
	(30, '/teams/2019/10.jpg', '2019', 122, 15),
	(33, '/teams/2019/11.jpg', '2019', 22, 15),
	(36, '/teams/2019/12.jpg', '2019', 86, 3),
	(39, '/teams/2019/13.jpg', '2019', 30, 2),
	(42, '/teams/2019/14.jpg', '2019', 83, 5),
	(45, '/teams/2018/1.jpg', '2018', 65, 1),
	(48, '/teams/2018/2.jpg', '2018', 111, 4),
	(51, '/teams/2018/3.jpg', '2018', 102, 17),
	(54, '/teams/2018/4.jpg', '2018', 119, 17),
	(57, '/teams/2018/5.jpg', '2018', 24, 18),
	(60, '/teams/2018/6.jpg', '2018', 19, 18),
	(63, '/teams/2018/7.jpg', '2018', 60, 7),
	(66, '/teams/2018/8.jpg', '2018', 75, 7),
	(69, '/teams/2018/9.jpg', '2018', 121, 15),
	(72, '/teams/2018/10.jpg', '2018', 101, 15),
	(75, '/teams/2018/11.jpg', '2018', 100, 15),
	(78, '/teams/2018/12.jpg', '2018', 86, 3),
	(81, '/teams/2018/13.jpg', '2018', 51, 2),
	(84, '/teams/2018/14.jpg', '2018', 84, 5),
	(87, '/teams/2017/1.jpg', '2017', 54, 1),
	(90, '/teams/2017/2.jpg', '2017', 51, 4),
	(93, '/teams/2017/3.jpg', '2017', 31, 17),
	(96, '/teams/2017/4.jpg', '2017', 30, 17),
	(99, '/teams/2017/5.jpg', '2017', 35, 18),
	(102, '/teams/2017/6.jpg', '2017', 90, 18),
	(105, '/teams/2017/7.jpg', '2017', 45, 7),
	(108, '/teams/2017/8.jpg', '2017', 95, 7),
	(111, '/teams/2017/9.jpg', '2017', 19, 15),
	(114, '/teams/2017/10.jpg', '2017', 86, 15),
	(117, '/teams/2017/11.jpg', '2017', 11, 15),
	(120, '/teams/2017/12.jpg', '2017', 91, 3),
	(123, '/teams/2017/13.jpg', '2017', 110, 2),
	(126, '/teams/2017/14.jpg', '2017', 65, 5),
	(129, '/teams/2016/1.jpg', '2016', 105, 1),
	(132, '/teams/2016/2.jpg', '2016', 66, 4),
	(135, '/teams/2016/3.jpg', '2016', 31, 16),
	(138, '/teams/2016/4.jpg', '2016', 51, 16),
	(141, '/teams/2016/5.jpg', '2016', 62, 11),
	(144, '/teams/2016/6.jpg', '2016', 98, 11),
	(147, '/teams/2016/7.jpg', '2016', 2, 8),
	(150, '/teams/2016/8.jpg', '2016', 45, 8),
	(153, '/teams/2016/9.jpg', '2016', 54, 15),
	(156, '/teams/2016/10.jpg', '2016', 97, 15),
	(159, '/teams/2016/11.jpg', '2016', 26, 15),
	(162, '/teams/2016/12.jpg', '2016', 20, 3),
	(165, '/teams/2016/13.jpg', '2016', 110, 2),
	(168, '/teams/2016/14.jpg', '2016', 28, 5),
	(171, '/teams/2015/1.jpg', '2015', 110, 1),
	(174, '/teams/2015/2.jpg', '2015', 109, 4),
	(177, '/teams/2015/3.jpg', '2015', 46, 10),
	(180, '/teams/2015/4.jpg', '2015', 17, 10),
	(183, '/teams/2015/5.jpg', '2015', 88, 11),
	(186, '/teams/2015/6.jpg', '2015', 50, 11),
	(189, '/teams/2015/7.jpg', '2015', 78, 7),
	(192, '/teams/2015/8.jpg', '2015', 112, 7),
	(195, '/teams/2015/9.jpg', '2015', 66, 14),
	(198, '/teams/2015/10.jpg', '2015', 2, 14),
	(201, '/teams/2015/11.jpg', '2015', 54, 14),
	(204, '/teams/2015/12.jpg', '2015', 3, 3),
	(207, '/teams/2015/13.jpg', '2015', 58, 2),
	(210, '/teams/2015/14.jpg', '2015', 23, 5),
	(213, '/teams/2014/1.jpg', '2014', 92, 1),
	(216, '/teams/2014/2.jpg', '2014', 113, 4),
	(219, '/teams/2014/3.jpg', '2014', 110, 10),
	(222, '/teams/2014/4.jpg', '2014', 105, 10),
	(225, '/teams/2014/5.jpg', '2014', 82, 11),
	(228, '/teams/2014/6.jpg', '2014', 46, 11),
	(231, '/teams/2014/7.jpg', '2014', 52, 7),
	(234, '/teams/2014/8.jpg', '2014', 42, 7),
	(237, '/teams/2014/9.jpg', '2014', 107, 14),
	(240, '/teams/2014/10.jpg', '2014', 109, 14),
	(243, '/teams/2014/11.jpg', '2014', 10, 14),
	(246, '/teams/2014/12.jpg', '2014', 72, 3),
	(249, '/teams/2014/13.jpg', '2014', 108, 2),
	(252, '/teams/2014/14.jpg', '2014', 66, 5),
	(255, '/teams/2013/1.jpg', '2013', 92, 1),
	(258, '/teams/2013/2.jpg', '2013', 68, 4),
	(261, '/teams/2013/3.jpg', '2013', 39, 9),
	(264, '/teams/2013/4.jpg', '2013', 52, 9),
	(267, '/teams/2013/5.jpg', '2013', 41, 13),
	(270, '/teams/2013/6.jpg', '2013', 25, 8),
	(273, '/teams/2013/7.jpg', '2013', 113, 14),
	(276, '/teams/2013/8.jpg', '2013', 29, 3),
	(279, '/teams/2013/9.jpg', '2013', 58, 2),
	(282, '/teams/2013/10.jpg', '2013', 72, 5),
	(286, '/teams/2020/1.jpg', '2020', 102, 1),
	(289, '/teams/2020/2.jpg', '2020', 83, 4),
	(292, '/teams/2020/3.jpg', '2020', 94, 16),
	(295, '/teams/2020/4.jpg', '2020', 89, 18),
	(298, '/teams/2020/5.jpg', '2020', 40, 18),
	(301, '/teams/2020/6.jpg', '2020', 84, 6),
	(304, '/teams/2020/7.jpg', '2020', 59, 6),
	(307, '/teams/2020/8.jpg', '2020', 131, 12),
	(310, '/teams/2020/9.jpg', '2020', 55, 12),
	(313, '/teams/2020/10.jpg', '2020', 96, 15),
	(316, '/teams/2020/11.jpg', '2020', 103, 15),
	(319, '/teams/2020/12.jpg', '2020', 135, 3),
	(322, '/teams/2020/13.jpg', '2020', 86, 2),
	(325, '/teams/2020/14.jpg', '2020', 130, 5),
	(326, '/teams/2021/1.jpg', '2021', 83, 1),
	(327, '/teams/2021/2.jpg', '2021', 139, 4),
	(328, '/teams/2021/3.jpg', '2021', 49, 16),
	(329, '/teams/2021/4.jpg', '2021', 125, 18),
	(330, '/teams/2021/5.jpg', '2021', 143, 18),
	(331, '/teams/2021/6.jpg', '2021', 124, 18),
	(332, '/teams/2021/7.jpg', '2021', 141, 6),
	(333, '/teams/2021/8.jpg', '2021', 128, 6),
	(334, '/teams/2021/9.jpg', '2021', 136, 12),
	(335, '/teams/2021/10.jpg', '2021', 142, 15),
	(336, '/teams/2021/11.jpg', '2021', 40, 15),
	(337, '/teams/2021/12.jpg', '2021', 135, 2),
	(338, '/teams/2021/13.jpg', '2021', 144, 3),
	(339, '/teams/2021/14.jpg', '2021', 140, 5),
	(343, '/teams/2022/1.jpg', '2022', 139, 1),
	(361, '/teams/2022/2.jpg', '2022', 140, 4),
	(364, '/teams/2022/3.jpg', '2022', 150, 6),
	(367, '/teams/2022/4.jpg', '2022', 138, 11),
	(370, '/teams/2022/5.jpg', '2022', 153, 15),
	(373, '/teams/2022/6.jpg', '2022', 154, 3),
	(376, '/teams/2022/7.jpg', '2022', 135, 2),
	(379, '/teams/2022/8.jpg', '2022', 155, 5),
	(382, '/teams/2022/9.jpg', '2022', 133, 12),
	(385, '/teams/2022/10.jpg', '2022', 132, 15),
	(388, '/teams/2022/11.jpg', '2022', 156, 11),
	(391, '/teams/2022/12.jpg', '2022', 74, 16),
	(394, '/teams/2022/13.jpg', '2022', 157, 12),
	(397, '/teams/2022/14.jpg', '2022', 128, 6),
	(398, '/teams/2022-23/1.jpg', '2022/23', 139, 1),
	(399, '/teams/2022-23/2.jpg', '2022/23', 156, 4),
	(400, '/teams/2022-23/3.jpg', '2022/23', 74, 16),
	(401, '/teams/2022-23/4.jpg', '2022/23', 153, 15),
	(402, '/teams/2022-23/5.jpg', '2022/23', 198, 15),
	(403, '/teams/2022-23/6.jpg', '2022/23', 154, 2),
	(404, '/teams/2022-23/7.jpg', '2022/23', 135, 12),
	(405, '/teams/2022-23/8.jpg', '2022/23', 155, 3),
	(406, '/teams/2022-23/9.jpg', '2022/23', 133, 12),
	(407, '/teams/2022-23/10.jpg', '2022/23', 160, 5),
	(408, '/teams/2022-23/11.jpg', '2022/23', 138, 11),
	(409, '/teams/2022-23/12.jpg', '2022/23', 159, 6),
	(410, '/teams/2022-23/13.jpg', '2022/23', 157, 6),
	(411, '/teams/2022-23/14.jpg', '2022/23', 150, 6);


--
-- Data for Name: team_role; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.team_role (id, name, weight) VALUES
	(1, 'Coordenador', 6),
	(2, 'Presidente da Mesa da RGM', 3),
	(3, 'Primeiro Secretário da Mesa da RGM', 2),
	(4, 'Responsável Financeiro', 5),
	(5, 'Segundo Secretário da Mesa da RGM', 1),
	(6, 'Vogal da Secção Académica', 4),
	(7, 'Vogal da Secção Académica e Desportiva', 4),
	(8, 'Vogal da Secção Académica-Desportiva', 4),
	(9, 'Vogal da Secção Administrativa', 4),
	(10, 'Vogal da Secção Administrativa, Relações Externas e Merchandising', 4),
	(11, 'Vogal da Secção Comunicação e Imagem', 4),
	(12, 'Vogal da Secção Desportiva', 4),
	(13, 'Vogal da Secção Informativa', 4),
	(14, 'Vogal da Secção Pedagógica', 4),
	(15, 'Vogal da Secção Pedagógica e Social', 4),
	(16, 'Vogal da Secção da Administração Interna', 4),
	(17, 'Vogal da Secção da Administração Interna e Merchandising', 4),
	(18, 'Vogal da Secção da Comunicação e Imagem', 4);


--
-- Data for Name: user; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei."user" (id, iupi, nmec, hashed_password, name, surname, gender, image, curriculum, linkedin, github, scopes, updated_at, created_at, birthday) VALUES
	(1, NULL, NULL, '$argon2id$v=19$m=65536,t=3,p=4$Tumdc87ZG4PQmtP6f8+5Fw$g1qvQyunD053z1FJiX91OGocYeas4IwHUBW2CqtEgAU', 'NEI', 'AAUAv', NULL, NULL, NULL, NULL, NULL, '{ADMIN}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(2, NULL, NULL, '', 'Beatriz', 'Marques', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(3, NULL, NULL, '', 'André', 'Moleirinho', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(4, NULL, NULL, '', 'Alexandre', 'Lopes', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(5, NULL, NULL, '', 'Alina', 'Yanchuk', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(6, NULL, NULL, '', 'Ana', 'Ortega', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(7, NULL, NULL, '', 'Rafaela', 'Vieira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(8, NULL, NULL, '', 'André', 'Alves', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(9, NULL, NULL, '', 'André', 'Amarante', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(10, NULL, NULL, '', 'Bárbara', 'Neto', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(11, NULL, NULL, '', 'Bernardo', 'Domingues', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(12, NULL, NULL, '', 'Bruno', 'Barbosa', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(13, NULL, NULL, '', 'Bruno', 'Pinto', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(14, NULL, NULL, '', 'Camila', 'Uachave', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(15, NULL, NULL, '', 'Carina', 'Neves', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(16, NULL, NULL, '', 'Carlos', 'Pacheco', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(17, NULL, NULL, '', 'Carlota', 'Marques', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(18, NULL, NULL, '', 'Carolina', 'Araújo', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(19, NULL, NULL, '', 'Carolina', 'Albuquerque', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(20, NULL, NULL, '', 'Andreia', 'Ferreira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(21, NULL, NULL, '', 'Catarina', 'Vinagre', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(22, NULL, NULL, '', 'Cláudio', 'Costa', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(23, NULL, NULL, '', 'Cláudio', 'Santos', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(24, NULL, NULL, '', 'Carlos', 'Soares', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(25, NULL, NULL, '', 'João', 'Costa', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(26, NULL, NULL, '', 'Cristóvão', 'Freitas', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(27, NULL, NULL, '', 'Dinis', 'Cruz', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(28, NULL, NULL, '', 'Mimi', 'Cunha', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(29, NULL, NULL, '', 'Daniel', 'Rodrigues', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(30, NULL, NULL, '', 'David', 'Fernandes', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(31, NULL, NULL, '', 'David', 'Ferreira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(32, NULL, NULL, '', 'David', 'Ferreira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(33, NULL, NULL, '', 'Dimitri', 'Silva', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(34, NULL, NULL, '', 'Diogo', 'Andrade', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(35, NULL, NULL, '', 'Diogo', 'Reis', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(36, NULL, NULL, '', 'Diogo', 'Silva', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(37, NULL, NULL, '', 'Diogo', 'Bento', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(38, NULL, NULL, '', 'Diogo', 'Ramos', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(39, NULL, NULL, '', 'Diogo', 'Paiva', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(40, NULL, NULL, '', 'Duarte', 'Mortágua', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(41, NULL, NULL, '', 'Eduardo', 'Martins', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(42, NULL, NULL, '', 'Emanuel', 'Laranjo', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(44, NULL, NULL, '', 'Fábio', 'Almeida', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(45, NULL, NULL, '', 'Fábio', 'Barros', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(46, NULL, NULL, '', 'Filipe', 'Castro', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(47, NULL, NULL, '', 'Flávia', 'Figueiredo', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(48, NULL, NULL, '', 'Francisco', 'Silveira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(49, NULL, NULL, '', 'Gonçalo', 'Matos', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(50, NULL, NULL, '', 'Guilherme', 'Moura', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(51, NULL, NULL, '', 'Hugo', 'Pintor', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(52, NULL, NULL, '', 'Hugo', 'Correia', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(53, NULL, NULL, '', 'Hugo', 'Almeida', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(54, NULL, NULL, '', 'Inês', 'Correia', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(55, NULL, NULL, '', 'Isadora', 'Loredo', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(56, NULL, NULL, '', 'João', 'Vasconcelos', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(57, NULL, NULL, '', 'João', 'Costa', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(58, NULL, NULL, '', 'Joana', 'Coelho', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(59, NULL, NULL, '', 'João', 'Laranjo', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(60, NULL, NULL, '', 'João', 'Ribeiro', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(61, NULL, NULL, '', 'João', 'Ferreira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(62, NULL, NULL, '', 'João', 'Limas', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(63, NULL, NULL, '', 'João', 'Dias', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(64, NULL, NULL, '', 'João', 'Paúl', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(65, NULL, NULL, '', 'João Abílio', 'Rodrigues', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(66, NULL, NULL, '', 'João', 'Alegria', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(67, NULL, NULL, '', 'João', 'Soares', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(68, NULL, NULL, '', 'Jorge', 'Fernandes', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(69, NULL, NULL, '', 'José', 'Frias', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(70, NULL, NULL, '', 'José', 'Moreira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(71, NULL, NULL, '', 'José', 'Ribeiro', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(72, NULL, NULL, '', 'Josimar', 'Cassandra', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(73, NULL, NULL, '', 'João', 'Magalhães', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(75, NULL, NULL, '', 'Luís Miguel', 'Costa', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(76, NULL, NULL, '', 'Luís', 'Fonseca', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(77, NULL, NULL, '', 'Luís', 'Silva', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(78, NULL, NULL, '', 'Luis', 'Santos', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(79, NULL, NULL, '', 'Luís', 'Oliveira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(80, NULL, NULL, '', 'Marco', 'Miranda', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(81, NULL, NULL, '', 'Marco', 'Ventura', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(82, NULL, NULL, '', 'Marcos', 'Silva', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(84, NULL, NULL, '', 'Marta', 'Ferreira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(85, NULL, NULL, '', 'Maxlaine', 'Moreira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(86, NULL, NULL, '', 'Mariana', 'Sequeira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(87, NULL, NULL, '', 'Miguel', 'Mota', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(88, NULL, NULL, '', 'Miguel', 'Antunes', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(89, NULL, NULL, '', 'André', 'Morais', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(90, NULL, NULL, '', 'Paulo', 'Seixas', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(91, NULL, NULL, '', 'Andreia', 'Patrocínio', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(83, NULL, NULL, '', 'Margarida', 'Martins', NULL, NULL, NULL, NULL, NULL, '{}', '2023-05-22 12:38:29.003609', '2023-01-01 00:00:00', NULL),
	(43, NULL, NULL, '', 'Eduardo', 'Santos', NULL, NULL, NULL, NULL, NULL, '{}', '2023-05-31 16:24:53.510394', '2023-01-01 00:00:00', NULL),
	(92, NULL, NULL, '', 'Paulo', 'Pintor', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(93, NULL, NULL, '', 'Pedro', 'Bastos', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(94, NULL, NULL, '', 'Pedro', 'Ferreira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(95, NULL, NULL, '', 'Pedro', 'Matos', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(96, NULL, NULL, '', 'Pedro', 'Oliveira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(97, NULL, NULL, '', 'Jorge', 'Pereira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(98, NULL, NULL, '', 'João', 'Rodrigues', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(99, NULL, NULL, '', 'Pedro', 'Neves', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(100, NULL, NULL, '', 'Pedro', 'Pires', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(101, NULL, NULL, '', 'Rafael', 'Direito', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(102, NULL, NULL, '', 'Rafael', 'Teixeira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(103, NULL, NULL, '', 'Rafael', 'Simões', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(104, NULL, NULL, '', 'Rui', 'Fernandes', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(105, NULL, NULL, '', 'João', 'Peixe Ribeiro', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(106, NULL, NULL, '', 'Ricardo', 'Cruz', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(107, NULL, NULL, '', 'Ricardo', 'Mendes', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(108, NULL, NULL, '', 'Rita', 'Jesus', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(109, NULL, NULL, '', 'Rita', 'Portas', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(110, NULL, NULL, '', 'Rafael', 'Martins', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(112, NULL, NULL, '', 'Rui', 'Azevedo', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(113, NULL, NULL, '', 'Joana', 'Silva', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(114, NULL, NULL, '', 'Sandra', 'Andrade', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(115, NULL, NULL, '', 'Sérgio', 'Martins', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(116, NULL, NULL, '', 'Sara', 'Furão', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(117, NULL, NULL, '', 'Simão', 'Arrais', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(118, NULL, NULL, '', 'Sofia', 'Moniz', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(119, NULL, NULL, '', 'Tiago', 'Cardoso', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(120, NULL, NULL, '', 'Tiago', 'Mendes', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(121, NULL, NULL, '', 'Tomás', 'Batista', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(122, NULL, NULL, '', 'Tomás', 'Costa', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(123, NULL, NULL, '', 'Artur', 'Romão', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(124, NULL, NULL, '', 'Camila', 'Fonseca', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(125, NULL, NULL, '', 'Daniela', 'Dias', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(126, NULL, NULL, '', 'Diana', 'Siso', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(127, NULL, NULL, '', 'Diogo', 'Monteiro', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(128, NULL, NULL, '', 'Fábio', 'Martins', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(130, NULL, NULL, '', 'Mariana', 'Rosa', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(131, NULL, NULL, '', 'Marta', 'Fradique', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(132, NULL, NULL, '', 'Miguel', 'Ferreira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(133, NULL, NULL, '', 'Paulo', 'Pereira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(134, NULL, NULL, '', 'Pedro', 'Sobral', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(136, NULL, NULL, '', 'Vitor', 'Dias', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(137, NULL, NULL, '', 'Afonso', 'Campos', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(138, NULL, NULL, '', 'Yanis', 'Faquir', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(139, NULL, NULL, '', 'Pedro', 'Figueiredo', NULL, NULL, NULL, 'https://www.linkedin.com/in/pedro-figueiredo-9983181ba/', 'https://github.com/PFig420', '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(140, NULL, NULL, '', 'Artur', 'Correia', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(141, NULL, NULL, '', 'André', 'Benquerença', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(142, NULL, NULL, '', 'Daniel', 'Carvalho', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(143, NULL, NULL, '', 'Rafael', 'Gonçalves', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(145, NULL, NULL, '', 'Rodrigo', 'Oliveira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(146, NULL, NULL, '', 'Miguel', 'Fonseca', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(147, NULL, NULL, '', 'Catarina', 'Costa', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(148, NULL, NULL, '', 'Leonardo', 'Almeida', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(149, NULL, NULL, '', 'Lucius', 'Filho', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(150, NULL, NULL, '', 'Daniel', 'Ferreira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(151, NULL, NULL, '', 'Filipe', 'Silva', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(152, NULL, NULL, '', 'Alexandre', 'Santos', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(153, NULL, NULL, '', 'Vicente', 'Barros', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(155, NULL, NULL, '', 'Rafaela', 'Abrunhosa', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(156, NULL, NULL, '', 'Matilde', 'Teixeira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(159, NULL, NULL, '', 'Pedro', 'Rei', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(161, NULL, NULL, '', 'Tomás', 'Almeida', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(162, NULL, NULL, '', 'Bernado', 'Leandro', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(163, NULL, NULL, '', 'Lia', 'Cardoso', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(164, NULL, NULL, '', 'Violeta', 'Ramos', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(165, NULL, NULL, '', 'Marta', 'Inácio', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(166, NULL, NULL, '', 'Bárbara', 'Galiza', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(167, NULL, NULL, '', 'Roberto', 'Castro', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(169, NULL, NULL, '', 'Diogo', 'Fernandes', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(170, NULL, NULL, '', 'Ricardo', 'Martins', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(171, NULL, NULL, '', 'Fábio', 'Matias', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(172, NULL, NULL, '', 'Carolina', 'Silva', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(173, NULL, NULL, '', 'André', 'Dora', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(174, NULL, NULL, '', 'Raquel', 'Vinagre', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(175, NULL, NULL, '', 'Hugo', 'Castro', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(176, NULL, NULL, '', 'Henrique', 'Mendonça', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(177, NULL, NULL, '', 'Daniel', 'Figueiredo', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(178, NULL, NULL, '', 'Ana Rita', 'Silva', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(180, NULL, NULL, '', 'Joana', 'Gomes', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(181, NULL, NULL, '', 'António', 'Alberto', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(182, NULL, NULL, '', 'Regina', 'Tavares', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(179, NULL, NULL, '', 'João', 'Capucho', NULL, NULL, NULL, NULL, NULL, '{}', '2023-05-05 21:25:05.579838', '2023-01-01 00:00:00', NULL),
	(111, NULL, NULL, '', 'Rui', 'Coelho', NULL, NULL, NULL, NULL, NULL, '{}', '2023-05-07 16:22:42.156735', '2023-01-01 00:00:00', NULL),
	(183, NULL, NULL, '', 'Maria', 'Linhares', NULL, NULL, NULL, NULL, NULL, '{}', '2023-05-09 23:35:47.766051', '2023-01-01 00:00:00', NULL),
	(144, NULL, NULL, '', 'Inês', 'Ferreira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-05-11 17:37:00.739449', '2023-01-01 00:00:00', NULL),
	(160, NULL, NULL, '', 'João', 'Luís', 'MALE', NULL, NULL, NULL, 'https://github.com/jnluis', '{}', '2023-05-19 20:35:12.928434', '2023-01-01 00:00:00', '2003-02-25'),
	(129, NULL, NULL, '', 'João', 'Reis', NULL, NULL, NULL, NULL, NULL, '{}', '2023-05-21 14:25:28.643725', '2023-01-01 00:00:00', NULL),
	(154, NULL, NULL, '', 'Tiago', 'Gomes', NULL, NULL, NULL, NULL, NULL, '{}', '2023-05-28 16:14:49.329866', '2023-01-01 00:00:00', NULL),
	(184, NULL, NULL, '', 'Guilherme', 'Rosa', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(185, NULL, NULL, '', 'Henrique', 'Teixeira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(186, NULL, NULL, '', 'Gabriel', 'Teixeira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(187, NULL, NULL, '', 'Tomás', 'Victal', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(188, NULL, NULL, '', 'Luca', 'Pereira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(189, NULL, NULL, '', 'Gonçalo', 'Sousa', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(190, NULL, NULL, '', 'Vicente', 'Costa', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(196, NULL, NULL, '', 'Bernardo', 'Figueiredo', NULL, '/users/196/profile.jpg', NULL, NULL, NULL, '{}', '2023-06-04 02:13:44.67189', '2023-01-01 00:00:00', NULL),
	(193, NULL, NULL, '', 'Eduardo', 'Fernandes', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(194, NULL, NULL, '', 'Diana', 'Miranda', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(195, NULL, NULL, '', 'José', 'Gameiro', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(198, NULL, NULL, '', 'João', 'Borges', NULL, NULL, NULL, NULL, NULL, '{}', '2023-01-01 00:00:00', '2023-01-01 00:00:00', NULL),
	(157, NULL, NULL, '', 'Hugo', 'Correia', 'MALE', '/users/157/profile.jpg', NULL, 'https://pt.pornhub.com/', 'https://github.com/MrLoydHD', '{}', '2023-06-04 02:30:04.44905', '2023-01-01 00:00:00', '2003-01-03'),
	(74, NULL, NULL, '$argon2id$v=19$m=65536,t=3,p=4$2rsXohTivJfSujcmJARgrA$1PndJW47wdBvZ5lGMvAUOxk2KvFgtUk9qYzUS2rNMj4', 'Leandro', 'Silva', 'MALE', '/users/74/profile.jpg', NULL, NULL, 'https://github.com/leand12', '{}', '2023-06-04 03:42:26.059075', '2023-01-01 00:00:00', '2000-09-19'),
	(220, NULL, NULL, NULL, 'Vitalie', 'Bologa', NULL, '/users/220/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-30 15:06:57.218351', '2023-05-30 15:06:57.218343', NULL),
	(199, NULL, NULL, NULL, 'Gonçalo', 'Lopes', NULL, '/users/199/profile.jpg', NULL, NULL, NULL, '{}', '2023-04-24 22:39:31.483411', '2023-04-24 22:39:31.483403', NULL),
	(192, NULL, NULL, '', 'Pedro', 'Monteiro', NULL, NULL, NULL, NULL, NULL, '{}', '2023-04-25 14:32:38.556216', '2023-01-01 00:00:00', NULL),
	(200, NULL, NULL, NULL, 'Pedro', 'Duarte', NULL, '/users/200/profile.jpg', NULL, NULL, NULL, '{}', '2023-04-25 14:33:25.55307', '2023-04-25 14:32:46.405023', NULL),
	(168, NULL, NULL, '', 'Diogo', 'Falcão', 'MALE', '/users/168/profile.jpg', NULL, NULL, 'https://github.com/falcaodiogo', '{}', '2023-04-30 19:24:51.111658', '2023-01-01 00:00:00', '2003-03-26'),
	(202, NULL, NULL, NULL, 'José', 'Trigo', NULL, '/users/202/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-03 23:13:20.599937', '2023-05-03 23:13:20.599932', NULL),
	(191, NULL, NULL, '', 'Daniel', 'Madureira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-05-04 17:30:38.160591', '2023-01-01 00:00:00', NULL),
	(203, NULL, NULL, NULL, 'Emanuel', 'Marques', NULL, '/users/203/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-04 20:46:09.1129', '2023-05-04 20:46:02.709208', NULL),
	(204, NULL, NULL, NULL, 'José', 'Mendes', NULL, '/users/204/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-05 11:14:42.678164', '2023-05-05 11:14:42.678156', NULL),
	(206, NULL, NULL, NULL, 'José', 'Oliveira', NULL, '/users/206/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-05 14:15:56.882918', '2023-05-05 14:15:56.88291', NULL),
	(197, NULL, NULL, '', 'Alexandre', 'Cotorobai', 'MALE', NULL, NULL, NULL, 'https://github.com/AlexandreCotorobai', '{}', '2023-05-05 21:21:39.106511', '2023-01-01 00:00:00', '2023-05-08'),
	(205, NULL, NULL, NULL, 'Zakhar', 'Kruptsala', NULL, '/users/205/profile.jpg', NULL, NULL, 'https://github.com/Blosuhm', '{}', '2023-05-05 23:20:34.794436', '2023-05-05 13:31:41.678051', '1900-01-02'),
	(201, NULL, NULL, NULL, 'Duarte', 'Cruz', NULL, '/users/201/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-13 23:02:33.987284', '2023-05-01 21:09:12.916836', NULL),
	(209, NULL, NULL, NULL, 'João', 'Farias', 'MALE', '/users/209/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-10 15:45:48.140384', '2023-05-10 15:45:25.171577', NULL),
	(210, NULL, NULL, NULL, 'Mariana', 'Andrade', NULL, '/users/210/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-10 18:36:26.513615', '2023-05-10 18:36:26.51361', NULL),
	(211, NULL, NULL, NULL, 'Sebastião', 'Teixeira', NULL, '/users/211/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-10 21:42:02.63965', '2023-05-10 21:42:02.639643', NULL),
	(214, NULL, NULL, NULL, 'Airton', 'Moreira', NULL, '/users/214/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-14 17:21:48.415499', '2023-05-14 17:21:48.41549', NULL),
	(212, NULL, NULL, NULL, 'André', 'Fernandes', NULL, '/users/212/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-11 17:37:47.679807', '2023-05-11 17:37:28.839187', NULL),
	(215, NULL, NULL, '$argon2id$v=19$m=65536,t=3,p=4$UYpRCkHIuRfCGEOI8R5jjA$c1TScwYvvg2tP0rprO3DEfI/w1LeXCP4MKwCQKnWgTM', 'Apgm', 'Moreira', NULL, NULL, NULL, NULL, NULL, '{}', '2023-05-14 17:26:30.292516', '2023-05-14 17:26:30.292508', NULL),
	(213, NULL, NULL, NULL, 'Tiago', 'Carvalho', 'MALE', '/users/213/profile.jpg', NULL, 'https://www.linkedin.com/in/tiagosora/', 'https://github.com/tiagosora', '{}', '2023-05-12 23:19:25.768274', '2023-05-12 23:16:00.060341', '2023-04-12'),
	(216, NULL, NULL, NULL, 'Tiago', 'Cruz', NULL, '/users/216/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-15 00:15:30.141798', '2023-05-15 00:15:30.141791', NULL),
	(217, NULL, NULL, NULL, 'Simão', 'Antunes', NULL, '/users/217/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-16 14:27:36.097848', '2023-05-16 14:27:36.097841', NULL),
	(135, NULL, NULL, '', 'Renato', 'Dias', 'MALE', '/users/135/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-16 14:46:47.928536', '2023-01-01 00:00:00', '2001-07-08'),
	(218, NULL, NULL, NULL, 'Paulo', 'Pinto', NULL, '/users/218/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-22 17:52:25.651137', '2023-05-22 17:52:25.651128', NULL),
	(208, NULL, NULL, NULL, 'Nicole', 'Cunha', 'FEMALE', '/users/208/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-31 22:39:44.1846', '2023-05-06 21:53:25.376539', '2003-08-29'),
	(219, NULL, NULL, NULL, 'Bruno', 'Meixedo', NULL, '/users/219/profile.jpg', NULL, NULL, NULL, '{}', '2023-05-24 18:36:07.925906', '2023-05-24 18:35:46.540508', NULL),
	(207, NULL, NULL, NULL, 'Igor', 'Coelho', NULL, '/users/207/profile.jpg', NULL, NULL, NULL, '{}', '2023-06-02 22:14:02.005916', '2023-05-05 21:21:22.828628', NULL),
	(221, NULL, NULL, NULL, 'Liliana', 'Ribeiro', NULL, '/users/221/profile.jpg', NULL, NULL, NULL, '{}', '2023-06-04 02:12:25.511903', '2023-06-04 02:11:47.133052', NULL);


--
-- Data for Name: user_academic_details; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.user_academic_details (id, user_id, course_id, curricular_year, created_at) VALUES
	(1, 74, 9263, 2, '2023-06-04 03:42:26.070155'),
	(69, 199, 8295, 2, '2023-04-24 22:39:31.52826'),
	(70, 192, 9263, 1, '2023-04-25 14:32:38.569204'),
	(71, 200, 9263, 1, '2023-04-25 14:32:46.418088'),
	(72, 168, 8295, 2, '2023-04-30 19:23:12.674994'),
	(75, 202, 9263, 1, '2023-05-03 23:13:20.617391'),
	(76, 191, 8295, 2, '2023-05-04 17:30:38.173541'),
	(77, 203, 8295, 3, '2023-05-04 20:46:09.124428'),
	(78, 204, 8295, 1, '2023-05-05 11:14:42.698592'),
	(80, 206, 8295, 1, '2023-05-05 14:15:56.900681'),
	(2, 197, 8295, 2, '2023-05-05 21:21:13.978534'),
	(83, 179, 8295, 1, '2023-05-05 21:25:05.597237'),
	(79, 205, 8295, 1, '2023-05-05 23:16:44.276306'),
	(85, 111, 9281, 1, '2023-05-07 16:22:42.165279'),
	(86, 183, 8295, 1, '2023-05-09 23:35:47.778691'),
	(87, 209, 9263, 1, '2023-05-10 15:45:25.189455'),
	(88, 210, 8295, 3, '2023-05-10 18:36:26.531803'),
	(89, 211, 8295, 1, '2023-05-10 21:42:02.657684'),
	(90, 144, 8295, 3, '2023-05-11 17:37:00.754153'),
	(91, 212, 8295, 3, '2023-05-11 17:37:47.69209'),
	(92, 213, 8295, 3, '2023-05-12 23:16:00.111967'),
	(73, 201, 8295, 2, '2023-05-13 22:26:02.119738'),
	(93, 214, 8295, 3, '2023-05-14 17:21:48.435897'),
	(94, 216, 8295, 2, '2023-05-15 00:15:30.182046'),
	(95, 217, 8295, 3, '2023-05-16 14:27:36.116437'),
	(36, 135, 9263, 1, '2023-05-16 14:46:47.940807'),
	(96, 160, 8295, 2, '2023-05-19 20:34:31.340952'),
	(97, 129, 9263, 1, '2023-05-21 14:25:28.656225'),
	(98, 83, 9263, 2, '2023-05-22 12:38:29.016063'),
	(99, 218, 8295, 3, '2023-05-22 17:52:25.673124'),
	(100, 219, 8295, 1, '2023-05-24 18:35:51.821539'),
	(35, 154, 8295, 2, '2023-05-28 16:14:49.342339'),
	(101, 220, 8295, 2, '2023-05-30 15:06:57.23639'),
	(102, 43, 9263, 1, '2023-05-31 16:24:53.521136'),
	(84, 208, 8246, 2, '2023-05-31 22:39:44.198404'),
	(81, 207, 8295, 1, '2023-06-02 22:14:02.019319'),
	(82, 196, 8295, 2, '2023-06-04 02:12:24.406875'),
	(74, 157, 8295, 2, '2023-06-04 02:12:25.150897'),
	(103, 221, 8295, 2, '2023-06-04 02:12:25.523431');


--
-- Data for Name: user_academic_details__subjects; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.user_academic_details__subjects (user_academic_details_id, subject) VALUES
	(1, 41226),
	(1, 43370),
	(1, 49711),
	(1, 49997),
	(2, 40337),
	(2, 40381),
	(2, 40382),
	(2, 40383),
	(2, 40432),
	(2, 40437),
	(2, 41469),
	(2, 41549),
	(2, 41770),
	(2, 42532),
	(35, 40337),
	(35, 40381),
	(35, 40382),
	(35, 40383),
	(35, 40432),
	(35, 40437),
	(35, 41469),
	(35, 41549),
	(35, 41770),
	(35, 42532),
	(36, 40751),
	(36, 40752),
	(36, 40754),
	(36, 40756),
	(36, 40757),
	(36, 41492),
	(36, 42596),
	(36, 44139),
	(36, 44158),
	(36, 45587),
	(69, 40337),
	(69, 40381),
	(69, 40382),
	(69, 40383),
	(69, 40432),
	(69, 40437),
	(69, 41469),
	(69, 41549),
	(69, 41770),
	(69, 42532),
	(70, 40751),
	(70, 40752),
	(70, 40753),
	(70, 40754),
	(70, 40756),
	(70, 41010),
	(70, 41492),
	(70, 41687),
	(70, 44156),
	(70, 45587),
	(71, 40752),
	(71, 40756),
	(71, 41492),
	(71, 41687),
	(71, 41781),
	(72, 40337),
	(72, 40379),
	(72, 40381),
	(72, 40382),
	(72, 40383),
	(72, 40432),
	(72, 40436),
	(72, 40437),
	(72, 41549),
	(72, 41770),
	(72, 42502),
	(72, 42532),
	(73, 40337),
	(73, 40381),
	(73, 40382),
	(73, 40383),
	(73, 40432),
	(73, 40437),
	(73, 41469),
	(73, 41549),
	(73, 41770),
	(73, 42532),
	(74, 40337),
	(74, 40381),
	(74, 40382),
	(74, 40383),
	(74, 40432),
	(74, 40437),
	(74, 41469),
	(74, 41549),
	(74, 41770),
	(74, 42532),
	(75, 40751),
	(75, 40752),
	(75, 40753),
	(75, 40754),
	(75, 40756),
	(75, 41492),
	(75, 41687),
	(75, 42596),
	(75, 44156),
	(75, 45587),
	(76, 40337),
	(76, 40381),
	(76, 40382),
	(76, 40383),
	(76, 40432),
	(76, 40437),
	(76, 41469),
	(76, 41549),
	(76, 41770),
	(76, 42532),
	(77, 40384),
	(77, 40385),
	(77, 40386),
	(77, 40387),
	(77, 40534),
	(77, 40551),
	(77, 40846),
	(77, 41495),
	(77, 42573),
	(77, 45426),
	(78, 40379),
	(78, 40380),
	(78, 40431),
	(78, 40436),
	(78, 41769),
	(78, 42502),
	(78, 42709),
	(78, 42728),
	(78, 42729),
	(78, 47166),
	(79, 40379),
	(79, 40380),
	(79, 40431),
	(79, 40436),
	(79, 41769),
	(79, 42502),
	(79, 42709),
	(79, 42728),
	(79, 42729),
	(79, 47166),
	(80, 40379),
	(80, 40380),
	(80, 40431),
	(80, 40436),
	(80, 41769),
	(80, 42502),
	(80, 42709),
	(80, 42728),
	(80, 42729),
	(80, 47166),
	(81, 40379),
	(81, 40380),
	(81, 40431),
	(81, 40436),
	(81, 41769),
	(81, 42502),
	(81, 42709),
	(81, 42728),
	(81, 42729),
	(81, 47166),
	(82, 40337),
	(82, 40381),
	(82, 40382),
	(82, 40383),
	(82, 40432),
	(82, 40437),
	(82, 41469),
	(82, 41549),
	(82, 41770),
	(82, 42532),
	(83, 40379),
	(83, 40380),
	(83, 40431),
	(83, 40436),
	(83, 41769),
	(83, 42502),
	(83, 42709),
	(83, 42728),
	(83, 42729),
	(83, 47166),
	(84, 40664),
	(84, 41652),
	(84, 41654),
	(84, 41656),
	(84, 41658),
	(84, 41663),
	(84, 42484),
	(84, 47068),
	(84, 49980),
	(84, 49981),
	(85, 41779),
	(85, 41780),
	(85, 41781),
	(85, 41782),
	(85, 41783),
	(86, 40379),
	(86, 40380),
	(86, 40431),
	(86, 40436),
	(86, 41769),
	(86, 42502),
	(86, 42709),
	(86, 42728),
	(86, 42729),
	(86, 47166),
	(87, 40751),
	(87, 41231),
	(87, 41492),
	(87, 42596),
	(87, 44156),
	(87, 49705),
	(87, 49706),
	(87, 49707),
	(87, 49708),
	(87, 49709),
	(88, 40384),
	(88, 40385),
	(88, 40386),
	(88, 40387),
	(88, 40534),
	(88, 40551),
	(88, 40846),
	(88, 42573),
	(88, 45426),
	(89, 40379),
	(89, 40380),
	(89, 40431),
	(89, 40436),
	(89, 41769),
	(89, 42502),
	(89, 42709),
	(89, 42728),
	(89, 42729),
	(89, 47166),
	(90, 40337),
	(90, 40381),
	(90, 40382),
	(90, 40383),
	(90, 40385),
	(90, 40386),
	(90, 40846),
	(90, 41469),
	(90, 41770),
	(90, 45426),
	(91, 40337),
	(91, 40382),
	(91, 40383),
	(91, 40384),
	(91, 40432),
	(91, 40846),
	(91, 41469),
	(91, 42532),
	(91, 42573),
	(91, 45426),
	(92, 40384),
	(92, 40385),
	(92, 40386),
	(92, 40387),
	(92, 40551),
	(92, 40846),
	(92, 42573),
	(92, 45423),
	(92, 45426),
	(93, 40337),
	(93, 40381),
	(93, 40383),
	(93, 40385),
	(93, 40432),
	(93, 41549),
	(93, 41769),
	(93, 42728),
	(93, 47166),
	(94, 40337),
	(94, 40381),
	(94, 40382),
	(94, 40383),
	(94, 40432),
	(94, 40437),
	(94, 41469),
	(94, 41549),
	(94, 41770),
	(94, 42532),
	(95, 40381),
	(95, 40385),
	(95, 40386),
	(95, 40432),
	(95, 40846),
	(95, 40914),
	(95, 41469),
	(95, 42573),
	(95, 43948),
	(95, 45426),
	(96, 40337),
	(96, 40381),
	(96, 40382),
	(96, 40383),
	(96, 40432),
	(96, 40437),
	(96, 41469),
	(96, 41549),
	(96, 41770),
	(96, 42532),
	(97, 40751),
	(97, 40752),
	(97, 40753),
	(97, 40754),
	(97, 40755),
	(97, 41010),
	(97, 41231),
	(97, 41492),
	(97, 41877),
	(97, 42596),
	(98, 41226),
	(98, 41749),
	(98, 49711),
	(98, 49997),
	(99, 40384),
	(99, 40385),
	(99, 40386),
	(99, 40387),
	(99, 40534),
	(99, 40551),
	(99, 40846),
	(99, 42573),
	(99, 45426),
	(100, 40379),
	(100, 40380),
	(100, 40431),
	(100, 40436),
	(100, 41769),
	(100, 42502),
	(100, 42709),
	(100, 42728),
	(100, 42729),
	(100, 47166),
	(101, 40337),
	(101, 40381),
	(101, 40382),
	(101, 40383),
	(101, 40432),
	(101, 40437),
	(101, 41469),
	(101, 41549),
	(101, 41770),
	(101, 42532),
	(101, 47166),
	(102, 40751),
	(102, 40754),
	(102, 41492),
	(102, 41687),
	(102, 44158),
	(103, 40337),
	(103, 40381),
	(103, 40382),
	(103, 40383),
	(103, 40432),
	(103, 40437),
	(103, 41469),
	(103, 41549),
	(103, 41770),
	(103, 42532);


--
-- Data for Name: user_email; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.user_email (email, user_id, active) VALUES
	('nei@aauav.pt', 1, true),
	('abbm@ua.pt', 2, true),
	('afmoleirinho@ua.pt', 3, true),
	('alexandrejflopes@ua.pt', 4, true),
	('alinayanchuk@ua.pt', 5, true),
	('anaortega@ua.pt', 6, true),
	('anarafaela98@ua.pt', 7, true),
	('andre.alves@ua.pt', 8, true),
	('andreribau@ua.pt', 9, true),
	('barbara.jael@ua.pt', 10, true),
	('bernardo.domingues@ua.pt', 11, true),
	('brunobarbosa@ua.pt', 12, true),
	('brunopinto5151@ua.pt', 13, true),
	('camilauachave@ua.pt', 14, true),
	('carina.f.f.neves@ua.pt', 15, true),
	('carlos.pacheco@ua.pt', 16, true),
	('carlotamarques@ua.pt', 17, true),
	('carolina.araujo00@ua.pt', 18, true),
	('carolinaalbuquerque@ua.pt', 19, true),
	('castroferreira@ua.pt', 20, true),
	('catarinajvinagre@ua.pt', 21, true),
	('claudio.costa@ua.pt', 22, true),
	('claudioveigas@ua.pt', 23, true),
	('cmsoares@ua.pt', 24, true),
	('costa.j@ua.pt', 25, true),
	('cristovaofreitas@ua.pt', 26, true),
	('cruzdinis@ua.pt', 27, true),
	('cunha.filipa.ana@ua.pt', 28, true),
	('daniel.v.rodrigues@ua.pt', 29, true),
	('dasfernandes@ua.pt', 30, true),
	('davidcruzferreira@ua.pt', 31, true),
	('davidsantosferreira@ua.pt', 32, true),
	('dimitrisilva@ua.pt', 33, true),
	('diogo.andrade@ua.pt', 34, true),
	('diogo.reis@ua.pt', 35, true),
	('diogo04@ua.pt', 36, true),
	('diogobento@ua.pt', 37, true),
	('diogorafael@ua.pt', 38, true),
	('dpaiva@ua.pt', 39, true),
	('duarte.ntm@ua.pt', 40, true),
	('e.martins@ua.pt', 41, true),
	('ealaranjo@ua.pt', 42, true),
	('eduardosantoshf@ua.pt', 43, true),
	('fabio.almeida@ua.pt', 44, true),
	('fabiodaniel@ua.pt', 45, true),
	('filipemcastro@ua.pt', 46, true),
	('flaviafigueiredo@ua.pt', 47, true),
	('franciscosilveira@ua.pt', 48, true),
	('gmatos.ferreira@ua.pt', 49, true),
	('gpmoura@ua.pt', 50, true),
	('hrcpintor@ua.pt', 51, true),
	('hugo.andre@ua.pt', 52, true),
	('hugofpaiva@ua.pt', 53, true),
	('ines.gomes.correia@ua.pt', 54, true),
	('isadora.fl@ua.pt', 55, true),
	('j.vasconcelos99@ua.pt', 56, true),
	('jarturcosta@ua.pt', 57, true),
	('joana.coelho@ua.pt', 58, true),
	('joao.laranjo@ua.pt', 59, true),
	('joaoantonioribeiro@ua.pt', 60, true),
	('joaogferreira@ua.pt', 61, true),
	('joaolimas@ua.pt', 62, true),
	('joaomadias@ua.pt', 63, true),
	('joaopaul@ua.pt', 64, true),
	('joaosilva9@ua.pt', 65, true),
	('joaotalegria@ua.pt', 66, true),
	('joaots@ua.pt', 67, true),
	('jorge.fernandes@ua.pt', 68, true),
	('josefrias99@ua.pt', 69, true),
	('joseppmoreira@ua.pt', 70, true),
	('josepribeiro@ua.pt', 71, true),
	('josimarcassandra@ua.pt', 72, true),
	('jrsrm@ua.pt', 73, true),
	('leandrosilva12@ua.pt', 74, true),
	('lmcosta98@ua.pt', 75, true),
	('luiscdf@ua.pt', 76, true),
	('luisfgbs@ua.pt', 77, true),
	('luisfsantos@ua.pt', 78, true),
	('luisoliveira98@ua.pt', 79, true),
	('marco.miranda@ua.pt', 80, true),
	('marcoandreventura@ua.pt', 81, true),
	('marcossilva@ua.pt', 82, true),
	('margarida.martins@ua.pt', 83, true),
	('martasferreira@ua.pt', 84, true),
	('maxlainesmoreira@ua.pt', 85, true),
	('mfs98@ua.pt', 86, true),
	('miguel.mota@ua.pt', 87, true),
	('miguelaantunes@ua.pt', 88, true),
	('moraisandre@ua.pt', 89, true),
	('p.seixas96@ua.pt', 90, true),
	('patrocinioandreia@ua.pt', 91, true),
	('paulopintor@ua.pt', 92, true),
	('pedro.bas@ua.pt', 93, true),
	('pedro.joseferreira@ua.pt', 94, true),
	('pedroguilhermematos@ua.pt', 95, true),
	('pedrooliveira99@ua.pt', 96, true),
	('pereira.jorge@ua.pt', 97, true),
	('pgr96@ua.pt', 98, true),
	('pmn@ua.pt', 99, true),
	('ptpires@ua.pt', 100, true),
	('rafael.neves.direito@ua.pt', 101, true),
	('rafaelgteixeira@ua.pt', 102, true),
	('rafaeljsimoes@ua.pt', 103, true),
	('rfmf@ua.pt', 104, true),
	('ribeirojoao@ua.pt', 105, true),
	('ricardo.cruz29@ua.pt', 106, true),
	('ricardo.mendes@ua.pt', 107, true),
	('ritajesus@ua.pt', 108, true),
	('ritareisportas@ua.pt', 109, true),
	('rjmartins@ua.pt', 110, true),
	('ruicoelho@ua.pt', 111, true),
	('ruimazevedo@ua.pt', 112, true),
	('s.joana@ua.pt', 113, true),
	('sandraandrade@ua.pt', 114, true),
	('sergiomartins8@ua.pt', 115, true),
	('sfurao@ua.pt', 116, true),
	('simaoarrais@ua.pt', 117, true),
	('sofiamoniz@ua.pt', 118, true),
	('t.cardoso@ua.pt', 119, true),
	('tiagocmendes@ua.pt', 120, true),
	('tomasbatista99@ua.pt', 121, true),
	('tomascosta@ua.pt', 122, true),
	('artur.romao@ua.pt', 123, true),
	('cffonseca@ua.pt', 124, true),
	('ddias@ua.pt', 125, true),
	('diana.siso@ua.pt', 126, true),
	('diogo.mo.monteiro@ua.pt', 127, true),
	('fabio.m@ua.pt', 128, true),
	('joaoreis16@ua.pt', 129, true),
	('marianarosa@ua.pt', 130, true),
	('martafradique@ua.pt', 131, true),
	('miguel.r.ferreira@ua.pt', 132, true),
	('paulogspereira@ua.pt', 133, true),
	('sobral@ua.pt', 134, true),
	('renatoaldias12@ua.pt', 135, true),
	('vfrd00@ua.pt', 136, true),
	('afonso.campos@ua.pt', 137, true),
	('yanismarinafaquir@ua.pt', 138, true),
	('palexandre09@ua.pt', 139, true),
	('art.afo@ua.pt', 140, true),
	('andre.bmgf22@gmail.com', 141, true),
	('dl.carvalho@ua.pt', 142, true),
	('rfg@ua.pt', 143, true),
	('inesferreira02@ua.pt', 144, true),
	('rfo08@hotmail.com', 145, true),
	('catarinateves02@ua.pt', 147, true),
	('leonardoalmeida7@ua.pt', 148, true),
	('luciusviniciusf@ua.pt', 149, true),
	('danielmartinsferreira@ua.pt', 150, true),
	('vmabarros@ua.pt', 153, true),
	('tiagocgomes@ua.pt', 154, true),
	('maria.abrunhosa@ua.pt', 155, true),
	('matilde.teixeira@ua.pt', 156, true),
	('hf.correia@ua.pt', 157, true),
	('pedrorrei@ua.pt', 159, true),
	('jnluis@ua.pt', 160, true),
	('Tomasalmeida8@ua.pt', 161, true),
	('bernardoleandro1@ua.pt', 162, true),
	('lia.cardoso@ua.pt', 163, true),
	('dbramos@ua.pt', 164, true),
	('marta.oliveira.inacio@ua.pt', 165, true),
	('barbara.galiza@ua.pt', 166, true),
	('robertorcastro@ua.pt', 167, true),
	('falcao.diogo@ua.pt', 168, true),
	('diogomiguel.fernandes@ua.pt', 169, true),
	('san.bas@ua.pt', 170, true),
	('fabiomatias39@ua.pt', 171, true),
	('carolinaspsilva@ua.pt', 172, true),
	('andrevasquesdora@ua.pt', 173, true),
	('raquelvinagre@ua.pt', 174, true),
	('hugocastro@ua.pt', 175, true),
	('henrique.bmo@ua.pt', 176, true),
	('dani.fig@ua.pt', 177, true),
	('aritafs@ua.pt', 178, true),
	('jcapucho@ua.pt', 179, true),
	('joanaagomes@ua.pt', 180, true),
	('antonio.alberto@ua.pt', 181, true),
	('regina.tavares@ua.pt', 182, true),
	('marialinhares@ua.pt', 183, true),
	('guilherme.rosa60@ua.pt', 184, true),
	('henriqueft04@ua.pt', 185, true),
	('gabrielm.teixeira@ua.pt', 186, true),
	('tomasvictal@ua.pt', 187, true),
	('lucapereira@ua.pt', 188, true),
	('gfcs@ua.pt', 189, true),
	('vicente.costa@ua.pt', 190, true),
	('daniel.madureira@ua.pt', 191, true),
	('pmapm@ua.pt', 192, true),
	('eduardofernandes@ua.pt', 193, true),
	('dianarrmiranda@ua.pt', 194, true),
	('jose.mcgameiro@ua.pt', 195, true),
	('bernardo.figueiredo@ua.pt', 196, true),
	('alexandrecotorobai@ua.pt', 197, true),
	('borgesjps@ua.pt', 198, true),
	('goncalorcml@ua.pt', 199, true),
	('pedro.dld@ua.pt', 200, true),
	('duarteccruz@ua.pt', 201, true),
	('josetrigo@ua.pt', 202, true),
	('emanuel.gmarques@ua.pt', 203, true),
	('j.m.mendes@ua.pt', 204, true),
	('zakhar.kruptsala@ua.pt', 205, true),
	('pedro.salgado@ua.pt', 206, true),
	('iavcoelho@ua.pt', 207, true),
	('nicole.cunha@ua.pt', 208, true),
	('joaobernardo0@ua.pt', 209, true),
	('marianaandrade@ua.pt', 210, true),
	('sebastiao.teixeira@ua.pt', 211, true),
	('andre.sou.fernandes@ua.pt', 212, true),
	('tiagogcarvalho@ua.pt', 213, true),
	('agm@ua.pt', 214, true),
	('apgm12@outlook.pt', 215, true),
	('tiagofcruz78@ua.pt', 216, true),
	('simaoma@ua.pt', 217, true),
	('paulojnpinto02@ua.pt', 218, true),
	('brunotavaresmeixedo@ua.pt', 219, true),
	('vitalie@ua.pt', 220, true),
	('lilianapcribeiro@ua.pt', 221, true);


--
-- Data for Name: video; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.video (id, youtube_id, title, subtitle, image, created_at, playlist) VALUES
	(1, 'PL0-X-dbGZUABPg-FWm3tT7rCVh6SESK2d', 'FP', 'Fundamentos de Programação', '/videos/FP_2020.jpg', '2020-12-09 00:00:00', 1),
	(2, 'PL0-X-dbGZUAA8rQm4klslEksHCrb3EIDG', 'IAC', 'Introdução à Arquitetura de Computadores', '/videos/IAC_2020.jpg', '2020-06-10 00:00:00', 1),
	(3, 'PL0-X-dbGZUABp2uATg_-lqfT4FTFlyNir', 'ITW', 'Introdução às Tecnologias Web', '/videos/ITW_2020.jpg', '2020-12-17 00:00:00', 1),
	(4, 'PL0-X-dbGZUACS3EkepgT7DOf287MiTzp0', 'POO', 'Programação Orientada a Objetos', '/videos/POO_2020.jpg', '2020-11-16 00:00:00', 1),
	(5, 'ips-tkEr_pM', 'Discord Bot', 'Workshop', '/videos/discord.jpg', '2021-07-14 00:00:00', 0),
	(6, '3hjRgoIItYk', 'Anchorage', 'Palestra', '/videos/anchorage.jpg', '2021-04-01 00:00:00', 0),
	(7, 'GmNvZC6iv1Y', 'Git', 'Workshop', '/videos/git.jpg', '2020-04-28 00:00:00', 0);


--
-- Data for Name: video__video_tags; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.video__video_tags (video_id, video_tag_id) VALUES
	(1, 1),
	(2, 1),
	(3, 1),
	(4, 1),
	(5, 5),
	(6, 6),
	(7, 5);


--
-- Data for Name: video_tag; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.video_tag (id, name, color) VALUES
	(1, '1A', 'rgb(1, 202, 228)'),
	(2, '2A', 'rgb(1, 171, 192)'),
	(3, '3A', 'rgb(1, 135, 152)'),
	(4, 'MEI', 'rgb(1, 90, 101)'),
	(5, 'Workshops', 'rgb(11, 66, 21)'),
	(6, 'Palestras', 'rgb(20, 122, 38)');


--
-- Name: faina_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.faina_id_seq', 11, false);


--
-- Name: faina_member_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.faina_member_id_seq', 108, false);


--
-- Name: faina_role_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.faina_role_id_seq', 11, false);


--
-- Name: merch_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.merch_id_seq', 6, false);


--
-- Name: news_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.news_id_seq', 27, false);


--
-- Name: note_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.note_id_seq', 386, false);


--
-- Name: partner_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.partner_id_seq', 3, false);


--
-- Name: redirect_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.redirect_id_seq', 10, false);


--
-- Name: rgm_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.rgm_id_seq', 54, false);


--
-- Name: senior_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.senior_id_seq', 5, false);


--
-- Name: teacher_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.teacher_id_seq', 41, false);


--
-- Name: team_member_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.team_member_id_seq', 412, false);


--
-- Name: team_role_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.team_role_id_seq', 19, false);


--
-- Name: user_academic_details_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.user_academic_details_id_seq', 103, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.user_id_seq', 221, true);


--
-- Name: video_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.video_id_seq', 8, false);


--
-- Name: video_tag_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.video_tag_id_seq', 7, false);


--
-- Name: course course_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (code);


--
-- Name: device_login device_login_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.device_login
    ADD CONSTRAINT device_login_pkey PRIMARY KEY (user_id, session_id);


--
-- Name: faina_member faina_member_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.faina_member
    ADD CONSTRAINT faina_member_pkey PRIMARY KEY (id);


--
-- Name: faina faina_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.faina
    ADD CONSTRAINT faina_pkey PRIMARY KEY (id);


--
-- Name: faina_role faina_role_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.faina_role
    ADD CONSTRAINT faina_role_pkey PRIMARY KEY (id);


--
-- Name: history history_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (moment);


--
-- Name: merch merch_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.merch
    ADD CONSTRAINT merch_pkey PRIMARY KEY (id);


--
-- Name: news news_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.news
    ADD CONSTRAINT news_pkey PRIMARY KEY (id);


--
-- Name: note note_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.note
    ADD CONSTRAINT note_pkey PRIMARY KEY (id);


--
-- Name: partner partner_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.partner
    ADD CONSTRAINT partner_pkey PRIMARY KEY (id);


--
-- Name: redirect redirect_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.redirect
    ADD CONSTRAINT redirect_pkey PRIMARY KEY (id);


--
-- Name: rgm rgm_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.rgm
    ADD CONSTRAINT rgm_pkey PRIMARY KEY (id);


--
-- Name: senior senior_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.senior
    ADD CONSTRAINT senior_pkey PRIMARY KEY (id);


--
-- Name: senior_student senior_student_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.senior_student
    ADD CONSTRAINT senior_student_pkey PRIMARY KEY (senior_id, user_id);


--
-- Name: subject subject_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (code);


--
-- Name: teacher teacher_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.teacher
    ADD CONSTRAINT teacher_pkey PRIMARY KEY (id);


--
-- Name: team_colaborator team_colaborator_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.team_colaborator
    ADD CONSTRAINT team_colaborator_pkey PRIMARY KEY (user_id, mandate);


--
-- Name: team_member team_member_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.team_member
    ADD CONSTRAINT team_member_pkey PRIMARY KEY (id);


--
-- Name: team_role team_role_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.team_role
    ADD CONSTRAINT team_role_pkey PRIMARY KEY (id);


--
-- Name: senior uc_year_course; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.senior
    ADD CONSTRAINT uc_year_course UNIQUE (year, course);


--
-- Name: user_academic_details__subjects user_academic_details__subjects_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.user_academic_details__subjects
    ADD CONSTRAINT user_academic_details__subjects_pkey PRIMARY KEY (user_academic_details_id, subject);


--
-- Name: user_academic_details user_academic_details_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.user_academic_details
    ADD CONSTRAINT user_academic_details_pkey PRIMARY KEY (id);


--
-- Name: user_email user_email_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.user_email
    ADD CONSTRAINT user_email_pkey PRIMARY KEY (email, user_id);


--
-- Name: user user_iupi_key; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei."user"
    ADD CONSTRAINT user_iupi_key UNIQUE (iupi);


--
-- Name: user user_nmec_key; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei."user"
    ADD CONSTRAINT user_nmec_key UNIQUE (nmec);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: video__video_tags video__video_tags_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.video__video_tags
    ADD CONSTRAINT video__video_tags_pkey PRIMARY KEY (video_id, video_tag_id);


--
-- Name: video video_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.video
    ADD CONSTRAINT video_pkey PRIMARY KEY (id);


--
-- Name: video_tag video_tag_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.video_tag
    ADD CONSTRAINT video_tag_pkey PRIMARY KEY (id);


--
-- Name: ix_nei_faina_member_faina_id; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_faina_member_faina_id ON nei.faina_member USING btree (faina_id);


--
-- Name: ix_nei_faina_member_member_id; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_faina_member_member_id ON nei.faina_member USING btree (member_id);


--
-- Name: ix_nei_faina_member_role_id; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_faina_member_role_id ON nei.faina_member USING btree (role_id);


--
-- Name: ix_nei_news_author_id; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_news_author_id ON nei.news USING btree (author_id);


--
-- Name: ix_nei_news_changed_by; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_news_changed_by ON nei.news USING btree (changed_by);


--
-- Name: ix_nei_news_published_by; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_news_published_by ON nei.news USING btree (published_by);


--
-- Name: ix_nei_note_author_id; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_note_author_id ON nei.note USING btree (author_id);


--
-- Name: ix_nei_note_created_at; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_note_created_at ON nei.note USING btree (created_at);


--
-- Name: ix_nei_note_subject_id; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_note_subject_id ON nei.note USING btree (subject_id);


--
-- Name: ix_nei_note_teacher_id; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_note_teacher_id ON nei.note USING btree (teacher_id);


--
-- Name: ix_nei_note_year; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_note_year ON nei.note USING btree (year);


--
-- Name: ix_nei_rgm_mandate; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_rgm_mandate ON nei.rgm USING btree (mandate);


--
-- Name: ix_nei_team_member_mandate; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_team_member_mandate ON nei.team_member USING btree (mandate);


--
-- Name: ix_nei_team_member_role_id; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_team_member_role_id ON nei.team_member USING btree (role_id);


--
-- Name: ix_nei_team_member_user_id; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_team_member_user_id ON nei.team_member USING btree (user_id);


--
-- Name: ix_nei_team_role_weight; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_team_role_weight ON nei.team_role USING btree (weight);


--
-- Name: ix_nei_user_academic_details_course_id; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_user_academic_details_course_id ON nei.user_academic_details USING btree (course_id);


--
-- Name: ix_nei_user_academic_details_created_at; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_user_academic_details_created_at ON nei.user_academic_details USING btree (created_at);


--
-- Name: ix_nei_user_academic_details_user_id; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_user_academic_details_user_id ON nei.user_academic_details USING btree (user_id);


--
-- Name: ix_nei_user_created_at; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_user_created_at ON nei."user" USING btree (created_at);


--
-- Name: ix_nei_user_updated_at; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_user_updated_at ON nei."user" USING btree (updated_at);


--
-- Name: ix_nei_video_created_at; Type: INDEX; Schema: nei; Owner: postgres
--

CREATE INDEX ix_nei_video_created_at ON nei.video USING btree (created_at);


--
-- Name: device_login device_login_user_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.device_login
    ADD CONSTRAINT device_login_user_id_fkey FOREIGN KEY (user_id) REFERENCES nei."user"(id) ON DELETE CASCADE;


--
-- Name: faina_member faina_member_faina_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.faina_member
    ADD CONSTRAINT faina_member_faina_id_fkey FOREIGN KEY (faina_id) REFERENCES nei.faina(id);


--
-- Name: faina_member faina_member_member_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.faina_member
    ADD CONSTRAINT faina_member_member_id_fkey FOREIGN KEY (member_id) REFERENCES nei."user"(id);


--
-- Name: faina_member faina_member_role_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.faina_member
    ADD CONSTRAINT faina_member_role_id_fkey FOREIGN KEY (role_id) REFERENCES nei.faina_role(id);


--
-- Name: news fk_author_id; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.news
    ADD CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES nei."user"(id);


--
-- Name: note fk_author_id; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.note
    ADD CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES nei."user"(id);


--
-- Name: news fk_editor_id; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.news
    ADD CONSTRAINT fk_editor_id FOREIGN KEY (changed_by) REFERENCES nei."user"(id);


--
-- Name: news fk_publisher_id; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.news
    ADD CONSTRAINT fk_publisher_id FOREIGN KEY (published_by) REFERENCES nei."user"(id);


--
-- Name: note fk_subject_id; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.note
    ADD CONSTRAINT fk_subject_id FOREIGN KEY (subject_id) REFERENCES nei.subject(code);


--
-- Name: note fk_teacher_id; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.note
    ADD CONSTRAINT fk_teacher_id FOREIGN KEY (teacher_id) REFERENCES nei.teacher(id);


--
-- Name: senior_student senior_student_senior_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.senior_student
    ADD CONSTRAINT senior_student_senior_id_fkey FOREIGN KEY (senior_id) REFERENCES nei.senior(id);


--
-- Name: senior_student senior_student_user_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.senior_student
    ADD CONSTRAINT senior_student_user_id_fkey FOREIGN KEY (user_id) REFERENCES nei."user"(id);


--
-- Name: subject subject_course_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.subject
    ADD CONSTRAINT subject_course_id_fkey FOREIGN KEY (course_id) REFERENCES nei.course(code);


--
-- Name: team_colaborator team_colaborator_user_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.team_colaborator
    ADD CONSTRAINT team_colaborator_user_id_fkey FOREIGN KEY (user_id) REFERENCES nei."user"(id);


--
-- Name: team_member team_member_role_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.team_member
    ADD CONSTRAINT team_member_role_id_fkey FOREIGN KEY (role_id) REFERENCES nei.team_role(id);


--
-- Name: team_member team_member_user_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.team_member
    ADD CONSTRAINT team_member_user_id_fkey FOREIGN KEY (user_id) REFERENCES nei."user"(id);


--
-- Name: user_academic_details__subjects user_academic_details__subjects_subject_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.user_academic_details__subjects
    ADD CONSTRAINT user_academic_details__subjects_subject_fkey FOREIGN KEY (subject) REFERENCES nei.subject(code);


--
-- Name: user_academic_details__subjects user_academic_details__subjects_user_academic_details_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.user_academic_details__subjects
    ADD CONSTRAINT user_academic_details__subjects_user_academic_details_id_fkey FOREIGN KEY (user_academic_details_id) REFERENCES nei.user_academic_details(id);


--
-- Name: user_academic_details user_academic_details_course_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.user_academic_details
    ADD CONSTRAINT user_academic_details_course_id_fkey FOREIGN KEY (course_id) REFERENCES nei.course(code);


--
-- Name: user_academic_details user_academic_details_user_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.user_academic_details
    ADD CONSTRAINT user_academic_details_user_id_fkey FOREIGN KEY (user_id) REFERENCES nei."user"(id);


--
-- Name: user_email user_email_user_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.user_email
    ADD CONSTRAINT user_email_user_id_fkey FOREIGN KEY (user_id) REFERENCES nei."user"(id) ON DELETE CASCADE;


--
-- Name: video__video_tags video__video_tags_video_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.video__video_tags
    ADD CONSTRAINT video__video_tags_video_id_fkey FOREIGN KEY (video_id) REFERENCES nei.video(id);


--
-- Name: video__video_tags video__video_tags_video_tag_id_fkey; Type: FK CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.video__video_tags
    ADD CONSTRAINT video__video_tags_video_tag_id_fkey FOREIGN KEY (video_tag_id) REFERENCES nei.video_tag(id);


--
-- PostgreSQL database dump complete
--

