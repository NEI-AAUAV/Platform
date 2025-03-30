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
-- Name: rally_tascas; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA rally_tascas;


ALTER SCHEMA rally_tascas OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: checkpoint; Type: TABLE; Schema: rally_tascas; Owner: postgres
--

CREATE TABLE rally_tascas.checkpoint (
    id integer NOT NULL,
    name character varying,
    shot_name character varying,
    description character varying
);


ALTER TABLE rally_tascas.checkpoint OWNER TO postgres;

--
-- Name: checkpoint_id_seq; Type: SEQUENCE; Schema: rally_tascas; Owner: postgres
--

CREATE SEQUENCE rally_tascas.checkpoint_id_seq
    AS integer
    START WITH 9
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rally_tascas.checkpoint_id_seq OWNER TO postgres;

--
-- Name: checkpoint_id_seq; Type: SEQUENCE OWNED BY; Schema: rally_tascas; Owner: postgres
--

ALTER SEQUENCE rally_tascas.checkpoint_id_seq OWNED BY rally_tascas.checkpoint.id;


--
-- Name: team; Type: TABLE; Schema: rally_tascas; Owner: postgres
--

CREATE TABLE rally_tascas.team (
    id integer NOT NULL,
    name character varying,
    times timestamp without time zone[],
    score_per_checkpoint integer[],
    total integer,
    classification integer
);


ALTER TABLE rally_tascas.team OWNER TO postgres;

--
-- Name: team_id_seq; Type: SEQUENCE; Schema: rally_tascas; Owner: postgres
--

CREATE SEQUENCE rally_tascas.team_id_seq
    AS integer
    START WITH 17
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rally_tascas.team_id_seq OWNER TO postgres;

--
-- Name: team_id_seq; Type: SEQUENCE OWNED BY; Schema: rally_tascas; Owner: postgres
--

ALTER SEQUENCE rally_tascas.team_id_seq OWNED BY rally_tascas.team.id;


--
-- Name: user; Type: TABLE; Schema: rally_tascas; Owner: postgres
--

CREATE TABLE rally_tascas."user" (
    id integer NOT NULL,
    username character varying,
    name character varying,
    team_id integer,
    staff_checkpoint_id integer,
    is_admin boolean,
    disabled boolean,
    hashed_password character varying
);


ALTER TABLE rally_tascas."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: rally_tascas; Owner: postgres
--

CREATE SEQUENCE rally_tascas.user_id_seq
    AS integer
    START WITH 103
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rally_tascas.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: rally_tascas; Owner: postgres
--

ALTER SEQUENCE rally_tascas.user_id_seq OWNED BY rally_tascas."user".id;


--
-- Name: checkpoint id; Type: DEFAULT; Schema: rally_tascas; Owner: postgres
--

ALTER TABLE ONLY rally_tascas.checkpoint ALTER COLUMN id SET DEFAULT nextval('rally_tascas.checkpoint_id_seq'::regclass);


--
-- Name: team id; Type: DEFAULT; Schema: rally_tascas; Owner: postgres
--

