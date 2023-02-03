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
-- Name: aauav_nei; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA aauav_nei;


ALTER SCHEMA aauav_nei OWNER TO postgres;

--
-- Name: category_enum; Type: TYPE; Schema: aauav_nei; Owner: postgres
--

CREATE TYPE aauav_nei.category_enum AS ENUM (
    'EVENT',
    'NEWS',
    'PARCERIA'
);


ALTER TYPE aauav_nei.category_enum OWNER TO postgres;

--
-- Name: permission_enum; Type: TYPE; Schema: aauav_nei; Owner: postgres
--

CREATE TYPE aauav_nei.permission_enum AS ENUM (
    'DEFAULT',
    'FAINA',
    'HELPER',
    'COLABORATOR',
    'MANAGER',
    'ADMIN'
);


ALTER TYPE aauav_nei.permission_enum OWNER TO postgres;

--
-- Name: status_enum; Type: TYPE; Schema: aauav_nei; Owner: postgres
--

CREATE TYPE aauav_nei.status_enum AS ENUM (
    'ACTIVE',
    'INACTIVE'
);


ALTER TYPE aauav_nei.status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: faina; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.faina (
    id integer NOT NULL,
    image character varying(2048),
    year character varying(9)
);


ALTER TABLE aauav_nei.faina OWNER TO postgres;

--
-- Name: faina_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.faina_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.faina_id_seq OWNER TO postgres;

--
-- Name: faina_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.faina_id_seq OWNED BY aauav_nei.faina.id;


--
-- Name: faina_member; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.faina_member (
    id integer NOT NULL,
    member_id integer,
    faina_id integer,
    role_id integer
);


ALTER TABLE aauav_nei.faina_member OWNER TO postgres;

--
-- Name: faina_member_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.faina_member_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.faina_member_id_seq OWNER TO postgres;

--
-- Name: faina_member_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.faina_member_id_seq OWNED BY aauav_nei.faina_member.id;


--
-- Name: faina_role; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.faina_role (
    id integer NOT NULL,
    name character varying(20),
    weight integer
);


ALTER TABLE aauav_nei.faina_role OWNER TO postgres;

--
-- Name: faina_role_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.faina_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.faina_role_id_seq OWNER TO postgres;

--
-- Name: faina_role_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.faina_role_id_seq OWNED BY aauav_nei.faina_role.id;


--
-- Name: history; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.history (
    moment date NOT NULL,
    title character varying(120),
    body text,
    image character varying(2048)
);


ALTER TABLE aauav_nei.history OWNER TO postgres;

--
-- Name: merch; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.merch (
    id integer NOT NULL,
    name character varying(255),
    image character varying(2048),
    price double precision,
    number_of_items integer
);


ALTER TABLE aauav_nei.merch OWNER TO postgres;

--
-- Name: merch_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.merch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.merch_id_seq OWNER TO postgres;

--
-- Name: merch_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.merch_id_seq OWNED BY aauav_nei.merch.id;


--
-- Name: news; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.news (
    id integer NOT NULL,
    header character varying(2048),
    status aauav_nei.status_enum,
    title character varying(255),
    category aauav_nei.category_enum,
    content character varying(20000),
    published_by integer,
    created_at timestamp without time zone,
    last_change_at timestamp without time zone,
    changed_by integer,
    author_id integer
);


ALTER TABLE aauav_nei.news OWNER TO postgres;

--
-- Name: news_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.news_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.news_id_seq OWNER TO postgres;

--
-- Name: news_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.news_id_seq OWNED BY aauav_nei.news.id;


--
-- Name: note; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.note (
    id integer NOT NULL,
    name character varying(255),
    location character varying(2048),
    subject_id integer,
    author_id integer,
    school_year_id integer,
    teacher_id integer,
    summary smallint,
    tests smallint,
    bibliography smallint,
    slides smallint,
    exercises smallint,
    projects smallint,
    notebook smallint,
    content text,
    created_at timestamp without time zone,
    type_id integer,
    size integer
);


ALTER TABLE aauav_nei.note OWNER TO postgres;

--
-- Name: note_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.note_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.note_id_seq OWNER TO postgres;

--
-- Name: note_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.note_id_seq OWNED BY aauav_nei.note.id;


--
-- Name: note_school_year; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.note_school_year (
    id integer NOT NULL,
    year_begin smallint,
    year_end smallint
);


ALTER TABLE aauav_nei.note_school_year OWNER TO postgres;

--
-- Name: note_school_year_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.note_school_year_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.note_school_year_id_seq OWNER TO postgres;

--
-- Name: note_school_year_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.note_school_year_id_seq OWNED BY aauav_nei.note_school_year.id;


--
-- Name: note_subject; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.note_subject (
    paco_code integer NOT NULL,
    name character varying(60),
    year integer,
    semester integer,
    short character varying(5),
    discontinued smallint,
    optional smallint
);


ALTER TABLE aauav_nei.note_subject OWNER TO postgres;

--
-- Name: note_teacher; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.note_teacher (
    id integer NOT NULL,
    name character varying(100),
    personal_page character varying(255)
);


ALTER TABLE aauav_nei.note_teacher OWNER TO postgres;

--
-- Name: note_teacher_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.note_teacher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.note_teacher_id_seq OWNER TO postgres;

--
-- Name: note_teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.note_teacher_id_seq OWNED BY aauav_nei.note_teacher.id;


--
-- Name: note_thank; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.note_thank (
    id integer NOT NULL,
    author_id integer,
    note_personal_page character varying(255)
);


ALTER TABLE aauav_nei.note_thank OWNER TO postgres;

--
-- Name: note_thank_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.note_thank_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.note_thank_id_seq OWNER TO postgres;

--
-- Name: note_thank_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.note_thank_id_seq OWNED BY aauav_nei.note_thank.id;


--
-- Name: note_types; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.note_type (
    id integer NOT NULL,
    name character varying(40),
    download_caption character varying(40),
    icon_display character varying(40),
    icon_download character varying(40),
    external smallint
);


ALTER TABLE aauav_nei.note_type OWNER TO postgres;

--
-- Name: note_types_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.note_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.note_type_id_seq OWNER TO postgres;

--
-- Name: note_types_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.note_type_id_seq OWNED BY aauav_nei.note_type.id;


--
-- Name: partner; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.partner (
    id integer NOT NULL,
    header character varying(2048),
    company character varying(255),
    description text,
    content character varying(255),
    link character varying(255),
    banner_url character varying(255),
    banner_image character varying(2048),
    banner_until timestamp without time zone
);


ALTER TABLE aauav_nei.partner OWNER TO postgres;

--
-- Name: partner_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.partner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.partner_id_seq OWNER TO postgres;

--
-- Name: partner_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.partner_id_seq OWNED BY aauav_nei.partner.id;


--
-- Name: redirect; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.redirect (
    id integer NOT NULL,
    alias character varying(255),
    redirect character varying(2048)
);


ALTER TABLE aauav_nei.redirect OWNER TO postgres;

--
-- Name: redirect_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.redirect_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.redirect_id_seq OWNER TO postgres;

--
-- Name: redirect_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.redirect_id_seq OWNED BY aauav_nei.redirect.id;


--
-- Name: rgm; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.rgm (
    id integer NOT NULL,
    category character varying(11),
    mandate integer,
    file character varying(2048)
);


ALTER TABLE aauav_nei.rgm OWNER TO postgres;

--
-- Name: rgm_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.rgm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.rgm_id_seq OWNER TO postgres;

--
-- Name: rgm_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.rgm_id_seq OWNED BY aauav_nei.rgm.id;


--
-- Name: senior; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.senior (
    id integer NOT NULL,
    year integer,
    course character varying(6),
    image character varying(2048)
);


ALTER TABLE aauav_nei.senior OWNER TO postgres;

--
-- Name: senior_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.senior_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.senior_id_seq OWNER TO postgres;

--
-- Name: senior_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.senior_id_seq OWNED BY aauav_nei.senior.id;


--
-- Name: senior_student; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.senior_student (
    senior_id integer NOT NULL,
    user_id integer NOT NULL,
    quote character varying(280),
    image character varying(2048)
);


ALTER TABLE aauav_nei.senior_student OWNER TO postgres;

--
-- Name: team; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.team (
    id integer NOT NULL,
    header character varying(2048),
    mandate integer,
    user_id integer,
    role_id integer
);


ALTER TABLE aauav_nei.team OWNER TO postgres;

--
-- Name: team_colaborator; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.team_colaborator (
    user_id integer NOT NULL,
    mandate integer NOT NULL
);


ALTER TABLE aauav_nei.team_colaborator OWNER TO postgres;

--
-- Name: team_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.team_id_seq OWNER TO postgres;

--
-- Name: team_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.team_id_seq OWNED BY aauav_nei.team.id;


--
-- Name: team_role; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.team_role (
    id integer NOT NULL,
    name character varying(120),
    weight integer
);


ALTER TABLE aauav_nei.team_role OWNER TO postgres;

--
-- Name: team_role_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.team_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.team_role_id_seq OWNER TO postgres;

--
-- Name: team_role_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.team_role_id_seq OWNED BY aauav_nei.team_role.id;


--
-- Name: user; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.user (
    id integer NOT NULL,
    name character varying(255),
    full_name character varying(255),
    uu_email character varying(255),
    uu_iupi character varying(255),
    curriculo character varying(255),
    linkedin character varying(255),
    git character varying(255),
    permission aauav_nei.permission_enum,
    created_at timestamp without time zone
);


ALTER TABLE aauav_nei.user OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.user_id_seq OWNED BY aauav_nei.user.id;


--
-- Name: video; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.video (
    id integer NOT NULL,
    youtube_id character varying(255),
    title character varying(255),
    subtitle character varying(255),
    image character varying(2048),
    created_at timestamp without time zone,
    playlist smallint
);


ALTER TABLE aauav_nei.video OWNER TO postgres;

--
-- Name: video_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.video_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.video_id_seq OWNER TO postgres;

--
-- Name: video_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.video_id_seq OWNED BY aauav_nei.video.id;


--
-- Name: video_tag; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.video_tag (
    id integer NOT NULL,
    name character varying(255),
    color character varying(18)
);


ALTER TABLE aauav_nei.video_tag OWNER TO postgres;

--
-- Name: video_tag_id_seq; Type: SEQUENCE; Schema: aauav_nei; Owner: postgres
--

CREATE SEQUENCE aauav_nei.video_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aauav_nei.video_tag_id_seq OWNER TO postgres;

--
-- Name: video_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: aauav_nei; Owner: postgres
--

ALTER SEQUENCE aauav_nei.video_tag_id_seq OWNED BY aauav_nei.video_tag.id;


--
-- Name: video_video_tags; Type: TABLE; Schema: aauav_nei; Owner: postgres
--

CREATE TABLE aauav_nei.video_video_tags (
    video integer NOT NULL,
    video_tag integer NOT NULL
);


ALTER TABLE aauav_nei.video_video_tags OWNER TO postgres;

--
-- Name: faina id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.faina ALTER COLUMN id SET DEFAULT nextval('aauav_nei.faina_id_seq'::regclass);


--
-- Name: faina_member id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.faina_member ALTER COLUMN id SET DEFAULT nextval('aauav_nei.faina_member_id_seq'::regclass);


--
-- Name: faina_role id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.faina_role ALTER COLUMN id SET DEFAULT nextval('aauav_nei.faina_role_id_seq'::regclass);


--
-- Name: merch id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.merch ALTER COLUMN id SET DEFAULT nextval('aauav_nei.merch_id_seq'::regclass);


--
-- Name: news id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.news ALTER COLUMN id SET DEFAULT nextval('aauav_nei.news_id_seq'::regclass);


--
-- Name: note id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note ALTER COLUMN id SET DEFAULT nextval('aauav_nei.note_id_seq'::regclass);


--
-- Name: note_school_year id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note_school_year ALTER COLUMN id SET DEFAULT nextval('aauav_nei.note_school_year_id_seq'::regclass);


--
-- Name: note_teacher id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note_teacher ALTER COLUMN id SET DEFAULT nextval('aauav_nei.note_teacher_id_seq'::regclass);


--
-- Name: note_thank id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note_thank ALTER COLUMN id SET DEFAULT nextval('aauav_nei.note_thank_id_seq'::regclass);


--
-- Name: note_types id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note_type ALTER COLUMN id SET DEFAULT nextval('aauav_nei.note_type_id_seq'::regclass);


--
-- Name: partner id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.partner ALTER COLUMN id SET DEFAULT nextval('aauav_nei.partner_id_seq'::regclass);


--
-- Name: redirect id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.redirect ALTER COLUMN id SET DEFAULT nextval('aauav_nei.redirect_id_seq'::regclass);


--
-- Name: rgm id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.rgm ALTER COLUMN id SET DEFAULT nextval('aauav_nei.rgm_id_seq'::regclass);


--
-- Name: senior id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.senior ALTER COLUMN id SET DEFAULT nextval('aauav_nei.senior_id_seq'::regclass);


--
-- Name: team id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.team ALTER COLUMN id SET DEFAULT nextval('aauav_nei.team_id_seq'::regclass);


