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
)

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
    yearEnd SMALLINT(4),
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

UPDATE faina SET anoLetivo="2011/2012" WHERE mandato=2012;
UPDATE faina SET anoLetivo="2012/2013" WHERE mandato=2013;
UPDATE faina SET anoLetivo="2013/2014" WHERE mandato=2014;
UPDATE faina SET anoLetivo="2014/2015" WHERE mandato=2015;
UPDATE faina SET anoLetivo="2015/2016" WHERE mandato=2016;
UPDATE faina SET anoLetivo="2016/2017" WHERE mandato=2017;
UPDATE faina SET anoLetivo="2017/2018" WHERE mandato=2018;
UPDATE faina SET anoLetivo="2018/2019" WHERE mandato=2019;

INSERT INTO faina (mandato, imagem, anoLetivo) VALUES
    (2020, NULL, "2019/2020"),
    (2021, NULL, "2020/2021")
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
