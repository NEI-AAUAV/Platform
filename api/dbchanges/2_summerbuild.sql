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