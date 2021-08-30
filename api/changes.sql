-- Changes to data model

-- Partners
UPDATE TABLE partners SET header=CONCAT("upload",header);
DELETE FROM partners WHERE id!=1; -- Apagar todos menos Lavandaria

-- Create table for History
CREATE TABLE history (
    moment DATE PRIMARY KEY,
    title VARCHAR(120),
    body TEXT,
    image VARCHAR(255)
);

INSERT INTO history (moment, title, image, body) VALUES 
    ("2019-06-30", "Candidatura ENEI 2020", "/images/history/20190630.png", "Entrega de uma candidatura conjunta (NEI+NEECT+AETTUA) para a organização do Encontro Nacional de Estudantes de Informática 2019. Esta candidatura teve a concorrência de uma candidatura conjunta da CESIUM, constituída por alunos da Universidade do Minho, que acabaram por ser a candidatura vencedora."),
    ("2019-06-12", "2º Lugar Futsal", "/images/history/20190612.jpg", "Num jogo em que se fizeram das tripas coração, o NEI defrontou a equipa de EGI num jogo que veio a perder, foi um jogo bastante disputado, contudo, acabou por ganhar EGI remetendo o NEI para o 2º lugar."),
    ("2018-04-30", "Elaboração de Candidatura para o Encontro Nacional de Estudantes de Informática 2019", "/images/history/20180430.png", "Entrega de uma candidatura conjunta (NEI+AETTUA) para a organização do Encontro Nacional de Estudantes de Informática 2019. Esta candidatura teve a concorrência de uma candidatura conjunta do ISCAC Junior Solutions e Junisec, constituída por alunos do Politécnico de Coimbra, que acabaram por ser a candidatura vencedora.")
;

INSERT INTO history (moment, title, image, body) VALUES 
    ("2019-03-09", "1ª Edição ThinkTwice", "/images/history/20190309.jpg", "A primeira edição do evento, realizada em 2019, teve lugar no Auditório Mestre Hélder Castanheira da Universidade de Aveiro e contou com uma duração de 24 horas para a resolução de 30 desafios colocados, que continham diferentes graus de dificuldade. O evento contou com a participação de 34 estudantes, perfazendo um total de 12 equipas."),
    ("2020-03-06", "2ª Edição ThinkTwice", "/images/history/20200306.jpg", "A edição de 2020 contou com a participação de 57 participantes divididos em 19 equipas, com 40 desafios de algoritmia de várias dificuldades para serem resolvidos em 40 horas, tendo lugar nas instalações da Casa do Estudante da Universidade de Aveiro. Esta edição contou ainda com 2 workshops e um momento de networking com as empresas patrocinadoras do evento."),
    ("2021-05-07", "3ª Edição ThinkTwice", "/images/history/20210507.png", "Devido ao contexto pandémico que se vivia a 3ª edição foi 100% online através de plataformas como o Discord e a Twitch, de 7 a 9 de maio. Nesta edição as 11 equipas participantes puderam escolher participar em uma de três tipos de competição: desafios de algoritmia, projeto de gamificação e projeto de cibersegurança. O evento contou ainda com 4 workshops e uma sessão de networking com as empresas patrocinadoras.")
;

-- Create table for seniors
CREATE TABLE seniors (
    year INT, 
    course VARCHAR(3),
    image VARCHAR(255),
    PRIMARY KEY (year, course)
)

INSERT INTO seniors (year, course, image) VALUES
    (2020, "LEI", "/images/seniors/lei/2020.jpg"),
    (2020, "MEI", "/images/seniors/mei/2020.jpg")
;

CREATE TABLE seniors_students (
    year INT,
    course VARCHAR(3),
    userId INT,
    FOREIGN KEY (year, course) REFERENCES seniors(year, course),
    FOREIGN KEY (userId) REFERENCES users(id),
    PRIMARY KEY (year, course, userId)
)

-- SELECT * FROM seniors_students INNER JOIN users ON userId=users.id; 

INSERT INTO users (id, name, full_name, uu_email, uu_iupi, curriculo, linkedIn, git, permission, created_at) VALUES
    (2130, "Rodrigo Oliveira", "Rodrigo Oliveira", "", "", "", "", "", "DEFAULT", "2021-06-11"),
    (2131, "Miguel Fonseca", "Miguel Fonseca", "", "", "", "", "", "DEFAULT", "2021-06-11")
;

INSERT INTO seniors_students (course, year, userId) VALUES
    -- LEI
    ("LEI", 2020, 873), -- Alexandre
    ("LEI", 2020, 879), -- Alina
    ("LEI", 2020, 897), -- Rafaela Vieira
    ("LEI", 2020, 927), -- André Amarante
    ("LEI", 2020, 900), -- André Alves
    ("LEI", 2020, 999), -- Camila
    ("LEI", 2020, 1002), -- Carina
    ("LEI", 2020, 1137), -- Diogo Andrade
    ("LEI", 2020, 1161), -- Diogo Silva (??????)
    ("LEI", 2020, 1245), -- Flávia Figueiredo
    ("LEI", 2020, 1266), -- Francisco
    ("LEI", 2020, 1545), -- Luís Fonseca
    ("LEI", 2020, 1425), -- João Dias (??????)
    ("LEI", 2020, 1362), -- João Vasconcelos (??????)
    ("LEI", 2020, 1476), -- José Frias
    ("LEI", 2020, 1647), -- Miguel Mota
    ("LEI", 2020, 1764), -- Pedro Oliveira
    ("LEI", 2020, 1938), -- Sofia Moniz
    ("LEI", 2020, 1995), -- Tomás Costa
    ("LEI", 2020, 2130), -- Rodrigo Oliveira
    -- MEI
    ("MEI", 2020, 1059), -- Carlos Soares
    ("MEI", 2020, 2131) -- Miguel Fonseca
;



-- Apontamentos Data Model

CREATE TABLE notes_teachers (
    id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(100) UNIQUE,
    personalPage VARCHAR(255)
);

CREATE TABLE notes_schoolyear (
    id INT PRIMARY KEY AUTO_INCREMENT,
    yearBegin SMALLINT(4),
    yearEnd SMALLINT(4)
);

CREATE TABLE notes_subjects (
  paco_code INT PRIMARY KEY,
  name VARCHAR(60) NOT NULL,
  year INT NOT NULL,
  semester INT NOT NULL,
  short VARCHAR(5) NOT NULL
);

INSERT INTO notes_subjects (`paco_code`, `name`, `year`, `semester`, `short`) VALUES
    (40337, 'Métodos Probabilísticos para Engenharia Informática', 2, 1, 'MPEI'),
    (40379, 'Fundamentos de Programação', 1, 1, 'FP'),
    (40380, 'Introdução às Tecnologias Web', 1, 1, 'ITW'),
    (40381, 'Sistemas Operativos', 2, 1, 'SO'),
    (40382, 'Computação Distribuída', 2, 2, 'CD'),
    (40383, 'Padrões e Desenho de Software', 2, 2, 'PDS'),
    (40384, 'Introdução à Engenharia de Software', 3, 1, 'IES'),
    (40385, 'Complementos de Bases de Dados', 3, 1, 'CBD'),
    (40431, 'Modelação e Análise de Sistemas', 1, 2, 'MAS'),
    (40432, 'Sistemas Multimédia', 2, 1, 'SM'),
    (40433, 'Redes e Serviços', 2, 1, 'RS'),
    (40436, 'Programação Orientada a Objetos', 1, 2, 'POO'),
    (40437, 'Algoritmos e Estruturas de Dados', 2, 1, 'AED'),
    (40551, 'Tecnologias e Programação Web', 3, 2, 'TPW'),
    (40751, 'Algoritmos Avançados', 4, 1, 'AA'),
    (40752, 'Teoria Algorítmica da Informação', 4, 1, 'TAI'),
    (40753, 'Computação em Larga Escala', 4, 2, 'CLE'),
    (40756, 'Gestão de Infraestruturas de Computação', 4, 2, 'GIC'),
    (40757, 'Arquiteturas de Software', 4, 2, 'AS'),
    (40846, 'Inteligência Artificial', 3, 1, 'IA'),
    (41469, 'Compiladores', 2, 2, 'C'),
    (41549, 'Interação Humano-Computador', 2, 2, 'IHC'),
    (41791, 'Elementos de Fisíca', 1, 1, 'EF'),
    (42502, 'Introdução à Arquitetura de Computadores', 1, 2, 'IAC'),
    (42532, 'Bases de Dados', 2, 2, 'BD'),
    (42573, 'Segurança Informática e Nas Organizações', 3, 1, 'SIO'),
    (42709, 'Álgebra Linear e Geometria Analítica', 1, 1, 'ALGA'),
    (42728, 'Cálculo I', 1, 1, 'C1'),
    (42729, 'Cálculo II', 1, 2, 'C2'),
    (44156, 'Visualização de Informação', 4, 1, 'VI'),
    (44158, 'Web Semântica', 4, 2, 'WS'),
    (45424, 'Introdução à Computação Móvel', 3, 1, 'ICM'),
    (45426, 'Teste e Qualidade de Software', 3, 2, 'TQS'),
    (45587, 'Exploração de Dados', 4, 1, 'ED'),
    (47166, 'Matemática Discreta', 1, 2, 'MD');

