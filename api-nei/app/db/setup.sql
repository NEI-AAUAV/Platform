\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.0
-- Dumped by pg_dump version 15.0

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
-- Name: faina; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.faina (
    id integer NOT NULL,
    image character varying(2048),
    year character varying(9)
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
    number_of_items integer
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
    category character varying(11),
    mandate integer,
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
    semester integer,
    discontinued smallint,
    optional smallint
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
    mandate integer NOT NULL
);


ALTER TABLE nei.team_colaborator OWNER TO postgres;

--
-- Name: team_member; Type: TABLE; Schema: nei; Owner: postgres
--

CREATE TABLE nei.team_member (
    id integer NOT NULL,
    header character varying(2048),
    mandate integer,
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
    email character varying(256) NOT NULL,
    hashed_password text,
    name character varying(20) NOT NULL,
    surname character varying(20) NOT NULL,
    gender nei.gender_enum,
    image character varying(2048),
    curriculum character varying(2048),
    linkedin character varying(100),
    github character varying(39),
    scopes nei.scope_enum[],
    updated_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    active boolean NOT NULL
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
-- Name: faina_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.faina_id_seq', 1, false);


--
-- Name: faina_member_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.faina_member_id_seq', 1, false);


--
-- Name: faina_role_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.faina_role_id_seq', 1, false);


--
-- Name: merch_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.merch_id_seq', 1, false);


--
-- Name: news_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.news_id_seq', 1, false);


--
-- Name: note_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.note_id_seq', 1, false);


--
-- Name: partner_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.partner_id_seq', 1, false);


--
-- Name: redirect_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.redirect_id_seq', 1, false);


--
-- Name: rgm_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.rgm_id_seq', 1, false);


--
-- Name: senior_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.senior_id_seq', 1, false);


--
-- Name: teacher_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.teacher_id_seq', 1, false);


--
-- Name: team_member_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.team_member_id_seq', 1, false);


--
-- Name: team_role_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.team_role_id_seq', 1, false);


--
-- Name: user_academic_details_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.user_academic_details_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.user_id_seq', 199, false);


--
-- Name: video_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.video_id_seq', 1, false);


--
-- Name: video_tag_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.video_tag_id_seq', 1, false);


--
-- Name: course course_pkey; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (code);


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
-- Name: user user_email_key; Type: CONSTRAINT; Schema: nei; Owner: postgres
--

ALTER TABLE ONLY nei."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


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