ALTER TABLE ONLY rally_tascas.team ALTER COLUMN id SET DEFAULT nextval('rally_tascas.team_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: rally_tascas; Owner: postgres
--

ALTER TABLE ONLY rally_tascas."user" ALTER COLUMN id SET DEFAULT nextval('rally_tascas.user_id_seq'::regclass);



--
-- Data for Name: checkpoint; Type: TABLE DATA; Schema: rally_tascas; Owner: postgres
--

INSERT INTO rally_tascas.checkpoint (id, name, shot_name, description) VALUES
(1, 'Tribunal', 'Mugshot', 'Dirige-te para a AFUAv'),
(2, 'Receção', 'Algemas', 'Dirige-te para o Dep. Materiais'),
(3, 'Cela', 'Até andas de lado', 'Dirige-te para o túnel entre o DETI e o DEP'),
(4, 'Pátio', 'Palmada', 'Dirige-te para a Fotossíntese'),
(5, 'Cantina', 'Hot Wheels', 'Dirige-te para o Dep. Matemática'),
(6, 'WC', 'Sabonetes', 'Dirige-te para o Restaurante Universitário (Grelhados)'),
(7, 'Ginásio', 'MotoMoto', 'Dirige-te para o Pavilhão Arístides'),
(8, 'Enfermaria', 'SpEIderSémen', 'Dirige-te para a entrada da ponte do Crasto');


--
-- Data for Name: team; Type: TABLE DATA; Schema: rally_tascas; Owner: postgres
--

INSERT INTO rally_tascas.team (id, name, score_per_checkpoint, times, total, classification) VALUES
(1, 'Lambada de mão aberta', array[]::integer[], array[]::timestamp without time zone[], 0, -1),
(2, 'Seca Extrema', array[]::integer[], array[]::timestamp without time zone[], 0, -1),
(3, 'Uisqe konhaque tudo', array[]::integer[], array[]::timestamp without time zone[], 0, -1),
(4, 'Não tavas capaz não vinhas', array[]::integer[], array[]::timestamp without time zone[], 0, -1),
(5, 'equipa xl', array[]::integer[], array[]::timestamp without time zone[], 0, -1),
(6, 'Tasca do Pai Jorge', array[]::integer[], array[]::timestamp without time zone[], 0, -1),
(7, 'Pink stars', array[]::integer[], array[]::timestamp without time zone[], 0, -1),
(8, 'Mmmm tenso', array[]::integer[], array[]::timestamp without time zone[], 0, -1),
(9, 'Diga diga', array[]::integer[], array[]::timestamp without time zone[], 0, -1),
(10, 'Psicoalcolémicos', array[]::integer[], array[]::timestamp without time zone[], 0, -1),
(11, 'eu não bebo', array[]::integer[], array[]::timestamp without time zone[], 0, -1),
(12, 'T-Bag Drinkers',  array[]::integer[], array[]::timestamp without time zone[], 0, -1);


--
-- Data for Name: user; Type: TABLE DATA; Schema: rally_tascas; Owner: postgres
--

INSERT INTO rally_tascas."user" (id, name, username, team_id, staff_checkpoint_id, is_admin, disabled, hashed_password) VALUES
(1, 'admin', 'admin', NULL, NULL, true, false, '$2b$12$vdzU3SF8bPmtolmZphAor.UV.oA1vyHo2pMeV7R4sIWmIPF1fX7bu'),
(2, 'staff1', 'staff1', NULL, 1, false, false, '$2b$12$KGzsZzbL9iAp01J3AerfAuvsYyRcNZbDEV6ZacUaen.oY59yrVj8a'),
(3, 'staff2', 'staff2', NULL, 2, false, false, '$2b$12$D1NQnbeeGzasJSPD6WfVwevqDP3LMnevDf1QfCUuIJf1K7nhsnb5W'),
(4, 'staff3', 'staff3', NULL, 3, false, false, '$2b$12$j/fQ50TG42QgCMM7rUVp3eL0fSIKxaYfkj061Du2S3pHBV3U1X.eC'),
(5, 'staff4', 'staff4', NULL, 4, false, false, '$2b$12$phHNBOAGfZgkDI6vlBqDkOUz8hc1Q67ttWLYNMUbL/UQUniZu1866'),
(6, 'staff5', 'staff5', NULL, 5, false, false, '$2b$12$bjjUq9Zb7vEQK0GSXWQp.O/C/La4HieDM.DCfyYUc4aBJceozCe1S'),
(7, 'staff6', 'staff6', NULL, 6, false, false, '$2b$12$eusj0RE/GXnV4D9OId4.4eJczdkKDKS8JaWENGa7pX3sfTHJO5iOK'),
(8, 'staff7', 'staff7', NULL, 7, false, false, '$2b$12$lPDUvi5nieWbwWEgKQu5cOssTkAMcgBvFK9Q9A11.Bx.7U/PmD1ra'),
(9, 'staff8', 'staff8', NULL, 8, false, false, '$2b$12$DSvL77x63dhk9WCa7UtOk.4sdwvVEpTZGcGFrKi2sqrxFCrzuZSWq'),
-- Lambada de mão aberta
(10, 'Duarte Cruz', 'duarteccruz@ua.pt', 1, NULL, false, false, '$2b$12$2g6PxoUVlnJ.KBmeFUH9F.eyWhq5QI7NRfIQ8EgCFJJqzxaCFKpV2'),
(11, 'Gonçalo Ferreira', 'goncalomf@ua.pt', 1, NULL, false, false, '$2b$12$2g6PxoUVlnJ.KBmeFUH9F.eyWhq5QI7NRfIQ8EgCFJJqzxaCFKpV2'),
(12, 'Diogo Almeida', 'almeidadiogo03@ua.pt', 1, NULL, false, false, '$2b$12$2g6PxoUVlnJ.KBmeFUH9F.eyWhq5QI7NRfIQ8EgCFJJqzxaCFKpV2'),
(13, 'Guilherme Duarte', 'duarte.g@ua.pt', 1, NULL, false, false, '$2b$12$2g6PxoUVlnJ.KBmeFUH9F.eyWhq5QI7NRfIQ8EgCFJJqzxaCFKpV2'),
(14, 'Tomás Matos', 'tomas.matos@ua.pt', 1, NULL, false, false, '$2b$12$2g6PxoUVlnJ.KBmeFUH9F.eyWhq5QI7NRfIQ8EgCFJJqzxaCFKpV2'),
(15, 'Rodrigo Graça', 'rodrigomgraca@ua.pt', 1, NULL, false, false, '$2b$12$2g6PxoUVlnJ.KBmeFUH9F.eyWhq5QI7NRfIQ8EgCFJJqzxaCFKpV2'),
-- Seca Extrema
(16, 'Simão', 'simaocordeirosantos@ua.pt', 2, NULL, false, false, '$2b$12$McP9I3pPmDS7h0hloI9do.FemAr7wCd5kLl4d1k0QdKI2LKnc9wpK'),
(17, 'Raquel', 'raq.milh@ua.pt', 2, NULL, false, false, '$2b$12$McP9I3pPmDS7h0hloI9do.FemAr7wCd5kLl4d1k0QdKI2LKnc9wpK'),
(18, 'Rodrigo Martins', 'rodrigomartins@ua.pt', 2, NULL, false, false, '$2b$12$McP9I3pPmDS7h0hloI9do.FemAr7wCd5kLl4d1k0QdKI2LKnc9wpK'),
(19, 'Lúcia', 'luciamsousa00@ua.pt', 2, NULL, false, false, '$2b$12$McP9I3pPmDS7h0hloI9do.FemAr7wCd5kLl4d1k0QdKI2LKnc9wpK'),
(20, 'Alexandre', 'alexandretomas@ua.pt', 2, NULL, false, false, '$2b$12$McP9I3pPmDS7h0hloI9do.FemAr7wCd5kLl4d1k0QdKI2LKnc9wpK'),
(21, 'João Gameiro', 'joao.gameiro@ua.pt', 2, NULL, false, false, '$2b$12$McP9I3pPmDS7h0hloI9do.FemAr7wCd5kLl4d1k0QdKI2LKnc9wpK'),
-- Uisqe konhaque tudo
(22, 'Martim Santos', 'santos.martim@ua.pt', 3, NULL, false, false, '$2b$12$GELTrMRS8h73siBTD8/iMeCpZR1fIjvarYik3/0leUu8m1uuOU8Ge'),
(23, 'Maria Linhares', 'marialinhares@ua.pt', 3, NULL, false, false, '$2b$12$GELTrMRS8h73siBTD8/iMeCpZR1fIjvarYik3/0leUu8m1uuOU8Ge'),
(24, 'Rui Machado', 'rmachado@ua.pt', 3, NULL, false, false, '$2b$12$GELTrMRS8h73siBTD8/iMeCpZR1fIjvarYik3/0leUu8m1uuOU8Ge'),
(25, 'Zakhar Kruptsala', 'zakhar.kruptsala@ua.pt', 3, NULL, false, false, '$2b$12$GELTrMRS8h73siBTD8/iMeCpZR1fIjvarYik3/0leUu8m1uuOU8Ge'),
(26, 'Gabriel Martins Silva', 'gabrielmsilva4@ua.pt', 3, NULL, false, false, '$2b$12$GELTrMRS8h73siBTD8/iMeCpZR1fIjvarYik3/0leUu8m1uuOU8Ge'),
(27, 'Guilherme Rosa', 'guilherme.rosa60@ua.pt', 3, NULL, false, false, '$2b$12$GELTrMRS8h73siBTD8/iMeCpZR1fIjvarYik3/0leUu8m1uuOU8Ge'),
-- Não tavas capaz não vinhas
(28, 'Bernardo Figueiredo', 'bernardo.figueiredo@ua.pt', 4, NULL, false, false, '$2b$12$lZdxOoAbdAQylgQ2DdWIDeXrZC/KI/BTotC.awaYDlFJ8D7cORb.O'),
(29, 'João Viallelle', 'jonyoviolado@ua.pt', 4, NULL, false, false, '$2b$12$lZdxOoAbdAQylgQ2DdWIDeXrZC/KI/BTotC.awaYDlFJ8D7cORb.O'),
(30, 'Joaquim Rosa', 'joaquimvr15@ua.pt', 4, NULL, false, false, '$2b$12$lZdxOoAbdAQylgQ2DdWIDeXrZC/KI/BTotC.awaYDlFJ8D7cORb.O'),
(31, 'José Gameiro', 'jose.mcgameiro@ua.pt', 4, NULL, false, false, '$2b$12$lZdxOoAbdAQylgQ2DdWIDeXrZC/KI/BTotC.awaYDlFJ8D7cORb.O'),
(32, 'Alexandre Cotorobai', 'alexandrecotorobai@ua.pt', 4, NULL, false, false, '$2b$12$lZdxOoAbdAQylgQ2DdWIDeXrZC/KI/BTotC.awaYDlFJ8D7cORb.O'),
(33, 'Rodrigo Azevedo', 'rodrigo.azevedo@ua.pt', 4, NULL, false, false, '$2b$12$lZdxOoAbdAQylgQ2DdWIDeXrZC/KI/BTotC.awaYDlFJ8D7cORb.O'),
-- equipa xl
(34, 'Mariana Oliveira', 'marianacso@ua.pt', 5, NULL, false, false, '$2b$12$bvNYJnq53EMu9v5vZmqIjOon4aZ/VBfULstz30u0kXHo9CiDcZvBm'),
(35, 'Sumeja Ferreira', 'sumejaferreira@ua.pt', 5, NULL, false, false, '$2b$12$bvNYJnq53EMu9v5vZmqIjOon4aZ/VBfULstz30u0kXHo9CiDcZvBm'),
(36, 'Beatriz Saraiva', 'beatriz.s@ua.pt', 5, NULL, false, false, '$2b$12$bvNYJnq53EMu9v5vZmqIjOon4aZ/VBfULstz30u0kXHo9CiDcZvBm'),
(37, 'Augusto Camacho', 'augustocamacho@ua.pt', 5, NULL, false, false, '$2b$12$bvNYJnq53EMu9v5vZmqIjOon4aZ/VBfULstz30u0kXHo9CiDcZvBm'),
(38, 'Maria Lucas', 'marialucas@ua.pt', 5, NULL, false, false, '$2b$12$bvNYJnq53EMu9v5vZmqIjOon4aZ/VBfULstz30u0kXHo9CiDcZvBm'),
(39, 'João Gonçalo', 'joao.goncalo.santos@ua.pt', 5, NULL, false, false, '$2b$12$bvNYJnq53EMu9v5vZmqIjOon4aZ/VBfULstz30u0kXHo9CiDcZvBm'),
-- Tasca do Pai Jorge
(40, 'Margarida Martins', 'margarida.martins@ua.pt', 6, NULL, false, false, '$2b$12$pOAgHhV.JtdCL8AkGS47KOEl8ONMje7jLmrEJNGYpAJdg46CQyuWS'),
(41, 'Leandro Silva', 'leandrosilva12@ua.pt', 6, NULL, false, false, '$2b$12$pOAgHhV.JtdCL8AkGS47KOEl8ONMje7jLmrEJNGYpAJdg46CQyuWS'),
(42, 'Pedro Marques', 'pedroagoncalvesmarques@ua.pt', 6, NULL, false, false, '$2b$12$pOAgHhV.JtdCL8AkGS47KOEl8ONMje7jLmrEJNGYpAJdg46CQyuWS'),
(43, 'Pedro Tavares', 'pedrod33@ua.pt', 6, NULL, false, false, '$2b$12$pOAgHhV.JtdCL8AkGS47KOEl8ONMje7jLmrEJNGYpAJdg46CQyuWS'),
(44, 'Chico Silva', 'mariosilva@ua.pt', 6, NULL, false, false, '$2b$12$pOAgHhV.JtdCL8AkGS47KOEl8ONMje7jLmrEJNGYpAJdg46CQyuWS'),
-- Pink stars
(45, 'Cíntia Magalhães', 'magalhaescintia9@ua.pt', 7, NULL, false, false, '$2b$12$F/pyG6PBEVapk8amrUrIFuV.yJ3X5lmw.VlUfsYJmlnF90YtxTCte'),
(46, 'Maria Silva', 'geral.mariasilva36@gmail.com', 7, NULL, false, false, '$2b$12$F/pyG6PBEVapk8amrUrIFuV.yJ3X5lmw.VlUfsYJmlnF90YtxTCte'),
(47, 'Beatriz Glória', 'beatriz.pg@ua.pt', 7, NULL, false, false, '$2b$12$F/pyG6PBEVapk8amrUrIFuV.yJ3X5lmw.VlUfsYJmlnF90YtxTCte'),
(48, 'Catarina Castro', 'catarinalemoscastro@gmail.com', 7, NULL, false, false, '$2b$12$F/pyG6PBEVapk8amrUrIFuV.yJ3X5lmw.VlUfsYJmlnF90YtxTCte'),
(49, 'Leonor Vicente', 'leonorvicente288@gmail.com', 7, NULL, false, false, '$2b$12$F/pyG6PBEVapk8amrUrIFuV.yJ3X5lmw.VlUfsYJmlnF90YtxTCte'),
(50, 'Letícia Lima', 'leticiasantanadelima@gmail.com', 7, NULL, false, false, '$2b$12$F/pyG6PBEVapk8amrUrIFuV.yJ3X5lmw.VlUfsYJmlnF90YtxTCte'),
-- Mmmm tenso
(51, 'José Almeida', 'jpaa1814@gmail.com', 8, NULL, false, false, '$2b$12$kF.5pvYfXfLAtwQe1Cmjr..eIpUCPQ6G2uSJC7QmPkDY6uaHONJ3G'),
(52, 'João Gomes', 'joaopedrog@ua.pt', 8, NULL, false, false, '$2b$12$kF.5pvYfXfLAtwQe1Cmjr..eIpUCPQ6G2uSJC7QmPkDY6uaHONJ3G'),
(53, 'Diogo Campinho', 'diogocampinho@ua.pt', 8, NULL, false, false, '$2b$12$kF.5pvYfXfLAtwQe1Cmjr..eIpUCPQ6G2uSJC7QmPkDY6uaHONJ3G'),
(54, 'Helena Costa', 'fontoura@ua.pt', 8, NULL, false, false, '$2b$12$kF.5pvYfXfLAtwQe1Cmjr..eIpUCPQ6G2uSJC7QmPkDY6uaHONJ3G'),
(55, 'Matilde Gonçalves', 'matildegonçalves@ua.pt', 8, NULL, false, false, '$2b$12$kF.5pvYfXfLAtwQe1Cmjr..eIpUCPQ6G2uSJC7QmPkDY6uaHONJ3G'),
(56, 'Inês Ramalho', 'inesramalhos.12@gmail.com', 8, NULL, false, false, '$2b$12$kF.5pvYfXfLAtwQe1Cmjr..eIpUCPQ6G2uSJC7QmPkDY6uaHONJ3G'),
-- Diga diga
(57, 'João Carvalho', 'joao.carvalho19@ua.pt', 9, NULL, false, false, '$2b$12$UBwboAvKLYhceuCvl4IB.ODaAa9YhvQS4NxRN7hoVfI/GieNr/FuW'),
(58, 'André Alves', 'andre.alves@ua.pt', 9, NULL, false, false, '$2b$12$UBwboAvKLYhceuCvl4IB.ODaAa9YhvQS4NxRN7hoVfI/GieNr/FuW'),
(59, 'Pedro Oliveira', 'pedrooliveira99@ua.pt', 9, NULL, false, false, '$2b$12$UBwboAvKLYhceuCvl4IB.ODaAa9YhvQS4NxRN7hoVfI/GieNr/FuW'),
(60, 'Pedro Marques', 'pedromm@ua.pt', 9, NULL, false, false, '$2b$12$UBwboAvKLYhceuCvl4IB.ODaAa9YhvQS4NxRN7hoVfI/GieNr/FuW'),
(61, 'Henrique Lourenço', 'henriquelourenco02@gmail.com', 9, NULL, false, false, '$2b$12$UBwboAvKLYhceuCvl4IB.ODaAa9YhvQS4NxRN7hoVfI/GieNr/FuW'),
(62, 'Diogo Silva', NULL, 9, NULL, false, false, '$2b$12$UBwboAvKLYhceuCvl4IB.ODaAa9YhvQS4NxRN7hoVfI/GieNr/FuW'),
-- Psicoalcolémicos
(63, 'Daniela Fidalgo', 'danielasf@ua.pt', 10, NULL, false, false, '$2b$12$VrFJ7HDsQum2wVvGf2ZoXuQCOJ5lp8KSmVQJHPSMNO4pgyDzeWwD2'),
(64, 'Henrique Oliveira', 'valent.oliv@ua.pt', 10, NULL, false, false, '$2b$12$VrFJ7HDsQum2wVvGf2ZoXuQCOJ5lp8KSmVQJHPSMNO4pgyDzeWwD2'),
(65, 'Daniela Carquejo', 'danielacarquejo@ua.pt', 10, NULL, false, false, '$2b$12$VrFJ7HDsQum2wVvGf2ZoXuQCOJ5lp8KSmVQJHPSMNO4pgyDzeWwD2'),
(66, 'Helena Bernardo', 'helenabernardo19@ua.pt', 10, NULL, false, false, '$2b$12$VrFJ7HDsQum2wVvGf2ZoXuQCOJ5lp8KSmVQJHPSMNO4pgyDzeWwD2'),
(67, 'Fábio Morais', 'fabio.sobral@ua.pt', 10, NULL, false, false, '$2b$12$VrFJ7HDsQum2wVvGf2ZoXuQCOJ5lp8KSmVQJHPSMNO4pgyDzeWwD2'),
(68, 'Joana Domingues', 'joanaffdomingues@ua.pt', 10, NULL, false, false, '$2b$12$VrFJ7HDsQum2wVvGf2ZoXuQCOJ5lp8KSmVQJHPSMNO4pgyDzeWwD2'),
-- eu não bebo
(69, 'Francisca Alves', 'francisca.alves@ua.pt', 11, NULL, false, false, '$2b$12$xrVYzZ4B5sKsYjKGs1vxtOMo1HOzwgXktL38X1ha4RJnjfsq.HDGy'),
(70, 'Andreia Santos', 'amrsantos@ua.pt', 11, NULL, false, false, '$2b$12$xrVYzZ4B5sKsYjKGs1vxtOMo1HOzwgXktL38X1ha4RJnjfsq.HDGy'),
(71, 'Francisco Queirós', 'f.queiros@ua.pt', 11, NULL, false, false, '$2b$12$xrVYzZ4B5sKsYjKGs1vxtOMo1HOzwgXktL38X1ha4RJnjfsq.HDGy'),
(72, 'Matilde Simões', 'matildesimoes02@ua.pt', 11, NULL, false, false, '$2b$12$xrVYzZ4B5sKsYjKGs1vxtOMo1HOzwgXktL38X1ha4RJnjfsq.HDGy'),
(73, 'Rodrigo Monteiro', 'rodrigomonteiro@ua.pt', 11, NULL, false, false, '$2b$12$xrVYzZ4B5sKsYjKGs1vxtOMo1HOzwgXktL38X1ha4RJnjfsq.HDGy'),
(74, 'Tiago Santos', 'tiagojcorreiasantos@gmail.com', 11, NULL, false, false, '$2b$12$xrVYzZ4B5sKsYjKGs1vxtOMo1HOzwgXktL38X1ha4RJnjfsq.HDGy'),
-- T-Bag Drinkers
(75, 'José Silva', 'josesilva.jpas@gmail.com', 12, NULL, false, false, '$2b$12$o.86IxcEw8nTuEbJWkpxgO1F3tz9BpNWaFXfhoX2x5TGlgLTDnu7G'),
(76, 'Ana Martins', 'anamartins14@ua.pt', 12, NULL, false, false, '$2b$12$o.86IxcEw8nTuEbJWkpxgO1F3tz9BpNWaFXfhoX2x5TGlgLTDnu7G'),
(77, 'Natacha Ramos', 'natachaferreira@ua.pt', 12, NULL, false, false, '$2b$12$o.86IxcEw8nTuEbJWkpxgO1F3tz9BpNWaFXfhoX2x5TGlgLTDnu7G'),
(78, 'Joana Costa', 'joanamonteirocosta@ua.pt', 12, NULL, false, false, '$2b$12$o.86IxcEw8nTuEbJWkpxgO1F3tz9BpNWaFXfhoX2x5TGlgLTDnu7G'),
(79, 'Nolwenn Santos', 'nolwennsantos@ua.pt', 12, NULL, false, false, '$2b$12$o.86IxcEw8nTuEbJWkpxgO1F3tz9BpNWaFXfhoX2x5TGlgLTDnu7G'),
(80, 'Inês Branco', NULL, 12, NULL, false, false, '$2b$12$o.86IxcEw8nTuEbJWkpxgO1F3tz9BpNWaFXfhoX2x5TGlgLTDnu7G');


--
-- Name: checkpoint_id_seq; Type: SEQUENCE SET; Schema: rally_tascas; Owner: postgres
--

SELECT pg_catalog.setval('rally_tascas.checkpoint_id_seq', 1, false);


--
-- Name: team_id_seq; Type: SEQUENCE SET; Schema: rally_tascas; Owner: postgres
--

SELECT pg_catalog.setval('rally_tascas.team_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: rally_tascas; Owner: postgres
--

SELECT pg_catalog.setval('rally_tascas.user_id_seq', 1, false);


--
-- Name: checkpoint checkpoint_pkey; Type: CONSTRAINT; Schema: rally_tascas; Owner: postgres
--

ALTER TABLE ONLY rally_tascas.checkpoint
    ADD CONSTRAINT checkpoint_pkey PRIMARY KEY (id);


--
-- Name: team team_pkey; Type: CONSTRAINT; Schema: rally_tascas; Owner: postgres
--

ALTER TABLE ONLY rally_tascas.team
    ADD CONSTRAINT team_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: rally_tascas; Owner: postgres
--

ALTER TABLE ONLY rally_tascas."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user user_username_key; Type: CONSTRAINT; Schema: rally_tascas; Owner: postgres
--

ALTER TABLE ONLY rally_tascas."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- Name: user user_staff_checkpoint_id_fkey; Type: FK CONSTRAINT; Schema: rally_tascas; Owner: postgres
--

ALTER TABLE ONLY rally_tascas."user"
    ADD CONSTRAINT user_staff_checkpoint_id_fkey FOREIGN KEY (staff_checkpoint_id) REFERENCES rally_tascas.checkpoint(id);


--
-- Name: user user_team_id_fkey; Type: FK CONSTRAINT; Schema: rally_tascas; Owner: postgres
--

ALTER TABLE ONLY rally_tascas."user"
    ADD CONSTRAINT user_team_id_fkey FOREIGN KEY (team_id) REFERENCES rally_tascas.team(id);


--
-- PostgreSQL database dump complete
--