CREATE TABLE notes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255), 
    location VARCHAR(255), 
    -- Foreign keys
    subject INT, 
    author INT,
    schoolYear INT(4),
    teacher INT,
    -- Tags
    summary BOOLEAN,
    tests BOOLEAN,
    bibliography BOOLEAN,
    slides BOOLEAN,
    exercises BOOLEAN,
    projects BOOLEAN,
    notebook BOOLEAN,
    -- Extra details
    content TEXT,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP, -- Define default value to getDate() on PHPMyAdmin
    -- Contraints
    FOREIGN KEY (subject) REFERENCES notes_subjects(paco_code),
    FOREIGN KEY (author) REFERENCES users(id),
    FOREIGN KEY (schoolYear) REFERENCES notes_schoolyear(id),
    FOREIGN KEY (teacher) REFERENCES notes_teachers(id)
);

--- Faina
INSERT INTO faina (mandato, imagem) VALUES
    (2012, NULL),
    (2013, NULL),
    (2014, NULL),
    (2015, NULL),
    (2016, NULL),
    (2017, NULL),
    (2018, '/upload/faina/team/2018.jpg'),
    (2019, '/upload/faina/team/2019.jpg')
;

ALTER TABLE faina ADD anoLetivo VARCHAR(9);

UPDATE faina SET anoLetivo="2012/2013" WHERE mandato=2012;
UPDATE faina SET anoLetivo="2013/2014" WHERE mandato=2013;
UPDATE faina SET anoLetivo="2014/2015" WHERE mandato=2014;
UPDATE faina SET anoLetivo="2015/2016" WHERE mandato=2015;
UPDATE faina SET anoLetivo="2016/2017" WHERE mandato=2016;
UPDATE faina SET anoLetivo="2017/2018" WHERE mandato=2017;
UPDATE faina SET anoLetivo="2018/2019" WHERE mandato=2018;
UPDATE faina SET anoLetivo="2019/2020" WHERE mandato=2019;

INSERT INTO faina (mandato, imagem, anoLetivo) VALUES
    (2020, NULL, "2020/2021")
;

CREATE TABLE faina_roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20), 
    weight INT
);

INSERT INTO faina_roles(id, name, weight) VALUES
    (10, "Mestre de Curso", 6),
    (9, "Varina", 6),
    (8, "Arrais", 6),
    (7, "Mestre", 5),
    (6, "Salineira", 3),
    (5, "Marnoto", 4),
    (4, "Moça", 2),
    (3, "Moço", 2),
    (2, "Caniça", 1),
    (1, "Junco", 1)
;

CREATE TABLE faina_member (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member INT,
    year INT,
    role INT,
    -- Contraints
    FOREIGN KEY (member) REFERENCES users(id),
    FOREIGN KEY (year) REFERENCES faina(mandato),
    FOREIGN KEY (role) REFERENCES faina_roles(id)
);

INSERT INTO users (id, name, full_name, uu_email, uu_iupi, curriculo, linkedIn, git, permission, created_at) VALUES
    (2137, "Filipe Silva", "Filipe Silva", "", "", "", "", "", "DEFAULT", "2021-06-11"),
    (2138, "Alexandre Santos", "Alexandre Santos", "", "", "", "", "", "DEFAULT", "2021-06-11")
;

INSERT INTO faina_member(year, role, member) VALUES
    -- 2012
    (2012, 10, 1179), -- Mestre de Curso Diogo Paiva
    (2012, 7, 1593), -- Mestre Marco Miranda
    (2012, 5, 1062), -- Marnoto João Costa
    (2012, 5, 1080), -- Marnoto Daniel Rodrigues
    (2012, 5, 2137), -- Marnoto Filipe Silva (N encontrei, criei novo)
    (2012, 6, 1380), -- Salineira Joana Coelho
    (2012, 6, 1893), -- Salineira Joana Silva
    (2012, 6, 1848), -- Salineira Rita Jesus
    (2012, 6, 1167), -- Moço Diogo Ramos
    (2012, 6, 1599), -- Moço Marcus Silva
    (2012, 6, 1785), -- Moço Pedro Neves
    -- 2013
    (2013, 10, 1893), -- Mestre de Curso Joana Silva
    (2013, 7, 1848), -- Mestre Rita Jesus
    (2013, 5, 1218), -- Marnoto Fábio Almeida
    (2013, 5, 1599), -- Marnoto Marcos Silva
    (2013, 5, 1785), -- Marnoto Pedro Neves
    (2013, 5, 1917), -- Marnoto Sérgio Martins
    (2013, 4, 1032), -- Moça Andreia Castro
    (2013, 3, 1488), -- Moço João Ribeiro
    (2013, 3, 1551), -- Moço Luís Santos
    (2013, 2, 1629), -- Caniça Maxlaine Moreira
    (2013, 1, 1854), -- Junco Rafael Martins
    -- 2014
    (2014, 10, 1785), -- Mestre de Curso Pedro Neves
    (2014, 7, 1005), -- Mestre Carlos Pacheco
    (2014, 7, 1218), -- Mestre Fábio de Almeida
    (2014, 7, 1917), -- Mestre Sérgio Martins
    (2014, 5, 1551), -- Marnoto Luís Santos
    (2014, 4, 1038), -- Moça Catarina Vinagre
    (2014, 3, 1455), -- Moço João Alegria (?? Há dois!)
    (2014, 3, 1554), -- Moço Luís Oliveira (?? Há dois!)
    (2014, 4, 1629), -- Moça Maxlaine Moreira
    (2014, 3, 1854), -- Moço Rafael Martins
    (2014, 4, 1923), -- Moça Sara Furão
    -- 2015
    (2015, 10, 1551), -- Mestre de Curso Luís Santos
    (2015, 7, 894), -- Mestre Ana Ortega
    (2015, 7, 1194), -- Mestre Emanuel Laranjo
    (2015, 7, 1293), -- Mestre Guilherme Moura
    (2015, 5, 2138), -- Marnoto Alexandre Santos (N encontrei, criei novo)
    (2015, 5, 987), -- Marnoto Bruno Pinto
    (2015, 5, 1065), -- Marnoto João Freitas
    (2015, 5, 1653), -- Marnoto Miguel Antunes
    (2015, 3, 984), -- Moço Bruno Barbosa
    (2015, 1, 858), -- Junco André Moleirinho
    (2015, 1, 1437), -- Junco João Paúl
    -- 2016
    (2016, 10, 1293), -- Mestre de Curso Guilherme Moura
    (2016, 7, 2138), -- Mestre Alex Santos
    (2016, 5, 984), -- Marnoto Bruno Barbosa
    (2016, 6, 1071), -- Salineira Mimi Cunha
    (2016, 5, 1752), -- Marnoto Pedro Matos
    (2016, 3, 1437), -- Moço João Paúl
    (2016, 3, 1596), -- Moço Marco Ventura
    (2016, 2, 1704), -- Caniça Andreia Patrocínio
    (2016, 1, 1059), -- Junco Carlos Soares
    (2016, 1, 1947), -- Junco Tiago Cardoso
    -- 2017
    (2017, 10, 984), -- Mestre de Curso Bruno Barbosa
    (2017, 7, 1116), -- Mestre David Ferreira
    (2017, 4, 1704), -- Moça Andreia Patrocínio
    (2017, 3, 1059), -- Moço Carlos Soares
    (2017, 4, 1023), -- Moça Carolina Albuquerque
    (2017, 3, 1101), -- Moço David Fernandes
    (2017, 3, 1134), -- Moço Dimitri da Silva
    (2017, 3, 1365), -- Moço João Artur Costa
    (2017, 3, 1947), -- Moço Tiago Cardoso
    (2017, 1, 1929), -- Junco Simão Arrais
    -- 2018
    (2018, 9, 1704), -- Varina Andreia Patrocínio
    (2018, 5, 1365), -- Marnoto João Artur Costa
    (2018, 5, 1512), -- Marnoto João Magalhães
    (2018, 5, 1485), -- Marnoto José Moreira
    (2018, 3, 1053), -- Moço Cláudio Costa
    (2018, 3, 1266), -- Moço Francisco Silveira
    (2018, 3, 1524), -- Moço Luís Costa
    (2018, 4, 1902), -- Moça Sandra Andrade
    (2018, 1, 900), -- Junco André Alves
    (2018, 2, 1002), -- Caniça Carina Neves
    (2018, 1, 1965), -- Junco Tiago Mendes
    -- 2019
    (2019, 10, 1365), -- Mestre de Curso João Artur Costa
    (2019, 7, 1419), -- Mestre João Ferreira
    (2019, 7, 1512), -- Mestre João Magalhães
    (2019, 7, 1485), -- Mestre José Moreira
    (2019, 4, 1002), -- Moça Carina Neves
    (2019, 3, 1548), -- Moço Luís Silva
    (2019, 4, 1626), -- Moça Marta Ferreira
    (2019, 3, 1965), -- Moço Tiago Mendes
    (2019, 1, 1068), -- Junco Dinis Cruz
    (2019, 1, 1200), -- Junco Eduardo Santos
    (2019, 1, 1716) -- Junco Pedro Bastos
