-- Changes to data model

-- Partners
UPDATE TABLE partners SET header=CONCAT("upload",header);

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

-- Create table for seniors
CREATE TABLE seniors (
    year INT, 
    course VARCHAR(3),
    image VARCHAR(255),
    PRIMARY KEY (year, course)
)

INSERT INTO seniors (year, course, image) VALUES
    (2020, "LEI", "/images/seniors/LEI/2020.jpg"),
    (2020, "MEI", "/images/seniors/MEI/2020.jpg")
;

CREATE TABLE seniors_students (
    year INT,
    course VARCHAR(3),
    userId INT,
    FOREIGN KEY (year, course) REFERENCES seniors(year, course),
    FOREIGN KEY (userId) REFERENCES users(id),
    PRIMARY KEY (year, course, userId)
)

INSERT INTO seniors_students (course, year, userId) VALUES
    ("LEI", 2020, 873),
    ("LEI", 2020, 900),
    ("LEI", 2020, 1545),
    ("LEI", 2020, 1362),
    ("LEI", 2020, 879),
    ("MEI", 2020, 1059)
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

INSERT INTO faina_member(year, role, member) VALUES
    (2017, 10, 984),
    (2017, 4, 1704),
    (2017, 7, 1107),
    (2018, 2, 1002),
    (2018, 1, 900),
    (2018, 4, 1902),
    (2019, 10, 1365),
    (2019, 7, 1419),
    (2019, 7, 1512)
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

-- News

ALTER TABLE news ADD COLUMN author INT REFERENCES users(id);

INSERT INTO `users` (`id`, `name`, `full_name`, `uu_email`, `uu_iupi`, `curriculo`, `linkedIn`, `git`, `permission`, `created_at`) VALUES
(1, 'NEI', 'Núcleo de Estudantes de Informática', '', '', '', '', '', '', '2021-04-26');

UPDATE news SET author=1 WHERE 1;
