-- NEI SUMMER BUILD
-- https://github.com/NEI-AAUAV/Website/projects/2

-- ISSUE 49 // https://github.com/NEI-AAUAV/Website/issues/49

ALTER TABLE seniors_students ADD quote VARCHAR(280); -- Like Twitter
ALTER TABLE seniors_students ADD image VARCHAR(255);

INSERT INTO `seniors` (`year`, `course`, `image`) VALUES ('2021', 'LEI', NULL);

INSERT INTO `seniors_students` (`year`, `course`, `userId`, `quote`, `image`) VALUES ('2021', 'LEI', '873', 'Loren ipsum 1....', '/seniors/lei/2021/avatar.jpg');
INSERT INTO `seniors_students` (`year`, `course`, `userId`, `quote`, `image`) VALUES ('2021', 'LEI', '1845', 'Loren ipsum 2....', '/seniors/lei/2021/avatar.jpg'); 