;


INSERT INTO faina_member(year, role, member) VALUES
    -- 2020
    (2020, 10, 1512), -- Mestre de Curso João Magalhães
    (2020, 7, 1419), -- Mestre João Ferreira
    (2020, 7, 1485), -- Mestre José Moreira
    (2020, 6, 1002), -- Salineira Carina Neves
    (2020, 5, 1548), -- Marnoto Luís Silva
    (2020, 3, 1200), -- Moço Eduardo Santos
    (2020, 3, 1716), -- Moço Pedro Bastos
    (2020, 3, 1821), -- Moço Rui Fernandes
    (2020, 3, 2026), -- Junco Artur Romão
    (2020, 3, 2047), -- Junco João Reis
    (2020, 3, 2059) -- Junco Pedro Sobral
;




    
-- Team tables

CREATE TABLE team_roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120), 
    weight INT
);

ALTER TABLE team ADD COLUMN role INT REFERENCES team_roles(id);

ALTER TABLE team DROP COLUMN title;

CREATE TABLE team_colaborators (
    colaborator INT,
    mandate INT,
    FOREIGN KEY (colaborator) REFERENCES users(id)
);

INSERT INTO users (id, name, full_name, uu_email, uu_iupi, curriculo, linkedIn, git, permission, created_at) VALUES
    (2132, "Catarina Costa", "Catarina Costa", "", "", "", "", "", "DEFAULT", "2021-06-11"),
    (2133, "Leonardo Almeida", "Leonardo Almeida", "", "", "", "", "", "DEFAULT", "2021-06-11"),
    (2134, "Lucius Filho", "Lucius Vinicius Rocha Machado Filho", "", "", "", "", "", "DEFAULT", "2021-06-11"),
    (2135, "Yanis Faquir", "Yanis Marina Faquir", "", "", "", "", "", "DEFAULT", "2021-06-11"),
    (2136, "Daniel Ferreira", "Daniel Martins Ferreira,", "", "", "", "", "", "DEFAULT", "2021-06-11")
;

INSERT INTO team_colaborators (colaborator, mandate) VALUES
    (2104, 2021), -- Afonso Campos
    (2132, 2021), -- Catarina Costa
    (2136, 2021), -- Daniel Ferreira
    (2033, 2021), -- Diana Oliveira
    (2035, 2021), -- Diogo Monteiro
    (2133, 2021), -- Leonardo Almeida
    (2055, 2021), -- Miguel Ferreira
    (2134, 2021), -- Lucius Filho
    (2058, 2021), -- Paulo Pereira
    (2132, 2021) -- Yanis
;

-- News

ALTER TABLE news ADD COLUMN author INT REFERENCES users(id);

INSERT INTO `users` (`id`, `name`, `full_name`, `uu_email`, `uu_iupi`, `curriculo`, `linkedIn`, `git`, `permission`, `created_at`) VALUES
(1, 'NEI', 'Núcleo de Estudantes de Informática', '', '', '', '', '', '', '2021-04-26');

UPDATE news SET author=1 WHERE 1;

-- Users corrections
UPDATE users SET name="Margarida Martins" WHERE id=1602;
UPDATE users SET name="Alina Yanchuk" WHERE id=879;

UPDATE users SET linkedin="https://www.linkedin.com/in/pedro-figueiredo-9983181ba/" WHERE id=2124;
UPDATE users SET linkedin="https://www.linkedin.com/in/renato-a-l-dias-2919a3195/" WHERE id=2066;
UPDATE users SET linkedin="http://www.linkedin.com/in/daniel-carvalho-a89b1b176" WHERE id=2127;
UPDATE users SET linkedin="https://www.linkedin.com/in/v%C3%ADtor-dias-7b566920a" WHERE id=2075;
UPDATE users SET linkedin="https://www.linkedin.com/in/goncalofmatos/" WHERE id=1275;


UPDATE users SET uu_email="dl.carvalho@ua.pt" WHERE id=2127;

-- Merchandiging
DELETE FROM `merchandisings` WHERE `merchandisings`.`id` = 1; 
DELETE FROM `merchandisings` WHERE `merchandisings`.`id` = 3;
DELETE FROM `merchandisings` WHERE `merchandisings`.`id` = 4;
DELETE FROM `merchandisings` WHERE `merchandisings`.`id` = 5;
DELETE FROM `merchandisings` WHERE `merchandisings`.`id` = 6;
DELETE FROM `merchandisings` WHERE `merchandisings`.`id` = 7;
INSERT INTO merchandisings (name, image, price, number_of_items) VALUES
    ("Cachecol de curso", NULL, 3.5, 0),
    ("Casaco de curso", "/merch/casaco.png", 16.5, 0),
    ("Sweat de curso", "/merch/sweat.png", 18, 0),
    ("Emblema NEI", "/merch/emblemanei.png", 2.25, 0);

-- Static files url change
UPDATE news SET header = REPLACE(header, 'upload/NEI/', '/news/');
UPDATE history SET image = REPLACE(image, '/images/', '/');
UPDATE team SET header = REPLACE(header, 'upload/NEI/', '/');
UPDATE team SET header = REPLACE(header, 'upload/NESI/', '/');
UPDATE rgm SET file = REPLACE(file, '/upload/documents/', '/rgm/');
UPDATE rgm SET file = REPLACE(file, '/RGM_ATAS/', '/ATAS/');
UPDATE faina SET imagem = REPLACE(imagem, '/upload/', '/');
UPDATE seniors SET image = REPLACE(image, '/images/', '/');
UPDATE partners SET header = REPLACE(header, 'upload/patrocinadores/', '/partners/');
UPDATE merchandisings SET image = REPLACE(image, '/upload/', '/');


-- Team was removed, so it was repopulated
INSERT INTO `team_roles` (`id`, `name`, `weight`) VALUES
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


INSERT INTO `team` (`id`, `header`, `mandato`, `user_id`, `role`) VALUES
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
(339, '/team/2021/14.jpg', 2021, 2125, 5);

