--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15.1

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
-- Data for Name: course; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.course (code, name, short, discontinued) FROM stdin;
9263	MESTRADO EM ENGENHARIA INFORMÁTICA (2º CICLO)	MEI	0
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei."user" (id, iupi, nmec, hashed_password, name, surname, gender, image, curriculum, linkedin, github, scopes, updated_at, created_at, birthday) FROM stdin;
1	\N	\N	$argon2id$v=19$m=65536,t=3,p=4$Tumdc87ZG4PQmtP6f8+5Fw$g1qvQyunD053z1FJiX91OGocYeas4IwHUBW2CqtEgAU	NEI	AAUAv	\N	\N	\N	\N	\N	{ADMIN}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
2	\N	\N		Beatriz	Marques	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
3	\N	\N		André	Moleirinho	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
4	\N	\N		Alexandre	Lopes	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
5	\N	\N		Alina	Yanchuk	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
6	\N	\N		Ana	Ortega	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
7	\N	\N		Rafaela	Vieira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
8	\N	\N		André	Alves	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
9	\N	\N		André	Amarante	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
10	\N	\N		Bárbara	Neto	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
11	\N	\N		Bernardo	Domingues	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
12	\N	\N		Bruno	Barbosa	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
13	\N	\N		Bruno	Pinto	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
14	\N	\N		Camila	Uachave	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
15	\N	\N		Carina	Neves	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
16	\N	\N		Carlos	Pacheco	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
17	\N	\N		Carlota	Marques	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
18	\N	\N		Carolina	Araújo	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
19	\N	\N		Carolina	Albuquerque	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
20	\N	\N		Andreia	Ferreira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
21	\N	\N		Catarina	Vinagre	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
22	\N	\N		Cláudio	Costa	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
23	\N	\N		Cláudio	Santos	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
24	\N	\N		Carlos	Soares	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
25	\N	\N		João	Costa	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
26	\N	\N		Cristóvão	Freitas	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
27	\N	\N		Dinis	Cruz	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
28	\N	\N		Mimi	Cunha	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
29	\N	\N		Daniel	Rodrigues	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
30	\N	\N		David	Fernandes	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
31	\N	\N		David	Ferreira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
32	\N	\N		David	Ferreira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
33	\N	\N		Dimitri	Silva	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
34	\N	\N		Diogo	Andrade	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
35	\N	\N		Diogo	Reis	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
36	\N	\N		Diogo	Silva	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
37	\N	\N		Diogo	Bento	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
38	\N	\N		Diogo	Ramos	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
39	\N	\N		Diogo	Paiva	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
40	\N	\N		Duarte	Mortágua	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
41	\N	\N		Eduardo	Martins	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
42	\N	\N		Emanuel	Laranjo	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
43	\N	\N		Eduardo	Santos	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
44	\N	\N		Fábio	Almeida	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
45	\N	\N		Fábio	Barros	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
46	\N	\N		Filipe	Castro	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
47	\N	\N		Flávia	Figueiredo	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
48	\N	\N		Francisco	Silveira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
49	\N	\N		Gonçalo	Matos	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
50	\N	\N		Guilherme	Moura	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
51	\N	\N		Hugo	Pintor	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
52	\N	\N		Hugo	Correia	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
53	\N	\N		Hugo	Almeida	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
54	\N	\N		Inês	Correia	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
55	\N	\N		Isadora	Loredo	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
56	\N	\N		João	Vasconcelos	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
57	\N	\N		João	Costa	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
58	\N	\N		Joana	Coelho	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
59	\N	\N		João	Laranjo	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
60	\N	\N		João	Ribeiro	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
61	\N	\N		João	Ferreira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
62	\N	\N		João	Limas	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
63	\N	\N		João	Dias	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
64	\N	\N		João	Paúl	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
65	\N	\N		João Abílio	Rodrigues	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
66	\N	\N		João	Alegria	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
67	\N	\N		João	Soares	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
68	\N	\N		Jorge	Fernandes	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
69	\N	\N		José	Frias	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
70	\N	\N		José	Moreira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
71	\N	\N		José	Ribeiro	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
72	\N	\N		Josimar	Cassandra	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
73	\N	\N		João	Magalhães	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
74	\N	\N		Leandro	Silva	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
75	\N	\N		Luís Miguel	Costa	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
76	\N	\N		Luís	Fonseca	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
77	\N	\N		Luís	Silva	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
78	\N	\N		Luis	Santos	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
79	\N	\N		Luís	Oliveira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
80	\N	\N		Marco	Miranda	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
81	\N	\N		Marco	Ventura	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
82	\N	\N		Marcos	Silva	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
83	\N	\N		Margarida	Martins	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
84	\N	\N		Marta	Ferreira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
85	\N	\N		Maxlaine	Moreira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
86	\N	\N		Mariana	Sequeira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
87	\N	\N		Miguel	Mota	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
88	\N	\N		Miguel	Antunes	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
89	\N	\N		André	Morais	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
90	\N	\N		Paulo	Seixas	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
91	\N	\N		Andreia	Patrocínio	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
92	\N	\N		Paulo	Pintor	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
93	\N	\N		Pedro	Bastos	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
94	\N	\N		Pedro	Ferreira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
95	\N	\N		Pedro	Matos	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
96	\N	\N		Pedro	Oliveira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
97	\N	\N		Jorge	Pereira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
98	\N	\N		João	Rodrigues	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
99	\N	\N		Pedro	Neves	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
100	\N	\N		Pedro	Pires	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
101	\N	\N		Rafael	Direito	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
102	\N	\N		Rafael	Teixeira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
103	\N	\N		Rafael	Simões	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
104	\N	\N		Rui	Fernandes	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
105	\N	\N		João	Peixe Ribeiro	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
106	\N	\N		Ricardo	Cruz	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
107	\N	\N		Ricardo	Mendes	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
108	\N	\N		Rita	Jesus	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
109	\N	\N		Rita	Portas	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
110	\N	\N		Rafael	Martins	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
111	\N	\N		Rui	Coelho	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
112	\N	\N		Rui	Azevedo	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
113	\N	\N		Joana	Silva	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
114	\N	\N		Sandra	Andrade	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
115	\N	\N		Sérgio	Martins	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
116	\N	\N		Sara	Furão	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
117	\N	\N		Simão	Arrais	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
118	\N	\N		Sofia	Moniz	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
119	\N	\N		Tiago	Cardoso	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
120	\N	\N		Tiago	Mendes	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
121	\N	\N		Tomás	Batista	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
122	\N	\N		Tomás	Costa	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
123	\N	\N		Artur	Romão	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
124	\N	\N		Camila	Fonseca	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
125	\N	\N		Daniela	Dias	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
126	\N	\N		Diana	Siso	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
127	\N	\N		Diogo	Monteiro	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
128	\N	\N		Fábio	Martins	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
129	\N	\N		João	Reis	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
130	\N	\N		Mariana	Rosa	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
131	\N	\N		Marta	Fradique	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
132	\N	\N		Miguel	Ferreira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
133	\N	\N		Paulo	Pereira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
134	\N	\N		Pedro	Sobral	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
135	\N	\N		Renato	Dias	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
136	\N	\N		Vitor	Dias	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
137	\N	\N		Afonso	Campos	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
138	\N	\N		Yanis	Faquir	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
139	\N	\N		Pedro	Figueiredo	\N	\N	\N	https://www.linkedin.com/in/pedro-figueiredo-9983181ba/	https://github.com/PFig420	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
140	\N	\N		Artur	Correia	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
141	\N	\N		André	Benquerença	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
142	\N	\N		Daniel	Carvalho	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
143	\N	\N		Rafael	Gonçalves	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
144	\N	\N		Inês	Ferreira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
145	\N	\N		Rodrigo	Oliveira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
146	\N	\N		Miguel	Fonseca	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
147	\N	\N		Catarina	Costa	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
148	\N	\N		Leonardo	Almeida	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
149	\N	\N		Lucius	Filho	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
150	\N	\N		Daniel	Ferreira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
151	\N	\N		Filipe	Silva	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
152	\N	\N		Alexandre	Santos	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
153	\N	\N		Vicente	Barros	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
154	\N	\N		Tiago	Gomes	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
155	\N	\N		Rafaela	Abrunhosa	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
156	\N	\N		Matilde	Teixeira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
157	\N	\N		Hugo	Correia	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
159	\N	\N		Pedro	Rei	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
160	\N	\N		João	Luís	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
161	\N	\N		Tomás	Almeida	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
162	\N	\N		Bernado	Leandro	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
163	\N	\N		Lia	Cardoso	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
164	\N	\N		Violeta	Ramos	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
165	\N	\N		Marta	Inácio	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
166	\N	\N		Bárbara	Galiza	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
167	\N	\N		Roberto	Castro	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
168	\N	\N		Diogo	Falcão	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
169	\N	\N		Diogo	Fernandes	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
170	\N	\N		Ricardo	Martins	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
171	\N	\N		Fábio	Matias	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
172	\N	\N		Carolina	Silva	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
173	\N	\N		André	Dora	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
174	\N	\N		Raquel	Vinagre	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
175	\N	\N		Hugo	Castro	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
176	\N	\N		Henrique	Mendonça	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
177	\N	\N		Daniel	Figueiredo	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
178	\N	\N		Ana Rita	Silva	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
179	\N	\N		João	Capucho	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
180	\N	\N		Joana	Gomes	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
181	\N	\N		António	Alberto	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
182	\N	\N		Regina	Tavares	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
183	\N	\N		Maria	Linhares	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
184	\N	\N		Guilherme	Rosa	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
185	\N	\N		Henrique	Teixeira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
186	\N	\N		Gabriel	Teixeira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
187	\N	\N		Tomás	Victal	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
188	\N	\N		Luca	Pereira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
189	\N	\N		Gonçalo	Sousa	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
190	\N	\N		Vicente	Costa	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
191	\N	\N		Daniel	Madureira	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
192	\N	\N		Pedro	Monteiro	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
193	\N	\N		Eduardo	Fernandes	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
194	\N	\N		Diana	Miranda	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
195	\N	\N		José	Gameiro	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
196	\N	\N		Bernardo	Figueiredo	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
197	\N	\N		Alexandre	Cotorobai	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
198	\N	\N		João	Borges	\N	\N	\N	\N	\N	{}	2023-01-01 00:00:00	2023-01-01 00:00:00	\N
\.


--
-- Data for Name: device_login; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.device_login (user_id, session_id, refreshed_at, expires_at) FROM stdin;
0	1681486354	2023-04-14 15:32:34.066286	2023-04-21 15:32:34.066286
0	1681684724	2023-04-16 22:38:44.876764	2023-04-23 22:38:44.876764
0	1681737128	2023-04-17 13:12:08.68512	2023-04-24 13:12:08.68512
0	1681737222	2023-04-17 13:13:42.539913	2023-04-24 13:13:42.539913
\.


--
-- Data for Name: faina; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.faina (id, image, mandate) FROM stdin;
1	\N	2012/13
2	\N	2013/14
3	\N	2014/15
4	\N	2015/16
5	\N	2016/17
6	\N	2017/18
7	/faina/2018.jpg	2018/19
8	/faina/2019.jpg	2019/20
9	/faina/2020.jpg	2020/21
10	/faina/2021.jpg	2021/22
\.


--
-- Data for Name: faina_role; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.faina_role (id, name, weight) FROM stdin;
1	Junco	1
2	Caniça	1
3	Moço	2
4	Moça	2
5	Marnoto	4
6	Salineira	3
7	Mestre	5
8	Arrais	6
9	Varina	6
10	Mestre de Curso	6
\.


--
-- Data for Name: faina_member; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.faina_member (id, member_id, faina_id, role_id) FROM stdin;
1	39	1	10
2	80	1	7
3	25	1	5
4	29	1	5
5	151	1	5
6	58	1	6
7	113	1	6
8	108	1	6
9	38	1	3
10	82	1	3
11	99	1	3
12	113	2	10
13	108	2	7
14	44	2	5
15	82	2	5
16	99	2	5
17	115	2	5
18	20	2	4
19	71	2	3
20	78	2	3
21	85	2	2
22	110	2	1
23	99	3	10
24	16	3	7
25	44	3	7
26	115	3	7
27	78	3	5
28	21	3	4
29	66	3	3
30	79	3	3
31	85	3	4
32	110	3	3
33	116	3	4
34	78	4	10
35	6	4	7
36	42	4	7
37	50	4	7
38	152	4	5
39	13	4	5
40	26	4	5
41	88	4	5
42	12	4	3
43	3	4	1
44	64	4	1
45	50	5	10
46	152	5	7
47	12	5	5
48	28	5	6
49	95	5	5
50	64	5	3
51	81	5	3
52	91	5	2
53	24	5	1
54	119	5	1
55	12	6	10
56	32	6	7
57	91	6	4
58	24	6	3
59	19	6	4
60	30	6	3
61	33	6	3
62	57	6	3
63	119	6	3
64	117	6	1
65	91	7	9
66	57	7	5
67	73	7	5
68	70	7	5
69	22	7	3
70	48	7	3
71	75	7	3
72	114	7	4
73	8	7	1
74	15	7	2
75	120	7	1
76	57	8	10
77	61	8	7
78	73	8	7
79	70	8	7
80	15	8	4
81	77	8	3
82	84	8	4
83	120	8	3
84	27	8	1
85	43	8	1
86	93	8	1
87	73	9	10
88	61	9	7
89	70	9	7
90	15	9	6
91	77	9	5
92	43	9	3
93	93	9	3
94	104	9	3
95	123	9	1
96	129	9	1
97	134	9	1
98	15	10	10
99	43	10	5
100	77	10	7
101	93	10	5
102	104	10	5
103	123	10	3
104	129	10	3
105	133	10	3
106	134	10	3
107	130	10	4
\.


--
-- Data for Name: history; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.history (moment, title, body, image) FROM stdin;
2018-04-30	Elaboração de Candidatura para o Encontro Nacional de Estudantes de Informática 2019	Entrega de uma candidatura conjunta (NEI+AETTUA) para a organização do Encontro Nacional de Estudantes de Informática 2019. Esta candidatura teve a concorrência de uma candidatura conjunta do ISCAC Junior Solutions e Junisec, constituída por alunos do Politécnico de Coimbra, que acabaram por ser a candidatura vencedora.	/history/20180430.png
2019-03-09	1ª Edição ThinkTwice	A primeira edição do evento, realizada em 2019, teve lugar no Auditório Mestre Hélder Castanheira da Universidade de Aveiro e contou com uma duração de 24 horas para a resolução de 30 desafios colocados, que continham diferentes graus de dificuldade. O evento contou com a participação de 34 estudantes, perfazendo um total de 12 equipas.	/history/20190309.jpg
2019-06-12	2º Lugar Futsal	Num jogo em que se fizeram das tripas coração, o NEI defrontou a equipa de EGI num jogo que veio a perder, foi um jogo bastante disputado, contudo, acabou por ganhar EGI remetendo o NEI para o 2º lugar.	/history/20190612.jpg
2019-06-30	Candidatura ENEI 2020	Entrega de uma candidatura conjunta (NEI+NEECT+AETTUA) para a organização do Encontro Nacional de Estudantes de Informática 2019. Esta candidatura teve a concorrência de uma candidatura conjunta da CESIUM, constituída por alunos da Universidade do Minho, que acabaram por ser a candidatura vencedora.	/history/20190630.png
2020-03-06	2ª Edição ThinkTwice	A edição de 2020 contou com a participação de 57 participantes divididos em 19 equipas, com 40 desafios de algoritmia de várias dificuldades para serem resolvidos em 40 horas, tendo lugar nas instalações da Casa do Estudante da Universidade de Aveiro. Esta edição contou ainda com 2 workshops e um momento de networking com as empresas patrocinadoras do evento.	/history/20200306.jpg
2021-05-07	3ª Edição ThinkTwice	Devido ao contexto pandémico que se vivia a 3ª edição foi 100% online através de plataformas como o Discord e a Twitch, de 7 a 9 de maio. Nesta edição as 11 equipas participantes puderam escolher participar em uma de três tipos de competição: desafios de algoritmia, projeto de gamificação e projeto de cibersegurança. O evento contou ainda com 4 workshops e uma sessão de networking com as empresas patrocinadoras.	/history/20210507.png
\.


--
-- Data for Name: merch; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.merch (id, name, image, price, number_of_items) FROM stdin;
1	Emblema de curso	/merch/emblema.png	2.5	0
2	Cachecol de curso	/merch/scarf.png	3.5	0
3	Casaco de curso	/merch/casaco.png	16.5	0
4	Sweat de curso	/merch/sweat.png	18	0
5	Emblema NEI	/merch/emblemanei.png	2.5	0
\.


