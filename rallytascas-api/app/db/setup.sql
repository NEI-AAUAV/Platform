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
    question_scores boolean[],
    time_scores integer[],
    times timestamp without time zone[],
    pukes integer[],
    skips integer[],
    total integer,
    card1 integer,
    card2 integer,
    card3 integer,
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
(1, 'Tribunal', 'shot 1', 'Uma breve descrição qualquer.'),
(2, 'Receção', 'shot 2', 'Uma breve descrição qualquer.'),
(3, 'Cela', 'shot 3', 'Uma breve descrição qualquer.'),
(4, 'Pátio', 'shot 4', 'Uma breve descrição qualquer.'),
(5, 'Cantina', 'shot 5', 'Uma breve descrição qualquer.'),
(6, 'WC', 'shot 6', 'Uma breve descrição qualquer.'),
(7, 'Ginásio', 'shot 7', 'Uma breve descrição qualquer.'),
(8, 'Enfermaria', 'shot 8', 'Uma breve descrição qualquer.');


--
-- Data for Name: team; Type: TABLE DATA; Schema: rally_tascas; Owner: postgres
--

INSERT INTO rally_tascas.team (id, name, question_scores, time_scores, times, pukes, skips, total, card1, card2, card3, classification) VALUES
(1, 'Lambada de mão aberta', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(2, 'Os cansados', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(3, 'Porta Aberta', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(4, 'Seca Extrema', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(5, 'Uisqe konhaque tudo', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(6, 'Não tavas capaz não vinhas', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(7, 'Gueguenation', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(8, 'Que mistelga', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(9, 'equipa xl', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(10, 'Psisioneiros', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(11, 'FAJESƧE', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(12, 'Tasca do Pai Jorge', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(13, 'Psicoalcolémicos', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(14, 'Portugal', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(15, 'Pink stars', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1),
(16, 'Mmmm tenso', array[]::boolean[], array[]::integer[], array[]::timestamp without time zone[], array[]::integer[], array[]::integer[], 0, -1, -1, -1, -1);


--
-- Data for Name: user; Type: TABLE DATA; Schema: rally_tascas; Owner: postgres
--

INSERT INTO rally_tascas."user" (id, name, username, team_id, staff_checkpoint_id, is_admin, disabled, hashed_password) VALUES
(1, 'admin', 'admin', NULL, NULL, true, false, '$2b$12$ZdTAyeGS54YVZRS.9b2WVeMhwK5hB6bdWvxc3QM1mpR1HG0Pg2n5e'),
(2, 'staff1', 'staff1', NULL, 1, false, false, '$2b$12$/Ya5n.vMkX6QK1.aSlQ/../kAb8Qn7cexEbLu64afA5kyEfjag9Du'),
(3, 'staff2', 'staff2', NULL, 2, false, false, '$2b$12$Wx2clPbHCwkc7SzeYy6XnOlXHiHuriguU77RpD1pRnTo4aMMcY2Hq'),
(4, 'staff3', 'staff3', NULL, 3, false, false, '$2b$12$uq1FBdSK1IBqqlHDSpsVcu7bDJnd96klBzBgN/BZtqbueLHU7doie'),
(5, 'staff4', 'staff4', NULL, 4, false, false, '$2b$12$no9pN4jmaZKIFv/c54vPLuw6NpZsrn1mAUNPIvQli.mWuWhBsb0jm'),
(6, 'staff5', 'staff5', NULL, 5, false, false, '$2b$12$VBKNU90gTZiPIoCeBVr53ueQKkKEp7BmWuw/vdJgFcDf0Hlemrt6e'),
(7, 'staff6', 'staff6', NULL, 6, false, false, '$2b$12$QVKZ5u8NklAgLKY9M4ANz.D6i.Yyq5l.eV46jqwkaO96mas7froh.'),
(8, 'staff7', 'staff7', NULL, 7, false, false, '$2b$12$GnL.KdwpDLJx/RQAA/L8pOTBwtzYpGMsuMVhhYZax.3NvvA7gaKRW'),
(9, 'staff8', 'staff8', NULL, 8, false, false, '$2b$12$JuuAjRA7XoYvvKygARZ6tOYb5fdz72yHEs8p9sFmfqcR82QRzNc2a'),
-- Lambada de mão aberta
(10, 'Duarte Cruz', 'duarteccruz@ua.pt', 1, NULL, false, false, '$2b$12$Lb.R2Nqmp/Pi9oeNS894UOcXGJBmztvQlEseYRL4rgvblaO4KRP56'),
(11, 'Gonçalo Ferreira', 'goncalomf@ua.pt', 1, NULL, false, false, '$2b$12$Lb.R2Nqmp/Pi9oeNS894UOcXGJBmztvQlEseYRL4rgvblaO4KRP56'),
(12, 'Diogo Almeida', 'almeidadiogo03@ua.pt', 1, NULL, false, false, '$2b$12$Lb.R2Nqmp/Pi9oeNS894UOcXGJBmztvQlEseYRL4rgvblaO4KRP56'),
(13, 'Guilherme Duarte', 'duarte.g@ua.pt', 1, NULL, false, false, '$2b$12$Lb.R2Nqmp/Pi9oeNS894UOcXGJBmztvQlEseYRL4rgvblaO4KRP56'),
(14, 'Tomás Matos', 'tomas.matos@ua.pt', 1, NULL, false, false, '$2b$12$Lb.R2Nqmp/Pi9oeNS894UOcXGJBmztvQlEseYRL4rgvblaO4KRP56'),
(15, 'Rodrigo Graça', 'rodrigomgraca@ua.pt', 1, NULL, false, false, '$2b$12$Lb.R2Nqmp/Pi9oeNS894UOcXGJBmztvQlEseYRL4rgvblaO4KRP56'),
-- Os cansados
(16, 'Gonçalo Sousa', 'gfcs@ua.pt', 2, NULL, false, false, '$2b$12$F/pyG6PBEVapk8amrUrIFuV.yJ3X5lmw.VlUfsYJmlnF90YtxTCte'),
(17, 'João Monteiro', 'joao.mont@ua.pt', 2, NULL, false, false, '$2b$12$F/pyG6PBEVapk8amrUrIFuV.yJ3X5lmw.VlUfsYJmlnF90YtxTCte'),
(18, 'Liliana Ribeiro', 'lilianapcribeiro@ua.pt', 2, NULL, false, false, '$2b$12$F/pyG6PBEVapk8amrUrIFuV.yJ3X5lmw.VlUfsYJmlnF90YtxTCte'),
(19, 'Paulo Pinto', 'paulojnpinto02@ua.pt', 2, NULL, false, false, '$2b$12$F/pyG6PBEVapk8amrUrIFuV.yJ3X5lmw.VlUfsYJmlnF90YtxTCte'),
(20, 'Tiago Carvalho', 'tiagogcarvalho@ua.pt', 2, NULL, false, false, '$2b$12$F/pyG6PBEVapk8amrUrIFuV.yJ3X5lmw.VlUfsYJmlnF90YtxTCte'),
-- Porta Aberta
(21, 'Raquel Paradinha', 'raquelparadinha@ua.pt', 3, NULL, false, false, '$2b$12$2g6PxoUVlnJ.KBmeFUH9F.eyWhq5QI7NRfIQ8EgCFJJqzxaCFKpV2'),
(22, 'Catarina Costa', 'catarinateves02@ua.pt', 3, NULL, false, false, '$2b$12$2g6PxoUVlnJ.KBmeFUH9F.eyWhq5QI7NRfIQ8EgCFJJqzxaCFKpV2'),
(23, 'João Sousa', 'jsousa11@ua.pt', 3, NULL, false, false, '$2b$12$2g6PxoUVlnJ.KBmeFUH9F.eyWhq5QI7NRfIQ8EgCFJJqzxaCFKpV2'),
(24, 'Beatriz Dias', 'dias.beatriz@ua.pt', 3, NULL, false, false, '$2b$12$2g6PxoUVlnJ.KBmeFUH9F.eyWhq5QI7NRfIQ8EgCFJJqzxaCFKpV2'),
(25, 'Miguel Matos', 'miguelamatos@ua.pt', 3, NULL, false, false, '$2b$12$2g6PxoUVlnJ.KBmeFUH9F.eyWhq5QI7NRfIQ8EgCFJJqzxaCFKpV2'),
-- Seca Extrema
(26, 'Simão', 'simaocordeirosantos@ua.pt', 4, NULL, false, false, '$2b$12$XOHxnyGEeTkKZjGHZZ.6ee0ZcSnTIG/4WfAJbAg1Gs4vbzkZLcWj2'),
(27, 'Raquel', 'raq.milh@ua.pt', 4, NULL, false, false, '$2b$12$XOHxnyGEeTkKZjGHZZ.6ee0ZcSnTIG/4WfAJbAg1Gs4vbzkZLcWj2'),
(28, 'Inês', 'ines4@ua.pt', 4, NULL, false, false, '$2b$12$XOHxnyGEeTkKZjGHZZ.6ee0ZcSnTIG/4WfAJbAg1Gs4vbzkZLcWj2'),
(29, 'Lúcia', 'luciamsousa00@ua.pt', 4, NULL, false, false, '$2b$12$XOHxnyGEeTkKZjGHZZ.6ee0ZcSnTIG/4WfAJbAg1Gs4vbzkZLcWj2'),
(30, 'Alexandre', 'alexandretomas@ua.pt', 4, NULL, false, false, '$2b$12$XOHxnyGEeTkKZjGHZZ.6ee0ZcSnTIG/4WfAJbAg1Gs4vbzkZLcWj2'),
(31, 'João Gameiro', 'joao.gameiro@ua.pt', 4, NULL, false, false, '$2b$12$XOHxnyGEeTkKZjGHZZ.6ee0ZcSnTIG/4WfAJbAg1Gs4vbzkZLcWj2'),
-- Uisqe konhaque tudo
(32, 'Martim Santos', 'santos.martim@ua.pt', 5, NULL, false, false, '$2b$12$17DzetB.K.s4AeMMSc49POwMaOcmJ.0kdNneA.C159x8lSpkOyEGC'),
(33, 'Maria Linhares', 'marialinhares@ua.pt', 5, NULL, false, false, '$2b$12$17DzetB.K.s4AeMMSc49POwMaOcmJ.0kdNneA.C159x8lSpkOyEGC'),
(34, 'Rui Machado', 'rmachado@ua.pt', 5, NULL, false, false, '$2b$12$17DzetB.K.s4AeMMSc49POwMaOcmJ.0kdNneA.C159x8lSpkOyEGC'),
(35, 'Zakhar Kruptsala', 'zakhar.kruptsala@ua.pt', 5, NULL, false, false, '$2b$12$17DzetB.K.s4AeMMSc49POwMaOcmJ.0kdNneA.C159x8lSpkOyEGC'),
(36, 'Gabriel Martins Silva', 'gabrielmsilva4@ua.pt', 5, NULL, false, false, '$2b$12$17DzetB.K.s4AeMMSc49POwMaOcmJ.0kdNneA.C159x8lSpkOyEGC'),
(37, 'Guilherme Rosa', 'guilherme.rosa60@ua.pt', 5, NULL, false, false, '$2b$12$17DzetB.K.s4AeMMSc49POwMaOcmJ.0kdNneA.C159x8lSpkOyEGC'),
-- Não tavas capaz não vinhas
(38, 'Bernardo Figueiredo', 'bernardo.figueiredo@ua.pt', 6, NULL, false, false, '$2b$12$u6/QyJ3G1To/cTyvzg8ZReFE4M5DFXFoviSIRipxEHKmLVs44gl1i'),
(39, 'Gabriel Teixeira', 'gabrielm.teixeira@ua.pt', 6, NULL, false, false, '$2b$12$u6/QyJ3G1To/cTyvzg8ZReFE4M5DFXFoviSIRipxEHKmLVs44gl1i'),
(40, 'Joaquim Rosa', 'joaquimvr15@ua.pt', 6, NULL, false, false, '$2b$12$u6/QyJ3G1To/cTyvzg8ZReFE4M5DFXFoviSIRipxEHKmLVs44gl1i'),
(41, 'José Gameiro', 'jose.mcgameiro@ua.pt', 6, NULL, false, false, '$2b$12$u6/QyJ3G1To/cTyvzg8ZReFE4M5DFXFoviSIRipxEHKmLVs44gl1i'),
(42, 'Alexandre Cotorobai', 'alexandrecotorobai@ua.pt', 6, NULL, false, false, '$2b$12$u6/QyJ3G1To/cTyvzg8ZReFE4M5DFXFoviSIRipxEHKmLVs44gl1i'),
(43, 'Rodrigo Azevedo', 'rodrigo.azevedo@ua.pt', 6, NULL, false, false, '$2b$12$u6/QyJ3G1To/cTyvzg8ZReFE4M5DFXFoviSIRipxEHKmLVs44gl1i'),
-- Gueguenation
(44, 'Adriana Lages', 'adrianalages@ua.pt', 7, NULL, false, false, '$2b$12$bGzKO1o8ar3Hwj9mZR.GY.O4MHPTd25SorEx2tk4ptRNBI624hBgq'),
(45, 'Tomé Silva', 'tome.silva@ua.pt', 7, NULL, false, false, '$2b$12$bGzKO1o8ar3Hwj9mZR.GY.O4MHPTd25SorEx2tk4ptRNBI624hBgq'),
(46, 'Bernardo Botto', 'bernardoboto@ua.pt', 7, NULL, false, false, '$2b$12$bGzKO1o8ar3Hwj9mZR.GY.O4MHPTd25SorEx2tk4ptRNBI624hBgq'),
(47, 'Vasco Oliveira', 'vasco.oliveira00@ua.pt', 7, NULL, false, false, '$2b$12$bGzKO1o8ar3Hwj9mZR.GY.O4MHPTd25SorEx2tk4ptRNBI624hBgq'),
(48, 'Mariana Neves', 'mariananeves@ua.pt', 7, NULL, false, false, '$2b$12$bGzKO1o8ar3Hwj9mZR.GY.O4MHPTd25SorEx2tk4ptRNBI624hBgq'),
(49, 'Inês Vieira', 'inesvieira00@ua.pt', 7, NULL, false, false, '$2b$12$bGzKO1o8ar3Hwj9mZR.GY.O4MHPTd25SorEx2tk4ptRNBI624hBgq'),
-- Que mistelga
(50, 'Patrícia Vaz', 'patricianvaz@ua.pt', 8, NULL, false, false, '$2b$12$1SkXXmkzWVf7OLM/yuB3yuFugEBWsvdtyvZbBXMaY.H/.gUgmK7su'),
(51, 'Jéssica Fernandes', 'jessicavfernandes@ua.pt', 8, NULL, false, false, '$2b$12$1SkXXmkzWVf7OLM/yuB3yuFugEBWsvdtyvZbBXMaY.H/.gUgmK7su'),
(52, 'Eduardo Lopes', 'eduardolplopes@ua.pt', 8, NULL, false, false, '$2b$12$1SkXXmkzWVf7OLM/yuB3yuFugEBWsvdtyvZbBXMaY.H/.gUgmK7su'),
(53, 'Susana Pinto', 'susanapfpinto@ua.pt', 8, NULL, false, false, '$2b$12$1SkXXmkzWVf7OLM/yuB3yuFugEBWsvdtyvZbBXMaY.H/.gUgmK7su'),
(54, 'Iara Matos', 'iaramatos1110@gmail.com', 8, NULL, false, false, '$2b$12$1SkXXmkzWVf7OLM/yuB3yuFugEBWsvdtyvZbBXMaY.H/.gUgmK7su'),
(55, 'Pedro Gonçalves', 'pedroefta@gmail.com', 8, NULL, false, false, '$2b$12$1SkXXmkzWVf7OLM/yuB3yuFugEBWsvdtyvZbBXMaY.H/.gUgmK7su'),
-- equipa xl
(56, 'Mariana Oliveira', 'marianacso@ua.pt', 9, NULL, false, false, '$2b$12$eoI7CRl1gykUv2riC1PVAenLye1Q0INE69F9BKlel8aQscSklAHOW'),
(57, 'Sumeja Ferreira', 'sumejaferreira@ua.pt', 9, NULL, false, false, '$2b$12$eoI7CRl1gykUv2riC1PVAenLye1Q0INE69F9BKlel8aQscSklAHOW'),
(58, 'Beatriz Saraiva', 'beatriz.s@ua.pt', 9, NULL, false, false, '$2b$12$eoI7CRl1gykUv2riC1PVAenLye1Q0INE69F9BKlel8aQscSklAHOW'),
(59, 'Augusto Camacho', 'augustocamacho@ua.pt', 9, NULL, false, false, '$2b$12$eoI7CRl1gykUv2riC1PVAenLye1Q0INE69F9BKlel8aQscSklAHOW'),
(60, 'Maria Lucas', 'marialucas@ua.pt', 9, NULL, false, false, '$2b$12$eoI7CRl1gykUv2riC1PVAenLye1Q0INE69F9BKlel8aQscSklAHOW'),
(61, 'João Gonçalo', 'joao.goncalo.santos@ua.pt', 9, NULL, false, false, '$2b$12$eoI7CRl1gykUv2riC1PVAenLye1Q0INE69F9BKlel8aQscSklAHOW'),
-- Psisioneiros
(62, 'Oleksandr Vozovikov', 'hello@leks.gg', 10, NULL, false, false, '$2b$12$kF.5pvYfXfLAtwQe1Cmjr..eIpUCPQ6G2uSJC7QmPkDY6uaHONJ3G'),
(63, 'Nolwenn Santos', 'nolwennsantos@ua.pt', 10, NULL, false, false, '$2b$12$kF.5pvYfXfLAtwQe1Cmjr..eIpUCPQ6G2uSJC7QmPkDY6uaHONJ3G'),
(64, 'Lucas Sant''Ana de Alencar', 'lucas.alencar@ua.pt', 10, NULL, false, false, '$2b$12$kF.5pvYfXfLAtwQe1Cmjr..eIpUCPQ6G2uSJC7QmPkDY6uaHONJ3G'),
(65, 'Sophia Kikuchi', 'sophia.kikuchi@ua.pt', 10, NULL, false, false, '$2b$12$kF.5pvYfXfLAtwQe1Cmjr..eIpUCPQ6G2uSJC7QmPkDY6uaHONJ3G'),
(66, 'Gabriel Carvalho da Cruz Souza', 'gabriel.souza@ua.pt', 10, NULL, false, false, '$2b$12$kF.5pvYfXfLAtwQe1Cmjr..eIpUCPQ6G2uSJC7QmPkDY6uaHONJ3G'),
-- FAJESƧE
(67, 'Diana Carapuço', 'dianacardoso1881@gmail.com', 11, NULL, false, false, '$2b$12$McP9I3pPmDS7h0hloI9do.FemAr7wCd5kLl4d1k0QdKI2LKnc9wpK'),
(68, 'Carolina Marques', 'carolina.marques810@gmail.com', 11, NULL, false, false, '$2b$12$McP9I3pPmDS7h0hloI9do.FemAr7wCd5kLl4d1k0QdKI2LKnc9wpK'),
(69, 'Tiago Pereira', 'tiagopereira0477@gmail.com', 11, NULL, false, false, '$2b$12$McP9I3pPmDS7h0hloI9do.FemAr7wCd5kLl4d1k0QdKI2LKnc9wpK'),
(70, 'Diogo Ferreira', 'ferreiradiogo223@gmail.com', 11, NULL, false, false, '$2b$12$McP9I3pPmDS7h0hloI9do.FemAr7wCd5kLl4d1k0QdKI2LKnc9wpK'),
(71, 'Pedro Ramos', 'pedro10ramos1999@gmail.com', 11, NULL, false, false, '$2b$12$McP9I3pPmDS7h0hloI9do.FemAr7wCd5kLl4d1k0QdKI2LKnc9wpK'),
(72, 'Daniel Silva', 'danielfrsilva04@gmail.com', 11, NULL, false, false, '$2b$12$McP9I3pPmDS7h0hloI9do.FemAr7wCd5kLl4d1k0QdKI2LKnc9wpK'),
-- Tasca do Pai Jorge
(73, 'Margarida Martins', 'margarida.martins@ua.pt', 12, NULL, false, false, '$2b$12$.O1bIy8RQ7Y.vWYRf1um0O5wv7NZGsn6as104KyTbngPm74dTo1FO'),
(74, 'Leandro Silva', 'leandrosilva12@ua.pt', 12, NULL, false, false, '$2b$12$.O1bIy8RQ7Y.vWYRf1um0O5wv7NZGsn6as104KyTbngPm74dTo1FO'),
(75, 'Pedro Marques', 'pedroagoncalvesmarques@ua.pt', 12, NULL, false, false, '$2b$12$.O1bIy8RQ7Y.vWYRf1um0O5wv7NZGsn6as104KyTbngPm74dTo1FO'),
(76, 'Pedro Tavares', 'pedrod33@ua.pt', 12, NULL, false, false, '$2b$12$.O1bIy8RQ7Y.vWYRf1um0O5wv7NZGsn6as104KyTbngPm74dTo1FO'),
(77, 'Chico Silva', 'mariosilva@ua.pt', 12, NULL, false, false, '$2b$12$.O1bIy8RQ7Y.vWYRf1um0O5wv7NZGsn6as104KyTbngPm74dTo1FO'),
(78, 'Afonso Silva', 'afonsosilva6@ua.pt', 12, NULL, false, false, '$2b$12$.O1bIy8RQ7Y.vWYRf1um0O5wv7NZGsn6as104KyTbngPm74dTo1FO'),
-- Psicoalcolémicos
(79, 'Andreia Carlota Rodrigues', 'acar@ua.pt', 13, NULL, false, false, '$2b$12$UBwboAvKLYhceuCvl4IB.ODaAa9YhvQS4NxRN7hoVfI/GieNr/FuW'),
(80, 'Daniela Carquejo', 'danielacarquejo@ua.pt', 13, NULL, false, false, '$2b$12$UBwboAvKLYhceuCvl4IB.ODaAa9YhvQS4NxRN7hoVfI/GieNr/FuW'),
(81, 'Neuza Esteves', 'neuza-esteves@hotmail.com', 13, NULL, false, false, '$2b$12$UBwboAvKLYhceuCvl4IB.ODaAa9YhvQS4NxRN7hoVfI/GieNr/FuW'),
(82, 'Helena Bernardo', 'helenabernardo19@ua.pt', 13, NULL, false, false, '$2b$12$UBwboAvKLYhceuCvl4IB.ODaAa9YhvQS4NxRN7hoVfI/GieNr/FuW'),
(83, 'Daniela Fidalgo', 'danielasf@ua.pt', 13, NULL, false, false, '$2b$12$UBwboAvKLYhceuCvl4IB.ODaAa9YhvQS4NxRN7hoVfI/GieNr/FuW'),
(84, 'Henrique Oliveira', 'valent.oliv@ua.pt', 13, NULL, false, false, '$2b$12$UBwboAvKLYhceuCvl4IB.ODaAa9YhvQS4NxRN7hoVfI/GieNr/FuW'),
-- Portugal
(85, 'Filipe Maia Antão', 'fantao@ua.pt', 14, NULL, false, false, '$2b$12$mG2cHkOTlhfr61AMEzkP9Oeb3i6JxWfuZTUsQCZek71FZk1M9k8mi'),
(86, 'Pedro Matos', 'pedromfm02@ua.pt', 14, NULL, false, false, '$2b$12$mG2cHkOTlhfr61AMEzkP9Oeb3i6JxWfuZTUsQCZek71FZk1M9k8mi'),
(87, 'Simão Antunes', 'simaoma@ua.pt', 14, NULL, false, false, '$2b$12$mG2cHkOTlhfr61AMEzkP9Oeb3i6JxWfuZTUsQCZek71FZk1M9k8mi'),
(88, 'Pedro Nuno', 'pedronuno15@ua.pr', 14, NULL, false, false, '$2b$12$mG2cHkOTlhfr61AMEzkP9Oeb3i6JxWfuZTUsQCZek71FZk1M9k8mi'),
(89, 'Isaac Santiago', 'isaacddsantiago@uampt', 14, NULL, false, false, '$2b$12$mG2cHkOTlhfr61AMEzkP9Oeb3i6JxWfuZTUsQCZek71FZk1M9k8mi'),
(90, 'Tomás Marques', NULL, 14, NULL, false, false, '$2b$12$mG2cHkOTlhfr61AMEzkP9Oeb3i6JxWfuZTUsQCZek71FZk1M9k8mi'),
-- Pink stars
(91, 'Cíntia Magalhães', 'magalhaescintia9@ua.pt', 15, NULL, false, false, '$2b$12$VrFJ7HDsQum2wVvGf2ZoXuQCOJ5lp8KSmVQJHPSMNO4pgyDzeWwD2'),
(92, 'Maria Silva', 'geral.mariasilva36@gmail.com', 15, NULL, false, false, '$2b$12$VrFJ7HDsQum2wVvGf2ZoXuQCOJ5lp8KSmVQJHPSMNO4pgyDzeWwD2'),
(93, 'Beatriz Glória', 'beatriz.pg@ua.pt', 15, NULL, false, false, '$2b$12$VrFJ7HDsQum2wVvGf2ZoXuQCOJ5lp8KSmVQJHPSMNO4pgyDzeWwD2'),
(94, 'Catarina Castro', 'catarinalemoscastro@gmail.com', 15, NULL, false, false, '$2b$12$VrFJ7HDsQum2wVvGf2ZoXuQCOJ5lp8KSmVQJHPSMNO4pgyDzeWwD2'),
(95, 'Leonor Vicente', 'leonorvicente288@gmail.com', 15, NULL, false, false, '$2b$12$VrFJ7HDsQum2wVvGf2ZoXuQCOJ5lp8KSmVQJHPSMNO4pgyDzeWwD2'),
(96, 'Letícia Lima', 'leticiasantanadelima@gmail.com', 15, NULL, false, false, '$2b$12$VrFJ7HDsQum2wVvGf2ZoXuQCOJ5lp8KSmVQJHPSMNO4pgyDzeWwD2'),
-- Mmmm tenso
(97, 'José Almeida', 'jpaa1814@gmail.com', 16, NULL, false, false, '$2b$12$o.86IxcEw8nTuEbJWkpxgO1F3tz9BpNWaFXfhoX2x5TGlgLTDnu7G'),
(98, 'João Gomes', 'joaopedrog@ua.pt', 16, NULL, false, false, '$2b$12$o.86IxcEw8nTuEbJWkpxgO1F3tz9BpNWaFXfhoX2x5TGlgLTDnu7G'),
(99, 'Diogo Campinho', 'diogocampinho@ua.pt', 16, NULL, false, false, '$2b$12$o.86IxcEw8nTuEbJWkpxgO1F3tz9BpNWaFXfhoX2x5TGlgLTDnu7G'),
(100, 'Ana Guerra', 'anabguerra@ua.pt', 16, NULL, false, false, '$2b$12$o.86IxcEw8nTuEbJWkpxgO1F3tz9BpNWaFXfhoX2x5TGlgLTDnu7G'),
(101, 'Joana Lopes', 'joanalopes04@ua.pt', 16, NULL, false, false, '$2b$12$o.86IxcEw8nTuEbJWkpxgO1F3tz9BpNWaFXfhoX2x5TGlgLTDnu7G'),
(102, 'Matilde Gonçalves', 'matildegonçalves@ua.pt', 16, NULL, false, false, '$2b$12$o.86IxcEw8nTuEbJWkpxgO1F3tz9BpNWaFXfhoX2x5TGlgLTDnu7G');


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