-- Notes was populated from scratch
INSERT INTO notes_teachers (id, name, personalPage) VALUES
	(1, "José Nuno Panelas Nunes Lau", "https://www.ua.pt/pt/p/10312826"),
	(2, "Diogo Nuno Pereira Gomes", "https://www.ua.pt/pt/p/10331537"),
	(3, "João Paulo Silva Barraca", "https://www.ua.pt/pt/p/10333322"),
	(4, "Carlos Alberto da Costa Bastos", "https://www.ua.pt/pt/p/10312427"),
	(5, "Paulo Jorge dos Santos Gonçalves Ferreira", "https://www.ua.pt/pt/p/10308388"),
	(6, "Pedro Miguel Ribeiro Lavrador", "https://www.ua.pt/pt/p/16606771"),
	(7, "Carlos Manuel Azevedo Costa", "https://www.ua.pt/pt/p/10322010"),
	(8, "Joaquim Manuel Henriques de Sousa Pinto", "https://www.ua.pt/pt/p/10312245"),
	(9, "Maria Beatriz Alves de Sousa Santos", "https://www.ua.pt/pt/p/10306666"),
	(10, "Miguel Augusto Mendes Oliveira e Silva", "https://www.ua.pt/pt/p/10313337"),
	(11, "Tomás António Mendes Oliveira e Silva", "https://www.ua.pt/pt/p/10309907"),
	(12, "José Luis Guimarães Oliveira", "https://www.ua.pt/pt/p/10309676"),
	(13, "Ilídio Fernando de Castro Oliveira", "https://www.ua.pt/pt/p/10318398"),
	(14, "Telmo Reis Cunha", "https://www.ua.pt/pt/p/10322185"),
	(15, "José Manuel Neto Vieira", "https://www.ua.pt/pt/p/10311461"),
	(16, "António Manuel Duarte Nogueira", "https://www.ua.pt/pt/p/10317117"),
	(17, "Joaquim João Estrela Ribeiro Silvestre Madeira", "https://www.ua.pt/en/p/10320092"),
	(18, "Vera Ivanovna Kharlamova", "https://www.ua.pt/pt/p/10317978"),
	(19, "Isabel Alexandra Vieira Brás", "https://www.ua.pt/pt/p/10310747"),
	(20, "Paula Cristina Roque da Silva Rama", "https://www.ua.pt/pt/p/10312567"),
	(21, "António Manuel Rosa Pereira Caetano", "https://www.ua.pt/pt/p/10312455"),
	(22, "José Alexandre da Rocha Almeida", "https://www.ua.pt/pt/p/10316585"),
	(23, "Maria Raquel Rocha Pinto", "https://www.ua.pt/pt/p/10312973"),
	(24, "Mário Fernando dos Santos Ferreira", "https://www.ua.pt/pt/p/10308549"),
	(25, "Helder Troca Zagalo", "https://www.ua.pt/pt/p/10316375"),
	(26, "Ana Maria Perfeito Tomé", "https://www.ua.pt/pt/p/10307429"),
	(27, "João Manuel de Oliveira e Silva Rodrigues", "https://www.ua.pt/pt/p/10314156"),
	(28, "António Joaquim da Silva Teixeira", "https://www.ua.pt/pt/p/10315017"),
	(29, "Vitor José Babau Torres", "https://www.ua.pt/pt/p/10307149"),
	(30, "Luís Filipe de Seabra Lopes", "https://www.ua.pt/pt/p/10314261"),
	(31, "António José Ribeiro Neves", "https://www.ua.pt/pt/p/16606785")
;


INSERT INTO notes_schoolyear (id, yearBegin, yearEnd) VALUES
	(1, 2014, 2015),
	(2, 2017, 2018),
	(3, 2018, 2019),
	(4, 2016, 2017),
	(5, 2015, 2016),
	(6, 2013, 2014)
;


