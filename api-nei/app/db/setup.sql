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
    hashed_password character varying(60),
    name character varying(20) NOT NULL,
    surname character varying(20) NOT NULL,
    gender nei.gender_enum,
    image character varying(2048),
    curriculum character varying(2048),
    linkedin character varying(100),
    github character varying(39),
    scopes nei.scope_enum[],
    updated_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL
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
-- Data for Name: course; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.course (code, name, short, discontinued) VALUES
(9263, 'MESTRADO EM ENGENHARIA INFORMÁTICA (2º CICLO)', 'MEI', 0);

--
-- Data for Name: faina; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.faina (id, image, year) VALUES
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
(107, 158, 10, 4);


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

INSERT INTO nei.merch (id, name, image, price, number_of_items) VALUES
(1, 'Emblema de curso', '/merch/emblema.png', 2.5, 0),
(2, 'Cachecol de curso', '/merch/scarf.png', 3.5, 0),
(3, 'Casaco de curso', '/merch/casaco.png', 16.5, 0),
(4, 'Sweat de curso', '/merch/sweat.png', 18, 0),
(5, 'Emblema NEI', '/merch/emblemanei.png', 2.5, 0);


--
-- Data for Name: news; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.news (id, header, status, title, category, content, published_by, created_at, last_change_at, changed_by, author_id) VALUES
(1, '/news/6aniversario.jpg', 'ACTIVE', '6º Aniversário NEI', 'EVENT', 'Fez 6 anos, no passado dia 24 de Janeiro, que se formou o Núcleo de Estudantes de Informática. Para celebrar o 6º aniversário do NEI, convidamos todos os nossos alunos, colegas e amigos a juntarem-se a nós num jantar repleto de surpresas. O jantar realizar-se-á no dia 28 de fevereiro no restaurante \Monte Alentejano\ - Rua de São Sebastião 27A - pelas 20h00 tendo um custo de 11 euros por pessoa. Contamos com a presença de todos para apagarmos as velas e comermos o bolo, porque alegria e diversão já têm presença marcada!<hr><b>Ementa</b><ul><li>Carne de porco à alentejana/ opção vegetariana</li><li>Bebida à descrição</li><li>Champanhe</li><li>Bolo</li></ul>  Nota: Caso pretendas opção vegetariana deves comunicar ao NEI por mensagem privada no facebook ou então via email.<hr><b>Informações</b><br>Inscrições até dia 21 de fevereiro sendo que as mesmas estão limitadas a 100 pessoas.<br>&#9888;&#65039; A inscrição só será validada após o pagamento junto de um elemento do NEI até dia 22 de fevereiro às 16horas!<br>+info: nei@aauav.pt ou pela nossa página de Facebook<br><hr><b>Logins</b><br>Caso não saibas o teu login contacta: <a href=\https://www.facebook.com/ruicoelho43\>Rui Coelho</a> ou então diretamente com o <a href=\https://www.facebook.com/nei.aauav/\>NEI</a>, podes ainda mandar mail para o NEI, nei@aauav.pt.', 111, '2019-01-18', NULL, NULL, 1),
(2, '/news/rgm1.png', 'ACTIVE', 'Convocatória RGM Extraordinária', 'EVENT', 'De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos Núcleos da Associação Académica da Universidade de Aveiro, convocam-se todos os membros da Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática para uma Reunião Geral de Membros Extraordinária, que se realizará no dia 14 do mês de Fevereiro de 2019, na sala 102 do Departamento de Eletrónica, Telecomunicações e Informática da Universidade de Aveiro, pelas 18 horas, com a seguinte ordem de trabalhos:  <br><br>1. Aprovação da Ata da RGM anterior;   <br>2. Informações;   <br>3. Apresentação do Plano de Atividades e Orçamento;  <br>4. Aprovação do Plano de Atividades e Orçamentos;  <br>5. Outros assuntos.   <br><br>Mais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI.<br><br><div style=\text-align:center\>Aveiro, 11 de janeiro de 2019<br>David Augusto de Sousa Fernandes<br>Presidente da Mesa da Reunião Geral de Membros<br>Núcleo de Estudantes de Informática da AAUAv <br></div><hr>Links úteis:<br><a href=\https://nei.web.ua.pt/scripts/unlock.php?url=upload/documents/RGM_ATAS/2018/RGM_10jan2019.pdf\ target=\_blank\>Ata da RGM anterior</a><br><a href=\https://nei.web.ua.pt/upload/documents/CONV_ATAS/2019/1RGM.pdf\ target=\_blank\>Documento da convocatória</a> ', 111, '2019-02-11', NULL, NULL, 1),
(3, '/news/rgm2.png', 'ACTIVE', 'Convocatória RGM Extraordinária', 'EVENT', 'De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos  Núcleos  da  Associação Académica  da  Universidade  de  Aveiro,  convocam-se  todos  os membros  da  Licenciatura  em  Engenharia  Informática  e  Mestrado  em  Engenharia  Informática para uma Reunião Geral de MembrosExtraordinária, que se realizará no dia 1do mês de Abrilde 2019,   na   sala   102   do   Departamento   de   Eletrónica,   Telecomunicações   e   Informática   da Universidade de Aveiro, pelas 17:45horas, com a seguinte ordem de trabalhos: <br><br>1. Aprovação da Ata da RGM anterior;   <br>2. Informações;   <br>3. Discussão sobre o tema da barraca;  <br>4. Orçamento Participativo 2019;  <br>5. Outros assuntos.   <br><br>Se   à   hora   indicada   não   existir   quórum,   a   Assembleia   iniciar-se-á   meia   hora   depois, independentemente do número de membros presentes, no mesmo local, e com a mesma ordem de trabalhos.<br>Mais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI (https://nei.web.ua.pt).<br><br><div style=\text-align:center\>Aveiro, 28 de Março de 2019<br>David Augusto de Sousa Fernandes<br>Presidente da Mesa da Reunião Geral de Membros<br>Núcleo de Estudantes de Informática da AAUAv <br></div><hr>', 111, '2019-03-28', NULL, NULL, 1),
(4, '/news/idpimage.png', 'ACTIVE', 'Integração IDP', 'NEWS', 'Recentemente foi feito um update no site que permite agora aos alunos de Engenharia Informática, quer mestrado, quer licenciatura, iniciar sessão no site  <a href=\https://nei.web.ua.pt\>nei.web.ua.pt</a> através do idp. <br>Esta alteração tem por consequência direta que a gestão de passwords deixa de estar diretamente ligada ao NEI passando assim, deste modo, qualquer password que seja perdida ou seja necessária alterar, responsabilidade do IDP da UA.<br><hr><h5 style=\text-align: center\><strong>Implicações diretas</strong></h5><br>Todas as funcionalidades do site se mantém e esta alteração em nada afeta o normal workflow do site, os apontamentos vão continuar na mesma disponíveis e em breve irão sofrer um update sendo corrigidas eventuais falhas nos atuais e adicionados mais alguns apontamentos No que diz respeito aos jantares de curso, a inscrição para estes também será feita via login através do IDP.<br>De forma genérica o IDP veio simplificar a forma como acedemos às plataformas do NEI, usando assim o Utilizador Universal da Universidade de Aveiro para fazer o login.<br>É de frisar que <strong>apenas</strong> os estudantes dos cursos  <strong>Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática  </strong>têm acesso ao site, todos os outros irão receber uma mensagem de erro quando fazem login e serão redirecionados para a homepage, não tendo, assim, acesso à informação e funcionalidades que necessitam de autenticação.<hr><h5 style=\text-align: center\><strong>Falha nos acessos</strong></h5><br>Existe a possibilidade de alguns alunos não terem acesso caso ainda não tivessem sido registados na versão antiga do site, assim, caso não consigas aceder por favor entra em contacto connosco via email para o <a href=\mailto:nei@aauav.pt?Subject=Acesso%20NEI\ target=\_top\>NEI</a> ou via facebook por mensagem direta para o <a href=\https://www.facebook.com/nei.aauav/\>NEI</a> ou então diretamente com o <a href=\https://www.facebook.com/ruicoelho43\>Rui Coelho</a>.<br>', 111, '2019-05-15', NULL, NULL, 1),
(5, '/news/florinhas.jpg', 'ACTIVE', 'Entrega de t-shirts à Florinhas de Vouga', 'NEWS', 'Hoje procedemos à entrega de mais de 200 t-shirts em bom estado que nos sobraram ao longo dos anos às Florinhas Do Vouga, possibilitando assim roupa a quem mais precisa.<br>A IPSS – Florinhas do Vouga é uma Instituição Diocesana de Superior Interesse Social, fundada em 6 de Outubro de 1940 por iniciativa do Bispo D. João Evangelista de Lima Vidal, a quem se deve a criação de obras similares, as Florinhas da Rua em Lisboa e as Florinhas da Neve em Vila Real.<br>A Instituição desenvolve a sua intervenção na cidade de Aveiro, mais concretamente na freguesia da Glória, onde se situa um dos Bairros Sociais mais problemáticos da cidade (Bairro de Santiago), dando também resposta, sempre que necessário, às solicitações das freguesias limítrofes e outras, algumas delas fora do Concelho.<br>No desenvolvimento da sua actividade mantém com o CDSSS de Aveiro Acordos de Cooperação nas áreas da Infância e Juventude; População Idosa; Família e Comunidade e Toxicodependência.<br>É Entidade aderente do Núcleo Local de Inserção no âmbito do Rendimento Social de Inserção, parceira do CLAS, assumindo com os diferentes Organismos e Instituições uma parceria activa.<br>O desenvolvimento das respostas decorreu até Agosto de 2008 em equipamentos dispersos na freguesia da Glória e Vera Cruz, o que levou a Instituição a construir um edifício de raiz na freguesia da Glória, espaço onde passou a ter condições para concentrar parte das respostas que desenvolvia (nomeadamente Estabelecimento de Educação Pré-Escolar, CATL e SAD), assumir novas respostas (Creche), dar continuidade ao trabalho desenvolvido e garantir uma melhoria substancial na qualidade dos serviços prestados, encontrando-se neste momento num processo de implementação de Sistema de Gestão de Qualidade com vista à certificação.<br>A presença de famílias numerosas, multiproblemáticas, sem rendimentos de trabalho, quase que limitadas a rendimentos provenientes de prestações sociais, famílias com fortes vulnerabilidades, levaram a Instituição a ser mediadora no Programa Comunitário de Ajuda a Carenciados e a procurar sinergias capazes de optimizar os seus recursos existentes e dar resposta à emergência social, são exemplos disso a acção “Mercearia e Companhia”, que apoia mensalmente cerca de 200 famílias em géneros alimentares, vestuário e outros e a “Ceia com Calor” que distribui diariamente um suplemento alimentar aos Sem-abrigo de Aveiro.<br>É de salientar que as famílias que usufruem de Respostas Socais tipificadas, face às suas vulnerabilidades acabam por não conseguir assumir o pagamento das mensalidades mínimas que deveriam pagar pela prestação dos serviços que lhe são garantidos pela Instituição, o que exige um maior esforço por parte desta.<br>Em termos globais, a Instituição tem assumido uma estratégia de efectiva prevenção, promoção e inclusão da população alvo.<br><strong>Se tiveres roupa ou produtos de higiene a mais e queres ajudar as Florinhas por favor dirige-te à instituição e entrega as mesmas!</strong><br>Fica a conhecer mais sobre esta instituição: http://www.florinhasdovouga.pt', 65, '2019-09-11', NULL, NULL, 1),
(6, '/news/rgm3.png', 'ACTIVE', 'Convocatória RGM Extraordinária', 'EVENT', 'De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos Núcleos da Associação Académica da Universidade de Aveiro, convocam-se todos os membros da Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática para uma Reunião Geral de Membros Extraordinária, que se realizará no dia 24 do mês de Setembro de 2019, na sala 102 do Departamento de Eletrónica, Telecomunicações e Informática da Universidade de Aveiro, pelas 18:00 horas, com a seguinte ordem de trabalhos: <br><br>1. Aprovação da Ata da RGM anterior; <br>2. Informações; <br>3. Pitch Bootcamp; <br>4. Taça UA; <br>5. Programa de Integração; <br>6. Outros assuntos. <br><br>Se à hora indicada não existir quórum, a Assembleia iniciar-se-á meia hora depois, independentemente do número de membros presentes, no mesmo local, e com a mesma ordem de trabalhos.<br>Mais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI (https://nei.web.ua.pt), sendo necessário fazer login na plataforma para ter acesso à mesma.<br><br><div style=\text-align:center\>David Augusto de Sousa Fernandes<br>Aveiro, 20 de setembro de 2019<br>Presidente da Mesa da Reunião Geral de Membros<br>Núcleo de Estudantes de Informática da AAUAv <br></div><hr>', 65, '2019-09-20', NULL, NULL, 1),
(7, '/news/newNEI.png', 'ACTIVE', 'Lançamento do novo portal do NEI', 'NEWS', 'Passado um cerca de um ano após o lançamento da versão anterior do portal do NEI, lançamos agora uma versão renovada do mesmo com um desgin mais atrativo utilizando react para a sua criação.<br>Esta nova versão do site conta com algumas novas features:<ol>  <li>Podes agora ter uma foto utilizando o gravatar, fizemos a integração com o mesmo.</li>  <li>Podes associar o teu CV, linkedin e conta git ao teu perfil.</li>  <li>Vais poder acompanhar tudo o que se passa na taça UA com as equipas do NEI a partir da plataforma de desporto que em breve será colocada online.</li>  <li>Existe uma secção que vai permitir aos alunos interessados no curso encontrar informação sobre o mesmo mais facilmente.</li>  <li>Podes encontrar a composição de todas as coordenações na página dedicada à equipa.</li>  <li>Podes encontrar a composição de todas as comissões de faina na página dedicada à equipa.</li>  <li>Integração dos eventos criados no facebook.</li>  <li>Podes ver todas as tuas compras de Merchandising.</li>  <li>Possibilidade de divulgar os projetos no site do NEI todos os projetos que fazes, estes não precisam de ser apenas projetos universitários, podem ser também projetos pessoais. Esta função ainda não está ativa mas em breve terás novidades.</li>  <li>Foi redesenhada a página dos apontamentos sendo agora mais fácil encontrares os apontamentos que precisas, podes pesquisar diretamente ou utilizar diferentes sorts de modo a que fiquem ordenados a teu gosto.</li></ol> À semelhança da anterior versão do website do NEI continuamos a ter a integração do IPD da UA fazendo assim a gestão de acessos ao website mais facilmente. Caso tenhas algum problema com o teu login entra em contacto conosco para resolvermos essa situação.<br>Da mesma que o IDP se manteve, todas as funcionalidades anteriores foram mantidas, apenas remodelamos a imagem. Quanto às funcionalidades existentes, fizemos uma pequena alteração nas atas da RGM, as mesmas passam agora apenas a estarem disponíveis para os membros do curso.Chamamos para a atenção do facto de que, na anterior versão todas as opções existentes no site apareciam logo sem login e posteriormente é que era pedido o mesmo, alteramos isso, agora só aparecem todas as opções após login.<hr>Caso encontres algum bug por favor informa o NEI de modo a que este possa ser corrigido!', 111, '2019-07-22', '2019-09-06', 111, 1),
(8, '/news/mecvsei.jpg', 'ACTIVE', 'Engenharia Mecânica vs Engenharia Informática (3-2)', 'EVENT', 'Apesar da derrota frente a Engenharia Mecânica por 3-2 num jogo bastante efusivo tivemos as bancadas cheias.<br>Mostramos hoje, novamente, que não é por acaso que ganhamos o prémio de melhor claque da época 2018/2019<br>Podes ver as fotos do jogo no nosso facebook:<br><br><iframe src=\https://www.facebook.com/plugins/post.php?href=https%3A%2F%2Fwww.facebook.com%2Fmedia%2Fset%2F%3Fset%3Da.2657806134483446%26type%3D3&width=500\ width=\500\ height=\650\ align=\middle\ style=\border:none;overflow:hidden\ scrolling=\no\ frameborder=\0\ allowTransparency=\true\ allow=\encrypted-media\></iframe>', 111, '2019-10-17', NULL, NULL, 1),
(9, '/news/melhorclaque.jpg', 'ACTIVE', 'Melhor Claque 2018/2019', 'NEWS', 'No passado domingo, dia 13 de outubro, decorreu a gala <strong>Academia de Ouro</strong> organizada pela Associação Académica da Universidade de Aveiro.<br>Esta gala visa distinguir personalidades que se destacaram na época de 2018/2019 e dar a conhecer a nova época.<br>O curso de Engenharia Informática foi nomeado para melhor claque e acabou por vencer trazendo para o DETI um prémio que faltava no palmarés.<br>O troféu encontra-se agora exposto junto da porta que dá acesso ao aquário.<br>Resalvamos que esteve ainda nomeado o Bruno Barbosa para melhor jogador mas infelizmente não ganhou o prémio.<br>', 111, '2019-10-17', NULL, NULL, 1),
(10, '/news/boxburger.png', 'ACTIVE', 'Aproveita o teu desconto de 25%', 'PARCERIA', 'Façam como a Flávia e o Luís e comam no Box Burger.<br>Agora qualquer estudante de Engenharia Informática tem desconto de 25%. Basta apresentarem o cartão de estudante e informar que são de Engenharia Informática.<br>Do que estás à espera? Aproveita!', 111, '2019-10-17', NULL, NULL, 1),
(11, '/news/rally.jpg', 'ACTIVE', 'Aveiro Horror Story | Rally Tascas #2', 'EVENT', 'És aquele que boceja nos filmes de terror? Adormeceste enquanto dava a parte mais tramada do filme? Este Rally Tascas é para ti!<br>Vem pôr à prova a tua capacidade de engolir o medo no próximo dia 31, e habilita-te a ganhar um prémio!<br>O último Rally foi só o trailer... desta vez vens viver um episódio de terror!<br><br>Não percas a oportunidade e inscreve-te <a href=\https://nei.web.ua.pt/links/irally\ target=\_blank\>aqui!</a><br><br>Consulta o Regulamento <a href=\https://nei.web.ua.pt/links/rally\ target=\_blank\> aqui!</a>', 111, '2019-10-17', NULL, NULL, 1),
(12, '/news/sessfp.jpg', 'ACTIVE', '1ª Sessão de Dúvidas // Fundamentos de Programação', 'EVENT', 'O NEI está a organizar uma sessão de dúvidas que te vai ajudar a preparar de uma melhor forma para os teus exames da unidade curricular de Fundamentos da Porgramação.<br>A sessão vai ter lugar no dia 22 de outubro e ocorrerá no DETI entre as 18-22h.<br>É importante trazeres o teu material de estudo e o teu computador pessoal uma vez que nem todas as salas têm computadores à disposição.<br>As salas ainda não foram atribuídas, serão no dia do evento, está atento ao <a href=\https://www.facebook.com/events/493810694797695/\>nosso facebook!</a><br>', 111, '2019-10-18', NULL, NULL, 1),
(13, '/news/newNEI.png', 'ACTIVE', 'PWA NEI', 'NEWS', 'Agora o site do NEI já possui uma PWA, basta aceder ao site e carregar na notificação para fazer download da mesma.<br>Fica atento, em breve, terás novidades sobre uma plataforma para a Taça UA! Vais poder acompanhar tudo o que se passa e inclusivé ver os resultados do teu curso em direto.<br><img src=\https://nei.web.ua.pt/upload/NEI/pwa.jpg\ height=\400\/><img src=\https://nei.web.ua.pt/upload/NEI/pwa2.jpg\ height=\400\/>', 111, '2019-10-21', NULL, NULL, 1),
(14, '/news/const_cv.png', 'ACTIVE', 'Como construir um bom CV? by Olisipo', 'EVENT', 'Dada a competitividade atual do mercado de trabalho, apresentar um bom currículo torna-se cada vez mais indispensável. Desta forma, o NEI e o NEECT organizaram um workshop chamado \Como construir um bom CV?\, com o apoio da Olisipo. <br>Informações relevantes:<br><ul> <li> 7 de Novembro pelas 18h no DETI (Sala 102)</li> <li> Participação Gratuita</li> <li> INSCRIÇÕES OBRIGATÓRIAS</li> <li> INSCRIÇÕES LIMITADAS</li> <li> Inscrições <a href=\https://docs.google.com/forms/d/e/1FAIpQLSf4e3ZnHdp4INHrFgVCaXQv3pvVgkXrWN_U39s94X7Hvd98XA/viewform\ target=\_blank\>aqui</a></li></ul>  <br> Nesta atividade serão abordados diversos tópicos relativos à importância de um bom currículo e quais as formas corretas de o apresentar.', 111, '2019-11-02', NULL, 111, 1),
(15, '/news/apontamentos.png', 'ACTIVE', 'Apontamentos que já não precisas? Há quem precise!', 'NEWS', 'Tens apontamentos, resoluções ou qualquer outro material de estudo que já não precisas?Vem promover a inter-ajuda e entrega-os na sala do NEI (132) ou digitaliza-os e envia para nei@aauav.pt.Estarás a contribuir para uma base de dados de apontamentos mais sólida, organizada e completa para o nosso curso!Os alunos de informática agradecem!', 94, '2020-01-29', NULL, NULL, 1),
(16, '/news/nei_aniv.png', 'ACTIVE', '7º ANIVERSÁRIO DO NEI', 'EVENT', 'Foi no dia 25, há 7 anos atrás, que o TEU núcleo foi criado. Na altura chamado de Núcleo de Estudantes de Sistemas de Informação, mudou para o seu nome atual em 2014.Dos marcos do núcleo ao longo da sua história destacam-se o ENEI em 2014, o Think Twice em 2019 e as diversas presenças nas atividades em grande escala da AAUAv.Parabéns a todos os que contribuíram para o NEI que hoje temos!', 94, '2020-01-29', NULL, NULL, 1),
(17, '/news/delloitte_consultantforaday.png', 'ACTIVE', 'Queres ser consultor por um dia? A Deloitte dá-te essa oportunidade', 'EVENT', 'A Deloitte Portugal está a organizar o evento “Be a Consultant for a Day | Open House Porto”. Esta iniciativa dá-te acesso a um dia com várias experiências de desenvolvimento de competências e terás ainda a oportunidade de conhecer melhor as áreas de negócio integradas em consultoria tecnológica.O evento irá decorrer no Deloitte Studio do Porto e contará com alunos de várias Universidades da região Norte (Coimbra, Aveiro, Porto e Minho).', 94, '2020-01-29', NULL, NULL, 1),
(18, '/news/pub_rgm.png', 'ACTIVE', 'Primeira RGM Ordinária', 'EVENT', 'Convocam-se todos os membros de LEI e MEI para a 1ª RGM ordinária com a seguinte ordem de trabalhos:<br><br>1. Aprovação da ata da RGM anterior;<br>2. Apresentação do Plano de Atividades e Orçamento;<br>3. Aprovação do Plano de Atividades e Orçamento;<br>4. Discução relativa à modalidade do Evento do Aniversário do NEI;<br>5. Colaboradores do NEI;<br>6. Informações relativas à Barraca do Enterro 2020;<br>7. Discussão sobre as Unidades Curriculares do 1º Semestre;<br>8. Outros assuntos.<br><br>Link para o Plano de Atividades e Orçamento (PAO):<br>https://nei.web.ua.pt/upload/documents/PAO/2020/PAO_NEI2020.pdf<br><br>Na RGM serão discutidos assuntos relativos a TODOS os estudantes de informática.<br>Sendo assim, apelamos à participação de TODOS!', 94, '2020-02-18', '2020-02-18', 94, 1),
(19, '/news/colaboradores.jpg', 'ACTIVE', 'Vem ser nosso Colaborador!', 'EVENT', 'És um estudante ativo?<br>Procuras aprender novas competências e desenvolver novas?<br>Gostavas de ajudar o teu núcleo a proporcionar as melhores atividades da Universidade?<br>Se respondeste sim a pelo menos uma destas questões clica <a href=\https://forms.gle/3y5JZfNvN7rBjFZT8\ target=\_blank\>aqui</a><br>E preenche o formulário!<br>Sendo um colaborador do NEI vais poder desenvolver várias capacidades, sendo que maioria delas não são abordadas nas Unidades Curriculares!<br>Vais fazer amizades e a cima de tudo vais te divertir!<br>Junta-te a nós e ajuda o NEI a desenvolver as melhores atividades possíveis!', 94, '2020-02-19', NULL, NULL, 1),
(20, '/news/dia-syone.jpg', 'ACTIVE', 'Dia da Syone', 'EVENT', 'A Syone é uma empresa portuguesa provedora de Open Software Solutions.<br/>Neste dia podes participar num workshop, almoço gratuito e num mini-hackathon com prémios! <i class=\fa fa-trophy\ style=\color: gold\></i><br/>Garante já a tua presença através do <a href=\https://forms.gle/62yYsFiiiZXoTiaR8\ target=\_blank\>formulário</a>.<br/>O evento está limitado a 30 pessoas!', 94, '2020-02-26', NULL, NULL, 1),
(21, '/news/roundtable.jpg', 'ACTIVE', 'Round Table - Bolsas de Investigação', 'EVENT', 'Gostavas de estudar e de ao mesmo tempo desenvolver trabalho de investigação? E se com isto tiveres acesso a uma bolsa?<br/>Aparece nesta round table com os docentes responsáveis pelas bolsas de investigação e vem esclarecer todas as tuas dúvidas!', 94, '2020-02-26', '2020-03-01', 94, 1),
(22, '/news/jogos-marco.jpg', 'ACTIVE', 'Calendário dos Jogos de março', 'EVENT', 'Não percas os jogos do teu curso na Taça UA para o mês de março!<br/>Aparece ao máximo de jogos possível para apoiares o teu curso em todas as modalidades.<br/>Vem encher a bancada e fazer parte da melhor claque da UA! Contamos contigo e o teu magnifico apoio!', 94, '2020-03-01', NULL, NULL, 1),
(23, '/news/hackathome.png', 'ACTIVE', 'HackatHome', 'EVENT', 'Tens andado aborrecido nesta quarentena? É contigo em mente que decidimos contornar esta triste situação e organizar um HackatHome!<br/>O HackatHome é uma competição de programação online promovida pelo NEI que consiste na resolução de uma coleção de desafios de programação.<br/>A partir desta quarta feira, e todas as quartas durante as próximas 12 semanas(!), será disponibilizado um desafio, o qual os participantes têm até à quarta-feira seguinte para resolver (1 semana).<br/>Toda a competição assentará na plataforma GitHub Classroom, utilizada para requisitar e submeter os desafios. As pontuações são atribuídas por desafio, e ganha o participante com mais pontos acumulados ao final das 12 semanas!<br/>Não há processo de inscrição, apenas tens de estar atento à divulgação dos links dos desafios nos meios de comunicação do NEI, resolver e submeter através da tua conta GitHub!<br/>Além do prémio do vencedor, será também premiado um participante aleatório! Interessante não? &#129300;<br/>Consulta o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_HackatHome.pdf\ target=\_blank\>regulamento</a>!<br/>E prepara-te para a competição! &#128170;<br/><h2><b>Desafios</b></h2><h4><a href=\https://bit.ly/3bJBNaA\ target=\_blank\>Desafio 1</a></h4><h4><a href=\https://bit.ly/2Rnuy03\ target=\_blank\>Desafio 2</a></h4><h4><a href=\https://bit.ly/2wKmZJW\ target=\_blank\>Desafio 3</a></h4><h4><a href=\http://tiny.cc/Desafio4\ target=\_blank\>Desafio 4</a></h4><h4><a href=\http://tiny.cc/DESAFIO5\ target=\_blank\>Desafio 5</a></h4><h4><a href=\http://tiny.cc/Desafio6\ target=\_blank\>Desafio 6</a></h4><h4><a href=\http://tiny.cc/Desafio7\ target=\_blank\>Desafio 7</a></h4>', 94, '2020-03-30', '2020-05-13', 94, 1),
(24, '/news/pleiathome.png', 'ACTIVE', 'PLEIATHOME', 'EVENT', 'O PL<b style=\color: #59CD00\>EI</b>ATHOME é um conjunto de mini-torneios de jogos online que se vão desenrolar ao longo do semestre. As equipas acumulam \pontos PLEIATHOME\ ao longo dos mini-torneios, sendo que os vencedores finais ganham prémios!<br/>Organiza a tua equipa e vai participar em mais uma saga AtHome do NEI!Podes consultar o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_PLEIATHOME.pdf\ target=\_blank\>regulamento</a> do evento.<br/><br/><b><big>FIRST TOURNAMENT</big></b><br/>KABOOM!! Chegou o primeiro torneio da competição PL<b style=\color: #59CD00\>EI</b>ATHOME, com o jogo Bombtag!<br/>O mini-torneio terá início dia 10 de abril pelas 19h, inscreve-te neste <a href=\https://bit.ly/3dXrAsU\ target=\_blank\>formulário</a> do Kaboom.<br/>E consulta o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_Kaboom.pdf\ target=\_blank\>regulamento</a> do Kaboom.<br/>Vamos lá!<br/><br/><b><big>SECOND TOURNAMENT</big></b><br/>SpeedTux &#128039;&#128168; Chegou o segundo torneio PL<b style=\color: #59CD00\>EI</b>ATHOME, com o clássico SuperTux!<br/>O mini-torneio terá início dia 24 de abril, pelas 19h. Inscreve-te neste <a href=\https://bit.ly/34ClZE3\ target=\_blank\>formulário</a> até às 12h desse mesmo dia. E consulta o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_SpeedTux.pdf\ target=\_blank\>regulamento</a> do SpeedTux.<br/>Estás à altura? &#128170;<br/><br/><b><big>THIRD TOURNAMENT</big></b><br/>Races à La Kart! Chegou mais um torneio PL<b style=\color: #59CD00\>EI</b>ATHOME, com o famoso TrackMania!<br/>O mini-torneio terá início dia 8 de maio (sexta-feira) pelas 19h, inscreve-te no <a href=\tiny.cc/racesalakart\ target=\_blank\>formulário</a> e consulta o <a href=\https://nei.web.ua.pt/upload/NEI/Regulamento_Races_a_la_KART.pdf\ target=\_blank\>regulamento</a>.<br/>Descobre se és o mais rápido! &#127988;', 94, '2020-04-06', '2020-05-04', 94, 1),
(25, '/news/nei_lol.png', 'ACTIVE', 'Torneio Nacional de LoL', 'EVENT', 'Como a vida não é só trabalho, vem divertir-te a jogar e representar a Universidade de Aveiro em simultâneo! O NEEEC-FEUP está a organizar um torneio de League of Legends inter-universidades a nível nacional, e a UA está apta para participar.<br/>Existirá uma ronda de qualificação em Aveiro para determinar as 2 equipas que participam nacionalmente. O torneio é de inscrição gratuita e garante prémios para as equipas que conquistem o 1º e 2º lugar!<br/>Forma equipa e mostra o que vales!<br/><a href=\http://tiny.cc/torneioLOL\ target=\_blank\>Inscreve-te</a>!', 94, '2020-05-13', NULL, NULL, 1),
(26, '/news/202122/96.jpg', 'ACTIVE', 'Roots Beach Club', 'EVENT', '<p>A primeira semana de aulas vai terminar em grande!</p><p>Na sexta-feira vem ao Roots Beach Club para uma beach party incrível.</p><p>A pulseira do evento garante o transporte desde Aveiro até à Praia da Barra, um teste antigénio à covid e a entrada no bar com uma bebida incluída!</p><p>Reserva a tua pulseira terça feira das 16h às 19h na sala 4.1.32.</p>', 83, '2021-10-10', NULL, NULL, 1);



