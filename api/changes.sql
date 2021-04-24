-- Changes to data model

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