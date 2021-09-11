-- NEI SUMMER BUILD
-- https://github.com/NEI-AAUAV/Website/projects/2

-- ISSUE 49 // https://github.com/NEI-AAUAV/Website/issues/49

ALTER TABLE seniors_students ADD quote VARCHAR(280); -- Like Twitter
ALTER TABLE seniors_students ADD image VARCHAR(255);

INSERT INTO `seniors` (`year`, `course`, `image`) VALUES ('2021', 'LEI', NULL);
INSERT INTO `seniors` (`year`, `course`, `image`) VALUES ('2021', 'MEI', NULL);

-- carolinaalbuquerque@ua.pt
INSERT INTO `seniors_students` (`year`, `course`, `userId`, `quote`, `image`) VALUES ('2021', 'MEI', '1023', '<h1>Fun fact: #EAAA00</h1>', '/seniors/mei/2021/1023.jpg'); 
-- hugofpaiva@ua.pt
INSERT INTO `seniors_students` (`year`, `course`, `userId`, `quote`, `image`) VALUES ('2021', 'LEI', '1329', NULL, '/seniors/lei/2021/1329.jpg'); 
-- carolina.araujo00@ua.pt
INSERT INTO `seniors_students` (`year`, `course`, `userId`, `quote`, `image`) VALUES ('2021', 'LEI', '1020', 'Level up', '/seniors/lei/2021/1020.jpg'); 
-- joaots@ua.pt
INSERT INTO `seniors_students` (`year`, `course`, `userId`, `quote`, `image`) VALUES ('2021', 'LEI', '1461', 'Simplesmente viciado em café e futebol', '/seniors/lei/2021/1461.jpg'); 
-- pedro.bas@ua.pt
INSERT INTO `seniors_students` (`year`, `course`, `userId`, `quote`, `image`) VALUES ('2021', 'LEI', '1716', 'Há tempo para tudo na vida académica!', '/seniors/lei/2021/1716.jpg'); 
-- ricardo.cruz29@ua.pt 
INSERT INTO `seniors_students` (`year`, `course`, `userId`, `quote`, `image`) VALUES ('2021', 'LEI', '1827', 'Melhorias = Mito', '/seniors/lei/2021/1827.jpg'); 
-- eduardosantoshf@ua.pt
INSERT INTO `seniors_students` (`year`, `course`, `userId`, `quote`, `image`) VALUES ('2021', 'LEI', '1200', 'Já dizia a minha avó: "O meu neto não bebe álcool"', '/seniors/lei/2021/1200.jpg'); 
-- margarida.martins@ua.pt
INSERT INTO `seniors_students` (`year`, `course`, `userId`, `quote`, `image`) VALUES ('2021', 'LEI', '1602', 'MD é fixe.', '/seniors/lei/2021/1602.jpg'); 
-- diogobento@ua.pt
INSERT INTO `seniors_students` (`year`, `course`, `userId`, `quote`, `image`) VALUES ('2021', 'LEI', '1164', 'Mal posso esperar para ver o que se segue', '/seniors/lei/2021/1164.jpg'); 
-- gmatos.ferreira@ua.pt
INSERT INTO `seniors_students` (`year`, `course`, `userId`, `quote`, `image`) VALUES ('2021', 'LEI', '1275', NULL, '/seniors/lei/2021/1275.jpg'); 

-- ISSUE 53 https://github.com/NEI-AAUAV/Website/issues/53

CREATE TABLE notes_types (
    id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(40), 
    download_caption VARCHAR(40),
    icon_display VARCHAR(40),
    icon_download VARCHAR(40),
    external BOOLEAN DEFAULT FALSE        -- Stored in NEI server?
);

ALTER TABLE notes ADD type INT NOT NULL;

INSERT INTO `notes_types` (`id`, `name`, `download_caption`, `icon_display`, `icon_download`, `external`) VALUES 
    ('1', 'PDF NEI', 'Descarregar', 'fas file-pdf', 'fas cloud-download-alt', '0'), 
    ('2', 'ZIP NEI', 'Descarregar', 'fas folder', 'fas cloud-download-alt', '0'), 
    ('3', 'Repositório', 'Repositório', 'fab github', 'fab github', '1'), 
    ('4', 'Google Drive', 'Google Drive', 'fab google-drive', 'fab google-drive', '1');

-- SELECT location, type FROM notes WHERE location LIKE "%.pdf";
-- SELECT location, type FROM notes WHERE location LIKE "%.zip";
UPDATE notes SET type=1 WHERE location LIKE "%.pdf";
UPDATE notes SET type=2 WHERE location LIKE "%.zip";
-- SELECT location, type FROM notes WHERE type=0;

ALTER TABLE notes ADD CONSTRAINT FOREIGN KEY (type) REFERENCES notes_types(id);

INSERT INTO notes_schoolyear (id, yearBegin, yearEnd) VALUES
	(7, 2019, 2020),
	(8, 2020, 2021);


INSERT INTO `notes` (`id`, `name`, `location`, `subject`, `author`, `schoolYear`, `teacher`, `summary`, `tests`, `bibliography`, `slides`, `exercises`, `projects`, `notebook`, `content`, `createdAt`, `type`) VALUES ('197', 'StoreGo (Projeto TQS)', 'https://github.com/gmatosferreira/IES_Project_G31', '45426', '1275', '8', '13', NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, current_timestamp(), '3'); 