--
-- Name: team_role id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.team_role ALTER COLUMN id SET DEFAULT nextval('aauav_nei.team_role_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.user ALTER COLUMN id SET DEFAULT nextval('aauav_nei.user_id_seq'::regclass);


--
-- Name: video id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.video ALTER COLUMN id SET DEFAULT nextval('aauav_nei.video_id_seq'::regclass);


--
-- Name: video_tag id; Type: DEFAULT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.video_tag ALTER COLUMN id SET DEFAULT nextval('aauav_nei.video_tag_id_seq'::regclass);


--
-- Data for Name: faina; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.faina (id, image, year) VALUES
(1, NULL, '2012/13'),
(2, NULL, '2013/14'),
(3, NULL, '2014/15'),
(4, NULL, '2015/16'),
(5, NULL, '2016/17'),
(6, NULL, '2017/18'),
(7, '/faina/team/2018.jpg', '2018/19'),
(8, '/faina/team/2019.jpg', '2019/20'),
(9, '/faina/team/2020.jpg', '2020/21'),
(10, '/faina/team/2021.jpg', '2021/22');

--
-- Data for Name: faina_member; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.faina_member (id, member_id, faina_id, role_id) VALUES
(1, 1179, 1, 10),
(2, 1593, 1, 7),
(3, 1062, 1, 5),
(4, 1080, 1, 5),
(5, 2137, 1, 5),
(6, 1380, 1, 6),
(7, 1893, 1, 6),
(8, 1848, 1, 6),
(9, 1167, 1, 3),
(10, 1599, 1, 3),
(11, 1785, 1, 3),
(12, 1893, 2, 10),
(13, 1848, 2, 7),
(14, 1218, 2, 5),
(15, 1599, 2, 5),
(16, 1785, 2, 5),
(17, 1917, 2, 5),
(18, 1032, 2, 4),
(19, 1488, 2, 3),
(20, 1551, 2, 3),
(21, 1629, 2, 2),
(22, 1854, 2, 1),
(23, 1785, 3, 10),
(24, 1005, 3, 7),
(25, 1218, 3, 7),
(26, 1917, 3, 7),
(27, 1551, 3, 5),
(28, 1038, 3, 4),
(29, 1455, 3, 3),
(30, 1554, 3, 3),
(31, 1629, 3, 4),
(32, 1854, 3, 3),
(33, 1923, 3, 4),
(34, 1551, 4, 10),
(35, 894, 4, 7),
(36, 1194, 4, 7),
(37, 1293, 4, 7),
(38, 2138, 4, 5),
(39, 987, 4, 5),
(40, 1065, 4, 5),
(41, 1653, 4, 5),
(42, 984, 4, 3),
(43, 858, 4, 1),
(44, 1437, 4, 1),
(45, 1293, 5, 10),
(46, 2138, 5, 7),
(47, 984, 5, 5),
(48, 1071, 5, 6),
(49, 1752, 5, 5),
(50, 1437, 5, 3),
(51, 1596, 5, 3),
(52, 1704, 5, 2),
(53, 1059, 5, 1),
(54, 1947, 5, 1),
(55, 984, 6, 10),
(56, 1116, 6, 7),
(57, 1704, 6, 4),
(58, 1059, 6, 3),
(59, 1023, 6, 4),
(60, 1101, 6, 3),
(61, 1134, 6, 3),
(62, 1365, 6, 3),
(63, 1947, 6, 3),
(64, 1929, 6, 1),
(65, 1704, 7, 9),
(66, 1365, 7, 5),
(67, 1512, 7, 5),
(68, 1485, 7, 5),
(69, 1053, 7, 3),
(70, 1266, 7, 3),
(71, 1524, 7, 3),
(72, 1902, 7, 4),
(73, 900, 7, 1),
(74, 1002, 7, 2),
(75, 1965, 7, 1),
(76, 1365, 8, 10),
(77, 1419, 8, 7),
(78, 1512, 8, 7),
(79, 1485, 8, 7),
(80, 1002, 8, 4),
(81, 1548, 8, 3),
(82, 1626, 8, 4),
(83, 1965, 8, 3),
(84, 1068, 8, 1),
(85, 1200, 8, 1),
(86, 1716, 8, 1),
(87, 1512, 9, 10),
(88, 1419, 9, 7),
(89, 1485, 9, 7),
(90, 1002, 9, 6),
(91, 1548, 9, 5),
(92, 1200, 9, 3),
(93, 1716, 9, 3),
(94, 1821, 9, 3),
(95, 2026, 9, 1),
(96, 2047, 9, 1),
(97, 2059, 9, 1),
(98, 1002, 10, 10),
(99, 1200, 10, 5),
(100, 1548, 10, 7),
(101, 1716, 10, 5),
(102, 1821, 10, 5),
(103, 2026, 10, 3),
(104, 2047, 10, 3),
(105, 2058, 10, 3),
(106, 2059, 10, 3),
(107, 2161, 10, 4);


--
-- Data for Name: faina_role; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.faina_role (id, name, weight) VALUES
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
-- Data for Name: history; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.history (moment, title, body, image) VALUES
('2018-04-30', 'Elaboração de Candidatura para o Encontro Nacional de Estudantes de Informática 2019', 'Entrega de uma candidatura conjunta (NEI+AETTUA) para a organização do Encontro Nacional de Estudantes de Informática 2019. Esta candidatura teve a concorrência de uma candidatura conjunta do ISCAC Junior Solutions e Junisec, constituída por alunos do Politécnico de Coimbra, que acabaram por ser a candidatura vencedora.', '/history/20180430.png'),
('2019-03-09', '1ª Edição ThinkTwice', 'A primeira edição do evento, realizada em 2019, teve lugar no Auditório Mestre Hélder Castanheira da Universidade de Aveiro e contou com uma duração de 24 horas para a resolução de 30 desafios colocados, que continham diferentes graus de dificuldade. O evento contou com a participação de 34 estudantes, perfazendo um total de 12 equipas.', '/history/20190309.jpg'),
('2019-06-12', '2º Lugar Futsal', 'Num jogo em que se fizeram das tripas coração, o NEI defrontou a equipa de EGI num jogo que veio a perder, foi um jogo bastante disputado, contudo, acabou por ganhar EGI remetendo o NEI para o 2º lugar.', '/history/20190612.jpg'),
('2019-06-30', 'Candidatura ENEI 2020', 'Entrega de uma candidatura conjunta (NEI+NEECT+AETTUA) para a organização do Encontro Nacional de Estudantes de Informática 2019. Esta candidatura teve a concorrência de uma candidatura conjunta da CESIUM, constituída por alunos da Universidade do Minho, que acabaram por ser a candidatura vencedora.', '/history/20190630.png'),
('2020-03-06', '2ª Edição ThinkTwice', 'A edição de 2020 contou com a participação de 57 participantes divididos em 19 equipas, com 40 desafios de algoritmia de várias dificuldades para serem resolvidos em 40 horas, tendo lugar nas instalações da Casa do Estudante da Universidade de Aveiro. Esta edição contou ainda com 2 workshops e um momento de networking com as empresas patrocinadoras do evento.', '/history/20200306.jpg'),
('2021-05-07', '3ª Edição ThinkTwice', 'Devido ao contexto pandémico que se vivia a 3ª edição foi 100% online através de plataformas como o Discord e a Twitch, de 7 a 9 de maio. Nesta edição as 11 equipas participantes puderam escolher participar em uma de três tipos de competição: desafios de algoritmia, projeto de gamificação e projeto de cibersegurança. O evento contou ainda com 4 workshops e uma sessão de networking com as empresas patrocinadoras.', '/history/20210507.png');


--
-- Data for Name: merch; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.merch (id, name, image, price, number_of_items) VALUES
(1, 'Emblema de curso', '/merch/emblema.png', 2.5, 0),
(2, 'Cachecol de curso', '/merch/scarf.png', 3.5, 0),
(3, 'Casaco de curso', '/merch/casaco.png', 16.5, 0),
(4, 'Sweat de curso', '/merch/sweat.png', 18, 0),
(5, 'Emblema NEI', '/merch/emblemanei.png', 2.5, 0);


--
-- Data for Name: news; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.news (id, header, status, title, category, content, published_by, created_at, last_change_at, changed_by, author_id) VALUES
(1, '/news/6aniversario.jpg', 'ACTIVE', '6º Aniversário NEI', 'EVENT', 'Fez 6 anos, no passado dia 24 de Janeiro, que se formou o Núcleo de Estudantes de Informática. Para celebrar o 6º aniversário do NEI, convidamos todos os nossos alunos, colegas e amigos a juntarem-se a nós num jantar repleto de surpresas. O jantar realizar-se-á no dia 28 de fevereiro no restaurante \Monte Alentejano\ - Rua de São Sebastião 27A - pelas 20h00 tendo um custo de 11 euros por pessoa. Contamos com a presença de todos para apagarmos as velas e comermos o bolo, porque alegria e diversão já têm presença marcada!<hr><b>Ementa</b><ul><li>Carne de porco à alentejana/ opção vegetariana</li><li>Bebida à descrição</li><li>Champanhe</li><li>Bolo</li></ul>  Nota: Caso pretendas opção vegetariana deves comunicar ao NEI por mensagem privada no facebook ou então via email.<hr><b>Informações</b><br>Inscrições até dia 21 de fevereiro sendo que as mesmas estão limitadas a 100 pessoas.<br>&#9888;&#65039; A inscrição só será validada após o pagamento junto de um elemento do NEI até dia 22 de fevereiro às 16horas!<br>+info: nei@aauav.pt ou pela nossa página de Facebook<br><hr><b>Logins</b><br>Caso não saibas o teu login contacta: <a href=\https://www.facebook.com/ruicoelho43\>Rui Coelho</a> ou então diretamente com o <a href=\https://www.facebook.com/nei.aauav/\>NEI</a>, podes ainda mandar mail para o NEI, nei@aauav.pt.', 1866, '2019-01-18', NULL, NULL, 1),
(2, '/news/rgm1.png', 'ACTIVE', 'Convocatória RGM Extraordinária', 'EVENT', 'De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos Núcleos da Associação Académica da Universidade de Aveiro, convocam-se todos os membros da Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática para uma Reunião Geral de Membros Extraordinária, que se realizará no dia 14 do mês de Fevereiro de 2019, na sala 102 do Departamento de Eletrónica, Telecomunicações e Informática da Universidade de Aveiro, pelas 18 horas, com a seguinte ordem de trabalhos:  <br><br>1. Aprovação da Ata da RGM anterior;   <br>2. Informações;   <br>3. Apresentação do Plano de Atividades e Orçamento;  <br>4. Aprovação do Plano de Atividades e Orçamentos;  <br>5. Outros assuntos.   <br><br>Mais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI.<br><br><div style=\text-align:center\>Aveiro, 11 de janeiro de 2019<br>David Augusto de Sousa Fernandes<br>Presidente da Mesa da Reunião Geral de Membros<br>Núcleo de Estudantes de Informática da AAUAv <br></div><hr>Links úteis:<br><a href=\https://nei.web.ua.pt/scripts/unlock.php?url=upload/documents/RGM_ATAS/2018/RGM_10jan2019.pdf\ target=\_blank\>Ata da RGM anterior</a><br><a href=\https://nei.web.ua.pt/upload/documents/CONV_ATAS/2019/1RGM.pdf\ target=\_blank\>Documento da convocatória</a> ', 1866, '2019-02-11', NULL, NULL, 1),
(3, '/news/rgm2.png', 'ACTIVE', 'Convocatória RGM Extraordinária', 'EVENT', 'De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos  Núcleos  da  Associação Académica  da  Universidade  de  Aveiro,  convocam-se  todos  os membros  da  Licenciatura  em  Engenharia  Informática  e  Mestrado  em  Engenharia  Informática para uma Reunião Geral de MembrosExtraordinária, que se realizará no dia 1do mês de Abrilde 2019,   na   sala   102   do   Departamento   de   Eletrónica,   Telecomunicações   e   Informática   da Universidade de Aveiro, pelas 17:45horas, com a seguinte ordem de trabalhos: <br><br>1. Aprovação da Ata da RGM anterior;   <br>2. Informações;   <br>3. Discussão sobre o tema da barraca;  <br>4. Orçamento Participativo 2019;  <br>5. Outros assuntos.   <br><br>Se   à   hora   indicada   não   existir   quórum,   a   Assembleia   iniciar-se-á   meia   hora   depois, independentemente do número de membros presentes, no mesmo local, e com a mesma ordem de trabalhos.<br>Mais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI (https://nei.web.ua.pt).<br><br><div style=\text-align:center\>Aveiro, 28 de Março de 2019<br>David Augusto de Sousa Fernandes<br>Presidente da Mesa da Reunião Geral de Membros<br>Núcleo de Estudantes de Informática da AAUAv <br></div><hr>', 1866, '2019-03-28', NULL, NULL, 1),
(4, '/news/idpimage.png', 'ACTIVE', 'Integração IDP', 'NEWS', 'Recentemente foi feito um update no site que permite agora aos alunos de Engenharia Informática, quer mestrado, quer licenciatura, iniciar sessão no site  <a href=\https://nei.web.ua.pt\>nei.web.ua.pt</a> através do idp. <br>Esta alteração tem por consequência direta que a gestão de passwords deixa de estar diretamente ligada ao NEI passando assim, deste modo, qualquer password que seja perdida ou seja necessária alterar, responsabilidade do IDP da UA.<br><hr><h5 style=\text-align: center\><strong>Implicações diretas</strong></h5><br>Todas as funcionalidades do site se mantém e esta alteração em nada afeta o normal workflow do site, os apontamentos vão continuar na mesma disponíveis e em breve irão sofrer um update sendo corrigidas eventuais falhas nos atuais e adicionados mais alguns apontamentos No que diz respeito aos jantares de curso, a inscrição para estes também será feita via login através do IDP.<br>De forma genérica o IDP veio simplificar a forma como acedemos às plataformas do NEI, usando assim o Utilizador Universal da Universidade de Aveiro para fazer o login.<br>É de frisar que <strong>apenas</strong> os estudantes dos cursos  <strong>Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática  </strong>têm acesso ao site, todos os outros irão receber uma mensagem de erro quando fazem login e serão redirecionados para a homepage, não tendo, assim, acesso à informação e funcionalidades que necessitam de autenticação.<hr><h5 style=\text-align: center\><strong>Falha nos acessos</strong></h5><br>Existe a possibilidade de alguns alunos não terem acesso caso ainda não tivessem sido registados na versão antiga do site, assim, caso não consigas aceder por favor entra em contacto connosco via email para o <a href=\mailto:nei@aauav.pt?Subject=Acesso%20NEI\ target=\_top\>NEI</a> ou via facebook por mensagem direta para o <a href=\https://www.facebook.com/nei.aauav/\>NEI</a> ou então diretamente com o <a href=\https://www.facebook.com/ruicoelho43\>Rui Coelho</a>.<br>', 1866, '2019-05-15', NULL, NULL, 1),
(5, '/news/florinhas.jpg', 'ACTIVE', 'Entrega de t-shirts à Florinhas de Vouga', 'NEWS', 'Hoje procedemos à entrega de mais de 200 t-shirts em bom estado que nos sobraram ao longo dos anos às Florinhas Do Vouga, possibilitando assim roupa a quem mais precisa.<br>A IPSS – Florinhas do Vouga é uma Instituição Diocesana de Superior Interesse Social, fundada em 6 de Outubro de 1940 por iniciativa do Bispo D. João Evangelista de Lima Vidal, a quem se deve a criação de obras similares, as Florinhas da Rua em Lisboa e as Florinhas da Neve em Vila Real.<br>A Instituição desenvolve a sua intervenção na cidade de Aveiro, mais concretamente na freguesia da Glória, onde se situa um dos Bairros Sociais mais problemáticos da cidade (Bairro de Santiago), dando também resposta, sempre que necessário, às solicitações das freguesias limítrofes e outras, algumas delas fora do Concelho.<br>No desenvolvimento da sua actividade mantém com o CDSSS de Aveiro Acordos de Cooperação nas áreas da Infância e Juventude; População Idosa; Família e Comunidade e Toxicodependência.<br>É Entidade aderente do Núcleo Local de Inserção no âmbito do Rendimento Social de Inserção, parceira do CLAS, assumindo com os diferentes Organismos e Instituições uma parceria activa.<br>O desenvolvimento das respostas decorreu até Agosto de 2008 em equipamentos dispersos na freguesia da Glória e Vera Cruz, o que levou a Instituição a construir um edifício de raiz na freguesia da Glória, espaço onde passou a ter condições para concentrar parte das respostas que desenvolvia (nomeadamente Estabelecimento de Educação Pré-Escolar, CATL e SAD), assumir novas respostas (Creche), dar continuidade ao trabalho desenvolvido e garantir uma melhoria substancial na qualidade dos serviços prestados, encontrando-se neste momento num processo de implementação de Sistema de Gestão de Qualidade com vista à certificação.<br>A presença de famílias numerosas, multiproblemáticas, sem rendimentos de trabalho, quase que limitadas a rendimentos provenientes de prestações sociais, famílias com fortes vulnerabilidades, levaram a Instituição a ser mediadora no Programa Comunitário de Ajuda a Carenciados e a procurar sinergias capazes de optimizar os seus recursos existentes e dar resposta à emergência social, são exemplos disso a acção “Mercearia e Companhia”, que apoia mensalmente cerca de 200 famílias em géneros alimentares, vestuário e outros e a “Ceia com Calor” que distribui diariamente um suplemento alimentar aos Sem-abrigo de Aveiro.<br>É de salientar que as famílias que usufruem de Respostas Socais tipificadas, face às suas vulnerabilidades acabam por não conseguir assumir o pagamento das mensalidades mínimas que deveriam pagar pela prestação dos serviços que lhe são garantidos pela Instituição, o que exige um maior esforço por parte desta.<br>Em termos globais, a Instituição tem assumido uma estratégia de efectiva prevenção, promoção e inclusão da população alvo.<br><strong>Se tiveres roupa ou produtos de higiene a mais e queres ajudar as Florinhas por favor dirige-te à instituição e entrega as mesmas!</strong><br>Fica a conhecer mais sobre esta instituição: http://www.florinhasdovouga.pt', 1452, '2019-09-11', NULL, NULL, 1),
(6, '/news/rgm3.png', 'ACTIVE', 'Convocatória RGM Extraordinária', 'EVENT', 'De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos Núcleos da Associação Académica da Universidade de Aveiro, convocam-se todos os membros da Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática para uma Reunião Geral de Membros Extraordinária, que se realizará no dia 24 do mês de Setembro de 2019, na sala 102 do Departamento de Eletrónica, Telecomunicações e Informática da Universidade de Aveiro, pelas 18:00 horas, com a seguinte ordem de trabalhos: <br><br>1. Aprovação da Ata da RGM anterior; <br>2. Informações; <br>3. Pitch Bootcamp; <br>4. Taça UA; <br>5. Programa de Integração; <br>6. Outros assuntos. <br><br>Se à hora indicada não existir quórum, a Assembleia iniciar-se-á meia hora depois, independentemente do número de membros presentes, no mesmo local, e com a mesma ordem de trabalhos.<br>Mais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI (https://nei.web.ua.pt), sendo necessário fazer login na plataforma para ter acesso à mesma.<br><br><div style=\text-align:center\>David Augusto de Sousa Fernandes<br>Aveiro, 20 de setembro de 2019<br>Presidente da Mesa da Reunião Geral de Membros<br>Núcleo de Estudantes de Informática da AAUAv <br></div><hr>', 1452, '2019-09-20', NULL, NULL, 1),
(7, '/news/newNEI.png', 'ACTIVE', 'Lançamento do novo portal do NEI', 'NEWS', 'Passado um cerca de um ano após o lançamento da versão anterior do portal do NEI, lançamos agora uma versão renovada do mesmo com um desgin mais atrativo utilizando react para a sua criação.<br>Esta nova versão do site conta com algumas novas features:<ol>  <li>Podes agora ter uma foto utilizando o gravatar, fizemos a integração com o mesmo.</li>  <li>Podes associar o teu CV, linkedin e conta git ao teu perfil.</li>  <li>Vais poder acompanhar tudo o que se passa na taça UA com as equipas do NEI a partir da plataforma de desporto que em breve será colocada online.</li>  <li>Existe uma secção que vai permitir aos alunos interessados no curso encontrar informação sobre o mesmo mais facilmente.</li>  <li>Podes encontrar a composição de todas as coordenações na página dedicada à equipa.</li>  <li>Podes encontrar a composição de todas as comissões de faina na página dedicada à equipa.</li>  <li>Integração dos eventos criados no facebook.</li>  <li>Podes ver todas as tuas compras de Merchandising.</li>  <li>Possibilidade de divulgar os projetos no site do NEI todos os projetos que fazes, estes não precisam de ser apenas projetos universitários, podem ser também projetos pessoais. Esta função ainda não está ativa mas em breve terás novidades.</li>  <li>Foi redesenhada a página dos apontamentos sendo agora mais fácil encontrares os apontamentos que precisas, podes pesquisar diretamente ou utilizar diferentes sorts de modo a que fiquem ordenados a teu gosto.</li></ol> À semelhança da anterior versão do website do NEI continuamos a ter a integração do IPD da UA fazendo assim a gestão de acessos ao website mais facilmente. Caso tenhas algum problema com o teu login entra em contacto conosco para resolvermos essa situação.<br>Da mesma que o IDP se manteve, todas as funcionalidades anteriores foram mantidas, apenas remodelamos a imagem. Quanto às funcionalidades existentes, fizemos uma pequena alteração nas atas da RGM, as mesmas passam agora apenas a estarem disponíveis para os membros do curso.Chamamos para a atenção do facto de que, na anterior versão todas as opções existentes no site apareciam logo sem login e posteriormente é que era pedido o mesmo, alteramos isso, agora só aparecem todas as opções após login.<hr>Caso encontres algum bug por favor informa o NEI de modo a que este possa ser corrigido!', 1866, '2019-07-22', '2019-09-06', 1866, 1),
(8, '/news/mecvsei.jpg', 'ACTIVE', 'Engenharia Mecânica vs Engenharia Informática (3-2)', 'EVENT', 'Apesar da derrota frente a Engenharia Mecânica por 3-2 num jogo bastante efusivo tivemos as bancadas cheias.<br>Mostramos hoje, novamente, que não é por acaso que ganhamos o prémio de melhor claque da época 2018/2019<br>Podes ver as fotos do jogo no nosso facebook:<br><br><iframe src=\https://www.facebook.com/plugins/post.php?href=https%3A%2F%2Fwww.facebook.com%2Fmedia%2Fset%2F%3Fset%3Da.2657806134483446%26type%3D3&width=500\ width=\500\ height=\650\ align=\middle\ style=\border:none;overflow:hidden\ scrolling=\no\ frameborder=\0\ allowTransparency=\true\ allow=\encrypted-media\></iframe>', 1866, '2019-10-17', NULL, NULL, 1),
(9, '/news/melhorclaque.jpg', 'ACTIVE', 'Melhor Claque 2018/2019', 'NEWS', 'No passado domingo, dia 13 de outubro, decorreu a gala <strong>Academia de Ouro</strong> organizada pela Associação Académica da Universidade de Aveiro.<br>Esta gala visa distinguir personalidades que se destacaram na época de 2018/2019 e dar a conhecer a nova época.<br>O curso de Engenharia Informática foi nomeado para melhor claque e acabou por vencer trazendo para o DETI um prémio que faltava no palmarés.<br>O troféu encontra-se agora exposto junto da porta que dá acesso ao aquário.<br>Resalvamos que esteve ainda nomeado o Bruno Barbosa para melhor jogador mas infelizmente não ganhou o prémio.<br>', 1866, '2019-10-17', NULL, NULL, 1),
(10, '/news/boxburger.png', 'ACTIVE', 'Aproveita o teu desconto de 25%', 'PARCERIA', 'Façam como a Flávia e o Luís e comam no Box Burger.<br>Agora qualquer estudante de Engenharia Informática tem desconto de 25%. Basta apresentarem o cartão de estudante e informar que são de Engenharia Informática.<br>Do que estás à espera? Aproveita!', 1866, '2019-10-17', NULL, NULL, 1),
(11, '/news/rally.jpg', 'ACTIVE', 'Aveiro Horror Story | Rally Tascas #2', 'EVENT', 'És aquele que boceja nos filmes de terror? Adormeceste enquanto dava a parte mais tramada do filme? Este Rally Tascas é para ti!<br>Vem pôr à prova a tua capacidade de engolir o medo no próximo dia 31, e habilita-te a ganhar um prémio!<br>O último Rally foi só o trailer... desta vez vens viver um episódio de terror!<br><br>Não percas a oportunidade e inscreve-te <a href=\https://nei.web.ua.pt/links/irally\ target=\_blank\>aqui!</a><br><br>Consulta o Regulamento <a href=\https://nei.web.ua.pt/links/rally\ target=\_blank\> aqui!</a>', 1866, '2019-10-17', NULL, NULL, 1),
(12, '/news/sessfp.jpg', 'ACTIVE', '1ª Sessão de Dúvidas // Fundamentos de Programação', 'EVENT', 'O NEI está a organizar uma sessão de dúvidas que te vai ajudar a preparar de uma melhor forma para os teus exames da unidade curricular de Fundamentos da Porgramação.<br>A sessão vai ter lugar no dia 22 de outubro e ocorrerá no DETI entre as 18-22h.<br>É importante trazeres o teu material de estudo e o teu computador pessoal uma vez que nem todas as salas têm computadores à disposição.<br>As salas ainda não foram atribuídas, serão no dia do evento, está atento ao <a href=\https://www.facebook.com/events/493810694797695/\>nosso facebook!</a><br>', 1866, '2019-10-18', NULL, NULL, 1),
(13, '/news/newNEI.png', 'ACTIVE', 'PWA NEI', 'NEWS', 'Agora o site do NEI já possui uma PWA, basta aceder ao site e carregar na notificação para fazer download da mesma.<br>Fica atento, em breve, terás novidades sobre uma plataforma para a Taça UA! Vais poder acompanhar tudo o que se passa e inclusivé ver os resultados do teu curso em direto.<br><img src=\https://nei.web.ua.pt/upload/NEI/pwa.jpg\ height=\400\/><img src=\https://nei.web.ua.pt/upload/NEI/pwa2.jpg\ height=\400\/>', 1866, '2019-10-21', NULL, NULL, 1),
(14, '/news/const_cv.png', 'ACTIVE', 'Como construir um bom CV? by Olisipo', 'EVENT', 'Dada a competitividade atual do mercado de trabalho, apresentar um bom currículo torna-se cada vez mais indispensável. Desta forma, o NEI e o NEECT organizaram um workshop chamado \Como construir um bom CV?\, com o apoio da Olisipo. <br>Informações relevantes:<br><ul> <li> 7 de Novembro pelas 18h no DETI (Sala 102)</li> <li> Participação Gratuita</li> <li> INSCRIÇÕES OBRIGATÓRIAS</li> <li> INSCRIÇÕES LIMITADAS</li> <li> Inscrições <a href=\https://docs.google.com/forms/d/e/1FAIpQLSf4e3ZnHdp4INHrFgVCaXQv3pvVgkXrWN_U39s94X7Hvd98XA/viewform\ target=\_blank\>aqui</a></li></ul>  <br> Nesta atividade serão abordados diversos tópicos relativos à importância de um bom currículo e quais as formas corretas de o apresentar.', 1866, '2019-11-02', NULL, 1866, 1),
(15, '/news/apontamentos.png', 'ACTIVE', 'Apontamentos que já não precisas? Há quem precise!', 'NEWS', 'Tens apontamentos, resoluções ou qualquer outro material de estudo que já não precisas?Vem promover a inter-ajuda e entrega-os na sala do NEI (132) ou digitaliza-os e envia para nei@aauav.pt.Estarás a contribuir para uma base de dados de apontamentos mais sólida, organizada e completa para o nosso curso!Os alunos de informática agradecem!', 1719, '2020-01-29', NULL, NULL, 1),
(16, '/news/nei_aniv.png', 'ACTIVE', '7º ANIVERSÁRIO DO NEI', 'EVENT', 'Foi no dia 25, há 7 anos atrás, que o TEU núcleo foi criado. Na altura chamado de Núcleo de Estudantes de Sistemas de Informação, mudou para o seu nome atual em 2014.Dos marcos do núcleo ao longo da sua história destacam-se o ENEI em 2014, o Think Twice em 2019 e as diversas presenças nas atividades em grande escala da AAUAv.Parabéns a todos os que contribuíram para o NEI que hoje temos!', 1719, '2020-01-29', NULL, NULL, 1),
(17, '/news/delloitte_consultantforaday.png', 'ACTIVE', 'Queres ser consultor por um dia? A Deloitte dá-te essa oportunidade', 'EVENT', 'A Deloitte Portugal está a organizar o evento “Be a Consultant for a Day | Open House Porto”. Esta iniciativa dá-te acesso a um dia com várias experiências de desenvolvimento de competências e terás ainda a oportunidade de conhecer melhor as áreas de negócio integradas em consultoria tecnológica.O evento irá decorrer no Deloitte Studio do Porto e contará com alunos de várias Universidades da região Norte (Coimbra, Aveiro, Porto e Minho).', 1719, '2020-01-29', NULL, NULL, 1),
(18, '/news/pub_rgm.png', 'ACTIVE', 'Primeira RGM Ordinária', 'EVENT', 'Convocam-se todos os membros de LEI e MEI para a 1ª RGM ordinária com a seguinte ordem de trabalhos:<br><br>1. Aprovação da ata da RGM anterior;<br>2. Apresentação do Plano de Atividades e Orçamento;<br>3. Aprovação do Plano de Atividades e Orçamento;<br>4. Discução relativa à modalidade do Evento do Aniversário do NEI;<br>5. Colaboradores do NEI;<br>6. Informações relativas à Barraca do Enterro 2020;<br>7. Discussão sobre as Unidades Curriculares do 1º Semestre;<br>8. Outros assuntos.<br><br>Link para o Plano de Atividades e Orçamento (PAO):<br>https://nei.web.ua.pt/upload/documents/PAO/2020/PAO_NEI2020.pdf<br><br>Na RGM serão discutidos assuntos relativos a TODOS os estudantes de informática.<br>Sendo assim, apelamos à participação de TODOS!', 1719, '2020-02-18', '2020-02-18', 1719, 1),
(19, '/news/colaboradores.jpg', 'ACTIVE', 'Vem ser nosso Colaborador!', 'EVENT', 'És um estudante ativo?<br>Procuras aprender novas competências e desenvolver novas?<br>Gostavas de ajudar o teu núcleo a proporcionar as melhores atividades da Universidade?<br>Se respondeste sim a pelo menos uma destas questões clica <a href=\https://forms.gle/3y5JZfNvN7rBjFZT8\ target=\_blank\>aqui</a><br>E preenche o formulário!<br>Sendo um colaborador do NEI vais poder desenvolver várias capacidades, sendo que maioria delas não são abordadas nas Unidades Curriculares!<br>Vais fazer amizades e a cima de tudo vais te divertir!<br>Junta-te a nós e ajuda o NEI a desenvolver as melhores atividades possíveis!', 1719, '2020-02-19', NULL, NULL, 1),
(20, '/news/dia-syone.jpg', 'ACTIVE', 'Dia da Syone', 'EVENT', 'A Syone é uma empresa portuguesa provedora de Open Software Solutions.<br/>Neste dia podes participar num workshop, almoço gratuito e num mini-hackathon com prémios! <i class=\fa fa-trophy\ style=\color: gold\></i><br/>Garante já a tua presença através do <a href=\https://forms.gle/62yYsFiiiZXoTiaR8\ target=\_blank\>formulário</a>.<br/>O evento está limitado a 30 pessoas!', 1719, '2020-02-26', NULL, NULL, 1),
(21, '/news/roundtable.jpg', 'ACTIVE', 'Round Table - Bolsas de Investigação', 'EVENT', 'Gostavas de estudar e de ao mesmo tempo desenvolver trabalho de investigação? E se com isto tiveres acesso a uma bolsa?<br/>Aparece nesta round table com os docentes responsáveis pelas bolsas de investigação e vem esclarecer todas as tuas dúvidas!', 1719, '2020-02-26', '2020-03-01', 1719, 1),
(22, '/news/jogos-marco.jpg', 'ACTIVE', 'Calendário dos Jogos de março', 'EVENT', 'Não percas os jogos do teu curso na Taça UA para o mês de março!<br/>Aparece ao máximo de jogos possível para apoiares o teu curso em todas as modalidades.<br/>Vem encher a bancada e fazer parte da melhor claque da UA! Contamos contigo e o teu magnifico apoio!', 1719, '2020-03-01', NULL, NULL, 1),
(23, '/news/hackathome.png', 'ACTIVE', 'HackatHome', 'EVENT', 'Tens andado aborrecido nesta quarentena? É contigo em mente que decidimos contornar esta triste situação e organizar um HackatHome!<br/>O HackatHome é uma competição de programação online promovida pelo NEI que consiste na resolução de uma coleção de desafios de programação.<br/>A partir desta quarta feira, e todas as quartas durante as próximas 12 semanas(!), será disponibilizado um desafio, o qual os participantes têm até à quarta-feira seguinte para resolver (1 semana).<br/>Toda a competição assentará na plataforma GitHub Classroom, utilizada para requisitar e submeter os desafios. As pontuações são atribuídas por desafio, e ganha o participante com mais pontos acumulados ao final das 12 semanas!<br/>Não há processo de inscrição, apenas tens de estar atento à divulgação dos links dos desafios nos meios de comunicação do NEI, resolver e submeter através da tua conta GitHub!<br/>Além do prémio do vencedor, será também premiado um participante aleatório! Interessante não? &#129300;<br/>Consulta o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_HackatHome.pdf\ target=\_blank\>regulamento</a>!<br/>E prepara-te para a competição! &#128170;<br/><h2><b>Desafios</b></h2><h4><a href=\https://bit.ly/3bJBNaA\ target=\_blank\>Desafio 1</a></h4><h4><a href=\https://bit.ly/2Rnuy03\ target=\_blank\>Desafio 2</a></h4><h4><a href=\https://bit.ly/2wKmZJW\ target=\_blank\>Desafio 3</a></h4><h4><a href=\http://tiny.cc/Desafio4\ target=\_blank\>Desafio 4</a></h4><h4><a href=\http://tiny.cc/DESAFIO5\ target=\_blank\>Desafio 5</a></h4><h4><a href=\http://tiny.cc/Desafio6\ target=\_blank\>Desafio 6</a></h4><h4><a href=\http://tiny.cc/Desafio7\ target=\_blank\>Desafio 7</a></h4>', 1719, '2020-03-30', '2020-05-13', 1719, 1),
(24, '/news/pleiathome.png', 'ACTIVE', 'PLEIATHOME', 'EVENT', 'O PL<b style=\color: #59CD00\>EI</b>ATHOME é um conjunto de mini-torneios de jogos online que se vão desenrolar ao longo do semestre. As equipas acumulam \pontos PLEIATHOME\ ao longo dos mini-torneios, sendo que os vencedores finais ganham prémios!<br/>Organiza a tua equipa e vai participar em mais uma saga AtHome do NEI!Podes consultar o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_PLEIATHOME.pdf\ target=\_blank\>regulamento</a> do evento.<br/><br/><b><big>FIRST TOURNAMENT</big></b><br/>KABOOM!! Chegou o primeiro torneio da competição PL<b style=\color: #59CD00\>EI</b>ATHOME, com o jogo Bombtag!<br/>O mini-torneio terá início dia 10 de abril pelas 19h, inscreve-te neste <a href=\https://bit.ly/3dXrAsU\ target=\_blank\>formulário</a> do Kaboom.<br/>E consulta o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_Kaboom.pdf\ target=\_blank\>regulamento</a> do Kaboom.<br/>Vamos lá!<br/><br/><b><big>SECOND TOURNAMENT</big></b><br/>SpeedTux &#128039;&#128168; Chegou o segundo torneio PL<b style=\color: #59CD00\>EI</b>ATHOME, com o clássico SuperTux!<br/>O mini-torneio terá início dia 24 de abril, pelas 19h. Inscreve-te neste <a href=\https://bit.ly/34ClZE3\ target=\_blank\>formulário</a> até às 12h desse mesmo dia. E consulta o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_SpeedTux.pdf\ target=\_blank\>regulamento</a> do SpeedTux.<br/>Estás à altura? &#128170;<br/><br/><b><big>THIRD TOURNAMENT</big></b><br/>Races à La Kart! Chegou mais um torneio PL<b style=\color: #59CD00\>EI</b>ATHOME, com o famoso TrackMania!<br/>O mini-torneio terá início dia 8 de maio (sexta-feira) pelas 19h, inscreve-te no <a href=\tiny.cc/racesalakart\ target=\_blank\>formulário</a> e consulta o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_Races_a_la_KART.pdf\ target=\_blank\>regulamento</a>.<br/>Descobre se és o mais rápido! &#127988;', 1719, '2020-04-06', '2020-05-04', 1719, 1),
(25, '/news/nei_lol.png', 'ACTIVE', 'Torneio Nacional de LoL', 'EVENT', 'Como a vida não é só trabalho, vem divertir-te a jogar e representar a Universidade de Aveiro em simultâneo! O NEEEC-FEUP está a organizar um torneio de League of Legends inter-universidades a nível nacional, e a UA está apta para participar.<br/>Existirá uma ronda de qualificação em Aveiro para determinar as 2 equipas que participam nacionalmente. O torneio é de inscrição gratuita e garante prémios para as equipas que conquistem o 1º e 2º lugar!<br/>Forma equipa e mostra o que vales!<br/><a href=\http://tiny.cc/torneioLOL\ target=\_blank\>Inscreve-te</a>!', 1719, '2020-05-13', NULL, NULL, 1),
(26, '/news/202122/96.jpg', 'ACTIVE', 'Roots Beach Club', 'EVENT', '<p>A primeira semana de aulas vai terminar em grande!</p><p>Na sexta-feira vem ao Roots Beach Club para uma beach party incrível.</p><p>A pulseira do evento garante o transporte desde Aveiro até à Praia da Barra, um teste antigénio à covid e a entrada no bar com uma bebida incluída!</p><p>Reserva a tua pulseira terça feira das 16h às 19h na sala 4.1.32.</p>', 1602, '2021-10-10', NULL, NULL, 1);


--
-- Data for Name: note; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.note (id, name, location, subject_id, author_id, school_year_id, teacher_id, summary, tests, bibliography, slides, exercises, projects, notebook, content, created_at, type_id, size) VALUES
(1, 'MPEI Exemplo Teste 2014', '/note/segundo_ano/primeiro_semestre/mpei/MP_Exemplo_Teste.pdf', 40337, NULL, 1, 5, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(2, 'Diversos - 2017/2018 (zip)', '/note/segundo_ano/primeiro_semestre/mpei/RafaelDireito_2017_2018_MPEI.zip', 40337, 1800, 2, 4, 1, 0, 1, 1, 1, 0, 0, NULL, '2021-06-14 19:17:30', 2, 35),
(3, 'Resumos Teóricos (zip)', '/note/segundo_ano/primeiro_semestre/mpei/Resumos_Teoricas.zip', 40337, 1023, 1, 5, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos_Teóricas</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 8),
(4, 'Resumos FP 2018/2019 (zip)', '/note/primeiro_ano/primeiro_semestre/fp/Goncalo_FP.zip', 40379, 1275, 3, 27, 1, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aulas Práticas</dt><dd><dd>148 pastas</dd><dd>132 ficheiros</dd><dd></dl><dl><dt>Resumos</dt><dd><dd>1 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Testes para praticar</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Visualize Cod...</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 30),
(5, 'Material FP 2016/2017 (zip)', '/note/primeiro_ano/primeiro_semestre/fp/RafaelDireito_FP_16_17.zip', 40379, 1800, 4, NULL, 1, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>34 pastas</dd><dd>30 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 14),
(6, 'Resoluções 18/19', '/note/primeiro_ano/primeiro_semestre/fp/resolucoes18_19.zip', 40379, NULL, 3, NULL, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>18-19</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(7, 'Apontamentos Globais', '/note/primeiro_ano/primeiro_semestre/itw/apontamentos001.pdf', 40380, NULL, NULL, 8, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 3),
(8, 'Questões de SO (zip)', '/note/segundo_ano/primeiro_semestre/so/Questões.zip', 40381, NULL, 5, NULL, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Quest?es</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(9, 'Diversos - 2017/2018 (zip)', '/note/segundo_ano/primeiro_semestre/so/RafaelDireito_2017_2018_SO.zip', 40381, 1800, 2, 1, 1, 0, 0, 1, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>46 pastas</dd><dd>43 ficheiros</dd><dd></dl><dl><dt>Rafael_Diteit...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 35),
(10, 'Apontamentos Diversos (zip)', '/note/segundo_ano/segundo_semestre/pds/JoaoAlegria_PDS.zip', 40383, 1455, 5, 12, 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_R...</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>JoaoAlegria_E...</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 6),
(11, 'Resumos de 2015/2016', '/note/segundo_ano/segundo_semestre/pds/pds_apontamentos_001.pdf', 40383, 1455, 5, 12, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 4),
(12, 'Apontamentos genéricos I', '/note/segundo_ano/segundo_semestre/pds/pds_apontamentos_002.pdf', 40383, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(13, 'Apontamentos genéricos II', '/note/segundo_ano/segundo_semestre/pds/pds_apontamentos_003.pdf', 40383, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(14, 'Diversos - CBD Prof. JLO (zip)', '/note/terceiro_ano/primeiro_semestre/cbd/InesCorreia_CBD(CC_JLO).zip', 40385, 1335, NULL, 12, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>InesCorreia_C...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 2),
(15, 'MAS 2014/2015 (zip)', '/note/primeiro_ano/segundo_semestre/mas/BarbaraJael_14_15_MAS.zip', 40431, 963, 1, 13, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>resumo-mas.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 14),
(16, 'Preparação para Exame Final de MAS', '/note/primeiro_ano/segundo_semestre/mas/Duarte_MAS.pdf', 40431, 1182, 3, 13, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(17, 'MAS 2016/2017 (zip)', '/note/primeiro_ano/segundo_semestre/mas/RafaelDireito_2016_2017_MAS.zip', 40431, 1800, 4, 13, 1, 0, 1, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 19),
(18, 'Resumos_MAS', '/note/primeiro_ano/segundo_semestre/mas/Resumos_MAS_Carina.zip', 40431, 1002, 2, 13, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>MAS_Resumos.pdf</dt><dd><dd></dl><dl><dt>MAS_Resumos2.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 8),
(19, 'Resolução das fichas (zip)', '/note/segundo_ano/primeiro_semestre/smu/Resoluçao_das_fichas.zip', 40432, NULL, NULL, NULL, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resoluçao das fichas</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 27),
(20, 'Resumos (zip)', '/note/segundo_ano/primeiro_semestre/smu/Resumo.zip', 40432, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 116),
(21, 'Resumos de 2013/2014', '/note/segundo_ano/primeiro_semestre/smu/smu_apontamentos_001.pdf', 40432, 963, 6, 26, 1, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 11),
(22, 'Resumos de 2016/2017', '/note/segundo_ano/primeiro_semestre/smu/smu_apontamentos_002.pdf', 40432, 1023, 4, 15, 1, 1, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(23, 'Resumos de 2017/2018', '/note/segundo_ano/primeiro_semestre/smu/smu_apontamentos_003.pdf', 40432, 1866, 2, 15, 1, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 7),
(24, 'Resumos 2018/19', '/note/segundo_ano/primeiro_semestre/smu/SMU_Resumos.pdf', 40432, NULL, NULL, NULL, 1, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 4),
(25, 'Resumos (zip)', '/note/segundo_ano/primeiro_semestre/rs/Resumo.zip', 40433, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 24),
(26, 'Caderno', '/note/segundo_ano/primeiro_semestre/rs/rs_apontamentos_001.pdf', 40433, 963, 1, 16, 1, 0, 0, 0, 1, 0, 1, NULL, '2021-06-14 19:17:30', 1, 6),
(27, 'Resumos_POO', '/note/primeiro_ano/segundo_semestre/poo/Carina_POO_Resumos.zip', 40436, 1002, 2, 31, 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>POO_Resumos_OT.pdf</dt><dd><dd></dl><dl><dt>POO_Resumos.pdf</dt><dd><dd></dl><dl><dt>POO_resumos_v2.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 6),
(28, 'Resumos POO 2018/2019 (zip)', '/note/primeiro_ano/segundo_semestre/poo/Goncalo_POO.zip', 40436, 1275, 3, 28, 1, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Apontamentos</dt><dd><dd>1 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Aulas Práticas</dt><dd><dd>17 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 4),
(29, 'Diversos - Prática e Teórica (zip)', '/note/primeiro_ano/segundo_semestre/poo/RafaelDireito_2016_2017_POO.zip', 40436, 1800, 4, NULL, 1, 1, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>495 pastas</dd><dd>492 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 43),
(30, 'Resumos Teóricos (zip)', '/note/primeiro_ano/segundo_semestre/poo/Resumos.zip', 40436, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 22),
(31, 'Resumos de 2016/2017', '/note/segundo_ano/primeiro_semestre/aed/aed_apontamentos_001.pdf', 40437, 1023, 4, 17, 1, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 5),
(32, 'Bibliografia (zip)', '/note/segundo_ano/primeiro_semestre/aed/bibliografia.zip', 40437, NULL, NULL, NULL, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Linguagem C -...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 33),
(33, 'Resumos 2016/2017', '/note/mestrado/aa/aa_apontamentos_001.pdf', 40751, 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(34, 'Exames 2017/2018', '/note/mestrado/tai/tai_apontamentos_001.pdf', 40752, 1455, 2, NULL, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(35, 'Teste Modelo 2016/2017', '/note/mestrado/tai/tai_apontamentos_002.pdf', 40752, 1455, 4, NULL, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 3),
(36, 'Ficha de Exercícios 1 - 2016/2017', '/note/mestrado/tai/tai_apontamentos_003.pdf', 40752, 1455, 4, NULL, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 5),
(37, 'Ficha de Exercícios 2 - 2016/2017', '/note/mestrado/tai/tai_apontamentos_004.pdf', 40752, 1455, 4, NULL, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 3),
(38, 'Resumos 2016/2017', '/note/mestrado/cle/cle_apontamentos_001.pdf', 40753, 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 12),
(39, 'Resumos 2016/2017', '/note/mestrado/gic/gic_apontamentos_001.pdf', 40756, 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 12),
(40, 'Resumos 2017/2018', '/note/terceiro_ano/primeiro_semestre/ia/ia_apontamentos_002.pdf', 40846, 1023, 2, 30, 1, 1, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 6),
(41, 'Aulas Teóricas (zip)', '/note/segundo_ano/segundo_semestre/c/Aulas_Teóricas.zip', 41469, NULL, 5, 10, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aulas Teóricas</dt><dd><dd>41 pastas</dd><dd>27 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 6),
(42, 'Guião de preparacao para o teste prático (zip)', '/note/segundo_ano/segundo_semestre/c/Guião_de _preparacao_para_o_teste_pratico.zip', 41469, NULL, NULL, NULL, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Gui?o de prep...</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(43, 'Apontamentos Diversos (zip)', '/note/segundo_ano/segundo_semestre/ihc/Apontamentos.zip', 41549, NULL, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Apontamentos</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 16),
(44, 'Avaliação Heurística', '/note/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_001.pdf', 41549, 1455, 1, 9, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(45, 'Resumos de 2014/2015', '/note/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_002.pdf', 41549, 963, 1, 9, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 3),
(46, 'Resolução de fichas (zip)', '/note/segundo_ano/segundo_semestre/ihc/Resolução_de_fichas.zip', 41549, NULL, NULL, 9, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resoluç?o de fichas</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 14),
(47, 'Apontamentos EF (zip)', '/note/primeiro_ano/primeiro_semestre/ef/BarbaraJael_EF.zip', 41791, 963, 1, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>BarbaraJael_1...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 4),
(48, 'Exercícios 2017/2018', '/note/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_001.pdf', 41791, 1800, 2, 24, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(49, 'Exercícios 2016/17', '/note/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_002.pdf', 41791, 1800, 4, NULL, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 7),
(50, 'Resumos EF 2018/2019 (zip)', '/note/primeiro_ano/primeiro_semestre/ef/Goncalo_EF.zip', 41791, 1275, 3, 29, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Documento_Obt...pdf</dt><dd><dd></dl><dl><dt>Documento_Tra...pdf</dt><dd><dd></dl><dl><dt>P4_7-12.pdf</dt><dd><dd></dl><dl><dt>PL1_Ótica.pdf</dt><dd><dd></dl><dl><dt>PL2_Pêndulo E...pdf</dt><dd><dd></dl><dl><dt>PL2_Pêndulo E...jpg</dt><dd><dd></dl><dl><dt>PL2_Pêndulo E...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração.pdf</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL4_Relatório.pdf</dt><dd><dd></dl><dl><dt>PL_Pauta Final.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 5),
(51, 'Exercícios 2018/19', '/note/primeiro_ano/primeiro_semestre/ef/Pedro_Oliveira_2018_2019.zip', 41791, 1764, 3, 29, 0, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pedro Oliveira</dt><dd><dd>6 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 28),
(52, 'Apontamentos e Resoluções (zip)', '/note/primeiro_ano/segundo_semestre/iac/PedroOliveira.zip', 42502, 1764, 2, 6, 0, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pedro Oliveira</dt><dd><dd>10 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 23),
(53, 'Caderno - 2016/2017', '/note/segundo_ano/segundo_semestre/bd/bd_apontamentos_001.pdf', 42532, 1023, 4, 7, 1, 0, 0, 0, 1, 0, 1, NULL, '2021-06-14 19:17:30', 1, 2),
(54, 'Resumos - 2014/2015', '/note/segundo_ano/segundo_semestre/bd/bd_apontamentos_002.pdf', 42532, 1455, 1, 7, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(55, 'Resumos globais', '/note/segundo_ano/segundo_semestre/bd/BD_Resumos.pdf', 42532, NULL, NULL, 7, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 8),
(56, 'Slides das Aulas Teóricas (zip)', '/note/segundo_ano/segundo_semestre/bd/Slides_Teoricas.zip', 42532, NULL, 1, 7, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides_Teoricas</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 21),
(57, 'Outros Resumos (zip)', '/note/terceiro_ano/primeiro_semestre/sio/Outros_Resumos.zip', 42573, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Outros Resumos</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 3),
(58, 'Resumo geral de segurança I', '/note/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_001.pdf', 42573, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(59, 'Resumo geral de segurança II', '/note/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_002.pdf', 42573, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(60, 'Resumos de 2015/2016', '/note/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_003.pdf', 42573, 963, 5, 3, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 8),
(61, 'Resumo geral de segurança III', '/note/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_004.pdf', 42573, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(62, 'Apontamentos genéricos', '/note/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_005.pdf', 42573, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(63, 'Resumos de ALGA (zip)', '/note/primeiro_ano/primeiro_semestre/alga/Carolina_Albuquerque_ALGA.zip', 42709, 1023, 5, 23, 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>ALGA - Resumo...pdf</dt><dd><dd></dl><dl><dt>Exemplos da i...pdf</dt><dd><dd></dl><dl><dt>Exemplos de m...pdf</dt><dd><dd></dl><dl><dt>Exemplos de m...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 59),
(64, 'ALGA 2017/2018 (zip)', '/note/primeiro_ano/primeiro_semestre/alga/DiogoSilva_17_18_ALGA.zip', 42709, 1161, 2, 23, 0, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>DiogoSilva_17...</dt><dd><dd>0 pastas</dd><dd>26 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 21),
(65, 'Resumos ALGA 2018/2019 (zip)', '/note/primeiro_ano/primeiro_semestre/alga/Goncalo_ALGA.zip', 42709, 1275, 3, 19, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_Matrizes e ...pdf</dt><dd><dd></dl><dl><dt>2_Determinantes.pdf</dt><dd><dd></dl><dl><dt>3_Vetores, re...pdf</dt><dd><dd></dl><dl><dt>4_Espaços vet...pdf</dt><dd><dd></dl><dl><dt>5_Valores e v...pdf</dt><dd><dd></dl><dl><dt>6_Cónicas e q...pdf</dt><dd><dd></dl><dl><dt>7_Aplicações ...pdf</dt><dd><dd></dl><dl><dt>Complemento_C...pdf</dt><dd><dd></dl><dl><dt>Complemento_C...pdf</dt><dd><dd></dl><dl><dt>Resumo Teste ...pdf</dt><dd><dd></dl><dl><dt>Resumo Teste ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 41),
(66, 'Resumos 2016/2017', '/note/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_001.pdf', 42728, 1719, 4, 21, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 16),
(67, 'Resumos 2016/2017', '/note/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_002.pdf', 42728, 1866, 4, 21, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 5),
(68, 'Teste Primitivas 2016/2017', '/note/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_003.pdf', 42728, 1800, 4, 21, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(69, 'Exercícios 2016/2017', '/note/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_004.pdf', 42728, 1800, 4, 21, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 5),
(70, 'Resumos 2016/2017', '/note/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_005.pdf', 42728, 1800, 4, 21, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 11),
(71, 'Fichas 2016/2017', '/note/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_006.pdf', 42728, 1800, 4, 21, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 22),
(72, 'CI 2017/2018 (zip)', '/note/primeiro_ano/primeiro_semestre/c1/DiogoSilva_17_18_C1.zip', 42728, 1161, 2, 21, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>28821701_4498...jpg</dt><dd><dd></dl><dl><dt>28768155_4497...jpg</dt><dd><dd></dl><dl><dt>28927694_4497...jpg</dt><dd><dd></dl><dl><dt>28821773_4497...jpg</dt><dd><dd></dl><dl><dt>28876807_4497...jpg</dt><dd><dd></dl><dl><dt>28879472_4497...jpg</dt><dd><dd></dl><dl><dt>28822131_4497...jpg</dt><dd><dd></dl><dl><dt>28768108_4497...jpg</dt><dd><dd></dl><dl><dt>28811040_4497...jpg</dt><dd><dd></dl><dl><dt>28943154_4497...jpg</dt><dd><dd></dl><dl><dt>28879660_4497...jpg</dt><dd><dd></dl><dl><dt>28876653_4497...jpg</dt><dd><dd></dl><dl><dt>28768432_4497...jpg</dt><dd><dd></dl><dl><dt>28768056_4497...jpg</dt><dd><dd></dl><dl><dt>28877054_4497...jpg</dt><dd><dd></dl><dl><dt>28768634_4497...jpg</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 2),
(73, 'Resumos Cálculo I 2018/2019 (zip)', '/note/primeiro_ano/primeiro_semestre/c1/Goncalo_C1.zip', 42728, 1275, 3, 18, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>0_Formulário_...pdf</dt><dd><dd></dl><dl><dt>0_FORMULÁRIO_...pdf</dt><dd><dd></dl><dl><dt>0_Revisões se...pdf</dt><dd><dd></dl><dl><dt>1_Funções tri...pdf</dt><dd><dd></dl><dl><dt>2_Teoremas do...pdf</dt><dd><dd></dl><dl><dt>3_Integrais i...pdf</dt><dd><dd></dl><dl><dt>4_Integrais d...pdf</dt><dd><dd></dl><dl><dt>5_Integrais i...pdf</dt><dd><dd></dl><dl><dt>6_Séries numé...pdf</dt><dd><dd></dl><dl><dt>Formulário_Sé...pdf</dt><dd><dd></dl><dl><dt>Resumo_Integr...pdf</dt><dd><dd></dl><dl><dt>Tópicos_Teste 1.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 24),
(74, 'Caderno de 2016/2017', '/note/primeiro_ano/segundo_semestre/c2/calculoii_apontamentos_003.pdf', 42729, 1719, 4, 22, 0, 0, 0, 0, 0, 0, 1, NULL, '2021-06-14 19:17:30', 1, 18),
(75, 'Resumos Cálculo II 2018/2019 (zip)', '/note/primeiro_ano/segundo_semestre/c2/Goncalo_C2.zip', 42729, 1275, 3, 19, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>0_Revisões.pdf</dt><dd><dd></dl><dl><dt>1_Séries de p...pdf</dt><dd><dd></dl><dl><dt>2_Sucessões e...pdf</dt><dd><dd></dl><dl><dt>3.1_Funções r...pdf</dt><dd><dd></dl><dl><dt>3.2_Funções r...pdf</dt><dd><dd></dl><dl><dt>4_Equações di...pdf</dt><dd><dd></dl><dl><dt>5_Transformad...pdf</dt><dd><dd></dl><dl><dt>Detalhes para...pdf</dt><dd><dd></dl><dl><dt>Detalhes para...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 21),
(76, 'Resumos 2016/2017', '/note/mestrado/vi/vi_apontamentos_001.pdf', 44156, 1455, 4, 9, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 4),
(77, 'Resumos por capítulo (zip)', '/note/mestrado/ws/JoaoAlegria_ResumosPorCapítulo.zip', 44158, 1455, 4, 25, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_R...</dt><dd><dd>0 pastas</dd><dd>10 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 8),
(78, 'Resumos 2016/2017', '/note/mestrado/ws/web_semantica_apontamentos_001.pdf', 44158, 1455, 4, 25, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 9),
(79, 'Apontamentos Diversos', '/note/terceiro_ano/primeiro_semestre/icm/Inês_Correia_ICM.pdf', 45424, 1335, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(80, 'Apontamentos Diversos', '/note/terceiro_ano/segundo_semestre/tqs/Inês_Correia_TQS.pdf', 45426, 1335, 4, 13, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 14),
(81, 'Resumos (zip)', '/note/terceiro_ano/segundo_semestre/tqs/resumos.zip', 45426, NULL, 4, 13, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos_chave</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 22),
(82, 'Resumos 2015/2016', '/note/terceiro_ano/segundo_semestre/tqs/tqs_apontamentos_002.pdf', 45426, 1455, 5, 13, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 3),
(83, 'Resumos 2017/2018 - I', '/note/mestrado/ed/ed_dm_apontamentos_001.pdf', 45587, 1455, 4, 26, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 36),
(84, 'Resumos 2017/2018 - II', '/note/mestrado/ed/ed_dm_apontamentos_002.pdf', 45587, 1455, 4, 26, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 48),
(85, 'Resumos MD 2018/2019 (zip)', '/note/primeiro_ano/segundo_semestre/md/Goncalo_MD.zip', 47166, 1275, 3, 20, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1.1_Lógica pr...pdf</dt><dd><dd></dl><dl><dt>1.2_Conjuntos.pdf</dt><dd><dd></dl><dl><dt>1.3_Relações ...pdf</dt><dd><dd></dl><dl><dt>1.4_Funções.pdf</dt><dd><dd></dl><dl><dt>1.5_Relações ...pdf</dt><dd><dd></dl><dl><dt>1.6_Lógica de...pdf</dt><dd><dd></dl><dl><dt>2_Contextos e...pdf</dt><dd><dd></dl><dl><dt>3_Princípios ...pdf</dt><dd><dd></dl><dl><dt>4_Permutações.pdf</dt><dd><dd></dl><dl><dt>5_Agrupamento...pdf</dt><dd><dd></dl><dl><dt>6_Recorrência...pdf</dt><dd><dd></dl><dl><dt>7_Elementos d...pdf</dt><dd><dd></dl><dl><dt>Detalhes capí...pdf</dt><dd><dd></dl><dl><dt>Detalhes capí...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 27),
(86, 'Resumos 2017/2018', '/note/primeiro_ano/segundo_semestre/md/MD_Capitulo5.pdf', 47166, 1002, 2, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 4),
(87, 'RafaelDireito_2016_2017_MD.zip', '/note/primeiro_ano/segundo_semestre/md/RafaelDireito_2016_2017_MD.zip', 47166, 1800, 4, NULL, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>11 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 24),
(88, 'RafaelDireito_MD_16_17_Apontamentos (zip)', '/note/primeiro_ano/segundo_semestre/md/RafaelDireito_MD_16_17_Apontamentos.zip', 47166, 1800, 4, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 4),
(89, 'DS_MPEI_18_19_Testes (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Testes.zip', 40337, 1161, 3, 4, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Enunciados</dt><dd><dd>5 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>Teste 1 2015</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Teste 2 2015</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Teste 2 2017</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 23),
(90, 'DS_MPEI_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_SlidesTeoricos.zip', 40337, 1161, 3, 4, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>MPEI-2017-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2017-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 27),
(91, 'DS_MPEI_18_19_Resumos (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Resumos.zip', 40337, 1161, 3, 4, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo1</dt><dd><dd>0 pastas</dd><dd>39 ficheiros</dd><dd></dl><dl><dt>Resumo2</dt><dd><dd>0 pastas</dd><dd>24 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 209),
(92, 'DS_MPEI_18_19_Projeto (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Projeto.zip', 40337, 1161, 3, 4, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>mpei.pptx</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 16),
(93, 'DS_MPEI_18_19_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Praticas.zip', 40337, 1161, 3, 4, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P01</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>P02</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P03</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>P04</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>P05</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P06</dt><dd><dd>0 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>P07</dt><dd><dd>0 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>P08</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>Remakes</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 9),
(94, 'DS_MPEI_18_19_Livros (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Livros.zip', 40337, 1161, 3, 4, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>estatistica-f...pdf</dt><dd><dd></dl><dl><dt>Livro.pdf</dt><dd><dd></dl><dl><dt>matlabnuminst...pdf</dt><dd><dd></dl><dl><dt>MATLAB_Starte...pdf</dt><dd><dd></dl><dl><dt>pt.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 6),
(95, 'DS_MPEI_18_19_Exercicios (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Exercicios.zip', 40337, 1161, 3, 4, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>2</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>3</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Slides Exercicios</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 37),
(96, 'Goncalo_ITW_18_19_Testes (zip)', '/note/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Testes.zip', 40380, 1275, 3, 8, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P7 05_Nov_201...</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>Teste teórico 1.zip</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(97, 'Goncalo_ITW_18_19_Resumos (zip)', '/note/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Resumos.zip', 40380, 1275, 3, 8, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>ITW _ BOOTSTRAP.pdf</dt><dd><dd></dl><dl><dt>ITW _ CSS.pdf</dt><dd><dd></dl><dl><dt>ITW _ HTML.pdf</dt><dd><dd></dl><dl><dt>ITW _ JAVASCRIPT.pdf</dt><dd><dd></dl><dl><dt>JAVACRIPT _ E...pdf</dt><dd><dd></dl><dl><dt>JAVACRIPT _P6...pdf</dt><dd><dd></dl><dl><dt>Resumo_T10_Kn...pdf</dt><dd><dd></dl><dl><dt>Resumo_T11_Du...pdf</dt><dd><dd></dl><dl><dt>Resumo_T8_jQu...pdf</dt><dd><dd></dl><dl><dt>Resumo_T9_Goo...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 12),
(98, 'Goncalo_ITW_18_19_Projeto (zip)', '/note/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Projeto.zip', 40380, 1275, 3, 8, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>P11 03_Nov_20...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>PROJETO</dt><dd><dd>147 pastas</dd><dd>147 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 33),
(99, 'Goncalo_ITW_18_19_Praticas (zip)', '/note/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Praticas.zip', 40380, 1275, 3, 8, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P1 24_Set_2018</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P10 26_Nov_20...</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P11 03_Nov_20...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>P2 01_Out_2018</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>P3 08_Out_2018</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P4 15_Out_2018</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>P5 22_Out_2018</dt><dd><dd>1 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>P6 29_Out_2018</dt><dd><dd>1 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>P7 05_Nov_201...</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>P8 12_Nov_2018</dt><dd><dd>0 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>P9 19_Nov_201...</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 30),
(100, 'RafaelDireito_ITW_18_19_Testes (zip)', '/note/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Testes.zip', 40380, 1800, 4, 8, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bootstrap+Tes...rar</dt><dd><dd></dl><dl><dt>Teste Prático ITW</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>Teste Teórico 2</dt><dd><dd>0 pastas</dd><dd>20 ficheiros</dd><dd></dl><dl><dt>Teste_Prático_ITW</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>Teste_Prático...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>ITW-Teste Teórico</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>ITW_Teste</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 9),
(101, 'RafaelDireito_ITW_18_19_Slides (zip)', '/note/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Slides.zip', 40380, 1800, 4, 8, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aula 1 - Apre...pdf</dt><dd><dd></dl><dl><dt>Aula 1 -Intro...pdf</dt><dd><dd></dl><dl><dt>Aula 10 - Goo...pdf</dt><dd><dd></dl><dl><dt>Aula 11 - ITW...pdf</dt><dd><dd></dl><dl><dt>Aula 11 - Tra...pdf</dt><dd><dd></dl><dl><dt>Aula 2 - Form...pdf</dt><dd><dd></dl><dl><dt>Aula 3 - CSS.pdf</dt><dd><dd></dl><dl><dt>Aula 4 -Twitt...pdf</dt><dd><dd></dl><dl><dt>Aula 5 -Javas...pdf</dt><dd><dd></dl><dl><dt>Aula 7 -Javas...pdf</dt><dd><dd></dl><dl><dt>Aula 8 -JQuery.pdf</dt><dd><dd></dl><dl><dt>Aula 9 -JQuer...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 19),
(102, 'RafaelDireito_ITW_18_19_Praticas (zip)', '/note/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Praticas.zip', 40380, 1800, 4, 8, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aula 8</dt><dd><dd>3 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Aula5-Js</dt><dd><dd>1 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>Aulas Práticas</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>Bilhete-Aviao</dt><dd><dd>6 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Calculadora-JS</dt><dd><dd>2 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Concerto- GER...</dt><dd><dd>3 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>Concerto-Jquery</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Concerto-Jque...</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Concerto-JS</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Conferencia</dt><dd><dd>6 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Gráficos</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>ITW java</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>ITW-Bootstrap_1</dt><dd><dd>20 pastas</dd><dd>26 ficheiros</dd><dd></dl><dl><dt>ITW_jQuery</dt><dd><dd>3 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Links de Apoi...txt</dt><dd><dd></dl><dl><dt>Mapa</dt><dd><dd>3 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Treino-ITW-2</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Weather</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>GitHub-  stor.txt</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 18),
(103, 'DS_SO_18_19_Testes (zip)', '/note/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Testes.zip', 40381, 1161, 3, 1, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Enunciados</dt><dd><dd>1 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Teorico-Pratico</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Teste 2015</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Teste 2017</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 46),
(104, 'DS_SO_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/primeiro_semestre/so/DS_SO_18_19_SlidesTeoricos.zip', 40381, 1161, 3, 1, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>sop_1819_0918...pdf</dt><dd><dd></dl><dl><dt>sop_1819_1002...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1023...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1030...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1106...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1120...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1127...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1204...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1211...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1218...ppt</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 11),
(105, 'DS_SO_18_19_ResumosTeoricos (zip)', '/note/segundo_ano/primeiro_semestre/so/DS_SO_18_19_ResumosTeoricos.zip', 40381, 1161, 3, 1, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Teorico</dt><dd><dd>0 pastas</dd><dd>43 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 157),
(106, 'DS_SO_18_19_ResumosPraticos (zip)', '/note/segundo_ano/primeiro_semestre/so/DS_SO_18_19_ResumosPraticos.zip', 40381, 1161, 3, 1, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pratico</dt><dd><dd>0 pastas</dd><dd>38 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 122),
(107, 'DS_SO_18_19_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Praticas.zip', 40381, 1161, 3, 1, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P01</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P02</dt><dd><dd>1 pastas</dd><dd>24 ficheiros</dd><dd></dl><dl><dt>P03</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P04</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>P05</dt><dd><dd>2 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>P06</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P07</dt><dd><dd>0 pastas</dd><dd>10 ficheiros</dd><dd></dl><dl><dt>P08</dt><dd><dd>1 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P09</dt><dd><dd>7 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P10</dt><dd><dd>3 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>P11</dt><dd><dd>1 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Remakes</dt><dd><dd>24 pastas</dd><dd>18 ficheiros</dd><dd></dl><dl><dt>Remakes2</dt><dd><dd>9 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 5),
(108, 'DS_SO_18_19_Fichas (zip)', '/note/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Fichas.zip', 40381, 1161, 3, 1, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Enunciados</dt><dd><dd>10 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Ficha 1</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>Ficha 2</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Ficha 3</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Ficha NEI 1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Ficha NEI 2</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Ficha NEI 4</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 51),
(109, 'CD_18_19_Livros (zip)', '/note/segundo_ano/segundo_semestre/cd/CD_18_19_Livros.zip', 40382, NULL, NULL, NULL, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Distributed_S...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 19),
(110, 'DS_CD_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/segundo_semestre/cd/DS_CD_18_19_SlidesTeoricos.zip', 40382, 1161, 3, 2, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aula 1.pdf</dt><dd><dd></dl><dl><dt>Aula 2.pdf</dt><dd><dd></dl><dl><dt>Aula 3.pdf</dt><dd><dd></dl><dl><dt>Aula 4.pdf</dt><dd><dd></dl><dl><dt>Aula 6.pdf</dt><dd><dd></dl><dl><dt>Aula 7.pdf</dt><dd><dd></dl><dl><dt>Aula 8.pdf</dt><dd><dd></dl><dl><dt>Cloud Computing.pdf</dt><dd><dd></dl><dl><dt>Flask.pdf</dt><dd><dd></dl><dl><dt>Syllabus.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 32),
(111, 'DS_CD_18_19_Resumos (zip)', '/note/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Resumos.zip', 40382, 1161, 3, 2, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>CDresumoch6.docx</dt><dd><dd></dl><dl><dt>CDresumoch6.pdf</dt><dd><dd></dl><dl><dt>CDresumoch7.docx</dt><dd><dd></dl><dl><dt>CDresumoch7.pdf</dt><dd><dd></dl><dl><dt>CDresumoch8.docx</dt><dd><dd></dl><dl><dt>GIT 101.pdf</dt><dd><dd></dl><dl><dt>Resumo Ch1-4</dt><dd><dd>0 pastas</dd><dd>104 ficheiros</dd><dd></dl><dl><dt>Resumos Ch5-8</dt><dd><dd>0 pastas</dd><dd>34 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 309),
(112, 'DS_CD_18_19_Projetos (zip)', '/note/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Projetos.zip', 40382, 1161, 3, 2, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>Projeto 1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Projeto 2</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(113, 'DS_CD_18_19_Praticas (zip)', '/note/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Praticas.zip', 40382, 1161, 3, 2, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P01</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>P02</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P03</dt><dd><dd>36 pastas</dd><dd>36 ficheiros</dd><dd></dl><dl><dt>P04</dt><dd><dd>6 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 3),
(114, 'DS_PDS_18_19_Testes (zip)', '/note/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Testes.zip', 40383, 1161, 3, 12, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Teste 2019</dt><dd><dd>0 pastas</dd><dd>26 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(115, 'DS_PDS_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_SlidesTeoricos.zip', 40383, 1161, 3, 12, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>PDS_0.pdf</dt><dd><dd></dl><dl><dt>PDS_09_Lambda...pdf</dt><dd><dd></dl><dl><dt>PDS_1_Softwar...pdf</dt><dd><dd></dl><dl><dt>PDS_2_GRASP.pdf</dt><dd><dd></dl><dl><dt>PDS_3_Pattern...pdf</dt><dd><dd></dl><dl><dt>PDS_4_Creatio...pdf</dt><dd><dd></dl><dl><dt>PDS_5_Structu...pdf</dt><dd><dd></dl><dl><dt>PDS_6_Behavio...pdf</dt><dd><dd></dl><dl><dt>PDS_7_Softwar...pdf</dt><dd><dd></dl><dl><dt>PDS_8_Reflection.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 81),
(116, 'DS_PDS_18_19_Resumos (zip)', '/note/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Resumos.zip', 40383, 1161, 3, 12, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo 1</dt><dd><dd>0 pastas</dd><dd>35 ficheiros</dd><dd></dl><dl><dt>Resumo 2</dt><dd><dd>0 pastas</dd><dd>25 ficheiros</dd><dd></dl><dl><dt>Resumo 3</dt><dd><dd>0 pastas</dd><dd>25 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 185),
(117, 'DS_PDS_18_19_Praticas (zip)', '/note/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Praticas.zip', 40383, 1161, 3, 12, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Guioes</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>pds_2019_g22</dt><dd><dd>70 pastas</dd><dd>61 ficheiros</dd><dd></dl><dl><dt>PraticasRemade</dt><dd><dd>277 pastas</dd><dd>276 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 6),
(118, 'MAS_18_19_Bibliografia (zip)', '/note/primeiro_ano/segundo_semestre/mas/MAS_18_19_Bibliografia.zip', 40431, NULL, NULL, NULL, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bibliografia_...pdf</dt><dd><dd></dl><dl><dt>Bibliografia_...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 6),
(119, 'MAS_18_19_Topicos_Estudo_Exame (zip)', '/note/primeiro_ano/segundo_semestre/mas/MAS_18_19_Topicos_Estudo_Exame.zip', 40431, NULL, 3, 13, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>MAS 201819 - ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(120, 'Goncalo_MAS_18_19_Resumos (zip)', '/note/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Resumos.zip', 40431, 1275, 3, 13, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1. O que é qu...pdf</dt><dd><dd></dl><dl><dt>2. Modelos de...pdf</dt><dd><dd></dl><dl><dt>3. Modelos no...pdf</dt><dd><dd></dl><dl><dt>MAA_Resumos.pdf</dt><dd><dd></dl><dl><dt>Post-it.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 10),
(121, 'Goncalo_MAS_18_19_Projeto (zip)', '/note/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Projeto.zip', 40431, 1275, 3, 13, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>AMS-E3-Visao ...docx</dt><dd><dd></dl><dl><dt>Apresentacion...pdf</dt><dd><dd></dl><dl><dt>Apresentaç?o ...odt</dt><dd><dd></dl><dl><dt>CalEntregas.png</dt><dd><dd></dl><dl><dt>Elaboration 1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Gui?o.pdf</dt><dd><dd></dl><dl><dt>Inception1</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>JMeter</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>MAS - Projeto...pdf</dt><dd><dd></dl><dl><dt>MicroSite</dt><dd><dd>24 pastas</dd><dd>20 ficheiros</dd><dd></dl><dl><dt>Projeto.zip</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 22),
(122, 'Goncalo_MAS_18_19_Praticas (zip)', '/note/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Praticas.zip', 40431, 1275, 3, 13, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Lab1</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>Lab2</dt><dd><dd>1 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Lab3</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>Lab5</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Lab6</dt><dd><dd>1 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>Lab7</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>MAS_Práticas-...zip</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 46),
(123, 'RafaelDireito_SMU_17_18_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Praticas.zip', 40432, 1800, 2, 15, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P</dt><dd><dd>11 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>12 pastas</dd><dd>12 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 40),
(124, 'RafaelDireito_SMU_17_18_TP (zip)', '/note/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_TP.zip', 40432, 1800, 2, 15, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>TP</dt><dd><dd>0 pastas</dd><dd>10 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 68),
(125, 'RafaelDireito_SMU_17_18_Prep2Test (zip)', '/note/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Prep2Teste.zip', 40432, 1800, 2, 15, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Prep2Teste</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 3),
(126, 'RafaelDireito_SMU_17_18_Bibliografia (zip)', '/note/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Bibliografia.zip', 40432, 1800, 2, 15, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bibliografia</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 54),
(127, 'DS_SMU_18_19_Fichas (zip)', '/note/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Fichas.zip', 40432, 1161, 3, 14, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>12 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>13 pastas</dd><dd>13 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 113),
(128, 'DS_SMU_18_19_Livros (zip)', '/note/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Livros.zip', 40432, 1161, 3, 14, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Livros</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 54),
(129, 'DS_SMU_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_SlidesTeoricos.zip', 40432, 1161, 3, 14, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Teoricos</dt><dd><dd>1 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>2 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 30),
(130, 'DS_SMU_18_19_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Praticas.zip', 40432, 1161, 3, 14, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Praticas</dt><dd><dd>19 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>20 pastas</dd><dd>20 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 26),
(131, 'DS_SMU_18_19_Resumos (zip)', '/note/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Resumos.zip', 40432, 1161, 3, 14, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 181),
(132, 'DS_SMU_18_19_Testes (zip)', '/note/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Testes.zip', 40432, 1161, 3, 14, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>8 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>9 pastas</dd><dd>9 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 60),
(133, 'DS_RS_18_19_Testes (zip)', '/note/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Testes.zip', 40433, 1161, 3, 16, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>16 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>17 pastas</dd><dd>17 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 130),
(134, 'DS_RS_18_19_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Praticas.zip', 40433, 1161, 3, 16, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Praticas</dt><dd><dd>2 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 2),
(135, 'DS_RS_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_SlidesTeoricos.zip', 40433, 1161, 3, 16, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Teoricos</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 10),
(136, 'DS_RS_18_19_Resumos (zip)', '/note/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Resumos.zip', 40433, 1161, 3, 16, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(137, 'DS_AED_18_19_Resumos (zip)', '/note/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Resumos.zip', 40437, 1161, 3, 11, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 271),
(138, 'DS_AED_18_19_Livros (zip)', '/note/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Livros.zip', 40437, 1161, 3, 11, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Livros</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 20),
(139, 'DS_AED_18_19_Testes (zip)', '/note/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Testes.zip', 40437, 1161, 3, 11, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>24 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>25 pastas</dd><dd>25 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 94),
(140, 'DS_AED_18_19_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Praticas.zip', 40437, 1161, 3, 11, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pr?Çáticas</dt><dd><dd>21 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>20 pastas</dd><dd>20 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 20),
(141, 'DS_AED_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_SlidesTeoricos.zip', 40437, 1161, 3, 11, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Te?óricos</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 2),
(142, 'DS_AED_18_19_Fichas (zip)', '/note/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Fichas.zip', 40437, 1161, 3, 11, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 16);
INSERT INTO aauav_nei.note (id, name, location, subject_id, author_id, school_year_id, teacher_id, summary, tests, bibliography, slides, exercises, projects, notebook, content, created_at, type_id, size) VALUES
(143, 'RafaelDireito_AED_17_18_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Praticas.zip', 40437, 1800, 2, 31, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P</dt><dd><dd>4 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>5 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(144, 'RafaelDireito_AED_17_18_Testes (zip)', '/note/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Testes.zip', 40437, 1800, 2, 31, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(145, 'RafaelDireito_AED_17_18_Books (zip)', '/note/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Praticas.zip', 40437, 1800, 2, 31, 0, 0, 1, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2, NULL),
(146, 'RafaelDireito_AED_17_18_LearningC (zip)', '/note/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_LearningC.zip', 40437, 1800, 2, 31, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>LearningC</dt><dd><dd>0 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(147, 'RafaelDireito_AED_17_18_AED (pdf)', '/note/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_AED.pdf', 40437, 1800, 2, 31, 0, 0, 0, 1, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(148, 'DS_Compiladores_18_19_Praticas (zip)', '/note/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Praticas.zip', 41469, 1161, 3, 10, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Praticas</dt><dd><dd>35 pastas</dd><dd>32 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>31 pastas</dd><dd>31 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(149, 'DS_Compiladores_18_19_Fichas (zip)', '/note/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Fichas.zip', 41469, 1161, 3, 10, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 42),
(150, 'DS_Compiladores_18_19_Testes (zip)', '/note/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Testes.zip', 41469, 1161, 3, 10, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 33),
(151, 'DS_Compiladores_18_19_Resumos (zip)', '/note/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Resumos.zip', 41469, 1161, 3, 10, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 242),
(152, 'DS_Compiladores_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_SlidesTeoricos.zip', 41469, 1161, 3, 10, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Te?óricos</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 4),
(153, 'DS_IHC_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_SlidesTeoricos.zip', 41549, 1161, 3, 9, 0, 0, 0, 1, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2, NULL),
(154, 'DS_IHC_18_19_Fichas (zip)', '/note/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_Fichas.zip', 41549, 1161, 3, 9, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>5 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>6 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 51),
(155, 'DS_IHC_18_19_Projetos (zip)', '/note/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_Projetos.zip', 41549, 1161, 3, 9, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>Projetos</dt><dd><dd>5 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>6 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 90),
(156, 'DS_IHC_18_19_Testes (zip)', '/note/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_SlidesTeoricos.zip', 41549, 1161, 3, 9, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2, NULL),
(157, 'Resumos (zip)', '/note/terceiro_ano/primeiro_semestre/ia/resumo.zip', 40846, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo.pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(158, 'DS_EF_17_18_Resumos (zip)', '/note/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Resumos.zip', 41791, 1161, 2, 24, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 4),
(159, 'DS_EF_17_18_Exercicios (zip)', '/note/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Exercicios.zip', 41791, 1161, 2, 24, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Exerci?ücios</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 3),
(160, 'DS_EF_17_18_Exames (zip)', '/note/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Exames.zip', 41791, 1161, 2, 24, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Exames</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 2),
(161, 'Exames (zip)', '/note/primeiro_ano/segundo_semestre/iac/exames.zip', 42502, NULL, NULL, 6, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>iac_apontamen...pdf</dt><dd><dd></dl><dl><dt>iac_apontamen...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(162, 'Goncalo_IAC_18_19_Praticas (zip)', '/note/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Praticas.zip', 42502, 1275, 3, 6, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pr?íticas</dt><dd><dd>113 pastas</dd><dd>111 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>113 pastas</dd><dd>113 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 44),
(163, 'Goncalo_IAC_18_19_Resumos (zip)', '/note/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Resumos.zip', 42502, 1275, 3, 6, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 17),
(164, 'Goncalo_IAC_18_19_Apontamentos (zip)', '/note/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Apontamentos.zip', 42502, 1275, 3, 6, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Apontamentos</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 3),
(165, 'Goncalo_IAC_18_19_Bibliografia (zip)', '/note/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Bibliografia.zip', 42502, 1275, 3, 6, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bibliografia ...pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Bibliografia ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 18),
(166, 'Goncalo_IAC_18_19_Testes (zip)', '/note/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Testes.zip', 42502, 1275, 3, 6, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 2),
(167, 'RafaelDireito_IAC_16_17_Testes (zip)', '/note/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Testes.zip', 42502, 1800, 4, 6, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 3),
(168, 'RafaelDireito_IAC_16_17_Teorica (zip)', '/note/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Teorica.zip', 42502, 1800, 4, 6, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Te?órica</dt><dd><dd>0 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 14),
(169, 'RafaelDireito_IAC_16_17_FolhasPraticas (zip)', '/note/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_FolhasPraticas.zip', 42502, 1800, 4, 6, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>FolhasPr?Çáticas</dt><dd><dd>0 pastas</dd><dd>16 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 13),
(170, 'RafaelDireito_IAC_16_17_ExerciciosResolvidos (zip)', '/note/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_ExerciciosResolvidos.zip', 42502, 1800, 4, 6, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>ExerciciosResolvidos</dt><dd><dd>6 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>7 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(171, 'RafaelDireito_IAC_16_17_Resumos (zip)', '/note/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Resumos.zip', 42502, 1800, 4, 6, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDireito...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 10),
(172, 'RafaelDireito_IAC_16_17_DossiePedagogicov2 (zip)', '/note/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_DossiePedagogicov2.zip', 42502, 1800, 4, 6, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>DossiePedagog...pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(173, 'DS_BD_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/segundo_semestre/bd/DS_BD_18_19_SlidesTeoricos.zip', 42532, 1161, 3, 7, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Te?óricos</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 30),
(174, 'DS_BD_18_19_Resumos (zip)', '/note/segundo_ano/segundo_semestre/bd/DS_BD_18_19_Resumos.zip', 42532, 1161, 3, 7, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>2 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 144),
(175, 'DS_BD_18_19_Praticas (zip)', '/note/segundo_ano/segundo_semestre/bd/DS_BD_18_19_Praticas.zip', 42532, 1161, 3, 7, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pr?Çáticas</dt><dd><dd>48 pastas</dd><dd>34 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>45 pastas</dd><dd>45 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 81),
(176, 'Resumos Diversos (zip)', '/note/segundo_ano/segundo_semestre/bd/Resumos.zip', 42532, NULL, NULL, NULL, 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(177, 'Resumos EF', '/note/primeiro_ano/primeiro_semestre/ef/CarolinaAlbuquerque_EF_Resumo.pdf', 41791, 1023, 5, 24, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 8),
(178, 'Resolução Fichas EF', '/note/primeiro_ano/primeiro_semestre/ef/CarolinaAlbuquerque_EF_ResolucoesFichas.zip', 41791, 1023, 5, 24, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>CarolinaAlbuq...</dt><dd><dd>6 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 169),
(179, 'Exames SIO resolvidos', '/note/terceiro_ano/primeiro_semestre/sio/JoaoAlegria_Exames.zip', 42573, 1455, 4, NULL, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_Exames</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 13),
(180, 'Resumos SIO', '/note/terceiro_ano/primeiro_semestre/sio/JoaoAlegria_Resumos.zip', 42573, 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_Resumos</dt><dd><dd>1 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 20),
(181, 'Exames e testes ALGA', '/note/primeiro_ano/primeiro_semestre/alga/Rafael_Direito_Exames.zip', 42709, 1800, 4, 23, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 9),
(182, 'Fichas resolvidas ALGA', '/note/primeiro_ano/primeiro_semestre/alga/RafaelDireito_Fichas.pdf', 42709, 1800, 4, 23, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 15),
(183, 'Resumos ALGA ', '/note/primeiro_ano/primeiro_semestre/alga/RafelDireito_Resumos.pdf', 42709, 1800, 4, 23, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 8),
(184, 'Caderno de cálculo', '/note/primeiro_ano/primeiro_semestre/c1/CarolinaAlbuquerque_C1_caderno.pdf', 42728, 1023, 5, 19, 0, 0, 0, 0, 0, 0, 1, NULL, '2021-06-14 19:17:30', 1, 11),
(185, 'Fichas resolvidas CII', '/note/primeiro_ano/segundo_semestre/c2/PedroOliveira_Fichas.zip', 42729, 1764, 3, 19, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Ficha1</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>Ficha2</dt><dd><dd>0 pastas</dd><dd>15 ficheiros</dd><dd></dl><dl><dt>Ficha3</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>ficha3-part2.pdf</dt><dd><dd></dl><dl><dt>ficha3.pdf</dt><dd><dd></dl><dl><dt>Ficha4_000001.pdf</dt><dd><dd></dl><dl><dt>Ficha5_000001.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 110),
(186, 'Testes CII', '/note/primeiro_ano/segundo_semestre/c2/PedroOliveira_testes-resol.zip', 42729, 1764, 3, 19, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>testes-resol</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 24),
(187, 'Apontamentos Gerais ICM', '/note/terceiro_ano/primeiro_semestre/icm/Resumo Geral Android.pdf', 45424, 1335, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 3),
(188, 'Resoluções material apoio MD', '/note/primeiro_ano/segundo_semestre/md/PedroOliveira_EA.zip', 47166, 1764, 3, 20, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>EA(livro nos ...</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>EA1</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>EA1(refeito)</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>EA2(Completo)</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>EA2.pdf</dt><dd><dd></dl><dl><dt>EA2ex4.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 45),
(189, 'Resoluções fichas MD', '/note/primeiro_ano/segundo_semestre/md/PedroOliveira_Fichas.zip', 47166, 1764, 3, 20, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Ficha1</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>ficha2.pdf</dt><dd><dd></dl><dl><dt>ficha3_000001.pdf</dt><dd><dd></dl><dl><dt>ficha4_000001.pdf</dt><dd><dd></dl><dl><dt>ficha5-cont.pdf</dt><dd><dd></dl><dl><dt>ficha5.pdf</dt><dd><dd></dl><dl><dt>Ficha6.pdf</dt><dd><dd></dl><dl><dt>ficha7(incomp...pdf</dt><dd><dd></dl><dl><dt>Ficha8_000001.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 79),
(190, 'Resoluções testes MD', '/note/primeiro_ano/segundo_semestre/md/PedroOliveira_testes.zip', 47166, 1764, 3, 20, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>testes</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 33),
(191, 'Estudo para o exame', '/note/segundo_ano/primeiro_semestre/rs/RafaelDireito_2017_RSexame.pdf', 40433, 1800, 2, 4, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 6),
(192, 'Exercícios TPW', '/note/terceiro_ano/segundo_semestre/tpw/Exercicios.zip', 40551, NULL, NULL, NULL, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Exercicios</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 14),
(193, 'Resumos 2016/2017', '/note/mestrado/as/as_apontamentos_001.pdf', 40757, 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(194, 'Resumos por capítulo (zip)', '/note/mestrado/as/JoaoAlegria_ResumosPorCapitulo.zip', 40757, 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2, 2),
(195, 'Exercícios IA', '/note/terceiro_ano/primeiro_semestre/ia/Inês_Correia_IA_exercícios.pdf', 40846, 1335, NULL, NULL, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 7),
(196, 'Resumos IA', '/note/terceiro_ano/primeiro_semestre/ia/Inês_Correia_IA_resumo.pdf', 40846, 1335, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 9),
(197, 'Caderno MD Cap. 6 e 7', '/note/primeiro_ano/segundo_semestre/md/MarianaRosa_Caderno_Capts6e7.pdf', 47166, 2051, 7, 32, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, '2021-06-16 22:18:59', 1, 20),
(198, 'Resumos 1.ª Parte MD', '/note/primeiro_ano/segundo_semestre/md/MarianaRosa_Resumos_1aParte.pdf', 47166, 2051, 7, 32, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:21:33', 1, 13),
(199, 'Práticas BD', '/note/segundo_ano/segundo_semestre/bd/Goncalo_Praticas.zip', 42532, 1275, 7, 8, NULL, NULL, NULL, NULL, 1, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>P</dt><dd><dd>11 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:27:12', 2, 23),
(200, 'Resumos BD', '/note/segundo_ano/segundo_semestre/bd/Goncalo_Resumos.zip', 42532, 1275, 7, 7, 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>TP</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:28:20', 2, 20),
(201, 'Resumos Caps. 3 e 4', '/note/segundo_ano/segundo_semestre/c/Goncalo_TP.zip', 41469, 1275, 7, 10, 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>TP</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 8),
(202, 'Resumos ANTLR4', '/note/segundo_ano/segundo_semestre/c/Goncalo_ANTLR4.zip', 41469, 1275, 7, 10, 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>ANTLR4 Listeners.pdf</dt><dd><dd></dl><dl><dt>ANTLR4 Visitors.pdf</dt><dd><dd></dl><dl><dt>ANTLR4.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 1),
(203, 'Guiões P Resolvidos', '/note/segundo_ano/segundo_semestre/c/Goncalo_GuioesPraticos.zip', 41469, 1275, 7, 10, NULL, NULL, NULL, NULL, 1, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>P1_20fev2020</dt><dd><dd>1 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>P2_05fev2020</dt><dd><dd>35 pastas</dd><dd>37 ficheiros</dd><dd></dl><dl><dt>P3</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 2),
(204, 'Resumos Práticos', '/note/segundo_ano/segundo_semestre/c/Goncalo_ResumosPraticos.zip', 41469, 1275, 7, 10, 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>1_Compiladores.pdf</dt><dd><dd></dl><dl><dt>2_ANTLR4.pdf</dt><dd><dd></dl><dl><dt>3_Análise sem...pdf</dt><dd><dd></dl><dl><dt>5_Análise sem...pdf</dt><dd><dd></dl><dl><dt>6_Geração de ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 17),
(205, 'Bibliografia', '/note/segundo_ano/segundo_semestre/cd/Bibliografia.zip', 40382, 1275, 7, 2, NULL, NULL, 1, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>mvsteen-distr...pdf</dt><dd><dd></dl><dl><dt>ResolucaoPerg...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 39),
(206, 'Cheatsheet', '/note/segundo_ano/segundo_semestre/cd/Goncalo_CheatSheet.pdf', 40382, 1275, 7, 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 1, 1),
(207, 'Aulas Resolvidas', '/note/segundo_ano/segundo_semestre/cd/Goncalo_Aulas.zip', 40382, 1275, 7, 2, NULL, NULL, NULL, NULL, 1, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>P1_11Fev2020</dt><dd><dd>138 pastas</dd><dd>140 ficheiros</dd><dd></dl><dl><dt>P2_10Fev2020</dt><dd><dd>125 pastas</dd><dd>128 ficheiros</dd><dd></dl><dl><dt>P3_28Abr2020</dt><dd><dd>103 pastas</dd><dd>104 ficheiros</dd><dd></dl><dl><dt>P4_19Mai2020</dt><dd><dd>183 pastas</dd><dd>183 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 8),
(208, 'Projeto1', '/note/segundo_ano/segundo_semestre/cd/Goncalo_Projeto1.zip', 40382, 1275, 7, 2, NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>message-broke...</dt><dd><dd>260 pastas</dd><dd>268 ficheiros</dd><dd></dl><dl><dt>Projecto 1 - ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 3),
(209, 'Projeto2', '/note/segundo_ano/segundo_semestre/cd/Goncalo_Projeto2.zip', 40382, 1275, 7, 2, NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>distributed-o...</dt><dd><dd>7 pastas</dd><dd>22 ficheiros</dd><dd></dl><dl><dt>Projecto 2 - ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 15),
(210, 'Resumos Teóricos', '/note/segundo_ano/segundo_semestre/cd/Goncalo_TP.pdf', 40382, 1275, 7, 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 1, 6),
(211, 'Paper \Help, I am stuck...\', '/note/segundo_ano/segundo_semestre/ihc/Goncalo_Francisca_Paper.zip', 41549, 1275, 7, 9, NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>92972_93102_[...pdf</dt><dd><dd></dl><dl><dt>IHC_Paper.pdf</dt><dd><dd></dl><dl><dt>Paper-selecti...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 2),
(212, 'Resumos (incompletos)', '/note/segundo_ano/segundo_semestre/ihc/Goncalo_TP.pdf', 41549, 1275, 7, 9, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 1, 1),
(213, 'Perguntitas de preparação exame', '/note/segundo_ano/segundo_semestre/ihc/Perguntitaspreparaçaoexame.zip', 41549, 1275, 7, 9, NULL, 1, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>(1) User prof...pdf</dt><dd><dd></dl><dl><dt>(2) User ... ...pdf</dt><dd><dd></dl><dl><dt>(3) User mode...pdf</dt><dd><dd></dl><dl><dt>(4) Input & O...pdf</dt><dd><dd></dl><dl><dt>(5) Usability...pdf</dt><dd><dd></dl><dl><dt>exam.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 1),
(214, 'Resumos teóricos', '/note/segundo_ano/segundo_semestre/pds/Goncalo_TP.pdf', 40383, 1275, 7, 12, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 1, 11),
(215, 'Projeto final: Padrões Bridge e Flyweight e Refactoring', '/note/segundo_ano/segundo_semestre/pds/Goncalo_Projeto.zip', 40383, 1275, 7, 12, NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>Entrega</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 74),
(216, 'Aulas P Resolvidas', '/note/segundo_ano/segundo_semestre/pds/Goncalo_Aulas.zip', 40383, 1275, 7, 12, NULL, NULL, NULL, NULL, 1, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>P1_11fev2020</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P2_03mar2020</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P3_10mar2020</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P4_17mar2020</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>P5_24mar2020</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P6_31mar2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P7_14abr2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P8_21abr2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P9_28abr2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P10_05mai2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P11_19mai29020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P12_26mai2020</dt><dd><dd>0 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>P13_02jun2020</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>pds_2020_g205</dt><dd><dd>482 pastas</dd><dd>481 ficheiros</dd><dd></dl><dl><dt>Readme.txt</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 38),
(217, 'Exame final', '/note/segundo_ano/segundo_semestre/pds/Goncalo_Exame.zip', 40383, 1275, 7, 12, NULL, 1, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>92972</dt><dd><dd>0 pastas</dd><dd>16 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 1),
(218, 'Bibliografia', '/note/segundo_ano/segundo_semestre/pds/Bibliografia.zip', 40383, 1275, 7, 12, NULL, NULL, 1, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>applying-uml-...pdf</dt><dd><dd></dl><dl><dt>DesignPatterns.pdf</dt><dd><dd></dl><dl><dt>kupdf.net_use...pdf</dt><dd><dd></dl><dl><dt>software-arch...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 159),
(220, 'Projeto final \Show tracker\', 'https://github.com/gmatosferreira/show-tracker-app', 41549, 1275, 7, 9, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, '2021-10-18 15:00:00', 3, NULL),
(232, 'AI: A Modern Approach', '/note/terceiro_ano/primeiro_semestre/ia/artificial-intelligence-modern-approach.9780131038059.25368.pdf', 40846, NULL, 8, 30, 0, 0, 1, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 38),
(238, 'Resumos', '/note/terceiro_ano/primeiro_semestre/ia/Goncalo_IA_TP.pdf', 40846, 1275, 8, 30, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 3),
(241, 'Notas código práticas', '/note/terceiro_ano/primeiro_semestre/ia/Goncalo_Código_Anotado_Práticas.zip', 40846, 1275, 8, 2, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>BayesNet.pdf</dt><dd><dd></dl><dl><dt>ConstraintSearch.pdf</dt><dd><dd></dl><dl><dt>SearchTree.pdf</dt><dd><dd></dl><dl><dt>SemanticNetwork.pdf</dt><dd><dd></dl><dl><dt>Strips.pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 4),
(244, 'Código práticas', '/note/terceiro_ano/primeiro_semestre/ia/Goncalo_Praticas.zip', 40846, 1275, 8, 2, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>guiao-de-prog...</dt><dd><dd>6 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>guiao-rc-gmat...</dt><dd><dd>6 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>guiao-sobre-p...</dt><dd><dd>6 pastas</dd><dd>15 ficheiros</dd><dd></dl><dl><dt>ia-iia-tpi-1-...</dt><dd><dd>4 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>ia-iia-tpi2-g...</dt><dd><dd>1 pastas</dd><dd>10 ficheiros</dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 2),
(247, 'Resumos', '/note/terceiro_ano/primeiro_semestre/ge/Goncalo_GE_TP.pdf', 2450, 1275, 8, 34, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 2),
(250, 'Post-its', '/note/terceiro_ano/primeiro_semestre/ge/Goncalo_Postits.zip', 2450, 1275, 8, 34, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_Introduçao ...pdf</dt><dd><dd></dl><dl><dt>2_Modelo de n...pdf</dt><dd><dd></dl><dl><dt>3_Modelo de n...pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 11),
(253, 'Post-its', '/note/terceiro_ano/primeiro_semestre/ies/Goncalo_Postits.zip', 40384, 1275, 8, 12, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_IES.pdf</dt><dd><dd></dl><dl><dt>2_Processo so...pdf</dt><dd><dd></dl><dl><dt>3_Desenvolvim...pdf</dt><dd><dd></dl><dl><dt>4_Devops.pdf</dt><dd><dd></dl><dl><dt>5_Padroes arq...pdf</dt><dd><dd></dl><dl><dt>6_Web framewo...pdf</dt><dd><dd></dl><dl><dt>8_Spring fram...pdf</dt><dd><dd></dl><dl><dt>9_Spring boot.pdf</dt><dd><dd></dl><dl><dt>10_Microserviços.pdf</dt><dd><dd></dl><dl><dt>11_Sistemas b...pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 12),
(256, 'Aulas práticas', '/note/terceiro_ano/primeiro_semestre/ies/Goncalo_Práticas.zip', 40384, 1275, 8, 12, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Lab1_92972.zip</dt><dd><dd></dl><dl><dt>Lab2_92972.zip</dt><dd><dd></dl><dl><dt>Lab3_92972.zip</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 3),
(259, 'Resumos', '/note/terceiro_ano/primeiro_semestre/ies/Goncalo_IES_TP.pdf', 40384, 1275, 8, 12, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 5),
(262, 'Projeto final \Store Go\', 'https://github.com/gmatosferreira/IES_Project_G31', 40384, 1275, 8, 12, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', 3, NULL),
(265, 'Resumos', '/note/terceiro_ano/primeiro_semestre/sio/Goncalo_SIO_TP.pdf', 42573, 1275, 8, 3, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 4),
(268, 'Tópicos exame', '/note/terceiro_ano/primeiro_semestre/sio/Goncalo_Tópicos_exame.pdf', 42573, 1275, 8, 3, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 2),
(271, 'Security in Computing', '/note/terceiro_ano/primeiro_semestre/sio/security-in-computing-5-e.pdf', 42573, NULL, 8, 3, 0, 0, 1, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 18),
(274, 'Projeto 1 \Exploração de vulnerabilidades\', '/note/terceiro_ano/primeiro_semestre/sio/Goncalo_[SIO][Projeto 1]_Relatório.pdf', 42573, 1275, 8, 3, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', 1, 1),
(277, 'Projeto 4 \Forensics\', '/note/terceiro_ano/primeiro_semestre/sio/Goncalo_[SIO][Projeto 4]_Relatório.pdf', 42573, 1275, 8, 3, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', 1, 1),
(280, 'Projeto 2 \Secure Media Player\', 'https://github.com/gmatosferreira/securemediaplayer', 42573, 1275, 8, 3, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', 3, NULL),
(283, 'Resumos', '/note/terceiro_ano/primeiro_semestre/cbd/Goncalo_CBD_TP.pdf', 40385, 1275, 8, 12, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 3),
(286, 'Post-its', '/note/terceiro_ano/primeiro_semestre/cbd/Goncalo_Postits.zip', 40385, 1275, 8, 12, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_Foco nos dados.pdf</dt><dd><dd></dl><dl><dt>2_Modelos de ...pdf</dt><dd><dd></dl><dl><dt>3_Armazenamen...pdf</dt><dd><dd></dl><dl><dt>4_Formatos do...pdf</dt><dd><dd></dl><dl><dt>5 a 8_Tipos b...pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 6),
(289, 'Práticas', '/note/terceiro_ano/primeiro_semestre/cbd/Goncalo_Praticas.zip', 40385, 1275, 8, 12, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Lab-1_92972.zip</dt><dd><dd></dl><dl><dt>Lab2_92972.zip</dt><dd><dd></dl><dl><dt>92972_Lab3.zip</dt><dd><dd></dl><dl><dt>92972_Lab4.zip</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 4),
(292, 'Designing Data Intensive Applications', '/note/terceiro_ano/primeiro_semestre/cbd/Designing Data Intensive Applications.pdf', 40385, NULL, 8, 12, 0, 0, 1, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 25),
(298, 'Projeto 2 \Secure Media Player\', 'https://github.com/margaridasmartins/digital-rights-management', 42573, 1602, 8, 3, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-11-15 19:17:30', 3, NULL),
(304, 'Práticas POO', 'https://github.com/Rui-FMF/POO', 40436, 1821, 3, 28, 0, 1, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', 3, NULL),
(307, 'Práticas FP', 'https://github.com/Rui-FMF/FP', 40379, 1821, 3, 27, 0, 0, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', 3, NULL),
(313, 'Práticas IAC', 'https://github.com/Rui-FMF/IAC', 42502, 1821, 3, 6, 0, 0, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', 3, NULL),
(319, 'Projeto RS', 'https://github.com/Rui-FMF/RS', 40433, 1821, 7, 16, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(322, 'Práticas e projeto MPEI', 'https://github.com/Rui-FMF/MPEI', 40337, 1821, 7, 28, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(325, 'Projetos AED', 'https://github.com/Rui-FMF/AED', 40437, 1821, 7, 11, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(328, 'Projetos SO', 'https://github.com/Rui-FMF/SO', 40381, 1821, 7, 1, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(331, 'Guiões e Exame P, Projeto T', 'https://github.com/Rui-FMF/PDS', 40383, 1821, 7, 12, 0, 1, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(334, 'Práticas e Projetos CD', 'https://github.com/Rui-FMF/CD', 40382, 1821, 7, 2, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(337, 'Projeto 1 TAA', 'https://github.com/Rui-FMF/TAA_1', 12832, 1821, 8, 40, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(340, 'Projetos e artigo IHC', 'https://github.com/Rui-FMF/IHC', 41549, 1821, 7, 9, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(343, 'Guiões P e Homework TQS', 'https://github.com/Rui-FMF/TQS', 45426, 1821, 8, 13, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(346, 'Práticas e projeto C', 'https://github.com/Rui-FMF/C', 41469, 1821, 7, 10, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(349, 'Labs CBD', 'https://github.com/Rui-FMF/CBD', 40385, 1821, 8, 12, 0, 0, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', 3, NULL),
(352, 'Guiões, TPI e Projeto de IA', 'https://github.com/Rui-FMF/IA', 40846, 1821, 8, 2, 0, 1, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(355, 'Labs e projeto de IES', 'https://github.com/Rui-FMF/IES', 40384, 1821, 8, 12, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(358, 'Projetos SIO', 'https://github.com/Rui-FMF/SIO', 42573, 1821, 8, 3, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(361, 'Projetos TPW', 'https://github.com/Rui-FMF/TPW', 40551, 1821, 8, 25, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(364, 'Projeto de IES', 'https://github.com/margaridasmartins/IES_Project', 40384, 1602, 8, 12, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(367, 'Guiões P e Homework TQS', 'https://github.com/margaridasmartins/TQSLabs', 45426, 1602, 8, 13, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(370, 'Programas MSF', '/note/primeiro_ano/segundo_semestre/msf/20_21_Artur_Programas.zip', 14817, 2125, 8, 29, 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', 2, NULL),
(373, 'Exercícios resolvidos MSF', '/note/primeiro_ano/segundo_semestre/msf/20_21_Artur_ExsResolvidos.zip', 14817, 2125, 8, 29, 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', 2, NULL),
(376, 'Exercícios MSF', '/note/primeiro_ano/segundo_semestre/msf/20_21_Artur_Exercicios.zip', 14817, 2125, 8, 29, 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', 2, NULL),
(379, 'Guiões práticos MSF', '/note/primeiro_ano/segundo_semestre/msf/20_21_Artur_Ps.zip', 14817, 2125, 8, 29, 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', 2, NULL),
(382, 'Slides teóricos MSF', '/note/primeiro_ano/segundo_semestre/msf/20_21_Artur_TPs.zip', 14817, 2125, 8, 29, 0, 0, 0, 1, 0, 0, 0, NULL, '2022-01-31 20:37:14', 2, NULL),
(385, 'Formulário MSF', '/note/primeiro_ano/segundo_semestre/msf/20_21_Artur_Form.pdf', 14817, 2125, 8, 29, 1, 0, 0, 0, 0, 0, 0, NULL, '2022-01-31 20:37:14', 1, NULL);


--
-- Data for Name: note_school_year; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.note_school_year (id, year_begin, year_end) VALUES
(1, 2014, 2015),
(2, 2017, 2018),
(3, 2018, 2019),
(4, 2016, 2017),
(5, 2015, 2016),
(6, 2013, 2014),
(7, 2019, 2020),
(8, 2020, 2021);


--
-- Data for Name: note_subject; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.note_subject (paco_code, name, year, semester, short, discontinued, optional) VALUES
(2373, 'Empreendedorismo', 3, 3, 'E', 0, 1),
(2450, 'Gestão de Empresas', 3, 3, 'GE', 0, 0),
(9270, 'Arquitectura e Gestão de Redes', 3, 3, 'AGR', 0, 1),
(12271, 'Aspetos Profissionais e Sociais da Engenharia Informática', 3, 3, 'APSEI', 0, 0),
(12830, 'Complementos Sobre Linguagens de Programação', 3, 3, 'CSLP', 0, 1),
(12832, 'Tópicos de Aprendizagem Automática', 3, 2, 'TAA', 0, 0),
(14817, 'Modelação de Sistemas Físicos', 1, 1, 'MSF', 0, 0),
(40337, 'Métodos Probabilísticos para Engenharia Informática', 2, 1, 'MPEI', 0, 0),
(40379, 'Fundamentos de Programação', 1, 1, 'FP', 0, 0),
(40380, 'Introdução às Tecnologias Web', 1, 1, 'ITW', 0, 0),
(40381, 'Sistemas Operativos', 2, 1, 'SO', 0, 0),
(40382, 'Computação Distribuída', 2, 2, 'CD', 0, 0),
(40383, 'Padrões e Desenho de Software', 2, 2, 'PDS', 0, 0),
(40384, 'Introdução à Engenharia de Software', 3, 1, 'IES', 0, 0),
(40385, 'Complementos de Bases de Dados', 3, 1, 'CBD', 0, 0),
(40431, 'Modelação e Análise de Sistemas', 1, 2, 'MAS', 0, 0),
(40432, 'Sistemas Multimédia', 2, 1, 'SM', 0, 0),
(40433, 'Redes e Serviços', 2, 1, 'RS', 0, 0),
(40436, 'Programação Orientada a Objetos', 1, 2, 'POO', 0, 0),
(40437, 'Algoritmos e Estruturas de Dados', 2, 1, 'AED', 0, 0),
(40551, 'Tecnologias e Programação Web', 3, 3, 'TPW', 0, 0),
(40751, 'Algoritmos Avançados', 4, 1, 'AA', 0, 0),
(40752, 'Teoria Algorítmica da Informação', 4, 1, 'TAI', 0, 0),
(40753, 'Computação em Larga Escala', 4, 2, 'CLE', 0, 0),
(40756, 'Gestão de Infraestruturas de Computação', 4, 2, 'GIC', 0, 0),
(40757, 'Arquiteturas de Software', 4, 2, 'AS', 0, 0),
(40846, 'Inteligência Artificial', 3, 1, 'IA', 0, 0),
(41469, 'Compiladores', 2, 2, 'C', 0, 0),
(41549, 'Interação Humano-Computador', 2, 2, 'IHC', 0, 0),
(41791, 'Elementos de Fisíca', 1, 1, 'EF', 1, 0),
(42502, 'Introdução à Arquitetura de Computadores', 1, 2, 'IAC', 0, 0),
(42532, 'Bases de Dados', 2, 2, 'BD', 0, 0),
(42573, 'Segurança Informática e Nas Organizações', 3, 1, 'SIO', 0, 0),
(42709, 'Álgebra Linear e Geometria Analítica', 1, 1, 'ALGA', 0, 0),
(42728, 'Cálculo I', 1, 1, 'C1', 0, 0),
(42729, 'Cálculo II', 1, 2, 'C2', 0, 0),
(44156, 'Visualização de Informação', 4, 1, 'VI', 0, 0),
(44158, 'Web Semântica', 4, 2, 'WS', 0, 0),
(45424, 'Introdução à Computação Móvel', 3, 3, 'ICM', 0, 0),
(45426, 'Teste e Qualidade de Software', 3, 2, 'TQS', 0, 0),
(45587, 'Exploração de Dados', 4, 1, 'ED', 0, 0),
(47166, 'Matemática Discreta', 1, 2, 'MD', 0, 0);


--
-- Data for Name: note_teacher; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.note_teacher (id, name, personal_page) VALUES
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
-- Data for Name: note_thank; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.note_thank (id, author_id, note_personal_page) VALUES
(1, 1161, 'https://resumosdeinformatica.netlify.app/');


--
-- Data for Name: note_types; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.note_type (id, name, download_caption, icon_display, icon_download, external) VALUES
(1, 'PDF NEI', 'Descarregar', 'fas file-pdf', 'fas cloud-download-alt', 0),
(2, 'ZIP NEI', 'Descarregar', 'fas folder', 'fas cloud-download-alt', 0),
(3, 'Repositório', 'Repositório', 'fab github', 'fab github', 1),
(4, 'Google Drive', 'Google Drive', 'fab google-drive', 'fab google-drive', 1);


--
-- Data for Name: partner; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.partner (id, header, company, description, content, link, banner_url, banner_image, banner_until) VALUES
(1, '/partner/LavandariaFrame.jpg', 'Lavandaria Portuguesa', 'A Lavandaria Portuguesa encontra-se aliada ao NEI desde março de 2018, ajudando o núcleo na área desportiva com lavagens de equipamentos dos atletas que representam o curso.', NULL, 'https://www.facebook.com/alavandariaportuguesa.pt/', NULL, NULL, NULL),
(2, '/partner/OlisipoFrame.jpg', 'Olisipo', 'Fundada em 1994, a Olisipo é a única empresa portuguesa com mais de 25 anos de experiência dedicada à Gestão de Profissionais na área das Tecnologias de Informação.\n\nSomos gestores de carreira de mais de 500 profissionais de TI e temos Talent Managers capazes de influenciar o sucesso da carreira dos nossos colaboradores e potenciar o crescimento dos nossos clientes.\n\nVem conhecer um Great Place to Work® e uma das 30 melhores empresas para trabalhar em Portugal.', NULL, 'https://bit.ly/3KVT8zs', 'https://bit.ly/3KVT8zs', '/partner/banners/Olisipo.png', '2023-01-31 23:59:59');


--
-- Data for Name: redirect; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.redirect (id, alias, redirect) VALUES
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
-- Data for Name: rgm; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.rgm (id, category, mandate, file) VALUES
(1, 'RAC', 2013, '/rgm/RAC/2013/RAC_NESI2013.pdf'),
(2, 'RAC', 2014, '/rgm/RAC/2014/RAC_NEI2014.pdf'),
(3, 'RAC', 2015, '/rgm/RAC/2015/RAC_NEI2015.pdf'),
(4, 'RAC', 2016, '/rgm/RAC/2016/RAC_NEI2016.pdf'),
(5, 'RAC', 2017, '/rgm/RAC/2017/RAC_NEI2017.pdf'),
(6, 'RAC', 2018, '/rgm/RAC/2018/RAC_NEI2018.pdf'),
(7, 'RAC', 2019, '/rgm/RAC/2019/RAC_NEI2019.pdf'),
(8, 'PAO', 2013, '/rgm/PAO/2013/PAO_NESI2013.pdf'),
(9, 'PAO', 2014, '/rgm/PAO/2014/PAO_NESI2014.pdf'),
(10, 'PAO', 2015, '/rgm/PAO/2015/PAO_NEI2015.pdf'),
(11, 'PAO', 2016, '/rgm/PAO/2016/PAO_NEI2016.pdf'),
(12, 'PAO', 2017, '/rgm/PAO/2017/PAO_NEI2017.pdf'),
(13, 'PAO', 2018, '/rgm/PAO/2018/PAO_NEI2018.pdf'),
(14, 'PAO', 2019, '/rgm/PAO/2019/PAO_NEI2019.pdf'),
(15, 'PAO', 2020, '/rgm/PAO/2020/PAO_NEI2020.pdf'),
(16, 'ATAS', 2013, '/rgm/ATAS/2013/5.pdf'),
(17, 'ATAS', 2013, '/rgm/ATAS/2013/3.pdf'),
(18, 'ATAS', 2013, '/rgm/ATAS/2013/1.pdf'),
(19, 'ATAS', 2013, '/rgm/ATAS/2013/4.pdf'),
(20, 'ATAS', 2013, '/rgm/ATAS/2013/2.pdf'),
(21, 'ATAS', 2014, '/rgm/ATAS/2014/2.pdf'),
(22, 'ATAS', 2014, '/rgm/ATAS/2014/4.pdf'),
(23, 'ATAS', 2014, '/rgm/ATAS/2014/3.pdf'),
(24, 'ATAS', 2014, '/rgm/ATAS/2014/1.pdf'),
(25, 'ATAS', 2014, '/rgm/ATAS/2014/5.pdf'),
(26, 'ATAS', 2015, '/rgm/ATAS/2015/2.pdf'),
(27, 'ATAS', 2015, '/rgm/ATAS/2015/3.pdf'),
(28, 'ATAS', 2015, '/rgm/ATAS/2015/1.pdf'),
(29, 'ATAS', 2016, '/rgm/ATAS/2016/2.pdf'),
(30, 'ATAS', 2016, '/rgm/ATAS/2016/1.pdf'),
(31, 'ATAS', 2017, '/rgm/ATAS/2017/3.pdf'),
(32, 'ATAS', 2017, '/rgm/ATAS/2017/2.pdf'),
(33, 'ATAS', 2017, '/rgm/ATAS/2017/1.pdf'),
(34, 'ATAS', 2018, '/rgm/ATAS/2018/4.pdf'),
(35, 'ATAS', 2018, '/rgm/ATAS/2018/2.pdf'),
(36, 'ATAS', 2018, '/rgm/ATAS/2018/1.pdf'),
(37, 'ATAS', 2018, '/rgm/ATAS/2018/3.pdf'),
(38, 'ATAS', 2019, '/rgm/ATAS/2019/1.pdf'),
(39, 'ATAS', 2019, '/rgm/ATAS/2019/2.pdf'),
(40, 'ATAS', 2019, '/rgm/ATAS/2019/3.pdf'),
(41, 'ATAS', 2019, '/rgm/ATAS/2019/4.pdf'),
(42, 'ATAS', 2020, '/rgm/ATAS/2020/1.pdf'),
(43, 'RAC', 2020, '/rgm/RAC/2020/RAC_NEI2020.pdf'),
(44, 'ATAS', 2020, '/rgm/ATAS/2020/2.pdf'),
(45, 'PAO', 2021, '/rgm/PAO/2021/PAO_NEI2021.pdf'),
(46, 'ATAS', 2021, '/rgm/ATAS/2021/1.pdf'),
(47, 'RAC', 2021, '/rgm/RAC/2021/RAC_NEI2021.pdf'),
(48, 'ATAS', 2021, '/rgm/ATAS/2021/2.pdf'),
(49, 'PAO', 2022, '/rgm/PAO/2022/PAO_NEI2022.pdf'),
(50, 'ATAS', 2022, '/rgm/ATAS/2022/1.pdf'),
(51, 'ATAS', 2022, '/rgm/ATAS/2022/2.pdf'),
(52, 'PAO', 2022, '/rgm/PAO/2022/PAO_NEI2022-23.pdf'),
(53, 'RAC', 2022, '/rgm/RAC/2022/RAC_NEI2022.pdf');


--
-- Data for Name: senior; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.senior (id, year, course, image) VALUES
(1, 2020, 'LEI', '/senior/lei/2020_3.jpg'),
(2, 2020, 'MEI', '/senior/mei/2020.jpg'),
(3, 2021, 'LEI', NULL),
(4, 2021, 'MEI', NULL);


--
-- Data for Name: senior_student; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.senior_student (senior_id, user_id, quote, image) VALUES
(1, 873, NULL, NULL),
(1, 879, NULL, NULL),
(1, 897, NULL, NULL),
(1, 900, NULL, NULL),
(1, 927, NULL, NULL),
(1, 999, NULL, NULL),
(1, 1002, NULL, NULL),
(1, 1137, NULL, NULL),
(1, 1161, NULL, NULL),
(1, 1245, NULL, NULL),
(1, 1266, NULL, NULL),
(1, 1362, NULL, NULL),
(1, 1425, NULL, NULL),
(1, 1476, NULL, NULL),
(1, 1545, NULL, NULL),
(1, 1647, NULL, NULL),
(1, 1764, NULL, NULL),
(1, 1938, NULL, NULL),
(1, 1995, NULL, NULL),
(1, 2130, NULL, NULL),
(2, 1059, NULL, '/senior/mei/2020/1059.jpg'),
(2, 2131, NULL, '/senior/mei/2020/2131.jpg'),
(3, 1020, 'Level up', '/senior/lei/2021/1020.jpg'),
(3, 1164, 'Mal posso esperar para ver o que se segue', '/senior/lei/2021/1164.jpg'),
(3, 1200, 'Já dizia a minha avó: \O meu neto não bebe álcool\', '/senior/lei/2021/1200.jpg'),
(3, 1275, NULL, '/senior/lei/2021/1275.jpg'),
(3, 1329, NULL, '/senior/lei/2021/1329.jpg'),
(3, 1461, 'Simplesmente viciado em café e futebol', '/senior/lei/2021/1461.jpg'),
(3, 1602, 'MD é fixe.', '/senior/lei/2021/1602.jpg'),
(3, 1716, 'Há tempo para tudo na vida académica!', '/senior/lei/2021/1716.jpg'),
(3, 1827, 'Melhorias = Mito', '/senior/lei/2021/1827.jpg'),
(4, 1023, '<h1>Fun fact: #EAAA00</h1>', '/senior/mei/2021/1023.jpg');


--
-- Data for Name: team; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.team (id, header, mandate, user_id, role_id) VALUES
(3, '/team/2019/1.jpg', 2019, 1452, 1),
(6, '/team/2019/2.jpg', 2019, 1866, 4),
(9, '/team/2019/3.jpg', 2019, 1362, 17),
(12, '/team/2019/4.jpg', 2019, 1245, 18),
(15, '/team/2019/5.jpg', 2019, 1938, 18),
(18, '/team/2019/6.jpg', 2019, 1626, 7),
(21, '/team/2019/7.jpg', 2019, 1806, 7),
(24, '/team/2019/8.jpg', 2019, 1524, 7),
(27, '/team/2019/9.jpg', 2019, 1329, 15),
(30, '/team/2019/10.jpg', 2019, 1995, 15),
(33, '/team/2019/11.jpg', 2019, 1053, 15),
(36, '/team/2019/12.jpg', 2019, 1638, 3),
(39, '/team/2019/13.jpg', 2019, 1101, 2),
(42, '/team/2019/14.jpg', 2019, 1602, 5),
(45, '/team/2018/1.jpg', 2018, 1452, 1),
(48, '/team/2018/2.jpg', 2018, 1866, 4),
(51, '/team/2018/3.jpg', 2018, 1806, 17),
(54, '/team/2018/4.jpg', 2018, 1947, 17),
(57, '/team/2018/5.jpg', 2018, 1059, 18),
(60, '/team/2018/6.jpg', 2018, 1023, 18),
(63, '/team/2018/7.jpg', 2018, 1410, 7),
(66, '/team/2018/8.jpg', 2018, 1524, 7),
(69, '/team/2018/9.jpg', 2018, 1989, 15),
(72, '/team/2018/10.jpg', 2018, 1800, 15),
(75, '/team/2018/11.jpg', 2018, 1788, 15),
(78, '/team/2018/12.jpg', 2018, 1638, 3),
(81, '/team/2018/13.jpg', 2018, 1317, 2),
(84, '/team/2018/14.jpg', 2018, 1626, 5),
(87, '/team/2017/1.jpg', 2017, 1335, 1),
(90, '/team/2017/2.jpg', 2017, 1317, 4),
(93, '/team/2017/3.jpg', 2017, 1107, 17),
(96, '/team/2017/4.jpg', 2017, 1101, 17),
(99, '/team/2017/5.jpg', 2017, 1155, 18),
(102, '/team/2017/6.jpg', 2017, 1701, 18),
(105, '/team/2017/7.jpg', 2017, 1233, 7),
(108, '/team/2017/8.jpg', 2017, 1752, 7),
(111, '/team/2017/9.jpg', 2017, 1023, 15),
(114, '/team/2017/10.jpg', 2017, 1638, 15),
(117, '/team/2017/11.jpg', 2017, 966, 15),
(120, '/team/2017/12.jpg', 2017, 1704, 3),
(123, '/team/2017/13.jpg', 2017, 1854, 2),
(126, '/team/2017/14.jpg', 2017, 1452, 5),
(129, '/team/2016/1.jpg', 2016, 1824, 1),
(132, '/team/2016/2.jpg', 2016, 1455, 4),
(135, '/team/2016/3.jpg', 2016, 1107, 16),
(138, '/team/2016/4.jpg', 2016, 1317, 16),
(141, '/team/2016/5.jpg', 2016, 1422, 11),
(144, '/team/2016/6.jpg', 2016, 1776, 11),
(147, '/team/2016/7.jpg', 2016, 846, 8),
(150, '/team/2016/8.jpg', 2016, 1233, 8),
(153, '/team/2016/9.jpg', 2016, 1335, 15),
(156, '/team/2016/10.jpg', 2016, 1770, 15),
(159, '/team/2016/11.jpg', 2016, 1065, 15),
(162, '/team/2016/12.jpg', 2016, 1032, 3),
(165, '/team/2016/13.jpg', 2016, 1854, 2),
(168, '/team/2016/14.jpg', 2016, 1071, 5),
(171, '/team/2015/1.jpg', 2015, 1854, 1),
(174, '/team/2015/2.jpg', 2015, 1851, 4),
(177, '/team/2015/3.jpg', 2015, 1239, 10),
(180, '/team/2015/4.jpg', 2015, 1017, 10),
(183, '/team/2015/5.jpg', 2015, 1653, 11),
(186, '/team/2015/6.jpg', 2015, 1293, 11),
(189, '/team/2015/7.jpg', 2015, 1551, 7),
(192, '/team/2015/8.jpg', 2015, 1875, 7),
(195, '/team/2015/9.jpg', 2015, 1455, 14),
(198, '/team/2015/10.jpg', 2015, 846, 14),
(201, '/team/2015/11.jpg', 2015, 1335, 14),
(204, '/team/2015/12.jpg', 2015, 858, 3),
(207, '/team/2015/13.jpg', 2015, 1380, 2),
(210, '/team/2015/14.jpg', 2015, 1056, 5),
(213, '/team/2014/1.jpg', 2014, 1710, 1),
(216, '/team/2014/2.jpg', 2014, 1893, 4),
(219, '/team/2014/3.jpg', 2014, 1854, 10),
(222, '/team/2014/4.jpg', 2014, 1824, 10),
(225, '/team/2014/5.jpg', 2014, 1599, 11),
(228, '/team/2014/6.jpg', 2014, 1239, 11),
(231, '/team/2014/7.jpg', 2014, 1320, 7),
(234, '/team/2014/8.jpg', 2014, 1194, 7),
(237, '/team/2014/9.jpg', 2014, 1833, 14),
(240, '/team/2014/10.jpg', 2014, 1851, 14),
(243, '/team/2014/11.jpg', 2014, 963, 14),
(246, '/team/2014/12.jpg', 2014, 1500, 3),
(249, '/team/2014/13.jpg', 2014, 1848, 2),
(252, '/team/2014/14.jpg', 2014, 1455, 5),
(255, '/team/2013/1.jpg', 2013, 1710, 1),
(258, '/team/2013/2.jpg', 2013, 1464, 4),
(261, '/team/2013/3.jpg', 2013, 1179, 9),
(264, '/team/2013/4.jpg', 2013, 1320, 9),
(267, '/team/2013/5.jpg', 2013, 1191, 13),
(270, '/team/2013/6.jpg', 2013, 1062, 8),
(273, '/team/2013/7.jpg', 2013, 1893, 14),
(276, '/team/2013/8.jpg', 2013, 1080, 3),
(279, '/team/2013/9.jpg', 2013, 1380, 2),
(282, '/team/2013/10.jpg', 2013, 1500, 5),
(286, '/team/2020/1.jpg', 2020, 1806, 1),
(289, '/team/2020/2.jpg', 2020, 1602, 4),
(292, '/team/2020/3.jpg', 2020, 1719, 16),
(295, '/team/2020/4.jpg', 2020, 1674, 18),
(298, '/team/2020/5.jpg', 2020, 1182, 18),
(301, '/team/2020/6.jpg', 2020, 1626, 6),
(304, '/team/2020/7.jpg', 2020, 1389, 6),
(307, '/team/2020/8.jpg', 2020, 2052, 12),
(310, '/team/2020/9.jpg', 2020, 1350, 12),
(313, '/team/2020/10.jpg', 2020, 1764, 15),
(316, '/team/2020/11.jpg', 2020, 1809, 15),
(319, '/team/2020/12.jpg', 2020, 2066, 3),
(322, '/team/2020/13.jpg', 2020, 1638, 2),
(325, '/team/2020/14.jpg', 2020, 2051, 5),
(326, '/team/2021/1.jpg', 2021, 1602, 1),
(327, '/team/2021/2.jpg', 2021, 2124, 4),
(328, '/team/2021/3.jpg', 2021, 1275, 16),
(329, '/team/2021/4.jpg', 2021, 2032, 18),
(330, '/team/2021/5.jpg', 2021, 2128, 18),
(331, '/team/2021/6.jpg', 2021, 2028, 18),
(332, '/team/2021/7.jpg', 2021, 2126, 6),
(333, '/team/2021/8.jpg', 2021, 2040, 6),
(334, '/team/2021/9.jpg', 2021, 2075, 12),
(335, '/team/2021/10.jpg', 2021, 2127, 15),
(336, '/team/2021/11.jpg', 2021, 1182, 15),
(337, '/team/2021/12.jpg', 2021, 2066, 2),
(338, '/team/2021/13.jpg', 2021, 2129, 3),
(339, '/team/2021/14.jpg', 2021, 2125, 5),
(343, '/team/2022/1.jpg', 2022, 2124, 1),
(361, '/team/2022/2.jpg', 2022, 2125, 4),
(364, '/team/2022/3.jpg', 2022, 2136, 6),
(367, '/team/2022/4.jpg', 2022, 2122, 11),
(370, '/team/2022/5.jpg', 2022, 2146, 15),
(373, '/team/2022/6.jpg', 2022, 2149, 3),
(376, '/team/2022/7.jpg', 2022, 2066, 2),
(379, '/team/2022/8.jpg', 2022, 2152, 5),
(382, '/team/2022/9.jpg', 2022, 2058, 12),
(385, '/team/2022/10.jpg', 2022, 2055, 15),
(388, '/team/2022/11.jpg', 2022, 2155, 11),
(391, '/team/2022/12.jpg', 2022, 1521, 16),
(394, '/team/2022/13.jpg', 2022, 2158, 12),
(397, '/team/2022/14.jpg', 2022, 2040, 6);


--
-- Data for Name: team_colaborator; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.team_colaborator (user_id, mandate) VALUES
(2104, 2021),
(2136, 2021),
(2033, 2021),
(2035, 2021),
(2133, 2021),
(2055, 2021),
(2134, 2021),
(2058, 2021),
(2132, 2021);


--
-- Data for Name: team_role; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.team_role (id, name, weight) VALUES
(1, 'Coordenador', 6),
(2, 'Presidente da Mesa da RGM', 3),
(3, 'Primeiro Secretário da Mesa da RGM', 1),
(4, 'Responsável Financeiro', 5),
(5, 'Segundo Secretário da Mesa da RGM', 2),
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
-- Data for Name: user; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.user (id, name, full_name, uu_email, uu_iupi, curriculo, linkedin, git, permission, created_at) VALUES
(1, 'NEI', 'Núcleo de Estudantes de Informática', '', '', '', '', '', NULL, '2021-04-26'),
(840, 'Afonso Rodrigues', 'AFONSO ANTÓNIO MAIA RODRIGUES', 'aamrodrigues@ua.pt', '2DAF6140-A055-4F1D-BFE6-6E79D9A0B345', '', '', '', NULL, '1971-01-01'),
(843, 'Alexandre Rodrigues', 'ALEXANDRE ANTUNES RODRIGUES', 'aarodrigues@ua.pt', '8D850DA2-EB43-4D1E-A2C9-6DD7FA1E48DD', '', '', '', NULL, '1971-01-01'),
(846, 'Beatriz Marques', 'ANA BEATRIZ BORREGO MARQUES', 'abbm@ua.pt', '2FD4A666-1EA5-4E36-8119-A8DDCB374AD9', '', 'https://www.linkedin.com/in/beatriz-marques-6a677414b/', '', NULL, '2013-09-12'),
(849, 'Abel Fernando', 'ABEL FERNANDO BARROS RODRIGUES', 'abelfernando@ua.pt', '5A10E15C-0EC2-4DE6-9F44-F886DF4CB178', '/upload/curriculos/849.pdf', '', '', NULL, '2018-12-14'),
(852, 'Ana Rodrigues', 'ANA CRISTINA DOS SANTOS RODRIGUES', 'acsr@ua.pt', '64402D72-6638-4733-8725-63A423A75A69', '', '', '', NULL, '2013-09-12'),
(855, 'André Soares', 'ANDRÉ FILIPE BARBOSA SOARES', 'afbs@ua.pt', 'B7D88976-208B-4698-BA7C-DF23A7665921', '', '', '', NULL, '2013-09-12'),
(858, 'André Moleirinho', 'ANDRÉ FONSECA MOLEIRINHO', 'afmoleirinho@ua.pt', 'EF4A4ACD-9469-4D79-B663-E8843FD4F1E7', '', 'https://www.linkedin.com/in/andr%C3%A9-moleirinho/', '', NULL, '2014-09-18'),
(861, 'Afonso Pimentel', 'AFONSO JOÃO PIRES PIMENTEL', 'afonsopimentel@ua.pt', 'B90DB218-13DF-4066-B8BE-EC25917AAFE2', '', '', '', NULL, '2015-09-23'),
(864, 'Afonso Silva', 'AFONSO DE SALGUEIRO E SILVA', 'afonsosilva6@ua.pt', '7C325E15-DEFA-4E5B-8E45-C02CF50B6970', '', '', '', NULL, '1971-01-01'),
(867, 'André Almeida', 'ANDRÉ GOMES DE ALMEIDA', 'aga@ua.pt', 'FC6F9D25-CBBF-4F7C-8BE3-29752FBBAA37', '', '', '', NULL, '2013-09-12'),
(870, 'Alexandra Carvalho', 'ALEXANDRA TEIXEIRA DE SOUSA MARQUES DE CARVALHO', 'alexandracarvalho@ua.pt', 'B7D45431-DAE9-4320-BD68-9FD26DD01152', '', '', '', NULL, '1971-01-01'),
(873, 'Alexandre Lopes', 'Alexandre Lopes', 'alexandrejflopes@ua.pt', '', '', '', '', NULL, '2019-07-02'),
(876, 'Alex Santos', 'ALEX MIRANDA DOS SANTOS', 'alexmsantos@ua.pt', 'A9704A27-68DD-4B8E-98E4-17C6E5C489AD', '', '', '', NULL, '2013-09-25'),
(879, 'Alina Yanchuk', 'ALINA YANCHUK', 'alinayanchuk@ua.pt', '1E1D1C86-7A29-4BC5-83D5-751A85C5D253', '', '', '', NULL, '2017-10-23'),
(882, 'Miguel Almeida', 'MIGUEL ÂNGELO FERNANDES DE ALMEIDA', 'almeida.m@ua.pt', '35076817-7687-4DAD-88D6-2934A7131C34', '', '', '', NULL, '1971-01-01'),
(885, 'Bruno Almeida', 'BRUNO MIGUEL TAVARES DE ALMEIDA', 'almeidabruno@ua.pt', 'D7FFFAB2-2660-483D-B910-D661427969A9', '', '', '', NULL, '2014-04-02'),
(888, 'Ana Almeida', 'ANA FILIPA SIMÃO DE ALMEIDA', 'anaa@ua.pt', 'E5D766B9-6D25-4039-9594-485841E14E48', '', '', '', NULL, '2015-09-23'),
(891, 'Ana Tavares', 'ANA FILIPA FERREIRA TAVARES', 'anafilipatavares@ua.pt', '00FFA235-5496-43A3-A8A7-AA78DCB816BC', '', '', '', NULL, '2014-09-17'),
(894, 'Ana Ortega', 'ANA ISABEL CARVALHO ORTEGA', 'anaortega@ua.pt', '1F04EE42-7F10-43E7-97A7-AFEBB6CA59C2', '', '', '', NULL, '2013-09-12'),
(897, 'Rafaela Vieira', 'ANA RAFAELA RODRIGUES VIEIRA', 'anarafaela98@ua.pt', 'B62E7A1F-B77D-4245-93F2-500642B1E8CD', '', '', '', NULL, '2018-01-11'),
(900, 'André Alves', 'ANDRÉ TEIXEIRA BAIÃO ALVES', 'andre.alves@ua.pt', '08C6C0B0-CDDE-4472-8DE1-233CE88B7840', '/upload/curriculos/900.pdf', '', '', NULL, '2017-10-23'),
(903, 'André Amorim', 'ANDRÉ DE ARAÚJO E SILVA AMORIM', 'andre.amorim@ua.pt', 'BB8A45B6-3632-46B9-BCE6-37BE08FD110B', '', '', '', NULL, '2017-10-23'),
(906, 'André Catarino', 'ANDRÉ ALMEIDA CATARINO', 'andre.catarino@ua.pt', '2D115D45-ACCF-44BB-907C-1EAA121330DC', '/upload/curriculos/906.pdf', '', '', NULL, '2017-10-23'),
(909, 'André Ribas', 'ANDRÉ FILIPE DA SILVA RIBAS', 'andre.ribass@ua.pt', '53655B49-A049-4C45-B405-D0495A102924', '', '', '', NULL, '2013-09-12'),
(912, 'Nuno Barreto', 'NUNO ANDRÉ TÁVORA BARRETO', 'andrebarreto@ua.pt', 'A919A5D4-43DC-4D65-BE53-473ED0B932DC', '', '', '', NULL, '2013-09-12'),
(915, 'André Bastos', 'ANDRÉ PAULO BASTOS', 'andrebastos@ua.pt', '0060AE76-8081-45FD-89BB-F6A9A30775EE', '', '', '', NULL, '2013-09-24'),
(918, 'André Brandão', 'ANDRÉ XAVIER RIBEIRO DE ALMEIDA BRANDÃO', 'andrebrandao@ua.pt', 'C9482D49-4992-4F1D-8933-C3CBF2370FDA', '', '', '', NULL, '2018-01-11'),
(921, 'André Gual', 'ANDRÉ FREITAS BAPTISTA GUAL', 'andregual@ua.pt', 'CF14E72E-54F9-44FE-9EA9-77B3608FE3A8', '', '', '', NULL, '2017-10-23'),
(924, 'André Bastos', 'ANDRÉ MARTINS BASTOS', 'andrembastos@ua.pt', '5BD6FB14-7351-4E8B-9D24-ECAE0F3484BD', '', '', '', NULL, '2013-09-26'),
(927, 'André Amarante', 'ANDRÉ GRAMATA RIBAU AMARANTE', 'andreribau@ua.pt', '0AB48885-9F64-418E-AAC9-CC6C698B4F32', '', '', '', NULL, '2017-10-23'),
(930, 'André Gomes', 'ANDRÉ SANTOS GOMES', 'andresgomes@ua.pt', '54176BC4-E0CA-42CF-A488-58BA5195A251', '', '', '', NULL, '2018-01-11'),
(933, 'Anthony Pereira', 'ANTHONY DOS SANTOS PEREIRA', 'anthonypereira@ua.pt', '922D8550-C063-41FC-85AA-B3CB00818B3D', '', '', '', NULL, '1971-01-01'),
(936, 'António Castanheira', 'ANTÓNIO MANUEL DE MELO CASTANHEIRA', 'antonio.castanheira@ua.pt', '2C74D3CA-60DD-438F-8478-BD5428D466D1', '', '', '', NULL, '2015-09-23'),
(939, 'António Freire', 'ANTÓNIO EMANUEL TEIXEIRA FREIRE', 'antonio.emanuel@ua.pt', 'DE93C4B5-50F9-4D6E-B667-A4F3AC026F67', '', '', '', NULL, '2013-09-28'),
(942, 'António Gomes', 'ANTÓNIO SÉRGIO PEREIRA SÁ GOMES', 'antonio97@ua.pt', 'EBE79A24-71A8-4423-984C-FC1E17D49C65', '', '', '', NULL, '2015-09-23'),
(945, 'António Fernandes', 'ANTÓNIO JORGE OLIVEIRA FERNANDES', 'antoniojorgefernandes@ua.pt', '516B2525-3A36-4194-836A-56632BD275E0', '', '', '', NULL, '1971-01-01'),
(948, 'Ana Gonçalves', 'ANA ROSA MARQUES GONÇALVES', 'argoncalves@ua.pt', '0E1B019F-8877-4D8E-B9AB-8196FC3FADD2', '', '', '', NULL, '2014-04-01'),
(951, 'Ana Oliveira', 'ANA RITA RODRIGUES OLIVEIRA', 'arro@ua.pt', 'D30218AF-85F6-49D6-9C90-7975C2690965', '', '', '', NULL, '2015-09-23'),
(954, 'Artur Sousa', 'ARTUR SAMPAIO LEITÃO ALVES DE SOUSA', 'artur.sousa@ua.pt', 'B6119592-AB33-4F8C-9CE3-6813ED394B16', '', '', '', NULL, '2018-10-28'),
(957, 'André Pedrosa', 'ANDRÉ SILVA PEDROSA', 'aspedrosa@ua.pt', '9D7069F7-116D-424F-8898-59F9E6F9C962', '', '', '', NULL, '2018-01-11'),
(960, 'Leticia Azevedo', 'LETÍCIA ISABEL GOMES AZEVEDO', 'azevedo.leticia@ua.pt', '9A5B040B-ADB3-4610-853B-75C0349EEB70', '', '', '', NULL, '2018-10-22'),
(963, 'Bárbara Neto', 'BÁRBARA JAEL DOS SANTOS NETO', 'barbara.jael@ua.pt', '3BD02E80-1927-41BD-B64A-37F61B852EEF', '/upload/curriculos/963.pdf', 'https://www.linkedin.com/in/barbarajael/', '', NULL, '2013-09-25'),
(966, 'Bernardo Domingues', 'BERNARDO DE OLIVEIRA DOMINGUES', 'bernardo.domingues@ua.pt', '3A8F740A-BDCE-4836-B006-40919821C5D5', '', 'https://www.linkedin.com/in/bernardodomingues/', '', NULL, '2017-02-09'),
(969, 'Bernardo Rodrigues', 'BERNARDO JOÃO GONÇALVES DA CRUZ RODRIGUES', 'bernardorodrigues@ua.pt', '14E96F4E-A5E1-4C4A-BF84-18DFD75CDEA6', '', '', '', NULL, '2017-10-23'),
(972, 'Bruno Rocha', 'BRUNO MIGUEL FONSECA DA ROCHA', 'bmfrocha@ua.pt', '1B157763-88C9-435E-BBAB-F59B0D1FB9AB', '', '', '', NULL, '2013-09-12'),
(975, 'Bruno Pereira', 'BRUNO MIGUEL DA SILVA PEREIRA', 'bmpereira@ua.pt', '50A5FD5C-940C-4AB5-8FBE-E28E60EC2ED1', '', '', '', NULL, '2013-09-28'),
(978, 'Breno Salles', 'BRENO DA FONSECA SALLES', 'brenosalles@ua.pt', 'F948C6F4-5B2F-490D-80AE-688DB6314198', '', '', '', NULL, '2015-09-23'),
(981, 'Bruno Cruz', 'BRUNO SIMÕES CRUZ', 'bruno.cruz@ua.pt', 'CA156253-519C-4B63-8B02-C2A7F358711B', '', '', '', NULL, '2013-10-04'),
(984, 'Bruno Barbosa', 'BRUNO MIGUEL PINHO BARBOSA', 'brunobarbosa@ua.pt', '604DE09F-F2CB-466E-B8CB-40E87BE3063C', '', '', '', NULL, '2013-09-25'),
(987, 'Bruno Pinto', 'BRUNO MARQUES PINTO', 'brunopinto5151@ua.pt', 'B14C29C0-DB97-4276-845D-7B91B93F3FF7', '/upload/curriculos/987.pdf', '', '', NULL, '2013-09-24'),
(990, 'Bruno Rabaçal', 'BRUNO NELSON DIOGO RABAÇAL', 'brunorabacal@ua.pt', '14319191-66EF-472D-BF7B-A6EA70AD4CFF', '', '', '', NULL, '2018-01-11'),
(993, 'Bruno Bastos', 'BRUNO DE SOUSA BASTOS', 'brunosb@ua.pt', '588FF064-CAB3-4718-AD1C-00D4C113C0DC', '', '', '', NULL, '1971-01-01'),
(996, 'Caio Jacobina', 'CAIO SANTANA JACOBINA', 'caio@ua.pt', 'EDEC525F-783D-4480-85CE-4FF5773FC986', '', '', '', NULL, '2013-09-24'),
(999, 'Camila Uachave', 'CAMILA EUGÉNIO SILVESTRE FRANCISCO UACHAVE', 'camilauachave@ua.pt', '4F9312E0-1093-4702-87F6-BF048F466202', '', '', '', NULL, '2018-12-06'),
(1002, 'Carina Neves', 'CARINA FILIPA FREITAS DAS NEVES', 'carina.f.f.neves@ua.pt', '88A27055-CD44-4662-981B-3907A9E4488B', '', '', '', NULL, '2018-12-05'),
(1005, 'Pacheco', 'CARLOS ANTÓNIO RIBEIRO FERREIRA PACHECO', 'carlos.pacheco@ua.pt', '0FD9DCD6-C3F8-4434-9627-12CE1DA35323', '', '', '', NULL, '2013-09-12'),
(1008, 'Carlos Cabral', 'CARLOS MANUEL MOURA CABRAL', 'carlosmcabral@ua.pt', 'D52D08BC-6207-4FB7-B62D-218BEE4111E5', '', '', '', NULL, '2013-09-12'),
(1011, 'Carlos Raimundo', 'CARLOS ANDRÉ SILVA RAIMUNDO', 'carlosraimundo7@ua.pt', '4A60311D-1650-4CA1-A800-782FCE42D02A', '', '', '', NULL, '2013-09-15'),
(1014, 'Carlos Ying Zhu', 'CARLOS YING ZHU', 'carlosyingzhu@ua.pt', '76FEBB6A-CB39-43A9-B653-991B736EE34C', '', '', '', NULL, '2017-05-27'),
(1017, 'Carlota Marques', 'CARLOTA RIBEIRO MARQUES', 'carlotamarques@ua.pt', '323DFF5C-4246-4B9E-90A5-4FF6310F7213', '', 'https://www.linkedin.com/in/carlota-marques/', '', NULL, '2014-09-15'),
(1020, 'Carolina Araújo', 'CAROLINA SIMÕES ARAÚJO', 'carolina.araujo00@ua.pt', 'B644062B-1275-4AE1-BA60-7E2783D72F78', '', '', '', NULL, '1971-01-01'),
(1023, 'Carolina Albuquerque', 'CAROLINA MARQUES ALBUQUERQUE', 'carolinaalbuquerque@ua.pt', 'CCCE24F9-1B0C-4184-A1A9-13F809AA4F67', '/upload/curriculos/1023.pdf', 'https://www.linkedin.com/in/carolina-albuquerque29/', '', NULL, '2015-09-23'),
(1026, 'Carolina Marques', 'CAROLINA RESENDE MARQUES', 'carolinaresendemarques@ua.pt', 'C8AC5540-2103-4BFB-BD5D-EADE71C35C40', '', '', '', NULL, '2018-01-11'),
(1029, 'Daniela Carvalho', 'DANIELA FILIPA PIRES DE CARVALHO', 'carvalho.filipa@ua.pt', 'EF46A01F-5187-438A-ACD7-A0B3492606CC', '', '', '', NULL, '2013-09-24'),
(1032, 'Andreia Ferreira', 'ANDREIA DE CASTRO FERREIRA', 'castroferreira@ua.pt', '394756EA-3DE8-46E3-9C9A-FC5156265FDA', '', 'https://www.linkedin.com/in/castroferreira/', '', NULL, '2013-09-12'),
(1035, 'Catarina Fonseca', 'CATARINA ISABEL VASCO FONSECA', 'catarina.vasco.fonseca@ua.pt', '5F99620C-32AD-48B6-9897-4009CEE87E51', '', '', '', NULL, '2016-03-19'),
(1038, 'Catarina Vinagre', 'CATARINA JOÃO ALMEIDA VINAGRE', 'catarinajvinagre@ua.pt', '297A9A21-49B7-4DE2-9AF4-0645255735F2', '', '', '', NULL, '2013-09-27'),
(1041, 'Catarina Xavier', 'CATARINA MARGARIDA NUNES SOARES XAVIER', 'catarinaxavier@ua.pt', '1CE18A6E-7C12-438C-B8FA-79B266F5ACB7', '', '', '', NULL, '2018-01-11'),
(1044, 'Cátia Matos', 'CÁTIA RAQUEL DE LIMA MATOS', 'catiamatos@ua.pt', '4DE33C79-ED78-4A22-BA25-38407B165075', '', '', '', NULL, '2013-09-12'),
(1047, 'Carlos Daniel Santos Marques', 'CARLOS DANIEL SANTOS MARQUES', 'cdaniel@ua.pt', '85372F54-019E-4851-9C5C-D7BABC215D62', '/upload/curriculos/1047.pdf', '', '', NULL, '2018-01-11'),
(1050, 'Carlos Ferreira', 'CARLOS HENRIQUE DE FIGUEIREDO FERREIRA', 'chff@ua.pt', '404B77B7-A6D8-43F2-ACC8-9D16E88804A2', '', '', '', NULL, '2015-09-23'),
(1053, 'Claudio Costa', 'CLÁUDIO MIGUEL DOS SANTOS MOREIRA DA COSTA', 'claudio.costa@ua.pt', 'EACC20D1-AD0F-4CA6-BE79-7E99F3A86C29', '', 'https://www.linkedin.com/in/cláudio-costa-8912a4192/', '', NULL, '2018-01-11'),
(1056, 'Claudio Santos', 'CLÁUDIO VEIGAS SANTOS', 'claudioveigas@ua.pt', '0E74058D-E006-412D-8383-7230944DEAE6', '', 'https://www.linkedin.com/in/claudiovsantos/', '', NULL, '2014-09-17'),
(1059, 'Carlos Soares', 'CARLOS MANUEL LOPES SOARES', 'cmsoares@ua.pt', 'A72E83A0-001C-4AD6-8FFA-34E362BA2969', '', 'https://www.linkedin.com/in/carlos-soares-56a754152/', '', NULL, '2015-09-23'),
(1062, 'João Costa', 'JOÃO ANTÓNIO TEIXEIRA COSTA', 'costa.j@ua.pt', '0EE19EC6-D7D7-4390-B0E1-2759E5FDA6F6', '', '', '', NULL, '2013-09-12'),
(1065, 'Cristóvão Freitas', 'JOÃO CRISTÓVÃO ALVES FREITAS', 'cristovaofreitas@ua.pt', 'DFF321A8-E7FF-4044-8CBB-42A5ABE982E0', '', 'https://www.linkedin.com/in/cristovaofreitas/', '', NULL, '2013-09-12'),
(1068, 'Dinis Cruz', 'DINIS BARROQUEIRO CRUZ', 'cruzdinis@ua.pt', '9D8BCB3A-6022-4AF9-9B56-C3879D17D7C6', '', '', '', NULL, '1971-01-01'),
(1071, 'Mimi Cunha', 'ANA FILIPA MAIA CUNHA', 'cunha.filipa.ana@ua.pt', 'F582AF03-C72D-404D-89E1-B7C530C6E98E', '', 'https://www.linkedin.com/in/filipacunha29/', '', NULL, '2013-09-24'),
(1074, 'Daniel Gomes', 'DANIEL DE AMARAL GOMES', 'dagomes@ua.pt', 'E546076D-C0A9-4A10-8C1C-344399F86BA4', '', '', '', NULL, '1971-01-01'),
(1077, 'Daniel Couto', 'DANIEL SERAFIM GOMES COUTO', 'daniel.couto@ua.pt ', 'C957CF34-150C-4545-A6FA-640CBF07D75D', '', '', '', NULL, '1971-01-01'),
(1080, 'Daniel Rodrigues', 'DANIEL VALÉRIO RODRIGUES', 'daniel.v.rodrigues@ua.pt', 'B3D0A53C-6E0D-48AD-A9D2-C9D8D283AA43', '', 'https://www.linkedin.com/in/danielvrodrigues/', '', NULL, '2013-09-12'),
(1083, 'Daniela Pinto', 'DANIELA ALEXANDRA BASTOS PINTO', 'daniela.pinto@ua.pt', 'C3ACB56C-57D6-4FE9-AD1F-7CE4FAE314F8', '', '', '', NULL, '2013-10-21'),
(1086, 'Daniel Moreira', 'DANIEL BARBOSA MOREIRA', 'danielbarbosa@ua.pt', '682FE72D-577F-4431-956D-55D92F198F48', '', '', '', NULL, '2013-09-24'),
(1089, 'Daniel Silva', 'DANIEL LEMOS DA SILVA', 'daniellemossilva@ua.pt', '6FCE3F27-F871-4161-984D-3CE23D217429', '', '', '', NULL, '2014-09-15'),
(1092, 'Daniel Gonçalves', 'DANIEL MATEUS GONÇALVES', 'danielmateusgoncalves@ua.pt', '2B0A2A92-FF40-4F78-902A-322B78B1B02B', '', '', '', NULL, '2015-09-23'),
(1095, 'Daniel Nunes', 'DANIEL FILIPE BRITO NUNES', 'danielnunes98@ua.pt', '9279330F-5115-4FFA-BF67-3656CA643475', '/upload/curriculos/1095.pdf', '', '', NULL, '2018-01-11'),
(1098, 'Daniel Teixeira', 'DANIEL OLIVEIRA TEIXEIRA', 'danielteixeira31@ua.pt', '136A6B77-EE67-46F5-8898-5D7061FDEC22', '', 'https://www.linkedin.com/in/daniel-teixeira-75b64217b/', 'https://github.com/DamnDaniel7', NULL, '2018-01-11'),
(1101, 'David Fernandes', 'DAVID AUGUSTO DE SOUSA FERNANDES', 'dasfernandes@ua.pt', '77238D3D-B708-47ED-A1F8-B18C6CE16D7F', '/upload/curriculos/1101.pdf', 'https://www.linkedin.com/in/dasfernandes/', '', NULL, '2016-02-23'),
(1104, 'Jorge Loureiro', 'JORGE DAVID DE OLIVEIRA LOUREIRO', 'david.jorge@ua.pt', '60CFC2CF-3B4A-48B9-8218-04F6F4550890', '', '', '', NULL, '2013-09-25'),
(1107, 'David Ferreira', 'DAVID DA CRUZ FERREIRA', 'davidcruzferreira@ua.pt', '23C10F1D-6629-47C1-82B0-FB930A1D99D1', '', 'https://www.linkedin.com/in/david-ferreira-a49580147/', '', NULL, '2013-09-25'),
(1110, 'Davide Pontes', 'DAVIDE FRAGA PACHECO PEREIRA PONTES', 'davidepontes@ua.pt', '8A7641DE-65F0-4597-B0C2-86F9FB14646D', '', '', '', NULL, '2013-09-12'),
(1113, 'David Morais', 'DAVID GOMES MORAIS', 'davidmorais35@ua.pt', 'B6438AEE-A01B-4112-A8F2-BF326B1EFD18', '', '', '', NULL, '1971-01-01'),
(1116, 'David Ferreira', 'DAVID DOS SANTOS FERREIRA', 'davidsantosferreira@ua.pt', '1E2EC34C-C3A6-48D0-9CAD-16D57A4D285D', '', '', '', NULL, '2013-09-24'),
(1119, 'Rafael Batista', 'RAFAEL DURÃES BAPTISTA', 'dbrafael@ua.pt', '0F9685A6-A478-4730-BE2D-DDA3FEC36B26', '', '', '', NULL, '2018-01-11'),
(1122, 'Diogo Carvalho', 'DIOGO FILIPE AMARAL CARVALHO', 'dfac@ua.pt', '4B5560CD-9D67-4ACC-95C8-13D370264521', '', '', '', NULL, '1971-01-01'),
(1125, 'Diogo Cunha', 'DIOGO GUILHERME ROCHA CUNHA', 'dgcunha@ua.pt', 'FB2E2BE1-ED33-49DE-870D-1A18A33D241D', '', '', '', NULL, '1971-01-01'),
(1128, 'Diego Santos', 'DIEGO ALESSANDRO BATISTA SANTOS', 'diego.santos@ua.pt', 'DAE94FDC-99FA-4AD9-A4D0-D682209E2278', '', '', '', NULL, '1971-01-01'),
(1131, 'Diego Trovisco', 'DIEGO FERNANDO ALVES TROVISCO', 'diegotrovisco@ua.pt', '2A6B35CB-1EB7-4FF6-B3A9-8EE57545C1D7', '', '', '', NULL, '2015-09-23'),
(1134, 'Dimitri Silva', 'DIMITRI ALEXANDRE DA SILVA', 'dimitrisilva@ua.pt', '5D53B30C-4001-4038-9309-588A20D1DF12', '', '', '', NULL, '2015-09-23'),
(1137, 'Diogo Andrade', 'DIOGO ANDRÉ LOPES ANDRADE', 'diogo.andrade@ua.pt', 'D241CE33-7CB7-49D1-AE19-F660BD633F47', '', '', '', NULL, '2017-10-23'),
(1140, 'Diogo Arrais', 'DIOGO FRADINHO ARRAIS', 'diogo.arrais@ua.pt', '5BA6FD65-D93A-4F53-AEB1-5B55A933EAE9', '', '', '', NULL, '2013-09-12'),
(1143, 'Diogo Borges', 'DIOGO RAIMONDI BORGES', 'diogo.borges@ua.pt', 'C433B7FD-77D4-4A0F-9849-4570952C2C25', '', '', '', NULL, '2013-09-25'),
(1146, 'Diogo Moreita', 'DIOGO EMANUEL DE OLIVEIRA MOREIRA', 'diogo.e.moreira@ua.pt', 'E6175917-4FD8-4903-BBA1-B8799820CE3C', '', '', '', NULL, '1971-01-01'),
(1149, 'Diogo Silva', 'DIOGO GUIMARÃES SILVA', 'diogo.g@ua.pt', '10694C97-193E-48E8-A58B-2DEA9BA74455', '', '', '', NULL, '1971-01-01'),
(1152, 'Diogo Jorge', 'DIOGO JORGE FERREIRA', 'diogo.jorge97@ua.pt', '846FA9A2-3812-46D7-B090-0DD0C47EDD28', '/upload/curriculos/1152.pdf', '', '', NULL, '2015-09-23'),
(1155, 'Diogo Reis', 'DIOGO FILIPE ESTEVES REIS', 'diogo.reis@ua.pt', '3D5BC612-4DAF-4457-BE03-88C1E7C349E7', '', 'https://www.linkedin.com/in/diogo-f-reis/', '', NULL, '2014-03-05'),
(1158, 'Diogo Silveira', 'DIOGO MIGUEL DE ALMEIDA SILVEIRA', 'diogo.silveira10@ua.pt', 'B60EF0F6-AC7D-4C83-8CC4-40B3B07FA521', '', '', '', NULL, '2018-01-11'),
(1161, 'Diogo Silva', 'DIOGO GONÇALVES SILVA', 'diogo04@ua.pt', '319E204B-87ED-48FE-BFFE-48A6F619EC17', '/upload/curriculos/1161.pdf', '', '', NULL, '2017-10-23'),
(1164, 'Diogo Bento', 'DIOGO OLIVEIRA BENTO', 'diogobento@ua.pt', '849B6413-3265-463A-91DB-4B650CDEA75E', '', '', '', NULL, '1971-01-01'),
(1167, 'Diogo Ramos', 'DIOGO RAFAEL RODRIGUES RAMOS', 'diogorafael@ua.pt', 'DB9EC254-97D8-4F39-81B1-264193124D71', '', '', '', NULL, '2013-09-28'),
(1170, 'Daniel Lopes', 'DANIEL ALMEIDA LOPES', 'dlopes@ua.pt', 'FD42B037-3CC4-4885-A154-2C3A8E21163A', '', '', '', NULL, '2015-09-23'),
(1173, 'Daniel Pinto', 'DANIEL JOSÉ MATIAS PINTO', 'dmatiaspinto@ua.pt', '3DF564DB-A663-43CD-93E6-AC334B1C00A2', '', '', '', NULL, '2017-10-23'),
(1176, 'Diogo Sousa', 'DIOGO MACEDO DE SOUSA', 'dmdsousa@ua.pt', '319B53BC-CC20-4C73-86E5-150B46FB60DA', '', '', '', NULL, '2013-09-24'),
(1179, 'Diogo Paiva', 'DIOGO OLIVEIRA PAIVA', 'dpaiva@ua.pt', '7D2444A9-1CB3-41C6-9271-81D6CF0737E1', '', 'https://www.linkedin.com/in/diogo-paiva-bb578877/', '', NULL, '2013-09-09'),
(1182, 'Duarte Mortágua', 'DUARTE NEVES TAVARES MORTÁGUA', 'duarte.ntm@ua.pt', '0798A134-0DBB-4E1F-88D1-24358E6C6AF9', '', 'https://www.linkedin.com/in/duartemortagua/', 'https://github.com/DNTM2802', NULL, '1971-01-01'),
(1185, 'Duarte Castanho', 'DUARTE MANUEL CUNHA PINTO COSTA CASTANHO', 'duartecastanho@ua.pt', 'FD192438-1C4B-4287-9190-9F1DED6F1FA6', '', '', '', NULL, '2018-01-11'),
(1188, 'Nuno Fonseca', 'NUNO DUARTE SIMÃO DA FONSECA', 'duartenuno@ua.pt', '9727D515-1099-4A66-9D4E-1BF4D7F555D5', '', '', '', NULL, '2014-09-17'),
(1191, 'Eduardo Martins', 'EDUARDO GUERRA MARTINS', 'e.martins@ua.pt', '95C38707-5BFC-4939-8DD8-6894D8B75D14', '', 'https://www.linkedin.com/in/eduardo-martins-5b616367/', '', NULL, '2013-09-12'),
(1194, 'Emanuel Laranjo', 'EMANUEL ALEXANDRE PEREIRA LARANJO', 'ealaranjo@ua.pt', '97D9E83B-C61B-4D5D-BF8F-939F550A72F3', '', 'https://www.linkedin.com/in/emanuel-laranjo-63bb5012a/', '', NULL, '2013-09-12'),
(1197, 'Edgar Morais', 'EDGAR GUILHERME SILVA MORAIS', 'edgarmorais@ua.pt', '25571A85-2A63-47FE-B18A-7F3D1FC30968', '', '', '', NULL, '2017-10-23'),
(1200, 'Eduardo Santos', 'EDUARDO HENRIQUE FERREIRA SANTOS', 'eduardosantoshf@ua.pt', 'DC2AC32D-50A9-403A-BA15-A492640FD869', '', 'https://www.linkedin.com/in/eduardosantoshf/', '', NULL, '1971-01-01'),
(1203, 'Eleandro Laureano', 'ELEANDRO GISENEL GAMBÔA LAUREANO', 'eleandrog@ua.pt', '0967AF88-0903-4D65-AAC0-25A587FC32E9', '', '', '', NULL, '2018-01-11'),
(1206, 'Pedro Escaleira', 'PEDRO MIGUEL NICOLAU ESCALEIRA', 'escaleira@ua.pt', '0FBC7C37-68C8-40B7-BF39-20A41B98141B', '/upload/curriculos/1206.pdf', '', '', NULL, '2017-10-23'),
(1209, 'Sara Espanhol', 'SARA SOFIA GIGA ESPANHOL', 'espanholgiga@ua.pt', 'F1B28154-76D2-4D03-8650-783C2B156873', '', '', '', NULL, '2013-09-24'),
(1212, 'Francisco Fontinha', 'FRANCISCO ALEXANDRE AIRES FONTINHA', 'f.fontinha@ua.pt', 'C9A68D7E-E21A-443B-B121-4390C6F28DDC', '', '', '', NULL, '2014-09-17'),
(1215, 'Fábio Carmelino', 'FÁBIO ALEXANDRE ANDRADE CARMELINO', 'faac@ua.pt', 'AAFD5676-61F0-4F10-97F0-6C152BD03C85', '', '', '', NULL, '1971-01-01'),
(1218, 'Fábio Almeida', 'FÁBIO LUÍS ESTIMA DE ALMEIDA', 'fabio.almeida@ua.pt', '0642471C-4907-49FF-A118-1ED5752A7675', '', '', '', NULL, '2013-09-12'),
(1221, 'Fábio Luís', 'FÁBIO ANDRÉ DE ALMEIDA LUÍS', 'fabio.luis@ua.pt', 'F83EA9E8-B6BC-4C36-B015-839338ED7F75', '', '', '', NULL, '2013-09-20'),
(1224, 'Fábio Rogão', 'FÁBIO BARREIRA ROGÃO', 'fabio.rogao@ua.pt', '4D14A892-4C8C-47B5-B2AC-9EA0985E283B', '', '', '', NULL, '2015-09-23'),
(1227, 'Fábio Ferreira', 'FÁBIO XAVIER LEITE FERREIRA', 'fabio.xavier@ua.pt', 'A87EE122-324C-4CCD-B8FB-CD81DAE690D1', '', '', '', NULL, '2013-09-24'),
(1230, 'Fábio Alves', 'FÁBIO ANDRÉ TEIXEIRA ALVES', 'fabioalves@ua.pt', 'DFE162EA-2722-46B5-9611-199D1EA2C94B', '', '', '', NULL, '2013-09-12'),
(1233, 'Fábio Barros', 'FÁBIO DANIEL RODRIGUES BARROS', 'fabiodaniel@ua.pt', '8C2F1324-FE76-4DA7-B3CF-6F995D55FEA6', '', '', '', NULL, '2016-09-25'),
(1236, 'Fábio Pereira', 'FÁBIO MANUEL BAPTISTA PEREIRA', 'fabiompereira@ua.pt', '2EBE112D-21FC-43A3-B760-E63ED579F6D3', '', '', '', NULL, '2013-09-20'),
(1239, 'Filipe Castro', 'FILIPE MIGUEL SANTOS DE CASTRO', 'filipemcastro@ua.pt', '802508C6-40FC-4984-8004-085D72629B0F', '', 'https://www.linkedin.com/in/filipe-castro-8738a497/', '', NULL, '2013-09-12'),
(1242, 'Filipe Neto Pires', 'FILIPE DA SILVA NETO ABRANCHES PIRES', 'filipesnetopires@ua.pt', '09E8B4D6-FCFE-4A53-858A-5E6D7C1A9075', '/upload/curriculos/1242.pdf', '', '', NULL, '2018-01-11'),
(1245, 'Flávia Figueiredo', 'FLÁVIA GOMES FIGUEIREDO', 'flaviafigueiredo@ua.pt', '0BE574DF-4044-400A-BE42-A8FFC88ECCB7', '', 'https://www.linkedin.com/in/flavia-figueiredo/', '', NULL, '2017-10-23'),
(1248, 'Flávia Cardoso', 'FLAVIA MANUELA PINHEIRO CARDOSO', 'flaviamcardoso@ua.pt', '22B54D25-3009-404C-9199-D02EA787FBB8', '', '', '', NULL, '2013-09-12'),
(1251, 'Fábio Santos', 'FÁBIO MIGUEL TOMAZ DOS SANTOS', 'fmts@ua.pt', '50DCE9CF-23FD-4926-B881-A44F2667CB85', '', '', '', NULL, '2015-09-23'),
(1254, 'Francisca Barros', 'FRANCISCA INÊS MARCOS DE BARROS', 'francisca.mbarros@ua.pt', '27F22927-E453-4AE1-B78E-BBE67C8218E1', '', '', '', NULL, '1971-01-01'),
(1257, 'Francisco Machado', 'FRANCISCO JOÃO DUARTE MACHADO', 'francisco.machado@ua.pt', '583878B4-6C43-4296-B504-1E5F65E45689', '', '', '', NULL, '2013-09-29'),
(1260, 'Francisco Pinho', 'FRANCISCO PINHO OLIVEIRA', 'francisco.pinho@ua.pt', 'A5BFCA8B-FCC3-4C55-9883-7CA737CABE74', '', '', '', NULL, '2014-09-17'),
(1263, 'Francisco Araújo', 'FRANCISCO FERNANDO VILELA ARAÚJO', 'franciscoaraujo@ua.pt', 'EC8EB5CF-0E82-4C33-900F-26A94F634C99', '', '', '', NULL, '2015-09-23'),
(1266, 'Francisco Silveira', 'FRANCISCO LOURENÇO BRASIL SILVEIRA', 'franciscosilveira@ua.pt', '0F843A02-F4CB-4BB5-9EFA-7D9D9B267D00', '/upload/curriculos/1266.pdf', '', '', NULL, '2018-01-11'),
(1269, 'Frederico Avo', 'FREDERICO CAMPOS DE AVO', 'fredericoavo@ua.pt', '5D6270FF-B082-46A5-A3D7-31BBFF394229', '', '', '', NULL, '2015-09-23'),
(1272, 'Gil Mesquita', 'GIL GUILHERME CAÇADOR FERNANDES MESQUITA', 'gil.mesquita@ua.pt', 'A3ED09EC-019D-4D93-A945-0D43D65A2B4A', '', '', '', NULL, '2013-09-24'),
(1275, 'Gonçalo Matos', 'GONÇALO ANDRÉ FERREIRA MATOS', 'gmatos.ferreira@ua.pt', 'ADE949DB-D390-4AC3-82FB-9F1D609FEA8D', '', 'https://www.linkedin.com/in/goncalofmatos/', '', NULL, '1971-01-01'),
(1278, 'Gonçalo Almeida', 'GONÇALO LIMA DE ALMEIDA', 'goncalo.almeida@ua.pt', '9DFA3F2B-4B3F-468F-B487-67C7F05AD822', '', '', '', NULL, '2015-09-23'),
(1281, 'Gonçalo Nogueira', 'GONÇALO PINTO NOGUEIRA', 'goncalo34@ua.pt', 'DC029634-313B-4F06-B615-3C291B2542DB', '', '', '', NULL, '2017-10-23'),
(1284, 'Gonçalo Freixinho', 'GONÇALO JOSÉ DE BARROS FREIXINHO', 'goncalofreixinho@ua.pt', 'B094AB13-79C6-45FC-A03D-857498C09CA3', '', '', '', NULL, '2017-10-23'),
(1287, 'Gonçalo Passos', 'GONÇALO CORREIA PASSOS', 'goncalopassos@ua.pt', '6A53CE74-BFCD-4682-9393-516A9CF3B250', '', '', '', NULL, '2017-10-23'),
(1290, 'Gonçalo Pinto', 'GONÇALO DIOGO AUGUSTO RODRIGUES PINTO', 'goncalopinto@ua.pt', '0CABD920-5044-4D75-8FBE-8310387BBF43', '', '', '', NULL, '2013-09-12'),
(1293, 'Guilherme Moura', 'GUILHERME PAULO OLIVEIRA MOURA', 'gpmoura@ua.pt', '38F52836-4107-4EBB-8811-EA47AC6D4531', '', '', '', NULL, '2013-09-12'),
(1296, 'Guilherme Lopes', 'GUILHERME MATOS LOPES', 'guilherme.lopes@ua.pt', '0B016983-7B1E-46BF-83D9-007F5D78E0ED', '', '', '', NULL, '2017-10-23'),
(1299, 'Gustavo Neves', 'GUSTAVO NUNO NEVES FERREIRA', 'gustavo.neves@ua.pt', '4AE4151C-4599-42FC-B587-58023A92E7A3', '', '', '', NULL, '2016-03-04'),
(1302, 'Manso', 'HENRIQUE JOSÉ MARQUES MANSO', 'henrique.manso@ua.pt', '2DFB83A2-EEBC-46B8-BBE7-0DFFA3FDF7DC', '', '', '', NULL, '2013-09-12'),
(1305, 'Henrique Moreira', 'HENRIQUE MANUEL DE ALMEIDA MOREIRA', 'henrique.moreira@ua.pt', 'C778294E-8B32-4BFD-AFAA-62C6AAE0FCF9', '', '', '', NULL, '2013-09-24'),
(1308, 'Henrique Gonçalves', 'HENRIQUE EMANUEL OLIVEIRA GONÇALVES', 'henriqueoliveira@ua.pt', 'FED17B86-84DC-47CD-B7E5-9A341A11D674', '', '', '', NULL, '2013-09-15'),
(1311, 'Hugo Soares', 'HUGO EMANUEL DE OLIVEIRA SOARES', 'heos@ua.pt', '541D5C5E-1CF2-4763-BD52-6692EC4A8870', '', '', '', NULL, '2014-04-02'),
(1314, 'Hugo Oliveira', 'HUGO FILIPE FERREIRA OLIVEIRA', 'hffoliveira@ua.pt', '64745D10-EEBD-48CE-8FAF-96F88F07E2AA', '', '', '', NULL, '2014-09-17'),
(1317, 'Hugo Pintor', 'HUGO RAFAEL CAMPINOS PINTOR', 'hrcpintor@ua.pt', '347D34DE-3120-4F50-9407-B363FFB48518', '', 'https://www.linkedin.com/in/hugo-pintor/', '', NULL, '2014-09-15'),
(1320, 'Hugo Correia', 'HUGO ANDRÉ MARTINS CORREIA', 'hugo.andre@ua.pt', '519E3111-2CF4-4DAD-8C29-B0E6EE4BF09C', '', 'https://www.linkedin.com/in/hugo-correia-0985888b/', '', NULL, '2013-09-09'),
(1323, 'Hugo Santos', 'HUGO ANDRÉ FERREIRA DE ALMEIDA SANTOS', 'hugoandre@ua.pt', 'BF75A2F3-A6CC-4A54-A1BD-A38476700A6D', '', '', '', NULL, '2013-09-12'),
(1326, 'Hugo Ferreira', 'HUGO DINIS OLIVEIRA FERREIRA', 'hugodinis@ua.pt', 'BB7590A4-9C27-4F56-A892-FA8426EA681B', '', '', '', NULL, '1971-01-01'),
(1329, 'Hugo Almeida', 'HUGO FILIPE RIBEIRO PAIVA DE ALMEIDA', 'hugofpaiva@ua.pt', 'A08FAA58-5EB0-444F-B4D5-A538E5A915C5', '', 'https://www.linkedin.com/in/hugofpaiva/', '', NULL, '1971-01-01'),
(1332, 'Hugo Silva', 'HUGO MIGUEL OLIVEIRA E SILVA', 'hugomsilva@ua.pt', '8D5E7D6E-44E1-4A01-A9C8-A9E933175F6E', '', '', '', NULL, '2013-09-25'),
(1335, 'Inês Correia', 'INÊS GOMES CORREIA', 'ines.gomes.correia@ua.pt', '110C5947-2E01-48FA-8574-36536F06A212', '/upload/curriculos/1335.pdf', 'https://www.linkedin.com/in/in%C3%AAs-correia/', '', NULL, '2014-09-15'),
(1338, 'Inês Santos', 'INES DE OLIVEIRA SANTOS', 'ines.oliveira@ua.pt', '6D666A90-4C57-4FDF-A7D9-40DDA7930A08', '', '', '', NULL, '2013-09-12'),
(1341, 'Inês Leite', 'INÊS PINHO LEITE', 'ines.pl@ua.pt', '3095F985-9843-4EF4-A0DA-A1396CEE7AA3', '', '', '', NULL, '1971-01-01'),
(1344, 'Maria Rocha', 'MARIA INÊS SEABRA ROCHA', 'ines.seabrarocha@ua.pt', 'DEB666E5-3DB2-4E4F-A4B5-C3A1E5AD3077', '', '', '', NULL, '1971-01-01'),
(1347, 'Inês Pombinho', 'INÊS COSTA POMBINHO', 'inespombinho@ua.pt', '1353F351-E649-4D58-875E-E59E3601B131', '', '', '', NULL, '2017-10-23'),
(1350, 'Isadora Loredo', 'ISADORA FERREIRA LOREDO', 'isadora.fl@ua.pt', '7200E484-B90B-4257-9E57-60D9541A70E0', '/upload/curriculos/1350.pdf', 'https://www.linkedin.com/in/isadora-f-loredo/', 'https://github.com/flisadora', NULL, '1971-01-01'),
(1353, 'Isaac dos Anjos', 'ISAAC TOMÉ DOS ANJOS', 'itda@ua.pt', '6E2743D8-7B4E-43EB-9F9A-B80FE9B5FFE7', '/upload/curriculos/1353.pdf', '', '', NULL, '2017-05-27'),
(1356, 'Ivo Angélico', 'IVO ALEXANDRE COSTA ALVES ANGÉLICO', 'ivoangelico@ua.pt', '7D447F49-BD63-4C90-B3D1-ECD6F98F8A08', '', '', '', NULL, '2019-02-13'),
(1359, 'Jean Brito', 'Jean Brito', 'j.brito@ua.pt', 'B14C29C0-DB97-4276-845D-7B91B93F3FF7', '/upload/curriculos/1359.pdf', 'https://www.linkedin.com/in/britojean/', '', NULL, '2019-04-24'),
(1362, 'João Vasconcelos', 'JOÃO MIGUEL NUNES DE MEDEIROS E VASCONCELOS', 'j.vasconcelos99@ua.pt', '9B7FC8DC-465E-4C5D-A609-F46515BFF072', '/upload/curriculos/1362.pdf', 'https://www.linkedin.com/in/jo%C3%A3o-vasconcelos/', '', NULL, '2017-10-23'),
(1365, 'Joao Costa', 'JOÃO ARTUR DOS SANTOS MOREIRA DA COSTA', 'jarturcosta@ua.pt', '589DF9F1-6453-4869-B999-858C7F05F23B', '/upload/curriculos/1365.pdf', 'https://www.linkedin.com/in/jo%C3%A3o-artur-costa-328712146/', 'https://gitlab.com/jarturcosta', NULL, '2015-09-23'),
(1368, 'João Santos', 'JOÃO CARLOS PINTO SANTOS', 'jcps@ua.pt', '6F626743-2C65-4880-B520-FCF40BB31926', '', '', '', NULL, '2013-09-29'),
(1371, 'Soares', 'JOÃO FERREIRA SOARES', 'jfsoares@ua.pt', '70015803-03FE-4C5D-AE32-9D067A422F8F', '', '', '', NULL, '2015-09-23'),
(1374, 'João Catarino', 'JOÃO FRANCISCO TEIXEIRA CATARINO', 'jftcatarino@ua.pt', '3C5A4E24-0648-4AFF-AB20-74620471EFE3', '', '', '', NULL, '1971-01-01'),
(1377, 'João Gravato', 'JOÃO MIGUEL LOPES GRAVATO', 'jmlgravato@ua.pt', '7B31513F-1C0C-48A4-91DC-1A46D6FE1416', '', '', '', NULL, '2013-09-12'),
(1380, 'Joana Coelho', 'JOANA COELHO VIGÁRIO', 'joana.coelho@ua.pt', '9568B59A-B5E5-4E8D-BDAA-21B00EF08263', '', 'https://www.linkedin.com/in/joanacoelhovigario/', '', NULL, '2013-09-12'),
(1383, 'João Carvalho', 'JOÃO MIGUEL SANTOS CARVALHO', 'joao.carvalho19@ua.pt', 'A56441CD-9528-413E-8AAD-377E49AFFC05', '', '', '', NULL, '2018-12-07'),
(1386, 'João Faria', 'JOÃO DA SILVA FARIA', 'joao.faria00@ua.pt', '961FC997-E7D4-4E23-9BF7-982518CD3D5C', '', '', '', NULL, '2017-10-23'),
(1389, 'João Laranjo', 'JOÃO PEDRO DE MELO LARANJO', 'joao.laranjo@ua.pt', 'C7D9883A-22F2-4D83-97DF-FE0C4BB6D310', '', 'https://www.linkedin.com/in/joaolaranj0/', '', NULL, '2018-10-09'),
(1392, 'Joao Mourao', 'JOÃO MANUEL PALMARES MOURÃO', 'joao.mourao97@ua.pt', '339B8F99-6F03-4847-A9F1-65B249C9E780', '', '', '', NULL, '2015-09-23'),
(1395, 'Joao Marques', 'Joao Marques', 'joao.p.marques@ua.pt', '', '', '', '', NULL, '2019-06-24'),
(1398, 'João Pedro Alegria', 'JOÃO PEDRO SIMÕES ALEGRIA', 'joao.p@ua.pt', 'CC1CB549-04F7-4445-BDA9-B3DD36B72869', '/upload/curriculos/1398.pdf', '', '', NULL, '2018-01-11'),
(1401, 'Gold', 'JOÃO PEDRO SANTOS ROCHA', 'joao.pedro.rocha@ua.pt', '92071185-57B0-4208-AA38-B317B57C0613', '', '', '', NULL, '2013-09-12'),
(1404, 'João Almeida', 'JOÃO RAFAEL DUARTE DE ALMEIDA', 'joao.rafael.almeida@ua.pt', '988D005C-9110-4501-9F8D-CF8C868C1AB2', '', '', '', NULL, '2013-10-05'),
(1407, 'Joao Serpa', 'JOÃO CARREIRO SERPA', 'joao.serpa@ua.pt', 'AB9502DA-B04A-4310-97B8-85F427602D6A', '', '', '', NULL, '2015-09-23'),
(1410, 'João Ribeiro', 'JOÃO ANTÓNIO LOPES RIBEIRO', 'joaoantonioribeiro@ua.pt', '169CA622-6142-4BAC-8083-CD8BB0A7047C', '', 'https://www.linkedin.com/in/jo%C3%A3o-ribeiro-a76951168/', '', NULL, '2018-01-11'),
(1413, 'Joao Cruz', 'JOÃO PEDRO PINHO DA CRUZ', 'joaocruz@ua.pt', '94D83A7E-6C5C-495D-98F4-2EF6E861C933', '', '', '', NULL, '2015-09-23'),
(1416, 'João Carvalho', 'JOÃO FILIPE MAGALHÃES CARVALHO', 'joaofcarvalho@ua.pt', '8762767F-F805-441F-8F45-4E0E38A941F2', '', '', '', NULL, '2014-09-15'),
(1419, 'Joao Ferreira', 'JOÃO GUILHERME MENDONÇA PIMENTA DE OLIVEIRA FERREIRA', 'joaogferreira@ua.pt', 'A7CC0EB3-724C-4B2A-B9B6-E1222158E77A', '', '', '', NULL, '2015-09-23'),
(1422, 'João Limas', 'JOÃO RENATO PINTO LIMAS', 'joaolimas@ua.pt', 'A608E4D0-FCCB-42DA-AAA5-C70BFEC03B99', '', 'https://www.linkedin.com/in/joao-limas/', '', NULL, '2013-09-12'),
(1425, 'Joao Dias', 'JOÃO MIGUEL ABRANTES DIAS', 'joaomadias@ua.pt', 'AE87359F-C162-4085-AAD2-7099B5CFA5AF', '', '', '', NULL, '2019-03-27'),
(1428, 'João Dias', 'JOÃO MIGUEL SERRAS DIAS', 'joaomdias@ua.pt', '850A054B-F4FF-498A-A7CB-557EC3D38A6C', '', '', '', NULL, '2017-10-23'),
(1431, 'João Lourenço', 'JOÃO MIGUEL ISIDORO DA ROCHA LOURENÇO', 'joaomiguellourenco@ua.pt', 'BF89508C-AF78-40D8-BA28-F5D5EB4C0ADC', '', '', '', NULL, '1971-01-01'),
(1434, 'João Nogueira', 'JOÃO EDUARDO ALVES NOGUEIRA', 'joaonogueira20@ua.pt', '1638DD9E-49B2-48B3-82E1-2B789C09D75E', '', '', '', NULL, '2017-10-23'),
(1437, 'João Paúl', 'JOÃO ANTÓNIO CALISTO PAÚL', 'joaopaul@ua.pt', '24FD9E12-64E1-4833-B345-F4317B778737', '', '', '', NULL, '2014-09-15'),
(1440, 'João Martins', 'JOÃO PEDRO MARTINS GONÇALVES', 'joaopmg96@ua.pt', '4F43F42B-3496-4AF2-9C6C-FF4BC4F3A216', '', '', '', NULL, '2014-09-17'),
(1443, 'João Pedrosa', 'JOÃO PEDRO OLIVEIRA PEDROSA', 'joaoppedrosa@ua.pt', '08E09FA7-C16B-4582-87AC-873B452313B9', '', '', '', NULL, '2013-10-18'),
(1446, 'João Vasconcelos', 'JOÃO PEDRO LACERDA VASCONCELOS', 'joaopvasconcelos@ua.pt', 'E525FE41-FC06-4CA1-8CBF-C25095FF6534', '', '', '', NULL, '2018-12-15'),
(1449, 'João Campos', 'JOÃO RICARDO ANTUNES CAMPOS', 'joaoricardoantunescampos@ua.pt', '601E1072-5A3E-4F1F-9AA0-57F3FCB2E5ED', '', '', '', NULL, '2014-09-17'),
(1452, 'Joao Abilio Rodrigues', 'JOÃO ABÍLIO DA SILVA RODRIGUES', 'joaosilva9@ua.pt', '2F81E704-6632-43B7-8B3F-46CCE4BBDDFA', '/upload/curriculos/1452.pdf', 'https://www.linkedin.com/in/joaoarodrigues9', '', NULL, '2017-10-22'),
(1455, 'João Alegria', 'JOÃO TIAGO FARIA ALEGRIA', 'joaotalegria@ua.pt', '3865AA07-9DFB-4157-801B-D136D22E1244', '', 'https://www.linkedin.com/in/jtalegria/', '', NULL, '2013-09-12'),
(1458, 'Joao Tomaz', 'JOÃO DANIEL GOMES TOMAZ', 'joaotomaz@ua.pt', 'A918FB1F-3924-4A84-8965-D90F9B4E1A2A', '', '', '', NULL, '2014-09-15'),
(1461, 'João Soares', 'JOÃO TEIXEIRA SOARES', 'joaots@ua.pt', 'D18FF07E-2577-47D0-B038-94D5AE7CA829', '', '', '', NULL, '1971-01-01'),
(1464, 'Jorge Fernandes', 'JORGE FRANCLIM MARTINS NASCIMENTO FERNANDES', 'jorge.fernandes@ua.pt', 'FA37FBF2-2797-48BB-B86F-D5AC58819379', '', 'https://www.linkedin.com/in/jorge-fernandes/', '', NULL, '2013-10-10'),
(1467, 'Jorge Pimenta', 'JORGE HUMBERTO E SOUSA PIMENTA', 'jorge.pimenta@ua.pt', 'A6E05F3E-E29B-41F7-89B0-1E642A55C0D8', '', '', '', NULL, '2013-09-24'),
(1470, 'Jorge Leite', 'JORGE BARROCAS LEITE', 'jorgeleite@ua.pt', '8059E358-46BC-4F3D-AEF6-5FE398DE8FAA', '', '', '', NULL, '1971-01-01'),
(1473, 'José Santos', 'JOSÉ PEDRO VAZ SANTOS', 'jose.vaz@ua.pt', '46C75291-8FC7-4A8B-B19A-902DAA0717D5', '', '', '', NULL, '2017-10-23'),
(1476, 'José Frias', 'JOSÉ ANDRÉ LOPES FRIAS', 'josefrias99@ua.pt', '6E752B76-0600-42D1-A8D6-36ACE20E8BC8', '', '', '', NULL, '2017-10-23'),
(1479, 'José Sousa', 'JOSÉ LUCAS MIMOSO DONAS BOTTO SOUSA', 'joselmdbsousa@ua.pt', '9CA67BF3-30F1-4E86-9EB9-135F5557CA5B', '', '', '', NULL, '1971-01-01'),
(1482, 'José Pedro', 'JOSÉ PEDRO ALVES FERREIRA DO CARMO', 'josepedrocarmo@ua.pt', 'E8CE6C40-94CF-48A3-85A3-DA9F93616E26', '', '', '', NULL, '2013-11-07'),
(1485, 'Jose Moreira', 'JOSÉ PEDRO PINTO MOREIRA', 'joseppmoreira@ua.pt', '2B61A8A7-D3E2-4F16-B70B-18F66EEA7920', '', '', '', NULL, '2015-09-23'),
(1488, 'Jose Ribeiro', 'Jose Ribeiro', 'josepribeiro@ua.pt', '', '', '', '', NULL, '2019-05-20'),
(1491, 'José Rego', 'JOSÉ FILIPE DIAS REGO', 'joserego@ua.pt', 'A3F5D504-8663-4107-9679-6E3E33F5AD7F', '', '', '', NULL, '2013-09-12'),
(1494, 'José Reis', 'JOSÉ FILIPE RIBAS DOS SANTOS REIS', 'josereis@ua.pt', '3250B11C-63AC-4DAD-AD59-2D16550CC3CF', '', '', '', NULL, '2013-10-11'),
(1497, 'José Sá', 'JOSÉ AUGUSTO DE GÓIS RODRIGUES DE SÁ', 'josesa@ua.pt', '497AF720-BEA4-49B6-BEB2-46C3C5E6C40A', '', '', '', NULL, '2013-09-29'),
(1500, 'Josimar Cassandra', 'JOSIMAR DOS PRAZERES BENEDITO CASSANDRA', 'josimarcassandra@ua.pt', '5DF16216-8395-4FF1-B629-6A792B8E9CA9', '', 'https://www.linkedin.com/in/josimar-cassandra-28888b11b/', '', NULL, '2013-09-12'),
(1503, 'João Pereira', 'JOÃO PEDRO FERNANDES PEREIRA', 'jpedro@ua.pt', 'A03A64C6-AA0C-49EB-8E28-E667E662B122', '', '', '', NULL, '2013-10-15'),
(1506, 'José Gonçalves', 'JOSÉ PEDRO DOMINGUES GONÇALVES', 'jpedrogoncalves@ua.pt', '311F08A8-B708-4950-BBC7-91C2780BFBD1', '', '', '', NULL, '2018-01-11'),
(1509, 'João Gonçalves', 'JOÃO PEDRO PINO GONÇALVES', 'jpedropino@ua.pt', 'BC060265-0D1A-4DB2-AF73-B616293D4256', '', '', '', NULL, '2014-09-15'),
(1512, 'Joao Magalhaes', 'JOÃO RICARDO SANTANA RIBEIRO MAGALHÃES', 'jrsrm@ua.pt', '9528C242-2E32-401E-8F2F-788941F01B28', '', '', '', NULL, '2015-09-23'),
(1515, 'Luís Oliveira', 'LUÍS FILIPE PINTO OLIVEIRA', 'l.f.p.o@ua.pt', '1000B683-5AE8-4724-A510-B66456B079E5', '', '', '', NULL, '2013-09-24'),
(1518, 'Luís Rêgo', 'LUÍS ALVES DE SOUSA RÊGO', 'lasr@ua.pt', 'DA0FF020-911B-4263-8E39-2105E8715C7E', '', '', '', NULL, '2018-12-09'),
(1521, 'Leandro Silva', 'LEANDRO EMANUEL SOARES ALVES DA SILVA', 'leandrosilva12@ua.pt', 'AC4E9C03-8C71-4B0E-AF0F-B072868BEBA2', '/upload/curriculos/1521.pdf', '', '', NULL, '1971-01-01'),
(1524, 'Luís Miguel Costa', 'LUÍS MIGUEL DIAS DOS SANTOS PEREIRA DA COSTA', 'lmcosta98@ua.pt', '9817C75D-ED1C-46A4-86AF-199C5CD7B472', '', '', '', NULL, '2018-01-11'),
(1527, 'Francisco Lopes', 'FRANCISCO QUADRADO LOPES', 'lopes.francisco@ua.pt', '53F43B53-2FBD-4A4B-BB8C-118032833B97', '', '', '', NULL, '2014-09-15'),
(1530, 'Luís Cardoso', 'LUÍS PEDRO CARDOSO', 'lpcardoso@ua.pt', 'CBC71464-4CF1-4E6B-B6B1-B1433C38EFED', '', '', '', NULL, '2018-01-11'),
(1533, 'Tiago Santos', 'TIAGO LUIS SALGUEIRO DOS SANTOS', 'ltiagosantos@ua.pt', 'B32FD58A-04F0-4EBD-8739-068F6127E2B2', '', '', '', NULL, '2013-10-21'),
(1536, 'Lucas Silva', 'LUCAS AQUILINO ALMEIDA DA SILVA', 'lucasaquilino@ua.pt', '904CFA62-ED8E-46A0-B8A3-D967EC34EBBB', '', '', '', NULL, '2018-01-11'),
(1539, 'Lucas Barros', 'LUCAS FILIPE ROBERTO DE BARROS', 'lucasfrb45@ua.pt', 'CCE70F43-70A4-4A7B-867A-A8D42E4E2E5C', '', '', '', NULL, '2018-01-11'),
(1542, 'Luís Pereira', 'LUÍS ANTÓNIO CASTRO MORAIS PINTO PEREIRA', 'luis.pinto.pereira@ua.pt', '7C0AE4E2-DC10-496D-8F26-F674FC154753', '', '', '', NULL, '1971-01-01'),
(1545, 'Luís Fonseca', 'LUÍS CARLOS DUARTE FONSECA', 'luiscdf@ua.pt', '3B5E7C5A-71C8-4853-A188-1C4C11FDD642', '', '', '', NULL, '2017-10-23'),
(1548, 'Luís Silva', 'LUÍS FILIPE GUEDES BORGES DA SILVA', 'luisfgbs@ua.pt', '937406ED-D4C5-48F8-A585-98236F77BED9', '', '', '', NULL, '2017-10-23'),
(1551, 'Luis Santos', 'LUIS FILIPE ALMEIDA SANTOS', 'luisfsantos@ua.pt', '2150D9AB-7CF5-4EB4-BDD1-7C9F3EF11713', '', 'https://www.linkedin.com/in/luis-filipe-santos-2510/', '', NULL, '2013-09-18'),
(1554, 'Luís Oliveira', 'LUÍS ANDRÉ PAIS ALVES DE OLIVEIRA', 'luisoliveira98@ua.pt', 'F53C29C5-533C-4465-A909-16DBE4F6299B', '', '', '', NULL, '2018-01-11'),
(1557, 'Luís Valetim', 'LUÍS MIGUEL GOULART VALENTIM', 'lvalentim@ua.pt', '3CDE541D-3BE9-4432-B1C2-D5F9F9B1E744', '', '', '', NULL, '1971-01-01'),
(1560, 'Maria Lopes', 'MARIA SALOMÉ FIGUEIRA LOPES', 'm.lopes1@ua.pt', '63826462-8106-4F35-B9CC-5BB25CC38D33', '', '', '', NULL, '2015-09-23'),
(1563, 'Gonçalo Ferreira', 'GONÇALO MACÁRIO FERREIRA', 'macario.goncalo@ua.pt', '2D4F1C1E-6958-40E6-9198-179836B50A55', '', '', '', NULL, '2013-09-12'),
(1566, 'Andreia Machado', 'ANDREIA RAQUEL FILIPE MACHADO', 'machadoandreia@ua.pt', 'AD211965-137B-45DB-9DB1-2857A5CF7DAA', '', '', '', NULL, '2014-09-17'),
(1569, 'Manuel Marcos', 'MANUEL CURA MARCOS', 'manuel.cura@ua.pt', '3231D5EA-10B7-48F1-AE02-5C5F6236E415', '', '', '', NULL, '2014-09-17'),
(1572, 'Manuel Felizardo', 'MANUEL ANTÓNIO FELIZARDO ROXO', 'manuel.felizardo@ua.pt', '23994C79-C4F1-4AE2-B4AE-3BD6B19CFF41', '', '', '', NULL, '2015-09-23'),
(1575, 'Manuel Gil', 'MANUEL JOÃO BALTAZAR GIL', 'manuel.gil@ua.pt', 'DD6E142F-010E-4006-A0F3-63CE940D1D35', '', '', '', NULL, '2013-09-24'),
(1578, 'Manuel Roda', 'MANUEL LUÍS VALENTE RODA', 'manuel.roda@ua.pt', '81E78F6D-F58C-4582-A01B-0849D3499735', '', '', '', NULL, '2014-09-17'),
(1581, 'Marcelo Cardoso', 'MARCELO JOSÉ FIGUEIREDO CARDOSO', 'marcelocardoso@ua.pt', 'CB7EE087-4425-4981-8E08-E48B7E40334F', '', '', '', NULL, '2013-09-24'),
(1584, 'Marcelo Génio', 'MARCELO PEREIRA GÉNIO', 'marcelog@ua.pt', 'D2F7C1A8-49E0-4D50-A9F3-AA06D731B261', '', '', '', NULL, '2013-09-25'),
(1587, 'Márcia', 'MÁRCIA DE CARVALHO CARDOSO', 'marciaccardoso@ua.pt', '7C66D413-A9A8-46CC-A83E-EA1B42516D72', '', '', '', NULL, '2015-09-23'),
(1590, 'Márcio Fernandes', 'MÁRCIO ANDRÉ NOGUEIRA FERNANDES', 'marcioafernandes@ua.pt', 'E21F145B-A4B7-4E72-8AE6-A058D5FEA267', '', '', '', NULL, '2013-09-12'),
(1593, 'Marco Miranda', 'MARCO RODRIGUES MIRANDA', 'marco.miranda@ua.pt', '040D58CA-41EC-4245-8DE8-EC560F275B3D', '', '', '', NULL, '2013-09-12'),
(1596, 'Marco Ventura', 'MARCO ANDRÉ MORAIS VENTURA', 'marcoandreventura@ua.pt', 'FA796E0B-BA72-4756-82B9-AA0B486ECED7', '/upload/curriculos/1596.pdf', '', '', NULL, '2014-09-15'),
(1599, 'Marcos Silva', 'MARCOS OLIVEIRA MOREIRA DA SILVA', 'marcossilva@ua.pt', 'ECABF47F-0A5A-4EFD-B157-4AC9AAC6E261', '', 'https://www.linkedin.com/in/marcos-silva-a64b7850/', '', NULL, '2013-09-09'),
(1602, 'Margarida Martins', 'MARGARIDA SILVA MARTINS', 'margarida.martins@ua.pt', 'A2FF0A2A-52F1-45E6-8869-B9DD2340E385', '/upload/curriculos/1602.pdf', 'https://www.linkedin.com/in/margarida-martins-140086173/', '', NULL, '1971-01-01'),
(1605, 'Mariana Gameiro', 'MARIANA BALUGA GAMEIRO', 'mari.gameiro@ua.pt', '2E566B1B-75A1-4B72-81C2-4CD0565D14CF', '', '', '', NULL, '2017-10-23'),
(1608, 'Mariana Ladeiro', 'MARIANA BACÊLO LADEIRO', 'marianaladeiro@ua.pt', '18F478C2-84DB-4150-AFB7-DB40D509CCD6', '', '', '', NULL, '1971-01-01'),
(1611, 'Mariana Santos', 'MARIANA SOUSA PINHO SANTOS', 'marianasps@ua.pt', '945900A4-7A8E-4998-B935-E85206B02E8D', '', '', '', NULL, '1971-01-01'),
(1614, 'Marina Wischert', 'MARINA FARIAS WISCHERT', 'marinawischert@ua.pt', 'D536B8F0-EE1F-410C-BFFF-E0B4DAA437AA', '', '', '', NULL, '2013-09-12'),
(1617, 'Mário Correia', 'MÁRIO JORGE LOPES CORREIA', 'mariocorreia@ua.pt', '67C01E23-6771-4449-843B-8B04E985EA88', '', '', '', NULL, '2014-04-01'),
(1620, 'Mário Silva', 'MÁRIO FRANCISCO COSTA SILVA', 'mariosilva@ua.pt', 'A5D099D7-4F7F-4382-874C-59078B7E6DEF', '', '', '', NULL, '1971-01-01'),
(1623, 'André Cardoso', 'ANDRÉ FILIPE MARQUES CARDOSO', 'marquescardoso@ua.pt', 'DBC00079-CCFF-4FE8-8FB6-4DFCEBBFF9B7', '', '', '', NULL, '2015-09-21'),
(1626, 'Marta Ferreira', 'MARTA SEABRA FERREIRA', 'martasferreira@ua.pt', '8FA9F1BD-7E8A-45F0-BF41-7B3F7A6282AD', '', 'https://www.linkedin.com/in/marta-sferreira/', '', NULL, '2017-10-23'),
(1629, 'Maxlaine Moreira', 'MAXLAINE SILVA MOREIRA', 'maxlainesmoreira@ua.pt', 'CCE9E2A9-F921-4A84-9CD4-86E9D008BEB9', '', '', '', NULL, '2013-09-24'),
(1632, 'Miguel Araújo', 'MIGUEL DIOGO FERRAZ ARAÚJO', 'mdaraujo@ua.pt', '9A40CB93-7894-4BC7-8BDC-44FE472EB056', '', '', '', NULL, '2019-01-06'),
(1635, 'Ana Mendes', 'ANA FILIPA VINHAS MENDES', 'mendesana@ua.pt', 'B963547E-D8AE-40BA-A8E2-BB3BC9D67E4A', '', '', '', NULL, '2013-09-18'),
(1638, 'Mariana Sequeira', 'MARIANA FIGUEIREDO SEQUEIRA', 'mfs98@ua.pt', '39C30989-D52C-4943-BDDF-A9836BCABDA5', '', 'https://www.linkedin.com/in/mariana-sequeira-82a811171/', '', NULL, '2018-01-11'),
(1641, 'Micael Mendes', 'MICAEL MARQUES MENDES', 'micaelmendes@ua.pt', '031DB6CD-F6B0-47CB-8E65-7584E3EC2A8D', '', '', '', NULL, '2015-09-23'),
(1644, 'Miguel Fradinho', 'MIGUEL FRADINHO ALVES', 'miguel.fradinho@ua.pt', '705A65FE-A078-4BEF-B7DE-3770BC49D5C3', '/upload/curriculos/1644.pdf', '', '', NULL, '2018-12-05'),
(1647, 'Miguel Mota', 'MIGUEL MARTINS MOTA', 'miguel.mota@ua.pt', 'DDE195D9-090B-42F7-B9BC-3FFB2F1466B8', '', '', '', NULL, '2017-10-23'),
(1650, 'Miguel Santos', 'VÍTOR MIGUEL CASTANHEIRA DOS SANTOS', 'miguel.santos@ua.pt', '394DDFA9-67C4-42C3-B271-F060AB14E3B3', '', '', '', NULL, '2014-03-31'),
(1653, 'Miguel Antunes', 'MIGUEL ÂNGELO FARINHA ANTUNES', 'miguelaantunes@ua.pt', 'E474FAEA-769D-4ABC-86CA-3C6AC906E1D4', '', 'https://www.linkedin.com/in/miguel-antunes/', '', NULL, '2013-09-12'),
(1656, 'Miguel Angelo Da Costa Rodrigu', 'MIGUEL ÂNGELO DA COSTA RODRIGUES', 'miguelangelorodrigues@ua.pt', '4FD1462C-6C7D-412F-9F16-9D65DC130612', '', '', '', NULL, '2014-11-11'),
(1659, 'Miguel Matos', 'MIGUEL FILIPE CARVALHAIS DOS SANTOS DE MATOS', 'miguelcarvalhaismatos@ua.pt', 'C3DA7E5D-013E-4A35-9084-963D362BCDED', '', '', '', NULL, '2014-09-17'),
(1662, 'Luís Castro', 'LUÍS MIGUEL SANTOS CASTRO', 'miguelcastro@ua.pt', 'A6D80A43-214F-4609-A5A8-3BDCC04F2920', '', '', '', NULL, '2014-09-17'),
(1665, 'Miguel Matos', 'MIGUEL CRUZ MATOS', 'miguelcruzmatos@ua.pt', '625E0BF7-67B2-4FF3-BD97-13736F336726', '', '', '', NULL, '2017-10-23'),
(1668, 'Miguel Santos', 'JOÃO MIGUEL VALENTE DOS SANTOS', 'miguelsantos@ua.pt', '4B6E7539-B628-4DA5-AC50-2C185EEA431D', '', '', '', NULL, '2014-04-02'),
(1671, 'Miguel Simoes', 'MIGUEL MARQUES SIMÕES', 'mmsimoes@ua.pt', '9A15CED1-2546-4EB4-9DA8-6FEA1D679B33', '', '', '', NULL, '2015-09-23'),
(1674, 'André Morais', 'ANDRÉ FILIPE MONIZ MORAIS', 'moraisandre@ua.pt', '777366FB-58C9-4D6C-87B5-6625532C46E5', '', 'https://www.linkedin.com/in/andre-moniz-morais/', '', NULL, '1971-01-01'),
(1677, 'Yuriy Muryn', 'YURIY MURYN', 'murynyuriy@ua.pt', 'FCC43FE4-92ED-4087-8CFD-5F25614E98B9', '', '', '', NULL, '2014-09-17'),
(1680, 'Neusa Barbosa', 'NEUSA SOFIA LOPES BARBOSA', 'neusa.barbosa@ua.pt', '7CAB7DE2-CE2D-41FE-A8B7-A3E6A1FE68FF', '', '', '', NULL, '2019-02-25'),
(1683, 'Nuno Cardoso', 'NUNO MIGUEL DE SOUSA CARDOSO', 'nmsc@ua.pt', '5957B054-04F7-429C-A8B5-925E9B3E8940', '', '', '', NULL, '2013-09-25'),
(1686, 'Nuno Aparicio', 'Nuno Aparicio', 'nuno.aparicio@ua.pt', '', '', '', '', NULL, '2019-05-20'),
(1689, 'Nuno Matamba', 'NUNO ALEXANDRE GOMES MATAMBA', 'nuno.matamba@ua.pt', 'DE62AE7E-E45D-4311-8891-1887F6D2D283', '', '', '', NULL, '2015-09-24'),
(1692, 'Nuno Silva', 'NUNO FILIPE MACHADO LOPES DA SILVA', 'nuno1@ua.pt', 'A8626D6D-2B31-4523-9609-C68FFE574A11', '', '', '', NULL, '2015-09-23'),
(1695, 'Olga Oliveira', 'OLGA MARGARIDA FAJARDA OLIVEIRA', 'olga.oliveira@ua.pt', 'D81DB24D-ACFC-4056-AD2C-65AF00210470', '', '', '', NULL, '2013-09-12'),
(1698, 'Orlando Macedo', 'ORLANDO JORGE RIBEIRO MACEDO', 'orlando.macedo15@ua.pt', '76D84966-DFCC-4D5E-8319-AC6010DF0700', '', '', '', NULL, '1971-01-01'),
(1701, 'Paulo Seixas', 'PAULO ALEXANDRE MARTINS SEIXAS', 'p.seixas96@ua.pt', '9ED1E631-9CE0-456D-AF89-6FE709732A92', '', 'https://www.linkedin.com/in/pauloamseixas/', '', NULL, '2014-09-17'),
(1704, 'Andreia Patrocinio', 'ANDREIA FILIPA MARTINS PATROCÍNIO', 'patrocinioandreia@ua.pt', '29B7A3BD-BC5F-484E-BE0B-2DA2E865FC8A', '/upload/curriculos/1704.pdf', '', '', NULL, '2015-09-23'),
(1707, 'Paulo Oliveira', 'PAULO JORGE NASCIMENTO DE OLIVEIRA', 'paulo.nascimento@ua.pt', '058BFF3D-53B0-46E8-AE2C-1277EFA99786', '', '', '', NULL, '2013-09-12'),
(1710, 'Paulo Pintor', 'PAULO SÉRGIO OLIVEIRA PINTOR', 'paulopintor@ua.pt', '033F2231-7E9F-40BA-8269-921BB7E4562E', '', 'https://www.linkedin.com/in/paulo-pintor/', '', NULL, '2013-10-15'),
(1713, 'Pedro Amaral', 'PEDRO MIGUEL LOUREIRO AMARAL', 'pedro.amaral@ua.pt', '8E7FAB88-0F36-4824-8103-25257F6FB9D8', '', '', '', NULL, '1971-01-01'),
(1716, 'Pedro Bastos', 'PEDRO MIGUEL BASTOS DE ALMEIDA', 'pedro.bas@ua.pt', '6671B2E9-0A68-4806-A16F-13CDEA958BFA', '', '', '', NULL, '1971-01-01'),
(1719, 'Pedro Ferreira', 'PEDRO JOSÉ GOMES FERREIRA', 'pedro.joseferreira@ua.pt', '8A248D9E-DA97-45C1-A10F-0E7594059860', '/upload/curriculos/1719.pdf', 'https://www.linkedin.com/in/pedro-ferreira-1a6756153/', '', NULL, '2018-01-11'),
(1722, 'Pedro Santos', 'PEDRO MIGUEL ALMEIDA SANTOS', 'pedro.miguel50@ua.pt', '025A4C5B-B629-46C1-9184-580C1032909C', '', '', '', NULL, '1971-01-01'),
(1725, 'Pedro Miguel Oliveira Costa', 'PEDRO MIGUEL OLIVEIRA COSTA', 'pedro.oliveira.costa@ua.pt', '85A9B0C2-3B84-474D-A2B5-8D62C5C1102C', '', '', '', NULL, '2017-05-27'),
(1728, 'Pedro Fernandes', 'PEDRO ALEXANDRE SANTOS FERNANDES', 'pedroafernandes@ua.pt', 'C83D9721-A4A9-435A-9A12-13F496F1674B', '', '', '', NULL, '2013-10-09'),
(1731, 'Pedro Dias', 'PEDRO ARTUR AFONSO DIAS', 'pedroafonsodias@ua.pt', 'F2285129-947B-4530-B0B3-39EF6841B2C4', '', '', '', NULL, '2013-09-15'),
(1734, 'Pedro Marques', 'PEDRO ALEXANDRE GONÇALVES MARQUES', 'pedroagoncalvesmarques@ua.pt', 'EA5279B0-0B1F-4421-AA04-EDE259F76780', '', '', '', NULL, '1971-01-01'),
(1737, 'Pedro Candoso', 'PEDRO BARBOSA CANDOSO', 'pedrocandoso2@ua.pt', '58DCED63-E656-4761-A9AF-9D50B8126A3F', '', '', '', NULL, '2018-01-11'),
(1740, 'Pedro Cavadas', 'PEDRO XAVIER LEITE CAVADAS', 'pedrocavadas@ua.pt', 'A3D697F1-5DCA-4405-93EC-6FD2D4C9AF26', '', '', '', NULL, '2018-01-11'),
(1743, 'Pedro Tavares', 'PEDRO DINIS BASTOS TAVARES', 'pedrod33@ua.pt', '7AFB2BC0-EF13-4D8C-AB91-2EF249CA7CEA', '', '', '', NULL, '1971-01-01'),
(1746, 'Pedro Fajardo', 'PEDRO MIGUEL OLIVEIRA FAJARDO', 'pedrofajardo98@ua.pt', '12EEEE5A-AD7D-4056-892A-04CE572B97EF', '', '', '', NULL, '2018-01-11'),
(1749, 'Pedro Fonseca', 'PEDRO MIGUEL LOPES DA FONSECA', 'pedrofonseca98@ua.pt', '42B04729-4FEF-460C-BE1A-B66DB4F81DC2', '/upload/curriculos/1749.pdf', '', '', NULL, '2018-01-11'),
(1752, 'Pedro Matos', 'PEDRO GUILHERME SILVA MATOS', 'pedroguilhermematos@ua.pt', 'AEC02114-337E-4F69-B559-9ABEB88DEFAA', '', 'https://www.linkedin.com/in/matos-pedro/', '', NULL, '2016-03-14'),
(1755, 'Pedro Matos', 'PEDRO DAVID LOPES MATOS', 'pedrolopesmatos@ua.pt', 'CBCF6FBB-1707-4163-A51D-FA7FD003D1D6', '', '', '', NULL, '2018-01-11'),
(1758, 'Pedro Souto', 'PEDRO MIGUEL GOMES DE ALMEIDA SOUTO', 'pedromgsouto@ua.pt', '44278869-CBA7-4B9B-BD33-849DEC8E6B79', '', '', '', NULL, '1971-01-01'),
(1761, 'Pedro Miguel', 'PEDRO MIGUEL FERREIRA MARQUES', 'pedromm@ua.pt', '2D34958A-AE4D-46BD-949F-12294AC356FD', '', '', '', NULL, '2018-12-07'),
(1764, 'Pedro Oliveira', 'PEDRO MIGUEL ROCHA OLIVEIRA', 'pedrooliveira99@ua.pt', 'E0854A60-C9D4-4181-A6D7-13668AF40266', '/upload/curriculos/1764.pdf', 'https://www.linkedin.com/in/pedromroliveira/', '', NULL, '2017-10-23'),
(1767, 'Gonçalo Pereira', 'GONÇALO DA COSTA PEREIRA', 'pereira.goncalo@ua.pt', '9B26B8A1-063D-44BF-8590-E75C8FE97D29', '', '', '', NULL, '1971-01-01'),
(1770, 'Jorge Pereira', 'JORGE MIGUEL ANTUNES PEREIRA', 'pereira.jorge@ua.pt', '0EEE15DC-CD62-4F43-AA88-0BAE7764DE27', '', 'https://www.linkedin.com/in/jorge-pereira-956095178/', '', NULL, '2013-09-12'),
(1773, 'Hélio Pesanhane', 'HÉLIO SALOMÃO PESANHANE', 'pesanhane@ua.pt', '81EDA7F9-27ED-4EA3-AF65-646E9B5F9296', '', '', '', NULL, '2013-10-05'),
(1776, 'João Rodrigues', 'JOÃO PEDRO GONÇALVES RODRIGUES', 'pgr96@ua.pt', 'C112BC74-FF42-4060-A339-18ECF2D11D06', '', 'https://www.linkedin.com/in/pedro-rodrigues-36b295139/', '', NULL, '2014-09-17'),
(1779, 'Pedro Casimiro', 'PEDRO LARANJINHA CASIMIRO', 'plcasimiro@ua.pt', '0F0774DE-E454-41CE-B0C7-6EBF66820B82', '', '', '', NULL, '1971-01-01'),
(1782, 'Pedro Silva', 'PEDRO MIGUEL ALVES SILVA', 'pmasilva20@ua.pt', 'A4B4B85D-CE88-48EE-B02F-8AE1763F1527', '', '', '', NULL, '1971-01-01'),
(1785, 'Pedro Neves', 'PEDRO MIGUEL PEREIRA NEVES', 'pmn@ua.pt', 'BA870AB8-87E0-40D7-87F2-1C4A209DE41F', '', '', '', NULL, '2013-09-12'),
(1788, 'Pedro Pires', 'PEDRO TEIXEIRA PIRES', 'ptpires@ua.pt', '2C9EB760-267A-4987-B926-89148B8E5DC7', '', 'https://www.linkedin.com/in/el-pires/', '', NULL, '2015-09-23'),
(1791, 'Rui Jesus', 'RUI FILIPE RIBEIRO JESUS', 'r.jesus@ua.pt', '3E743B4C-D130-4134-8A20-08A6925623BB', '', '', '', NULL, '2015-09-23');
INSERT INTO aauav_nei.user (id, name, full_name, uu_email, uu_iupi, curriculo, linkedin, git, permission, created_at) VALUES
(1794, 'Rui Melo', 'RUI FILIPE COIMBRA PEREIRA DE MELO', 'r.melo@ua.pt', '7EB9EABE-2838-4FFA-AF04-E28CC73EFF3C', '', '', '', NULL, '2017-10-23'),
(1797, 'Ricardo Antão', 'RICARDO NUNO DE LIMA ANTÃO', 'r.n.l.a@ua.pt', '3754DDDA-7400-4964-8423-3249FDAC6B13', '', '', '', NULL, '2013-09-25'),
(1800, 'Rafael Direito', 'RAFAEL DAS NEVES SIMÕES DIREITO', 'rafael.neves.direito@ua.pt', '841B00B4-DC68-42B4-AC21-531081E66FD3', '/upload/curriculos/1800.pdf', '', '', NULL, '2017-10-22'),
(1803, 'Rafael Baptista', 'RAFAEL FERREIRA BAPTISTA', 'rafaelbaptista@ua.pt', 'D2523B84-7133-43F3-8410-6C255DF94D09', '', '', '', NULL, '1971-01-01'),
(1806, 'Rafael Teixeira', 'RAFAEL GONÇALVES TEIXEIRA', 'rafaelgteixeira@ua.pt', '32039F55-1583-4DE1-B88A-030785C6EEAF', '/upload/curriculos/1806.pdf', 'https://www.linkedin.com/in/rafael-teixeira-652618170/', '', NULL, '2018-01-11'),
(1809, 'Rafael Simões', 'RAFAEL JOSÉ SANTOS SIMÕES', 'rafaeljsimoes@ua.pt', 'B8F34D36-6564-43D2-9AD1-89BDB6CF48B2', '/upload/curriculos/1809.pdf', 'https://www.linkedin.com/in/rafael-simões-60958b173', '', NULL, '2017-10-23'),
(1812, 'Raul VilasBoas', 'RAUL VILAS BOAS', 'raulvilasboas97@ua.pt', 'EE7550C7-3A2E-4B89-B3AD-300A435ECAE0', '', '', '', NULL, '2015-09-23'),
(1815, 'Renan Ferreira', 'RENAN ALVES FERREIRA', 'renanaferreira@ua.pt', '31FD00B0-3E42-4FA8-AF2D-2E6695E39EF2', '/upload/curriculos/1815.pdf', '', '', NULL, '1971-01-01'),
(1818, 'Renato Duarte', 'RENATO VALENTE DUARTE', 'renato.duarte@ua.pt', 'A621A8D7-0AB2-4027-B133-8C0BFBD62D74', '', '', '', NULL, '2013-09-12'),
(1821, 'Rui Fernandes', 'RUI FILIPE MONTEIRO FERNANDES', 'rfmf@ua.pt', '0BBEFA9E-590B-4B1D-AB57-273BC3E3C1DB', '', '', '', NULL, '1971-01-01'),
(1824, 'João Peixe Ribeiro', 'JOÃO GONÇALO PEIXE RIBEIRO', 'ribeirojoao@ua.pt', '727C7ECB-12BC-47AD-B743-064D5A48EE87', '', 'https://www.linkedin.com/in/joao-peixe-ribeiro/', '', NULL, '2013-09-12'),
(1827, 'Ricardo Cruz', 'RICARDO SARAIVA DA CRUZ', 'ricardo.cruz29@ua.pt', '1D65A881-CD4E-4428-BD3C-B7C680CD0B3D', '', '', '', NULL, '1971-01-01'),
(1830, 'Ricardo Lucas', 'RICARDO JORGE MARTINS LUCAS', 'ricardo.lucas@ua.pt', '3C1E3961-C932-4021-837F-B9C7F83D94DB', '', '', '', NULL, '2013-09-30'),
(1833, 'Ricardo Mendes', 'RICARDO DANIEL RAMOS MENDES', 'ricardo.mendes@ua.pt', '4A3C5C2A-071A-4F72-979D-C4CC37525C41', '', 'https://www.linkedin.com/in/rdrmendes/', '', NULL, '2013-10-15'),
(1836, 'Ricardo Querido', 'RICARDO FILIPE MARTINS QUERIDO', 'ricardo.querido98@ua.pt', '7FDB78FD-74FD-4AFF-98DF-8A41DB6EB880', '', '', '', NULL, '2018-01-11'),
(1839, 'Ricardo Gonçalves', 'RICARDO JORGE ALVES GONÇALVES', 'ricardojagoncalves@ua.pt', 'FE33D7CD-ED95-4517-9793-FCBE77898367', '', '', '', NULL, '1971-01-01'),
(1842, 'Ricardo Castor', 'RICARDO JOSÉ SIMÕES CASTOR', 'ricardojscastor@ua.pt', 'DDEA1C81-CADF-4385-B61A-3A5A19A20C65', '', '', '', NULL, '2018-01-11'),
(1845, 'Ana Rita Cerdeira Marques', 'ANA RITA CERDEIRA MARQUES', 'ritacerdeira@ua.pt', '65437B50-258D-4AEC-865D-7CB33EFEFBD8', '', '', '', NULL, '2017-05-27'),
(1848, 'Rita Jesus', 'RITA ALEXANDRA DA FONSECA JESUS', 'ritajesus@ua.pt', '0906B877-582F-4B35-B382-1077754DF67C', '', 'https://www.linkedin.com/in/ritajesus/', '', NULL, '2013-09-12'),
(1851, 'Rita Portas', 'RITA FERNANDA REIS COLETA PORTAS', 'ritareisportas@ua.pt', 'F1026687-606F-48CE-B1DA-A39349B85147', '', 'https://www.linkedin.com/in/rita-reis-portas/', '', NULL, '2013-09-18'),
(1854, 'Rafael Martins', 'RAFAEL JOSÉ DA SILVA MARTINS', 'rjmartins@ua.pt', 'B06A4751-5340-4E6F-868B-6DB91BC7151F', '', 'https://www.linkedin.com/in/rafael-martins-68661985/', '', NULL, '2013-09-12'),
(1857, 'João Rocha', 'JOÃO MIGUEL ARAÚJO MONTEIRO DA ROCHA', 'rocha.miguel@ua.pt', '27D646B9-A1AD-4CBC-9841-FA1D0A789176', '', '', '', NULL, '2013-09-24'),
(1860, 'Rui Serrano', 'RUI MIGUEL PARDAL HANEMANN GUIMARAES SERRANO', 'rui.serrano@ua.pt', 'C463CE13-1102-4EF7-9496-E52324C85700', '', '', '', NULL, '2013-09-12'),
(1863, 'Rui Brito', 'RUI DANIEL REBELO BRITO', 'ruibrito@ua.pt', '64E01601-E756-4FC6-9C2D-623C228F69C8', '', '', '', NULL, '2013-09-12'),
(1866, 'Rui Coelho', 'RUI MIGUEL OLIVEIRA COELHO', 'ruicoelho@ua.pt', '45F37FEC-D896-4527-8F77-F7C89FDA904D', '/upload/curriculos/1866.pdf', 'https://www.linkedin.com/in/ruimigueloliveiracoelho/', 'https://github.com/user-cube/', NULL, '2018-01-10'),
(1869, 'Rui Mendes', 'RUI DANIEL ALVES MENDES', 'ruidamendes@ua.pt', 'F2D30783-5E7D-4DFC-A1CB-D93C75B1919A', '', '', '', NULL, '2013-09-12'),
(1872, 'Rui Lopes', 'RUI EDUARDO DE FIGUEIREDO ARNAY LOPES', 'ruieduardo.fa.lopes@ua.pt', '1F2A48CF-6843-4DFE-B124-5293333418AB', '', '', '', NULL, '2013-09-24'),
(1875, 'Rui Azevedo', 'RUI MANUEL CASTRO AZEVEDO', 'ruimazevedo@ua.pt', '26D9C32B-70C4-44D7-8535-9D58B16F8BE3', '', 'https://www.linkedin.com/in/ruimcazevedo/', '', NULL, '2013-09-12'),
(1878, 'Rui Mendes', 'RUI ALEXANDRE DA SILVA MENDES', 'ruimendes@ua.pt', '13C0DB18-A0E7-4530-BA7F-4A654A97C87E', '', '', '', NULL, '2013-09-12'),
(1881, 'Rui Silva', 'RUI PEDRO SOARES TAVARES DA SILVA', 'ruipsilva@ua.pt', 'D891C72A-0586-4D66-B647-0DD1FEDFFFB3', '', '', '', NULL, '2013-09-26'),
(1884, 'Rui Sacchetti', 'RUI MAIA BARRETO SACCHETTI', 'ruisacchetti@ua.pt', '10C4FFC1-7A63-4241-B2AF-C690955B8391', '', '', '', NULL, '2013-09-24'),
(1887, 'Rui Simões', 'RUI FILIPE DE ALMEIDA SIMÕES', 'ruisimoes@ua.pt', '39D636A2-AF1E-40B9-866A-73F0CF5912B9', '', '', '', NULL, '2013-09-12'),
(1890, 'Samuel Gomes', 'SAMUEL CONCEIÇÃO GOMES', 's.gomes@ua.pt', '823F8F55-E4C2-4A3F-B322-52EDC31B09B7', '', '', '', NULL, '2013-09-24'),
(1893, 'Joana Silva', 'JOANA CATARINA DOS SANTOS SILVA', 's.joana@ua.pt', 'BD164E15-993F-40AF-A02A-EEB7F0696617', '', 'https://www.linkedin.com/in/joanacssilva/', '', NULL, '2013-09-12'),
(1896, 'Samuel Campos', 'SAMUEL PIRES CAMPOS', 'samuel.campos@ua.pt', 'CDEDF986-62B0-4856-9DD9-26B9A6A9CDFA', '', '', '', NULL, '2013-09-30'),
(1899, 'Sanaz Shahbazzadegan', 'SANAZ SHAHBAZ ZADEGAN', 'sanaz.shahbazzadegan@ua.pt', 'CAC6517F-C851-455A-B016-161B47BF472C', '', '', '', NULL, '2013-09-12'),
(1902, 'Sandra Andrade', 'SANDRA MARISA CARVALHO DE ANDRADE', 'sandraandrade@ua.pt', '6AD97E0C-2252-47CD-B305-3DBC0E0F4049', '', '', '', NULL, '2018-01-11'),
(1905, 'Sandybel Osório', 'SANDYBEL VEIGA OSÓRIO', 'sandybel@ua.pt', 'B3302A7B-5000-4EC0-ABAD-A08763E1CC1F', '', '', '', NULL, '2013-11-17'),
(1908, 'Sara Dias', 'SARA RAQUEL DIAS DA RESSURREIÇÃO', 'sara.dias@ua.pt', '4B7E7DE2-6A0A-4F94-A18A-F5517565EB7A', '', '', '', NULL, '2013-09-12'),
(1911, 'Sara Matos', 'SARA DA SILVA MATOS', 'saramatos@ua.pt', '5ADB4876-E4AD-4BC7-B27C-0D3155C9C5E5', '', '', '', NULL, '2013-11-14'),
(1914, 'Sergio Gonzalez', 'SÉRGIO ANDRÉ GONZALEZ RIBEIRO', 'sergiogonzalez@ua.pt', '851B6734-DD47-4A0C-A0F9-CE222DDDB1D2', '', '', '', NULL, '2018-01-11'),
(1917, 'Sérgio Martins', 'SÉRGIO DE OLIVEIRA MARTINS', 'sergiomartins8@ua.pt', '44FC1466-A886-4011-8B89-0BE43A735BEF', '', '', '', NULL, '2013-09-12'),
(1920, 'Sérgio Cunha', 'SÉRGIO DANIEL MARQUES CUNHA', 'sergiomcunha@ua.pt', 'EE60C20F-B734-4255-BE99-14A6C75A0CFB', '', '', '', NULL, '2013-09-12'),
(1923, 'Sara Furão', 'SARA DA SILVA FURÃO', 'sfurao@ua.pt', '357C7899-946E-41E4-B3A7-06ADE1A4241A', '', '', '', NULL, '2013-09-12'),
(1926, 'Susana Gomes', 'SUSANA GONÇALVES GOMES', 'sgg@ua.pt', 'EA4A6E86-1CCB-4CED-BD6A-DA4DC72198AD', '', '', '', NULL, '1971-01-01'),
(1929, 'Simão Arrais', 'SIMÃO TELES ARRAIS', 'simaoarrais@ua.pt', 'ECD5E1F2-B075-4F5D-8073-3FDB9086256A', '', '', '', NULL, '2018-01-11'),
(1932, 'Ivanov', 'SAVELIY IVANOV', 'sivanov@ua.pt', '321FDBFF-69BA-4E79-8504-C2A695F0A670', '', '', '', NULL, '2015-09-23'),
(1935, 'Sofia Marques', 'SOFIA LOPES MARQUES', 'sofia.marques99@ua.pt', '38F90093-1796-4FEC-9C5F-5D2C8EDAAD37', '', '', '', NULL, '2017-10-23'),
(1938, 'Sofia Moniz', 'ANA SOFIA MEDEIROS DE CASTRO MONIZ FERNANDES', 'sofiamoniz@ua.pt', 'B30018AB-D80C-4A5A-95B2-0E473F9BBD9E', '/upload/curriculos/1938.pdf', 'https://www.linkedin.com/in/sofiamoniz/', '', NULL, '2017-10-23'),
(1941, 'Sandra Silva', 'SANDRA PATRÍCIA PINTO DA SILVA', 'spps@ua.pt', '158B3BF7-D90D-4B36-8D66-9D11C6EEF843', '', '', '', NULL, '2013-09-30'),
(1944, 'Stive Oliveira', 'STIVE DUARTE OLIVEIRA', 'stiveoliveira@ua.pt', 'FE604B8D-6C94-494A-AD7A-E575DFEC2B56', '', '', '', NULL, '2018-10-16'),
(1947, 'Tiago Cardoso', 'TIAGO FILIPE TEODÓSIO CARDOSO', 't.cardoso@ua.pt', '3DE2E157-BBAC-4E8D-8369-E12D96E022FF', '', 'https://www.linkedin.com/in/tkardozo/', '', NULL, '2015-09-23'),
(1950, 'Tiago Soares', 'TIAGO ALEXANDRE SILVA SOARES', 'tasoares@ua.pt', '5426CA8E-D570-4497-B7E9-41B55E168C27', '', '', '', NULL, '2013-09-24'),
(1953, 'Tiago Coelho', 'TIAGO DIONÍSIO ANTUNES COELHO', 'tiago.coelho@ua.pt', 'A47D4FEA-E9A1-4FF4-801D-8AFEEA8A4690', '', '', '', NULL, '2013-09-24'),
(1956, 'Tiago Oliveira', 'TIAGO DA SILVA RIBEIRO VAZ OLIVEIRA', 'tiago.srv.oliveira@ua.pt', '431A0A24-BB36-4DFE-9DB8-4ECCB52387C4', '', '', '', NULL, '1971-01-01'),
(1959, 'Tiago Alves', 'TIAGO ANDRE SANTOS MARQUES BAPTISTA ALVES', 'tiagoaalves@ua.pt', '5910D0D3-2495-4DFD-A4ED-17F893B26E6D', '', '', '', NULL, '2014-04-08'),
(1962, 'Tiago Pereira', 'TIAGO ANDRÉ DA SILVA PEREIRA', 'tiagoapereira@ua.pt', '7D820E6D-BE7A-4E3D-8E10-E3A4E5BAAA08', '', '', '', NULL, '2013-09-12'),
(1965, 'Tiago Mendes', 'TIAGO CARVALHO MENDES', 'tiagocmendes@ua.pt', '6B45E2C1-D3B6-4AB6-A937-B34622B08F50', '/upload/curriculos/1965.pdf', '', '', NULL, '2017-10-23'),
(1968, 'Tiago Duarte', 'TIAGO FILIPE RODRIGUES DUARTE', 'tiagoduarte21@ua.pt', '5D2DC36B-25F5-44DB-9CE2-AA7AD0044E96', '', '', '', NULL, '2013-09-12'),
(1971, 'Tiago Martins', 'TIAGO FERREIRA MARTINS', 'tiagofmartins@ua.pt', '3F6ED8F3-1103-451E-973D-AB14200E61E2', '', '', '', NULL, '2013-09-12'),
(1974, 'Tiago Teixeira', 'TIAGO FILIPE MAIO TEIXEIRA', 'tiagomaioteixeira@ua.pt', 'D91D54B0-1DA6-45B4-9F4F-8DE59BA53486', '', '', '', NULL, '2013-09-12'),
(1977, 'Tiago Melo', 'TIAGO MANUEL BORGES LEÓN GOMES DE MELO', 'tiagomelo@ua.pt', '80072C01-651A-4DB9-B292-7BF60A53BB0D', '/upload/curriculos/1977.pdf', '', '', NULL, '2017-10-23'),
(1980, 'Tiago Almeida', 'TIAGO ALEXANDRE MELO ALMEIDA', 'tiagomeloalmeida@ua.pt', '35DAADC5-1442-4F6D-A963-AD5EAED6F860', '', '', '', NULL, '2014-09-17'),
(1983, 'Tibério Baptista', 'TIBÉRIO FILIPE PACHECO BAPTISTA', 'tiberio.baptista@ua.pt', 'C9A1F0C4-5209-4C9E-8DE5-1349B5DFDE4B', '', '', '', NULL, '2018-12-17'),
(1986, 'Tiago Brito', 'TIAGO LOPES FERREIRA BRITO', 'tlfbrito@ua.pt', '012FC7FF-2529-4237-9793-778D4F74DF28', '', '', '', NULL, '2013-09-12'),
(1989, 'Tomás Batista', 'TOMÁS DOS SANTOS BATISTA', 'tomasbatista99@ua.pt', 'B2747FEF-3590-44CC-8803-E6E799BBE938', '', 'https://www.linkedin.com/in/tomas99batista/', '', NULL, '2017-10-23'),
(1992, 'Tomás Rocha', 'TOMÁS DOS SANTOS CARVALHO ROCHA', 'tomascarvalho@ua.pt', 'B676DB10-A19E-4230-8A15-2C865FC45E0A', '', '', '', NULL, '2013-09-12'),
(1995, 'Tomás Costa', 'TOMÁS OLIVEIRA DA COSTA', 'tomascosta@ua.pt', 'E9310711-3AF9-448D-AE8A-F338BE750D83', '/upload/curriculos/1995.pdf', 'https://www.linkedin.com/in/tomascostax/', '', NULL, '2017-10-23'),
(1998, 'Tomás Lopes', 'TOMÁS HENRIQUE NOGUEIRA LOPES', 'tomaslopes@ua.pt', 'FD4A5960-AD7F-4503-B19F-72E1DCAF266E', '', '', '', NULL, '1971-01-01'),
(2001, 'Tomé Marques', 'TOMÉ DOS SANTOS MARQUES', 'tomemarques@ua.pt', '4787029A-1332-4118-A976-D7CA977C5CC7', '', '', '', NULL, '2014-04-02'),
(2004, 'Vasco Marieiro', 'Vasco Marieiro', 'vasco.marieiro@ua.pt', '', '', '', '', NULL, '2019-04-30'),
(2007, 'Vasco Ramos', 'VASCO ANTÓNIO LOPES RAMOS', 'vascoalramos@ua.pt', 'C2EFB820-1F50-4ABB-B0E6-BBE6A42C1E72', '/upload/curriculos/2007.pdf', '', '', NULL, '2017-10-23'),
(2010, 'Vinicius Ribeiro', 'VINÍCIUS BENITE RIBEIRO', 'viniciusribeiro@ua.pt', '1A3E50D1-E54F-49F3-92BA-40D6F81EBBEC', '', '', '', NULL, '1971-01-01'),
(2013, 'Vitor Fajardo', 'VÍTOR MANUEL OLIVEIRA FAJARDO', 'vitorfajardo@ua.pt', '9FBF6844-2384-4EC9-B4EC-7BF1D465ED25', '', '', '', NULL, '2018-01-11'),
(2016, 'Wei Ye', 'WEI YE', 'weiye@ua.pt', 'C3D585A1-2B0F-441A-AE06-4CCC0F744AA4', '', '', '', NULL, '1971-01-01'),
(2019, 'Yanick Alfredo', 'YANICK HAYES MONDLANE ALFREDO', 'yanick.alfredo@ua.pt', '49ABA8A5-BD5F-491F-9F7C-A800009348BA', '', '', '', NULL, '2018-12-17'),
(2020, 'Afonso Botô', 'AFONSO MIGUEL SANTOS BÔTO', 'afonso.boto@ua.pt', '', '', '', '', NULL, '1971-01-01'),
(2021, 'Alexandre Serras', 'ALEXANDRE MAIA SERRAS', 'alexandreserras@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2022, 'Alexandre Pinto', 'ALEXANDRE PEREIRA PINTO', 'alexandrepp07@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2023, 'André Gomes', 'ANDRÉ LOURENÇO GOMES', 'alg@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2024, 'André Freixo', 'ANDRÉ SEQUEIRA FREIXO', 'andrefreixo18@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2025, 'Andreia Portela', 'ANDREIA DE SÁ PORTELA', 'andreia.portela@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2026, 'Artur Romão', 'ARTUR CORREIA ROMÃO', 'artur.romao@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2027, 'Bernardo Leandro', 'BERNARDO ALVES LEANDRO', 'bernardoleandro1@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2028, 'Camila Fonseca', 'CAMILA FRANCO DE SÁ FONSECA', 'cffonseca@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2029, 'Catarina Oliveira', 'CATARINA CRUZ OLIVEIRA', 'catarinaoliveira@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2030, 'Daniel Figueiredo', 'DANIEL ANTÓNIO FERREIRA FIGUEIREDO', 'dani.figa@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2031, 'Daniel Francisco', 'DANIEL JOÃO FRANCISCO', 'daniel.francisco@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2032, 'Daniela Dias', 'DANIELA FILIPA PINTO DIAS', 'ddias@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2033, 'Diana Siso', 'DIANA ELISABETE SISO OLIVEIRA', 'diana.siso@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2034, 'Dinis Lei', 'DINIS DOS SANTOS LEI', 'dinislei@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2035, 'Diogo Monteiro', 'DIOGO MARCELO OLIVEIRA MONTEIRO', 'diogo.mo.monteiro@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2036, 'Diogo Silva', 'DIOGO MIGUEL FERREIRA SILVA', 'diogomfsilva98@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2037, 'Diogo Cruz', 'DIOGO PEREIRA HENRIQUES CRUZ', 'diogophc@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2038, 'Eduardo Fernandes', 'EDUARDO ROCHA FERNANDES', 'eduardofernandes@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2039, 'Eva Bartolomeu', 'EVA POMPOSO BARTOLOMEU', 'evabartolomeu@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2040, 'Fábio Martins', 'FÁBIO ALEXANDRE RAMOS MARTINS', 'fabio.m@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2041, 'Filipe Gonçalves', 'FILIPE ANDRÉ SEABRA GONÇALVES', 'fasd@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2042, 'Gonçalo Machado', 'GONÇALO FERNANDES MACHADO', 'goncalofmachado@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2043, 'Gonçalo Silva', 'GONÇALO LEAL SILVA', 'goncalolealsilva@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2044, 'Henrique Sousa', 'HENRIQUE CARVALHO SOUSA', 'hsousa@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2045, 'Hugo Gonçalves', 'HUGO MIGUEL TEIXEIRA GONÇALVES', 'hugogoncalves13@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2046, 'Isabel Rosário', 'ISABEL ALEXANDRA JORDÃO ROSÁRIO', 'isabel.rosario@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2047, 'João Reis', 'JOÃO ANTÓNIO ASSIS REIS', 'joaoreis16@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2048, 'João Bernardo', 'JOÃO BERNARDO TAVARES FARIAS', 'joaobernardo0@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2049, 'João Borges', 'JOÃO PEDRO SARAIVA BORGES', 'borgesjps@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2050, 'José Trigo', 'JOSÉ PEDRO MARTA TRIGO', 'josetrigo@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2051, 'Mariana Sousa', 'MARIANA CABRAL DA SILVA SILVEIRA ROSA', 'marianarosa@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2052, 'Marta Fradique', 'MARTA SOFIA AZEVEDO FRADIQUE', 'martafradique@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2053, 'Martinho Tavares', 'MARTINHO MARTINS BASTOS TAVARES', 'martinho.tavares@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2054, 'Miguel Beirão', 'MIGUEL BEIRÃO E BRANQUINHO OLIVEIRA MONTEIRO', 'mbeiraob@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2055, 'Miguel Ferreira', 'MIGUEL ROCHA FERREIRA', 'miguel.r.ferreira@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2056, 'Nuno Souza', 'NUNO PINTO SOUZA', 'nunosouza10@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2057, 'Patrícia Dias', 'PATRÍCIA MATIAS DIAS', 'pmd8@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2058, 'Paulo Pereira', 'PAULO GUILHERME SOARES PEREIRA', 'paulogspereira@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2059, 'Pedro Sobral', 'PEDRO ALEXANDRE COELHO SOBRAL', 'sobral@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2060, 'Pedro Alexandre', 'PEDRO ALEXANDRE CORREIA DE FIGUEIREDO', 'palexandre@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2061, 'Pedro Lopes', 'PEDRO DANIEL FONTES LOPES', 'pdfl@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2062, 'Pedro Duarte', 'PEDRO DANIEL LOPES DUARTE', 'pedro.dld@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2063, 'Pedro Monteiro', 'PEDRO MIGUEL AFONSO DE PINA MONTEIRO', 'pmapm@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2064, 'Pedro Simão', 'PEDRO SIMÃO MINISTRO JORGE', 'pedro.simao10@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2065, 'Raquel Ferreira', 'RAQUEL DA SILVA FERREIRA', 'raquelsf@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2066, 'Renato Dias', 'RENATO ALEXANDRE LOURENÇO DIAS', 'renatoaldias12@ua.pt', '', '', 'https://www.linkedin.com/in/renato-a-l-dias-2919a3195/', '', NULL, '2019-09-13'),
(2067, 'Ricardo Ferreira', 'RICARDO DE ANDRADE SERRANO FERREIRA', 'ricardoserranoferreira@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2068, 'Ricardo Rodriguez', 'RICARDO MANUEL BATISTA RODRIGUEZ', 'ricardorodriguez@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2069, 'Rodrigo Lima', 'RODRIGO FRANÇA LIMA', 'rodrigoflima@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2070, 'Tiago Brandão Costa', 'TIAGO MANUEL CALISTO BRANDÃO COSTA', 'bran.costa@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2071, 'Tiago Matos', 'TIAGO MIGUEL RUIVO DE MATOS', 'tiagomrm@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2072, 'Tomé Carvalho', 'TOMÉ LOPES CARVALHO', 'tomecarvalho@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2073, 'Vasco Regal', 'VASCO JORGE REGAL SOUSA', 'vascoregal24@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2074, 'Vicente Costa', 'VICENTE SAMUEL GONÇALVES COSTA', 'vicente.costa@ua.pt', '', '', '', '', NULL, '2019-09-13'),
(2075, 'Vitor Dias', 'VITOR FRANCISCO RIBEIRO DIAS', 'vfrd00@ua.pt', '', '', 'https://www.linkedin.com/in/v%C3%ADtor-dias-7b566920a', '', NULL, '2019-09-13'),
(2077, 'Ivan Garcia', 'Ivan Manso', 'ivanmansogarcia@ua.pt', ' ', '', '', '', 'DEFAULT', '2019-09-26'),
(2080, 'Brais Perez', 'Brais Gonzalez Peres', 'brais@ua.pt', '', '', '', '', 'DEFAULT', '2019-09-26'),
(2086, 'Guilherme Alegre', 'Guilherme Alegre', 'guilhermealegre@ua.pt', '', '', '', '', 'DEFAULT', '2019-10-09'),
(2092, 'Pedro Rodrigues', 'Pedro Miguel Tavares Rodrigues', 'ped.rodr@ua.pt', '', '', '', '', 'DEFAULT', '2019-10-13'),
(2098, 'Luís Martins', 'Luís Martins', 'luisccmartins88@ua.pt', ' ', '', '', '', 'DEFAULT', '2019-10-23'),
(2104, 'Afonso Campos', 'Afonso Campos', 'afonso.campos@ua.pt', ' ', '', '', '', 'DEFAULT', '2019-10-25'),
(2106, 'Sophie Pousinho', 'Sophie Pousinho', 'sophiepousinho@ua.pt', '', '', '', '', 'DEFAULT', '2019-11-05'),
(2109, 'Filipe Gonçalves', 'Filipe Gonçalves', 'filipeg@ua.pt', '', '', '', '', 'DEFAULT', '2019-11-05'),
(2112, 'Dani Figueiredo', 'Dani Figueiredo', 'dani.fig@ua.pt', '', '', '', '', 'DEFAULT', '2019-11-05'),
(2118, 'Airton Moreira', 'Airton Moreira', 'agm@ua.pt', '', '', '', '', 'DEFAULT', '2019-11-06'),
(2121, 'Hugo Silva', 'HUGO TAVARES SILVA', 'hugot.silva@ua.pt', '', '', '', '', NULL, '2019-10-01'),
(2122, 'Yanis Faquir', 'Yanis Marina Faquir', 'yanismarinafaquir@ua.pt', '', '', '', '', 'DEFAULT', '2020-03-10'),
(2123, 'Rita Ferrolho', '', 'ritaferrolho@ua.pt', '', '', '', '', 'DEFAULT', '2020-04-21'),
(2124, 'Pedro Figueiredo', 'Pedro Figueiredo', 'palexandre09@ua.pt', ' ', ' ', 'https://www.linkedin.com/in/pedro-figueiredo-9983181ba/', ' ', 'DEFAULT', '2021-03-09'),
(2125, 'Artur Correia', 'Artur Correia', 'non@ua.pt', ' ', ' ', '', ' ', 'DEFAULT', '2021-03-09'),
(2126, 'André Benquerença', 'André Benquerença', 'non@ua.pt', ' ', ' ', '', ' ', 'DEFAULT', '2021-03-09'),
(2127, 'Daniel Carvalho', 'Daniel Carvalho', 'dl.carvalho@ua.pt', ' ', '', 'http://www.linkedin.com/in/daniel-carvalho-a89b1b176', ' ', 'DEFAULT', '2021-03-09'),
(2128, 'Rafael Gonçalves', 'Rafael Gonçalves', 'non@ua.pt', ' ', ' ', '', ' ', 'DEFAULT', '2021-03-09'),
(2129, 'Inês Ferreira', 'Inês Queirós Ferreira', 'non@ua.pt', ' ', ' ', '', ' ', 'DEFAULT', '2021-03-09'),
(2130, 'Rodrigo Oliveira', 'Rodrigo Oliveira', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2131, 'Miguel Fonseca', 'Miguel Fonseca', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2132, 'Catarina Costa', 'Catarina Costa', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2133, 'Leonardo Almeida', 'Leonardo Almeida', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2134, 'Lucius Filho', 'Lucius Vinicius Rocha Machado Filho', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2135, 'Yanis Faquir', 'Yanis Marina Faquir', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2136, 'Daniel Ferreira', 'Daniel Martins Ferreira,', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2137, 'Filipe Silva', 'Filipe Silva', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2138, 'Alexandre Santos', 'Alexandre Santos', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2146, 'Vicente Barros', 'VICENTE MANUEL ANDRADE BARROS', 'vmabarros@ua.pt', '', '', '', '', NULL, '1971-01-01'),
(2149, 'Tiago Gomes', 'TIAGO CARIDADE GOMES', 'tiagocgomes@ua.pt', '', '', '', '', NULL, '1971-01-01'),
(2152, 'Rafaela Abrunhosa', 'MARIA RAFAELA ALVES ABRUNHOSA', 'maria.abrunhosa@ua.pt', '', '', '', '', NULL, '1971-01-01'),
(2155, 'Matilde Teixeira', 'MATILDE MOITAL PORTUGAL SAMPAIO TEIXEIRA', 'matilde.teixeira@ua.pt', '', '', '', '', NULL, '1971-01-01'),
(2158, 'Hugo Correia', 'HUGO FRANCISCO DA COSTA CORREIA', 'hf.correia@ua.pt', '', '', '', '', NULL, '1971-01-01'),
(2161, 'Mariana Rosa', 'MARIANA CABRAL DA SILVA SILVEIRA ROSA', '', '', '', '', '', NULL, '1971-01-01');


--
-- Data for Name: video; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.video (id, youtube_id, title, subtitle, image, created_at, playlist) VALUES
(1, 'PL0-X-dbGZUABPg-FWm3tT7rCVh6SESK2d', 'FP', 'Fundamentos de Programação', '/videos/FP_2020.jpg', '2020-12-09 00:00:00', 1),
(2, 'PL0-X-dbGZUAA8rQm4klslEksHCrb3EIDG', 'IAC', 'Introdução à Arquitetura de Computadores', '/videos/IAC_2020.jpg', '2020-06-10 00:00:00', 1),
(3, 'PL0-X-dbGZUABp2uATg_-lqfT4FTFlyNir', 'ITW', 'Introdução às Tecnologias Web', '/videos/ITW_2020.jpg', '2020-12-17 00:00:00', 1),
(4, 'PL0-X-dbGZUACS3EkepgT7DOf287MiTzp0', 'POO', 'Programação Orientada a Objetos', '/videos/POO_2020.jpg', '2020-11-16 00:00:00', 1),
(5, 'ips-tkEr_pM', 'Discord Bot', 'Workshop', '/videos/discord.jpg', '2021-07-14 00:00:00', 0),
(6, '3hjRgoIItYk', 'Anchorage', 'Palestra', '/videos/anchorage.jpg', '2021-04-01 00:00:00', 0),
(7, 'GmNvZC6iv1Y', 'Git', 'Workshop', '/videos/git.jpg', '2020-04-28 00:00:00', 0);


--
-- Data for Name: video_tag; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.video_tag (id, name, color) VALUES
(1, '1A', 'rgb(1, 202, 228)'),
(2, '2A', 'rgb(1, 171, 192)'),
(3, '3A', 'rgb(1, 135, 152)'),
(4, 'MEI', 'rgb(1, 90, 101)'),
(5, 'Workshops', 'rgb(11, 66, 21)'),
(6, 'Palestras', 'rgb(20, 122, 38)');


--
-- Data for Name: video_video_tags; Type: TABLE DATA; Schema: aauav_nei; Owner: postgres
--

INSERT INTO aauav_nei.video_video_tags (video, video_tag) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 5),
(6, 6),
(7, 5);


--
-- Name: faina_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.faina_id_seq', 1, false);


--
-- Name: faina_member_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.faina_member_id_seq', 1, false);


--
-- Name: faina_role_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.faina_role_id_seq', 1, false);


--
-- Name: merch_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.merch_id_seq', 1, false);


--
-- Name: news_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.news_id_seq', 1, false);


--
-- Name: note_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.note_id_seq', 1, false);


--
-- Name: note_school_year_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.note_school_year_id_seq', 1, false);


--
-- Name: note_teacher_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.note_teacher_id_seq', 1, false);


--
-- Name: note_thank_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.note_thank_id_seq', 1, false);


--
-- Name: note_types_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.note_type_id_seq', 1, false);


--
-- Name: partner_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.partner_id_seq', 1, false);


--
-- Name: redirect_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.redirect_id_seq', 1, false);


--
-- Name: rgm_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.rgm_id_seq', 1, false);


--
-- Name: senior_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.senior_id_seq', 1, false);


--
-- Name: team_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.team_id_seq', 1, false);


--
-- Name: team_role_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.team_role_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.user_id_seq', 1, false);


--
-- Name: video_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.video_id_seq', 1, false);


--
-- Name: video_tag_id_seq; Type: SEQUENCE SET; Schema: aauav_nei; Owner: postgres
--

SELECT pg_catalog.setval('aauav_nei.video_tag_id_seq', 1, false);


--
-- Name: faina_member faina_member_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.faina_member
    ADD CONSTRAINT faina_member_pkey PRIMARY KEY (id);


--
-- Name: faina faina_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.faina
    ADD CONSTRAINT faina_pkey PRIMARY KEY (id);


--
-- Name: faina_role faina_role_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.faina_role
    ADD CONSTRAINT faina_role_pkey PRIMARY KEY (id);


--
-- Name: history history_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (moment);


--
-- Name: merch merch_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.merch
    ADD CONSTRAINT merch_pkey PRIMARY KEY (id);


--
-- Name: news news_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.news
    ADD CONSTRAINT news_pkey PRIMARY KEY (id);


--
-- Name: note note_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note
    ADD CONSTRAINT note_pkey PRIMARY KEY (id);


--
-- Name: note_school_year note_school_year_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note_school_year
    ADD CONSTRAINT note_school_year_pkey PRIMARY KEY (id);


--
-- Name: note_subject note_subject_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note_subject
    ADD CONSTRAINT note_subject_pkey PRIMARY KEY (paco_code);


--
-- Name: note_teacher note_teacher_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note_teacher
    ADD CONSTRAINT note_teacher_pkey PRIMARY KEY (id);


--
-- Name: note_thank note_thank_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note_thank
    ADD CONSTRAINT note_thank_pkey PRIMARY KEY (id);


--
-- Name: note_types note_types_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note_type
    ADD CONSTRAINT note_types_pkey PRIMARY KEY (id);


--
-- Name: partner partner_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.partner
    ADD CONSTRAINT partner_pkey PRIMARY KEY (id);


--
-- Name: redirect redirect_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.redirect
    ADD CONSTRAINT redirect_pkey PRIMARY KEY (id);


--
-- Name: rgm rgm_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.rgm
    ADD CONSTRAINT rgm_pkey PRIMARY KEY (id);


--
-- Name: senior senior_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.senior
    ADD CONSTRAINT senior_pkey PRIMARY KEY (id);


--
-- Name: senior_student senior_student_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.senior_student
    ADD CONSTRAINT senior_student_pkey PRIMARY KEY (senior_id, user_id);


--
-- Name: team_colaborator team_colaborator_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.team_colaborator
    ADD CONSTRAINT team_colaborator_pkey PRIMARY KEY (user_id, mandate);


--
-- Name: team team_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.team
    ADD CONSTRAINT team_pkey PRIMARY KEY (id);


--
-- Name: team_role team_role_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.team_role
    ADD CONSTRAINT team_role_pkey PRIMARY KEY (id);


--
-- Name: senior uc_year_course; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.senior
    ADD CONSTRAINT uc_year_course UNIQUE (year, course);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.user
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: video video_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.video
    ADD CONSTRAINT video_pkey PRIMARY KEY (id);


--
-- Name: video_tag video_tag_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.video_tag
    ADD CONSTRAINT video_tag_pkey PRIMARY KEY (id);


--
-- Name: video_video_tags video_video_tags_pkey; Type: CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.video_video_tags
    ADD CONSTRAINT video_video_tags_pkey PRIMARY KEY (video, video_tag);


--
-- Name: ix_aauav_nei_faina_member_faina_id; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_faina_member_faina_id ON aauav_nei.faina_member USING btree (faina_id);


--
-- Name: ix_aauav_nei_faina_member_member_id; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_faina_member_member_id ON aauav_nei.faina_member USING btree (member_id);


--
-- Name: ix_aauav_nei_faina_member_role_id; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_faina_member_role_id ON aauav_nei.faina_member USING btree (role_id);


--
-- Name: ix_aauav_nei_news_author_id; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_news_author_id ON aauav_nei.news USING btree (author_id);


--
-- Name: ix_aauav_nei_news_changed_by; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_news_changed_by ON aauav_nei.news USING btree (changed_by);


--
-- Name: ix_aauav_nei_news_published_by; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_news_published_by ON aauav_nei.news USING btree (published_by);


--
-- Name: ix_aauav_nei_note_author_id; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_note_author_id ON aauav_nei.note USING btree (author_id);


--
-- Name: ix_aauav_nei_note_created_at; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_note_created_at ON aauav_nei.note USING btree (created_at);


--
-- Name: ix_aauav_nei_note_school_year_id; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_note_school_year_id ON aauav_nei.note USING btree (school_year_id);


--
-- Name: ix_aauav_nei_note_subject_id; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_note_subject_id ON aauav_nei.note USING btree (subject_id);


--
-- Name: ix_aauav_nei_note_teacher_id; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_note_teacher_id ON aauav_nei.note USING btree (teacher_id);


--
-- Name: ix_aauav_nei_note_thank_author_id; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_note_thank_author_id ON aauav_nei.note_thank USING btree (author_id);


--
-- Name: ix_aauav_nei_note_type_id; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_note_type_id ON aauav_nei.note USING btree (type_id);


--
-- Name: ix_aauav_nei_team_mandate; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_team_mandate ON aauav_nei.team USING btree (mandate);


--
-- Name: ix_aauav_nei_team_role_id; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_team_role_id ON aauav_nei.team USING btree (role_id);


--
-- Name: ix_aauav_nei_team_role_weight; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_team_role_weight ON aauav_nei.team_role USING btree (weight);


--
-- Name: ix_aauav_nei_team_user_id; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_team_user_id ON aauav_nei.team USING btree (user_id);


--
-- Name: ix_aauav_nei_user_created_at; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_user_created_at ON aauav_nei.user USING btree (created_at);


--
-- Name: ix_aauav_nei_video_created_at; Type: INDEX; Schema: aauav_nei; Owner: postgres
--

CREATE INDEX ix_aauav_nei_video_created_at ON aauav_nei.video USING btree (created_at);


--
-- Name: faina_member faina_member_faina_id_fkey; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.faina_member
    ADD CONSTRAINT faina_member_faina_id_fkey FOREIGN KEY (faina_id) REFERENCES aauav_nei.faina(id);


--
-- Name: faina_member faina_member_member_id_fkey; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.faina_member
    ADD CONSTRAINT faina_member_member_id_fkey FOREIGN KEY (member_id) REFERENCES aauav_nei.user(id);


--
-- Name: faina_member faina_member_role_id_fkey; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.faina_member
    ADD CONSTRAINT faina_member_role_id_fkey FOREIGN KEY (role_id) REFERENCES aauav_nei.faina_role(id);


--
-- Name: news fk_author_id; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.news
    ADD CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES aauav_nei.user(id);


--
-- Name: note fk_author_id; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note
    ADD CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES aauav_nei.user(id);


--
-- Name: note_thank fk_author_id; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note_thank
    ADD CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES aauav_nei.user(id);


--
-- Name: news fk_editor_id; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.news
    ADD CONSTRAINT fk_editor_id FOREIGN KEY (changed_by) REFERENCES aauav_nei.user(id);


--
-- Name: news fk_publisher_id; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.news
    ADD CONSTRAINT fk_publisher_id FOREIGN KEY (published_by) REFERENCES aauav_nei.user(id);


--
-- Name: note fk_school_year_id; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note
    ADD CONSTRAINT fk_school_year_id FOREIGN KEY (school_year_id) REFERENCES aauav_nei.note_school_year(id);


--
-- Name: note fk_subject_id; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note
    ADD CONSTRAINT fk_subject_id FOREIGN KEY (subject_id) REFERENCES aauav_nei.note_subject(paco_code);


--
-- Name: note fk_teacher_id; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note
    ADD CONSTRAINT fk_teacher_id FOREIGN KEY (teacher_id) REFERENCES aauav_nei.note_teacher(id);


--
-- Name: note fk_type_id; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.note
    ADD CONSTRAINT fk_type_id FOREIGN KEY (type_id) REFERENCES aauav_nei.note_type(id);


--
-- Name: senior_student senior_student_senior_id_fkey; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.senior_student
    ADD CONSTRAINT senior_student_senior_id_fkey FOREIGN KEY (senior_id) REFERENCES aauav_nei.senior(id);


--
-- Name: senior_student senior_student_user_id_fkey; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.senior_student
    ADD CONSTRAINT senior_student_user_id_fkey FOREIGN KEY (user_id) REFERENCES aauav_nei.user(id);


--
-- Name: team_colaborator team_colaborator_user_id_fkey; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.team_colaborator
    ADD CONSTRAINT team_colaborator_user_id_fkey FOREIGN KEY (user_id) REFERENCES aauav_nei.user(id);


--
-- Name: team team_role_id_fkey; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.team
    ADD CONSTRAINT team_role_id_fkey FOREIGN KEY (role_id) REFERENCES aauav_nei.team_role(id);


--
-- Name: team team_user_id_fkey; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.team
    ADD CONSTRAINT team_user_id_fkey FOREIGN KEY (user_id) REFERENCES aauav_nei.user(id);


--
-- Name: video_video_tags video_video_tags_video_fkey; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.video_video_tags
    ADD CONSTRAINT video_video_tags_video_fkey FOREIGN KEY (video) REFERENCES aauav_nei.video(id);


--
-- Name: video_video_tags video_video_tags_video_tag_fkey; Type: FK CONSTRAINT; Schema: aauav_nei; Owner: postgres
--

ALTER TABLE ONLY aauav_nei.video_video_tags
    ADD CONSTRAINT video_video_tags_video_tag_fkey FOREIGN KEY (video_tag) REFERENCES aauav_nei.video_tag(id);


--
-- PostgreSQL database dump complete
--