--
-- Data for Name: news; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.news (id, header, status, title, category, content, published_by, created_at, last_change_at, changed_by, author_id) FROM stdin;
1	/news/6aniversario.jpg	ACTIVE	6º Aniversário NEI	EVENT	Fez 6 anos, no passado dia 24 de Janeiro, que se formou o Núcleo de Estudantes de Informática. Para celebrar o 6º aniversário do NEI, convidamos todos os nossos alunos, colegas e amigos a juntarem-se a nós num jantar repleto de surpresas. O jantar realizar-se-á no dia 28 de fevereiro no restaurante \\Monte Alentejano\\ - Rua de São Sebastião 27A - pelas 20h00 tendo um custo de 11 euros por pessoa. Contamos com a presença de todos para apagarmos as velas e comermos o bolo, porque alegria e diversão já têm presença marcada!<hr><b>Ementa</b><ul><li>Carne de porco à alentejana/ opção vegetariana</li><li>Bebida à descrição</li><li>Champanhe</li><li>Bolo</li></ul>  Nota: Caso pretendas opção vegetariana deves comunicar ao NEI por mensagem privada no facebook ou então via email.<hr><b>Informações</b><br>Inscrições até dia 21 de fevereiro sendo que as mesmas estão limitadas a 100 pessoas.<br>&#9888;&#65039; A inscrição só será validada após o pagamento junto de um elemento do NEI até dia 22 de fevereiro às 16horas!<br>+info: nei@aauav.pt ou pela nossa página de Facebook<br><hr><b>Logins</b><br>Caso não saibas o teu login contacta: <a href=\\https://www.facebook.com/ruicoelho43\\>Rui Coelho</a> ou então diretamente com o <a href=\\https://www.facebook.com/nei.aauav/\\>NEI</a>, podes ainda mandar mail para o NEI, nei@aauav.pt.	111	2019-01-18 00:00:00	\N	\N	1
2	/news/rgm1.png	ACTIVE	Convocatória RGM Extraordinária	EVENT	De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos Núcleos da Associação Académica da Universidade de Aveiro, convocam-se todos os membros da Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática para uma Reunião Geral de Membros Extraordinária, que se realizará no dia 14 do mês de Fevereiro de 2019, na sala 102 do Departamento de Eletrónica, Telecomunicações e Informática da Universidade de Aveiro, pelas 18 horas, com a seguinte ordem de trabalhos:  <br><br>1. Aprovação da Ata da RGM anterior;   <br>2. Informações;   <br>3. Apresentação do Plano de Atividades e Orçamento;  <br>4. Aprovação do Plano de Atividades e Orçamentos;  <br>5. Outros assuntos.   <br><br>Mais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI.<br><br><div style=\\text-align:center\\>Aveiro, 11 de janeiro de 2019<br>David Augusto de Sousa Fernandes<br>Presidente da Mesa da Reunião Geral de Membros<br>Núcleo de Estudantes de Informática da AAUAv <br></div><hr>Links úteis:<br><a href=\\https://nei.web.ua.pt/scripts/unlock.php?url=upload/documents/RGM_ATAS/2018/RGM_10jan2019.pdf\\ target=\\_blank\\>Ata da RGM anterior</a><br><a href=\\https://nei.web.ua.pt/upload/documents/CONV_ATAS/2019/1RGM.pdf\\ target=\\_blank\\>Documento da convocatória</a> 	111	2019-02-11 00:00:00	\N	\N	1
3	/news/rgm2.png	ACTIVE	Convocatória RGM Extraordinária	EVENT	De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos  Núcleos  da  Associação Académica  da  Universidade  de  Aveiro,  convocam-se  todos  os membros  da  Licenciatura  em  Engenharia  Informática  e  Mestrado  em  Engenharia  Informática para uma Reunião Geral de MembrosExtraordinária, que se realizará no dia 1do mês de Abrilde 2019,   na   sala   102   do   Departamento   de   Eletrónica,   Telecomunicações   e   Informática   da Universidade de Aveiro, pelas 17:45horas, com a seguinte ordem de trabalhos: <br><br>1. Aprovação da Ata da RGM anterior;   <br>2. Informações;   <br>3. Discussão sobre o tema da barraca;  <br>4. Orçamento Participativo 2019;  <br>5. Outros assuntos.   <br><br>Se   à   hora   indicada   não   existir   quórum,   a   Assembleia   iniciar-se-á   meia   hora   depois, independentemente do número de membros presentes, no mesmo local, e com a mesma ordem de trabalhos.<br>Mais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI (https://nei.web.ua.pt).<br><br><div style=\\text-align:center\\>Aveiro, 28 de Março de 2019<br>David Augusto de Sousa Fernandes<br>Presidente da Mesa da Reunião Geral de Membros<br>Núcleo de Estudantes de Informática da AAUAv <br></div><hr>	111	2019-03-28 00:00:00	\N	\N	1
4	/news/idpimage.png	ACTIVE	Integração IDP	NEWS	Recentemente foi feito um update no site que permite agora aos alunos de Engenharia Informática, quer mestrado, quer licenciatura, iniciar sessão no site  <a href=\\https://nei.web.ua.pt\\>nei.web.ua.pt</a> através do idp. <br>Esta alteração tem por consequência direta que a gestão de passwords deixa de estar diretamente ligada ao NEI passando assim, deste modo, qualquer password que seja perdida ou seja necessária alterar, responsabilidade do IDP da UA.<br><hr><h5 style=\\text-align: center\\><strong>Implicações diretas</strong></h5><br>Todas as funcionalidades do site se mantém e esta alteração em nada afeta o normal workflow do site, os apontamentos vão continuar na mesma disponíveis e em breve irão sofrer um update sendo corrigidas eventuais falhas nos atuais e adicionados mais alguns apontamentos No que diz respeito aos jantares de curso, a inscrição para estes também será feita via login através do IDP.<br>De forma genérica o IDP veio simplificar a forma como acedemos às plataformas do NEI, usando assim o Utilizador Universal da Universidade de Aveiro para fazer o login.<br>É de frisar que <strong>apenas</strong> os estudantes dos cursos  <strong>Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática  </strong>têm acesso ao site, todos os outros irão receber uma mensagem de erro quando fazem login e serão redirecionados para a homepage, não tendo, assim, acesso à informação e funcionalidades que necessitam de autenticação.<hr><h5 style=\\text-align: center\\><strong>Falha nos acessos</strong></h5><br>Existe a possibilidade de alguns alunos não terem acesso caso ainda não tivessem sido registados na versão antiga do site, assim, caso não consigas aceder por favor entra em contacto connosco via email para o <a href=\\mailto:nei@aauav.pt?Subject=Acesso%20NEI\\ target=\\_top\\>NEI</a> ou via facebook por mensagem direta para o <a href=\\https://www.facebook.com/nei.aauav/\\>NEI</a> ou então diretamente com o <a href=\\https://www.facebook.com/ruicoelho43\\>Rui Coelho</a>.<br>	111	2019-05-15 00:00:00	\N	\N	1
5	/news/florinhas.jpg	ACTIVE	Entrega de t-shirts à Florinhas de Vouga	NEWS	Hoje procedemos à entrega de mais de 200 t-shirts em bom estado que nos sobraram ao longo dos anos às Florinhas Do Vouga, possibilitando assim roupa a quem mais precisa.<br>A IPSS – Florinhas do Vouga é uma Instituição Diocesana de Superior Interesse Social, fundada em 6 de Outubro de 1940 por iniciativa do Bispo D. João Evangelista de Lima Vidal, a quem se deve a criação de obras similares, as Florinhas da Rua em Lisboa e as Florinhas da Neve em Vila Real.<br>A Instituição desenvolve a sua intervenção na cidade de Aveiro, mais concretamente na freguesia da Glória, onde se situa um dos Bairros Sociais mais problemáticos da cidade (Bairro de Santiago), dando também resposta, sempre que necessário, às solicitações das freguesias limítrofes e outras, algumas delas fora do Concelho.<br>No desenvolvimento da sua actividade mantém com o CDSSS de Aveiro Acordos de Cooperação nas áreas da Infância e Juventude; População Idosa; Família e Comunidade e Toxicodependência.<br>É Entidade aderente do Núcleo Local de Inserção no âmbito do Rendimento Social de Inserção, parceira do CLAS, assumindo com os diferentes Organismos e Instituições uma parceria activa.<br>O desenvolvimento das respostas decorreu até Agosto de 2008 em equipamentos dispersos na freguesia da Glória e Vera Cruz, o que levou a Instituição a construir um edifício de raiz na freguesia da Glória, espaço onde passou a ter condições para concentrar parte das respostas que desenvolvia (nomeadamente Estabelecimento de Educação Pré-Escolar, CATL e SAD), assumir novas respostas (Creche), dar continuidade ao trabalho desenvolvido e garantir uma melhoria substancial na qualidade dos serviços prestados, encontrando-se neste momento num processo de implementação de Sistema de Gestão de Qualidade com vista à certificação.<br>A presença de famílias numerosas, multiproblemáticas, sem rendimentos de trabalho, quase que limitadas a rendimentos provenientes de prestações sociais, famílias com fortes vulnerabilidades, levaram a Instituição a ser mediadora no Programa Comunitário de Ajuda a Carenciados e a procurar sinergias capazes de optimizar os seus recursos existentes e dar resposta à emergência social, são exemplos disso a acção “Mercearia e Companhia”, que apoia mensalmente cerca de 200 famílias em géneros alimentares, vestuário e outros e a “Ceia com Calor” que distribui diariamente um suplemento alimentar aos Sem-abrigo de Aveiro.<br>É de salientar que as famílias que usufruem de Respostas Socais tipificadas, face às suas vulnerabilidades acabam por não conseguir assumir o pagamento das mensalidades mínimas que deveriam pagar pela prestação dos serviços que lhe são garantidos pela Instituição, o que exige um maior esforço por parte desta.<br>Em termos globais, a Instituição tem assumido uma estratégia de efectiva prevenção, promoção e inclusão da população alvo.<br><strong>Se tiveres roupa ou produtos de higiene a mais e queres ajudar as Florinhas por favor dirige-te à instituição e entrega as mesmas!</strong><br>Fica a conhecer mais sobre esta instituição: http://www.florinhasdovouga.pt	65	2019-09-11 00:00:00	\N	\N	1
6	/news/rgm3.png	ACTIVE	Convocatória RGM Extraordinária	EVENT	De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos Núcleos da Associação Académica da Universidade de Aveiro, convocam-se todos os membros da Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática para uma Reunião Geral de Membros Extraordinária, que se realizará no dia 24 do mês de Setembro de 2019, na sala 102 do Departamento de Eletrónica, Telecomunicações e Informática da Universidade de Aveiro, pelas 18:00 horas, com a seguinte ordem de trabalhos: <br><br>1. Aprovação da Ata da RGM anterior; <br>2. Informações; <br>3. Pitch Bootcamp; <br>4. Taça UA; <br>5. Programa de Integração; <br>6. Outros assuntos. <br><br>Se à hora indicada não existir quórum, a Assembleia iniciar-se-á meia hora depois, independentemente do número de membros presentes, no mesmo local, e com a mesma ordem de trabalhos.<br>Mais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI (https://nei.web.ua.pt), sendo necessário fazer login na plataforma para ter acesso à mesma.<br><br><div style=\\text-align:center\\>David Augusto de Sousa Fernandes<br>Aveiro, 20 de setembro de 2019<br>Presidente da Mesa da Reunião Geral de Membros<br>Núcleo de Estudantes de Informática da AAUAv <br></div><hr>	65	2019-09-20 00:00:00	\N	\N	1
7	/news/newNEI.png	ACTIVE	Lançamento do novo portal do NEI	NEWS	Passado um cerca de um ano após o lançamento da versão anterior do portal do NEI, lançamos agora uma versão renovada do mesmo com um desgin mais atrativo utilizando react para a sua criação.<br>Esta nova versão do site conta com algumas novas features:<ol>  <li>Podes agora ter uma foto utilizando o gravatar, fizemos a integração com o mesmo.</li>  <li>Podes associar o teu CV, linkedin e conta git ao teu perfil.</li>  <li>Vais poder acompanhar tudo o que se passa na taça UA com as equipas do NEI a partir da plataforma de desporto que em breve será colocada online.</li>  <li>Existe uma secção que vai permitir aos alunos interessados no curso encontrar informação sobre o mesmo mais facilmente.</li>  <li>Podes encontrar a composição de todas as coordenações na página dedicada à equipa.</li>  <li>Podes encontrar a composição de todas as comissões de faina na página dedicada à equipa.</li>  <li>Integração dos eventos criados no facebook.</li>  <li>Podes ver todas as tuas compras de Merchandising.</li>  <li>Possibilidade de divulgar os projetos no site do NEI todos os projetos que fazes, estes não precisam de ser apenas projetos universitários, podem ser também projetos pessoais. Esta função ainda não está ativa mas em breve terás novidades.</li>  <li>Foi redesenhada a página dos apontamentos sendo agora mais fácil encontrares os apontamentos que precisas, podes pesquisar diretamente ou utilizar diferentes sorts de modo a que fiquem ordenados a teu gosto.</li></ol> À semelhança da anterior versão do website do NEI continuamos a ter a integração do IPD da UA fazendo assim a gestão de acessos ao website mais facilmente. Caso tenhas algum problema com o teu login entra em contacto conosco para resolvermos essa situação.<br>Da mesma que o IDP se manteve, todas as funcionalidades anteriores foram mantidas, apenas remodelamos a imagem. Quanto às funcionalidades existentes, fizemos uma pequena alteração nas atas da RGM, as mesmas passam agora apenas a estarem disponíveis para os membros do curso.Chamamos para a atenção do facto de que, na anterior versão todas as opções existentes no site apareciam logo sem login e posteriormente é que era pedido o mesmo, alteramos isso, agora só aparecem todas as opções após login.<hr>Caso encontres algum bug por favor informa o NEI de modo a que este possa ser corrigido!	111	2019-07-22 00:00:00	2019-09-06 00:00:00	111	1
8	/news/mecvsei.jpg	ACTIVE	Engenharia Mecânica vs Engenharia Informática (3-2)	EVENT	Apesar da derrota frente a Engenharia Mecânica por 3-2 num jogo bastante efusivo tivemos as bancadas cheias.<br>Mostramos hoje, novamente, que não é por acaso que ganhamos o prémio de melhor claque da época 2018/2019<br>Podes ver as fotos do jogo no nosso facebook:<br><br><iframe src=\\https://www.facebook.com/plugins/post.php?href=https%3A%2F%2Fwww.facebook.com%2Fmedia%2Fset%2F%3Fset%3Da.2657806134483446%26type%3D3&width=500\\ width=\\500\\ height=\\650\\ align=\\middle\\ style=\\border:none;overflow:hidden\\ scrolling=\\no\\ frameborder=\\0\\ allowTransparency=\\true\\ allow=\\encrypted-media\\></iframe>	111	2019-10-17 00:00:00	\N	\N	1
9	/news/melhorclaque.jpg	ACTIVE	Melhor Claque 2018/2019	NEWS	No passado domingo, dia 13 de outubro, decorreu a gala <strong>Academia de Ouro</strong> organizada pela Associação Académica da Universidade de Aveiro.<br>Esta gala visa distinguir personalidades que se destacaram na época de 2018/2019 e dar a conhecer a nova época.<br>O curso de Engenharia Informática foi nomeado para melhor claque e acabou por vencer trazendo para o DETI um prémio que faltava no palmarés.<br>O troféu encontra-se agora exposto junto da porta que dá acesso ao aquário.<br>Resalvamos que esteve ainda nomeado o Bruno Barbosa para melhor jogador mas infelizmente não ganhou o prémio.<br>	111	2019-10-17 00:00:00	\N	\N	1
10	/news/boxburger.png	ACTIVE	Aproveita o teu desconto de 25%	PARCERIA	Façam como a Flávia e o Luís e comam no Box Burger.<br>Agora qualquer estudante de Engenharia Informática tem desconto de 25%. Basta apresentarem o cartão de estudante e informar que são de Engenharia Informática.<br>Do que estás à espera? Aproveita!	111	2019-10-17 00:00:00	\N	\N	1
11	/news/rally.jpg	ACTIVE	Aveiro Horror Story | Rally Tascas #2	EVENT	És aquele que boceja nos filmes de terror? Adormeceste enquanto dava a parte mais tramada do filme? Este Rally Tascas é para ti!<br>Vem pôr à prova a tua capacidade de engolir o medo no próximo dia 31, e habilita-te a ganhar um prémio!<br>O último Rally foi só o trailer... desta vez vens viver um episódio de terror!<br><br>Não percas a oportunidade e inscreve-te <a href=\\https://nei.web.ua.pt/links/irally\\ target=\\_blank\\>aqui!</a><br><br>Consulta o Regulamento <a href=\\https://nei.web.ua.pt/links/rally\\ target=\\_blank\\> aqui!</a>	111	2019-10-17 00:00:00	\N	\N	1
12	/news/sessfp.jpg	ACTIVE	1ª Sessão de Dúvidas // Fundamentos de Programação	EVENT	O NEI está a organizar uma sessão de dúvidas que te vai ajudar a preparar de uma melhor forma para os teus exames da unidade curricular de Fundamentos da Porgramação.<br>A sessão vai ter lugar no dia 22 de outubro e ocorrerá no DETI entre as 18-22h.<br>É importante trazeres o teu material de estudo e o teu computador pessoal uma vez que nem todas as salas têm computadores à disposição.<br>As salas ainda não foram atribuídas, serão no dia do evento, está atento ao <a href=\\https://www.facebook.com/events/493810694797695/\\>nosso facebook!</a><br>	111	2019-10-18 00:00:00	\N	\N	1
13	/news/newNEI.png	ACTIVE	PWA NEI	NEWS	Agora o site do NEI já possui uma PWA, basta aceder ao site e carregar na notificação para fazer download da mesma.<br>Fica atento, em breve, terás novidades sobre uma plataforma para a Taça UA! Vais poder acompanhar tudo o que se passa e inclusivé ver os resultados do teu curso em direto.<br><img src=\\https://nei.web.ua.pt/upload/NEI/pwa.jpg\\ height=\\400\\/><img src=\\https://nei.web.ua.pt/upload/NEI/pwa2.jpg\\ height=\\400\\/>	111	2019-10-21 00:00:00	\N	\N	1
14	/news/const_cv.png	ACTIVE	Como construir um bom CV? by Olisipo	EVENT	Dada a competitividade atual do mercado de trabalho, apresentar um bom currículo torna-se cada vez mais indispensável. Desta forma, o NEI e o NEECT organizaram um workshop chamado \\Como construir um bom CV?\\, com o apoio da Olisipo. <br>Informações relevantes:<br><ul> <li> 7 de Novembro pelas 18h no DETI (Sala 102)</li> <li> Participação Gratuita</li> <li> INSCRIÇÕES OBRIGATÓRIAS</li> <li> INSCRIÇÕES LIMITADAS</li> <li> Inscrições <a href=\\https://docs.google.com/forms/d/e/1FAIpQLSf4e3ZnHdp4INHrFgVCaXQv3pvVgkXrWN_U39s94X7Hvd98XA/viewform\\ target=\\_blank\\>aqui</a></li></ul>  <br> Nesta atividade serão abordados diversos tópicos relativos à importância de um bom currículo e quais as formas corretas de o apresentar.	111	2019-11-02 00:00:00	\N	111	1
15	/news/apontamentos.png	ACTIVE	Apontamentos que já não precisas? Há quem precise!	NEWS	Tens apontamentos, resoluções ou qualquer outro material de estudo que já não precisas?Vem promover a inter-ajuda e entrega-os na sala do NEI (132) ou digitaliza-os e envia para nei@aauav.pt.Estarás a contribuir para uma base de dados de apontamentos mais sólida, organizada e completa para o nosso curso!Os alunos de informática agradecem!	94	2020-01-29 00:00:00	\N	\N	1
16	/news/nei_aniv.png	ACTIVE	7º ANIVERSÁRIO DO NEI	EVENT	Foi no dia 25, há 7 anos atrás, que o TEU núcleo foi criado. Na altura chamado de Núcleo de Estudantes de Sistemas de Informação, mudou para o seu nome atual em 2014.Dos marcos do núcleo ao longo da sua história destacam-se o ENEI em 2014, o Think Twice em 2019 e as diversas presenças nas atividades em grande escala da AAUAv.Parabéns a todos os que contribuíram para o NEI que hoje temos!	94	2020-01-29 00:00:00	\N	\N	1
17	/news/delloitte_consultantforaday.png	ACTIVE	Queres ser consultor por um dia? A Deloitte dá-te essa oportunidade	EVENT	A Deloitte Portugal está a organizar o evento “Be a Consultant for a Day | Open House Porto”. Esta iniciativa dá-te acesso a um dia com várias experiências de desenvolvimento de competências e terás ainda a oportunidade de conhecer melhor as áreas de negócio integradas em consultoria tecnológica.O evento irá decorrer no Deloitte Studio do Porto e contará com alunos de várias Universidades da região Norte (Coimbra, Aveiro, Porto e Minho).	94	2020-01-29 00:00:00	\N	\N	1
18	/news/pub_rgm.png	ACTIVE	Primeira RGM Ordinária	EVENT	Convocam-se todos os membros de LEI e MEI para a 1ª RGM ordinária com a seguinte ordem de trabalhos:<br><br>1. Aprovação da ata da RGM anterior;<br>2. Apresentação do Plano de Atividades e Orçamento;<br>3. Aprovação do Plano de Atividades e Orçamento;<br>4. Discução relativa à modalidade do Evento do Aniversário do NEI;<br>5. Colaboradores do NEI;<br>6. Informações relativas à Barraca do Enterro 2020;<br>7. Discussão sobre as Unidades Curriculares do 1º Semestre;<br>8. Outros assuntos.<br><br>Link para o Plano de Atividades e Orçamento (PAO):<br>https://nei.web.ua.pt/upload/documents/PAO/2020/PAO_2020_NEI.pdf<br><br>Na RGM serão discutidos assuntos relativos a TODOS os estudantes de informática.<br>Sendo assim, apelamos à participação de TODOS!	94	2020-02-18 00:00:00	2020-02-18 00:00:00	94	1
19	/news/colaboradores.jpg	ACTIVE	Vem ser nosso Colaborador!	EVENT	És um estudante ativo?<br>Procuras aprender novas competências e desenvolver novas?<br>Gostavas de ajudar o teu núcleo a proporcionar as melhores atividades da Universidade?<br>Se respondeste sim a pelo menos uma destas questões clica <a href=\\https://forms.gle/3y5JZfNvN7rBjFZT8\\ target=\\_blank\\>aqui</a><br>E preenche o formulário!<br>Sendo um colaborador do NEI vais poder desenvolver várias capacidades, sendo que maioria delas não são abordadas nas Unidades Curriculares!<br>Vais fazer amizades e a cima de tudo vais te divertir!<br>Junta-te a nós e ajuda o NEI a desenvolver as melhores atividades possíveis!	94	2020-02-19 00:00:00	\N	\N	1
20	/news/dia-syone.jpg	ACTIVE	Dia da Syone	EVENT	A Syone é uma empresa portuguesa provedora de Open Software Solutions.<br/>Neste dia podes participar num workshop, almoço gratuito e num mini-hackathon com prémios! <i class=\\fa fa-trophy\\ style=\\color: gold\\></i><br/>Garante já a tua presença através do <a href=\\https://forms.gle/62yYsFiiiZXoTiaR8\\ target=\\_blank\\>formulário</a>.<br/>O evento está limitado a 30 pessoas!	94	2020-02-26 00:00:00	\N	\N	1
21	/news/roundtable.jpg	ACTIVE	Round Table - Bolsas de Investigação	EVENT	Gostavas de estudar e de ao mesmo tempo desenvolver trabalho de investigação? E se com isto tiveres acesso a uma bolsa?<br/>Aparece nesta round table com os docentes responsáveis pelas bolsas de investigação e vem esclarecer todas as tuas dúvidas!	94	2020-02-26 00:00:00	2020-03-01 00:00:00	94	1
22	/news/jogos-marco.jpg	ACTIVE	Calendário dos Jogos de março	EVENT	Não percas os jogos do teu curso na Taça UA para o mês de março!<br/>Aparece ao máximo de jogos possível para apoiares o teu curso em todas as modalidades.<br/>Vem encher a bancada e fazer parte da melhor claque da UA! Contamos contigo e o teu magnifico apoio!	94	2020-03-01 00:00:00	\N	\N	1
23	/news/hackathome.png	ACTIVE	HackatHome	EVENT	Tens andado aborrecido nesta quarentena? É contigo em mente que decidimos contornar esta triste situação e organizar um HackatHome!<br/>O HackatHome é uma competição de programação online promovida pelo NEI que consiste na resolução de uma coleção de desafios de programação.<br/>A partir desta quarta feira, e todas as quartas durante as próximas 12 semanas(!), será disponibilizado um desafio, o qual os participantes têm até à quarta-feira seguinte para resolver (1 semana).<br/>Toda a competição assentará na plataforma GitHub Classroom, utilizada para requisitar e submeter os desafios. As pontuações são atribuídas por desafio, e ganha o participante com mais pontos acumulados ao final das 12 semanas!<br/>Não há processo de inscrição, apenas tens de estar atento à divulgação dos links dos desafios nos meios de comunicação do NEI, resolver e submeter através da tua conta GitHub!<br/>Além do prémio do vencedor, será também premiado um participante aleatório! Interessante não? &#129300;<br/>Consulta o <a href=\\https://nei.web.ua.pt/upload/NEI/Regulamento_HackatHome.pdf\\ target=\\_blank\\>regulamento</a>!<br/>E prepara-te para a competição! &#128170;<br/><h2><b>Desafios</b></h2><h4><a href=\\https://bit.ly/3bJBNaA\\ target=\\_blank\\>Desafio 1</a></h4><h4><a href=\\https://bit.ly/2Rnuy03\\ target=\\_blank\\>Desafio 2</a></h4><h4><a href=\\https://bit.ly/2wKmZJW\\ target=\\_blank\\>Desafio 3</a></h4><h4><a href=\\http://tiny.cc/Desafio4\\ target=\\_blank\\>Desafio 4</a></h4><h4><a href=\\http://tiny.cc/DESAFIO5\\ target=\\_blank\\>Desafio 5</a></h4><h4><a href=\\http://tiny.cc/Desafio6\\ target=\\_blank\\>Desafio 6</a></h4><h4><a href=\\http://tiny.cc/Desafio7\\ target=\\_blank\\>Desafio 7</a></h4>	94	2020-03-30 00:00:00	2020-05-13 00:00:00	94	1
24	/news/pleiathome.png	ACTIVE	PLEIATHOME	EVENT	O PL<b style=\\color: #59CD00\\>EI</b>ATHOME é um conjunto de mini-torneios de jogos online que se vão desenrolar ao longo do semestre. As equipas acumulam \\pontos PLEIATHOME\\ ao longo dos mini-torneios, sendo que os vencedores finais ganham prémios!<br/>Organiza a tua equipa e vai participar em mais uma saga AtHome do NEI!Podes consultar o <a href=\\https://nei.web.ua.pt/upload/NEI/Regulamento_PLEIATHOME.pdf\\ target=\\_blank\\>regulamento</a> do evento.<br/><br/><b><big>FIRST TOURNAMENT</big></b><br/>KABOOM!! Chegou o primeiro torneio da competição PL<b style=\\color: #59CD00\\>EI</b>ATHOME, com o jogo Bombtag!<br/>O mini-torneio terá início dia 10 de abril pelas 19h, inscreve-te neste <a href=\\https://bit.ly/3dXrAsU\\ target=\\_blank\\>formulário</a> do Kaboom.<br/>E consulta o <a href=\\https://nei.web.ua.pt/upload/NEI/Regulamento_Kaboom.pdf\\ target=\\_blank\\>regulamento</a> do Kaboom.<br/>Vamos lá!<br/><br/><b><big>SECOND TOURNAMENT</big></b><br/>SpeedTux &#128039;&#128168; Chegou o segundo torneio PL<b style=\\color: #59CD00\\>EI</b>ATHOME, com o clássico SuperTux!<br/>O mini-torneio terá início dia 24 de abril, pelas 19h. Inscreve-te neste <a href=\\https://bit.ly/34ClZE3\\ target=\\_blank\\>formulário</a> até às 12h desse mesmo dia. E consulta o <a href=\\https://nei.web.ua.pt/upload/NEI/Regulamento_SpeedTux.pdf\\ target=\\_blank\\>regulamento</a> do SpeedTux.<br/>Estás à altura? &#128170;<br/><br/><b><big>THIRD TOURNAMENT</big></b><br/>Races à La Kart! Chegou mais um torneio PL<b style=\\color: #59CD00\\>EI</b>ATHOME, com o famoso TrackMania!<br/>O mini-torneio terá início dia 8 de maio (sexta-feira) pelas 19h, inscreve-te no <a href=\\tiny.cc/racesalakart\\ target=\\_blank\\>formulário</a> e consulta o <a href=\\https://nei.web.ua.pt/upload/NEI/Regulamento_Races_a_la_KART.pdf\\ target=\\_blank\\>regulamento</a>.<br/>Descobre se és o mais rápido! &#127988;	94	2020-04-06 00:00:00	2020-05-04 00:00:00	94	1
25	/news/nei_lol.png	ACTIVE	Torneio Nacional de LoL	EVENT	Como a vida não é só trabalho, vem divertir-te a jogar e representar a Universidade de Aveiro em simultâneo! O NEEEC-FEUP está a organizar um torneio de League of Legends inter-universidades a nível nacional, e a UA está apta para participar.<br/>Existirá uma ronda de qualificação em Aveiro para determinar as 2 equipas que participam nacionalmente. O torneio é de inscrição gratuita e garante prémios para as equipas que conquistem o 1º e 2º lugar!<br/>Forma equipa e mostra o que vales!<br/><a href=\\http://tiny.cc/torneioLOL\\ target=\\_blank\\>Inscreve-te</a>!	94	2020-05-13 00:00:00	\N	\N	1
26	/news/202122/96.jpg	ACTIVE	Roots Beach Club	EVENT	<p>A primeira semana de aulas vai terminar em grande!</p><p>Na sexta-feira vem ao Roots Beach Club para uma beach party incrível.</p><p>A pulseira do evento garante o transporte desde Aveiro até à Praia da Barra, um teste antigénio à covid e a entrada no bar com uma bebida incluída!</p><p>Reserva a tua pulseira terça feira das 16h às 19h na sala 4.1.32.</p>	83	2021-10-10 00:00:00	\N	\N	1
\.


--
-- Data for Name: subject; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.subject (code, course_id, curricular_year, name, short, discontinued, optional) FROM stdin;
2373	\N	3	Empreendedorismo	E	0	1
2450	\N	3	Gestão de Empresas	GE	0	0
9270	\N	3	Arquitectura e Gestão de Redes	AGR	0	1
12271	\N	3	Aspetos Profissionais e Sociais da Engenharia Informática	APSEI	0	0
12830	\N	3	Complementos Sobre Linguagens de Programação	CSLP	0	1
12832	\N	3	Tópicos de Aprendizagem Automática	TAA	0	0
14817	\N	1	Modelação de Sistemas Físicos	MSF	0	0
40337	\N	2	Métodos Probabilísticos para Engenharia Informática	MPEI	0	0
40379	\N	1	Fundamentos de Programação	FP	0	0
40380	\N	1	Introdução às Tecnologias Web	ITW	0	0
40381	\N	2	Sistemas Operativos	SO	0	0
40382	\N	2	Computação Distribuída	CD	0	0
40383	\N	2	Padrões e Desenho de Software	PDS	0	0
40384	\N	3	Introdução à Engenharia de Software	IES	0	0
40385	\N	3	Complementos de Bases de Dados	CBD	0	0
40431	\N	1	Modelação e Análise de Sistemas	MAS	0	0
40432	\N	2	Sistemas Multimédia	SM	0	0
40433	\N	2	Redes e Serviços	RS	0	0
40436	\N	1	Programação Orientada a Objetos	POO	0	0
40437	\N	2	Algoritmos e Estruturas de Dados	AED	0	0
40551	\N	3	Tecnologias e Programação Web	TPW	0	0
40751	\N	4	Algoritmos Avançados	AA	0	0
40752	\N	4	Teoria Algorítmica da Informação	TAI	0	0
40753	\N	4	Computação em Larga Escala	CLE	0	0
40756	\N	4	Gestão de Infraestruturas de Computação	GIC	0	0
40757	\N	4	Arquiteturas de Software	AS	0	0
40846	\N	3	Inteligência Artificial	IA	0	0
41469	\N	2	Compiladores	C	0	0
41549	\N	2	Interação Humano-Computador	IHC	0	0
41791	\N	1	Elementos de Fisíca	EF	1	0
42502	\N	1	Introdução à Arquitetura de Computadores	IAC	0	0
42532	\N	2	Bases de Dados	BD	0	0
42573	\N	3	Segurança Informática e Nas Organizações	SIO	0	0
42709	\N	1	Álgebra Linear e Geometria Analítica	ALGA	0	0
42728	\N	1	Cálculo I	C1	0	0
42729	\N	1	Cálculo II	C2	0	0
44156	\N	4	Visualização de Informação	VI	0	0
44130	\N	4	Web Semântica	WS	0	0
45424	\N	3	Introdução à Computação Móvel	ICM	0	0
45426	\N	3	Teste e Qualidade de Software	TQS	0	0
45587	\N	4	Exploração de Dados	ED	0	0
47166	\N	1	Matemática Discreta	MD	0	0
\.


--
-- Data for Name: teacher; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.teacher (id, name, personal_page) FROM stdin;
1	José Nuno Panelas Nunes Lau	https://www.ua.pt/pt/p/10312826
2	Diogo Nuno Pereira Gomes	https://www.ua.pt/pt/p/10331537
3	João Paulo Silva Barraca	https://www.ua.pt/pt/p/10333322
4	Carlos Alberto da Costa Bastos	https://www.ua.pt/pt/p/10312427
5	Paulo Jorge dos Santos Gonçalves Ferreira	https://www.ua.pt/pt/p/10308388
6	Pedro Miguel Ribeiro Lavrador	https://www.ua.pt/pt/p/16606771
7	Carlos Manuel Azevedo Costa	https://www.ua.pt/pt/p/10322010
8	Joaquim Manuel Henriques de Sousa Pinto	https://www.ua.pt/pt/p/10312245
9	Maria Beatriz Alves de Sousa Santos	https://www.ua.pt/pt/p/10306666
10	Miguel Augusto Mendes Oliveira e Silva	https://www.ua.pt/pt/p/10313337
11	Tomás António Mendes Oliveira e Silva	https://www.ua.pt/pt/p/10309907
12	José Luis Guimarães Oliveira	https://www.ua.pt/pt/p/10309676
13	Ilídio Fernando de Castro Oliveira	https://www.ua.pt/pt/p/10318398
14	Telmo Reis Cunha	https://www.ua.pt/pt/p/10322185
15	José Manuel Neto Vieira	https://www.ua.pt/pt/p/10311461
16	António Manuel Duarte Nogueira	https://www.ua.pt/pt/p/10317117
17	Joaquim João Estrela Ribeiro Silvestre Madeira	https://www.ua.pt/en/p/10320092
18	Vera Ivanovna Kharlamova	https://www.ua.pt/pt/p/10317978
19	Isabel Alexandra Vieira Brás	https://www.ua.pt/pt/p/10310747
20	Paula Cristina Roque da Silva Rama	https://www.ua.pt/pt/p/10312567
21	António Manuel Rosa Pereira Caetano	https://www.ua.pt/pt/p/10312455
22	José Alexandre da Rocha Almeida	https://www.ua.pt/pt/p/10316585
23	Maria Raquel Rocha Pinto	https://www.ua.pt/pt/p/10312973
24	Mário Fernando dos Santos Ferreira	https://www.ua.pt/pt/p/10308549
25	Helder Troca Zagalo	https://www.ua.pt/pt/p/10316375
26	Ana Maria Perfeito Tomé	https://www.ua.pt/pt/p/10307429
27	João Manuel de Oliveira e Silva Rodrigues	https://www.ua.pt/pt/p/10314156
28	António Joaquim da Silva Teixeira	https://www.ua.pt/pt/p/10315017
29	Vitor José Babau Torres	https://www.ua.pt/pt/p/10307149
30	Luís Filipe de Seabra Lopes	https://www.ua.pt/pt/p/10314261
31	António José Ribeiro Neves	https://www.ua.pt/pt/p/16606785
32	Maria Elisa Carrancho Fernandes	https://www.ua.pt/pt/p/10321317
34	Cristina Isabel Assis de Morais Miguéns	https://www.ua.pt/pt/p/10333350
40	Pétia Georgieva Georgieva	https://www.ua.pt/pt/p/10321408
\.


--
-- Data for Name: note; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.note (id, author_id, subject_id, teacher_id, name, location, year, summary, tests, bibliography, slides, exercises, projects, notebook, created_at, size) FROM stdin;
1	\N	40337	5	MPEI Exemplo Teste 2014	/notes/segundo_ano/primeiro_semestre/mpei/MP_Exemplo_Teste.pdf	2014	0	1	0	0	0	0	0	2021-06-14 19:17:30	1
2	101	40337	4	Diversos - 2017/2018 (zip)	/notes/segundo_ano/primeiro_semestre/mpei/RafaelDireito_2017_2018_MPEI.zip	2017	1	0	1	1	1	0	0	2021-06-14 19:17:30	35
3	19	40337	5	Resumos Teóricos (zip)	/notes/segundo_ano/primeiro_semestre/mpei/Resumos_Teoricas.zip	2014	1	0	0	0	0	0	0	2021-06-14 19:17:30	8
4	49	40379	27	Resumos FP 2018/2019 (zip)	/notes/primeiro_ano/primeiro_semestre/fp/Goncalo_FP.zip	2018	1	1	0	0	1	0	0	2021-06-14 19:17:30	30
5	101	40379	\N	Material FP 2016/2017 (zip)	/notes/primeiro_ano/primeiro_semestre/fp/RafaelDireito_FP_16_17.zip	2016	1	1	0	0	1	0	0	2021-06-14 19:17:30	14
6	\N	40379	\N	Resoluções 18/19	/notes/primeiro_ano/primeiro_semestre/fp/resolucoes18_19.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	1
7	\N	40380	8	Apontamentos Globais	/notes/primeiro_ano/primeiro_semestre/itw/apontamentos001.pdf	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	3
8	\N	40381	\N	Questões de SO (zip)	/notes/segundo_ano/primeiro_semestre/so/Questões.zip	2015	0	0	0	0	1	0	0	2021-06-14 19:17:30	1
9	101	40381	1	Diversos - 2017/2018 (zip)	/notes/segundo_ano/primeiro_semestre/so/RafaelDireito_2017_2018_SO.zip	2017	1	0	0	1	1	0	0	2021-06-14 19:17:30	35
10	66	40383	12	Apontamentos Diversos (zip)	/notes/segundo_ano/segundo_semestre/pds/JoaoAlegria_PDS.zip	2015	1	0	0	0	1	0	0	2021-06-14 19:17:30	6
11	66	40383	12	Resumos de 2015/2016	/notes/segundo_ano/segundo_semestre/pds/pds_apontamentos_001.pdf	2015	1	0	0	0	0	0	0	2021-06-14 19:17:30	4
12	\N	40383	\N	Apontamentos genéricos I	/notes/segundo_ano/segundo_semestre/pds/pds_apontamentos_002.pdf	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	1
13	\N	40383	\N	Apontamentos genéricos II	/notes/segundo_ano/segundo_semestre/pds/pds_apontamentos_003.pdf	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	1
14	54	40385	12	Diversos - CBD Prof. JLO (zip)	/notes/terceiro_ano/primeiro_semestre/cbd/InesCorreia_CBD(CC_JLO).zip	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	2
15	10	40431	13	MAS 2014/2015 (zip)	/notes/primeiro_ano/segundo_semestre/mas/BarbaraJael_14_15_MAS.zip	2014	1	0	0	0	0	0	0	2021-06-14 19:17:30	14
16	40	40431	13	Preparação para Exame Final de MAS	/notes/primeiro_ano/segundo_semestre/mas/Duarte_MAS.pdf	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	1
17	101	40431	13	MAS 2016/2017 (zip)	/notes/primeiro_ano/segundo_semestre/mas/RafaelDireito_2016_2017_MAS.zip	2016	1	0	1	1	0	0	0	2021-06-14 19:17:30	19
18	15	40431	13	Resumos_MAS	/notes/primeiro_ano/segundo_semestre/mas/Resumos_MAS_Carina.zip	2017	1	0	0	0	0	0	0	2021-06-14 19:17:30	8
19	\N	40432	\N	Resolução das fichas (zip)	/notes/segundo_ano/primeiro_semestre/smu/Resoluçao_das_fichas.zip	\N	0	0	0	0	1	0	0	2021-06-14 19:17:30	27
20	\N	40432	\N	Resumos (zip)	/notes/segundo_ano/primeiro_semestre/smu/Resumo.zip	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	116
21	10	40432	26	Resumos de 2013/2014	/notes/segundo_ano/primeiro_semestre/smu/smu_apontamentos_001.pdf	2013	1	0	0	0	1	0	0	2021-06-14 19:17:30	11
22	19	40432	15	Resumos de 2016/2017	/notes/segundo_ano/primeiro_semestre/smu/smu_apontamentos_002.pdf	2016	1	1	0	0	1	0	0	2021-06-14 19:17:30	2
23	111	40432	15	Resumos de 2017/2018	/notes/segundo_ano/primeiro_semestre/smu/smu_apontamentos_003.pdf	2017	1	0	0	0	1	0	0	2021-06-14 19:17:30	7
24	\N	40432	\N	Resumos 2018/19	/notes/segundo_ano/primeiro_semestre/smu/SMU_Resumos.pdf	\N	1	0	0	0	1	0	0	2021-06-14 19:17:30	4
25	\N	40433	\N	Resumos (zip)	/notes/segundo_ano/primeiro_semestre/rs/Resumo.zip	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	24
26	10	40433	16	Caderno	/notes/segundo_ano/primeiro_semestre/rs/rs_apontamentos_001.pdf	2014	1	0	0	0	1	0	1	2021-06-14 19:17:30	6
27	15	40436	31	Resumos_POO	/notes/primeiro_ano/segundo_semestre/poo/Carina_POO_Resumos.zip	2017	1	0	0	0	1	0	0	2021-06-14 19:17:30	6
28	49	40436	28	Resumos POO 2018/2019 (zip)	/notes/primeiro_ano/segundo_semestre/poo/Goncalo_POO.zip	2018	1	1	0	0	1	0	0	2021-06-14 19:17:30	4
29	101	40436	\N	Diversos - Prática e Teórica (zip)	/notes/primeiro_ano/segundo_semestre/poo/RafaelDireito_2016_2017_POO.zip	2016	1	1	0	1	0	0	0	2021-06-14 19:17:30	43
30	\N	40436	\N	Resumos Teóricos (zip)	/notes/primeiro_ano/segundo_semestre/poo/Resumos.zip	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	22
31	19	40437	17	Resumos de 2016/2017	/notes/segundo_ano/primeiro_semestre/aed/aed_apontamentos_001.pdf	2016	1	1	0	0	0	0	0	2021-06-14 19:17:30	5
32	\N	40437	\N	Bibliografia (zip)	/notes/segundo_ano/primeiro_semestre/aed/bibliografia.zip	\N	0	0	1	0	0	0	0	2021-06-14 19:17:30	33
33	66	40751	\N	Resumos 2016/2017	/notes/mestrado/aa/aa_apontamentos_001.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	1
34	66	40752	\N	Exames 2017/2018	/notes/mestrado/tai/tai_apontamentos_001.pdf	2017	0	1	0	0	0	0	0	2021-06-14 19:17:30	1
35	66	40752	\N	Teste Modelo 2016/2017	/notes/mestrado/tai/tai_apontamentos_002.pdf	2016	0	1	0	0	0	0	0	2021-06-14 19:17:30	3
36	66	40752	\N	Ficha de Exercícios 1 - 2016/2017	/notes/mestrado/tai/tai_apontamentos_003.pdf	2016	0	0	0	0	1	0	0	2021-06-14 19:17:30	5
37	66	40752	\N	Ficha de Exercícios 2 - 2016/2017	/notes/mestrado/tai/tai_apontamentos_004.pdf	2016	0	0	0	0	1	0	0	2021-06-14 19:17:30	3
38	66	40753	\N	Resumos 2016/2017	/notes/mestrado/cle/cle_apontamentos_001.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	12
39	66	40756	\N	Resumos 2016/2017	/notes/mestrado/gic/gic_apontamentos_001.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	12
40	19	40846	30	Resumos 2017/2018	/notes/terceiro_ano/primeiro_semestre/ia/ia_apontamentos_002.pdf	2017	1	1	0	0	1	0	0	2021-06-14 19:17:30	6
41	\N	41469	10	Aulas Teóricas (zip)	/notes/segundo_ano/segundo_semestre/c/Aulas_Teóricas.zip	2015	0	0	0	1	0	0	0	2021-06-14 19:17:30	6
42	\N	41469	\N	Guião de preparacao para o teste prático (zip)	/notes/segundo_ano/segundo_semestre/c/Guião_de_preparacao_para_o_teste_pratico.zip	\N	0	1	0	0	0	0	0	2021-06-14 19:17:30	1
43	\N	41549	\N	Apontamentos Diversos (zip)	/notes/segundo_ano/segundo_semestre/ihc/Apontamentos.zip	\N	1	0	0	1	0	0	0	2021-06-14 19:17:30	16
44	66	41549	9	Avaliação Heurística	/notes/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_001.pdf	2014	1	0	0	0	0	0	0	2021-06-14 19:17:30	1
45	10	41549	9	Resumos de 2014/2015	/notes/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_002.pdf	2014	1	0	0	0	0	0	0	2021-06-14 19:17:30	3
46	\N	41549	9	Resolução de fichas (zip)	/notes/segundo_ano/segundo_semestre/ihc/Resolução_de_fichas.zip	\N	0	0	0	0	1	0	0	2021-06-14 19:17:30	14
47	10	41791	\N	Apontamentos EF (zip)	/notes/primeiro_ano/primeiro_semestre/ef/BarbaraJael_EF.zip	2014	1	0	0	0	0	0	0	2021-06-14 19:17:30	4
48	101	41791	24	Exercícios 2017/2018	/notes/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_001.pdf	2017	0	1	0	0	0	0	0	2021-06-14 19:17:30	2
49	101	41791	\N	Exercícios 2016/17	/notes/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_002.pdf	2016	0	0	0	0	1	0	0	2021-06-14 19:17:30	7
50	49	41791	29	Resumos EF 2018/2019 (zip)	/notes/primeiro_ano/primeiro_semestre/ef/Goncalo_EF.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	5
51	96	41791	29	Exercícios 2018/19	/notes/primeiro_ano/primeiro_semestre/ef/Pedro_Oliveira_2018_2019.zip	2018	0	1	0	0	1	0	0	2021-06-14 19:17:30	28
52	96	42502	6	Apontamentos e Resoluções (zip)	/notes/primeiro_ano/segundo_semestre/iac/PedroOliveira.zip	2017	0	1	0	0	1	0	0	2021-06-14 19:17:30	23
53	19	42532	7	Caderno - 2016/2017	/notes/segundo_ano/segundo_semestre/bd/bd_apontamentos_001.pdf	2016	1	0	0	0	1	0	1	2021-06-14 19:17:30	2
54	66	42532	7	Resumos - 2014/2015	/notes/segundo_ano/segundo_semestre/bd/bd_apontamentos_002.pdf	2014	1	0	0	0	0	0	0	2021-06-14 19:17:30	1
55	\N	42532	7	Resumos globais	/notes/segundo_ano/segundo_semestre/bd/BD_Resumos.pdf	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	8
56	\N	42532	7	Slides das Aulas Teóricas (zip)	/notes/segundo_ano/segundo_semestre/bd/Slides_Teoricas.zip	2014	0	0	0	1	0	0	0	2021-06-14 19:17:30	21
57	\N	42573	\N	Outros Resumos (zip)	/notes/terceiro_ano/primeiro_semestre/sio/Outros_Resumos.zip	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	3
58	\N	42573	\N	Resumo geral de segurança I	/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_001.pdf	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	2
59	\N	42573	\N	Resumo geral de segurança II	/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_002.pdf	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	1
60	10	42573	3	Resumos de 2015/2016	/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_003.pdf	2015	1	0	0	0	0	0	0	2021-06-14 19:17:30	8
61	\N	42573	\N	Resumo geral de segurança III	/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_004.pdf	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	1
62	\N	42573	\N	Apontamentos genéricos	/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_005.pdf	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	1
63	19	42709	23	Resumos de ALGA (zip)	/notes/primeiro_ano/primeiro_semestre/alga/Carolina_Albuquerque_ALGA.zip	2015	1	0	0	0	1	0	0	2021-06-14 19:17:30	59
64	36	42709	23	ALGA 2017/2018 (zip)	/notes/primeiro_ano/primeiro_semestre/alga/DiogoSilva_17_18_ALGA.zip	2017	0	0	0	0	0	0	0	2021-06-14 19:17:30	21
65	49	42709	19	Resumos ALGA 2018/2019 (zip)	/notes/primeiro_ano/primeiro_semestre/alga/Goncalo_ALGA.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	41
66	94	42728	21	Resumos 2016/2017	/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_001.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	16
67	111	42728	21	Resumos 2016/2017	/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_002.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	5
346	104	41469	10	Práticas e projeto C	https://github.com/Rui-FMF/C	2019	0	0	0	0	1	1	0	2021-11-15 00:00:00	\N
68	101	42728	21	Teste Primitivas 2016/2017	/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_003.pdf	2016	0	1	0	0	0	0	0	2021-06-14 19:17:30	2
69	101	42728	21	Exercícios 2016/2017	/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_004.pdf	2016	0	0	0	0	1	0	0	2021-06-14 19:17:30	5
70	101	42728	21	Resumos 2016/2017	/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_005.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	11
71	101	42728	21	Fichas 2016/2017	/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_006.pdf	2016	0	0	0	0	1	0	0	2021-06-14 19:17:30	22
72	36	42728	21	CI 2017/2018 (zip)	/notes/primeiro_ano/primeiro_semestre/c1/DiogoSilva_17_18_C1.zip	2017	1	0	0	0	0	0	0	2021-06-14 19:17:30	2
73	49	42728	18	Resumos Cálculo I 2018/2019 (zip)	/notes/primeiro_ano/primeiro_semestre/c1/Goncalo_C1.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	24
74	94	42729	22	Caderno de 2016/2017	/notes/primeiro_ano/segundo_semestre/c2/calculoii_apontamentos_003.pdf	2016	0	0	0	0	0	0	1	2021-06-14 19:17:30	18
75	49	42729	19	Resumos Cálculo II 2018/2019 (zip)	/notes/primeiro_ano/segundo_semestre/c2/Goncalo_C2.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	21
76	66	44156	9	Resumos 2016/2017	/notes/mestrado/vi/vi_apontamentos_001.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	4
77	66	44130	25	Resumos por capítulo (zip)	/notes/mestrado/ws/JoaoAlegria_ResumosPorCapítulo.zip	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	8
78	66	44130	25	Resumos 2016/2017	/notes/mestrado/ws/web_semantica_apontamentos_001.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	9
79	54	45424	\N	Apontamentos Diversos	/notes/terceiro_ano/primeiro_semestre/icm/Inês_Correia_ICM.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	2
80	54	45426	13	Apontamentos Diversos	/notes/terceiro_ano/segundo_semestre/tqs/Inês_Correia_TQS.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	14
81	\N	45426	13	Resumos (zip)	/notes/terceiro_ano/segundo_semestre/tqs/resumos.zip	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	22
82	66	45426	13	Resumos 2015/2016	/notes/terceiro_ano/segundo_semestre/tqs/tqs_apontamentos_002.pdf	2015	1	0	0	0	0	0	0	2021-06-14 19:17:30	3
83	66	45587	26	Resumos 2017/2018 - I	/notes/mestrado/ed/ed_dm_apontamentos_001.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	36
84	66	45587	26	Resumos 2017/2018 - II	/notes/mestrado/ed/ed_dm_apontamentos_002.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	48
85	49	47166	20	Resumos MD 2018/2019 (zip)	/notes/primeiro_ano/segundo_semestre/md/Goncalo_MD.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	27
86	15	47166	\N	Resumos 2017/2018	/notes/primeiro_ano/segundo_semestre/md/MD_Capitulo5.pdf	2017	1	0	0	0	0	0	0	2021-06-14 19:17:30	4
87	101	47166	\N	RafaelDireito_2016_2017_MD.zip	/notes/primeiro_ano/segundo_semestre/mdmorphine/RafaelDireito_2016_2017_MD.zip	2016	0	0	0	0	1	0	0	2021-06-14 19:17:30	24
88	101	47166	\N	RafaelDireito_MD_16_17_Apontamentos (zip)	/notes/primeiro_ano/segundo_semestre/md/RafaelDireito_MD_16_17_Apontamentos.zip	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	4
89	36	40337	4	DS_MPEI_18_19_Testes (zip)	/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Testes.zip	2018	0	1	0	0	0	0	0	2021-06-14 19:17:30	23
115	36	40383	12	DS_PDS_18_19_SlidesTeoricos (zip)	/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_SlidesTeoricos.zip	2018	0	0	0	1	0	0	0	2021-06-14 19:17:30	81
90	36	40337	4	DS_MPEI_18_19_SlidesTeoricos (zip)	/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_SlidesTeoricos.zip	2018	0	0	0	1	0	0	0	2021-06-14 19:17:30	27
91	36	40337	4	DS_MPEI_18_19_Resumos (zip)	/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Resumos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	209
92	36	40337	4	DS_MPEI_18_19_Projeto (zip)	/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Projeto.zip	2018	0	0	0	0	0	1	0	2021-06-14 19:17:30	16
93	36	40337	4	DS_MPEI_18_19_Praticas (zip)	/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Praticas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	9
94	36	40337	4	DS_MPEI_18_19_Livros (zip)	/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Livros.zip	2018	0	0	1	0	0	0	0	2021-06-14 19:17:30	6
95	36	40337	4	DS_MPEI_18_19_Exercicios (zip)	/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Exercicios.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	37
96	49	40380	8	Goncalo_ITW_18_19_Testes (zip)	/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Testes.zip	2018	0	1	0	0	0	0	0	2021-06-14 19:17:30	1
97	49	40380	8	Goncalo_ITW_18_19_Resumos (zip)	/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Resumos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	12
98	49	40380	8	Goncalo_ITW_18_19_Projeto (zip)	/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Projeto.zip	2018	0	0	0	0	0	1	0	2021-06-14 19:17:30	33
99	49	40380	8	Goncalo_ITW_18_19_Praticas (zip)	/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Praticas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	30
100	101	40380	8	RafaelDireito_ITW_18_19_Testes (zip)	/notes/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Testes.zip	2016	0	1	0	0	0	0	0	2021-06-14 19:17:30	9
101	101	40380	8	RafaelDireito_ITW_18_19_Slides (zip)	/notes/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Slides.zip	2016	0	0	0	1	0	0	0	2021-06-14 19:17:30	19
116	36	40383	12	DS_PDS_18_19_Resumos (zip)	/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Resumos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	185
118	\N	40431	\N	MAS_18_19_Bibliografia (zip)	/notes/primeiro_ano/segundo_semestre/mas/MAS_18_19_Bibliografia.zip	\N	0	0	1	0	0	0	0	2021-06-14 19:17:30	6
102	101	40380	8	RafaelDireito_ITW_18_19_Praticas (zip)	/notes/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Praticas.zip	2016	0	0	0	0	1	0	0	2021-06-14 19:17:30	18
103	36	40381	1	DS_SO_18_19_Testes (zip)	/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Testes.zip	2018	0	1	0	0	0	0	0	2021-06-14 19:17:30	46
104	36	40381	1	DS_SO_18_19_SlidesTeoricos (zip)	/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_SlidesTeoricos.zip	2018	0	0	0	1	0	0	0	2021-06-14 19:17:30	11
105	36	40381	1	DS_SO_18_19_ResumosTeoricos (zip)	/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_ResumosTeoricos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	157
106	36	40381	1	DS_SO_18_19_ResumosPraticos (zip)	/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_ResumosPraticos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	122
107	36	40381	1	DS_SO_18_19_Praticas (zip)	/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Praticas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	5
108	36	40381	1	DS_SO_18_19_Fichas (zip)	/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Fichas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	51
109	\N	40382	\N	CD_18_19_Livros (zip)	/notes/segundo_ano/segundo_semestre/cd/CD_18_19_Livros.zip	\N	0	0	1	0	0	0	0	2021-06-14 19:17:30	19
110	36	40382	2	DS_CD_18_19_SlidesTeoricos (zip)	/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_SlidesTeoricos.zip	2018	0	0	0	1	0	0	0	2021-06-14 19:17:30	32
111	36	40382	2	DS_CD_18_19_Resumos (zip)	/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Resumos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	309
112	36	40382	2	DS_CD_18_19_Projetos (zip)	/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Projetos.zip	2018	0	0	0	0	0	1	0	2021-06-14 19:17:30	1
113	36	40382	2	DS_CD_18_19_Praticas (zip)	/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Praticas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	3
114	36	40383	12	DS_PDS_18_19_Testes (zip)	/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Testes.zip	2018	0	1	0	0	0	0	0	2021-06-14 19:17:30	1
117	36	40383	12	DS_PDS_18_19_Praticas (zip)	/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Praticas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	6
119	\N	40431	13	MAS_18_19_Topicos_Estudo_Exame (zip)	/notes/primeiro_ano/segundo_semestre/mas/MAS_18_19_Topicos_Estudo_Exame.zip	2018	0	1	0	0	0	0	0	2021-06-14 19:17:30	1
120	49	40431	13	Goncalo_MAS_18_19_Resumos (zip)	/notes/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Resumos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	10
121	49	40431	13	Goncalo_MAS_18_19_Projeto (zip)	/notes/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Projeto.zip	2018	0	0	0	0	0	1	0	2021-06-14 19:17:30	22
122	49	40431	13	Goncalo_MAS_18_19_Praticas (zip)	/notes/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Praticas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	46
123	101	40432	15	RafaelDireito_SMU_17_18_Praticas (zip)	/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Praticas.zip	2017	0	0	0	0	1	0	0	2021-06-14 19:17:30	40
124	101	40432	15	RafaelDireito_SMU_17_18_TP (zip)	/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_TP.zip	2017	0	0	0	1	0	0	0	2021-06-14 19:17:30	68
125	101	40432	15	RafaelDireito_SMU_17_18_Prep2Test (zip)	/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Prep2Teste.zip	2017	0	1	0	0	0	0	0	2021-06-14 19:17:30	3
126	101	40432	15	RafaelDireito_SMU_17_18_Bibliografia (zip)	/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Bibliografia.zip	2017	0	0	1	0	0	0	0	2021-06-14 19:17:30	54
127	36	40432	14	DS_SMU_18_19_Fichas (zip)	/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Fichas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	113
128	36	40432	14	DS_SMU_18_19_Livros (zip)	/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Livros.zip	2018	0	0	1	0	0	0	0	2021-06-14 19:17:30	54
129	36	40432	14	DS_SMU_18_19_SlidesTeoricos (zip)	/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_SlidesTeoricos.zip	2018	0	0	0	1	0	0	0	2021-06-14 19:17:30	30
130	36	40432	14	DS_SMU_18_19_Praticas (zip)	/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Praticas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	26
131	36	40432	14	DS_SMU_18_19_Resumos (zip)	/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Resumos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	181
132	36	40432	14	DS_SMU_18_19_Testes (zip)	/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Testes.zip	2018	0	1	0	0	0	0	0	2021-06-14 19:17:30	60
133	36	40433	16	DS_RS_18_19_Testes (zip)	/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Testes.zip	2018	0	1	0	0	0	0	0	2021-06-14 19:17:30	130
134	36	40433	16	DS_RS_18_19_Praticas (zip)	/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Praticas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	2
135	36	40433	16	DS_RS_18_19_SlidesTeoricos (zip)	/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_SlidesTeoricos.zip	2018	0	0	0	1	0	0	0	2021-06-14 19:17:30	10
136	36	40433	16	DS_RS_18_19_Resumos (zip)	/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Resumos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	1
137	36	40437	11	DS_AED_18_19_Resumos (zip)	/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Resumos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	271
138	36	40437	11	DS_AED_18_19_Livros (zip)	/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Livros.zip	2018	0	0	1	0	0	0	0	2021-06-14 19:17:30	20
325	104	40437	11	Projetos AED	https://github.com/Rui-FMF/AED	2019	0	0	0	0	0	1	0	2021-11-15 00:00:00	\N
328	104	40381	1	Projetos SO	https://github.com/Rui-FMF/SO	2019	0	0	0	0	0	1	0	2021-11-15 00:00:00	\N
139	36	40437	11	DS_AED_18_19_Testes (zip)	/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Testes.zip	2018	0	1	0	0	0	0	0	2021-06-14 19:17:30	94
140	36	40437	11	DS_AED_18_19_Praticas (zip)	/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Praticas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	20
141	36	40437	11	DS_AED_18_19_SlidesTeoricos (zip)	/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_SlidesTeoricos.zip	2018	0	0	0	1	0	0	0	2021-06-14 19:17:30	2
142	36	40437	11	DS_AED_18_19_Fichas (zip)	/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Fichas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	16
143	101	40437	31	RafaelDireito_AED_17_18_Praticas (zip)	/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Praticas.zip	2017	0	0	0	0	1	0	0	2021-06-14 19:17:30	1
144	101	40437	31	RafaelDireito_AED_17_18_Testes (zip)	/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Testes.zip	2017	0	1	0	0	0	0	0	2021-06-14 19:17:30	1
145	101	40437	31	RafaelDireito_AED_17_18_Books (zip)	/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Praticas.zip	2017	0	0	1	0	0	0	0	2021-06-14 19:17:30	\N
146	101	40437	31	RafaelDireito_AED_17_18_LearningC (zip)	/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_LearningC.zip	2017	0	0	0	0	1	0	0	2021-06-14 19:17:30	1
147	101	40437	31	RafaelDireito_AED_17_18_AED (pdf)	/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_AED.pdf	2017	0	0	0	1	0	0	0	2021-06-14 19:17:30	2
148	36	41469	10	DS_Compiladores_18_19_Praticas (zip)	/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Praticas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	1
149	36	41469	10	DS_Compiladores_18_19_Fichas (zip)	/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Fichas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	42
150	36	41469	10	DS_Compiladores_18_19_Testes (zip)	/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Testes.zip	2018	0	1	0	0	0	0	0	2021-06-14 19:17:30	33
151	36	41469	10	DS_Compiladores_18_19_Resumos (zip)	/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Resumos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	242
152	36	41469	10	DS_Compiladores_18_19_SlidesTeoricos (zip)	/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_SlidesTeoricos.zip	2018	0	0	0	1	0	0	0	2021-06-14 19:17:30	4
153	36	41549	9	DS_IHC_18_19_SlidesTeoricos (zip)	/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_SlidesTeoricos.zip	2018	0	0	0	1	0	0	0	2021-06-14 19:17:30	\N
154	36	41549	9	DS_IHC_18_19_Fichas (zip)	/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_Fichas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	51
155	36	41549	9	DS_IHC_18_19_Projetos (zip)	/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_Projetos.zip	2018	0	0	0	0	0	1	0	2021-06-14 19:17:30	90
156	36	41549	9	DS_IHC_18_19_Testes (zip)	/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_SlidesTeoricos.zip	2018	0	1	0	0	0	0	0	2021-06-14 19:17:30	\N
157	\N	40846	\N	Resumos (zip)	/notes/terceiro_ano/primeiro_semestre/ia/resumo.zip	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	1
158	36	41791	24	DS_EF_17_18_Resumos (zip)	/notes/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Resumos.zip	2017	1	0	0	0	0	0	0	2021-06-14 19:17:30	4
159	36	41791	24	DS_EF_17_18_Exercicios (zip)	/notes/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Exercicios.zip	2017	0	0	0	0	1	0	0	2021-06-14 19:17:30	3
160	36	41791	24	DS_EF_17_18_Exames (zip)	/notes/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Exames.zip	2017	0	1	0	0	0	0	0	2021-06-14 19:17:30	2
161	\N	42502	6	Exames (zip)	/notes/primeiro_ano/segundo_semestre/iac/exames.zip	\N	0	1	0	0	0	0	0	2021-06-14 19:17:30	1
162	49	42502	6	Goncalo_IAC_18_19_Praticas (zip)	/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Praticas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	44
163	49	42502	6	Goncalo_IAC_18_19_Resumos (zip)	/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Resumos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	17
164	49	42502	6	Goncalo_IAC_18_19_Apontamentos (zip)	/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Apontamentos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	3
165	49	42502	6	Goncalo_IAC_18_19_Bibliografia (zip)	/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Bibliografia.zip	2018	0	0	1	0	0	0	0	2021-06-14 19:17:30	18
166	49	42502	6	Goncalo_IAC_18_19_Testes (zip)	/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Testes.zip	2018	0	1	0	0	0	0	0	2021-06-14 19:17:30	2
167	101	42502	6	RafaelDireito_IAC_16_17_Testes (zip)	/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Testes.zip	2016	0	1	0	0	0	0	0	2021-06-14 19:17:30	3
168	101	42502	6	RafaelDireito_IAC_16_17_Teorica (zip)	/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Teorica.zip	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	14
169	101	42502	6	RafaelDireito_IAC_16_17_FolhasPraticas (zip)	/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_FolhasPraticas.zip	2016	0	0	0	0	1	0	0	2021-06-14 19:17:30	13
170	101	42502	6	RafaelDireito_IAC_16_17_ExerciciosResolvidos (zip)	/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_ExerciciosResolvidos.zip	2016	0	0	0	0	1	0	0	2021-06-14 19:17:30	1
171	101	42502	6	RafaelDireito_IAC_16_17_Resumos (zip)	/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Resumos.zip	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	10
172	101	42502	6	RafaelDireito_IAC_16_17_DossiePedagogicov2 (zip)	/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_DossiePedagogicov2.zip	2016	0	0	0	1	0	0	0	2021-06-14 19:17:30	1
173	36	42532	7	DS_BD_18_19_SlidesTeoricos (zip)	/notes/segundo_ano/segundo_semestre/bd/DS_BD_18_19_SlidesTeoricos.zip	2018	0	0	0	1	0	0	0	2021-06-14 19:17:30	30
174	36	42532	7	DS_BD_18_19_Resumos (zip)	/notes/segundo_ano/segundo_semestre/bd/DS_BD_18_19_Resumos.zip	2018	1	0	0	0	0	0	0	2021-06-14 19:17:30	144
175	36	42532	7	DS_BD_18_19_Praticas (zip)	/notes/segundo_ano/segundo_semestre/bd/DS_BD_18_19_Praticas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	81
176	\N	42532	\N	Resumos Diversos (zip)	/notes/segundo_ano/segundo_semestre/bd/Resumos.zip	\N	1	0	0	0	1	0	0	2021-06-14 19:17:30	1
177	19	41791	24	Resumos EF	/notes/primeiro_ano/primeiro_semestre/ef/CarolinaAlbuquerque_EF_Resumo.pdf	2015	1	0	0	0	0	0	0	2021-06-14 19:17:30	8
178	19	41791	24	Resolução Fichas EF	/notes/primeiro_ano/primeiro_semestre/ef/CarolinaAlbuquerque_EF_ResolucoesFichas.zip	2015	0	0	0	0	1	0	0	2021-06-14 19:17:30	169
179	66	42573	\N	Exames SIO resolvidos	/notes/terceiro_ano/primeiro_semestre/sio/JoaoAlegria_Exames.zip	2016	0	1	0	0	0	0	0	2021-06-14 19:17:30	13
180	66	42573	\N	Resumos SIO	/notes/terceiro_ano/primeiro_semestre/sio/JoaoAlegria_Resumos.zip	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	20
181	101	42709	23	Exames e testes ALGA	/notes/primeiro_ano/primeiro_semestre/alga/Rafael_Direito_Exames.zip	2016	0	1	0	0	0	0	0	2021-06-14 19:17:30	9
182	101	42709	23	Fichas resolvidas ALGA	/notes/primeiro_ano/primeiro_semestre/alga/RafaelDireito_Fichas.pdf	2016	0	0	0	0	1	0	0	2021-06-14 19:17:30	15
183	101	42709	23	Resumos ALGA 	/notes/primeiro_ano/primeiro_semestre/alga/RafelDireito_Resumos.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	8
184	19	42728	19	Caderno de cálculo	/notes/primeiro_ano/primeiro_semestre/c1/CarolinaAlbuquerque_C1_caderno.pdf	2015	0	0	0	0	0	0	1	2021-06-14 19:17:30	11
185	96	42729	19	Fichas resolvidas CII	/notes/primeiro_ano/segundo_semestre/c2/PedroOliveira_Fichas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	110
186	96	42729	19	Testes CII	/notes/primeiro_ano/segundo_semestre/c2/PedroOliveira_testes-resol.zip	2018	0	1	0	0	0	0	0	2021-06-14 19:17:30	24
187	54	45424	\N	Apontamentos Gerais ICM	/notes/terceiro_ano/primeiro_semestre/icm/Resumo Geral Android.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	3
331	104	40383	12	Guiões e Exame P, Projeto T	https://github.com/Rui-FMF/PDS	2019	0	1	0	0	1	1	0	2021-11-15 00:00:00	\N
334	104	40382	2	Práticas e Projetos CD	https://github.com/Rui-FMF/CD	2019	0	0	0	0	1	1	0	2021-11-15 00:00:00	\N
337	104	12832	40	Projeto 1 TAA	https://github.com/Rui-FMF/TAA_1	2020	0	0	0	0	0	1	0	2021-11-15 00:00:00	\N
188	96	47166	20	Resoluções material apoio MD	/notes/primeiro_ano/segundo_semestre/md/PedroOliveira_EA.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	45
189	96	47166	20	Resoluções fichas MD	/notes/primeiro_ano/segundo_semestre/md/PedroOliveira_Fichas.zip	2018	0	0	0	0	1	0	0	2021-06-14 19:17:30	79
190	96	47166	20	Resoluções testes MD	/notes/primeiro_ano/segundo_semestre/md/PedroOliveira_testes.zip	2018	0	1	0	0	0	0	0	2021-06-14 19:17:30	33
191	101	40433	4	Estudo para o exame	/notes/segundo_ano/primeiro_semestre/rs/RafaelDireito_2017_RSexame.pdf	2017	1	0	0	0	0	0	0	2021-06-14 19:17:30	6
192	\N	40551	\N	Exercícios TPW	/notes/terceiro_ano/segundo_semestre/tpw/Exercicios.zip	\N	0	0	0	0	1	0	0	2021-06-14 19:17:30	14
193	66	40757	\N	Resumos 2016/2017	/notes/mestrado/as/as_apontamentos_001.pdf	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	2
194	66	40757	\N	Resumos por capítulo (zip)	/notes/mestrado/as/JoaoAlegria_ResumosPorCapitulo.zip	2016	1	0	0	0	0	0	0	2021-06-14 19:17:30	2
195	54	40846	\N	Exercícios IA	/notes/terceiro_ano/primeiro_semestre/ia/Inês_Correia_IA_exercícios.pdf	\N	0	0	0	0	1	0	0	2021-06-14 19:17:30	7
196	54	40846	\N	Resumos IA	/notes/terceiro_ano/primeiro_semestre/ia/Inês_Correia_IA_resumo.pdf	\N	1	0	0	0	0	0	0	2021-06-14 19:17:30	9
197	130	47166	32	Caderno MD Cap. 6 e 7	/notes/primeiro_ano/segundo_semestre/md/MarianaRosa_Caderno_Capts6e7.pdf	2019	\N	\N	\N	\N	\N	\N	1	2021-06-16 22:18:59	20
198	130	47166	32	Resumos 1.ª Parte MD	/notes/primeiro_ano/segundo_semestre/md/MarianaRosa_Resumos_1aParte.pdf	2019	1	\N	\N	\N	\N	\N	\N	2021-06-16 22:21:33	13
199	49	42532	8	Práticas BD	/notes/segundo_ano/segundo_semestre/bd/Goncalo_Praticas.zip	2019	\N	\N	\N	\N	1	1	\N	2021-06-16 22:27:12	23
200	49	42532	7	Resumos BD	/notes/segundo_ano/segundo_semestre/bd/Goncalo_Resumos.zip	2019	1	\N	\N	\N	\N	\N	\N	2021-06-16 22:28:20	20
201	49	41469	10	Resumos Caps. 3 e 4	/notes/segundo_ano/segundo_semestre/c/Goncalo_TP.zip	2019	1	\N	\N	\N	\N	\N	\N	2021-06-16 22:32:40	8
202	49	41469	10	Resumos ANTLR4	/notes/segundo_ano/segundo_semestre/c/Goncalo_ANTLR4.zip	2019	1	\N	\N	\N	\N	\N	\N	2021-06-16 22:32:40	1
203	49	41469	10	Guiões P Resolvidos	/notes/segundo_ano/segundo_semestre/c/Goncalo_GuioesPraticos.zip	2019	\N	\N	\N	\N	1	\N	\N	2021-06-16 22:32:40	2
204	49	41469	10	Resumos Práticos	/notes/segundo_ano/segundo_semestre/c/Goncalo_ResumosPraticos.zip	2019	1	\N	\N	\N	\N	\N	\N	2021-06-16 22:32:40	17
205	49	40382	2	Bibliografia	/notes/segundo_ano/segundo_semestre/cd/Bibliografia.zip	2019	\N	\N	1	\N	\N	\N	\N	2021-06-16 22:32:40	39
206	49	40382	2	Cheatsheet	/notes/segundo_ano/segundo_semestre/cd/Goncalo_CheatSheet.pdf	2019	1	\N	\N	\N	\N	\N	\N	2021-06-16 22:32:40	1
207	49	40382	2	Aulas Resolvidas	/notes/segundo_ano/segundo_semestre/cd/Goncalo_Aulas.zip	2019	\N	\N	\N	\N	1	\N	\N	2021-06-16 22:32:40	8
208	49	40382	2	Projeto1	/notes/segundo_ano/segundo_semestre/cd/Goncalo_Projeto1.zip	2019	\N	\N	\N	\N	\N	1	\N	2021-06-16 22:32:40	3
209	49	40382	2	Projeto2	/notes/segundo_ano/segundo_semestre/cd/Goncalo_Projeto2.zip	2019	\N	\N	\N	\N	\N	1	\N	2021-06-16 22:32:40	15
210	49	40382	2	Resumos Teóricos	/notes/segundo_ano/segundo_semestre/cd/Goncalo_TP.pdf	2019	1	\N	\N	\N	\N	\N	\N	2021-06-16 22:32:40	6
211	49	41549	9	Paper \\Help, I am stuck...\\	/notes/segundo_ano/segundo_semestre/ihc/Goncalo_Francisca_Paper.zip	2019	\N	\N	\N	\N	\N	1	\N	2021-06-16 22:32:40	2
212	49	41549	9	Resumos (incompletos)	/notes/segundo_ano/segundo_semestre/ihc/Goncalo_TP.pdf	2019	1	\N	\N	\N	\N	\N	\N	2021-06-16 22:32:40	1
213	49	41549	9	Perguntitas de preparação exame	/notes/segundo_ano/segundo_semestre/ihc/Perguntitaspreparaçaoexame.zip	2019	\N	1	\N	\N	\N	\N	\N	2021-06-16 22:32:40	1
214	49	40383	12	Resumos teóricos	/notes/segundo_ano/segundo_semestre/pds/Goncalo_TP.pdf	2019	1	\N	\N	\N	\N	\N	\N	2021-06-16 22:32:40	11
215	49	40383	12	Projeto final: Padrões Bridge e Flyweight e Refactoring	/notes/segundo_ano/segundo_semestre/pds/Goncalo_Projeto.zip	2019	\N	\N	\N	\N	\N	1	\N	2021-06-16 22:32:40	74
340	104	41549	9	Projetos e artigo IHC	https://github.com/Rui-FMF/IHC	2019	0	0	0	0	1	1	0	2021-11-15 00:00:00	\N
343	104	45426	13	Guiões P e Homework TQS	https://github.com/Rui-FMF/TQS	2020	0	0	0	0	1	1	0	2021-11-15 00:00:00	\N
216	49	40383	12	Aulas P Resolvidas	/notes/segundo_ano/segundo_semestre/pds/Goncalo_Aulas.zip	2019	\N	\N	\N	\N	1	\N	\N	2021-06-16 22:32:40	38
217	49	40383	12	Exame final	/notes/segundo_ano/segundo_semestre/pds/Goncalo_Exame.zip	2019	\N	1	\N	\N	\N	\N	\N	2021-06-16 22:32:40	1
218	49	40383	12	Bibliografia	/notes/segundo_ano/segundo_semestre/pds/Bibliografia.zip	2019	\N	\N	1	\N	\N	\N	\N	2021-06-16 22:32:40	159
220	49	41549	9	Projeto final \\Show tracker\\	https://github.com/gmatosferreira/show-tracker-app	2019	\N	\N	\N	\N	\N	1	\N	2021-10-18 15:00:00	\N
232	\N	40846	30	AI: A Modern Approach	/notes/terceiro_ano/primeiro_semestre/ia/artificial-intelligence-modern-approach.9780131038059.25368.pdf	2020	0	0	1	0	0	0	0	2021-10-18 00:00:00	38
238	49	40846	30	Resumos	/notes/terceiro_ano/primeiro_semestre/ia/Goncalo_IA_TP.pdf	2020	1	0	0	0	0	0	0	2021-10-18 00:00:00	3
241	49	40846	2	Notas código práticas	/notes/terceiro_ano/primeiro_semestre/ia/Goncalo_Código_Anotado_Práticas.zip	2020	0	0	0	0	1	0	0	2021-10-18 00:00:00	4
244	49	40846	2	Código práticas	/notes/terceiro_ano/primeiro_semestre/ia/Goncalo_Praticas.zip	2020	0	0	0	0	1	0	0	2021-10-18 00:00:00	2
247	49	2450	34	Resumos	/notes/terceiro_ano/primeiro_semestre/ge/Goncalo_GE_TP.pdf	2020	1	0	0	0	0	0	0	2021-10-18 00:00:00	2
250	49	2450	34	Post-its	/notes/terceiro_ano/primeiro_semestre/ge/Goncalo_Postits.zip	2020	1	0	0	0	0	0	0	2021-10-18 00:00:00	11
253	49	40384	12	Post-its	/notes/terceiro_ano/primeiro_semestre/ies/Goncalo_Postits.zip	2020	1	0	0	0	0	0	0	2021-10-18 00:00:00	12
256	49	40384	12	Aulas práticas	/notes/terceiro_ano/primeiro_semestre/ies/Goncalo_Práticas.zip	2020	0	0	0	0	1	0	0	2021-10-18 00:00:00	3
259	49	40384	12	Resumos	/notes/terceiro_ano/primeiro_semestre/ies/Goncalo_IES_TP.pdf	2020	1	0	0	0	0	0	0	2021-10-18 00:00:00	5
262	49	40384	12	Projeto final \\Store Go\\	https://github.com/gmatosferreira/IES_Project_G31	2020	0	0	0	0	0	1	0	2021-10-18 00:00:00	\N
265	49	42573	3	Resumos	/notes/terceiro_ano/primeiro_semestre/sio/Goncalo_SIO_TP.pdf	2020	1	0	0	0	0	0	0	2021-10-18 00:00:00	4
268	49	42573	3	Tópicos exame	/notes/terceiro_ano/primeiro_semestre/sio/Goncalo_Tópicos_exame.pdf	2020	0	1	0	0	0	0	0	2021-10-18 00:00:00	2
271	\N	42573	3	Security in Computing	/notes/terceiro_ano/primeiro_semestre/sio/security-in-computing-5-e.pdf	2020	0	0	1	0	0	0	0	2021-10-18 00:00:00	18
274	49	42573	3	Projeto 1 \\Exploração de vulnerabilidades\\	/notes/terceiro_ano/primeiro_semestre/sio/Goncalo_[SIO][Projeto 1]_Relatório.pdf	2020	0	0	0	0	0	1	0	2021-10-18 00:00:00	1
277	49	42573	3	Projeto 4 \\Forensics\\	/notes/terceiro_ano/primeiro_semestre/sio/Goncalo_[SIO][Projeto 4]_Relatório.pdf	2020	0	0	0	0	0	1	0	2021-10-18 00:00:00	1
280	49	42573	3	Projeto 2 \\Secure Media Player\\	https://github.com/gmatosferreira/securemediaplayer	2020	0	0	0	0	0	1	0	2021-10-18 00:00:00	\N
283	49	40385	12	Resumos	/notes/terceiro_ano/primeiro_semestre/cbd/Goncalo_CBD_TP.pdf	2020	1	0	0	0	0	0	0	2021-10-18 00:00:00	3
286	49	40385	12	Post-its	/notes/terceiro_ano/primeiro_semestre/cbd/Goncalo_Postits.zip	2020	1	0	0	0	0	0	0	2021-10-18 00:00:00	6
289	49	40385	12	Práticas	/notes/terceiro_ano/primeiro_semestre/cbd/Goncalo_Praticas.zip	2020	0	0	0	0	1	0	0	2021-10-18 00:00:00	4
292	\N	40385	12	Designing Data Intensive Applications	/notes/terceiro_ano/primeiro_semestre/cbd/Designing Data Intensive Applications.pdf	2020	0	0	1	0	0	0	0	2021-10-18 00:00:00	25
298	83	42573	3	Projeto 2 \\Secure Media Player\\	https://github.com/margaridasmartins/digital-rights-management	2020	0	0	0	0	0	1	0	2021-11-15 19:17:30	\N
304	104	40436	28	Práticas POO	https://github.com/Rui-FMF/POO	2018	0	1	0	0	1	0	0	2021-11-15 00:00:00	\N
307	104	40379	27	Práticas FP	https://github.com/Rui-FMF/FP	2018	0	0	0	0	1	0	0	2021-11-15 00:00:00	\N
313	104	42502	6	Práticas IAC	https://github.com/Rui-FMF/IAC	2018	0	0	0	0	1	0	0	2021-11-15 00:00:00	\N
319	104	40433	16	Projeto RS	https://github.com/Rui-FMF/RS	2019	0	0	0	0	0	1	0	2021-11-15 00:00:00	\N
322	104	40337	28	Práticas e projeto MPEI	https://github.com/Rui-FMF/MPEI	2019	0	0	0	0	1	1	0	2021-11-15 00:00:00	\N
349	104	40385	12	Labs CBD	https://github.com/Rui-FMF/CBD	2020	0	0	0	0	1	0	0	2021-11-15 00:00:00	\N
352	104	40846	2	Guiões, TPI e Projeto de IA	https://github.com/Rui-FMF/IA	2020	0	1	0	0	1	1	0	2021-11-15 00:00:00	\N
355	104	40384	12	Labs e projeto de IES	https://github.com/Rui-FMF/IES	2020	0	0	0	0	1	1	0	2021-11-15 00:00:00	\N
358	104	42573	3	Projetos SIO	https://github.com/Rui-FMF/SIO	2020	0	0	0	0	0	1	0	2021-11-15 00:00:00	\N
361	104	40551	25	Projetos TPW	https://github.com/Rui-FMF/TPW	2020	0	0	0	0	0	1	0	2021-11-15 00:00:00	\N
364	83	40384	12	Projeto de IES	https://github.com/margaridasmartins/IES_Project	2020	0	0	0	0	0	1	0	2021-11-15 00:00:00	\N
367	83	45426	13	Guiões P e Homework TQS	https://github.com/margaridasmartins/TQSLabs	2020	0	0	0	0	1	1	0	2021-11-15 00:00:00	\N
370	140	14817	29	Programas MSF	/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_Programas.zip	2020	0	0	0	0	1	0	0	2022-01-31 20:37:14	\N
373	140	14817	29	Exercícios resolvidos MSF	/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_ExsResolvidos.zip	2020	0	0	0	0	1	0	0	2022-01-31 20:37:14	\N
376	140	14817	29	Exercícios MSF	/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_Exercicios.zip	2020	0	0	0	0	1	0	0	2022-01-31 20:37:14	\N
379	140	14817	29	Guiões práticos MSF	/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_Ps.zip	2020	0	0	0	0	1	0	0	2022-01-31 20:37:14	\N
382	140	14817	29	Slides teóricos MSF	/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_TPs.zip	2020	0	0	0	1	0	0	0	2022-01-31 20:37:14	\N
385	140	14817	29	Formulário MSF	/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_Form.pdf	2020	1	0	0	0	0	0	0	2022-01-31 20:37:14	\N
\.


--
-- Data for Name: partner; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.partner (id, header, company, description, content, link, banner_url, banner_image, banner_until) FROM stdin;
1	/partners/LavandariaFrame.jpg	Lavandaria Portuguesa	A Lavandaria Portuguesa encontra-se aliada ao NEI desde março de 2018, ajudando o núcleo na área desportiva com lavagens de equipamentos dos atletas que representam o curso.	\N	https://www.facebook.com/alavandariaportuguesa.pt/	\N	\N	\N
2	/partners/OlisipoFrame.jpg	Olisipo	Fundada em 1994, a Olisipo é a única empresa portuguesa com mais de 25 anos de experiência dedicada à Gestão de Profissionais na área das Tecnologias de Informação.\\n\\nSomos gestores de carreira de mais de 500 profissionais de TI e temos Talent Managers capazes de influenciar o sucesso da carreira dos nossos colaboradores e potenciar o crescimento dos nossos clientes.\\n\\nVem conhecer um Great Place to Work® e uma das 30 melhores empresas para trabalhar em Portugal.	\N	https://bit.ly/3KVT8zs	https://bit.ly/3KVT8zs	/partner/banners/Olisipo.png	2023-01-31 23:59:59
\.


--
-- Data for Name: redirect; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.redirect (id, alias, redirect) FROM stdin;
1	mapa	/integracao/202122/peddypaper/mapa.png
2	glicinias	/integracao/202122/peddypaper/glicinias.jpg
3	ribau	/integracao/202122/peddypaper/congressos.jpg
4	forum	/integracao/202122/peddypaper/forum.jpg
5	santos	/integracao/202122/peddypaper/santos.jpg
6	macaca	/integracao/202122/peddypaper/macaca.jpg
7	convivio	/integracao/202122/peddypaper/convivio.jpg
8	be	/integracao/202122/peddypaper/be.jpg
9	socorro	/integracao/202122/guiasobrevivencia.pdf
\.


--
-- Data for Name: rgm; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.rgm (id, category, mandate, date, title, file) FROM stdin;
1	ATA	2013	2012-12-19 00:00:00	Acta da Assembleia de Alunos de Licenciatura de Tecnologias e Sistemas de Informação e Mestrado de Sistemas de Informação	/rgm/ATA/2013/ATA1.pdf
2	ATA	2013	2013-02-26 00:00:00	Acta da Reunião Geral de Membros do Pré-Núcleo Estudantes de Sistemas de Informação	/rgm/ATA/2013/ATA2.pdf
3	ATA	2013	2013-10-14 00:00:00	Ata da Reunião Geral de Membros Extraordinária de Licenciatura em Tecnologias e Sistemas de Informação e Mestrado em Sistemas de Informação	/rgm/ATA/2013/ATA3.pdf
4	ATA	2013	2013-11-20 00:00:00	Ata da Reunião Geral de Membros - Extraordinária TSI & MSI	/rgm/ATA/2013/ATA4.pdf
5	ATA	2013	2013-12-11 00:00:00	Ata da Reunião Geral de Membros de Licenciatura em Tecnologias e Sistemas de Informação e Mestrado em Sistemas de Informação	/rgm/ATA/2013/ATA5.pdf
6	PAO	2013	\N	Pré- Núcleo de Estudantes de Sistemas de Informação NESI	/rgm/PAO/PAO_2013_NESI.pdf
7	RAC	2013	\N	Núcleo de Estudantes de Sistemas de Informação	/rgm/RAC/RAC_2013_NESI.pdf
8	ATA	2014	2014-02-18 00:00:00	Ata da Reunião Geral de Membros da Licenciatura em Tecnologias e Sistemas de Informação e do Mestrado em Sistemas de Informação	/rgm/ATA/2014/ATA1.pdf
9	ATA	2014	2014-06-02 00:00:00	Ata da Reunião Geral de Membros Extraordinária da Licenciatura em Tecnologias e Sistemas de Informação e do Mestrado em Sistemas de Informação	/rgm/ATA/2014/ATA2.pdf
10	ATA	2014	2014-10-14 00:00:00	Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação	/rgm/ATA/2014/ATA3.pdf
11	ATA	2014	2014-11-06 00:00:00	Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação	/rgm/ATA/2014/ATA4.pdf
12	ATA	2014	2014-12-16 00:00:00	Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação	/rgm/ATA/2014/ATA5.pdf
13	PAO	2014	\N	Núcleo de Estudantes de Sistemas de Informação	/rgm/PAO/PAO_2014_NESI.pdf
14	RAC	2014	\N	Núcleo de Estudantes de Informática	/rgm/RAC/RAC_2014_NEI.pdf
15	ATA	2015	2015-02-19 00:00:00	Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação	/rgm/ATA/2015/ATA1.pdf
16	ATA	2015	2015-04-07 00:00:00	Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação	/rgm/ATA/2015/ATA2.pdf
17	ATA	2015	2016-01-14 00:00:00	Ata da Reunião Geral de Membros Extraordinária da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação	/rgm/ATA/2015/ATA3.pdf
18	PAO	2015	\N	Núcleo de Estudantes de Informática	/rgm/PAO/PAO_2015_NEI.pdf
19	RAC	2015	\N	Núcleo de Estudantes de Informática	/rgm/RAC/RAC_2015_NEI.pdf
20	ATA	2016	2016-02-18 00:00:00	Ata número Um do Mandato 2016: Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação	/rgm/ATA/2016/ATA1.pdf
21	ATA	2016	2016-04-07 00:00:00	Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação	/rgm/ATA/2016/ATA2.pdf
22	PAO	2016	\N	\N	/rgm/PAO/PAO_2016_NEI.pdf
23	RAC	2016	\N	Núcleo de Estudantes de Informática	/rgm/RAC/RAC_2016_NEI.pdf
26	ATA	2017	2017-02-13 00:00:00	Ata da Reunião Geral de Membros da Licenciatura em Engenharia Informática e do Mestrado em Sistemas de Informação	/rgm/ATA/2017/ATA1.pdf
25	ATA	2017	2017-10-11 00:00:00	REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2017 ATA NÚMERO 2	/rgm/ATA/2017/ATA2.pdf
24	ATA	2017	2018-01-10 00:00:00	REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2017 ATA NÚMERO 3	/rgm/ATA/2017/ATA3.pdf
27	PAO	2017	\N	\N	/rgm/PAO/PAO_2017_NEI.pdf
28	RAC	2017	\N	NEI-AAUAv 2017	/rgm/RAC/RAC_2017_NEI.pdf
31	ATA	2018	2018-03-13 00:00:00	\N	/rgm/ATA/2018/ATA1.pdf
30	ATA	2018	2018-02-15 00:00:00	\N	/rgm/ATA/2018/ATA2.pdf
32	ATA	2018	2018-10-18 00:00:00	\N	/rgm/ATA/2018/ATA3.pdf
29	ATA	2018	2019-01-10 00:00:00	\N	/rgm/ATA/2018/ATA4.pdf
33	PAO	2018	\N	\N	/rgm/PAO/PAO_2018_NEI.pdf
34	RAC	2018	\N	NEI-AAUAv 2018	/rgm/RAC/RAC_2018_NEI.pdf
35	ATA	2019	2019-02-14 00:00:00	REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2019 ATA NÚMERO 1	/rgm/ATA/2019/ATA1.pdf
36	ATA	2019	2019-04-01 00:00:00	REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2019 ATA NÚMERO 2	/rgm/ATA/2019/ATA2.pdf
37	ATA	2019	2019-09-24 00:00:00	REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2019 ATA NÚMERO 3	/rgm/ATA/2019/ATA3.pdf
38	ATA	2019	2020-01-09 00:00:00	REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2019 ATA NÚMERO 4	/rgm/ATA/2019/ATA4.pdf
39	PAO	2019	\N	\N	/rgm/PAO/PAO_2019_NEI.pdf
40	RAC	2019	\N	Núcleo de Estudantes de Informática	/rgm/RAC/RAC_2019_NEI.pdf
41	ATA	2020	2020-02-12 00:00:00	REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2020 ATA NÚMERO 1	/rgm/ATA/2020/ATA1.pdf
42	ATA	2020	2021-02-11 00:00:00	REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2020 ATA NÚMERO 2	/rgm/ATA/2020/ATA2.pdf
43	PAO	2020	\N	NEI	/rgm/PAO/PAO_2020_NEI.pdf
44	RAC	2020	\N	Núcleo de Estudantes de Informática	/rgm/RAC/RAC_2020_NEI.pdf
45	ATA	2021	2021-04-05 00:00:00	REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2021 ATA NÚMERO 1	/rgm/ATA/2021/ATA1.pdf
46	ATA	2021	2022-02-01 00:00:00	REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2021 ATA NÚMERO 2	/rgm/ATA/2021/ATA2.pdf
47	PAO	2021	\N	NEI	/rgm/PAO/PAO_2021_NEI.pdf
48	RAC	2021	\N	NEI	/rgm/RAC/RAC_2021_NEI.pdf
49	ATA	2022	2022-03-28 00:00:00	REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2022 ATA NÚMERO 1	/rgm/ATA/2022/ATA1.pdf
50	ATA	2022	2022-06-20 00:00:00	REUNIÃO GERAL DE MEMBROS NÚCLEO DE ESTUDANTES DE INFORMÁTICA DA ASSOCIAÇÃO ACADÉMICA DA UNIVERSIDADE DE AVEIRO Mandato 2022 ATA NÚMERO 2	/rgm/ATA/2022/ATA2.pdf
51	PAO	2022	\N	NEI	/rgm/PAO/PAO_2022_NEI.pdf
52	RAC	2022	\N	NEI	/rgm/RAC/RAC_2022_NEI.pdf
53	PAO	2022/23	\N	NEI	/rgm/PAO/PAO_202223_NEI.pdf
\.


--
-- Data for Name: senior; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.senior (id, year, course, image) FROM stdin;
1	2020	LEI	/seniors/lei/2020_3.jpg
2	2020	MEI	/seniors/mei/2020.jpg
3	2021	LEI	\N
4	2021	MEI	\N
\.


--
-- Data for Name: senior_student; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.senior_student (senior_id, user_id, quote, image) FROM stdin;
1	4	\N	\N
1	5	\N	\N
1	7	\N	\N
1	8	\N	\N
1	9	\N	\N
1	14	\N	\N
1	15	\N	\N
1	34	\N	\N
1	36	\N	\N
1	47	\N	\N
1	48	\N	\N
1	56	\N	\N
1	63	\N	\N
1	69	\N	\N
1	76	\N	\N
1	87	\N	\N
1	96	\N	\N
1	118	\N	\N
1	122	\N	\N
1	145	\N	\N
2	24	\N	/seniors/mei/2020/24.jpg
2	146	\N	/seniors/mei/2020/146.jpg
3	18	Level up	/seniors/lei/2021/18.jpg
3	37	Mal posso esperar para ver o que se segue	/seniors/lei/2021/37.jpg
3	43	Já dizia a minha avó: \\O meu neto não bebe álcool\\	/seniors/lei/2021/43.jpg
3	49	\N	/seniors/lei/2021/49.jpg
3	53	\N	/seniors/lei/2021/53.jpg
3	67	Simplesmente viciado em café e futebol	/seniors/lei/2021/67.jpg
3	83	MD é fixe.	/seniors/lei/2021/83.jpg
3	93	Há tempo para tudo na vida académica!	/seniors/lei/2021/93.jpg
3	106	Melhorias = Mito	/seniors/lei/2021/106.jpg
4	19	<h1>Fun fact: #EAAA00</h1>	/seniors/mei/2021/19.jpg
\.


--
-- Data for Name: team_colaborator; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.team_colaborator (user_id, mandate) FROM stdin;
137	2021
150	2021
126	2021
127	2021
148	2021
132	2021
149	2021
133	2021
147	2021
83	2022
160	2022
188	2022
189	2022
190	2022
191	2022
192	2022
193	2022
194	2022
195	2022
196	2022
197	2022
198	2022
161	2022/23
162	2022/23
163	2022/23
164	2022/23
165	2022/23
166	2022/23
167	2022/23
168	2022/23
169	2022/23
170	2022/23
171	2022/23
172	2022/23
173	2022/23
174	2022/23
175	2022/23
176	2022/23
177	2022/23
178	2022/23
179	2022/23
180	2022/23
181	2022/23
182	2022/23
183	2022/23
184	2022/23
185	2022/23
186	2022/23
187	2022/23
190	2022/23
191	2022/23
192	2022/23
193	2022/23
194	2022/23
195	2022/23
196	2022/23
197	2022/23
\.


--
-- Data for Name: team_role; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.team_role (id, name, weight) FROM stdin;
1	Coordenador	6
2	Presidente da Mesa da RGM	3
3	Primeiro Secretário da Mesa da RGM	2
4	Responsável Financeiro	5
5	Segundo Secretário da Mesa da RGM	1
6	Vogal da Secção Académica	4
7	Vogal da Secção Académica e Desportiva	4
8	Vogal da Secção Académica-Desportiva	4
9	Vogal da Secção Administrativa	4
10	Vogal da Secção Administrativa, Relações Externas e Merchandising	4
11	Vogal da Secção Comunicação e Imagem	4
12	Vogal da Secção Desportiva	4
13	Vogal da Secção Informativa	4
14	Vogal da Secção Pedagógica	4
15	Vogal da Secção Pedagógica e Social	4
16	Vogal da Secção da Administração Interna	4
17	Vogal da Secção da Administração Interna e Merchandising	4
18	Vogal da Secção da Comunicação e Imagem	4
\.


--
-- Data for Name: team_member; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.team_member (id, header, mandate, user_id, role_id) FROM stdin;
3	/teams/2019/1.jpg	2019	65	1
6	/teams/2019/2.jpg	2019	111	4
9	/teams/2019/3.jpg	2019	56	17
12	/teams/2019/4.jpg	2019	47	18
15	/teams/2019/5.jpg	2019	118	18
18	/teams/2019/6.jpg	2019	84	7
21	/teams/2019/7.jpg	2019	102	7
24	/teams/2019/8.jpg	2019	75	7
27	/teams/2019/9.jpg	2019	53	15
30	/teams/2019/10.jpg	2019	122	15
33	/teams/2019/11.jpg	2019	22	15
36	/teams/2019/12.jpg	2019	86	3
39	/teams/2019/13.jpg	2019	30	2
42	/teams/2019/14.jpg	2019	83	5
45	/teams/2018/1.jpg	2018	65	1
48	/teams/2018/2.jpg	2018	111	4
51	/teams/2018/3.jpg	2018	102	17
54	/teams/2018/4.jpg	2018	119	17
57	/teams/2018/5.jpg	2018	24	18
60	/teams/2018/6.jpg	2018	19	18
63	/teams/2018/7.jpg	2018	60	7
66	/teams/2018/8.jpg	2018	75	7
69	/teams/2018/9.jpg	2018	121	15
72	/teams/2018/10.jpg	2018	101	15
75	/teams/2018/11.jpg	2018	100	15
78	/teams/2018/12.jpg	2018	86	3
81	/teams/2018/13.jpg	2018	51	2
84	/teams/2018/14.jpg	2018	84	5
87	/teams/2017/1.jpg	2017	54	1
90	/teams/2017/2.jpg	2017	51	4
93	/teams/2017/3.jpg	2017	31	17
96	/teams/2017/4.jpg	2017	30	17
99	/teams/2017/5.jpg	2017	35	18
102	/teams/2017/6.jpg	2017	90	18
105	/teams/2017/7.jpg	2017	45	7
108	/teams/2017/8.jpg	2017	95	7
111	/teams/2017/9.jpg	2017	19	15
114	/teams/2017/10.jpg	2017	86	15
117	/teams/2017/11.jpg	2017	11	15
120	/teams/2017/12.jpg	2017	91	3
123	/teams/2017/13.jpg	2017	110	2
126	/teams/2017/14.jpg	2017	65	5
129	/teams/2016/1.jpg	2016	105	1
132	/teams/2016/2.jpg	2016	66	4
135	/teams/2016/3.jpg	2016	31	16
138	/teams/2016/4.jpg	2016	51	16
141	/teams/2016/5.jpg	2016	62	11
144	/teams/2016/6.jpg	2016	98	11
147	/teams/2016/7.jpg	2016	2	8
150	/teams/2016/8.jpg	2016	45	8
153	/teams/2016/9.jpg	2016	54	15
156	/teams/2016/10.jpg	2016	97	15
159	/teams/2016/11.jpg	2016	26	15
162	/teams/2016/12.jpg	2016	20	3
165	/teams/2016/13.jpg	2016	110	2
168	/teams/2016/14.jpg	2016	28	5
171	/teams/2015/1.jpg	2015	110	1
174	/teams/2015/2.jpg	2015	109	4
177	/teams/2015/3.jpg	2015	46	10
180	/teams/2015/4.jpg	2015	17	10
183	/teams/2015/5.jpg	2015	88	11
186	/teams/2015/6.jpg	2015	50	11
189	/teams/2015/7.jpg	2015	78	7
192	/teams/2015/8.jpg	2015	112	7
195	/teams/2015/9.jpg	2015	66	14
198	/teams/2015/10.jpg	2015	2	14
201	/teams/2015/11.jpg	2015	54	14
204	/teams/2015/12.jpg	2015	3	3
207	/teams/2015/13.jpg	2015	58	2
210	/teams/2015/14.jpg	2015	23	5
213	/teams/2014/1.jpg	2014	92	1
216	/teams/2014/2.jpg	2014	113	4
219	/teams/2014/3.jpg	2014	110	10
222	/teams/2014/4.jpg	2014	105	10
225	/teams/2014/5.jpg	2014	82	11
228	/teams/2014/6.jpg	2014	46	11
231	/teams/2014/7.jpg	2014	52	7
234	/teams/2014/8.jpg	2014	42	7
237	/teams/2014/9.jpg	2014	107	14
240	/teams/2014/10.jpg	2014	109	14
243	/teams/2014/11.jpg	2014	10	14
246	/teams/2014/12.jpg	2014	72	3
249	/teams/2014/13.jpg	2014	108	2
252	/teams/2014/14.jpg	2014	66	5
255	/teams/2013/1.jpg	2013	92	1
258	/teams/2013/2.jpg	2013	68	4
261	/teams/2013/3.jpg	2013	39	9
264	/teams/2013/4.jpg	2013	52	9
267	/teams/2013/5.jpg	2013	41	13
270	/teams/2013/6.jpg	2013	25	8
273	/teams/2013/7.jpg	2013	113	14
276	/teams/2013/8.jpg	2013	29	3
279	/teams/2013/9.jpg	2013	58	2
282	/teams/2013/10.jpg	2013	72	5
286	/teams/2020/1.jpg	2020	102	1
289	/teams/2020/2.jpg	2020	83	4
292	/teams/2020/3.jpg	2020	94	16
295	/teams/2020/4.jpg	2020	89	18
298	/teams/2020/5.jpg	2020	40	18
301	/teams/2020/6.jpg	2020	84	6
304	/teams/2020/7.jpg	2020	59	6
307	/teams/2020/8.jpg	2020	131	12
310	/teams/2020/9.jpg	2020	55	12
313	/teams/2020/10.jpg	2020	96	15
316	/teams/2020/11.jpg	2020	103	15
319	/teams/2020/12.jpg	2020	135	3
322	/teams/2020/13.jpg	2020	86	2
325	/teams/2020/14.jpg	2020	130	5
326	/teams/2021/1.jpg	2021	83	1
327	/teams/2021/2.jpg	2021	139	4
328	/teams/2021/3.jpg	2021	49	16
329	/teams/2021/4.jpg	2021	125	18
330	/teams/2021/5.jpg	2021	143	18
331	/teams/2021/6.jpg	2021	124	18
332	/teams/2021/7.jpg	2021	141	6
333	/teams/2021/8.jpg	2021	128	6
334	/teams/2021/9.jpg	2021	136	12
335	/teams/2021/10.jpg	2021	142	15
336	/teams/2021/11.jpg	2021	40	15
337	/teams/2021/12.jpg	2021	135	2
338	/teams/2021/13.jpg	2021	144	3
339	/teams/2021/14.jpg	2021	140	5
343	/teams/2022/1.jpg	2022	139	1
361	/teams/2022/2.jpg	2022	140	4
364	/teams/2022/3.jpg	2022	150	6
367	/teams/2022/4.jpg	2022	138	11
370	/teams/2022/5.jpg	2022	153	15
373	/teams/2022/6.jpg	2022	154	3
376	/teams/2022/7.jpg	2022	135	2
379	/teams/2022/8.jpg	2022	155	5
382	/teams/2022/9.jpg	2022	133	12
385	/teams/2022/10.jpg	2022	132	15
388	/teams/2022/11.jpg	2022	156	11
391	/teams/2022/12.jpg	2022	74	16
394	/teams/2022/13.jpg	2022	157	12
397	/teams/2022/14.jpg	2022	128	6
398	/teams/2022-23/1.jpg	2022/23	139	1
399	/teams/2022-23/2.jpg	2022/23	156	4
400	/teams/2022-23/3.jpg	2022/23	74	16
401	/teams/2022-23/4.jpg	2022/23	153	15
402	/teams/2022-23/5.jpg	2022/23	198	15
403	/teams/2022-23/6.jpg	2022/23	154	2
404	/teams/2022-23/7.jpg	2022/23	135	12
405	/teams/2022-23/8.jpg	2022/23	155	3
406	/teams/2022-23/9.jpg	2022/23	133	12
407	/teams/2022-23/10.jpg	2022/23	160	5
408	/teams/2022-23/11.jpg	2022/23	138	11
409	/teams/2022-23/12.jpg	2022/23	159	6
410	/teams/2022-23/13.jpg	2022/23	157	6
411	/teams/2022-23/14.jpg	2022/23	150	6
\.


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
-- Data for Name: user_email; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.user_email (email, user_id, active) FROM stdin;
nei@aauav.pt	1	t
abbm@ua.pt	2	t
afmoleirinho@ua.pt	3	t
alexandrejflopes@ua.pt	4	t
alinayanchuk@ua.pt	5	t
anaortega@ua.pt	6	t
anarafaela98@ua.pt	7	t
andre.alves@ua.pt	8	t
andreribau@ua.pt	9	t
barbara.jael@ua.pt	10	t
bernardo.domingues@ua.pt	11	t
brunobarbosa@ua.pt	12	t
brunopinto5151@ua.pt	13	t
camilauachave@ua.pt	14	t
carina.f.f.neves@ua.pt	15	t
carlos.pacheco@ua.pt	16	t
carlotamarques@ua.pt	17	t
carolina.araujo00@ua.pt	18	t
carolinaalbuquerque@ua.pt	19	t
castroferreira@ua.pt	20	t
catarinajvinagre@ua.pt	21	t
claudio.costa@ua.pt	22	t
claudioveigas@ua.pt	23	t
cmsoares@ua.pt	24	t
costa.j@ua.pt	25	t
cristovaofreitas@ua.pt	26	t
cruzdinis@ua.pt	27	t
cunha.filipa.ana@ua.pt	28	t
daniel.v.rodrigues@ua.pt	29	t
dasfernandes@ua.pt	30	t
davidcruzferreira@ua.pt	31	t
davidsantosferreira@ua.pt	32	t
dimitrisilva@ua.pt	33	t
diogo.andrade@ua.pt	34	t
diogo.reis@ua.pt	35	t
diogo04@ua.pt	36	t
diogobento@ua.pt	37	t
diogorafael@ua.pt	38	t
dpaiva@ua.pt	39	t
duarte.ntm@ua.pt	40	t
e.martins@ua.pt	41	t
ealaranjo@ua.pt	42	t
eduardosantoshf@ua.pt	43	t
fabio.almeida@ua.pt	44	t
fabiodaniel@ua.pt	45	t
filipemcastro@ua.pt	46	t
flaviafigueiredo@ua.pt	47	t
franciscosilveira@ua.pt	48	t
gmatos.ferreira@ua.pt	49	t
gpmoura@ua.pt	50	t
hrcpintor@ua.pt	51	t
hugo.andre@ua.pt	52	t
hugofpaiva@ua.pt	53	t
ines.gomes.correia@ua.pt	54	t
isadora.fl@ua.pt	55	t
j.vasconcelos99@ua.pt	56	t
jarturcosta@ua.pt	57	t
joana.coelho@ua.pt	58	t
joao.laranjo@ua.pt	59	t
joaoantonioribeiro@ua.pt	60	t
joaogferreira@ua.pt	61	t
joaolimas@ua.pt	62	t
joaomadias@ua.pt	63	t
joaopaul@ua.pt	64	t
joaosilva9@ua.pt	65	t
joaotalegria@ua.pt	66	t
joaots@ua.pt	67	t
jorge.fernandes@ua.pt	68	t
josefrias99@ua.pt	69	t
joseppmoreira@ua.pt	70	t
josepribeiro@ua.pt	71	t
josimarcassandra@ua.pt	72	t
jrsrm@ua.pt	73	t
leandrosilva12@ua.pt	74	t
lmcosta98@ua.pt	75	t
luiscdf@ua.pt	76	t
luisfgbs@ua.pt	77	t
luisfsantos@ua.pt	78	t
luisoliveira98@ua.pt	79	t
marco.miranda@ua.pt	80	t
marcoandreventura@ua.pt	81	t
marcossilva@ua.pt	82	t
margarida.martins@ua.pt	83	t
martasferreira@ua.pt	84	t
maxlainesmoreira@ua.pt	85	t
mfs98@ua.pt	86	t
miguel.mota@ua.pt	87	t
miguelaantunes@ua.pt	88	t
moraisandre@ua.pt	89	t
p.seixas96@ua.pt	90	t
patrocinioandreia@ua.pt	91	t
paulopintor@ua.pt	92	t
pedro.bas@ua.pt	93	t
pedro.joseferreira@ua.pt	94	t
pedroguilhermematos@ua.pt	95	t
pedrooliveira99@ua.pt	96	t
pereira.jorge@ua.pt	97	t
pgr96@ua.pt	98	t
pmn@ua.pt	99	t
ptpires@ua.pt	100	t
rafael.neves.direito@ua.pt	101	t
rafaelgteixeira@ua.pt	102	t
rafaeljsimoes@ua.pt	103	t
rfmf@ua.pt	104	t
ribeirojoao@ua.pt	105	t
ricardo.cruz29@ua.pt	106	t
ricardo.mendes@ua.pt	107	t
ritajesus@ua.pt	108	t
ritareisportas@ua.pt	109	t
rjmartins@ua.pt	110	t
ruicoelho@ua.pt	111	t
ruimazevedo@ua.pt	112	t
s.joana@ua.pt	113	t
sandraandrade@ua.pt	114	t
sergiomartins8@ua.pt	115	t
sfurao@ua.pt	116	t
simaoarrais@ua.pt	117	t
sofiamoniz@ua.pt	118	t
t.cardoso@ua.pt	119	t
tiagocmendes@ua.pt	120	t
tomasbatista99@ua.pt	121	t
tomascosta@ua.pt	122	t
artur.romao@ua.pt	123	t
cffonseca@ua.pt	124	t
ddias@ua.pt	125	t
diana.siso@ua.pt	126	t
diogo.mo.monteiro@ua.pt	127	t
fabio.m@ua.pt	128	t
joaoreis16@ua.pt	129	t
marianarosa@ua.pt	130	t
martafradique@ua.pt	131	t
miguel.r.ferreira@ua.pt	132	t
paulogspereira@ua.pt	133	t
sobral@ua.pt	134	t
renatoaldias12@ua.pt	135	t
vfrd00@ua.pt	136	t
afonso.campos@ua.pt	137	t
yanismarinafaquir@ua.pt	138	t
palexandre09@ua.pt	139	t
art.afo@ua.pt	140	t
andre.bmgf22@gmail.com	141	t
dl.carvalho@ua.pt	142	t
rfg@ua.pt	143	t
inesferreira02@ua.pt	144	t
rfo08@hotmail.com	145	t
_unknown_	146	f
catarinateves02@ua.pt	147	t
leonardoalmeida7@ua.pt	148	t
luciusviniciusf@ua.pt	149	t
danielmartinsferreira@ua.pt	150	t
_151_	151	t
_152_	152	t
vmabarros@ua.pt	153	t
tiagocgomes@ua.pt	154	t
maria.abrunhosa@ua.pt	155	t
matilde.teixeira@ua.pt	156	t
hf.correia@ua.pt	157	t
pedrorrei@ua.pt	159	t
jnluis@ua.pt	160	t
Tomasalmeida8@ua.pt	161	t
bernardoleandro1@ua.pt	162	t
lia.cardoso@ua.pt	163	t
dbramos@ua.pt	164	t
marta.oliveira.inacio@ua.pt	165	t
barbara.galiza@ua.pt	166	t
robertorcastro@ua.pt	167	t
falcao.diogo@ua.pt	168	t
diogomiguel.fernandes@ua.pt	169	t
san.bas@ua.pt	170	t
fabiomatias39@ua.pt	171	t
carolinaspsilva@ua.pt	172	t
andrevasquesdora@ua.pt	173	t
raquelvinagre@ua.pt	174	t
hugocastro@ua.pt	175	t
henrique.bmo@ua.pt	176	t
dani.fig@ua.pt	177	t
aritafs@ua.pt	178	t
jcapucho@ua.pt	179	t
joanaagomes@ua.pt	180	t
antonio.alberto@ua.pt	181	t
regina.tavares@ua.pt	182	t
marialinhares@ua.pt	183	t
guilherme.rosa60@ua.pt	184	t
henriqueft04@ua.pt	185	t
gabrielm.teixeira@ua.pt	186	t
tomasvictal@ua.pt	187	t
lucapereira@ua.pt	188	t
gfcs@ua.pt	189	t
vicente.costa@ua.pt	190	t
daniel.madureira@ua.pt	191	t
pmapm@ua.pt	192	t
eduardofernandes@ua.pt	193	t
dianarrmiranda@ua.pt	194	t
jose.mcgameiro@ua.pt	195	t
bernardo.figueiredo@ua.pt	196	t
alexandrecotorobai@ua.pt	197	t
borgesjps@ua.pt	198	t
\.


--
-- Data for Name: video; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.video (id, youtube_id, title, subtitle, image, created_at, playlist) FROM stdin;
1	PL0-X-dbGZUABPg-FWm3tT7rCVh6SESK2d	FP	Fundamentos de Programação	/videos/FP_2020.jpg	2020-12-09 00:00:00	1
2	PL0-X-dbGZUAA8rQm4klslEksHCrb3EIDG	IAC	Introdução à Arquitetura de Computadores	/videos/IAC_2020.jpg	2020-06-10 00:00:00	1
3	PL0-X-dbGZUABp2uATg_-lqfT4FTFlyNir	ITW	Introdução às Tecnologias Web	/videos/ITW_2020.jpg	2020-12-17 00:00:00	1
4	PL0-X-dbGZUACS3EkepgT7DOf287MiTzp0	POO	Programação Orientada a Objetos	/videos/POO_2020.jpg	2020-11-16 00:00:00	1
5	ips-tkEr_pM	Discord Bot	Workshop	/videos/discord.jpg	2021-07-14 00:00:00	0
6	3hjRgoIItYk	Anchorage	Palestra	/videos/anchorage.jpg	2021-04-01 00:00:00	0
7	GmNvZC6iv1Y	Git	Workshop	/videos/git.jpg	2020-04-28 00:00:00	0
\.


--
-- Data for Name: video_tag; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.video_tag (id, name, color) FROM stdin;
1	1A	rgb(1, 202, 228)
2	2A	rgb(1, 171, 192)
3	3A	rgb(1, 135, 152)
4	MEI	rgb(1, 90, 101)
5	Workshops	rgb(11, 66, 21)
6	Palestras	rgb(20, 122, 38)
\.


--
-- Data for Name: video__video_tags; Type: TABLE DATA; Schema: nei; Owner: postgres
--

COPY nei.video__video_tags (video_id, video_tag_id) FROM stdin;
1	1
2	1
3	1
4	1
5	5
6	6
7	5
\.


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

SELECT pg_catalog.setval('nei.user_academic_details_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.user_id_seq', 199, false);


--
-- Name: video_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.video_id_seq', 8, false);


--
-- Name: video_tag_id_seq; Type: SEQUENCE SET; Schema: nei; Owner: postgres
--

SELECT pg_catalog.setval('nei.video_tag_id_seq', 7, false);


--
-- PostgreSQL database dump complete
--