--
-- Data for Name: note; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.note (id, subject_id, author_id, teacher_id, year, name, location, summary, tests, bibliography, slides, exercises, projects, notebook, content, created_at, size) VALUES
(1, 40337, NULL, 5, 2014, 'MPEI Exemplo Teste 2014', '/note/segundo_ano/primeiro_semestre/mpei/MP_Exemplo_Teste.pdf', 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
(2, 40337, 101, 4, 2017, 'Diversos - 2017/2018 (zip)', '/note/segundo_ano/primeiro_semestre/mpei/RafaelDireito_2017_2018_MPEI.zip', 1, 0, 1, 1, 1, 0, 0, NULL, '2021-06-14 19:17:30', 35),
(3, 40337, 19, 5, 2014, 'Resumos Teóricos (zip)', '/note/segundo_ano/primeiro_semestre/mpei/Resumos_Teoricas.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos_Teóricas</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 8),
(4, 40379, 49, 27, 2018, 'Resumos FP 2018/2019 (zip)', '/note/primeiro_ano/primeiro_semestre/fp/Goncalo_FP.zip', 1, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aulas Práticas</dt><dd><dd>148 pastas</dd><dd>132 ficheiros</dd><dd></dl><dl><dt>Resumos</dt><dd><dd>1 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Testes para praticar</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Visualize Cod...</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 30),
(5, 40379, 101, NULL, 2016, 'Material FP 2016/2017 (zip)', '/note/primeiro_ano/primeiro_semestre/fp/RafaelDireito_FP_16_17.zip', 1, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>34 pastas</dd><dd>30 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 14),
(6, 40379, NULL, NULL, 2018, 'Resoluções 18/19', '/note/primeiro_ano/primeiro_semestre/fp/resolucoes18_19.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>18-19</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(7, 40380, NULL, 8, NULL, 'Apontamentos Globais', '/note/primeiro_ano/primeiro_semestre/itw/apontamentos001.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 3),
(8, 40381, NULL, NULL, 2015, 'Questões de SO (zip)', '/note/segundo_ano/primeiro_semestre/so/Questões.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Quest?es</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(9, 40381, 101, 1, 2017, 'Diversos - 2017/2018 (zip)', '/note/segundo_ano/primeiro_semestre/so/RafaelDireito_2017_2018_SO.zip', 1, 0, 0, 1, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>46 pastas</dd><dd>43 ficheiros</dd><dd></dl><dl><dt>Rafael_Diteit...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 35),
(10, 40383, 66, 12, 2015, 'Apontamentos Diversos (zip)', '/note/segundo_ano/segundo_semestre/pds/JoaoAlegria_PDS.zip', 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_R...</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>JoaoAlegria_E...</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 6),
(11, 40383, 66, 12, 2015, 'Resumos de 2015/2016', '/note/segundo_ano/segundo_semestre/pds/pds_apontamentos_001.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 4),
(12, 40383, NULL, NULL, NULL, 'Apontamentos genéricos I', '/note/segundo_ano/segundo_semestre/pds/pds_apontamentos_002.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
(13, 40383, NULL, NULL, NULL, 'Apontamentos genéricos II', '/note/segundo_ano/segundo_semestre/pds/pds_apontamentos_003.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
(14, 40385, 54, 12, NULL, 'Diversos - CBD Prof. JLO (zip)', '/note/terceiro_ano/primeiro_semestre/cbd/InesCorreia_CBD(CC_JLO).zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>InesCorreia_C...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2),
(15, 40431, 10, 13, 2014, 'MAS 2014/2015 (zip)', '/note/primeiro_ano/segundo_semestre/mas/BarbaraJael_14_15_MAS.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>resumo-mas.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 14),
(16, 40431, 40, 13, 2018, 'Preparação para Exame Final de MAS', '/note/primeiro_ano/segundo_semestre/mas/Duarte_MAS.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
(17, 40431, 101, 13, 2016, 'MAS 2016/2017 (zip)', '/note/primeiro_ano/segundo_semestre/mas/RafaelDireito_2016_2017_MAS.zip', 1, 0, 1, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 19),
(18, 40431, 15, 13, 2017, 'Resumos_MAS', '/note/primeiro_ano/segundo_semestre/mas/Resumos_MAS_Carina.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>MAS_Resumos.pdf</dt><dd><dd></dl><dl><dt>MAS_Resumos2.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 8),
(19, 40432, NULL, NULL, NULL, 'Resolução das fichas (zip)', '/note/segundo_ano/primeiro_semestre/smu/Resoluçao_das_fichas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resoluçao das fichas</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 27),
(20, 40432, NULL, NULL, NULL, 'Resumos (zip)', '/note/segundo_ano/primeiro_semestre/smu/Resumo.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 116),
(21, 40432, 10, 26, 2013, 'Resumos de 2013/2014', '/note/segundo_ano/primeiro_semestre/smu/smu_apontamentos_001.pdf', 1, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 11),
(22, 40432, 19, 15, 2016, 'Resumos de 2016/2017', '/note/segundo_ano/primeiro_semestre/smu/smu_apontamentos_002.pdf', 1, 1, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 2),
(23, 40432, 111, 15, 2017, 'Resumos de 2017/2018', '/note/segundo_ano/primeiro_semestre/smu/smu_apontamentos_003.pdf', 1, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 7),
(24, 40432, NULL, NULL, NULL, 'Resumos 2018/19', '/note/segundo_ano/primeiro_semestre/smu/SMU_Resumos.pdf', 1, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 4),
(25, 40433, NULL, NULL, NULL, 'Resumos (zip)', '/note/segundo_ano/primeiro_semestre/rs/Resumo.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 24),
(26, 40433, 10, 16, 2014, 'Caderno', '/note/segundo_ano/primeiro_semestre/rs/rs_apontamentos_001.pdf', 1, 0, 0, 0, 1, 0, 1, NULL, '2021-06-14 19:17:30', 6),
(27, 40436, 15, 31, 2017, 'Resumos_POO', '/note/primeiro_ano/segundo_semestre/poo/Carina_POO_Resumos.zip', 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>POO_Resumos_OT.pdf</dt><dd><dd></dl><dl><dt>POO_Resumos.pdf</dt><dd><dd></dl><dl><dt>POO_resumos_v2.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 6),
(28, 40436, 49, 28, 2018, 'Resumos POO 2018/2019 (zip)', '/note/primeiro_ano/segundo_semestre/poo/Goncalo_POO.zip', 1, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Apontamentos</dt><dd><dd>1 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Aulas Práticas</dt><dd><dd>17 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 4),
(29, 40436, 101, NULL, 2016, 'Diversos - Prática e Teórica (zip)', '/note/primeiro_ano/segundo_semestre/poo/RafaelDireito_2016_2017_POO.zip', 1, 1, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>495 pastas</dd><dd>492 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 43),
(30, 40436, NULL, NULL, NULL, 'Resumos Teóricos (zip)', '/note/primeiro_ano/segundo_semestre/poo/Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 22),
(31, 40437, 19, 17, 2016, 'Resumos de 2016/2017', '/note/segundo_ano/primeiro_semestre/aed/aed_apontamentos_001.pdf', 1, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 5),
(32, 40437, NULL, NULL, NULL, 'Bibliografia (zip)', '/note/segundo_ano/primeiro_semestre/aed/bibliografia.zip', 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Linguagem C -...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 33),
(33, 40751, 66, NULL, 2016, 'Resumos 2016/2017', '/note/mestrado/aa/aa_apontamentos_001.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
(34, 40752, 66, NULL, 2017, 'Exames 2017/2018', '/note/mestrado/tai/tai_apontamentos_001.pdf', 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
(35, 40752, 66, NULL, 2016, 'Teste Modelo 2016/2017', '/note/mestrado/tai/tai_apontamentos_002.pdf', 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 3),
(36, 40752, 66, NULL, 2016, 'Ficha de Exercícios 1 - 2016/2017', '/note/mestrado/tai/tai_apontamentos_003.pdf', 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 5),
(37, 40752, 66, NULL, 2016, 'Ficha de Exercícios 2 - 2016/2017', '/note/mestrado/tai/tai_apontamentos_004.pdf', 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 3),
(38, 40753, 66, NULL, 2016, 'Resumos 2016/2017', '/note/mestrado/cle/cle_apontamentos_001.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 12),
(39, 40756, 66, NULL, 2016, 'Resumos 2016/2017', '/note/mestrado/gic/gic_apontamentos_001.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 12),
(40, 40846, 19, 30, 2017, 'Resumos 2017/2018', '/note/terceiro_ano/primeiro_semestre/ia/ia_apontamentos_002.pdf', 1, 1, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 6),
(41, 41469, NULL, 10, 2015, 'Aulas Teóricas (zip)', '/note/segundo_ano/segundo_semestre/c/Aulas_Teóricas.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aulas Teóricas</dt><dd><dd>41 pastas</dd><dd>27 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 6),
(42, 41469, NULL, NULL, NULL, 'Guião de preparacao para o teste prático (zip)', '/note/segundo_ano/segundo_semestre/c/Guião_de _preparacao_para_o_teste_pratico.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Gui?o de prep...</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(43, 41549, NULL, NULL, NULL, 'Apontamentos Diversos (zip)', '/note/segundo_ano/segundo_semestre/ihc/Apontamentos.zip', 1, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Apontamentos</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 16),
(44, 41549, 66, 9, 2014, 'Avaliação Heurística', '/note/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_001.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
(45, 41549, 10, 9, 2014, 'Resumos de 2014/2015', '/note/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_002.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 3),
(46, 41549, NULL, 9, NULL, 'Resolução de fichas (zip)', '/note/segundo_ano/segundo_semestre/ihc/Resolução_de_fichas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resoluç?o de fichas</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 14),
(47, 41791, 10, NULL, 2014, 'Apontamentos EF (zip)', '/note/primeiro_ano/primeiro_semestre/ef/BarbaraJael_EF.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>BarbaraJael_1...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 4),
(48, 41791, 101, 24, 2017, 'Exercícios 2017/2018', '/note/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_001.pdf', 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
(49, 41791, 101, NULL, 2016, 'Exercícios 2016/17', '/note/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_002.pdf', 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 7),
(50, 41791, 49, 29, 2018, 'Resumos EF 2018/2019 (zip)', '/note/primeiro_ano/primeiro_semestre/ef/Goncalo_EF.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Documento_Obt...pdf</dt><dd><dd></dl><dl><dt>Documento_Tra...pdf</dt><dd><dd></dl><dl><dt>P4_7-12.pdf</dt><dd><dd></dl><dl><dt>PL1_Ótica.pdf</dt><dd><dd></dl><dl><dt>PL2_Pêndulo E...pdf</dt><dd><dd></dl><dl><dt>PL2_Pêndulo E...jpg</dt><dd><dd></dl><dl><dt>PL2_Pêndulo E...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração.pdf</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL4_Relatório.pdf</dt><dd><dd></dl><dl><dt>PL_Pauta Final.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 5),
(51, 41791, 96, 29, 2018, 'Exercícios 2018/19', '/note/primeiro_ano/primeiro_semestre/ef/Pedro_Oliveira_2018_2019.zip', 0, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pedro Oliveira</dt><dd><dd>6 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 28),
(52, 42502, 96, 6, 2017, 'Apontamentos e Resoluções (zip)', '/note/primeiro_ano/segundo_semestre/iac/PedroOliveira.zip', 0, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pedro Oliveira</dt><dd><dd>10 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 23),
(53, 42532, 19, 7, 2016, 'Caderno - 2016/2017', '/note/segundo_ano/segundo_semestre/bd/bd_apontamentos_001.pdf', 1, 0, 0, 0, 1, 0, 1, NULL, '2021-06-14 19:17:30', 2),
(54, 42532, 66, 7, 2014, 'Resumos - 2014/2015', '/note/segundo_ano/segundo_semestre/bd/bd_apontamentos_002.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
(55, 42532, NULL, 7, NULL, 'Resumos globais', '/note/segundo_ano/segundo_semestre/bd/BD_Resumos.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 8),
(56, 42532, NULL, 7, 2014, 'Slides das Aulas Teóricas (zip)', '/note/segundo_ano/segundo_semestre/bd/Slides_Teoricas.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides_Teoricas</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 21),
(57, 42573, NULL, NULL, NULL, 'Outros Resumos (zip)', '/note/terceiro_ano/primeiro_semestre/sio/Outros_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Outros Resumos</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 3),
(58, 42573, NULL, NULL, NULL, 'Resumo geral de segurança I', '/note/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_001.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
(59, 42573, NULL, NULL, NULL, 'Resumo geral de segurança II', '/note/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_002.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
(60, 42573, 10, 3, 2015, 'Resumos de 2015/2016', '/note/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_003.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 8),
(61, 42573, NULL, NULL, NULL, 'Resumo geral de segurança III', '/note/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_004.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
(62, 42573, NULL, NULL, NULL, 'Apontamentos genéricos', '/note/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_005.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1),
(63, 42709, 19, 23, 2015, 'Resumos de ALGA (zip)', '/note/primeiro_ano/primeiro_semestre/alga/Carolina_Albuquerque_ALGA.zip', 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>ALGA - Resumo...pdf</dt><dd><dd></dl><dl><dt>Exemplos da i...pdf</dt><dd><dd></dl><dl><dt>Exemplos de m...pdf</dt><dd><dd></dl><dl><dt>Exemplos de m...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 59),
(64, 42709, 36, 23, 2017, 'ALGA 2017/2018 (zip)', '/note/primeiro_ano/primeiro_semestre/alga/DiogoSilva_17_18_ALGA.zip', 0, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>DiogoSilva_17...</dt><dd><dd>0 pastas</dd><dd>26 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 21),
(65, 42709, 49, 19, 2018, 'Resumos ALGA 2018/2019 (zip)', '/note/primeiro_ano/primeiro_semestre/alga/Goncalo_ALGA.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_Matrizes e ...pdf</dt><dd><dd></dl><dl><dt>2_Determinantes.pdf</dt><dd><dd></dl><dl><dt>3_Vetores, re...pdf</dt><dd><dd></dl><dl><dt>4_Espaços vet...pdf</dt><dd><dd></dl><dl><dt>5_Valores e v...pdf</dt><dd><dd></dl><dl><dt>6_Cónicas e q...pdf</dt><dd><dd></dl><dl><dt>7_Aplicações ...pdf</dt><dd><dd></dl><dl><dt>Complemento_C...pdf</dt><dd><dd></dl><dl><dt>Complemento_C...pdf</dt><dd><dd></dl><dl><dt>Resumo Teste ...pdf</dt><dd><dd></dl><dl><dt>Resumo Teste ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 41),
(66, 42728, 94, 21, 2016, 'Resumos 2016/2017', '/note/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_001.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 16),
(67, 42728, 111, 21, 2016, 'Resumos 2016/2017', '/note/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_002.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 5),
(68, 42728, 101, 21, 2016, 'Teste Primitivas 2016/2017', '/note/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_003.pdf', 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
(69, 42728, 101, 21, 2016, 'Exercícios 2016/2017', '/note/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_004.pdf', 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 5),
(70, 42728, 101, 21, 2016, 'Resumos 2016/2017', '/note/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_005.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 11),
(71, 42728, 101, 21, 2016, 'Fichas 2016/2017', '/note/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_006.pdf', 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 22),
(72, 42728, 36, 21, 2017, 'CI 2017/2018 (zip)', '/note/primeiro_ano/primeiro_semestre/c1/DiogoSilva_17_18_C1.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>28821701_4498...jpg</dt><dd><dd></dl><dl><dt>28768155_4497...jpg</dt><dd><dd></dl><dl><dt>28927694_4497...jpg</dt><dd><dd></dl><dl><dt>28821773_4497...jpg</dt><dd><dd></dl><dl><dt>28876807_4497...jpg</dt><dd><dd></dl><dl><dt>28879472_4497...jpg</dt><dd><dd></dl><dl><dt>28822131_4497...jpg</dt><dd><dd></dl><dl><dt>28768108_4497...jpg</dt><dd><dd></dl><dl><dt>28811040_4497...jpg</dt><dd><dd></dl><dl><dt>28943154_4497...jpg</dt><dd><dd></dl><dl><dt>28879660_4497...jpg</dt><dd><dd></dl><dl><dt>28876653_4497...jpg</dt><dd><dd></dl><dl><dt>28768432_4497...jpg</dt><dd><dd></dl><dl><dt>28768056_4497...jpg</dt><dd><dd></dl><dl><dt>28877054_4497...jpg</dt><dd><dd></dl><dl><dt>28768634_4497...jpg</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2),
(73, 42728, 49, 18, 2018, 'Resumos Cálculo I 2018/2019 (zip)', '/note/primeiro_ano/primeiro_semestre/c1/Goncalo_C1.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>0_Formulário_...pdf</dt><dd><dd></dl><dl><dt>0_FORMULÁRIO_...pdf</dt><dd><dd></dl><dl><dt>0_Revisões se...pdf</dt><dd><dd></dl><dl><dt>1_Funções tri...pdf</dt><dd><dd></dl><dl><dt>2_Teoremas do...pdf</dt><dd><dd></dl><dl><dt>3_Integrais i...pdf</dt><dd><dd></dl><dl><dt>4_Integrais d...pdf</dt><dd><dd></dl><dl><dt>5_Integrais i...pdf</dt><dd><dd></dl><dl><dt>6_Séries numé...pdf</dt><dd><dd></dl><dl><dt>Formulário_Sé...pdf</dt><dd><dd></dl><dl><dt>Resumo_Integr...pdf</dt><dd><dd></dl><dl><dt>Tópicos_Teste 1.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 24),
(74, 42729, 94, 22, 2016, 'Caderno de 2016/2017', '/note/primeiro_ano/segundo_semestre/c2/calculoii_apontamentos_003.pdf', 0, 0, 0, 0, 0, 0, 1, NULL, '2021-06-14 19:17:30', 18),
(75, 42729, 49, 19, 2018, 'Resumos Cálculo II 2018/2019 (zip)', '/note/primeiro_ano/segundo_semestre/c2/Goncalo_C2.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>0_Revisões.pdf</dt><dd><dd></dl><dl><dt>1_Séries de p...pdf</dt><dd><dd></dl><dl><dt>2_Sucessões e...pdf</dt><dd><dd></dl><dl><dt>3.1_Funções r...pdf</dt><dd><dd></dl><dl><dt>3.2_Funções r...pdf</dt><dd><dd></dl><dl><dt>4_Equações di...pdf</dt><dd><dd></dl><dl><dt>5_Transformad...pdf</dt><dd><dd></dl><dl><dt>Detalhes para...pdf</dt><dd><dd></dl><dl><dt>Detalhes para...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 21),
(76, 44156, 66, 9, 2016, 'Resumos 2016/2017', '/note/mestrado/vi/vi_apontamentos_001.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 4),
(77, 44158, 66, 25, 2016, 'Resumos por capítulo (zip)', '/note/mestrado/ws/JoaoAlegria_ResumosPorCapítulo.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_R...</dt><dd><dd>0 pastas</dd><dd>10 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 8),
(78, 44158, 66, 25, 2016, 'Resumos 2016/2017', '/note/mestrado/ws/web_semantica_apontamentos_001.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 9),
(79, 45424, 54, NULL, 2016, 'Apontamentos Diversos', '/note/terceiro_ano/primeiro_semestre/icm/Inês_Correia_ICM.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
(80, 45426, 54, 13, 2016, 'Apontamentos Diversos', '/note/terceiro_ano/segundo_semestre/tqs/Inês_Correia_TQS.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 14),
(81, 45426, NULL, 13, 2016, 'Resumos (zip)', '/note/terceiro_ano/segundo_semestre/tqs/resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos_chave</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 22),
(82, 45426, 66, 13, 2015, 'Resumos 2015/2016', '/note/terceiro_ano/segundo_semestre/tqs/tqs_apontamentos_002.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 3),
(83, 45587, 66, 26, 2016, 'Resumos 2017/2018 - I', '/note/mestrado/ed/ed_dm_apontamentos_001.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 36),
(84, 45587, 66, 26, 2016, 'Resumos 2017/2018 - II', '/note/mestrado/ed/ed_dm_apontamentos_002.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 48),
(85, 47166, 49, 20, 2018, 'Resumos MD 2018/2019 (zip)', '/note/primeiro_ano/segundo_semestre/md/Goncalo_MD.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1.1_Lógica pr...pdf</dt><dd><dd></dl><dl><dt>1.2_Conjuntos.pdf</dt><dd><dd></dl><dl><dt>1.3_Relações ...pdf</dt><dd><dd></dl><dl><dt>1.4_Funções.pdf</dt><dd><dd></dl><dl><dt>1.5_Relações ...pdf</dt><dd><dd></dl><dl><dt>1.6_Lógica de...pdf</dt><dd><dd></dl><dl><dt>2_Contextos e...pdf</dt><dd><dd></dl><dl><dt>3_Princípios ...pdf</dt><dd><dd></dl><dl><dt>4_Permutações.pdf</dt><dd><dd></dl><dl><dt>5_Agrupamento...pdf</dt><dd><dd></dl><dl><dt>6_Recorrência...pdf</dt><dd><dd></dl><dl><dt>7_Elementos d...pdf</dt><dd><dd></dl><dl><dt>Detalhes capí...pdf</dt><dd><dd></dl><dl><dt>Detalhes capí...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 27),
(86, 47166, 15, NULL, 2017, 'Resumos 2017/2018', '/note/primeiro_ano/segundo_semestre/md/MD_Capitulo5.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 4),
(87, 47166, 101, NULL, 2016, 'RafaelDireito_2016_2017_MD.zip', '/note/primeiro_ano/segundo_semestre/mdmorphine/RafaelDireito_2016_2017_MD.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>11 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 24),
(88, 47166, 101, NULL, 2016, 'RafaelDireito_MD_16_17_Apontamentos (zip)', '/note/primeiro_ano/segundo_semestre/md/RafaelDireito_MD_16_17_Apontamentos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 4),
(89, 40337, 36, 4, 2018, 'DS_MPEI_18_19_Testes (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Testes.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Enunciados</dt><dd><dd>5 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>Teste 1 2015</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Teste 2 2015</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Teste 2 2017</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 23),
(90, 40337, 36, 4, 2018, 'DS_MPEI_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_SlidesTeoricos.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>MPEI-2017-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2017-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 27),
(91, 40337, 36, 4, 2018, 'DS_MPEI_18_19_Resumos (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo1</dt><dd><dd>0 pastas</dd><dd>39 ficheiros</dd><dd></dl><dl><dt>Resumo2</dt><dd><dd>0 pastas</dd><dd>24 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 209),
(92, 40337, 36, 4, 2018, 'DS_MPEI_18_19_Projeto (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Projeto.zip', 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>mpei.pptx</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 16),
(93, 40337, 36, 4, 2018, 'DS_MPEI_18_19_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P01</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>P02</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P03</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>P04</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>P05</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P06</dt><dd><dd>0 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>P07</dt><dd><dd>0 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>P08</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>Remakes</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 9),
(94, 40337, 36, 4, 2018, 'DS_MPEI_18_19_Livros (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Livros.zip', 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>estatistica-f...pdf</dt><dd><dd></dl><dl><dt>Livro.pdf</dt><dd><dd></dl><dl><dt>matlabnuminst...pdf</dt><dd><dd></dl><dl><dt>MATLAB_Starte...pdf</dt><dd><dd></dl><dl><dt>pt.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 6),
(95, 40337, 36, 4, 2018, 'DS_MPEI_18_19_Exercicios (zip)', '/note/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Exercicios.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>2</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>3</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Slides Exercicios</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 37),
(96, 40380, 49, 8, 2018, 'Goncalo_ITW_18_19_Testes (zip)', '/note/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Testes.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P7 05_Nov_201...</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>Teste teórico 1.zip</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(97, 40380, 49, 8, 2018, 'Goncalo_ITW_18_19_Resumos (zip)', '/note/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>ITW _ BOOTSTRAP.pdf</dt><dd><dd></dl><dl><dt>ITW _ CSS.pdf</dt><dd><dd></dl><dl><dt>ITW _ HTML.pdf</dt><dd><dd></dl><dl><dt>ITW _ JAVASCRIPT.pdf</dt><dd><dd></dl><dl><dt>JAVACRIPT _ E...pdf</dt><dd><dd></dl><dl><dt>JAVACRIPT _P6...pdf</dt><dd><dd></dl><dl><dt>Resumo_T10_Kn...pdf</dt><dd><dd></dl><dl><dt>Resumo_T11_Du...pdf</dt><dd><dd></dl><dl><dt>Resumo_T8_jQu...pdf</dt><dd><dd></dl><dl><dt>Resumo_T9_Goo...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 12),
(98, 40380, 49, 8, 2018, 'Goncalo_ITW_18_19_Projeto (zip)', '/note/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Projeto.zip', 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>P11 03_Nov_20...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>PROJETO</dt><dd><dd>147 pastas</dd><dd>147 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 33),
(99, 40380, 49, 8, 2018, 'Goncalo_ITW_18_19_Praticas (zip)', '/note/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P1 24_Set_2018</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P10 26_Nov_20...</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P11 03_Nov_20...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>P2 01_Out_2018</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>P3 08_Out_2018</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P4 15_Out_2018</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>P5 22_Out_2018</dt><dd><dd>1 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>P6 29_Out_2018</dt><dd><dd>1 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>P7 05_Nov_201...</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>P8 12_Nov_2018</dt><dd><dd>0 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>P9 19_Nov_201...</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 30),
(100, 40380, 101, 8, 2016, 'RafaelDireito_ITW_18_19_Testes (zip)', '/note/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Testes.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bootstrap+Tes...rar</dt><dd><dd></dl><dl><dt>Teste Prático ITW</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>Teste Teórico 2</dt><dd><dd>0 pastas</dd><dd>20 ficheiros</dd><dd></dl><dl><dt>Teste_Prático_ITW</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>Teste_Prático...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>ITW-Teste Teórico</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>ITW_Teste</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 9),
(101, 40380, 101, 8, 2016, 'RafaelDireito_ITW_18_19_Slides (zip)', '/note/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Slides.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aula 1 - Apre...pdf</dt><dd><dd></dl><dl><dt>Aula 1 -Intro...pdf</dt><dd><dd></dl><dl><dt>Aula 10 - Goo...pdf</dt><dd><dd></dl><dl><dt>Aula 11 - ITW...pdf</dt><dd><dd></dl><dl><dt>Aula 11 - Tra...pdf</dt><dd><dd></dl><dl><dt>Aula 2 - Form...pdf</dt><dd><dd></dl><dl><dt>Aula 3 - CSS.pdf</dt><dd><dd></dl><dl><dt>Aula 4 -Twitt...pdf</dt><dd><dd></dl><dl><dt>Aula 5 -Javas...pdf</dt><dd><dd></dl><dl><dt>Aula 7 -Javas...pdf</dt><dd><dd></dl><dl><dt>Aula 8 -JQuery.pdf</dt><dd><dd></dl><dl><dt>Aula 9 -JQuer...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 19),
(102, 40380, 101, 8, 2016, 'RafaelDireito_ITW_18_19_Praticas (zip)', '/note/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aula 8</dt><dd><dd>3 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Aula5-Js</dt><dd><dd>1 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>Aulas Práticas</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>Bilhete-Aviao</dt><dd><dd>6 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Calculadora-JS</dt><dd><dd>2 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Concerto- GER...</dt><dd><dd>3 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>Concerto-Jquery</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Concerto-Jque...</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Concerto-JS</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Conferencia</dt><dd><dd>6 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Gráficos</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>ITW java</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>ITW-Bootstrap_1</dt><dd><dd>20 pastas</dd><dd>26 ficheiros</dd><dd></dl><dl><dt>ITW_jQuery</dt><dd><dd>3 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Links de Apoi...txt</dt><dd><dd></dl><dl><dt>Mapa</dt><dd><dd>3 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Treino-ITW-2</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Weather</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>GitHub-  stor.txt</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 18),
(103, 40381, 36, 1, 2018, 'DS_SO_18_19_Testes (zip)', '/note/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Testes.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Enunciados</dt><dd><dd>1 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Teorico-Pratico</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Teste 2015</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Teste 2017</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 46),
(104, 40381, 36, 1, 2018, 'DS_SO_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/primeiro_semestre/so/DS_SO_18_19_SlidesTeoricos.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>sop_1819_0918...pdf</dt><dd><dd></dl><dl><dt>sop_1819_1002...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1023...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1030...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1106...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1120...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1127...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1204...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1211...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1218...ppt</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 11),
(105, 40381, 36, 1, 2018, 'DS_SO_18_19_ResumosTeoricos (zip)', '/note/segundo_ano/primeiro_semestre/so/DS_SO_18_19_ResumosTeoricos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Teorico</dt><dd><dd>0 pastas</dd><dd>43 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 157),
(106, 40381, 36, 1, 2018, 'DS_SO_18_19_ResumosPraticos (zip)', '/note/segundo_ano/primeiro_semestre/so/DS_SO_18_19_ResumosPraticos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pratico</dt><dd><dd>0 pastas</dd><dd>38 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 122),
(107, 40381, 36, 1, 2018, 'DS_SO_18_19_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P01</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P02</dt><dd><dd>1 pastas</dd><dd>24 ficheiros</dd><dd></dl><dl><dt>P03</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P04</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>P05</dt><dd><dd>2 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>P06</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P07</dt><dd><dd>0 pastas</dd><dd>10 ficheiros</dd><dd></dl><dl><dt>P08</dt><dd><dd>1 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P09</dt><dd><dd>7 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P10</dt><dd><dd>3 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>P11</dt><dd><dd>1 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Remakes</dt><dd><dd>24 pastas</dd><dd>18 ficheiros</dd><dd></dl><dl><dt>Remakes2</dt><dd><dd>9 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 5),
(108, 40381, 36, 1, 2018, 'DS_SO_18_19_Fichas (zip)', '/note/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Fichas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Enunciados</dt><dd><dd>10 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Ficha 1</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>Ficha 2</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Ficha 3</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Ficha NEI 1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Ficha NEI 2</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Ficha NEI 4</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 51),
(109, 40382, NULL, NULL, NULL, 'CD_18_19_Livros (zip)', '/note/segundo_ano/segundo_semestre/cd/CD_18_19_Livros.zip', 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Distributed_S...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 19),
(110, 40382, 36, 2, 2018, 'DS_CD_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/segundo_semestre/cd/DS_CD_18_19_SlidesTeoricos.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aula 1.pdf</dt><dd><dd></dl><dl><dt>Aula 2.pdf</dt><dd><dd></dl><dl><dt>Aula 3.pdf</dt><dd><dd></dl><dl><dt>Aula 4.pdf</dt><dd><dd></dl><dl><dt>Aula 6.pdf</dt><dd><dd></dl><dl><dt>Aula 7.pdf</dt><dd><dd></dl><dl><dt>Aula 8.pdf</dt><dd><dd></dl><dl><dt>Cloud Computing.pdf</dt><dd><dd></dl><dl><dt>Flask.pdf</dt><dd><dd></dl><dl><dt>Syllabus.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 32),
(111, 40382, 36, 2, 2018, 'DS_CD_18_19_Resumos (zip)', '/note/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>CDresumoch6.docx</dt><dd><dd></dl><dl><dt>CDresumoch6.pdf</dt><dd><dd></dl><dl><dt>CDresumoch7.docx</dt><dd><dd></dl><dl><dt>CDresumoch7.pdf</dt><dd><dd></dl><dl><dt>CDresumoch8.docx</dt><dd><dd></dl><dl><dt>GIT 101.pdf</dt><dd><dd></dl><dl><dt>Resumo Ch1-4</dt><dd><dd>0 pastas</dd><dd>104 ficheiros</dd><dd></dl><dl><dt>Resumos Ch5-8</dt><dd><dd>0 pastas</dd><dd>34 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 309),
(112, 40382, 36, 2, 2018, 'DS_CD_18_19_Projetos (zip)', '/note/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Projetos.zip', 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>Projeto 1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Projeto 2</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(113, 40382, 36, 2, 2018, 'DS_CD_18_19_Praticas (zip)', '/note/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P01</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>P02</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P03</dt><dd><dd>36 pastas</dd><dd>36 ficheiros</dd><dd></dl><dl><dt>P04</dt><dd><dd>6 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 3),
(114, 40383, 36, 12, 2018, 'DS_PDS_18_19_Testes (zip)', '/note/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Testes.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Teste 2019</dt><dd><dd>0 pastas</dd><dd>26 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(115, 40383, 36, 12, 2018, 'DS_PDS_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_SlidesTeoricos.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>PDS_0.pdf</dt><dd><dd></dl><dl><dt>PDS_09_Lambda...pdf</dt><dd><dd></dl><dl><dt>PDS_1_Softwar...pdf</dt><dd><dd></dl><dl><dt>PDS_2_GRASP.pdf</dt><dd><dd></dl><dl><dt>PDS_3_Pattern...pdf</dt><dd><dd></dl><dl><dt>PDS_4_Creatio...pdf</dt><dd><dd></dl><dl><dt>PDS_5_Structu...pdf</dt><dd><dd></dl><dl><dt>PDS_6_Behavio...pdf</dt><dd><dd></dl><dl><dt>PDS_7_Softwar...pdf</dt><dd><dd></dl><dl><dt>PDS_8_Reflection.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 81),
(116, 40383, 36, 12, 2018, 'DS_PDS_18_19_Resumos (zip)', '/note/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo 1</dt><dd><dd>0 pastas</dd><dd>35 ficheiros</dd><dd></dl><dl><dt>Resumo 2</dt><dd><dd>0 pastas</dd><dd>25 ficheiros</dd><dd></dl><dl><dt>Resumo 3</dt><dd><dd>0 pastas</dd><dd>25 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 185),
(117, 40383, 36, 12, 2018, 'DS_PDS_18_19_Praticas (zip)', '/note/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Guioes</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>pds_2019_g22</dt><dd><dd>70 pastas</dd><dd>61 ficheiros</dd><dd></dl><dl><dt>PraticasRemade</dt><dd><dd>277 pastas</dd><dd>276 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 6),
(118, 40431, NULL, NULL, NULL, 'MAS_18_19_Bibliografia (zip)', '/note/primeiro_ano/segundo_semestre/mas/MAS_18_19_Bibliografia.zip', 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bibliografia_...pdf</dt><dd><dd></dl><dl><dt>Bibliografia_...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 6),
(119, 40431, NULL, 13, 2018, 'MAS_18_19_Topicos_Estudo_Exame (zip)', '/note/primeiro_ano/segundo_semestre/mas/MAS_18_19_Topicos_Estudo_Exame.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>MAS 201819 - ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(120, 40431, 49, 13, 2018, 'Goncalo_MAS_18_19_Resumos (zip)', '/note/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1. O que é qu...pdf</dt><dd><dd></dl><dl><dt>2. Modelos de...pdf</dt><dd><dd></dl><dl><dt>3. Modelos no...pdf</dt><dd><dd></dl><dl><dt>MAA_Resumos.pdf</dt><dd><dd></dl><dl><dt>Post-it.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 10),
(121, 40431, 49, 13, 2018, 'Goncalo_MAS_18_19_Projeto (zip)', '/note/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Projeto.zip', 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>AMS-E3-Visao ...docx</dt><dd><dd></dl><dl><dt>Apresentacion...pdf</dt><dd><dd></dl><dl><dt>Apresentaç?o ...odt</dt><dd><dd></dl><dl><dt>CalEntregas.png</dt><dd><dd></dl><dl><dt>Elaboration 1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Gui?o.pdf</dt><dd><dd></dl><dl><dt>Inception1</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>JMeter</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>MAS - Projeto...pdf</dt><dd><dd></dl><dl><dt>MicroSite</dt><dd><dd>24 pastas</dd><dd>20 ficheiros</dd><dd></dl><dl><dt>Projeto.zip</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 22),
(122, 40431, 49, 13, 2018, 'Goncalo_MAS_18_19_Praticas (zip)', '/note/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Lab1</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>Lab2</dt><dd><dd>1 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Lab3</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>Lab5</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Lab6</dt><dd><dd>1 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>Lab7</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>MAS_Práticas-...zip</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 46),
(123, 40432, 101, 15, 2017, 'RafaelDireito_SMU_17_18_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P</dt><dd><dd>11 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>12 pastas</dd><dd>12 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 40),
(124, 40432, 101, 15, 2017, 'RafaelDireito_SMU_17_18_TP (zip)', '/note/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_TP.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>TP</dt><dd><dd>0 pastas</dd><dd>10 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 68),
(125, 40432, 101, 15, 2017, 'RafaelDireito_SMU_17_18_Prep2Test (zip)', '/note/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Prep2Teste.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Prep2Teste</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 3),
(126, 40432, 101, 15, 2017, 'RafaelDireito_SMU_17_18_Bibliografia (zip)', '/note/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Bibliografia.zip', 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bibliografia</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 54),
(127, 40432, 36, 14, 2018, 'DS_SMU_18_19_Fichas (zip)', '/note/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Fichas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>12 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>13 pastas</dd><dd>13 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 113),
(128, 40432, 36, 14, 2018, 'DS_SMU_18_19_Livros (zip)', '/note/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Livros.zip', 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Livros</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 54),
(129, 40432, 36, 14, 2018, 'DS_SMU_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_SlidesTeoricos.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Teoricos</dt><dd><dd>1 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>2 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 30),
(130, 40432, 36, 14, 2018, 'DS_SMU_18_19_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Praticas</dt><dd><dd>19 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>20 pastas</dd><dd>20 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 26),
(131, 40432, 36, 14, 2018, 'DS_SMU_18_19_Resumos (zip)', '/note/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 181),
(132, 40432, 36, 14, 2018, 'DS_SMU_18_19_Testes (zip)', '/note/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Testes.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>8 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>9 pastas</dd><dd>9 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 60),
(133, 40433, 36, 16, 2018, 'DS_RS_18_19_Testes (zip)', '/note/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Testes.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>16 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>17 pastas</dd><dd>17 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 130),
(134, 40433, 36, 16, 2018, 'DS_RS_18_19_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Praticas</dt><dd><dd>2 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2),
(135, 40433, 36, 16, 2018, 'DS_RS_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_SlidesTeoricos.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Teoricos</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 10),
(136, 40433, 36, 16, 2018, 'DS_RS_18_19_Resumos (zip)', '/note/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(137, 40437, 36, 11, 2018, 'DS_AED_18_19_Resumos (zip)', '/note/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 271),
(138, 40437, 36, 11, 2018, 'DS_AED_18_19_Livros (zip)', '/note/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Livros.zip', 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Livros</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 20),
(139, 40437, 36, 11, 2018, 'DS_AED_18_19_Testes (zip)', '/note/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Testes.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>24 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>25 pastas</dd><dd>25 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 94),
(140, 40437, 36, 11, 2018, 'DS_AED_18_19_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pr?Çáticas</dt><dd><dd>21 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>20 pastas</dd><dd>20 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 20),
(141, 40437, 36, 11, 2018, 'DS_AED_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_SlidesTeoricos.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Te?óricos</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2),
(142, 40437, 36, 11, 2018, 'DS_AED_18_19_Fichas (zip)', '/note/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Fichas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 16);
INSERT INTO nei.note (id, subject_id, author_id, teacher_id, year, name, location, summary, tests, bibliography, slides, exercises, projects, notebook, content, created_at, size) VALUES
(143, 40437, 101, 31, 2017, 'RafaelDireito_AED_17_18_Praticas (zip)', '/note/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P</dt><dd><dd>4 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>5 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(144, 40437, 101, 31, 2017, 'RafaelDireito_AED_17_18_Testes (zip)', '/note/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Testes.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(145, 40437, 101, 31, 2017, 'RafaelDireito_AED_17_18_Books (zip)', '/note/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Praticas.zip', 0, 0, 1, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', NULL),
(146, 40437, 101, 31, 2017, 'RafaelDireito_AED_17_18_LearningC (zip)', '/note/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_LearningC.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>LearningC</dt><dd><dd>0 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(147, 40437, 101, 31, 2017, 'RafaelDireito_AED_17_18_AED (pdf)', '/note/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_AED.pdf', 0, 0, 0, 1, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
(148, 41469, 36, 10, 2018, 'DS_Compiladores_18_19_Praticas (zip)', '/note/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Praticas</dt><dd><dd>35 pastas</dd><dd>32 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>31 pastas</dd><dd>31 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(149, 41469, 36, 10, 2018, 'DS_Compiladores_18_19_Fichas (zip)', '/note/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Fichas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 42),
(150, 41469, 36, 10, 2018, 'DS_Compiladores_18_19_Testes (zip)', '/note/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Testes.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 33),
(151, 41469, 36, 10, 2018, 'DS_Compiladores_18_19_Resumos (zip)', '/note/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 242),
(152, 41469, 36, 10, 2018, 'DS_Compiladores_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_SlidesTeoricos.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Te?óricos</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 4),
(153, 41549, 36, 9, 2018, 'DS_IHC_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_SlidesTeoricos.zip', 0, 0, 0, 1, 0, 0, 0, NULL, '2021-06-14 19:17:30', NULL),
(154, 41549, 36, 9, 2018, 'DS_IHC_18_19_Fichas (zip)', '/note/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_Fichas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>5 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>6 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 51),
(155, 41549, 36, 9, 2018, 'DS_IHC_18_19_Projetos (zip)', '/note/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_Projetos.zip', 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>Projetos</dt><dd><dd>5 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>6 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 90),
(156, 41549, 36, 9, 2018, 'DS_IHC_18_19_Testes (zip)', '/note/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_SlidesTeoricos.zip', 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', NULL),
(157, 40846, NULL, NULL, NULL, 'Resumos (zip)', '/note/terceiro_ano/primeiro_semestre/ia/resumo.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo.pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(158, 41791, 36, 24, 2017, 'DS_EF_17_18_Resumos (zip)', '/note/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 4),
(159, 41791, 36, 24, 2017, 'DS_EF_17_18_Exercicios (zip)', '/note/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Exercicios.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Exerci?ücios</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 3),
(160, 41791, 36, 24, 2017, 'DS_EF_17_18_Exames (zip)', '/note/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Exames.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Exames</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2),
(161, 42502, NULL, 6, NULL, 'Exames (zip)', '/note/primeiro_ano/segundo_semestre/iac/exames.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>iac_apontamen...pdf</dt><dd><dd></dl><dl><dt>iac_apontamen...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(162, 42502, 49, 6, 2018, 'Goncalo_IAC_18_19_Praticas (zip)', '/note/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pr?íticas</dt><dd><dd>113 pastas</dd><dd>111 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>113 pastas</dd><dd>113 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 44),
(163, 42502, 49, 6, 2018, 'Goncalo_IAC_18_19_Resumos (zip)', '/note/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 17),
(164, 42502, 49, 6, 2018, 'Goncalo_IAC_18_19_Apontamentos (zip)', '/note/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Apontamentos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Apontamentos</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 3),
(165, 42502, 49, 6, 2018, 'Goncalo_IAC_18_19_Bibliografia (zip)', '/note/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Bibliografia.zip', 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bibliografia ...pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Bibliografia ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 18),
(166, 42502, 49, 6, 2018, 'Goncalo_IAC_18_19_Testes (zip)', '/note/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Testes.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2),
(167, 42502, 101, 6, 2016, 'RafaelDireito_IAC_16_17_Testes (zip)', '/note/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Testes.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 3),
(168, 42502, 101, 6, 2016, 'RafaelDireito_IAC_16_17_Teorica (zip)', '/note/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Teorica.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Te?órica</dt><dd><dd>0 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 14),
(169, 42502, 101, 6, 2016, 'RafaelDireito_IAC_16_17_FolhasPraticas (zip)', '/note/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_FolhasPraticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>FolhasPr?Çáticas</dt><dd><dd>0 pastas</dd><dd>16 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 13),
(170, 42502, 101, 6, 2016, 'RafaelDireito_IAC_16_17_ExerciciosResolvidos (zip)', '/note/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_ExerciciosResolvidos.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>ExerciciosResolvidos</dt><dd><dd>6 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>7 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(171, 42502, 101, 6, 2016, 'RafaelDireito_IAC_16_17_Resumos (zip)', '/note/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDireito...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 10),
(172, 42502, 101, 6, 2016, 'RafaelDireito_IAC_16_17_DossiePedagogicov2 (zip)', '/note/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_DossiePedagogicov2.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>DossiePedagog...pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(173, 42532, 36, 7, 2018, 'DS_BD_18_19_SlidesTeoricos (zip)', '/note/segundo_ano/segundo_semestre/bd/DS_BD_18_19_SlidesTeoricos.zip', 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Te?óricos</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 30),
(174, 42532, 36, 7, 2018, 'DS_BD_18_19_Resumos (zip)', '/note/segundo_ano/segundo_semestre/bd/DS_BD_18_19_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>2 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 144),
(175, 42532, 36, 7, 2018, 'DS_BD_18_19_Praticas (zip)', '/note/segundo_ano/segundo_semestre/bd/DS_BD_18_19_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pr?Çáticas</dt><dd><dd>48 pastas</dd><dd>34 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>45 pastas</dd><dd>45 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 81),
(176, 42532, NULL, NULL, NULL, 'Resumos Diversos (zip)', '/note/segundo_ano/segundo_semestre/bd/Resumos.zip', 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 1),
(177, 41791, 19, 24, 2015, 'Resumos EF', '/note/primeiro_ano/primeiro_semestre/ef/CarolinaAlbuquerque_EF_Resumo.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 8),
(178, 41791, 19, 24, 2015, 'Resolução Fichas EF', '/note/primeiro_ano/primeiro_semestre/ef/CarolinaAlbuquerque_EF_ResolucoesFichas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>CarolinaAlbuq...</dt><dd><dd>6 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 169),
(179, 42573, 66, NULL, 2016, 'Exames SIO resolvidos', '/note/terceiro_ano/primeiro_semestre/sio/JoaoAlegria_Exames.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_Exames</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 13),
(180, 42573, 66, NULL, 2016, 'Resumos SIO', '/note/terceiro_ano/primeiro_semestre/sio/JoaoAlegria_Resumos.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_Resumos</dt><dd><dd>1 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 20),
(181, 42709, 101, 23, 2016, 'Exames e testes ALGA', '/note/primeiro_ano/primeiro_semestre/alga/Rafael_Direito_Exames.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 9),
(182, 42709, 101, 23, 2016, 'Fichas resolvidas ALGA', '/note/primeiro_ano/primeiro_semestre/alga/RafaelDireito_Fichas.pdf', 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 15),
(183, 42709, 101, 23, 2016, 'Resumos ALGA ', '/note/primeiro_ano/primeiro_semestre/alga/RafelDireito_Resumos.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 8),
(184, 42728, 19, 19, 2015, 'Caderno de cálculo', '/note/primeiro_ano/primeiro_semestre/c1/CarolinaAlbuquerque_C1_caderno.pdf', 0, 0, 0, 0, 0, 0, 1, NULL, '2021-06-14 19:17:30', 11),
(185, 42729, 96, 19, 2018, 'Fichas resolvidas CII', '/note/primeiro_ano/segundo_semestre/c2/PedroOliveira_Fichas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Ficha1</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>Ficha2</dt><dd><dd>0 pastas</dd><dd>15 ficheiros</dd><dd></dl><dl><dt>Ficha3</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>ficha3-part2.pdf</dt><dd><dd></dl><dl><dt>ficha3.pdf</dt><dd><dd></dl><dl><dt>Ficha4_000001.pdf</dt><dd><dd></dl><dl><dt>Ficha5_000001.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 110),
(186, 42729, 96, 19, 2018, 'Testes CII', '/note/primeiro_ano/segundo_semestre/c2/PedroOliveira_testes-resol.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>testes-resol</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 24),
(187, 45424, 54, NULL, 2016, 'Apontamentos Gerais ICM', '/note/terceiro_ano/primeiro_semestre/icm/Resumo Geral Android.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 3),
(188, 47166, 96, 20, 2018, 'Resoluções material apoio MD', '/note/primeiro_ano/segundo_semestre/md/PedroOliveira_EA.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>EA(livro nos ...</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>EA1</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>EA1(refeito)</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>EA2(Completo)</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>EA2.pdf</dt><dd><dd></dl><dl><dt>EA2ex4.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 45),
(189, 47166, 96, 20, 2018, 'Resoluções fichas MD', '/note/primeiro_ano/segundo_semestre/md/PedroOliveira_Fichas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Ficha1</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>ficha2.pdf</dt><dd><dd></dl><dl><dt>ficha3_000001.pdf</dt><dd><dd></dl><dl><dt>ficha4_000001.pdf</dt><dd><dd></dl><dl><dt>ficha5-cont.pdf</dt><dd><dd></dl><dl><dt>ficha5.pdf</dt><dd><dd></dl><dl><dt>Ficha6.pdf</dt><dd><dd></dl><dl><dt>ficha7(incomp...pdf</dt><dd><dd></dl><dl><dt>Ficha8_000001.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 79),
(190, 47166, 96, 20, 2018, 'Resoluções testes MD', '/note/primeiro_ano/segundo_semestre/md/PedroOliveira_testes.zip', 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>testes</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 33),
(191, 40433, 101, 4, 2017, 'Estudo para o exame', '/note/segundo_ano/primeiro_semestre/rs/RafaelDireito_2017_RSexame.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 6),
(192, 40551, NULL, NULL, NULL, 'Exercícios TPW', '/note/terceiro_ano/segundo_semestre/tpw/Exercicios.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Exercicios</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 14),
(193, 40757, 66, NULL, 2016, 'Resumos 2016/2017', '/note/mestrado/as/as_apontamentos_001.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
(194, 40757, 66, NULL, 2016, 'Resumos por capítulo (zip)', '/note/mestrado/as/JoaoAlegria_ResumosPorCapitulo.zip', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2),
(195, 40846, 54, NULL, NULL, 'Exercícios IA', '/note/terceiro_ano/primeiro_semestre/ia/Inês_Correia_IA_exercícios.pdf', 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 7),
(196, 40846, 54, NULL, NULL, 'Resumos IA', '/note/terceiro_ano/primeiro_semestre/ia/Inês_Correia_IA_resumo.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 9),
(197, 47166, 130, 32, 2019, 'Caderno MD Cap. 6 e 7', '/note/primeiro_ano/segundo_semestre/md/MarianaRosa_Caderno_Capts6e7.pdf', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, '2021-06-16 22:18:59', 20),
(198, 47166, 130, 32, 2019, 'Resumos 1.ª Parte MD', '/note/primeiro_ano/segundo_semestre/md/MarianaRosa_Resumos_1aParte.pdf', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:21:33', 13),
(199, 42532, 49, 8, 2019, 'Práticas BD', '/note/segundo_ano/segundo_semestre/bd/Goncalo_Praticas.zip', NULL, NULL, NULL, NULL, 1, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>P</dt><dd><dd>11 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:27:12', 23),
(200, 42532, 49, 7, 2019, 'Resumos BD', '/note/segundo_ano/segundo_semestre/bd/Goncalo_Resumos.zip', 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>TP</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:28:20', 20),
(201, 41469, 49, 10, 2019, 'Resumos Caps. 3 e 4', '/note/segundo_ano/segundo_semestre/c/Goncalo_TP.zip', 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>TP</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 8),
(202, 41469, 49, 10, 2019, 'Resumos ANTLR4', '/note/segundo_ano/segundo_semestre/c/Goncalo_ANTLR4.zip', 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>ANTLR4 Listeners.pdf</dt><dd><dd></dl><dl><dt>ANTLR4 Visitors.pdf</dt><dd><dd></dl><dl><dt>ANTLR4.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 1),
(203, 41469, 49, 10, 2019, 'Guiões P Resolvidos', '/note/segundo_ano/segundo_semestre/c/Goncalo_GuioesPraticos.zip', NULL, NULL, NULL, NULL, 1, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>P1_20fev2020</dt><dd><dd>1 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>P2_05fev2020</dt><dd><dd>35 pastas</dd><dd>37 ficheiros</dd><dd></dl><dl><dt>P3</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2),
(204, 41469, 49, 10, 2019, 'Resumos Práticos', '/note/segundo_ano/segundo_semestre/c/Goncalo_ResumosPraticos.zip', 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>1_Compiladores.pdf</dt><dd><dd></dl><dl><dt>2_ANTLR4.pdf</dt><dd><dd></dl><dl><dt>3_Análise sem...pdf</dt><dd><dd></dl><dl><dt>5_Análise sem...pdf</dt><dd><dd></dl><dl><dt>6_Geração de ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 17),
(205, 40382, 49, 2, 2019, 'Bibliografia', '/note/segundo_ano/segundo_semestre/cd/Bibliografia.zip', NULL, NULL, 1, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>mvsteen-distr...pdf</dt><dd><dd></dl><dl><dt>ResolucaoPerg...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 39),
(206, 40382, 49, 2, 2019, 'Cheatsheet', '/note/segundo_ano/segundo_semestre/cd/Goncalo_CheatSheet.pdf', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 1),
(207, 40382, 49, 2, 2019, 'Aulas Resolvidas', '/note/segundo_ano/segundo_semestre/cd/Goncalo_Aulas.zip', NULL, NULL, NULL, NULL, 1, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>P1_11Fev2020</dt><dd><dd>138 pastas</dd><dd>140 ficheiros</dd><dd></dl><dl><dt>P2_10Fev2020</dt><dd><dd>125 pastas</dd><dd>128 ficheiros</dd><dd></dl><dl><dt>P3_28Abr2020</dt><dd><dd>103 pastas</dd><dd>104 ficheiros</dd><dd></dl><dl><dt>P4_19Mai2020</dt><dd><dd>183 pastas</dd><dd>183 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 8),
(208, 40382, 49, 2, 2019, 'Projeto1', '/note/segundo_ano/segundo_semestre/cd/Goncalo_Projeto1.zip', NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>message-broke...</dt><dd><dd>260 pastas</dd><dd>268 ficheiros</dd><dd></dl><dl><dt>Projecto 1 - ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 3),
(209, 40382, 49, 2, 2019, 'Projeto2', '/note/segundo_ano/segundo_semestre/cd/Goncalo_Projeto2.zip', NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>distributed-o...</dt><dd><dd>7 pastas</dd><dd>22 ficheiros</dd><dd></dl><dl><dt>Projecto 2 - ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 15),
(210, 40382, 49, 2, 2019, 'Resumos Teóricos', '/note/segundo_ano/segundo_semestre/cd/Goncalo_TP.pdf', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 6),
(211, 41549, 49, 9, 2019, 'Paper \Help, I am stuck...\', '/note/segundo_ano/segundo_semestre/ihc/Goncalo_Francisca_Paper.zip', NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>92972_93102_[...pdf</dt><dd><dd></dl><dl><dt>IHC_Paper.pdf</dt><dd><dd></dl><dl><dt>Paper-selecti...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2),
(212, 41549, 49, 9, 2019, 'Resumos (incompletos)', '/note/segundo_ano/segundo_semestre/ihc/Goncalo_TP.pdf', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 1),
(213, 41549, 49, 9, 2019, 'Perguntitas de preparação exame', '/note/segundo_ano/segundo_semestre/ihc/Perguntitaspreparaçaoexame.zip', NULL, 1, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>(1) User prof...pdf</dt><dd><dd></dl><dl><dt>(2) User ... ...pdf</dt><dd><dd></dl><dl><dt>(3) User mode...pdf</dt><dd><dd></dl><dl><dt>(4) Input & O...pdf</dt><dd><dd></dl><dl><dt>(5) Usability...pdf</dt><dd><dd></dl><dl><dt>exam.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 1),
(214, 40383, 49, 12, 2019, 'Resumos teóricos', '/note/segundo_ano/segundo_semestre/pds/Goncalo_TP.pdf', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 11),
(215, 40383, 49, 12, 2019, 'Projeto final: Padrões Bridge e Flyweight e Refactoring', '/note/segundo_ano/segundo_semestre/pds/Goncalo_Projeto.zip', NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>Entrega</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 74),
(216, 40383, 49, 12, 2019, 'Aulas P Resolvidas', '/note/segundo_ano/segundo_semestre/pds/Goncalo_Aulas.zip', NULL, NULL, NULL, NULL, 1, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>P1_11fev2020</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P2_03mar2020</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P3_10mar2020</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P4_17mar2020</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>P5_24mar2020</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P6_31mar2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P7_14abr2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P8_21abr2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P9_28abr2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P10_05mai2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P11_19mai29020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P12_26mai2020</dt><dd><dd>0 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>P13_02jun2020</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>pds_2020_g205</dt><dd><dd>482 pastas</dd><dd>481 ficheiros</dd><dd></dl><dl><dt>Readme.txt</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 38),
(217, 40383, 49, 12, 2019, 'Exame final', '/note/segundo_ano/segundo_semestre/pds/Goncalo_Exame.zip', NULL, 1, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>92972</dt><dd><dd>0 pastas</dd><dd>16 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 1),
(218, 40383, 49, 12, 2019, 'Bibliografia', '/note/segundo_ano/segundo_semestre/pds/Bibliografia.zip', NULL, NULL, 1, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>applying-uml-...pdf</dt><dd><dd></dl><dl><dt>DesignPatterns.pdf</dt><dd><dd></dl><dl><dt>kupdf.net_use...pdf</dt><dd><dd></dl><dl><dt>software-arch...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 159),
(220, 41549, 49, 9, 2019, 'Projeto final \Show tracker\', 'https://github.com/gmatosferreira/show-tracker-app', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, '2021-10-18 15:00:00', NULL),
(232, 40846, NULL, 30, 2020, 'AI: A Modern Approach', '/note/terceiro_ano/primeiro_semestre/ia/artificial-intelligence-modern-approach.9780131038059.25368.pdf', 0, 0, 1, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 38),
(238, 40846, 49, 30, 2020, 'Resumos', '/note/terceiro_ano/primeiro_semestre/ia/Goncalo_IA_TP.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 3),
(241, 40846, 49, 2, 2020, 'Notas código práticas', '/note/terceiro_ano/primeiro_semestre/ia/Goncalo_Código_Anotado_Práticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>BayesNet.pdf</dt><dd><dd></dl><dl><dt>ConstraintSearch.pdf</dt><dd><dd></dl><dl><dt>SearchTree.pdf</dt><dd><dd></dl><dl><dt>SemanticNetwork.pdf</dt><dd><dd></dl><dl><dt>Strips.pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 4),
(244, 40846, 49, 2, 2020, 'Código práticas', '/note/terceiro_ano/primeiro_semestre/ia/Goncalo_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>guiao-de-prog...</dt><dd><dd>6 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>guiao-rc-gmat...</dt><dd><dd>6 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>guiao-sobre-p...</dt><dd><dd>6 pastas</dd><dd>15 ficheiros</dd><dd></dl><dl><dt>ia-iia-tpi-1-...</dt><dd><dd>4 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>ia-iia-tpi2-g...</dt><dd><dd>1 pastas</dd><dd>10 ficheiros</dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2),
(247, 2450, 49, 34, 2020, 'Resumos', '/note/terceiro_ano/primeiro_semestre/ge/Goncalo_GE_TP.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 2),
(250, 2450, 49, 34, 2020, 'Post-its', '/note/terceiro_ano/primeiro_semestre/ge/Goncalo_Postits.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_Introduçao ...pdf</dt><dd><dd></dl><dl><dt>2_Modelo de n...pdf</dt><dd><dd></dl><dl><dt>3_Modelo de n...pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 11),
(253, 40384, 49, 12, 2020, 'Post-its', '/note/terceiro_ano/primeiro_semestre/ies/Goncalo_Postits.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_IES.pdf</dt><dd><dd></dl><dl><dt>2_Processo so...pdf</dt><dd><dd></dl><dl><dt>3_Desenvolvim...pdf</dt><dd><dd></dl><dl><dt>4_Devops.pdf</dt><dd><dd></dl><dl><dt>5_Padroes arq...pdf</dt><dd><dd></dl><dl><dt>6_Web framewo...pdf</dt><dd><dd></dl><dl><dt>8_Spring fram...pdf</dt><dd><dd></dl><dl><dt>9_Spring boot.pdf</dt><dd><dd></dl><dl><dt>10_Microserviços.pdf</dt><dd><dd></dl><dl><dt>11_Sistemas b...pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 12),
(256, 40384, 49, 12, 2020, 'Aulas práticas', '/note/terceiro_ano/primeiro_semestre/ies/Goncalo_Práticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Lab1_92972.zip</dt><dd><dd></dl><dl><dt>Lab2_92972.zip</dt><dd><dd></dl><dl><dt>Lab3_92972.zip</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 3),
(259, 40384, 49, 12, 2020, 'Resumos', '/note/terceiro_ano/primeiro_semestre/ies/Goncalo_IES_TP.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 5),
(262, 40384, 49, 12, 2020, 'Projeto final \Store Go\', 'https://github.com/gmatosferreira/IES_Project_G31', 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', NULL),
(265, 42573, 49, 3, 2020, 'Resumos', '/note/terceiro_ano/primeiro_semestre/sio/Goncalo_SIO_TP.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 4),
(268, 42573, 49, 3, 2020, 'Tópicos exame', '/note/terceiro_ano/primeiro_semestre/sio/Goncalo_Tópicos_exame.pdf', 0, 1, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 2),
(271, 42573, NULL, 3, 2020, 'Security in Computing', '/note/terceiro_ano/primeiro_semestre/sio/security-in-computing-5-e.pdf', 0, 0, 1, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 18),
(274, 42573, 49, 3, 2020, 'Projeto 1 \Exploração de vulnerabilidades\', '/note/terceiro_ano/primeiro_semestre/sio/Goncalo_[SIO][Projeto 1]_Relatório.pdf', 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', 1),
(277, 42573, 49, 3, 2020, 'Projeto 4 \Forensics\', '/note/terceiro_ano/primeiro_semestre/sio/Goncalo_[SIO][Projeto 4]_Relatório.pdf', 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', 1),
(280, 42573, 49, 3, 2020, 'Projeto 2 \Secure Media Player\', 'https://github.com/gmatosferreira/securemediaplayer', 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', NULL),
(283, 40385, 49, 12, 2020, 'Resumos', '/note/terceiro_ano/primeiro_semestre/cbd/Goncalo_CBD_TP.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 3),
(286, 40385, 49, 12, 2020, 'Post-its', '/note/terceiro_ano/primeiro_semestre/cbd/Goncalo_Postits.zip', 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_Foco nos dados.pdf</dt><dd><dd></dl><dl><dt>2_Modelos de ...pdf</dt><dd><dd></dl><dl><dt>3_Armazenamen...pdf</dt><dd><dd></dl><dl><dt>4_Formatos do...pdf</dt><dd><dd></dl><dl><dt>5 a 8_Tipos b...pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 6),
(289, 40385, 49, 12, 2020, 'Práticas', '/note/terceiro_ano/primeiro_semestre/cbd/Goncalo_Praticas.zip', 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Lab-1_92972.zip</dt><dd><dd></dl><dl><dt>Lab2_92972.zip</dt><dd><dd></dl><dl><dt>92972_Lab3.zip</dt><dd><dd></dl><dl><dt>92972_Lab4.zip</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 4),
(292, 40385, NULL, 12, 2020, 'Designing Data Intensive Applications', '/note/terceiro_ano/primeiro_semestre/cbd/Designing Data Intensive Applications.pdf', 0, 0, 1, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 25),
(298, 42573, 83, 3, 2020, 'Projeto 2 \Secure Media Player\', 'https://github.com/margaridasmartins/digital-rights-management', 0, 0, 0, 0, 0, 1, 0, NULL, '2021-11-15 19:17:30', NULL),
(304, 40436, 104, 28, 2018, 'Práticas POO', 'https://github.com/Rui-FMF/POO', 0, 1, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', NULL),
(307, 40379, 104, 27, 2018, 'Práticas FP', 'https://github.com/Rui-FMF/FP', 0, 0, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', NULL),
(313, 42502, 104, 6, 2018, 'Práticas IAC', 'https://github.com/Rui-FMF/IAC', 0, 0, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', NULL),
(319, 40433, 104, 16, 2019, 'Projeto RS', 'https://github.com/Rui-FMF/RS', 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
(322, 40337, 104, 28, 2019, 'Práticas e projeto MPEI', 'https://github.com/Rui-FMF/MPEI', 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
(325, 40437, 104, 11, 2019, 'Projetos AED', 'https://github.com/Rui-FMF/AED', 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
(328, 40381, 104, 1, 2019, 'Projetos SO', 'https://github.com/Rui-FMF/SO', 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
(331, 40383, 104, 12, 2019, 'Guiões e Exame P, Projeto T', 'https://github.com/Rui-FMF/PDS', 0, 1, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
(334, 40382, 104, 2, 2019, 'Práticas e Projetos CD', 'https://github.com/Rui-FMF/CD', 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
(337, 12832, 104, 40, 2020, 'Projeto 1 TAA', 'https://github.com/Rui-FMF/TAA_1', 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
(340, 41549, 104, 9, 2019, 'Projetos e artigo IHC', 'https://github.com/Rui-FMF/IHC', 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
(343, 45426, 104, 13, 2020, 'Guiões P e Homework TQS', 'https://github.com/Rui-FMF/TQS', 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
(346, 41469, 104, 10, 2019, 'Práticas e projeto C', 'https://github.com/Rui-FMF/C', 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
(349, 40385, 104, 12, 2020, 'Labs CBD', 'https://github.com/Rui-FMF/CBD', 0, 0, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', NULL),
(352, 40846, 104, 2, 2020, 'Guiões, TPI e Projeto de IA', 'https://github.com/Rui-FMF/IA', 0, 1, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
(355, 40384, 104, 12, 2020, 'Labs e projeto de IES', 'https://github.com/Rui-FMF/IES', 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
(358, 42573, 104, 3, 2020, 'Projetos SIO', 'https://github.com/Rui-FMF/SIO', 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
(361, 40551, 104, 25, 2020, 'Projetos TPW', 'https://github.com/Rui-FMF/TPW', 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
(364, 40384, 83, 12, 2020, 'Projeto de IES', 'https://github.com/margaridasmartins/IES_Project', 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', NULL),
(367, 45426, 83, 13, 2020, 'Guiões P e Homework TQS', 'https://github.com/margaridasmartins/TQSLabs', 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', NULL),
(370, 14817, 140, 29, 2020, 'Programas MSF', '/note/primeiro_ano/segundo_semestre/msf/20_21_Artur_Programas.zip', 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', NULL),
(373, 14817, 140, 29, 2020, 'Exercícios resolvidos MSF', '/note/primeiro_ano/segundo_semestre/msf/20_21_Artur_ExsResolvidos.zip', 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', NULL),
(376, 14817, 140, 29, 2020, 'Exercícios MSF', '/note/primeiro_ano/segundo_semestre/msf/20_21_Artur_Exercicios.zip', 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', NULL),
(379, 14817, 140, 29, 2020, 'Guiões práticos MSF', '/note/primeiro_ano/segundo_semestre/msf/20_21_Artur_Ps.zip', 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', NULL),
(382, 14817, 140, 29, 2020, 'Slides teóricos MSF', '/note/primeiro_ano/segundo_semestre/msf/20_21_Artur_TPs.zip', 0, 0, 0, 1, 0, 0, 0, NULL, '2022-01-31 20:37:14', NULL),
(385, 14817, 140, 29, 2020, 'Formulário MSF', '/note/primeiro_ano/segundo_semestre/msf/20_21_Artur_Form.pdf', 1, 0, 0, 0, 0, 0, 0, NULL, '2022-01-31 20:37:14', NULL);



--
-- Data for Name: partner; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.partner (id, header, company, description, content, link, banner_url, banner_image, banner_until) VALUES
(1, '/partner/LavandariaFrame.jpg', 'Lavandaria Portuguesa', 'A Lavandaria Portuguesa encontra-se aliada ao NEI desde março de 2018, ajudando o núcleo na área desportiva com lavagens de equipamentos dos atletas que representam o curso.', NULL, 'https://www.facebook.com/alavandariaportuguesa.pt/', NULL, NULL, NULL),
(2, '/partner/OlisipoFrame.jpg', 'Olisipo', 'Fundada em 1994, a Olisipo é a única empresa portuguesa com mais de 25 anos de experiência dedicada à Gestão de Profissionais na área das Tecnologias de Informação.\n\nSomos gestores de carreira de mais de 500 profissionais de TI e temos Talent Managers capazes de influenciar o sucesso da carreira dos nossos colaboradores e potenciar o crescimento dos nossos clientes.\n\nVem conhecer um Great Place to Work® e uma das 30 melhores empresas para trabalhar em Portugal.', NULL, 'https://bit.ly/3KVT8zs', 'https://bit.ly/3KVT8zs', '/partner/banners/Olisipo.png', '2023-01-31 23:59:59');



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

INSERT INTO nei.rgm (id, category, mandate, file) VALUES
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
-- Data for Name: senior; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.senior (id, year, course, image) VALUES
(1, 2020, 'LEI', '/senior/lei/2020_3.jpg'),
(2, 2020, 'MEI', '/senior/mei/2020.jpg'),
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
(2, 24, NULL, '/senior/mei/2020/24.jpg'),
(2, 146, NULL, '/senior/mei/2020/146.jpg'),
(3, 18, 'Level up', '/senior/lei/2021/18.jpg'),
(3, 37, 'Mal posso esperar para ver o que se segue', '/senior/lei/2021/37.jpg'),
(3, 43, 'Já dizia a minha avó: \O meu neto não bebe álcool\', '/senior/lei/2021/43.jpg'),
(3, 49, NULL, '/senior/lei/2021/49.jpg'),
(3, 53, NULL, '/senior/lei/2021/53.jpg'),
(3, 67, 'Simplesmente viciado em café e futebol', '/senior/lei/2021/67.jpg'),
(3, 83, 'MD é fixe.', '/senior/lei/2021/83.jpg'),
(3, 93, 'Há tempo para tudo na vida académica!', '/senior/lei/2021/93.jpg'),
(3, 106, 'Melhorias = Mito', '/senior/lei/2021/106.jpg'),
(4, 19, '<h1>Fun fact: #EAAA00</h1>', '/senior/mei/2021/19.jpg');


--
-- Data for Name: subject; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.subject (code, name, curricular_year, semester, short, discontinued, optional) VALUES
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
(137, 2021),
(150, 2021),
(126, 2021),
(127, 2021),
(148, 2021),
(132, 2021),
(149, 2021),
(133, 2021),
(147, 2021);


--
-- Data for Name: team_member; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.team_member (id, header, mandate, user_id, role_id) VALUES
(3, '/team/2019/1.jpg', '2019', 65, 1),
(6, '/team/2019/2.jpg', '2019', 111, 4),
(9, '/team/2019/3.jpg', '2019', 56, 17),
(12, '/team/2019/4.jpg', '2019', 47, 18),
(15, '/team/2019/5.jpg', '2019', 118, 18),
(18, '/team/2019/6.jpg', '2019', 84, 7),
(21, '/team/2019/7.jpg', '2019', 102, 7),
(24, '/team/2019/8.jpg', '2019', 75, 7),
(27, '/team/2019/9.jpg', '2019', 53, 15),
(30, '/team/2019/10.jpg', '2019', 122, 15),
(33, '/team/2019/11.jpg', '2019', 22, 15),
(36, '/team/2019/12.jpg', '2019', 86, 3),
(39, '/team/2019/13.jpg', '2019', 30, 2),
(42, '/team/2019/14.jpg', '2019', 83, 5),
(45, '/team/2018/1.jpg', '2018', 65, 1),
(48, '/team/2018/2.jpg', '2018', 111, 4),
(51, '/team/2018/3.jpg', '2018', 102, 17),
(54, '/team/2018/4.jpg', '2018', 119, 17),
(57, '/team/2018/5.jpg', '2018', 24, 18),
(60, '/team/2018/6.jpg', '2018', 19, 18),
(63, '/team/2018/7.jpg', '2018', 60, 7),
(66, '/team/2018/8.jpg', '2018', 75, 7),
(69, '/team/2018/9.jpg', '2018', 121, 15),
(72, '/team/2018/10.jpg', '2018', 101, 15),
(75, '/team/2018/11.jpg', '2018', 100, 15),
(78, '/team/2018/12.jpg', '2018', 86, 3),
(81, '/team/2018/13.jpg', '2018', 51, 2),
(84, '/team/2018/14.jpg', '2018', 84, 5),
(87, '/team/2017/1.jpg', '2017', 54, 1),
(90, '/team/2017/2.jpg', '2017', 51, 4),
(93, '/team/2017/3.jpg', '2017', 31, 17),
(96, '/team/2017/4.jpg', '2017', 30, 17),
(99, '/team/2017/5.jpg', '2017', 35, 18),
(102, '/team/2017/6.jpg', '2017', 90, 18),
(105, '/team/2017/7.jpg', '2017', 45, 7),
(108, '/team/2017/8.jpg', '2017', 95, 7),
(111, '/team/2017/9.jpg', '2017', 19, 15),
(114, '/team/2017/10.jpg', '2017', 86, 15),
(117, '/team/2017/11.jpg', '2017', 11, 15),
(120, '/team/2017/12.jpg', '2017', 91, 3),
(123, '/team/2017/13.jpg', '2017', 110, 2),
(126, '/team/2017/14.jpg', '2017', 65, 5),
(129, '/team/2016/1.jpg', '2016', 105, 1),
(132, '/team/2016/2.jpg', '2016', 66, 4),
(135, '/team/2016/3.jpg', '2016', 31, 16),
(138, '/team/2016/4.jpg', '2016', 51, 16),
(141, '/team/2016/5.jpg', '2016', 62, 11),
(144, '/team/2016/6.jpg', '2016', 98, 11),
(147, '/team/2016/7.jpg', '2016', 2, 8),
(150, '/team/2016/8.jpg', '2016', 45, 8),
(153, '/team/2016/9.jpg', '2016', 54, 15),
(156, '/team/2016/10.jpg', '2016', 97, 15),
(159, '/team/2016/11.jpg', '2016', 26, 15),
(162, '/team/2016/12.jpg', '2016', 20, 3),
(165, '/team/2016/13.jpg', '2016', 110, 2),
(168, '/team/2016/14.jpg', '2016', 28, 5),
(171, '/team/2015/1.jpg', '2015', 110, 1),
(174, '/team/2015/2.jpg', '2015', 109, 4),
(177, '/team/2015/3.jpg', '2015', 46, 10),
(180, '/team/2015/4.jpg', '2015', 17, 10),
(183, '/team/2015/5.jpg', '2015', 88, 11),
(186, '/team/2015/6.jpg', '2015', 50, 11),
(189, '/team/2015/7.jpg', '2015', 78, 7),
(192, '/team/2015/8.jpg', '2015', 112, 7),
(195, '/team/2015/9.jpg', '2015', 66, 14),
(198, '/team/2015/10.jpg', '2015', 2, 14),
(201, '/team/2015/11.jpg', '2015', 54, 14),
(204, '/team/2015/12.jpg', '2015', 3, 3),
(207, '/team/2015/13.jpg', '2015', 58, 2),
(210, '/team/2015/14.jpg', '2015', 23, 5),
(213, '/team/2014/1.jpg', '2014', 92, 1),
(216, '/team/2014/2.jpg', '2014', 113, 4),
(219, '/team/2014/3.jpg', '2014', 110, 10),
(222, '/team/2014/4.jpg', '2014', 105, 10),
(225, '/team/2014/5.jpg', '2014', 82, 11),
(228, '/team/2014/6.jpg', '2014', 46, 11),
(231, '/team/2014/7.jpg', '2014', 52, 7),
(234, '/team/2014/8.jpg', '2014', 42, 7),
(237, '/team/2014/9.jpg', '2014', 107, 14),
(240, '/team/2014/10.jpg', '2014', 109, 14),
(243, '/team/2014/11.jpg', '2014', 10, 14),
(246, '/team/2014/12.jpg', '2014', 72, 3),
(249, '/team/2014/13.jpg', '2014', 108, 2),
(252, '/team/2014/14.jpg', '2014', 66, 5),
(255, '/team/2013/1.jpg', '2013', 92, 1),
(258, '/team/2013/2.jpg', '2013', 68, 4),
(261, '/team/2013/3.jpg', '2013', 39, 9),
(264, '/team/2013/4.jpg', '2013', 52, 9),
(267, '/team/2013/5.jpg', '2013', 41, 13),
(270, '/team/2013/6.jpg', '2013', 25, 8),
(273, '/team/2013/7.jpg', '2013', 113, 14),
(276, '/team/2013/8.jpg', '2013', 29, 3),
(279, '/team/2013/9.jpg', '2013', 58, 2),
(282, '/team/2013/10.jpg', '2013', 72, 5),
(286, '/team/2020/1.jpg', '2020', 102, 1),
(289, '/team/2020/2.jpg', '2020', 83, 4),
(292, '/team/2020/3.jpg', '2020', 94, 16),
(295, '/team/2020/4.jpg', '2020', 89, 18),
(298, '/team/2020/5.jpg', '2020', 40, 18),
(301, '/team/2020/6.jpg', '2020', 84, 6),
(304, '/team/2020/7.jpg', '2020', 59, 6),
(307, '/team/2020/8.jpg', '2020', 131, 12),
(310, '/team/2020/9.jpg', '2020', 55, 12),
(313, '/team/2020/10.jpg', '2020', 96, 15),
(316, '/team/2020/11.jpg', '2020', 103, 15),
(319, '/team/2020/12.jpg', '2020', 135, 3),
(322, '/team/2020/13.jpg', '2020', 86, 2),
(325, '/team/2020/14.jpg', '2020', 130, 5),
(326, '/team/2021/1.jpg', '2021', 83, 1),
(327, '/team/2021/2.jpg', '2021', 139, 4),
(328, '/team/2021/3.jpg', '2021', 49, 16),
(329, '/team/2021/4.jpg', '2021', 125, 18),
(330, '/team/2021/5.jpg', '2021', 143, 18),
(331, '/team/2021/6.jpg', '2021', 124, 18),
(332, '/team/2021/7.jpg', '2021', 141, 6),
(333, '/team/2021/8.jpg', '2021', 128, 6),
(334, '/team/2021/9.jpg', '2021', 136, 12),
(335, '/team/2021/10.jpg', '2021', 142, 15),
(336, '/team/2021/11.jpg', '2021', 40, 15),
(337, '/team/2021/12.jpg', '2021', 135, 2),
(338, '/team/2021/13.jpg', '2021', 144, 3),
(339, '/team/2021/14.jpg', '2021', 140, 5),
(343, '/team/2022/1.jpg', '2022', 139, 1),
(361, '/team/2022/2.jpg', '2022', 140, 4),
(364, '/team/2022/3.jpg', '2022', 150, 6),
(367, '/team/2022/4.jpg', '2022', 138, 11),
(370, '/team/2022/5.jpg', '2022', 153, 15),
(373, '/team/2022/6.jpg', '2022', 154, 3),
(376, '/team/2022/7.jpg', '2022', 135, 2),
(379, '/team/2022/8.jpg', '2022', 155, 5),
(382, '/team/2022/9.jpg', '2022', 133, 12),
(385, '/team/2022/10.jpg', '2022', 132, 15),
(388, '/team/2022/11.jpg', '2022', 156, 11),
(391, '/team/2022/12.jpg', '2022', 74, 16),
(394, '/team/2022/13.jpg', '2022', 157, 12),
(397, '/team/2022/14.jpg', '2022', 128, 6);


--
-- Data for Name: team_role; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei.team_role (id, name, weight) VALUES
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
-- Data for Name: user; Type: TABLE DATA; Schema: nei; Owner: postgres
--

INSERT INTO nei."user" (id, email, name, surname, gender, iupi, nmec, image, curriculum, linkedin, github, updated_at, created_at, scopes, hashed_password) VALUES
(1, 'nei@aauav.pt', 'NEI', 'AAUAv', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY['ADMIN']::nei.scope_enum[], ''),
(2, 'abbm@ua.pt', 'Beatriz', 'Marques', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(3, 'afmoleirinho@ua.pt', 'André', 'Moleirinho', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(4, 'alexandrejflopes@ua.pt', 'Alexandre', 'Lopes', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(5, 'alinayanchuk@ua.pt', 'Alina', 'Yanchuk', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(6, 'anaortega@ua.pt', 'Ana', 'Ortega', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(7, 'anarafaela98@ua.pt', 'Rafaela', 'Vieira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(8, 'andre.alves@ua.pt', 'André', 'Alves', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(9, 'andreribau@ua.pt', 'André', 'Amarante', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(10, 'barbara.jael@ua.pt', 'Bárbara', 'Neto', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(11, 'bernardo.domingues@ua.pt', 'Bernardo', 'Domingues', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(12, 'brunobarbosa@ua.pt', 'Bruno', 'Barbosa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(13, 'brunopinto5151@ua.pt', 'Bruno', 'Pinto', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(14, 'camilauachave@ua.pt', 'Camila', 'Uachave', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(15, 'carina.f.f.neves@ua.pt', 'Carina', 'Neves', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(16, 'carlos.pacheco@ua.pt', 'Carlos', 'Pacheco', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(17, 'carlotamarques@ua.pt', 'Carlota', 'Marques', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(18, 'carolina.araujo00@ua.pt', 'Carolina', 'Araújo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(19, 'carolinaalbuquerque@ua.pt', 'Carolina', 'Albuquerque', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(20, 'castroferreira@ua.pt', 'Andreia', 'Ferreira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(21, 'catarinajvinagre@ua.pt', 'Catarina', 'Vinagre', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(22, 'claudio.costa@ua.pt', 'Cláudio', 'Costa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(23, 'claudioveigas@ua.pt', 'Cláudio', 'Santos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(24, 'cmsoares@ua.pt', 'Carlos', 'Soares', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(25, 'costa.j@ua.pt', 'João', 'Costa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(26, 'cristovaofreitas@ua.pt', 'Cristóvão', 'Freitas', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(27, 'cruzdinis@ua.pt', 'Dinis', 'Cruz', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(28, 'cunha.filipa.ana@ua.pt', 'Mimi', 'Cunha', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(29, 'daniel.v.rodrigues@ua.pt', 'Daniel', 'Rodrigues', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(30, 'dasfernandes@ua.pt', 'David', 'Fernandes', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(31, 'davidcruzferreira@ua.pt', 'David', 'Ferreira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(32, 'davidsantosferreira@ua.pt', 'David', 'Ferreira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(33, 'dimitrisilva@ua.pt', 'Dimitri', 'Silva', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(34, 'diogo.andrade@ua.pt', 'Diogo', 'Andrade', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(35, 'diogo.reis@ua.pt', 'Diogo', 'Reis', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(36, 'diogo04@ua.pt', 'Diogo', 'Silva', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(37, 'diogobento@ua.pt', 'Diogo', 'Bento', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(38, 'diogorafael@ua.pt', 'Diogo', 'Ramos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(39, 'dpaiva@ua.pt', 'Diogo', 'Paiva', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(40, 'duarte.ntm@ua.pt', 'Duarte', 'Mortágua', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(41, 'e.martins@ua.pt', 'Eduardo', 'Martins', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(42, 'ealaranjo@ua.pt', 'Emanuel', 'Laranjo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(43, 'eduardosantoshf@ua.pt', 'Eduardo', 'Santos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(44, 'fabio.almeida@ua.pt', 'Fábio', 'Almeida', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(45, 'fabiodaniel@ua.pt', 'Fábio', 'Barros', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(46, 'filipemcastro@ua.pt', 'Filipe', 'Castro', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(47, 'flaviafigueiredo@ua.pt', 'Flávia', 'Figueiredo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(48, 'franciscosilveira@ua.pt', 'Francisco', 'Silveira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(49, 'gmatos.ferreira@ua.pt', 'Gonçalo', 'Matos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(50, 'gpmoura@ua.pt', 'Guilherme', 'Moura', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(51, 'hrcpintor@ua.pt', 'Hugo', 'Pintor', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(52, 'hugo.andre@ua.pt', 'Hugo', 'Correia', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(53, 'hugofpaiva@ua.pt', 'Hugo', 'Almeida', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(54, 'ines.gomes.correia@ua.pt', 'Inês', 'Correia', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(55, 'isadora.fl@ua.pt', 'Isadora', 'Loredo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(56, 'j.vasconcelos99@ua.pt', 'João', 'Vasconcelos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(57, 'jarturcosta@ua.pt', 'João', 'Costa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(58, 'joana.coelho@ua.pt', 'Joana', 'Coelho', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(59, 'joao.laranjo@ua.pt', 'João', 'Laranjo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(60, 'joaoantonioribeiro@ua.pt', 'João', 'Ribeiro', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(61, 'joaogferreira@ua.pt', 'João', 'Ferreira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(62, 'joaolimas@ua.pt', 'João', 'Limas', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(63, 'joaomadias@ua.pt', 'João', 'Dias', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(64, 'joaopaul@ua.pt', 'João', 'Paúl', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(65, 'joaosilva9@ua.pt', 'João Abílio', 'Rodrigues', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(66, 'joaotalegria@ua.pt', 'João', 'Alegria', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(67, 'joaots@ua.pt', 'João', 'Soares', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(68, 'jorge.fernandes@ua.pt', 'Jorge', 'Fernandes', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(69, 'josefrias99@ua.pt', 'José', 'Frias', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(70, 'joseppmoreira@ua.pt', 'José', 'Moreira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(71, 'josepribeiro@ua.pt', 'José', 'Ribeiro', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(72, 'josimarcassandra@ua.pt', 'Josimar', 'Cassandra', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(73, 'jrsrm@ua.pt', 'João', 'Magalhães', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(74, 'leandrosilva12@ua.pt', 'Leandro', 'Silva', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(75, 'lmcosta98@ua.pt', 'Luís Miguel', 'Costa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(76, 'luiscdf@ua.pt', 'Luís', 'Fonseca', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(77, 'luisfgbs@ua.pt', 'Luís', 'Silva', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(78, 'luisfsantos@ua.pt', 'Luis', 'Santos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(79, 'luisoliveira98@ua.pt', 'Luís', 'Oliveira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(80, 'marco.miranda@ua.pt', 'Marco', 'Miranda', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(81, 'marcoandreventura@ua.pt', 'Marco', 'Ventura', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(82, 'marcossilva@ua.pt', 'Marcos', 'Silva', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(83, 'margarida.martins@ua.pt', 'Margarida', 'Martins', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(84, 'martasferreira@ua.pt', 'Marta', 'Ferreira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(85, 'maxlainesmoreira@ua.pt', 'Maxlaine', 'Moreira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(86, 'mfs98@ua.pt', 'Mariana', 'Sequeira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(87, 'miguel.mota@ua.pt', 'Miguel', 'Mota', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(88, 'miguelaantunes@ua.pt', 'Miguel', 'Antunes', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(89, 'moraisandre@ua.pt', 'André', 'Morais', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(90, 'p.seixas96@ua.pt', 'Paulo', 'Seixas', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(91, 'patrocinioandreia@ua.pt', 'Andreia', 'Patrocínio', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(92, 'paulopintor@ua.pt', 'Paulo', 'Pintor', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(93, 'pedro.bas@ua.pt', 'Pedro', 'Bastos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(94, 'pedro.joseferreira@ua.pt', 'Pedro', 'Ferreira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(95, 'pedroguilhermematos@ua.pt', 'Pedro', 'Matos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(96, 'pedrooliveira99@ua.pt', 'Pedro', 'Oliveira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(97, 'pereira.jorge@ua.pt', 'Jorge', 'Pereira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(98, 'pgr96@ua.pt', 'João', 'Rodrigues', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(99, 'pmn@ua.pt', 'Pedro', 'Neves', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(100, 'ptpires@ua.pt', 'Pedro', 'Pires', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(101, 'rafael.neves.direito@ua.pt', 'Rafael', 'Direito', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(102, 'rafaelgteixeira@ua.pt', 'Rafael', 'Teixeira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(103, 'rafaeljsimoes@ua.pt', 'Rafael', 'Simões', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(104, 'rfmf@ua.pt', 'Rui', 'Fernandes', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(105, 'ribeirojoao@ua.pt', 'João', 'Peixe Ribeiro', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(106, 'ricardo.cruz29@ua.pt', 'Ricardo', 'Cruz', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(107, 'ricardo.mendes@ua.pt', 'Ricardo', 'Mendes', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(108, 'ritajesus@ua.pt', 'Rita', 'Jesus', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(109, 'ritareisportas@ua.pt', 'Rita', 'Portas', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(110, 'rjmartins@ua.pt', 'Rafael', 'Martins', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(111, 'ruicoelho@ua.pt', 'Rui', 'Coelho', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(112, 'ruimazevedo@ua.pt', 'Rui', 'Azevedo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(113, 's.joana@ua.pt', 'Joana', 'Silva', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(114, 'sandraandrade@ua.pt', 'Sandra', 'Andrade', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(115, 'sergiomartins8@ua.pt', 'Sérgio', 'Martins', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(116, 'sfurao@ua.pt', 'Sara', 'Furão', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(117, 'simaoarrais@ua.pt', 'Simão', 'Arrais', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(118, 'sofiamoniz@ua.pt', 'Sofia', 'Moniz', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(119, 't.cardoso@ua.pt', 'Tiago', 'Cardoso', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(120, 'tiagocmendes@ua.pt', 'Tiago', 'Mendes', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(121, 'tomasbatista99@ua.pt', 'Tomás', 'Batista', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(122, 'tomascosta@ua.pt', 'Tomás', 'Costa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(123, 'artur.romao@ua.pt', 'Artur', 'Romão', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(124, 'cffonseca@ua.pt', 'Camila', 'Fonseca', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(125, 'ddias@ua.pt', 'Daniela', 'Dias', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(126, 'diana.siso@ua.pt', 'Diana', 'Siso', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(127, 'diogo.mo.monteiro@ua.pt', 'Diogo', 'Monteiro', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(128, 'fabio.m@ua.pt', 'Fábio', 'Martins', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(129, 'joaoreis16@ua.pt', 'João', 'Reis', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(130, 'marianarosa@ua.pt', 'Mariana', 'Sousa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(131, 'martafradique@ua.pt', 'Marta', 'Fradique', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(132, 'miguel.r.ferreira@ua.pt', 'Miguel', 'Ferreira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(133, 'paulogspereira@ua.pt', 'Paulo', 'Pereira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(134, 'sobral@ua.pt', 'Pedro', 'Sobral', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(135, 'renatoaldias12@ua.pt', 'Renato', 'Dias', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(136, 'vfrd00@ua.pt', 'Vitor', 'Dias', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(137, 'afonso.campos@ua.pt', 'Afonso', 'Campos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(138, 'yanismarinafaquir@ua.pt', 'Yanis', 'Faquir', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(139, 'palexandre09@ua.pt', 'Pedro', 'Figueiredo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(140, '_140_', 'Artur', 'Correia', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(141, '_141_', 'André', 'Benquerença', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(142, 'dl.carvalho@ua.pt', 'Daniel', 'Carvalho', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(143, '_143_', 'Rafael', 'Gonçalves', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(144, '_144_', 'Inês', 'Ferreira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(145, '_145_', 'Rodrigo', 'Oliveira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(146, '_146_', 'Miguel', 'Fonseca', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(147, '_147_', 'Catarina', 'Costa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(148, '_148_', 'Leonardo', 'Almeida', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(149, '_149_', 'Lucius', 'Filho', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(150, '_150_', 'Daniel', 'Ferreira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(151, '_151_', 'Filipe', 'Silva', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(152, '_152_', 'Alexandre', 'Santos', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(153, 'vmabarros@ua.pt', 'Vicente', 'Barros', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(154, 'tiagocgomes@ua.pt', 'Tiago', 'Gomes', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(155, 'maria.abrunhosa@ua.pt', 'Rafaela', 'Abrunhosa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(156, 'matilde.teixeira@ua.pt', 'Matilde', 'Teixeira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(157, 'hf.correia@ua.pt', 'Hugo', 'Correia', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], ''),
(158, '_158_', 'Mariana', 'Rosa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY[]::nei.scope_enum[], '');


--
-- Data for Name: user_academic_details; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.user_academic_details (id, user_id, course_id, curricular_year, created_at) FROM stdin;
\.


--
-- Data for Name: user_academic_details__subjects; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.user_academic_details__subjects (user_academic_details_id, subject) FROM stdin;
\.


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

SELECT pg_catalog.setval('nei.user_id_seq', 1, false);


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