INSERT INTO notes (id, subject, name, location, author, schoolYear, teacher, summary, tests, bibliography, slides, exercises, projects, notebook, content) VALUES
	(1, "40337", "MPEI Exemplo Teste 2014", "/notes/segundo_ano/primeiro_semestre/mpei/MP_Exemplo_Teste.pdf", NULL, 1, 5, 0, 1, 0, 0, 0, 0, 0, NULL),
	(2, "40337", "Diversos - 2017/2018 (zip)", "/notes/segundo_ano/primeiro_semestre/mpei/RafaelDireito_2017_2018_MPEI.zip", 1800, 2, 4, 1, 0, 1, 1, 1, 0, 0, NULL),
	(3, "40337", "Resumos Teóricos (zip)", "/notes/segundo_ano/primeiro_semestre/mpei/Resumos_Teoricas.zip", 1023, 1, 5, 1, 0, 0, 0, 0, 0, 0, NULL),
	(4, "40379", "Resumos FP 2018/2019 (zip)", "/notes/primeiro_ano/primeiro_semestre/fp/Goncalo_FP.zip", 1275, 3, 27, 1, 1, 0, 0, 1, 0, 0, NULL),
	(5, "40379", "Material FP 2016/2017 (zip)", "/notes/primeiro_ano/primeiro_semestre/fp/RafaelDireito_FP_16_17.zip", 1800, 4, NULL, 1, 1, 0, 0, 1, 0, 0, NULL),
	(6, "40379", "Resoluções 18/19", "/notes/primeiro_ano/primeiro_semestre/fp/resolucoes18_19.zip", NULL, 3, NULL, 0, 0, 0, 0, 1, 0, 0, NULL),
	(7, "40380", "Apontamentos Globais", "/notes/primeiro_ano/primeiro_semestre/itw/apontamentos001.pdf", NULL, NULL, 8, 1, 0, 0, 0, 0, 0, 0, NULL),
	(8, "40381", "Questões de SO (zip)", "/notes/segundo_ano/primeiro_semestre/so/Questões.zip", NULL, 5, NULL, 0, 0, 0, 0, 1, 0, 0, NULL),
	(9, "40381", "Diversos - 2017/2018 (zip)", "/notes/segundo_ano/primeiro_semestre/so/RafaelDireito_2017_2018_SO.zip", 1800, 2, 1, 1, 0, 0, 1, 1, 0, 0, NULL),
	(10, "40383", "Apontamentos Diversos (zip)", "/notes/segundo_ano/segundo_semestre/pds/JoaoAlegria_PDS.zip", 1455, 5, 12, 1, 0, 0, 0, 1, 0, 0, NULL),
	(11, "40383", "Resumos de 2015/2016", "/notes/segundo_ano/segundo_semestre/pds/pds_apontamentos_001.pdf", 1455, 5, 12, 1, 0, 0, 0, 0, 0, 0, NULL),
	(12, "40383", "Apontamentos genéricos I", "/notes/segundo_ano/segundo_semestre/pds/pds_apontamentos_002.pdf", NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(13, "40383", "Apontamentos genéricos II", "/notes/segundo_ano/segundo_semestre/pds/pds_apontamentos_003.pdf", NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(14, "40385", "Diversos - CBD Prof. JLO (zip)", "/notes/terceiro_ano/primeiro_semestre/cbd/InesCorreia_CBD(CC_JLO).zip", 1335, NULL, 12, 1, 0, 0, 0, 0, 0, 0, NULL),
	(15, "40431", "MAS 2014/2015 (zip)", "/notes/primeiro_ano/segundo_semestre/mas/BarbaraJael_14_15_MAS.zip", 963, 1, 13, 1, 0, 0, 0, 0, 0, 0, NULL),
	(16, "40431", "Preparação para Exame Final de MAS", "/notes/primeiro_ano/segundo_semestre/mas/Duarte_MAS.pdf", 1182, 3, 13, 1, 0, 0, 0, 0, 0, 0, NULL),
	(17, "40431", "MAS 2016/2017 (zip)", "/notes/primeiro_ano/segundo_semestre/mas/RafaelDireito_2016_2017_MAS.zip", 1800, 4, 13, 1, 0, 1, 1, 0, 0, 0, NULL),
	(18, "40431", "Resumos_MAS", "/notes/primeiro_ano/segundo_semestre/mas/Resumos_MAS_Carina.zip", 1002, 2, 13, 1, 0, 0, 0, 0, 0, 0, NULL),
	(19, "40432", "Resolução das fichas (zip)", "/notes/segundo_ano/primeiro_semestre/smu/Resoluçao_das_fichas.zip", NULL, NULL, NULL, 0, 0, 0, 0, 1, 0, 0, NULL),
	(20, "40432", "Resumos (zip)", "/notes/segundo_ano/primeiro_semestre/smu/Resumo.zip", NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(21, "40432", "Resumos de 2013/2014", "/notes/segundo_ano/primeiro_semestre/smu/smu_apontamentos_001.pdf", 963, 6, 26, 1, 0, 0, 0, 1, 0, 0, NULL),
	(22, "40432", "Resumos de 2016/2017", "/notes/segundo_ano/primeiro_semestre/smu/smu_apontamentos_002.pdf", 1023, 4, 15, 1, 1, 0, 0, 1, 0, 0, NULL),
	(23, "40432", "Resumos de 2017/2018", "/notes/segundo_ano/primeiro_semestre/smu/smu_apontamentos_003.pdf", 1866, 2, 15, 1, 0, 0, 0, 1, 0, 0, NULL),
	(24, "40432", "Resumos 2018/19", "/notes/segundo_ano/primeiro_semestre/smu/SMU_Resumos.pdf", NULL, NULL, NULL, 1, 0, 0, 0, 1, 0, 0, NULL),
	(25, "40433", "Resumos (zip)", "/notes/segundo_ano/primeiro_semestre/rs/Resumo.zip", NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(26, "40433", "Caderno", "/notes/segundo_ano/primeiro_semestre/rs/rs_apontamentos_001.pdf", 963, 1, 16, 1, 0, 0, 0, 1, 0, 1, NULL),
	(27, "40436", "Resumos_POO", "/notes/primeiro_ano/segundo_semestre/poo/Carina_POO_Resumos.zip", 1002, 2, 31, 1, 0, 0, 0, 1, 0, 0, NULL),
	(28, "40436", "Resumos POO 2018/2019 (zip)", "/notes/primeiro_ano/segundo_semestre/poo/Goncalo_POO.zip", 1275, 3, 28, 1, 1, 0, 0, 1, 0, 0, NULL),
	(29, "40436", "Diversos - Prática e Teórica (zip)", "/notes/primeiro_ano/segundo_semestre/poo/RafaelDireito_2016_2017_POO.zip", 1800, 4, NULL, 1, 1, 0, 1, 0, 0, 0, NULL),
	(30, "40436", "Resumos Teóricos (zip)", "/notes/primeiro_ano/segundo_semestre/poo/Resumos.zip", NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(31, "40437", "Resumos de 2016/2017", "/notes/segundo_ano/primeiro_semestre/aed/aed_apontamentos_001.pdf", 1023, 4, 17, 1, 1, 0, 0, 0, 0, 0, NULL),
	(32, "40437", "Bibliografia (zip)", "/notes/segundo_ano/primeiro_semestre/aed/bibliografia.zip", NULL, NULL, NULL, 0, 0, 1, 0, 0, 0, 0, NULL),
	(33, "40751", "Resumos 2016/2017", "/notes/mestrado/aa/aa_apontamentos_001.pdf", 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(34, "40752", "Exames 2017/2018", "/notes/mestrado/tai/tai_apontamentos_001.pdf", 1455, 2, NULL, 0, 1, 0, 0, 0, 0, 0, NULL),
	(35, "40752", "Teste Modelo 2016/2017", "/notes/mestrado/tai/tai_apontamentos_002.pdf", 1455, 4, NULL, 0, 1, 0, 0, 0, 0, 0, NULL),
	(36, "40752", "Ficha de Exercícios 1 - 2016/2017", "/notes/mestrado/tai/tai_apontamentos_003.pdf", 1455, 4, NULL, 0, 0, 0, 0, 1, 0, 0, NULL),
	(37, "40752", "Ficha de Exercícios 2 - 2016/2017", "/notes/mestrado/tai/tai_apontamentos_004.pdf", 1455, 4, NULL, 0, 0, 0, 0, 1, 0, 0, NULL),
	(38, "40753", "Resumos 2016/2017", "/notes/mestrado/cle/cle_apontamentos_001.pdf", 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(39, "40756", "Resumos 2016/2017", "/notes/mestrado/gic/gic_apontamentos_001.pdf", 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(40, "40846", "Resumos 2017/2018", "/notes/terceiro_ano/primeiro_semestre/ia/ia_apontamentos_002.pdf", 1023, 2, 30, 1, 1, 0, 0, 1, 0, 0, NULL),
	(41, "41469", "Aulas Teóricas (zip)", "/notes/segundo_ano/segundo_semestre/c/Aulas_Teóricas.zip", NULL, 5, 10, 0, 0, 0, 1, 0, 0, 0, NULL),
	(42, "41469", "Guião de preparacao para o teste prático (zip)", "/notes/segundo_ano/segundo_semestre/c/Guião_de _preparacao_para_o_teste_pratico.zip", NULL, NULL, NULL, 0, 1, 0, 0, 0, 0, 0, NULL),
	(43, "41549", "Apontamentos Diversos (zip)", "/notes/segundo_ano/segundo_semestre/ihc/Apontamentos.zip", NULL, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, NULL),
	(44, "41549", "Avaliação Heurística", "/notes/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_001.pdf", 1455, 1, 9, 1, 0, 0, 0, 0, 0, 0, NULL),
	(45, "41549", "Resumos de 2014/2015", "/notes/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_002.pdf", 963, 1, 9, 1, 0, 0, 0, 0, 0, 0, NULL),
	(46, "41549", "Resolução de fichas (zip)", "/notes/segundo_ano/segundo_semestre/ihc/Resolução_de_fichas.zip", NULL, NULL, 9, 0, 0, 0, 0, 1, 0, 0, NULL),
	(47, "41791", "Apontamentos EF (zip)", "/notes/primeiro_ano/primeiro_semestre/ef/BarbaraJael_EF.zip", 963, 1, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(48, "41791", "Exercícios 2017/2018", "/notes/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_001.pdf", 1800, 2, 24, 0, 1, 0, 0, 0, 0, 0, NULL),
	(49, "41791", "Exercícios 2016/17", "/notes/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_002.pdf", 1800, 4, NULL, 0, 0, 0, 0, 1, 0, 0, NULL),
	(50, "41791", "Resumos EF 2018/2019 (zip)", "/notes/primeiro_ano/primeiro_semestre/ef/Goncalo_EF.zip", 1275, 3, 29, 0, 0, 0, 0, 1, 0, 0, NULL),
	(51, "41791", "Exercícios 2018/19", "/notes/primeiro_ano/primeiro_semestre/ef/Pedro_Oliveira_2018_2019.zip", 1764, 3, 29, 0, 1, 0, 0, 1, 0, 0, NULL),
	(52, "42502", "Apontamentos e Resoluções (zip)", "/notes/primeiro_ano/segundo_semestre/iac/PedroOliveira.zip", 1764, 2, 6, 0, 1, 0, 0, 1, 0, 0, NULL),
	(53, "42532", "Caderno - 2016/2017", "/notes/segundo_ano/segundo_semestre/bd/bd_apontamentos_001.pdf", 1023, 4, 7, 1, 0, 0, 0, 1, 0, 1, NULL),
	(54, "42532", "Resumos - 2014/2015", "/notes/segundo_ano/segundo_semestre/bd/bd_apontamentos_002.pdf", 1455, 1, 7, 1, 0, 0, 0, 0, 0, 0, NULL),
	(55, "42532", "Resumos globais", "/notes/segundo_ano/segundo_semestre/bd/BD_Resumos.pdf", NULL, NULL, 7, 1, 0, 0, 0, 0, 0, 0, NULL),
	(56, "42532", "Slides das Aulas Teóricas (zip)", "/notes/segundo_ano/segundo_semestre/bd/Slides_Teoricas.zip", NULL, 1, 7, 0, 0, 0, 1, 0, 0, 0, NULL),
	(57, "42573", "Outros Resumos (zip)", "/notes/terceiro_ano/primeiro_semestre/sio/Outros_Resumos.zip", NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(58, "42573", "Resumo geral de segurança I", "/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_001.pdf", NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(59, "42573", "Resumo geral de segurança II", "/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_002.pdf", NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(60, "42573", "Resumos de 2015/2016", "/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_003.pdf", 963, 5, 3, 1, 0, 0, 0, 0, 0, 0, NULL),
	(61, "42573", "Resumo geral de segurança III", "/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_004.pdf", NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(62, "42573", "Apontamentos genéricos", "/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_005.pdf", NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(63, "42709", "Resumos de ALGA (zip)", "/notes/primeiro_ano/primeiro_semestre/alga/Carolina_Albuquerque_ALGA.zip", 1023, 5, 23, 1, 0, 0, 0, 1, 0, 0, NULL),
	(64, "42709", "ALGA 2017/2018 (zip)", "/notes/primeiro_ano/primeiro_semestre/alga/DiogoSilva_17_18_ALGA.zip", 1161, 2, 23, 0, 0, 0, 0, 0, 0, 0, NULL),
	(65, "42709", "Resumos ALGA 2018/2019 (zip)", "/notes/primeiro_ano/primeiro_semestre/alga/Goncalo_ALGA.zip", 1275, 3, 19, 1, 0, 0, 0, 0, 0, 0, NULL),
	(66, "42728", "Resumos 2016/2017", "/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_001.pdf", 1719, 4, 21, 1, 0, 0, 0, 0, 0, 0, NULL),
	(67, "42728", "Resumos 2016/2017", "/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_002.pdf", 1866, 4, 21, 1, 0, 0, 0, 0, 0, 0, NULL),
	(68, "42728", "Teste Primitivas 2016/2017", "/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_003.pdf", 1800, 4, 21, 0, 1, 0, 0, 0, 0, 0, NULL),
	(69, "42728", "Exercícios 2016/2017", "/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_004.pdf", 1800, 4, 21, 0, 0, 0, 0, 1, 0, 0, NULL),
	(70, "42728", "Resumos 2016/2017", "/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_005.pdf", 1800, 4, 21, 1, 0, 0, 0, 0, 0, 0, NULL),
	(71, "42728", "Fichas 2016/2017", "/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_006.pdf", 1800, 4, 21, 0, 0, 0, 0, 1, 0, 0, NULL),
	(72, "42728", "CI 2017/2018 (zip)", "/notes/primeiro_ano/primeiro_semestre/c1/DiogoSilva_17_18_C1.zip", 1161, 2, 21, 1, 0, 0, 0, 0, 0, 0, NULL),
	(73, "42728", "Resumos Cálculo I 2018/2019 (zip)", "/notes/primeiro_ano/primeiro_semestre/c1/Goncalo_C1.zip", 1275, 3, 18, 1, 0, 0, 0, 0, 0, 0, NULL),
	(74, "42729", "Caderno de 2016/2017", "/notes/primeiro_ano/segundo_semestre/c2/calculoii_apontamentos_003.pdf", 1719, 4, 22, 0, 0, 0, 0, 0, 0, 1, NULL),
	(75, "42729", "Resumos Cálculo II 2018/2019 (zip)", "/notes/primeiro_ano/segundo_semestre/c2/Goncalo_C2.zip", 1275, 3, 19, 1, 0, 0, 0, 0, 0, 0, NULL),
	(76, "44156", "Resumos 2016/2017", "/notes/mestrado/vi/vi_apontamentos_001.pdf", 1455, 4, 9, 1, 0, 0, 0, 0, 0, 0, NULL),
	(77, "44158", "Resumos por capítulo (zip)", "/notes/mestrado/ws/JoaoAlegria_ResumosPorCapítulo.zip", 1455, 4, 25, 1, 0, 0, 0, 0, 0, 0, NULL),
	(78, "44158", "Resumos 2016/2017", "/notes/mestrado/ws/web_semantica_apontamentos_001.pdf", 1455, 4, 25, 1, 0, 0, 0, 0, 0, 0, NULL),
	(79, "45424", "Apontamentos Diversos", "/notes/terceiro_ano/primeiro_semestre/icm/Inês_Correia_ICM.pdf", 1335, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(80, "45426", "Apontamentos Diversos", "/notes/terceiro_ano/segundo_semestre/tqs/Inês_Correia_TQS.pdf", 1335, 4, 13, 1, 0, 0, 0, 0, 0, 0, NULL),
	(81, "45426", "Resumos (zip)", "/notes/terceiro_ano/segundo_semestre/tqs/resumos.zip", NULL, 4, 13, 1, 0, 0, 0, 0, 0, 0, NULL),
	(82, "45426", "Resumos 2015/2016", "/notes/terceiro_ano/segundo_semestre/tqs/tqs_apontamentos_002.pdf", 1455, 5, 13, 1, 0, 0, 0, 0, 0, 0, NULL),
	(83, "45587", "Resumos 2017/2018 - I", "/notes/mestrado/ed/ed_dm_apontamentos_001.pdf", 1455, 4, 26, 1, 0, 0, 0, 0, 0, 0, NULL),
	(84, "45587", "Resumos 2017/2018 - II", "/notes/mestrado/ed/ed_dm_apontamentos_002.pdf", 1455, 4, 26, 1, 0, 0, 0, 0, 0, 0, NULL),
	(85, "47166", "Resumos MD 2018/2019 (zip)", "/notes/primeiro_ano/segundo_semestre/md/Goncalo_MD.zip", 1275, 3, 20, 1, 0, 0, 0, 0, 0, 0, NULL),
	(86, "47166", "Resumos 2017/2018", "/notes/primeiro_ano/segundo_semestre/md/MD_Capitulo5.pdf", 1002, 2, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(87, "47166", "RafaelDireito_2016_2017_MD.zip", "/notes/primeiro_ano/segundo_semestre/md/RafaelDireito_2016_2017_MD.zip", 1800, 4, NULL, 0, 0, 0, 0, 1, 0, 0, NULL),
	(88, "47166", "RafaelDireito_MD_16_17_Apontamentos (zip)", "/notes/primeiro_ano/segundo_semestre/md/RafaelDireito_MD_16_17_Apontamentos.zip", 1800, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(89, "40337", "DS_MPEI_18_19_Testes (zip)", "/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Testes.zip", 1161, 3, 4, 0, 1, 0, 0, 0, 0, 0, NULL),
	(90, "40337", "DS_MPEI_18_19_SlidesTeoricos (zip)", "/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_SlidesTeoricos.zip", 1161, 3, 4, 0, 0, 0, 1, 0, 0, 0, NULL),
	(91, "40337", "DS_MPEI_18_19_Resumos (zip)", "/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Resumos.zip", 1161, 3, 4, 1, 0, 0, 0, 0, 0, 0, NULL),
	(92, "40337", "DS_MPEI_18_19_Projeto (zip)", "/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Projeto.zip", 1161, 3, 4, 0, 0, 0, 0, 0, 1, 0, NULL),
	(93, "40337", "DS_MPEI_18_19_Praticas (zip)", "/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Praticas.zip", 1161, 3, 4, 0, 0, 0, 0, 1, 0, 0, NULL),
	(94, "40337", "DS_MPEI_18_19_Livros (zip)", "/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Livros.zip", 1161, 3, 4, 0, 0, 1, 0, 0, 0, 0, NULL),
	(95, "40337", "DS_MPEI_18_19_Exercicios (zip)", "/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Exercicios.zip", 1161, 3, 4, 0, 0, 0, 0, 1, 0, 0, NULL),
	(96, "40380", "Goncalo_ITW_18_19_Testes (zip)", "/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Testes.zip", 1275, 3, 8, 0, 1, 0, 0, 0, 0, 0, NULL),
	(97, "40380", "Goncalo_ITW_18_19_Resumos (zip)", "/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Resumos.zip", 1275, 3, 8, 1, 0, 0, 0, 0, 0, 0, NULL),
	(98, "40380", "Goncalo_ITW_18_19_Projeto (zip)", "/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Projeto.zip", 1275, 3, 8, 0, 0, 0, 0, 0, 1, 0, NULL),
	(99, "40380", "Goncalo_ITW_18_19_Praticas (zip)", "/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Praticas.zip", 1275, 3, 8, 0, 0, 0, 0, 1, 0, 0, NULL),
	(100, "40380", "RafaelDireito_ITW_18_19_Testes (zip)", "/notes/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Testes.zip", 1800, 4, 8, 0, 1, 0, 0, 0, 0, 0, NULL),
	(101, "40380", "RafaelDireito_ITW_18_19_Slides (zip)", "/notes/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Slides.zip", 1800, 4, 8, 0, 0, 0, 1, 0, 0, 0, NULL),
	(102, "40380", "RafaelDireito_ITW_18_19_Praticas (zip)", "/notes/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Praticas.zip", 1800, 4, 8, 0, 0, 0, 0, 1, 0, 0, NULL),
	(103, "40381", "DS_SO_18_19_Testes (zip)", "/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Testes.zip", 1161, 3, 1, 0, 1, 0, 0, 0, 0, 0, NULL),
	(104, "40381", "DS_SO_18_19_SlidesTeoricos (zip)", "/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_SlidesTeoricos.zip", 1161, 3, 1, 0, 0, 0, 1, 0, 0, 0, NULL),
	(105, "40381", "DS_SO_18_19_ResumosTeoricos (zip)", "/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_ResumosTeoricos.zip", 1161, 3, 1, 1, 0, 0, 0, 0, 0, 0, NULL),
	(106, "40381", "DS_SO_18_19_ResumosPraticos (zip)", "/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_ResumosPraticos.zip", 1161, 3, 1, 1, 0, 0, 0, 0, 0, 0, NULL),
	(107, "40381", "DS_SO_18_19_Praticas (zip)", "/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Praticas.zip", 1161, 3, 1, 0, 0, 0, 0, 1, 0, 0, NULL),
	(108, "40381", "DS_SO_18_19_Fichas (zip)", "/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Fichas.zip", 1161, 3, 1, 0, 0, 0, 0, 1, 0, 0, NULL),
	(109, "40382", "CD_18_19_Livros (zip)", "/notes/segundo_ano/segundo_semestre/cd/CD_18_19_Livros.zip", NULL, NULL, NULL, 0, 0, 1, 0, 0, 0, 0, NULL),
	(110, "40382", "DS_CD_18_19_SlidesTeoricos (zip)", "/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_SlidesTeoricos.zip", 1161, 3, 2, 0, 0, 0, 1, 0, 0, 0, NULL),
	(111, "40382", "DS_CD_18_19_Resumos (zip)", "/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Resumos.zip", 1161, 3, 2, 1, 0, 0, 0, 0, 0, 0, NULL),
	(112, "40382", "DS_CD_18_19_Projetos (zip)", "/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Projetos.zip", 1161, 3, 2, 0, 0, 0, 0, 0, 1, 0, NULL),
	(113, "40382", "DS_CD_18_19_Praticas (zip)", "/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Praticas.zip", 1161, 3, 2, 0, 0, 0, 0, 1, 0, 0, NULL),
	(114, "40383", "DS_PDS_18_19_Testes (zip)", "/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Testes.zip", 1161, 3, 12, 0, 1, 0, 0, 0, 0, 0, NULL),
	(115, "40383", "DS_PDS_18_19_SlidesTeoricos (zip)", "/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_SlidesTeoricos.zip", 1161, 3, 12, 0, 0, 0, 1, 0, 0, 0, NULL),
	(116, "40383", "DS_PDS_18_19_Resumos (zip)", "/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Resumos.zip", 1161, 3, 12, 1, 0, 0, 0, 0, 0, 0, NULL),
	(117, "40383", "DS_PDS_18_19_Praticas (zip)", "/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Praticas.zip", 1161, 3, 12, 0, 0, 0, 0, 1, 0, 0, NULL),
	(118, "40431", "MAS_18_19_Bibliografia (zip)", "/notes/primeiro_ano/segundo_semestre/mas/MAS_18_19_Bibliografia.zip", NULL, NULL, NULL, 0, 0, 1, 0, 0, 0, 0, NULL),
	(119, "40431", "MAS_18_19_Topicos_Estudo_Exame (zip)", "/notes/primeiro_ano/segundo_semestre/mas/MAS_18_19_Topicos_Estudo_Exame.zip", NULL, 3, 13, 0, 1, 0, 0, 0, 0, 0, NULL),
	(120, "40431", "Goncalo_MAS_18_19_Resumos (zip)", "/notes/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Resumos.zip", 1275, 3, 13, 1, 0, 0, 0, 0, 0, 0, NULL),
	(121, "40431", "Goncalo_MAS_18_19_Projeto (zip)", "/notes/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Projeto.zip", 1275, 3, 13, 0, 0, 0, 0, 0, 1, 0, NULL),
	(122, "40431", "Goncalo_MAS_18_19_Praticas (zip)", "/notes/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Praticas.zip", 1275, 3, 13, 0, 0, 0, 0, 1, 0, 0, NULL),
	(123, "40432", "RafaelDireito_SMU_17_18_Praticas (zip)", "/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Praticas.zip", 1800, 2, 15, 0, 0, 0, 0, 1, 0, 0, NULL),
	(124, "40432", "RafaelDireito_SMU_17_18_TP (zip)", "/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_TP.zip", 1800, 2, 15, 0, 0, 0, 1, 0, 0, 0, NULL),
	(125, "40432", "RafaelDireito_SMU_17_18_Prep2Test (zip)", "/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Prep2Teste.zip", 1800, 2, 15, 0, 1, 0, 0, 0, 0, 0, NULL),
	(126, "40432", "RafaelDireito_SMU_17_18_Bibliografia (zip)", "/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Bibliografia.zip", 1800, 2, 15, 0, 0, 1, 0, 0, 0, 0, NULL),
	(127, "40432", "DS_SMU_18_19_Fichas (zip)", "/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Fichas.zip", 1161, 3, 14, 0, 0, 0, 0, 1, 0, 0, NULL),
	(128, "40432", "DS_SMU_18_19_Livros (zip)", "/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Livros.zip", 1161, 3, 14, 0, 0, 1, 0, 0, 0, 0, NULL),
	(129, "40432", "DS_SMU_18_19_SlidesTeoricos (zip)", "/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_SlidesTeoricos.zip", 1161, 3, 14, 0, 0, 0, 1, 0, 0, 0, NULL),
	(130, "40432", "DS_SMU_18_19_Praticas (zip)", "/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Praticas.zip", 1161, 3, 14, 0, 0, 0, 0, 1, 0, 0, NULL),
	(131, "40432", "DS_SMU_18_19_Resumos (zip)", "/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Resumos.zip", 1161, 3, 14, 1, 0, 0, 0, 0, 0, 0, NULL),
	(132, "40432", "DS_SMU_18_19_Testes (zip)", "/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Testes.zip", 1161, 3, 14, 0, 1, 0, 0, 0, 0, 0, NULL),
	(133, "40433", "DS_RS_18_19_Testes (zip)", "/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Testes.zip", 1161, 3, 16, 0, 1, 0, 0, 0, 0, 0, NULL),
	(134, "40433", "DS_RS_18_19_Praticas (zip)", "/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Praticas.zip", 1161, 3, 16, 0, 0, 0, 0, 1, 0, 0, NULL),
	(135, "40433", "DS_RS_18_19_SlidesTeoricos (zip)", "/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_SlidesTeoricos.zip", 1161, 3, 16, 0, 0, 0, 1, 0, 0, 0, NULL),
	(136, "40433", "DS_RS_18_19_Resumos (zip)", "/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Resumos.zip", 1161, 3, 16, 1, 0, 0, 0, 0, 0, 0, NULL),
	(137, "40437", "DS_AED_18_19_Resumos (zip)", "/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Resumos.zip", 1161, 3, 11, 1, 0, 0, 0, 0, 0, 0, NULL),
	(138, "40437", "DS_AED_18_19_Livros (zip)", "/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Livros.zip", 1161, 3, 11, 0, 0, 1, 0, 0, 0, 0, NULL),
	(139, "40437", "DS_AED_18_19_Testes (zip)", "/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Testes.zip", 1161, 3, 11, 0, 1, 0, 0, 0, 0, 0, NULL),
	(140, "40437", "DS_AED_18_19_Praticas (zip)", "/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Praticas.zip", 1161, 3, 11, 0, 0, 0, 0, 1, 0, 0, NULL),
	(141, "40437", "DS_AED_18_19_SlidesTeoricos (zip)", "/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_SlidesTeoricos.zip", 1161, 3, 11, 0, 0, 0, 1, 0, 0, 0, NULL),
	(142, "40437", "DS_AED_18_19_Fichas (zip)", "/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Fichas.zip", 1161, 3, 11, 0, 0, 0, 0, 1, 0, 0, NULL),
	(143, "40437", "RafaelDireito_AED_17_18_Praticas (zip)", "/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Praticas.zip", 1800, 2, 31, 0, 0, 0, 0, 1, 0, 0, NULL),
	(144, "40437", "RafaelDireito_AED_17_18_Testes (zip)", "/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Testes.zip", 1800, 2, 31, 0, 1, 0, 0, 0, 0, 0, NULL),
	(145, "40437", "RafaelDireito_AED_17_18_Books (zip)", "/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Praticas.zip", 1800, 2, 31, 0, 0, 1, 0, 0, 0, 0, NULL),
	(146, "40437", "RafaelDireito_AED_17_18_LearningC (zip)", "/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_LearningC.zip", 1800, 2, 31, 0, 0, 0, 0, 1, 0, 0, NULL),
	(147, "40437", "RafaelDireito_AED_17_18_AED (pdf)", "/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_AED.pdf", 1800, 2, 31, 0, 0, 0, 1, 0, 0, 0, NULL),
	(148, "41469", "DS_Compiladores_18_19_Praticas (zip)", "/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Praticas.zip", 1161, 3, 10, 0, 0, 0, 0, 1, 0, 0, NULL),
	(149, "41469", "DS_Compiladores_18_19_Fichas (zip)", "/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Fichas.zip", 1161, 3, 10, 0, 0, 0, 0, 1, 0, 0, NULL),
	(150, "41469", "DS_Compiladores_18_19_Testes (zip)", "/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Testes.zip", 1161, 3, 10, 0, 1, 0, 0, 0, 0, 0, NULL),
	(151, "41469", "DS_Compiladores_18_19_Resumos (zip)", "/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Resumos.zip", 1161, 3, 10, 1, 0, 0, 0, 0, 0, 0, NULL),
	(152, "41469", "DS_Compiladores_18_19_SlidesTeoricos (zip)", "/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_SlidesTeoricos.zip", 1161, 3, 10, 0, 0, 0, 1, 0, 0, 0, NULL),
	(153, "41549", "DS_IHC_18_19_SlidesTeoricos (zip)", "/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_SlidesTeoricos.zip", 1161, 3, 9, 0, 0, 0, 1, 0, 0, 0, NULL),
	(154, "41549", "DS_IHC_18_19_Fichas (zip)", "/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_Fichas.zip", 1161, 3, 9, 0, 0, 0, 0, 1, 0, 0, NULL),
	(155, "41549", "DS_IHC_18_19_Projetos (zip)", "/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_Projetos.zip", 1161, 3, 9, 0, 0, 0, 0, 0, 1, 0, NULL),
	(156, "41549", "DS_IHC_18_19_Testes (zip)", "/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_SlidesTeoricos.zip", 1161, 3, 9, 0, 1, 0, 0, 0, 0, 0, NULL),
	(157, "40846", "Resumos (zip)", "/notes/terceiro_ano/primeiro_semestre/ia/resumo.zip", NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(158, "41549", "DS_EF_17_18_Resumos (zip)", "/notes/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Resumos.zip", 1161, 2, 24, 1, 0, 0, 0, 0, 0, 0, NULL),
	(159, "41549", "DS_EF_17_18_Exercicios (zip)", "/notes/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Exercicios.zip", 1161, 2, 24, 0, 0, 0, 0, 1, 0, 0, NULL),
	(160, "41549", "DS_EF_17_18_Exames (zip)", "/notes/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Exames.zip", 1161, 2, 24, 0, 1, 0, 0, 0, 0, 0, NULL),
	(161, "42502", "Exames (zip)", "/notes/primeiro_ano/segundo_semestre/iac/exames.zip", NULL, NULL, 6, 0, 1, 0, 0, 0, 0, 0, NULL),
	(162, "42502", "Goncalo_IAC_18_19_Praticas (zip)", "/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Praticas.zip", 1275, 3, 6, 0, 0, 0, 0, 1, 0, 0, NULL),
	(163, "42502", "Goncalo_IAC_18_19_Resumos (zip)", "/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Resumos.zip", 1275, 3, 6, 1, 0, 0, 0, 0, 0, 0, NULL),
	(164, "42502", "Goncalo_IAC_18_19_Apontamentos (zip)", "/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Apontamentos.zip", 1275, 3, 6, 1, 0, 0, 0, 0, 0, 0, NULL),
	(165, "42502", "Goncalo_IAC_18_19_Bibliografia (zip)", "/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Bibliografia.zip", 1275, 3, 6, 0, 0, 1, 0, 0, 0, 0, NULL),
	(166, "42502", "Goncalo_IAC_18_19_Testes (zip)", "/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Testes.zip", 1275, 3, 6, 0, 1, 0, 0, 0, 0, 0, NULL),
	(167, "42502", "RafaelDireito_IAC_16_17_Testes (zip)", "/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Testes.zip", 1800, 4, 6, 0, 1, 0, 0, 0, 0, 0, NULL),
	(168, "42502", "RafaelDireito_IAC_16_17_Teorica (zip)", "/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Teorica.zip", 1800, 4, 6, 1, 0, 0, 0, 0, 0, 0, NULL),
	(169, "42502", "RafaelDireito_IAC_16_17_FolhasPraticas (zip)", "/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_FolhasPraticas.zip", 1800, 4, 6, 0, 0, 0, 0, 1, 0, 0, NULL),
	(170, "42502", "RafaelDireito_IAC_16_17_ExerciciosResolvidos (zip)", "/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_ExerciciosResolvidos.zip", 1800, 4, 6, 0, 0, 0, 0, 1, 0, 0, NULL),
	(171, "42502", "RafaelDireito_IAC_16_17_Resumos (zip)", "/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Resumos.zip", 1800, 4, 6, 1, 0, 0, 0, 0, 0, 0, NULL),
	(172, "42502", "RafaelDireito_IAC_16_17_DossiePedagogicov2 (zip)", "/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_DossiePedagogicov2.zip", 1800, 4, 6, 0, 0, 0, 1, 0, 0, 0, NULL),
	(173, "42532", "DS_BD_18_19_SlidesTeoricos (zip)", "/notes/segundo_ano/segundo_semestre/bd/DS_BD_18_19_SlidesTeoricos.zip", 1161, 3, 7, 0, 0, 0, 1, 0, 0, 0, NULL),
	(174, "42532", "DS_BD_18_19_Resumos (zip)", "/notes/segundo_ano/segundo_semestre/bd/DS_BD_18_19_Resumos.zip", 1161, 3, 7, 1, 0, 0, 0, 0, 0, 0, NULL),
	(175, "42532", "DS_BD_18_19_Praticas (zip)", "/notes/segundo_ano/segundo_semestre/bd/DS_BD_18_19_Praticas.zip", 1161, 3, 7, 0, 0, 0, 0, 1, 0, 0, NULL),
	(176, "42532", "Resumos Diversos (zip)", "/notes/segundo_ano/segundo_semestre/bd/Resumos.zip", NULL, NULL, NULL, 1, 0, 0, 0, 1, 0, 0, NULL),
	(177, "41791", "Resumos EF", "/notes/primeiro_ano/primeiro_semestre/ef/CarolinaAlbuquerque_EF_Resumo.pdf", 1023, 5, 24, 1, 0, 0, 0, 0, 0, 0, NULL),
	(178, "41791", "Resolução Fichas EF", "/notes/primeiro_ano/primeiro_semestre/ef/CarolinaAlbuquerque_EF_ResolucoesFichas.zip", 1023, 5, 24, 0, 0, 0, 0, 1, 0, 0, NULL),
	(179, "42573", "Exames SIO resolvidos", "/notes/terceiro_ano/primeiro_semestre/sio/JoaoAlegria_Exames.zip", 1455, 4, NULL, 0, 1, 0, 0, 0, 0, 0, NULL),
	(180, "42573", "Resumos SIO", "/notes/terceiro_ano/primeiro_semestre/sio/JoaoAlegria_Resumos.zip", 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(181, "42709", "Exames e testes ALGA", "/notes/primeiro_ano/primeiro_semestre/alga/Rafael_Direito_Exames.zip", 1800, 4, 23, 0, 1, 0, 0, 0, 0, 0, NULL),
	(182, "42709", "Fichas resolvidas ALGA", "/notes/primeiro_ano/primeiro_semestre/alga/RafaelDireito_Fichas.pdf", 1800, 4, 23, 0, 0, 0, 0, 1, 0, 0, NULL),
	(183, "42709", "Resumos ALGA ", "/notes/primeiro_ano/primeiro_semestre/alga/RafelDireito_Resumos.pdf", 1800, 4, 23, 1, 0, 0, 0, 0, 0, 0, NULL),
	(184, "42728", "Caderno de cálculo", "/notes/primeiro_ano/primeiro_semestre/c1/CarolinaAlbuquerque_C1_caderno.pdf", 1023, 5, 19, 0, 0, 0, 0, 0, 0, 1, NULL),
	(185, "42729", "Fichas resolvidas CII", "/notes/primeiro_ano/segundo_semestre/c2/PedroOliveira_Fichas.zip", 1764, 3, 19, 0, 0, 0, 0, 1, 0, 0, NULL),
	(186, "42729", "Testes CII", "/notes/primeiro_ano/segundo_semestre/c2/PedroOliveira_testes-resol.zip", 1764, 3, 19, 0, 1, 0, 0, 0, 0, 0, NULL),
	(187, "45424", "Apontamentos Gerais ICM", "/notes/terceiro_ano/primeiro_semestre/icm/Resumo Geral Android.pdf", 1335, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(188, "47166", "Resoluções material apoio MD", "/notes/primeiro_ano/segundo_semestre/md/PedroOliveira_EA.zip", 1764, 3, 20, 0, 0, 0, 0, 1, 0, 0, NULL),
	(189, "47166", "Resoluções fichas MD", "/notes/primeiro_ano/segundo_semestre/md/PedroOliveira_Fichas.zip", 1764, 3, 20, 0, 0, 0, 0, 1, 0, 0, NULL),
	(190, "47166", "Resoluções testes MD", "/notes/primeiro_ano/segundo_semestre/md/PedroOliveira_testes.zip", 1764, 3, 20, 0, 1, 0, 0, 0, 0, 0, NULL),
	(191, "40433", "Estudo para o exame", "/notes/segundo_ano/primeiro_semestre/rs/RafaelDireito_2017_RSexame.pdf", 1800, 2, 4, 1, 0, 0, 0, 0, 0, 0, NULL),
	(192, "40551", "Exercícios TPW", "/notes/terceiro_ano/segundo_semestre/tpw/Exercicios.zip", NULL, NULL, NULL, 0, 0, 0, 0, 1, 0, 0, NULL),
	(193, "40757", "Resumos 2016/2017", "/notes/mestrado/as/as_apontamentos_001.pdf", 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(194, "40757", "Resumos por capítulo (zip)", "/notes/mestrado/as/JoaoAlegria_ResumosPorCapitulo.zip", 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL),
	(195, "40846", "Exercícios IA", "/notes/terceiro_ano/primeiro_semestre/ia/Inês_Correia_IA_exercícios.pdf", 1335, NULL, NULL, 0, 0, 0, 0, 1, 0, 0, NULL),
	(196, "40846", "Resumos IA", "/notes/terceiro_ano/primeiro_semestre/ia/Inês_Correia_IA_resumo.pdf", 1335, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL)
;
