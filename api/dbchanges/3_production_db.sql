-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: mysql-hosting.ua.pt:3306
-- Generation Time: Jun 06, 2022 at 04:34 PM
-- Server version: 10.1.18-MariaDB
-- PHP Version: 7.3.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aauav-nei`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`aauav-nei-dbo`@`%` PROCEDURE `Get_All_Users` ()  Select u_iupi, u_login, u_email, u_name, u_name_full
From `users`
Order By u_name$$

CREATE DEFINER=`aauav-nei-dbo`@`%` PROCEDURE `Get_Dinner_Signups_Faina` (IN `post_id` INT(11))  SELECT u_name, guests, estado 
FROM inscricoes 
JOIN users 
ON user_login = u_login 
WHERE post_id = @p0$$

CREATE DEFINER=`aauav-nei-dbo`@`%` PROCEDURE `Get_Dinner_Signups_Nei` (IN `post_id` INT)  SELECT u_name, guests, estado 
FROM inscricoes_nei 
JOIN users 
ON user_login = u_login 
WHERE post_id = @p0$$

CREATE DEFINER=`aauav-nei-dbo`@`%` PROCEDURE `Get_Post_Details_Faina` (IN `post_id` INT)  SELECT title, content, name, path, user_entry 
FROM f_posts 
JOIN images
ON images.id = image_id 
WHERE state=1 AND f_posts.id =@p0$$

CREATE DEFINER=`aauav-nei-dbo`@`%` PROCEDURE `Get_Post_Details_Nei` (IN `post_id` INT)  SELECT title, content, name, path, user_entry 
FROM n_posts 
JOIN images_nei 
ON images_nei.id = image_id 
WHERE state=1 AND n_posts.id = @p0$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `classificacao_tacaua`
--

CREATE TABLE `classificacao_tacaua` (
  `id` int(11) NOT NULL,
  `idModalidade` int(11) NOT NULL,
  `idEquipa` int(11) NOT NULL,
  `pontuacao` int(11) NOT NULL DEFAULT '0',
  `njogos` int(11) NOT NULL DEFAULT '0',
  `vitorias` int(11) NOT NULL DEFAULT '0',
  `empates` int(11) DEFAULT NULL,
  `derrotas` int(11) NOT NULL DEFAULT '0',
  `fc` int(11) NOT NULL DEFAULT '0',
  `gmarcados` int(11) NOT NULL DEFAULT '0',
  `gsofridos` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `classificacao_tacaua`
--

INSERT INTO `classificacao_tacaua` (`id`, `idModalidade`, `idEquipa`, `pontuacao`, `njogos`, `vitorias`, `empates`, `derrotas`, `fc`, `gmarcados`, `gsofridos`) VALUES
(1, 19, 1, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 19, 3, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

CREATE TABLE `companies` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `permission` int(11) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `companies`
--

INSERT INTO `companies` (`id`, `name`, `email`, `permission`, `password`) VALUES
(1, 'Admin', 'nei@aauav.pt', 1, '$P$B1ihizlvPX6tVq6tdCyHXLhw9EyRV.0'),
(10, 'Miguel Sarmento', 'miguel.sarmento@syone.com', 1, '$P$BT7Ya455vsg.aZhIpaXmX07i5IbZKw/');

-- --------------------------------------------------------

--
-- Table structure for table `equipas_tacaua`
--

CREATE TABLE `equipas_tacaua` (
  `id` int(11) NOT NULL,
  `nome` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `equipas_tacaua`
--

INSERT INTO `equipas_tacaua` (`id`, `nome`) VALUES
(1, 'EET'),
(2, 'Marketing'),
(3, 'Contabilidade'),
(4, 'Enfermagem'),
(5, 'ECT'),
(6, 'Biotecnologia'),
(7, 'Psicologia'),
(8, 'Eng. Mecânica'),
(9, 'EGI'),
(10, 'Eng. Física'),
(11, 'Eng. Informática'),
(12, 'Turismo'),
(13, 'Eng. Civil'),
(14, 'Economia'),
(15, 'Ed. Básica'),
(16, 'CBM'),
(17, 'Biologia/Geologia'),
(18, 'Bioquímica'),
(19, 'Música'),
(20, 'LRE'),
(21, 'Matemática'),
(22, 'Gestão'),
(23, 'Eng. Química'),
(24, 'Química'),
(25, 'Eng. Ambiente'),
(26, 'AP'),
(27, 'Ciências do Mar'),
(28, 'IMRT'),
(29, 'MOG'),
(30, 'Biologia'),
(31, 'Finanças'),
(32, 'NTC'),
(33, 'Eng. Materiais'),
(34, 'Fisioterapia'),
(35, 'EET B'),
(36, 'Geologia'),
(37, 'EGI B'),
(38, 'Contabilidade B'),
(39, 'Design'),
(40, 'AP B'),
(41, 'Bioquímica B'),
(42, 'Tradução');

-- --------------------------------------------------------

--
-- Table structure for table `estatistica`
--

CREATE TABLE `estatistica` (
  `id` int(11) NOT NULL,
  `acessos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `estatistica`
--

INSERT INTO `estatistica` (`id`, `acessos`) VALUES
(840, 1),
(843, 10),
(870, 1),
(921, 1),
(969, 1),
(990, 1),
(999, 2),
(1020, 1),
(1023, 1),
(1053, 5),
(1059, 1),
(1074, 1),
(1098, 3),
(1101, 1),
(1113, 2),
(1137, 1),
(1182, 1),
(1254, 4),
(1275, 1),
(1284, 1),
(1341, 3),
(1344, 1),
(1350, 1),
(1359, 2),
(1425, 1),
(1452, 2),
(1608, 9),
(1626, 1),
(1716, 1),
(1821, 1),
(1866, 9),
(1926, 1),
(1929, 1),
(1995, 1),
(2010, 1),
(2016, 3),
(2021, 2),
(2028, 1),
(2033, 8),
(2043, 1),
(2044, 1),
(2045, 1),
(2048, 1),
(2059, 1),
(2061, 2),
(2066, 3),
(2077, 1),
(2080, 1);

-- --------------------------------------------------------

--
-- Table structure for table `estatistica_comp`
--

CREATE TABLE `estatistica_comp` (
  `id` int(11) NOT NULL,
  `acessos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `faina`
--

CREATE TABLE `faina` (
  `mandato` int(255) NOT NULL,
  `imagem` varchar(255) DEFAULT NULL,
  `anoLetivo` varchar(9) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `faina`
--

INSERT INTO `faina` (`mandato`, `imagem`, `anoLetivo`) VALUES
(2012, NULL, '2012/2013'),
(2013, NULL, '2013/2014'),
(2014, NULL, '2014/2015'),
(2015, NULL, '2015/2016'),
(2016, NULL, '2016/2017'),
(2017, NULL, '2017/2018'),
(2018, '/faina/team/2018.jpg', '2018/2019'),
(2019, '/faina/team/2019.jpg', '2019/2020'),
(2020, '/faina/team/2020.jpeg', '2020/2021');

-- --------------------------------------------------------

--
-- Table structure for table `faina_memb`
--

CREATE TABLE `faina_memb` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `ano` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `faina_memb`
--

INSERT INTO `faina_memb` (`id`, `nome`, `ano`) VALUES
(1, 'Mestre de Curso João Artur Costa', 2019),
(4, 'Mestre João Ferreira', 2019),
(7, 'Mestre João Magalhães', 2019),
(8, 'Mestre José Moreira', 2019),
(10, 'Moça Carina Neves', 2019),
(13, 'Moço Luís Silva', 2019),
(16, 'Moça Marta Ferreira', 2019),
(19, 'Moço Tiago Mendes', 2019),
(22, 'Junco Dinis Cruz', 2019),
(25, 'Junco Eduardo Santos', 2019),
(28, 'Junco Pedro Bastos', 2019),
(31, 'Varina Andreia Patrocínio', 2018),
(34, 'Marnoto João Artur Costa', 2018),
(37, 'Marnoto João Magalhães', 2018),
(40, 'Marnoto José Moreira', 2018),
(43, 'Moço Cláudio Costa', 2018),
(46, 'Moço Francisco Silveira', 2018),
(49, 'Moço Luís Costa', 2018),
(52, 'Moça Sandra Andrade', 2018),
(55, 'Junco André Alves ', 2018),
(58, 'Caniça Carina Neves', 2018),
(61, 'Junco Tiago Mendes', 2018),
(64, 'Mestre de Curso Bruno Barbosa', 2017),
(67, 'Mestre David Ferreira', 2017),
(70, 'Moça Andreia Patrocínio', 2017),
(73, 'Moço Carlos Soares', 2017),
(76, 'Moça Carolina Albuquerque', 2017),
(79, 'Moço David Fernandes', 2017),
(82, 'Moço Dimitri da Silva', 2017),
(85, 'Moço João Artur Costa', 2017),
(86, 'Moço Tiago Cardoso', 2017),
(88, 'Junco Simão Arrais', 2017),
(91, 'Mestre de Curso Guilherme Moura', 2016),
(94, 'Mestre Alex Santos', 2016),
(97, 'Marnoto Bruno Barbosa', 2016),
(100, 'Salineira Mimi Cunha', 2016),
(103, 'Marnoto Pedro Matos', 2016),
(106, 'Moço João Paúl', 2016),
(109, 'Moço Marco Ventura', 2016),
(112, 'Caniça Andreia Patrocínio', 2016),
(115, 'Junco Carlos Soares', 2016),
(118, 'Junco Tiago Cardoso', 2016),
(121, 'Mestre de Curso Luís Santos', 2015),
(124, 'Mestre Ana Ortega', 2015),
(127, 'Mestre Emanuel Laranjo', 2015),
(128, 'Mestre Guilherme Moura', 2015),
(132, 'Marnoto Alex Santos', 2015),
(133, 'Marnoto Bruno Pinto', 2015),
(134, 'Marnoto João Freitas', 2015),
(135, 'Marnoto Miguel Antunes', 2015),
(142, 'Moço Bruno Barbosa', 2015),
(145, 'Junco André Moleirinho', 2015),
(148, 'Junco João Paúl', 2015),
(151, 'Mestre de Curso Pedro Neves', 2014),
(154, 'Mestre Carlos Pacheco', 2014),
(157, 'Mestre Fábio de Almeida', 2014),
(160, 'Mestre Sérgio Martins', 2014),
(163, 'Marnoto Luís Santos', 2014),
(166, 'Moça Catarina Vinagre', 2014),
(169, 'Moço João Alegria', 2014),
(172, 'Moço Luís Oliveira', 2014),
(175, 'Moça Maxlaine Moreira', 2014),
(178, 'Moço Rafael Martins', 2014),
(181, 'Moça Sara Furão', 2014),
(184, 'Mestre de Curso Joana Silva', 2013),
(187, 'Mestre Rita Jesus', 2013),
(190, 'Marnoto Fábio Almeida', 2013),
(193, 'Marnoto Marcos Silva', 2013),
(196, 'Marnoto Pedro Neves', 2013),
(199, 'Marnoto Sérgio Martins', 2013),
(202, 'Moça Andreia Castro', 2013),
(205, 'Moço João Ribeiro', 2013),
(208, 'Moço Luís Santos', 2013),
(211, 'Caniça Maxlaine Moreira', 2013),
(214, 'Junco Rafael Martins', 2013),
(217, 'Mestre de Curso Diogo Paiva', 2012),
(220, 'Mestre Marco Miranda', 2012),
(223, 'Marnoto João Costa', 2012),
(226, 'Marnoto Daniel Rodrigues', 2012),
(229, 'Marnoto Filipe Silva', 2012),
(232, 'Salineira Joana Coelho', 2012),
(235, 'Salineira Joana Silva', 2012),
(238, 'Salineira Rita Jesus', 2012),
(241, 'Moço Diogo Ramos', 2012),
(244, 'Moço Marcus Silva', 2012),
(247, 'Moço Pedro Neves', 2012);

-- --------------------------------------------------------

--
-- Table structure for table `faina_member`
--

CREATE TABLE `faina_member` (
  `id` int(11) NOT NULL,
  `member` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `role` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `faina_member`
--

INSERT INTO `faina_member` (`id`, `member`, `year`, `role`) VALUES
(4, 1179, 2012, 10),
(7, 1593, 2012, 7),
(10, 1062, 2012, 5),
(13, 1080, 2012, 5),
(16, 2137, 2012, 5),
(19, 1380, 2012, 6),
(22, 1893, 2012, 6),
(25, 1848, 2012, 6),
(28, 1167, 2012, 3),
(31, 1599, 2012, 3),
(34, 1785, 2012, 3),
(37, 1893, 2013, 10),
(40, 1848, 2013, 7),
(43, 1218, 2013, 5),
(46, 1599, 2013, 5),
(49, 1785, 2013, 5),
(52, 1917, 2013, 5),
(55, 1032, 2013, 4),
(58, 1488, 2013, 3),
(61, 1551, 2013, 3),
(64, 1629, 2013, 2),
(67, 1854, 2013, 1),
(70, 1785, 2014, 10),
(73, 1005, 2014, 7),
(76, 1218, 2014, 7),
(79, 1917, 2014, 7),
(82, 1551, 2014, 5),
(85, 1038, 2014, 4),
(88, 1455, 2014, 3),
(91, 1554, 2014, 3),
(94, 1629, 2014, 4),
(97, 1854, 2014, 3),
(100, 1923, 2014, 4),
(103, 1551, 2015, 10),
(106, 894, 2015, 7),
(109, 1194, 2015, 7),
(112, 1293, 2015, 7),
(115, 2138, 2015, 5),
(118, 987, 2015, 5),
(121, 1065, 2015, 5),
(124, 1653, 2015, 5),
(127, 984, 2015, 3),
(130, 858, 2015, 1),
(133, 1437, 2015, 1),
(136, 1293, 2016, 10),
(139, 2138, 2016, 7),
(142, 984, 2016, 5),
(145, 1071, 2016, 6),
(148, 1752, 2016, 5),
(151, 1437, 2016, 3),
(154, 1596, 2016, 3),
(157, 1704, 2016, 2),
(160, 1059, 2016, 1),
(163, 1947, 2016, 1),
(166, 984, 2017, 10),
(169, 1116, 2017, 7),
(172, 1704, 2017, 4),
(175, 1059, 2017, 3),
(178, 1023, 2017, 4),
(181, 1101, 2017, 3),
(184, 1134, 2017, 3),
(187, 1365, 2017, 3),
(190, 1947, 2017, 3),
(193, 1929, 2017, 1),
(196, 1704, 2018, 9),
(199, 1365, 2018, 5),
(202, 1512, 2018, 5),
(205, 1485, 2018, 5),
(208, 1053, 2018, 3),
(211, 1266, 2018, 3),
(214, 1524, 2018, 3),
(217, 1902, 2018, 4),
(220, 900, 2018, 1),
(223, 1002, 2018, 2),
(226, 1965, 2018, 1),
(229, 1365, 2019, 10),
(232, 1419, 2019, 7),
(235, 1512, 2019, 7),
(238, 1485, 2019, 7),
(241, 1002, 2019, 4),
(244, 1548, 2019, 3),
(247, 1626, 2019, 4),
(250, 1965, 2019, 3),
(253, 1068, 2019, 1),
(256, 1200, 2019, 1),
(259, 1716, 2019, 1),
(262, 1512, 2020, 10),
(265, 1419, 2020, 7),
(268, 1485, 2020, 7),
(271, 1002, 2020, 6),
(274, 1548, 2020, 5),
(277, 1200, 2020, 3),
(280, 1716, 2020, 3),
(283, 1821, 2020, 3),
(286, 2026, 2020, 1),
(289, 2047, 2020, 1),
(292, 2059, 2020, 1);

-- --------------------------------------------------------

--
-- Table structure for table `faina_roles`
--

CREATE TABLE `faina_roles` (
  `id` int(11) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `weight` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `faina_roles`
--

INSERT INTO `faina_roles` (`id`, `name`, `weight`) VALUES
(1, 'Junco', 1),
(2, 'Caniça', 1),
(3, 'Moço', 2),
(4, 'Moça', 2),
(5, 'Marnoto', 4),
(6, 'Salineira', 3),
(7, 'Mestre', 5),
(8, 'Arrais', 6),
(9, 'Varina', 6),
(10, 'Mestre de Curso', 6);

-- --------------------------------------------------------

--
-- Table structure for table `GenTokens`
--

CREATE TABLE `GenTokens` (
  `id` int(255) NOT NULL,
  `userid` int(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expire_date` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `GenTokens`
--

INSERT INTO `GenTokens` (`id`, `userid`, `token`, `expire_date`) VALUES
(43, 1020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIwIiwidXNlcm1haWwiOiJjYXJvbGluYS5hcmF1am8wMEB1YS5wdCIsImlhdCI6MTU2OTkxOTM4NywiZXhwIjoxNTY5OTIxMTg3LCJwZXJtaXNzaW9uIjoiIn0.LKWa3z9YGbcclm1F9Quf1oICj8eHB5RREYH38rEWlwo', 1569921187),
(46, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1Njk5MjAzMzgsImV4cCI6MTU2OTkyMjEzOCwicGVybWlzc2lvbiI6IiJ9.OeHjQclfWn-oXUtVhsjmE_yovnrPwx8CLgD9jYHQQOs', 1569922138),
(49, 1359, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU5IiwidXNlcm1haWwiOiJqLmJyaXRvQHVhLnB0IiwiaWF0IjoxNTY5OTIyNTI5LCJleHAiOjE1Njk5MjQzMjksInBlcm1pc3Npb24iOiIifQ.hkJUqoJwitkP76nMBiWjFh8Mz1wSr1Gtckeuh_yGMO0', 1569924329),
(52, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1Njk5MjM2MTAsImV4cCI6MTU2OTkyNTQxMCwicGVybWlzc2lvbiI6IiJ9.uv7eJJnR9ysZ1z_5z6OsBCipzXHJr7hNMGeHBQbzmuo', 1569925410),
(55, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1Njk5MjQ2NjQsImV4cCI6MTU2OTkyNjQ2NCwicGVybWlzc2lvbiI6IiJ9.qxV0Zzp_ci4_33lfGbRH99D9s4F-vRVJgkjqwWFKHjk', 1569926464),
(58, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTY5OTI0ODgwLCJleHAiOjE1Njk5MjY2ODAsInBlcm1pc3Npb24iOiIifQ.vopcFz-d0K8xFfeHaHOMCEyO-Jfm7BYHa3IYXVCnBg4', 1569926680),
(70, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTY5OTI5MTc3LCJleHAiOjE1Njk5MzA5NzcsInBlcm1pc3Npb24iOiIifQ.ddILXg5e-JSrybg2PWswlkSnDSIwc8At-UegtPlXLXI', 1569930977),
(76, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTY5OTMyOTQzLCJleHAiOjE1Njk5MzQ3NDMsInBlcm1pc3Npb24iOiIifQ.xgHehNcqErYkxpPZdK0QxPDE-gApfp2g80XK7OhyQQE', 1569934743),
(79, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1Njk5MzMyMjksImV4cCI6MTU2OTkzNTAyOSwicGVybWlzc2lvbiI6IiJ9.exjlV6ygiHLN0tac1KSVaB1CrspvsZENPnXW2jG9MWs', 1569935029),
(82, 1359, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU5IiwidXNlcm1haWwiOiJqLmJyaXRvQHVhLnB0IiwiaWF0IjoxNTY5OTM2NDUwLCJleHAiOjE1Njk5MzgyNTAsInBlcm1pc3Npb24iOiIifQ.F90gTb8tDRVsIuL4h_wBFvQKmTY_fSXGo9OtPcA7nNI', 1569938250),
(85, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU2OTkzODQxMiwiZXhwIjoxNTY5OTQwMjEyLCJwZXJtaXNzaW9uIjoiIn0.XrxVglK3p0tfTc6fvkUQmLKe_9rYWju5kJ76RRDAur4', 1569940212),
(88, 1821, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODIxIiwidXNlcm1haWwiOiJyZm1mQHVhLnB0IiwiaWF0IjoxNTY5OTM4NzExLCJleHAiOjE1Njk5NDA1MTEsInBlcm1pc3Npb24iOiIifQ.qLtcoQ8w1YvrP_J8kkY0PpNaYhvh56pYx4YDDS4Ud9Q', 1569940511),
(91, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1Njk5Mzk1MzAsImV4cCI6MTU2OTk0MTMzMCwicGVybWlzc2lvbiI6IiJ9.wEyNMjfwCzPLaehwAx5VvduUYn1IDtSW3FOvrw_esCk', 1569941330),
(97, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Njk5NDM0NjQsImV4cCI6MTU2OTk0NTI2NCwicGVybWlzc2lvbiI6IiJ9.Cbk_PpDxBsWGNWiaMKVUmfFAieWTgz-GBCm3X12MwH0', 1569945264),
(103, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTY5OTQ2ODc2LCJleHAiOjE1Njk5NDg2NzYsInBlcm1pc3Npb24iOiIifQ.9Gy7J84MAaN8rheQoZPzWJWEPE1-C6j_gyLspuZDM4A', 1569948676),
(109, 1350, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzUwIiwidXNlcm1haWwiOiJpc2Fkb3JhLmZsQHVhLnB0IiwiaWF0IjoxNTY5OTQ4NzcyLCJleHAiOjE1Njk5NTA1NzIsInBlcm1pc3Npb24iOiIifQ.sGbsVlZ6iFeupR463EACMonVc8w7Dyi2YOYQ50j5Ybo', 1569950572),
(115, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTY5OTYyNjAzLCJleHAiOjE1Njk5NjQ0MDMsInBlcm1pc3Npb24iOiIifQ.pQSSupy2mvPyEDzQT7zGvG5sYWLY6PpzuU-SiRcTB6Q', 1569964403),
(121, 1716, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE2IiwidXNlcm1haWwiOiJwZWRyby5iYXNAdWEucHQiLCJpYXQiOjE1Njk5NjgwNjIsImV4cCI6MTU2OTk2OTg2MiwicGVybWlzc2lvbiI6IiJ9.rrsDaNiSf-ih6CtQcn4u5iqwMDvv-D6KjlxBpTqtAXQ', 1569969862),
(127, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTY5OTczMjI1LCJleHAiOjE1Njk5NzUwMjUsInBlcm1pc3Npb24iOiIifQ.VED9pEIg6uqxeADIphJNeLhv4gamzupZUiUCx4nQM3g', 1569975025),
(133, 870, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NzAiLCJ1c2VybWFpbCI6ImFsZXhhbmRyYWNhcnZhbGhvQHVhLnB0IiwiaWF0IjoxNTcwMDAzOTU0LCJleHAiOjE1NzAwMDU3NTQsInBlcm1pc3Npb24iOiIifQ.L4qSF22D8O-jm10E-r03NUQvZp4kOiE6oqeSZQj4aNw', 1570005754),
(136, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU3MDAwNTM4OSwiZXhwIjoxNTcwMDA3MTg5LCJwZXJtaXNzaW9uIjoiIn0.vFyzYCeVDzZkWynNQpQRxsJT3_w2HkE4BoM2sLSHnVA', 1570007189),
(139, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDAwNTc3OCwiZXhwIjoxNTcwMDA3NTc4LCJwZXJtaXNzaW9uIjoiIn0.RaHb5PW_DFUn2PRRwHEuARnpittNK5w4UFDgxBnaoGA', 1570007578),
(145, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTcwMDExMTc0LCJleHAiOjE1NzAwMTI5NzQsInBlcm1pc3Npb24iOiIifQ.rXj-qzWnfd0AIu3A4NG2F6W6Suf_UlAJFJqmHFUSJus', 1570012974),
(148, 2080, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDgwIiwidXNlcm1haWwiOiJicmFpc0B1YS5wdCIsImlhdCI6MTU3MDAxMTE4MywiZXhwIjoxNTcwMDEyOTgzLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.R9qXB2giBO0YvNx59OQwkyoOAVe3bu4kP5mg4Gqtbqo', 1570012983),
(151, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDAxMTQzNywiZXhwIjoxNTcwMDEzMjM3LCJwZXJtaXNzaW9uIjoiIn0.UtkvQhfVpe1lvjszyE1s8SJo1vDeF023fyjJhC5O5o0', 1570013237),
(157, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1NzAwMTU4NzEsImV4cCI6MTU3MDAxNzY3MSwicGVybWlzc2lvbiI6IiJ9.sba4c5b2U6GdjViZ5Tcyt9i3d8eeYFElallN8ZJtpKM', 1570017671),
(163, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwMDI1NjU0LCJleHAiOjE1NzAwMjc0NTQsInBlcm1pc3Npb24iOiIifQ.Y5S-uIT4lxH2q-llSQQQIbwUfcjrV6CeiQ5RsfiCPrA', 1570027454),
(169, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1NzAwMjk0NzMsImV4cCI6MTU3MDAzMTI3MywicGVybWlzc2lvbiI6IiJ9.GTclwahladYS5i534eeFXty-1OyXbKvbXldAFJBKCyU', 1570031273),
(175, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwMDM0NTQ1LCJleHAiOjE1NzAwMzYzNDUsInBlcm1pc3Npb24iOiIifQ.PHkBV93HXVTIDBRF_UKS80nvtU4p1cf25741RL-hzPE', 1570036345),
(181, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1NzAwMzkwMzMsImV4cCI6MTU3MDA0MDgzMywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.5095OsmiFJjz1olGlyvzIZl-LdJZ0bBDUcAAT_lFI-c', 1570040833),
(187, 969, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NjkiLCJ1c2VybWFpbCI6ImJlcm5hcmRvcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwMDQzMDc0LCJleHAiOjE1NzAwNDQ4NzQsInBlcm1pc3Npb24iOiIifQ.9yT2PWIpnrlB6_cB2ZZp5w8O5hd25qRgnoOaWdtuB0M', 1570044874),
(193, 2061, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYxIiwidXNlcm1haWwiOiJwZGZsQHVhLnB0IiwiaWF0IjoxNTcwMDQ5NTY1LCJleHAiOjE1NzAwNTEzNjUsInBlcm1pc3Npb24iOiIifQ.TSfNS5yA4dJ8qlJGfzSO_j7PP3G5EUyS1_nJBJ3Z9Ls', 1570051365),
(199, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU3MDA5MTU2MSwiZXhwIjoxNTcwMDkzMzYxLCJwZXJtaXNzaW9uIjoiIn0.hMcJQsVL0YN3PpqXqZAJ52oyzACtLwS2GsLSHrXyEco', 1570093361),
(202, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1NzAwOTE4MDIsImV4cCI6MTU3MDA5MzYwMiwicGVybWlzc2lvbiI6IiJ9.g4XrEXg_8P9I4yhnU2yfzQ6ZgSek1mJodM8-OIVQqCQ', 1570093602),
(208, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcwMTAwMDM4LCJleHAiOjE1NzAxMDE4MzgsInBlcm1pc3Npb24iOiIifQ.JbROCbXgRpr2XoVj1g_jldf61Kw5yvWhRbqHTfY3BEE', 1570101838),
(214, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwMTA3Mjk5LCJleHAiOjE1NzAxMDkwOTksInBlcm1pc3Npb24iOiIifQ.Hv7lgSIwcAhDyBGK0IJ-Vqwf3ue-urmB790qRLl5U3U', 1570109099),
(220, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU3MDExMTU1OSwiZXhwIjoxNTcwMTEzMzU5LCJwZXJtaXNzaW9uIjoiIn0.ro4_NPmAYBIkCR_5kHe14Wo33U3PK9NpZgRhaTeYGNE', 1570113359),
(223, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTcwMTEyODUxLCJleHAiOjE1NzAxMTQ2NTEsInBlcm1pc3Npb24iOiIifQ.0ge-61QaV2sVxKLt62gbdOjBrFZNsrdzKIZxXKQ2RfY', 1570114651),
(226, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzAxMTQwMTAsImV4cCI6MTU3MDExNTgxMCwicGVybWlzc2lvbiI6IiJ9.11Mlx8c7XH40fW4HrkUKmnGohBTJewdm1mxS-2Au7k4', 1570115810),
(232, 1341, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQxIiwidXNlcm1haWwiOiJpbmVzLnBsQHVhLnB0IiwiaWF0IjoxNTcwMTI3ODE1LCJleHAiOjE1NzAxMjk2MTUsInBlcm1pc3Npb24iOiIifQ.H7R83E-wNyLKaEgWq7xPi85PUglQATN4znhipM1vbVw', 1570129615),
(238, 2061, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYxIiwidXNlcm1haWwiOiJwZGZsQHVhLnB0IiwiaWF0IjoxNTcwMTM3MzgwLCJleHAiOjE1NzAxMzkxODAsInBlcm1pc3Npb24iOiIifQ.126vCSXs50CUS3Jqc7UbsEsp4wqTsYYIQ-5CVM7lGkA', 1570139180),
(241, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU3MDEzNzkxNSwiZXhwIjoxNTcwMTM5NzE1LCJwZXJtaXNzaW9uIjoiIn0.7cQOPgvJsLli-fXcTUPk0kXkK0A47A7ya0pCVXomniI', 1570139715),
(244, 1059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDU5IiwidXNlcm1haWwiOiJjbXNvYXJlc0B1YS5wdCIsImlhdCI6MTU3MDEzOTY4NywiZXhwIjoxNTcwMTQxNDg3LCJwZXJtaXNzaW9uIjoiIn0.ZOQMHAfZs_40K_OglTPiTA4-DbJ8SPK8e1NQua44FNI', 1570141487),
(250, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1NzAxNDM1MTUsImV4cCI6MTU3MDE0NTMxNSwicGVybWlzc2lvbiI6IiJ9.TZDSSzh2uT-fsn_pVh7dnmwGVhw3JuYKWEqq2rZDufA', 1570145315),
(256, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3MDE3NTkxMCwiZXhwIjoxNTcwMTc3NzEwLCJwZXJtaXNzaW9uIjoiIn0.rBK8gJOJpZRWq6yk8TwynJkkCMLqdGNOFShFmPJ-VMs', 1570177710),
(262, 990, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTAiLCJ1c2VybWFpbCI6ImJydW5vcmFiYWNhbEB1YS5wdCIsImlhdCI6MTU3MDE4MTc1OCwiZXhwIjoxNTcwMTgzNTU4LCJwZXJtaXNzaW9uIjoiIn0.MPy4U4PhO-YvPxTD9MTIslQsM1ROCZxf2KpRcn7kLRU', 1570183558),
(265, 1137, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTM3IiwidXNlcm1haWwiOiJkaW9nby5hbmRyYWRlQHVhLnB0IiwiaWF0IjoxNTcwMTgzODA2LCJleHAiOjE1NzAxODU2MDYsInBlcm1pc3Npb24iOiIifQ.BSM978HMjiJ945Tnz2QFK-QcYhwgqxU6yaX7ZGz-r0Q', 1570185606),
(271, 1182, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTgyIiwidXNlcm1haWwiOiJkdWFydGUubnRtQHVhLnB0IiwiaWF0IjoxNTcwMTk1MTg0LCJleHAiOjE1NzAxOTY5ODQsInBlcm1pc3Npb24iOiIifQ.fMrkfmW848H0soZ9zZRD7hYdluKqMB8KFmdNZMc4_u0', 1570196984),
(274, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU3MDE5NTg1MCwiZXhwIjoxNTcwMTk3NjUwLCJwZXJtaXNzaW9uIjoiIn0.MUfQ5tNPXMcP-8ObfYEp4MHh__JUsrXgnrUV9qWW9NM', 1570197650),
(280, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzAxOTk1NzksImV4cCI6MTU3MDIwMTM3OSwicGVybWlzc2lvbiI6IiJ9.DZm0MQnmrJ3RUZXLLEjrMVE6ClixiptG9Ej7ErdFHyo', 1570201379),
(286, 1626, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjI2IiwidXNlcm1haWwiOiJtYXJ0YXNmZXJyZWlyYUB1YS5wdCIsImlhdCI6MTU3MDIwMzA2MywiZXhwIjoxNTcwMjA0ODYzLCJwZXJtaXNzaW9uIjoiIn0.XCBu4FO05tlJ7C26mRb5WC6NL9ghU84hT1xmL97ums8', 1570204863),
(289, 1344, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQ0IiwidXNlcm1haWwiOiJpbmVzLnNlYWJyYXJvY2hhQHVhLnB0IiwiaWF0IjoxNTcwMjA0ODg4LCJleHAiOjE1NzAyMDY2ODgsInBlcm1pc3Npb24iOiIifQ.AiU_NgtJkoj3LYotvIk8I_40Jnpxs5Ancx7R_ViT9Fs', 1570206688),
(301, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTcwMjY3MDE4LCJleHAiOjE1NzAyNjg4MTgsInBlcm1pc3Npb24iOiIifQ.NCEU9_E399tJAASJ4jFEYpvm4CHtRi97xPheyoQ0lPM', 1570268818),
(304, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDI2NzEyMywiZXhwIjoxNTcwMjY4OTIzLCJwZXJtaXNzaW9uIjoiIn0.MBMofxiVoZffesmM4ifBvwKXMFstO3a6n2lrEBAThu4', 1570268923),
(310, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDI3MjQ1NCwiZXhwIjoxNTcwMjc0MjU0LCJwZXJtaXNzaW9uIjoiIn0.0mJ5ecopxx06VUYsex7KC2AEYzEOcuvkrThUKXRGTGw', 1570274254),
(313, 2028, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI4IiwidXNlcm1haWwiOiJjZmZvbnNlY2FAdWEucHQiLCJpYXQiOjE1NzAyNzQ0MzQsImV4cCI6MTU3MDI3NjIzNCwicGVybWlzc2lvbiI6IiJ9.kVoCXza1sxs6TcMNTNWC-xupVLAacmniui1XsRykdv4', 1570276234),
(316, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwMjc2NjE3LCJleHAiOjE1NzAyNzg0MTcsInBlcm1pc3Npb24iOiIifQ.fT43HR3l8kjkD2zF97i4QDVNGD0CalnOvUcM4haSdCM', 1570278417),
(319, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1NzAyNzczODAsImV4cCI6MTU3MDI3OTE4MCwicGVybWlzc2lvbiI6IiJ9.N32umB1INDG_Ce8IDk_KTE2ZIKS-cbWd7AJgc65YmXo', 1570279180),
(322, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDI3OTkwOCwiZXhwIjoxNTcwMjgxNzA4LCJwZXJtaXNzaW9uIjoiIn0.PLTGv2wFNy24opdcEmT5IrsdSPiONCMlFABoWzjz3DY', 1570281708),
(325, 2045, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ1IiwidXNlcm1haWwiOiJodWdvZ29uY2FsdmVzMTNAdWEucHQiLCJpYXQiOjE1NzAyODA3NjAsImV4cCI6MTU3MDI4MjU2MCwicGVybWlzc2lvbiI6IiJ9.CkFjHEcIomLZKaeeyCH2GiP34paWMMhn9HGIwnVJMzs', 1570282560),
(328, 1995, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTk1IiwidXNlcm1haWwiOiJ0b21hc2Nvc3RhQHVhLnB0IiwiaWF0IjoxNTcwMjgyMzU1LCJleHAiOjE1NzAyODQxNTUsInBlcm1pc3Npb24iOiIifQ.TrQ8MaECFb3NTqMDFnvdPK7iWKc_l6Gzy85_VKv2-IA', 1570284155),
(334, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzAyOTQ5NDEsImV4cCI6MTU3MDI5Njc0MSwicGVybWlzc2lvbiI6IiJ9.ajt7_jnPv8ixqqgLW4hZOlGXnRXCTfYfwvi0iHVqTws', 1570296741),
(337, 1425, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDI1IiwidXNlcm1haWwiOiJqb2FvbWFkaWFzQHVhLnB0IiwiaWF0IjoxNTcwMjk4NjY2LCJleHAiOjE1NzAzMDA0NjYsInBlcm1pc3Npb24iOiIifQ.kbC0tzCgHT4H10lahAaITh2DnTvge8xQt1GhjInMxyU', 1570300466),
(340, 1053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDUzIiwidXNlcm1haWwiOiJjbGF1ZGlvLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTcwMzAxNDc4LCJleHAiOjE1NzAzMDMyNzgsInBlcm1pc3Npb24iOiIifQ.-b5ljsfpt4R_ElCqE3Zgl3lo8xE9X7qSn2zNtpupnJY', 1570303278),
(343, 1053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDUzIiwidXNlcm1haWwiOiJjbGF1ZGlvLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTcwMzAxNTExLCJleHAiOjE1NzAzMDMzMTEsInBlcm1pc3Npb24iOiIifQ.eeWMLQZXA3uoCiwMfphwRFPxMcyO0ebWEoSCmGVDiLw', 1570303311),
(346, 1053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDUzIiwidXNlcm1haWwiOiJjbGF1ZGlvLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTcwMzAxNTExLCJleHAiOjE1NzAzMDMzMTEsInBlcm1pc3Npb24iOiIifQ.eeWMLQZXA3uoCiwMfphwRFPxMcyO0ebWEoSCmGVDiLw', 1570303311),
(349, 1053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDUzIiwidXNlcm1haWwiOiJjbGF1ZGlvLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTcwMzAxNTE3LCJleHAiOjE1NzAzMDMzMTcsInBlcm1pc3Npb24iOiIifQ.bPhXVQVF6t1ZsBCgV8eFOCwxlLUMuzXWff4SwfXnewQ', 1570303317),
(352, 1053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDUzIiwidXNlcm1haWwiOiJjbGF1ZGlvLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTcwMzAxNTIwLCJleHAiOjE1NzAzMDMzMjAsInBlcm1pc3Npb24iOiIifQ.aYsx59bZ7QUKCfgBFVu0Pkee7F2ZMBYDm0AwsI9pkl4', 1570303320),
(358, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDM1MzQ4MiwiZXhwIjoxNTcwMzU1MjgyLCJwZXJtaXNzaW9uIjoiIn0.wfQeT0GOk038Yi_I_FGBA52bhf623fQfpu1kukdAvZM', 1570355282),
(364, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwMzYwMzA2LCJleHAiOjE1NzAzNjIxMDYsInBlcm1pc3Npb24iOiIifQ.JpdVDCO2nCU1MD5WDMbYGLQW4tXPs4dbq3TX3bVsAcY', 1570362106),
(376, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcwMzg0MDc0LCJleHAiOjE1NzAzODU4NzQsInBlcm1pc3Npb24iOiIifQ.yl82OzBw8IjuUehaU5UyoeTiX7v4EJJvuUreRCEJQZk', 1570385874),
(379, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcwMzg0MDk2LCJleHAiOjE1NzAzODU4OTYsInBlcm1pc3Npb24iOiIifQ.MhhtGSF56rnszd_7rtFwuZ04DrPC2tsL5zfYqUxMvZQ', 1570385896),
(382, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcwMzg0MDk5LCJleHAiOjE1NzAzODU4OTksInBlcm1pc3Npb24iOiIifQ.mPpNOCD09QGwJ9LCeuNDq6J1ukXcDuiS0xB4xF7PUjs', 1570385899),
(385, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcwMzg0MTE5LCJleHAiOjE1NzAzODU5MTksInBlcm1pc3Npb24iOiIifQ.jqSrZyPIeT852Cp0wbIvmc53Ubks2QGnXq90Ghbv4pI', 1570385919),
(388, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcwMzg0MTg1LCJleHAiOjE1NzAzODU5ODUsInBlcm1pc3Npb24iOiIifQ._dPrfyhgDRgBW4_cf4xgcByQBhgQj29ANhOaoIGcwGc', 1570385985),
(391, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcwMzg0MjM5LCJleHAiOjE1NzAzODYwMzksInBlcm1pc3Npb24iOiIifQ.dj-h8FSONfx4l_VyFbHhWS4y29iHE2m3o_3mtTdCkVo', 1570386039),
(394, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcwMzg0MjQ1LCJleHAiOjE1NzAzODYwNDUsInBlcm1pc3Npb24iOiIifQ.53lMl2Fy16x7rQ4F2bHDJeaBu3TsOt05_qj3J2W4YFg', 1570386045),
(397, 1284, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjg0IiwidXNlcm1haWwiOiJnb25jYWxvZnJlaXhpbmhvQHVhLnB0IiwiaWF0IjoxNTcwMzg2MDE2LCJleHAiOjE1NzAzODc4MTYsInBlcm1pc3Npb24iOiIifQ.IHe1WMceDBcNebSLt2PyAWGjnbufKTexlUzKQusUtwM', 1570387816),
(403, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTcwMzk1MDk5LCJleHAiOjE1NzAzOTY4OTksInBlcm1pc3Npb24iOiIifQ.AySd8tGt6lYWvbTzMp1nGsG_gzzaJfaIKG9eqE3-6Ck', 1570396899),
(406, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwMzk3MTA4LCJleHAiOjE1NzAzOTg5MDgsInBlcm1pc3Npb24iOiIifQ.q_UeCv9Dym_hzfmuLTiAYFs-qGQuQelmjLlkLjWn8tw', 1570398908),
(409, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzAzOTkxMDAsImV4cCI6MTU3MDQwMDkwMCwicGVybWlzc2lvbiI6IiJ9.vz7Lv5Y6x-ZGLshRbZ9NNuYXP3qqvAtiVDL6zaJKH6c', 1570400900),
(415, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDQ0MzYyMywiZXhwIjoxNTcwNDQ1NDIzLCJwZXJtaXNzaW9uIjoiIn0.SMasOa_HSRhvbhfyUn96BZ1awa-tcizEd8Oxdo5JbUI', 1570445423),
(418, 840, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDAiLCJ1c2VybWFpbCI6ImFhbXJvZHJpZ3Vlc0B1YS5wdCIsImlhdCI6MTU3MDQ0Njg4MCwiZXhwIjoxNTcwNDQ4NjgwLCJwZXJtaXNzaW9uIjoiIn0.k_c3zRa4DyRJ8XgUXTEKFrvjKeHx5fMfd7iYiGtx_as', 1570448680),
(424, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTcwNDY1MDgzLCJleHAiOjE1NzA0NjY4ODMsInBlcm1pc3Npb24iOiIifQ.lWoxEUdh76Hr9v1-KW92lwhNOsb_gbjwhEerUxPfswM', 1570466883),
(430, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwNDcyNDc3LCJleHAiOjE1NzA0NzQyNzcsInBlcm1pc3Npb24iOiIifQ.6jJ6F4qWwo-9lDhJxJ3Bqx43GBpuAzrCWZnIeKK7lyY', 1570474277),
(436, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDQ3NzI1MiwiZXhwIjoxNTcwNDc5MDUyLCJwZXJtaXNzaW9uIjoiIn0.yO1NyP0CjxKzlBWsMxSTMGy_mmpM6KLpn76CAKVlAds', 1570479052),
(442, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTcwNDgyNDk3LCJleHAiOjE1NzA0ODQyOTcsInBlcm1pc3Npb24iOiIifQ.KOenA5X33qFBdYMM4C89fQNBaVv_aXzr6rwaUoJa1ws', 1570484297),
(445, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTcwNDg0MTgxLCJleHAiOjE1NzA0ODU5ODEsInBlcm1pc3Npb24iOiIifQ.wN6AooyGKMqttD-NL6-BhBG8rT5tOr3OST_XvZCz4aU', 1570485981),
(448, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwNDg1NjU0LCJleHAiOjE1NzA0ODc0NTQsInBlcm1pc3Npb24iOiIifQ.m4LHk_cerWvFkJHk5zxpWn8M097txSTS7ZZLvqVs3jQ', 1570487454),
(451, 921, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MjEiLCJ1c2VybWFpbCI6ImFuZHJlZ3VhbEB1YS5wdCIsImlhdCI6MTU3MDQ4NjQzNiwiZXhwIjoxNTcwNDg4MjM2LCJwZXJtaXNzaW9uIjoiIn0.lwUIDrJq-0aYvmF-FA2AOPdRetr549idX-4WSbVJgog', 1570488236),
(454, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU3MDQ4OTI4MywiZXhwIjoxNTcwNDkxMDgzLCJwZXJtaXNzaW9uIjoiIn0.7fZCRoMJkmgn3L5sAnftHfxLD4FOzDWpxvAE4Xb930Y', 1570491083),
(457, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU3MDQ5MzU1MCwiZXhwIjoxNTcwNDk1MzUwLCJwZXJtaXNzaW9uIjoiIn0.nIzQMUUto-FKKKiQuaQa-Wi9bFK8jhxNCamS611xbM8', 1570495350),
(463, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3MDUzNTg1NCwiZXhwIjoxNTcwNTM3NjU0LCJwZXJtaXNzaW9uIjoiIn0.Y9taPBZugOCBd7KRhh69wgbVOhSn7BoxmfS5XjR9kE4', 1570537654),
(466, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3MDUzODY3OSwiZXhwIjoxNTcwNTQwNDc5LCJwZXJtaXNzaW9uIjoiIn0.1A2c8uqs8YpwQtzEngVdIDEg30cA6gLVHvMwT8QtriU', 1570540479),
(469, 1341, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQxIiwidXNlcm1haWwiOiJpbmVzLnBsQHVhLnB0IiwiaWF0IjoxNTcwNTQwMTM1LCJleHAiOjE1NzA1NDE5MzUsInBlcm1pc3Npb24iOiIifQ.izI1OQOUWbe0vFuzx1hULrSxRpnRWRY0edJ4onfdhNM', 1570541935),
(472, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzA1NDA3NzQsImV4cCI6MTU3MDU0MjU3NCwicGVybWlzc2lvbiI6IiJ9.TzcCqekbtKdyVueEmEOME1kzwMFnAQDG6qO2AIQtx7k', 1570542574),
(475, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzA1NDA3OTYsImV4cCI6MTU3MDU0MjU5NiwicGVybWlzc2lvbiI6IiJ9.FbBBdokN9Qg5miJK9aHbmpmQmtda3YAAryIo332PalY', 1570542596),
(478, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzA1NDA4MDksImV4cCI6MTU3MDU0MjYwOSwicGVybWlzc2lvbiI6IiJ9.QO7p1CgnXHnfSJKQQvhdeiN5rlPOS7YiGi6KM-mnBsA', 1570542609),
(484, 1341, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQxIiwidXNlcm1haWwiOiJpbmVzLnBsQHVhLnB0IiwiaWF0IjoxNTcwNTQ0NzI2LCJleHAiOjE1NzA1NDY1MjYsInBlcm1pc3Npb24iOiIifQ.Ljxv89rReQDu4DxB9SHdOsjtyXYNWbWJJUZi7SjbjqQ', 1570546526),
(487, 1929, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI5IiwidXNlcm1haWwiOiJzaW1hb2FycmFpc0B1YS5wdCIsImlhdCI6MTU3MDU0NTcyNSwiZXhwIjoxNTcwNTQ3NTI1LCJwZXJtaXNzaW9uIjoiIn0.8H2GnbsIyFpPe9ace-Ui-sHjr05xiusaXZ30HbCq7aE', 1570547525),
(490, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzA1NDY5MzMsImV4cCI6MTU3MDU0ODczMywicGVybWlzc2lvbiI6IiJ9.OmgoufDfGW2lvvRFHYGRGxd0J8JL60Uge3QXsOFtNB8', 1570548733),
(493, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzA1NDkyNzgsImV4cCI6MTU3MDU1MTA3OCwicGVybWlzc2lvbiI6IiJ9.CtrYgl4e5WmbFCTI9jj95_xKso4A4nd7JjwQ2nisTmk', 1570551078),
(496, 1359, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU5IiwidXNlcm1haWwiOiJqLmJyaXRvQHVhLnB0IiwiaWF0IjoxNTcwNTQ5MzkyLCJleHAiOjE1NzA1NTExOTIsInBlcm1pc3Npb24iOiIifQ.V4k4Zij2d4KD2EnNGeNJgGkwOKiOxAcWOex4QVw5Oo4', 1570551192),
(499, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTcwNTQ5NDE1LCJleHAiOjE1NzA1NTEyMTUsInBlcm1pc3Npb24iOiIifQ.sSK5CyzwhwX1wkRpyXw5v4KSdq5oLfp-s64SQjj3Ubc', 1570551215),
(505, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzA1NTE3NjQsImV4cCI6MTU3MDU1MzU2NCwicGVybWlzc2lvbiI6IiJ9.nLFz5Zlwar84GvpC2ULcv5i7XaehRYD5XWqQQZDEcVE', 1570553564),
(511, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3MDU1NTg0OSwiZXhwIjoxNTcwNTU3NjQ5LCJwZXJtaXNzaW9uIjoiIn0._9olOIkHE-3hevBBYlNlo4kodx_k6Toyr5FcJeTm4Hs', 1570557649),
(514, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwNTU2MDc1LCJleHAiOjE1NzA1NTc4NzUsInBlcm1pc3Npb24iOiIifQ.55vAWNlEExa5XGnrHR5RcXVJitgwTdq6vRMn9k5Ab3c', 1570557875),
(520, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTcwNTYwMzU4LCJleHAiOjE1NzA1NjIxNTgsInBlcm1pc3Npb24iOiIifQ.IaqG0bkKjYI9YiASst5q3Z4rJWEQVdhCyGohIqUTZLE', 1570562158),
(526, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwNTY0MTExLCJleHAiOjE1NzA1NjU5MTEsInBlcm1pc3Npb24iOiIifQ.poKcv2VNx09uTcU2A1aq9_Z2_OoAxqJbO1kRpKHyEBU', 1570565911),
(532, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzA1NzI0MzEsImV4cCI6MTU3MDU3NDIzMSwicGVybWlzc2lvbiI6IiJ9.PASKD3FhVGb87AwMUmx1_jTKP_wvtHziENQ0R-DIYXM', 1570574231),
(535, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwNTczMjA1LCJleHAiOjE1NzA1NzUwMDUsInBlcm1pc3Npb24iOiIifQ.yVxIQatzT_A0biEs7Xtuo0aaKbROMcqY1Aq-Stle9Uo', 1570575005),
(541, 1743, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzQzIiwidXNlcm1haWwiOiJwZWRyb2QzM0B1YS5wdCIsImlhdCI6MTU3MDYxMDQ4MiwiZXhwIjoxNTcwNjEyMjgyLCJwZXJtaXNzaW9uIjoiIn0.iGsKDy6ImVWrCPljpa2lF2Iu_nAEO-0n0RK2UzKt94o', 1570612282),
(544, 993, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTMiLCJ1c2VybWFpbCI6ImJydW5vc2JAdWEucHQiLCJpYXQiOjE1NzA2MTA0ODQsImV4cCI6MTU3MDYxMjI4NCwicGVybWlzc2lvbiI6IiJ9.eKldv70mK63MAV2HW7FGgku2ifUE4IF-p9e_qNGb20w', 1570612284),
(550, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDYxNzQ0NCwiZXhwIjoxNTcwNjE5MjQ0LCJwZXJtaXNzaW9uIjoiIn0.tTbaf-Mu-KHBWny63bTS2bIf0F7f_rUcWuwnJm7MPkI', 1570619244),
(556, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwNjE4MDU0LCJleHAiOjE1NzA2MTk4NTQsInBlcm1pc3Npb24iOiIifQ.1hhUg2OVJW4AcAjbPAPTmqEai63NX1dpoa5dG8Se_2Q', 1570619854),
(562, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1NzA2MjE4NTIsImV4cCI6MTU3MDYyMzY1MiwicGVybWlzc2lvbiI6IiJ9.3u5pQHd6EfNjSQJiZnJpi3CByh8-vXlSXQ_MKDFULF4', 1570623652),
(565, 2061, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYxIiwidXNlcm1haWwiOiJwZGZsQHVhLnB0IiwiaWF0IjoxNTcwNjIyNjQzLCJleHAiOjE1NzA2MjQ0NDMsInBlcm1pc3Npb24iOiIifQ.K-JFN_Hcpyiv3tw_f5rj8JWt3G5uwZjuGMpZ3DXxSEA', 1570624443),
(571, 1059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDU5IiwidXNlcm1haWwiOiJjbXNvYXJlc0B1YS5wdCIsImlhdCI6MTU3MDYzMTI4MywiZXhwIjoxNTcwNjMzMDgzLCJwZXJtaXNzaW9uIjoiIn0.f1p0msgpz-stfIgIJHD53znfIybg2_S7jZ7jcq5CDCk', 1570633083),
(577, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDYzNDQyNywiZXhwIjoxNTcwNjM2MjI3LCJwZXJtaXNzaW9uIjoiIn0.5wgVMiGm5I4AgU_umiecBuFHOssBJ00hy6v-Uc_ostc', 1570636227),
(580, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDYzNDY2NCwiZXhwIjoxNTcwNjM2NDY0LCJwZXJtaXNzaW9uIjoiIn0.yeW5TLX2xO7wFsBS-4vJLeuDW_PqLKNNO2PZ6lRciQM', 1570636464),
(583, 1734, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzM0IiwidXNlcm1haWwiOiJwZWRyb2Fnb25jYWx2ZXNtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTcwNjM1MjA1LCJleHAiOjE1NzA2MzcwMDUsInBlcm1pc3Npb24iOiIifQ.lPMxaGYnsVwY64SEoDjxkVrg3ojDLuaAc0MEf2_BrmM', 1570637005),
(589, 840, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDAiLCJ1c2VybWFpbCI6ImFhbXJvZHJpZ3Vlc0B1YS5wdCIsImlhdCI6MTU3MDY0NDg1MywiZXhwIjoxNTcwNjQ2NjUzLCJwZXJtaXNzaW9uIjoiIn0.cDNoxxKypTNbgQVEg0hO--A2JgTnz0eOGYoB6fiKfIs', 1570646653),
(592, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzA2NDc1MzAsImV4cCI6MTU3MDY0OTMzMCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.morw9VpGCFgLMjCBt95Clg2KL5eYWc8YhrX6ArEdcKs', 1570649330),
(595, 2055, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU1IiwidXNlcm1haWwiOiJtaWd1ZWwuci5mZXJyZWlyYUB1YS5wdCIsImlhdCI6MTU3MDY0ODk3MywiZXhwIjoxNTcwNjUwNzczLCJwZXJtaXNzaW9uIjoiIn0.f_fhXpJI9PBKffp_p8ugZ9Vojcn48yh-n94jaSJDkWQ', 1570650773),
(598, 2061, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYxIiwidXNlcm1haWwiOiJwZGZsQHVhLnB0IiwiaWF0IjoxNTcwNjUwMDQyLCJleHAiOjE1NzA2NTE4NDIsInBlcm1pc3Npb24iOiIifQ.raNcOGpKgmxEIaokOmHgsCrUWbOJOlLmzL1o6a9LvdA', 1570651842),
(601, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwNjUwMjA0LCJleHAiOjE1NzA2NTIwMDQsInBlcm1pc3Npb24iOiIifQ.4MVAblSWVdyNw4lCyXRWy_htKSKdEKgr_4dm4ZPCDpI', 1570652004),
(604, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTcwNjUzMDc3LCJleHAiOjE1NzA2NTQ4NzcsInBlcm1pc3Npb24iOiIifQ.kdBSLlU9mUyXunRT_x_NvaMzIstbKmvvZLYGEDfDJ9I', 1570654877),
(610, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzA2NTg2ODQsImV4cCI6MTU3MDY2MDQ4NCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.rT_-5jYvvPB9V83wdlpWq8qAGDP3jhswXOL8jMv8nDY', 1570660484),
(613, 993, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTMiLCJ1c2VybWFpbCI6ImJydW5vc2JAdWEucHQiLCJpYXQiOjE1NzA2NTk0MTcsImV4cCI6MTU3MDY2MTIxNywicGVybWlzc2lvbiI6IiJ9.5HBe-uGfoN5h800mnknDhHuN2XUtXwQtCBOJySwq4GU', 1570661217),
(616, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcwNjU5NjA1LCJleHAiOjE1NzA2NjE0MDUsInBlcm1pc3Npb24iOiIifQ.9y4lS5_HPF5x1zGNgtAERyCO8fZQGMjk3eZ8b0c0HgA', 1570661405),
(622, 1182, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTgyIiwidXNlcm1haWwiOiJkdWFydGUubnRtQHVhLnB0IiwiaWF0IjoxNTcwNjk5OTIxLCJleHAiOjE1NzA3MDE3MjEsInBlcm1pc3Npb24iOiIifQ.RWA9x5sCUGn-ENfbENLMYsqOBKjwtNqwSCYp0KSezBc', 1570701721),
(625, 1956, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTU2IiwidXNlcm1haWwiOiJ0aWFnby5zcnYub2xpdmVpcmFAdWEucHQiLCJpYXQiOjE1NzA3MDAyOTcsImV4cCI6MTU3MDcwMjA5NywicGVybWlzc2lvbiI6IiJ9.R8wgKRqZD51cOE5t5W6eazo3hXYYjYO31lDDjh9ZKr4', 1570702097),
(628, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTcwNzAxNTk2LCJleHAiOjE1NzA3MDMzOTYsInBlcm1pc3Npb24iOiIifQ.TutVJl1KIJGkPWRcXm3DykN2iOFqc1Z1yyTByxukjBs', 1570703396),
(631, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTcwNzAyNzI5LCJleHAiOjE1NzA3MDQ1MjksInBlcm1pc3Npb24iOiIifQ.H5u3y5QfBDihY9PxmXkSWE1T1zy8YUbBFeS1D4RKDNQ', 1570704529),
(637, 1761, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzYxIiwidXNlcm1haWwiOiJwZWRyb21tQHVhLnB0IiwiaWF0IjoxNTcwNzE3NTczLCJleHAiOjE1NzA3MTkzNzMsInBlcm1pc3Npb24iOiIifQ.PEWUYH4A64MNSUwtiz8UdxX8YrXkHPkjLSCEuUX4gJM', 1570719373),
(643, 873, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NzMiLCJ1c2VybWFpbCI6ImFsZXhhbmRyZWpmbG9wZXNAdWEucHQiLCJpYXQiOjE1NzA3MjAzMDksImV4cCI6MTU3MDcyMjEwOSwicGVybWlzc2lvbiI6IiJ9.Zjct9T4PUfXHHRwleRb94ssYufHnAKMBOjRelrAErWE', 1570722109),
(646, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzA3MjA1NjcsImV4cCI6MTU3MDcyMjM2NywicGVybWlzc2lvbiI6IiJ9.pmSsj09u_8yWbAMnNjjg7GtuS6Vi4r_yYhfId9eeQRk', 1570722367),
(652, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzA3MzA5NDgsImV4cCI6MTU3MDczMjc0OCwicGVybWlzc2lvbiI6IiJ9.oO1SACwU10VLPCusWCzig_s1asY-mle0nlvtFfagVUA', 1570732748),
(661, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzA3Mzc1MjgsImV4cCI6MTU3MDczOTMyOCwicGVybWlzc2lvbiI6IiJ9.xNML1loXTo2vl-L1eDdoTqTWclVxRUGxP_54mOxsRPA', 1570739328),
(664, 918, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MTgiLCJ1c2VybWFpbCI6ImFuZHJlYnJhbmRhb0B1YS5wdCIsImlhdCI6MTU3MDc0MDMwOCwiZXhwIjoxNTcwNzQyMTA4LCJwZXJtaXNzaW9uIjoiIn0.Ktp6kmjHJrazekyY71NQk_y23X0bPhzQQ2DRm-nunqc', 1570742108),
(670, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3MDc4MTQ0MCwiZXhwIjoxNTcwNzgzMjQwLCJwZXJtaXNzaW9uIjoiIn0.Kg_SbvsIy0xU-J3BrceEjWH1zHsRze-Z-KsaNp8_g-4', 1570783240),
(676, 1611, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjExIiwidXNlcm1haWwiOiJtYXJpYW5hc3BzQHVhLnB0IiwiaWF0IjoxNTcwNzg2MjIyLCJleHAiOjE1NzA3ODgwMjIsInBlcm1pc3Npb24iOiIifQ.YqCH0fXAf1ojq0b_CmITXrySueKeIeTryAh-yM2gnJQ', 1570788022),
(682, 1287, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjg3IiwidXNlcm1haWwiOiJnb25jYWxvcGFzc29zQHVhLnB0IiwiaWF0IjoxNTcwODA0NzQ2LCJleHAiOjE1NzA4MDY1NDYsInBlcm1pc3Npb24iOiIifQ.ZWUJHxNkzoG94NyGuKnvInn3tU5NTQJ413kDvlvJt30', 1570806546),
(685, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU3MDgwNTk0MywiZXhwIjoxNTcwODA3NzQzLCJwZXJtaXNzaW9uIjoiIn0.jRuParTzS-wPfm4_aFfcfIe44pNvDpIqM4AUjmrocMQ', 1570807743),
(691, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTcwODA5MDM1LCJleHAiOjE1NzA4MTA4MzUsInBlcm1pc3Npb24iOiIifQ.ErXvJPzTsd9mKCOwxRfxcbTEwwc9cmIKwkB3AMV9wVI', 1570810835),
(697, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwODEyNDA5LCJleHAiOjE1NzA4MTQyMDksInBlcm1pc3Npb24iOiIifQ.ef0NXFkVS-GIJxRVYe1T2TJLr77HxFD-smcLEqhCdqo', 1570814209),
(703, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDgxNjgyOCwiZXhwIjoxNTcwODE4NjI4LCJwZXJtaXNzaW9uIjoiIn0.SdaZTx3jBq2qIvPMp8isBqcQIalB1DT0T6vG3khjCpI', 1570818628),
(709, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3MDgzMDkwNywiZXhwIjoxNTcwODMyNzA3LCJwZXJtaXNzaW9uIjoiIn0.yQR6Osaqab97yM5wW06Bh3xI1BMzQABJnWsmwVPGESI', 1570832707),
(715, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwODYwNjQ1LCJleHAiOjE1NzA4NjI0NDUsInBlcm1pc3Npb24iOiIifQ.9oCOKClhMKwY4Xc46MhzM6M4f32kVBZyL0qpHSuCNhg', 1570862445),
(721, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwODc0Nzk1LCJleHAiOjE1NzA4NzY1OTUsInBlcm1pc3Npb24iOiIifQ.dgq-UZ_CU3pWOAn2T9jZLkZiSo9KiRoASPH7kM3RPic', 1570876595),
(727, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzA4ODAyOTAsImV4cCI6MTU3MDg4MjA5MCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.3iyinGPtcCtqLx_KSywzRMmh11c20z_Jtbm4jCw8rg0', 1570882090),
(733, 1827, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODI3IiwidXNlcm1haWwiOiJyaWNhcmRvLmNydXoyOUB1YS5wdCIsImlhdCI6MTU3MDg4OTgyMywiZXhwIjoxNTcwODkxNjIzLCJwZXJtaXNzaW9uIjoiIn0.iyJXVdDrgq97sl6I_706RTYNW2awPN8dntufdi5P2vs', 1570891623),
(736, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDg5MDY4NCwiZXhwIjoxNTcwODkyNDg0LCJwZXJtaXNzaW9uIjoiIn0.iaRUWKEbgxBJwC0SO6lNuwau0B78vm44hEeyQRxIVPU', 1570892484),
(739, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU3MDg5MzI5MywiZXhwIjoxNTcwODk1MDkzLCJwZXJtaXNzaW9uIjoiIn0.vffEeGsr08YaTsKUke7Dh8iuDPT2EMVZcxr38mdDyAs', 1570895093),
(742, 2045, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ1IiwidXNlcm1haWwiOiJodWdvZ29uY2FsdmVzMTNAdWEucHQiLCJpYXQiOjE1NzA4OTM1MTUsImV4cCI6MTU3MDg5NTMxNSwicGVybWlzc2lvbiI6IiJ9.LUljnT47S-P3Lfqf3U6_hFOdb1GxUSROUJPr36vmvFA', 1570895315),
(745, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTcwODk0NDQ4LCJleHAiOjE1NzA4OTYyNDgsInBlcm1pc3Npb24iOiIifQ.Rs1ZcTVEcqN8uygJIUuPmbBqn7mLuKDVXtKJM4pfC6o', 1570896248),
(748, 840, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDAiLCJ1c2VybWFpbCI6ImFhbXJvZHJpZ3Vlc0B1YS5wdCIsImlhdCI6MTU3MDg5NjE1MiwiZXhwIjoxNTcwODk3OTUyLCJwZXJtaXNzaW9uIjoiIn0.vevzwKg1CpG_J-1j1IX9rrNId8kuG5nIIw61EX3LLw0', 1570897952),
(751, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwODk3MzExLCJleHAiOjE1NzA4OTkxMTEsInBlcm1pc3Npb24iOiIifQ.-NByz2YongDo7FDqsWt6Z1VVD25yxA62slc0MNqyYZY', 1570899111),
(754, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTcwOTAwNjg0LCJleHAiOjE1NzA5MDI0ODQsInBlcm1pc3Npb24iOiIifQ._dBk1F3MzgAnDYyS4CcXfFwXv2sOwVUkdPU4zMKc69s', 1570902484),
(760, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1NzA5MTAyODUsImV4cCI6MTU3MDkxMjA4NSwicGVybWlzc2lvbiI6IiJ9.Nl7pMhyYnRT1SRD_MfaFSHraitOiMMn25EoPqNI5DbE', 1570912085),
(763, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1NzA5MTMyMDksImV4cCI6MTU3MDkxNTAwOSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.JJumxBn1atcIUDmkAGs6CNdxkordqVz8yEQeHYQGRCA', 1570915009),
(769, 2092, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDkyIiwidXNlcm1haWwiOiJwZWQucm9kckB1YS5wdCIsImlhdCI6MTU3MDkyMzE0NCwiZXhwIjoxNTcwOTI0OTQ0LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.T5Rl5lD58EOMFdG7zJI5rW9esxuvrjT3gjtU2WCNst0', 1570924944),
(775, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MDk1NjUxNywiZXhwIjoxNTcwOTU4MzE3LCJwZXJtaXNzaW9uIjoiIn0.eooQ_LGbV-8udSm_SFkXEfb3bcla2OB-L4q-h_3WOpY', 1570958317),
(781, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTcwOTYwNzQzLCJleHAiOjE1NzA5NjI1NDMsInBlcm1pc3Npb24iOiIifQ.oHSbMb26fVL9l8TjMHLrxlydsOTPuRfzpbHlGFvnWF4', 1570962543),
(787, 1701, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzAxIiwidXNlcm1haWwiOiJwLnNlaXhhczk2QHVhLnB0IiwiaWF0IjoxNTcwOTY2OTI0LCJleHAiOjE1NzA5Njg3MjQsInBlcm1pc3Npb24iOiIifQ.7rPji6nTStUNy5D0kRaqXU_2CnnjH4H7kyNuGB_3PfA', 1570968724),
(793, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU3MDk3MTg5OCwiZXhwIjoxNTcwOTczNjk4LCJwZXJtaXNzaW9uIjoiIn0.v7ZadnPmZcptffdJkOvmw8gIvzLtR5rZwIvQYRUjyqw', 1570973698),
(799, 1821, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODIxIiwidXNlcm1haWwiOiJyZm1mQHVhLnB0IiwiaWF0IjoxNTcwOTc1NjUyLCJleHAiOjE1NzA5Nzc0NTIsInBlcm1pc3Npb24iOiIifQ.uPiQIYkcmOLTVescPj1Zyfmwb5eh0eYXGjUlikKUnjI', 1570977452),
(802, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzA5Nzc3NDgsImV4cCI6MTU3MDk3OTU0OCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.sivse-tj_sYNEg8v0J80ZySrD2OStqKEiW1ryhepOV4', 1570979548),
(805, 1821, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODIxIiwidXNlcm1haWwiOiJyZm1mQHVhLnB0IiwiaWF0IjoxNTcwOTc5MjQyLCJleHAiOjE1NzA5ODEwNDIsInBlcm1pc3Npb24iOiIifQ.viEjMorGVoHoku1KA5oHWKn2WIc8ZHm_JcQN30Yl8KI', 1570981042),
(808, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcwOTc5OTYzLCJleHAiOjE1NzA5ODE3NjMsInBlcm1pc3Npb24iOiIifQ.MezmRE058hNeIDhnzySQzxwnaeASj6cvPBppaXTMPhY', 1570981763),
(811, 2038, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM4IiwidXNlcm1haWwiOiJlZHVhcmRvZmVybmFuZGVzQHVhLnB0IiwiaWF0IjoxNTcwOTgwNzc5LCJleHAiOjE1NzA5ODI1NzksInBlcm1pc3Npb24iOiIifQ.DFs6l0U6xFexYneuiQkRVvfQ9K-x2yrK202dlZqmfKs', 1570982579),
(814, 1620, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjIwIiwidXNlcm1haWwiOiJtYXJpb3NpbHZhQHVhLnB0IiwiaWF0IjoxNTcwOTgyMTYxLCJleHAiOjE1NzA5ODM5NjEsInBlcm1pc3Npb24iOiIifQ.m4CcIRaabVWo2PJJ3zUabgC0VfWjrr1MeIzHAQsUyNE', 1570983961),
(817, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU3MDk4Mjg3NiwiZXhwIjoxNTcwOTg0Njc2LCJwZXJtaXNzaW9uIjoiIn0.1FsZkhVUXDKtOuIb_bM7NvfE4ebBifjlyzsfb__Ctas', 1570984676),
(820, 1722, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzIyIiwidXNlcm1haWwiOiJwZWRyby5taWd1ZWw1MEB1YS5wdCIsImlhdCI6MTU3MDk4NDk4MCwiZXhwIjoxNTcwOTg2NzgwLCJwZXJtaXNzaW9uIjoiIn0.jvS1kBkYe8TeqSBCJr9pElPwJiVGFOajfke2jsytDsY', 1570986780),
(823, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1NzA5ODY2MTQsImV4cCI6MTU3MDk4ODQxNCwicGVybWlzc2lvbiI6IiJ9.BKEOJ8jlGn32yBMAMTROqWH4zGsOg4uoMpXXftDif8w', 1570988414),
(826, 1182, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTgyIiwidXNlcm1haWwiOiJkdWFydGUubnRtQHVhLnB0IiwiaWF0IjoxNTcwOTg4MTYxLCJleHAiOjE1NzA5ODk5NjEsInBlcm1pc3Npb24iOiIifQ.8trw_uIMjfGXM9OYaZfcI8d0Qcq6z-mHfnBvFuR6H-o', 1570989961),
(829, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzA5OTExMDUsImV4cCI6MTU3MDk5MjkwNSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.j8VsfhtR1tYOXk3dvz6H71qnC6Oj0myn66vHGhJ4sBA', 1570992905),
(835, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTcxMDAxNzU4LCJleHAiOjE1NzEwMDM1NTgsInBlcm1pc3Npb24iOiIifQ.Tac8B-VWi3FF1GKtaGv0pmBJWJChJxVwtOQDnb7XUHQ', 1571003558),
(841, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1NzEwMDQ3MTgsImV4cCI6MTU3MTAwNjUxOCwicGVybWlzc2lvbiI6IiJ9.39jlUvNP2YZ-3TY01VYpNcvrIgQ6utfjlaOwAzMf_AE', 1571006518),
(847, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1NzEwNDAxNjgsImV4cCI6MTU3MTA0MTk2OCwicGVybWlzc2lvbiI6IiJ9.gqUGB_9hIAP_0XnT1L-jKl08dAyfiXFAw1_7vD36-9w', 1571041968),
(853, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MTA0NDk3MSwiZXhwIjoxNTcxMDQ2NzcxLCJwZXJtaXNzaW9uIjoiIn0.ludz8O54d6hO2YjEpzOspZHgEtd12hJV4WSQXAkw99c', 1571046771),
(859, 1146, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTQ2IiwidXNlcm1haWwiOiJkaW9nby5lLm1vcmVpcmFAdWEucHQiLCJpYXQiOjE1NzEwNDgzNjEsImV4cCI6MTU3MTA1MDE2MSwicGVybWlzc2lvbiI6IiJ9.Cb-yYiv1VgrBPrwjM7VrZeaZwld5Kd8Ax7QEx7o_9QY', 1571050161),
(865, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzEwNTg1ODMsImV4cCI6MTU3MTA2MDM4MywicGVybWlzc2lvbiI6IiJ9.5nnG2j-tS_afFFz-3WNrpTA8tSnkVCUu73h36vhRviw', 1571060383),
(868, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MTA1ODYyNiwiZXhwIjoxNTcxMDYwNDI2LCJwZXJtaXNzaW9uIjoiIn0.IV95cEHCTGbT0yN5Y-1KkTgjsZrUzrzRvx_Zrc7Ma5Y', 1571060426),
(874, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MTA2NDgxOCwiZXhwIjoxNTcxMDY2NjE4LCJwZXJtaXNzaW9uIjoiIn0.abfFD4aP4CseuGi2J26DUdPXb04-X0JtkRqA8ycbStQ', 1571066618),
(880, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzEwNjkzODYsImV4cCI6MTU3MTA3MTE4NiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.5-vCbHNaRrtGmZ4iqIK6F1FKGNZ_PbyHUp6Nuw8JSz4', 1571071186),
(886, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTcxMDcyMzAzLCJleHAiOjE1NzEwNzQxMDMsInBlcm1pc3Npb24iOiIifQ.xaZwXjBxDSCETHs-6tnZoTHWauBueKnJjh1ub2HJX78', 1571074103),
(889, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzEwNzM3MzAsImV4cCI6MTU3MTA3NTUzMCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.O3eMQXMS1-jbOXVMB6FYs7zm4BLbl_Slx4BaZgiq43U', 1571075530),
(892, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzEwNzQ2NTgsImV4cCI6MTU3MTA3NjQ1OCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.cMnEbLkVAFjNqkrJduqeMm02_6xmgKjucyXEpMKL2tI', 1571076458),
(895, 2028, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI4IiwidXNlcm1haWwiOiJjZmZvbnNlY2FAdWEucHQiLCJpYXQiOjE1NzEwNzYzNDgsImV4cCI6MTU3MTA3ODE0OCwicGVybWlzc2lvbiI6IiJ9.Bix4ZUpkadcOlUarDcxrEnDe11QecErIjUK3wIx8Q_k', 1571078148),
(898, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxMDc4MTQwLCJleHAiOjE1NzEwNzk5NDAsInBlcm1pc3Npb24iOiIifQ.LvLBZi0Auanuue71gIBMdaP9bhL13CSaJSjVtn1EH0A', 1571079940),
(901, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzEwODAwMDIsImV4cCI6MTU3MTA4MTgwMiwicGVybWlzc2lvbiI6IiJ9.i8p7TW6kemGZQ4iOOT2-Tp_LUJU0JkC8FDg44lCaxzg', 1571081802),
(904, 1734, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzM0IiwidXNlcm1haWwiOiJwZWRyb2Fnb25jYWx2ZXNtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTcxMDgwMDk0LCJleHAiOjE1NzEwODE4OTQsInBlcm1pc3Npb24iOiIifQ.WhEKob0FyH-HMAELmuJz-LLgfV0JXx0L32CmilrEmjA', 1571081894),
(907, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxMDgzNDEzLCJleHAiOjE1NzEwODUyMTMsInBlcm1pc3Npb24iOiIifQ.K7T_6oYTzQFRApi_fxy5qagInYzvX4x7bcguZBrCmk0', 1571085213),
(910, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzEwODM2ODQsImV4cCI6MTU3MTA4NTQ4NCwicGVybWlzc2lvbiI6IiJ9.yB7ZgO45GrYyk9tknrqf6_Mdmkf5RO0EkSU7AxFT0gk', 1571085484),
(913, 1689, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjg5IiwidXNlcm1haWwiOiJudW5vLm1hdGFtYmFAdWEucHQiLCJpYXQiOjE1NzEwODYzOTgsImV4cCI6MTU3MTA4ODE5OCwicGVybWlzc2lvbiI6IiJ9.e2g9u50xIvOXi0i-bEZSi2sw1PiW4ciWtffZRWbY9j8', 1571088198),
(919, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzEwOTQyNDQsImV4cCI6MTU3MTA5NjA0NCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.sych2wIheBh564hWa4oCmSFWfuoxNitjSOrehIONhaA', 1571096044),
(925, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxMTM1NDY5LCJleHAiOjE1NzExMzcyNjksInBlcm1pc3Npb24iOiIifQ.YeYseM_Sx7jQSU9bxDVBKo3vTVmn1Gdd2UGf5XAQAFk', 1571137269),
(931, 1494, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDk0IiwidXNlcm1haWwiOiJqb3NlcmVpc0B1YS5wdCIsImlhdCI6MTU3MTE0NjQ0MywiZXhwIjoxNTcxMTQ4MjQzLCJwZXJtaXNzaW9uIjoiIn0.Ma424NClHPZRfFEzAaPtUWPxpdf7lEhuo0lFMGWchCw', 1571148243),
(937, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MTE1NjYzMiwiZXhwIjoxNTcxMTU4NDMyLCJwZXJtaXNzaW9uIjoiIn0.iRPyrzLesTM_ZKzmWjBAfgX1cy0HOWwBW6a9iyi43hk', 1571158432),
(940, 1644, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjQ0IiwidXNlcm1haWwiOiJtaWd1ZWwuZnJhZGluaG9AdWEucHQiLCJpYXQiOjE1NzExNTcwMTAsImV4cCI6MTU3MTE1ODgxMCwicGVybWlzc2lvbiI6IiJ9.vL4II384AMfZ6pcsGDr7UXN74st9Vq5bJpI00bBH6cY', 1571158810),
(946, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxMTU5NzE4LCJleHAiOjE1NzExNjE1MTgsInBlcm1pc3Npb24iOiIifQ.GmyASrq2to88LR2uzYuZX1xtZgB7orgyonq8cTVKE5w', 1571161518),
(952, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxMTYyOTc0LCJleHAiOjE1NzExNjQ3NzQsInBlcm1pc3Npb24iOiIifQ.jJcCqrXxiHJtYi8YXEXHxrQUIOMW8hizJ7enfwYycU4', 1571164774),
(955, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzExNjQ3NjAsImV4cCI6MTU3MTE2NjU2MCwicGVybWlzc2lvbiI6IiJ9.lwIyaOGAx8-OSr20vFYh3rlffsLFwyrCA2GUHUGDqdo', 1571166560),
(961, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1NzExNjgwMzcsImV4cCI6MTU3MTE2OTgzNywicGVybWlzc2lvbiI6IiJ9.3j2IbrGvKMjmKGy_KABHbHdkFAtbNXpkB3fLEHQXrGY', 1571169837),
(964, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3MTE2ODI1NiwiZXhwIjoxNTcxMTcwMDU2LCJwZXJtaXNzaW9uIjoiIn0.D7UG7byMF9CWfy3iG7XrmghlXpRGEXDn6oTsmkoyc0M', 1571170056),
(967, 933, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MzMiLCJ1c2VybWFpbCI6ImFudGhvbnlwZXJlaXJhQHVhLnB0IiwiaWF0IjoxNTcxMTY5MTg4LCJleHAiOjE1NzExNzA5ODgsInBlcm1pc3Npb24iOiIifQ.EH-opaoqbdW9cKrKlMRIffVfEQ4BTUT_gik8HfC52JI', 1571170988),
(973, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1NzExNzgzNDcsImV4cCI6MTU3MTE4MDE0NywicGVybWlzc2lvbiI6IiJ9.s11FhS-jQfWR1q1nrX0PGZEjm_bNcBowb2iXm-Vjnvc', 1571180147);
INSERT INTO `GenTokens` (`id`, `userid`, `token`, `expire_date`) VALUES
(979, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTcxMTgzOTYxLCJleHAiOjE1NzExODU3NjEsInBlcm1pc3Npb24iOiIifQ.USeUSQ3fK4H3XzDyLMLUJBv9bMosgK2-VR19Usdv4_s', 1571185761),
(982, 1704, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzA0IiwidXNlcm1haWwiOiJwYXRyb2NpbmlvYW5kcmVpYUB1YS5wdCIsImlhdCI6MTU3MTE4NDEzMiwiZXhwIjoxNTcxMTg1OTMyLCJwZXJtaXNzaW9uIjoiIn0.TIw473fY745h7qA8l9zFfmTQ2-d0EbhhIKOSxV7weT4', 1571185932),
(988, 1734, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzM0IiwidXNlcm1haWwiOiJwZWRyb2Fnb25jYWx2ZXNtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTcxMjIxMjkwLCJleHAiOjE1NzEyMjMwOTAsInBlcm1pc3Npb24iOiIifQ.qaAAGSTlX4M8CJ69fr6-f6nAtjmXP3jGt1NaRN_vjag', 1571223090),
(991, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTcxMjIxNTE2LCJleHAiOjE1NzEyMjMzMTYsInBlcm1pc3Npb24iOiIifQ.ZZ-zTEbgwttBKC9Nxlkthiuq_FHEUj-6wdL_Bja6jTI', 1571223316),
(994, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxMjIzNTYxLCJleHAiOjE1NzEyMjUzNjEsInBlcm1pc3Npb24iOiIifQ.DokpO1E9mhZrCzN-i3d-VHacW5foBWfQrWI020Em7TU', 1571225361),
(1000, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxMjMwNzYwLCJleHAiOjE1NzEyMzI1NjAsInBlcm1pc3Npb24iOiIifQ.F17uBV7TjlcvoAO54CpERRvKmwxeUyjbNAgLEl7q9KQ', 1571232560),
(1003, 870, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NzAiLCJ1c2VybWFpbCI6ImFsZXhhbmRyYWNhcnZhbGhvQHVhLnB0IiwiaWF0IjoxNTcxMjMwOTMyLCJleHAiOjE1NzEyMzI3MzIsInBlcm1pc3Npb24iOiIifQ.Q1oSacKY_4HeAFcaOrvwLUFrghAoQ68WYMvGr6UpMDk', 1571232732),
(1006, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1NzEyMzE3NjQsImV4cCI6MTU3MTIzMzU2NCwicGVybWlzc2lvbiI6IiJ9.RJ5vEF6vAfpwPDCDq4D5yfMNFi2o_31Hv0oYmisjz8o', 1571233564),
(1009, 1698, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjk4IiwidXNlcm1haWwiOiJvcmxhbmRvLm1hY2VkbzE1QHVhLnB0IiwiaWF0IjoxNTcxMjMyMzAyLCJleHAiOjE1NzEyMzQxMDIsInBlcm1pc3Npb24iOiIifQ.4dzz4KxCsWSRYxkK4-NjyDQn9TuMJOmyBt9Bllh5aNc', 1571234102),
(1012, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU3MTIzNDAxMiwiZXhwIjoxNTcxMjM1ODEyLCJwZXJtaXNzaW9uIjoiIn0.vFwJkIQ7dn5z5b9HXYOHYmtLjkBSTBfC1pzHSBCDvNs', 1571235812),
(1015, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU3MTIzNDgzNCwiZXhwIjoxNTcxMjM2NjM0LCJwZXJtaXNzaW9uIjoiIn0.BdYqwBIhqozLVJcANoX9uWJJLvkh_xxrQMce8X41Q34', 1571236634),
(1018, 1827, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODI3IiwidXNlcm1haWwiOiJyaWNhcmRvLmNydXoyOUB1YS5wdCIsImlhdCI6MTU3MTIzNTYzNCwiZXhwIjoxNTcxMjM3NDM0LCJwZXJtaXNzaW9uIjoiIn0.PWGFsk1Ae2Q3Cml0hCKdfP6jdcicM-uAzlCZlPBo_to', 1571237434),
(1024, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTcxMjM4NjI0LCJleHAiOjE1NzEyNDA0MjQsInBlcm1pc3Npb24iOiIifQ.l-IX6v8rCtaxYgqfqJH4GaDVFBVgb-nFthsQKOXBCp0', 1571240424),
(1027, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3MTI0MTI0MywiZXhwIjoxNTcxMjQzMDQzLCJwZXJtaXNzaW9uIjoiIn0.ef-RnBiwrF37yj8XwzVh0qdy0UK1V_b_qv2-7yAHlTs', 1571243043),
(1033, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxMjQ0NTg1LCJleHAiOjE1NzEyNDYzODUsInBlcm1pc3Npb24iOiIifQ.VxvXh2_d9Z6Y86P5uFpTZg0sPaiQrK2RhiFEH-RG1-k', 1571246385),
(1036, 1359, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU5IiwidXNlcm1haWwiOiJqLmJyaXRvQHVhLnB0IiwiaWF0IjoxNTcxMjQ0ODY1LCJleHAiOjE1NzEyNDY2NjUsInBlcm1pc3Npb24iOiIifQ.Pzve22wOmsnP4tMWNIqpNnm2Bsc9TRggfPN1lcnBoYs', 1571246665),
(1039, 2061, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYxIiwidXNlcm1haWwiOiJwZGZsQHVhLnB0IiwiaWF0IjoxNTcxMjQ1NTkwLCJleHAiOjE1NzEyNDczOTAsInBlcm1pc3Npb24iOiIifQ.RYJlRZMSFdx88PaB6DLVnl9nBE1CwL1dx5arFlcTTO0', 1571247390),
(1042, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1NzEyNDU3MDIsImV4cCI6MTU3MTI0NzUwMiwicGVybWlzc2lvbiI6IiJ9.v5lkuZpprWl0MZl2TRkEaoBzvji_5Y8bfKrsW-6qZDk', 1571247502),
(1045, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3MTI0NjMzNSwiZXhwIjoxNTcxMjQ4MTM1LCJwZXJtaXNzaW9uIjoiIn0.Mwi1lhd4fVWozlXimoRRohRoNH7gJVTQGtC_BeWggrQ', 1571248135),
(1054, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxMjU4OTc0LCJleHAiOjE1NzEyNjA3NzQsInBlcm1pc3Npb24iOiIifQ.MXSm99WtNhaPSmcM16elPJCXC2lyOBnayj2Ywdi9cDQ', 1571260774),
(1060, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzEyNjYyNzAsImV4cCI6MTU3MTI2ODA3MCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.n_-RO_9FpbxuCKbcUnoZUia8DRncmVBxN42JUOpab0I', 1571268070),
(1066, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzEyNzg1NjMsImV4cCI6MTU3MTI4MDM2MywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.XFRZDveAzmUG2_4FBueDMwlyfn0dJdWz2EJ0mO-sM3o', 1571280363),
(1072, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTcxMzEwMDkyLCJleHAiOjE1NzEzMTE4OTIsInBlcm1pc3Npb24iOiIifQ.tw6nyPPwnd8pYrxPdnpUGb6-qH0vmDzr_hv5UeePpFI', 1571311892),
(1078, 1821, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODIxIiwidXNlcm1haWwiOiJyZm1mQHVhLnB0IiwiaWF0IjoxNTcxMzE5Njk5LCJleHAiOjE1NzEzMjE0OTksInBlcm1pc3Npb24iOiIifQ.txRSNUh-hAco3T8YIjidtLsz2dk6Ggg4CP9pGqkAiXs', 1571321499),
(1081, 1722, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzIyIiwidXNlcm1haWwiOiJwZWRyby5taWd1ZWw1MEB1YS5wdCIsImlhdCI6MTU3MTMxOTg0NCwiZXhwIjoxNTcxMzIxNjQ0LCJwZXJtaXNzaW9uIjoiIn0.8ujLtWQKnbMO637ddUgmXNkR8d12ho8yu04zvDvatsM', 1571321644),
(1087, 1689, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjg5IiwidXNlcm1haWwiOiJudW5vLm1hdGFtYmFAdWEucHQiLCJpYXQiOjE1NzEzMjI5OTUsImV4cCI6MTU3MTMyNDc5NSwicGVybWlzc2lvbiI6IiJ9.rSM2HWuwKTxWp_241aT-zpk9SediAgC2CWoH8h6HtvU', 1571324795),
(1090, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxMzIzMjY2LCJleHAiOjE1NzEzMjUwNjYsInBlcm1pc3Npb24iOiIifQ.ouru6SH681MMEPqut24YO6mqQE9sH4GnMLHyi5y8pGA', 1571325066),
(1093, 1722, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzIyIiwidXNlcm1haWwiOiJwZWRyby5taWd1ZWw1MEB1YS5wdCIsImlhdCI6MTU3MTMyNDQzNSwiZXhwIjoxNTcxMzI2MjM1LCJwZXJtaXNzaW9uIjoiIn0.fdjB3dfcSx1lMqTpp46VIk95Nn1hFRfZS-PQOok7QI0', 1571326235),
(1099, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1NzEzMjY1ODYsImV4cCI6MTU3MTMyODM4NiwicGVybWlzc2lvbiI6IiJ9.6m81AMNisb-jfclRzpzP3Za58LOFgu84HDfhlbIfu8o', 1571328386),
(1102, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1NzEzMjY1OTQsImV4cCI6MTU3MTMyODM5NCwicGVybWlzc2lvbiI6IiJ9.nFH8waDl0Eq4db35ZkXphOsvr-5hh2fs__oaYGdqgV0', 1571328394),
(1105, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1NzEzMjY2MDcsImV4cCI6MTU3MTMyODQwNywicGVybWlzc2lvbiI6IiJ9.4-L0T7LQRrYsDbEue5vzCu7IxERc1XnieLDb2icCWds', 1571328407),
(1108, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1NzEzMjY2MjYsImV4cCI6MTU3MTMyODQyNiwicGVybWlzc2lvbiI6IiJ9.H9jAn7elrX4TBweurdp5sGq28HqucXx3Cj74k5M1fn0', 1571328426),
(1111, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1NzEzMjY2MjksImV4cCI6MTU3MTMyODQyOSwicGVybWlzc2lvbiI6IiJ9.HCy9_ip4PwWvaNHNHvzjrA34kDmKi8d3ngpCbMyZi1Y', 1571328429),
(1120, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1NzEzMzAwNzIsImV4cCI6MTU3MTMzMTg3MiwicGVybWlzc2lvbiI6IiJ9.DMRvh775ZtX8l6fIlgw2YaIbMzh7UJFjW9oJ9iQQ-aQ', 1571331872),
(1126, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzEzMzMwNjUsImV4cCI6MTU3MTMzNDg2NSwicGVybWlzc2lvbiI6IiJ9.nGA7VXW6fpTgT2e7FW_FAR9e16x28aunizeNiW7UG2o', 1571334865),
(1129, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTcxMzMzMzk5LCJleHAiOjE1NzEzMzUxOTksInBlcm1pc3Npb24iOiIifQ.xpqI48SCkWZNscBWl3ytMVhUyC9GiimlIvNhyLRTjzk', 1571335199),
(1132, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzEzMzM1MDIsImV4cCI6MTU3MTMzNTMwMiwicGVybWlzc2lvbiI6IiJ9.T6fQU5qDYXRXxkRuFs3glDo86XLGW4K0pbx0Et-Y6Pg', 1571335302),
(1138, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MTM0OTAyNSwiZXhwIjoxNTcxMzUwODI1LCJwZXJtaXNzaW9uIjoiIn0.JebNEXIBpKQSTbn1WEiCwkqoEdALVPQKVux8BtBKRbc', 1571350825),
(1144, 2055, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU1IiwidXNlcm1haWwiOiJtaWd1ZWwuci5mZXJyZWlyYUB1YS5wdCIsImlhdCI6MTU3MTM1NjIxNiwiZXhwIjoxNTcxMzU4MDE2LCJwZXJtaXNzaW9uIjoiIn0.JVZvFh4odu_brrC_IgSnPUlZpmdtTG50UhkcybQZfUA', 1571358016),
(1150, 2061, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYxIiwidXNlcm1haWwiOiJwZGZsQHVhLnB0IiwiaWF0IjoxNTcxMzk0MzEwLCJleHAiOjE1NzEzOTYxMTAsInBlcm1pc3Npb24iOiIifQ.AY6fZJxQPIdESFEWjZ8Lr8X_KXIwXBDxpfvyRdMtWbQ', 1571396110),
(1156, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTcxNDA4NzQwLCJleHAiOjE1NzE0MTA1NDAsInBlcm1pc3Npb24iOiIifQ.49oEnZVCSP26fLwV0gqcTUVVCS83LrHH_4GeW8hhL30', 1571410540),
(1159, 2055, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU1IiwidXNlcm1haWwiOiJtaWd1ZWwuci5mZXJyZWlyYUB1YS5wdCIsImlhdCI6MTU3MTQwOTM1NywiZXhwIjoxNTcxNDExMTU3LCJwZXJtaXNzaW9uIjoiIn0.gjoyYYrTq5KMlBMQngcJBxqzgsIv6gmkITDIbDZlnm4', 1571411157),
(1165, 1821, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODIxIiwidXNlcm1haWwiOiJyZm1mQHVhLnB0IiwiaWF0IjoxNTcxNDE3NjM0LCJleHAiOjE1NzE0MTk0MzQsInBlcm1pc3Npb24iOiIifQ.2q0hpQrBKe9kcOF9QVSmuAtwotj7KqWQrl-aOFoHeJU', 1571419434),
(1171, 2028, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI4IiwidXNlcm1haWwiOiJjZmZvbnNlY2FAdWEucHQiLCJpYXQiOjE1NzE0MjI0ODUsImV4cCI6MTU3MTQyNDI4NSwicGVybWlzc2lvbiI6IiJ9.neM5B1tE4MVGJUZfO_AEjTEaaGUtlhS5ojDCD7DW6ts', 1571424285),
(1174, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTcxNDI1MzA0LCJleHAiOjE1NzE0MjcxMDQsInBlcm1pc3Npb24iOiIifQ.3PmCmYL4X9MWWU0wMKaLiJFS-mNVaj87tf3FMqWk7tU', 1571427104),
(1177, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTcxNDI2MDU4LCJleHAiOjE1NzE0Mjc4NTgsInBlcm1pc3Npb24iOiIifQ.LeNdQazneGyfAzpg98h54KP5Ao9ainlrhuqCc3Qiuek', 1571427858),
(1180, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTcxNDI5ODY2LCJleHAiOjE1NzE0MzE2NjYsInBlcm1pc3Npb24iOiIifQ.v8L19Rr6T1-h6D9_LPLPKQMx_1jD6igaeKfDxKRUGW4', 1571431666),
(1186, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTcxNDgzMTQ1LCJleHAiOjE1NzE0ODQ5NDUsInBlcm1pc3Npb24iOiIifQ.XLQW3_-svX8GznE9IAv-f8CUwTgwx6lzU3HzQQmuZLU', 1571484945),
(1189, 1473, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDczIiwidXNlcm1haWwiOiJqb3NlLnZhekB1YS5wdCIsImlhdCI6MTU3MTQ4NTIwMCwiZXhwIjoxNTcxNDg3MDAwLCJwZXJtaXNzaW9uIjoiIn0.WaLGsiW4b7Ugo53Sqevd87TGDmE3z1nblqGNxY6YRK4', 1571487000),
(1195, 933, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MzMiLCJ1c2VybWFpbCI6ImFudGhvbnlwZXJlaXJhQHVhLnB0IiwiaWF0IjoxNTcxNDg4MzA5LCJleHAiOjE1NzE0OTAxMDksInBlcm1pc3Npb24iOiIifQ.e79yw2ezinvVGIiisAv06O_kaHHAKWSWWO22BkPj_PM', 1571490109),
(1198, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzE0ODg1MzEsImV4cCI6MTU3MTQ5MDMzMSwicGVybWlzc2lvbiI6IiJ9.qp-u-40E_vKtMacs8otfzy01DGmHhv1VwjN-gsXecWE', 1571490331),
(1201, 2028, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI4IiwidXNlcm1haWwiOiJjZmZvbnNlY2FAdWEucHQiLCJpYXQiOjE1NzE0OTE1MTgsImV4cCI6MTU3MTQ5MzMxOCwicGVybWlzc2lvbiI6IiJ9.DIdhE-3SUhxdvtGtClPJ6Ife9XPWsG8Hk3c6KNIyCL8', 1571493318),
(1204, 933, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MzMiLCJ1c2VybWFpbCI6ImFudGhvbnlwZXJlaXJhQHVhLnB0IiwiaWF0IjoxNTcxNDkxOTkzLCJleHAiOjE1NzE0OTM3OTMsInBlcm1pc3Npb24iOiIifQ.mZ6zWuiq6s3kzswBL4YlHvC7cQKnUyfoVzXm6IHe8Cw', 1571493793),
(1207, 1758, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzU4IiwidXNlcm1haWwiOiJwZWRyb21nc291dG9AdWEucHQiLCJpYXQiOjE1NzE0OTQ1NjksImV4cCI6MTU3MTQ5NjM2OSwicGVybWlzc2lvbiI6IiJ9.tyttKRfBuggLaeoEagLmX9muLMfWTj2dPM-oxzyog7U', 1571496369),
(1210, 1473, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDczIiwidXNlcm1haWwiOiJqb3NlLnZhekB1YS5wdCIsImlhdCI6MTU3MTQ5NjgxOSwiZXhwIjoxNTcxNDk4NjE5LCJwZXJtaXNzaW9uIjoiIn0.ls80TeV5NpxHBU2vW68xmwWD8Q_w0qnlLyRCFN4UycU', 1571498619),
(1216, 1722, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzIyIiwidXNlcm1haWwiOiJwZWRyby5taWd1ZWw1MEB1YS5wdCIsImlhdCI6MTU3MTUwNDY4NSwiZXhwIjoxNTcxNTA2NDg1LCJwZXJtaXNzaW9uIjoiIn0.PNt7AFPkID7NpPNQgUrrnc3lK_VdkM0atIQpOw8TTbI', 1571506485),
(1219, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzE1MDY0NzMsImV4cCI6MTU3MTUwODI3MywicGVybWlzc2lvbiI6IiJ9.dQSgP9vO0P6H5JmKIURGzvBlC6O4H9Kjstc-8CqnH2k', 1571508273),
(1225, 1722, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzIyIiwidXNlcm1haWwiOiJwZWRyby5taWd1ZWw1MEB1YS5wdCIsImlhdCI6MTU3MTUxNzExMSwiZXhwIjoxNTcxNTE4OTExLCJwZXJtaXNzaW9uIjoiIn0.Iax0rn0hNrz9RPwSn6w8QCjnSmLtpSvOWOe82Eez-I0', 1571518911),
(1228, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU3MTUxOTQyMCwiZXhwIjoxNTcxNTIxMjIwLCJwZXJtaXNzaW9uIjoiIn0.9Vj9WKF4Sndoi7-k2gh1NxfXy0u8YwRMzd2NuVmtY5M', 1571521220),
(1231, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxNTIyMjg4LCJleHAiOjE1NzE1MjQwODgsInBlcm1pc3Npb24iOiIifQ.oUw18AYa-LsC_40E4Ql9zemuPQVNaYbe5lILTp1bHT0', 1571524088),
(1237, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU3MTU2MTEyMywiZXhwIjoxNTcxNTYyOTIzLCJwZXJtaXNzaW9uIjoiIn0.Tmm7N7UqRUtxR-Y438SwFXducTmi2dphN4vz2NHUtus', 1571562923),
(1240, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzE1NjM0MjksImV4cCI6MTU3MTU2NTIyOSwicGVybWlzc2lvbiI6IiJ9.GwqOpFW-V64STMqVYTFvbUOzVduETDnOOwr2UZ-pj_A', 1571565229),
(1243, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTcxNTY3ODUyLCJleHAiOjE1NzE1Njk2NTIsInBlcm1pc3Npb24iOiIifQ.4O_tVHJpB_Rlo7Ipl3wjXQBh3z7i-xnDawsia9Riyok', 1571569652),
(1246, 1020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIwIiwidXNlcm1haWwiOiJjYXJvbGluYS5hcmF1am8wMEB1YS5wdCIsImlhdCI6MTU3MTU3MTg0NCwiZXhwIjoxNTcxNTczNjQ0LCJwZXJtaXNzaW9uIjoiIn0.m_qkO2gcEhZO8sZM1MlN-BVx5EX2bdsRlSX_b2-5nZo', 1571573644),
(1252, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3MTU3OTI0NiwiZXhwIjoxNTcxNTgxMDQ2LCJwZXJtaXNzaW9uIjoiIn0.59UFF1uFJg4UFn8bMQQIKFI4qdyhsnIIWn74cebF3NY', 1571581046),
(1255, 1461, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDYxIiwidXNlcm1haWwiOiJqb2FvdHNAdWEucHQiLCJpYXQiOjE1NzE1ODIwODAsImV4cCI6MTU3MTU4Mzg4MCwicGVybWlzc2lvbiI6IiJ9.XADcvKI4HRLHDcjZjSh0KYX4HWBuhBJvG2_kwg6dkfA', 1571583880),
(1258, 993, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTMiLCJ1c2VybWFpbCI6ImJydW5vc2JAdWEucHQiLCJpYXQiOjE1NzE1ODU3MTksImV4cCI6MTU3MTU4NzUxOSwicGVybWlzc2lvbiI6IiJ9.J0AsaYtd4jEzuTwWb9Zu1lgAmpLJyfq4ZwkgUkbCk1A', 1571587519),
(1264, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU3MTU5MjQxNywiZXhwIjoxNTcxNTk0MjE3LCJwZXJtaXNzaW9uIjoiIn0.C_f93MN2M7aoTp9JH5xoU_OryPU_IQ7oczIdqYcUpMI', 1571594217),
(1267, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1NzE1OTM0MzEsImV4cCI6MTU3MTU5NTIzMSwicGVybWlzc2lvbiI6IiJ9.bQkS3xiWAJn830ZQ5ZmotlSFdiyk6fGG1vUsLsnEpU0', 1571595231),
(1270, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxNTk4MDY5LCJleHAiOjE1NzE1OTk4NjksInBlcm1pc3Npb24iOiIifQ.iPj_qcKEa1vEENdHUUAs_fKezLZcYjzye4PrAj_Zpgg', 1571599869),
(1273, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxNjAwNjY4LCJleHAiOjE1NzE2MDI0NjgsInBlcm1pc3Npb24iOiIifQ.ruUTH7QpEvxxTge8_XaCQ6PzA2eXZm_xpvW1NtbXmyM', 1571602468),
(1279, 1356, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU2IiwidXNlcm1haWwiOiJpdm9hbmdlbGljb0B1YS5wdCIsImlhdCI6MTU3MTYwNTU2NiwiZXhwIjoxNTcxNjA3MzY2LCJwZXJtaXNzaW9uIjoiIn0.Qba9qNCIw7XOZFcenmiDXsw1fhcWlxFNeaKwydFQFLw', 1571607366),
(1282, 1356, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU2IiwidXNlcm1haWwiOiJpdm9hbmdlbGljb0B1YS5wdCIsImlhdCI6MTU3MTYwNjg2MywiZXhwIjoxNTcxNjA4NjYzLCJwZXJtaXNzaW9uIjoiIn0.lFaa9Zx6kBbretR-kUDXQGP1HSAybkj9FExXxyEiD28', 1571608663),
(1285, 1356, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU2IiwidXNlcm1haWwiOiJpdm9hbmdlbGljb0B1YS5wdCIsImlhdCI6MTU3MTYwNjg2OSwiZXhwIjoxNTcxNjA4NjY5LCJwZXJtaXNzaW9uIjoiIn0.Nupz1e5uLh5Kxxc_S9fMcopMiGc_DwleXalMxKHjtjM', 1571608669),
(1288, 1356, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU2IiwidXNlcm1haWwiOiJpdm9hbmdlbGljb0B1YS5wdCIsImlhdCI6MTU3MTYwNjg3MiwiZXhwIjoxNTcxNjA4NjcyLCJwZXJtaXNzaW9uIjoiIn0.paQQ-jJU3LXkfxbUXdcY0Fxv61bm2jQjvELrxmuN0iM', 1571608672),
(1291, 1356, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU2IiwidXNlcm1haWwiOiJpdm9hbmdlbGljb0B1YS5wdCIsImlhdCI6MTU3MTYwNjg3NiwiZXhwIjoxNTcxNjA4Njc2LCJwZXJtaXNzaW9uIjoiIn0.J805iAx_KzvbVDVMqUJaLYoYbY2pHZT8GxWsS_LfbHE', 1571608676),
(1294, 1356, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU2IiwidXNlcm1haWwiOiJpdm9hbmdlbGljb0B1YS5wdCIsImlhdCI6MTU3MTYwNjg3OSwiZXhwIjoxNTcxNjA4Njc5LCJwZXJtaXNzaW9uIjoiIn0.VVPNwiFh1NEInwLSPwLaFHj-yuN8lBMxbuqtEB2bXgc', 1571608679),
(1297, 1356, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU2IiwidXNlcm1haWwiOiJpdm9hbmdlbGljb0B1YS5wdCIsImlhdCI6MTU3MTYwNjg5NCwiZXhwIjoxNTcxNjA4Njk0LCJwZXJtaXNzaW9uIjoiIn0.i30GV5B5rnjjChWA6JcC_jyX66IKuv499CUBtpm_9Jg', 1571608694),
(1300, 1350, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzUwIiwidXNlcm1haWwiOiJpc2Fkb3JhLmZsQHVhLnB0IiwiaWF0IjoxNTcxNjA4NDAwLCJleHAiOjE1NzE2MTAyMDAsInBlcm1pc3Npb24iOiIifQ.3ZteFYg5RbpQfwHiT0umZupJWrFpHCeX42faO8fYz30', 1571610200),
(1303, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzE2MDg0MTQsImV4cCI6MTU3MTYxMDIxNCwicGVybWlzc2lvbiI6IiJ9.9o-YsKEmKPF9EypUUgcfzZZuhlcJZByt7JB3S-3UnyI', 1571610214),
(1306, 1284, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjg0IiwidXNlcm1haWwiOiJnb25jYWxvZnJlaXhpbmhvQHVhLnB0IiwiaWF0IjoxNTcxNjExMzU4LCJleHAiOjE1NzE2MTMxNTgsInBlcm1pc3Npb24iOiIifQ.G6cQPoC4nWGrJ1JzZPgqXW8xSpw7DqxhavegzQLABSQ', 1571613158),
(1309, 1758, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzU4IiwidXNlcm1haWwiOiJwZWRyb21nc291dG9AdWEucHQiLCJpYXQiOjE1NzE2MTMyNTEsImV4cCI6MTU3MTYxNTA1MSwicGVybWlzc2lvbiI6IiJ9.QzOpQCt6Uhb3dr_8vavhzynvcgF0lmgGe4OdN1-1Qyw', 1571615051),
(1312, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MTYxMzY5NSwiZXhwIjoxNTcxNjE1NDk1LCJwZXJtaXNzaW9uIjoiIn0.U5_Ja0WmPP5Z14yOLq1Xql3REc1RjibEKbl7TSBNfLo', 1571615495),
(1318, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3MTY0NTA2NywiZXhwIjoxNTcxNjQ2ODY3LCJwZXJtaXNzaW9uIjoiIn0.XB7cKKjPp_X5SQSphrYGcq_6JdFbENw6i8huizoxNyc', 1571646867),
(1324, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU3MTY0OTYyNCwiZXhwIjoxNTcxNjUxNDI0LCJwZXJtaXNzaW9uIjoiIn0.VpmPlxDV5mVkOjW8WA5tsikoJek1G5TATGf0kCDn3lM', 1571651424),
(1327, 2080, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDgwIiwidXNlcm1haWwiOiJicmFpc0B1YS5wdCIsImlhdCI6MTU3MTY0OTY0MSwiZXhwIjoxNTcxNjUxNDQxLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.iJ13cCF2SSG088AegQqeSnQfXQTTWqr4qZVLv5Z2vD0', 1571651441),
(1330, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3MTY0OTk4MiwiZXhwIjoxNTcxNjUxNzgyLCJwZXJtaXNzaW9uIjoiIn0.wepCgDD-ijpemTff4Fu3DB-qspWsFde8MXwvEAL4VIc', 1571651782),
(1336, 1761, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzYxIiwidXNlcm1haWwiOiJwZWRyb21tQHVhLnB0IiwiaWF0IjoxNTcxNjUzOTI1LCJleHAiOjE1NzE2NTU3MjUsInBlcm1pc3Npb24iOiIifQ.yby2q_snNqYDb6eD2FHVElXOLHvMaFnqqZN8uFS8YRg', 1571655725),
(1342, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzE2NTY5MjEsImV4cCI6MTU3MTY1ODcyMSwicGVybWlzc2lvbiI6IiJ9.yqJWVuUISWnq1zhDExE-IoG3cKIpHr5XD3StnAuaz3Y', 1571658721),
(1345, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTcxNjU2OTMwLCJleHAiOjE1NzE2NTg3MzAsInBlcm1pc3Npb24iOiIifQ.s5Xl5rBckCQIJJ2ZRPLY_2wAOvNYn70XX7pT83necgc', 1571658730),
(1351, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzE2NzQzMjcsImV4cCI6MTU3MTY3NjEyNywicGVybWlzc2lvbiI6IiJ9.6v2DAeEEM0FIq8UXCS_Yf79I-DwJSq2EJsJph48Cvw4', 1571676127),
(1357, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1NzE2ODEwMTIsImV4cCI6MTU3MTY4MjgxMiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.HeKg2yf1XXzSBx0ZFkc0J-xlPK4r9XcWhxTKHKNBZA0', 1571682812),
(1360, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU3MTY4MjgyOSwiZXhwIjoxNTcxNjg0NjI5LCJwZXJtaXNzaW9uIjoiIn0.Ff2RSJI4j5c-Yfry4ipPzB-VtBtmdqc8QIPB7kDaEvM', 1571684629),
(1363, 1059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDU5IiwidXNlcm1haWwiOiJjbXNvYXJlc0B1YS5wdCIsImlhdCI6MTU3MTY4NjA4NCwiZXhwIjoxNTcxNjg3ODg0LCJwZXJtaXNzaW9uIjoiIn0.mwuKxiIJ57zDHGiHCV3-IAwRzXlAsWEFnyxBYfgV4NM', 1571687884),
(1369, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzE2OTEzNDYsImV4cCI6MTU3MTY5MzE0NiwicGVybWlzc2lvbiI6IiJ9.L8YuhycwMOogHEMt4dkB_2GC7y7eZDMPdAdR2wIZLEM', 1571693146),
(1372, 1620, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjIwIiwidXNlcm1haWwiOiJtYXJpb3NpbHZhQHVhLnB0IiwiaWF0IjoxNTcxNjkyNDM3LCJleHAiOjE1NzE2OTQyMzcsInBlcm1pc3Npb24iOiIifQ.SsOvkCHh7vHrteZJ_0HslicX3lN-jYuM1aFMqL67nlk', 1571694237),
(1375, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTcxNjk1NzI3LCJleHAiOjE1NzE2OTc1MjcsInBlcm1pc3Npb24iOiIifQ.DQIdByaWWMkonSdEtMq-ZlQuD8kmImXiwpRm-t65eLc', 1571697527),
(1378, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzE2OTU3NTksImV4cCI6MTU3MTY5NzU1OSwicGVybWlzc2lvbiI6IiJ9.DYx-YXIrhjCGBQUv_eDpEjpi702uUlEfBuKpdKQEXKc', 1571697559),
(1381, 1284, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjg0IiwidXNlcm1haWwiOiJnb25jYWxvZnJlaXhpbmhvQHVhLnB0IiwiaWF0IjoxNTcxNjk4NTUzLCJleHAiOjE1NzE3MDAzNTMsInBlcm1pc3Npb24iOiIifQ.lHJXo3sJsAeJqA0-tWXppooN4D0xeD7cqS7JAsQFKLQ', 1571700353),
(1384, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzE3MDE2ODcsImV4cCI6MTU3MTcwMzQ4NywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.AP05qyWdMxoJIVuX1tfZzL3PLi8XeR5FnTLjMKUzjkU', 1571703487),
(1387, 1122, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTIyIiwidXNlcm1haWwiOiJkZmFjQHVhLnB0IiwiaWF0IjoxNTcxNzAzMDUxLCJleHAiOjE1NzE3MDQ4NTEsInBlcm1pc3Npb24iOiIifQ.gCO8b-0tIV9Nxl1m3vpGPOdM8Y9ylPDPg2Dlxl7so6Q', 1571704851),
(1393, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzE3MDkyMTcsImV4cCI6MTU3MTcxMTAxNywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.WnUpVvRgUChunXS98nW9PYcuc8Tg2NQy0NV10CIhXKQ', 1571711017),
(1399, 1362, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzYyIiwidXNlcm1haWwiOiJqLnZhc2NvbmNlbG9zOTlAdWEucHQiLCJpYXQiOjE1NzE3MjU5NTUsImV4cCI6MTU3MTcyNzc1NSwicGVybWlzc2lvbiI6IiJ9.FnLAHIJ2x9Xq0Dmeds0mT9IHiC7zzUMjPLckgYDXx9E', 1571727755),
(1405, 1827, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODI3IiwidXNlcm1haWwiOiJyaWNhcmRvLmNydXoyOUB1YS5wdCIsImlhdCI6MTU3MTczNDkyNywiZXhwIjoxNTcxNzM2NzI3LCJwZXJtaXNzaW9uIjoiIn0.4d2zdOALwrip1gwl5UwklUIPsNRRxYpmd_sVBBW4-cA', 1571736727),
(1408, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzE3Mzc0MDAsImV4cCI6MTU3MTczOTIwMCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.dVoPQq9RYzSZ362VGqOKwurRHTjRWGJRzQd3qBzaXl8', 1571739200),
(1411, 1827, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODI3IiwidXNlcm1haWwiOiJyaWNhcmRvLmNydXoyOUB1YS5wdCIsImlhdCI6MTU3MTczNzg4MywiZXhwIjoxNTcxNzM5NjgzLCJwZXJtaXNzaW9uIjoiIn0.YdIqj7igZwcM3kfRlfAfiwNsFf1_jkcaqAzb9RCJyKw', 1571739683),
(1417, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU3MTc0MjEwNCwiZXhwIjoxNTcxNzQzOTA0LCJwZXJtaXNzaW9uIjoiIn0.nQKzrpdKkm5d86M77OZG6Z6trDvZodHrLYDd9B15Mig', 1571743904),
(1420, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MTc0MjM4OCwiZXhwIjoxNTcxNzQ0MTg4LCJwZXJtaXNzaW9uIjoiIn0.5gH-7Edtwrl4PbEzJJBZXtBo_MFXVvdvYzNAF1ZEmGw', 1571744188),
(1423, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcxNzQzNTA2LCJleHAiOjE1NzE3NDUzMDYsInBlcm1pc3Npb24iOiIifQ.mFnrjTekVsS5NPosSpQ85Uq-C8akTVZnbodUtasw9hM', 1571745306),
(1426, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTcxNzQzNjU4LCJleHAiOjE1NzE3NDU0NTgsInBlcm1pc3Npb24iOiIifQ.iSMh877tNvzpwWMsHvwBDrNMT_6WjWAFFRzhRCrnqDE', 1571745458),
(1432, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MTc0OTk2MSwiZXhwIjoxNTcxNzUxNzYxLCJwZXJtaXNzaW9uIjoiIn0.Wy823ZuEDY1gufqBkbWeUGVZrHYVNojnR9xOZfJyxDo', 1571751761),
(1438, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1NzE3NTU2NzIsImV4cCI6MTU3MTc1NzQ3MiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.9XmVUr8u-3i0mete9KW1pR1hz-EccRW969n4hD04Les', 1571757472),
(1441, 870, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NzAiLCJ1c2VybWFpbCI6ImFsZXhhbmRyYWNhcnZhbGhvQHVhLnB0IiwiaWF0IjoxNTcxNzU3MjIyLCJleHAiOjE1NzE3NTkwMjIsInBlcm1pc3Npb24iOiIifQ.6lB97WYQQFb7Z4aM3TfOvP21Poyx8PFiuYqUhZQKZRI', 1571759022),
(1444, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzE3NTc1MDYsImV4cCI6MTU3MTc1OTMwNiwicGVybWlzc2lvbiI6IiJ9.h2Rh-1oOcNRq0MANNXiz0jpvmLwfApLJX0xPSsy5QAY', 1571759306),
(1447, 2080, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDgwIiwidXNlcm1haWwiOiJicmFpc0B1YS5wdCIsImlhdCI6MTU3MTc1ODI3MSwiZXhwIjoxNTcxNzYwMDcxLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.YW_w6EDjCz-wDGuIS4pZLvDn2CNFkKlq-1Vj9Si4XC0', 1571760071),
(1450, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTcxNzU4MzgyLCJleHAiOjE1NzE3NjAxODIsInBlcm1pc3Npb24iOiIifQ.IGpXM-VFoo-A8dKUXXcyt6L9tAr0DhqIh7YA53Oe97Q', 1571760182),
(1453, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MTc1ODM4OCwiZXhwIjoxNTcxNzYwMTg4LCJwZXJtaXNzaW9uIjoiIn0.Nys73n8jtCMxnE-OtAprRZnvxYMntHRc2l4z7MBSNqg', 1571760188),
(1459, 987, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5ODciLCJ1c2VybWFpbCI6ImJydW5vcGludG81MTUxQHVhLnB0IiwiaWF0IjoxNTcxNzYwNDg3LCJleHAiOjE1NzE3NjIyODcsInBlcm1pc3Npb24iOiIifQ.vFCXrtLJluTdBIvcWr2IO7KmcIrcwn6d0UMxrGo2Pa4', 1571762287),
(1465, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU3MTc2NjIwOSwiZXhwIjoxNTcxNzY4MDA5LCJwZXJtaXNzaW9uIjoiIn0.lnRI8C8omI4LmwrRPsskM7CG9JwMB1P5MIG8NumDVu4', 1571768009),
(1468, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU3MTc2NjI3NCwiZXhwIjoxNTcxNzY4MDc0LCJwZXJtaXNzaW9uIjoiIn0.isbRN0bjVUqiXyvAKZOa7hEZj0hb-4HM-FlbxJgV-g0', 1571768074),
(1471, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzE3NjY5MjEsImV4cCI6MTU3MTc2ODcyMSwicGVybWlzc2lvbiI6IiJ9.3zHpXbef_iOO5rVDoZLpU_O4LRlFvGPJwpaXxaTEKj4', 1571768721),
(1474, 1350, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzUwIiwidXNlcm1haWwiOiJpc2Fkb3JhLmZsQHVhLnB0IiwiaWF0IjoxNTcxNzY3NzA4LCJleHAiOjE1NzE3Njk1MDgsInBlcm1pc3Npb24iOiIifQ.2vwWsbX3oltbZYuoOcX9nmFZKxchoeVeubkhqabkyxk', 1571769508),
(1477, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTcxNzY4MjQwLCJleHAiOjE1NzE3NzAwNDAsInBlcm1pc3Npb24iOiIifQ.5dom1_E3AXxJNN67GFoa-IVAHms0IKeRbWicUlI5ZaQ', 1571770040),
(1483, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzE3NzIxNTUsImV4cCI6MTU3MTc3Mzk1NSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.i-01TnPoIqG_0sHXqk9KMMDAy96BXRh1ac8vQ0Fshek', 1571773955),
(1489, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTcxNzc3NDMyLCJleHAiOjE1NzE3NzkyMzIsInBlcm1pc3Npb24iOiIifQ.MuhsnVtHPIAFVfdFtJQasRCIvTWXT20wSV4E-kGQ0-o', 1571779232),
(1495, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MTc4NDM1NiwiZXhwIjoxNTcxNzg2MTU2LCJwZXJtaXNzaW9uIjoiIn0.zUXqTLrm1jdfz8aw7kil9ZheJ8A5Zr03zsMJHMVrh2k', 1571786156),
(1498, 1251, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjUxIiwidXNlcm1haWwiOiJmbXRzQHVhLnB0IiwiaWF0IjoxNTcxNzg0NDczLCJleHAiOjE1NzE3ODYyNzMsInBlcm1pc3Npb24iOiIifQ.2GLIe51i4vhU9fOAMPyTRRKt_G9cM8iK6f-xsEbT-Go', 1571786273),
(1501, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1NzE3ODc0OTEsImV4cCI6MTU3MTc4OTI5MSwicGVybWlzc2lvbiI6IiJ9.N-HmoynVn0yNvKSlTxeBEQHvGP37MD9cN4qgnRQLeX8', 1571789291),
(1504, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU3MTc4NzYwMSwiZXhwIjoxNTcxNzg5NDAxLCJwZXJtaXNzaW9uIjoiIn0.WbObaDCaxDbAKes0m0eayzeboMpMwYIRnQSBdpndy0M', 1571789401),
(1507, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1NzE3ODc3NTQsImV4cCI6MTU3MTc4OTU1NCwicGVybWlzc2lvbiI6IiJ9.tqzLLtuQIPaw2bkWPrYryQhNeOMXbtp-lYXOS1YVkok', 1571789554),
(1510, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU3MTc4NzgyMSwiZXhwIjoxNTcxNzg5NjIxLCJwZXJtaXNzaW9uIjoiIn0._lDj0uGiaMp09eYXnqVtftRcnsu_nRzRab3hn-4scOI', 1571789621),
(1513, 2050, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUwIiwidXNlcm1haWwiOiJqb3NldHJpZ29AdWEucHQiLCJpYXQiOjE1NzE3ODgxNTYsImV4cCI6MTU3MTc4OTk1NiwicGVybWlzc2lvbiI6IiJ9.HZjZw9dHzqP7cmC0G1dwFRADqNUQPQsqUS2kC55Kodk', 1571789956),
(1516, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTcxNzg4MzA5LCJleHAiOjE1NzE3OTAxMDksInBlcm1pc3Npb24iOiIifQ.jtiVYGhz8gFqolcdnP8mP07g21eTIvkoEny4h_PybrA', 1571790109),
(1519, 2092, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDkyIiwidXNlcm1haWwiOiJwZWQucm9kckB1YS5wdCIsImlhdCI6MTU3MTc5MTU5OCwiZXhwIjoxNTcxNzkzMzk4LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.5zgPym_gRUxEIwHa_V4fZOglfxLSiBBTz5SjzQJlHMc', 1571793398),
(1525, 2057, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU3IiwidXNlcm1haWwiOiJwbWQ4QHVhLnB0IiwiaWF0IjoxNTcxODEzNzA4LCJleHAiOjE1NzE4MTU1MDgsInBlcm1pc3Npb24iOiIifQ.8giHrCbhPUbXSgLu1gfMC1kZmTo5yC3iaxuZj1-IuLc', 1571815508),
(1528, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1NzE4MTY4ODAsImV4cCI6MTU3MTgxODY4MCwicGVybWlzc2lvbiI6IiJ9.oMUFVEfnzfOkvxHhCQFg1GLZhNuzF_TeHVi3IL-LWCk', 1571818680),
(1534, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU3MTgyMDg0NywiZXhwIjoxNTcxODIyNjQ3LCJwZXJtaXNzaW9uIjoiIn0.NfoEOV-4ESqUE02v7N-N-Z7W47t5Q6C0oYCjPNz8Ays', 1571822647),
(1540, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzE4MjQwMzEsImV4cCI6MTU3MTgyNTgzMSwicGVybWlzc2lvbiI6IiJ9.Ehm-JZjOaWpJrJVIESIf0zxMnIH8y4J0uHhkX7ELVXc', 1571825831),
(1543, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MTgyNDY0MywiZXhwIjoxNTcxODI2NDQzLCJwZXJtaXNzaW9uIjoiIn0.q-7zDnIBwsRKZiqXlJhIwhpctKjfmP8TGwbc1E7-ZRo', 1571826443),
(1546, 1758, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzU4IiwidXNlcm1haWwiOiJwZWRyb21nc291dG9AdWEucHQiLCJpYXQiOjE1NzE4MjcwMDcsImV4cCI6MTU3MTgyODgwNywicGVybWlzc2lvbiI6IiJ9.EKb-vp2YPGAAatnTj71PT_0qDPWLJz7WlhOytICjkbU', 1571828807),
(1549, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTcxODI4MDg0LCJleHAiOjE1NzE4Mjk4ODQsInBlcm1pc3Npb24iOiIifQ.ATtBlrEIAOaD2WwkQMN6DmYC7OrRtz5GYL3Y4vBLkFk', 1571829884),
(1555, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzE4MzAyMTIsImV4cCI6MTU3MTgzMjAxMiwicGVybWlzc2lvbiI6IiJ9.vOa5TO7kzcil_DM7VzPG2Uv-lWb0KarpxqHGtzSdOxo', 1571832012),
(1558, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1NzE4MzI0NjgsImV4cCI6MTU3MTgzNDI2OCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.sNz7lD86CxO8Lx5GW3bYcmwYsRG-99OuSfwRgBBX51A', 1571834268),
(1561, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzE4MzYwMDMsImV4cCI6MTU3MTgzNzgwMywicGVybWlzc2lvbiI6IiJ9.OZrTCOOKKVx_Rt672JYs2gICNu5mVjD_WWew-90VX90', 1571837803),
(1570, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTcxODQxNjM3LCJleHAiOjE1NzE4NDM0MzcsInBlcm1pc3Npb24iOiIifQ._ILXpRP2qlJZ4UZxXByChz_tEDGxE5g1fCja3_-Fd4Q', 1571843437),
(1576, 1161, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTYxIiwidXNlcm1haWwiOiJkaW9nbzA0QHVhLnB0IiwiaWF0IjoxNTcxODUwMDA1LCJleHAiOjE1NzE4NTE4MDUsInBlcm1pc3Npb24iOiIifQ.rIJnShQjw78vL6wPTW55V8loxfPGdwWjScwIo_LxiuM', 1571851805),
(1582, 1989, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTg5IiwidXNlcm1haWwiOiJ0b21hc2JhdGlzdGE5OUB1YS5wdCIsImlhdCI6MTU3MTg1ODAyNCwiZXhwIjoxNTcxODU5ODI0LCJwZXJtaXNzaW9uIjoiIn0.HfL7C2vQ2XgUHYO74awojMqF_VUEva2M46WmHR5_Zcc', 1571859824),
(1588, 1494, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDk0IiwidXNlcm1haWwiOiJqb3NlcmVpc0B1YS5wdCIsImlhdCI6MTU3MTg2OTQzMywiZXhwIjoxNTcxODcxMjMzLCJwZXJtaXNzaW9uIjoiIn0.SBIEEGCHxAPtd4CE7IJFUyO-IUxkezJ-GglNqGeWydc', 1571871233),
(1594, 2047, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ3IiwidXNlcm1haWwiOiJqb2FvcmVpczE2QHVhLnB0IiwiaWF0IjoxNTcxODc0NTEzLCJleHAiOjE1NzE4NzYzMTMsInBlcm1pc3Npb24iOiIifQ.PFDgNrauz5D0WtNpCnYYIIXl3khFQ20Aoq-Be7uKTAk', 1571876313),
(1600, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTcxODgxOTc5LCJleHAiOjE1NzE4ODM3NzksInBlcm1pc3Npb24iOiIifQ.ky9s-Y7cb8mbSw_v5Wzo_ws8ELoL2K-3BT55_9ON2dA', 1571883779),
(1606, 2057, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU3IiwidXNlcm1haWwiOiJwbWQ4QHVhLnB0IiwiaWF0IjoxNTcxODk3NjE3LCJleHAiOjE1NzE4OTk0MTcsInBlcm1pc3Npb24iOiIifQ.-uEINteX8mKsNPw9u-KZ7_BD1lY5VrMTrgZTf-_zcl8', 1571899417),
(1609, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTcxOTAxMTUyLCJleHAiOjE1NzE5MDI5NTIsInBlcm1pc3Npb24iOiIifQ.5kcXhgMPRz0kDxzLJ68fM9vz8Apbt6v1tRO49_DOPGs', 1571902952),
(1615, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTcxOTA1NjA1LCJleHAiOjE1NzE5MDc0MDUsInBlcm1pc3Npb24iOiIifQ.M6cE3tn1AE2GHkg413Iq16lEX-tkfCcKKixMB7F2HT0', 1571907405),
(1618, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzE5MDU2MDgsImV4cCI6MTU3MTkwNzQwOCwicGVybWlzc2lvbiI6IiJ9.N-MvgD6puDeAnEJ2B9-U8UD0j6Rhg3Y2A5t1C0OOJfY', 1571907408),
(1624, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzE5MTExMjUsImV4cCI6MTU3MTkxMjkyNSwicGVybWlzc2lvbiI6IiJ9.OwKmc4zOWCytTMPYULxhz6-ElF1nRIE-ZENxqgB29ps', 1571912925),
(1630, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU3MTkxNTA0MiwiZXhwIjoxNTcxOTE2ODQyLCJwZXJtaXNzaW9uIjoiIn0.rJzT0IlDApUdC37qkvvy9XZerFYGcJRathyIkbSy6rg', 1571916842),
(1633, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzE5MTUxOTAsImV4cCI6MTU3MTkxNjk5MCwicGVybWlzc2lvbiI6IiJ9.plHcCUKE1B2PRD7X-FaSy6ifoTeDXt5ONcAoAOFnHhY', 1571916990),
(1636, 1485, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDg1IiwidXNlcm1haWwiOiJqb3NlcHBtb3JlaXJhQHVhLnB0IiwiaWF0IjoxNTcxOTE3Mjg2LCJleHAiOjE1NzE5MTkwODYsInBlcm1pc3Npb24iOiIifQ.3VR-wQHl-6C5SFNZPzntkpA4CQDMM0gVuKN7xx-VW7k', 1571919086),
(1639, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTcxOTE3OTMxLCJleHAiOjE1NzE5MTk3MzEsInBlcm1pc3Npb24iOiIifQ.XZ7RYqGJKPfoLRM1gfj3WdLjefPbwRys2IVP9uKcw2M', 1571919731),
(1642, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU3MTkyMDgzNSwiZXhwIjoxNTcxOTIyNjM1LCJwZXJtaXNzaW9uIjoiIn0._eZu2OCAYwiCcZ1je2K37bwMLkJdIC2u8tOucl5O0hA', 1571922635),
(1645, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU3MTkyMTc3OCwiZXhwIjoxNTcxOTIzNTc4LCJwZXJtaXNzaW9uIjoiIn0.fd_Ab7zkUr-Ct1ZmDNHSMllwdaP_h50q6hRLz8DNg1s', 1571923578),
(1648, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1NzE5MjM2MjUsImV4cCI6MTU3MTkyNTQyNSwicGVybWlzc2lvbiI6IiJ9.VUaSi_deb8YxZjDVztUjHeB2V__tsNFFvj0cY7E3Oq4', 1571925425),
(1651, 2045, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ1IiwidXNlcm1haWwiOiJodWdvZ29uY2FsdmVzMTNAdWEucHQiLCJpYXQiOjE1NzE5MjQyMTUsImV4cCI6MTU3MTkyNjAxNSwicGVybWlzc2lvbiI6IiJ9.yT7Erx8pQoYc_WlGWs8NqOU4lwjvePWT_nzgLED0YpY', 1571926015),
(1654, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1NzE5MjQ0NDYsImV4cCI6MTU3MTkyNjI0NiwicGVybWlzc2lvbiI6IiJ9.nUM-Vwn_bkoVrVKfHlfk1GnoNDvlGZU94mCXg1U3i9U', 1571926246),
(1657, 870, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NzAiLCJ1c2VybWFpbCI6ImFsZXhhbmRyYWNhcnZhbGhvQHVhLnB0IiwiaWF0IjoxNTcxOTI1NTE2LCJleHAiOjE1NzE5MjczMTYsInBlcm1pc3Npb24iOiIifQ.Od8sW-xyydAhp9DW9oAQy8q1BYgxMVVtzG0BaN84_5w', 1571927316),
(1660, 1821, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODIxIiwidXNlcm1haWwiOiJyZm1mQHVhLnB0IiwiaWF0IjoxNTcxOTI3NjYxLCJleHAiOjE1NzE5Mjk0NjEsInBlcm1pc3Npb24iOiIifQ.jeEc3Qwd9FEsoKnOYwt2f6cXWSuDA6nt4Oi8pmZqwpw', 1571929461),
(1663, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU3MTkyNzk1OSwiZXhwIjoxNTcxOTI5NzU5LCJwZXJtaXNzaW9uIjoiIn0.K2TISjuw9mMn5lvZ9nMNoKDFFJq3bF-_ienHBxVaOvs', 1571929759),
(1669, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1NzE5MzA2NDQsImV4cCI6MTU3MTkzMjQ0NCwicGVybWlzc2lvbiI6IiJ9.ajA-5vYnPtr-mGD2qmMp5gqskDfNI49lwL6vpWWdJx8', 1571932444),
(1672, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU3MTkzMTgwMiwiZXhwIjoxNTcxOTMzNjAyLCJwZXJtaXNzaW9uIjoiIn0.otscfq0d5c74q5kQLa1WziTpNwM_QP4D6kne3ptyiGk', 1571933602),
(1675, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1NzE5MzQwNzgsImV4cCI6MTU3MTkzNTg3OCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.eTthbuZpYUEd8nDE_--3cpXqh8TjexULXlzsUmbjg6M', 1571935878),
(1678, 1734, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzM0IiwidXNlcm1haWwiOiJwZWRyb2Fnb25jYWx2ZXNtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTcxOTM1NDgzLCJleHAiOjE1NzE5MzcyODMsInBlcm1pc3Npb24iOiIifQ.hiu5JLD1WLQsoDy-lXag6hxlU_GUjFnCjksxDONEkdU', 1571937283),
(1681, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3MTkzNzQ4MiwiZXhwIjoxNTcxOTM5MjgyLCJwZXJtaXNzaW9uIjoiIn0.TUv-MdXxuYKoWCHJyvmiwdrv9LFfs1skDvdrNEZFnNw', 1571939282),
(1684, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU3MTkzODQ4MSwiZXhwIjoxNTcxOTQwMjgxLCJwZXJtaXNzaW9uIjoiIn0.raR7MCO1qD55SfuVkldzUWDXfc1JT6y84wxGOSbUurk', 1571940281),
(1687, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1NzE5Mzk3ODIsImV4cCI6MTU3MTk0MTU4MiwicGVybWlzc2lvbiI6IiJ9.W7gyWU9KbAfhpZ54GTvSVb-rKMsryZ-IylLkbyxKQSc', 1571941582),
(1690, 2055, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU1IiwidXNlcm1haWwiOiJtaWd1ZWwuci5mZXJyZWlyYUB1YS5wdCIsImlhdCI6MTU3MTk0MTAyNywiZXhwIjoxNTcxOTQyODI3LCJwZXJtaXNzaW9uIjoiIn0.ZETdi6ovX1rFAlmIWYvevuJMJNEGJNZnc0x6y_ilmlw', 1571942827),
(1696, 2055, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU1IiwidXNlcm1haWwiOiJtaWd1ZWwuci5mZXJyZWlyYUB1YS5wdCIsImlhdCI6MTU3MTk0NTU5OCwiZXhwIjoxNTcxOTQ3Mzk4LCJwZXJtaXNzaW9uIjoiIn0.GIN_VVwm5k7eaTrDPVnteVBDIvONvQiAvOBiBOtM1SE', 1571947398),
(1699, 1341, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQxIiwidXNlcm1haWwiOiJpbmVzLnBsQHVhLnB0IiwiaWF0IjoxNTcxOTQ3Nzk5LCJleHAiOjE1NzE5NDk1OTksInBlcm1pc3Npb24iOiIifQ.SiYFOdS6Sz1MM4FRzmSIzBQOFGO9t4DuVn3aS6U3_C4', 1571949599),
(1702, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTcxOTQ5MDU1LCJleHAiOjE1NzE5NTA4NTUsInBlcm1pc3Npb24iOiIifQ.ioO3dop29pgD4uBuo6hlfqPwORWXk8SI6lOPvOqVGbM', 1571950855),
(1705, 1611, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjExIiwidXNlcm1haWwiOiJtYXJpYW5hc3BzQHVhLnB0IiwiaWF0IjoxNTcxOTUwMjIzLCJleHAiOjE1NzE5NTIwMjMsInBlcm1pc3Npb24iOiIifQ.THJSsgAgNSaatEcv4pxQGp5OWKSOXKNuQd21IcAtYrU', 1571952023),
(1708, 2028, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI4IiwidXNlcm1haWwiOiJjZmZvbnNlY2FAdWEucHQiLCJpYXQiOjE1NzE5NTA2MjMsImV4cCI6MTU3MTk1MjQyMywicGVybWlzc2lvbiI6IiJ9.kfWzzwe3E7IqQ0x26bAeqR96J7GzmoSvpadl-aDzYmk', 1571952423),
(1711, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzE5NTA4NjYsImV4cCI6MTU3MTk1MjY2NiwicGVybWlzc2lvbiI6IiJ9.aI97mcI4uwvWbdHivMWdKHqGfWf_jkd6wEtiIM6krvM', 1571952666),
(1714, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU3MTk1MTUwNCwiZXhwIjoxNTcxOTUzMzA0LCJwZXJtaXNzaW9uIjoiIn0.Cym8W41guyteoJuYEGfPk8Opd0LxawIAj649aq2s_jU', 1571953304),
(1717, 2053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUzIiwidXNlcm1haWwiOiJtYXJ0aW5oby50YXZhcmVzQHVhLnB0IiwiaWF0IjoxNTcxOTUxNTA5LCJleHAiOjE1NzE5NTMzMDksInBlcm1pc3Npb24iOiIifQ.G9XC8NuvosJibiVHUe88Gu0rImdqueLQ3ZOR2scaMkE', 1571953309),
(1720, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU3MTk1MTcxOSwiZXhwIjoxNTcxOTUzNTE5LCJwZXJtaXNzaW9uIjoiIn0.tbwPRNDoFes6devKglTznw_1gkOms46Fdob4sLDt4yI', 1571953519),
(1723, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzE5NTQ4ODEsImV4cCI6MTU3MTk1NjY4MSwicGVybWlzc2lvbiI6IiJ9.CmiWmmo7UNKHFO4ko2Lqd0Pi3LvSTsiyJYm1OOb7PyE', 1571956681),
(1726, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU3MTk1NTYwNCwiZXhwIjoxNTcxOTU3NDA0LCJwZXJtaXNzaW9uIjoiIn0.nolyeUvjCGiodp3Ov92J4fs3C9KyHXvv9erBvSe_yDA', 1571957404),
(1729, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1NzE5NTc3NDAsImV4cCI6MTU3MTk1OTU0MCwicGVybWlzc2lvbiI6IiJ9.AeXymxOr37LI7TM_HThrm7v8zl3ObYbQ9CoktJYX1qc', 1571959540),
(1732, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU3MTk1OTc1NSwiZXhwIjoxNTcxOTYxNTU1LCJwZXJtaXNzaW9uIjoiIn0.CsBeh65SCCDfonZo6ymap3nVvXSIeE4kR1_MnxEsw7U', 1571961555),
(1735, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcxOTU5NzkxLCJleHAiOjE1NzE5NjE1OTEsInBlcm1pc3Npb24iOiIifQ.tJb7mQuRcuISiGtzozi6w-NVKfPk9SZoATjL1ob5a5Y', 1571961591),
(1738, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTcxOTYwNzk2LCJleHAiOjE1NzE5NjI1OTYsInBlcm1pc3Npb24iOiIifQ.AiKzjPZjvD4cZV-v9SKzkxiXobMkpxW2ZxrVsqv3F74', 1571962596),
(1744, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU3MTk3MDE3MCwiZXhwIjoxNTcxOTcxOTcwLCJwZXJtaXNzaW9uIjoiIn0.t6LTTLTSYQh5TUTVsPzzn0zxr_QGrsjVGJW4F3VC6fQ', 1571971970),
(1750, 1479, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDc5IiwidXNlcm1haWwiOiJqb3NlbG1kYnNvdXNhQHVhLnB0IiwiaWF0IjoxNTcxOTk4NjU1LCJleHAiOjE1NzIwMDA0NTUsInBlcm1pc3Npb24iOiIifQ.QHj6IiaXGIwunqRUpPwXDonr8xYM-VZEDoegdnFyMdg', 1572000455),
(1753, 2061, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYxIiwidXNlcm1haWwiOiJwZGZsQHVhLnB0IiwiaWF0IjoxNTcxOTk5NDgyLCJleHAiOjE1NzIwMDEyODIsInBlcm1pc3Npb24iOiIifQ.KydThCl7p4GOLPYrdMnM0mBY4oV9Mi5quIpZ-qSfJZU', 1572001282),
(1756, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzIwMDE1MjMsImV4cCI6MTU3MjAwMzMyMywicGVybWlzc2lvbiI6IiJ9.z9saGm818zipZsC0suxEjcXv0oXZmfijLBrI2vn-unA', 1572003323),
(1759, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTcyMDAyMTkwLCJleHAiOjE1NzIwMDM5OTAsInBlcm1pc3Npb24iOiIifQ.VBEnqX4rHtt-qnVQyKHkhxYjuqeeefXNVz-A2PJTEm4', 1572003990),
(1762, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTcyMDAyMzI4LCJleHAiOjE1NzIwMDQxMjgsInBlcm1pc3Npb24iOiIifQ.PeNfDpiVcoB9WekUe0SHe-r3qBDJNl7gSYPWDfknLa0', 1572004128),
(1765, 2057, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU3IiwidXNlcm1haWwiOiJwbWQ4QHVhLnB0IiwiaWF0IjoxNTcyMDA1NjgzLCJleHAiOjE1NzIwMDc0ODMsInBlcm1pc3Npb24iOiIifQ.p5yYOhnsK-AvBqvy-f9ep-4jKnGCB6NzY2f-PpUGAlo', 1572007483),
(1768, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTcyMDA2MDkyLCJleHAiOjE1NzIwMDc4OTIsInBlcm1pc3Npb24iOiIifQ.sW7T0fRJtg7inaNoLqg12I-IO-8MBzf0bWJV4nLBxeE', 1572007892),
(1771, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzIwMDgyMDgsImV4cCI6MTU3MjAxMDAwOCwicGVybWlzc2lvbiI6IiJ9.GAcrZ6vQT5frl47STz7HjQXLasaz3RlvnQ8NzW8a1tA', 1572010008),
(1777, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3MjAyNDMxNCwiZXhwIjoxNTcyMDI2MTE0LCJwZXJtaXNzaW9uIjoiIn0.NbjujTTtyDTKYDXobxwLMFA8W5uYDYLbsWHA5MWBmA8', 1572026114),
(1780, 1827, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODI3IiwidXNlcm1haWwiOiJyaWNhcmRvLmNydXoyOUB1YS5wdCIsImlhdCI6MTU3MjAyNjA2MSwiZXhwIjoxNTcyMDI3ODYxLCJwZXJtaXNzaW9uIjoiIn0.fQEsFFiFJqyCY_-j0OoewxQfl5XVRF9dWTk7SGuFYBY', 1572027861),
(1783, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcyMDI2MjcwLCJleHAiOjE1NzIwMjgwNzAsInBlcm1pc3Npb24iOiIifQ.NEDiPk-9vAJ_543HApX1ULcvTM4aahXZepjibQjmFeg', 1572028070),
(1786, 2055, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU1IiwidXNlcm1haWwiOiJtaWd1ZWwuci5mZXJyZWlyYUB1YS5wdCIsImlhdCI6MTU3MjAyODQ0NCwiZXhwIjoxNTcyMDMwMjQ0LCJwZXJtaXNzaW9uIjoiIn0.Ac4S_iMAC1kn1YF8UgLxhDzQpRIKiONdR9CL6nWR7Og', 1572030244),
(1792, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1NzIwMzQ3MDgsImV4cCI6MTU3MjAzNjUwOCwicGVybWlzc2lvbiI6IiJ9.3sGu2YMqgR1hT3QRoReV-rT0O0OtrM6ytt3Rt0k_X-s', 1572036508),
(1795, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTcyMDM3MjAyLCJleHAiOjE1NzIwMzkwMDIsInBlcm1pc3Npb24iOiIifQ.yL1efZ1-Xl4Yzb2A9e9RVSpz4vjeiuBz4K_7xSm_qLI', 1572039002),
(1801, 921, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MjEiLCJ1c2VybWFpbCI6ImFuZHJlZ3VhbEB1YS5wdCIsImlhdCI6MTU3MjA1NjE0MywiZXhwIjoxNTcyMDU3OTQzLCJwZXJtaXNzaW9uIjoiIn0.aZ75MNMpXGjoyNab6-z6g_oRrMDmbnQrulOm19lCoQw', 1572057943),
(1807, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1NzIwNzk2NTYsImV4cCI6MTU3MjA4MTQ1NiwicGVybWlzc2lvbiI6IiJ9.jnQHy2pGh9V1M5ftVD76LY4bOnfgcu0aIE_koqZR5JM', 1572081456);
INSERT INTO `GenTokens` (`id`, `userid`, `token`, `expire_date`) VALUES
(1810, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzIwODM4MDcsImV4cCI6MTU3MjA4NTYwNywicGVybWlzc2lvbiI6IiJ9.kL5JHuGx10fB-wfIxsQ5JvDFUB8zOtpVbQmLeqiKBQw', 1572085607),
(1816, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTcyMDk2MjgwLCJleHAiOjE1NzIwOTgwODAsInBlcm1pc3Npb24iOiIifQ.jAonISRyzOCmOUnx173phFQ5mHHJ_ETcRt6s_H0SBE8', 1572098080),
(1819, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzIwOTY2NjAsImV4cCI6MTU3MjA5ODQ2MCwicGVybWlzc2lvbiI6IiJ9.IvMcQTX1jsCSGGPGxxFRIdZ-GgYlCHy7XdaBwlEN_98', 1572098460),
(1822, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzIwOTcyOTksImV4cCI6MTU3MjA5OTA5OSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.hmwNDQGzCV8kGK0KvTxQdhZwTD5RBqKd_xo1TPgJX6w', 1572099099),
(1825, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MjA5OTM0NSwiZXhwIjoxNTcyMTAxMTQ1LCJwZXJtaXNzaW9uIjoiIn0.waHvHTm6LXmZZuGvY-_wVw1Wk5fEjWRwBYuvNVtCBMw', 1572101145),
(1828, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTcyMTAwMzEyLCJleHAiOjE1NzIxMDIxMTIsInBlcm1pc3Npb24iOiIifQ.HA7OsyrewOeiS1lONRJmlu-zPnyqAt9ppBlkUjRhH-M', 1572102112),
(1831, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcyMTAxMDQ4LCJleHAiOjE1NzIxMDI4NDgsInBlcm1pc3Npb24iOiIifQ.QQptaCD3H7Ad0p3886fvjW6k2zMCn3xMFMTIXdaQoq8', 1572102848),
(1834, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTcyMTAyMzUzLCJleHAiOjE1NzIxMDQxNTMsInBlcm1pc3Npb24iOiIifQ.Hiwn2x6PgAAjakC8N4b_yS03yEpYxwdNu-cbZkXwJTw', 1572104153),
(1837, 1020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIwIiwidXNlcm1haWwiOiJjYXJvbGluYS5hcmF1am8wMEB1YS5wdCIsImlhdCI6MTU3MjEwMzYyOSwiZXhwIjoxNTcyMTA1NDI5LCJwZXJtaXNzaW9uIjoiIn0.UQA180Dpj6SpWvnh3O8kMw10oyZMusM7zWnqm2ulWgs', 1572105429),
(1840, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzIxMDU0NzEsImV4cCI6MTU3MjEwNzI3MSwicGVybWlzc2lvbiI6IiJ9.GEbYeeDoKNu_SGGFuW-2nh9Fc9fzv-Hf2ug9Qa1xM-c', 1572107271),
(1843, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1NzIxMDU2MjIsImV4cCI6MTU3MjEwNzQyMiwicGVybWlzc2lvbiI6IiJ9.rSXIxlZ1UrOgcQlTmIVkWWGlev4XZaHiHfxaeyc07l0', 1572107422),
(1846, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTcyMTA5MjgxLCJleHAiOjE1NzIxMTEwODEsInBlcm1pc3Npb24iOiIifQ.iPrYyfEZw0qL8W6nOagF53shCmlNOyoqwwaD6EUu9i8', 1572111081),
(1849, 1701, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzAxIiwidXNlcm1haWwiOiJwLnNlaXhhczk2QHVhLnB0IiwiaWF0IjoxNTcyMTA5NjQ0LCJleHAiOjE1NzIxMTE0NDQsInBlcm1pc3Npb24iOiIifQ.jGGhqOn4VGMxkikQeCCjVMk6fvcOxdnv4g5VqApQwB8', 1572111444),
(1852, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1NzIxMTM0MDYsImV4cCI6MTU3MjExNTIwNiwicGVybWlzc2lvbiI6IiJ9.s0zRuvIj9-IRMBqnMddvPlh3Mm1Uh4iYV5TUQg_WeoE', 1572115206),
(1855, 1701, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzAxIiwidXNlcm1haWwiOiJwLnNlaXhhczk2QHVhLnB0IiwiaWF0IjoxNTcyMTEzOTUyLCJleHAiOjE1NzIxMTU3NTIsInBlcm1pc3Npb24iOiIifQ.Lkc4mwKw0juqh94fWHkpJbY2ANOvGvPtYyIZeOKx7E0', 1572115752),
(1858, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzIxMTYwNzIsImV4cCI6MTU3MjExNzg3MiwicGVybWlzc2lvbiI6IiJ9.RXKhgRgbF3mJms9N5qlb_gAfhi59JJsZygmybQ_ICu4', 1572117872),
(1861, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1NzIxMTY5NDIsImV4cCI6MTU3MjExODc0MiwicGVybWlzc2lvbiI6IiJ9.KNyUDtDw1O1kk93cGekCv_mJgJRZ1p7KDdFPTI1A5C8', 1572118742),
(1864, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1NzIxMTcxMjgsImV4cCI6MTU3MjExODkyOCwicGVybWlzc2lvbiI6IiJ9.FGnJfoFNW3prXPJwTGsBlhzOkxF958lnhcbN7ZgieOU', 1572118928),
(1867, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTcyMTE3NTU5LCJleHAiOjE1NzIxMTkzNTksInBlcm1pc3Npb24iOiIifQ.J0yxfRD1b1eL8KK_RtNcrILS9P5JlpPRNxkpbvYgL8I', 1572119359),
(1873, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTcyMTIxOTI5LCJleHAiOjE1NzIxMjM3MjksInBlcm1pc3Npb24iOiIifQ.dIl0wUwl3WMRCB6Vialx0hIgsIfmTijTrvyDsqd7pro', 1572123729),
(1876, 1758, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzU4IiwidXNlcm1haWwiOiJwZWRyb21nc291dG9AdWEucHQiLCJpYXQiOjE1NzIxMjQ0NDEsImV4cCI6MTU3MjEyNjI0MSwicGVybWlzc2lvbiI6IiJ9.peyNHRh5A0o-eEXqpG3eMxemg3YahWil1mPOGKDfBsA', 1572126241),
(1879, 1182, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTgyIiwidXNlcm1haWwiOiJkdWFydGUubnRtQHVhLnB0IiwiaWF0IjoxNTcyMTI1NzE0LCJleHAiOjE1NzIxMjc1MTQsInBlcm1pc3Npb24iOiIifQ.1nEnqmTHYa_pQses9mQ7f8KThwC1QrvzkZ8FKdz6Fw4', 1572127514),
(1882, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTcyMTI5MTMxLCJleHAiOjE1NzIxMzA5MzEsInBlcm1pc3Npb24iOiIifQ.BVJQ3sbjqfegE92AsxeSaJ11R0isnjewn3vghG7wHHA', 1572130931),
(1888, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTcyMTM2ODgzLCJleHAiOjE1NzIxMzg2ODMsInBlcm1pc3Npb24iOiIifQ.WfCOTORhaAljiBSljnQFBVdzh47gDhdO7hO-jxo_ZDI', 1572138683),
(1891, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzIxNDA5NjUsImV4cCI6MTU3MjE0Mjc2NSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.dR7RI2RGpHPfarTHtdV8-ztVvGtflc7rH8ZiD1VHEhI', 1572142765),
(1894, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTcyMTQzNjQ5LCJleHAiOjE1NzIxNDU0NDksInBlcm1pc3Npb24iOiIifQ.k-6ep3uRTGL31lhxur26uDO7ySylvRbqqo8ZlwbpFR8', 1572145449),
(1900, 1479, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDc5IiwidXNlcm1haWwiOiJqb3NlbG1kYnNvdXNhQHVhLnB0IiwiaWF0IjoxNTcyMTY3NDk1LCJleHAiOjE1NzIxNjkyOTUsInBlcm1pc3Npb24iOiIifQ.wnAAyj64b5wRu8Fa9H3r3kZSw0RY1N9hcA4DJtQXIus', 1572169295),
(1903, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1NzIxNzExNjcsImV4cCI6MTU3MjE3Mjk2NywicGVybWlzc2lvbiI6IiJ9.F3N8DuTs8me6jWZ5rxqzUTfRvGt1zLS0YHCv4iAQx5M', 1572172967),
(1909, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTcyMTc4MDY4LCJleHAiOjE1NzIxNzk4NjgsInBlcm1pc3Npb24iOiIifQ.2MIVeiAFM7J-wVVIpn_HuwQ9moragB0DE-oa1eahiig', 1572179868),
(1912, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU3MjE3ODUxMywiZXhwIjoxNTcyMTgwMzEzLCJwZXJtaXNzaW9uIjoiIn0.Sj6Se_1lMPm2iqM_mUlL4aYPXpvnL4hAHDY-J0UWHd4', 1572180313),
(1915, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTcyMTgxMDg4LCJleHAiOjE1NzIxODI4ODgsInBlcm1pc3Npb24iOiIifQ.2X3olmgZC8hKmaCaDHUVodRpERGKBDFt3vNiCoBMz0U', 1572182888),
(1918, 1734, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzM0IiwidXNlcm1haWwiOiJwZWRyb2Fnb25jYWx2ZXNtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTcyMTgyODMwLCJleHAiOjE1NzIxODQ2MzAsInBlcm1pc3Npb24iOiIifQ.Av_3_9Ck7oZ-d4v7UfKafpgl2RYuuDsgViJRqDdEQ2o', 1572184630),
(1921, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzIxODM5ODYsImV4cCI6MTU3MjE4NTc4NiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.6u_3Vl-V0MokV0V82gQkW5reYtZYf7nTgIREe3Z6lww', 1572185786),
(1924, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzIxODUzMzksImV4cCI6MTU3MjE4NzEzOSwicGVybWlzc2lvbiI6IiJ9.flN3CxSRZ4wdjzPFxFI_yoReot8d33Ib9RKa_BS2u14', 1572187139),
(1927, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcyMTg1NDc3LCJleHAiOjE1NzIxODcyNzcsInBlcm1pc3Npb24iOiIifQ.uScp5j4wfF8Nh7-EwFynKbbkodPKJTOwfXucgyoDcZo', 1572187277),
(1930, 2057, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU3IiwidXNlcm1haWwiOiJwbWQ4QHVhLnB0IiwiaWF0IjoxNTcyMTg1NTMwLCJleHAiOjE1NzIxODczMzAsInBlcm1pc3Npb24iOiIifQ.WfqfIHaON1CRpgRlBeWBzaPOsQz3VgTubu5EH9gTEDc', 1572187330),
(1936, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3MjE4NTczNSwiZXhwIjoxNTcyMTg3NTM1LCJwZXJtaXNzaW9uIjoiIn0.Co-Ork-sCzEfrZBVn_x01QbZGtT6QWbj0sHPqJc42Go', 1572187535),
(1939, 2025, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI1IiwidXNlcm1haWwiOiJhbmRyZWlhLnBvcnRlbGFAdWEucHQiLCJpYXQiOjE1NzIxODYzNzUsImV4cCI6MTU3MjE4ODE3NSwicGVybWlzc2lvbiI6IiJ9.DK6HWBJdeN6BIqXyYBimGsEIwaqblgIFPUrNT8z8F80', 1572188175),
(1942, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MjE4NzkzNiwiZXhwIjoxNTcyMTg5NzM2LCJwZXJtaXNzaW9uIjoiIn0.yYuHPI2GrfF4AuAF4kvRcHI8ceXLLcYj8Nuo5cX3t1k', 1572189736),
(1945, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU3MjE4ODMzNSwiZXhwIjoxNTcyMTkwMTM1LCJwZXJtaXNzaW9uIjoiIn0.I2txvQMV-h-ClPYX0DBSm4STZ_19H5xuiRbWDRanOxg', 1572190135),
(1948, 2047, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ3IiwidXNlcm1haWwiOiJqb2FvcmVpczE2QHVhLnB0IiwiaWF0IjoxNTcyMTg4NjU2LCJleHAiOjE1NzIxOTA0NTYsInBlcm1pc3Npb24iOiIifQ.p4xvHd1rqslZvKJb9XvcX7FN1vb5cQFq4MkLYsr0C9A', 1572190456),
(1951, 1479, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDc5IiwidXNlcm1haWwiOiJqb3NlbG1kYnNvdXNhQHVhLnB0IiwiaWF0IjoxNTcyMTkwNjYwLCJleHAiOjE1NzIxOTI0NjAsInBlcm1pc3Npb24iOiIifQ.JCzT1hnYB6QrR2Q02ApM2_IqRvksNWGMh1JGCroKUt0', 1572192460),
(1954, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU3MjE5MzQ5NCwiZXhwIjoxNTcyMTk1Mjk0LCJwZXJtaXNzaW9uIjoiIn0.rliv_sjPQIoMXoo1ykj8Fq-KKKQDHxeIvdNoEBXjR1I', 1572195294),
(1957, 2045, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ1IiwidXNlcm1haWwiOiJodWdvZ29uY2FsdmVzMTNAdWEucHQiLCJpYXQiOjE1NzIxOTUyMzcsImV4cCI6MTU3MjE5NzAzNywicGVybWlzc2lvbiI6IiJ9.N-V_uRI7_hVwU_wQ-J6Dt18JfuXzg6s-WTG9KmeRYHU', 1572197037),
(1960, 1026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDI2IiwidXNlcm1haWwiOiJjYXJvbGluYXJlc2VuZGVtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTcyMTk2ODk3LCJleHAiOjE1NzIxOTg2OTcsInBlcm1pc3Npb24iOiIifQ.ZoW7cohNrLHJU_tbgkZuux1wc1pGwKJFH4vv5bXflYM', 1572198697),
(1963, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTcyMTk3MDM0LCJleHAiOjE1NzIxOTg4MzQsInBlcm1pc3Npb24iOiIifQ.jQ-8Zviy7DZv0VE6gMT9xTb-aZdpUnh-sX0ROFLfndg', 1572198834),
(1966, 2061, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYxIiwidXNlcm1haWwiOiJwZGZsQHVhLnB0IiwiaWF0IjoxNTcyMTk5NTU2LCJleHAiOjE1NzIyMDEzNTYsInBlcm1pc3Npb24iOiIifQ.fxszHuHgPDhLLqHnO99l5SM6xM3HlNIb2Lttfu6v-28', 1572201356),
(1969, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTcyMjAyNDAzLCJleHAiOjE1NzIyMDQyMDMsInBlcm1pc3Npb24iOiIifQ.xxv3pi8CxcOSXB-uA9fqdyrjKhDV39xghQrd-YjbXkc', 1572204203),
(1975, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzIyMDk5NDMsImV4cCI6MTU3MjIxMTc0MywicGVybWlzc2lvbiI6IiJ9.oPQvuFRo-SIaeoHZn008LNc1WaSV8UAoPfqpN5MANuE', 1572211743),
(1978, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzIyMTI1NDAsImV4cCI6MTU3MjIxNDM0MCwicGVybWlzc2lvbiI6IiJ9.jT6TeEnvfrwdeoGouU09ITFqkyR1o9XSb7cp24lJ0K0', 1572214340),
(1981, 1722, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzIyIiwidXNlcm1haWwiOiJwZWRyby5taWd1ZWw1MEB1YS5wdCIsImlhdCI6MTU3MjIxNDI5MywiZXhwIjoxNTcyMjE2MDkzLCJwZXJtaXNzaW9uIjoiIn0.5o9Lw4M0rsU2AxhIuJYbo2LP525ppoN4TYsvhLdjn8A', 1572216093),
(1984, 1362, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzYyIiwidXNlcm1haWwiOiJqLnZhc2NvbmNlbG9zOTlAdWEucHQiLCJpYXQiOjE1NzIyMTQ2MjksImV4cCI6MTU3MjIxNjQyOSwicGVybWlzc2lvbiI6IiJ9.3scZdS6rJTbqXI-3tXHDj9U9FU9FU5Ds_NIiEFD2iDs', 1572216429),
(1987, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU3MjIxNTk5MSwiZXhwIjoxNTcyMjE3NzkxLCJwZXJtaXNzaW9uIjoiIn0.wuv0WBlCXhfsKD6rVkyvCFeItyu0MmcAyyFzQiuCVRo', 1572217791),
(1989, 1890, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODkwIiwidXNlcm1haWwiOiJzLmdvbWVzQHVhLnB0IiwiaWF0IjoxNTcyMjU2ODUyLCJleHAiOjE1NzIyNTg2NTIsInBlcm1pc3Npb24iOiIifQ.UNoEgnvy_tbo_N1KXIzPumlFpAC51fjjEePtxYL0T5I', 1572258652),
(1991, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1NzIyNTY4NzMsImV4cCI6MTU3MjI1ODY3MywicGVybWlzc2lvbiI6IiJ9.VntFzZ1G7nAMXIinaiTkwRP0UUz0DbM1Jg9hbEQwGF8', 1572258673),
(1996, 1164, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTY0IiwidXNlcm1haWwiOiJkaW9nb2JlbnRvQHVhLnB0IiwiaWF0IjoxNTcyMjYzNjAyLCJleHAiOjE1NzIyNjU0MDIsInBlcm1pc3Npb24iOiIifQ.TsS6H9zxXwn2_2xlHgwIh1ko8PX6E-q7x2ut8gKE6Z8', 1572265402),
(1999, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3MjI2NDQ2MiwiZXhwIjoxNTcyMjY2MjYyLCJwZXJtaXNzaW9uIjoiIn0.WTqRwtlg1qxZMlwpUFlh3RQ3mnKwaCjA4Pk8npNeKlE', 1572266262),
(2005, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTcyMjY0OTU0LCJleHAiOjE1NzIyNjY3NTQsInBlcm1pc3Npb24iOiIifQ.QKrIEsBuGoJRLiHkgoYdihA3zTgVN8Fk1RnGPwdfL0Y', 1572266754),
(2011, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTcyMjY0OTI5LCJleHAiOjE1NzIyNjY3MjksInBlcm1pc3Npb24iOiIifQ.CJlnPGAKb01_kAWx6UXDqHy6V_wA0rsGMtlJT3AVy7I', 1572266729),
(2013, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MjI3MzA4MywiZXhwIjoxNTcyMjc0ODgzLCJwZXJtaXNzaW9uIjoiIn0.zd6o1fCl71T-IwdcJft7H-cejgQUu1PC0pVYQFtWcCE', 1572274883),
(2019, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3MjI3OTE5NywiZXhwIjoxNTcyMjgwOTk3LCJwZXJtaXNzaW9uIjoiIn0.8V8PgiIIQ2lNcHKWwxST4NrV5P4sSCQbETFW-Rqju2c', 1572280997),
(2025, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTcyMjg0NTg1LCJleHAiOjE1NzIyODYzODUsInBlcm1pc3Npb24iOiIifQ.m5rgvknMeOttAT36TpZ7YM_wfDueVq-UFJk6FoafIJA', 1572286385),
(2028, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1NzIyODUzNzQsImV4cCI6MTU3MjI4NzE3NCwicGVybWlzc2lvbiI6IiJ9.tACFk9rAiSY_Cfq_zcMLzpJYkH1WikITfFNsuk_MkLQ', 1572287174),
(2031, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTcyMjg3MjIxLCJleHAiOjE1NzIyODkwMjEsInBlcm1pc3Npb24iOiIifQ.CHv4eCjCSU8YzYy1w9oDk1-0_303xZ1nqLaQdzk_VTA', 1572289021),
(2040, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTcyMjk1MDk4LCJleHAiOjE1NzIyOTY4OTgsInBlcm1pc3Npb24iOiIifQ.OqT3hmzcAEhO0AidYs-yFPZJ4VzRUXYdjllqq6Lu8kI', 1572296898),
(2043, 1344, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQ0IiwidXNlcm1haWwiOiJpbmVzLnNlYWJyYXJvY2hhQHVhLnB0IiwiaWF0IjoxNTcyMjk2MTQ5LCJleHAiOjE1NzIyOTc5NDksInBlcm1pc3Npb24iOiIifQ.8F4aMyQGhmq5HYvi4p2b4OABRMgGxGWj-7roNrxDimY', 1572297949),
(2046, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzIyOTc2MzcsImV4cCI6MTU3MjI5OTQzNywicGVybWlzc2lvbiI6IiJ9.2gzTsw6sL9LO-MtFDBytAJlo5BWCxfGOGMZhPjhn5xM', 1572299437),
(2049, 1479, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDc5IiwidXNlcm1haWwiOiJqb3NlbG1kYnNvdXNhQHVhLnB0IiwiaWF0IjoxNTcyMzAwMjY1LCJleHAiOjE1NzIzMDIwNjUsInBlcm1pc3Npb24iOiIifQ.2JJt-a6Q7G2rljJGa9QFy4d775V_8_-OquHYfJq3RuY', 1572302065),
(2052, 1701, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzAxIiwidXNlcm1haWwiOiJwLnNlaXhhczk2QHVhLnB0IiwiaWF0IjoxNTcyMzAwNDk1LCJleHAiOjE1NzIzMDIyOTUsInBlcm1pc3Npb24iOiIifQ.Gn8dwAq0EwoFadwxaXYl3tZ-i4-zQr8jhZuIhtsH8cI', 1572302295),
(2055, 1284, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjg0IiwidXNlcm1haWwiOiJnb25jYWxvZnJlaXhpbmhvQHVhLnB0IiwiaWF0IjoxNTcyMzAyMjE4LCJleHAiOjE1NzIzMDQwMTgsInBlcm1pc3Npb24iOiIifQ.UZLPz9uB_TblnsZpuz8OAKpWIzBq3xANz4zFmOCHoJ4', 1572304018),
(2058, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MjMwMjQ1MCwiZXhwIjoxNTcyMzA0MjUwLCJwZXJtaXNzaW9uIjoiIn0.JUICbzm7mJ1sfrU_dDvYsK4ZhTUMcDJBpeZftmUPxcM', 1572304250),
(2061, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1NzIzMDQ4MjUsImV4cCI6MTU3MjMwNjYyNSwicGVybWlzc2lvbiI6IiJ9.RpRwugL6kOlEb-F-6pkglmDEmPOWquSZ2-bQYJ27-oI', 1572306625),
(2067, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1NzIzMDkwMDAsImV4cCI6MTU3MjMxMDgwMCwicGVybWlzc2lvbiI6IiJ9.sQfC1FtA5TTHPkkvEFJB4S5c6ogFXif4m5vRZZvXTvo', 1572310800),
(2070, 1479, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDc5IiwidXNlcm1haWwiOiJqb3NlbG1kYnNvdXNhQHVhLnB0IiwiaWF0IjoxNTcyMzA5MTEzLCJleHAiOjE1NzIzMTA5MTMsInBlcm1pc3Npb24iOiIifQ.GJ-QzH1riHTxtayf48YKrhRh8XjhOqKAj1mf_uY6NS4', 1572310913),
(2076, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTcyMzE1NzE5LCJleHAiOjE1NzIzMTc1MTksInBlcm1pc3Npb24iOiIifQ.9GVIzUMAXnnpwHhQ9-6roMnZx3hSInmQ4J_GqZnZnzE', 1572317519),
(2079, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTcyMzE1NzUzLCJleHAiOjE1NzIzMTc1NTMsInBlcm1pc3Npb24iOiIifQ.oZsZORQyZGcXpExeuMgIaGT3DRloLU8H5Spl8iw474I', 1572317553),
(2082, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTcyMzE1NzczLCJleHAiOjE1NzIzMTc1NzMsInBlcm1pc3Npb24iOiIifQ.OL_VNA0dykaMKuZcKKUeM5Dr2WxtKfz8BmXXdEmt4U8', 1572317573),
(2085, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTcyMzE1Nzg5LCJleHAiOjE1NzIzMTc1ODksInBlcm1pc3Npb24iOiIifQ.eNwWmbf66rHyWmHhYfdZT22bkJ7MVycXQ6GX44y2P4I', 1572317589),
(2088, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTcyMzE1ODM5LCJleHAiOjE1NzIzMTc2MzksInBlcm1pc3Npb24iOiIifQ.lhQs-5u_9aXA-vuSTuwEEMtco78anDs_Qt2htgp3ZDE', 1572317639),
(2091, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTcyMzE1ODgzLCJleHAiOjE1NzIzMTc2ODMsInBlcm1pc3Npb24iOiIifQ.-aLU2Z-BLSQvFvZORCRQuBoHf8-unUBvj3LD3G1PWZo', 1572317683),
(2094, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTcyMzE1ODk2LCJleHAiOjE1NzIzMTc2OTYsInBlcm1pc3Npb24iOiIifQ.mMQwRqrayBIvlBXi_J2RwkCP9etV34O-rkF4Nf_rqZ0', 1572317696),
(2097, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTcyMzE1OTA0LCJleHAiOjE1NzIzMTc3MDQsInBlcm1pc3Npb24iOiIifQ.y5uFzmSpdRuJC8x__0e7DurInDEQTjbEZkauB_qeAbY', 1572317704),
(2100, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTcyMzE1OTU2LCJleHAiOjE1NzIzMTc3NTYsInBlcm1pc3Npb24iOiIifQ.NO4lvxbkONNQAGeo2rbObGCZm9jYnWUmCMO1v21HsMc', 1572317756),
(2106, 2038, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM4IiwidXNlcm1haWwiOiJlZHVhcmRvZmVybmFuZGVzQHVhLnB0IiwiaWF0IjoxNTcyMzQxOTkxLCJleHAiOjE1NzIzNDM3OTEsInBlcm1pc3Npb24iOiIifQ.lXbn6LCY65nXKUcYYno9RquxcflYhkEZMh6MDFlo200', 1572343791),
(2112, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTcyMzQ1MDA5LCJleHAiOjE1NzIzNDY4MDksInBlcm1pc3Npb24iOiIifQ.J_NRucqXBowrVd-nNoDUBQpTiqML7okLSjuudTOLxRM', 1572346809),
(2115, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MjM0NTQ1NCwiZXhwIjoxNTcyMzQ3MjU0LCJwZXJtaXNzaW9uIjoiIn0.ZDlg-fvUVij28Y-1QOcHrPMkRiyeNaYXthjTluzY3AE', 1572347254),
(2118, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcyMzQ1ODUwLCJleHAiOjE1NzIzNDc2NTAsInBlcm1pc3Npb24iOiIifQ.lzkMrcrSNptDmgyRT8SzN5YO-sVo-_EN-kUWtgCr39Q', 1572347650),
(2121, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzIzNDcyMTksImV4cCI6MTU3MjM0OTAxOSwicGVybWlzc2lvbiI6IiJ9.0xd99oyNLAcIHv_yuVtYOSt_aI8JrxxxT-zeRx6k88I', 1572349019),
(2127, 2025, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI1IiwidXNlcm1haWwiOiJhbmRyZWlhLnBvcnRlbGFAdWEucHQiLCJpYXQiOjE1NzIzNTk5NzQsImV4cCI6MTU3MjM2MTc3NCwicGVybWlzc2lvbiI6IiJ9.lrJzjFLvs9hwdutE-A4Js6ZAc4WLZI4EFNpRzyFM5rs', 1572361774),
(2130, 1827, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODI3IiwidXNlcm1haWwiOiJyaWNhcmRvLmNydXoyOUB1YS5wdCIsImlhdCI6MTU3MjM2MDgwMiwiZXhwIjoxNTcyMzYyNjAyLCJwZXJtaXNzaW9uIjoiIn0.-4zFhqdq89PotCzZRAR9iBcxe01Xbovy0XOMfJ76z6g', 1572362602),
(2133, 1479, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDc5IiwidXNlcm1haWwiOiJqb3NlbG1kYnNvdXNhQHVhLnB0IiwiaWF0IjoxNTcyMzYxODc4LCJleHAiOjE1NzIzNjM2NzgsInBlcm1pc3Npb24iOiIifQ.FuhhJsuNlDb0dAzBJy_ebiZyJBJ04PtbEc7MIxWE3qU', 1572363678),
(2136, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTcyMzYxOTM1LCJleHAiOjE1NzIzNjM3MzUsInBlcm1pc3Npb24iOiIifQ.Ry2Bp0MMqBXDUBOeRjFZ9pJI6KfC2lomworWZqg4njI', 1572363735),
(2139, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1NzIzNjQyNjUsImV4cCI6MTU3MjM2NjA2NSwicGVybWlzc2lvbiI6IiJ9._8ZciyhNXiDzH3UXcQbU0kf8tUbMYHJaQzIGvd4eoW8', 1572366065),
(2142, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcyMzY2NDY3LCJleHAiOjE1NzIzNjgyNjcsInBlcm1pc3Npb24iOiIifQ.SJcL5w2G-RofukCtoDjmvr3mfk1DBbqS5rX-VSJAIBE', 1572368267),
(2145, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTcyMzY2OTcwLCJleHAiOjE1NzIzNjg3NzAsInBlcm1pc3Npb24iOiIifQ.Bau9p4AWqblkC6EyuetCz6E7fPZdFJaJUF13bPyWZpM', 1572368770),
(2151, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MjM3MDg5MSwiZXhwIjoxNTcyMzcyNjkxLCJwZXJtaXNzaW9uIjoiIn0.xnqZFI6KpYnKXxYNp4aJtueDNYzAlJSnLloUYkEjH24', 1572372691),
(2157, 1806, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA2IiwidXNlcm1haWwiOiJyYWZhZWxndGVpeGVpcmFAdWEucHQiLCJpYXQiOjE1NzIzNzUxMzMsImV4cCI6MTU3MjM3NjkzMywicGVybWlzc2lvbiI6IiJ9.ojR6bYzlDx2dnG3TlXS1K_SnA3p1cFq6M76IXU5L8ms', 1572376933),
(2160, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTcyMzc2MjIxLCJleHAiOjE1NzIzNzgwMjEsInBlcm1pc3Npb24iOiIifQ.jnOkj4sFWv20QUU8FV-r-YPMKC6crSV9O0sRWaH2q78', 1572378021),
(2163, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTcyMzc3NzU5LCJleHAiOjE1NzIzNzk1NTksInBlcm1pc3Npb24iOiIifQ.Fv6BsJJMol1F9aKxrLt50Iw66jOixJbHM_qwCCcVCYw', 1572379559),
(2169, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1NzIzODIzOTgsImV4cCI6MTU3MjM4NDE5OCwicGVybWlzc2lvbiI6IiJ9.gCeVY-pnP7bDmrgdxHz0Vp-TJNmgYE0EmLMqijvF0ek', 1572384198),
(2172, 1446, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDQ2IiwidXNlcm1haWwiOiJqb2FvcHZhc2NvbmNlbG9zQHVhLnB0IiwiaWF0IjoxNTcyMzgyNDI0LCJleHAiOjE1NzIzODQyMjQsInBlcm1pc3Npb24iOiIifQ.hpqbmGa-qbqaN-_ycYuFrxgzk-ykpn8Rw2SJiYs5z8k', 1572384224),
(2175, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTcyMzgzNDQxLCJleHAiOjE1NzIzODUyNDEsInBlcm1pc3Npb24iOiIifQ.u3is0UXcWW0D7DTrK2uBDKB84RpkrHYtVDg-5blpb7k', 1572385241),
(2178, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU3MjM4Mzc3MywiZXhwIjoxNTcyMzg1NTczLCJwZXJtaXNzaW9uIjoiIn0.0vqvT-Mf6MFwilLO8yITwFgpG_NiqbeM4O9w9cjB_EI', 1572385573),
(2181, 2047, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ3IiwidXNlcm1haWwiOiJqb2FvcmVpczE2QHVhLnB0IiwiaWF0IjoxNTcyMzg2MzcxLCJleHAiOjE1NzIzODgxNzEsInBlcm1pc3Npb24iOiIifQ.aFSnZZQ40fYy_KVz9PnvZhyE3BhynKRERrvpnctRYHQ', 1572388171),
(2187, 1149, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTQ5IiwidXNlcm1haWwiOiJkaW9nby5nQHVhLnB0IiwiaWF0IjoxNTcyMzk2OTg5LCJleHAiOjE1NzIzOTg3ODksInBlcm1pc3Npb24iOiIifQ.a-8w2LRX3OtE_1GVQMWujv0mguX6p5GzJnAFpdbUbpY', 1572398789),
(2190, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU3MjM5ODI0NiwiZXhwIjoxNTcyNDAwMDQ2LCJwZXJtaXNzaW9uIjoiIn0.TZqoZ1nsVXuI6w4tvbh3Gb1-JPTA2HmxqfFuP9MtKck', 1572400046),
(2196, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MjQyNTkzMiwiZXhwIjoxNTcyNDI3NzMyLCJwZXJtaXNzaW9uIjoiIn0.cNwgLDAOKXtJTUYXqkTeXZeJvNvOnNeL3U5mMrEhT8Q', 1572427732),
(2202, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MjQzMDA0MywiZXhwIjoxNTcyNDMxODQzLCJwZXJtaXNzaW9uIjoiIn0.d0P01g_b4MEABMhWWo6gR1284YqxubWMkql28dvUWt4', 1572431843),
(2208, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MjQzNDYxMiwiZXhwIjoxNTcyNDM2NDEyLCJwZXJtaXNzaW9uIjoiIn0.675e3Fr7upjIPjFQJKmvz9hTZjxoUQnRkVte2McTuck', 1572436412),
(2211, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTcyNDM1NTMwLCJleHAiOjE1NzI0MzczMzAsInBlcm1pc3Npb24iOiIifQ.l23J2aEf6rzpDVEfdgJQHC4KjHlTVn-BJcOG-DllHqk', 1572437330),
(2214, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTcyNDM3NjAxLCJleHAiOjE1NzI0Mzk0MDEsInBlcm1pc3Npb24iOiIifQ.-DXSQOG4ILdXCy0U0AyOH64AX5iuhjAQKl7Vq9TYw-o', 1572439401),
(2217, 1395, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzk1IiwidXNlcm1haWwiOiJqb2FvLnAubWFycXVlc0B1YS5wdCIsImlhdCI6MTU3MjQzNzYwMSwiZXhwIjoxNTcyNDM5NDAxLCJwZXJtaXNzaW9uIjoiIn0.n61MIXBlCsBByCgkeX6fzumIHgaGK3JSCFAO0c4b3UI', 1572439401),
(2223, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTcyNDM5ODk4LCJleHAiOjE1NzI0NDE2OTgsInBlcm1pc3Npb24iOiIifQ.EO_bsHcPs787unjYQEY8XbIKzK6T7_xurIBvQKXhKlE', 1572441698),
(2229, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzI0NDUzMDQsImV4cCI6MTU3MjQ0NzEwNCwicGVybWlzc2lvbiI6IiJ9.kSAzmIaW7jGGuIP1kM8-y6CJ1o0ukYTRwxHYv5kpxYw', 1572447104),
(2232, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTcyNDQ1NTU0LCJleHAiOjE1NzI0NDczNTQsInBlcm1pc3Npb24iOiIifQ.EA0XYuWX5E3tHwafUnBJ9bWjhPV5W1OD_WnEF03Y4qk', 1572447354),
(2235, 1389, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzg5IiwidXNlcm1haWwiOiJqb2FvLmxhcmFuam9AdWEucHQiLCJpYXQiOjE1NzI0NDczODgsImV4cCI6MTU3MjQ0OTE4OCwicGVybWlzc2lvbiI6IiJ9.h-RjAjxqvMoKQdSrtTVmpmiaNxx_WqLHIDWRQ1OmdTI', 1572449188),
(2238, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1NzI0NDkzOTQsImV4cCI6MTU3MjQ1MTE5NCwicGVybWlzc2lvbiI6IiJ9.oTlgtlDCinOnNHlM7yNN4c73DVgSe-mhY8ls0KwDZNk', 1572451194),
(2241, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTcyNDQ5NTg3LCJleHAiOjE1NzI0NTEzODcsInBlcm1pc3Npb24iOiIifQ.UxiZEYdsH2Kwl3FH9T6BCji4_5w5sHoxUQyNx963RAg', 1572451387),
(2247, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTcyNDUzMTU0LCJleHAiOjE1NzI0NTQ5NTQsInBlcm1pc3Npb24iOiIifQ.81nqaUDImzCUz6vBn2z6NAJbznJMl45HWVsrJzaQLlY', 1572454954),
(2250, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1NzI0NTUxMjYsImV4cCI6MTU3MjQ1NjkyNiwicGVybWlzc2lvbiI6IiJ9._cxMWBB4bzajCctqk1BSd9TDyt6QCaUs14JtGs-rCUc', 1572456926),
(2253, 1059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDU5IiwidXNlcm1haWwiOiJjbXNvYXJlc0B1YS5wdCIsImlhdCI6MTU3MjQ1NzY2MiwiZXhwIjoxNTcyNDU5NDYyLCJwZXJtaXNzaW9uIjoiIn0.iKYvFkLD9yPc3bXXN1wzwWrmlqOsJG1KJ-_zYW-f5SE', 1572459462),
(2256, 1059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDU5IiwidXNlcm1haWwiOiJjbXNvYXJlc0B1YS5wdCIsImlhdCI6MTU3MjQ1NzY2NywiZXhwIjoxNTcyNDU5NDY3LCJwZXJtaXNzaW9uIjoiIn0.FTTvAxBOQsu_kXdufHsUuTYvimOq_gV3CRw2_XxiFpw', 1572459467),
(2259, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3MjQ1ODk5MiwiZXhwIjoxNTcyNDYwNzkyLCJwZXJtaXNzaW9uIjoiIn0.WDuKchAXn1D95WThCZ93qYTStBY6qs7a8USRv-BEh30', 1572460792),
(2265, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTcyNDcxMDExLCJleHAiOjE1NzI0NzI4MTEsInBlcm1pc3Npb24iOiIifQ.uf3lYDQAhziBpeWbrIw13viMoXAFveEIDma6Kn5C9dA', 1572472811),
(2268, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTcyNDcxNzcxLCJleHAiOjE1NzI0NzM1NzEsInBlcm1pc3Npb24iOiIifQ.GLkCFXbpgKP41ex7GA857tI8_jlWjJKqBOEt4HdXkgU', 1572473571),
(2274, 1827, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODI3IiwidXNlcm1haWwiOiJyaWNhcmRvLmNydXoyOUB1YS5wdCIsImlhdCI6MTU3MjUxODM1OCwiZXhwIjoxNTcyNTIwMTU4LCJwZXJtaXNzaW9uIjoiIn0.QuMzq19YCQBXUlKo_zexU6g_A6-Jj9qgUlEUGjoypOs', 1572520158),
(2280, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MjUyMTYyNywiZXhwIjoxNTcyNTIzNDI3LCJwZXJtaXNzaW9uIjoiIn0.5yQ9lw4l2lxm-QtI0BGx2ZII87t_R1IO2hO6yxg_kcI', 1572523427),
(2286, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTcyNTI5OTQ4LCJleHAiOjE1NzI1MzE3NDgsInBlcm1pc3Npb24iOiIifQ.TeBvOdxP8IIFB6MjvxI4cfvXEepcRQn8I2cjMA5T4wU', 1572531748),
(2289, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU3MjUzMjI4MCwiZXhwIjoxNTcyNTM0MDgwLCJwZXJtaXNzaW9uIjoiIn0.qp6v1RPffhVBQCKC5ScMBH2jOvSB3KCBlDRisGvf1x8', 1572534080),
(2292, 987, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5ODciLCJ1c2VybWFpbCI6ImJydW5vcGludG81MTUxQHVhLnB0IiwiaWF0IjoxNTcyNTM0MjkzLCJleHAiOjE1NzI1MzYwOTMsInBlcm1pc3Npb24iOiIifQ.6GJVU1EZB5R5f8VU10ScBC2OZm81PtreX_uZmbdMfrc', 1572536093),
(2295, 945, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NDUiLCJ1c2VybWFpbCI6ImFudG9uaW9qb3JnZWZlcm5hbmRlc0B1YS5wdCIsImlhdCI6MTU3MjUzNTA1NCwiZXhwIjoxNTcyNTM2ODU0LCJwZXJtaXNzaW9uIjoiIn0.q-fzY2Z9tCZA7UaxR_UnD6nnRKfdVTdiF6a6kV3FEBQ', 1572536854),
(2301, 945, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NDUiLCJ1c2VybWFpbCI6ImFudG9uaW9qb3JnZWZlcm5hbmRlc0B1YS5wdCIsImlhdCI6MTU3MjUzOTU5NSwiZXhwIjoxNTcyNTQxMzk1LCJwZXJtaXNzaW9uIjoiIn0.4aRxvXYMJgcJhkh1b1dnFcD4VHA9DfarTC1It0A7-Is', 1572541395),
(2307, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3MjU0OTI4MiwiZXhwIjoxNTcyNTUxMDgyLCJwZXJtaXNzaW9uIjoiIn0.JRsY8v2g_RdrT296OPapggRCLlBDYNjZHyvkKnU0P9s', 1572551082),
(2313, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU3MjU1NjE5NCwiZXhwIjoxNTcyNTU3OTk0LCJwZXJtaXNzaW9uIjoiIn0.JyEcC0KwU92tuRuj-3NIXP3GXt6AQrQj7hFmcodrM6M', 1572557994),
(2316, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTcyNTU5MTM4LCJleHAiOjE1NzI1NjA5MzgsInBlcm1pc3Npb24iOiIifQ.33IWgS7VzME4COhmYdVJcXL1MYgoXqlxZ_WSXGUdNts', 1572560938),
(2322, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzI1NjQ3MTcsImV4cCI6MTU3MjU2NjUxNywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.qdpX-vFsGIcaX7stWvGLbrTIopa0w-Dz9z192c5twRc', 1572566517),
(2328, 1446, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDQ2IiwidXNlcm1haWwiOiJqb2FvcHZhc2NvbmNlbG9zQHVhLnB0IiwiaWF0IjoxNTcyNjEwNzA5LCJleHAiOjE1NzI2MTI1MDksInBlcm1pc3Npb24iOiIifQ.JGhglxn4dmzJrnW5CUb9XWx_ZiRqezYg5D-JB6pDKUY', 1572612509),
(2331, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzI2MTE1MTIsImV4cCI6MTU3MjYxMzMxMiwicGVybWlzc2lvbiI6IiJ9.d1tZbArZYwOqjoRWB8Poq6Mt9VvAqBBZAwC3_yxopcA', 1572613312),
(2334, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1NzI2MTQxMjAsImV4cCI6MTU3MjYxNTkyMCwicGVybWlzc2lvbiI6IiJ9.F3YE8nV6KVElxq1UnOCPQXOQrnP2tvH1xf38ewPOcEE', 1572615920),
(2337, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1NzI2MTQ5NjcsImV4cCI6MTU3MjYxNjc2NywicGVybWlzc2lvbiI6IiJ9._67ACcvuOHIRNHtzvvggMOcUDDVP4rcKHgcfxGQ48d0', 1572616767),
(2340, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTcyNjE3MjAzLCJleHAiOjE1NzI2MTkwMDMsInBlcm1pc3Npb24iOiIifQ.WXhpY2JiBqmqyMNuOzla_OcXMG4gIfbCGqPKuaIKJYM', 1572619003),
(2343, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcyNjE4MjUxLCJleHAiOjE1NzI2MjAwNTEsInBlcm1pc3Npb24iOiIifQ.yb1wgZI7aHJw3SOCWfsG6T06Lh-yR-8NGEvveIIRN_8', 1572620051),
(2346, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTcyNjE5MDQ4LCJleHAiOjE1NzI2MjA4NDgsInBlcm1pc3Npb24iOiIifQ.Msux5PosRezbTuoqzdpzEBDDhsHggkVwJRdGBcie0ds', 1572620848),
(2349, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MjYyMDMyNiwiZXhwIjoxNTcyNjIyMTI2LCJwZXJtaXNzaW9uIjoiIn0.WwENi2xDNOp9SZcAM1S5DDvdwrt1dVohbWEUd8Z2Ogw', 1572622126),
(2352, 2045, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ1IiwidXNlcm1haWwiOiJodWdvZ29uY2FsdmVzMTNAdWEucHQiLCJpYXQiOjE1NzI2MjIxODcsImV4cCI6MTU3MjYyMzk4NywicGVybWlzc2lvbiI6IiJ9.ia2_eFCUDkasrkra04FFb0QX79wu0uPf5m-KJxX1JaQ', 1572623987),
(2355, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3MjYyMjMyMCwiZXhwIjoxNTcyNjI0MTIwLCJwZXJtaXNzaW9uIjoiIn0.Ibf6O9rT5gTDOW4lhOroSwY3sYszMSQroelvzwGijOI', 1572624120),
(2358, 2040, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQwIiwidXNlcm1haWwiOiJmYWJpby5tQHVhLnB0IiwiaWF0IjoxNTcyNjI1MzU3LCJleHAiOjE1NzI2MjcxNTcsInBlcm1pc3Npb24iOiIifQ.grDEql3RCfkY5XhrVvz_bFgW7mAenwVinAG6QH-YLjk', 1572627157),
(2361, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcyNjI3NjYzLCJleHAiOjE1NzI2Mjk0NjMsInBlcm1pc3Npb24iOiIifQ.uLqYjfhQIb6xGxU52Tq0RKgbaOXeXL9olHIwZ_xBZ7s', 1572629463),
(2367, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3MjYzMTI0NywiZXhwIjoxNTcyNjMzMDQ3LCJwZXJtaXNzaW9uIjoiIn0.VEzE_0hTc8G1_k7O4t_DC90WIG01jqWaZGYCAKMteyE', 1572633047),
(2370, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTcyNjMzNjE0LCJleHAiOjE1NzI2MzU0MTQsInBlcm1pc3Npb24iOiIifQ.M7aiQkh-mKuIpUZEoW_ixrENc4YFBepM0f0ALlrOCo0', 1572635414),
(2373, 2104, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA0IiwidXNlcm1haWwiOiJhZm9uc28uY2FtcG9zQHVhLnB0IiwiaWF0IjoxNTcyNjM1NjM0LCJleHAiOjE1NzI2Mzc0MzQsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.zVR6ERMJZyw_CwA94WvJnIqdAI_0hXpE2ILhXl-ttNU', 1572637434),
(2376, 1173, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTczIiwidXNlcm1haWwiOiJkbWF0aWFzcGludG9AdWEucHQiLCJpYXQiOjE1NzI2MzkyMTksImV4cCI6MTU3MjY0MTAxOSwicGVybWlzc2lvbiI6IiJ9.ra-vk48Xn2PxnoDarcDZKhf5HXrhkU-T6uqXy6spNLs', 1572641019),
(2379, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTcyNjQzMDA4LCJleHAiOjE1NzI2NDQ4MDgsInBlcm1pc3Npb24iOiIifQ.kgr0bYx1YMUZSaHWKHVB74AHgkFh1TuHTzzZsUByTvM', 1572644808),
(2385, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcyNjUwMjI0LCJleHAiOjE1NzI2NTIwMjQsInBlcm1pc3Npb24iOiIifQ.yzQcQgglfLi6rRfieZaj1eg5hJGc95l4HcciEtp7HRI', 1572652024),
(2388, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzI2NTEyMDMsImV4cCI6MTU3MjY1MzAwMywicGVybWlzc2lvbiI6IiJ9.srzu2Ug4lptrtdu26wIl8NnT3i93tF0jettYTY0GB_k', 1572653003),
(2391, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTcyNjU0MjA4LCJleHAiOjE1NzI2NTYwMDgsInBlcm1pc3Npb24iOiIifQ.z0ymvOzt8dxF4oQN847o1MegsrMLMWabp85dHnALWHM', 1572656008),
(2394, 945, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NDUiLCJ1c2VybWFpbCI6ImFudG9uaW9qb3JnZWZlcm5hbmRlc0B1YS5wdCIsImlhdCI6MTU3MjY1NDQ2MywiZXhwIjoxNTcyNjU2MjYzLCJwZXJtaXNzaW9uIjoiIn0.cxN9QWdYm7_4mhgN4KyE-i5UOsT-TlF4633q9OiWGdw', 1572656263),
(2400, 2028, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI4IiwidXNlcm1haWwiOiJjZmZvbnNlY2FAdWEucHQiLCJpYXQiOjE1NzI2OTcwMTYsImV4cCI6MTU3MjY5ODgxNiwicGVybWlzc2lvbiI6IiJ9.dR8V2XHoV0cAatSRCALrturIpiUFgkDhiioRr44Gk10', 1572698816),
(2403, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzI2OTczOTMsImV4cCI6MTU3MjY5OTE5MywicGVybWlzc2lvbiI6IiJ9.bEOYklEXmQZbMVmbNQl817ZqK-7yqd5XIpXmMWS3ZGs', 1572699193),
(2406, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzI2OTg3NzMsImV4cCI6MTU3MjcwMDU3MywicGVybWlzc2lvbiI6IiJ9.AlBKmoo0SrJA1u4_c2V1dHU3vj1nh0MDpl9FQWYF-PU', 1572700573),
(2409, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzI2OTg4NzcsImV4cCI6MTU3MjcwMDY3NywicGVybWlzc2lvbiI6IiJ9.roQkXglQ6QEAQ1ECV1s5ANlymW7PttaSpyNju2r81Lo', 1572700677),
(2412, 1287, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjg3IiwidXNlcm1haWwiOiJnb25jYWxvcGFzc29zQHVhLnB0IiwiaWF0IjoxNTcyNzAwOTY2LCJleHAiOjE1NzI3MDI3NjYsInBlcm1pc3Npb24iOiIifQ.Zwua3nKPVKPyJOg19YhPlQr3JIICLKDcXaWp1e10IAI', 1572702766),
(2418, 1173, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTczIiwidXNlcm1haWwiOiJkbWF0aWFzcGludG9AdWEucHQiLCJpYXQiOjE1NzI3MDgzODAsImV4cCI6MTU3MjcxMDE4MCwicGVybWlzc2lvbiI6IiJ9.PMzlezbLph8Zs90zV6jLe1q8qZ1HoTZTy08aGwWZfYw', 1572710180),
(2421, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzI3MDg5MjEsImV4cCI6MTU3MjcxMDcyMSwicGVybWlzc2lvbiI6IiJ9.OUAhV3TED2pSNo70Iez5ZhXEZMZRT1wSu58shlN4P90', 1572710721),
(2424, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTcyNzEwMjA4LCJleHAiOjE1NzI3MTIwMDgsInBlcm1pc3Npb24iOiIifQ.VPIbpr5nXToOFpR2AaaGVaBwTEJUq8djx-1sJ3CtydQ', 1572712008),
(2427, 2028, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI4IiwidXNlcm1haWwiOiJjZmZvbnNlY2FAdWEucHQiLCJpYXQiOjE1NzI3MTE5NzIsImV4cCI6MTU3MjcxMzc3MiwicGVybWlzc2lvbiI6IiJ9.XNEMvCVbd7VU-OTpATEhD79_0ibcDeB4g4ghqcqWb6A', 1572713772),
(2430, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MjcxMjU4MywiZXhwIjoxNTcyNzE0MzgzLCJwZXJtaXNzaW9uIjoiIn0.hscT9N-4yFSF2nIppJOmsfK1MKUhAj8jnR47DjWrKw8', 1572714383),
(2433, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MjcxNDM3NCwiZXhwIjoxNTcyNzE2MTc0LCJwZXJtaXNzaW9uIjoiIn0.DppOTYDPdOczzHmlKIpPtExFVwF_sX_mMTnh0cBfQ2U', 1572716174),
(2436, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1NzI3MTQ0OTUsImV4cCI6MTU3MjcxNjI5NSwicGVybWlzc2lvbiI6IiJ9.Zb_LVjk1HpxkFdW_Yv39MBzgJ9MAZKJz0OZ-li-cYC0', 1572716295),
(2439, 1827, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODI3IiwidXNlcm1haWwiOiJyaWNhcmRvLmNydXoyOUB1YS5wdCIsImlhdCI6MTU3MjcxNDg5NSwiZXhwIjoxNTcyNzE2Njk1LCJwZXJtaXNzaW9uIjoiIn0.5W-FI5RAivDCt0C-2snE9F5yz-C6XmS7e1ef9wrQDcM', 1572716695),
(2442, 2047, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ3IiwidXNlcm1haWwiOiJqb2FvcmVpczE2QHVhLnB0IiwiaWF0IjoxNTcyNzE3MjM0LCJleHAiOjE1NzI3MTkwMzQsInBlcm1pc3Npb24iOiIifQ.rnSpBdI_cN8PqHP0UTTUy3FnOKtQsYN5RnkbuEgZ5hE', 1572719034),
(2445, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTcyNzIxNzk2LCJleHAiOjE1NzI3MjM1OTYsInBlcm1pc3Npb24iOiIifQ.51hncIiAhcf8RzAoeuVUZZ2jFOrVz2_rZC97YbTs1b8', 1572723596),
(2448, 1284, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjg0IiwidXNlcm1haWwiOiJnb25jYWxvZnJlaXhpbmhvQHVhLnB0IiwiaWF0IjoxNTcyNzI0MzkzLCJleHAiOjE1NzI3MjYxOTMsInBlcm1pc3Npb24iOiIifQ.8RWPYTZYN3NJ8VsnARnTUPtJrT75tl3W6ir37fE_r34', 1572726193),
(2451, 1755, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzU1IiwidXNlcm1haWwiOiJwZWRyb2xvcGVzbWF0b3NAdWEucHQiLCJpYXQiOjE1NzI3MjQ4NTIsImV4cCI6MTU3MjcyNjY1MiwicGVybWlzc2lvbiI6IiJ9.eVnlryM3opJx1eibYuxEgZFeVAWUrKhfsfs0qbjlkhw', 1572726652),
(2457, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU3MjczMDQzMCwiZXhwIjoxNTcyNzMyMjMwLCJwZXJtaXNzaW9uIjoiIn0.1RiqOUey04UgRwJg3Vw4LraEgfJtwYjX9LqWMI50h7c', 1572732230),
(2463, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU3MjczODgzOCwiZXhwIjoxNTcyNzQwNjM4LCJwZXJtaXNzaW9uIjoiIn0.6d1j1vp4oOg4VZBpso8_hJbSgUuHvMtvQcQpyEEnTMY', 1572740638),
(2466, 2057, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU3IiwidXNlcm1haWwiOiJwbWQ4QHVhLnB0IiwiaWF0IjoxNTcyNzc1ODk4LCJleHAiOjE1NzI3Nzc2OTgsInBlcm1pc3Npb24iOiIifQ.063uJoQ8SPOs6h6sprlxJlS60w1F3nssMaFtR6A81Hc', 1572777698),
(2469, 2053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUzIiwidXNlcm1haWwiOiJtYXJ0aW5oby50YXZhcmVzQHVhLnB0IiwiaWF0IjoxNTcyNzc4Nzk1LCJleHAiOjE1NzI3ODA1OTUsInBlcm1pc3Npb24iOiIifQ.UJFQBCglgy_LQr_lwHwEVK-uOh4IRecS7cBkCUJk3rY', 1572780595),
(2472, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcyNzgxNTE4LCJleHAiOjE1NzI3ODMzMTgsInBlcm1pc3Npb24iOiIifQ.AwCuuupxgzKukFTTo1UZCUM54aLWUvZH73BtISWtxt0', 1572783318),
(2478, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3Mjc5MjAzMSwiZXhwIjoxNTcyNzkzODMxLCJwZXJtaXNzaW9uIjoiIn0.ISIH4ouR_LIwct1RrwLE_8_5tPmq9lnRkQr5qEXnK50', 1572793831),
(2481, 1977, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTc3IiwidXNlcm1haWwiOiJ0aWFnb21lbG9AdWEucHQiLCJpYXQiOjE1NzI3OTM2MjcsImV4cCI6MTU3Mjc5NTQyNywicGVybWlzc2lvbiI6IiJ9.EcDd7Cd1XSfkaW42SJpI--ow3CpCFW10XsxR0pzQMAM', 1572795427),
(2487, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3Mjc5NzU1MCwiZXhwIjoxNTcyNzk5MzUwLCJwZXJtaXNzaW9uIjoiIn0.yxrWNf1zDfeNn4f2fIWiU_nWkzLRY0PNzuOmeHfg9OA', 1572799350),
(2490, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTcyNzk5MTEyLCJleHAiOjE1NzI4MDA5MTIsInBlcm1pc3Npb24iOiIifQ.TT5fcSvO2MDE9dlshh_uVr29ZUUsHatfKmzeI3ioDMc', 1572800912),
(2493, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzI4MDA5MjgsImV4cCI6MTU3MjgwMjcyOCwicGVybWlzc2lvbiI6IiJ9.tYNMp7feDMDscQB1Pyb2t_xPD3rrmhHlA2oxalhI3HM', 1572802728),
(2499, 933, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MzMiLCJ1c2VybWFpbCI6ImFudGhvbnlwZXJlaXJhQHVhLnB0IiwiaWF0IjoxNTcyODEwNzQ4LCJleHAiOjE1NzI4MTI1NDgsInBlcm1pc3Npb24iOiIifQ.uoXWKKfuFF28Y5e0LKwf5DjzRtT2znC190AGPuKxuZY', 1572812548),
(2505, 2036, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM2IiwidXNlcm1haWwiOiJkaW9nb21mc2lsdmE5OEB1YS5wdCIsImlhdCI6MTU3MjgxNTg2MywiZXhwIjoxNTcyODE3NjYzLCJwZXJtaXNzaW9uIjoiIn0.elVPmB25LElCNEiWfw6ePrm_oBJ_ZdFAWb0wzgBA-d0', 1572817663),
(2511, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTcyODI1NTcwLCJleHAiOjE1NzI4MjczNzAsInBlcm1pc3Npb24iOiIifQ.hbbIMNzLqqsEu547fclEohxELTd0dP-6QkZZh9k-60o', 1572827370),
(2514, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3MjgyNjYwNiwiZXhwIjoxNTcyODI4NDA2LCJwZXJtaXNzaW9uIjoiIn0.skd2RoDyFQsW00h5M8HozFjIZf6gNrNjZGF-TGmXElY', 1572828406),
(2517, 1965, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTY1IiwidXNlcm1haWwiOiJ0aWFnb2NtZW5kZXNAdWEucHQiLCJpYXQiOjE1NzI4Mjk2NDQsImV4cCI6MTU3MjgzMTQ0NCwicGVybWlzc2lvbiI6IiJ9.FCrMw1V5-OtmJegSkpHPwhxmhqw2_bsRp_MQBIkWFVY', 1572831444),
(2520, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzI4MzA4MjcsImV4cCI6MTU3MjgzMjYyNywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.5DYWiP5yWYUBTMwGe8Bcq9UNUG0-netmADiGw4Pk3AQ', 1572832627),
(2526, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTcyODY4NjU5LCJleHAiOjE1NzI4NzA0NTksInBlcm1pc3Npb24iOiIifQ.Dcj_52GLIlnr35uZPKtyGVoTwg9m2k_xeOra_bK9zFk', 1572870459),
(2532, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1NzI4NzM5OTksImV4cCI6MTU3Mjg3NTc5OSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.jrTjGk9aqxfZsU-OXATNc1PoNCYW9EjIMqzgc5y2WkE', 1572875799),
(2538, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTcyODc3MzYwLCJleHAiOjE1NzI4NzkxNjAsInBlcm1pc3Npb24iOiIifQ.0zhY-krZC5zyN4F4HM7XC_H3jHcXzGhIu5cB_bTiMpE', 1572879160),
(2541, 987, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5ODciLCJ1c2VybWFpbCI6ImJydW5vcGludG81MTUxQHVhLnB0IiwiaWF0IjoxNTcyODc4NDgyLCJleHAiOjE1NzI4ODAyODIsInBlcm1pc3Npb24iOiIifQ.k95GDX8eN40evvBTrsWtzn9eaOHt3-Bvrw_Av33pbwY', 1572880282),
(2544, 1890, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODkwIiwidXNlcm1haWwiOiJzLmdvbWVzQHVhLnB0IiwiaWF0IjoxNTcyODgwMTcyLCJleHAiOjE1NzI4ODE5NzIsInBlcm1pc3Npb24iOiIifQ.uKBvMklER0DtD4H6eLfD1gST5AX_EApGIfrP_O42fGM', 1572881972),
(2547, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTcyODgwOTk4LCJleHAiOjE1NzI4ODI3OTgsInBlcm1pc3Npb24iOiIifQ.tWMlq6cg07MXEItq6_WeQJGFafS0PsJGKN60Hhh4vQ4', 1572882798),
(2550, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTcyODgxNDYzLCJleHAiOjE1NzI4ODMyNjMsInBlcm1pc3Npb24iOiIifQ.7FKJitTdUZjDPkt7rKlOwHGoN2YcIyNLzrTwszHfhy4', 1572883263),
(2553, 1479, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDc5IiwidXNlcm1haWwiOiJqb3NlbG1kYnNvdXNhQHVhLnB0IiwiaWF0IjoxNTcyODgxNTQ4LCJleHAiOjE1NzI4ODMzNDgsInBlcm1pc3Npb24iOiIifQ.uvrzWZQRjrlsNAuGmF_vRTIuJIxOL-cl0KBaE261hTo', 1572883348),
(2559, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTcyODk0NTU5LCJleHAiOjE1NzI4OTYzNTksInBlcm1pc3Npb24iOiIifQ.Z7krGVOOtWx17lVcLd5SClu5emU1Lupomo5F-3c0KeM', 1572896359),
(2565, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzI4OTgzNTcsImV4cCI6MTU3MjkwMDE1NywicGVybWlzc2lvbiI6IiJ9.YiVRfs3EkswKS1TbA-gdKo9POVvmiKXXx5U49yCfGXk', 1572900157),
(2568, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1NzI4OTk5MDcsImV4cCI6MTU3MjkwMTcwNywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.YObHl5ULDtAPHedp4-ct6PmklVCjT-ipdzQovoTUjmU', 1572901707),
(2571, 1956, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTU2IiwidXNlcm1haWwiOiJ0aWFnby5zcnYub2xpdmVpcmFAdWEucHQiLCJpYXQiOjE1NzI5MDEwNDAsImV4cCI6MTU3MjkwMjg0MCwicGVybWlzc2lvbiI6IiJ9.j-AzxP95QZfLCN3S6qS-M5GWUCjoGZQ4ylUmrt9mGu0', 1572902840),
(2574, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcyOTAzOTc2LCJleHAiOjE1NzI5MDU3NzYsInBlcm1pc3Npb24iOiIifQ.SVZm7KQEurspG-TiDPIdcy4pKRXgWQHPtn8Sc3azbYI', 1572905776),
(2577, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTcyOTA2MTk3LCJleHAiOjE1NzI5MDc5OTcsInBlcm1pc3Npb24iOiIifQ.36mjzlOd2ekCSMx-_30qPeGZky--zx36OV4pH6sGcSo', 1572907997),
(2583, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1NzI5MTM4NDQsImV4cCI6MTU3MjkxNTY0NCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.i8yF3uGarzIx7QgV7DVw4rMSCoADAsMgf-Pp3U4wzBo', 1572915644),
(2589, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1NzI5MTkzMjAsImV4cCI6MTU3MjkyMTEyMCwicGVybWlzc2lvbiI6IiJ9.fJm4lJMKr-Q-nu3uHAHXl0xiXgb69gSK3Z9QI9owb6w', 1572921120);
INSERT INTO `GenTokens` (`id`, `userid`, `token`, `expire_date`) VALUES
(2595, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU3MjkyNjM2NywiZXhwIjoxNTcyOTI4MTY3LCJwZXJtaXNzaW9uIjoiIn0.bn_HQN-c5ehG1dOaPoNN3oOcB8UEwW7gj6ff_hHnoc4', 1572928167),
(2598, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU3MjkzMDEzOSwiZXhwIjoxNTcyOTMxOTM5LCJwZXJtaXNzaW9uIjoiIn0.y-Lk3EfoduS4DUGlU8mKOBcoVaW94i4w_YQweuPQJ1Y', 1572931939),
(2604, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTcyOTQ0NzU0LCJleHAiOjE1NzI5NDY1NTQsInBlcm1pc3Npb24iOiIifQ.b9DnltYhytY8PR67OOpzWFtjdTLtFnNBu-wOWWLvVdU', 1572946554),
(2607, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTcyOTQ0NzY1LCJleHAiOjE1NzI5NDY1NjUsInBlcm1pc3Npb24iOiIifQ.DmK6VVzLZ8omShgAAZZG4o89KfpD20dnG_dYXTuogb0', 1572946565),
(2613, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTcyOTQ3NjIxLCJleHAiOjE1NzI5NDk0MjEsInBlcm1pc3Npb24iOiIifQ.8X4ESriSFvgCErFU8jLPsmhWO6_s1ertnYkaLYfvcSo', 1572949421),
(2616, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcyOTQ4NDQxLCJleHAiOjE1NzI5NTAyNDEsInBlcm1pc3Npb24iOiIifQ.Vbvk-JMuDTfOGPEhLJCCZi9qmrw8iRmAnyppyOxmqik', 1572950241),
(2619, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTcyOTQ5MjQ4LCJleHAiOjE1NzI5NTEwNDgsInBlcm1pc3Npb24iOiIifQ.xaRpdq3eYmmKl3bDZusNxNGtjlgTQ5-BRMk4F51xv4U', 1572951048),
(2625, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTcyOTUwOTA0LCJleHAiOjE1NzI5NTI3MDQsInBlcm1pc3Npb24iOiIifQ.w91uSYdK4KD8S1aVrPRHRepyNEfjAxQPDTUJ9KlZAhg', 1572952704),
(2628, 1233, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjMzIiwidXNlcm1haWwiOiJmYWJpb2RhbmllbEB1YS5wdCIsImlhdCI6MTU3Mjk1MjI1OCwiZXhwIjoxNTcyOTU0MDU4LCJwZXJtaXNzaW9uIjoiIn0.8eY4KgrCqqq2kfmUBdRaEBw7QD0Hd7iud9QcSP-Omqg', 1572954058),
(2631, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3Mjk1MzI2NiwiZXhwIjoxNTcyOTU1MDY2LCJwZXJtaXNzaW9uIjoiIn0.ppyQEnt6SCOn7R8hon5KrCWHNey5z3mYiJT1310p55U', 1572955066),
(2634, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3Mjk1MzI5MywiZXhwIjoxNTcyOTU1MDkzLCJwZXJtaXNzaW9uIjoiIn0.XkvH3N7lL1xS2omAsmVOwvEuPA1bG2xj9qLsscz9K30', 1572955093),
(2637, 1512, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTEyIiwidXNlcm1haWwiOiJqcnNybUB1YS5wdCIsImlhdCI6MTU3Mjk1Mzc1OSwiZXhwIjoxNTcyOTU1NTU5LCJwZXJtaXNzaW9uIjoiIn0.LOnVNM-1lRiKTZICISFR-XvZzIIHwB-q9Wj7DjesYQc', 1572955559),
(2640, 2109, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA5IiwidXNlcm1haWwiOiJmaWxpcGVnQHVhLnB0IiwiaWF0IjoxNTcyOTU0MzA0LCJleHAiOjE1NzI5NTYxMDQsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.ohyr-rZ1yuEJ6BFSg3e7R6kXWcU29TKQg3Z_UBTJWUE', 1572956104),
(2643, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU3Mjk1NTM0OCwiZXhwIjoxNTcyOTU3MTQ4LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.UUqxlQ64FRDTZ0X1tFje6j0med9jnfON01eza4ZH1Rc', 1572957148),
(2646, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzI5NTYwMDIsImV4cCI6MTU3Mjk1NzgwMiwicGVybWlzc2lvbiI6IiJ9.ZDhezmd-7WOYUvdyTWPvMKicUvyfHoTH6iOu7NRR4KY', 1572957802),
(2649, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1NzI5NTc1MzIsImV4cCI6MTU3Mjk1OTMzMiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.8SZvg9Iq69I0Zv0-d1z3mt-5SEDPsg2JCpAcOaullQc', 1572959332),
(2652, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3Mjk1NzgyNywiZXhwIjoxNTcyOTU5NjI3LCJwZXJtaXNzaW9uIjoiIn0.gqViNBv1ukxlwnvIv2wgulUfdxBN2jj3OhVyMUzfTc4', 1572959627),
(2655, 2106, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA2IiwidXNlcm1haWwiOiJzb3BoaWVwb3VzaW5ob0B1YS5wdCIsImlhdCI6MTU3Mjk1ODEzNCwiZXhwIjoxNTcyOTU5OTM0LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.yGAn-QO5jr-mJBJUWlF97n9qK_Llo_VVwWBDWnLiElY', 1572959934),
(2658, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTcyOTU5Njk5LCJleHAiOjE1NzI5NjE0OTksInBlcm1pc3Npb24iOiIifQ.XF1oLjA5oXj-71OdAYZvMYo9HzThF1Js3D9Aw95eCi8', 1572961499),
(2664, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTcyOTY2ODcxLCJleHAiOjE1NzI5Njg2NzEsInBlcm1pc3Npb24iOiIifQ.2jUUZZJQsR-epit8qCDy6Aug-3asjSWZ9rIH8L3cF8U', 1572968671),
(2670, 987, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5ODciLCJ1c2VybWFpbCI6ImJydW5vcGludG81MTUxQHVhLnB0IiwiaWF0IjoxNTcyOTcwMDI2LCJleHAiOjE1NzI5NzE4MjYsInBlcm1pc3Npb24iOiIifQ.MQzRxvGP-3WPyu328Eumf3Tym0jQ9JfoQnQOUac9fxE', 1572971826),
(2676, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzI5Nzc2NDAsImV4cCI6MTU3Mjk3OTQ0MCwicGVybWlzc2lvbiI6IiJ9.oCBtyU0LqW0YapmhlADxp1PU1OA2QN-qMli9av1dQV8', 1572979440),
(2679, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU3Mjk3ODc0MCwiZXhwIjoxNTcyOTgwNTQwLCJwZXJtaXNzaW9uIjoiIn0.nByPSfLOi1KCcsKjNPn4apnDS1wBKEyZde6FM0D5gzc', 1572980540),
(2682, 1434, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDM0IiwidXNlcm1haWwiOiJqb2Fvbm9ndWVpcmEyMEB1YS5wdCIsImlhdCI6MTU3Mjk3OTcwOCwiZXhwIjoxNTcyOTgxNTA4LCJwZXJtaXNzaW9uIjoiIn0.JZ43YbY2J492mslUIrOui1wbWqIAnGdouXC8Qh8t96s', 1572981508),
(2685, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTcyOTgyMjgwLCJleHAiOjE1NzI5ODQwODAsInBlcm1pc3Npb24iOiIifQ.YNMYpZVJy8Ftyv7Z1h0NPf1DzWOcyVTc9ZDYIclB7oc', 1572984080),
(2691, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzI5OTQzNzgsImV4cCI6MTU3Mjk5NjE3OCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.X5ZhrWc90wbDSUjjJa8Yyoue5VntluEvqK9F8UzAQWw', 1572996178),
(2697, 1599, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTk5IiwidXNlcm1haWwiOiJtYXJjb3NzaWx2YUB1YS5wdCIsImlhdCI6MTU3MzAwNzAxOCwiZXhwIjoxNTczMDA4ODE4LCJwZXJtaXNzaW9uIjoiIn0.Y9rObskPaf4tF4FlY4YgIT26zRvmYOe1_yEs4YN4aMk', 1573008818),
(2703, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzMwMzQyNjEsImV4cCI6MTU3MzAzNjA2MSwicGVybWlzc2lvbiI6IiJ9.VfJNAoc1Cs6OlOvDD4cNuNKiC86AxXmE0IBrEEKd-KY', 1573036061),
(2709, 2109, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA5IiwidXNlcm1haWwiOiJmaWxpcGVnQHVhLnB0IiwiaWF0IjoxNTczMDM3MDc4LCJleHAiOjE1NzMwMzg4NzgsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.3A8vXPyMcdT4hg0A24W78pO4Ji6vcNiSd-FGsXJDhmI', 1573038878),
(2712, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTczMDM3OTM3LCJleHAiOjE1NzMwMzk3MzcsInBlcm1pc3Npb24iOiIifQ.qPTmZtmmZzfA-fDEZeW1QkzdcNm9d17q6CX4TR4GQaI', 1573039737),
(2715, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTczMDM5MTA5LCJleHAiOjE1NzMwNDA5MDksInBlcm1pc3Npb24iOiIifQ.u44V91DiTOMPl5YruMASHwqOlJtKacNIma38DvNDDQE', 1573040909),
(2718, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU3MzAzOTM1MiwiZXhwIjoxNTczMDQxMTUyLCJwZXJtaXNzaW9uIjoiIn0.PHN5UVOqVj3cPKK-SKVP4KcS1R2DBt9bWpyB_T7t2y0', 1573041152),
(2721, 2050, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUwIiwidXNlcm1haWwiOiJqb3NldHJpZ29AdWEucHQiLCJpYXQiOjE1NzMwNDAzNjUsImV4cCI6MTU3MzA0MjE2NSwicGVybWlzc2lvbiI6IiJ9.kl7tgbDy0ilP2L_qSe7oHM4wYpJvrsiXhVoZhhvAnYw', 1573042165),
(2724, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzMwNDA0OTQsImV4cCI6MTU3MzA0MjI5NCwicGVybWlzc2lvbiI6IiJ9.PdmETHBozI5SSL1VPr6TVNy01wS_ZJk_kFGQPwXWQ68', 1573042294),
(2730, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzMwNDUzNTksImV4cCI6MTU3MzA0NzE1OSwicGVybWlzc2lvbiI6IiJ9.-Jjdi41twNtHUviGt32tuNIX8PnNb4BOwhJtHeQYo6w', 1573047159),
(2736, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1NzMwNTgyMDgsImV4cCI6MTU3MzA2MDAwOCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.ssQwrHUs3s5oIA1SC7Gyxrs8_EnDq-NdLdod4vKgyrA', 1573060008),
(2742, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1NzMwNjQyNzgsImV4cCI6MTU3MzA2NjA3OCwicGVybWlzc2lvbiI6IiJ9.5Qd1ngEe3niB6KcnXdiSvX34zs2oT0MwWPoWhX-U4oI', 1573066078),
(2748, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1NzMwNjk0MzMsImV4cCI6MTU3MzA3MTIzMywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.We9wBhq5PFoQTjSLgq9qBSUF0YSu0CklbbGbzlXOMI4', 1573071233),
(2754, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTczMDg3MDQ0LCJleHAiOjE1NzMwODg4NDQsInBlcm1pc3Npb24iOiIifQ._l2_3JtERPvPeWEoxdqjATlzkFHtpm9QcXXi_-GfHj8', 1573088844),
(2757, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTczMDg4MDc2LCJleHAiOjE1NzMwODk4NzYsInBlcm1pc3Npb24iOiIifQ.iFfAWZQFJjpEj-2eehYU2HZGGW2zIIIPntQtT4OiQ7I', 1573089876),
(2763, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MzEyMjcyOSwiZXhwIjoxNTczMTI0NTI5LCJwZXJtaXNzaW9uIjoiIn0.1uheLaTwhycW11ATAB8zk3lgj1ymWwsaq4G0-euQ2XE', 1573124529),
(2769, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTczMTI3NTc3LCJleHAiOjE1NzMxMjkzNzcsInBlcm1pc3Npb24iOiIifQ.j9_KFv81vvFmBary4YBwsdrLBr2WQoyrfDgS8fgc9Pg', 1573129377),
(2772, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1NzMxMjg4NDgsImV4cCI6MTU3MzEzMDY0OCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.oJvE1EIY-RP94yY4C6ef6sSDtW66Dipg8MQnVZJN1bQ', 1573130648),
(2778, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTczMTM0ODU1LCJleHAiOjE1NzMxMzY2NTUsInBlcm1pc3Npb24iOiIifQ.iFS51HNkLhIpt53m0s1ARdwAobny6ezFyRSUCtwP7rc', 1573136655),
(2784, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU3MzEzODg1NiwiZXhwIjoxNTczMTQwNjU2LCJwZXJtaXNzaW9uIjoiIn0.-oPxw0aSrijUB__ev1YBHehp0SfS7XUCGk_hyoHmnNs', 1573140656),
(2787, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTczMTM5MDIwLCJleHAiOjE1NzMxNDA4MjAsInBlcm1pc3Npb24iOiIifQ.W-54Ra-wz6tFuBrD7zftZg9So1N9P3yD_zkQzL0UYWc', 1573140820),
(2793, 1995, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTk1IiwidXNlcm1haWwiOiJ0b21hc2Nvc3RhQHVhLnB0IiwiaWF0IjoxNTczMTQ3NTcyLCJleHAiOjE1NzMxNDkzNzIsInBlcm1pc3Npb24iOiIifQ.uefJVdAC6-isHv11p_VWblRo5m5alqwaqiMg_GDr1mg', 1573149372),
(2799, 1053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDUzIiwidXNlcm1haWwiOiJjbGF1ZGlvLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTczMTU0NDcwLCJleHAiOjE1NzMxNTYyNzAsInBlcm1pc3Npb24iOiIifQ.jK8nPeYdiW1wZ8PO1_lHtxMqvqAwZGDp7PLLEUT2VX4', 1573156270),
(2802, 2109, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA5IiwidXNlcm1haWwiOiJmaWxpcGVnQHVhLnB0IiwiaWF0IjoxNTczMTU3MzA2LCJleHAiOjE1NzMxNTkxMDYsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.ch3uRH8fv6TnsqEsPA2tLviCzKrRgW7yoUmtwXD-fC8', 1573159106),
(2808, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTczMTYxNjk0LCJleHAiOjE1NzMxNjM0OTQsInBlcm1pc3Npb24iOiIifQ.1Jl-oUZNak73OhSB0eBiTy37mtQygbjBkRAw9zgK14w', 1573163494),
(2811, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzMxNjIyOTMsImV4cCI6MTU3MzE2NDA5MywicGVybWlzc2lvbiI6IiJ9.iBZwthAYkX5z_BBrq0r53fWGH_fx32QGnI0bSbHw714', 1573164093),
(2814, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTczMTYzMzYyLCJleHAiOjE1NzMxNjUxNjIsInBlcm1pc3Npb24iOiIifQ.MUS_9rK9rEhyap8tmFfSCxXZDRWXhCSwUuXtLN_ltmI', 1573165162),
(2817, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzMxNjMzNzQsImV4cCI6MTU3MzE2NTE3NCwicGVybWlzc2lvbiI6IiJ9.-1uFHTnRKmH4EZfA6srnhgHRUKiGKD8xoCZbn57d3DU', 1573165174),
(2820, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTczMTY1NzQ3LCJleHAiOjE1NzMxNjc1NDcsInBlcm1pc3Npb24iOiIifQ.jFFwWaOB2thEnzsyz-yLqTo9B3lUBYPgJA-JY_F342k', 1573167547),
(2823, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU3MzE2NzYwOCwiZXhwIjoxNTczMTY5NDA4LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.G9seEM0DVFNAF_RrD2O5tpEWefqvzR8d-hICs7Qeioc', 1573169408),
(2826, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzMxNjg4NjYsImV4cCI6MTU3MzE3MDY2NiwicGVybWlzc2lvbiI6IiJ9.XNCbh6uvu5Y6LWocBZO3ayt8lpJQuHahdEzMPke_K1w', 1573170666),
(2829, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3MzE2OTQwNiwiZXhwIjoxNTczMTcxMjA2LCJwZXJtaXNzaW9uIjoiIn0.y_4-3kXlTJ6NcipxHJ2zZTfhOHdPqtlC3SRTE1eTZgE', 1573171206),
(2832, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzMxNjk0MTksImV4cCI6MTU3MzE3MTIxOSwicGVybWlzc2lvbiI6IiJ9.sqj-xZtXtEoi2M2SOSyvzRdEa_2Ds2Ut4ahE3aYfftU', 1573171219),
(2838, 945, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NDUiLCJ1c2VybWFpbCI6ImFudG9uaW9qb3JnZWZlcm5hbmRlc0B1YS5wdCIsImlhdCI6MTU3MzE3OTY0OSwiZXhwIjoxNTczMTgxNDQ5LCJwZXJtaXNzaW9uIjoiIn0.-Q3GDFWWVuBBf_J9Ir2frTfefex59w8jSRmsPKRXaHY', 1573181449),
(2844, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTczMjA0NDUxLCJleHAiOjE1NzMyMDYyNTEsInBlcm1pc3Npb24iOiIifQ.fG__wtW2RdnKIvrkHdAohmgREx-YOGeSV4tMPcEh0MU', 1573206251),
(2850, 1512, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTEyIiwidXNlcm1haWwiOiJqcnNybUB1YS5wdCIsImlhdCI6MTU3MzIwNjUwMiwiZXhwIjoxNTczMjA4MzAyLCJwZXJtaXNzaW9uIjoiIn0.TfsolXX6lNFoTqG4g_3VAtLlENSiP6tOJZa4q9iviXk', 1573208302),
(2856, 945, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NDUiLCJ1c2VybWFpbCI6ImFudG9uaW9qb3JnZWZlcm5hbmRlc0B1YS5wdCIsImlhdCI6MTU3MzIxMTk2NSwiZXhwIjoxNTczMjEzNzY1LCJwZXJtaXNzaW9uIjoiIn0.DwFSagjaHWaMl8NiXJ939LIY6oagTJZ0_m9fqfWuq8E', 1573213765),
(2859, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1NzMyMTM3NjQsImV4cCI6MTU3MzIxNTU2NCwicGVybWlzc2lvbiI6IiJ9.MZHrvrUFVG9zhCbvvlE-RWM6DMO9vlFuENZWkyf46TY', 1573215564),
(2862, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1NzMyMTQ2MzgsImV4cCI6MTU3MzIxNjQzOCwicGVybWlzc2lvbiI6IiJ9.mCbmXXMWDhmmrokerKNvrSvLcwyYmSGaplP3ti5TgFY', 1573216438),
(2868, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTczMjIzMDQ3LCJleHAiOjE1NzMyMjQ4NDcsInBlcm1pc3Npb24iOiIifQ.TnIrzwmWpCtfX1WM8JwXGOuIrREe3IWpBAMUYA3SpTI', 1573224847),
(2874, 2040, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQwIiwidXNlcm1haWwiOiJmYWJpby5tQHVhLnB0IiwiaWF0IjoxNTczMjI5MDQwLCJleHAiOjE1NzMyMzA4NDAsInBlcm1pc3Npb24iOiIifQ.yy4YZl1Xi6zS7eDax5sW6mO3aQaC6bwGsyp08D-He1c', 1573230840),
(2880, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1NzMyMzY0MjgsImV4cCI6MTU3MzIzODIyOCwicGVybWlzc2lvbiI6IiJ9.inisET6D8dcM-YXxzPQqYp0HBto0SfVAZNlbV9HahV0', 1573238228),
(2886, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1NzMyNDAzNzksImV4cCI6MTU3MzI0MjE3OSwicGVybWlzc2lvbiI6IiJ9.b_z7NpLkhWuHSC7VPAOnu6YWq24n5VJAGKu7tPhP2mY', 1573242179),
(2892, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzMyNDM4OTMsImV4cCI6MTU3MzI0NTY5MywicGVybWlzc2lvbiI6IiJ9.sdNePrH8Dzg-3YuvzViS-gZV6UMUCgxXxY9Ne993Pgw', 1573245693),
(2901, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU3MzI1MzI2NywiZXhwIjoxNTczMjU1MDY3LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.sBUzmwIfasEa4Iog9Yry8F8V5ZAT66O6bhbYBK8_Rwo', 1573255067),
(2904, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU3MzI1Mzc1MywiZXhwIjoxNTczMjU1NTUzLCJwZXJtaXNzaW9uIjoiIn0.1jXngTHF3RvPYxyhUSQ7YASncClxxrpmgoIPoiyOuwc', 1573255553),
(2910, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzMyNTk4OTMsImV4cCI6MTU3MzI2MTY5MywicGVybWlzc2lvbiI6IiJ9.0XoQUQgteITq_MZDBXlBSf-CK3ySUEpvekuthbLueJc', 1573261693),
(2916, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTczMjk5MDkyLCJleHAiOjE1NzMzMDA4OTIsInBlcm1pc3Npb24iOiIifQ.mZzdaEYRmQWhdF38QdLO2IQdFQzqoBJtgSf5IrcHC2E', 1573300892),
(2922, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTczMzA1NDYxLCJleHAiOjE1NzMzMDcyNjEsInBlcm1pc3Npb24iOiIifQ.BztuuNbMbIFImRYDjYKhW-4r4f4gIB5YgpSvZ4Xws2U', 1573307261),
(2925, 2040, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQwIiwidXNlcm1haWwiOiJmYWJpby5tQHVhLnB0IiwiaWF0IjoxNTczMzA5MTI3LCJleHAiOjE1NzMzMTA5MjcsInBlcm1pc3Npb24iOiIifQ.i4Uw7qqS3QcAqT_pfo0MxrK8ta6WHPyiBGd7eBTVgU8', 1573310927),
(2931, 1026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDI2IiwidXNlcm1haWwiOiJjYXJvbGluYXJlc2VuZGVtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTczMzIwMjY3LCJleHAiOjE1NzMzMjIwNjcsInBlcm1pc3Npb24iOiIifQ.tQWaUqAkRPdhEXVfKEy9T1R0c7281Ii8VSBWPzT8dRw', 1573322067),
(2937, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1NzMzMjY3NDksImV4cCI6MTU3MzMyODU0OSwicGVybWlzc2lvbiI6IiJ9.du5M0c3hW44BwUEDFJeL470_7vdvffutTlFQ8LgtH3w', 1573328549),
(2943, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTczMzMzOTg0LCJleHAiOjE1NzMzMzU3ODQsInBlcm1pc3Npb24iOiIifQ.nZNDATzP-HKFHdqtYxeVM40p_PGvAnE0KctkeySPvRw', 1573335784),
(2949, 1548, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTQ4IiwidXNlcm1haWwiOiJsdWlzZmdic0B1YS5wdCIsImlhdCI6MTU3MzM0Mzk2NCwiZXhwIjoxNTczMzQ1NzY0LCJwZXJtaXNzaW9uIjoiIn0.EZnPOsZ_W4QuGiAoABSbvIm1KZE8ZhEb-LRUNWHPvCI', 1573345764),
(2951, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTczMzg0ODU4LCJleHAiOjE1NzMzODY2NTgsInBlcm1pc3Npb24iOiIifQ.ztcVWmhfzUJMrSOfJGufGtL9sKb-8GyaKueBNZlLY68', 1573386658),
(2953, 1344, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQ0IiwidXNlcm1haWwiOiJpbmVzLnNlYWJyYXJvY2hhQHVhLnB0IiwiaWF0IjoxNTczMzg1OTgyLCJleHAiOjE1NzMzODc3ODIsInBlcm1pc3Npb24iOiIifQ.q8_tkbVUfTbv0-o7bFbC6o3YLJ3_mt0fVP6bRlmTCEk', 1573387782),
(2955, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1NzMzODcyMzcsImV4cCI6MTU3MzM4OTAzNywicGVybWlzc2lvbiI6IiJ9.D_eIvVqTyErvrQoxLLn45hs0_ukyjKlTvGOFzHt3ZVc', 1573389037),
(2959, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTczMzk2ODY3LCJleHAiOjE1NzMzOTg2NjcsInBlcm1pc3Npb24iOiIifQ.9_qKchc7dVyM5K6qUFHXPQhMJiOUOdn5FtcBSFtnVTc', 1573398667),
(2961, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1NzMzOTgwMTMsImV4cCI6MTU3MzM5OTgxMywicGVybWlzc2lvbiI6IiJ9.mZoK6BHRJ3VUxKn10hBWCPO5Zm52ek_0e-ghGHsvmeQ', 1573399813),
(2965, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3MzQwOTE2NCwiZXhwIjoxNTczNDEwOTY0LCJwZXJtaXNzaW9uIjoiIn0.StTuyYARgFyVbau5XnInwqTv_cpOXFP_I9Q0jtzMprQ', 1573410964),
(2967, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3MzQwOTE3NCwiZXhwIjoxNTczNDEwOTc0LCJwZXJtaXNzaW9uIjoiIn0.--xYH5cxZEi3VI-q0x3PuOnbq4jY-1QbADEExNHaGcw', 1573410974),
(2969, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1NzM0MTAwMjQsImV4cCI6MTU3MzQxMTgyNCwicGVybWlzc2lvbiI6IiJ9.UvbM32n6UHdv_cuytiJIoUrlLmeNSy7drPifnpuhuyU', 1573411824),
(2971, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzM0MTAxOTgsImV4cCI6MTU3MzQxMTk5OCwicGVybWlzc2lvbiI6IiJ9._F1hqc_rNU53Oz4VqSdgYaXhk-_YwEXiCGSKgvaTO34', 1573411998),
(2973, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzM0MTA5ODcsImV4cCI6MTU3MzQxMjc4NywicGVybWlzc2lvbiI6IiJ9.xJRhWgB39XcUaUjfvbVJakS7WYcl15oAts6CQj5dCMk', 1573412787),
(2975, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTczNDExOTUwLCJleHAiOjE1NzM0MTM3NTAsInBlcm1pc3Npb24iOiIifQ.XvL4z0PEw9K-ASnqHPvJm4o3OwmQNCgKv1bMStGQcoE', 1573413750),
(2977, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzM0MTI3NTMsImV4cCI6MTU3MzQxNDU1MywicGVybWlzc2lvbiI6IiJ9.N-A279BgdZ1LBUN4LEAo6tLTLcfbSyou2GyMOjX6aTs', 1573414553),
(2981, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTczNDE3NTA0LCJleHAiOjE1NzM0MTkzMDQsInBlcm1pc3Npb24iOiIifQ.Z7gtIufCGGk-bzmqlorg7uGPR53HsD-i-qCZz3SjV5Q', 1573419304),
(2985, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzM0MjMwMDQsImV4cCI6MTU3MzQyNDgwNCwicGVybWlzc2lvbiI6IiJ9.p017KUseUsFA-tSZbaj3IWQAsFRwSoqaBvQDKxwtlQk', 1573424804),
(2989, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1NzM0Njc5MjgsImV4cCI6MTU3MzQ2OTcyOCwicGVybWlzc2lvbiI6IiJ9.zJfHvzwa7Wh-VkcEaQqV7grf-UjzSzbECq2cD4Hx59E', 1573469728),
(2993, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3MzQ3MjExMywiZXhwIjoxNTczNDczOTEzLCJwZXJtaXNzaW9uIjoiIn0.q8rtq6Pj59_myHvcu1vSpDSYpqM0qAGdCd8GjAyytQg', 1573473913),
(2997, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3MzQ3NzcxMywiZXhwIjoxNTczNDc5NTEzLCJwZXJtaXNzaW9uIjoiIn0.zvT0dXP5yL9pnieUAEKdsW0-a6L7qsWUQFO6e3NfvLM', 1573479513),
(3001, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzM0ODE5MDcsImV4cCI6MTU3MzQ4MzcwNywicGVybWlzc2lvbiI6IiJ9.8NEwxfUBzsyxi0E2ROERo8NcBatrVuCkUMjWCsxQ4mg', 1573483707),
(3003, 1734, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzM0IiwidXNlcm1haWwiOiJwZWRyb2Fnb25jYWx2ZXNtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTczNDgzMTQzLCJleHAiOjE1NzM0ODQ5NDMsInBlcm1pc3Npb24iOiIifQ.XyXmL24jG6gb_QQfOsnv0oISCKwdCr_UAFIJAuQBf0c', 1573484943),
(3007, 1173, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTczIiwidXNlcm1haWwiOiJkbWF0aWFzcGludG9AdWEucHQiLCJpYXQiOjE1NzM0OTQ2NjIsImV4cCI6MTU3MzQ5NjQ2MiwicGVybWlzc2lvbiI6IiJ9.PflclYPIPbFzjC4GMnNPabdx9pgS0_gT4awAGQuTKzw', 1573496462),
(3011, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU3MzUwMDQxNCwiZXhwIjoxNTczNTAyMjE0LCJwZXJtaXNzaW9uIjoiIn0.FvBVQoOkuFxSC8UuB17PB8lhIi0VPU-lbI_ANgk2NWs', 1573502214),
(3015, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTczNTA2MTEzLCJleHAiOjE1NzM1MDc5MTMsInBlcm1pc3Npb24iOiIifQ.7UHY1BN8Gbi6pfMhvDWSPHLjEJLNW16ASTldk4z5jNc', 1573507913),
(3017, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTczNTA3ODU5LCJleHAiOjE1NzM1MDk2NTksInBlcm1pc3Npb24iOiIifQ.1CJuEU_gdx9pzh5VdNrpgVODbSZy-W7zqAr-AcSvzR8', 1573509659),
(3021, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1NzM1MTIzMjksImV4cCI6MTU3MzUxNDEyOSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.a0kZgaSXqso6quc6nzj-abXXoCW8bq0vGvfi_Vtg4Ok', 1573514129),
(3023, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzM1MTI0NjUsImV4cCI6MTU3MzUxNDI2NSwicGVybWlzc2lvbiI6IiJ9.S_-E3FEnFUoaoUGf2OjogcyCz7q2_MVtC1aWEyFrYRc', 1573514265),
(3027, 1479, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDc5IiwidXNlcm1haWwiOiJqb3NlbG1kYnNvdXNhQHVhLnB0IiwiaWF0IjoxNTczNTU2MzMwLCJleHAiOjE1NzM1NTgxMzAsInBlcm1pc3Npb24iOiIifQ.Wu9vVSvUqkZ1om8YJznDsAWOuS5MDzWjL8Pag66OQp8', 1573558130),
(3031, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzM1NjA4MTUsImV4cCI6MTU3MzU2MjYxNSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.YZB0xO-oCiCBuV5QoZa1_bJ7OBTxt18-jqzIKS4WA_Y', 1573562615),
(3033, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTczNTYyNzMxLCJleHAiOjE1NzM1NjQ1MzEsInBlcm1pc3Npb24iOiIifQ.7uhAlS_H7DdLrHaJQFhvSIdnuX9lxWJgLGQe2RGg1bM', 1573564531),
(3037, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTczNTY5Mzk2LCJleHAiOjE1NzM1NzExOTYsInBlcm1pc3Npb24iOiIifQ.5oINRl2QtoYR2Vf5KBy4xGIhhMbFtv34jhp_45p6Oms', 1573571196),
(3039, 1722, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzIyIiwidXNlcm1haWwiOiJwZWRyby5taWd1ZWw1MEB1YS5wdCIsImlhdCI6MTU3MzU2OTQ2MywiZXhwIjoxNTczNTcxMjYzLCJwZXJtaXNzaW9uIjoiIn0.cC-oAWU1Bv9QS-tQNCNMuHvVQsmlhnaWXxpmd9gfqvA', 1573571263),
(3041, 1722, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzIyIiwidXNlcm1haWwiOiJwZWRyby5taWd1ZWw1MEB1YS5wdCIsImlhdCI6MTU3MzU2OTUzMSwiZXhwIjoxNTczNTcxMzMxLCJwZXJtaXNzaW9uIjoiIn0.kDRIJU1uhIaVjdi0tlPY-hVrcYiNaBMncFbLHQs6eAM', 1573571331),
(3043, 1734, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzM0IiwidXNlcm1haWwiOiJwZWRyb2Fnb25jYWx2ZXNtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTczNTcxODIwLCJleHAiOjE1NzM1NzM2MjAsInBlcm1pc3Npb24iOiIifQ.FE8uu9V6rpo_clfCJnKOAYLI3G6UgN7eK1lBHn5qUIg', 1573573620),
(3047, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTczNTg0MjgyLCJleHAiOjE1NzM1ODYwODIsInBlcm1pc3Npb24iOiIifQ.fyG86KVB5uSsXGaYHQbtv95_irD_eMP90LaWbKSfoTU', 1573586082),
(3051, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1NzM1ODc5NDUsImV4cCI6MTU3MzU4OTc0NSwicGVybWlzc2lvbiI6IiJ9.VLdBG-S-39PZMlFDs5bI8z8QawfrgU0lMhZaQY7FPlo', 1573589745),
(3055, 1938, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTM4IiwidXNlcm1haWwiOiJzb2ZpYW1vbml6QHVhLnB0IiwiaWF0IjoxNTczNTk2NTYyLCJleHAiOjE1NzM1OTgzNjIsInBlcm1pc3Npb24iOiIifQ.EZD0AnQYg8V57YxbXK1HPPYli5DvrpPJRHxiJzFMDoM', 1573598362),
(3057, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTczNTk4NDYyLCJleHAiOjE1NzM2MDAyNjIsInBlcm1pc3Npb24iOiIifQ.-qditsL301aVQ1c2w7ZTSjPTGbBhPRysFbmAWa409rc', 1573600262),
(3059, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTczNTk4ODMzLCJleHAiOjE1NzM2MDA2MzMsInBlcm1pc3Npb24iOiIifQ.lBqLLe0AVd0X95BxuI1TJb3V6XPqgKuZmIJ8tWvFou8', 1573600633),
(3063, 2047, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ3IiwidXNlcm1haWwiOiJqb2FvcmVpczE2QHVhLnB0IiwiaWF0IjoxNTczNjA1NjU1LCJleHAiOjE1NzM2MDc0NTUsInBlcm1pc3Npb24iOiIifQ.LZ6T2ZSimEnFtubU6o9BBk_-9M6HkokGQ25m_Zzjya4', 1573607455),
(3065, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3MzYwNzI3OSwiZXhwIjoxNTczNjA5MDc5LCJwZXJtaXNzaW9uIjoiIn0.r-MZug6pF6DOfnxnVlWchAT6qW-GzJg-szYIAcbYids', 1573609079),
(3069, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU3MzY0NDY2MywiZXhwIjoxNTczNjQ2NDYzLCJwZXJtaXNzaW9uIjoiIn0.9vTj_AEnTm8PjtgdXUKLZXYqmlLLBaMMDiL7PdF_6kQ', 1573646463),
(3073, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTczNjQ2MTEyLCJleHAiOjE1NzM2NDc5MTIsInBlcm1pc3Npb24iOiIifQ.sAPLE9VFaLhl-22TYoMLy2Sj6X13kn3lvoB1CnKa-CQ', 1573647912),
(3075, 1173, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTczIiwidXNlcm1haWwiOiJkbWF0aWFzcGludG9AdWEucHQiLCJpYXQiOjE1NzM2NDc3NjMsImV4cCI6MTU3MzY0OTU2MywicGVybWlzc2lvbiI6IiJ9.P3ey0BobwO6Ev3YR1tcNS0ZLt7BpAvSE0PME6FTC1Lw', 1573649563),
(3077, 2047, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ3IiwidXNlcm1haWwiOiJqb2FvcmVpczE2QHVhLnB0IiwiaWF0IjoxNTczNjQ4NzIwLCJleHAiOjE1NzM2NTA1MjAsInBlcm1pc3Npb24iOiIifQ.r0Fu-sVun1TVHcnwGynDsluO3Iz2xGv5kbFpR7ptgxQ', 1573650520),
(3081, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1NzM2NTMzNjMsImV4cCI6MTU3MzY1NTE2MywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.G7QfEJUgIpeElcz8WkDE4Un6dxW6h3Ig8P0K7ghe5gA', 1573655163),
(3083, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU3MzY1NDE4NCwiZXhwIjoxNTczNjU1OTg0LCJwZXJtaXNzaW9uIjoiIn0.pFDqo5XSoVjQ5fS1L9InP_RqIdg98fJwJogA5HAgKfU', 1573655984),
(3093, 1173, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTczIiwidXNlcm1haWwiOiJkbWF0aWFzcGludG9AdWEucHQiLCJpYXQiOjE1NzM2NTc2OTAsImV4cCI6MTU3MzY1OTQ5MCwicGVybWlzc2lvbiI6IiJ9.95DTLkNZdIG-LpC9klu2d-J1qlHoly1HJB1QwIJ8ogw', 1573659490),
(3095, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTczNjU4MTcxLCJleHAiOjE1NzM2NTk5NzEsInBlcm1pc3Npb24iOiIifQ.lkNDnRA9XiAhKiYb6b_88TE9DSridG-WadFQ5OVDvNw', 1573659971),
(3099, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3MzY2Mjg3OCwiZXhwIjoxNTczNjY0Njc4LCJwZXJtaXNzaW9uIjoiIn0.RuXfUJKIR8Tiqki3FLuA0uFrjR4JZM0_XvJGRCQ7Prs', 1573664678),
(3101, 2057, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU3IiwidXNlcm1haWwiOiJwbWQ4QHVhLnB0IiwiaWF0IjoxNTczNjYzNzQxLCJleHAiOjE1NzM2NjU1NDEsInBlcm1pc3Npb24iOiIifQ.HyG2DUsek53s5zRIsK5-jl5R4e1XyIkHUnoxGQGBndU', 1573665541),
(3105, 1389, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzg5IiwidXNlcm1haWwiOiJqb2FvLmxhcmFuam9AdWEucHQiLCJpYXQiOjE1NzM2NzU0ODcsImV4cCI6MTU3MzY3NzI4NywicGVybWlzc2lvbiI6IiJ9.YZ0VbcsUlVOZdnFIc2Sf9yOf8XZINxMA32R3JVAPkMs', 1573677287),
(3109, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1NzM2Nzk2OTksImV4cCI6MTU3MzY4MTQ5OSwicGVybWlzc2lvbiI6IiJ9.uO_8JWr6W_l_eJ_3y9nZInWnY7_vxAfqVUDHkP8htkM', 1573681499),
(3113, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzM2ODM5MDksImV4cCI6MTU3MzY4NTcwOSwicGVybWlzc2lvbiI6IiJ9.SkU4RFzOo4UYgTW8v4EfagtcayPJSmJuBFTEZLFGGco', 1573685709),
(3117, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTczNjg2OTQ5LCJleHAiOjE1NzM2ODg3NDksInBlcm1pc3Npb24iOiIifQ.eJlqEZlS4XunCbj1LV65a_FGTUCgXkOO8CwB7QLpWCg', 1573688749),
(3121, 993, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTMiLCJ1c2VybWFpbCI6ImJydW5vc2JAdWEucHQiLCJpYXQiOjE1NzM3MjM5MjMsImV4cCI6MTU3MzcyNTcyMywicGVybWlzc2lvbiI6IiJ9.oY31jYiiwxiGfnCl6bP5wiTCiVhoRyY8WzRjk50bMQM', 1573725723),
(3125, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTczNzMzNTg4LCJleHAiOjE1NzM3MzUzODgsInBlcm1pc3Npb24iOiIifQ.P62u6_5n4wz1XdKVZ4gS7Th4qRwaKHUXGnccfzSjhlw', 1573735388),
(3129, 945, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NDUiLCJ1c2VybWFpbCI6ImFudG9uaW9qb3JnZWZlcm5hbmRlc0B1YS5wdCIsImlhdCI6MTU3Mzc0MjM0NSwiZXhwIjoxNTczNzQ0MTQ1LCJwZXJtaXNzaW9uIjoiIn0.zsSPWbkSGn2Hte0laIr_s_LhSYrgwg0nRW6gtR6RYAw', 1573744145),
(3133, 1368, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzY4IiwidXNlcm1haWwiOiJqY3BzQHVhLnB0IiwiaWF0IjoxNTczNzQ3Mzk5LCJleHAiOjE1NzM3NDkxOTksInBlcm1pc3Npb24iOiIifQ.flns1Hm9PNfmBjlBjTmpqyfaCRsC0sLqRjlkYMZXeNk', 1573749199),
(3135, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1NzM3NDc2NDEsImV4cCI6MTU3Mzc0OTQ0MSwicGVybWlzc2lvbiI6IiJ9.bfrfa8-_YLlPAB_raYZi7AIOi7oClf2-QC_wd7PgrNg', 1573749441),
(3139, 1767, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzY3IiwidXNlcm1haWwiOiJwZXJlaXJhLmdvbmNhbG9AdWEucHQiLCJpYXQiOjE1NzM3NTcxMDAsImV4cCI6MTU3Mzc1ODkwMCwicGVybWlzc2lvbiI6IiJ9.n3MHQ5oI4qfbEdesimSPwbiZnNeZdAQ_J_DZiousvHM', 1573758900),
(3141, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3Mzc1NzUxOSwiZXhwIjoxNTczNzU5MzE5LCJwZXJtaXNzaW9uIjoiIn0.B-Vru_dRPFPVWVckEzUU9DhZLbpwAsvnn08J2THuZ3c', 1573759319),
(3145, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTczNzYwOTk1LCJleHAiOjE1NzM3NjI3OTUsInBlcm1pc3Npb24iOiIifQ.07HEfqrIobhijKwQx0Fy4EvntXS8RTsoILBX11VJgNI', 1573762795),
(3147, 1368, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzY4IiwidXNlcm1haWwiOiJqY3BzQHVhLnB0IiwiaWF0IjoxNTczNzYxMzc0LCJleHAiOjE1NzM3NjMxNzQsInBlcm1pc3Npb24iOiIifQ.xDnOnGk_VP9NedepLKztBgizHZItG4_DMJmzPnFzxUw', 1573763174),
(3151, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzM3Njc0OTIsImV4cCI6MTU3Mzc2OTI5MiwicGVybWlzc2lvbiI6IiJ9.fDuNJvG76q1r0maHFWwML3i-czdaswbisF2mYcybkdo', 1573769292),
(3153, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU3Mzc2OTI1OSwiZXhwIjoxNTczNzcxMDU5LCJwZXJtaXNzaW9uIjoiIn0.LqrEb6rxeEBJLB7F78jbrOvAI9K3ihchg4Ut6eiUj-0', 1573771059),
(3157, 1368, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzY4IiwidXNlcm1haWwiOiJqY3BzQHVhLnB0IiwiaWF0IjoxNTczODE0MDQ3LCJleHAiOjE1NzM4MTU4NDcsInBlcm1pc3Npb24iOiIifQ.zkeuB4aAGCPXzkDrE7aLTbcTWgoc2WlffMLlRe63vsk', 1573815847),
(3159, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzM4MTU3MzAsImV4cCI6MTU3MzgxNzUzMCwicGVybWlzc2lvbiI6IiJ9.s1kxpPGB8vNtSEgIemlJeiyza70nnHIMO5qNRbIDqf8', 1573817530),
(3161, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzM4MTYzNDEsImV4cCI6MTU3MzgxODE0MSwicGVybWlzc2lvbiI6IiJ9.m2dr94pM2YeB7SevnRw7CS7X0WJXsYOBCeU62bAUIYA', 1573818141),
(3163, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU3MzgxODEyMywiZXhwIjoxNTczODE5OTIzLCJwZXJtaXNzaW9uIjoiIn0.DRR_n69-ePN9s7NWqzOANmcEe9e01zNAS_BSbUpE8d8', 1573819923),
(3165, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1NzM4MTg0MzUsImV4cCI6MTU3MzgyMDIzNSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.eP_VWK296nBpZD6TwDy5nW8L2zY7_Lu7AJR509TN_SM', 1573820235),
(3167, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzM4MTg0NTcsImV4cCI6MTU3MzgyMDI1NywicGVybWlzc2lvbiI6IiJ9.lttGWReIQqnXXnx82j9VaUAtebBh9F_6uK_Mo4MtNHM', 1573820257),
(3169, 1368, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzY4IiwidXNlcm1haWwiOiJqY3BzQHVhLnB0IiwiaWF0IjoxNTczODE5MDUyLCJleHAiOjE1NzM4MjA4NTIsInBlcm1pc3Npb24iOiIifQ.ZoO2jsW9w4FCs_REaee4e_zJOyKKaisZ5_OhIEVSaoc', 1573820852),
(3171, 1356, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU2IiwidXNlcm1haWwiOiJpdm9hbmdlbGljb0B1YS5wdCIsImlhdCI6MTU3MzgxOTMzNSwiZXhwIjoxNTczODIxMTM1LCJwZXJtaXNzaW9uIjoiIn0.QOhZEgCKSe5qBOknd7Y6dDIswDnn_SQQQyRvgKHU4DY', 1573821135),
(3175, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzM4MjI1MjIsImV4cCI6MTU3MzgyNDMyMiwicGVybWlzc2lvbiI6IiJ9.ioB1RLUktx1wqv55KIEgH4Dkov9LO0yC4Md-Lh99zVI', 1573824322),
(3179, 1956, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTU2IiwidXNlcm1haWwiOiJ0aWFnby5zcnYub2xpdmVpcmFAdWEucHQiLCJpYXQiOjE1NzM4MzAwNzMsImV4cCI6MTU3MzgzMTg3MywicGVybWlzc2lvbiI6IiJ9.0vPzq2WwzZiiduQoYmEcEYIUQTiQDgIWJEEGvsNiG8w', 1573831873),
(3183, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzM4MzUxMTIsImV4cCI6MTU3MzgzNjkxMiwicGVybWlzc2lvbiI6IiJ9.8IIM2NbJJfxKy_kvuSlkZGD9rfSQk9-CO116QyU-ZXQ', 1573836912),
(3185, 2080, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDgwIiwidXNlcm1haWwiOiJicmFpc0B1YS5wdCIsImlhdCI6MTU3MzgzNTc5MCwiZXhwIjoxNTczODM3NTkwLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.b0C4zt56WILk1CSs7VLMChS0l-GKbbvZE0l0bXEkaaA', 1573837590),
(3187, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1NzM4Mzg5MTUsImV4cCI6MTU3Mzg0MDcxNSwicGVybWlzc2lvbiI6IiJ9.N3BDMBjmMtu7MlGw3Ga7Lm55ef_CESbjUeiVLtpPnvI', 1573840715),
(3189, 2061, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYxIiwidXNlcm1haWwiOiJwZGZsQHVhLnB0IiwiaWF0IjoxNTczODM5NTE5LCJleHAiOjE1NzM4NDEzMTksInBlcm1pc3Npb24iOiIifQ.p7hmfIoNsalTcIFTic388b0-CQcF_RrDT3GDzQS6_dA', 1573841319),
(3193, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTczODQyODk0LCJleHAiOjE1NzM4NDQ2OTQsInBlcm1pc3Npb24iOiIifQ.V5Kb4Vn7oxu12JGnYqP8CIAYPMk6VrGpMqmNQt5GO0U', 1573844694),
(3197, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3Mzg1MjU5NSwiZXhwIjoxNTczODU0Mzk1LCJwZXJtaXNzaW9uIjoiIn0.DRe_X0JuPT7ol3CSvsW7pqEkaLlnv0vnql00ruuRSrk', 1573854395),
(3201, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTczODU4NTc5LCJleHAiOjE1NzM4NjAzNzksInBlcm1pc3Npb24iOiIifQ.tKNwQ-PCS-C3rdL6ff0En50xH5_BV_o8FGdnmbkxG5U', 1573860379),
(3203, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU3Mzg1ODU4NSwiZXhwIjoxNTczODYwMzg1LCJwZXJtaXNzaW9uIjoiIn0.l6UmX1QG8MUK3EWr1rF6RaL70WnmzsbAdk5WuRubw_w', 1573860385),
(3207, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzM5MDgxODQsImV4cCI6MTU3MzkwOTk4NCwicGVybWlzc2lvbiI6IiJ9.Vbbs3ZDHkNvovn_XExcNLOJJmRfQ3HVhG-_s4A79UF8', 1573909984),
(3211, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzM5MTUyNDIsImV4cCI6MTU3MzkxNzA0MiwicGVybWlzc2lvbiI6IiJ9.sSJ7foSL61j6pd2G9cCrpZlmZJUvRvUcQGaFz41-tRg', 1573917042),
(3213, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3MzkxNjY5MywiZXhwIjoxNTczOTE4NDkzLCJwZXJtaXNzaW9uIjoiIn0.xHkYU9C6EmPkQN6lY41eWLJkJ4d7I0BQ8CKT4FlrlT8', 1573918493),
(3217, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTczOTIxNjcwLCJleHAiOjE1NzM5MjM0NzAsInBlcm1pc3Npb24iOiIifQ.vuRBGhCP-EIUTjzru9v-BWwfpGPsQE-fphGbVejGMTE', 1573923470),
(3219, 933, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MzMiLCJ1c2VybWFpbCI6ImFudGhvbnlwZXJlaXJhQHVhLnB0IiwiaWF0IjoxNTczOTIzNDk1LCJleHAiOjE1NzM5MjUyOTUsInBlcm1pc3Npb24iOiIifQ.MEGBbscSriFEepYSSVWwpCy3aFWWdlQtPBWHfyj28jM', 1573925295),
(3223, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTczOTI4NTYzLCJleHAiOjE1NzM5MzAzNjMsInBlcm1pc3Npb24iOiIifQ.__pY90JzO_kzkr88be3iq-ifT6svE8xByWtN21SwOvM', 1573930363),
(3225, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzM5Mjg2ODgsImV4cCI6MTU3MzkzMDQ4OCwicGVybWlzc2lvbiI6IiJ9.G_bpIsoJC7vffqJfkpaPJAPYHsSJBFRtqlOXurMdS70', 1573930488),
(3227, 1521, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTIxIiwidXNlcm1haWwiOiJsZWFuZHJvc2lsdmExMkB1YS5wdCIsImlhdCI6MTU3MzkzMTY4OSwiZXhwIjoxNTczOTMzNDg5LCJwZXJtaXNzaW9uIjoiIn0.ihFq5i6A7l_YwY_SWuY4-RoUeYNtGMIYyPDJOnsy7lg', 1573933489),
(3229, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTczOTM0NDU1LCJleHAiOjE1NzM5MzYyNTUsInBlcm1pc3Npb24iOiIifQ.glzYALPF_4ZCkGnbDh4VngfU3swiH8pIr3XaQNLi6iA', 1573936255),
(3233, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3MzkzODYxMCwiZXhwIjoxNTczOTQwNDEwLCJwZXJtaXNzaW9uIjoiIn0.7rbywKzwYq6hd4BvPRVae6i6GH9mPncOc_yk1pG7Trc', 1573940410),
(3237, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTczOTQxNjEyLCJleHAiOjE1NzM5NDM0MTIsInBlcm1pc3Npb24iOiIifQ.EBxNeKJVU_0g3zb-8AUgXhze2XwUOxmdHIluBCDYRsY', 1573943412),
(3239, 1521, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTIxIiwidXNlcm1haWwiOiJsZWFuZHJvc2lsdmExMkB1YS5wdCIsImlhdCI6MTU3Mzk0NDA2NiwiZXhwIjoxNTczOTQ1ODY2LCJwZXJtaXNzaW9uIjoiIn0.PMOXiCf8RFoaApw4w680E8rgdPGKYNU3b1J4CB6b68s', 1573945866),
(3243, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTczOTc2NjY4LCJleHAiOjE1NzM5Nzg0NjgsInBlcm1pc3Npb24iOiIifQ.r1EROmSq61E-bTnrT8xIUEwEDuCe1mglpWYfvAZYwdU', 1573978468),
(3247, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3Mzk4NjkxNiwiZXhwIjoxNTczOTg4NzE2LCJwZXJtaXNzaW9uIjoiIn0.0p4p4yeeL7u6tgzqhRUsudukYUOgiEZYVnCpmSoFfRs', 1573988716),
(3249, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzM5OTAxNDgsImV4cCI6MTU3Mzk5MTk0OCwicGVybWlzc2lvbiI6IiJ9.BGmCorMkaWGYF0IEO4JQiZqMfuZE42DSPabxcNycISE', 1573991948),
(3251, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3Mzk5MTUyMSwiZXhwIjoxNTczOTkzMzIxLCJwZXJtaXNzaW9uIjoiIn0.XK6LzyxbIvb-hj1mPrxIZqxN4QEvgQ36-uG3kpxydgI', 1573993321),
(3253, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTczOTkyODYwLCJleHAiOjE1NzM5OTQ2NjAsInBlcm1pc3Npb24iOiIifQ.2udfAiTdrjxWdsoDlfYNMAvJ9GNKjpJPphBZ8VJ8i90', 1573994660),
(3255, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTczOTk0Mjk4LCJleHAiOjE1NzM5OTYwOTgsInBlcm1pc3Npb24iOiIifQ.apL5zLcA9EdjqBKva8WJI-QKVsmfkNEdkVmOydIdn_4', 1573996098),
(3259, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3Mzk5ODA4NiwiZXhwIjoxNTczOTk5ODg2LCJwZXJtaXNzaW9uIjoiIn0.Z8NK3VRpNxACNr7Upw5PEN4uPbQ60KLoOTPDLKDX2IQ', 1573999886),
(3263, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTc0MDA2MTE3LCJleHAiOjE1NzQwMDc5MTcsInBlcm1pc3Npb24iOiIifQ.QdEnUOQatyNuxajPoD2WL4JwnVak07og2sKw-CJHmtg', 1574007917),
(3265, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3NDAwNjEzNiwiZXhwIjoxNTc0MDA3OTM2LCJwZXJtaXNzaW9uIjoiIn0.yh6bcaCN41crlnt-pfX2t5AdsOdGUzf8rpudIS5w9FI', 1574007936),
(3267, 1620, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjIwIiwidXNlcm1haWwiOiJtYXJpb3NpbHZhQHVhLnB0IiwiaWF0IjoxNTc0MDA3MDk4LCJleHAiOjE1NzQwMDg4OTgsInBlcm1pc3Npb24iOiIifQ.z7YwckZDgQmtO9vzOYpZYsm14wNimk8UOkGdtG_pTXU', 1574008898),
(3269, 2057, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU3IiwidXNlcm1haWwiOiJwbWQ4QHVhLnB0IiwiaWF0IjoxNTc0MDA4OTc0LCJleHAiOjE1NzQwMTA3NzQsInBlcm1pc3Npb24iOiIifQ.SmK0gpeT1szhdTkejeEPF2N7TWhkiKIcXckr4hcKL8I', 1574010774),
(3273, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3NDAxNjQ0NCwiZXhwIjoxNTc0MDE4MjQ0LCJwZXJtaXNzaW9uIjoiIn0.ZeAiXqAgu38ROyyjZxGlpZ2EivxPXBtjO_rrKM2ePRA', 1574018244),
(3275, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3NDAxNjQ4MywiZXhwIjoxNTc0MDE4MjgzLCJwZXJtaXNzaW9uIjoiIn0.oJlVHBIngnkqA-W7AzDlPlJVkGFSWrCswZO-82hN5S4', 1574018283),
(3279, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU3NDAyMTE1NCwiZXhwIjoxNTc0MDIyOTU0LCJwZXJtaXNzaW9uIjoiIn0.mgiWrVdrSYoDYuqF8Ki2JeXvbWHus7xf5s0xiUw-huU', 1574022954),
(3283, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTc0MDI4OTYxLCJleHAiOjE1NzQwMzA3NjEsInBlcm1pc3Npb24iOiIifQ.HOL-gAoz7gyPEIvepzEXoWD74GZm02NWwkEf2HMrvSc', 1574030761),
(3287, 906, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MDYiLCJ1c2VybWFpbCI6ImFuZHJlLmNhdGFyaW5vQHVhLnB0IiwiaWF0IjoxNTc0MDQzNDg1LCJleHAiOjE1NzQwNDUyODUsInBlcm1pc3Npb24iOiIifQ.BuAikqmF55nNS7gR3ELzDwvlonbdujj3yk4MZFofuyA', 1574045285),
(3291, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTc0MDcwNjc4LCJleHAiOjE1NzQwNzI0NzgsInBlcm1pc3Npb24iOiIifQ.F6l_SvcUC3xa1VvoiCeE8fDzjY2X7qqTDjFosiE9enQ', 1574072478),
(3293, 1620, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjIwIiwidXNlcm1haWwiOiJtYXJpb3NpbHZhQHVhLnB0IiwiaWF0IjoxNTc0MDcyMjM2LCJleHAiOjE1NzQwNzQwMzYsInBlcm1pc3Npb24iOiIifQ._sPo603luHM09_TqWOGCow9Fe9uBUmccY2QQqE58CQY', 1574074036),
(3297, 2106, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA2IiwidXNlcm1haWwiOiJzb3BoaWVwb3VzaW5ob0B1YS5wdCIsImlhdCI6MTU3NDA4NjI2MCwiZXhwIjoxNTc0MDg4MDYwLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.PEScH11tmmAi-4AY1jc2kcZrkzbDEpfIF9BXqI1k51M', 1574088060),
(3299, 2106, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA2IiwidXNlcm1haWwiOiJzb3BoaWVwb3VzaW5ob0B1YS5wdCIsImlhdCI6MTU3NDA4NjQ3NywiZXhwIjoxNTc0MDg4Mjc3LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.tiYiCf7KgKYw27LnbvAXAxEwKE4gF6iQkiLdKpPpBk4', 1574088277),
(3303, 2046, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ2IiwidXNlcm1haWwiOiJpc2FiZWwucm9zYXJpb0B1YS5wdCIsImlhdCI6MTU3NDA4OTc5NSwiZXhwIjoxNTc0MDkxNTk1LCJwZXJtaXNzaW9uIjoiIn0.HAqqkoMJqVcs3a9kLMv_VhULu_tcFlmN8cAK3NIWADs', 1574091595),
(3307, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc0MDkzNzI2LCJleHAiOjE1NzQwOTU1MjYsInBlcm1pc3Npb24iOiIifQ.6vJJxQUYSLj2Dm2SW8moHxv5h4ZeNXD84bCfI2NfMeE', 1574095526),
(3309, 987, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5ODciLCJ1c2VybWFpbCI6ImJydW5vcGludG81MTUxQHVhLnB0IiwiaWF0IjoxNTc0MDk1Nzk5LCJleHAiOjE1NzQwOTc1OTksInBlcm1pc3Npb24iOiIifQ.94pGtfdXE61jhJu_AmKDYDZN60BVB6Gxmjxq5dM-Lqc', 1574097599),
(3311, 2050, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUwIiwidXNlcm1haWwiOiJqb3NldHJpZ29AdWEucHQiLCJpYXQiOjE1NzQwOTYxNjgsImV4cCI6MTU3NDA5Nzk2OCwicGVybWlzc2lvbiI6IiJ9.O99cmsSG7IT4RBJ0XfKZ4e0qo0sWSFQhpkABeORvVnA', 1574097968),
(3315, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc0MTA4NzQ0LCJleHAiOjE1NzQxMTA1NDQsInBlcm1pc3Npb24iOiIifQ.wahD2g9XbGyeYDScvZzDCSQEPT4TrPbIA-5KbgAZR0A', 1574110544),
(3317, 1956, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTU2IiwidXNlcm1haWwiOiJ0aWFnby5zcnYub2xpdmVpcmFAdWEucHQiLCJpYXQiOjE1NzQxMDk0NDcsImV4cCI6MTU3NDExMTI0NywicGVybWlzc2lvbiI6IiJ9.W0-OhDRvP3_KMBkjcOxkPwC6xjI4u7JJTahVh_1in8M', 1574111247),
(3319, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3NDEwOTczOSwiZXhwIjoxNTc0MTExNTM5LCJwZXJtaXNzaW9uIjoiIn0.0P7uuB5cl1R6Q0tU7H6L-iT9LVqREMmogFZJmi3kh4I', 1574111539),
(3321, 1344, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQ0IiwidXNlcm1haWwiOiJpbmVzLnNlYWJyYXJvY2hhQHVhLnB0IiwiaWF0IjoxNTc0MTEyMDYxLCJleHAiOjE1NzQxMTM4NjEsInBlcm1pc3Npb24iOiIifQ.bi6U5M99LDW8B86LcTm6t8TfKjSofo2aC2Vk5X-6xBs', 1574113861),
(3325, 993, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTMiLCJ1c2VybWFpbCI6ImJydW5vc2JAdWEucHQiLCJpYXQiOjE1NzQxMTY5NTcsImV4cCI6MTU3NDExODc1NywicGVybWlzc2lvbiI6IiJ9.jzD8rf-QW5H7SbbaGPNykdCaN18ISbKfHCgK8caf05U', 1574118757),
(3329, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc0MTI2OTgyLCJleHAiOjE1NzQxMjg3ODIsInBlcm1pc3Npb24iOiIifQ.CbPXGdQigXwyjlruDSaCXUP-izgB8Qm3VTnWYJMjBks', 1574128782),
(3333, 2106, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA2IiwidXNlcm1haWwiOiJzb3BoaWVwb3VzaW5ob0B1YS5wdCIsImlhdCI6MTU3NDE1NjMxMywiZXhwIjoxNTc0MTU4MTEzLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.qSrfIw59ZC9aBSiJGOHx-GlhqVWWOi1O6rKR_81o8rU', 1574158113),
(3335, 2047, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ3IiwidXNlcm1haWwiOiJqb2FvcmVpczE2QHVhLnB0IiwiaWF0IjoxNTc0MTU4NDg0LCJleHAiOjE1NzQxNjAyODQsInBlcm1pc3Npb24iOiIifQ.I1Nv2SaY5p8wdyy38ONiwy11mslvrx388r8EQ_ap5zc', 1574160284),
(3337, 945, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NDUiLCJ1c2VybWFpbCI6ImFudG9uaW9qb3JnZWZlcm5hbmRlc0B1YS5wdCIsImlhdCI6MTU3NDE2MDA3MywiZXhwIjoxNTc0MTYxODczLCJwZXJtaXNzaW9uIjoiIn0.f2jYIbpBM1Cn8cxu5wIcceTr5oJCEJoaQ2et7qaprQc', 1574161873),
(3341, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU3NDE2NjczNywiZXhwIjoxNTc0MTY4NTM3LCJwZXJtaXNzaW9uIjoiIn0.KLdDIHrvXfg8wDLQOs4y8ZOWLPATM81k8iB-ZnAai28', 1574168537);
INSERT INTO `GenTokens` (`id`, `userid`, `token`, `expire_date`) VALUES
(3345, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTc0MTg2MTY1LCJleHAiOjE1NzQxODc5NjUsInBlcm1pc3Npb24iOiIifQ.ABs_zc1rWj-wwjhti49vk4B8YI7J4wqbXJ56Ce7JvX8', 1574187965),
(3349, 1425, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDI1IiwidXNlcm1haWwiOiJqb2FvbWFkaWFzQHVhLnB0IiwiaWF0IjoxNTc0MTkxMzU0LCJleHAiOjE1NzQxOTMxNTQsInBlcm1pc3Npb24iOiIifQ.CgdsRFuOyp01fT_O5sXtA0Uxulki_iYL4Sjsdsitgr8', 1574193154),
(3353, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc0MTk2MDg1LCJleHAiOjE1NzQxOTc4ODUsInBlcm1pc3Npb24iOiIifQ.lYExuXHyg2wItgiliUUybuU2XHm6YY5j2lCZeXbK-Js', 1574197885),
(3357, 2106, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA2IiwidXNlcm1haWwiOiJzb3BoaWVwb3VzaW5ob0B1YS5wdCIsImlhdCI6MTU3NDIwNDUyMiwiZXhwIjoxNTc0MjA2MzIyLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.Pl3mv3p_5u-IdQfwYIXRZbxGV0OaGQzbvs2w7MHLRLg', 1574206322),
(3361, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1NzQyMzkxNjUsImV4cCI6MTU3NDI0MDk2NSwicGVybWlzc2lvbiI6IiJ9.PBlfoS60t6Dxa7WRCV9bRS_dlWegWquDwY_9QYB0OO8', 1574240965),
(3363, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzQyNDA3OTMsImV4cCI6MTU3NDI0MjU5MywicGVybWlzc2lvbiI6IiJ9.RyHrlugT4uimwJZFeRvGScK2THhoaux6IS7Bs46jSuY', 1574242593),
(3365, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU3NDI0MjQ2NSwiZXhwIjoxNTc0MjQ0MjY1LCJwZXJtaXNzaW9uIjoiIn0.rj83MScS3bOyv7bHZOZRIQR3iiOuPjVKhpKEvjTIbUo', 1574244265),
(3369, 2109, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA5IiwidXNlcm1haWwiOiJmaWxpcGVnQHVhLnB0IiwiaWF0IjoxNTc0MjQ3NzcxLCJleHAiOjE1NzQyNDk1NzEsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.uwRbv2xij9ES-QHNbB9EqkiRACFzQ6wUncPiWjg6LW0', 1574249571),
(3373, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzQyNTE2NDgsImV4cCI6MTU3NDI1MzQ0OCwicGVybWlzc2lvbiI6IiJ9.VeTnmcHj8Ejh3oaRHkjTiFH03o_4f1Z9IGQlEN4BuYk', 1574253448),
(3377, 1548, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTQ4IiwidXNlcm1haWwiOiJsdWlzZmdic0B1YS5wdCIsImlhdCI6MTU3NDI1Njk1OCwiZXhwIjoxNTc0MjU4NzU4LCJwZXJtaXNzaW9uIjoiIn0.t0bIyaysleEXdmcm1R6jKGTdfjyCp799zoykkWkPO3Q', 1574258758),
(3381, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU3NDI3MTg0NSwiZXhwIjoxNTc0MjczNjQ1LCJwZXJtaXNzaW9uIjoiIn0.5CcxZSHk-zYwcDU_EyxlhAcZ7xK42JCcU36uIoMYko4', 1574273645),
(3383, 1722, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzIyIiwidXNlcm1haWwiOiJwZWRyby5taWd1ZWw1MEB1YS5wdCIsImlhdCI6MTU3NDI3MzM5NywiZXhwIjoxNTc0Mjc1MTk3LCJwZXJtaXNzaW9uIjoiIn0.THy0YDJLHuL6B8p9LThcPk2_OMwNDPJ2FirDcVJbkLU', 1574275197),
(3387, 1722, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzIyIiwidXNlcm1haWwiOiJwZWRyby5taWd1ZWw1MEB1YS5wdCIsImlhdCI6MTU3NDI3NzY0MSwiZXhwIjoxNTc0Mjc5NDQxLCJwZXJtaXNzaW9uIjoiIn0.e-6By1388dwP3eGa7_iN1hZtXIMPIaW5R-acy7doo9o', 1574279441),
(3389, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzQyODAzNzEsImV4cCI6MTU3NDI4MjE3MSwicGVybWlzc2lvbiI6IiJ9.LaOl2x6VsM9tGXumNCXI4K5dloFXmd7NW78zN-l7LKY', 1574282171),
(3393, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzQyOTQzOTYsImV4cCI6MTU3NDI5NjE5NiwicGVybWlzc2lvbiI6IiJ9.PaDYSJIGf7xEUlkRj9Y9GJFT53SR8aObFS2WObaVfVg', 1574296196),
(3397, 2080, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDgwIiwidXNlcm1haWwiOiJicmFpc0B1YS5wdCIsImlhdCI6MTU3NDMwNzAzMSwiZXhwIjoxNTc0MzA4ODMxLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.0F3L77RIg_Z1hxGVGnzPXSPZroi-dh7vk5skmPtrvhQ', 1574308831),
(3401, 933, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MzMiLCJ1c2VybWFpbCI6ImFudGhvbnlwZXJlaXJhQHVhLnB0IiwiaWF0IjoxNTc0MzM1MDEwLCJleHAiOjE1NzQzMzY4MTAsInBlcm1pc3Npb24iOiIifQ.AqRRBjQv_m_Ui-2OoN6BHSXsq-0W38CnrqQZX2F8YIc', 1574336810),
(3405, 1368, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzY4IiwidXNlcm1haWwiOiJqY3BzQHVhLnB0IiwiaWF0IjoxNTc0MzM5MTYxLCJleHAiOjE1NzQzNDA5NjEsInBlcm1pc3Npb24iOiIifQ.OwlYfGiD8MKGLUHaKe2FDLvzSQHqFNqucXL5sX3OLA0', 1574340961),
(3409, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc0MzQ4MTM2LCJleHAiOjE1NzQzNDk5MzYsInBlcm1pc3Npb24iOiIifQ.C3eZDUxT3g2GRmePQVKfBN-u-oBFBOUa8DwV_PEj-s0', 1574349936),
(3413, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTc0MzU5NjU4LCJleHAiOjE1NzQzNjE0NTgsInBlcm1pc3Npb24iOiIifQ.iune-JTpBYbYzRo6UUumMtlGVj8g5BugoFG6_UOiXO8', 1574361458),
(3417, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTc0MzY2NTcxLCJleHAiOjE1NzQzNjgzNzEsInBlcm1pc3Npb24iOiIifQ.8j8rJP-P_j3b_iy5X9Tek8VyRweLD1oUy0wOljFELj4', 1574368371),
(3421, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU3NDM3NzUzOCwiZXhwIjoxNTc0Mzc5MzM4LCJwZXJtaXNzaW9uIjoiIn0.8NwES1wi-0RxDdg1YKjQvngyiYgCgYcx5NVZfzq8FO4', 1574379338),
(3425, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzQ0MTczMTgsImV4cCI6MTU3NDQxOTExOCwicGVybWlzc2lvbiI6IiJ9.hfMK0AztbZTUsrKo8pUum22lyNyMkm0gRRVJOV1t7Vo', 1574419118),
(3427, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU3NDQxNzQ4NywiZXhwIjoxNTc0NDE5Mjg3LCJwZXJtaXNzaW9uIjoiIn0.ljzpm8JuZ37rAdI0bRq8J3WsSqsNChV_YEM6Faq1ZpI', 1574419287),
(3431, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzQ0MjIwMTQsImV4cCI6MTU3NDQyMzgxNCwicGVybWlzc2lvbiI6IiJ9.mVCFhRGW9mKCOHWXZtI6gCjj7_YD2jUjMt3539Kj7Uw', 1574423814),
(3435, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU3NDQzNTY2OCwiZXhwIjoxNTc0NDM3NDY4LCJwZXJtaXNzaW9uIjoiIn0.ep7vS6RxBknmRq210yJlYaV8y7FSNMpM4kXwAjHwBFw', 1574437468),
(3437, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU3NDQzNTY3NSwiZXhwIjoxNTc0NDM3NDc1LCJwZXJtaXNzaW9uIjoiIn0.dbG-WYD5vB14T66YdiOiEZlCE6CEdzuNyIeZysC8w9Y', 1574437475),
(3441, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3NDQzODkwMCwiZXhwIjoxNTc0NDQwNzAwLCJwZXJtaXNzaW9uIjoiIn0.86dZyIWy0mb_g3e99DBcoEWreCQVI88gl9gBMCnrjos', 1574440700),
(3443, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU3NDQ0MTQ2MSwiZXhwIjoxNTc0NDQzMjYxLCJwZXJtaXNzaW9uIjoiIn0.phS35avSXrRVs8pQi9_to13g_U36QndlYu9LP_z8CEw', 1574443261),
(3445, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU3NDQ0MjkzNywiZXhwIjoxNTc0NDQ0NzM3LCJwZXJtaXNzaW9uIjoiIn0.EQVv3E4JTZJ_200Z8EzStp3RKR5oV6YgUHcQ9SCXEhg', 1574444737),
(3447, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc0NDQzMzQwLCJleHAiOjE1NzQ0NDUxNDAsInBlcm1pc3Npb24iOiIifQ.j_i4diOp0xzX_4ZsY1Zi-Se-UnovhWTYbAo0_IAjV7k', 1574445140),
(3451, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTc0NDUyNTgyLCJleHAiOjE1NzQ0NTQzODIsInBlcm1pc3Npb24iOiIifQ.qzMOHv1f-JgtPVi__X3VKVHtfRF0NtoCzEPeR6JdEc4', 1574454382),
(3453, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzQ0NTQ0MTQsImV4cCI6MTU3NDQ1NjIxNCwicGVybWlzc2lvbiI6IiJ9.giAROISC_eLkIRR4CkLeQ_eySnNytTxG4vxmyJWOgUg', 1574456214),
(3455, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU3NDQ1NDUxNiwiZXhwIjoxNTc0NDU2MzE2LCJwZXJtaXNzaW9uIjoiIn0.in6kqYnpr8tiw7Pdt9ck9vJT7N8qB3Ofpzp58pAgVss', 1574456316),
(3457, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTc0NDU2MDYwLCJleHAiOjE1NzQ0NTc4NjAsInBlcm1pc3Npb24iOiIifQ.gNLoFEDQtS4PjcqSZS3jPwqnqIvFSSsR91MWljYBjC0', 1574457860),
(3459, 2046, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ2IiwidXNlcm1haWwiOiJpc2FiZWwucm9zYXJpb0B1YS5wdCIsImlhdCI6MTU3NDQ1ODk1NCwiZXhwIjoxNTc0NDYwNzU0LCJwZXJtaXNzaW9uIjoiIn0.ostycY8gDNjqAouM082oLREwsqRaHcq_YON2tekLCUk', 1574460754),
(3461, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTc0NDYwNDYyLCJleHAiOjE1NzQ0NjIyNjIsInBlcm1pc3Npb24iOiIifQ.B1DmxdCCehXriPom95McyrUNEdr60fOk_z4bRtHChH0', 1574462262),
(3465, 1827, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODI3IiwidXNlcm1haWwiOiJyaWNhcmRvLmNydXoyOUB1YS5wdCIsImlhdCI6MTU3NDQ2NDMwOSwiZXhwIjoxNTc0NDY2MTA5LCJwZXJtaXNzaW9uIjoiIn0.qDZfShEwQyURV5YqfJjY03JAGhODnJVXbzYvHT5l2aI', 1574466109),
(3467, 1146, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTQ2IiwidXNlcm1haWwiOiJkaW9nby5lLm1vcmVpcmFAdWEucHQiLCJpYXQiOjE1NzQ0NjUxODIsImV4cCI6MTU3NDQ2Njk4MiwicGVybWlzc2lvbiI6IiJ9.AtZZLUL01ZwbXoLj0QENh-j7rMU7tRUpV3n_ra2kSqY', 1574466982),
(3469, 1827, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODI3IiwidXNlcm1haWwiOiJyaWNhcmRvLmNydXoyOUB1YS5wdCIsImlhdCI6MTU3NDQ2NTYxOCwiZXhwIjoxNTc0NDY3NDE4LCJwZXJtaXNzaW9uIjoiIn0.5enRpHSXRHlDNhGUhup02zdOv8U8CBUW3Pf8_90igg8', 1574467418),
(3471, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTc0NDY3NzQ4LCJleHAiOjE1NzQ0Njk1NDgsInBlcm1pc3Npb24iOiIifQ.3xFVTpaZBoI3MR6iDQzXrCZSJQRcJ49oOS5MrCqV6f0', 1574469548),
(3475, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzQ0NzcxMjcsImV4cCI6MTU3NDQ3ODkyNywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.4p19Cr7HI12KfF5BjlTq_pEnVCxJb4-kYWpy6hG2LiU', 1574478927),
(3479, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc0NTA4OTM1LCJleHAiOjE1NzQ1MTA3MzUsInBlcm1pc3Npb24iOiIifQ.MN_B7njO1S77IFPQSxcxmX3-IJKQECrJQAfWl_QIubI', 1574510735),
(3481, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1NzQ1MDk1ODcsImV4cCI6MTU3NDUxMTM4NywicGVybWlzc2lvbiI6IiJ9.CJYnCJZmITAAPj8lnBjw3cGsXiCgE2gIdARgagpnrTk', 1574511387),
(3483, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzQ1MTA0MjcsImV4cCI6MTU3NDUxMjIyNywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.18eoqMj1CgAksAsSdE3qICbX73hWraMVkE_PZ0kfK3U', 1574512227),
(3489, 1461, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDYxIiwidXNlcm1haWwiOiJqb2FvdHNAdWEucHQiLCJpYXQiOjE1NzQ1MTY2NzgsImV4cCI6MTU3NDUxODQ3OCwicGVybWlzc2lvbiI6IiJ9.XtMYGla-2eG20IkM1FOK1xPEuWnQeSjLb7RJsuUd46Y', 1574518478),
(3493, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1NzQ1MjUwNjcsImV4cCI6MTU3NDUyNjg2NywicGVybWlzc2lvbiI6IiJ9.lZJuFthFtktzewC54azA4QM9Th7XpKHTdsKBqAHuS68', 1574526867),
(3495, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc0NTI1NTEwLCJleHAiOjE1NzQ1MjczMTAsInBlcm1pc3Npb24iOiIifQ.OchISXuLhUdIGxNFf3wHeMCuMTWyeXb3Ea4tKK28o-Q', 1574527310),
(3497, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc0NTI1NTMyLCJleHAiOjE1NzQ1MjczMzIsInBlcm1pc3Npb24iOiIifQ.v8QiwjcVatfJOOsOF5QXNBPA1KIeFsKx6vYpVWPAmDw', 1574527332),
(3499, 1689, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjg5IiwidXNlcm1haWwiOiJudW5vLm1hdGFtYmFAdWEucHQiLCJpYXQiOjE1NzQ1MjYyOTYsImV4cCI6MTU3NDUyODA5NiwicGVybWlzc2lvbiI6IiJ9.tPdgJlkKUcGrubEuoHCliPAumGvAw4-30U-856EkpmU', 1574528096),
(3501, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTc0NTI2NDIwLCJleHAiOjE1NzQ1MjgyMjAsInBlcm1pc3Npb24iOiIifQ.KvjbHQjzQdDLuecnvreBNxPiXU01wfSGE6BKwrfO_OI', 1574528220),
(3503, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc0NTI3NjE5LCJleHAiOjE1NzQ1Mjk0MTksInBlcm1pc3Npb24iOiIifQ.6GIdxmGmx5TWNgY5vyiUQ66IwX9hAOa5wX_So4TebI0', 1574529419),
(3505, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTc0NTI4MjY0LCJleHAiOjE1NzQ1MzAwNjQsInBlcm1pc3Npb24iOiIifQ.Z_lQ0wWAblvrKs2BQOGB8BG_i-Kk0ud5IjfxPzCLjIA', 1574530064),
(3507, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc0NTI4Njg1LCJleHAiOjE1NzQ1MzA0ODUsInBlcm1pc3Npb24iOiIifQ.uRdh2sRLb_wKDzDt7-ZSw3l0A3uRXUPQ9SUnUMkmBmY', 1574530485),
(3509, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc0NTMxMzUxLCJleHAiOjE1NzQ1MzMxNTEsInBlcm1pc3Npb24iOiIifQ.wZ77uX762kQVystawpmHVbfNaJk6hiatQG_eQGIDM2o', 1574533151),
(3513, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3NDUzNjI1NCwiZXhwIjoxNTc0NTM4MDU0LCJwZXJtaXNzaW9uIjoiIn0.zFxvqsjcHJKKACgBKaVaMJ1Y9CutyR86bWdql9thvYw', 1574538054),
(3517, 2036, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM2IiwidXNlcm1haWwiOiJkaW9nb21mc2lsdmE5OEB1YS5wdCIsImlhdCI6MTU3NDU0MDA3OCwiZXhwIjoxNTc0NTQxODc4LCJwZXJtaXNzaW9uIjoiIn0.rU_Eq7XpMrWUF5DoYorEgCIR-wJFn3_uugQV5HT7uws', 1574541878),
(3519, 2055, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU1IiwidXNlcm1haWwiOiJtaWd1ZWwuci5mZXJyZWlyYUB1YS5wdCIsImlhdCI6MTU3NDU0MTAxMiwiZXhwIjoxNTc0NTQyODEyLCJwZXJtaXNzaW9uIjoiIn0.vpVszTp1edON5i2ZxuXnOHfTQckdd_Wl-Zv3cdmIVj8', 1574542812),
(3525, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTc0NTQ1NTAxLCJleHAiOjE1NzQ1NDczMDEsInBlcm1pc3Npb24iOiIifQ.x4RY2Gpt24e0S_9Zkd4Khu33EC-hz7A1qA7L9HtAKro', 1574547301),
(3527, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc0NTQ1ODk4LCJleHAiOjE1NzQ1NDc2OTgsInBlcm1pc3Npb24iOiIifQ.gxq1XEldBF13QsTkPJdmc-hyQRZKlKXnBfuTzqsyxtE', 1574547698),
(3529, 1620, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjIwIiwidXNlcm1haWwiOiJtYXJpb3NpbHZhQHVhLnB0IiwiaWF0IjoxNTc0NTQ2MTA4LCJleHAiOjE1NzQ1NDc5MDgsInBlcm1pc3Npb24iOiIifQ.HgK5mkRbq97hF1MuvT0tYTr7_-W9QIH6-YR6sNwELVo', 1574547908),
(3531, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3NDU0OTA4OCwiZXhwIjoxNTc0NTUwODg4LCJwZXJtaXNzaW9uIjoiIn0.mZO0tPCfkT3jYVcyHaDlLc1vdt9ESvpDzydxrF0IXtY', 1574550888),
(3533, 2055, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU1IiwidXNlcm1haWwiOiJtaWd1ZWwuci5mZXJyZWlyYUB1YS5wdCIsImlhdCI6MTU3NDU1MDYyMSwiZXhwIjoxNTc0NTUyNDIxLCJwZXJtaXNzaW9uIjoiIn0.OsGAoFImswVUNzJW1yuPLrLY0osof0qaVK0OJWYz6cM', 1574552421),
(3537, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzQ1OTI1MTMsImV4cCI6MTU3NDU5NDMxMywicGVybWlzc2lvbiI6IiJ9.uohr6-Fbz-KDrcFfeeXtHcmw9jZYWr7Ng-wrGaccESw', 1574594313),
(3539, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU3NDU5NDE3NSwiZXhwIjoxNTc0NTk1OTc1LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.W9YbufWuAFVuMO_fzyXhYRnnnJgvyjpeebspOMZn00k', 1574595975),
(3543, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc0NTk5MjMyLCJleHAiOjE1NzQ2MDEwMzIsInBlcm1pc3Npb24iOiIifQ.7gvjuePHOodEsuV5td39qscM_UML4A7RsByNXamVN50', 1574601032),
(3545, 933, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MzMiLCJ1c2VybWFpbCI6ImFudGhvbnlwZXJlaXJhQHVhLnB0IiwiaWF0IjoxNTc0NjAwNDQ2LCJleHAiOjE1NzQ2MDIyNDYsInBlcm1pc3Npb24iOiIifQ.MkJVpwskrf4zplGA4X8ciQyJxv6cTRrVVG60vAkSRLU', 1574602246),
(3549, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc0NjA2Mzg0LCJleHAiOjE1NzQ2MDgxODQsInBlcm1pc3Npb24iOiIifQ.f-E1wJRfxEsWrvzQAWVwNtToL_asA7BlumvXphDukXI', 1574608184),
(3551, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc0NjA3MTE0LCJleHAiOjE1NzQ2MDg5MTQsInBlcm1pc3Npb24iOiIifQ.X0L-3ZQWNSMQ8dnUkco-ntFNpeiI8Eck0WpEvh62OL4', 1574608914),
(3553, 1350, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzUwIiwidXNlcm1haWwiOiJpc2Fkb3JhLmZsQHVhLnB0IiwiaWF0IjoxNTc0NjA4Mzk2LCJleHAiOjE1NzQ2MTAxOTYsInBlcm1pc3Npb24iOiIifQ.tSUJzEdG11S1GeYrjUk_1WN-lOgmFbe3MK5-Hw359xA', 1574610196),
(3557, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTc0NjEyOTkwLCJleHAiOjE1NzQ2MTQ3OTAsInBlcm1pc3Npb24iOiIifQ.htS2TFkPPQalx3lWxLVnIiIvk7MA8xDxGvDhnNdQM0E', 1574614790),
(3559, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1NzQ2MTY1MDUsImV4cCI6MTU3NDYxODMwNSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.Sx7OAg0PYoI9jmqOP00Wnv_1JienSH5WhIt1FZo3T7c', 1574618305),
(3561, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1NzQ2MTgyNzgsImV4cCI6MTU3NDYyMDA3OCwicGVybWlzc2lvbiI6IiJ9.FiRfqixPdypTPErktjbMAMWNZ55e-OMPPMFdPYZx1bo', 1574620078),
(3563, 2109, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA5IiwidXNlcm1haWwiOiJmaWxpcGVnQHVhLnB0IiwiaWF0IjoxNTc0NjE5NDg3LCJleHAiOjE1NzQ2MjEyODcsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.cjxrPBqgHZEgB7kwzi-r8O_pQWOTjaf1a5YUhUGkFnI', 1574621287),
(3565, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU3NDYyMDE5NCwiZXhwIjoxNTc0NjIxOTk0LCJwZXJtaXNzaW9uIjoiIn0.6byVGa2MJRh7lp7qnu30jxiD_d5dZOIbRO9RjzJpGcI', 1574621994),
(3567, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTc0NjIzNDY2LCJleHAiOjE1NzQ2MjUyNjYsInBlcm1pc3Npb24iOiIifQ.3i44aDc2vjCJMNMdiXh8kI_PYLzYMXrSeXp9eB_VKYg', 1574625266),
(3569, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3NDYyMzgzNiwiZXhwIjoxNTc0NjI1NjM2LCJwZXJtaXNzaW9uIjoiIn0.F5lpN3T2L2-KryHHQabKPHfzLoGUpkxjuxNZRepAEUQ', 1574625636),
(3573, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTc0NjI4MTUxLCJleHAiOjE1NzQ2Mjk5NTEsInBlcm1pc3Npb24iOiIifQ.tBY4GxUDVuE_1DPAKe0IDHq2lzDGlt66fPpilO1jddI', 1574629951),
(3575, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTc0NjI4ODA5LCJleHAiOjE1NzQ2MzA2MDksInBlcm1pc3Npb24iOiIifQ.qFP4L0jlsHElQSmx1hJDjir1M24pB2FgLo2SkcuUqY8', 1574630609),
(3577, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU3NDYyOTg3NSwiZXhwIjoxNTc0NjMxNjc1LCJwZXJtaXNzaW9uIjoiIn0.3VrrZ08H7P4zy0tN7k2oKDTUH7WPBlwz13HUZ9_W8Q4', 1574631675),
(3581, 2109, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA5IiwidXNlcm1haWwiOiJmaWxpcGVnQHVhLnB0IiwiaWF0IjoxNTc0NjY4Mjc5LCJleHAiOjE1NzQ2NzAwNzksInBlcm1pc3Npb24iOiJERUZBVUxUIn0.LF15YeS6llkdpyKBDiCVrb_yhF1qVl2yveox8c4MG-E', 1574670079),
(3585, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1NzQ2NzU5OTEsImV4cCI6MTU3NDY3Nzc5MSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.Cs0V1VC99kDD56iNufTOYlXlUV_xLwdv84hvXOiu020', 1574677791),
(3587, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1NzQ2Nzc1ODIsImV4cCI6MTU3NDY3OTM4MiwicGVybWlzc2lvbiI6IiJ9.xrmrhdBxL7EoLGI1_ZY5JL9aFgHfWsJ_iPpIft4eZZU', 1574679382),
(3591, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU3NDY4MDY2NCwiZXhwIjoxNTc0NjgyNDY0LCJwZXJtaXNzaW9uIjoiIn0.RpA5UO4PvpYtH-vccWBTdXRNct-0dX1NpgcUcPHiL4g', 1574682464),
(3595, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTc0NjgzMzYyLCJleHAiOjE1NzQ2ODUxNjIsInBlcm1pc3Npb24iOiIifQ.aNUi1SPexBPR1_w-YnKWM74B9OwxMM4TBGTLnzsGmSA', 1574685162),
(3597, 2022, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIyIiwidXNlcm1haWwiOiJhbGV4YW5kcmVwcDA3QHVhLnB0IiwiaWF0IjoxNTc0NjgzMzk5LCJleHAiOjE1NzQ2ODUxOTksInBlcm1pc3Npb24iOiIifQ.BThHB4XZg9UjudMSYxugm_hSQfwZhHs4J2ssufkr7Vc', 1574685199),
(3601, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU3NDY4OTA1MSwiZXhwIjoxNTc0NjkwODUxLCJwZXJtaXNzaW9uIjoiIn0.Q5xspeTtwXhTLsIW-NlBd17tbNQz-4U3leNZCbApIWo', 1574690851),
(3603, 2032, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMyIiwidXNlcm1haWwiOiJkZGlhc0B1YS5wdCIsImlhdCI6MTU3NDY4OTA5NiwiZXhwIjoxNTc0NjkwODk2LCJwZXJtaXNzaW9uIjoiIn0.3bIOOI7gXBdMbz1b4Yt2gH-z1DCV945nqzIUGACdPcw', 1574690896),
(3605, 2022, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIyIiwidXNlcm1haWwiOiJhbGV4YW5kcmVwcDA3QHVhLnB0IiwiaWF0IjoxNTc0NjkwODU5LCJleHAiOjE1NzQ2OTI2NTksInBlcm1pc3Npb24iOiIifQ.BOqTHYQqrDCDiJGuR-2lFRJurnRczHKWgI2nyE45WaA', 1574692659),
(3607, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzQ2OTE5MzYsImV4cCI6MTU3NDY5MzczNiwicGVybWlzc2lvbiI6IiJ9.ALWe8zivoKZmxbRTRlXH1QdaJ8d3RJcDz0GPKkJBco0', 1574693736),
(3609, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzQ2OTIwNDgsImV4cCI6MTU3NDY5Mzg0OCwicGVybWlzc2lvbiI6IiJ9.MS-carhdy05gdSxhbu_eGf0XALCms86olA0wPaXXzlo', 1574693848),
(3611, 2022, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIyIiwidXNlcm1haWwiOiJhbGV4YW5kcmVwcDA3QHVhLnB0IiwiaWF0IjoxNTc0NjkyODI5LCJleHAiOjE1NzQ2OTQ2MjksInBlcm1pc3Npb24iOiIifQ.CveJtP8SUDOIO72jGuk20Ogu_a763JmMA1-zBSD0dCM', 1574694629),
(3617, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1NzQ2OTk3MDQsImV4cCI6MTU3NDcwMTUwNCwicGVybWlzc2lvbiI6IiJ9.tMNuItJLc6SfIQsKi0bdpH8WflzXTRrUGdPQw8L6OIE', 1574701504),
(3621, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3NDcwNzQyMCwiZXhwIjoxNTc0NzA5MjIwLCJwZXJtaXNzaW9uIjoiIn0.xnDmuN4UF6jo_-1XEq_Hi5OdDuhxW7NpDSGQcY--eCU', 1574709220),
(3623, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1NzQ3MDc3ODIsImV4cCI6MTU3NDcwOTU4MiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.X_v2bIc1rdoPLeYFlEwNcXflA4RrnA1vPIcMSl3u6I4', 1574709582),
(3625, 1278, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc4IiwidXNlcm1haWwiOiJnb25jYWxvLmFsbWVpZGFAdWEucHQiLCJpYXQiOjE1NzQ3MDg0NjcsImV4cCI6MTU3NDcxMDI2NywicGVybWlzc2lvbiI6IiJ9.4NoC_UuF9TyuTVTonreja3mBpqzXZHXmB0zhTpuxH0M', 1574710267),
(3627, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzQ3MDg1NDMsImV4cCI6MTU3NDcxMDM0MywicGVybWlzc2lvbiI6IiJ9.v-pKKgT114FDft96gDjlCvk4w0Pt2XkROwpwwi4EvfU', 1574710343),
(3631, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc0NzEzNDI5LCJleHAiOjE1NzQ3MTUyMjksInBlcm1pc3Npb24iOiIifQ.GZoP3j1PUQW3bYBIiqtm0zZf4aU6FOr-RbIa6Qkx6c0', 1574715229),
(3633, 1278, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc4IiwidXNlcm1haWwiOiJnb25jYWxvLmFsbWVpZGFAdWEucHQiLCJpYXQiOjE1NzQ3MTUxNDIsImV4cCI6MTU3NDcxNjk0MiwicGVybWlzc2lvbiI6IiJ9.XAhZzrOTcwF6Wk5IalDZddw1-7GdEKRIufgZOI8lRog', 1574716942),
(3635, 2022, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIyIiwidXNlcm1haWwiOiJhbGV4YW5kcmVwcDA3QHVhLnB0IiwiaWF0IjoxNTc0NzE3MzAyLCJleHAiOjE1NzQ3MTkxMDIsInBlcm1pc3Npb24iOiIifQ.QvYPRfFQSUuj33mZrFkYhgfC1hVUVyQEsKN7A8Gjbeg', 1574719102),
(3637, 2032, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMyIiwidXNlcm1haWwiOiJkZGlhc0B1YS5wdCIsImlhdCI6MTU3NDcxODQ3OSwiZXhwIjoxNTc0NzIwMjc5LCJwZXJtaXNzaW9uIjoiIn0.ZpvTDMzfxqHa8_BEVyCBV32X8gFUeQ8_LOHslayoX3w', 1574720279),
(3639, 1278, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc4IiwidXNlcm1haWwiOiJnb25jYWxvLmFsbWVpZGFAdWEucHQiLCJpYXQiOjE1NzQ3MjE2OTgsImV4cCI6MTU3NDcyMzQ5OCwicGVybWlzc2lvbiI6IiJ9.HXQQ0IjASxcjrGbVP1CNJxQois547g5mE-NdIVW4Qro', 1574723498),
(3643, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTc0NzY3OTE0LCJleHAiOjE1NzQ3Njk3MTQsInBlcm1pc3Npb24iOiIifQ.FiZmVjANZJaUNHlfCkEcrVeT-TRfeWeRecVJGfhS0Vk', 1574769714),
(3647, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc0Nzc3NTU1LCJleHAiOjE1NzQ3NzkzNTUsInBlcm1pc3Npb24iOiIifQ.uc3Yvt-Ax9TrtJzM6FdfPqP5AsJv4XkgExRDqmFnKDs', 1574779355),
(3651, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc0NzgwODUzLCJleHAiOjE1NzQ3ODI2NTMsInBlcm1pc3Npb24iOiIifQ.T4Z-EGyIXZX8qN-QlQBAVPRftvyr-TXEC2jA32uXeEo', 1574782653),
(3655, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzQ3ODkxNjcsImV4cCI6MTU3NDc5MDk2NywicGVybWlzc2lvbiI6IiJ9.5uA0t5nGAsGPydA-sOnBAHiLlaKLIX11Jlx1SdWrRXE', 1574790967),
(3659, 2053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUzIiwidXNlcm1haWwiOiJtYXJ0aW5oby50YXZhcmVzQHVhLnB0IiwiaWF0IjoxNTc0Nzk5MTUyLCJleHAiOjE1NzQ4MDA5NTIsInBlcm1pc3Npb24iOiIifQ.Mej2KE8sfg1WmLWUzr_o2A6h2DgG-AYIYV1ot8t7_o0', 1574800952),
(3663, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTc0ODY5NjM3LCJleHAiOjE1NzQ4NzE0MzcsInBlcm1pc3Npb24iOiIifQ.ZnHj0uHFddi0RtPe42oRE43swSSsGr4xJZXQO0IV_Hw', 1574871437),
(3667, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzQ4ODEwOTgsImV4cCI6MTU3NDg4Mjg5OCwicGVybWlzc2lvbiI6IiJ9.Z_lsfUMYJ3TNhLhqiRGJaOhe8W6G7jexSj9rjBGZ38U', 1574882898),
(3671, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU3NDg4ODgxMiwiZXhwIjoxNTc0ODkwNjEyLCJwZXJtaXNzaW9uIjoiIn0.mHy1R0iFI-S2VV0XzzSVVNaifeilPAoXzp3XX5VmyyA', 1574890612),
(3675, 1461, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDYxIiwidXNlcm1haWwiOiJqb2FvdHNAdWEucHQiLCJpYXQiOjE1NzQ5MDYzNDAsImV4cCI6MTU3NDkwODE0MCwicGVybWlzc2lvbiI6IiJ9.y_2M8JnfNmVUTUg27PImV_07qRwTuXi60pd8Lz_ydGk', 1574908140),
(3679, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc0OTQ2NzYxLCJleHAiOjE1NzQ5NDg1NjEsInBlcm1pc3Npb24iOiIifQ.w78qVo7FJ2y6LPyTZ7EFgY0n77i2A24JfLTfiQHVwHc', 1574948561),
(3681, 2050, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUwIiwidXNlcm1haWwiOiJqb3NldHJpZ29AdWEucHQiLCJpYXQiOjE1NzQ5NDk3MzAsImV4cCI6MTU3NDk1MTUzMCwicGVybWlzc2lvbiI6IiJ9.3iAuBafbcX01xhzaOUdPXYLGpM8LwWqYc-r8tU1jpK4', 1574951530),
(3683, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzQ5NTAyNzUsImV4cCI6MTU3NDk1MjA3NSwicGVybWlzc2lvbiI6IiJ9.kEAzT2aursgrlySiOSoBuittSs0BM72nV5ZPAgVeBy0', 1574952075),
(3685, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTc0OTUwNjU0LCJleHAiOjE1NzQ5NTI0NTQsInBlcm1pc3Npb24iOiIifQ.0ovTvPdp0Dx1xhYBvaOZEiF9999l_4lnKgapRqWc3Gw', 1574952454),
(3689, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTc0OTYxMzg0LCJleHAiOjE1NzQ5NjMxODQsInBlcm1pc3Npb24iOiIifQ.eHxf_q3uERPa4s8Rh-ZrsdrKCmexo7HKhBGHRnmUAek', 1574963184),
(3693, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc0OTYzOTc0LCJleHAiOjE1NzQ5NjU3NzQsInBlcm1pc3Npb24iOiIifQ.EAh2OAls8OKjJ7kT5BfSru2AKN7GuoOH306-JcBoLjw', 1574965774),
(3695, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzQ5NjUzMjEsImV4cCI6MTU3NDk2NzEyMSwicGVybWlzc2lvbiI6IiJ9.H-Mdp2gl7LHnHrLjDGTlAoytvddeYH4B4zbyqg0Z6yM', 1574967121),
(3699, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzQ5Njk5ODksImV4cCI6MTU3NDk3MTc4OSwicGVybWlzc2lvbiI6IiJ9.z_JObmjByG8c_-2FT5gYcMlXra1yvFCxIjRtGVhXGeM', 1574971789),
(3701, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzQ5NzAwNDAsImV4cCI6MTU3NDk3MTg0MCwicGVybWlzc2lvbiI6IiJ9.WnLXrMhDQLjFe-jh6qxGnOUDZmOuNpfVA7piCQVmhPs', 1574971840),
(3705, 2046, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ2IiwidXNlcm1haWwiOiJpc2FiZWwucm9zYXJpb0B1YS5wdCIsImlhdCI6MTU3NDk3NDMwMiwiZXhwIjoxNTc0OTc2MTAyLCJwZXJtaXNzaW9uIjoiIn0.Vn1BiUXeWzS4DCEV2ZYYaPsW_TZKbRQrKzMz1wRXGfc', 1574976102),
(3709, 2050, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUwIiwidXNlcm1haWwiOiJqb3NldHJpZ29AdWEucHQiLCJpYXQiOjE1NzQ5ODA0NzksImV4cCI6MTU3NDk4MjI3OSwicGVybWlzc2lvbiI6IiJ9.kAxKC-mRVVelIL2czsWjegT5CKEokSjpOKILH5_ks-U', 1574982279),
(3711, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU3NDk4MTY1NywiZXhwIjoxNTc0OTgzNDU3LCJwZXJtaXNzaW9uIjoiIn0.D-js9o-QRITeUnH6eavho8GONG31FDaNuDIyI_yKAF4', 1574983457),
(3715, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc0OTg2OTg2LCJleHAiOjE1NzQ5ODg3ODYsInBlcm1pc3Npb24iOiIifQ.h7PjHodWK0KuFDx6Mf5m-TAbUXswcgD-Xd6T02FWeuI', 1574988786),
(3717, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1NzQ5ODkwNTUsImV4cCI6MTU3NDk5MDg1NSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.yCXYQBdcfnPQkw1_m4dp2CLGhz2y2UoOhM8VLNnJRbg', 1574990855),
(3719, 1611, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjExIiwidXNlcm1haWwiOiJtYXJpYW5hc3BzQHVhLnB0IiwiaWF0IjoxNTc0OTg5NTMxLCJleHAiOjE1NzQ5OTEzMzEsInBlcm1pc3Npb24iOiIifQ.EYOKNnOgI6gi4S1tPzY-p10uhi_TO_hY2TNwltZL6Ac', 1574991331),
(3723, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTc1MDI4MTk2LCJleHAiOjE1NzUwMjk5OTYsInBlcm1pc3Npb24iOiIifQ.TB80UwkT_OkMGmAaDaeB1fnE_UsqNgIb2sO8aEuJ0nY', 1575029996),
(3725, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTc1MDMwMDIwLCJleHAiOjE1NzUwMzE4MjAsInBlcm1pc3Npb24iOiIifQ.tMrijkaxTYD8r-q2Nd5-RhZ4HWjUsCNOtZYJUYnJdic', 1575031820),
(3729, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTc1MDQyOTI1LCJleHAiOjE1NzUwNDQ3MjUsInBlcm1pc3Npb24iOiIifQ.wRpbGvtFNgfUv2pP7nutpR9dSDE03H-7tCIAYyTYVSo', 1575044725),
(3737, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc1MTEyMzk1LCJleHAiOjE1NzUxMTQxOTUsInBlcm1pc3Npb24iOiIifQ.DLPmrnAneyv4wd7o3OsvvlsA42UTOwB7gL6pCYsWG2k', 1575114195),
(3739, 2046, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ2IiwidXNlcm1haWwiOiJpc2FiZWwucm9zYXJpb0B1YS5wdCIsImlhdCI6MTU3NTExNDA2MCwiZXhwIjoxNTc1MTE1ODYwLCJwZXJtaXNzaW9uIjoiIn0.zABy-LiyR8yI8pXRI4j1BInkOo1v7qS2KyH6kJ4ZBHU', 1575115860),
(3743, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1NzUxMjkxNjMsImV4cCI6MTU3NTEzMDk2MywicGVybWlzc2lvbiI6IiJ9.jWUSs1pPyhHZErvK1qseycqU5hyVlcFDASfJrjldiIc', 1575130963),
(3745, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc1MTMxNTQ3LCJleHAiOjE1NzUxMzMzNDcsInBlcm1pc3Npb24iOiIifQ.FsrOSXz0ApBPaLLOECcljHxYcYb_t7hRh3m-CwH6JQg', 1575133347),
(3747, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1NzUxMzE4MDUsImV4cCI6MTU3NTEzMzYwNSwicGVybWlzc2lvbiI6IiJ9.mq7rlwNFaaxmAByMgV4tZjo-IOnZo4U2SIVkWq3zq_8', 1575133605),
(3749, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzUxMzIzNDUsImV4cCI6MTU3NTEzNDE0NSwicGVybWlzc2lvbiI6IiJ9.xL3UdYZtVRaKrhhvPQEb5loaJHfPirsdrTfIepBLMiA', 1575134145),
(3751, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc1MTMzODQ4LCJleHAiOjE1NzUxMzU2NDgsInBlcm1pc3Npb24iOiIifQ.OCv4TlEGzcwAZA_OEqLOzbzM5-fPRsyicu2rCQ0oNW0', 1575135648),
(3753, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTc1MTM0NDcxLCJleHAiOjE1NzUxMzYyNzEsInBlcm1pc3Npb24iOiIifQ.9Ro-ERD3RdGIIQ1mlZrPG2s0I0MHy47MN2ODUonY6e0', 1575136271),
(3755, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc1MTM2MTkyLCJleHAiOjE1NzUxMzc5OTIsInBlcm1pc3Npb24iOiIifQ.5lyTcAGGQDSv6d1eK-gonm7qTqH7c6DEokxBLKGV2h8', 1575137992),
(3757, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU3NTEzNjIxMiwiZXhwIjoxNTc1MTM4MDEyLCJwZXJtaXNzaW9uIjoiIn0.9E4QeGD0sGFLLJ8vTHGgiMxKAMr-YB-tb1U2L2Cwceo', 1575138012),
(3759, 2045, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ1IiwidXNlcm1haWwiOiJodWdvZ29uY2FsdmVzMTNAdWEucHQiLCJpYXQiOjE1NzUxMzgwOTYsImV4cCI6MTU3NTEzOTg5NiwicGVybWlzc2lvbiI6IiJ9.k0VlBwWiVu1Vpyqb1kBV-Ztou_XvuPd7aG6ZeoRv5MM', 1575139896),
(3761, 2045, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ1IiwidXNlcm1haWwiOiJodWdvZ29uY2FsdmVzMTNAdWEucHQiLCJpYXQiOjE1NzUxMzgxNTIsImV4cCI6MTU3NTEzOTk1MiwicGVybWlzc2lvbiI6IiJ9.hHxndEDf9OESTR5VoWg2dPloOslYQs9qClYiJhB8Xhc', 1575139952),
(3763, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTc1MTM4MjQ3LCJleHAiOjE1NzUxNDAwNDcsInBlcm1pc3Npb24iOiIifQ.ivJ8sh0K6FPf-dGPvSXqumYkA_OJmdtDKQ2PaEMAWw4', 1575140047),
(3765, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3NTEzODc3MiwiZXhwIjoxNTc1MTQwNTcyLCJwZXJtaXNzaW9uIjoiIn0.ldntq3zWod3prjQmICK-1k6EpIDQycnqFwGQHHuFGTs', 1575140572),
(3769, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzUxMzk1MjcsImV4cCI6MTU3NTE0MTMyNywicGVybWlzc2lvbiI6IiJ9.iV3D1lMgw2JFhtlGKTBKIHYwyTad-E4cpyp_sabzZRI', 1575141327),
(3773, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzUxNTc3NTUsImV4cCI6MTU3NTE1OTU1NSwicGVybWlzc2lvbiI6IiJ9.rg3cVOaxi77sSX2M9mxsuD2-w0oDYu4DouP_EWzxDQM', 1575159555),
(3775, 2104, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA0IiwidXNlcm1haWwiOiJhZm9uc28uY2FtcG9zQHVhLnB0IiwiaWF0IjoxNTc1MTU5OTE3LCJleHAiOjE1NzUxNjE3MTcsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.19t_rTqmAu4cUR7EqBa14ig7uG6ELvw-C1e6UoyIkvY', 1575161717),
(3779, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1NzUxNjQwMjUsImV4cCI6MTU3NTE2NTgyNSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.Emyrnvn0vhXBoeDyUm01GhzeRuk9cC_ltnpRrEeNWSY', 1575165825),
(3783, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3NTE2OTM3NywiZXhwIjoxNTc1MTcxMTc3LCJwZXJtaXNzaW9uIjoiIn0.ZdscwdRmYdMrucoK5922VWsde11wclyWFbBPxFCt8vU', 1575171177),
(3787, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTc1MTk5NTI1LCJleHAiOjE1NzUyMDEzMjUsInBlcm1pc3Npb24iOiIifQ.Acxz1-p13Uowkb5E2dxtvz_EbroQdLXgdTSO5IcMfvU', 1575201325),
(3791, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzUyMDQ2MzcsImV4cCI6MTU3NTIwNjQzNywicGVybWlzc2lvbiI6IiJ9.uIRNV57ez2VfM28IUo_zw-wqhhU0kBsmJthHsvmiTtY', 1575206437),
(3795, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU3NTIxNjYzOSwiZXhwIjoxNTc1MjE4NDM5LCJwZXJtaXNzaW9uIjoiIn0.GRWuaCYEWvJ345K_tEz8CihDq2tSy5dNoQ_sWDc9qNY', 1575218439),
(3797, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU3NTIxODk4NiwiZXhwIjoxNTc1MjIwNzg2LCJwZXJtaXNzaW9uIjoiIn0.D9Xza7uECTwEOxWDbOp_-gzE0o4cXI5w4vjkfPFq-I8', 1575220786),
(3799, 2045, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ1IiwidXNlcm1haWwiOiJodWdvZ29uY2FsdmVzMTNAdWEucHQiLCJpYXQiOjE1NzUyMTkyNjEsImV4cCI6MTU3NTIyMTA2MSwicGVybWlzc2lvbiI6IiJ9.ezngTeYAwYPNKVCHAqnLzO5OzSQ3u5R3TQ-C1KJV878', 1575221061),
(3801, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzUyMjIwMDksImV4cCI6MTU3NTIyMzgwOSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.NecbHXNIKIiJ9omrFJh9-NV4GBOXFYMuqjThk4OhF-Q', 1575223809),
(3803, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTc1MjIzMDU2LCJleHAiOjE1NzUyMjQ4NTYsInBlcm1pc3Npb24iOiIifQ.iNDtMQzzprgL7cD21p8hHi6aYlmxV9SEDNJg8_1q0E0', 1575224856),
(3805, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc1MjI1OTIyLCJleHAiOjE1NzUyMjc3MjIsInBlcm1pc3Npb24iOiIifQ.Qn14O_dpgL-HhjtjwT5kuEH82NWrqnQyiLbxYnMrqZU', 1575227722),
(3809, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTc1MjI5MDI5LCJleHAiOjE1NzUyMzA4MjksInBlcm1pc3Npb24iOiIifQ.hgOIw3qsMDEUGXVoFNhO7zbjWKrmmryvzbLpCkXSX4E', 1575230829),
(3813, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3NTI0MDc4MywiZXhwIjoxNTc1MjQyNTgzLCJwZXJtaXNzaW9uIjoiIn0.vpyxHbFuvC5NU8kcdiQ6QhArzuyB-SvnuiX3u65u76Y', 1575242583),
(3817, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTc1MjQ3MjQ0LCJleHAiOjE1NzUyNDkwNDQsInBlcm1pc3Npb24iOiIifQ.Tm1-w2D-CPH8wBExlLwGzrhDnIAZa8Z07pGBpBP7uf4', 1575249044),
(3821, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc1Mjc5MzE5LCJleHAiOjE1NzUyODExMTksInBlcm1pc3Npb24iOiIifQ.dS1pTsg23JpgbhulihZKiW50rAU0lqycw8QehpE6XuA', 1575281119),
(3825, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTc1Mjg2NDQ5LCJleHAiOjE1NzUyODgyNDksInBlcm1pc3Npb24iOiIifQ.5zF-yfC8jh6TGLJ3LHtLQmhlr2RUkYAwPhqUlYTL_ws', 1575288249),
(3827, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU3NTI4NjYzNCwiZXhwIjoxNTc1Mjg4NDM0LCJwZXJtaXNzaW9uIjoiIn0.42RpFijpofnoItmOoXck-fJaViT7p0Yh6KN1qnJI8Qg', 1575288434),
(3829, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3NTI4NzExNSwiZXhwIjoxNTc1Mjg4OTE1LCJwZXJtaXNzaW9uIjoiIn0.T9Tf39Nu7LX5d29m4LOugnJB4YeOSHQui0ChASjKa-w', 1575288915),
(3833, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzUyODk5MjYsImV4cCI6MTU3NTI5MTcyNiwicGVybWlzc2lvbiI6IiJ9.KrGkb3TtWn3AJnHv5UgFAQC9F0PWAntNdqc_NLcMr_0', 1575291726),
(3835, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzUyOTAwMDIsImV4cCI6MTU3NTI5MTgwMiwicGVybWlzc2lvbiI6IiJ9.sd28ZTjpSyymwsU1cNhDImeeRy0krgNOsJLowiZcruA', 1575291802),
(3839, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzUzMDQ4MDcsImV4cCI6MTU3NTMwNjYwNywicGVybWlzc2lvbiI6IiJ9.qEN2PsReTf76yxyGwxEFiSqZp6sAqvax9Bym5OTP9aE', 1575306607),
(3841, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3NTMwNDkxMywiZXhwIjoxNTc1MzA2NzEzLCJwZXJtaXNzaW9uIjoiIn0.7MLxU2IrvXa329iCnu-bHuVnVi5g61_pYXu5O3PuBak', 1575306713),
(3845, 2109, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA5IiwidXNlcm1haWwiOiJmaWxpcGVnQHVhLnB0IiwiaWF0IjoxNTc1MzA5MzIxLCJleHAiOjE1NzUzMTExMjEsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.RG8KXpswF_EdtBITCG8BOr1O8pYJ2z3V3YQicF2gj0I', 1575311121),
(3847, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc1MzExMzQ3LCJleHAiOjE1NzUzMTMxNDcsInBlcm1pc3Npb24iOiIifQ.nAxEIx49FeeVQOeDV3802PYjJiiJWTb4Olu7VJvpH3I', 1575313147),
(3851, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTc1MzE3NDA2LCJleHAiOjE1NzUzMTkyMDYsInBlcm1pc3Npb24iOiIifQ.3ZalX3N-xYMMSELLhunPWdxSlgPQqi-zCEM4e8mcDGI', 1575319206),
(3855, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU3NTMyMjUwOSwiZXhwIjoxNTc1MzI0MzA5LCJwZXJtaXNzaW9uIjoiIn0.Jeul1qgC9ViCyku0_EPdsu7JCPwOGF9Bm0ASNb_RFOU', 1575324309),
(3857, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU3NTMyMjUzNSwiZXhwIjoxNTc1MzI0MzM1LCJwZXJtaXNzaW9uIjoiIn0.wLTx7vnwVBWoa1ImeFN5TVpZPZcD4e5iFlfD_4h1vl4', 1575324335),
(3859, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc1MzI0NDQzLCJleHAiOjE1NzUzMjYyNDMsInBlcm1pc3Npb24iOiIifQ.SB4NM9E4jQO8Xto1xf_YcJ-nuPjBWOK9cf5ss9--LTk', 1575326243),
(3861, 2104, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA0IiwidXNlcm1haWwiOiJhZm9uc28uY2FtcG9zQHVhLnB0IiwiaWF0IjoxNTc1MzI1MTY1LCJleHAiOjE1NzUzMjY5NjUsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.5X2V1BP1pniU8thsvKBb6KmnI3t6M5sLcS0Q4NbnXo8', 1575326965),
(3865, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU3NTMyODA0NiwiZXhwIjoxNTc1MzI5ODQ2LCJwZXJtaXNzaW9uIjoiIn0.7NiM0TgB2wrlrNr8_zMnraDpduHWN5xubKxSigdLbSo', 1575329846),
(3867, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU3NTMyODE2NSwiZXhwIjoxNTc1MzI5OTY1LCJwZXJtaXNzaW9uIjoiIn0.2fi-NQbb0cqw-tDbOjnasxkmqNqZUF6t_a_8gT0-Iuc', 1575329965),
(3869, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTc1MzI4OTQwLCJleHAiOjE1NzUzMzA3NDAsInBlcm1pc3Npb24iOiIifQ.lSA7jIZlxCFoHbGxKuuKnF0xoN9TQzSter8YZyzodDk', 1575330740),
(3873, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU3NTMzNDExMCwiZXhwIjoxNTc1MzM1OTEwLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.L9_5IilCXjzMHemQBWkgvb0l1kUb4v9kYAur5SrHAM8', 1575335910),
(3877, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzUzNjg1OTAsImV4cCI6MTU3NTM3MDM5MCwicGVybWlzc2lvbiI6IiJ9.BvSiJCAzhIWbYCIS7nWzWaF3D0djGiR3_kNJLX0vdQE', 1575370390),
(3881, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc1MzcyODA2LCJleHAiOjE1NzUzNzQ2MDYsInBlcm1pc3Npb24iOiIifQ.ByuUMAtvDZnyOsEhVoA6Uh-x4x0WHsNxYQ7pFDBZujM', 1575374606),
(3885, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTc1Mzc1NzE5LCJleHAiOjE1NzUzNzc1MTksInBlcm1pc3Npb24iOiIifQ.DhRvb2MNGA02XeaTVhXBo2gL78ksXQjDcjKVznv8n-M', 1575377519),
(3887, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc1Mzc2NzE3LCJleHAiOjE1NzUzNzg1MTcsInBlcm1pc3Npb24iOiIifQ.zEEDt3k9cOXskfCtZ6LpGQ3l3gTuBSpvXD-ohgQcbp8', 1575378517),
(3891, 1356, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU2IiwidXNlcm1haWwiOiJpdm9hbmdlbGljb0B1YS5wdCIsImlhdCI6MTU3NTM4NTkxOSwiZXhwIjoxNTc1Mzg3NzE5LCJwZXJtaXNzaW9uIjoiIn0.-N3n4wgjlFfqjtMxuWBoje2OX3rs33Z9_GO_8zZc5B8', 1575387719),
(3893, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU3NTM4NjE0MCwiZXhwIjoxNTc1Mzg3OTQwLCJwZXJtaXNzaW9uIjoiIn0.PO885dQ9qamzBCN-tpJePru1TdeGoZWsrnAiLMYRyNE', 1575387940),
(3895, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU3NTM4NzY1NSwiZXhwIjoxNTc1Mzg5NDU1LCJwZXJtaXNzaW9uIjoiIn0.NlgjaTVnIwPSmz8Gwd32YHyriff4QLmfBfj9T4BeYlc', 1575389455),
(3899, 1149, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTQ5IiwidXNlcm1haWwiOiJkaW9nby5nQHVhLnB0IiwiaWF0IjoxNTc1Mzk1MzgwLCJleHAiOjE1NzUzOTcxODAsInBlcm1pc3Npb24iOiIifQ.UJaIMxVT8UWnZIfmhZXV3jGfK--5VcG0yvZbipEoSgc', 1575397180),
(3901, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc1Mzk3NzM5LCJleHAiOjE1NzUzOTk1MzksInBlcm1pc3Npb24iOiIifQ.6esWkZCmXI3WAwZSl-1L_IY_iuwqIEGBB-cnhxE8BIg', 1575399539),
(3905, 1701, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzAxIiwidXNlcm1haWwiOiJwLnNlaXhhczk2QHVhLnB0IiwiaWF0IjoxNTc1NDA1MTAxLCJleHAiOjE1NzU0MDY5MDEsInBlcm1pc3Npb24iOiIifQ.LIFQ4AXgIUMqDx3ZO_nozh444E_PkWFuy3NqndJiIqA', 1575406901),
(3909, 2050, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUwIiwidXNlcm1haWwiOiJqb3NldHJpZ29AdWEucHQiLCJpYXQiOjE1NzU0MTI4ODUsImV4cCI6MTU3NTQxNDY4NSwicGVybWlzc2lvbiI6IiJ9.mhuengw6xdn5C2kA1ELfB_7uMVSlGypK1mP2lIrcgjI', 1575414685),
(3911, 2074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc0IiwidXNlcm1haWwiOiJ2aWNlbnRlLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTc1NDE0MTg2LCJleHAiOjE1NzU0MTU5ODYsInBlcm1pc3Npb24iOiIifQ.OyIUd2zCiJh6JzUkIQtszAF1PsNAFzMhrf91vAphYlI', 1575415986),
(3915, 2074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc0IiwidXNlcm1haWwiOiJ2aWNlbnRlLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTc1NDE5NzQ2LCJleHAiOjE1NzU0MjE1NDYsInBlcm1pc3Npb24iOiIifQ.PFNPiVh9pAuZzkC___ss8LzgI5c30B9DzActhRr4l_M', 1575421546),
(3919, 1287, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjg3IiwidXNlcm1haWwiOiJnb25jYWxvcGFzc29zQHVhLnB0IiwiaWF0IjoxNTc1NDUxNDAyLCJleHAiOjE1NzU0NTMyMDIsInBlcm1pc3Npb24iOiIifQ.UH9oMxWhIbje2HUH5nc2URZ7yOvm6LeJSo53MfBdmFk', 1575453202),
(3923, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU3NTQ1NDIyMywiZXhwIjoxNTc1NDU2MDIzLCJwZXJtaXNzaW9uIjoiIn0.mejVnqcB3kNUVdV3EvT5HUDkKIRKOfgsXwXKZ-s130c', 1575456023),
(3925, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU3NTQ1NTk2NSwiZXhwIjoxNTc1NDU3NzY1LCJwZXJtaXNzaW9uIjoiIn0.JkP7S-Ji2HPmqeU1dh5ptt4cT9yHMwQyTOuSHCUcofk', 1575457765),
(3929, 2109, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA5IiwidXNlcm1haWwiOiJmaWxpcGVnQHVhLnB0IiwiaWF0IjoxNTc1NDU5MTMzLCJleHAiOjE1NzU0NjA5MzMsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.yXHs21aEmOhQSBj_n_Xh-c7lDeVgNyDVYMfpBARyjL8', 1575460933),
(3931, 2053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUzIiwidXNlcm1haWwiOiJtYXJ0aW5oby50YXZhcmVzQHVhLnB0IiwiaWF0IjoxNTc1NDU5NDM1LCJleHAiOjE1NzU0NjEyMzUsInBlcm1pc3Npb24iOiIifQ.I1HEpbIwDQ_tl54bRpTIAi3B9ekdM5s66i2Ueosv3xk', 1575461235),
(3935, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzU0ODE4NzUsImV4cCI6MTU3NTQ4MzY3NSwicGVybWlzc2lvbiI6IiJ9.0R6OiBrTUA3M5-34DDUNNPQR49-denUQEV7EW9iWytQ', 1575483675),
(3939, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc1NDg1NDkwLCJleHAiOjE1NzU0ODcyOTAsInBlcm1pc3Npb24iOiIifQ.BERfPl7i7YOdc-tSyKQGhcDtFLmvz5bctp8r-Nu4mCc', 1575487290),
(3943, 2074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc0IiwidXNlcm1haWwiOiJ2aWNlbnRlLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTc1NDk0NzE4LCJleHAiOjE1NzU0OTY1MTgsInBlcm1pc3Npb24iOiIifQ.eLJG_FaH1zEBxkN4BaLdrep9V03cgGvsg8aPGl2dJ24', 1575496518),
(3945, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzU0OTYwMjUsImV4cCI6MTU3NTQ5NzgyNSwicGVybWlzc2lvbiI6IiJ9.3TJTEYFl0Ul6_a3mhiXEusPz4W-sjlJ6gMZprGeibZQ', 1575497825),
(3947, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTc1NDk2NjAwLCJleHAiOjE1NzU0OTg0MDAsInBlcm1pc3Npb24iOiIifQ.I79deiIKSEEITtz158ofA3SjfkAqYG-tEsrzlNA-LQQ', 1575498400),
(3951, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1NzU1MDE3MDIsImV4cCI6MTU3NTUwMzUwMiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.cFein9fba7Ye4cDyHXmrm2gvVIXDuvHQ88kVoIniBq4', 1575503502),
(3953, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3NTUwMjIxMywiZXhwIjoxNTc1NTA0MDEzLCJwZXJtaXNzaW9uIjoiIn0.b7E4Lj82HD915-SM4tDUFBNQ9DxLCCsy7S_tbH5ggEU', 1575504013),
(3957, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3NTU0NDUyMywiZXhwIjoxNTc1NTQ2MzIzLCJwZXJtaXNzaW9uIjoiIn0.A9ZPF2bvE1eDJfKafZYWoKwGsVDxgK4q6MiXX2CvRu4', 1575546323),
(3961, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc1NTQ2OTM5LCJleHAiOjE1NzU1NDg3MzksInBlcm1pc3Npb24iOiIifQ.nTQPn9KbceX-JHr6vCcOiocBQToGCqEFmsxG15Vip4Y', 1575548739),
(3963, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3NTU0ODI5NywiZXhwIjoxNTc1NTUwMDk3LCJwZXJtaXNzaW9uIjoiIn0.7QqH4SbG92F6rLrzz_PM1xwytR2Bl5rDXTrjNaHSkTM', 1575550097);
INSERT INTO `GenTokens` (`id`, `userid`, `token`, `expire_date`) VALUES
(3965, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTc1NTQ4ODU4LCJleHAiOjE1NzU1NTA2NTgsInBlcm1pc3Npb24iOiIifQ.8SKhQ6dGWYkRNfNpsMvFKDbvqEZ0LoLmk89ZWSKFX6w', 1575550658),
(3969, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU3NTU1OTkzMSwiZXhwIjoxNTc1NTYxNzMxLCJwZXJtaXNzaW9uIjoiIn0.oo2QzOu_pvYsyeW6-6On7zo7fBkrsBlDS4iTypu36RA', 1575561731),
(3971, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3NTU2MDgzNywiZXhwIjoxNTc1NTYyNjM3LCJwZXJtaXNzaW9uIjoiIn0.Juf4Gpwaz4_T7hNIn09h09pHOQ5vlnTh5FJvpFUYbiU', 1575562637),
(3975, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc1NTY0MTQwLCJleHAiOjE1NzU1NjU5NDAsInBlcm1pc3Npb24iOiIifQ.pvsV1ygeztxR1f7QCTM853EBMZ_5vq7XoFgU4fXGfMk', 1575565940),
(3977, 2025, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI1IiwidXNlcm1haWwiOiJhbmRyZWlhLnBvcnRlbGFAdWEucHQiLCJpYXQiOjE1NzU1NjQxODYsImV4cCI6MTU3NTU2NTk4NiwicGVybWlzc2lvbiI6IiJ9.6HBTxe4923ffL9jmlNN202KYGgU9L0rUpYmHMu1Ntug', 1575565986),
(3981, 2025, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI1IiwidXNlcm1haWwiOiJhbmRyZWlhLnBvcnRlbGFAdWEucHQiLCJpYXQiOjE1NzU1Nzc1NzYsImV4cCI6MTU3NTU3OTM3NiwicGVybWlzc2lvbiI6IiJ9.69GTOwWoKuSKvDJLuQuYRmxpoHBr3PeoQcfVnJVTQKg', 1575579376),
(3985, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc1NTgxMTAyLCJleHAiOjE1NzU1ODI5MDIsInBlcm1pc3Npb24iOiIifQ.ZNlnSzPNYFdSxrQH0ThBo_jy2zX-kfkczAr6gw1f8wA', 1575582902),
(3987, 2047, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ3IiwidXNlcm1haWwiOiJqb2FvcmVpczE2QHVhLnB0IiwiaWF0IjoxNTc1NTgxNTY3LCJleHAiOjE1NzU1ODMzNjcsInBlcm1pc3Npb24iOiIifQ.HVsclzWEDfCNRIRR96vp-oK9SJ3RKlM22-OvxaXW9WQ', 1575583367),
(3989, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc1NTgzNjA5LCJleHAiOjE1NzU1ODU0MDksInBlcm1pc3Npb24iOiIifQ.bdoFUytnhyr57YsgypvNPJlcoa6q-fswaSgKBS0GWLE', 1575585409),
(3991, 2104, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA0IiwidXNlcm1haWwiOiJhZm9uc28uY2FtcG9zQHVhLnB0IiwiaWF0IjoxNTc1NTgzNjY2LCJleHAiOjE1NzU1ODU0NjYsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.y6RziqBW55x9CyuytS8Ex50HQ1rRgNhyfbvzOgtGYaU', 1575585466),
(3993, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc1NTg0MzQ1LCJleHAiOjE1NzU1ODYxNDUsInBlcm1pc3Npb24iOiIifQ.5ixZ3o8JjmjLOFYb0I-Zbbo7ezeyFRdYE0qQhUD0ByE', 1575586145),
(3997, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc1NTk0NTM3LCJleHAiOjE1NzU1OTYzMzcsInBlcm1pc3Npb24iOiIifQ.xWoDcqLp3FOZvn3FXkcxuVLzVi0x0fQWxmMU_IaaNSA', 1575596337),
(4001, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzU2MjQxNDEsImV4cCI6MTU3NTYyNTk0MSwicGVybWlzc2lvbiI6IiJ9.5bIU_K_TQmTeb8Dc-z_xqnC7KG_3vxas0x25w2pXxyM', 1575625941),
(4003, 2046, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ2IiwidXNlcm1haWwiOiJpc2FiZWwucm9zYXJpb0B1YS5wdCIsImlhdCI6MTU3NTYyNDM0NCwiZXhwIjoxNTc1NjI2MTQ0LCJwZXJtaXNzaW9uIjoiIn0.yMnG1RtPBzngJ7yalzSDEDnGGEHx-66P_B_Ywnc96A8', 1575626144),
(4007, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc1NjMwNjY2LCJleHAiOjE1NzU2MzI0NjYsInBlcm1pc3Npb24iOiIifQ.J_O6EwlTsD9CtL63vALNSwKbAnts4F39o6vs-87i-WU', 1575632466),
(4009, 2104, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA0IiwidXNlcm1haWwiOiJhZm9uc28uY2FtcG9zQHVhLnB0IiwiaWF0IjoxNTc1NjMxMzU0LCJleHAiOjE1NzU2MzMxNTQsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.qZJdUUWBLWCUWea0IxTXGQmFoL1vq-NjjxvVoOdUtPU', 1575633154),
(4011, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc1NjMxNjMwLCJleHAiOjE1NzU2MzM0MzAsInBlcm1pc3Npb24iOiIifQ.JmBKQtji-vyrV9xh-zKkJo3SIjc-nhzpaJRmdPy3I34', 1575633430),
(4013, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc1NjMxOTkyLCJleHAiOjE1NzU2MzM3OTIsInBlcm1pc3Npb24iOiIifQ.g9d0-HVa2nU8u-LuLLNFavCOix2eRav3q4ePXccuDw4', 1575633792),
(4017, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTc1NjM4OTQwLCJleHAiOjE1NzU2NDA3NDAsInBlcm1pc3Npb24iOiIifQ.3-mKKUpYOX4oDtuhFyCL9rH77NMsIGrZrZ5Pr0NLVng', 1575640740),
(4021, 2025, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI1IiwidXNlcm1haWwiOiJhbmRyZWlhLnBvcnRlbGFAdWEucHQiLCJpYXQiOjE1NzU2NDE4OTksImV4cCI6MTU3NTY0MzY5OSwicGVybWlzc2lvbiI6IiJ9.Vb9OLwuiqAuFRFn8arkF3RcvQBV7eOvNXqnJ8YOyTxc', 1575643699),
(4023, 2046, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ2IiwidXNlcm1haWwiOiJpc2FiZWwucm9zYXJpb0B1YS5wdCIsImlhdCI6MTU3NTY0MTk0NywiZXhwIjoxNTc1NjQzNzQ3LCJwZXJtaXNzaW9uIjoiIn0.y_zlH2VJkjejFOtMYJKfJU4xyDMaLsnHNsKF1GYoujw', 1575643747),
(4025, 2046, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ2IiwidXNlcm1haWwiOiJpc2FiZWwucm9zYXJpb0B1YS5wdCIsImlhdCI6MTU3NTY0MTk4MCwiZXhwIjoxNTc1NjQzNzgwLCJwZXJtaXNzaW9uIjoiIn0.E1Arx8w6bhYd-lpxVRKubtF16EVdx79tbhZ0py02YoI', 1575643780),
(4029, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc1NjU0MjE3LCJleHAiOjE1NzU2NTYwMTcsInBlcm1pc3Npb24iOiIifQ.uH0gbqu8LmkKCq2qjQ294E09U4sYdMgS44Fppy3kL2I', 1575656017),
(4031, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU3NTY1NjA0NiwiZXhwIjoxNTc1NjU3ODQ2LCJwZXJtaXNzaW9uIjoiIn0.xnxHD-62LaI-A2-3jt2y_6GoYrzl5oeeCt-i15yP3TE', 1575657846),
(4033, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTc1NjU5NTM4LCJleHAiOjE1NzU2NjEzMzgsInBlcm1pc3Npb24iOiIifQ.6KHyuLrNQckXti368YY5i1sYCEqLUlM5oogVciioI4g', 1575661338),
(4035, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc1NjYwMzkyLCJleHAiOjE1NzU2NjIxOTIsInBlcm1pc3Npb24iOiIifQ.Mnc0x2PtlyG3FaoDPvExdD134SBwHAt5paIZEbkR1ws', 1575662192),
(4039, 1512, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTEyIiwidXNlcm1haWwiOiJqcnNybUB1YS5wdCIsImlhdCI6MTU3NTY2NTM2NiwiZXhwIjoxNTc1NjY3MTY2LCJwZXJtaXNzaW9uIjoiIn0.Daxw7guAc2-LXsVJ0m1Dp3dgsh_BAfRAeaYMznE3j3g', 1575667166),
(4043, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzU2NzUzMDIsImV4cCI6MTU3NTY3NzEwMiwicGVybWlzc2lvbiI6IiJ9.8-fYdbSFnHqSKrgzJVeyo90h-kzBznIFtty46zSyUho', 1575677102),
(4047, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU3NTY4NDg4OSwiZXhwIjoxNTc1Njg2Njg5LCJwZXJtaXNzaW9uIjoiIn0.yThOgY2LHG0D8tJbs5uH8yVs8MdQWOCAgIe_5BNx3u4', 1575686689),
(4051, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3NTcyMDAzNCwiZXhwIjoxNTc1NzIxODM0LCJwZXJtaXNzaW9uIjoiIn0.i9ixpOdqrIddH5nqyyDg1gjM6_AzxK7g96tUMjknOwA', 1575721834),
(4053, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzU3MjE4MTAsImV4cCI6MTU3NTcyMzYxMCwicGVybWlzc2lvbiI6IiJ9.bq0mC5EF4M-vKNJzUZEmBIHmunjpEg9YhowyecyU1CE', 1575723610),
(4055, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc1NzIzOTEyLCJleHAiOjE1NzU3MjU3MTIsInBlcm1pc3Npb24iOiIifQ.BpB4YUC2dhxSDDW8UwHD97hC6FMSUW1hK4e6iZAzd38', 1575725712),
(4057, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU3NTcyNDk1NCwiZXhwIjoxNTc1NzI2NzU0LCJwZXJtaXNzaW9uIjoiIn0.G3LW1RNk9lUAuJmY_k9UsnauEwwDzkVpoUeShlsF-tM', 1575726754),
(4059, 1122, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTIyIiwidXNlcm1haWwiOiJkZmFjQHVhLnB0IiwiaWF0IjoxNTc1NzI2NzU1LCJleHAiOjE1NzU3Mjg1NTUsInBlcm1pc3Npb24iOiIifQ.x31y9y7lRkupCcRwxDuYWVdTQoEPAuM7NJ5jcCgV3D8', 1575728555),
(4061, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3NTcyNjc1NiwiZXhwIjoxNTc1NzI4NTU2LCJwZXJtaXNzaW9uIjoiIn0.HORpj3fuFwgWC3QCuCqmfuU4-jVKbpaabxVdmTW8CnM', 1575728556),
(4063, 2057, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU3IiwidXNlcm1haWwiOiJwbWQ4QHVhLnB0IiwiaWF0IjoxNTc1NzMwMDg1LCJleHAiOjE1NzU3MzE4ODUsInBlcm1pc3Npb24iOiIifQ.iWZhQLCvyMi9H7-JgpbKZ0adDmoum87XC-D_MwjgE2I', 1575731885),
(4065, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzU3MzM5NjEsImV4cCI6MTU3NTczNTc2MSwicGVybWlzc2lvbiI6IiJ9.V7W5DT-uGbmbYE1lBtrIMMLCGsgGVWvLThnw8TzVyJ4', 1575735761),
(4067, 2028, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI4IiwidXNlcm1haWwiOiJjZmZvbnNlY2FAdWEucHQiLCJpYXQiOjE1NzU3MzY4MDEsImV4cCI6MTU3NTczODYwMSwicGVybWlzc2lvbiI6IiJ9.YNDrbdPONt5JRTNBNuDBo-fyww1I4c3z2O_ZxmBj0Bc', 1575738601),
(4071, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzU3NDA2NDYsImV4cCI6MTU3NTc0MjQ0NiwicGVybWlzc2lvbiI6IiJ9.rFCN8ZG4ZJryvbcLrn5G1SCwmQFDkOdlXIQApr0DY6o', 1575742446),
(4073, 1200, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjAwIiwidXNlcm1haWwiOiJlZHVhcmRvc2FudG9zaGZAdWEucHQiLCJpYXQiOjE1NzU3NDI3MTksImV4cCI6MTU3NTc0NDUxOSwicGVybWlzc2lvbiI6IiJ9.HBTXdq_GTduS1KfG4s9EVFBvR5zm55cyKy6J1n-_CHc', 1575744519),
(4077, 2055, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU1IiwidXNlcm1haWwiOiJtaWd1ZWwuci5mZXJyZWlyYUB1YS5wdCIsImlhdCI6MTU3NTc1MjQ1OCwiZXhwIjoxNTc1NzU0MjU4LCJwZXJtaXNzaW9uIjoiIn0.Zlt7-CM4IYVZVdqsVT337XirAp7N3mCRPn1STLeUWAw', 1575754258),
(4079, 2025, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI1IiwidXNlcm1haWwiOiJhbmRyZWlhLnBvcnRlbGFAdWEucHQiLCJpYXQiOjE1NzU3NTI5OTQsImV4cCI6MTU3NTc1NDc5NCwicGVybWlzc2lvbiI6IiJ9.9b5FZw8jxcTSvbYfSJP221zDJsZTaJ6AlxWHGZb9u40', 1575754794),
(4083, 1026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDI2IiwidXNlcm1haWwiOiJjYXJvbGluYXJlc2VuZGVtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTc1NzU4ODk0LCJleHAiOjE1NzU3NjA2OTQsInBlcm1pc3Npb24iOiIifQ.cJoEl-L4djcfCnMPhxHjlTyXSzVStue-xQSk4niLuJw', 1575760694),
(4085, 2047, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ3IiwidXNlcm1haWwiOiJqb2FvcmVpczE2QHVhLnB0IiwiaWF0IjoxNTc1NzYxNDgwLCJleHAiOjE1NzU3NjMyODAsInBlcm1pc3Npb24iOiIifQ.YAZBVPD-AjOAGlKKUyt-2kVKBJ9v7PNO7mLgB-d85j4', 1575763280),
(4087, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTc1NzYyNDY4LCJleHAiOjE1NzU3NjQyNjgsInBlcm1pc3Npb24iOiIifQ._LXemf5ullo8hKq0Ln9xjceHLhVjVDj35QK7qvYyAz0', 1575764268),
(4091, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzU4MDMxMDgsImV4cCI6MTU3NTgwNDkwOCwicGVybWlzc2lvbiI6IiJ9._7sdyeBxdai2x5VufbiKhGHY_BKcwdi9trVA66LbZ3M', 1575804908),
(4093, 1701, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzAxIiwidXNlcm1haWwiOiJwLnNlaXhhczk2QHVhLnB0IiwiaWF0IjoxNTc1ODA2MTY5LCJleHAiOjE1NzU4MDc5NjksInBlcm1pc3Npb24iOiIifQ.j3wZjXY0ogf_STcJgtvdMLZZJav4o0_ZFldFEd_6kEA', 1575807969),
(4095, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc1ODA5NTQ3LCJleHAiOjE1NzU4MTEzNDcsInBlcm1pc3Npb24iOiIifQ.m7jLD77LvXCabXFEu6-HGQKNfY_v33LW1ozFHUdwUZw', 1575811347),
(4099, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1NzU4MjQ0MDcsImV4cCI6MTU3NTgyNjIwNywicGVybWlzc2lvbiI6IiJ9.JuGoEJtuMijm2hqs2RJfTDC-5NjoBq9VKhMhTRUb1_U', 1575826207),
(4101, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU3NTgyNTI4NSwiZXhwIjoxNTc1ODI3MDg1LCJwZXJtaXNzaW9uIjoiIn0.N68srIZzDqvsGAh3kADtWU0x8m4UoTH7xkDMKRpJSjQ', 1575827085),
(4103, 1722, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzIyIiwidXNlcm1haWwiOiJwZWRyby5taWd1ZWw1MEB1YS5wdCIsImlhdCI6MTU3NTgyNjI4MywiZXhwIjoxNTc1ODI4MDgzLCJwZXJtaXNzaW9uIjoiIn0.FHuy7jCgPq6tyRdmwvgszm6TUVSH4guH2nXSrGjC-5k', 1575828083),
(4107, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc1ODQ3OTAwLCJleHAiOjE1NzU4NDk3MDAsInBlcm1pc3Npb24iOiIifQ.eM0JBDgl5-jlTaImva043RXz9Trnm3ROab61FVSlV4w', 1575849700),
(4109, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1NzU4NDg4MzgsImV4cCI6MTU3NTg1MDYzOCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.F5mFTA9Ii_cvDG149__cABsZTJmvR9lAVODpiM1ual0', 1575850638),
(4111, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTc1ODQ5OTE3LCJleHAiOjE1NzU4NTE3MTcsInBlcm1pc3Npb24iOiIifQ.F5JI6uII4hzFiRo-W8M6wOVrWw-1x_lVGayl-FAL6jg', 1575851717),
(4115, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc1ODg1NDYzLCJleHAiOjE1NzU4ODcyNjMsInBlcm1pc3Npb24iOiIifQ.9GA8_rBmE4W58wWpl1QETPLyy4zraVkC8ZqD5Eo9-zw', 1575887263),
(4117, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU3NTg4NzQ2MywiZXhwIjoxNTc1ODg5MjYzLCJwZXJtaXNzaW9uIjoiIn0.Zf2H13Z3MG4jc3jqI3oq90Q_Lz40C3GJuGgGMHYnHeE', 1575889263),
(4121, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc1ODkxODU1LCJleHAiOjE1NzU4OTM2NTUsInBlcm1pc3Npb24iOiIifQ._ddVuVlhbzQpfMOj9e0Ag2FLkG4kFmSDEUYwmOtGUjE', 1575893655),
(4125, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1NzU5MDE0NjgsImV4cCI6MTU3NTkwMzI2OCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.SHqiVCS9THojJ1Zazv3yAVdP9_acrMNpcMfSPXZRYBs', 1575903268),
(4129, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTc1OTA5MzQzLCJleHAiOjE1NzU5MTExNDMsInBlcm1pc3Npb24iOiIifQ.xA5gQpyQqvUqDV6kkUr5uOMfpm85L0nJbO-nF4j49rc', 1575911143),
(4133, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc1OTEzNTMyLCJleHAiOjE1NzU5MTUzMzIsInBlcm1pc3Npb24iOiIifQ.fjZ56mBUs1NW5B0EVEAwAsAu05XiEeHCu2S9q6aPODs', 1575915332),
(4137, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc1OTI1NDQzLCJleHAiOjE1NzU5MjcyNDMsInBlcm1pc3Npb24iOiIifQ.DuXc8hp4KGvyi0fOYvzzCRDcwFeCowCnDIPRGuebUhE', 1575927243),
(4139, 1350, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzUwIiwidXNlcm1haWwiOiJpc2Fkb3JhLmZsQHVhLnB0IiwiaWF0IjoxNTc1OTI2MzkwLCJleHAiOjE1NzU5MjgxOTAsInBlcm1pc3Npb24iOiIifQ.bY44fRtum4HKddJHrPwkUvVG9UOcOeHWBAFCCoVXnh0', 1575928190),
(4141, 1956, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTU2IiwidXNlcm1haWwiOiJ0aWFnby5zcnYub2xpdmVpcmFAdWEucHQiLCJpYXQiOjE1NzU5Mjc5OTIsImV4cCI6MTU3NTkyOTc5MiwicGVybWlzc2lvbiI6IiJ9.1MMeuwQ29x3iup60Fu70eTUW4JyFGzgmcsVgngSca_U', 1575929792),
(4145, 1827, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODI3IiwidXNlcm1haWwiOiJyaWNhcmRvLmNydXoyOUB1YS5wdCIsImlhdCI6MTU3NTkzODEwNywiZXhwIjoxNTc1OTM5OTA3LCJwZXJtaXNzaW9uIjoiIn0.S70NUCG6mBLELc5g8720ngXEJ7bgn3HFIO7O1Wte_Gc', 1575939907),
(4147, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc1OTQwMzgwLCJleHAiOjE1NzU5NDIxODAsInBlcm1pc3Npb24iOiIifQ.fR47V-B84WDmOpxF8kh4n_Z9VrTqKPYAMHykzMwJFNo', 1575942180),
(4151, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc1OTQ0NDE3LCJleHAiOjE1NzU5NDYyMTcsInBlcm1pc3Npb24iOiIifQ.LHEWYNH2UzE018RN1jwA-GwPFbPqGKaPu-clnfGXLF4', 1575946217),
(4155, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1NzU5NzAyOTYsImV4cCI6MTU3NTk3MjA5NiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.j-f9R6wg2NHgwtGdQf0OKiGS6G6vlRckLIe3tEWHVro', 1575972096),
(4157, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1NzU5NzIwMDMsImV4cCI6MTU3NTk3MzgwMywicGVybWlzc2lvbiI6IiJ9.B-tDIjyjjdOPhDGIJ0bVlxPfTUCtbX9PojPov2NUclQ', 1575973803),
(4161, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1NzU5ODIzOTYsImV4cCI6MTU3NTk4NDE5NiwicGVybWlzc2lvbiI6IiJ9.kNIiaedIxJkJKaTnfh6ttv2qfn4zzdfhnnPB7RRsfeI', 1575984196),
(4165, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1NzU5ODY1MjIsImV4cCI6MTU3NTk4ODMyMiwicGVybWlzc2lvbiI6IiJ9.jIY63tGvdaCv5E02ESGrSI9ZMPVJYUF6Q3wW_2rfUaQ', 1575988322),
(4167, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzU5ODg0NzcsImV4cCI6MTU3NTk5MDI3NywicGVybWlzc2lvbiI6IiJ9.fxnnLUARs31luI2ZlyKDORiTIpr9QpRw3yXHlYliyHQ', 1575990277),
(4171, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU3NTk5NDY2OSwiZXhwIjoxNTc1OTk2NDY5LCJwZXJtaXNzaW9uIjoiIn0.3rhJJmxl_GBLc8Az2A7O2vEsZu8xzGLEy9cFyU25WBc', 1575996469),
(4173, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1NzU5OTQ4NTEsImV4cCI6MTU3NTk5NjY1MSwicGVybWlzc2lvbiI6IiJ9.JCIsA5WtZYzKFMqVAxTkQeKiI-VylPNkar3KebZ_I24', 1575996651),
(4177, 2036, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM2IiwidXNlcm1haWwiOiJkaW9nb21mc2lsdmE5OEB1YS5wdCIsImlhdCI6MTU3NjAxODczNiwiZXhwIjoxNTc2MDIwNTM2LCJwZXJtaXNzaW9uIjoiIn0.OtTHtWixCxT8muOYaksbujHRKhP5RqFfwy22p9V5iT0', 1576020536),
(4179, 1521, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTIxIiwidXNlcm1haWwiOiJsZWFuZHJvc2lsdmExMkB1YS5wdCIsImlhdCI6MTU3NjAxOTkyNywiZXhwIjoxNTc2MDIxNzI3LCJwZXJtaXNzaW9uIjoiIn0.u0L4t3tlbQEFCSX-bd9IMHdZ9ibiuX3lRgdlgsPhYVw', 1576021727),
(4183, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc2MDU3MDU1LCJleHAiOjE1NzYwNTg4NTUsInBlcm1pc3Npb24iOiIifQ.FPZmtJlIILTQ2enxj3hkaWWELZ-OYP0kuMjuZMIX91I', 1576058855),
(4185, 2016, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDE2IiwidXNlcm1haWwiOiJ3ZWl5ZUB1YS5wdCIsImlhdCI6MTU3NjA1ODE1NCwiZXhwIjoxNTc2MDU5OTU0LCJwZXJtaXNzaW9uIjoiIn0.6_aE6wx7E4vCSsmBT-jQU-OJy_9nDflKpSfZb6xesl8', 1576059954),
(4189, 993, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTMiLCJ1c2VybWFpbCI6ImJydW5vc2JAdWEucHQiLCJpYXQiOjE1NzYwNjExNDcsImV4cCI6MTU3NjA2Mjk0NywicGVybWlzc2lvbiI6IiJ9.G8v-8IMVgdVHN7564Lvkj6E-V82wHEYvtlbkyXJClng', 1576062947),
(4193, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTc2MDcxNDMyLCJleHAiOjE1NzYwNzMyMzIsInBlcm1pc3Npb24iOiIifQ.v3f3lu8YmiZcDrgnVp4mXB9roQ-WxwnAm6Vf-YaILxQ', 1576073232),
(4195, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3NjA3MjMzMSwiZXhwIjoxNTc2MDc0MTMxLCJwZXJtaXNzaW9uIjoiIn0.-yO_nYbpUKJuLj8FBSwrQX8kYOvSijcr0lOoixPmqvc', 1576074131),
(4197, 1761, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzYxIiwidXNlcm1haWwiOiJwZWRyb21tQHVhLnB0IiwiaWF0IjoxNTc2MDcyNDM0LCJleHAiOjE1NzYwNzQyMzQsInBlcm1pc3Npb24iOiIifQ.0HF1dVHBhmSo5vcuo6_XY9d38IsOgnuyOZtfN8HkRrY', 1576074234),
(4199, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU3NjA3MzkyOSwiZXhwIjoxNTc2MDc1NzI5LCJwZXJtaXNzaW9uIjoiIn0.1dB20dPxwvUBqlpxFgpBsbw7mlkI8WTJAzg870MnQ8M', 1576075729),
(4203, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1NzYwNzg3MjQsImV4cCI6MTU3NjA4MDUyNCwicGVybWlzc2lvbiI6IiJ9.YpjkJaVexfyZ6792EnU6YRWL07idpCIDeEGwpy-Dyzw', 1576080524),
(4205, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1NzYwNzkxOTIsImV4cCI6MTU3NjA4MDk5MiwicGVybWlzc2lvbiI6IiJ9.k9zY8b_3XcfFt4xPIi4qbkVi0I7Iwc-cC3G80mQNHa0', 1576080992),
(4207, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3NjA3OTIzNywiZXhwIjoxNTc2MDgxMDM3LCJwZXJtaXNzaW9uIjoiIn0.VXpgmtyiOvIqpFnM4H2jGpWya5QbRvsLziyAvi0tpbc', 1576081037),
(4211, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU3NjA5MTUwMywiZXhwIjoxNTc2MDkzMzAzLCJwZXJtaXNzaW9uIjoiIn0.Oshss4ShVcx7xbKFjlZbuKQ757oQtP-Fx_qy7dvdNFE', 1576093303),
(4215, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU3NjA5NTM2NCwiZXhwIjoxNTc2MDk3MTY0LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.9lLSO7hhvmTNDlirsSpPPEndXGZYiROEN7MGRhwQk84', 1576097164),
(4217, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1NzYwOTc5NTUsImV4cCI6MTU3NjA5OTc1NSwicGVybWlzc2lvbiI6IiJ9.XG6hZqaHdaP2KUbKyJYpKYat1GbKjf1tabcllTtF06w', 1576099755),
(4219, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1NzYwOTgzNDMsImV4cCI6MTU3NjEwMDE0MywicGVybWlzc2lvbiI6IiJ9.ghPn7uiHpMFaAfZzq2tqiS1mdAMx5Mp5z4MbndEAzXg', 1576100143),
(4223, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzYxNDExMzMsImV4cCI6MTU3NjE0MjkzMywicGVybWlzc2lvbiI6IiJ9.3ZxXRFVm7zQu4GKopAzFa5dXQOKPlmDtQJgqkUfYNb4', 1576142933),
(4225, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1NzYxNDI2NzYsImV4cCI6MTU3NjE0NDQ3NiwicGVybWlzc2lvbiI6IiJ9.OYVaXbw6IuQnoTUBODt6gvAuThQtDn_bUrn88M3EpOY', 1576144476),
(4229, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTc2MTUxNjU3LCJleHAiOjE1NzYxNTM0NTcsInBlcm1pc3Npb24iOiIifQ.iiL3Yk1na3eHW5Qml_FmHUxKmkUEUvrqt1VzP0R036k', 1576153457),
(4233, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc2MTU1NDY1LCJleHAiOjE1NzYxNTcyNjUsInBlcm1pc3Npb24iOiIifQ.R05jEjeq-UJrtfcgsVi217qj5fvWkPY6hmmflswjwkM', 1576157265),
(4235, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzYxNTU2OTksImV4cCI6MTU3NjE1NzQ5OSwicGVybWlzc2lvbiI6IiJ9.HsA5vz0T-ek6cEISSNoMU1Z77LRmiHALqmhuNNmYTr0', 1576157499),
(4239, 1473, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDczIiwidXNlcm1haWwiOiJqb3NlLnZhekB1YS5wdCIsImlhdCI6MTU3NjE2MzM5NiwiZXhwIjoxNTc2MTY1MTk2LCJwZXJtaXNzaW9uIjoiIn0.2H3ARgdroJb_PhrpTRG_gS2ZK8o2FP9tWWneNMWg-2Y', 1576165196),
(4241, 1758, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzU4IiwidXNlcm1haWwiOiJwZWRyb21nc291dG9AdWEucHQiLCJpYXQiOjE1NzYxNjQzMzgsImV4cCI6MTU3NjE2NjEzOCwicGVybWlzc2lvbiI6IiJ9.6ZrUxUICyEsHXp_D6w0xzIvqHke4FpCkp-q2EQgILvE', 1576166138),
(4243, 1146, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTQ2IiwidXNlcm1haWwiOiJkaW9nby5lLm1vcmVpcmFAdWEucHQiLCJpYXQiOjE1NzYxNjQ4MzEsImV4cCI6MTU3NjE2NjYzMSwicGVybWlzc2lvbiI6IiJ9.N2JEGNR_yetqGDLofIhNA2qz0hfbLVw6YbagnUP4gjM', 1576166631),
(4247, 1542, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTQyIiwidXNlcm1haWwiOiJsdWlzLnBpbnRvLnBlcmVpcmFAdWEucHQiLCJpYXQiOjE1NzYxNjg1MTEsImV4cCI6MTU3NjE3MDMxMSwicGVybWlzc2lvbiI6IiJ9.LKktfDnt09IwVv3jcyoVdqh866NezonGLU_DoX1r2V0', 1576170311),
(4249, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1NzYxNzA1NzcsImV4cCI6MTU3NjE3MjM3NywicGVybWlzc2lvbiI6IiJ9.n5iyMiQ8myOSlq8J-ZtPsMMMk8evPYOLB5npva0mvew', 1576172377),
(4253, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU3NjI2ODEyOCwiZXhwIjoxNTc2MjY5OTI4LCJwZXJtaXNzaW9uIjoiIn0._vhm5Yohf0bfdUQM4ZFPADsMVtrHuOiIzq3tWXwemGk', 1576269928),
(4257, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc2Mjc1NTkwLCJleHAiOjE1NzYyNzczOTAsInBlcm1pc3Npb24iOiIifQ.k0AEq_wA7y7pP-8gosOaJI8a2dySvP9nI5HlapKe_cM', 1576277390),
(4259, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc2Mjc5NTkzLCJleHAiOjE1NzYyODEzOTMsInBlcm1pc3Npb24iOiIifQ.s44GQdJiL9bZPoSgjB_YS7KpMQ7PTXCRSOvTzlqnf58', 1576281393),
(4263, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU3NjMxNzc1MCwiZXhwIjoxNTc2MzE5NTUwLCJwZXJtaXNzaW9uIjoiIn0.vmBJvjnTUUDUverbvwtVXAwbxS5sgUMyUZz5TnCOTPM', 1576319550),
(4267, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc2MzI3Njk5LCJleHAiOjE1NzYzMjk0OTksInBlcm1pc3Npb24iOiIifQ.Jc3dlbAz7bh32s4tLk0qww2s8OZnaoij4fk0zaDxSmU', 1576329499),
(4271, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTc2MzMyNDkzLCJleHAiOjE1NzYzMzQyOTMsInBlcm1pc3Npb24iOiIifQ.npWOqY1xMNqWEd26dqx8M-wcKcFXM26jhEAIJ9b11AU', 1576334293),
(4275, 1521, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTIxIiwidXNlcm1haWwiOiJsZWFuZHJvc2lsdmExMkB1YS5wdCIsImlhdCI6MTU3NjM0MjA3NiwiZXhwIjoxNTc2MzQzODc2LCJwZXJtaXNzaW9uIjoiIn0.z2l4SLEs-cou8_Y8PJKcwCP9H44FqFH593ef2Ct9FJ4', 1576343876),
(4277, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc2MzQzMTE0LCJleHAiOjE1NzYzNDQ5MTQsInBlcm1pc3Npb24iOiIifQ.qmapf4V6vf0cv-YSxFKkCPVPyKe_ZKAmWcX9O4zAc0w', 1576344914),
(4279, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1NzYzNDU2OTQsImV4cCI6MTU3NjM0NzQ5NCwicGVybWlzc2lvbiI6IiJ9.aXB8e229FNqy1NQ1CGMVgzBUGiHmhoPbu3nZF67Mqwk', 1576347494),
(4283, 1425, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDI1IiwidXNlcm1haWwiOiJqb2FvbWFkaWFzQHVhLnB0IiwiaWF0IjoxNTc2MzUyODI5LCJleHAiOjE1NzYzNTQ2MjksInBlcm1pc3Npb24iOiIifQ.Guq3xS6attSjop81diEBzx8laEgpFSE7ZWytB2_G818', 1576354629),
(4287, 1146, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTQ2IiwidXNlcm1haWwiOiJkaW9nby5lLm1vcmVpcmFAdWEucHQiLCJpYXQiOjE1NzYzNjY5MjgsImV4cCI6MTU3NjM2ODcyOCwicGVybWlzc2lvbiI6IiJ9.HElQnm7ykaLcwzPfJN3W3nvyPvqsg8xirPoUBjLxbPg', 1576368728),
(4291, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTc2NDI2ODQzLCJleHAiOjE1NzY0Mjg2NDMsInBlcm1pc3Npb24iOiIifQ.flgzb3w6_CAJq2XvqF03ebPFobfmJbvTa1xHkKkZj2w', 1576428643),
(4295, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc2NDQ1NTg2LCJleHAiOjE1NzY0NDczODYsInBlcm1pc3Npb24iOiIifQ.tvA6XIr8ZXxddZ6vzCoaisJTtaTpK6YDpk7_eGZ2dlY', 1576447386),
(4299, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc2NDUwMjc5LCJleHAiOjE1NzY0NTIwNzksInBlcm1pc3Npb24iOiIifQ.eGQSsiYkQAgcnFu7HTyQIK_5P8qZRdOUs2WjKhliJOo', 1576452079),
(4303, 1026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDI2IiwidXNlcm1haWwiOiJjYXJvbGluYXJlc2VuZGVtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTc2NTE1MzEyLCJleHAiOjE1NzY1MTcxMTIsInBlcm1pc3Npb24iOiIifQ.SqyWKdQyDNbv910lzy1XLtmWXE3q358DgYKMNr8iXHs', 1576517112),
(4305, 1815, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODE1IiwidXNlcm1haWwiOiJyZW5hbmFmZXJyZWlyYUB1YS5wdCIsImlhdCI6MTU3NjUxNTgzNiwiZXhwIjoxNTc2NTE3NjM2LCJwZXJtaXNzaW9uIjoiIn0.zmmzy7V1BTD6QSiHZTyAx5q5sDkMYFD4kj-2V3pxrZM', 1576517636),
(4307, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTc2NTE3MDE3LCJleHAiOjE1NzY1MTg4MTcsInBlcm1pc3Npb24iOiIifQ.qewCAVx6RHn8qIwkt8K17oAeDaraZTRGSsKmnYvnMM8', 1576518817),
(4311, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc2NTE5MTM3LCJleHAiOjE1NzY1MjA5MzcsInBlcm1pc3Npb24iOiIifQ.OVtbaioI23iM1U_81ptuf2XM3QdMymWns9boRoTLfsY', 1576520937),
(4315, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1NzY1MzIyODYsImV4cCI6MTU3NjUzNDA4NiwicGVybWlzc2lvbiI6IiJ9.fvX0nRZuiqbV9SfuM8MHoDP4so8zmu2U4y00RIjZjNs', 1576534086),
(4317, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc2NTMzNDE4LCJleHAiOjE1NzY1MzUyMTgsInBlcm1pc3Npb24iOiIifQ.csALr2YEynihGHzpIGfxCTOJBlwKoveUNDTrMj9GtZE', 1576535218),
(4321, 945, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NDUiLCJ1c2VybWFpbCI6ImFudG9uaW9qb3JnZWZlcm5hbmRlc0B1YS5wdCIsImlhdCI6MTU3NjU0MDE1NCwiZXhwIjoxNTc2NTQxOTU0LCJwZXJtaXNzaW9uIjoiIn0.yLbahEDildpEr9aGAPOML688AL82V9qDOBxs0wi6fsM', 1576541954),
(4323, 1701, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzAxIiwidXNlcm1haWwiOiJwLnNlaXhhczk2QHVhLnB0IiwiaWF0IjoxNTc2NTQwODc3LCJleHAiOjE1NzY1NDI2NzcsInBlcm1pc3Npb24iOiIifQ.sTxTCpMWBfCI_sOzMtJF1Bs_w69aeRm_Lo5lzFEwyt4', 1576542677),
(4325, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1NzY1NDM4OTQsImV4cCI6MTU3NjU0NTY5NCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.O-KHpSUt6viad572NSkNlK9-E7lKREj6lIW6un2D7SI', 1576545694),
(4329, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3NjYwMDE3MCwiZXhwIjoxNTc2NjAxOTcwLCJwZXJtaXNzaW9uIjoiIn0.nYQSLSPFA3gc4RrvWMaVHzTvFliPDY0yBHpJQBt0ihM', 1576601970),
(4333, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1NzY2MDU4NDYsImV4cCI6MTU3NjYwNzY0NiwicGVybWlzc2lvbiI6IiJ9.TvJilRRw3HyeOOFP18BB1F3M-LYrdQXVZgP4bACJQV0', 1576607646),
(4337, 906, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MDYiLCJ1c2VybWFpbCI6ImFuZHJlLmNhdGFyaW5vQHVhLnB0IiwiaWF0IjoxNTc2NjA5Njc0LCJleHAiOjE1NzY2MTE0NzQsInBlcm1pc3Npb24iOiIifQ.Agm14bfOPm-qgU2mhB41C0epxeqOOP5i-eWOtTuUNAI', 1576611474),
(4341, 900, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MDAiLCJ1c2VybWFpbCI6ImFuZHJlLmFsdmVzQHVhLnB0IiwiaWF0IjoxNTc2NjE1NjQyLCJleHAiOjE1NzY2MTc0NDIsInBlcm1pc3Npb24iOiIifQ.xHBLdQiZjf5_1ebWKy1gQ8-_0L1ySNf_Q844Qw7oteg', 1576617442),
(4345, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc2NjE5ODA2LCJleHAiOjE1NzY2MjE2MDYsInBlcm1pc3Npb24iOiIifQ.IZafioJG47kKI5P-XWBRdwl4s4lrlIlofXC_MHT_Exo', 1576621606),
(4349, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1NzY2MjI2NzcsImV4cCI6MTU3NjYyNDQ3NywicGVybWlzc2lvbiI6IiJ9.qsW0qUFo9zpnp4vGcZNSVkfyti1DA24kVhb2QNMaswQ', 1576624477),
(4353, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1NzY2NzYyNjcsImV4cCI6MTU3NjY3ODA2NywicGVybWlzc2lvbiI6IiJ9.kJ5Fwzt1w7Rqx3YhF3Kat6_g28YSx_JeJqgmEtu7wuQ', 1576678067),
(4357, 888, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4ODgiLCJ1c2VybWFpbCI6ImFuYWFAdWEucHQiLCJpYXQiOjE1NzY2ODIyMDIsImV4cCI6MTU3NjY4NDAwMiwicGVybWlzc2lvbiI6IiJ9.B0h4BYo5ie6vS2D7PR590bbt2wSUaOmafdECgYJATug', 1576684002),
(4361, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzY3NTU1OTksImV4cCI6MTU3Njc1NzM5OSwicGVybWlzc2lvbiI6IiJ9.CLFyTiRUYHD5y3ogwhCJbxz6w_jH0na-UnlEvYJANs0', 1576757399),
(4365, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzY3NjM2ODcsImV4cCI6MTU3Njc2NTQ4NywicGVybWlzc2lvbiI6IiJ9.lcVf0su0iji8XkVwPmW7MBu0CK9it9R-Mi-YZejwEho', 1576765487),
(4369, 1524, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTI0IiwidXNlcm1haWwiOiJsbWNvc3RhOThAdWEucHQiLCJpYXQiOjE1NzY3NzMzODMsImV4cCI6MTU3Njc3NTE4MywicGVybWlzc2lvbiI6IiJ9.zu469O7sC6ib6BPoIVpl6VCfuRwhmn-Cjngm-ObZcO8', 1576775183),
(4373, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1NzY4MzYyNTksImV4cCI6MTU3NjgzODA1OSwicGVybWlzc2lvbiI6IiJ9.mZ6hGRsQAiIy47_c-ZctypUvcXoA2DGeyBRkTfsxPkA', 1576838059),
(4377, 1938, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTM4IiwidXNlcm1haWwiOiJzb2ZpYW1vbml6QHVhLnB0IiwiaWF0IjoxNTc2ODM4OTA2LCJleHAiOjE1NzY4NDA3MDYsInBlcm1pc3Npb24iOiIifQ.5n_oW68cPlrS4iDpPLwIqBd1phw2WLziyetAjhjaEXk', 1576840706),
(4381, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzY4NTY0NTIsImV4cCI6MTU3Njg1ODI1MiwicGVybWlzc2lvbiI6IiJ9.mrSZqOGvDL63lnP-_2upnWFq5gjPmWoZNMB4ItrjHo4', 1576858252),
(4385, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzY4ODE3MzIsImV4cCI6MTU3Njg4MzUzMiwicGVybWlzc2lvbiI6IiJ9.MUw0L5JXerhIJG0vdYZFqqAWyEKi-zvO3gnPnaNIq7s', 1576883532),
(4389, 2046, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ2IiwidXNlcm1haWwiOiJpc2FiZWwucm9zYXJpb0B1YS5wdCIsImlhdCI6MTU3NjkyODYxOSwiZXhwIjoxNTc2OTMwNDE5LCJwZXJtaXNzaW9uIjoiIn0.-YvTyXf9xVThSyW2FdQ2uhvtkmy-YrFsqOM_ir6SWSU', 1576930419),
(4393, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc2OTcyMTY3LCJleHAiOjE1NzY5NzM5NjcsInBlcm1pc3Npb24iOiIifQ.mPKGRIYnGEDDts71dFDQjKkQno9tPBtGM_amHCadP5A', 1576973967),
(4397, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzY5Nzc5ODgsImV4cCI6MTU3Njk3OTc4OCwicGVybWlzc2lvbiI6IiJ9.BZGVcFjZq1YPpFG8JrhMtd2jSreRObi9090w0uLpyVE', 1576979788),
(4401, 1758, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzU4IiwidXNlcm1haWwiOiJwZWRyb21nc291dG9AdWEucHQiLCJpYXQiOjE1NzcwMjYwODEsImV4cCI6MTU3NzAyNzg4MSwicGVybWlzc2lvbiI6IiJ9.IKIp6ETSCg0F9QUo5Y3xWEy621iSNfbpM_lddCe_V5U', 1577027881),
(4405, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTc3MDUzNzM3LCJleHAiOjE1NzcwNTU1MzcsInBlcm1pc3Npb24iOiIifQ.OQsZ0uFW9BIQsbKIWh6Tmt1iYuWPPkfG2LXC6o2iLg4', 1577055537),
(4409, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzcwOTM3MjgsImV4cCI6MTU3NzA5NTUyOCwicGVybWlzc2lvbiI6IiJ9.Cx0129B8JEyMHu15HSEtrdGU1_HlEgaoIG2OwBz5wyo', 1577095528),
(4411, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTc3MDk3MTY0LCJleHAiOjE1NzcwOTg5NjQsInBlcm1pc3Npb24iOiIifQ.uibdsQ77oJ_w-om8pDT3W3o2azk5qgDFBsWr0tU2ESk', 1577098964),
(4415, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1NzcxMTc2NjAsImV4cCI6MTU3NzExOTQ2MCwicGVybWlzc2lvbiI6IiJ9.10Ov7RKHf_18Cou-iNQyNIW0LN--2W3mwCm6zkcHeFQ', 1577119460),
(4417, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc3MTE4MjgzLCJleHAiOjE1NzcxMjAwODMsInBlcm1pc3Npb24iOiIifQ.7NrFQBro1RW6Wg76aC9enoQQcWn5vVKJpmDKfyF0ahA', 1577120083),
(4421, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1NzcxMjYyODgsImV4cCI6MTU3NzEyODA4OCwicGVybWlzc2lvbiI6IiJ9.FFDEJznjeBz2j1X4LZ87fjiAX4PQGCpkcUXKcw5IdYw', 1577128088),
(4425, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc3MTMxNTY2LCJleHAiOjE1NzcxMzMzNjYsInBlcm1pc3Npb24iOiIifQ.M2cQN_bcmuE-1EGc8w8ev0W_xfmK8QwySTGf0CatxPs', 1577133366),
(4429, 945, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NDUiLCJ1c2VybWFpbCI6ImFudG9uaW9qb3JnZWZlcm5hbmRlc0B1YS5wdCIsImlhdCI6MTU3NzE1NjI0OSwiZXhwIjoxNTc3MTU4MDQ5LCJwZXJtaXNzaW9uIjoiIn0.QL5plC-7W0T-MZz6hEtyRw1ryEvI2J8RztrD0je8LjU', 1577158049),
(4433, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1NzcyMDc2NjgsImV4cCI6MTU3NzIwOTQ2OCwicGVybWlzc2lvbiI6IiJ9.w9K_ts2f3E9M1kiQX53epUddH3DtMvqp_indgpwMQag', 1577209468),
(4435, 2036, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM2IiwidXNlcm1haWwiOiJkaW9nb21mc2lsdmE5OEB1YS5wdCIsImlhdCI6MTU3NzIxMTM1OSwiZXhwIjoxNTc3MjEzMTU5LCJwZXJtaXNzaW9uIjoiIn0.7WtB6QM0tU6MojimSKDe1cHLrmwhHgV8PgLnnN4D_Vg', 1577213159),
(4439, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc3MzIwMzI5LCJleHAiOjE1NzczMjIxMjksInBlcm1pc3Npb24iOiIifQ.Byx4WYAC5wdcnZZX68pUCgp1JhAmGayyqQ-c9tDn0y0', 1577322129),
(4443, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3NzM2MDEyMCwiZXhwIjoxNTc3MzYxOTIwLCJwZXJtaXNzaW9uIjoiIn0.bTWV6gdCPGxSWeAtNhzeorn_Te9cUShpL_10p_fiPOQ', 1577361920),
(4447, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTc3MzY3NDA2LCJleHAiOjE1NzczNjkyMDYsInBlcm1pc3Npb24iOiIifQ.8aEpum-8V8B0H_36VC5arVuDbr5FYQtQ53Ln4tL3SAw', 1577369206),
(4451, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzczNzgxOTMsImV4cCI6MTU3NzM3OTk5MywicGVybWlzc2lvbiI6IiJ9.en1YmBGhAoE76RirWIc4iztJ9CBbX2YsCq9sMcBjMfU', 1577379993),
(4455, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc3Mzk3MTI3LCJleHAiOjE1NzczOTg5MjcsInBlcm1pc3Npb24iOiIifQ.W9xzExoySdCXn6v1CIFoqooMlGVz6GNBWOxWFJY5pzI', 1577398927),
(4457, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc3Mzk3MTgwLCJleHAiOjE1NzczOTg5ODAsInBlcm1pc3Npb24iOiIifQ.pocnhYzTgGnhEgAfvE8kdovkZGvKTiNAoey-42i6vv8', 1577398980),
(4459, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc3Mzk3MzMxLCJleHAiOjE1NzczOTkxMzEsInBlcm1pc3Npb24iOiIifQ.Qo0JioAA5yYujvjC2veHuj15AAa2wCj6Z3bfKOCCCZQ', 1577399131),
(4461, 1638, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjM4IiwidXNlcm1haWwiOiJtZnM5OEB1YS5wdCIsImlhdCI6MTU3NzM5ODQ5NywiZXhwIjoxNTc3NDAwMjk3LCJwZXJtaXNzaW9uIjoiIn0.L3drbf735a1zLp76J-MStnL3rJlF6uiMX0IoOqjgONw', 1577400297),
(4465, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc3NDQyMjMzLCJleHAiOjE1Nzc0NDQwMzMsInBlcm1pc3Npb24iOiIifQ.NyWHxv_u7HCaPc4hee65hyV6Cm1RS6ocdOeCJYOmnrM', 1577444033),
(4469, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1Nzc0NTkwMDgsImV4cCI6MTU3NzQ2MDgwOCwicGVybWlzc2lvbiI6IiJ9.FgMSh5q1q1VynZVH-IwzbSj9SHiPUJorokWd2oa3N2M', 1577460808),
(4471, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc3NDYyMTI0LCJleHAiOjE1Nzc0NjM5MjQsInBlcm1pc3Npb24iOiIifQ.RGMb0W-KhS3XfVfCmLUQPShOIqgVU0t8WVQp_gNVRxs', 1577463924),
(4475, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc3NDY3MDQ4LCJleHAiOjE1Nzc0Njg4NDgsInBlcm1pc3Npb24iOiIifQ.18OJydvgsmMAQz9i9BvA_Ivf_FWP0fUg33aGwucJjro', 1577468848),
(4477, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3NzQ2ODg3NSwiZXhwIjoxNTc3NDcwNjc1LCJwZXJtaXNzaW9uIjoiIn0.QizWs2JMWyLB7L6BntTxhkAD9RJl5S8MKS5V9NuDZYI', 1577470675),
(4481, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTc3NDk5NjA2LCJleHAiOjE1Nzc1MDE0MDYsInBlcm1pc3Npb24iOiIifQ.aqoOC6CNTxraotaA_T8-ye86Bm9fb6FFePi9YfpfYqc', 1577501406),
(4485, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc3NTI5NjY1LCJleHAiOjE1Nzc1MzE0NjUsInBlcm1pc3Npb24iOiIifQ.YQRF4MuE4Zc1Gi9EAsnjkwJYdk4jKoBZx-zULFsHif0', 1577531465),
(4489, 1287, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjg3IiwidXNlcm1haWwiOiJnb25jYWxvcGFzc29zQHVhLnB0IiwiaWF0IjoxNTc3NTUyODUwLCJleHAiOjE1Nzc1NTQ2NTAsInBlcm1pc3Npb24iOiIifQ.AuKu-w1ZnuStgayqo0ulUYSSwcnZoY_NKsalvoBwx6g', 1577554650),
(4493, 1938, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTM4IiwidXNlcm1haWwiOiJzb2ZpYW1vbml6QHVhLnB0IiwiaWF0IjoxNTc3NjIwNDgwLCJleHAiOjE1Nzc2MjIyODAsInBlcm1pc3Npb24iOiIifQ.1rBwv01-oW8UiTY-MDzgKHrUj59FEBdhWI2YyDGHSlM', 1577622280),
(4497, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc3NjMzMTgyLCJleHAiOjE1Nzc2MzQ5ODIsInBlcm1pc3Npb24iOiIifQ.g6pf8Xo9W4x1Ni70YV63di1bYtwPebPgZfsQ23CsXJ0', 1577634982),
(4501, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1Nzc2Mzc3MTIsImV4cCI6MTU3NzYzOTUxMiwicGVybWlzc2lvbiI6IiJ9.x-Tb472m4oj1iJOsxbgimEneDACFkEE9jIsn_ATyqpA', 1577639512),
(4505, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTc3NjQ0MTY5LCJleHAiOjE1Nzc2NDU5NjksInBlcm1pc3Npb24iOiIifQ.sWqVmSy6D69QUHQ0_EIewjsHhYWVm-foSth79QvfitQ', 1577645969),
(4507, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzc2NDUyMDksImV4cCI6MTU3NzY0NzAwOSwicGVybWlzc2lvbiI6IiJ9.shvYKUKZcAlq5uBAkChJf98NJZZmQ8rRkpnV_C8Vg8U', 1577647009),
(4511, 1701, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzAxIiwidXNlcm1haWwiOiJwLnNlaXhhczk2QHVhLnB0IiwiaWF0IjoxNTc3NjU1OTM4LCJleHAiOjE1Nzc2NTc3MzgsInBlcm1pc3Npb24iOiIifQ.3EAbiyjUtBGQUsvsdnA2kvXxd5x3iBZWxxEdLglKWTo', 1577657738),
(4515, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3NzcyMzE4MCwiZXhwIjoxNTc3NzI0OTgwLCJwZXJtaXNzaW9uIjoiIn0.rYXEfb-Hrblhc03IGpr2bvpqpEVUi6Nij8LKLFP8E-s', 1577724980),
(4519, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc3NzI5MTQ0LCJleHAiOjE1Nzc3MzA5NDQsInBlcm1pc3Npb24iOiIifQ.5XmFy_sU-o1nf8ISKcH2SIW-1urG4kpIyMVWOlhHOZo', 1577730944),
(4521, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzc3MzA0ODUsImV4cCI6MTU3NzczMjI4NSwicGVybWlzc2lvbiI6IiJ9.b85JqZUjyDx142vSaMU_0nVIFEOHf6VIE-YGlIJzh4M', 1577732285),
(4525, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc3NzM3NTg5LCJleHAiOjE1Nzc3MzkzODksInBlcm1pc3Npb24iOiIifQ.Msx4IxulcgQ4BL2bfyH6e1D8rdX65yLvoVzUbtHc_Dk', 1577739389),
(4527, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3NzczOTc1OSwiZXhwIjoxNTc3NzQxNTU5LCJwZXJtaXNzaW9uIjoiIn0.sJsaJTBJYIVsotqiefE75eHv7Y_1QlP58EkXDSx7q2A', 1577741559),
(4531, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzc3NTY2NzEsImV4cCI6MTU3Nzc1ODQ3MSwicGVybWlzc2lvbiI6IiJ9.9172UdOSQdJl5lZ80kv46dTwyp5U4f01Pz7VMZyQ_D8', 1577758471),
(4535, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU3Nzc5MjMwMiwiZXhwIjoxNTc3Nzk0MTAyLCJwZXJtaXNzaW9uIjoiIn0.Pdbc7DHq47cTvxD9AToERrmUGbBYFHiEQM-cQqMNgoU', 1577794102),
(4537, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc3NzkzNDkzLCJleHAiOjE1Nzc3OTUyOTMsInBlcm1pc3Npb24iOiIifQ.gyJwxdoJmexOBDzf_iO5pSuKYZpYoZmgYPgKbjnN9ho', 1577795293),
(4539, 2053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUzIiwidXNlcm1haWwiOiJtYXJ0aW5oby50YXZhcmVzQHVhLnB0IiwiaWF0IjoxNTc3Nzk0NjA2LCJleHAiOjE1Nzc3OTY0MDYsInBlcm1pc3Npb24iOiIifQ.kn6NRD-rmGRkolwVLZB_DEDZkZHByrCt737sYaw2hrw', 1577796406),
(4543, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1Nzc4MjcwMTcsImV4cCI6MTU3NzgyODgxNywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.ASjWRQj3thsYYgT_b0gdfNClI6G0L2K3AlM4YdzGeRk', 1577828817),
(4547, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1Nzc4NzQ4MjYsImV4cCI6MTU3Nzg3NjYyNiwicGVybWlzc2lvbiI6IiJ9.QMdTjHJuMM9hzKf2gGkBiv3QknxMP6TU1s8B5wajHyw', 1577876626),
(4549, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc3ODc2MDIwLCJleHAiOjE1Nzc4Nzc4MjAsInBlcm1pc3Npb24iOiIifQ.21TbXQ9pr1SsIRERHwGpnmr1qW-kQf_plHEwhagqwSw', 1577877820),
(4553, 1938, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTM4IiwidXNlcm1haWwiOiJzb2ZpYW1vbml6QHVhLnB0IiwiaWF0IjoxNTc3ODkyMTEwLCJleHAiOjE1Nzc4OTM5MTAsInBlcm1pc3Npb24iOiIifQ.lleahwcEypJG6xdSMxwoNgpjM2VCrv6stMbdyD1RUlo', 1577893910),
(4555, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3Nzg5MzEzOSwiZXhwIjoxNTc3ODk0OTM5LCJwZXJtaXNzaW9uIjoiIn0.NHmsACjrgM79Ra4TLazQxinvnrgV7aCBYiNgZQfG_rA', 1577894939),
(4559, 1611, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjExIiwidXNlcm1haWwiOiJtYXJpYW5hc3BzQHVhLnB0IiwiaWF0IjoxNTc3ODk3NzA5LCJleHAiOjE1Nzc4OTk1MDksInBlcm1pc3Npb24iOiIifQ.hr7Z0HHGCjOTAoZPQaGO0Ec8ab2q5-P8cXYDRVSIPz8', 1577899509),
(4563, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1Nzc5MDYzNzIsImV4cCI6MTU3NzkwODE3MiwicGVybWlzc2lvbiI6IiJ9.56YdseQnGtOxJLhydj_sKMEHfbX2mEYOcFUtxni_aVo', 1577908172),
(4567, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzc5MTg4MjYsImV4cCI6MTU3NzkyMDYyNiwicGVybWlzc2lvbiI6IiJ9.wsqk2aWj4FN6AqG7ElP5aVMsRmmnbVW5ucwYlOJUnXU', 1577920626),
(4571, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc3OTU4NjUzLCJleHAiOjE1Nzc5NjA0NTMsInBlcm1pc3Npb24iOiIifQ.EvgVDNFecBy4kNYXLctUkW0ZALSX9ioyOvZP5fWOHVc', 1577960453),
(4575, 1359, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU5IiwidXNlcm1haWwiOiJqLmJyaXRvQHVhLnB0IiwiaWF0IjoxNTc3OTYxOTYzLCJleHAiOjE1Nzc5NjM3NjMsInBlcm1pc3Npb24iOiIifQ.mT1B9gXw3bE7o0k307lTV5cu2e7QkxLR3LpfRAcoOz4', 1577963763),
(4579, 1938, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTM4IiwidXNlcm1haWwiOiJzb2ZpYW1vbml6QHVhLnB0IiwiaWF0IjoxNTc3OTczNDQzLCJleHAiOjE1Nzc5NzUyNDMsInBlcm1pc3Npb24iOiIifQ.NtyyC8H-vP2NvjAqBHmpeRdfG1__VqM5vnm1B1rO_aQ', 1577975243),
(4583, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3Nzk4MjczMywiZXhwIjoxNTc3OTg0NTMzLCJwZXJtaXNzaW9uIjoiIn0.zP8uwYFXfg3yO2QHC-BXbl9QQLyPwmbZWLHJWbuzuEk', 1577984533),
(4587, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc3OTg4NTI5LCJleHAiOjE1Nzc5OTAzMjksInBlcm1pc3Npb24iOiIifQ.oYGdMaX-gJ45FwUjvWxwlKmhQB9qz3VZF-QQpPq_5GI', 1577990329),
(4589, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1Nzc5ODg3MTAsImV4cCI6MTU3Nzk5MDUxMCwicGVybWlzc2lvbiI6IiJ9.2jhxJkApUJaAMkjRWxKdCejzEMY-pM1lUA2EbCqdGDk', 1577990510),
(4591, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1Nzc5OTA5NDksImV4cCI6MTU3Nzk5Mjc0OSwicGVybWlzc2lvbiI6IiJ9.a8m2yL_O1w3viHKlTFd3KSst1OfqQz2ZkKOq8LawH7c', 1577992749),
(4595, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzc5OTY3MzgsImV4cCI6MTU3Nzk5ODUzOCwicGVybWlzc2lvbiI6IiJ9.d9H2q_WwEidM81HrsGVyP8efaHZj8vh7Td8a2NaUYiI', 1577998538),
(4599, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzgwMDExMTUsImV4cCI6MTU3ODAwMjkxNSwicGVybWlzc2lvbiI6IiJ9.rVENB0-vvTN0fwTDg1tAn5tNC1FQ_4-zriZUMsmUsNw', 1578002915),
(4601, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1NzgwMDQwMjcsImV4cCI6MTU3ODAwNTgyNywicGVybWlzc2lvbiI6IiJ9.IOQ3bfNRErmOZGYZuszzVzysDMkzAg-_-6meopgj1sY', 1578005827),
(4603, 1611, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjExIiwidXNlcm1haWwiOiJtYXJpYW5hc3BzQHVhLnB0IiwiaWF0IjoxNTc4MDA0ODY5LCJleHAiOjE1NzgwMDY2NjksInBlcm1pc3Npb24iOiIifQ._61y59N05ThhTTazMvCVL8I2TLqO5uIbtHI6MEaGsV4', 1578006669),
(4605, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3ODAwNTY4OSwiZXhwIjoxNTc4MDA3NDg5LCJwZXJtaXNzaW9uIjoiIn0.B74Y5OYfANz-lAZO-O7bw0x9FOs1av_Sdli6UfAljBY', 1578007489),
(4607, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc4MDA2NzA0LCJleHAiOjE1NzgwMDg1MDQsInBlcm1pc3Npb24iOiIifQ.0XYgvFNpsWi52E0VjCLN4f8AuUm6pCKV_DoF7AFTjt4', 1578008504),
(4609, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc4MDQxNTQ4LCJleHAiOjE1NzgwNDMzNDgsInBlcm1pc3Npb24iOiIifQ.UqDMJIkaNNx644qQ0lS_bDmNoNaV7a1EGhiXYg4CygI', 1578043348),
(4610, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc4MDQ1ODA3LCJleHAiOjE1NzgwNDc2MDcsInBlcm1pc3Npb24iOiIifQ.qII_ODesaiIa-gnWxYGmoU1VEDVi0ixvoe-yrEXMMeU', 1578047607),
(4613, 1938, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTM4IiwidXNlcm1haWwiOiJzb2ZpYW1vbml6QHVhLnB0IiwiaWF0IjoxNTc4MDQ4NzA3LCJleHAiOjE1NzgwNTA1MDcsInBlcm1pc3Npb24iOiIifQ.tIH5lU37fi_IbnzrdJNLysoB2U0Rz5kivFEjJNnEuSE', 1578050507);
INSERT INTO `GenTokens` (`id`, `userid`, `token`, `expire_date`) VALUES
(4617, 2007, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDA3IiwidXNlcm1haWwiOiJ2YXNjb2FscmFtb3NAdWEucHQiLCJpYXQiOjE1NzgwNTc1OTksImV4cCI6MTU3ODA1OTM5OSwicGVybWlzc2lvbiI6IiJ9.cjch6XByErffEwjS2_T6pqx33RYd-uaHfDu7czSAx_Y', 1578059399),
(4619, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1NzgwNTg5MDIsImV4cCI6MTU3ODA2MDcwMiwicGVybWlzc2lvbiI6IiJ9.Qz8t2Uxgg6RxEXANVJDiClnP-7jRiOTwZqeUVsY_mHU', 1578060702),
(4623, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU3ODA3ODQzMiwiZXhwIjoxNTc4MDgwMjMyLCJwZXJtaXNzaW9uIjoiIn0.79qJ85DKkzBoz1BnA_ARo5QlQ_z450gV5jXZ-mIG9ds', 1578080232),
(4625, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU3ODA3ODU3OCwiZXhwIjoxNTc4MDgwMzc4LCJwZXJtaXNzaW9uIjoiIn0.IUGc1ixGmsgjGOog6B9qWpa3W8mbTHIibcWsWIQ_WX0', 1578080378),
(4629, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzgwODQxMzIsImV4cCI6MTU3ODA4NTkzMiwicGVybWlzc2lvbiI6IiJ9.qsoKEQgg0G8TzdTCuky0rJlmwD3-MTnoRsvdBSDseGk', 1578085932),
(4633, 1701, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzAxIiwidXNlcm1haWwiOiJwLnNlaXhhczk2QHVhLnB0IiwiaWF0IjoxNTc4MDg3ODgzLCJleHAiOjE1NzgwODk2ODMsInBlcm1pc3Npb24iOiIifQ.3HF1EP1uebzbIRR8I9TW-rfvDmScBHi4EpI3pv-4KJw', 1578089683),
(4637, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1NzgwOTA1OTYsImV4cCI6MTU3ODA5MjM5NiwicGVybWlzc2lvbiI6IiJ9.P0QFwuKX7XnEd61Bq4iX274ER22p1BtcZsMLlIct_oo', 1578092396),
(4639, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTc4MDkyNjM1LCJleHAiOjE1NzgwOTQ0MzUsInBlcm1pc3Npb24iOiIifQ.TxpUL-xDBbleq2uRHTZ7aYQ5nzvDOX7H5rPZP5QGhJs', 1578094435),
(4643, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc4MTMyOTkwLCJleHAiOjE1NzgxMzQ3OTAsInBlcm1pc3Npb24iOiIifQ.vERnl8qVLSM9QKo55M6SCPtExL72uYr4ZfjGdzqTc6I', 1578134790),
(4647, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1NzgxNDc3MTcsImV4cCI6MTU3ODE0OTUxNywicGVybWlzc2lvbiI6IiJ9.RZjX_lpkJjMWmmvNLswhC9QJTcpOEhA62AX5xCvT1ZI', 1578149517),
(4651, 2080, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDgwIiwidXNlcm1haWwiOiJicmFpc0B1YS5wdCIsImlhdCI6MTU3ODE1NzMzNiwiZXhwIjoxNTc4MTU5MTM2LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.LDIpQYXfuTiPu4TbqSHrRnwH1AdRdUwJKOifxgQczDE', 1578159136),
(4653, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc4MTU4MDA5LCJleHAiOjE1NzgxNTk4MDksInBlcm1pc3Npb24iOiIifQ.o5NoH4dSymg34DPsANVerHBueoYhqGuN_o_k_g48qfY', 1578159809),
(4655, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1NzgxNjEzODQsImV4cCI6MTU3ODE2MzE4NCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.Wn6SytdKZF7OtsvFihyo2yVSWSTaFy9lbB4gtM6lHLM', 1578163184),
(4659, 1800, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAwIiwidXNlcm1haWwiOiJyYWZhZWwubmV2ZXMuZGlyZWl0b0B1YS5wdCIsImlhdCI6MTU3ODE4NTU1MiwiZXhwIjoxNTc4MTg3MzUyLCJwZXJtaXNzaW9uIjoiIn0.y9jjIHwKyQBK_D0R8G9Vb1rn_hANav_CbyGIDZWN6Vs', 1578187352),
(4663, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1NzgyMTk4NjksImV4cCI6MTU3ODIyMTY2OSwicGVybWlzc2lvbiI6IiJ9.j-5oCjx7YddPyT3bk-DiDt2QPbdFXgsrzqqfRBRuu4I', 1578221669),
(4665, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzgyMzU1MDEsImV4cCI6MTU3ODIzNzMwMSwicGVybWlzc2lvbiI6IiJ9.nX0wPiUP4EjeBDtV0EIeI-X4DG8_xKu7WXTLhd_rTSA', 1578237301),
(4667, 945, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NDUiLCJ1c2VybWFpbCI6ImFudG9uaW9qb3JnZWZlcm5hbmRlc0B1YS5wdCIsImlhdCI6MTU3ODIzNzI1MiwiZXhwIjoxNTc4MjM5MDUyLCJwZXJtaXNzaW9uIjoiIn0.L_0nawlZZVr7NB4kjnLKcT61IIyqCb3ULI41tbYbIcQ', 1578239052),
(4671, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzgyNDg2NjMsImV4cCI6MTU3ODI1MDQ2MywicGVybWlzc2lvbiI6IiJ9.FoyEEHnh01kN4XE5lJKyA-LO8ZVxZ6EUr2JtA_6Lgjo', 1578250463),
(4675, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc4MjY1OTEzLCJleHAiOjE1NzgyNjc3MTMsInBlcm1pc3Npb24iOiIifQ.z-vQ-i6YME-E8WbhvzaITpGXbuCtsj_xDhurOSOEF24', 1578267713),
(4679, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc4MzAzODQ2LCJleHAiOjE1NzgzMDU2NDYsInBlcm1pc3Npb24iOiIifQ.7iY0y0SDvQmGmSlu5WVCZsN94JHaMB9DzlGHryOmUHc', 1578305646),
(4683, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc4MzExNzM3LCJleHAiOjE1NzgzMTM1MzcsInBlcm1pc3Npb24iOiIifQ.mVRcH2BRA2ByPNfsaChowVAu3lrNevZp9OVqv0q9RMg', 1578313537),
(4687, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1NzgzMTMxOTUsImV4cCI6MTU3ODMxNDk5NSwicGVybWlzc2lvbiI6IiJ9.yJLc7wVvM5luC7e6dLvZEauwP7TJQCWriBRWbGY08AE', 1578314995),
(4691, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc4MzIwMzEzLCJleHAiOjE1NzgzMjIxMTMsInBlcm1pc3Npb24iOiIifQ.C92TNU5sc7Hd7RrXjk97guW19X_Vld1ROtHl0Ely81E', 1578322113),
(4693, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc4MzIxNjc0LCJleHAiOjE1NzgzMjM0NzQsInBlcm1pc3Npb24iOiIifQ._Zsc94X2VDFChAsPVrFRdhAVYDquiWsnsyQ9W5Jf-08', 1578323474),
(4697, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzgzMjkxMTEsImV4cCI6MTU3ODMzMDkxMSwicGVybWlzc2lvbiI6IiJ9.vdYiGBQ-CdczT3ENuuEiHMYTZkTzFfGaWNaytNMtfeE', 1578330911),
(4699, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzgzMzE0NzUsImV4cCI6MTU3ODMzMzI3NSwicGVybWlzc2lvbiI6IiJ9.Z2yKctYm9ftvtRRsVPKmnswr1ZtILX4TTRReUNd77KA', 1578333275),
(4703, 1701, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzAxIiwidXNlcm1haWwiOiJwLnNlaXhhczk2QHVhLnB0IiwiaWF0IjoxNTc4MzUxNzY1LCJleHAiOjE1NzgzNTM1NjUsInBlcm1pc3Npb24iOiIifQ.mIXZiLFMfXCbvCGZB3GONqBlhRD4kALKdZENVaScgQw', 1578353565),
(4707, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTc4MzY5MTE2LCJleHAiOjE1NzgzNzA5MTYsInBlcm1pc3Npb24iOiIifQ.s9glvD6qvgmta7ACXeaCywLqdaPE8carw5tvcNpUSAw', 1578370916),
(4711, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1NzgzODgyNzIsImV4cCI6MTU3ODM5MDA3MiwicGVybWlzc2lvbiI6IiJ9.7YiYAtj5s0miJYxqssuYSmToTm3Ck_cV3TxhpeQ9pW8', 1578390072),
(4715, 2053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUzIiwidXNlcm1haWwiOiJtYXJ0aW5oby50YXZhcmVzQHVhLnB0IiwiaWF0IjoxNTc4MzkwNTI5LCJleHAiOjE1NzgzOTIzMjksInBlcm1pc3Npb24iOiIifQ.L6gORVqtZ475B4I0Y9GqzsIr9VBh1O01zF9fSaZTiSw', 1578392329),
(4717, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc4MzkxNjI1LCJleHAiOjE1NzgzOTM0MjUsInBlcm1pc3Npb24iOiIifQ.WcHW2VvjY8z8TG_UUMq0vmgqqadAqv3Wb--d-bsHJPc', 1578393425),
(4719, 1197, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTk3IiwidXNlcm1haWwiOiJlZGdhcm1vcmFpc0B1YS5wdCIsImlhdCI6MTU3ODM5MjQ5MSwiZXhwIjoxNTc4Mzk0MjkxLCJwZXJtaXNzaW9uIjoiIn0.0gDX738ZVp7BVMimwm8KnUyPaD2cP8Jk3Cw3YJa8kg4', 1578394291),
(4723, 1473, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDczIiwidXNlcm1haWwiOiJqb3NlLnZhekB1YS5wdCIsImlhdCI6MTU3ODQwNTUzNiwiZXhwIjoxNTc4NDA3MzM2LCJwZXJtaXNzaW9uIjoiIn0.Cba2n1opkCM4VRIoSPWwadHgxHpG3besET6_D5WYQ7g', 1578407336),
(4725, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc4NDA2Mjk3LCJleHAiOjE1Nzg0MDgwOTcsInBlcm1pc3Npb24iOiIifQ.XaNAHX8WQ_cN7JUS1zSwjESKwBSESCUfvvSZZ1kHx5E', 1578408097),
(4729, 1473, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDczIiwidXNlcm1haWwiOiJqb3NlLnZhekB1YS5wdCIsImlhdCI6MTU3ODQxMjczNCwiZXhwIjoxNTc4NDE0NTM0LCJwZXJtaXNzaW9uIjoiIn0.3h9W0YKU55tAWYvCtmIxVswtkTn6lhu0-097NOqZHIo', 1578414534),
(4731, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1Nzg0MTQ2NzksImV4cCI6MTU3ODQxNjQ3OSwicGVybWlzc2lvbiI6IiJ9.D6UOBbLD7Lth2LEyM8eEjOjoQ8E3SdIsN1QdnGXzqN0', 1578416479),
(4733, 888, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4ODgiLCJ1c2VybWFpbCI6ImFuYWFAdWEucHQiLCJpYXQiOjE1Nzg0MTQ3NDYsImV4cCI6MTU3ODQxNjU0NiwicGVybWlzc2lvbiI6IiJ9.R1sHMJvBG3haxV9R71n0JwmSDBkagxUtFFdoax2QuDk', 1578416546),
(4737, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc4NDIxNzEyLCJleHAiOjE1Nzg0MjM1MTIsInBlcm1pc3Npb24iOiIifQ.035PoI4wpPbZ7S5ZaharzGwwphuLWrOkBpCfxS3AcqA', 1578423512),
(4739, 1368, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzY4IiwidXNlcm1haWwiOiJqY3BzQHVhLnB0IiwiaWF0IjoxNTc4NDIyNDIwLCJleHAiOjE1Nzg0MjQyMjAsInBlcm1pc3Npb24iOiIifQ.6l6u2H5nwLT0mJrbIwh8ArQvMhzGTr30YYMsIIqPOhQ', 1578424220),
(4741, 1701, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzAxIiwidXNlcm1haWwiOiJwLnNlaXhhczk2QHVhLnB0IiwiaWF0IjoxNTc4NDIyNjAzLCJleHAiOjE1Nzg0MjQ0MDMsInBlcm1pc3Npb24iOiIifQ.rP3ghTNzbWdjF3WrBN9avGtZxRZUdwRdB54GDi92k0Y', 1578424403),
(4743, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1Nzg0MjM0NDEsImV4cCI6MTU3ODQyNTI0MSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.GQxBm3uYOj0snwlws9EQB-7DKaUdv-z-zx2mNKoQHcg', 1578425241),
(4747, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1Nzg0Mzg2OTMsImV4cCI6MTU3ODQ0MDQ5MywicGVybWlzc2lvbiI6IiJ9.Du4bcAjOQ0NuKybVBMDRXjN9qBaHDAlI7QY05Sg7R5g', 1578440493),
(4751, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU3ODQ4Mzk3MiwiZXhwIjoxNTc4NDg1NzcyLCJwZXJtaXNzaW9uIjoiIn0.ft5EC3woiW7By6TCU53SqRinX6exqkFvXD1X2iHD4Rw', 1578485772),
(4755, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg0OTAxMDUsImV4cCI6MTU3ODQ5MTkwNSwicGVybWlzc2lvbiI6IiJ9.Yo0Lkt_5Kn0ijiatIRNsC2c18b6j93YjltZanpX1tnE', 1578491905),
(4759, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg0OTc4NDgsImV4cCI6MTU3ODQ5OTY0OCwicGVybWlzc2lvbiI6IiJ9.OV4TvTIRY-8wpksmtEEMHloVAXPJdxBfPL5QKfnuoJg', 1578499648),
(4761, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc4NDk5MzQ3LCJleHAiOjE1Nzg1MDExNDcsInBlcm1pc3Npb24iOiIifQ.IX6oAyr5NbIxNVjhiU-zVb668_kJMSkTbhYu-nGQ6cc', 1578501147),
(4763, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTc4NTAxNjQwLCJleHAiOjE1Nzg1MDM0NDAsInBlcm1pc3Npb24iOiIifQ.FOvDRoLaBE45B4lasgH0Y0u5w2OKWvkDf-vBsuVU0z4', 1578503440),
(4767, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1Nzg1MDU1MDIsImV4cCI6MTU3ODUwNzMwMiwicGVybWlzc2lvbiI6IiJ9.9ap6giM6kBl_zuLUMaLFBBH61RDN7ye7_LgDqYyeRjM', 1578507302),
(4771, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTc4NTU5NDMyLCJleHAiOjE1Nzg1NjEyMzIsInBlcm1pc3Npb24iOiIifQ.ezbc9QsBJSiz23Xt6BUeRSCiwZ-CEmF5gZv1C7y1BMo', 1578561232),
(4775, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTc4NTcwNzIxLCJleHAiOjE1Nzg1NzI1MjEsInBlcm1pc3Npb24iOiIifQ.0EEnY6ne-cUYVGSL-PRs8f2hhnsAmHlXuYI4Xnc4dcU', 1578572521),
(4779, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU3ODU3MzkwMywiZXhwIjoxNTc4NTc1NzAzLCJwZXJtaXNzaW9uIjoiIn0.KxZbp3LkN3tGyHgjk8JgZrx5g-eBhei29PQ-SRTn56Q', 1578575703),
(4781, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU3ODU3NjQyNywiZXhwIjoxNTc4NTc4MjI3LCJwZXJtaXNzaW9uIjoiIn0.KQbm2FpZvKv7c5CKvikeFxSQ_Qcz8dU9ONsPufVYBAQ', 1578578227),
(4783, 1359, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzU5IiwidXNlcm1haWwiOiJqLmJyaXRvQHVhLnB0IiwiaWF0IjoxNTc4NTc4MzEzLCJleHAiOjE1Nzg1ODAxMTMsInBlcm1pc3Npb24iOiIifQ.W9Y-zTbMTNiHG3XIyvc9mDACfQh6JPEZCKO4vpYJZ3M', 1578580113),
(4787, 987, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5ODciLCJ1c2VybWFpbCI6ImJydW5vcGludG81MTUxQHVhLnB0IiwiaWF0IjoxNTc4NTgxOTc2LCJleHAiOjE1Nzg1ODM3NzYsInBlcm1pc3Npb24iOiIifQ.lsRnVFdYas-gMbCHGItmc0o4gMhUsPHXibmjmiC1zW0', 1578583776),
(4791, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1Nzg1ODc3ODcsImV4cCI6MTU3ODU4OTU4NywicGVybWlzc2lvbiI6IiJ9.DsxR6moSsOLvnPNPJ3y40eKaAr2OiJh5yHbaFC4bCiQ', 1578589587),
(4799, 1026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDI2IiwidXNlcm1haWwiOiJjYXJvbGluYXJlc2VuZGVtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTc4NTkzNTgyLCJleHAiOjE1Nzg1OTUzODIsInBlcm1pc3Npb24iOiIifQ.NQ0a49Ez7ZsywY2iWmjg6BrV6UHl0HjnwpZGVcKnhVs', 1578595382),
(4801, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU3ODU5Mzg3NSwiZXhwIjoxNTc4NTk1Njc1LCJwZXJtaXNzaW9uIjoiIn0.PrOF5e2WYIRkhpVddBEHsefki7cLrBFXpcs8WItoXHc', 1578595675),
(4803, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1Nzg1OTY2NzEsImV4cCI6MTU3ODU5ODQ3MSwicGVybWlzc2lvbiI6IiJ9.DN6AOsI5DXo87gBb_sSz2Rq1neKqkYk_Tb2T0E1hKLY', 1578598471),
(4805, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1Nzg1OTgxMjAsImV4cCI6MTU3ODU5OTkyMCwicGVybWlzc2lvbiI6IiJ9.izFupRv2bPAwJd3PSBOSwO0mBvdEsF6u4GnV0T0OuQE', 1578599920),
(4809, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTc4NjAzMDU1LCJleHAiOjE1Nzg2MDQ4NTUsInBlcm1pc3Npb24iOiIifQ.HXT7ZB_Q8J1CABjGvbD_ejuaLNff2-TN7uI4pU_-rLs', 1578604855),
(4811, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1Nzg2MDQyMzEsImV4cCI6MTU3ODYwNjAzMSwicGVybWlzc2lvbiI6IiJ9.FU98IsYcV4Com1uo6YskLZq5tx7kf4kSMOJaDS3ls9s', 1578606031),
(4813, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc4NjA0ODgwLCJleHAiOjE1Nzg2MDY2ODAsInBlcm1pc3Npb24iOiIifQ.tUOjDbHH7q1efncEZq-vaJq3qWH8FQHlPay-RlKGRXg', 1578606680),
(4817, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1Nzg2MDg4MjcsImV4cCI6MTU3ODYxMDYyNywicGVybWlzc2lvbiI6IiJ9.w7BKiZCdxXcw0D9g5uS30nqM437bP2C-Bz_L6czrkns', 1578610627),
(4819, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1Nzg2MDg4MzQsImV4cCI6MTU3ODYxMDYzNCwicGVybWlzc2lvbiI6IiJ9.MPj5emLxbtamnCl2avNdnY_4cTMRJNY-Y3CyrVz-asc', 1578610634),
(4821, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1Nzg2MDg4MzUsImV4cCI6MTU3ODYxMDYzNSwicGVybWlzc2lvbiI6IiJ9.AAykCiz6VmomKQBjVx3Zt2QCrrS7gT9odjw9-UOy2Qs', 1578610635),
(4823, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1Nzg2MDg4MzUsImV4cCI6MTU3ODYxMDYzNSwicGVybWlzc2lvbiI6IiJ9.AAykCiz6VmomKQBjVx3Zt2QCrrS7gT9odjw9-UOy2Qs', 1578610635),
(4825, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1Nzg2MDg4MzYsImV4cCI6MTU3ODYxMDYzNiwicGVybWlzc2lvbiI6IiJ9.WC31HruQZ7-EeX1fKWRBlYp_NJdP_5vCeB_DMwOndjc', 1578610636),
(4827, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1Nzg2MDg4NDMsImV4cCI6MTU3ODYxMDY0MywicGVybWlzc2lvbiI6IiJ9.lEz-KfdSxJ0N9aI7jvJc8O_OM8SDBOsGFEB9gEb-Jy4', 1578610643),
(4829, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1Nzg2MDg4NDksImV4cCI6MTU3ODYxMDY0OSwicGVybWlzc2lvbiI6IiJ9.PHqt7ZrU7jMJY-PkLI1oAX4rDl-Rm1oq1MGgMKNBG6s', 1578610649),
(4831, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTc4NjA4ODUwLCJleHAiOjE1Nzg2MTA2NTAsInBlcm1pc3Npb24iOiIifQ.OL0iQ3JEUf3cj6f22LJMea3KykP6l7NiCTWpSa5_028', 1578610650),
(4833, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1Nzg2MDg4NjgsImV4cCI6MTU3ODYxMDY2OCwicGVybWlzc2lvbiI6IiJ9._WECA5gtEQrGJhr74ef2yIY0pqX9PNa6k8bjYNk3d20', 1578610668),
(4835, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTc4NjA4ODcxLCJleHAiOjE1Nzg2MTA2NzEsInBlcm1pc3Npb24iOiIifQ.jyAfR2sf8E5S3y3u9x3mO6JSeXukxvxH4cuB8Fo4i98', 1578610671),
(4837, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTc4NjA4OTMzLCJleHAiOjE1Nzg2MTA3MzMsInBlcm1pc3Npb24iOiIifQ.0lR4n7pQZraQ-czO7phXlmwns6hZ3IoUqIgby2s_o9M', 1578610733),
(4839, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTc4NjA4OTM3LCJleHAiOjE1Nzg2MTA3MzcsInBlcm1pc3Npb24iOiIifQ.s9frrFF2LSMOXN6EtgJgQCMzF-FjX8A68TAxzxup8CI', 1578610737),
(4841, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTc4NjA4OTM5LCJleHAiOjE1Nzg2MTA3MzksInBlcm1pc3Npb24iOiIifQ.GG6NpSxf4palbe3cNbVOeW-3DLIThAmw_gs6LxNfBkI', 1578610739),
(4843, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg2MDkwOTgsImV4cCI6MTU3ODYxMDg5OCwicGVybWlzc2lvbiI6IiJ9.PMfJt-JExK6tEkzDvrAK3GzAvCB9kvk5Tb_aUC8RWTs', 1578610898),
(4845, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg2MDkxMjIsImV4cCI6MTU3ODYxMDkyMiwicGVybWlzc2lvbiI6IiJ9.-oeCyXEH8NFaKNTPF6sy2-QVf-x1wNqFODfxhul7rlk', 1578610922),
(4847, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg2MDkxNDEsImV4cCI6MTU3ODYxMDk0MSwicGVybWlzc2lvbiI6IiJ9.kc1aa99o4g1BuJaPFlaRDLW5DLPHqDkjMgWmjFswiKs', 1578610941),
(4849, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg2MDkxNDcsImV4cCI6MTU3ODYxMDk0NywicGVybWlzc2lvbiI6IiJ9.o-ObhWR81BhPdxG2aBQSaYkLF7fTmQZl5PmKCndBWtU', 1578610947),
(4851, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg2MDkxNTEsImV4cCI6MTU3ODYxMDk1MSwicGVybWlzc2lvbiI6IiJ9.sleEE5CAZrxm5cbOg6Muxe4UHkZSpivnaDvdxRgoPBo', 1578610951),
(4853, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg2MDkxNTgsImV4cCI6MTU3ODYxMDk1OCwicGVybWlzc2lvbiI6IiJ9.s3haghMRxe7pFMdLsU_jCAaKGx9Ol_2g2WOnB6GF-GM', 1578610958),
(4855, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg2MDkxNzksImV4cCI6MTU3ODYxMDk3OSwicGVybWlzc2lvbiI6IiJ9.72DFIY88WflsX7qk6Dq0W3fhaA17mmAsxaj7HzJE918', 1578610979),
(4857, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg2MDkyMTcsImV4cCI6MTU3ODYxMTAxNywicGVybWlzc2lvbiI6IiJ9.WYjETUQEaCPOUGJ432hUbBT0qS0bO0FzRLiYocJdQKw', 1578611017),
(4859, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg2MDkyMzQsImV4cCI6MTU3ODYxMTAzNCwicGVybWlzc2lvbiI6IiJ9.BMAnLFxrvQHClWpfcF4gjHLP7aE3eRUEXgn_Uy5st3M', 1578611034),
(4861, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg2MDkyOTAsImV4cCI6MTU3ODYxMTA5MCwicGVybWlzc2lvbiI6IiJ9.pkdRPKLrg8g5imX27gfBYawMChyEkELzEJ0pOVgoaRQ', 1578611090),
(4863, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg2MDkzNDIsImV4cCI6MTU3ODYxMTE0MiwicGVybWlzc2lvbiI6IiJ9.0jvdWZRukvO6wGKZyN2-wyz2bdl4GGehvnUIP5YIG1U', 1578611142),
(4865, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg2MDkzNDYsImV4cCI6MTU3ODYxMTE0NiwicGVybWlzc2lvbiI6IiJ9.Gflbp9o3QsgOjUfUlqpJiIrwIG1VG9PckuElqGL_0Js', 1578611146),
(4867, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc4NjA5Mzg3LCJleHAiOjE1Nzg2MTExODcsInBlcm1pc3Npb24iOiIifQ.ZTu5ifyX5tey8icRJvU-K-mczqtDu6VkM60tOyZMihQ', 1578611187),
(4869, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc4NjA5NDAyLCJleHAiOjE1Nzg2MTEyMDIsInBlcm1pc3Npb24iOiIifQ.lF__1VeWkrRf2rXLlY_wJINkfUcefuXq1FOBVTB60qk', 1578611202),
(4873, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTc4NjEwNTg4LCJleHAiOjE1Nzg2MTIzODgsInBlcm1pc3Npb24iOiIifQ.T7VCScRWD1BdARIqPM62Lp7EtCeXU9U1pOaEROsIdVI', 1578612388),
(4875, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1Nzg2MTE5OTgsImV4cCI6MTU3ODYxMzc5OCwicGVybWlzc2lvbiI6IiJ9.f07gzTnB07u-UVKeH9gTiyhCK7OfiXM_04AI6lVdMQk', 1578613798),
(4877, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTc4NjExOTk4LCJleHAiOjE1Nzg2MTM3OTgsInBlcm1pc3Npb24iOiIifQ.wtY5jQLDCPpHYqiRK571g5Al2GA4daO3LAGUfMRSvXI', 1578613798),
(4881, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc4NjE1MDA5LCJleHAiOjE1Nzg2MTY4MDksInBlcm1pc3Npb24iOiIifQ.wg4s9NjAnVCSy2refpZUyyxecdOQb2VIhlDpYRN9-kI', 1578616809),
(4883, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTc4NjE2NjI5LCJleHAiOjE1Nzg2MTg0MjksInBlcm1pc3Npb24iOiIifQ.dr3HQ3M0kIQKdKdXTMVya-NiA5yC1akDWdDubGgXFWE', 1578618429),
(4885, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc4NjE3NTMyLCJleHAiOjE1Nzg2MTkzMzIsInBlcm1pc3Npb24iOiIifQ.T3JrQ-PFKcomzdHjw1wzRREjZhJqF3QQkICWr6RgcPM', 1578619332),
(4887, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc4NjE4MzM2LCJleHAiOjE1Nzg2MjAxMzYsInBlcm1pc3Npb24iOiIifQ.ztYrPzXsDLYiYjsc2LW0ddoS6SIkprRHQb_3po1KZJA', 1578620136),
(4891, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU3ODY1MzcxMSwiZXhwIjoxNTc4NjU1NTExLCJwZXJtaXNzaW9uIjoiIn0.SIOvX2BfW36QtbiSWomnN67JF9SrbqeRe5SJIyG_SRk', 1578655511),
(4895, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTc4NjU3NDM5LCJleHAiOjE1Nzg2NTkyMzksInBlcm1pc3Npb24iOiIifQ.prj8p7vpvlYIIp-yS5cWOCgQuuG_Z2_yB2N_A73rhbc', 1578659239),
(4899, 1701, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzAxIiwidXNlcm1haWwiOiJwLnNlaXhhczk2QHVhLnB0IiwiaWF0IjoxNTc4NjY0MDI3LCJleHAiOjE1Nzg2NjU4MjcsInBlcm1pc3Npb24iOiIifQ.cjWEJgF4N73cIYzzagOMdc3ztkZcHOpYFEf3A2p_82o', 1578665827),
(4911, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc4Njc2MTA2LCJleHAiOjE1Nzg2Nzc5MDYsInBlcm1pc3Npb24iOiIifQ.wrd9VEzQTQX2C507XEuXoz7g3PJ5LnHWRDdEQZe1KnM', 1578677906),
(4915, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU3ODY5NzQ4MCwiZXhwIjoxNTc4Njk5MjgwLCJwZXJtaXNzaW9uIjoiIn0.mnmDBoE54YHx8bgb3khjv8KuglzUmPFPJwDLA5YYhig', 1578699280),
(4917, 1251, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjUxIiwidXNlcm1haWwiOiJmbXRzQHVhLnB0IiwiaWF0IjoxNTc4Njk5MjE3LCJleHAiOjE1Nzg3MDEwMTcsInBlcm1pc3Npb24iOiIifQ.F7wRb4mZ-Z_jjWV-Jniy3clONTYOj9l31mSq-MneHfA', 1578701017),
(4919, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTc4NzAwOTAzLCJleHAiOjE1Nzg3MDI3MDMsInBlcm1pc3Npb24iOiIifQ.HMmu9PDkSXiuNQ0HeLm5P5Rwqmo9oa0zXhdMGM0Eu8E', 1578702703),
(4923, 1563, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTYzIiwidXNlcm1haWwiOiJtYWNhcmlvLmdvbmNhbG9AdWEucHQiLCJpYXQiOjE1Nzg3NDE0MDEsImV4cCI6MTU3ODc0MzIwMSwicGVybWlzc2lvbiI6IiJ9.5YPENghShQoOMAD4aXg4vB3-pD1rSbSJuAOOiAmVwJ4', 1578743201),
(4927, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc4NzQ2Mzc5LCJleHAiOjE1Nzg3NDgxNzksInBlcm1pc3Npb24iOiIifQ.K90hIGR4b02Ue5klEQJzJRnwUj_QrPpWnbBrmJPdtIg', 1578748179),
(4931, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1Nzg3NTI2MDUsImV4cCI6MTU3ODc1NDQwNSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.MpSPwl12Wt_Hy9XzToasRR6MvlvyLRuoko_PjMsGTAI', 1578754405),
(4935, 1758, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzU4IiwidXNlcm1haWwiOiJwZWRyb21nc291dG9AdWEucHQiLCJpYXQiOjE1Nzg3NTYyNjksImV4cCI6MTU3ODc1ODA2OSwicGVybWlzc2lvbiI6IiJ9.RZspjBJugAu50QRLqQaGCbbxyNztsxhKJ89ePJ8sE_0', 1578758069),
(4939, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTc4NzYzNDkwLCJleHAiOjE1Nzg3NjUyOTAsInBlcm1pc3Npb24iOiIifQ.CLZVd2vSEBjvB2Io90w1xe05sbd-ZZ4-rVXpbHQ1xDw', 1578765290),
(4941, 1701, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzAxIiwidXNlcm1haWwiOiJwLnNlaXhhczk2QHVhLnB0IiwiaWF0IjoxNTc4NzY2NjcyLCJleHAiOjE1Nzg3Njg0NzIsInBlcm1pc3Npb24iOiIifQ.L69Vw1EoIO-YqAJz2kYBIIPcg6Mt5Mglg3HsPNLKMCY', 1578768472),
(4943, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1Nzg3Njc3NDAsImV4cCI6MTU3ODc2OTU0MCwicGVybWlzc2lvbiI6IiJ9.c8CF6u8hQtd-hhJWr8qO6FdlEMjXCXfOOGxDwsw9IHY', 1578769540),
(4947, 2053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUzIiwidXNlcm1haWwiOiJtYXJ0aW5oby50YXZhcmVzQHVhLnB0IiwiaWF0IjoxNTc4Nzg1MzIwLCJleHAiOjE1Nzg3ODcxMjAsInBlcm1pc3Npb24iOiIifQ.4YJI1isPQFjEjKFXW7xNILAk_sXzXmG-C-EvFNP0gSE', 1578787120),
(4949, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1Nzg3ODYzNTYsImV4cCI6MTU3ODc4ODE1NiwicGVybWlzc2lvbiI6IiJ9.QdCZf9WR49-LqSKm1qLxU9LiZre9MvfzafnsvPbZ56Q', 1578788156),
(4953, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc4ODMwMTg4LCJleHAiOjE1Nzg4MzE5ODgsInBlcm1pc3Npb24iOiIifQ.z0z-gxvJzjpoYm-BlZRfzLdGOmnUARxu4kJrMeFzd9Q', 1578831988),
(4957, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTc4ODM2NTYzLCJleHAiOjE1Nzg4MzgzNjMsInBlcm1pc3Npb24iOiIifQ.yzsmyQerD0u2CCUFaE6BmTqAVL1h1ewWqf-dfWuLuPo', 1578838363),
(4961, 1836, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODM2IiwidXNlcm1haWwiOiJyaWNhcmRvLnF1ZXJpZG85OEB1YS5wdCIsImlhdCI6MTU3ODg0NTYwOCwiZXhwIjoxNTc4ODQ3NDA4LCJwZXJtaXNzaW9uIjoiIn0.dmZ7_P20Iz6fkSwe7nH_k6qEBoCqWEp7wy4eD19vQzU', 1578847408),
(4963, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc4ODQ3MTMyLCJleHAiOjE1Nzg4NDg5MzIsInBlcm1pc3Npb24iOiIifQ.xiZIkFeySk9B784p4iFBwf7eO053va367tic6NiVyVk', 1578848932),
(4967, 1983, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTgzIiwidXNlcm1haWwiOiJ0aWJlcmlvLmJhcHRpc3RhQHVhLnB0IiwiaWF0IjoxNTc4ODU1MjAxLCJleHAiOjE1Nzg4NTcwMDEsInBlcm1pc3Npb24iOiIifQ.uvHvJMXYsUj06YUOGOPqyyPpVDdU53MIPdwWBj7nroA', 1578857001),
(4969, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTc4ODU1MjU0LCJleHAiOjE1Nzg4NTcwNTQsInBlcm1pc3Npb24iOiIifQ.XLSbqNvR4cUOfR3kBrAmvgsponeL8HL34zro2lUEhSs', 1578857054),
(4973, 2121, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTIxIiwidXNlcm1haWwiOiJodWdvdC5zaWx2YUB1YS5wdCIsImlhdCI6MTU3ODg1OTg0OSwiZXhwIjoxNTc4ODYxNjQ5LCJwZXJtaXNzaW9uIjoiIn0.aRT1xG066AuzCjoXYGFY2qfPT-3bZbb2P6KpgZjLR40', 1578861649),
(4975, 2121, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTIxIiwidXNlcm1haWwiOiJodWdvdC5zaWx2YUB1YS5wdCIsImlhdCI6MTU3ODg2MTcwNywiZXhwIjoxNTc4ODYzNTA3LCJwZXJtaXNzaW9uIjoiIn0.OxEtXUmewPZTKV59fjxCPXTstsUl2eARWYe2oZkM-r4', 1578863507),
(4979, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1Nzg4NjU5ODAsImV4cCI6MTU3ODg2Nzc4MCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.QOVH88XQ9Nilw3RXbz-w9s3i8xbHhcrG2LwjiO1Pa7w', 1578867780),
(4983, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1Nzg4NzIyNDksImV4cCI6MTU3ODg3NDA0OSwicGVybWlzc2lvbiI6IiJ9._Fg_fx7asMQC-HXCVOhCtDUyGQLguss-YvyebTEWVS8', 1578874049),
(4987, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTc4ODc3MTYwLCJleHAiOjE1Nzg4Nzg5NjAsInBlcm1pc3Npb24iOiIifQ.n1TEG-VtbfclP1q3Rv-5wqzoMZ1ONTaxtK_t5OdT_Ik', 1578878960),
(4989, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1Nzg4NzgxNzUsImV4cCI6MTU3ODg3OTk3NSwicGVybWlzc2lvbiI6IiJ9.unh5KwHVwo06rqAELMoav2HIlmTbhiuH27-VQIwpKHA', 1578879975),
(4993, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1Nzg5MDczMzQsImV4cCI6MTU3ODkwOTEzNCwicGVybWlzc2lvbiI6IiJ9.Y30pfoSGs4PW2pqYlriaKgK0CPWqzon6Irv9tNuSv1k', 1578909134),
(4995, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1Nzg5MDk4NTEsImV4cCI6MTU3ODkxMTY1MSwicGVybWlzc2lvbiI6IiJ9.qFwiXNDGMtsR79WyxFoTX-34BnLL7VXTVD54AFLtMFo', 1578911651),
(4999, 918, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MTgiLCJ1c2VybWFpbCI6ImFuZHJlYnJhbmRhb0B1YS5wdCIsImlhdCI6MTU3ODkxMTcyMiwiZXhwIjoxNTc4OTEzNTIyLCJwZXJtaXNzaW9uIjoiIn0.vv8EDSSVlV_IOHX5BQTGwYEO-em10ts4SSitcclAkfQ', 1578913522),
(5003, 1365, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzY1IiwidXNlcm1haWwiOiJqYXJ0dXJjb3N0YUB1YS5wdCIsImlhdCI6MTU3ODkxNDIyNCwiZXhwIjoxNTc4OTE2MDI0LCJwZXJtaXNzaW9uIjoiIn0.EhzU4193lT9fahwFp6Iio7ElQauP-EDInHOrCg5O2nQ', 1578916024),
(5005, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc4OTE1Mjk3LCJleHAiOjE1Nzg5MTcwOTcsInBlcm1pc3Npb24iOiIifQ.sFBJifGAQ6NpvAtw2KkYvDqZRc5i32cc1in3EFPM3qs', 1578917097),
(5009, 1365, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzY1IiwidXNlcm1haWwiOiJqYXJ0dXJjb3N0YUB1YS5wdCIsImlhdCI6MTU3ODkxOTgxMSwiZXhwIjoxNTc4OTIxNjExLCJwZXJtaXNzaW9uIjoiIn0.EHrcfLIa77LpfIqEXxHrOq9p2Yc67UEtOe-3kOpngVw', 1578921611),
(5013, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc4OTMwNDY1LCJleHAiOjE1Nzg5MzIyNjUsInBlcm1pc3Npb24iOiIifQ.bg7CeMrSgq5ayAwN_fTm_98kkX0avgM8F4_g1-D9Dms', 1578932265),
(5015, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc4OTMwNDk4LCJleHAiOjE1Nzg5MzIyOTgsInBlcm1pc3Npb24iOiIifQ.nUOBF8rV1DoIgWb3vsybOMNzM5QpEx99_fD7GrlS_1E', 1578932298),
(5019, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1Nzg5MzU1MjAsImV4cCI6MTU3ODkzNzMyMCwicGVybWlzc2lvbiI6IiJ9.KpncSoc28gD9tk4pUrw1DpjO49ThoBp9XGWk6Jby450', 1578937320),
(5023, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1Nzg5Mzg0ODEsImV4cCI6MTU3ODk0MDI4MSwicGVybWlzc2lvbiI6IiJ9.yIayQ_Ciq9uW8B-l99x1TuVxRAM_KZm0Jn8jLkC_H3g', 1578940281),
(5025, 1644, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjQ0IiwidXNlcm1haWwiOiJtaWd1ZWwuZnJhZGluaG9AdWEucHQiLCJpYXQiOjE1Nzg5NDA2NzQsImV4cCI6MTU3ODk0MjQ3NCwicGVybWlzc2lvbiI6IiJ9.VFQ1dVitaOfqv0EaVX67QVBMQw_Lh892AtR9a0F6I2M', 1578942474),
(5029, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3ODk0NjQyMCwiZXhwIjoxNTc4OTQ4MjIwLCJwZXJtaXNzaW9uIjoiIn0.wbbuZ0OmWb6lcqSFeGwUdWDgupDHo0zn66wpedingRg', 1578948220),
(5033, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1Nzg5NTA3NzMsImV4cCI6MTU3ODk1MjU3MywicGVybWlzc2lvbiI6IiJ9.SMJ144BBHlhn4UQegrD6cetg4edfiO97kYYbi7m367I', 1578952573),
(5039, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc4OTYxMzAzLCJleHAiOjE1Nzg5NjMxMDMsInBlcm1pc3Npb24iOiIifQ.WbRZp-a6hoJKrgWkg7xQ3rZAoNiL0XmcHgZ-KK4yQR8', 1578963103),
(5041, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1Nzg5NjIzOTIsImV4cCI6MTU3ODk2NDE5MiwicGVybWlzc2lvbiI6IiJ9.Esgypk5ULILIco8z8_pfKTz5qX_Qh-YFJ0JrmxXhih4', 1578964192),
(5043, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTc4OTYyODE1LCJleHAiOjE1Nzg5NjQ2MTUsInBlcm1pc3Npb24iOiIifQ.eTVSevIdfc3j3hXHJhQCfxIvba4Aa85TalqkJZKnSkE', 1578964615),
(5045, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc4OTYyODI2LCJleHAiOjE1Nzg5NjQ2MjYsInBlcm1pc3Npb24iOiIifQ.YhuFnOmyK6BlB_c9TSHzV4_hfzf3fh_cnLS4uJQ1iJ8', 1578964626),
(5049, 2038, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM4IiwidXNlcm1haWwiOiJlZHVhcmRvZmVybmFuZGVzQHVhLnB0IiwiaWF0IjoxNTc5MDE4NDkyLCJleHAiOjE1NzkwMjAyOTIsInBlcm1pc3Npb24iOiIifQ.a8lQKm6RU2J7ffrJtj_329ZPL1XSd2n0Ue8uMrgncbw', 1579020292),
(5051, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzkwMTg1ODYsImV4cCI6MTU3OTAyMDM4NiwicGVybWlzc2lvbiI6IiJ9.Dd9GkHy_oGBgvekHGh7lmADtdou5diDqMpnsPmYPr4I', 1579020386),
(5055, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc5MDIyNTg3LCJleHAiOjE1NzkwMjQzODcsInBlcm1pc3Npb24iOiIifQ.GFc-j6UOsVJYUfYnnWksqexNOhJCwW3zF5dTlLboWXs', 1579024387),
(5057, 990, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTAiLCJ1c2VybWFpbCI6ImJydW5vcmFiYWNhbEB1YS5wdCIsImlhdCI6MTU3OTAyMjY4NywiZXhwIjoxNTc5MDI0NDg3LCJwZXJtaXNzaW9uIjoiIn0.f9eOxXuWL1JCE63tfdOkgnEoO59fLNyyXkv20OnfxJI', 1579024487),
(5061, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTc5MDI2NzczLCJleHAiOjE1NzkwMjg1NzMsInBlcm1pc3Npb24iOiIifQ.1jIF4TF2qvFxYBsskDpgWrQFC6Yp1RoBlkI1Su51Avk', 1579028573),
(5063, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzkwMjgwNzYsImV4cCI6MTU3OTAyOTg3NiwicGVybWlzc2lvbiI6IiJ9.vk5Z0tiSRh0zragLCOsKx0BPk4WFGtGfuN0iXku3pfM', 1579029876),
(5065, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTc5MDI5MDYwLCJleHAiOjE1NzkwMzA4NjAsInBlcm1pc3Npb24iOiIifQ.7zPfSMo_8QTozahenRFQwepGPwWn4hOgFZMjekG2LGM', 1579030860),
(5067, 1815, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODE1IiwidXNlcm1haWwiOiJyZW5hbmFmZXJyZWlyYUB1YS5wdCIsImlhdCI6MTU3OTAzMTQ1NiwiZXhwIjoxNTc5MDMzMjU2LCJwZXJtaXNzaW9uIjoiIn0.mjBLrjZoJrOZj2umzNKiSZ1tabfUT8ajN6hBwF68KBo', 1579033256),
(5069, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1NzkwMzIyMDcsImV4cCI6MTU3OTAzNDAwNywicGVybWlzc2lvbiI6IiJ9.CVzTOaEd-BirMTgQI6fiia1P6xKimQ-OEe-s3zbJhYw', 1579034007),
(5073, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc5MDQyNTYzLCJleHAiOjE1NzkwNDQzNjMsInBlcm1pc3Npb24iOiIifQ.tpwWq-Lq1MOTq3N9deNB6zyQ8K9WJgmfo9XkQvg4S_g', 1579044363),
(5075, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTc5MDQ0MjEyLCJleHAiOjE1NzkwNDYwMTIsInBlcm1pc3Npb24iOiIifQ.0fqewwYkimg2-gvSMQ-m408ymOfwZ_28vS0r-TFIcZI', 1579046012),
(5079, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTc5MDUwMTA1LCJleHAiOjE1NzkwNTE5MDUsInBlcm1pc3Npb24iOiIifQ.PXbkiWGtN56Ime08gA5gpDnXc1dkO97ra_LZbut5Jek', 1579051905),
(5083, 945, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NDUiLCJ1c2VybWFpbCI6ImFudG9uaW9qb3JnZWZlcm5hbmRlc0B1YS5wdCIsImlhdCI6MTU3OTA2MDI1OSwiZXhwIjoxNTc5MDYyMDU5LCJwZXJtaXNzaW9uIjoiIn0.BAFyGiNVGA1HPgOgeqZh0KB83NbQr81HFjLJ6r-EJkI', 1579062059),
(5087, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc5MDg4Njc4LCJleHAiOjE1NzkwOTA0NzgsInBlcm1pc3Npb24iOiIifQ.AvaEgankJGzj9Y6oHf5ZAF7F7JpJfiNo6gyljmw-hHc', 1579090478),
(5089, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1NzkwOTAzMzksImV4cCI6MTU3OTA5MjEzOSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.y5w261snzemE40i0qUVPGxJBOZPZb5FQNiILJO_js48', 1579092139),
(5091, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc5MDkyMDYyLCJleHAiOjE1NzkwOTM4NjIsInBlcm1pc3Npb24iOiIifQ.EzoD_nC0FUentT5eudQCvM1Er1eq9l9MHXnY8tYlDaE', 1579093862),
(5093, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTc5MDk0NDE0LCJleHAiOjE1NzkwOTYyMTQsInBlcm1pc3Npb24iOiIifQ.ZBOeIzGtnTtLYUJVAvB4IA4KDmVqtOGVAx9uLOLzbgY', 1579096214),
(5097, 1827, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODI3IiwidXNlcm1haWwiOiJyaWNhcmRvLmNydXoyOUB1YS5wdCIsImlhdCI6MTU3OTA5NzM0OSwiZXhwIjoxNTc5MDk5MTQ5LCJwZXJtaXNzaW9uIjoiIn0.BcOFdJNb9G4Ye7ouPHoAU77u3fmAhOTwA6trz28FgY4', 1579099149),
(5099, 840, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDAiLCJ1c2VybWFpbCI6ImFhbXJvZHJpZ3Vlc0B1YS5wdCIsImlhdCI6MTU3OTA5OTIyNywiZXhwIjoxNTc5MTAxMDI3LCJwZXJtaXNzaW9uIjoiIn0.eabWq3b-bGA9AJ44HfJIu3YdRjwIJaowLDuHmZiZ47g', 1579101027),
(5101, 840, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDAiLCJ1c2VybWFpbCI6ImFhbXJvZHJpZ3Vlc0B1YS5wdCIsImlhdCI6MTU3OTA5OTI1NSwiZXhwIjoxNTc5MTAxMDU1LCJwZXJtaXNzaW9uIjoiIn0.bKPxbPzb0w9cJrwFDl-2PlFVbQ1o6gIMczC_AvkYfMU', 1579101055),
(5103, 1749, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzQ5IiwidXNlcm1haWwiOiJwZWRyb2ZvbnNlY2E5OEB1YS5wdCIsImlhdCI6MTU3OTA5OTUxNywiZXhwIjoxNTc5MTAxMzE3LCJwZXJtaXNzaW9uIjoiIn0.MWLLi5yQrEkW774oUYixqnzmoCzWLF4c_Y2_WRHs_0Y', 1579101317),
(5105, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc5MTAwNDY0LCJleHAiOjE1NzkxMDIyNjQsInBlcm1pc3Npb24iOiIifQ.ZPp1ZvzfFwRD4_ITF3nlinVEAXbYDQ4zhweWGeqjiNg', 1579102264),
(5107, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTc5MTAwNzk1LCJleHAiOjE1NzkxMDI1OTUsInBlcm1pc3Npb24iOiIifQ.o00zOUyVpso4h8xcYoVM0AteIwwE372rXl-50KvVrC8', 1579102595),
(5109, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1NzkxMDI0ODksImV4cCI6MTU3OTEwNDI4OSwicGVybWlzc2lvbiI6IiJ9.XmQF4y9yBglnIFPkIpdR2RT9aCH_5fdhGPABqXH4ahs', 1579104289),
(5113, 990, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTAiLCJ1c2VybWFpbCI6ImJydW5vcmFiYWNhbEB1YS5wdCIsImlhdCI6MTU3OTEwNzgzOSwiZXhwIjoxNTc5MTA5NjM5LCJwZXJtaXNzaW9uIjoiIn0.RmMsNr4_-qIgHEG2Joc9KTF7nxvJ_8tN_eFi0lTh0_8', 1579109639),
(5117, 2121, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTIxIiwidXNlcm1haWwiOiJodWdvdC5zaWx2YUB1YS5wdCIsImlhdCI6MTU3OTExMjkxNCwiZXhwIjoxNTc5MTE0NzE0LCJwZXJtaXNzaW9uIjoiIn0.Kvu7I13r4dPJVMNKc6w8fH-SrU9As3jibw4dAMVU5-Q', 1579114714),
(5121, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzkxMTg0MzAsImV4cCI6MTU3OTEyMDIzMCwicGVybWlzc2lvbiI6IiJ9.sR5SwUUZVhmdBqrswDCofplnnIByv5QTVDs_jFNJpNw', 1579120230),
(5125, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1NzkxMjgxNzAsImV4cCI6MTU3OTEyOTk3MCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.l7wVgBNghHVH4iZentCpb0v8aY5dPy7QBnnPxGbLOQk', 1579129970),
(5129, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1NzkxMzM2ODgsImV4cCI6MTU3OTEzNTQ4OCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.pFmq1e5z0_flJczztKFQU5eLqq2rK5AbweJyD-liWms', 1579135488),
(5133, 1173, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTczIiwidXNlcm1haWwiOiJkbWF0aWFzcGludG9AdWEucHQiLCJpYXQiOjE1NzkxNjc4MTAsImV4cCI6MTU3OTE2OTYxMCwicGVybWlzc2lvbiI6IiJ9.sfvKN3nQCuBssSdXCHwis7OUPbev5OVlJFpQLpp9xjQ', 1579169610),
(5137, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc5MTc4OTExLCJleHAiOjE1NzkxODA3MTEsInBlcm1pc3Npb24iOiIifQ.ao7BBpAo9oQFg60h3KFKDn69ZSiKUIpIK2JEtDl6bj4', 1579180711),
(5141, 1749, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzQ5IiwidXNlcm1haWwiOiJwZWRyb2ZvbnNlY2E5OEB1YS5wdCIsImlhdCI6MTU3OTE5MDI1MywiZXhwIjoxNTc5MTkyMDUzLCJwZXJtaXNzaW9uIjoiIn0.5ORCvSQitrf03iYsO0twXJuJuwsvDyg7UIHwFlvSgO8', 1579192053),
(5145, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTc5MTkzMjMzLCJleHAiOjE1NzkxOTUwMzMsInBlcm1pc3Npb24iOiIifQ.LvRNEIeDQdIGcFO6djZDB6UVoM2Iq4HXS6AKecFBksI', 1579195033),
(5147, 1278, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc4IiwidXNlcm1haWwiOiJnb25jYWxvLmFsbWVpZGFAdWEucHQiLCJpYXQiOjE1NzkxOTQxMTgsImV4cCI6MTU3OTE5NTkxOCwicGVybWlzc2lvbiI6IiJ9.TAS3RbSlDrstUbQ_vQIOUhzQhgr3zwzinGOuGA2bTQg', 1579195918),
(5149, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTc5MTk0MTM3LCJleHAiOjE1NzkxOTU5MzcsInBlcm1pc3Npb24iOiIifQ.aM6D6JimD42l33k5ZodOSGewyn-AzARKnCUjCVt0OdQ', 1579195937),
(5153, 2121, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTIxIiwidXNlcm1haWwiOiJodWdvdC5zaWx2YUB1YS5wdCIsImlhdCI6MTU3OTIwNTU2NCwiZXhwIjoxNTc5MjA3MzY0LCJwZXJtaXNzaW9uIjoiIn0.sdARc3YeCD3yxmKJ-rc99Ro61y-LI036G1fL3qEQScs', 1579207364),
(5157, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU3OTIxOTIzNSwiZXhwIjoxNTc5MjIxMDM1LCJwZXJtaXNzaW9uIjoiIn0.aOERcXT61p8csCes6Gncb5QoPypg4SaP33Et3D1TEV4', 1579221035),
(5161, 1395, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzk1IiwidXNlcm1haWwiOiJqb2FvLnAubWFycXVlc0B1YS5wdCIsImlhdCI6MTU3OTI1ODM2NiwiZXhwIjoxNTc5MjYwMTY2LCJwZXJtaXNzaW9uIjoiIn0.dz1eWxn1nbNCKXNEB-MOJrnwIOd9x9gRl3Lc8qN2guc', 1579260166),
(5165, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1NzkyNjc0MjIsImV4cCI6MTU3OTI2OTIyMiwicGVybWlzc2lvbiI6IiJ9.CU_1ASDcWIAxj4G-7NA7YvWFaPQV5QDLn7IB-RiiRao', 1579269222),
(5169, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc5MjcxMjkzLCJleHAiOjE1NzkyNzMwOTMsInBlcm1pc3Npb24iOiIifQ.qoxKLsbVzIvVrbnYjJ5v-XK6GoMJssqE6O7x5W9196Q', 1579273093),
(5171, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTc5MjcyOTM3LCJleHAiOjE1NzkyNzQ3MzcsInBlcm1pc3Npb24iOiIifQ.DkeyEF-oaFgDI8llw7WXTS6iEYx1z7gDdVGcOheAdHc', 1579274737),
(5175, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc5Mjc1NDk5LCJleHAiOjE1NzkyNzcyOTksInBlcm1pc3Npb24iOiIifQ.fgJSmnYqtG5Bu5h1iDWyrbSWBcYkCJkb8INN4stzSRs', 1579277299),
(5179, 1383, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzgzIiwidXNlcm1haWwiOiJqb2FvLmNhcnZhbGhvMTlAdWEucHQiLCJpYXQiOjE1NzkyODE3MzQsImV4cCI6MTU3OTI4MzUzNCwicGVybWlzc2lvbiI6IiJ9.mSEUxVyicH8v1s9gaBl79Y9nRbMUF0j_COfFnyCwlSw', 1579283534),
(5181, 888, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4ODgiLCJ1c2VybWFpbCI6ImFuYWFAdWEucHQiLCJpYXQiOjE1NzkyODM0OTMsImV4cCI6MTU3OTI4NTI5MywicGVybWlzc2lvbiI6IiJ9.ih6TTrzMueMzFIH-l4Py9oPwBrFK7Iv5PZJx1JxyMIA', 1579285293),
(5185, 1212, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjEyIiwidXNlcm1haWwiOiJmLmZvbnRpbmhhQHVhLnB0IiwiaWF0IjoxNTc5MzAzOTI2LCJleHAiOjE1NzkzMDU3MjYsInBlcm1pc3Npb24iOiIifQ.rFL-u9Zb2smeqykUV5dQAmPfBJKXeJkikhOjzqLdJAs', 1579305726),
(5189, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzkzMTU1NTgsImV4cCI6MTU3OTMxNzM1OCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.7KOS1ZXZ9Y6AEYZQ0E4XjaXjVoLLSJAlll0cXZyu5V8', 1579317358),
(5191, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzkzMTc0MzgsImV4cCI6MTU3OTMxOTIzOCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.l-BniYvtksBdfT7KS9W7Ijdxuccw-nttY7jUpKsjYvM', 1579319238),
(5195, 1794, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzk0IiwidXNlcm1haWwiOiJyLm1lbG9AdWEucHQiLCJpYXQiOjE1NzkzMjU3OTMsImV4cCI6MTU3OTMyNzU5MywicGVybWlzc2lvbiI6IiJ9.eYNfXemAonrE1qdAYDDHrUi7kXzuuQtjLBeW9Qg2jVU', 1579327593),
(5199, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc5MzM4NjEyLCJleHAiOjE1NzkzNDA0MTIsInBlcm1pc3Npb24iOiIifQ.U3maduQF-ePSe03_yQoX5r3BHUchFpIkc-ms5isAtrM', 1579340412),
(5201, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTc5MzQxNTk0LCJleHAiOjE1NzkzNDMzOTQsInBlcm1pc3Npb24iOiIifQ.CQfhYZ7Y7Y-2Prp3jm2JFCFE7ryWZRG13oIoZndRcIw', 1579343394),
(5203, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3OTM0NDAxNSwiZXhwIjoxNTc5MzQ1ODE1LCJwZXJtaXNzaW9uIjoiIn0.BnEhKNbl9Ggk-kCHzsQ4vnRHy5m7alD12tlbJpwkngs', 1579345815),
(5207, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1NzkzNDg4MjksImV4cCI6MTU3OTM1MDYyOSwicGVybWlzc2lvbiI6IiJ9.NZGd0n5rv5KV_y9KR56jxtZelMNIrPt-YkIpzmK_xPM', 1579350629),
(5211, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc5MzU1NTQwLCJleHAiOjE1NzkzNTczNDAsInBlcm1pc3Npb24iOiIifQ.1APQ1kBqJfWAiXe9GVLA_dJMdUa1roe7SuSK9OV3ZpQ', 1579357340),
(5213, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc5MzU1NjY0LCJleHAiOjE1NzkzNTc0NjQsInBlcm1pc3Npb24iOiIifQ.fN3olzRfzImKKKmBTPUS-__K2OADI12rT1CbO1rAAz4', 1579357464),
(5215, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU3OTM1NTY4NywiZXhwIjoxNTc5MzU3NDg3LCJwZXJtaXNzaW9uIjoiIn0.8F-qwMSKDGpZw2vx59OcuUo_HzgrBvsxfm5Afn6xg7U', 1579357487),
(5217, 1341, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQxIiwidXNlcm1haWwiOiJpbmVzLnBsQHVhLnB0IiwiaWF0IjoxNTc5MzU3MDkyLCJleHAiOjE1NzkzNTg4OTIsInBlcm1pc3Npb24iOiIifQ.qgwNcaaQZrD1IGfooFGJ9QTbA_rlTpgtMN2nmrforLQ', 1579358892),
(5219, 1749, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzQ5IiwidXNlcm1haWwiOiJwZWRyb2ZvbnNlY2E5OEB1YS5wdCIsImlhdCI6MTU3OTM1NzcwMSwiZXhwIjoxNTc5MzU5NTAxLCJwZXJtaXNzaW9uIjoiIn0.xZfkm4-Nk2YqW4qdkJ_NVd4zWAv72xQGTzcIbvc5W-4', 1579359501),
(5221, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc5MzU4MDI4LCJleHAiOjE1NzkzNTk4MjgsInBlcm1pc3Npb24iOiIifQ.S54JA4ebY8OOxOacrVq4mQ92LPug_vq6P4_0b5rYMtY', 1579359828),
(5223, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1NzkzNTk2MjksImV4cCI6MTU3OTM2MTQyOSwicGVybWlzc2lvbiI6IiJ9.sa0moQ6d-_vQw9GQDX3ZXb4NJSOUL_rzkx99WyLJY48', 1579361429),
(5227, 1173, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTczIiwidXNlcm1haWwiOiJkbWF0aWFzcGludG9AdWEucHQiLCJpYXQiOjE1NzkzNjQ2NzEsImV4cCI6MTU3OTM2NjQ3MSwicGVybWlzc2lvbiI6IiJ9.mxwRXYccBzda10hErnyaiGR-zZEGGkmZ7wSX5ZdMpD8', 1579366471),
(5229, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1NzkzNjUyMzQsImV4cCI6MTU3OTM2NzAzNCwicGVybWlzc2lvbiI6IiJ9.EJIq6Hc-7u6gMoaTyXNsab3hLxchzqOl-hFEk4896UY', 1579367034),
(5231, 1173, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTczIiwidXNlcm1haWwiOiJkbWF0aWFzcGludG9AdWEucHQiLCJpYXQiOjE1NzkzNjY3NDIsImV4cCI6MTU3OTM2ODU0MiwicGVybWlzc2lvbiI6IiJ9.gRfxt2n2aLrJGUyFZqbn04wkXthYeW1IxEJKHjPuAP0', 1579368542),
(5235, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1NzkzNzI4MzIsImV4cCI6MTU3OTM3NDYzMiwicGVybWlzc2lvbiI6IiJ9.9B1S0XFsvEAs0g_RyN1T5U45aldbKyQmLiQwfwAev6Q', 1579374632),
(5237, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU3OTM3NTUxNiwiZXhwIjoxNTc5Mzc3MzE2LCJwZXJtaXNzaW9uIjoiIn0.lUOajWYNCX9GsFR17zuqnq66XRvV5cYm1Yx6GmHGQss', 1579377316);
INSERT INTO `GenTokens` (`id`, `userid`, `token`, `expire_date`) VALUES
(5241, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTc5Mzg2NzEwLCJleHAiOjE1NzkzODg1MTAsInBlcm1pc3Npb24iOiIifQ.IM3lPd3Zzqb9c4U1QB30fPbNUrt4PEYOTvBjW8tIRhY', 1579388510),
(5245, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1NzkzOTMxODIsImV4cCI6MTU3OTM5NDk4MiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.rdKnqBK05PaOuv9b6yOyxxAHt4vB5Hb_rLsAr4Kvrig', 1579394982),
(5247, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTc5Mzk1ODI1LCJleHAiOjE1NzkzOTc2MjUsInBlcm1pc3Npb24iOiIifQ.fYRbKSIVQaxh1WqPGmf056p3Cxenjl9htluy5dAhHKU', 1579397625),
(5251, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc5NDE5ODE3LCJleHAiOjE1Nzk0MjE2MTcsInBlcm1pc3Npb24iOiIifQ.JuSmjyPyqNFn-iOMKNzF5cpAY-jvD6kwbjpcOgopEkY', 1579421617),
(5255, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU3OTQzNDQxNSwiZXhwIjoxNTc5NDM2MjE1LCJwZXJtaXNzaW9uIjoiIn0.MLX94L6vVPYXkd56mAi1NBVLv7-6D4xZ98cU7aAg2e0', 1579436215),
(5259, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc5NDM3Njk5LCJleHAiOjE1Nzk0Mzk0OTksInBlcm1pc3Npb24iOiIifQ.Imw2K4saXj--mZyWId0cJwlBL_1PTEX6H-VcH567Nb4', 1579439499),
(5263, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTc5NDUyNDAwLCJleHAiOjE1Nzk0NTQyMDAsInBlcm1pc3Npb24iOiIifQ.iot2LCkaiCbg6dCXFE1NbjKfxV5AT-mWDbPLDNBKopY', 1579454200),
(5265, 1749, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzQ5IiwidXNlcm1haWwiOiJwZWRyb2ZvbnNlY2E5OEB1YS5wdCIsImlhdCI6MTU3OTQ1NDk0NSwiZXhwIjoxNTc5NDU2NzQ1LCJwZXJtaXNzaW9uIjoiIn0.LHWjmEnnbXEMXgyhYfY8Yv6hfxxvnFnS3NfHa4s4lYE', 1579456745),
(5267, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc5NDU1NjM5LCJleHAiOjE1Nzk0NTc0MzksInBlcm1pc3Npb24iOiIifQ.HyeBU-ZCfWsmgfdhH04Giu6A3rAmnz5wDvduVDIsVa8', 1579457439),
(5271, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc5NDYzMzU0LCJleHAiOjE1Nzk0NjUxNTQsInBlcm1pc3Npb24iOiIifQ.opFMqMm04wtF2pk34v1q7tV7KJ6zzfqAa3qnUp7PqXc', 1579465154),
(5273, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1Nzk0NjM3MDksImV4cCI6MTU3OTQ2NTUwOSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.cys-IHs0EQP1CDMX17uNSJn8Ygo1gABWOJRVsH8P2GQ', 1579465509),
(5275, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc5NDY1ODQ0LCJleHAiOjE1Nzk0Njc2NDQsInBlcm1pc3Npb24iOiIifQ.pdqagHhY5vqjqQhhLtmQI-AMQassc_PDz7jIAj-B2qo', 1579467644),
(5277, 1278, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc4IiwidXNlcm1haWwiOiJnb25jYWxvLmFsbWVpZGFAdWEucHQiLCJpYXQiOjE1Nzk0Njg4NzksImV4cCI6MTU3OTQ3MDY3OSwicGVybWlzc2lvbiI6IiJ9.PoaBHgW2q9aRsZytntaGf1zxhG99RdNP7pafttK2IB4', 1579470679),
(5281, 1212, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjEyIiwidXNlcm1haWwiOiJmLmZvbnRpbmhhQHVhLnB0IiwiaWF0IjoxNTc5NDc0MzkyLCJleHAiOjE1Nzk0NzYxOTIsInBlcm1pc3Npb24iOiIifQ.yYILd-r64XoZLqbEGxEFxmHDtsVIlGfQMD3k68uYY2s', 1579476192),
(5285, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTc5NDc5Njk4LCJleHAiOjE1Nzk0ODE0OTgsInBlcm1pc3Npb24iOiIifQ.MMvN6ej80bJRSw-2zNgd3ZOVQgo6z7AluOnUP_A6-nw', 1579481498),
(5287, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1Nzk0ODAwMTAsImV4cCI6MTU3OTQ4MTgxMCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.-WA3TKiRNAsfN65ZcaK-LnJ2dn0szwDrlruq60y_ekk', 1579481810),
(5289, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTc5NDgyNDc4LCJleHAiOjE1Nzk0ODQyNzgsInBlcm1pc3Npb24iOiIifQ.GipOTnTssvtmVgM1hoJLy43okG4uzW3eqTyz3qAbugg', 1579484278),
(5291, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1Nzk0ODQyMDIsImV4cCI6MTU3OTQ4NjAwMiwicGVybWlzc2lvbiI6IiJ9.nmEqTQEr0Fhu_TY62eGBkxJ5Hm_oCYsKZCidhyBvpnQ', 1579486002),
(5295, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1Nzk0OTk1MjksImV4cCI6MTU3OTUwMTMyOSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.3fI0NZupde_sibNP5oZ1vYLyVMiNTKtFPg6zCINFZP4', 1579501329),
(5299, 1620, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjIwIiwidXNlcm1haWwiOiJtYXJpb3NpbHZhQHVhLnB0IiwiaWF0IjoxNTc5NTE5MTM3LCJleHAiOjE1Nzk1MjA5MzcsInBlcm1pc3Npb24iOiIifQ.mxAo4Qwg0zFfo93q7o9wMMQPtNSLVNDnBnJXmpK0Kjc', 1579520937),
(5301, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1Nzk1MjE1MzYsImV4cCI6MTU3OTUyMzMzNiwicGVybWlzc2lvbiI6IiJ9.MB-2dY188DOGOaB6EpDiScOLSq5SmfNp9pKkQqV6pGs', 1579523336),
(5305, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTc5NTM2NTM4LCJleHAiOjE1Nzk1MzgzMzgsInBlcm1pc3Npb24iOiIifQ.v6LP4-1GmI-TEh2Vq1dqtJmTlWC7JLXN9jgiubXU8jc', 1579538338),
(5309, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTc5NTQwODU3LCJleHAiOjE1Nzk1NDI2NTcsInBlcm1pc3Npb24iOiIifQ.3vWna_3CwNYGQdXgKsFC01K7Qn6LfKWod-Q5C4RoSCE', 1579542657),
(5311, 2121, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTIxIiwidXNlcm1haWwiOiJodWdvdC5zaWx2YUB1YS5wdCIsImlhdCI6MTU3OTU0MjIxNCwiZXhwIjoxNTc5NTQ0MDE0LCJwZXJtaXNzaW9uIjoiIn0.pXqay42Y4C5LGAJPjDQ_cSg03kgnKeei-0H_U4BH5KI', 1579544014),
(5313, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTc5NTQ0ODY1LCJleHAiOjE1Nzk1NDY2NjUsInBlcm1pc3Npb24iOiIifQ.speZiCawQ_oK19TpkSqx6tfPbrEq00TcYBZfHTJY0ns', 1579546665),
(5315, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc5NTQ3NDA3LCJleHAiOjE1Nzk1NDkyMDcsInBlcm1pc3Npb24iOiIifQ.OQYM8Yos1aamzpl7_e8jgw6WRQaPCy19-VwMr-XPUrg', 1579549207),
(5319, 1806, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA2IiwidXNlcm1haWwiOiJyYWZhZWxndGVpeGVpcmFAdWEucHQiLCJpYXQiOjE1Nzk1NTIwNDgsImV4cCI6MTU3OTU1Mzg0OCwicGVybWlzc2lvbiI6IiJ9.HmH0Ob6AvRvQmTI-hHNpu-hr9gAagYoCXscrGfZUvtU', 1579553848),
(5323, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTc5NTU2ODY2LCJleHAiOjE1Nzk1NTg2NjYsInBlcm1pc3Npb24iOiIifQ.mItWVAzyRniRjonEEISLKean-L0zqOO3itseFxG3_hU', 1579558666),
(5327, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTc5NTk1NDgyLCJleHAiOjE1Nzk1OTcyODIsInBlcm1pc3Npb24iOiIifQ.tJ4u8WrDFeCZ4lIlerzKbyLQbYDXwK2MQIMSz5N5lJM', 1579597282),
(5331, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1Nzk2MDMyOTksImV4cCI6MTU3OTYwNTA5OSwicGVybWlzc2lvbiI6IiJ9.VV4Vl8ccUahz-k8tCy6xsB-ZYHFsZZVtZ1tz082uRqc', 1579605099),
(5333, 1212, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjEyIiwidXNlcm1haWwiOiJmLmZvbnRpbmhhQHVhLnB0IiwiaWF0IjoxNTc5NjA1NTI3LCJleHAiOjE1Nzk2MDczMjcsInBlcm1pc3Npb24iOiIifQ.o_drKrCrB_WjyNtzg0goX9TKWUw0-QzfygDmANTlEAU', 1579607327),
(5335, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1Nzk2MDc1NDgsImV4cCI6MTU3OTYwOTM0OCwicGVybWlzc2lvbiI6IiJ9.5m9AFrgmh1cLgn3Fv90gwESzswHxqxJLPOyY_5xdG28', 1579609348),
(5339, 1689, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjg5IiwidXNlcm1haWwiOiJudW5vLm1hdGFtYmFAdWEucHQiLCJpYXQiOjE1Nzk2MTEwODQsImV4cCI6MTU3OTYxMjg4NCwicGVybWlzc2lvbiI6IiJ9.4TxhvXTQvaxZf24LE3rwVVsiXomINcvRu_8EJ8T2BJE', 1579612884),
(5341, 1341, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQxIiwidXNlcm1haWwiOiJpbmVzLnBsQHVhLnB0IiwiaWF0IjoxNTc5NjEzMzI5LCJleHAiOjE1Nzk2MTUxMjksInBlcm1pc3Npb24iOiIifQ.1H7t9xafoig2qxNoRjypqz7SR8s2zcL9FdQ-T-O8MRQ', 1579615129),
(5349, 990, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTAiLCJ1c2VybWFpbCI6ImJydW5vcmFiYWNhbEB1YS5wdCIsImlhdCI6MTU3OTYzMDk0MywiZXhwIjoxNTc5NjMyNzQzLCJwZXJtaXNzaW9uIjoiIn0.yyHcSRy3D0-qjhLCZwA6n4PJZ7riYfbm569fXOX0tnU', 1579632743),
(5353, 1341, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQxIiwidXNlcm1haWwiOiJpbmVzLnBsQHVhLnB0IiwiaWF0IjoxNTc5NjQzODA3LCJleHAiOjE1Nzk2NDU2MDcsInBlcm1pc3Npb24iOiIifQ.0x5K6vgNwyF3SHfdTBg95K3FviyZAhmyWvDUUU1h5Fs', 1579645607),
(5357, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTc5NjYyMDAyLCJleHAiOjE1Nzk2NjM4MDIsInBlcm1pc3Npb24iOiIifQ.t735uPyAN319rSBXJtR0M9yG0hs31poViv7Vm2vA2C0', 1579663802),
(5361, 1494, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDk0IiwidXNlcm1haWwiOiJqb3NlcmVpc0B1YS5wdCIsImlhdCI6MTU3OTY5MDE5NCwiZXhwIjoxNTc5NjkxOTk0LCJwZXJtaXNzaW9uIjoiIn0.Wc0GK6juO76S6--npLPElqTUwn4PM4eSXGZpKdMeXjY', 1579691994),
(5363, 1494, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDk0IiwidXNlcm1haWwiOiJqb3NlcmVpc0B1YS5wdCIsImlhdCI6MTU3OTY5MDIyNywiZXhwIjoxNTc5NjkyMDI3LCJwZXJtaXNzaW9uIjoiIn0.7equ9gZRC_tB4trunOKI-u_nf8MvhFAkiObVABNS2jw', 1579692027),
(5367, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1Nzk3MDM2ODQsImV4cCI6MTU3OTcwNTQ4NCwicGVybWlzc2lvbiI6IiJ9.niiT_o0Cag3xJoX_Sjvm6wzMaMyOD9WJl6miwEm5NBA', 1579705484),
(5371, 1806, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA2IiwidXNlcm1haWwiOiJyYWZhZWxndGVpeGVpcmFAdWEucHQiLCJpYXQiOjE1Nzk3MDgyNzcsImV4cCI6MTU3OTcxMDA3NywicGVybWlzc2lvbiI6IiJ9.OkXmVWcFXW6S9TRhAM8E7FaEJ7xSiloE7TLrEqg3hCg', 1579710077),
(5373, 987, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5ODciLCJ1c2VybWFpbCI6ImJydW5vcGludG81MTUxQHVhLnB0IiwiaWF0IjoxNTc5NzA4ODg5LCJleHAiOjE1Nzk3MTA2ODksInBlcm1pc3Npb24iOiIifQ.4Ck_5H8iLINrXxVOyxtye1sn3v7IdLQBXDt_n1nKJ6E', 1579710689),
(5377, 1689, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjg5IiwidXNlcm1haWwiOiJudW5vLm1hdGFtYmFAdWEucHQiLCJpYXQiOjE1Nzk3MTM1MjAsImV4cCI6MTU3OTcxNTMyMCwicGVybWlzc2lvbiI6IiJ9.1NX4e3otxZpLnkk-_KxRQNDZbvngOLSlZj8bwvAmKOg', 1579715320),
(5381, 1026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDI2IiwidXNlcm1haWwiOiJjYXJvbGluYXJlc2VuZGVtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTc5NzIwNzQ0LCJleHAiOjE1Nzk3MjI1NDQsInBlcm1pc3Npb24iOiIifQ.bPvkMNGnjPvGdPQrKKtg99cthkOsfmLTOk5Dmli4Mgw', 1579722544),
(5385, 1980, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTgwIiwidXNlcm1haWwiOiJ0aWFnb21lbG9hbG1laWRhQHVhLnB0IiwiaWF0IjoxNTc5Nzc5MjEzLCJleHAiOjE1Nzk3ODEwMTMsInBlcm1pc3Npb24iOiIifQ.VK9-SeMEkzxQOQsE8UNcdBm7gJErrFXa2r1Drnk6ZB4', 1579781013),
(5389, 840, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDAiLCJ1c2VybWFpbCI6ImFhbXJvZHJpZ3Vlc0B1YS5wdCIsImlhdCI6MTU3OTc5NjIzNywiZXhwIjoxNTc5Nzk4MDM3LCJwZXJtaXNzaW9uIjoiIn0.d0C1y0_a6EGU9XLq_6THCde3SThIznqCYkhOytQVF4U', 1579798037),
(5393, 1764, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzY0IiwidXNlcm1haWwiOiJwZWRyb29saXZlaXJhOTlAdWEucHQiLCJpYXQiOjE1Nzk3OTYzOTIsImV4cCI6MTU3OTc5ODE5MiwicGVybWlzc2lvbiI6IiJ9.C3R_RplGQvW7SBgZjnKqJZXWFXuRhkJQrIjnv7LBol0', 1579798192),
(5397, 1809, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA5IiwidXNlcm1haWwiOiJyYWZhZWxqc2ltb2VzQHVhLnB0IiwiaWF0IjoxNTc5Nzk3MzM2LCJleHAiOjE1Nzk3OTkxMzYsInBlcm1pc3Npb24iOiIifQ.tWc6FnHcdATib3rOb3KAlbEuCng8r92U6uw1JDt1HnE', 1579799136),
(5399, 1764, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzY0IiwidXNlcm1haWwiOiJwZWRyb29saXZlaXJhOTlAdWEucHQiLCJpYXQiOjE1Nzk3OTk4MTksImV4cCI6MTU3OTgwMTYxOSwicGVybWlzc2lvbiI6IiJ9.MVNW2yPMo3ePebMQyIBLaYLPAFw555F4h-3FLY_q694', 1579801619),
(5401, 840, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDAiLCJ1c2VybWFpbCI6ImFhbXJvZHJpZ3Vlc0B1YS5wdCIsImlhdCI6MTU3OTgwMTQxMSwiZXhwIjoxNTc5ODAzMjExLCJwZXJtaXNzaW9uIjoiIn0.8a_RPnxtfwI8yPwBCHy9qw9xLja9kYgnhiB6zJ0ohrE', 1579803211),
(5405, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc5ODYxMjk3LCJleHAiOjE1Nzk4NjMwOTcsInBlcm1pc3Npb24iOiIifQ.Nb30N_dhJUZjKxYkQTMzKHqrQ9JV7DVEM9qIEv1kSi4', 1579863097),
(5409, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTc5ODc0MjcxLCJleHAiOjE1Nzk4NzYwNzEsInBlcm1pc3Npb24iOiIifQ.8vcnMUMyKGR2fuYDiuzbcoRJ_qR-BoO2cHSEnKtGvt0', 1579876071),
(5411, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc5ODc1ODA3LCJleHAiOjE1Nzk4Nzc2MDcsInBlcm1pc3Npb24iOiIifQ.XqhYAPvhv9-poZFdfspsX7ZFnnxwwumvHkqYgOFrqLk', 1579877607),
(5415, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc5ODg4Njc2LCJleHAiOjE1Nzk4OTA0NzYsInBlcm1pc3Npb24iOiIifQ.PvFPHpXDohB0CKdmnSzD3ynIjfQWWW-dv72tSrw_w7M', 1579890476),
(5419, 1698, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjk4IiwidXNlcm1haWwiOiJvcmxhbmRvLm1hY2VkbzE1QHVhLnB0IiwiaWF0IjoxNTc5OTAxMTUxLCJleHAiOjE1Nzk5MDI5NTEsInBlcm1pc3Npb24iOiIifQ.FWIKnUbawQk8rtT-hHuwKeI5w6VxN9IQlrWBtGFPPrA', 1579902951),
(5423, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1Nzk5NDYzOTAsImV4cCI6MTU3OTk0ODE5MCwicGVybWlzc2lvbiI6IiJ9.j0QbQMLjCeHsFnCVqpB-Vy_JakmuOnUcRyxM4oiI9os', 1579948190),
(5425, 1806, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA2IiwidXNlcm1haWwiOiJyYWZhZWxndGVpeGVpcmFAdWEucHQiLCJpYXQiOjE1Nzk5NDcwMjAsImV4cCI6MTU3OTk0ODgyMCwicGVybWlzc2lvbiI6IiJ9.1Qn2cQvYlzV4NnJwaLR0V1TKT5PjZ0WCTQKy4IXjqX8', 1579948820),
(5427, 1698, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjk4IiwidXNlcm1haWwiOiJvcmxhbmRvLm1hY2VkbzE1QHVhLnB0IiwiaWF0IjoxNTc5OTQ3MDgzLCJleHAiOjE1Nzk5NDg4ODMsInBlcm1pc3Npb24iOiIifQ.dBcJVkgngWvMK-IGxBFXoX2-KNB1hH4yh0d-dgcpezI', 1579948883),
(5429, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU3OTk0ODI4NCwiZXhwIjoxNTc5OTUwMDg0LCJwZXJtaXNzaW9uIjoiIn0.jSGJjDamp8R2cdKr4B2aIl0n_UwbL0KGbdQgzuz9VYk', 1579950084),
(5431, 1638, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjM4IiwidXNlcm1haWwiOiJtZnM5OEB1YS5wdCIsImlhdCI6MTU3OTk0ODMwMiwiZXhwIjoxNTc5OTUwMTAyLCJwZXJtaXNzaW9uIjoiIn0.u3xDY99uGQjyKRH5fxGCD_IUbFItAEi1iaTylqSKrSU', 1579950102),
(5433, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU3OTk0ODQ1NywiZXhwIjoxNTc5OTUwMjU3LCJwZXJtaXNzaW9uIjoiIn0.3S4CgbGnDkX52vYMJh_XKJOISuxAZpCL7xclDio9hQ8', 1579950257),
(5435, 1809, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA5IiwidXNlcm1haWwiOiJyYWZhZWxqc2ltb2VzQHVhLnB0IiwiaWF0IjoxNTc5OTQ4NDk1LCJleHAiOjE1Nzk5NTAyOTUsInBlcm1pc3Npb24iOiIifQ.15oDUxlTxkVB3jwsIiyQdicR5LTBa9WiEJWyr31DRkU', 1579950295),
(5439, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU3OTk0ODg4NSwiZXhwIjoxNTc5OTUwNjg1LCJwZXJtaXNzaW9uIjoiIn0.Uz1onCbjNKmi0Wn0t_LxRFSBYjOaWtoicWMQX0vaais', 1579950685),
(5441, 1764, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzY0IiwidXNlcm1haWwiOiJwZWRyb29saXZlaXJhOTlAdWEucHQiLCJpYXQiOjE1Nzk5NDg5NzMsImV4cCI6MTU3OTk1MDc3MywicGVybWlzc2lvbiI6IiJ9.vMxHyi84_Va2_wDER0eGxgDsloa5x5GKXqF66Bhrvu4', 1579950773),
(5443, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU3OTk1MDM1NSwiZXhwIjoxNTc5OTUyMTU1LCJwZXJtaXNzaW9uIjoiIn0.K1P7RQpArEADpIV_-jSfRbJfe942cAH5Ea3BfaTsGAs', 1579952155),
(5447, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU3OTk1OTY2NCwiZXhwIjoxNTc5OTYxNDY0LCJwZXJtaXNzaW9uIjoiIn0.apITTs9YXfpwoxnZEo7jdzwPME3wYuefCwdwxxTtVnk', 1579961464),
(5449, 1182, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTgyIiwidXNlcm1haWwiOiJkdWFydGUubnRtQHVhLnB0IiwiaWF0IjoxNTc5OTU5NjczLCJleHAiOjE1Nzk5NjE0NzMsInBlcm1pc3Npb24iOiIifQ.6O79_Y1gdoupBg60CzBgkIjFXSOLWZrPDJh6A6We-xs', 1579961473),
(5451, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc5OTYxMzYzLCJleHAiOjE1Nzk5NjMxNjMsInBlcm1pc3Npb24iOiIifQ.jOa_-FoinLtheq1BO5mmf0YPz4Ei286zMQXMyoBk3Wc', 1579963163),
(5453, 1809, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA5IiwidXNlcm1haWwiOiJyYWZhZWxqc2ltb2VzQHVhLnB0IiwiaWF0IjoxNTc5OTYyMjY1LCJleHAiOjE1Nzk5NjQwNjUsInBlcm1pc3Npb24iOiIifQ.89KmLqJoRYXJigy9fPzXFfXo53lsdNlpNocAmdE9RUs', 1579964065),
(5455, 1764, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzY0IiwidXNlcm1haWwiOiJwZWRyb29saXZlaXJhOTlAdWEucHQiLCJpYXQiOjE1Nzk5NjI1MDYsImV4cCI6MTU3OTk2NDMwNiwicGVybWlzc2lvbiI6IiJ9.l5Qh4AWCmSazMFuIJH55dPvpLAjXC_JVnWmT7TJql2A', 1579964306),
(5461, 1809, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA5IiwidXNlcm1haWwiOiJyYWZhZWxqc2ltb2VzQHVhLnB0IiwiaWF0IjoxNTc5OTY4NTI1LCJleHAiOjE1Nzk5NzAzMjUsInBlcm1pc3Npb24iOiIifQ.vTHEThfbvwyG-OOr1Fl0o3KMtlRLBVW_Ckb-4W_1A5w', 1579970325),
(5465, 1365, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzY1IiwidXNlcm1haWwiOiJqYXJ0dXJjb3N0YUB1YS5wdCIsImlhdCI6MTU3OTk3MzY5MywiZXhwIjoxNTc5OTc1NDkzLCJwZXJtaXNzaW9uIjoiIn0.zpfSn_PFRrquQCBQqySnEAmIEgqJi03whESqU288Jv4', 1579975493),
(5467, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU3OTk3NTQwMCwiZXhwIjoxNTc5OTc3MjAwLCJwZXJtaXNzaW9uIjoiIn0.ipEDRLdFF0l7CT_8bes4gUMV719WCXss14SJza9UUNE', 1579977200),
(5471, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTc5OTg4Mjc0LCJleHAiOjE1Nzk5OTAwNzQsInBlcm1pc3Npb24iOiIifQ.s8yc1V06FaX_7juiF6Yag-lXHJJ2-W4kUtz1K5By-O0', 1579990074),
(5473, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1Nzk5ODg0MjIsImV4cCI6MTU3OTk5MDIyMiwicGVybWlzc2lvbiI6IiJ9.VNF6xhyxj2-UKaLCwQDuLKfbNbfI0TyYIOm9qurRBlM', 1579990222),
(5477, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTc5OTkyNTMyLCJleHAiOjE1Nzk5OTQzMzIsInBlcm1pc3Npb24iOiIifQ.hdNahHOKui0SzMMHsh3KeGS_6zogKiRxcHcgamg2aBU', 1579994332),
(5481, 990, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTAiLCJ1c2VybWFpbCI6ImJydW5vcmFiYWNhbEB1YS5wdCIsImlhdCI6MTU4MDAwMDc1NSwiZXhwIjoxNTgwMDAyNTU1LCJwZXJtaXNzaW9uIjoiIn0.QuLn7L99IWvIyr7NOhmOSEbGmFs6Fo1wV_xs8vJ6srw', 1580002555),
(5485, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTgwMDQ4NjkwLCJleHAiOjE1ODAwNTA0OTAsInBlcm1pc3Npb24iOiIifQ.2gbuVvR0V9LXSm8Y_A4eFtgAZr9aXPGETQSvSGjqig0', 1580050490),
(5489, 1473, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDczIiwidXNlcm1haWwiOiJqb3NlLnZhekB1YS5wdCIsImlhdCI6MTU4MDA1Mjk1MywiZXhwIjoxNTgwMDU0NzUzLCJwZXJtaXNzaW9uIjoiIn0.cqeeDWUXs8A7rQo0tG5qIqLRSPbAOX3wdurDVTeiHPE', 1580054753),
(5491, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODAwNTQxMjYsImV4cCI6MTU4MDA1NTkyNiwicGVybWlzc2lvbiI6IiJ9.W8osjGO_cvKAHEoWijndDFGmlZJgeX-_xWZtU0UICXU', 1580055926),
(5495, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTgwMDY0MzM1LCJleHAiOjE1ODAwNjYxMzUsInBlcm1pc3Npb24iOiIifQ.Uav7dg-9IvhqxmooOGW39bQw8GHOR-S6hDBlhBeQDu0', 1580066135),
(5497, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTgwMDY1MDkxLCJleHAiOjE1ODAwNjY4OTEsInBlcm1pc3Npb24iOiIifQ.A-pLgNdUyZUsgj-gibHRMHx4gjF9sDPjyLb05i3glBk', 1580066891),
(5503, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTgwMDY5MjY3LCJleHAiOjE1ODAwNzEwNjcsInBlcm1pc3Npb24iOiIifQ.PEmI5b0AR-Kd4vcSzxsINhDGrouKs1WQMfyaLtgcLrs', 1580071067),
(5507, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgwMDY5NjAyLCJleHAiOjE1ODAwNzE0MDIsInBlcm1pc3Npb24iOiIifQ.k5iE5uHCTz8YYZx6JJaYKIwCphz2GfrJW4MUTpGyD3w', 1580071402),
(5509, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTgwMDY5NjM3LCJleHAiOjE1ODAwNzE0MzcsInBlcm1pc3Npb24iOiIifQ.a3arCwF_7ejxds3Iau9iFmIclnCajWZDQpnte-_eGu0', 1580071437),
(5513, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODAwNzEwNDYsImV4cCI6MTU4MDA3Mjg0NiwicGVybWlzc2lvbiI6IiJ9.ZU00ZO2UbQDb7MhF88syoHCowoIyClmgvNXoVLf0bHI', 1580072846),
(5515, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTgwMDcxMzI1LCJleHAiOjE1ODAwNzMxMjUsInBlcm1pc3Npb24iOiIifQ.e_RNsF8fO_7gD-cjJFDph5Ol9idc5mrTEZpWL52rCI8', 1580073125),
(5521, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgwMDcyMzY5LCJleHAiOjE1ODAwNzQxNjksInBlcm1pc3Npb24iOiIifQ.jq-FFjUDBN-d1UunKnrVHiUq4TBTjDHxPfhUbN-zbss', 1580074169),
(5525, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTgwMDc2NzcxLCJleHAiOjE1ODAwNzg1NzEsInBlcm1pc3Npb24iOiIifQ.E0SDpxRd074L4TLkZ4B9LCXdLhw2yAOVlQXjsdlwVmg', 1580078571),
(5529, 990, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTAiLCJ1c2VybWFpbCI6ImJydW5vcmFiYWNhbEB1YS5wdCIsImlhdCI6MTU4MDA4MTk2MywiZXhwIjoxNTgwMDgzNzYzLCJwZXJtaXNzaW9uIjoiIn0.WpzbPdpPkt2zUK9qyMrKMn8GJJ3W_9sQ04X1HvF4l38', 1580083763),
(5533, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODAwODU2ODksImV4cCI6MTU4MDA4NzQ4OSwicGVybWlzc2lvbiI6IiJ9.Vcq-fmft2LQaePofSlJiSRuYu6KEDzlVHTLrlwI04M0', 1580087489),
(5537, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTgwMTE5NTQzLCJleHAiOjE1ODAxMjEzNDMsInBlcm1pc3Npb24iOiIifQ.tOO14GcQIUse584898FAHjFtL0AAW0yECi9_wuQqMyI', 1580121343),
(5541, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODAxMjQ4ODIsImV4cCI6MTU4MDEyNjY4MiwicGVybWlzc2lvbiI6IiJ9.H6utk9t-o1rJurVtJigp1mOhh3Ga--VPuN9oT_MNCZc', 1580126682),
(5545, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTgwMTQyNjk5LCJleHAiOjE1ODAxNDQ0OTksInBlcm1pc3Npb24iOiIifQ.u_hobHK4Y7uLUM-vGBSrgKROM19GBFhab1jKO-tt66o', 1580144499),
(5549, 1350, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzUwIiwidXNlcm1haWwiOiJpc2Fkb3JhLmZsQHVhLnB0IiwiaWF0IjoxNTgwMTUwOTgzLCJleHAiOjE1ODAxNTI3ODMsInBlcm1pc3Npb24iOiIifQ.THowOE-mASCgEXPRnZS6SbeTowFTX2xKf_ayoAQOWsE', 1580152783),
(5553, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTgwMTYwMjg1LCJleHAiOjE1ODAxNjIwODUsInBlcm1pc3Npb24iOiIifQ.v21R9kCMS_itffRg_OtGlZ0qReHEFaHZ3kGEFVMgEqY', 1580162085),
(5557, 1155, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTU1IiwidXNlcm1haWwiOiJkaW9nby5yZWlzQHVhLnB0IiwiaWF0IjoxNTgwMjM0NjY4LCJleHAiOjE1ODAyMzY0NjgsInBlcm1pc3Npb24iOiIifQ.eJ_q94IH07e6j2tniJQLapAtAy9LP5gx83PhJJyLNIk', 1580236468),
(5565, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU4MDMwMDExNiwiZXhwIjoxNTgwMzAxOTE2LCJwZXJtaXNzaW9uIjoiIn0.yzYo_lmZH30fh5bJmSkTz33sUES22qG4YQvn0Rt45TA', 1580301916),
(5569, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTgwMzA1NjYxLCJleHAiOjE1ODAzMDc0NjEsInBlcm1pc3Npb24iOiIifQ.ZQTWQyF0pAG_xbNfZ6AuwCke6jSKGIFvxYyVS7K8gLE', 1580307461),
(5571, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTgwMzA3NTA0LCJleHAiOjE1ODAzMDkzMDQsInBlcm1pc3Npb24iOiIifQ.KynsU5f0oyqhitT4eAvxltu6EocWO8V8MZ0i0uPDJmg', 1580309304),
(5575, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4MDMxMTY3OCwiZXhwIjoxNTgwMzEzNDc4LCJwZXJtaXNzaW9uIjoiIn0.qZm7kUQj3AeyWoBcMrhQIm7dywOnXT-FCSguB7NMzS4', 1580313478),
(5579, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1ODAzMjE4MzIsImV4cCI6MTU4MDMyMzYzMiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.d_OY6x4NBi5uIvpCJE7_SSY6R27z1R44FsfVHscjrfQ', 1580323632),
(5583, 1365, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzY1IiwidXNlcm1haWwiOiJqYXJ0dXJjb3N0YUB1YS5wdCIsImlhdCI6MTU4MDMyNTQzNywiZXhwIjoxNTgwMzI3MjM3LCJwZXJtaXNzaW9uIjoiIn0.b3hfP0UdPmn4D5YWeB0JaA8SRqjy8a1zj1t77tN2CkQ', 1580327237),
(5585, 1836, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODM2IiwidXNlcm1haWwiOiJyaWNhcmRvLnF1ZXJpZG85OEB1YS5wdCIsImlhdCI6MTU4MDMyNzY0OCwiZXhwIjoxNTgwMzI5NDQ4LCJwZXJtaXNzaW9uIjoiIn0.fCJJ19owpp00tosuIkf1dFDwIo-SjKyKA5ELc_v1zBM', 1580329448),
(5589, 1638, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjM4IiwidXNlcm1haWwiOiJtZnM5OEB1YS5wdCIsImlhdCI6MTU4MDMzMjM1NSwiZXhwIjoxNTgwMzM0MTU1LCJwZXJtaXNzaW9uIjoiIn0.rmpAoWJAndt0xLIUridqKSS1Z-weKmXqLlqOamc8k88', 1580334155),
(5591, 1536, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTM2IiwidXNlcm1haWwiOiJsdWNhc2FxdWlsaW5vQHVhLnB0IiwiaWF0IjoxNTgwMzMyNDg5LCJleHAiOjE1ODAzMzQyODksInBlcm1pc3Npb24iOiIifQ._PBb-HTQRbqkLkmOBfg0gFv70bTL08T-feJyWPevwLo', 1580334289),
(5593, 2050, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUwIiwidXNlcm1haWwiOiJqb3NldHJpZ29AdWEucHQiLCJpYXQiOjE1ODAzMzI1MTAsImV4cCI6MTU4MDMzNDMxMCwicGVybWlzc2lvbiI6IiJ9.Xe-MDzMGJ82gTeioBUHyM32x8EZwIWA6nMweRcy1TLU', 1580334310),
(5597, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1ODAzMzg5NjYsImV4cCI6MTU4MDM0MDc2NiwicGVybWlzc2lvbiI6IiJ9.uOUtpqlBY4LZUYAtZ7mT48nzVPfCSRBDVs8uiod8C7A', 1580340766),
(5599, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTgwMzM5MDc4LCJleHAiOjE1ODAzNDA4NzgsInBlcm1pc3Npb24iOiIifQ._Zygw854lPSSZ9qKpTbGzKzpHpXkgUf9hU2Vhwt8CrY', 1580340878),
(5603, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1ODAzNDMxOTgsImV4cCI6MTU4MDM0NDk5OCwicGVybWlzc2lvbiI6IiJ9.qHR27W5Gdm75kdNGJ0r00heNn5z2kTqdWqgt9iJZAnM', 1580344998),
(5605, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1ODAzNDYwNzIsImV4cCI6MTU4MDM0Nzg3MiwicGVybWlzc2lvbiI6IiJ9.xI77J1plAMvLlKLhj2fFIg04hAku9AV_3f4Tk3K-erE', 1580347872),
(5609, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU4MDM4NTQzNSwiZXhwIjoxNTgwMzg3MjM1LCJwZXJtaXNzaW9uIjoiIn0.GEQ7JTk4rnVW1AzXva3-n-Dbh-D8Di5x2QNX8KOEnNM', 1580387235),
(5613, 1836, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODM2IiwidXNlcm1haWwiOiJyaWNhcmRvLnF1ZXJpZG85OEB1YS5wdCIsImlhdCI6MTU4MDM5MTI3NCwiZXhwIjoxNTgwMzkzMDc0LCJwZXJtaXNzaW9uIjoiIn0.sHL-YjMKyUKhN9QF_X_wbZcHVCv7FskXgBAfHe4Ql3Q', 1580393074),
(5619, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODAzOTQ3MjgsImV4cCI6MTU4MDM5NjUyOCwicGVybWlzc2lvbiI6IiJ9.rmjLGXnNLM4JpXstS8m0adaABnetMu29vICAhCmb8Jc', 1580396528),
(5627, 897, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4OTciLCJ1c2VybWFpbCI6ImFuYXJhZmFlbGE5OEB1YS5wdCIsImlhdCI6MTU4MDQwMDU4NCwiZXhwIjoxNTgwNDAyMzg0LCJwZXJtaXNzaW9uIjoiIn0.3vMG2D35Yn8iKszvm3MjQeKezhz3nFnKabOCoaWvKwg', 1580402384),
(5631, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODA0MDY2MzAsImV4cCI6MTU4MDQwODQzMCwicGVybWlzc2lvbiI6IiJ9.MHpORHIque5-_iEfLmemjYHq-PQokhFHE5ehzXMP5Bo', 1580408430),
(5633, 1245, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjQ1IiwidXNlcm1haWwiOiJmbGF2aWFmaWd1ZWlyZWRvQHVhLnB0IiwiaWF0IjoxNTgwNDA3NTg0LCJleHAiOjE1ODA0MDkzODQsInBlcm1pc3Npb24iOiIifQ.csRIx_GAzEvtafgm7tg2DW3P2REdNh7yEyyYsqXksf4', 1580409384),
(5637, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgwNDE2NTc2LCJleHAiOjE1ODA0MTgzNzYsInBlcm1pc3Npb24iOiIifQ.3FAxKXPYdu-G0JBbfQkNcSGKpQ_j1fPjGW1PK2oCMqU', 1580418376),
(5641, 1212, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjEyIiwidXNlcm1haWwiOiJmLmZvbnRpbmhhQHVhLnB0IiwiaWF0IjoxNTgwNDY5MzA4LCJleHAiOjE1ODA0NzExMDgsInBlcm1pc3Npb24iOiIifQ.xzStWsGnoDA0bijxEnfi8CY0aKm-5AFdYmT1j_S7kog', 1580471108),
(5647, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1ODA0Nzg1MDIsImV4cCI6MTU4MDQ4MDMwMiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.OIzOKj-AIf-JkkediDJyQpC8Sen9h1zwOBeXYtle78A', 1580480302),
(5651, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTgwNDk1MTU3LCJleHAiOjE1ODA0OTY5NTcsInBlcm1pc3Npb24iOiIifQ.4Xbsta63Q7Gmefx3wqlybRQ1VzCEYQpLHatDrRzyKHo', 1580496957),
(5657, 1020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIwIiwidXNlcm1haWwiOiJjYXJvbGluYS5hcmF1am8wMEB1YS5wdCIsImlhdCI6MTU4MDU1MzIxNCwiZXhwIjoxNTgwNTU1MDE0LCJwZXJtaXNzaW9uIjoiIn0.0kBTbjrl0m1zyTj7-BZsoWRdnBn8F_sO4bocEXn_TLc', 1580555014),
(5661, 1845, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODQ1IiwidXNlcm1haWwiOiJyaXRhY2VyZGVpcmFAdWEucHQiLCJpYXQiOjE1ODA1NzAxMzEsImV4cCI6MTU4MDU3MTkzMSwicGVybWlzc2lvbiI6IiJ9.5T7hxm0By6vjqoqcoPDy421w8TXGtnYHpso4eTr_JBY', 1580571931),
(5665, 2121, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTIxIiwidXNlcm1haWwiOiJodWdvdC5zaWx2YUB1YS5wdCIsImlhdCI6MTU4MDY1MTc2MCwiZXhwIjoxNTgwNjUzNTYwLCJwZXJtaXNzaW9uIjoiIn0.Hom152VmWPt0kpwcvNBsBR_WI4sSXyXPBaq-_Ub6FvE', 1580653560),
(5669, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODA2NTQ1MzAsImV4cCI6MTU4MDY1NjMzMCwicGVybWlzc2lvbiI6IiJ9.lLq53Cy5utn_rCINm4I5Y5so5jlJR4dIWW4OdAgYFaY', 1580656330),
(5671, 945, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NDUiLCJ1c2VybWFpbCI6ImFudG9uaW9qb3JnZWZlcm5hbmRlc0B1YS5wdCIsImlhdCI6MTU4MDY1NzExMSwiZXhwIjoxNTgwNjU4OTExLCJwZXJtaXNzaW9uIjoiIn0.-_7E1R0eU5cK7q67-6OGG9dir7RPmitrVFVjIdJK-_I', 1580658911),
(5675, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODA2NjI3NzEsImV4cCI6MTU4MDY2NDU3MSwicGVybWlzc2lvbiI6IiJ9.obFek8iZzILQejmU3xcYVjsgax1jIHN3OKwYeBbVbSs', 1580664571),
(5679, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTgwNjg2Nzc2LCJleHAiOjE1ODA2ODg1NzYsInBlcm1pc3Npb24iOiIifQ.CNMybYR9oOCNJ6gby3V06rOfA2_R3VFkS8vpPu2pRvY', 1580688576),
(5683, 2050, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUwIiwidXNlcm1haWwiOiJqb3NldHJpZ29AdWEucHQiLCJpYXQiOjE1ODA2OTMzODUsImV4cCI6MTU4MDY5NTE4NSwicGVybWlzc2lvbiI6IiJ9.z-wOYuItDgYFdQIRvvs79xgGA7IOJN-IDS49WMdOtcc', 1580695185),
(5685, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTgwNjk0ODY4LCJleHAiOjE1ODA2OTY2NjgsInBlcm1pc3Npb24iOiIifQ.7EIg5trPy_FvvGQoQu6YjlvaDFtG5niKE6k8YQLUnQc', 1580696668),
(5689, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgwNzU4MTQ0LCJleHAiOjE1ODA3NTk5NDQsInBlcm1pc3Npb24iOiIifQ.NNXh3Czo-0jdt8Ce_-1CbnUJ0W-B4DYQWZKiL5JSPUs', 1580759944),
(5693, 1530, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTMwIiwidXNlcm1haWwiOiJscGNhcmRvc29AdWEucHQiLCJpYXQiOjE1ODA3ODM1NzAsImV4cCI6MTU4MDc4NTM3MCwicGVybWlzc2lvbiI6IiJ9.8ak8aS4uLRKX5HVNxM7KXptp7mLyqptHNUaOkcPg5b8', 1580785370),
(5697, 2121, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTIxIiwidXNlcm1haWwiOiJodWdvdC5zaWx2YUB1YS5wdCIsImlhdCI6MTU4MDgyOTU1NywiZXhwIjoxNTgwODMxMzU3LCJwZXJtaXNzaW9uIjoiIn0.nnoXN-Sb8HH-1h8GYI95kfWbyXXgBMXEg6DR1wr4ozs', 1580831357),
(5701, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTgwODMzOTI2LCJleHAiOjE1ODA4MzU3MjYsInBlcm1pc3Npb24iOiIifQ.CwrWqQsCyvFFdh0cG2OTo8QJX9uIqAr8B2qfQtQeND4', 1580835726),
(5707, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODA4NDQzNTksImV4cCI6MTU4MDg0NjE1OSwicGVybWlzc2lvbiI6IiJ9.GWOr9IuRqXZPPEbMIHpbLAquULWOoeycR0P919x_fBc', 1580846159),
(5709, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODA4NDUxNzUsImV4cCI6MTU4MDg0Njk3NSwicGVybWlzc2lvbiI6IiJ9.WpWtIL5YORaPSy9cS9yH0vmPACvmVo6jtiHLi1oUcks', 1580846975),
(5711, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODA4NDY2NzksImV4cCI6MTU4MDg0ODQ3OSwicGVybWlzc2lvbiI6IiJ9.WfNdk4Fwes_dFeG1adAxM_MahVTSzvabcCHawNuNazc', 1580848479),
(5713, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgwODQ4NzAyLCJleHAiOjE1ODA4NTA1MDIsInBlcm1pc3Npb24iOiIifQ.fY0jmP4nI33AL0ZRl0hMXLiTA53UCIOR_lzZeyquAgE', 1580850502),
(5715, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1ODA4NDk5NTMsImV4cCI6MTU4MDg1MTc1MywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.Kjb0Royiv-mantoFuK07h_qFc4f_u4MaOsqCsbAApvM', 1580851753),
(5719, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTgwODYyODc4LCJleHAiOjE1ODA4NjQ2NzgsInBlcm1pc3Npb24iOiIifQ.IhHMgmZZbivCvUntGkwWPm65G9znJ3D5zNW9VCnVfGY', 1580864678),
(5723, 873, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NzMiLCJ1c2VybWFpbCI6ImFsZXhhbmRyZWpmbG9wZXNAdWEucHQiLCJpYXQiOjE1ODA4OTczNTcsImV4cCI6MTU4MDg5OTE1NywicGVybWlzc2lvbiI6IiJ9.J1DAvJWZies1ojuU16UsNK8wsK4lfp0CfliMzhfscSw', 1580899157),
(5725, 2074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc0IiwidXNlcm1haWwiOiJ2aWNlbnRlLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTgwODk4NDkwLCJleHAiOjE1ODA5MDAyOTAsInBlcm1pc3Npb24iOiIifQ.ai3Waf2zPeqdPwtmlVdHufr-N5FUn14q0jrSaX8YgNQ', 1580900290),
(5729, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgwOTA5MjMzLCJleHAiOjE1ODA5MTEwMzMsInBlcm1pc3Npb24iOiIifQ.ilmbVSnylwfye0KYyxEdnP8pYNrDs_Eu1cjmQrPEGSc', 1580911033),
(5733, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU4MDkxNzU0MywiZXhwIjoxNTgwOTE5MzQzLCJwZXJtaXNzaW9uIjoiIn0._CxpF76VWPRyvkUySLYcib-I9baLE2QWaJ1DL_LoAlM', 1580919343),
(5737, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTgwOTI1MDE3LCJleHAiOjE1ODA5MjY4MTcsInBlcm1pc3Npb24iOiIifQ.QewMHN7QHq0USbr9Sc6sIa8NMkmQd19Ocw8CI4va294', 1580926817),
(5741, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODA5NDg4ODUsImV4cCI6MTU4MDk1MDY4NSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.H_Xd4nl0tXFtCcLrWVTNJwccZtTvup_oQm3YXjirpgY', 1580950685),
(5745, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU4MDk3ODQ4MCwiZXhwIjoxNTgwOTgwMjgwLCJwZXJtaXNzaW9uIjoiIn0._I35VkvmIb0BA64VC1WjtjHDnTpOpcT2n97niCD6frk', 1580980280),
(5749, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgwOTg4NTIyLCJleHAiOjE1ODA5OTAzMjIsInBlcm1pc3Npb24iOiIifQ.z8RkbSFQm5GYVZI-KFyVaGJGAS3w3b7amSOQmht2USA', 1580990322),
(5753, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgxMDIxNjAxLCJleHAiOjE1ODEwMjM0MDEsInBlcm1pc3Npb24iOiIifQ.fNctlj8LutB1qc-FHboVjfvYeE0Er7I__cd3NQWVlm4', 1581023401),
(5757, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgxMDI2NjM2LCJleHAiOjE1ODEwMjg0MzYsInBlcm1pc3Npb24iOiIifQ.u_cokZhhBLS1K7DFc_WIKzODt7ijBXUIIU4Ikh9_VJw', 1581028436),
(5759, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgxMDI4Njg3LCJleHAiOjE1ODEwMzA0ODcsInBlcm1pc3Npb24iOiIifQ.ft05cKCwIbC-QhmWY7Brv3eKYg5cAhgTN16g97G26jY', 1581030487),
(5763, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgxMDMzNzMyLCJleHAiOjE1ODEwMzU1MzIsInBlcm1pc3Npb24iOiIifQ.fcjNNDAO0xfMroy-jzAsd9IlsytxcrmemfYTRzwMQi4', 1581035532),
(5767, 1341, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQxIiwidXNlcm1haWwiOiJpbmVzLnBsQHVhLnB0IiwiaWF0IjoxNTgxMTY2MDc5LCJleHAiOjE1ODExNjc4NzksInBlcm1pc3Npb24iOiIifQ.sQaNAImvY2lhgMx5A2vaNXwlDHltevYxIlJu_Q8orbU', 1581167879),
(5771, 1341, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQxIiwidXNlcm1haWwiOiJpbmVzLnBsQHVhLnB0IiwiaWF0IjoxNTgxMTc4MDk1LCJleHAiOjE1ODExNzk4OTUsInBlcm1pc3Npb24iOiIifQ.aOrC4p37Z9rGyJS3gwRhUx8XMcTXKLIhgyww-MuWjAU', 1581179895),
(5775, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU4MTE4OTQ1NiwiZXhwIjoxNTgxMTkxMjU2LCJwZXJtaXNzaW9uIjoiIn0.EYmdrQPn0og_9kkXlU6Is2EekXB5Zhx0BN8ksiRFerg', 1581191256),
(5779, 1161, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTYxIiwidXNlcm1haWwiOiJkaW9nbzA0QHVhLnB0IiwiaWF0IjoxNTgxMTk1Mjc1LCJleHAiOjE1ODExOTcwNzUsInBlcm1pc3Npb24iOiIifQ.B64YXyzWRFeEbooyULrMK5yr4SX5X-gJb0O0VeRDdEY', 1581197075),
(5783, 873, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NzMiLCJ1c2VybWFpbCI6ImFsZXhhbmRyZWpmbG9wZXNAdWEucHQiLCJpYXQiOjE1ODEyNTEzMTMsImV4cCI6MTU4MTI1MzExMywicGVybWlzc2lvbiI6IiJ9.JmFimPG8adx1b9xcQG4Ho1hRHLQTDofqhmK2lHCVV_k', 1581253113),
(5787, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgxMzMyMTM4LCJleHAiOjE1ODEzMzM5MzgsInBlcm1pc3Npb24iOiIifQ.8dvQYn6nw9AcdG706Bm9leYrOp3oEgQ3h94XQrQgNdI', 1581333938),
(5791, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTgxMzQ5NTI2LCJleHAiOjE1ODEzNTEzMjYsInBlcm1pc3Npb24iOiIifQ.SpTJwp4_52SBSxWcp94u2sk4Q1nOx5W5UlK9xZOmdCo', 1581351326),
(5795, 1164, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTY0IiwidXNlcm1haWwiOiJkaW9nb2JlbnRvQHVhLnB0IiwiaWF0IjoxNTgxMzUxNDYyLCJleHAiOjE1ODEzNTMyNjIsInBlcm1pc3Npb24iOiIifQ.2tOiNZvpmSDdGyu3kV85XC6A-jfGcF5aB45nNGRGIpc', 1581353262),
(5799, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgxMzU2OTA1LCJleHAiOjE1ODEzNTg3MDUsInBlcm1pc3Npb24iOiIifQ.ErWqWIlMgOd_B0OFHFZ8x3C6pGLJCqqLk1JrTaoYq7I', 1581358705),
(5803, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTgxMzYwMTM2LCJleHAiOjE1ODEzNjE5MzYsInBlcm1pc3Npb24iOiIifQ.Gtlj71SzR-K90j-_wnSEnEhnA62rYTfhk71AxZkoK6Q', 1581361936),
(5811, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgxNDIzNjQ2LCJleHAiOjE1ODE0MjU0NDYsInBlcm1pc3Npb24iOiIifQ.PDZ4s1Y0qncCv_sPUTwVXPQLtK1P3VAyZAKGMjDddNk', 1581425446),
(5815, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1ODE0Mjk1MzYsImV4cCI6MTU4MTQzMTMzNiwicGVybWlzc2lvbiI6IiJ9.-7o2niY5LmOTIiJrEi0Cay2VfLGAlzwDTy_Q6V26TQw', 1581431336),
(5819, 1638, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjM4IiwidXNlcm1haWwiOiJtZnM5OEB1YS5wdCIsImlhdCI6MTU4MTQzMTc0NiwiZXhwIjoxNTgxNDMzNTQ2LCJwZXJtaXNzaW9uIjoiIn0.OwryuQ9cFjh6iieWUjpOFvnOa2gRXW_UPFbKhUPjAE0', 1581433546),
(5825, 1638, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjM4IiwidXNlcm1haWwiOiJtZnM5OEB1YS5wdCIsImlhdCI6MTU4MTQzMzc0NCwiZXhwIjoxNTgxNDM1NTQ0LCJwZXJtaXNzaW9uIjoiIn0.DJnhRDOWZf12wG6H9kZjgsX8OXCeMZvow_6Ipj_B8KE', 1581435544),
(5827, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1ODE0MzM4NDIsImV4cCI6MTU4MTQzNTY0MiwicGVybWlzc2lvbiI6IiJ9.6Mn77RaE24MaqwORzzuM2LhM9cAuvyMGSneCaPG7ZWE', 1581435642),
(5833, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODE0Mzc0MzcsImV4cCI6MTU4MTQzOTIzNywicGVybWlzc2lvbiI6IiJ9.bKMqXHG-aeSo1_ozpXZeNUulMObxdBzXEmpxK4APvSA', 1581439237),
(5837, 1521, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTIxIiwidXNlcm1haWwiOiJsZWFuZHJvc2lsdmExMkB1YS5wdCIsImlhdCI6MTU4MTQ0Njc0NywiZXhwIjoxNTgxNDQ4NTQ3LCJwZXJtaXNzaW9uIjoiIn0.HqLAwZ_RoqvJbPB_O5Bb1q3LN_KFFpvcODyaQjJGQgQ', 1581448547),
(5841, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODE1MDU3MTgsImV4cCI6MTU4MTUwNzUxOCwicGVybWlzc2lvbiI6IiJ9.pOYaWX8upLuwUvOQSYGIRO_Ja5bfM6ZE5YiDsS1FWjA', 1581507518),
(5845, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgxNTA4MjUyLCJleHAiOjE1ODE1MTAwNTIsInBlcm1pc3Npb24iOiIifQ.2wAQPLmRo8Xp3cwUitweBWG62mZWCe1LN0FOLzlNYz8', 1581510052),
(5847, 1410, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDEwIiwidXNlcm1haWwiOiJqb2FvYW50b25pb3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1ODE1MDg1OTQsImV4cCI6MTU4MTUxMDM5NCwicGVybWlzc2lvbiI6IiJ9.x88wIcYnWLgvePbRZyQUYPWeudNBt_7nvhxtQQEYAtY', 1581510394),
(5849, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODE1MDg3MzYsImV4cCI6MTU4MTUxMDUzNiwicGVybWlzc2lvbiI6IiJ9.CKgbwJe5K8AxUrsMMEGgvfJyZUCD20W73MgxTloFcFM', 1581510536),
(5851, 1638, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjM4IiwidXNlcm1haWwiOiJtZnM5OEB1YS5wdCIsImlhdCI6MTU4MTUwOTE4NCwiZXhwIjoxNTgxNTEwOTg0LCJwZXJtaXNzaW9uIjoiIn0.ht23PUqBrUkEI33m2hjzdAniRcl6ZsWQjqs-ChEH-H0', 1581510984),
(5855, 1806, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA2IiwidXNlcm1haWwiOiJyYWZhZWxndGVpeGVpcmFAdWEucHQiLCJpYXQiOjE1ODE1MTA0NzcsImV4cCI6MTU4MTUxMjI3NywicGVybWlzc2lvbiI6IiJ9.lO7U_5Q3pEfzng0FWoT3OXLiexnlsbhC2b82KnwAGOg', 1581512277),
(5857, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgxNTEwNjQwLCJleHAiOjE1ODE1MTI0NDAsInBlcm1pc3Npb24iOiIifQ.4f9lNF7LI5LfnN79SLYv9XDdhtPjsQ2XLWc-O7rSCe8', 1581512440),
(5861, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODE1MTU5ODMsImV4cCI6MTU4MTUxNzc4MywicGVybWlzc2lvbiI6IiJ9.DDPpYaQvfoCJGCDwQB7pcHeX-s1ATBmL7xKSCO6rfs0', 1581517783),
(5863, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODE1MTY0NjYsImV4cCI6MTU4MTUxODI2NiwicGVybWlzc2lvbiI6IiJ9.2f9hZIGXN3QiHY3X9OnhOjc33dY6kqCphCXXXoqgJAQ', 1581518266),
(5867, 1638, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjM4IiwidXNlcm1haWwiOiJtZnM5OEB1YS5wdCIsImlhdCI6MTU4MTUyNTcwNywiZXhwIjoxNTgxNTI3NTA3LCJwZXJtaXNzaW9uIjoiIn0.QErIN3IXKC7YFQeC77wEsKacwLNfpbLMLepwwykhLvk', 1581527507),
(5871, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODE1Mjk2NzEsImV4cCI6MTU4MTUzMTQ3MSwicGVybWlzc2lvbiI6IiJ9.g2qNUkJX22jfj-L1TINCEX44lw_PdL86ALwPEowJM8s', 1581531471),
(5873, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU4MTUzMDQ2NiwiZXhwIjoxNTgxNTMyMjY2LCJwZXJtaXNzaW9uIjoiIn0.EtdLA0eQUpElBhgEYtyrcayWRKxvjaKUjMQjcaLamWw', 1581532266),
(5875, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU4MTUzMjM3MCwiZXhwIjoxNTgxNTM0MTcwLCJwZXJtaXNzaW9uIjoiIn0.KMrd2h14-fmZ7QrmTaiUZE0_i556A0iYksWJPPPSoNs', 1581534170),
(5877, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTgxNTMyNDExLCJleHAiOjE1ODE1MzQyMTEsInBlcm1pc3Npb24iOiIifQ.bbVP5LO9MCmPxo6yolSZDpHJrpKg_jfmispe1VkHJ4A', 1581534211),
(5879, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODE1MzQ0MTAsImV4cCI6MTU4MTUzNjIxMCwicGVybWlzc2lvbiI6IiJ9._fJSjSz__a2WfZOrNWgjmwNTJyNyWV1Xit-HX7KjR2Q', 1581536210),
(5881, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTgxNTM1OTcwLCJleHAiOjE1ODE1Mzc3NzAsInBlcm1pc3Npb24iOiIifQ.vILeAcx0ep35n3GBTZrKUbUEMcuFgfeTGDNrlIdMI60', 1581537770),
(5885, 1965, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTY1IiwidXNlcm1haWwiOiJ0aWFnb2NtZW5kZXNAdWEucHQiLCJpYXQiOjE1ODE1NDE1MzgsImV4cCI6MTU4MTU0MzMzOCwicGVybWlzc2lvbiI6IiJ9.w7-nR3HGL2mYMp7A3LXCqMyfEJfdrgoyBc9qjIoCCIQ', 1581543338),
(5889, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTgxNTQ5Njk5LCJleHAiOjE1ODE1NTE0OTksInBlcm1pc3Npb24iOiIifQ.rzQqJoTerBAKnwyZW7udJ_mcPt0eB2rW8Ay3LtC6Nm8', 1581551499),
(5893, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTgxNTkyOTE1LCJleHAiOjE1ODE1OTQ3MTUsInBlcm1pc3Npb24iOiIifQ.FlMyf__ho4AqbOM0X4TIrnMZ9vQPcYHompExVXtP_8U', 1581594715),
(5895, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODE1OTQyOTQsImV4cCI6MTU4MTU5NjA5NCwicGVybWlzc2lvbiI6IiJ9.7rnnXTNBvbPmUn1BI59L92nmiCiKgTbqgFDNrybiUXc', 1581596094),
(5897, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU4MTU5NTE2NiwiZXhwIjoxNTgxNTk2OTY2LCJwZXJtaXNzaW9uIjoiIn0.FXW2UKjMWTt-ioBLJv5MFzdJ3zmUzRiJ6WsN3eo_Omc', 1581596966),
(5899, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU4MTU5NjQ1OCwiZXhwIjoxNTgxNTk4MjU4LCJwZXJtaXNzaW9uIjoiIn0.G2YbkAt4YR80-kGcU9Daf1_qgI0lzWcRLZ_QJdtOBiw', 1581598258),
(5903, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU4MTU5OTgxOSwiZXhwIjoxNTgxNjAxNjE5LCJwZXJtaXNzaW9uIjoiIn0.TJmJuwH6EehmiRB6A1CdfiG9a3__bxyCDAKSaJ_Rm-Q', 1581601619),
(5905, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODE2MDE4NDMsImV4cCI6MTU4MTYwMzY0MywicGVybWlzc2lvbiI6IiJ9.Qkv8tYIkf2cCIIYmiYYqp0q0yZ-1IhgfBZEKbQeNpXg', 1581603643),
(5907, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU4MTYwMjEzOSwiZXhwIjoxNTgxNjAzOTM5LCJwZXJtaXNzaW9uIjoiIn0.G1okojOHbOwXwnhUfvtAIAusMeEF0CbqqBshP7s-s0U', 1581603939),
(5909, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODE2MDMwMjAsImV4cCI6MTU4MTYwNDgyMCwicGVybWlzc2lvbiI6IiJ9.Hq7xAPhyzliloJaYsRj53NNRpy4gtmxlvRyz0dMjRiE', 1581604820),
(5911, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODE2MDMwMjQsImV4cCI6MTU4MTYwNDgyNCwicGVybWlzc2lvbiI6IiJ9.sXLnV396StsCBNmjntYsQqWANoheZC0W3LY8hizVCgk', 1581604824),
(5913, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODE2MDMwMzAsImV4cCI6MTU4MTYwNDgzMCwicGVybWlzc2lvbiI6IiJ9.RckX7T0Bk4eGsyllIid-m514cBeu_BBUcMhC9W9J6WI', 1581604830),
(5915, 2104, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA0IiwidXNlcm1haWwiOiJhZm9uc28uY2FtcG9zQHVhLnB0IiwiaWF0IjoxNTgxNjAzNDU2LCJleHAiOjE1ODE2MDUyNTYsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.0_5L3cQZxoCS89J1hL_-earE-L1PuNqUOq5J7nJOmnU', 1581605256),
(5917, 2104, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA0IiwidXNlcm1haWwiOiJhZm9uc28uY2FtcG9zQHVhLnB0IiwiaWF0IjoxNTgxNjAzNDc5LCJleHAiOjE1ODE2MDUyNzksInBlcm1pc3Npb24iOiJERUZBVUxUIn0.qTfr142LIVcd9-GIAXFEH40famtdF5F3Ei3VvWbgzjM', 1581605279),
(5921, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODE2MDU1MDYsImV4cCI6MTU4MTYwNzMwNiwicGVybWlzc2lvbiI6IiJ9.NGMB1xQkNwIB2sx390Q5nVn7XmGhVbXCIaGfht0r-Xo', 1581607306),
(5923, 1521, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTIxIiwidXNlcm1haWwiOiJsZWFuZHJvc2lsdmExMkB1YS5wdCIsImlhdCI6MTU4MTYwNjYxNCwiZXhwIjoxNTgxNjA4NDE0LCJwZXJtaXNzaW9uIjoiIn0.VvK5KKYbTTs_r5FyjaRnMkh7y2T5jBchWfVnUFI1JlM', 1581608414),
(5925, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1ODE2MDY2NDcsImV4cCI6MTU4MTYwODQ0NywicGVybWlzc2lvbiI6IiJ9.QLi6tLpDMlhgSoyjyu5YewgxuKGaFvCZkuLuHv9UIW4', 1581608447),
(5929, 1704, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzA0IiwidXNlcm1haWwiOiJwYXRyb2NpbmlvYW5kcmVpYUB1YS5wdCIsImlhdCI6MTU4MTYxMzU3MiwiZXhwIjoxNTgxNjE1MzcyLCJwZXJtaXNzaW9uIjoiIn0.OUWgYKSQT9Vl6M9wXCYtHeTs7PCuXurdNHamfdHTQig', 1581615372),
(5931, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1ODE2MTQ3MDcsImV4cCI6MTU4MTYxNjUwNywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.aifB1Cn00kW5ZdiAjR2lnXB7xfBXaXbTL_YIqUqHBLQ', 1581616507),
(5935, 1638, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjM4IiwidXNlcm1haWwiOiJtZnM5OEB1YS5wdCIsImlhdCI6MTU4MTYyMjMwNiwiZXhwIjoxNTgxNjI0MTA2LCJwZXJtaXNzaW9uIjoiIn0.45mkxgIyRsD9X5svXrRyCM6eDSxTDT_MKYScIF59mMk', 1581624106),
(5939, 1101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTAxIiwidXNlcm1haWwiOiJkYXNmZXJuYW5kZXNAdWEucHQiLCJpYXQiOjE1ODE2OTcyMzksImV4cCI6MTU4MTY5OTAzOSwicGVybWlzc2lvbiI6IiJ9.PDph30Xf2EcqSVXbuW5G73whUduqtDUSFXYmNIlg_U8', 1581699039);
INSERT INTO `GenTokens` (`id`, `userid`, `token`, `expire_date`) VALUES
(5943, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4MTc2MzA4NiwiZXhwIjoxNTgxNzY0ODg2LCJwZXJtaXNzaW9uIjoiIn0.hgp6bPT2NGRtlxzfoxnzysf8OXdRRSIdd-J0A0DYP7M', 1581764886),
(5947, 1758, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzU4IiwidXNlcm1haWwiOiJwZWRyb21nc291dG9AdWEucHQiLCJpYXQiOjE1ODE3ODI1NTIsImV4cCI6MTU4MTc4NDM1MiwicGVybWlzc2lvbiI6IiJ9.7q8rzvxPVduL26rBMHGCIxZ-xt8L3V8A-XVMhYMJ8oU', 1581784352),
(5949, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4MTc4NDczMCwiZXhwIjoxNTgxNzg2NTMwLCJwZXJtaXNzaW9uIjoiIn0.mzcm95kuHGd0lHRIUSLnthHHSxjKz4ukQ8jHCFW1ppg', 1581786530),
(5953, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODE3OTM2MjgsImV4cCI6MTU4MTc5NTQyOCwicGVybWlzc2lvbiI6IiJ9.zv_CIU5F8myNBmF4r6viVQhew6hU82dZHvCkF7TNyNE', 1581795428),
(5955, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTgxNzk1MDg3LCJleHAiOjE1ODE3OTY4ODcsInBlcm1pc3Npb24iOiIifQ.gDJEy6ko5a_jeXV_dPI7ujCVqPFbiBX9Fk-M6VqUrAk', 1581796887),
(5957, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgxNzk2MTU2LCJleHAiOjE1ODE3OTc5NTYsInBlcm1pc3Npb24iOiIifQ.rmiEorEzNBl3RKt8aUAeMBCe91M3nI83nyJth-0H1xc', 1581797956),
(5961, 1146, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTQ2IiwidXNlcm1haWwiOiJkaW9nby5lLm1vcmVpcmFAdWEucHQiLCJpYXQiOjE1ODE4MDAzMzIsImV4cCI6MTU4MTgwMjEzMiwicGVybWlzc2lvbiI6IiJ9.qJERx3kol2U2eBWng5oZqbL86AQEBynzi2yNTbNblSk', 1581802132),
(5965, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTgxODYzMTk2LCJleHAiOjE1ODE4NjQ5OTYsInBlcm1pc3Npb24iOiIifQ.pIEXYlRWnkvO8X-lZ8iaei9vwWJs5bS3P2MFFs6qzjg', 1581864996),
(5969, 1956, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTU2IiwidXNlcm1haWwiOiJ0aWFnby5zcnYub2xpdmVpcmFAdWEucHQiLCJpYXQiOjE1ODE4NzAyNjgsImV4cCI6MTU4MTg3MjA2OCwicGVybWlzc2lvbiI6IiJ9.yR-X1OHxtiDtfmyWTh8HcoZwMwAiWJgPjL-VZOzBPrk', 1581872068),
(5971, 1461, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDYxIiwidXNlcm1haWwiOiJqb2FvdHNAdWEucHQiLCJpYXQiOjE1ODE4NzEzODIsImV4cCI6MTU4MTg3MzE4MiwicGVybWlzc2lvbiI6IiJ9.cwgGBwNBSo2eX9nuozz_nZcA1YUjlkhKtIMEoBYrfvQ', 1581873182),
(5975, 1755, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzU1IiwidXNlcm1haWwiOiJwZWRyb2xvcGVzbWF0b3NAdWEucHQiLCJpYXQiOjE1ODE4ODU1NjYsImV4cCI6MTU4MTg4NzM2NiwicGVybWlzc2lvbiI6IiJ9.5_HvoSA5KQQBv_XspQdIpZeQomdmPLCx-ywZ9FpuOMw', 1581887366),
(5979, 1638, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjM4IiwidXNlcm1haWwiOiJtZnM5OEB1YS5wdCIsImlhdCI6MTU4MTg5NzExNCwiZXhwIjoxNTgxODk4OTE0LCJwZXJtaXNzaW9uIjoiIn0.OEpu-GVSOyPgZTOWTr3i-_hPXMM1UjOA1B-AuPFCcIc', 1581898914),
(5983, 1698, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjk4IiwidXNlcm1haWwiOiJvcmxhbmRvLm1hY2VkbzE1QHVhLnB0IiwiaWF0IjoxNTgxOTM2MzU5LCJleHAiOjE1ODE5MzgxNTksInBlcm1pc3Npb24iOiIifQ.QYJf2UGHwsRfGiSDg9ATiNJ_w20D-xh1UakncXHqpK4', 1581938159),
(5987, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU4MTk1NzAxMywiZXhwIjoxNTgxOTU4ODEzLCJwZXJtaXNzaW9uIjoiIn0.GLiqROCJgNgCbeXokM29xZE2sSNUzxf1i_xdn6vhkKI', 1581958813),
(5989, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODE5NTgzOTIsImV4cCI6MTU4MTk2MDE5MiwicGVybWlzc2lvbiI6IiJ9.Ku0NzHJMSYEhM24jBFzjnL3d9HP3mwq8q-LI5XH3ZYk', 1581960192),
(5993, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODE5NjA5MzIsImV4cCI6MTU4MTk2MjczMiwicGVybWlzc2lvbiI6IiJ9.nfZ9E4lIz4I9NtIW5F3AKh52RvEfUFBiz8MHiYaR6DA', 1581962732),
(5997, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU4MTk2NDI4MSwiZXhwIjoxNTgxOTY2MDgxLCJwZXJtaXNzaW9uIjoiIn0.iltmkSqFQ4sCSzlpSuQjxd1mve4TiZFZkAngNRS4v1U', 1581966081),
(6001, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4MTk2ODI0OSwiZXhwIjoxNTgxOTcwMDQ5LCJwZXJtaXNzaW9uIjoiIn0.6ExIEmNrQ7r0ih7hWV21WgllVsIdiJ62mOoVh73s5rk', 1581970049),
(6003, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODE5NzA1NTAsImV4cCI6MTU4MTk3MjM1MCwicGVybWlzc2lvbiI6IiJ9.MS2THJZ7wF4CSc0MAGw_ikxXYUXIxBJTTHeudc8m6gM', 1581972350),
(6007, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTgyMDM2MTc5LCJleHAiOjE1ODIwMzc5NzksInBlcm1pc3Npb24iOiIifQ.mdKiZkCBBlWonMJGl40_pEdAdxI5_M__HcxvDPRT6A8', 1582037979),
(6011, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTgyMDM5ODUwLCJleHAiOjE1ODIwNDE2NTAsInBlcm1pc3Npb24iOiIifQ.YCJ-uWPSw5yMPJSrPdtm8yI__zDWXG-cPf_guoWdLPs', 1582041650),
(6015, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTgyMDUxMjE0LCJleHAiOjE1ODIwNTMwMTQsInBlcm1pc3Npb24iOiIifQ.3emo8b7RaU_M17D40yp5PhHHxE44PkNwjQDd_3NR0VM', 1582053014),
(6017, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4MjA1MTQzOCwiZXhwIjoxNTgyMDUzMjM4LCJwZXJtaXNzaW9uIjoiIn0.sQY_SxyISnG4LdYrfAr-lqX9ogeNZKNpEsOOcNx7izI', 1582053238),
(6019, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODIwNTE2ODYsImV4cCI6MTU4MjA1MzQ4NiwicGVybWlzc2lvbiI6IiJ9.o92aeKLybSXvbnZmIX_5b_jhVE_7b5QVW8ARyRJPZtk', 1582053486),
(6021, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4MjA1Mzk3NCwiZXhwIjoxNTgyMDU1Nzc0LCJwZXJtaXNzaW9uIjoiIn0.NTkvNOEDOiJAVB7dxcZeA3ubimT0hT3xCBZ7_gG9yEg', 1582055774),
(6025, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU4MjA1NjY5MiwiZXhwIjoxNTgyMDU4NDkyLCJwZXJtaXNzaW9uIjoiIn0.Bho6jOnsUwdnypL5Hpd257K4DIftnOjsYgLyvWbBL1g', 1582058492),
(6033, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU4MjEzMDEyNywiZXhwIjoxNTgyMTMxOTI3LCJwZXJtaXNzaW9uIjoiIn0.ryjYocPTCSy87hqf5va5vz29gIv0dPupGjsB9s9Y5Wk', 1582131927),
(6035, 1341, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQxIiwidXNlcm1haWwiOiJpbmVzLnBsQHVhLnB0IiwiaWF0IjoxNTgyMTMwOTgwLCJleHAiOjE1ODIxMzI3ODAsInBlcm1pc3Npb24iOiIifQ.my1crXA7tFGwWD4udUjQhJV70EX83WeunQMQJPumdW8', 1582132780),
(6039, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODIxMzYwMTMsImV4cCI6MTU4MjEzNzgxMywicGVybWlzc2lvbiI6IiJ9.pAW-CabjwSMjD8fI3wA5XL5YxSAg8tqenvd6tFrK11E', 1582137813),
(6043, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODIxNDE3OTksImV4cCI6MTU4MjE0MzU5OSwicGVybWlzc2lvbiI6IiJ9.2jxIujYjjR_hQMIEXW5f-C8lY2AqoRdXJGuLMiPdCrQ', 1582143599),
(6047, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTgyMTQzODI1LCJleHAiOjE1ODIxNDU2MjUsInBlcm1pc3Npb24iOiIifQ.9_e3C7I9dK4_bglhxmzkit1dXPajRR6Layvm_yoivQA', 1582145625),
(6051, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTgyMTQ4NjE3LCJleHAiOjE1ODIxNTA0MTcsInBlcm1pc3Npb24iOiIifQ.zhI4Sau0GO5MyXwnfxcvu4oeNOnlnTpx6P86he7Spk8', 1582150417),
(6055, 1890, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODkwIiwidXNlcm1haWwiOiJzLmdvbWVzQHVhLnB0IiwiaWF0IjoxNTgyMTg5OTg5LCJleHAiOjE1ODIxOTE3ODksInBlcm1pc3Npb24iOiIifQ.d6lkfYtNea916yXi53hTW3gqy0MmWpyP5jEsvdIqSfo', 1582191789),
(6059, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODIxOTg4MjQsImV4cCI6MTU4MjIwMDYyNCwicGVybWlzc2lvbiI6IiJ9.LoPSR3mNMUNVbphAEyu6yByO7Oa-ANIFmpB1iRC95Cc', 1582200624),
(6067, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODIyMTA1NzgsImV4cCI6MTU4MjIxMjM3OCwicGVybWlzc2lvbiI6IiJ9.e4pYf_UCIf1FQBA-5edXmRtjN35TlLUfKoE54WhFYnw', 1582212378),
(6071, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1ODIyMTMxNDcsImV4cCI6MTU4MjIxNDk0NywicGVybWlzc2lvbiI6IiJ9.BcbdxgdcWlih0ynpnTf-4GVR0bFYHpi-a2vSqSBjnfs', 1582214947),
(6073, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTgyMjE1MTk2LCJleHAiOjE1ODIyMTY5OTYsInBlcm1pc3Npb24iOiIifQ.noZLsrdjS3ExXRSRiJuI_lePeoymSGgPErVNp1S35EM', 1582216996),
(6075, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1ODIyMTYyOTQsImV4cCI6MTU4MjIxODA5NCwicGVybWlzc2lvbiI6IiJ9.joCAsEMW1EViuQmZ-3lb2AeRBoFyeL0cIXWywTrA7Cs', 1582218094),
(6077, 2038, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM4IiwidXNlcm1haWwiOiJlZHVhcmRvZmVybmFuZGVzQHVhLnB0IiwiaWF0IjoxNTgyMjE3OTU3LCJleHAiOjE1ODIyMTk3NTcsInBlcm1pc3Npb24iOiIifQ.ZDbzj-EBCyLdxmGJFBHOzGx4G4rWd4kbJGwc-Rv916o', 1582219757),
(6079, 1764, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzY0IiwidXNlcm1haWwiOiJwZWRyb29saXZlaXJhOTlAdWEucHQiLCJpYXQiOjE1ODIyMTg3NTUsImV4cCI6MTU4MjIyMDU1NSwicGVybWlzc2lvbiI6IiJ9.1MnJyCWaXZhzwC7w1p4ms3SG4AKEYeFhKa3rjTgcgFY', 1582220555),
(6085, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODIyMjEzMTQsImV4cCI6MTU4MjIyMzExNCwicGVybWlzc2lvbiI6IiJ9.oWNtHJWIPLUahHsoryfJ8LBC89UQaf6UfOp21Efat_U', 1582223114),
(6087, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1ODIyMjI1NzIsImV4cCI6MTU4MjIyNDM3MiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.mFyIPZukpPC5NacPYfVJ0LuJ1xCkAJV2ZAP-N88bdm0', 1582224372),
(6091, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODIyODUyMzQsImV4cCI6MTU4MjI4NzAzNCwicGVybWlzc2lvbiI6IiJ9.6yR1iegPFSgcag2tGB3BKFTDPu7XLieOZyrcWSZ2ekY', 1582287034),
(6095, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODIyODk1MzYsImV4cCI6MTU4MjI5MTMzNiwicGVybWlzc2lvbiI6IiJ9.H5kE57tN9uICqCqsKjKzTM9_VxOEPMiYfot-w7yVgSo', 1582291336),
(6099, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODIyOTY3NzEsImV4cCI6MTU4MjI5ODU3MSwicGVybWlzc2lvbiI6IiJ9.a82vZK7_f1fW7xnLFbvaAaYiQ11F2l87RaVckvi5gFE', 1582298571),
(6105, 1716, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE2IiwidXNlcm1haWwiOiJwZWRyby5iYXNAdWEucHQiLCJpYXQiOjE1ODIzMTkzMzIsImV4cCI6MTU4MjMyMTEzMiwicGVybWlzc2lvbiI6IiJ9.mYuzTUgnjO4uBEA5VIIvmPzvPhS-n3btMf22WyMkua4', 1582321132),
(6109, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTgyMzIzMjYyLCJleHAiOjE1ODIzMjUwNjIsInBlcm1pc3Npb24iOiIifQ.3g_49K-Vzs4dlE8M0YwcYahpk2YH5a7rg_UpeK0QAao', 1582325062),
(6113, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTgyMzMxNDU0LCJleHAiOjE1ODIzMzMyNTQsInBlcm1pc3Npb24iOiIifQ.XvAJiISDzK1mzOkBv3ioX6k2u0o6XVcc_C8eBi0UgC0', 1582333254),
(6117, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODIzOTY1NjIsImV4cCI6MTU4MjM5ODM2MiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.S-rstV-kI7w-rhdnMqpQ2WanSvwlJdMHnuLSGDr2xQU', 1582398362),
(6121, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODI0MDcyMjIsImV4cCI6MTU4MjQwOTAyMiwicGVybWlzc2lvbiI6IiJ9._KfAL9cc1yUWI7iteTZOSit_D-Me_HgFlJNR4-LWXwk', 1582409022),
(6125, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODI0NjA1NzEsImV4cCI6MTU4MjQ2MjM3MSwicGVybWlzc2lvbiI6IiJ9.BK3R4pPAkhQ8SB6gh09WqoYwzA4xsG1JH3jBF7Oyq2g', 1582462371),
(6129, 2028, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI4IiwidXNlcm1haWwiOiJjZmZvbnNlY2FAdWEucHQiLCJpYXQiOjE1ODI0NjQyNTIsImV4cCI6MTU4MjQ2NjA1MiwicGVybWlzc2lvbiI6IiJ9.wIe5rxa4peAUDDkJODQecWnwvdB6N_KRQlpT2KCBXO8', 1582466052),
(6133, 1722, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzIyIiwidXNlcm1haWwiOiJwZWRyby5taWd1ZWw1MEB1YS5wdCIsImlhdCI6MTU4MjQ3ODY4NywiZXhwIjoxNTgyNDgwNDg3LCJwZXJtaXNzaW9uIjoiIn0.ObEYMhre5LZUDjN9gKAqYqsvUYMQtBg2uGUua8ZxBpI', 1582480487),
(6137, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1ODI1NjIzMDcsImV4cCI6MTU4MjU2NDEwNywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.RbE1TnvZgexIsK2Vbg4frcxJLtEILUuBBayiz-Zq-dI', 1582564107),
(6139, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1ODI1NjMxMjgsImV4cCI6MTU4MjU2NDkyOCwicGVybWlzc2lvbiI6IiJ9.BXobmuM73MjCfXMmvEatV8BBqsPUQ9fBJya71jvt3kc', 1582564928),
(6155, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgyNTc4MDc4LCJleHAiOjE1ODI1Nzk4NzgsInBlcm1pc3Npb24iOiIifQ.iL0AwnDkW_sm8XVFvTSXhBUcK7zQTCCN3Ax1BasTkVI', 1582579878),
(6157, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODI1NzgyMTIsImV4cCI6MTU4MjU4MDAxMiwicGVybWlzc2lvbiI6IiJ9.6QeTQodowf5ES0tUEDFzWS38i6URX5L_KXlyzdVLDaA', 1582580012),
(6161, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODI2NTYzMzgsImV4cCI6MTU4MjY1ODEzOCwicGVybWlzc2lvbiI6IiJ9.NtAUQTcZpOlZwUceM_l_SuZcRiLXMQPOTIvuRoigk8k', 1582658138),
(6163, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODI2NTY1MTIsImV4cCI6MTU4MjY1ODMxMiwicGVybWlzc2lvbiI6IiJ9.9JQSF4UyKs0o_f56vzPf8OAt41UDHjn7aGNtD3qIoSk', 1582658312),
(6167, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODI2NjQ5MjcsImV4cCI6MTU4MjY2NjcyNywicGVybWlzc2lvbiI6IiJ9.ecH4jR83Ynr_UErzBDQHKuNnN6XNElzVIXXgnBdmD64', 1582666727),
(6171, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODI3MjQ0MDksImV4cCI6MTU4MjcyNjIwOSwicGVybWlzc2lvbiI6IiJ9.YtlXmMBTqhexgAGpTL-LyynBOTJdaz_dsVcTkFh6g4A', 1582726209),
(6175, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1ODI3MzM5MzAsImV4cCI6MTU4MjczNTczMCwicGVybWlzc2lvbiI6IiJ9.wkF1n7Oqr8PQ7jyWVxz-T2dgyLrnH-HjYYnWomcr4oQ', 1582735730),
(6179, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTgyNzQ2MDA0LCJleHAiOjE1ODI3NDc4MDQsInBlcm1pc3Npb24iOiIifQ.3kOyvhIQ5NfAgAvaDDXCR9nS79b4-WXeenpGjyM5wAE', 1582747804),
(6183, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODI3NTYxOTgsImV4cCI6MTU4Mjc1Nzk5OCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.ENJF5TtCFpEhF5lYP6UNRa6iGVM7FEmUY2oD0T1bmQM', 1582757998),
(6187, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4Mjc5NDMyMCwiZXhwIjoxNTgyNzk2MTIwLCJwZXJtaXNzaW9uIjoiIn0.jzZdan_cfzjC4DcUzWAFmK-LeRqju82WYcJzbwZ6RUg', 1582796120),
(6191, 2080, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDgwIiwidXNlcm1haWwiOiJicmFpc0B1YS5wdCIsImlhdCI6MTU4Mjc5ODc0NywiZXhwIjoxNTgyODAwNTQ3LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.KB6WRA5Kv_KGB5ImBEFK6Uz3z8c--PZ92osDPu9eDfs', 1582800547),
(6193, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU4Mjc5OTkwMSwiZXhwIjoxNTgyODAxNzAxLCJwZXJtaXNzaW9uIjoiIn0.ZMq5tFhgKIDaL3s7JJ_u3HgCZOX0stRsJWzORk3ua5Q', 1582801701),
(6195, 882, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4ODIiLCJ1c2VybWFpbCI6ImFsbWVpZGEubUB1YS5wdCIsImlhdCI6MTU4MjgwMTgzNywiZXhwIjoxNTgyODAzNjM3LCJwZXJtaXNzaW9uIjoiIn0.Tm-3fws7cqcZbUutfbaYPAyWy6BPxwkZD2U2-JqIgIs', 1582803637),
(6197, 882, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4ODIiLCJ1c2VybWFpbCI6ImFsbWVpZGEubUB1YS5wdCIsImlhdCI6MTU4MjgwMzIzOCwiZXhwIjoxNTgyODA1MDM4LCJwZXJtaXNzaW9uIjoiIn0.KV6g4mREP-FWGF38VyVAp7gvVdSEYpzYoqQUKH7Csxg', 1582805038),
(6201, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODI4MTc3MjEsImV4cCI6MTU4MjgxOTUyMSwicGVybWlzc2lvbiI6IiJ9.99RRSySSXmDAUhiL-TwqPnC3D8WuZsaj_7AGqmOM59s', 1582819521),
(6205, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1ODI4MjA5NDQsImV4cCI6MTU4MjgyMjc0NCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.uykDWIwNBQMh1fBmKxsVOdnFP1ClsZH3N0sjN0g9BmE', 1582822744),
(6209, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTgyODIxOTEyLCJleHAiOjE1ODI4MjM3MTIsInBlcm1pc3Npb24iOiIifQ.Gttep0Twy0SDOZXTFKglRZz-hQQokZal1mTRus0iTCU', 1582823712),
(6213, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTgyODI1MDQxLCJleHAiOjE1ODI4MjY4NDEsInBlcm1pc3Npb24iOiIifQ.3aqhS7Mb81wCSDS9VleZ3fHOAymOMvJys-83I_wds4M', 1582826841),
(6217, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTgyODMzMDE2LCJleHAiOjE1ODI4MzQ4MTYsInBlcm1pc3Npb24iOiIifQ.5fz3gPNCzpQFtKKHgGHRk-HbCtV3Bt9XKDvOx2kPjdc', 1582834816),
(6221, 921, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5MjEiLCJ1c2VybWFpbCI6ImFuZHJlZ3VhbEB1YS5wdCIsImlhdCI6MTU4Mjg5NTI4MywiZXhwIjoxNTgyODk3MDgzLCJwZXJtaXNzaW9uIjoiIn0.yUlh7BoeUkAe04uMgyjDb1g3i7ffnHOIrjkdKM50CGk', 1582897083),
(6225, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgyOTI5NjM3LCJleHAiOjE1ODI5MzE0MzcsInBlcm1pc3Npb24iOiIifQ.gu2mJwLSAyoEJb5ke263LAc7oF_ND_aZonpIxOVSWKM', 1582931437),
(6229, 2010, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDEwIiwidXNlcm1haWwiOiJ2aW5pY2l1c3JpYmVpcm9AdWEucHQiLCJpYXQiOjE1ODI5NzYyNzEsImV4cCI6MTU4Mjk3ODA3MSwicGVybWlzc2lvbiI6IiJ9.aNH6mkzcs0eV1tR-DOr_lT8efvwK6fVGasLBt-qbs78', 1582978071),
(6233, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU4Mjk5ODUyMywiZXhwIjoxNTgzMDAwMzIzLCJwZXJtaXNzaW9uIjoiIn0.GDDPCHieXr64Uo3gRWSzZuKsVswWUwEYQgTARCRAnpA', 1583000323),
(6235, 1173, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTczIiwidXNlcm1haWwiOiJkbWF0aWFzcGludG9AdWEucHQiLCJpYXQiOjE1ODMwMDIwMjYsImV4cCI6MTU4MzAwMzgyNiwicGVybWlzc2lvbiI6IiJ9.XCUZ9vWo7IbN78kUCMpxgNNVlcVdRZ7ihAg9-FPymTI', 1583003826),
(6237, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU4MzAwNDkyNiwiZXhwIjoxNTgzMDA2NzI2LCJwZXJtaXNzaW9uIjoiIn0.hfHkhQoMjsd9Q8fHmbxtM49Z3Qj4AAOgmoKSXmbn7YM', 1583006726),
(6241, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTgzMDE1ODkzLCJleHAiOjE1ODMwMTc2OTMsInBlcm1pc3Npb24iOiIifQ.tIefa1NBwQVrajG0Zi5fjhXc6bcyScsWvRfsggXGKTo', 1583017693),
(6245, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTgzMDIwNjI3LCJleHAiOjE1ODMwMjI0MjcsInBlcm1pc3Npb24iOiIifQ.8aIh1YR_9HHEOcqhEmhPz4A5sAFxYr4kgzbXrDlAp88', 1583022427),
(6247, 2104, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA0IiwidXNlcm1haWwiOiJhZm9uc28uY2FtcG9zQHVhLnB0IiwiaWF0IjoxNTgzMDIwNjQ2LCJleHAiOjE1ODMwMjI0NDYsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.XI6ntj2IJwG6m71CfKs-MevZQphKwkB8iWz94k3JKAY', 1583022446),
(6251, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTgzMDYyNDQ4LCJleHAiOjE1ODMwNjQyNDgsInBlcm1pc3Npb24iOiIifQ.aduyKInacsdBzAMPqZsse1In8yGKG79HeI1nr1dLe68', 1583064248),
(6255, 2104, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA0IiwidXNlcm1haWwiOiJhZm9uc28uY2FtcG9zQHVhLnB0IiwiaWF0IjoxNTgzMDY2NTA2LCJleHAiOjE1ODMwNjgzMDYsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.0KBciyhWIFlvDfZwwVAXM7ntWF3nftQOMMOlhZSJIA4', 1583068306),
(6259, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTgzMDc3MTY3LCJleHAiOjE1ODMwNzg5NjcsInBlcm1pc3Npb24iOiIifQ.Yla4g-NtkZB0o9XI3H3QMp5o1vqmjty2o6c4H5ozML0', 1583078967),
(6261, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTgzMDc4NDA0LCJleHAiOjE1ODMwODAyMDQsInBlcm1pc3Npb24iOiIifQ.JnUJylffVO0v2eBIZ1YFtAns7CE5Xdiqq_LOcAyVzmg', 1583080204),
(6263, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU4MzA3OTExOCwiZXhwIjoxNTgzMDgwOTE4LCJwZXJtaXNzaW9uIjoiIn0.ZwhyFf7TKknOYbckW47ZQakg38PuHwnwfiK9xRXzrZs', 1583080918),
(6265, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU4MzA3OTE0OSwiZXhwIjoxNTgzMDgwOTQ5LCJwZXJtaXNzaW9uIjoiIn0._ZLxETYugjWaKd-jFHiNl12TiILZHj9XX1J9Hi0_bVg', 1583080949),
(6267, 1419, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDE5IiwidXNlcm1haWwiOiJqb2FvZ2ZlcnJlaXJhQHVhLnB0IiwiaWF0IjoxNTgzMDgwMDE4LCJleHAiOjE1ODMwODE4MTgsInBlcm1pc3Npb24iOiIifQ.-wPPBKvnJOz2BaB4rn_1hYGDCwegZGEMfosD54tyH9w', 1583081818),
(6269, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODMwODIxOTgsImV4cCI6MTU4MzA4Mzk5OCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.sxsfs4bwjoSenzMrodKrOU8FugrCY0SlixOxuBrpdEA', 1583083998),
(6271, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU4MzA4MzY1NSwiZXhwIjoxNTgzMDg1NDU1LCJwZXJtaXNzaW9uIjoiIn0.1PcQsrNZMJVCOJmSoEKnf7Et8Kc84wEq_kAq-dO0Tb4', 1583085455),
(6273, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1ODMwODU2MDksImV4cCI6MTU4MzA4NzQwOSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.DKoDVALL1RF4ogcg3iSGMpn9R8LuAsvk9Gf__4e0KYM', 1583087409),
(6275, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTgzMDg1OTQ2LCJleHAiOjE1ODMwODc3NDYsInBlcm1pc3Npb24iOiIifQ.4FzYgCDWi3I9mKFn5q7MTSjJCV4GZk8IfOZZB0Z_WMY', 1583087746),
(6277, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTgzMDg2OTI1LCJleHAiOjE1ODMwODg3MjUsInBlcm1pc3Npb24iOiIifQ.dBS4vwxZg_2D9eos1d7HXPj7yPdM1DD9PA5a_C50e_A', 1583088725),
(6279, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODMwODk2MTcsImV4cCI6MTU4MzA5MTQxNywicGVybWlzc2lvbiI6IiJ9.epVtuSo_grP8GL03774SVjzaLlH2lHI5k92i6E1D6z0', 1583091417),
(6281, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1ODMwOTA2NDEsImV4cCI6MTU4MzA5MjQ0MSwicGVybWlzc2lvbiI6IiJ9.EMumselmB9b_yA_TqxcvFs_1B0d7V4GuWM1NmqftBgc', 1583092441),
(6285, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTgzMDk0NTc0LCJleHAiOjE1ODMwOTYzNzQsInBlcm1pc3Npb24iOiIifQ.QDLlfST-MECF82TUwIJesmLXnneuqo7Jqh_xUBd5bXc', 1583096374),
(6289, 993, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTMiLCJ1c2VybWFpbCI6ImJydW5vc2JAdWEucHQiLCJpYXQiOjE1ODMwOTc3NzMsImV4cCI6MTU4MzA5OTU3MywicGVybWlzc2lvbiI6IiJ9.OZRQD4uE8WG3dEKVlcW2SkV6FwDswa0oILwSNCVDUsU', 1583099573),
(6293, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTgzMTAxNjI0LCJleHAiOjE1ODMxMDM0MjQsInBlcm1pc3Npb24iOiIifQ.nt-QnB_vqmAiTFueoMqM4ADQ-MTPFfaY7TO6eF9dpuw', 1583103424),
(6297, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4MzE1MjEwNSwiZXhwIjoxNTgzMTUzOTA1LCJwZXJtaXNzaW9uIjoiIn0.S3c_BdENVF9asc17r9pKWnKhPIDcCC0EA2MW-4d7cJA', 1583153905),
(6301, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgzMTU2ODczLCJleHAiOjE1ODMxNTg2NzMsInBlcm1pc3Npb24iOiIifQ.vJUE5O1EPsMMxolIc7MnUGMRB5nYY7Yrjx16rsxfneM', 1583158673),
(6303, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODMxNTY5NzgsImV4cCI6MTU4MzE1ODc3OCwicGVybWlzc2lvbiI6IiJ9.0rec6dwQN5omrpAO9A1rSAzEsI1oag-lsdVyh6SsVBQ', 1583158778),
(6311, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1ODMxNjQyNTQsImV4cCI6MTU4MzE2NjA1NCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.9zRQVB_GjUlX_vkolL9THGcUSiLDW01JBxQcvtlUGrg', 1583166054),
(6315, 2080, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDgwIiwidXNlcm1haWwiOiJicmFpc0B1YS5wdCIsImlhdCI6MTU4MzE2ODYxMSwiZXhwIjoxNTgzMTcwNDExLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.vLF4TrN58xXs9zc-Wc1QWLWrbATytoOg3hH3_kmzHZY', 1583170411),
(6317, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTgzMTcwMDMzLCJleHAiOjE1ODMxNzE4MzMsInBlcm1pc3Npb24iOiIifQ.caP2_KsU0-QeWH-oMyNRguPGygtSIoLIHldLD9oba2E', 1583171833),
(6321, 1383, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzgzIiwidXNlcm1haWwiOiJqb2FvLmNhcnZhbGhvMTlAdWEucHQiLCJpYXQiOjE1ODMxNzI3NjYsImV4cCI6MTU4MzE3NDU2NiwicGVybWlzc2lvbiI6IiJ9.bVhwfYem6tt2IzWb2Mg7aNWjBBVmLhxOsgBQ19jG_Bc', 1583174566),
(6325, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTgzMTkzMzA5LCJleHAiOjE1ODMxOTUxMDksInBlcm1pc3Npb24iOiIifQ.L2kaXW94_0nT4ipJgHL4jl8gxA25b97VKhpCMZX5NZA', 1583195109),
(6329, 2080, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDgwIiwidXNlcm1haWwiOiJicmFpc0B1YS5wdCIsImlhdCI6MTU4MzIzNDIxMCwiZXhwIjoxNTgzMjM2MDEwLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.RFEmsV2gTVlpHlFl-UXG9cEL0QjjiQNind_Z-N-Kgjs', 1583236010),
(6331, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1ODMyMzQ1MDgsImV4cCI6MTU4MzIzNjMwOCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.iyBPTOy9cTif1-O6p0NFg7GiTxv-n_QNF2tbehlooM4', 1583236308),
(6335, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgzMjM0OTU0LCJleHAiOjE1ODMyMzY3NTQsInBlcm1pc3Npb24iOiIifQ.1getcHYsRsqI6uPI_oZ84vGwVDmsPKHc9QJYjV5uaFU', 1583236754),
(6337, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODMyMzQ5OTcsImV4cCI6MTU4MzIzNjc5NywicGVybWlzc2lvbiI6IiJ9.xQPTZEjWgRgpnU_qX61BzuV-dDMFFyrTXpkAyuteKFc', 1583236797),
(6339, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODMyMzUyMjgsImV4cCI6MTU4MzIzNzAyOCwicGVybWlzc2lvbiI6IiJ9.NZgtHia9s6_MgWxIaN-oX-q8W6pzYKStzRhD5FvUeNE', 1583237028),
(6341, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODMyMzU0ODYsImV4cCI6MTU4MzIzNzI4NiwicGVybWlzc2lvbiI6IiJ9.GqOBHKKcKzWfDLLQ4Lwi5lqi8nT26A1ZXC4zbMiJbIE', 1583237286),
(6343, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODMyMzU1NzAsImV4cCI6MTU4MzIzNzM3MCwicGVybWlzc2lvbiI6IiJ9.dkZsS601IdlnLI-3uk_nNdMl5m6KpPMi9kbROQsSMIo', 1583237370),
(6347, 1806, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA2IiwidXNlcm1haWwiOiJyYWZhZWxndGVpeGVpcmFAdWEucHQiLCJpYXQiOjE1ODMyNTU3NDcsImV4cCI6MTU4MzI1NzU0NywicGVybWlzc2lvbiI6IiJ9.RpVf3Mfb1JPCvxcIubSRSxvw6aEeb3CjbaG0LssA67Y', 1583257547),
(6351, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU4MzI1NjEzNCwiZXhwIjoxNTgzMjU3OTM0LCJwZXJtaXNzaW9uIjoiIn0.9JvI0rgI1dmWhSZVHa8Ri7Mb3CWTqtkPviN7yh6n7nM', 1583257934),
(6353, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTgzMjU2MjQ4LCJleHAiOjE1ODMyNTgwNDgsInBlcm1pc3Npb24iOiIifQ.igIHBD9t94wJSeBnolHTnbhvz7OoZZWnHLveTFJB4Ao', 1583258048),
(6357, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU4MzI4MDEyOCwiZXhwIjoxNTgzMjgxOTI4LCJwZXJtaXNzaW9uIjoiIn0.cHy67yuZJBgfETcxnd27v0d_Z68KJSqZsdEnzV4yMuQ', 1583281928),
(6361, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTgzMjg1MDE4LCJleHAiOjE1ODMyODY4MTgsInBlcm1pc3Npb24iOiIifQ.nqi8owstt6ss-SLgymIBusLM67xW6jG5qLjTWRl1jqs', 1583286818),
(6365, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODMzMTYzOTgsImV4cCI6MTU4MzMxODE5OCwicGVybWlzc2lvbiI6IiJ9.fSWIhKxlu4SmeRlerI_CbuqfFGSqtsMvwFmMl89Yr1Y', 1583318198),
(6367, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODMzMTY3MDcsImV4cCI6MTU4MzMxODUwNywicGVybWlzc2lvbiI6IiJ9.VBkhxRAU4Uvn5rVLLeGJ0jw5HCSZbwSyTAwYMEbE4EQ', 1583318507),
(6371, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODMzMTg3MzgsImV4cCI6MTU4MzMyMDUzOCwicGVybWlzc2lvbiI6IiJ9.lqseYEPTv4ywYY4HkOnE_VCRcPOPaNyy0dwS2L6c4os', 1583320538),
(6373, 1821, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODIxIiwidXNlcm1haWwiOiJyZm1mQHVhLnB0IiwiaWF0IjoxNTgzMzE5MTcxLCJleHAiOjE1ODMzMjA5NzEsInBlcm1pc3Npb24iOiIifQ.Jq2iZPpdnMDtjKBTxyIJvd0aCMb_73YQTvllQcmi518', 1583320971),
(6377, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTgzMzQ3MTc4LCJleHAiOjE1ODMzNDg5NzgsInBlcm1pc3Npb24iOiIifQ.2FqlAZd-aSq-m1uPpeg3JE3lsC3eqZv6aLie8tdw7_U', 1583348978),
(6379, 2080, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDgwIiwidXNlcm1haWwiOiJicmFpc0B1YS5wdCIsImlhdCI6MTU4MzM0Nzc1NSwiZXhwIjoxNTgzMzQ5NTU1LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.CD98Uefaga8OYnceF5sfIo3RJO5mv4Qo10ttaFzC0ZQ', 1583349555),
(6383, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4MzQwMTg5MiwiZXhwIjoxNTgzNDAzNjkyLCJwZXJtaXNzaW9uIjoiIn0.RrdOpMn5PETrAL6pjO8otdfpWtVvo-mbJs_dr7kL53Y', 1583403692),
(6387, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU4MzQxMDQ0MiwiZXhwIjoxNTgzNDEyMjQyLCJwZXJtaXNzaW9uIjoiIn0.XGjl2uTR7F--v75P-iA7pXBnGjoXSPJ2YAyrYIahPiI', 1583412242),
(6393, 2025, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI1IiwidXNlcm1haWwiOiJhbmRyZWlhLnBvcnRlbGFAdWEucHQiLCJpYXQiOjE1ODM0MjU3NjgsImV4cCI6MTU4MzQyNzU2OCwicGVybWlzc2lvbiI6IiJ9.e978AHYTMJeoYTLHpyfWEVnhIfCuolrbF4Wrl9ekbjo', 1583427568),
(6397, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1ODM0OTA0OTcsImV4cCI6MTU4MzQ5MjI5NywicGVybWlzc2lvbiI6IiJ9.HanU8KtKJCcA_XNbrsPTbHm8xMD-UcMizAKSXyWbNKQ', 1583492297),
(6401, 1026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDI2IiwidXNlcm1haWwiOiJjYXJvbGluYXJlc2VuZGVtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTgzNTE4MTY0LCJleHAiOjE1ODM1MTk5NjQsInBlcm1pc3Npb24iOiIifQ.VK2zrb4712wCQgabXyXAEY8qEMifZYzbzyU5BgUfheU', 1583519964),
(6405, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1ODM1ODg3ODIsImV4cCI6MTU4MzU5MDU4MiwicGVybWlzc2lvbiI6IiJ9.YeB68OT1sW_3aNVxbaN1B4e60v4oeaME_ErphFivSc0', 1583590582),
(6409, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1ODM2MDEzMjYsImV4cCI6MTU4MzYwMzEyNiwicGVybWlzc2lvbiI6IiJ9.ASqy-sH5NRCGJIs17H5LUaUAWiTe2d4fdT6U4mC_V0U', 1583603126),
(6413, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1ODM2MTYxMDMsImV4cCI6MTU4MzYxNzkwMywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.DP6r_QiDASQUHhbl69P7JH9Kfe7zyj5gCfdCQvc12QA', 1583617903),
(6417, 1821, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODIxIiwidXNlcm1haWwiOiJyZm1mQHVhLnB0IiwiaWF0IjoxNTgzNjgyNjgzLCJleHAiOjE1ODM2ODQ0ODMsInBlcm1pc3Npb24iOiIifQ.WV1pum-hOBgZ2JaYYQvmi0f0npRKWoXhf6lkq33oleM', 1583684483),
(6421, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODM2OTI3MzEsImV4cCI6MTU4MzY5NDUzMSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.OLsw9N0rD0MkskqigffOvIb4gO4oC0KuCqiiQXwjERk', 1583694531),
(6423, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU4MzY5MzMxNywiZXhwIjoxNTgzNjk1MTE3LCJwZXJtaXNzaW9uIjoiIn0.NcYgziKzoag4TJVhkFwK23QC_Qfr6KFm6nSp__OR3Gg', 1583695117),
(6425, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4MzY5NDQ1OCwiZXhwIjoxNTgzNjk2MjU4LCJwZXJtaXNzaW9uIjoiIn0.zZyy3cA1tWr9uOiP8_h8O7_xFI_knVBUnKiadeH2vmY', 1583696258),
(6427, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4MzY5NTM2MiwiZXhwIjoxNTgzNjk3MTYyLCJwZXJtaXNzaW9uIjoiIn0.TzOoIIWrWrx9GT7guNpsKCaAMcOA8g1vUC6uwdOEPc8', 1583697162),
(6431, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1ODM3MDA5NTksImV4cCI6MTU4MzcwMjc1OSwicGVybWlzc2lvbiI6IiJ9.O7BmafxZ0KezTpLthoyKuROrcgV6jPbSOolmJtCeYwo', 1583702759),
(6433, 1716, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE2IiwidXNlcm1haWwiOiJwZWRyby5iYXNAdWEucHQiLCJpYXQiOjE1ODM3MDExNjMsImV4cCI6MTU4MzcwMjk2MywicGVybWlzc2lvbiI6IiJ9.Z3xdwBhCEG8NJWuZo4I4HyMAjMNQ0w07mN1jjxc4VkU', 1583702963),
(6435, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1ODM3MDE0MTYsImV4cCI6MTU4MzcwMzIxNiwicGVybWlzc2lvbiI6IiJ9.rCB4YzbdyK1-eaxJk9-cFY2A3ZZu5hSdRJjtkVaP5tA', 1583703216),
(6439, 1602, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjAyIiwidXNlcm1haWwiOiJtYXJnYXJpZGEubWFydGluc0B1YS5wdCIsImlhdCI6MTU4MzcwOTA5MCwiZXhwIjoxNTgzNzEwODkwLCJwZXJtaXNzaW9uIjoiIn0.20IeWs0gjsiEprlGU4CyPi4lfNnEbNfJtxcd7ov9vhU', 1583710890),
(6443, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODM3MTkzNDIsImV4cCI6MTU4MzcyMTE0MiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.JWZ3st3bZyeIZ4FXjvl9Pqiua6EN5HTI86GaVKMUB04', 1583721142),
(6447, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1ODM3NDU5OTQsImV4cCI6MTU4Mzc0Nzc5NCwicGVybWlzc2lvbiI6IiJ9.bWTE_jRwycBwjredBhku_JwHuKseI8qN43SoaNkQ5Oc', 1583747794),
(6451, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTgzNzU0NzU2LCJleHAiOjE1ODM3NTY1NTYsInBlcm1pc3Npb24iOiIifQ.-mlsNm7MBvBhDjnKhodZkIJfpIPn2XxJ2ksosm1WR-8', 1583756556),
(6455, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4Mzc1OTUwNywiZXhwIjoxNTgzNzYxMzA3LCJwZXJtaXNzaW9uIjoiIn0.txUCh-uRzIQZQzPwaGAdh6ntnI0OHVuV8gUhFs7uRL4', 1583761307),
(6459, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTgzNzgxMTUyLCJleHAiOjE1ODM3ODI5NTIsInBlcm1pc3Npb24iOiIifQ.lMaiDSdb_XcO_JN1SnhQl8CNIZKloOsQJwO5wbE6c_k', 1583782952),
(6461, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODM3ODE1NjAsImV4cCI6MTU4Mzc4MzM2MCwicGVybWlzc2lvbiI6IiJ9.75wari-BlPNiTNSZe1rXsLLwQPxMy64XibGeRPF-X1Y', 1583783360),
(6463, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4Mzc4MjM1OCwiZXhwIjoxNTgzNzg0MTU4LCJwZXJtaXNzaW9uIjoiIn0.N67Qh1r6v9mTWxf7xBIILcwABzVWmBwZD65GcY0ZnOQ', 1583784158),
(6465, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODM3ODUyNDksImV4cCI6MTU4Mzc4NzA0OSwicGVybWlzc2lvbiI6IiJ9.M1iZ-aU6xAccUbcv1y4oQlAn2lJ4LTpPczWbaXviB4E', 1583787049),
(6467, 2104, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA0IiwidXNlcm1haWwiOiJhZm9uc28uY2FtcG9zQHVhLnB0IiwiaWF0IjoxNTgzNzg2MTk1LCJleHAiOjE1ODM3ODc5OTUsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.j-J0pY3N_JuWflfNvgX_ahGu5IklTdNf2BPJTbdQ2sU', 1583787995),
(6469, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4Mzc4Nzg0NywiZXhwIjoxNTgzNzg5NjQ3LCJwZXJtaXNzaW9uIjoiIn0.Ka2pjE4xGtvitRb1p6pboOqDstFGdIwICtUyhjq03hI', 1583789647),
(6471, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU4Mzc4NzkyNiwiZXhwIjoxNTgzNzg5NzI2LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.aowU4su_O7qpU7-9RPixdOGA7vi0szr73tmE1EKqs_4', 1583789726),
(6475, 1182, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTgyIiwidXNlcm1haWwiOiJkdWFydGUubnRtQHVhLnB0IiwiaWF0IjoxNTgzNzkxODExLCJleHAiOjE1ODM3OTM2MTEsInBlcm1pc3Npb24iOiIifQ.uCfM5S6dQeZnKqeGJ-W1Khfk3q5APinVyzmshdzZmMw', 1583793611),
(6477, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU4Mzc5MzQzMiwiZXhwIjoxNTgzNzk1MjMyLCJwZXJtaXNzaW9uIjoiIn0.6ljPaxy6H3962NiJiTyUTZG3QpMuELnL3VPc4cVaOpU', 1583795232),
(6481, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU4Mzc5NzMzOSwiZXhwIjoxNTgzNzk5MTM5LCJwZXJtaXNzaW9uIjoiIn0.ac5fIfhlaGbv0gufx6agafLwMQqh_tDcwcfdW96z1wU', 1583799139),
(6485, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTgzODQwNDQ1LCJleHAiOjE1ODM4NDIyNDUsInBlcm1pc3Npb24iOiIifQ.65AIVH2X20WPEsX7tS0rvGNR0_jOCMjCKO2-EzG4j1A', 1583842245),
(6487, 1890, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODkwIiwidXNlcm1haWwiOiJzLmdvbWVzQHVhLnB0IiwiaWF0IjoxNTgzODQxNjg1LCJleHAiOjE1ODM4NDM0ODUsInBlcm1pc3Npb24iOiIifQ.XwA6W187CnUkvoSULSKBdIDCBzwUeqn8k6QsiA1n8SA', 1583843485),
(6491, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTgzODUxOTA1LCJleHAiOjE1ODM4NTM3MDUsInBlcm1pc3Npb24iOiIifQ.jz47Adp-HINcsdbQu_z5qerBKjkBr-SvElSsYcYoybQ', 1583853705),
(6493, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTgzODUzMzMzLCJleHAiOjE1ODM4NTUxMzMsInBlcm1pc3Npb24iOiIifQ.4hoerukOSAgzkGJd_NmCGugVaz1zRLMwucl4miSTpKc', 1583855133),
(6497, 2038, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM4IiwidXNlcm1haWwiOiJlZHVhcmRvZmVybmFuZGVzQHVhLnB0IiwiaWF0IjoxNTgzODU3NTE0LCJleHAiOjE1ODM4NTkzMTQsInBlcm1pc3Npb24iOiIifQ.-yX1X6SWg2cXWmMdg5nmCCIOjHjfWwtlOZw9TbAAJM4', 1583859314),
(6499, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1ODM4NTg2MzEsImV4cCI6MTU4Mzg2MDQzMSwicGVybWlzc2lvbiI6IiJ9.2qP_--vTzHncQeRm75uEKXFaM5GJ2Dc1QPz0x4zUd6c', 1583860431),
(6501, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODM4NTkzNTMsImV4cCI6MTU4Mzg2MTE1MywicGVybWlzc2lvbiI6IiJ9.gLK-yPUzX46Q5NI-yvPvzOErbMx62OkD419hiw_dGPg', 1583861153),
(6503, 2106, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA2IiwidXNlcm1haWwiOiJzb3BoaWVwb3VzaW5ob0B1YS5wdCIsImlhdCI6MTU4Mzg2MDE2MywiZXhwIjoxNTgzODYxOTYzLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.mYFkdU2CnsvQa9QpW308urvQ-y05NlXXpq3J_hmnaCY', 1583861963),
(6507, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODM4NjQwNDEsImV4cCI6MTU4Mzg2NTg0MSwicGVybWlzc2lvbiI6IiJ9.axAFrIaTQ1d5xFSCSwX0nBnW1E5slw5tbkDO_ju6I-c', 1583865841),
(6509, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1ODM4NjQ5MTAsImV4cCI6MTU4Mzg2NjcxMCwicGVybWlzc2lvbiI6IiJ9.OnnTGvcu9DJ0d0E5ctvCrjhyptDuklIzJAS_3eUHfmw', 1583866710),
(6511, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODM4NzAwNTAsImV4cCI6MTU4Mzg3MTg1MCwicGVybWlzc2lvbiI6IiJ9.qs5vIX3Y_2JFeWFrXpEwagQ6XCPEMGPzbgCXotK8ncA', 1583871850),
(6513, 1806, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA2IiwidXNlcm1haWwiOiJyYWZhZWxndGVpeGVpcmFAdWEucHQiLCJpYXQiOjE1ODM4NzA2MTksImV4cCI6MTU4Mzg3MjQxOSwicGVybWlzc2lvbiI6IiJ9.lL6R6dMTjQQDowtIr1O1gT0lmyzGILpLGac1uqxhbmk', 1583872419),
(6515, 2122, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTIyIiwidXNlcm1haWwiOiJ5YW5pc21hcmluYWZhcXVpckB1YS5wdCIsImlhdCI6MTU4Mzg3MTQ4NCwiZXhwIjoxNTgzODczMjg0LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.gnDhW8FtUAVEIAbrJKuJvzXEeQ8935eFPBXP76-PoV0', 1583873284),
(6519, 1956, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTU2IiwidXNlcm1haWwiOiJ0aWFnby5zcnYub2xpdmVpcmFAdWEucHQiLCJpYXQiOjE1ODM4NzUwNDgsImV4cCI6MTU4Mzg3Njg0OCwicGVybWlzc2lvbiI6IiJ9.p3HfKfx6eipHgny6jTACzaB9e9Kv9HhAr10U1rNGrQ4', 1583876848),
(6521, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1ODM4NzUxMDksImV4cCI6MTU4Mzg3NjkwOSwicGVybWlzc2lvbiI6IiJ9.A6qiYk7ftLGdxxNFpFmtgDZzXclPVg3KwGF3XAdf9Nw', 1583876909),
(6523, 1956, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTU2IiwidXNlcm1haWwiOiJ0aWFnby5zcnYub2xpdmVpcmFAdWEucHQiLCJpYXQiOjE1ODM4NzUyNjIsImV4cCI6MTU4Mzg3NzA2MiwicGVybWlzc2lvbiI6IiJ9.fcy4uNyvugSvPgTrm2A77ilPvBycreB5x28XV3JWWB8', 1583877062),
(6525, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTgzODc3ODc5LCJleHAiOjE1ODM4Nzk2NzksInBlcm1pc3Npb24iOiIifQ.17I0kdmhpyr1bjPCyOyQ5HEKCptt1x7DPUVig1EXVpg', 1583879679),
(6529, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODM4ODUxMTIsImV4cCI6MTU4Mzg4NjkxMiwicGVybWlzc2lvbiI6IiJ9.3CW0I9vktSmW5ZgGH4Ij8M4DjIktOiV3bhFA56UKmDU', 1583886912),
(6533, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4MzkyODc3OCwiZXhwIjoxNTgzOTMwNTc4LCJwZXJtaXNzaW9uIjoiIn0.oxndtIkln92Re4LSuW763uoJ7nZToqbxMzdhmOjSNDI', 1583930578),
(6541, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4Mzk0NzY3MCwiZXhwIjoxNTgzOTQ5NDcwLCJwZXJtaXNzaW9uIjoiIn0.LN1lyVtkRJkm1BYdckjlUeofU6pg2xsvGmlxuyFHuuE', 1583949470),
(6543, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4Mzk0Nzc1MiwiZXhwIjoxNTgzOTQ5NTUyLCJwZXJtaXNzaW9uIjoiIn0.wLGitlPASRdxyoKum2fG8I1gPC4yl7fPMHqoHhjcHL8', 1583949552),
(6547, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU4NDAyNjg3OSwiZXhwIjoxNTg0MDI4Njc5LCJwZXJtaXNzaW9uIjoiIn0.uaAxcoBn7Lfi1rllA_e859StCVrNrnH8KMoJVCyTvTM', 1584028679),
(6551, 1077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc3IiwidXNlcm1haWwiOiJkYW5pZWwuY291dG9AdWEucHQgIiwiaWF0IjoxNTg0MTExNzgxLCJleHAiOjE1ODQxMTM1ODEsInBlcm1pc3Npb24iOiIifQ.Bjb5IyXzfFIXnlveC-HZh4li1QgM3ydysvpTgl6GKM4', 1584113581),
(6555, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU4NDExOTkzNiwiZXhwIjoxNTg0MTIxNzM2LCJwZXJtaXNzaW9uIjoiIn0.D4hOeGMiKstf5vx43K8E3-GPQyDEHJ66CmuB_KRUEHI', 1584121736),
(6559, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1ODQxMjg2NzgsImV4cCI6MTU4NDEzMDQ3OCwicGVybWlzc2lvbiI6IiJ9.Dp27eBLR58-cIuIxjASe5JW7HWLhx13_dIjt5OegVPI', 1584130478),
(6563, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU4NDEzNzA0MSwiZXhwIjoxNTg0MTM4ODQxLCJwZXJtaXNzaW9uIjoiIn0.rJuqV1J30b2c07xpHvfhQL9m_VwjP-DCK4GoAboXBT0', 1584138841),
(6567, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1ODQxNDU4NTUsImV4cCI6MTU4NDE0NzY1NSwicGVybWlzc2lvbiI6IiJ9.DLU72ftGhkEr_soB7zJly73DXWQW4Ph5QdR1Mx4-t84', 1584147655),
(6571, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODQxOTAwNTMsImV4cCI6MTU4NDE5MTg1MywicGVybWlzc2lvbiI6IiJ9.tDLqjkucx8NFMr1ukas5eaSKrWJIMxNEDcAKIqMUGDQ', 1584191853),
(6573, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODQxOTAxMTUsImV4cCI6MTU4NDE5MTkxNSwicGVybWlzc2lvbiI6IiJ9.7CypT_00MgTFeawWwuroOuO7Mdqwu3TV5NKIWxQgT8M', 1584191915),
(6577, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg0MTk1NDc5LCJleHAiOjE1ODQxOTcyNzksInBlcm1pc3Npb24iOiIifQ.cNs1NcqDM0LmrUUPuuxReJh85f-KcBJD752f9PgmPx4', 1584197279),
(6581, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4NDI3MTEzOCwiZXhwIjoxNTg0MjcyOTM4LCJwZXJtaXNzaW9uIjoiIn0.oVRL1b8SHwam9Ek4LPu5jBACKZkHhtys7eXh-GQA2LE', 1584272938),
(6583, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4NDI3MjMyMywiZXhwIjoxNTg0Mjc0MTIzLCJwZXJtaXNzaW9uIjoiIn0.2qnFKrj0vSlnNULOy6Naz1hbMBl1e5FILwbpd_kctgE', 1584274123),
(6587, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTg0MjgxNzQ5LCJleHAiOjE1ODQyODM1NDksInBlcm1pc3Npb24iOiIifQ.O2Wu-pgyI5T8r8hArvEJ6xQ8okEgjhbEf7Mq1rSbgxA', 1584283549),
(6591, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4NDM3NTkxNywiZXhwIjoxNTg0Mzc3NzE3LCJwZXJtaXNzaW9uIjoiIn0.3yafT48PWFemVShatHyH2g-263VV1RvR3p4tUDiowks', 1584377717),
(6595, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg0Mzc5MDcyLCJleHAiOjE1ODQzODA4NzIsInBlcm1pc3Npb24iOiIifQ.7SS0ldWeG-Af_15wQ7aMjvmdpghZf5AEMA6DTnJqlTE', 1584380872),
(6599, 2104, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA0IiwidXNlcm1haWwiOiJhZm9uc28uY2FtcG9zQHVhLnB0IiwiaWF0IjoxNTg0Mzg5NDQyLCJleHAiOjE1ODQzOTEyNDIsInBlcm1pc3Npb24iOiJERUZBVUxUIn0.d2eJonx8_HINpKnVPPJA-TmKlKTGuQYPZBLs65FR-Eo', 1584391242),
(6603, 1254, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjU0IiwidXNlcm1haWwiOiJmcmFuY2lzY2EubWJhcnJvc0B1YS5wdCIsImlhdCI6MTU4NDM5NTIxNSwiZXhwIjoxNTg0Mzk3MDE1LCJwZXJtaXNzaW9uIjoiIn0.vDHMUrIEjNgWsx9AXOCpQuHdAZqKP8qCvcmK3gNx_AQ', 1584397015),
(6607, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU4NDUzMTU0MCwiZXhwIjoxNTg0NTMzMzQwLCJwZXJtaXNzaW9uIjoiIn0.CW9OSXSjLqt0v7zgKvdOw4K1_C4RptYbT-VxH_zZJb4', 1584533340),
(6609, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTg0NTMyNTMyLCJleHAiOjE1ODQ1MzQzMzIsInBlcm1pc3Npb24iOiIifQ.wVC3aNA2ghHy32TkvQXROVY9Qik77eCJ-2k8w0xUf8s', 1584534332),
(6613, 2080, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDgwIiwidXNlcm1haWwiOiJicmFpc0B1YS5wdCIsImlhdCI6MTU4NDU0Mzg0MCwiZXhwIjoxNTg0NTQ1NjQwLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.pw5twQXPjzX6KLZjuKnt_2L-tSCJurTeeNNNNOHkwWA', 1584545640),
(6617, 2077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc3IiwidXNlcm1haWwiOiJpdmFubWFuc29nYXJjaWFAdWEucHQiLCJpYXQiOjE1ODQ1NDkyMTYsImV4cCI6MTU4NDU1MTAxNiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.wFyiyQA5UXOhwdUwB-Am3xJ5ocPeMbhhvEyauCxXCw8', 1584551016),
(6619, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg0NTUwMTgyLCJleHAiOjE1ODQ1NTE5ODIsInBlcm1pc3Npb24iOiIifQ.dkkf0Af9C-g7el_H2oSmVtsJgm1bOfu74kWz0BIHLm0', 1584551982),
(6623, 897, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4OTciLCJ1c2VybWFpbCI6ImFuYXJhZmFlbGE5OEB1YS5wdCIsImlhdCI6MTU4NDU3ODI1NiwiZXhwIjoxNTg0NTgwMDU2LCJwZXJtaXNzaW9uIjoiIn0.Ymq5SAupOkD4wIFCphBoYlEOaTKYtFwtI5wri4d3Y-I', 1584580056),
(6627, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg0NjMzNDgyLCJleHAiOjE1ODQ2MzUyODIsInBlcm1pc3Npb24iOiIifQ.PYMses4Tqaagjdv134G0r5D1NTMQL7eg4K-ggYAMpxk', 1584635282),
(6629, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU4NDYzNDk4NiwiZXhwIjoxNTg0NjM2Nzg2LCJwZXJtaXNzaW9uIjoiIn0.1EnSDREzJh9qOC21gGqtW3lLzIxFZsMgkDqFoDHbJgo', 1584636786),
(6633, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU4NDY0ODYxMCwiZXhwIjoxNTg0NjUwNDEwLCJwZXJtaXNzaW9uIjoiIn0.te_be_HbA6ig-Iy3D5lFzQQZZI65tAWkZ7d-AEp9tyI', 1584650410),
(6637, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODQ2NjI4NzAsImV4cCI6MTU4NDY2NDY3MCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.5bSaDdquRp6tBbSJv4kMyxCBhLgFXYOTXveou848Lcg', 1584664670),
(6641, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg0NzA0NzE4LCJleHAiOjE1ODQ3MDY1MTgsInBlcm1pc3Npb24iOiIifQ.oF5vVUAomduHOiz-b2EVblpDntffyvRRiJjco35UON8', 1584706518);
INSERT INTO `GenTokens` (`id`, `userid`, `token`, `expire_date`) VALUES
(6645, 2040, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQwIiwidXNlcm1haWwiOiJmYWJpby5tQHVhLnB0IiwiaWF0IjoxNTg0NzIwODAyLCJleHAiOjE1ODQ3MjI2MDIsInBlcm1pc3Npb24iOiIifQ.VqlluDXEIzcNdcM0KGfEb_c7CeOMNgwOg9vJhcq4nME', 1584722602),
(6649, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODQ3NjIzNDEsImV4cCI6MTU4NDc2NDE0MSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.27o830X8MEqyNnbDIdAPJwoJFCgmAqpvH62sUQNn8VA', 1584764141),
(6655, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTg0NzgxOTAxLCJleHAiOjE1ODQ3ODM3MDEsInBlcm1pc3Npb24iOiIifQ.v9P0e3Vzdy1lXZCxhO1mgmFe__AS5GNzrxVt3VYjQK4', 1584783701),
(6661, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg0ODkxMTIyLCJleHAiOjE1ODQ4OTI5MjIsInBlcm1pc3Npb24iOiIifQ.TCY65aWjMUqla0br3h3SQpBeltEPVMwTGQ40tetUZrE', 1584892922),
(6667, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTg0ODk4OTYwLCJleHAiOjE1ODQ5MDA3NjAsInBlcm1pc3Npb24iOiIifQ.rdbnRN6yIhQzdbAiqNag-Y8DU1gOODtPlVx7K-x6v_Y', 1584900760),
(6673, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1ODQ5MDQ1MDAsImV4cCI6MTU4NDkwNjMwMCwicGVybWlzc2lvbiI6IiJ9.ZnBl7Tg0OTkvQZQKXwd5oyLuc0PiUoz9OhcCor1NiLk', 1584906300),
(6679, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODQ5MDgxODYsImV4cCI6MTU4NDkwOTk4NiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.eNrq1zQpxw9bq_OFsTaz53K_TYr7BYGZ4lu0LLRuzbo', 1584909986),
(6682, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODQ5MTEzNDIsImV4cCI6MTU4NDkxMzE0MiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.STHms3-B6B0COI6Dgiw3qsZeGchoo8rRT4g7y7wQfwc', 1584913142),
(6688, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg0OTE4ODk4LCJleHAiOjE1ODQ5MjA2OTgsInBlcm1pc3Npb24iOiIifQ.uNRHRGEnsEbAHWdCvoK_BimYJlOB1fuBaFolwLnRLz0', 1584920698),
(6691, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1ODQ5MjI0ODUsImV4cCI6MTU4NDkyNDI4NSwicGVybWlzc2lvbiI6IiJ9.st2sephI7XMRznWrFGTptRwmOWWmifdd1j_PNlkSnkc', 1584924285),
(6694, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg0OTIzMTE3LCJleHAiOjE1ODQ5MjQ5MTcsInBlcm1pc3Npb24iOiIifQ.1ve177WzMbrBnE0vohdDG0I0oRmG_Ul4haaE6F-9sOo', 1584924917),
(6697, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU4NDkyNDIzMywiZXhwIjoxNTg0OTI2MDMzLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.0kDRdTFeaGM99gvtkEK_JkJc4kShr14EJKocFtW5kQA', 1584926033),
(6703, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODQ5Mjg1NjcsImV4cCI6MTU4NDkzMDM2NywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.8abfvKHjLmNQESH-YQPPxUp2ZiVV-6jd4cKwdSHjLZA', 1584930367),
(6709, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg0OTY0MDU0LCJleHAiOjE1ODQ5NjU4NTQsInBlcm1pc3Npb24iOiIifQ.2VGx2j8T0x37pji1ysKiJicGn6_KP711W99zDAVfHNw', 1584965854),
(6715, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg0OTgwNjA0LCJleHAiOjE1ODQ5ODI0MDQsInBlcm1pc3Npb24iOiIifQ.K83M8_PQ58HBNFlaQiWMLd9rM6APsH9Qi9Tu5LKEgkY', 1584982404),
(6721, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1ODQ5ODQ3MTAsImV4cCI6MTU4NDk4NjUxMCwicGVybWlzc2lvbiI6IiJ9.UnGOTbFIGIcqKbndgq_wVwICAAkyLdBxm4wq74xyOB8', 1584986510),
(6727, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU4NDk4OTEwNCwiZXhwIjoxNTg0OTkwOTA0LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.GdLCiCkELwokoF2O7JiiRx_9MRQzBMuXMV_rT260l0w', 1584990904),
(6733, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTg0OTkzMjM1LCJleHAiOjE1ODQ5OTUwMzUsInBlcm1pc3Npb24iOiIifQ.KrQinvr2kI_LxndIeOPUT7DHB_7g96Lk1rGWcSgacUo', 1584995035),
(6739, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg1MDAwNzkyLCJleHAiOjE1ODUwMDI1OTIsInBlcm1pc3Npb24iOiIifQ.rcVCrGGmENgL5dh_ontpWIaFzIaDcFFBXbISP6vMhEQ', 1585002592),
(6745, 1890, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODkwIiwidXNlcm1haWwiOiJzLmdvbWVzQHVhLnB0IiwiaWF0IjoxNTg1MDQ5NDA0LCJleHAiOjE1ODUwNTEyMDQsInBlcm1pc3Npb24iOiIifQ.rpecNTm0lJ1Nb5Ldw05dYn70Brkaujxn3TibNPIK7ZU', 1585051204),
(6751, 2074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc0IiwidXNlcm1haWwiOiJ2aWNlbnRlLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTg1MDYxNzY3LCJleHAiOjE1ODUwNjM1NjcsInBlcm1pc3Npb24iOiIifQ.49jAOMGBGhlX75X9yVuou6BtYHFcFUk1yfGCDInxcRk', 1585063567),
(6757, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODUwNjM3NTQsImV4cCI6MTU4NTA2NTU1NCwicGVybWlzc2lvbiI6IiJ9.8XfFkp57UL7eDaVCYxUnQEdpfjEOz7Kqy_RhkKsHEQ4', 1585065554),
(6763, 1122, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTIyIiwidXNlcm1haWwiOiJkZmFjQHVhLnB0IiwiaWF0IjoxNTg1MDY3NDk1LCJleHAiOjE1ODUwNjkyOTUsInBlcm1pc3Npb24iOiIifQ.PXGF8QrIVao8eOSFtrwh3IiABSKuGvb9cc3JVTyPzec', 1585069295),
(6769, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODUwNzAyMzYsImV4cCI6MTU4NTA3MjAzNiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.fDAhfmCLId7-Mb77ND1TrZXl5W2WUdkYxmK0-EcgXj8', 1585072036),
(6772, 1425, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDI1IiwidXNlcm1haWwiOiJqb2FvbWFkaWFzQHVhLnB0IiwiaWF0IjoxNTg1MDcwOTM3LCJleHAiOjE1ODUwNzI3MzcsInBlcm1pc3Npb24iOiIifQ.O7eGEMa4ml5-ZajrM9KxkKfM11jVMwoIGYbt3ZbRXp0', 1585072737),
(6778, 1800, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAwIiwidXNlcm1haWwiOiJyYWZhZWwubmV2ZXMuZGlyZWl0b0B1YS5wdCIsImlhdCI6MTU4NTA3OTQyMCwiZXhwIjoxNTg1MDgxMjIwLCJwZXJtaXNzaW9uIjoiIn0.V56RsnWucbYhi7XttkxKDArZZvImi6au0xx9NH88tjw', 1585081220),
(6784, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTg1MDg2NTI0LCJleHAiOjE1ODUwODgzMjQsInBlcm1pc3Npb24iOiIifQ.KD42yVOQYHrXhMCw2f64Jhi6i36J3X2_9IA0cQ5KWA0', 1585088324),
(6790, 1722, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzIyIiwidXNlcm1haWwiOiJwZWRyby5taWd1ZWw1MEB1YS5wdCIsImlhdCI6MTU4NTE0Mzk5OSwiZXhwIjoxNTg1MTQ1Nzk5LCJwZXJtaXNzaW9uIjoiIn0.xELPNZ1z-ruOaZfMOzZfq2SRjjLbQ1uxGDYngiSTo6I', 1585145799),
(6796, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTg1MTUyNzc2LCJleHAiOjE1ODUxNTQ1NzYsInBlcm1pc3Npb24iOiIifQ.yE7mSDoGEJyAI828DKyhXJZKiYQexFSwjn88ux2Ujfg', 1585154576),
(6802, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTg1MTU4NTY3LCJleHAiOjE1ODUxNjAzNjcsInBlcm1pc3Npb24iOiIifQ.WhChElocydnsazOuocunwjWYo-JRzyY2mS_iREutrYU', 1585160367),
(6808, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTg1MTY2MDA2LCJleHAiOjE1ODUxNjc4MDYsInBlcm1pc3Npb24iOiIifQ.cbCUEW_RF-VM9J4DS7JEYzcMShi4QP5Qw4aupDUSxmQ', 1585167806),
(6814, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg1MTY4ODU0LCJleHAiOjE1ODUxNzA2NTQsInBlcm1pc3Npb24iOiIifQ.q5vp4qgRfowPvQMw-fuKyjsmuwWFMvlx7ECIlBUXRAg', 1585170654),
(6820, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTg1MjE2MjkzLCJleHAiOjE1ODUyMTgwOTMsInBlcm1pc3Npb24iOiIifQ.pdEVZlR5cKI6JFthy_iaYPUcgnleSExPGrMMm3Vgm0k', 1585218093),
(6826, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTg1MjMwNjg5LCJleHAiOjE1ODUyMzI0ODksInBlcm1pc3Npb24iOiIifQ.MRqnX6B6FwfpFY5K4Pnmp4ksIw82vdUBxeAIjcIib6o', 1585232489),
(6829, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU4NTIzMTk0MCwiZXhwIjoxNTg1MjMzNzQwLCJwZXJtaXNzaW9uIjoiIn0.HAeXGhOAWiEFFkKXvDOS2wrXBE11fkbVoGu-JSJjvzk', 1585233740),
(6832, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg1MjMzNjg2LCJleHAiOjE1ODUyMzU0ODYsInBlcm1pc3Npb24iOiIifQ.ALG26VpRfsAeBSKYijALElRvtA0uziZyNUq3MmiHuFk', 1585235486),
(6838, 2057, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU3IiwidXNlcm1haWwiOiJwbWQ4QHVhLnB0IiwiaWF0IjoxNTg1MjU2MjQ3LCJleHAiOjE1ODUyNTgwNDcsInBlcm1pc3Npb24iOiIifQ.yZYMqv1T4xbrBayUbsPBCHKfPUTMFig-v1xO4ONJDJI', 1585258047),
(6844, 2122, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTIyIiwidXNlcm1haWwiOiJ5YW5pc21hcmluYWZhcXVpckB1YS5wdCIsImlhdCI6MTU4NTMwNjcwMywiZXhwIjoxNTg1MzA4NTAzLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.O2t5ipOgwQkUEHp-hk-HlVa9JGvbamzwgGWyTU2aKAM', 1585308503),
(6850, 2038, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM4IiwidXNlcm1haWwiOiJlZHVhcmRvZmVybmFuZGVzQHVhLnB0IiwiaWF0IjoxNTg1MzA5NzI2LCJleHAiOjE1ODUzMTE1MjYsInBlcm1pc3Npb24iOiIifQ.IiTpBQAM3No7ukW3FH8A1s-zQSyfYgtxR0_4CZcoPHE', 1585311526),
(6856, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTg1MzE4MjE0LCJleHAiOjE1ODUzMjAwMTQsInBlcm1pc3Npb24iOiIifQ.jd2sohIdg1lkQTDIecnqlWG_X_1DcDyX6IocoMPISXQ', 1585320014),
(6862, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTg1MzkyNzc3LCJleHAiOjE1ODUzOTQ1NzcsInBlcm1pc3Npb24iOiIifQ.FCv7keZrigis2GPmdc4urNAwJgs3RD3nFZCFtuwSskE', 1585394577),
(6868, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4NTQwNjk1MiwiZXhwIjoxNTg1NDA4NzUyLCJwZXJtaXNzaW9uIjoiIn0.my8Sge0vEv1M6uQmi31LgXOyhMPKF1LfS5XrBoVawcM', 1585408752),
(6874, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg1NDE2NDQ1LCJleHAiOjE1ODU0MTgyNDUsInBlcm1pc3Npb24iOiIifQ.hP_WmNxWgL52MBKLEYNZXHc0XBKnt5_RI8grvHKDGas', 1585418245),
(6880, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTg1NDk2MzIyLCJleHAiOjE1ODU0OTgxMjIsInBlcm1pc3Npb24iOiIifQ.V2S6LwkxtF6dB1Z5tfLXVIqGFIZKD9DJHZjTloVxO4E', 1585498122),
(6883, 1557, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTU3IiwidXNlcm1haWwiOiJsdmFsZW50aW1AdWEucHQiLCJpYXQiOjE1ODU0OTY5NzQsImV4cCI6MTU4NTQ5ODc3NCwicGVybWlzc2lvbiI6IiJ9.DlJZ4-ZKfOAgYbD54gjN4pOSZU9VIBuogAwrEswhQac', 1585498774),
(6886, 1077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc3IiwidXNlcm1haWwiOiJkYW5pZWwuY291dG9AdWEucHQgIiwiaWF0IjoxNTg1NDk3NjE1LCJleHAiOjE1ODU0OTk0MTUsInBlcm1pc3Npb24iOiIifQ.4E07twFR46mgPpVo0R9f7dpt2VV4cAjyvUdTvPDsoeU', 1585499415),
(6892, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1ODU1MjA4NzQsImV4cCI6MTU4NTUyMjY3NCwicGVybWlzc2lvbiI6IiJ9.v0b7OTwV1WiJ9xpHhQ1EWr0PJ46_dePCYzsI5dc1mwM', 1585522674),
(6898, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODU1MjYyMTAsImV4cCI6MTU4NTUyODAxMCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.47smc9Z93u3oBxJ6fHflkP2Qj4Fp1CFWWqqC5wgMl8I', 1585528010),
(6904, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODU1NzExMzAsImV4cCI6MTU4NTU3MjkzMCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.v5sAeCIzcTgWo7iek0IQXszPFXrjRyyqF3a1x7ezjMs', 1585572930),
(6910, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4NTU3NjM1OCwiZXhwIjoxNTg1NTc4MTU4LCJwZXJtaXNzaW9uIjoiIn0.dSMbFlyu3GzpBju47-HYHiDWJO4-xpyR1EmApZPs6BM', 1585578158),
(6916, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg1NTgxNTM3LCJleHAiOjE1ODU1ODMzMzcsInBlcm1pc3Npb24iOiIifQ.qhx81AMws05I5STAFZYHnxLpY_kTcXBMrCAJOS07sPM', 1585583337),
(6919, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTg1NTgyMTg0LCJleHAiOjE1ODU1ODM5ODQsInBlcm1pc3Npb24iOiIifQ.4DjBy28ewd-tWstRgIvpvfatwPD-6JaDT91ZleRNzNk', 1585583984),
(6922, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODU1ODMxMjksImV4cCI6MTU4NTU4NDkyOSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.yz33Fdhn9e0T_CJrHPArk5n6W2KgDUmtOnTDWrN_OPc', 1585584929),
(6925, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTg1NTgzMTg2LCJleHAiOjE1ODU1ODQ5ODYsInBlcm1pc3Npb24iOiIifQ.RwHFflJ_JD-8EnXK_pkqTrw_O_TP9eFgTD94Xaex9kE', 1585584986),
(6931, 1341, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQxIiwidXNlcm1haWwiOiJpbmVzLnBsQHVhLnB0IiwiaWF0IjoxNTg1NjY3MjA0LCJleHAiOjE1ODU2NjkwMDQsInBlcm1pc3Npb24iOiIifQ.IK9_vgtE6SGZs3DJsGPxMOIZcxyRM0mPrlPSsUjyfrc', 1585669004),
(6937, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4NTY3NDgzNCwiZXhwIjoxNTg1Njc2NjM0LCJwZXJtaXNzaW9uIjoiIn0.J2lM80-WAXQhOAcvvS2KDvA8zmPfH_qtQ84ptLE5cz8', 1585676634),
(6943, 1806, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA2IiwidXNlcm1haWwiOiJyYWZhZWxndGVpeGVpcmFAdWEucHQiLCJpYXQiOjE1ODU2Nzg4MjMsImV4cCI6MTU4NTY4MDYyMywicGVybWlzc2lvbiI6IiJ9.JOXjF_zdqaKoG_K1OLGjOj4Mxxa0SOIySDKtctOV0ZU', 1585680623),
(6949, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTg1NzMyNzc4LCJleHAiOjE1ODU3MzQ1NzgsInBlcm1pc3Npb24iOiIifQ.cWN3T1LpehaEdX9Oyp5MKSQQc6xZMxFkxNL3OXliMhA', 1585734578),
(6955, 978, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5NzgiLCJ1c2VybWFpbCI6ImJyZW5vc2FsbGVzQHVhLnB0IiwiaWF0IjoxNTg1NzM5NTQ5LCJleHAiOjE1ODU3NDEzNDksInBlcm1pc3Npb24iOiIifQ.TCwwXSM41FFKYFyQ-Bu-TK-S9_EteSkPS0oxQkyRMeI', 1585741349),
(6961, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU4NTc0NjA0NCwiZXhwIjoxNTg1NzQ3ODQ0LCJwZXJtaXNzaW9uIjoiIn0.DvX87DX6w41LQMruonUL1zwLDiID_4t2Gwj2VrYm33Y', 1585747844),
(6967, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU4NTc1Mjc5NiwiZXhwIjoxNTg1NzU0NTk2LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.sEZSdrPmD9-t24H1g7mG4gr5F9EEQYsodZXH121pV5c', 1585754596),
(6973, 2036, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM2IiwidXNlcm1haWwiOiJkaW9nb21mc2lsdmE5OEB1YS5wdCIsImlhdCI6MTU4NTc2MTQ4MiwiZXhwIjoxNTg1NzYzMjgyLCJwZXJtaXNzaW9uIjoiIn0.LaA2k-sH_MmtLwmG8ZU5hsBkN7tu_PX1oM1Ldj50kPw', 1585763282),
(6979, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg1NzcyODkzLCJleHAiOjE1ODU3NzQ2OTMsInBlcm1pc3Npb24iOiIifQ.9a06mDqamM3oHOIk4NyDc2b_UgSlaDYT428lxCsdllo', 1585774693),
(6985, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU4NTgyMjU4MiwiZXhwIjoxNTg1ODI0MzgyLCJwZXJtaXNzaW9uIjoiIn0.GTT2_nhXA9ycZDjyBPBE0DShgFFjjGlBF3u-GdyIZ6A', 1585824382),
(6991, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTg1ODM3MTMxLCJleHAiOjE1ODU4Mzg5MzEsInBlcm1pc3Npb24iOiIifQ.zk3NJ_dy5IPgaYKJC5kFJhZKzrppjBwEOBTLAKkSy8I', 1585838931),
(6994, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODU4MzgwOTAsImV4cCI6MTU4NTgzOTg5MCwicGVybWlzc2lvbiI6IiJ9.QN6HqpQAZdtYJ5pnql1rR4WU-c3nze7QGwWpGO2Kp2U', 1585839890),
(7000, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1ODU4NDI0ODUsImV4cCI6MTU4NTg0NDI4NSwicGVybWlzc2lvbiI6IiJ9.cZ6gmD64vd4IPYNfc3RSJzUo-MA3Yw1f8pFD85DHokE', 1585844285),
(7003, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTg1ODQzOTE2LCJleHAiOjE1ODU4NDU3MTYsInBlcm1pc3Npb24iOiIifQ.f3mobcDgXueXVxlUnwywEQEhMz_rASFChYDxiX222mg', 1585845716),
(7009, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU4NTkwMTcxMiwiZXhwIjoxNTg1OTAzNTEyLCJwZXJtaXNzaW9uIjoiIn0.Khnpgv14SyGP4O1wfuzzBZy6rx_sDsPAjIAsZmgHEA0', 1585903512),
(7015, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODU5MjIzNzQsImV4cCI6MTU4NTkyNDE3NCwicGVybWlzc2lvbiI6IiJ9.bb1isqEsdN2ui6QnbR0S6fYa9FOamO3IYs-feb5OfYI', 1585924174),
(7021, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg1OTI4ODc0LCJleHAiOjE1ODU5MzA2NzQsInBlcm1pc3Npb24iOiIifQ.tUTTXq56Gncn0v20gIJLGrX6ALlrqqMuMTBWt8ooe3I', 1585930674),
(7027, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1ODU5NjAzMTIsImV4cCI6MTU4NTk2MjExMiwicGVybWlzc2lvbiI6IiJ9.WowOqhmU0yJ6IZxDlTV9j7rEPwzTTq3kmBxBMlFG2lQ', 1585962112),
(7033, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTg2MDE4OTUzLCJleHAiOjE1ODYwMjA3NTMsInBlcm1pc3Npb24iOiIifQ.XW8HyGyyA1XSib_VYcrEV-5O6CoEtqEEAK9CbqpsRRE', 1586020753),
(7039, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg2MDkzNDg5LCJleHAiOjE1ODYwOTUyODksInBlcm1pc3Npb24iOiIifQ.5oCXOxK0OXrel9qXgFTFFpHRkI_2PjomqJs707hRDJc', 1586095289),
(7045, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTg2MTYzODE5LCJleHAiOjE1ODYxNjU2MTksInBlcm1pc3Npb24iOiIifQ.3DM8ST43k7fbnXLDF42Y2JcY85TIfHLa7mXJrxwFpW8', 1586165619),
(7051, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4NjE4MjE1OSwiZXhwIjoxNTg2MTgzOTU5LCJwZXJtaXNzaW9uIjoiIn0.DjwB6QjMQb5UScGbaxTW03dld_jKxrq6WZQMGqVvqn4', 1586183959),
(7057, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTg2MTk4NDM2LCJleHAiOjE1ODYyMDAyMzYsInBlcm1pc3Npb24iOiIifQ.tOJVRY_rYM8QX06q0e1-ZON_MOHFwVVJssUiQPlb0mg', 1586200236),
(7063, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg2MjA0MDg5LCJleHAiOjE1ODYyMDU4ODksInBlcm1pc3Npb24iOiIifQ.A28ZQFJon92S_RK9C3Xm6phm-CfevU2n03OI4z_cCgQ', 1586205889),
(7069, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1ODYyMTkxNDEsImV4cCI6MTU4NjIyMDk0MSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.ZjjHiXcPV2LikA6QDFa2JhwlxgTUbN4645UOPbdVVUc', 1586220941),
(7075, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1ODYyNTcxMDIsImV4cCI6MTU4NjI1ODkwMiwicGVybWlzc2lvbiI6IiJ9.1K1d1ZY8vVLQ0-fWw2pBG_-cyZTmOmTXfjtr9V7xTS0', 1586258902),
(7078, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1ODYyNTg1NDIsImV4cCI6MTU4NjI2MDM0MiwicGVybWlzc2lvbiI6IiJ9._1PU6Mqw2flw5P_qWit2TUu5ujPlaK0uw4e_Ktl3rs8', 1586260342),
(7084, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODYyNjE1OTEsImV4cCI6MTU4NjI2MzM5MSwicGVybWlzc2lvbiI6IiJ9.Hk2yXn-pWpeCWHs74goskr0M-0AbK0QusOwE-dplKzk', 1586263391),
(7090, 2106, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA2IiwidXNlcm1haWwiOiJzb3BoaWVwb3VzaW5ob0B1YS5wdCIsImlhdCI6MTU4NjI2ODMyMiwiZXhwIjoxNTg2MjcwMTIyLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.u7KDrk5QZo5MtnyVYHMXS3Eg9s6mud80D0kkzPBYgL0', 1586270122),
(7093, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1ODYyNjg3NzAsImV4cCI6MTU4NjI3MDU3MCwicGVybWlzc2lvbiI6IiJ9.LckvSZfclLeOQP1xAkMpuCV-UpPxpDMlxUhOLG6EaC8', 1586270570),
(7099, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTg2MjcwNjk4LCJleHAiOjE1ODYyNzI0OTgsInBlcm1pc3Npb24iOiIifQ.6yBTkBIhCrixpK_DCqYQdbXJfw8l_9ZMyizu6o93r5s', 1586272498),
(7105, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTg2Mjg1MDU1LCJleHAiOjE1ODYyODY4NTUsInBlcm1pc3Npb24iOiIifQ.Q0CGgseNWkDf0xEqyJ_IeM6eE6jWGPXwhA4bHi0sHaQ', 1586286855),
(7108, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1ODYyODY3MDcsImV4cCI6MTU4NjI4ODUwNywicGVybWlzc2lvbiI6IiJ9.-BBHJr9yR9FtBMuu366OEtjSNgPOB-5XYNRKpCAHJXE', 1586288507),
(7114, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1ODYzNDYwMTEsImV4cCI6MTU4NjM0NzgxMSwicGVybWlzc2lvbiI6IiJ9.JC6O9huQCBHhXRTgKjLO3MCHti-5Nd6Fxy1_akIR3mg', 1586347811),
(7120, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU4NjM1Nzg2MCwiZXhwIjoxNTg2MzU5NjYwLCJwZXJtaXNzaW9uIjoiIn0.Zk8xwJ31PLtebWtNZuVOre6N20qx32i07Xb4L9I5WR0', 1586359660),
(7123, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTg2MzU5MDQ1LCJleHAiOjE1ODYzNjA4NDUsInBlcm1pc3Npb24iOiIifQ.EgtCTd_0nzjmKNkvDB05zS2gx8QIsmQYiBx3jVaSco8', 1586360845),
(7129, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg2MzYyMTIxLCJleHAiOjE1ODYzNjM5MjEsInBlcm1pc3Npb24iOiIifQ.bdvJWWUDxHIRWfT56nM9COQQ77dpzsDCAC3NsPVoU5Q', 1586363921),
(7135, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODYzNzAyMzIsImV4cCI6MTU4NjM3MjAzMiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.pytoN6fJT1_V4O7US71mlkfcGJlBl6GP6CXuI8B56Aw', 1586372032),
(7138, 2040, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQwIiwidXNlcm1haWwiOiJmYWJpby5tQHVhLnB0IiwiaWF0IjoxNTg2MzcxODk5LCJleHAiOjE1ODYzNzM2OTksInBlcm1pc3Npb24iOiIifQ.V4uJTeC8wSVQ5W8C5U1GY94hZepahmdDj-IJGWDHZyw', 1586373699),
(7144, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU4NjM3NjkwMSwiZXhwIjoxNTg2Mzc4NzAxLCJwZXJtaXNzaW9uIjoiIn0.9gADoLjFMjv2BR3xCyhcekgSfnloGKjjPep0GKXzOZA', 1586378701),
(7150, 2028, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI4IiwidXNlcm1haWwiOiJjZmZvbnNlY2FAdWEucHQiLCJpYXQiOjE1ODY0MzUzMDMsImV4cCI6MTU4NjQzNzEwMywicGVybWlzc2lvbiI6IiJ9.O-gVgU8NS0rRHQhEzamcwdKweQ3O95wv_spQunEQeGE', 1586437103),
(7153, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTg2NDM4NjQ1LCJleHAiOjE1ODY0NDA0NDUsInBlcm1pc3Npb24iOiIifQ.RriGK_kKMx8Wj0-1dtMmwLGsMUn_j15QoB9FwHj9RoI', 1586440445),
(7159, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU4NjQ0NDYwNCwiZXhwIjoxNTg2NDQ2NDA0LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.e87v64Au9dgH7dmvles6wsT0eSEF8TZwrXrvdDniZj4', 1586446404),
(7162, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU4NjQ0NjEzOCwiZXhwIjoxNTg2NDQ3OTM4LCJwZXJtaXNzaW9uIjoiIn0.s-gyV9dFCM56000Nkdr23rVwMDEALByvxwXiW3ASy4Y', 1586447938),
(7165, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU4NjQ0NjYzMywiZXhwIjoxNTg2NDQ4NDMzLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.vBM1HeiWHnGczawjqhl6i17uzoapq7Ck-zGwOW0vlqQ', 1586448433),
(7168, 2045, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ1IiwidXNlcm1haWwiOiJodWdvZ29uY2FsdmVzMTNAdWEucHQiLCJpYXQiOjE1ODY0NDcyMzAsImV4cCI6MTU4NjQ0OTAzMCwicGVybWlzc2lvbiI6IiJ9.UzfNuV7pxDjjuVLt6pPmLONA0b7QwcB4yYtUQ3sB5fE', 1586449030),
(7174, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU4NjQ1NjY0MSwiZXhwIjoxNTg2NDU4NDQxLCJwZXJtaXNzaW9uIjoiIn0.ok59zcWEAW0oAp7RmWWl1Q55lFcGmTzj7hXGAD5p4sE', 1586458441),
(7180, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU4NjQ2NjgxNywiZXhwIjoxNTg2NDY4NjE3LCJwZXJtaXNzaW9uIjoiIn0.WtyThDagPcTJN3JSsgPZ6T_L3544IwPzOmnpvPqLOZs', 1586468617),
(7186, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODY1MTIwMTIsImV4cCI6MTU4NjUxMzgxMiwicGVybWlzc2lvbiI6IiJ9.DT5FeRybyaMVnWPVUWcZHrZHbt9_TeLSve1Kq3nLNu4', 1586513812),
(7192, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTg2NTIzMTg2LCJleHAiOjE1ODY1MjQ5ODYsInBlcm1pc3Npb24iOiIifQ.PP8bXtLnpHm--79C7yqr8fgHrZC_-uYNWhFwfvwYIR8', 1586524986),
(7198, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1ODY1MjgyODMsImV4cCI6MTU4NjUzMDA4MywicGVybWlzc2lvbiI6IiJ9.UicKWLn3uLleiosg9xB8SKyCpIpLw9m8zIJ2hQQwlpY', 1586530083),
(7201, 2045, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ1IiwidXNlcm1haWwiOiJodWdvZ29uY2FsdmVzMTNAdWEucHQiLCJpYXQiOjE1ODY1MzIwNDEsImV4cCI6MTU4NjUzMzg0MSwicGVybWlzc2lvbiI6IiJ9.lgLUFbg2A2oLnAWaP76VR9FWueAhkCiUdTyVusJWS6g', 1586533841),
(7207, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTg2NjA0MTI3LCJleHAiOjE1ODY2MDU5MjcsInBlcm1pc3Npb24iOiIifQ.KI2hcVmHvQJB7OLdfdH47Ux2knNMS6_GeW487L7C-E0', 1586605927),
(7213, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg2NjEwMDQ4LCJleHAiOjE1ODY2MTE4NDgsInBlcm1pc3Npb24iOiIifQ.Xh_31SEKXkK7XeZVuHc8UFa_iyd0CVHxSSeB4AIf2Vc', 1586611848),
(7219, 2036, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM2IiwidXNlcm1haWwiOiJkaW9nb21mc2lsdmE5OEB1YS5wdCIsImlhdCI6MTU4NjYxNjMzMSwiZXhwIjoxNTg2NjE4MTMxLCJwZXJtaXNzaW9uIjoiIn0.184t2VCLH_wSLr-bbc3hvSvnNqFP3PSBvDp9LMl7w9w', 1586618131),
(7222, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg2NjE2Njc2LCJleHAiOjE1ODY2MTg0NzYsInBlcm1pc3Npb24iOiIifQ.Y69Qqel8Ly-aq674nYJ71S_tROxr69y8RmNPzBiWXx4', 1586618476),
(7228, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTg2NjI2ODM0LCJleHAiOjE1ODY2Mjg2MzQsInBlcm1pc3Npb24iOiIifQ.DTL9B5fAzv5VAHwu8BfJ0CaW6FciHcbi1x4rfVSmV-U', 1586628634),
(7231, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1ODY2MzA1MDEsImV4cCI6MTU4NjYzMjMwMSwicGVybWlzc2lvbiI6IiJ9.62gRkoCFQL8a4ST9QA1oRhEF4siojboQPv2baz6_Yhg', 1586632301),
(7234, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1ODY2MzE1ODEsImV4cCI6MTU4NjYzMzM4MSwicGVybWlzc2lvbiI6IiJ9.PSonhk9E6YJNECkilIwFMpQjnmE2qSuIhPShnXHu1ao', 1586633381),
(7240, 1611, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjExIiwidXNlcm1haWwiOiJtYXJpYW5hc3BzQHVhLnB0IiwiaWF0IjoxNTg2NjM4ODEyLCJleHAiOjE1ODY2NDA2MTIsInBlcm1pc3Npb24iOiIifQ._NWYp8a8yowGefDm0-LvT1f-k82uxOoXaqOCMQfU6jE', 1586640612),
(7243, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU4NjY0MDUyMCwiZXhwIjoxNTg2NjQyMzIwLCJwZXJtaXNzaW9uIjoiIn0.k2va80bkMlJuL8ezcqMpTM7CMKTEn3WGReSKa9x5-FA', 1586642320),
(7246, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1ODY2NDMyNjMsImV4cCI6MTU4NjY0NTA2MywicGVybWlzc2lvbiI6IiJ9.T72yJ3LDZlgyh5yzeut8YUOjl55_-BoISXuulswqZgc', 1586645063),
(7249, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODY2NDM4NTgsImV4cCI6MTU4NjY0NTY1OCwicGVybWlzc2lvbiI6IiJ9.fDwuuwNYHhoguTuWCavlymCw6f36e-Wrd3xyYrG6YZU', 1586645658),
(7255, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODY2OTQwNzgsImV4cCI6MTU4NjY5NTg3OCwicGVybWlzc2lvbiI6IiJ9.1B487cZzBgs3BJaBIgQXV2kfoAAEblfY99lyvkWBvbA', 1586695878),
(7258, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU4NjY5Njc2NywiZXhwIjoxNTg2Njk4NTY3LCJwZXJtaXNzaW9uIjoiIn0._wKPHUWKGKxmlPsHLum4vpnBPif3iNLojBYMFyQGS6s', 1586698567),
(7264, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg2NzEwMDAxLCJleHAiOjE1ODY3MTE4MDEsInBlcm1pc3Npb24iOiIifQ.BJCTMxVfvL1P3HhBsw7xJcpwYiieokoV1fFXC_EL55E', 1586711801),
(7270, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg2NzE0OTc3LCJleHAiOjE1ODY3MTY3NzcsInBlcm1pc3Npb24iOiIifQ.Yw8NKBvxgWtx48eNAc7vXUY4Pa6ERfc42eI7ko1_0aE', 1586716777),
(7273, 2074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc0IiwidXNlcm1haWwiOiJ2aWNlbnRlLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTg2NzE1OTQ3LCJleHAiOjE1ODY3MTc3NDcsInBlcm1pc3Npb24iOiIifQ.awYRhJwi3FOTwUMxoa-VRO9VivN23lp67a90-7Adk-M', 1586717747),
(7279, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg2ODAwNTAwLCJleHAiOjE1ODY4MDIzMDAsInBlcm1pc3Npb24iOiIifQ.Nq22wY-pLyBJSoIWzvCsOmsqYg5-pOXuh-lro6k3IQY', 1586802300),
(7282, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg2ODAwODg5LCJleHAiOjE1ODY4MDI2ODksInBlcm1pc3Npb24iOiIifQ.4A2ZMrxghCzVnqYhFpGPmwWGD7uZLhXgzzC5cVidPmk', 1586802689),
(7285, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU4NjgwMTYzMywiZXhwIjoxNTg2ODAzNDMzLCJwZXJtaXNzaW9uIjoiIn0.o9HSJvRzFh2kSePqa8sDxMGMRZTTAEN-A5CwKEPgGMw', 1586803433),
(7291, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU4NjgxMTUwOCwiZXhwIjoxNTg2ODEzMzA4LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.GTp0dS4k6v6MwFl22x8hMgyCqD0oFyjaR_0gowPxvdY', 1586813308),
(7297, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODY4MTQ3NDIsImV4cCI6MTU4NjgxNjU0MiwicGVybWlzc2lvbiI6IiJ9.80XRoqP-4dHTYVuiLxoHS_j5S_2-AjUIXT7wzbi5vBI', 1586816542),
(7303, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODY4NTcyNjYsImV4cCI6MTU4Njg1OTA2NiwicGVybWlzc2lvbiI6IiJ9.zRfzbTzIpVstsr-6_givcommf4yZyWUbwNUJHbb93-k', 1586859066),
(7306, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4Njg1ODQwMSwiZXhwIjoxNTg2ODYwMjAxLCJwZXJtaXNzaW9uIjoiIn0.GE0hLOudfj330XpCUlKEhPyiQS1YmJZZ-titdqYam5Q', 1586860201),
(7312, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTg2ODcxODk4LCJleHAiOjE1ODY4NzM2OTgsInBlcm1pc3Npb24iOiIifQ.3jPKqcneralxdmuPO3H_q7VHJpHi39IethsgcumsBDk', 1586873698),
(7318, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTg2ODc2NzgzLCJleHAiOjE1ODY4Nzg1ODMsInBlcm1pc3Npb24iOiIifQ.KeOURmWn_h1lIbu_kFrPtrUEqrek2lylywI-WOMVYG0', 1586878583),
(7324, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTg2ODgzNTcwLCJleHAiOjE1ODY4ODUzNzAsInBlcm1pc3Npb24iOiIifQ.P7kjhV_FgJyGmMadBXMVrNoz-dS0zUCLUKUwhd75Idg', 1586885370),
(7330, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg2OTEyNDA1LCJleHAiOjE1ODY5MTQyMDUsInBlcm1pc3Npb24iOiIifQ.yqtj8BFfU1yVW6utyRZGfHgWJPslDfQEcHNGkx7wCFI', 1586914205),
(7336, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU4Njk2MDM5MiwiZXhwIjoxNTg2OTYyMTkyLCJwZXJtaXNzaW9uIjoiIn0.YOOzgTlTazVv4oBP76WCGAEuSpBvyGEFjuXV-czPmgw', 1586962192),
(7342, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTg2OTY2MzE2LCJleHAiOjE1ODY5NjgxMTYsInBlcm1pc3Npb24iOiIifQ.M5odOL8ZjgHX4AQF10Y3Yjl1lMhA03xJnuff7aMOyos', 1586968116),
(7345, 1461, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDYxIiwidXNlcm1haWwiOiJqb2FvdHNAdWEucHQiLCJpYXQiOjE1ODY5Njc1NDEsImV4cCI6MTU4Njk2OTM0MSwicGVybWlzc2lvbiI6IiJ9.WueutJZtGLhQrv8uUFom7er5_G4SCnz6Wr4RAu9xQhk', 1586969341),
(7351, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTg2OTgxOTM4LCJleHAiOjE1ODY5ODM3MzgsInBlcm1pc3Npb24iOiIifQ.RWtPeNPfsGavV8Mn_xc0bc6xhtAxoTZRHDuW5-KgVGo', 1586983738),
(7354, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg2OTg0NzY2LCJleHAiOjE1ODY5ODY1NjYsInBlcm1pc3Npb24iOiIifQ.kxpEb_6TsQEYtnT5UQIBle3HyDWoKQdSuppoSkeF_08', 1586986566),
(7360, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODcwNDU5MDMsImV4cCI6MTU4NzA0NzcwMywicGVybWlzc2lvbiI6IiJ9.hu_0r5CL_82EgtjOaojW2bmxAjDY0TkyMtSaICQxvUs', 1587047703),
(7363, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODcwNDc4OTAsImV4cCI6MTU4NzA0OTY5MCwicGVybWlzc2lvbiI6IiJ9.pzAm6aMBS5gxIhncoO7TRq-Cm-J4V6eGmzU2KqH0c-g', 1587049690),
(7369, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1ODcwNTIzMzcsImV4cCI6MTU4NzA1NDEzNywicGVybWlzc2lvbiI6IiJ9.Sc4_tPwuXou14mlxxFs60UDVXYyqMn5MJyLeTu6nOjQ', 1587054137),
(7375, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1ODcwNjQ2MzYsImV4cCI6MTU4NzA2NjQzNiwicGVybWlzc2lvbiI6IiJ9.F9JoCmsZyEx_linvvZvq7y_o-dWjWYwIdCqAB8dbbEo', 1587066436),
(7381, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTg3MTE5MjQwLCJleHAiOjE1ODcxMjEwNDAsInBlcm1pc3Npb24iOiIifQ.Cxcv3aV0xcRtuco1bBzEMvn0gVD_EezL8pwoSihGrY8', 1587121040),
(7384, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODcxMTk2MDAsImV4cCI6MTU4NzEyMTQwMCwicGVybWlzc2lvbiI6IiJ9.EvRU7LJlv4Z4Ns9Lhf3pdd85w3RM6LfFr7HZlTayfjo', 1587121400),
(7390, 1182, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTgyIiwidXNlcm1haWwiOiJkdWFydGUubnRtQHVhLnB0IiwiaWF0IjoxNTg3MTM1ODYwLCJleHAiOjE1ODcxMzc2NjAsInBlcm1pc3Npb24iOiIifQ.Ooe9MBkMr7T7w-Fejt9iO-uSW1yhXWQGEXRTFmlV9vI', 1587137660),
(7396, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU4NzEzOTM4NCwiZXhwIjoxNTg3MTQxMTg0LCJwZXJtaXNzaW9uIjoiIn0.xh9STor5OpDLkx9kkskkv3FjbNb0yoL89hm4s9oAQMc', 1587141184),
(7402, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTg3MTQyNzE3LCJleHAiOjE1ODcxNDQ1MTcsInBlcm1pc3Npb24iOiIifQ.wtJknoV0sDfjhOOffuX4YdN14FVILGOktQWXbqOOT7k', 1587144517),
(7408, 2055, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU1IiwidXNlcm1haWwiOiJtaWd1ZWwuci5mZXJyZWlyYUB1YS5wdCIsImlhdCI6MTU4NzE2OTk0NiwiZXhwIjoxNTg3MTcxNzQ2LCJwZXJtaXNzaW9uIjoiIn0.cw20FrSO_8Y9tfvQxsAlUbtZo5s9wcvgD2pqdYTXnn8', 1587171746),
(7414, 1113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTEzIiwidXNlcm1haWwiOiJkYXZpZG1vcmFpczM1QHVhLnB0IiwiaWF0IjoxNTg3MjAwMjU1LCJleHAiOjE1ODcyMDIwNTUsInBlcm1pc3Npb24iOiIifQ.-IMhAcQHgjszIxJidf0-BHxhk0Wh1lKy0n-qmyfAlOI', 1587202055),
(7420, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg3MjMwMDMyLCJleHAiOjE1ODcyMzE4MzIsInBlcm1pc3Npb24iOiIifQ.1srKLZz38XyFEy14qzE7gCu5RVCz3jVpY22K9SbfHn0', 1587231832),
(7426, 1794, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzk0IiwidXNlcm1haWwiOiJyLm1lbG9AdWEucHQiLCJpYXQiOjE1ODcyMzQ5MjQsImV4cCI6MTU4NzIzNjcyNCwicGVybWlzc2lvbiI6IiJ9.wA2iD6MMX7wb0GOB5m2HOHHRN5_NWhGMTEReeuCvK2I', 1587236724),
(7435, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1ODcyNDY5MzUsImV4cCI6MTU4NzI0ODczNSwicGVybWlzc2lvbiI6IiJ9.DiKfm3bpe1qXcmXmpXrnXDClORe0Zmr9pzObwbL_Bs8', 1587248735),
(7441, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4NzI5MDA3NywiZXhwIjoxNTg3MjkxODc3LCJwZXJtaXNzaW9uIjoiIn0.37NsZKQtUGJKUlr72H6_69Ij-db7useajHJWpIJ32q0', 1587291877),
(7447, 1350, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzUwIiwidXNlcm1haWwiOiJpc2Fkb3JhLmZsQHVhLnB0IiwiaWF0IjoxNTg3MzI4MTExLCJleHAiOjE1ODczMjk5MTEsInBlcm1pc3Npb24iOiIifQ.Mafsrrp5uZCbANFmsUHFVkxaiey5nhV9AqJ-va-iiHU', 1587329911),
(7453, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1ODczNjI5NzAsImV4cCI6MTU4NzM2NDc3MCwicGVybWlzc2lvbiI6IiJ9.zu_1GqD12XVcEg97KgEkAFizqwxaUZRK31Iz14LiLQQ', 1587364770),
(7459, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTg3Mzc4MzM4LCJleHAiOjE1ODczODAxMzgsInBlcm1pc3Npb24iOiIifQ._vouKqFT882JFWAhTksE3sHVzTlj0Ex4Yl3j-USDcXg', 1587380138),
(7465, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg3Mzk4NTE1LCJleHAiOjE1ODc0MDAzMTUsInBlcm1pc3Npb24iOiIifQ.XYfH5E6Wn9CKcqCS12ruxjWoq8anYhdGPf2VBlknU8g', 1587400315),
(7471, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg3NDA3NTIzLCJleHAiOjE1ODc0MDkzMjMsInBlcm1pc3Npb24iOiIifQ.G1ETHaP0KbjFP6QD0OPg47aF399Cm106QoC5ugox75c', 1587409323),
(7477, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU4NzQxMzg2NiwiZXhwIjoxNTg3NDE1NjY2LCJwZXJtaXNzaW9uIjoiIn0.3sz4pcA-U3E-IQ1SLLduU6hMLz2X5GWzGebi_ajcV5U', 1587415666),
(7483, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1ODc0MjE4NDIsImV4cCI6MTU4NzQyMzY0MiwicGVybWlzc2lvbiI6IiJ9.vRgaD0ouyD659TRwIvaQphksuR4ZA3lqhjg-e53iyBo', 1587423642),
(7492, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODc0NjY5NzYsImV4cCI6MTU4NzQ2ODc3NiwicGVybWlzc2lvbiI6IiJ9.39hha9QhOopp25FiJz-_6PB8-vFDyanFFJgXn_PO0cY', 1587468776),
(7507, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTg3NDc4MDgxLCJleHAiOjE1ODc0Nzk4ODEsInBlcm1pc3Npb24iOiIifQ.wrKq6s7TykIRexFxjRgM17SQ0MrbjfRhZf-_O97GQrM', 1587479881),
(7519, 2123, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTIzIiwidXNlcm1haWwiOiJyaXRhZmVycm9saG9AdWEucHQiLCJpYXQiOjE1ODc0Nzg5MjcsImV4cCI6MTU4NzQ4MDcyNywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.8OrAY9cyKwLtot0FY4gXmNnLlBIdX9eqHd7cdLmLvyk', 1587480727),
(7525, 2123, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTIzIiwidXNlcm1haWwiOiJyaXRhZmVycm9saG9AdWEucHQiLCJpYXQiOjE1ODc0ODgxMjYsImV4cCI6MTU4NzQ4OTkyNiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.5eYzi4qRjYoZN38eSC5o4YO9UCvzWzhlvl5ctV1L4Hk', 1587489926),
(7531, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODc0OTM0MTEsImV4cCI6MTU4NzQ5NTIxMSwicGVybWlzc2lvbiI6IiJ9.pKvGffaqbsr3yjXe3Pbmz6yxhhIRFdkStwbOwI37SoQ', 1587495211),
(7537, 2057, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU3IiwidXNlcm1haWwiOiJwbWQ4QHVhLnB0IiwiaWF0IjoxNTg3NTAwMzgxLCJleHAiOjE1ODc1MDIxODEsInBlcm1pc3Npb24iOiIifQ.gd9OdlaU1TLcXMYMDiSPFRvvAoH7QiZXEaGL2v5bkxU', 1587502181),
(7540, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODc1MDEzNTIsImV4cCI6MTU4NzUwMzE1MiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.LnA6MO4Wfq4jUzTxUoliS9mKJ04Z9BBu9rDSy8CbweM', 1587503152),
(7546, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTg3NTQyODAzLCJleHAiOjE1ODc1NDQ2MDMsInBlcm1pc3Npb24iOiIifQ.J5U9c_HzdPNTTA_yPwYWYyOtYM0bfAjJYkbUZaxvtDM', 1587544603),
(7552, 1506, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTA2IiwidXNlcm1haWwiOiJqcGVkcm9nb25jYWx2ZXNAdWEucHQiLCJpYXQiOjE1ODc1NTAxMzYsImV4cCI6MTU4NzU1MTkzNiwicGVybWlzc2lvbiI6IiJ9.wGouV1sNaGqlUhZaalyQA2GUdOmPl8CoEERLMdTnTgQ', 1587551936),
(7558, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODc1NTg5ODUsImV4cCI6MTU4NzU2MDc4NSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.dF3laeRSVnBOk7fmjiS0g0EESxjwdBP6sZDkvlz_SmE', 1587560785),
(7564, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg3NTcxNjg4LCJleHAiOjE1ODc1NzM0ODgsInBlcm1pc3Npb24iOiIifQ.gK2Tp8MNM3p79N_TNHclOxit9yCagH434vt-6j0cOKg', 1587573488),
(7567, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODc1NzIwNDAsImV4cCI6MTU4NzU3Mzg0MCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.mmBC1Bq3B2YHprT0TWB0_7QJOZzlMNddauXzu--jW0M', 1587573840),
(7570, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg3NTczNjQ3LCJleHAiOjE1ODc1NzU0NDcsInBlcm1pc3Npb24iOiIifQ.zc7-YRFOaCTRSuPJkkje_-GLjMhQPbt0MnGE6KnD5Y4', 1587575447),
(7576, 1755, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzU1IiwidXNlcm1haWwiOiJwZWRyb2xvcGVzbWF0b3NAdWEucHQiLCJpYXQiOjE1ODc1OTAwMTUsImV4cCI6MTU4NzU5MTgxNSwicGVybWlzc2lvbiI6IiJ9.6EcFPRHcIR0lzsvG4E8onntKCFut7rpYgM1C-1scmqg', 1587591815),
(7582, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4NzYzMDk0MywiZXhwIjoxNTg3NjMyNzQzLCJwZXJtaXNzaW9uIjoiIn0.tpZDMKXnqpRZsxb0sbZhQ89Nhedtf6KmY0FwqSFf1YQ', 1587632743),
(7588, 2123, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTIzIiwidXNlcm1haWwiOiJyaXRhZmVycm9saG9AdWEucHQiLCJpYXQiOjE1ODc2Mzg1NzgsImV4cCI6MTU4NzY0MDM3OCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.LcVt6TtajIj0ZicVGxOmbLTs5KoSWotKM0u5QpnfKuM', 1587640378),
(7594, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU4NzY0NTcwMiwiZXhwIjoxNTg3NjQ3NTAyLCJwZXJtaXNzaW9uIjoiIn0.ErXoXfY31BKgm5dssQcjL3IBATO00Yx4Rkk-aDkp4jc', 1587647502),
(7600, 2026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI2IiwidXNlcm1haWwiOiJhcnR1ci5yb21hb0B1YS5wdCIsImlhdCI6MTU4NzY1MDQ0MCwiZXhwIjoxNTg3NjUyMjQwLCJwZXJtaXNzaW9uIjoiIn0.kQzIrBBy8kcVAhVlkmfo5kgoyZn9QmKVhiuvvo9MgR4', 1587652240),
(7603, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTg3NjUxMjg2LCJleHAiOjE1ODc2NTMwODYsInBlcm1pc3Npb24iOiIifQ.mDAnyrMznhGv3uQxA4bypcTVCWoLgw647PHGW-Nbvs4', 1587653086),
(7606, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4NzY1MjI2NiwiZXhwIjoxNTg3NjU0MDY2LCJwZXJtaXNzaW9uIjoiIn0.PP2YD1oNRlMVaQZpppZCZJkdz3SINbv5qob29mtOPMI', 1587654066),
(7609, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODc2NTMzNjksImV4cCI6MTU4NzY1NTE2OSwicGVybWlzc2lvbiI6IiJ9._-m1XUGRZhkYSc5VlzzknV3eu5owsy6MUauTDbSQ_w4', 1587655169),
(7615, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTg3NjU1NzYxLCJleHAiOjE1ODc2NTc1NjEsInBlcm1pc3Npb24iOiIifQ._PSrA407uG28grvDpOaRLg1BU9N9uGs0uuXjsL5J0hM', 1587657561),
(7621, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTg3Njc2MDE0LCJleHAiOjE1ODc2Nzc4MTQsInBlcm1pc3Npb24iOiIifQ.z7rhh30yoCrB5bQoH6uKXj-LX2j44XpxfIOvHbaHib4', 1587677814),
(7624, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTg3Njc4MDI5LCJleHAiOjE1ODc2Nzk4MjksInBlcm1pc3Npb24iOiIifQ.mh3I9QKX-HceByq7PO8Zr52kldiTB-72iIjqUJbrfBM', 1587679829),
(7627, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTg3Njc4MDM4LCJleHAiOjE1ODc2Nzk4MzgsInBlcm1pc3Npb24iOiIifQ.CLv31O1XeabQM8QpIB8eCcFSC30NThzrYDXg9BCOxTk', 1587679838),
(7633, 1425, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDI1IiwidXNlcm1haWwiOiJqb2FvbWFkaWFzQHVhLnB0IiwiaWF0IjoxNTg3NzE5OTAzLCJleHAiOjE1ODc3MjE3MDMsInBlcm1pc3Npb24iOiIifQ.-cLLfNrP5Y5DVBsSKKR5aBbkSbTJIqekXsi8uXOAHVI', 1587721703),
(7639, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTg3NzI4ODE2LCJleHAiOjE1ODc3MzA2MTYsInBlcm1pc3Npb24iOiIifQ.Q-KPN4tyaKeqWBSp4AVfVFTC6e_WCoJeQaljsf_QUbw', 1587730616),
(7645, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTg3NzQ0MTE1LCJleHAiOjE1ODc3NDU5MTUsInBlcm1pc3Npb24iOiIifQ.XyntXwCmfpjuSFubX3OgrmjyAOhSs6p-Y5M-fUSgvVE', 1587745915),
(7651, 1098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDk4IiwidXNlcm1haWwiOiJkYW5pZWx0ZWl4ZWlyYTMxQHVhLnB0IiwiaWF0IjoxNTg3NzU5NzIxLCJleHAiOjE1ODc3NjE1MjEsInBlcm1pc3Npb24iOiIifQ.qaO9H-LP9LLbkt9aNvDaym82CIAsO8AhEcfV3Pd410I', 1587761521),
(7657, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1ODc3Nzc3MDYsImV4cCI6MTU4Nzc3OTUwNiwicGVybWlzc2lvbiI6IiJ9.8_rbyCb6HA0xZXErRvyUsZffHdlkNHtiGXSf1zj2FlU', 1587779506),
(7663, 1341, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzQxIiwidXNlcm1haWwiOiJpbmVzLnBsQHVhLnB0IiwiaWF0IjoxNTg3ODE4NzQ4LCJleHAiOjE1ODc4MjA1NDgsInBlcm1pc3Npb24iOiIifQ.RHUgaH65KotMCtFPZH1yI7X1BuwLhHZvroAcA3ErzTg', 1587820548),
(7666, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU4NzgyMTAzOCwiZXhwIjoxNTg3ODIyODM4LCJwZXJtaXNzaW9uIjoiIn0.cBr4wQWvIaFrHOCFeTOsDEKrS8rHPn6gnyi17k3Lws0', 1587822838),
(7672, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTg3ODMwNTAwLCJleHAiOjE1ODc4MzIzMDAsInBlcm1pc3Npb24iOiIifQ.Yql3bFCAA3B0ZFCsdMCoCtqRP9LkMAfOuspysmjaS2I', 1587832300),
(7678, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU4Nzg1OTQ3MSwiZXhwIjoxNTg3ODYxMjcxLCJwZXJtaXNzaW9uIjoiIn0.S0U4xAz7bI0SojiLWXoR9XAaD7Dh_jzwGFv5YbErypg', 1587861271),
(7684, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU4NzkwOTM4MiwiZXhwIjoxNTg3OTExMTgyLCJwZXJtaXNzaW9uIjoiIn0.lst0I0eeoctbIf_sOBLGtrjq7fYBCQikZ_XsZFqMFOU', 1587911182),
(7690, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU4NzkyMjIxOSwiZXhwIjoxNTg3OTI0MDE5LCJwZXJtaXNzaW9uIjoiIn0.E9u9aL8CqNYxpA6qwaxarFOxWxPArnuOfbNQ9TcQw5I', 1587924019),
(7696, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU4NzkyODQyOCwiZXhwIjoxNTg3OTMwMjI4LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.aC24xfRitrRvQboEEl7_G8BuyGVHGwjbAlZKvekWkTg', 1587930228),
(7699, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODc5Mjg4MDYsImV4cCI6MTU4NzkzMDYwNiwicGVybWlzc2lvbiI6IiJ9.YG_dNMxKmsY3BDK0LmMiWex1-W-nh-NZKgySaE9Z1mE', 1587930606),
(7705, 2122, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTIyIiwidXNlcm1haWwiOiJ5YW5pc21hcmluYWZhcXVpckB1YS5wdCIsImlhdCI6MTU4NzkzNDM5NCwiZXhwIjoxNTg3OTM2MTk0LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.NTRsuRCY3lGjys6ctxOgXtHwygAS3vPBeJ5_m_vEvHk', 1587936194),
(7708, 2032, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMyIiwidXNlcm1haWwiOiJkZGlhc0B1YS5wdCIsImlhdCI6MTU4NzkzNTE3MSwiZXhwIjoxNTg3OTM2OTcxLCJwZXJtaXNzaW9uIjoiIn0.jplLPnh4KeTBbLxc8ZH7InqfmjdcHrehzRnZ_GgZ6fM', 1587936971),
(7714, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1ODc5ODAyODgsImV4cCI6MTU4Nzk4MjA4OCwicGVybWlzc2lvbiI6IiJ9.f_3vxNDNloR7qse2fiQdxGQ-pyFOu91gs5VRB0ssdPk', 1587982088),
(7720, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU4Nzk5NTIyMywiZXhwIjoxNTg3OTk3MDIzLCJwZXJtaXNzaW9uIjoiIn0.lDDW8mEzjnXfeJSyFcNZBVh4OlNx4a4K7AwKSb_CbPY', 1587997023),
(7723, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1ODc5OTYwNzksImV4cCI6MTU4Nzk5Nzg3OSwicGVybWlzc2lvbiI6IiJ9.5Gzduw31_TqM-jJJcjZERFaWPO3H5MJ8ZPNrLO0OLTE', 1587997879),
(7726, 1074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc0IiwidXNlcm1haWwiOiJkYWdvbWVzQHVhLnB0IiwiaWF0IjoxNTg3OTk2MjA4LCJleHAiOjE1ODc5OTgwMDgsInBlcm1pc3Npb24iOiIifQ.EdT8bhvQZ82lXHSvDo95AwH57xKn-6AdgQpEGLPr418', 1587998008),
(7732, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU4Nzk5ODg3NCwiZXhwIjoxNTg4MDAwNjc0LCJwZXJtaXNzaW9uIjoiIn0.EvaA4fUXcz5XTifsAGUOvko-8IkEFyrHlkAEQfvvwBI', 1588000674),
(7735, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1ODc5OTg5MTYsImV4cCI6MTU4ODAwMDcxNiwicGVybWlzc2lvbiI6IiJ9.DnZdiRMuKViUDm3eAvy1L_17Jo8977QlTABywRTPPTM', 1588000716);
INSERT INTO `GenTokens` (`id`, `userid`, `token`, `expire_date`) VALUES
(7741, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODgwMDQzMDksImV4cCI6MTU4ODAwNjEwOSwicGVybWlzc2lvbiI6IiJ9.yaJc9LifPQDA-T1vOsKB_WkqIe0boXu_zvv_7Q8hCxY', 1588006109),
(7744, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTg4MDA2MzM0LCJleHAiOjE1ODgwMDgxMzQsInBlcm1pc3Npb24iOiIifQ.Hoclr1MFX0ufbntl1Njcjrn8Zan1xK-fBTjGxt5G7dI', 1588008134),
(7750, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1ODgwMTIzMzMsImV4cCI6MTU4ODAxNDEzMywicGVybWlzc2lvbiI6IiJ9.PCaX6uevvgDXD9A5u-bV192wi6Z5RgV43SA4_tn0w1s', 1588014133),
(7756, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU4ODAyNzczOSwiZXhwIjoxNTg4MDI5NTM5LCJwZXJtaXNzaW9uIjoiIn0.lqC0sSUcD0h4di7ZkHy_cZ8I9F_rPZCglGkFxD-IhnA', 1588029539),
(7762, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODgwNjkxNjYsImV4cCI6MTU4ODA3MDk2NiwicGVybWlzc2lvbiI6IiJ9.Swli3bGCgJBQlFrJ-F5raKtjJIyM8enn_q5v6szlhn8', 1588070966),
(7768, 1077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc3IiwidXNlcm1haWwiOiJkYW5pZWwuY291dG9AdWEucHQgIiwiaWF0IjoxNTg4MDgyMjkyLCJleHAiOjE1ODgwODQwOTIsInBlcm1pc3Npb24iOiIifQ.p7JBibxTXrNx9thAgnPo_4MO3KwRVUEm2zvoO3iTwOU', 1588084092),
(7771, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg4MDgzNDY5LCJleHAiOjE1ODgwODUyNjksInBlcm1pc3Npb24iOiIifQ.MPotj_KimuYD2h6ltroPyJFyRJYhLXnA8uQ_HUFfeB8', 1588085269),
(7774, 1173, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTczIiwidXNlcm1haWwiOiJkbWF0aWFzcGludG9AdWEucHQiLCJpYXQiOjE1ODgwODM3MjEsImV4cCI6MTU4ODA4NTUyMSwicGVybWlzc2lvbiI6IiJ9.UUegZloFLvIt7OPx8wgULFC5xv9f_yRH5BhbyhCGyE0', 1588085521),
(7777, 1077, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDc3IiwidXNlcm1haWwiOiJkYW5pZWwuY291dG9AdWEucHQgIiwiaWF0IjoxNTg4MDg0NjYzLCJleHAiOjE1ODgwODY0NjMsInBlcm1pc3Npb24iOiIifQ.VTwKqxScFnymKAwJFsJ94i6ZxfbozcfcBGfk0pMhAv0', 1588086463),
(7780, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODgwODU3NzYsImV4cCI6MTU4ODA4NzU3NiwicGVybWlzc2lvbiI6IiJ9.y1NzSZCaYhT4bzit9rHNISwXl99EuRKDTSts-CCweJQ', 1588087576),
(7786, 1806, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA2IiwidXNlcm1haWwiOiJyYWZhZWxndGVpeGVpcmFAdWEucHQiLCJpYXQiOjE1ODgwOTM0MjUsImV4cCI6MTU4ODA5NTIyNSwicGVybWlzc2lvbiI6IiJ9.Ga-fhrTDZMxMni5-urMVdRcWL9TfH1XXyIdRhsws1E0', 1588095225),
(7792, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1ODgwOTk2NDMsImV4cCI6MTU4ODEwMTQ0MywicGVybWlzc2lvbiI6IiJ9.O1_WuBZdpYge7U-2CWZoENHwQTIPV8kC6HjZIqWciyQ', 1588101443),
(7795, 1806, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODA2IiwidXNlcm1haWwiOiJyYWZhZWxndGVpeGVpcmFAdWEucHQiLCJpYXQiOjE1ODgxMDE1ODksImV4cCI6MTU4ODEwMzM4OSwicGVybWlzc2lvbiI6IiJ9.VRIoA_pV7W8BeuyoDeAagl_NabiL3wgTvTZsKsC2CXY', 1588103389),
(7798, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU4ODEwMTY4OSwiZXhwIjoxNTg4MTAzNDg5LCJwZXJtaXNzaW9uIjoiIn0.xLMd7G8DNoOZeCUPlyoNRSA3Dzu0f-jIWBWtPK4cBaY', 1588103489),
(7801, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTg4MTA0MzMyLCJleHAiOjE1ODgxMDYxMzIsInBlcm1pc3Npb24iOiIifQ.gih0equMr7Angwk-Ue4AUI2FIO4c9BSN7oRi6Zz5iEo', 1588106132),
(7807, 1821, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODIxIiwidXNlcm1haWwiOiJyZm1mQHVhLnB0IiwiaWF0IjoxNTg4MTA5MjAwLCJleHAiOjE1ODgxMTEwMDAsInBlcm1pc3Npb24iOiIifQ.Ui3V_kVRg2DvXPqoRtec7HjeuIgM95sh69rjrxxnsUc', 1588111000),
(7813, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODgxMTMxNjYsImV4cCI6MTU4ODExNDk2NiwicGVybWlzc2lvbiI6IiJ9.JI-t2rfziBZlSE6LMctLtTCuDBbDnr9lWqaikWwXWtk', 1588114966),
(7819, 999, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI5OTkiLCJ1c2VybWFpbCI6ImNhbWlsYXVhY2hhdmVAdWEucHQiLCJpYXQiOjE1ODgxNjk4MDMsImV4cCI6MTU4ODE3MTYwMywicGVybWlzc2lvbiI6IiJ9.SBsb8DKV6a9lOfnT72BhU0HrkW5TuHc2yWwNG8WuyFU', 1588171603),
(7825, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODgxODM1ODYsImV4cCI6MTU4ODE4NTM4NiwicGVybWlzc2lvbiI6IiJ9.F97y080AXJTRVAFczOICFF_DUap01x43tQeDjjQp2kQ', 1588185386),
(7831, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4ODIzNTk0MSwiZXhwIjoxNTg4MjM3NzQxLCJwZXJtaXNzaW9uIjoiIn0.utUD0fpnlhstN_glVkO_Eibf9sS_56HVSu8al2D-Wi4', 1588237741),
(7837, 1803, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODAzIiwidXNlcm1haWwiOiJyYWZhZWxiYXB0aXN0YUB1YS5wdCIsImlhdCI6MTU4ODI1NTUyOCwiZXhwIjoxNTg4MjU3MzI4LCJwZXJtaXNzaW9uIjoiIn0.E6ThhIZPKCIOXbFOeJqIsp6ZOOSYfmnBHO_K4SIo4Iw', 1588257328),
(7843, 2052, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUyIiwidXNlcm1haWwiOiJtYXJ0YWZyYWRpcXVlQHVhLnB0IiwiaWF0IjoxNTg4MjU5MTAxLCJleHAiOjE1ODgyNjA5MDEsInBlcm1pc3Npb24iOiIifQ.gfhvY7fhEsOcvcmKILHXnI9S7VhN7fgKEAUSt2_hZ4Y', 1588260901),
(7849, 1452, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNDUyIiwidXNlcm1haWwiOiJqb2Fvc2lsdmE5QHVhLnB0IiwiaWF0IjoxNTg4MzY3ODU1LCJleHAiOjE1ODgzNjk2NTUsInBlcm1pc3Npb24iOiIifQ.PdHwbgnBBBLdVigPjl_Dn49VoqAI2eFq7dv_VUM5AHQ', 1588369655),
(7852, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU4ODM2Nzg3MywiZXhwIjoxNTg4MzY5NjczLCJwZXJtaXNzaW9uIjoiIn0.zB9C9MX2Qt5ywhebV4MMjkdAnGqYFxx0g7zzIqR2NPg', 1588369673),
(7855, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTg4MzY3ODgxLCJleHAiOjE1ODgzNjk2ODEsInBlcm1pc3Npb24iOiIifQ.CflJL5jrGrwULI5zO8kpyMgHDiN6XR8vGjZlAMp5Nf8', 1588369681),
(7861, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1ODg0MjUxNjgsImV4cCI6MTU4ODQyNjk2OCwicGVybWlzc2lvbiI6IiJ9.C8gYn8O_64tIC4IIW1035jIiQnV6fnqUzazD8dK3FAY', 1588426968),
(7864, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTg4NDI4MjcxLCJleHAiOjE1ODg0MzAwNzEsInBlcm1pc3Npb24iOiIifQ.RHlJSYIJebi2hmv3OUPcidUfSqotyPOxaPCHRyFPBPg', 1588430071),
(7870, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTg4NDM1OTczLCJleHAiOjE1ODg0Mzc3NzMsInBlcm1pc3Npb24iOiIifQ.JRvF-eLcgmXPklBZ_9aHuO09cs_N1B-cuJdm5VPAlQM', 1588437773),
(7876, 1755, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzU1IiwidXNlcm1haWwiOiJwZWRyb2xvcGVzbWF0b3NAdWEucHQiLCJpYXQiOjE1ODg0NTkwNjcsImV4cCI6MTU4ODQ2MDg2NywicGVybWlzc2lvbiI6IiJ9.S6G0epoqy1Gsf0U_8PL5r4epaopf82vHVxRAcntQjy8', 1588460867),
(7879, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTg4NDU5MTc1LCJleHAiOjE1ODg0NjA5NzUsInBlcm1pc3Npb24iOiIifQ.QD_bv1Vo_s8UoLUWDTxFpQ2yK2uFUYrp4R1pzm2H7G0', 1588460975),
(7885, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU4ODUyNDg5MiwiZXhwIjoxNTg4NTI2NjkyLCJwZXJtaXNzaW9uIjoiIn0.h3uBqIcZXibhlGpu6oyH0i_tEuy5VuQoMFlgFLQX5wc', 1588526692),
(7891, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4ODU4MDc2MywiZXhwIjoxNTg4NTgyNTYzLCJwZXJtaXNzaW9uIjoiIn0.AVRX1KYXiqe8f34yhR8ovANVEuz0qQNfkt8_agWmuCE', 1588582563),
(7894, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4ODU4MDc2OSwiZXhwIjoxNTg4NTgyNTY5LCJwZXJtaXNzaW9uIjoiIn0.ixK744wvc8gcxSWwwC9-2pcUenCUpbl7gWCfIcd4xQw', 1588582569),
(7900, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4ODU4ODUxMiwiZXhwIjoxNTg4NTkwMzEyLCJwZXJtaXNzaW9uIjoiIn0.dsXpRjlTpofJtweX0bRew6bg5xbGmIU6XjSS6oEY-e4', 1588590312),
(7906, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4ODU5OTk5MCwiZXhwIjoxNTg4NjAxNzkwLCJwZXJtaXNzaW9uIjoiIn0.ZYFc0AbkQUki6JBiW2EJSMqsMP4_s4lnDx-XFoWiOgQ', 1588601790),
(7912, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg4NjA3OTYwLCJleHAiOjE1ODg2MDk3NjAsInBlcm1pc3Npb24iOiIifQ.6uf3pHZEvS6_lSPJ3aoqZcqU-9LrbdgGhiX7hWgOM-g', 1588609760),
(7918, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU4ODYyNzU0MiwiZXhwIjoxNTg4NjI5MzQyLCJwZXJtaXNzaW9uIjoiIn0.LIp_izfXisf3nzROyvMMre3v2XAZ-yMvchRlr1110xI', 1588629342),
(7924, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTg4NjQxNjg3LCJleHAiOjE1ODg2NDM0ODcsInBlcm1pc3Npb24iOiIifQ.yP1hVkghDvhZm8kMk3Fz3vwtUO2xgCnpAP9Rgx8UjsI', 1588643487),
(7930, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4ODY3Mjk0OCwiZXhwIjoxNTg4Njc0NzQ4LCJwZXJtaXNzaW9uIjoiIn0.StELYHN_cFgvn6-p0hFf1vtUhGXBqtqRkm050TUAROE', 1588674748),
(7933, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTg4Njc0NTQ1LCJleHAiOjE1ODg2NzYzNDUsInBlcm1pc3Npb24iOiIifQ.-l7TIJ9KNwn07LN_gd6ueKeYJQRUsEFgkBaeSFlT4R8', 1588676345),
(7939, 2064, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY0IiwidXNlcm1haWwiOiJwZWRyby5zaW1hbzEwQHVhLnB0IiwiaWF0IjoxNTg4Njc2OTAxLCJleHAiOjE1ODg2Nzg3MDEsInBlcm1pc3Npb24iOiIifQ.VurjzOWiJMDzYcw4gXLie2upvx-YGKaSbkZFpQHmEVw', 1588678701),
(7945, 2106, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA2IiwidXNlcm1haWwiOiJzb3BoaWVwb3VzaW5ob0B1YS5wdCIsImlhdCI6MTU4ODY5NDU3MywiZXhwIjoxNTg4Njk2MzczLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.o8PbNeylhJ5YpXVXpvsTnhOwZz6YyQ84IDVXYeu2mXE', 1588696373),
(7948, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODg2OTU2ODksImV4cCI6MTU4ODY5NzQ4OSwicGVybWlzc2lvbiI6IiJ9.Vu6-f5fotvcs3xvWG2s3DHO3YgMTthSgBrXoaQ4Q9RA', 1588697489),
(7949, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1ODg3MDM1NzgsImV4cCI6MTU4ODcwNTM3OCwicGVybWlzc2lvbiI6IiJ9.EMIGswK7fZbFu2e-nzmIL0JtTyjV7S45cfNQ2spkr6Q', 1588705378),
(7950, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTg4NzI4NDYxLCJleHAiOjE1ODg3MzAyNjEsInBlcm1pc3Npb24iOiIifQ.NP7uiXAntpz4SHIUSRhNLJugGO-HLbpfqOkCX3bsmmM', 1588730261),
(7951, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4ODc1MzU2MSwiZXhwIjoxNTg4NzU1MzYxLCJwZXJtaXNzaW9uIjoiIn0.ctU561j4UEhKw-IsmP2l99Nt0XtYBTivPGlaobzHHdY', 1588755361),
(7952, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODg3NTQwMTYsImV4cCI6MTU4ODc1NTgxNiwicGVybWlzc2lvbiI6IiJ9.qnxKI8RPc97gOMRRcQsGyDIaNkw9Adfxuel3vTV7Uag', 1588755816),
(7953, 2071, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcxIiwidXNlcm1haWwiOiJ0aWFnb21ybUB1YS5wdCIsImlhdCI6MTU4ODc1NjA1OSwiZXhwIjoxNTg4NzU3ODU5LCJwZXJtaXNzaW9uIjoiIn0.MGQeTlnoHEXieIQ4LC81ZqFZ3atO5RHrhHmKXBdx2VA', 1588757859),
(7954, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg4Nzc3NDY0LCJleHAiOjE1ODg3NzkyNjQsInBlcm1pc3Npb24iOiIifQ.zQG2U5ic3dNuZvMjvRrF2txhEEj0C8U0ep2K4g8EpXU', 1588779264),
(7955, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODg3ODE1MjMsImV4cCI6MTU4ODc4MzMyMywicGVybWlzc2lvbiI6IiJ9.TpApOpM4ZpBbSGPyHK0w-JTc8z0N0-bRvRhLuoATx3M', 1588783323),
(7956, 2020, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIwIiwidXNlcm1haWwiOiJhZm9uc28uYm90b0B1YS5wdCIsImlhdCI6MTU4ODgwMTg1OCwiZXhwIjoxNTg4ODAzNjU4LCJwZXJtaXNzaW9uIjoiIn0.SrGNDc4Iu5Xjv91QXUhRmk5fUtlkr5pVCGmfpoOAdhg', 1588803658),
(7958, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTg4ODYzNTMyLCJleHAiOjE1ODg4NjUzMzIsInBlcm1pc3Npb24iOiIifQ.PmleNEyIBdpeIKyGz7ZO-z3dejNiFLW_medUu2iCDPE', 1588865332),
(7964, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODg4NzExODUsImV4cCI6MTU4ODg3Mjk4NSwicGVybWlzc2lvbiI6IiJ9._9o6bjBsIhLH75uzuVbP3AyatzdkRTS9vqe8bavNKM8', 1588872985),
(7970, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1ODg4NzY4NDksImV4cCI6MTU4ODg3ODY0OSwicGVybWlzc2lvbiI6IiJ9.Ivyc5wNu-zR27mq9EzDUmEwRjk3DPnuxtNKZFKydWlg', 1588878649),
(7976, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTg4OTM0Mjg0LCJleHAiOjE1ODg5MzYwODQsInBlcm1pc3Npb24iOiIifQ.hXaGA8AJtmQvsduqzgFFRit8UxtVLt7Ze8pns_GT_r0', 1588936084),
(7988, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU4OTA0NjQ5MSwiZXhwIjoxNTg5MDQ4MjkxLCJwZXJtaXNzaW9uIjoiIn0.4n8pAFYzxtK7G4652rGwQQYKOR38DlKOwWP_0WTVuCo', 1589048291),
(7994, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODkwNzIyNzUsImV4cCI6MTU4OTA3NDA3NSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.8Wx903zeC2aHWLtlmp_8GEtKh4tWuIrKLKqgJimGNrk', 1589074075),
(8000, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU4OTEyNzA2NCwiZXhwIjoxNTg5MTI4ODY0LCJwZXJtaXNzaW9uIjoiIn0.kokGg5UeK1NMVaXMoc-iXY9sGaXDtDhxgWqtOwcmJGo', 1589128864),
(8006, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1ODkyMDU0MjQsImV4cCI6MTU4OTIwNzIyNCwicGVybWlzc2lvbiI6IiJ9._QQwXxRmYZQwveoxNvLpsrDK2AAVRVzWVdawjGTieQE', 1589207224),
(8012, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1ODkyMTgwNDQsImV4cCI6MTU4OTIxOTg0NCwicGVybWlzc2lvbiI6IiJ9.An9VZ3VU-YkxUxb3davIYVjQtYfmawWb0CcX1luQXmA', 1589219844),
(8018, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODkyNzgyMTQsImV4cCI6MTU4OTI4MDAxNCwicGVybWlzc2lvbiI6IiJ9.uS6grU1Ih26TFU9QME5INB3XbpM18OUnMNRZF3xnzyU', 1589280014),
(8024, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU4OTI4NDE4MiwiZXhwIjoxNTg5Mjg1OTgyLCJwZXJtaXNzaW9uIjoiIn0.Rhy9wbPwdWIUunFMI3BY80Li_6gWq1jQwfFcCCbXg8Q', 1589285982),
(8027, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU4OTI4NjcxNywiZXhwIjoxNTg5Mjg4NTE3LCJwZXJtaXNzaW9uIjoiIn0.P9SlhK4Jx8vgcH9epUS0EdLSjhLnr8WdE1--mv5bUfI', 1589288517),
(8033, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4OTI5MzExMiwiZXhwIjoxNTg5Mjk0OTEyLCJwZXJtaXNzaW9uIjoiIn0.BobFSXGpW25cImddqr3xN3tHHofq3_OLz4eQJI2UHIQ', 1589294912),
(8036, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODkyOTM4NzAsImV4cCI6MTU4OTI5NTY3MCwicGVybWlzc2lvbiI6IiJ9.3Ia4V6iyjUZQQrKzAT0rlLuhMHmLElhvvcKb8WpiADU', 1589295670),
(8039, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1ODkyOTQ2NTIsImV4cCI6MTU4OTI5NjQ1MiwicGVybWlzc2lvbiI6IiJ9.NDlPhXDX7hztpWaizMxsr2voddfspKL3ESXd0pZs7Wg', 1589296452),
(8045, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODkzNTcwNjMsImV4cCI6MTU4OTM1ODg2MywicGVybWlzc2lvbiI6IiJ9.YCYezdA967pQB4yyxE92j5x1hRmtuFTMM3HbrCmiiGk', 1589358863),
(8051, 1068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDY4IiwidXNlcm1haWwiOiJjcnV6ZGluaXNAdWEucHQiLCJpYXQiOjE1ODkzNjc2NDMsImV4cCI6MTU4OTM2OTQ0MywicGVybWlzc2lvbiI6IiJ9.BRyIeFxvwo3zZqDxknJqvUgzZb1HlWFT2ZDuLKuYB6g', 1589369443),
(8057, 870, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NzAiLCJ1c2VybWFpbCI6ImFsZXhhbmRyYWNhcnZhbGhvQHVhLnB0IiwiaWF0IjoxNTg5Mzc1ODUwLCJleHAiOjE1ODkzNzc2NTAsInBlcm1pc3Npb24iOiIifQ.L0pz09TF5iPwpM5nJtVNJSxDIdQmYCt5IPzE4Z52GMY', 1589377650),
(8063, 1638, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjM4IiwidXNlcm1haWwiOiJtZnM5OEB1YS5wdCIsImlhdCI6MTU4OTM3ODc3NywiZXhwIjoxNTg5MzgwNTc3LCJwZXJtaXNzaW9uIjoiIn0.bOI9E2owRaSX7vC8CzY3OrT_YOWooueXbchNuD5fhjs', 1589380577),
(8066, 1536, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTM2IiwidXNlcm1haWwiOiJsdWNhc2FxdWlsaW5vQHVhLnB0IiwiaWF0IjoxNTg5Mzc4ODE4LCJleHAiOjE1ODkzODA2MTgsInBlcm1pc3Npb24iOiIifQ.Gb9qCNruMs2n7_MBKL4sBbmtRU_6pCRiq_kkoOLOJTE', 1589380618),
(8072, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU4OTM4NjQzNCwiZXhwIjoxNTg5Mzg4MjM0LCJwZXJtaXNzaW9uIjoiIn0.BIEslGGktTWPq7IA_E2eh16wE9zrIUzxcrydgEvixCE', 1589388234),
(8078, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU4OTQxMDA3MiwiZXhwIjoxNTg5NDExODcyLCJwZXJtaXNzaW9uIjoiIn0.VK9s2hv23w6i5iPzNP-sRapcFzg7S2KicwCSvXB76Qo', 1589411872),
(8082, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1ODk0NjE1MTcsImV4cCI6MTU4OTQ2MzMxNywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.HIGkV3fY8onZv5gzVPPAtQXNNd8ZvIrC6Et2T4h275Y', 1589463317),
(8088, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTg5NDY0MTAzLCJleHAiOjE1ODk0NjU5MDMsInBlcm1pc3Npb24iOiIifQ.hPZkYdub44czf4vOaQ3YkqkoEdDpA7WC4e7FjdLwRu8', 1589465903),
(8094, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg5NDY3OTIzLCJleHAiOjE1ODk0Njk3MjMsInBlcm1pc3Npb24iOiIifQ.MxLhq3Qg0uimgcH0A7uZypT-bfS2Fi3iZWLMkegCs4A', 1589469723),
(8097, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg5NDY5NjI5LCJleHAiOjE1ODk0NzE0MjksInBlcm1pc3Npb24iOiIifQ.Y7yKqQTUhX3-F99wHJLIZT9cLCVgkvavqmVl6MhhEjA', 1589471429),
(8103, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTg5NDg5NjI2LCJleHAiOjE1ODk0OTE0MjYsInBlcm1pc3Npb24iOiIifQ.vA0uzCnBlhplBsn36vfznoK_SaZAZ2KtFa2oMAO_Lrw', 1589491426),
(8109, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1ODk1MzgwNTQsImV4cCI6MTU4OTUzOTg1NCwicGVybWlzc2lvbiI6IiJ9.CKPlWcVFrcaJz73IFBS1fMsitiW8qTVJYNJVfPvjfFk', 1589539854),
(8112, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTg5NTM4NzIxLCJleHAiOjE1ODk1NDA1MjEsInBlcm1pc3Npb24iOiIifQ.ndQ5305eqH-pG-pXSimJVTia0z_nbCzEZBxhOjx-IHs', 1589540521),
(8118, 2057, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU3IiwidXNlcm1haWwiOiJwbWQ4QHVhLnB0IiwiaWF0IjoxNTg5NTQ3NTk0LCJleHAiOjE1ODk1NDkzOTQsInBlcm1pc3Npb24iOiIifQ.PekowpjvQjP70sBmlP5rvVW5g3sFYSQd68vlzY5hRoY', 1589549394),
(8124, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODk1NTI2MDUsImV4cCI6MTU4OTU1NDQwNSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.i9PrkltW02wKdKXQNFSzzlrzeWqsB6HPShtRrP_9HTU', 1589554405),
(8130, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4OTYyNzIxNSwiZXhwIjoxNTg5NjI5MDE1LCJwZXJtaXNzaW9uIjoiIn0.OuP-h97ZtuW6qAKr9Y7WZOmsBSGclqVzHkXX3mE5uCE', 1589629015),
(8136, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTg5NjM2NjgwLCJleHAiOjE1ODk2Mzg0ODAsInBlcm1pc3Npb24iOiIifQ.IKvqjYrqwRUxLnI37VO9uJIjtcVGf4Hxi96IoKVS3cw', 1589638480),
(8139, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4OTYzOTg5MSwiZXhwIjoxNTg5NjQxNjkxLCJwZXJtaXNzaW9uIjoiIn0.gJsr6YdqHr6i55SPAW4w8IPMIFJBb6Oq6r7uRQdhLWk', 1589641691),
(8145, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTg5NjQ1ODI2LCJleHAiOjE1ODk2NDc2MjYsInBlcm1pc3Npb24iOiIifQ.JCccvjKCTz_BO37lAMOEtKQpOexBdehCmnynpt-_4_Q', 1589647626),
(8151, 2073, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDczIiwidXNlcm1haWwiOiJ2YXNjb3JlZ2FsMjRAdWEucHQiLCJpYXQiOjE1ODk2NTY2MTAsImV4cCI6MTU4OTY1ODQxMCwicGVybWlzc2lvbiI6IiJ9.bvHh3iis59HIHq7FwgQDtslkYUWnaMJqXDc7g86dK7o', 1589658410),
(8157, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1ODk2Nzg2NTUsImV4cCI6MTU4OTY4MDQ1NSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.i5CRTV4PZpq7tmfW4nHupiiCwrpIaCB2hR6B3rslo-g', 1589680455),
(8163, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1ODk3MjIxMTYsImV4cCI6MTU4OTcyMzkxNiwicGVybWlzc2lvbiI6IiJ9.-2yQ05ipSlXMstLo8upLR6cwnePnqxIn52OnmAsRLPw', 1589723916),
(8169, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTg5NzUyOTE1LCJleHAiOjE1ODk3NTQ3MTUsInBlcm1pc3Npb24iOiIifQ.Qxso7lZU0yIs8tf1tWPORFWbK2l2nu5l6fgRJYz1p-Q', 1589754715),
(8175, 1611, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjExIiwidXNlcm1haWwiOiJtYXJpYW5hc3BzQHVhLnB0IiwiaWF0IjoxNTg5NzYyMzkyLCJleHAiOjE1ODk3NjQxOTIsInBlcm1pc3Npb24iOiIifQ.8StjVU8YJ-YYBJTi4gPAgdlHfMzvRjTWyLEvBAszSxQ', 1589764192),
(8181, 870, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NzAiLCJ1c2VybWFpbCI6ImFsZXhhbmRyYWNhcnZhbGhvQHVhLnB0IiwiaWF0IjoxNTg5ODA3NjcxLCJleHAiOjE1ODk4MDk0NzEsInBlcm1pc3Npb24iOiIifQ.XDoWQFjBdk-px_tpvkpu89axjplvw0nA3DzGe_Fewo4', 1589809471),
(8184, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1ODk4MDgyOTYsImV4cCI6MTU4OTgxMDA5NiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.BhROQ1PDPfUVRS_h74fXwJxfggXEO5H6JaxbLwqyiTY', 1589810096),
(8190, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTg5ODI0ODk3LCJleHAiOjE1ODk4MjY2OTcsInBlcm1pc3Npb24iOiIifQ.cg1CkxpHEodPMN4QH55GqnilhpdwHnFuUgAJF9tWvJc', 1589826697),
(8196, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU4OTgzMTc5MCwiZXhwIjoxNTg5ODMzNTkwLCJwZXJtaXNzaW9uIjoiIn0.krDGN4Y_eIJS7lOrbU4fUD8n2KemobDSo_Iyjo-mCts', 1589833590),
(8202, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1ODk4MzY5NDMsImV4cCI6MTU4OTgzODc0MywicGVybWlzc2lvbiI6IiJ9.aXhdmydNZX_eeQB0faTpo1SXssXgVxvGnc_cA8h80jc', 1589838743),
(8205, 2074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc0IiwidXNlcm1haWwiOiJ2aWNlbnRlLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTg5ODM3Mzk5LCJleHAiOjE1ODk4MzkxOTksInBlcm1pc3Npb24iOiIifQ.KMmKGVgDyhf1vRxIakeTdPs8Qlt-I5RkgPWgA9Rhqgw', 1589839199),
(8211, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU4OTg4NDcyNiwiZXhwIjoxNTg5ODg2NTI2LCJwZXJtaXNzaW9uIjoiIn0.0yYtVEyjvhhZWp6bA8Opa_f47RNApYbYxPKulBn1t8s', 1589886526),
(8214, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTg5ODg1NTE0LCJleHAiOjE1ODk4ODczMTQsInBlcm1pc3Npb24iOiIifQ.htoHhyCTRjn6g5HQ1vRXTqhudAPRk0DrbsXYYehkXJM', 1589887314),
(8220, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4OTg5NDU5NSwiZXhwIjoxNTg5ODk2Mzk1LCJwZXJtaXNzaW9uIjoiIn0.XL5VqJAXKZ2esav4h83ePx1cuSawUHxV_AzOW33lqz0', 1589896395),
(8226, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU4OTkxOTk3NywiZXhwIjoxNTg5OTIxNzc3LCJwZXJtaXNzaW9uIjoiIn0.pbXs9-02EalPs5EEWg8LHznKyF_snpJTkiZbPwenfb0', 1589921777),
(8229, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU4OTkyMTg0NywiZXhwIjoxNTg5OTIzNjQ3LCJwZXJtaXNzaW9uIjoiIn0.pGnhGBJlj94_25S3jGaQnoQU7smMIuRSYm-4v8jTPtw', 1589923647),
(8235, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1ODk5NjMxMjksImV4cCI6MTU4OTk2NDkyOSwicGVybWlzc2lvbiI6IiJ9.gukksl6WO2YEkbiuzM7RTOhIIt_9GmQu2TtyGl7ylM8', 1589964929),
(8238, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTg5OTY0ODYwLCJleHAiOjE1ODk5NjY2NjAsInBlcm1pc3Npb24iOiIifQ.r8MExmd3vwnErvR4uUaVuxpiAth7PWsgh5gAh8gWhpc', 1589966660),
(8241, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU4OTk2NjU3MywiZXhwIjoxNTg5OTY4MzczLCJwZXJtaXNzaW9uIjoiIn0.j2YmaqfAee8f24xe5s_DI6pXac-W9L2Wp_0y6PI0tzA', 1589968373),
(8247, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU4OTk5NDM4MiwiZXhwIjoxNTg5OTk2MTgyLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.8viu_oCDLSBGEfoifWW1D-30xqh4b54KJ9WglHoaq1M', 1589996182),
(8253, 1275, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc1IiwidXNlcm1haWwiOiJnbWF0b3MuZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1OTAwMDgwOTEsImV4cCI6MTU5MDAwOTg5MSwicGVybWlzc2lvbiI6IiJ9.skxhE-FXN8GN3jXNnsXhs8cPtfE9JvF3PoyGXz-_MYw', 1590009891),
(8259, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1OTAwMjI5OTIsImV4cCI6MTU5MDAyNDc5MiwicGVybWlzc2lvbiI6IiJ9.Gx3Hgl5DfRtEPSwCFmGI1NCdtKkm9jZT_Z2PrK3tq5g', 1590024792),
(8265, 2032, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMyIiwidXNlcm1haWwiOiJkZGlhc0B1YS5wdCIsImlhdCI6MTU5MDA1MjYyOCwiZXhwIjoxNTkwMDU0NDI4LCJwZXJtaXNzaW9uIjoiIn0.J8lk4EtETNG0LjCXpj25V9oZzOg-sobKGzmemlv6HTc', 1590054428),
(8271, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTkwMDU4OTE3LCJleHAiOjE1OTAwNjA3MTcsInBlcm1pc3Npb24iOiIifQ.HqlnlEVBehXuOZqGyQQRP4tTagepVbKkoIx5W8UYbCo', 1590060717),
(8277, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTkwMDY5MjU0LCJleHAiOjE1OTAwNzEwNTQsInBlcm1pc3Npb24iOiIifQ.BQ-5qo6sWRimepDuOH8ziR4TjAFIyOIb-jney7BpGiA', 1590071054),
(8283, 2040, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQwIiwidXNlcm1haWwiOiJmYWJpby5tQHVhLnB0IiwiaWF0IjoxNTkwMDgyNTM4LCJleHAiOjE1OTAwODQzMzgsInBlcm1pc3Npb24iOiIifQ.c72HasA-3nmpAk5kd-0IeYfWnuYflrPpT4_8WmqyGkI', 1590084338),
(8286, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU5MDA4MjU0MywiZXhwIjoxNTkwMDg0MzQzLCJwZXJtaXNzaW9uIjoiIn0.xceGPacoOfqziznSC-9qbFZeRlZCizVLEIsJkOVyUhk', 1590084343),
(8289, 1182, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTgyIiwidXNlcm1haWwiOiJkdWFydGUubnRtQHVhLnB0IiwiaWF0IjoxNTkwMDgyNTU4LCJleHAiOjE1OTAwODQzNTgsInBlcm1pc3Npb24iOiIifQ.KbRoTg4QY55at_PWMv7Dd7IG0rwAHr6_AQP4vMo0ZZI', 1590084358),
(8295, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1OTAwODU0MTYsImV4cCI6MTU5MDA4NzIxNiwicGVybWlzc2lvbiI6IiJ9.eFhUzztT5gWHmj7NdgzdxQMLVOa9Ndd34tlq6SoRTnI', 1590087216),
(8301, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU5MDA5MDMyOSwiZXhwIjoxNTkwMDkyMTI5LCJwZXJtaXNzaW9uIjoiIn0.AIOu72uBfTp6HW8nPGm6wI5CI0UricYBTj4F2-XNHHI', 1590092129),
(8304, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU5MDA5MDUwNSwiZXhwIjoxNTkwMDkyMzA1LCJwZXJtaXNzaW9uIjoiIn0.UediOgzhkN0jSqDfT6To6Yxgtl9E0ACeVJm7HBnLiGw', 1590092305),
(8310, 1023, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDIzIiwidXNlcm1haWwiOiJjYXJvbGluYWFsYnVxdWVycXVlQHVhLnB0IiwiaWF0IjoxNTkwMTYyOTE4LCJleHAiOjE1OTAxNjQ3MTgsInBlcm1pc3Npb24iOiIifQ.e421viPwlPvfJuz-mV4IEZ0dfSKAyQ9ripEH0JDi9Jg', 1590164718),
(8316, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1OTAxNzUyNjEsImV4cCI6MTU5MDE3NzA2MSwicGVybWlzc2lvbiI6IiJ9.YHHSQPYRm7ErVhMoLKH614xDP6YibkJKD5OiwifdB_Y', 1590177061),
(8322, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1OTAxNzkzMzQsImV4cCI6MTU5MDE4MTEzNCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.op2DN3BfbH-vnEus22pm84DRVc4lle8vrluyH951H0w', 1590181134),
(8325, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1OTAxODI3NjAsImV4cCI6MTU5MDE4NDU2MCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.y0HoEvCipnEFwFt_8OToqBHN-ffW8WNDaZbgkf7H4mY', 1590184560),
(8331, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU5MDE5MDU1OCwiZXhwIjoxNTkwMTkyMzU4LCJwZXJtaXNzaW9uIjoiIn0.uX3pntyWXKcufC7Hqq0c7UQHIviQKWnpXoHLJm4HikA', 1590192358),
(8337, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTkwMjQxNjgxLCJleHAiOjE1OTAyNDM0ODEsInBlcm1pc3Npb24iOiIifQ.irAGarMKxongerltzuLJIUu1Fmy2PidBdzbiD-Ow6FU', 1590243481),
(8340, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU5MDI0Mzk0NCwiZXhwIjoxNTkwMjQ1NzQ0LCJwZXJtaXNzaW9uIjoiIn0.J5F8U5XyVqZ7fo9_LkQH-39KbsuKrFR-Qq7QkoB5v6o', 1590245744),
(8352, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTkwMjc5ODk4LCJleHAiOjE1OTAyODE2OTgsInBlcm1pc3Npb24iOiIifQ.DV3JRUfc_WdduLIoetSeEg_fXcsX8EEbbu2kyqbFNgA', 1590281698),
(8358, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTkwMzE2NDcxLCJleHAiOjE1OTAzMTgyNzEsInBlcm1pc3Npb24iOiIifQ.2XWjVwFNxDQFSc6zFi8CpGXAEjvL1gQ3J4VGRbkwOjs', 1590318271),
(8361, 888, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4ODgiLCJ1c2VybWFpbCI6ImFuYWFAdWEucHQiLCJpYXQiOjE1OTAzMTcxMTQsImV4cCI6MTU5MDMxODkxNCwicGVybWlzc2lvbiI6IiJ9.GIMSVoNkpmzFdluTpwt00K_6ewlDS8vhrFrPs51tyqg', 1590318914),
(8367, 1644, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjQ0IiwidXNlcm1haWwiOiJtaWd1ZWwuZnJhZGluaG9AdWEucHQiLCJpYXQiOjE1OTAzNDc5MTksImV4cCI6MTU5MDM0OTcxOSwicGVybWlzc2lvbiI6IiJ9.PsFHTmG8Um0bCHoVECeQUi_Rbwn3XtculyoiWCVirss', 1590349719),
(8373, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1OTA0MTIyMzUsImV4cCI6MTU5MDQxNDAzNSwicGVybWlzc2lvbiI6IiJ9.xaC_ZL7TgkNwuIovggL9_y5x538HwuFtiEZKSbwo-aY', 1590414035),
(8379, 1674, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjc0IiwidXNlcm1haWwiOiJtb3JhaXNhbmRyZUB1YS5wdCIsImlhdCI6MTU5MDQyMzE4NCwiZXhwIjoxNTkwNDI0OTg0LCJwZXJtaXNzaW9uIjoiIn0.PRedQqu1AY2_On7gO-RYfGonVtOp_Ba5853Rew_awb0', 1590424984),
(8385, 2021, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDIxIiwidXNlcm1haWwiOiJhbGV4YW5kcmVzZXJyYXNAdWEucHQiLCJpYXQiOjE1OTA0Mzc5MjQsImV4cCI6MTU5MDQzOTcyNCwicGVybWlzc2lvbiI6IiJ9.E2jFmlYtIoXpoU_wIKqhcafTc6vV9UqVr3_OmmchQzE', 1590439724),
(8388, 1329, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMzI5IiwidXNlcm1haWwiOiJodWdvZnBhaXZhQHVhLnB0IiwiaWF0IjoxNTkwNDQwNzUwLCJleHAiOjE1OTA0NDI1NTAsInBlcm1pc3Npb24iOiIifQ.gO4rVbYzOIdBI153fm3U8axvEtplCBaM-zNdEjO1LGE', 1590442550),
(8391, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1OTA0NDEwOTQsImV4cCI6MTU5MDQ0Mjg5NCwicGVybWlzc2lvbiI6IiJ9.3mAc_zfL_qzw0vn1vVB2q-LhM5jrf-Vb0METtyyzJVU', 1590442894),
(8397, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTkwNDgyOTUxLCJleHAiOjE1OTA0ODQ3NTEsInBlcm1pc3Npb24iOiIifQ.AnYi1zYd4LKWxDxAfZiEMr20LZp4-EbBHwnKgnZE7VM', 1590484751),
(8403, 2112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTEyIiwidXNlcm1haWwiOiJkYW5pLmZpZ0B1YS5wdCIsImlhdCI6MTU5MDUwNTMxNCwiZXhwIjoxNTkwNTA3MTE0LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.UNDoSVVmjQa1gQRENqpqkhlMq14labOx3C0TlhCMLKg', 1590507114),
(8409, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTkwNTMyMTI1LCJleHAiOjE1OTA1MzM5MjUsInBlcm1pc3Npb24iOiIifQ.AS_DkMCDlX_ZpMcKf_3Y06RM8AWJUaI03XAAtCewpFg', 1590533925),
(8412, 2047, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ3IiwidXNlcm1haWwiOiJqb2FvcmVpczE2QHVhLnB0IiwiaWF0IjoxNTkwNTM0MjI3LCJleHAiOjE1OTA1MzYwMjcsInBlcm1pc3Npb24iOiIifQ.xf_DFMv4JAjDgYV060BDXyhgfw81_Tu-nOh6_I5ZckM', 1590536027),
(8415, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1OTA1MzY2ODAsImV4cCI6MTU5MDUzODQ4MCwicGVybWlzc2lvbiI6IiJ9.0b5vF4V_xtclR16qhdoeDANsDHJs3nWQxhK-fEezNac', 1590538480),
(8421, 1620, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjIwIiwidXNlcm1haWwiOiJtYXJpb3NpbHZhQHVhLnB0IiwiaWF0IjoxNTkwNTcwMjgxLCJleHAiOjE1OTA1NzIwODEsInBlcm1pc3Npb24iOiIifQ.sKuwSoHcZ1kInzawt9L43HVitilQ4sVxP4as0bOY6Yg', 1590572081),
(8427, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTkwNTczODQwLCJleHAiOjE1OTA1NzU2NDAsInBlcm1pc3Npb24iOiIifQ.2FArRmV9It0sPk-aHeuNtFXu4r-s14GfhXFsu04gFc8', 1590575640),
(8433, 2059, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU5IiwidXNlcm1haWwiOiJzb2JyYWxAdWEucHQiLCJpYXQiOjE1OTA1ODUyNjUsImV4cCI6MTU5MDU4NzA2NSwicGVybWlzc2lvbiI6IiJ9.TwGBaQITdezqdqz0Atx3zEmHW6xs9MtCjgc0vuc1JgA', 1590587065),
(8436, 2106, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA2IiwidXNlcm1haWwiOiJzb3BoaWVwb3VzaW5ob0B1YS5wdCIsImlhdCI6MTU5MDU4NjY0NywiZXhwIjoxNTkwNTg4NDQ3LCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.rT-V-6_oWqEqecO-MY5pTItz7gmB01CMioO_fo6U-Uw', 1590588447),
(8442, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTkwNTg5NTU4LCJleHAiOjE1OTA1OTEzNTgsInBlcm1pc3Npb24iOiIifQ.ej-iSmZZI-kg3PGAGWvsIRkRjf84UWDPX6afFNMCr4k', 1590591358),
(8448, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTkwNTkzOTAyLCJleHAiOjE1OTA1OTU3MDIsInBlcm1pc3Npb24iOiIifQ.qshiA0p27Lx1ef6CXYEoO5yMshbfM5xfG3Mh8iYzNmE', 1590595702),
(8451, 2069, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY5IiwidXNlcm1haWwiOiJyb2RyaWdvZmxpbWFAdWEucHQiLCJpYXQiOjE1OTA1OTQyMDksImV4cCI6MTU5MDU5NjAwOSwicGVybWlzc2lvbiI6IiJ9.RhXqz2anMM6mkEArzDbzZAxwPUJFZwK8JCJqVbhBC3Y', 1590596009),
(8454, 2072, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDcyIiwidXNlcm1haWwiOiJ0b21lY2FydmFsaG9AdWEucHQiLCJpYXQiOjE1OTA1OTUxNjksImV4cCI6MTU5MDU5Njk2OSwicGVybWlzc2lvbiI6IiJ9.c1fHXQcMLCAOP53Oell4l8_DKlDkHW_BKk8J7iUMTCc', 1590596969),
(8457, 2024, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI0IiwidXNlcm1haWwiOiJhbmRyZWZyZWl4bzE4QHVhLnB0IiwiaWF0IjoxNTkwNTk2MzQyLCJleHAiOjE1OTA1OTgxNDIsInBlcm1pc3Npb24iOiIifQ.7eG9nN7lAGmbq_zXYGBaoyx8EDU5lCo6cDvXjvimnHI', 1590598142),
(8460, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTkwNTk2NDI2LCJleHAiOjE1OTA1OTgyMjYsInBlcm1pc3Npb24iOiIifQ.Dh6sL4nIjVJPvYR-x7tEF9oYdHOdGmgpiyAOJQ3iD7k', 1590598226),
(8466, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1OTA2MDA1MzUsImV4cCI6MTU5MDYwMjMzNSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.HgPAfVQ7SvJdIbdyfKjzyeSLop6bgxO1ZGKzD28ciE8', 1590602335),
(8469, 2118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTE4IiwidXNlcm1haWwiOiJhZ21AdWEucHQiLCJpYXQiOjE1OTA2MDE2MTUsImV4cCI6MTU5MDYwMzQxNSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.PyISkxRG3PaS542xWTzd8DgLv4YeQxH_1SdURkXVrj8', 1590603415),
(8475, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTkwNjExODYwLCJleHAiOjE1OTA2MTM2NjAsInBlcm1pc3Npb24iOiIifQ.5fojnfXV6vJmh6Ps7q3Wy6I0QsUx997ZsAe4hJ1He3Y', 1590613660),
(8481, 2036, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM2IiwidXNlcm1haWwiOiJkaW9nb21mc2lsdmE5OEB1YS5wdCIsImlhdCI6MTU5MDYyODkyNSwiZXhwIjoxNTkwNjMwNzI1LCJwZXJtaXNzaW9uIjoiIn0.YpHju7bAWLtRVl5DYpzpadCcd1Sdu-G_KQ2kkgNxC94', 1590630725),
(8487, 1599, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNTk5IiwidXNlcm1haWwiOiJtYXJjb3NzaWx2YUB1YS5wdCIsImlhdCI6MTU5MDY2MDE0MiwiZXhwIjoxNTkwNjYxOTQyLCJwZXJtaXNzaW9uIjoiIn0.dRchqJdV6T31rMOv2z1rwKa4-szRyGtEIsnzIXio8LA', 1590661942),
(8490, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU5MDY2MDc4MCwiZXhwIjoxNTkwNjYyNTgwLCJwZXJtaXNzaW9uIjoiIn0.aN0hvkX_MQavHSBRaflUjg9Z8a0xOSn95kD_aRybqf4', 1590662580),
(8496, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU5MDY2MzcwMCwiZXhwIjoxNTkwNjY1NTAwLCJwZXJtaXNzaW9uIjoiIn0.BILk1SZGpXYbL2q0MD0YQEj0j41un_lRP_2jysscz3M', 1590665500),
(8499, 2047, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ3IiwidXNlcm1haWwiOiJqb2FvcmVpczE2QHVhLnB0IiwiaWF0IjoxNTkwNjYzODkxLCJleHAiOjE1OTA2NjU2OTEsInBlcm1pc3Npb24iOiIifQ.DjYAJqoQS3rXQae69Wc6yT0KvakVa16Q9C0ZGu4sZbg', 1590665691),
(8505, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU5MDY3OTQxOSwiZXhwIjoxNTkwNjgxMjE5LCJwZXJtaXNzaW9uIjoiIn0.JqEin56gz7soNF7OBkVHE68gcu-awDyTjP7b7coOhhU', 1590681219),
(8508, 2058, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDU4IiwidXNlcm1haWwiOiJwYXVsb2dzcGVyZWlyYUB1YS5wdCIsImlhdCI6MTU5MDY3OTU1NywiZXhwIjoxNTkwNjgxMzU3LCJwZXJtaXNzaW9uIjoiIn0.mxdrt2qwwkkAEGUZgU71onEbg515GjUyE97FNWJSE0c', 1590681357),
(8511, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTkwNjc5NjMyLCJleHAiOjE1OTA2ODE0MzIsInBlcm1pc3Npb24iOiIifQ.5sNoXjLr1K1-QAX3DjzqJlTdiwF8Vekjgyx9YUFj6E8', 1590681432),
(8514, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTkwNjgxMTQwLCJleHAiOjE1OTA2ODI5NDAsInBlcm1pc3Npb24iOiIifQ.u0EI9VBBb72g9afT11c_FE3US-vD5tVzp09hsZqL4mk', 1590682940),
(8517, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1OTA2ODEyNDIsImV4cCI6MTU5MDY4MzA0MiwicGVybWlzc2lvbiI6IiJ9.7o6O8-JBydjMBQLY-DKpD0dTt-V4Y15F5HdJDKzM_Hc', 1590683042),
(8520, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1OTA2ODEzMDgsImV4cCI6MTU5MDY4MzEwOCwicGVybWlzc2lvbiI6IiJ9.wIU17rng4lqfApaeIjbJY24-P93FV5ATs4jIybjRI14', 1590683108),
(8523, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU5MDY4MTU4MywiZXhwIjoxNTkwNjgzMzgzLCJwZXJtaXNzaW9uIjoiIn0.fFS4swE6t9pCfK2M2zNS1tkAL6aYst1unFbZk-pHbaA', 1590683383),
(8529, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1OTA2ODQ3NTksImV4cCI6MTU5MDY4NjU1OSwicGVybWlzc2lvbiI6IiJ9.Qqa21zzSG8WjcYdgy4SiYWLo740NZZtpdQVRLO0IZHA', 1590686559),
(8532, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTkwNjg1OTQ5LCJleHAiOjE1OTA2ODc3NDksInBlcm1pc3Npb24iOiIifQ.FNdxBsyKyzuIc9OTjoGN4_2CVJo4do1ASxaD6sBX7NM', 1590687749),
(8538, 1620, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjIwIiwidXNlcm1haWwiOiJtYXJpb3NpbHZhQHVhLnB0IiwiaWF0IjoxNTkwNzAxMTk3LCJleHAiOjE1OTA3MDI5OTcsInBlcm1pc3Npb24iOiIifQ.xxlDru1SBSO9wm7FpqzCEhhfIctC-KI7iILIBPQMQ5s', 1590702997),
(8544, 2062, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYyIiwidXNlcm1haWwiOiJwZWRyby5kbGRAdWEucHQiLCJpYXQiOjE1OTA3NDMxNDcsImV4cCI6MTU5MDc0NDk0NywicGVybWlzc2lvbiI6IiJ9.91IZuzKWeR2RPbnC3BUWA-p_qesvvyZPnMsBYAZh1sE', 1590744947),
(8550, 2043, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQzIiwidXNlcm1haWwiOiJnb25jYWxvbGVhbHNpbHZhQHVhLnB0IiwiaWF0IjoxNTkwNzY0MjM4LCJleHAiOjE1OTA3NjYwMzgsInBlcm1pc3Npb24iOiIifQ.Z20_xMwkEMqqzCIALuO6CgA8TfxWpqCyjHEKTADJaAg', 1590766038),
(8556, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTkwNzczMzk1LCJleHAiOjE1OTA3NzUxOTUsInBlcm1pc3Npb24iOiIifQ.5GKwzcCooOOXeyuYCcyi5ISJAeL8BEuHFKFh9JachX8', 1590775195),
(8562, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTkwNzc2NjM0LCJleHAiOjE1OTA3Nzg0MzQsInBlcm1pc3Npb24iOiIifQ.D7fLgEWuUazIsSBBQnUYoXH2FdiQJD6p0mtSAaRsA1M', 1590778434),
(8577, 2033, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMzIiwidXNlcm1haWwiOiJkaWFuYS5zaXNvQHVhLnB0IiwiaWF0IjoxNTkwODQyMjE5LCJleHAiOjE1OTA4NDQwMTksInBlcm1pc3Npb24iOiIifQ.LPOsGrP6jM_E0yPnMZZQyVzWC-4lPjj_MAOdu3ypnuM', 1590844019),
(8580, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1OTA4NDUyNTEsImV4cCI6MTU5MDg0NzA1MSwicGVybWlzc2lvbiI6IiJ9.43pkFHv0yQY9cKKwDn3r2mzue8MuViTVE2XV3zs5Wu4', 1590847051),
(8583, 2074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc0IiwidXNlcm1haWwiOiJ2aWNlbnRlLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTkwODQ1MjkxLCJleHAiOjE1OTA4NDcwOTEsInBlcm1pc3Npb24iOiIifQ.E-gooRYEPqL_QuqOPhK94JqELOE0lf6el3i7EUXPp-w', 1590847091),
(8586, 2063, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDYzIiwidXNlcm1haWwiOiJwbWFwbUB1YS5wdCIsImlhdCI6MTU5MDg0NjIxMywiZXhwIjoxNTkwODQ4MDEzLCJwZXJtaXNzaW9uIjoiIn0.FGeH5PHVZTKkbtBcflaJudeS3A93dPTz3TpPtgxPzsc', 1590848013),
(8595, 2044, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ0IiwidXNlcm1haWwiOiJoc291c2FAdWEucHQiLCJpYXQiOjE1OTA5MjE2NzYsImV4cCI6MTU5MDkyMzQ3NiwicGVybWlzc2lvbiI6IiJ9.g2UsLgYPxK-zqsJJvBp7jKB-9aDZRM_RZ6ZZqo10Qic', 1590923476),
(8601, 1926, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxOTI2IiwidXNlcm1haWwiOiJzZ2dAdWEucHQiLCJpYXQiOjE1OTA5NDA2NDEsImV4cCI6MTU5MDk0MjQ0MSwicGVybWlzc2lvbiI6IiJ9.9e6XKiQd47z2j_1ZSbUJ_MNfJIvPa5W33VKhUnrYnkI', 1590942441),
(8607, 2106, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMTA2IiwidXNlcm1haWwiOiJzb3BoaWVwb3VzaW5ob0B1YS5wdCIsImlhdCI6MTU5MTAwNjAwMywiZXhwIjoxNTkxMDA3ODAzLCJwZXJtaXNzaW9uIjoiREVGQVVMVCJ9.k0hGcnB2XBc-auG0rAiho1fThmFaNYAGRiCA-B9x_Q4', 1591007803),
(8610, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1OTEwMDY5MTEsImV4cCI6MTU5MTAwODcxMSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.c5bGs3L7pPh8vJWCVub2_g86aBqs3gKsV6dIByrfeso', 1591008711),
(8616, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1OTEwMTc0MDYsImV4cCI6MTU5MTAxOTIwNiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.L_0yn5rSEs-VlVeszrISx0M58X0Hq5jmU7z8VYykaio', 1591019206),
(8622, 1269, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjY5IiwidXNlcm1haWwiOiJmcmVkZXJpY29hdm9AdWEucHQiLCJpYXQiOjE1OTEwMTkzMzYsImV4cCI6MTU5MTAyMTEzNiwicGVybWlzc2lvbiI6IiJ9.pv2eGKu0K2OsaHgurlV2lQz5Naa2UutsZSlQbGG1tVo', 1591021136),
(8625, 1719, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzE5IiwidXNlcm1haWwiOiJwZWRyby5qb3NlZmVycmVpcmFAdWEucHQiLCJpYXQiOjE1OTEwMjAxNDgsImV4cCI6MTU5MTAyMTk0OCwicGVybWlzc2lvbiI6IiJ9.PI7nx3XsHZeZE_IpAQl-E4QOnUanbg4E3A9bfOqP0AM', 1591021948),
(8631, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTkxMDI1NjAxLCJleHAiOjE1OTEwMjc0MDEsInBlcm1pc3Npb24iOiIifQ.jxqjb7FJzDNqEgRSl5ABvBocB3GqGB6u-fjZo5Q4wT4', 1591027401),
(8637, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTkxMDM2Njk3LCJleHAiOjE1OTEwMzg0OTcsInBlcm1pc3Npb24iOiIifQ.FE_avU-lRaik8UdSPgbUuczUcdab3_A5sobl2sWtMLk', 1591038497),
(8643, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1OTEwNDMyNjYsImV4cCI6MTU5MTA0NTA2NiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.oe3TQ6W5PSt-yF1QhnC58F6w8Q1NwUt2YwG0BfKtbI8', 1591045066),
(8649, 2047, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ3IiwidXNlcm1haWwiOiJqb2FvcmVpczE2QHVhLnB0IiwiaWF0IjoxNTkxMDQ2NTY3LCJleHAiOjE1OTEwNDgzNjcsInBlcm1pc3Npb24iOiIifQ.IOOdmPoGoJnerP-VEDkFa0wO49h7ecKzX5kAEht0yVA', 1591048367),
(8655, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU5MTA1MzAzNywiZXhwIjoxNTkxMDU0ODM3LCJwZXJtaXNzaW9uIjoiIn0.f5owXhGP6IhBJG7Gzdjyf0rq2HxuVq8hR9di6roFNSs', 1591054837),
(8661, 2086, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDg2IiwidXNlcm1haWwiOiJndWlsaGVybWVhbGVncmVAdWEucHQiLCJpYXQiOjE1OTEwNjExNzcsImV4cCI6MTU5MTA2Mjk3NywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.Qr3yl0l9-m1sn_rL4A-YWcWh_LMVZ8rp3pa4sarxuBM', 1591062977),
(8667, 2068, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY4IiwidXNlcm1haWwiOiJyaWNhcmRvcm9kcmlndWV6QHVhLnB0IiwiaWF0IjoxNTkxMDkzNTU2LCJleHAiOjE1OTEwOTUzNTYsInBlcm1pc3Npb24iOiIifQ.cEnfiKlYWRdYU1fV7Ooon9rq2zg26PW1lra_ezj99XA', 1591095356),
(8673, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1OTEyMjMwMTAsImV4cCI6MTU5MTIyNDgxMCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.Rp-tblAv8IB5XMZ2pGBA6YBEp4WgegOAGfZ39oJbOoQ', 1591224810),
(8679, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1OTEyNjA4MDMsImV4cCI6MTU5MTI2MjYwMywicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.PlDZo0lrjO4sxUdDj-3CcLQYg_GOtDwY7_SmZNwKch8', 1591262603),
(8685, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1OTEzNTY0NDUsImV4cCI6MTU5MTM1ODI0NSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.8YG3N6yN_mPKP_zfy0_IhpS10jkXXPxfDylgPX30Akg', 1591358245),
(8691, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1OTEzNjYwMTQsImV4cCI6MTU5MTM2NzgxNCwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.4qIKfDz0Tfa_34wnE7w-nAaXYbnQ_-UNVgiHz0Vffw8', 1591367814),
(8697, 2074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc0IiwidXNlcm1haWwiOiJ2aWNlbnRlLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTkxMzkzNDU2LCJleHAiOjE1OTEzOTUyNTYsInBlcm1pc3Npb24iOiIifQ.laaN7IaOgxOY2wfR1EM6aNUWrIxcrgfZoTryQ_eUFFQ', 1591395256),
(8703, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU5MTUzNzY1OCwiZXhwIjoxNTkxNTM5NDU4LCJwZXJtaXNzaW9uIjoiIn0.jhha4jM4HXBmbUEQ-tSxQZG7N1g4HWlZj_OAi3uAA8w', 1591539458),
(8709, 2066, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY2IiwidXNlcm1haWwiOiJyZW5hdG9hbGRpYXMxMkB1YS5wdCIsImlhdCI6MTU5MTU0NjMyMSwiZXhwIjoxNTkxNTQ4MTIxLCJwZXJtaXNzaW9uIjoiIn0.AgzYk2qNJArc4CO04lvxxIxWuxsRGN4qJgbysIEXHhM', 1591548121),
(8715, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTkxNjUyNzI3LCJleHAiOjE1OTE2NTQ1MjcsInBlcm1pc3Npb24iOiIifQ.gyuIhhFg2aK32XolwZxV5e1RzpaNh7ZVwCuazuq7bGo', 1591654527),
(8721, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTkxNjU2MTg5LCJleHAiOjE1OTE2NTc5ODksInBlcm1pc3Npb24iOiIifQ.rGluMoIRgFpztizMRRZ4xUWjpafz0qtzJGGe4b4D_LU', 1591657989),
(8727, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU5MTcwNTg1MiwiZXhwIjoxNTkxNzA3NjUyLCJwZXJtaXNzaW9uIjoiIn0.qd590TJd950ucbFjvgo56nWOjKMtjrZd5xT2Ls27TWY', 1591707652),
(8733, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTkxNzE4ODUzLCJleHAiOjE1OTE3MjA2NTMsInBlcm1pc3Npb24iOiIifQ.OW02YZ4beXAmIrN0OG98yG2UuulWtX3fYDbkQwEpXHA', 1591720653),
(8736, 1278, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc4IiwidXNlcm1haWwiOiJnb25jYWxvLmFsbWVpZGFAdWEucHQiLCJpYXQiOjE1OTE3MTk0MDYsImV4cCI6MTU5MTcyMTIwNiwicGVybWlzc2lvbiI6IiJ9.dzW1-Vw3omJtZ-ETG1bSaB-aXLi7N1XTgFLXbW9Amq4', 1591721206),
(8742, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTkxNzg1NzUwLCJleHAiOjE1OTE3ODc1NTAsInBlcm1pc3Npb24iOiIifQ.RINZU38C7cTRQCI2-2llDrlr29u8j4owOF0HIyUy8mY', 1591787550),
(8748, 2074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc0IiwidXNlcm1haWwiOiJ2aWNlbnRlLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTkxODE1MzUyLCJleHAiOjE1OTE4MTcxNTIsInBlcm1pc3Npb24iOiIifQ.onlHTHJLLbJiZTUauimBf-6_eBdCnq1bJ_aeQz4L5f8', 1591817152),
(8757, 1026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDI2IiwidXNlcm1haWwiOiJjYXJvbGluYXJlc2VuZGVtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTkxODk4ODY0LCJleHAiOjE1OTE5MDA2NjQsInBlcm1pc3Npb24iOiIifQ.JgO7UeNv0zJstbH5VSa0s4POPYKhLfIpStRTexXpg14', 1591900664),
(8763, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTkxOTExMjY5LCJleHAiOjE1OTE5MTMwNjksInBlcm1pc3Npb24iOiIifQ.UfsjrLzuAf6S0fnAWhAcXOl-zTVTJ4aIsCVBA313fx8', 1591913069),
(8769, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU5MTk4NTcxOCwiZXhwIjoxNTkxOTg3NTE4LCJwZXJtaXNzaW9uIjoiIn0.r9BJAK9_PwNln0PjEgz0YrNmJCCCevLSNMior26UIRk', 1591987518),
(8775, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU5MjA1NTEwMSwiZXhwIjoxNTkyMDU2OTAxLCJwZXJtaXNzaW9uIjoiIn0.mvOpNMnsADULuCjbKBoqaaXxUhE0bnb7-vQe479XjFg', 1592056901),
(8781, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTkyMDY3MjcxLCJleHAiOjE1OTIwNjkwNzEsInBlcm1pc3Npb24iOiIifQ.q69eA-_6AYFWb-rale5BQu78TGNAE1fZaENPhaPk6Ds', 1592069071);
INSERT INTO `GenTokens` (`id`, `userid`, `token`, `expire_date`) VALUES
(8787, 1026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDI2IiwidXNlcm1haWwiOiJjYXJvbGluYXJlc2VuZGVtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTkyMTQxNDczLCJleHAiOjE1OTIxNDMyNzMsInBlcm1pc3Npb24iOiIifQ.k2g72A2Vho8NdGMPvpj7qPMil_5tF2eLMqZDqkDnNLE', 1592143273),
(8793, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTkyMTU3MzgzLCJleHAiOjE1OTIxNTkxODMsInBlcm1pc3Npb24iOiIifQ.use6SlsEXEI-EOblV3AJTCgzasMKnqSKCBZmI75Grzo', 1592159183),
(8799, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU5MjIxNzczNSwiZXhwIjoxNTkyMjE5NTM1LCJwZXJtaXNzaW9uIjoiIn0.HeckQb_fL9D6ctXxPdp7EDy08HlPHoA6aRavB8kwlb4', 1592219535),
(8805, 1620, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjIwIiwidXNlcm1haWwiOiJtYXJpb3NpbHZhQHVhLnB0IiwiaWF0IjoxNTkyMjMyNzM4LCJleHAiOjE1OTIyMzQ1MzgsInBlcm1pc3Npb24iOiIifQ.vnVVt9lXEYDe0JPT3j8MofP8AtBF0mo_tGUO614mXYQ', 1592234538),
(8808, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU5MjIzMzM2NSwiZXhwIjoxNTkyMjM1MTY1LCJwZXJtaXNzaW9uIjoiIn0.Cs--yZ7i_NTSq-4tQYqd7dAySvPUmmAZuyl49L_JieA', 1592235165),
(8811, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU5MjIzNTAwMywiZXhwIjoxNTkyMjM2ODAzLCJwZXJtaXNzaW9uIjoiIn0.St7ZAays48gDYQKTsGRoZXhYNNYD5N59g7P9LqNYj2w', 1592236803),
(8814, 1767, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzY3IiwidXNlcm1haWwiOiJwZXJlaXJhLmdvbmNhbG9AdWEucHQiLCJpYXQiOjE1OTIyMzY0MDIsImV4cCI6MTU5MjIzODIwMiwicGVybWlzc2lvbiI6IiJ9.EbTcdZ1UjKzD1i4L3wc--5UFoAb2W_KQD2H6Z28up3I', 1592238202),
(8820, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU5MjI0OTczNCwiZXhwIjoxNTkyMjUxNTM0LCJwZXJtaXNzaW9uIjoiIn0.WDtwCyf98uVbNXkwKCkrf1in9OTm7wWqCAtXZaqUVjc', 1592251534),
(8826, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU5MjI1Mjk0MiwiZXhwIjoxNTkyMjU0NzQyLCJwZXJtaXNzaW9uIjoiIn0.DjC90skWQqMpPgrgtRZfzK7T_NeehVFJS9-967IlmpE', 1592254742),
(8832, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTkyMjYwMTE0LCJleHAiOjE1OTIyNjE5MTQsInBlcm1pc3Npb24iOiIifQ.PfFxqckyqFq2lYPVFUk9ryGCbIVb3VjZHBvHNTo8d7k', 1592261914),
(8838, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU5MjMxMDY1OCwiZXhwIjoxNTkyMzEyNDU4LCJwZXJtaXNzaW9uIjoiIn0.ltzX2U5gQOy7k62Yh_8jWVgzlz5qRGoRco2Dis0kC2Y', 1592312458),
(8844, 1026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDI2IiwidXNlcm1haWwiOiJjYXJvbGluYXJlc2VuZGVtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTkyMzE5ODg0LCJleHAiOjE1OTIzMjE2ODQsInBlcm1pc3Npb24iOiIifQ.pxoqVzZBgOiWTPdQWE5HZeJDP_WSasmjtzhNRob0T_o', 1592321684),
(8850, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU5MjMyNDg3MCwiZXhwIjoxNTkyMzI2NjcwLCJwZXJtaXNzaW9uIjoiIn0.VfwOujhHv95mLH_rX_PK1XcVAFysgcAZQvYg7ptk4I4', 1592326670),
(8853, 2049, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ5IiwidXNlcm1haWwiOiJib3JnZXNqcHNAdWEucHQiLCJpYXQiOjE1OTIzMjYzMDYsImV4cCI6MTU5MjMyODEwNiwicGVybWlzc2lvbiI6IiJ9.B_si9GBd29OavLgdPpTM3MFPIdlvQ36XYjt0sbpFEpY', 1592328106),
(8859, 1026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDI2IiwidXNlcm1haWwiOiJjYXJvbGluYXJlc2VuZGVtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTkyMzk5MTgxLCJleHAiOjE1OTI0MDA5ODEsInBlcm1pc3Npb24iOiIifQ.xyFvyi68QSOqeiQuV7i_q9Pd6M3lkMGpWBbkTYnIb2M', 1592400981),
(8865, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTkyNDE3OTE3LCJleHAiOjE1OTI0MTk3MTcsInBlcm1pc3Npb24iOiIifQ.XVoKYz0XfTZfjm2MWOhcv-NpdHaKrcU9nwMQ6fsM-Bc', 1592419717),
(8871, 1026, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDI2IiwidXNlcm1haWwiOiJjYXJvbGluYXJlc2VuZGVtYXJxdWVzQHVhLnB0IiwiaWF0IjoxNTkyNDczNjM4LCJleHAiOjE1OTI0NzU0MzgsInBlcm1pc3Npb24iOiIifQ.8LgommMy9r1sFq196aND0gncMojKg-7TAnvefuq_NZo', 1592475438),
(8877, 1782, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzgyIiwidXNlcm1haWwiOiJwbWFzaWx2YTIwQHVhLnB0IiwiaWF0IjoxNTkyNDgxMzEzLCJleHAiOjE1OTI0ODMxMTMsInBlcm1pc3Npb24iOiIifQ.pK3gZgLddaGlO7zq8-YR8Mcp1nv63HAtVbhsZuXiL-M', 1592483113),
(8883, 1278, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc4IiwidXNlcm1haWwiOiJnb25jYWxvLmFsbWVpZGFAdWEucHQiLCJpYXQiOjE1OTI0OTg5NzksImV4cCI6MTU5MjUwMDc3OSwicGVybWlzc2lvbiI6IiJ9.W0LkkHhle62WpTyP9ujt1Q_z54rjQZvPMxb2EJPbv1o', 1592500779),
(8889, 1053, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMDUzIiwidXNlcm1haWwiOiJjbGF1ZGlvLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTkyNTAzMzQxLCJleHAiOjE1OTI1MDUxNDEsInBlcm1pc3Npb24iOiIifQ.Ts7E-_RDSHYKrD4njZ-8WmjD30a1kb0WeyP4nlyaCcY', 1592505141),
(8895, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU5MjU3NjI0MCwiZXhwIjoxNTkyNTc4MDQwLCJwZXJtaXNzaW9uIjoiIn0.p_VmCf3sI04GDwprB5vcbgGoZfg1jtq-6SIY3zqT20Q', 1592578040),
(8901, 1278, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMjc4IiwidXNlcm1haWwiOiJnb25jYWxvLmFsbWVpZGFAdWEucHQiLCJpYXQiOjE1OTI1ODA1MTQsImV4cCI6MTU5MjU4MjMxNCwicGVybWlzc2lvbiI6IiJ9.wK87guJtulKsDSWCoF0Xb9fvg6Zojen1qCp48pd4DG8', 1592582314),
(8907, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTkyNjY0NDM5LCJleHAiOjE1OTI2NjYyMzksInBlcm1pc3Npb24iOiIifQ.qt8bPUc08BpBpli9Ixb3g3jEXxb6Q9T9QuEUz0twdrM', 1592666239),
(8913, 1767, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzY3IiwidXNlcm1haWwiOiJwZXJlaXJhLmdvbmNhbG9AdWEucHQiLCJpYXQiOjE1OTI2NzUwMzAsImV4cCI6MTU5MjY3NjgzMCwicGVybWlzc2lvbiI6IiJ9.6CH_cJo2NirfObkolms4bIN-HnPoMhR3Xd2Eyr96Ypw', 1592676830),
(8919, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU5MjY5NDkwMSwiZXhwIjoxNTkyNjk2NzAxLCJwZXJtaXNzaW9uIjoiIn0.g1geO5To0HY2MNZXbkdJUjJO0w3OCA4yKWW4HAwDWAE', 1592696701),
(8925, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU5MjkyMjYyOSwiZXhwIjoxNTkyOTI0NDI5LCJwZXJtaXNzaW9uIjoiIn0.K9WO1Fsz08f_xS8kibWo5RBsOunUuElkg5kl-dEYrb0', 1592924429),
(8931, 2075, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc1IiwidXNlcm1haWwiOiJ2ZnJkMDBAdWEucHQiLCJpYXQiOjE1OTI5MzMzNTIsImV4cCI6MTU5MjkzNTE1MiwicGVybWlzc2lvbiI6IiJ9.sIUv_a-_OL0gm8_cq85OKrp1KXVYeK0G3hq-YHa_P8w', 1592935152),
(8937, 1779, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzc5IiwidXNlcm1haWwiOiJwbGNhc2ltaXJvQHVhLnB0IiwiaWF0IjoxNTkyOTYwMDkwLCJleHAiOjE1OTI5NjE4OTAsInBlcm1pc3Npb24iOiIifQ.Eq407-WIK-YJ5hVnbjFucLvKQSqZdLpVJGRT0yT0xos', 1592961890),
(8943, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTkzMDA1NzA1LCJleHAiOjE1OTMwMDc1MDUsInBlcm1pc3Npb24iOiIifQ.7O1fquWsDeW0GpLyR2txD9YeSDj4j7zROOMD6jhbv2Y', 1593007505),
(8946, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1OTMwMDc3NTgsImV4cCI6MTU5MzAwOTU1OCwicGVybWlzc2lvbiI6IiJ9.vZiImH1Pr5YmAZGO46AkKPGG8BFvrCDbQli4-u-r3Rk', 1593009558),
(8949, 1866, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxODY2IiwidXNlcm1haWwiOiJydWljb2VsaG9AdWEucHQiLCJpYXQiOjE1OTMwMDgzMTMsImV4cCI6MTU5MzAxMDExMywicGVybWlzc2lvbiI6IiJ9.kmCTVxzbU0ndKkpgurAqDOcWFtn0Qo4w76iWl9uxJPY', 1593010113),
(8955, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTkzMDE2MzE5LCJleHAiOjE1OTMwMTgxMTksInBlcm1pc3Npb24iOiIifQ.qeNZf-kSDjqc-iZGgnW9HYRSepMTNj5r75iewD2Kt8Q', 1593018119),
(8961, 2039, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM5IiwidXNlcm1haWwiOiJldmFiYXJ0b2xvbWV1QHVhLnB0IiwiaWF0IjoxNTkzMTc2NzQ4LCJleHAiOjE1OTMxNzg1NDgsInBlcm1pc3Npb24iOiIifQ.yFIk_UaNz_q99ZnyUesH0lgh4dE7TUf93VEWVfSIwIw', 1593178548),
(8967, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU5MzE3OTg3NywiZXhwIjoxNTkzMTgxNjc3LCJwZXJtaXNzaW9uIjoiIn0.Aqc2ggwkjJaM2hcGTyKo7S19IZOk8KtAn5XkKFZfZEI', 1593181677),
(8973, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU5MzE4NDkwNSwiZXhwIjoxNTkzMTg2NzA1LCJwZXJtaXNzaW9uIjoiIn0.pDnrYTLbSmLjKaWEaCN64qSUaWrTgVrOw4xaTuLF5Bg', 1593186705),
(8976, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU5MzE4NjkzNywiZXhwIjoxNTkzMTg4NzM3LCJwZXJtaXNzaW9uIjoiIn0.qx5av7PQHlQg0N2I8X03ScglL5P5Bf6tcd1VRsRI8lI', 1593188737),
(8982, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU5MzIxNTkwOSwiZXhwIjoxNTkzMjE3NzA5LCJwZXJtaXNzaW9uIjoiIn0.6foC13JoycP8A06X2z83uWofFMtmx97Q4KSleqi11QE', 1593217709),
(8985, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1OTMyMTc2MzksImV4cCI6MTU5MzIxOTQzOSwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.QUNtrdw6L3vPxBBhG-8MuVetWJs49um3ZvMsShWEOgo', 1593219439),
(8991, 1608, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjA4IiwidXNlcm1haWwiOiJtYXJpYW5hbGFkZWlyb0B1YS5wdCIsImlhdCI6MTU5MzM2MDEzNiwiZXhwIjoxNTkzMzYxOTM2LCJwZXJtaXNzaW9uIjoiIn0.HbVOB13FX9rGNdwt8FaxWfCjenmHqcvUEPRMtBlWsNA', 1593361936),
(8997, 2048, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDQ4IiwidXNlcm1haWwiOiJqb2FvYmVybmFyZG8wQHVhLnB0IiwiaWF0IjoxNTkzNDE5MzMwLCJleHAiOjE1OTM0MjExMzAsInBlcm1pc3Npb24iOiIifQ.zsmfvZm2lqaII1SP1fX_Nn_siwSNkl3T9Ha6k8bUNxA', 1593421130),
(9003, 1767, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzY3IiwidXNlcm1haWwiOiJwZXJlaXJhLmdvbmNhbG9AdWEucHQiLCJpYXQiOjE1OTM0Mzk1MjYsImV4cCI6MTU5MzQ0MTMyNiwicGVybWlzc2lvbiI6IiJ9.eOeXjvSs7oI1OFIYSGpkFwlCY3lo30SBVC3Csp75XJ8', 1593441326),
(9009, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU5MzQ0OTg0NywiZXhwIjoxNTkzNDUxNjQ3LCJwZXJtaXNzaW9uIjoiIn0.3R-p6mB-v0nSk6l8Wz8V5FrGxSPHvg3ZOGpiirxPvvQ', 1593451647),
(9015, 2037, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM3IiwidXNlcm1haWwiOiJkaW9nb3BoY0B1YS5wdCIsImlhdCI6MTU5MzQ1ODA4MywiZXhwIjoxNTkzNDU5ODgzLCJwZXJtaXNzaW9uIjoiIn0.naCP5xBSQCEHJiLKHb3qk4_xKcqexYNPCAkshs0D8IY', 1593459883),
(9021, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU5MzQ3MTcwOSwiZXhwIjoxNTkzNDczNTA5LCJwZXJtaXNzaW9uIjoiIn0.lNEHtDSrtlRzX8QCxBrSbu1c8XdQ5e-_JF72VE5U-Og', 1593473509),
(9027, 2074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc0IiwidXNlcm1haWwiOiJ2aWNlbnRlLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTkzNTEwODQyLCJleHAiOjE1OTM1MTI2NDIsInBlcm1pc3Npb24iOiIifQ.f-892vnUlbDg8BTRzus49HFFwydhiFB2zwlVO3bP4Cw', 1593512642),
(9033, 2074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc0IiwidXNlcm1haWwiOiJ2aWNlbnRlLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTkzNTI4ODc2LCJleHAiOjE1OTM1MzA2NzYsInBlcm1pc3Npb24iOiIifQ.rY0kTFo9zeFeWMTS8IUlk0pB5LKvVe-NJ4u09WhcSW8', 1593530676),
(9039, 2031, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDMxIiwidXNlcm1haWwiOiJkYW5pZWwuZnJhbmNpc2NvQHVhLnB0IiwiaWF0IjoxNTkzNTQzODA2LCJleHAiOjE1OTM1NDU2MDYsInBlcm1pc3Npb24iOiIifQ.xKTpX52VL1FUzHcj9DDSsyhZAt4cCLvn9UocdAMSfM0', 1593545606),
(9042, 2034, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDM0IiwidXNlcm1haWwiOiJkaW5pc2xlaUB1YS5wdCIsImlhdCI6MTU5MzU0NDAwMywiZXhwIjoxNTkzNTQ1ODAzLCJwZXJtaXNzaW9uIjoiIn0.31WbDCzv4pl4kmlxAsoYeOu5btLfWETJisFG4V4NVo8', 1593545803),
(9048, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU5MzU1NzAyNywiZXhwIjoxNTkzNTU4ODI3LCJwZXJtaXNzaW9uIjoiIn0.BQWVgqvAhJllteJFonsyiz2jyxGu38N_-4rOB2joV4I', 1593558827),
(9054, 843, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiI4NDMiLCJ1c2VybWFpbCI6ImFhcm9kcmlndWVzQHVhLnB0IiwiaWF0IjoxNTk0MDUwMDU1LCJleHAiOjE1OTQwNTE4NTUsInBlcm1pc3Npb24iOiIifQ.qV3jByeOxQDs-d31JTF2p8HLueerMG77o64HrzXJtO8', 1594051855),
(9060, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU5NDA2MDgwMywiZXhwIjoxNTk0MDYyNjAzLCJwZXJtaXNzaW9uIjoiIn0.KG8PsLIzcGQBpPPfBBY61h2jq1doASr8aIhT3t7cKXw', 1594062603),
(9066, 2074, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDc0IiwidXNlcm1haWwiOiJ2aWNlbnRlLmNvc3RhQHVhLnB0IiwiaWF0IjoxNTk0MzEwNDUwLCJleHAiOjE1OTQzMTIyNTAsInBlcm1pc3Npb24iOiIifQ.aO3L30qf-iyAFCQ4rhHckGW6AJzVwhqaiTcSrbNA_LM', 1594312250),
(9069, 2065, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDY1IiwidXNlcm1haWwiOiJyYXF1ZWxzZkB1YS5wdCIsImlhdCI6MTU5NDMxMTg3NSwiZXhwIjoxNTk0MzEzNjc1LCJwZXJtaXNzaW9uIjoiIn0.Zec8YCVbAo5vkMqiGZGxOO6SYXMm34-bhq_-73bhuJM', 1594313675),
(9075, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTk0NDY3MjE0LCJleHAiOjE1OTQ0NjkwMTQsInBlcm1pc3Npb24iOiIifQ.IkbPH8dmTVpTXnTSh2oaq5ez4ZdF1q5mkOHPnuGdkjU', 1594469014),
(9087, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTk0NjMyNDY3LCJleHAiOjE1OTQ2MzQyNjcsInBlcm1pc3Npb24iOiIifQ.k8fVAt4enInPiUcgF-3XrRNZdYMtDckPTq9lEwrvG18', 1594634267),
(9093, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTk0NjgzMDU5LCJleHAiOjE1OTQ2ODQ4NTksInBlcm1pc3Npb24iOiIifQ.zkCecrot77VTIYm2FKT58F2Lm783KRuepIO5iOxrvdY', 1594684859),
(9099, 1125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxMTI1IiwidXNlcm1haWwiOiJkZ2N1bmhhQHVhLnB0IiwiaWF0IjoxNTk0NzI0Njc5LCJleHAiOjE1OTQ3MjY0NzksInBlcm1pc3Npb24iOiIifQ.NBUoy65mpG0W7byrPD1irtlt1FmJAfshduxCP592VGU', 1594726479),
(9105, 2027, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDI3IiwidXNlcm1haWwiOiJiZXJuYXJkb2xlYW5kcm8xQHVhLnB0IiwiaWF0IjoxNTk0NzQ1NTgzLCJleHAiOjE1OTQ3NDczODMsInBlcm1pc3Npb24iOiIifQ.eF60MbEt8f55F8ONxatbLaKcSGXO3_YWDiId8jKC84A', 1594747383),
(9111, 2051, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDUxIiwidXNlcm1haWwiOiJtYXJpYW5hcm9zYUB1YS5wdCIsImlhdCI6MTU5NDg0OTU5NywiZXhwIjoxNTk0ODUxMzk3LCJwZXJtaXNzaW9uIjoiIn0.XbxyPFz323bMx80f3Y4KtA0BVDF6yHAZ_m6xBrmJzko', 1594851397),
(9117, 1767, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNzY3IiwidXNlcm1haWwiOiJwZXJlaXJhLmdvbmNhbG9AdWEucHQiLCJpYXQiOjE1OTU0NTg5NDMsImV4cCI6MTU5NTQ2MDc0MywicGVybWlzc2lvbiI6IiJ9.ifir5rMah4a3teNWc5bfOKhhP10JPjsKulmDtwb05H4', 1595460743),
(9123, 1698, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxNjk4IiwidXNlcm1haWwiOiJvcmxhbmRvLm1hY2VkbzE1QHVhLnB0IiwiaWF0IjoxNTk1Nzc2MzU3LCJleHAiOjE1OTU3NzgxNTcsInBlcm1pc3Npb24iOiIifQ.9de1K5zyANEtcNyeqFaRYLQYTS4tpKUJFbGxM53zxkE', 1595778157),
(9129, 2098, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIyMDk4IiwidXNlcm1haWwiOiJsdWlzY2NtYXJ0aW5zODhAdWEucHQiLCJpYXQiOjE1OTgyODE3MTYsImV4cCI6MTU5ODI4MzUxNiwicGVybWlzc2lvbiI6IkRFRkFVTFQifQ.w9xxwk-OmfRn3syzzU9VvZ7nc0ODI9IlECBdw-m43v8', 1598283516);

-- --------------------------------------------------------

--
-- Table structure for table `GenTokensComp`
--

CREATE TABLE `GenTokensComp` (
  `id` int(255) NOT NULL,
  `compid` int(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expire_date` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `GenTokensComp`
--

INSERT INTO `GenTokensComp` (`id`, `compid`, `token`, `expire_date`) VALUES
(4, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0NDkzMSwiZXhwIjoxNTcwNDQ2NzMxLCJwZXJtaXNzaW9uIjoxfQ.mxqJ_Usat0UBsde1qXwaNd6mvpJVuqAN2AwMKCISphk', 1570446731),
(7, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0NDk0MywiZXhwIjoxNTcwNDQ2NzQzLCJwZXJtaXNzaW9uIjoxfQ.zSbTuM2D3BvPTLCZy4hg7BVTppSVVIeYOm0frUlPZOY', 1570446743),
(10, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0NDk0NSwiZXhwIjoxNTcwNDQ2NzQ1LCJwZXJtaXNzaW9uIjoxfQ.I6u6TCjTyxcsyULPNzxL8i2B-siFiUlMm-ZE3pap2_s', 1570446745),
(13, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0NDk0OCwiZXhwIjoxNTcwNDQ2NzQ4LCJwZXJtaXNzaW9uIjoxfQ.GQ4s_rXjm3qZvJS67j-OpjIAKF-2Kp37K71xSKtvXIg', 1570446748),
(16, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0NDk1MCwiZXhwIjoxNTcwNDQ2NzUwLCJwZXJtaXNzaW9uIjoxfQ._HuKhEJAhjZIeX8vkHSMg3zgb7Yp5fPnMzR7FRpNs-s', 1570446750),
(19, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0NDk2MywiZXhwIjoxNTcwNDQ2NzYzLCJwZXJtaXNzaW9uIjoxfQ.wzUsh0ROaRnYYqYufmnFqizzLg4nUnBtVfPIg7LIIeE', 1570446763),
(22, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0NTAwMywiZXhwIjoxNTcwNDQ2ODAzLCJwZXJtaXNzaW9uIjoxfQ.J4arDGKC59DFP6RR9VA_2r0Q0RhHGinjnjDc9FfKDF8', 1570446803),
(25, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0NzQyNCwiZXhwIjoxNTcwNDQ5MjI0LCJwZXJtaXNzaW9uIjoxfQ.NTFW_nufNxjA97vIHGPD5yn7_SUSIOU4XCFKmWuJf3o', 1570449224),
(28, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0Nzc0NywiZXhwIjoxNTcwNDQ5NTQ3LCJwZXJtaXNzaW9uIjoxfQ.yjfP-kRxyMJkfzrS9qW7LA-r84fplOAgz_kra2KeFtw', 1570449547),
(31, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0ODQ3MCwiZXhwIjoxNTcwNDUwMjcwLCJwZXJtaXNzaW9uIjoxfQ.5iuGTKLnlFKkrRVtKUFuqYt3CjfnbtQpYuvF5D8BElU', 1570450270),
(34, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0ODUzNSwiZXhwIjoxNTcwNDUwMzM1LCJwZXJtaXNzaW9uIjoxfQ.EMlqNoNy72L_Wff6Mlo2l7AtzKn5kbSk58HnPgDsIdw', 1570450335),
(37, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0ODc0OSwiZXhwIjoxNTcwNDUwNTQ5LCJwZXJtaXNzaW9uIjoxfQ.HiY30VCzbJ4TnwtZvhH3oSCfGSn6PBHCbAdL61I5jrA', 1570450549),
(40, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0ODc2NywiZXhwIjoxNTcwNDUwNTY3LCJwZXJtaXNzaW9uIjoxfQ.Qjyv7ZdwGFiuue-REdxJ2FUOfimWP5rRh4GUCDBL0Ak', 1570450567),
(43, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0ODc4OSwiZXhwIjoxNTcwNDUwNTg5LCJwZXJtaXNzaW9uIjoxfQ.k4fHveMsEWP44_CtxStUUy3y8gkwHGp4yho9bs-ONAY', 1570450589),
(46, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ0ODg1MiwiZXhwIjoxNTcwNDUwNjUyLCJwZXJtaXNzaW9uIjoxfQ.GLjQBhdYZMnqVaTMtuGeOM0TSuEMaCNsiDOoXWkfNdI', 1570450652),
(52, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ1MjM1NCwiZXhwIjoxNTcwNDU0MTU0LCJwZXJtaXNzaW9uIjoxfQ.-3hb66gJQ1l-iewfjBPt_I9rZH1ldrY7_b3wyQPykLk', 1570454154),
(55, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ1MzkyMywiZXhwIjoxNTcwNDU1NzIzLCJwZXJtaXNzaW9uIjoxfQ.qzCq0r84ssvwVKuAFxH7ePCBiG9HEtSFG0eAvrI9m7g', 1570455723),
(61, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ2OTU0MiwiZXhwIjoxNTcwNDcxMzQyLCJwZXJtaXNzaW9uIjoxfQ.Cr55ZqmnS5f5BrzlZKbTqHWI2_WCrYrsz5oSPfFChsA', 1570471342),
(67, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ4NDI0NywiZXhwIjoxNTcwNDg2MDQ3LCJwZXJtaXNzaW9uIjoxfQ.x9XZud8ZmOghc_CnBY7O-1PnEV_CS5YTBpHGQRH-sBU', 1570486047),
(70, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ4NDI2NCwiZXhwIjoxNTcwNDg2MDY0LCJwZXJtaXNzaW9uIjoxfQ.EgMKO-bKeLNJwwPcAtia7LDBcCEyvQVdyC0pkC8aO4M', 1570486064),
(73, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ4NTQwOCwiZXhwIjoxNTcwNDg3MjA4LCJwZXJtaXNzaW9uIjoxfQ.kkclBT8LugH0CcuqNym1SCgPzfz119DDhM3VAkMwF5s', 1570487208),
(76, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ4NjM3MiwiZXhwIjoxNTcwNDg4MTcyLCJwZXJtaXNzaW9uIjoxfQ.rRIKZdxhsiyzi-uPjFCX-19UkwAznBworwt27q_swnM', 1570488172),
(79, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ4ODAxMywiZXhwIjoxNTcwNDg5ODEzLCJwZXJtaXNzaW9uIjoxfQ.s43BRm-XMPGmSOmRY1az8nm0bLuZUuma7pq6wfPQWmI', 1570489813),
(82, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ4ODA1NSwiZXhwIjoxNTcwNDg5ODU1LCJwZXJtaXNzaW9uIjoxfQ.URHFQEBvWZ6PpK2GX7t2IZl2PK70R__zbkTAt4M6JY8', 1570489855),
(85, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ5MTkwNCwiZXhwIjoxNTcwNDkzNzA0LCJwZXJtaXNzaW9uIjoxfQ.bf9k_S8lbNSnzgeX01fAbbt8LdAj3PkbDevDpubGfko', 1570493704),
(88, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ5MTkxMCwiZXhwIjoxNTcwNDkzNzEwLCJwZXJtaXNzaW9uIjoxfQ.capX59Y7vbrLdfeZoI0whAEF98T4OZne4brepIfVYPo', 1570493710),
(91, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ5MjUwMSwiZXhwIjoxNTcwNDk0MzAxLCJwZXJtaXNzaW9uIjoxfQ.jqSYVPmkftDWnuvxr6Nm9sMRBpx29YtNh6u-NZIhSZY', 1570494301),
(94, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDQ5NDEwMiwiZXhwIjoxNTcwNDk1OTAyLCJwZXJtaXNzaW9uIjoxfQ.Iq1bIR2kDmrYPPfBSEooXjdbg2u4yrg52WCaKCxCQZk', 1570495902),
(100, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDUyNDQyNiwiZXhwIjoxNTcwNTI2MjI2LCJwZXJtaXNzaW9uIjoxfQ.GNcyIDES7ksziDHar6Hi6kw8kIhp3O3pf4NPxUthYtQ', 1570526226),
(103, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDUyNjU0NiwiZXhwIjoxNTcwNTI4MzQ2LCJwZXJtaXNzaW9uIjoxfQ.qlMCYeYRhcMedQPyl9p-DE62OooC-4Rn9G_4b8P7Y-g', 1570528346),
(106, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDUyNzUzNCwiZXhwIjoxNTcwNTI5MzM0LCJwZXJtaXNzaW9uIjoxfQ.x1jWLKs6HV38mxKLwIBPnonJ2rKQg9bOCFyBSPa9YEI', 1570529334),
(109, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDUyNzk4MSwiZXhwIjoxNTcwNTI5NzgxLCJwZXJtaXNzaW9uIjoxfQ.80C7-sbs41CwtqMu27znTSWxdKaTsfYIZSv0tKQs0e8', 1570529781),
(112, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDUyODAzMCwiZXhwIjoxNTcwNTI5ODMwLCJwZXJtaXNzaW9uIjoxfQ.Pfm4LX3fNTKdliuzSp4UxQ3wULw1-E8UpC_OWkGpR6g', 1570529830),
(115, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDUyODI1MiwiZXhwIjoxNTcwNTMwMDUyLCJwZXJtaXNzaW9uIjoxfQ.DBAQ0FnDYhfiaiW62IduoczKpafz3DEUesd8TYasFZo', 1570530052),
(118, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDUyODQzOSwiZXhwIjoxNTcwNTMwMjM5LCJwZXJtaXNzaW9uIjoxfQ.qU5a1CdDOeaG8n5TftpIUy5lQDlzU5NysrnJy868stI', 1570530239),
(121, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDUyODUzNiwiZXhwIjoxNTcwNTMwMzM2LCJwZXJtaXNzaW9uIjoxfQ.grLn86Rdg6w423PxaVIqERPpJVrj8w1lDGUugkqx2Eg', 1570530336),
(124, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDUyODU1NiwiZXhwIjoxNTcwNTMwMzU2LCJwZXJtaXNzaW9uIjoxfQ.0XY-UVvTRqDEFwAejWmB_cmVeS1WtWmmPYy8Iftbjhk', 1570530356),
(130, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDUzMzM1OCwiZXhwIjoxNTcwNTM1MTU4LCJwZXJtaXNzaW9uIjoxfQ.ljGenBDMr_3k7zY_8gB5AacKR0CDkGq-xurZRLpZqbM', 1570535158),
(133, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDUzNTE5MSwiZXhwIjoxNTcwNTM2OTkxLCJwZXJtaXNzaW9uIjoxfQ.xM1dQ5EQXcH1cyVTaDBcWsR8ChVYIW55C_JWQOHX6i4', 1570536991),
(136, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDUzNTE5OSwiZXhwIjoxNTcwNTM2OTk5LCJwZXJtaXNzaW9uIjoxfQ.LU-hC3S3CPUEb50WZx0-46Ptg2lwkbcDAAYPT1p48iQ', 1570536999),
(139, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDUzNTQ5OCwiZXhwIjoxNTcwNTM3Mjk4LCJwZXJtaXNzaW9uIjoxfQ.LgMRYUFPbI7gZqgOXfVIJy7fFPjWnUqsz-VdRHyLveo', 1570537298),
(145, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU0MDYwOSwiZXhwIjoxNTcwNTQyNDA5LCJwZXJtaXNzaW9uIjoxfQ.jUAsp0O1Ffa7n2u2m2mWnch6OtSxgsPQ0bWGaQJk4d4', 1570542409),
(151, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU0NTI3MSwiZXhwIjoxNTcwNTQ3MDcxLCJwZXJtaXNzaW9uIjoxfQ.qNGNOzwXSUr1jOPktRYI1jXXSjMUHGeJdgBpPDOiAVM', 1570547071),
(157, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU0ODM3MiwiZXhwIjoxNTcwNTUwMTcyLCJwZXJtaXNzaW9uIjoxfQ.OgvfiOzq7acnoUKui99ikzUru_Upo7q0PiuQAvVDU7A', 1570550172),
(163, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU1MTcxNywiZXhwIjoxNTcwNTUzNTE3LCJwZXJtaXNzaW9uIjoxfQ.GrtX5cHxLiGfpe7wxdhed0g59ETbOhGdYYtNZwfxC5g', 1570553517),
(166, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU1MTg5MiwiZXhwIjoxNTcwNTUzNjkyLCJwZXJtaXNzaW9uIjoxfQ.k2bBQMZTRU7NFJwRJCyJ_KD_fj-xmit4QgZw1cX9Mps', 1570553692),
(169, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU1MjU4OSwiZXhwIjoxNTcwNTU0Mzg5LCJwZXJtaXNzaW9uIjoxfQ.seB2xdDYCR4ALj49DoTzMkSTMn01-_Odys9trjzw390', 1570554389),
(172, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU1NDI1NiwiZXhwIjoxNTcwNTU2MDU2LCJwZXJtaXNzaW9uIjoxfQ.k9PbPXhIe1izWDjHVc2RDBaZGeZ_st_JsQEKiZ8eQSM', 1570556056),
(175, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU1NDM5NSwiZXhwIjoxNTcwNTU2MTk1LCJwZXJtaXNzaW9uIjoxfQ.HzZ7XdcSvdOg_CvhVoRSj_p3c2kHL8-sueajTNn97ZI', 1570556195),
(178, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU1NDUxMCwiZXhwIjoxNTcwNTU2MzEwLCJwZXJtaXNzaW9uIjoxfQ.5J4xwoPHm8_bLjO-FvUN76_mQm5kj9lc69ljA3oDxl8', 1570556310),
(181, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU1NTIyNCwiZXhwIjoxNTcwNTU3MDI0LCJwZXJtaXNzaW9uIjoxfQ.VDjmwPLBuNyAfpJTjQsfEFEGQBfQKZKRP4UYUY5swhk', 1570557024),
(184, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU1NTQ0NiwiZXhwIjoxNTcwNTU3MjQ2LCJwZXJtaXNzaW9uIjoxfQ.juTVAUlFzl0NOS53kCjRoRm1SA8g5V49P9ERXQWRqK8', 1570557246),
(187, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU1NTcxNCwiZXhwIjoxNTcwNTU3NTE0LCJwZXJtaXNzaW9uIjoxfQ.Zof57KIx0BfZbW9VNqaiFSJGS6B5GvlpatL7JddeBJc', 1570557514),
(190, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU1NTcyOSwiZXhwIjoxNTcwNTU3NTI5LCJwZXJtaXNzaW9uIjoxfQ.NZPlx10OOl14IXpo9cYfyUo_PRena4jsjNqRdWouC20', 1570557529),
(196, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU3MjE3NiwiZXhwIjoxNTcwNTczOTc2LCJwZXJtaXNzaW9uIjoxfQ.vCYZ5BzHUyZ61xhbU3TiLn02wW9ZE8zzbgrwi7UsklU', 1570573976),
(199, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU3MjM1OCwiZXhwIjoxNTcwNTc0MTU4LCJwZXJtaXNzaW9uIjoxfQ.7vZDGcf2TFeBbZdpQFHQT4DeuoDU9EEc1D0IFABSaCs', 1570574158),
(202, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDU3NDU0MiwiZXhwIjoxNTcwNTc2MzQyLCJwZXJtaXNzaW9uIjoxfQ.8IyJe63YMzG9r-I_9dHVSe69fExAVYukmp6vhF9hgZI', 1570576342),
(208, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYxNjExNywiZXhwIjoxNTcwNjE3OTE3LCJwZXJtaXNzaW9uIjoxfQ.Xo0qu9K-1KTnp2qsij0bCdHfa308uPIJbfcWicMzmbU', 1570617917),
(211, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYxNjc4MiwiZXhwIjoxNTcwNjE4NTgyLCJwZXJtaXNzaW9uIjoxfQ.E-dZN6YzQ13OF6W70hW-lbec8F_3ODvWjpZRVkK43j4', 1570618582),
(217, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYxOTE1NSwiZXhwIjoxNTcwNjIwOTU1LCJwZXJtaXNzaW9uIjoxfQ.aCkWIoGQwPP9Qb6-9FVdD8IoXxalUmRy6_vSB2MMqxQ', 1570620955),
(220, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYxOTI1OCwiZXhwIjoxNTcwNjIxMDU4LCJwZXJtaXNzaW9uIjoxfQ.vzauSmsLmQ5c19kGdsCf_ZhYrTQW71YOJSgJAwXKjb4', 1570621058),
(223, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYxOTk0NiwiZXhwIjoxNTcwNjIxNzQ2LCJwZXJtaXNzaW9uIjoxfQ.hv_Me5XW9NSouHyXR6gMKkZ_AM0wHCwnSh0S1rKvnfU', 1570621746),
(226, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYxOTk5NSwiZXhwIjoxNTcwNjIxNzk1LCJwZXJtaXNzaW9uIjoxfQ.Dz0iMEHCgYwgGYkkClPbVi1wJx0mYKkGQSoZzFRc3Xs', 1570621795),
(229, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYyMDU4OCwiZXhwIjoxNTcwNjIyMzg4LCJwZXJtaXNzaW9uIjoxfQ.7qM65baNmNjUNz_HjuOnQXp-VNcs9nF55DfXBVsTY6Y', 1570622388),
(235, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYyNTUxMCwiZXhwIjoxNTcwNjI3MzEwLCJwZXJtaXNzaW9uIjoxfQ.FclqSzKz2tVcI42NE_4b-IGzJaE--yRdu2bf1Y7QlKg', 1570627310),
(238, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYyNTk1MiwiZXhwIjoxNTcwNjI3NzUyLCJwZXJtaXNzaW9uIjoxfQ.S4iDKhWjILfh5aIh0MGqNmh_ClrCe7c_dKfZZRDD_Wc', 1570627752),
(241, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYyNTk3NSwiZXhwIjoxNTcwNjI3Nzc1LCJwZXJtaXNzaW9uIjoxfQ.IZEgsxyYW-r4qPCtxF89czjH6Y53WQSb9EaCgKNLmfg', 1570627775),
(244, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYyNjE0MiwiZXhwIjoxNTcwNjI3OTQyLCJwZXJtaXNzaW9uIjoxfQ.3EUOHNqLUZzhAUFbu5G0TTUK6Alrioz6gcOiwXqfnR8', 1570627942),
(247, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYyNjE3NCwiZXhwIjoxNTcwNjI3OTc0LCJwZXJtaXNzaW9uIjoxfQ.pziDWMkjwBxVOei1Vhplslzomen8VZITzA5jZSs7MVE', 1570627974),
(250, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYyNjM1MywiZXhwIjoxNTcwNjI4MTUzLCJwZXJtaXNzaW9uIjoxfQ.2Ta1B6GPIV2ZcYVnMbCIz0XUUYs0m5d2zFSZRVPuYF8', 1570628153),
(253, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYyNjU1MCwiZXhwIjoxNTcwNjI4MzUwLCJwZXJtaXNzaW9uIjoxfQ.m8fWEHrxC3NkAHnLf59xRncjf0aVjFMUhAnsYvSwOmw', 1570628350),
(259, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYyOTkxMCwiZXhwIjoxNTcwNjMxNzEwLCJwZXJtaXNzaW9uIjoxfQ.qeXP_y1aPxp1p-88BxN_xpqwX0f-v3292t7K9pZDB14', 1570631710),
(262, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYyOTk4MiwiZXhwIjoxNTcwNjMxNzgyLCJwZXJtaXNzaW9uIjoxfQ.vWZnFkBpxE6WjxxmWdvRAbJq9NqzzUz8h5dNV2YWncI', 1570631782),
(265, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYzMDE3MCwiZXhwIjoxNTcwNjMxOTcwLCJwZXJtaXNzaW9uIjoxfQ.Z7l6uaBvXmThGgX9wBvJr4wYxcvtGwi1LwCSwZ9SC_g', 1570631970),
(268, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYzMDI0MywiZXhwIjoxNTcwNjMyMDQzLCJwZXJtaXNzaW9uIjoxfQ.QBRbhBsNVPiopNmsDH7iCPuvPo7HclgX_GD9Us8fj8Y', 1570632043),
(271, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDYzMDkzOCwiZXhwIjoxNTcwNjMyNzM4LCJwZXJtaXNzaW9uIjoxfQ.LQfbw1sehMR2Hja1TVaZD3dkiFigk2JKz0YimemhDfs', 1570632738),
(277, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0MTc5MSwiZXhwIjoxNTcwNjQzNTkxLCJwZXJtaXNzaW9uIjoxfQ.F1G-Z0nYQk9dhK7Pct7LebD65Nyan75Qx6YS9GDnP8o', 1570643591),
(280, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0MTg4NywiZXhwIjoxNTcwNjQzNjg3LCJwZXJtaXNzaW9uIjoxfQ.pQjBx2y7m2HGSMo-FG9wjfc7Dxc6o4ilQdQHfvLORbo', 1570643687),
(286, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0NjA5NCwiZXhwIjoxNTcwNjQ3ODk0LCJwZXJtaXNzaW9uIjoxfQ.EMM6EtM_bBgNc-9eM7Fd0hbdBj8QfpKmiT49Y6q6fVM', 1570647894),
(289, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0NjQ5NiwiZXhwIjoxNTcwNjQ4Mjk2LCJwZXJtaXNzaW9uIjoxfQ.kNSv0X3yMPDT7e8FfMfPCnwKWsmqN-GKqzpSQuiDV2I', 1570648296),
(292, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0ODI5MywiZXhwIjoxNTcwNjUwMDkzLCJwZXJtaXNzaW9uIjoxfQ.YTgfk8W4-4Rb7RnHXcSynboiVEgfRFPHNDcZN7VfUIo', 1570650093),
(295, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0ODMxNCwiZXhwIjoxNTcwNjUwMTE0LCJwZXJtaXNzaW9uIjoxfQ.YUWkbx-yHYKN1DQqRqot31AOa1nCEQKQ9qYE3tTml9E', 1570650114),
(298, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0ODQ1NSwiZXhwIjoxNTcwNjUwMjU1LCJwZXJtaXNzaW9uIjoxfQ.a3WRhnc0Ao6tX1cgyPpAAOOqtscS3mqSffT-L1H2G_Y', 1570650255),
(301, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0ODUxMywiZXhwIjoxNTcwNjUwMzEzLCJwZXJtaXNzaW9uIjoxfQ.thx7TK6kDVrlODfugQMFSzrF0SF8c4CmV79aspDPrJI', 1570650313),
(304, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0ODUyMywiZXhwIjoxNTcwNjUwMzIzLCJwZXJtaXNzaW9uIjoxfQ.jOf8WSgTzsYnFvGN94eaxEHVkK-KXO1h5HIY57LfrBE', 1570650323),
(307, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0ODU0NCwiZXhwIjoxNTcwNjUwMzQ0LCJwZXJtaXNzaW9uIjoxfQ.WjQdaYTsILbBUFOAvBH5HpRzV1twMOIiz3B4xAkHCMA', 1570650344),
(310, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0ODU3MCwiZXhwIjoxNTcwNjUwMzcwLCJwZXJtaXNzaW9uIjoxfQ.G-Bny7RnVZ8rmaVIDW4uHTYvmtlL-fQDVIdhBVArveU', 1570650370),
(313, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0ODYyNSwiZXhwIjoxNTcwNjUwNDI1LCJwZXJtaXNzaW9uIjoxfQ.7hN_DhUkEx9bw-FjSv4p4HHDypWW_GEx9SehK6xlqgM', 1570650425),
(316, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0ODY0NCwiZXhwIjoxNTcwNjUwNDQ0LCJwZXJtaXNzaW9uIjoxfQ.dGuPceoaL0eXW2vg77iR2wIQG0UwfTP3Q0WIm2x6fEo', 1570650444),
(319, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY0ODcxMiwiZXhwIjoxNTcwNjUwNTEyLCJwZXJtaXNzaW9uIjoxfQ.MwGpmzFENpHap-WI8YqjjN_utxUPTyX6ejZei2XKoB4', 1570650512),
(322, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY1MDEwNywiZXhwIjoxNTcwNjUxOTA3LCJwZXJtaXNzaW9uIjoxfQ.1wCk1i_fqnRdA9F42WO47EXBBc93SJSEKBL2U20l97g', 1570651907),
(325, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY1MDE4NywiZXhwIjoxNTcwNjUxOTg3LCJwZXJtaXNzaW9uIjoxfQ.PQXE02IXpXocc6ri9JXEfLNqSK1p_0n_xZjdwla9TL4', 1570651987),
(328, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY1MDIwNywiZXhwIjoxNTcwNjUyMDA3LCJwZXJtaXNzaW9uIjoxfQ.TG-TAyo89qTKw-MQ-5w-Hgw60Dv8EFQvlnW2pSkRTuc', 1570652007),
(331, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY1MDI2NiwiZXhwIjoxNTcwNjUyMDY2LCJwZXJtaXNzaW9uIjoxfQ.4yfEYhL3QXnrzVK9c6tD6BW1bAW1g4BXDkLq26h7dhw', 1570652066),
(334, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY1MDI4MywiZXhwIjoxNTcwNjUyMDgzLCJwZXJtaXNzaW9uIjoxfQ.HxtxtGxc6MY5ZCefSk2VWA_gObVaODwGHOgkbogfaE8', 1570652083),
(337, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY1MDQxNywiZXhwIjoxNTcwNjUyMjE3LCJwZXJtaXNzaW9uIjoxfQ.zUozT3FMgJyiEPKCblkxHJtHD7aSLFvioEjd7YNF35A', 1570652217),
(340, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY1MDk0NCwiZXhwIjoxNTcwNjUyNzQ0LCJwZXJtaXNzaW9uIjoxfQ.vEoq82iF0E6dnPi2HPCbY6qtdSChAfxUD6iHS1AYGuE', 1570652744),
(343, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY1MTAyMSwiZXhwIjoxNTcwNjUyODIxLCJwZXJtaXNzaW9uIjoxfQ.aI9xOCVZeNgzzqhhaqDhekZ00SCmY7GnpLJCaE2Fuf0', 1570652821),
(346, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY1MTExNCwiZXhwIjoxNTcwNjUyOTE0LCJwZXJtaXNzaW9uIjoxfQ.ay2L6dksyVJQoEtY6kpd7emOT4W_iax_gvhJWw6CoXg', 1570652914),
(349, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY1MTE1OCwiZXhwIjoxNTcwNjUyOTU4LCJwZXJtaXNzaW9uIjoxfQ.d_V4g84eK8J3M3Ip5pPJoHm6sIwR0WRfjMcE62S7Juk', 1570652958),
(352, 4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY1MTI2OCwiZXhwIjoxNTcwNjUzMDY4LCJwZXJtaXNzaW9uIjoxfQ.Qcj1-9BgwwuVy8wl3YHVVlWXQ6UgeIPnxJRR2P0JObQ', 1570653068),
(355, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY1MTUzOSwiZXhwIjoxNTcwNjUzMzM5LCJwZXJtaXNzaW9uIjoxfQ.Q-y_5xkkzheSHnXsT_FHt378ctR1aaxulAa2CdmyCF0', 1570653339),
(358, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY1MTU1MywiZXhwIjoxNTcwNjUzMzUzLCJwZXJtaXNzaW9uIjoxfQ.4F9v71YXOCqNVQ9MJd_0oUzuTu2V0wB0qlSd0pXvPwg', 1570653353),
(364, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY5ODM4OSwiZXhwIjoxNTcwNzAwMTg5LCJwZXJtaXNzaW9uIjoxfQ.ZatYrW_ecR2xD9ty3mLWtJ8bTfIbI_tTURiuV4WrfIk', 1570700189),
(367, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDY5ODY5MSwiZXhwIjoxNTcwNzAwNDkxLCJwZXJtaXNzaW9uIjoxfQ.s0n0wRWNSxsi-Lwh0RDwgK6rfKvEa0AlR7eAvFpd7FM', 1570700491),
(373, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDcyMDQ0NywiZXhwIjoxNTcwNzIyMjQ3LCJwZXJtaXNzaW9uIjoxfQ.-DKboZ8sj_adL5csHn-gqs7oT7oYQ17LhFn5S-cjEEk', 1570722247),
(376, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDcyMTk5OCwiZXhwIjoxNTcwNzIzNzk4LCJwZXJtaXNzaW9uIjoxfQ.2Ms8kJW6IshoHPsqia8xhM7yeUMhcABsdp1-srhfKeI', 1570723798),
(382, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDczMjY4MCwiZXhwIjoxNTcwNzM0NDgwLCJwZXJtaXNzaW9uIjoxfQ.qjYE1a6YbQ9wO9bIOpdYKBcfGZzIMG-wwY3bCMPvODY', 1570734480),
(388, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDc4NzQ5NCwiZXhwIjoxNTcwNzg5Mjk0LCJwZXJtaXNzaW9uIjoxfQ.JpK64YBJuHS1iMrV21G1pFa5GAzecZ7NWJPrmbNXZB8', 1570789294),
(394, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDc4OTIyMCwiZXhwIjoxNTcwNzkxMDIwLCJwZXJtaXNzaW9uIjoxfQ.-nc4fcIMBgHhxsUro3Oamh8Ia5wohZLiioGopNtAFKs', 1570791020),
(400, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDc5MTgyMiwiZXhwIjoxNTcwNzkzNjIyLCJwZXJtaXNzaW9uIjoxfQ.tc7lNVnY5hrHiGkJ1wmiKHWHOZLoeAG0pPdILPTDYmc', 1570793622),
(403, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDc5MjQ2OSwiZXhwIjoxNTcwNzk0MjY5LCJwZXJtaXNzaW9uIjoxfQ.EJyWQk4M2CHrm7HHTXIORwhWfFAhG15qHifQ7UlyFRw', 1570794269),
(409, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MDgxOTUyMCwiZXhwIjoxNTcwODIxMzIwLCJwZXJtaXNzaW9uIjoxfQ.5-jPMe4Tyl0ejPsoEr5WhQAzL0jH4lNhvagg1Cq-VVE', 1570821320),
(415, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MTA3NTk2MiwiZXhwIjoxNTcxMDc3NzYyLCJwZXJtaXNzaW9uIjoxfQ.D4OTnF8XF0ND7qXJA_rhbx8dUTGZL16b_kW0rPmZeKM', 1571077762),
(418, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MTA3NzM2MiwiZXhwIjoxNTcxMDc5MTYyLCJwZXJtaXNzaW9uIjoxfQ.mUgJtauq08VBTqcMRM0Z-lUERvj3bJOvARBr_WUg3pI', 1571079162),
(424, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MTIyMDY3NSwiZXhwIjoxNTcxMjIyNDc1LCJwZXJtaXNzaW9uIjoxfQ.3nsPZhKJSPzijb6XLb-ZG6o1SlkV9w7Rbw5_7gN24o0', 1571222475),
(430, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MTIyNDk0NywiZXhwIjoxNTcxMjI2NzQ3LCJwZXJtaXNzaW9uIjoxfQ.MrLsOUkmtrRCFJvmCW4f30nO8Spdp4eshtMmx0ma5T8', 1571226747),
(436, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MTI0ODM5NiwiZXhwIjoxNTcxMjUwMTk2LCJwZXJtaXNzaW9uIjoxfQ.8-nyDuoJL_SvsvGpLF04cQKyXDJbE6gUyjKFEzK0WEo', 1571250196),
(439, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MTI0OTI1MywiZXhwIjoxNTcxMjUxMDUzLCJwZXJtaXNzaW9uIjoxfQ.L6zhEZYQuCpmDYPDtxcyXdxYh3zsGjVFbYyZ4U5I5Bo', 1571251053),
(445, 10, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiTWlndWVsIFNhcm1lbnRvIiwiY29tcG1haWwiOiJtaWd1ZWwuc2FybWVudG9Ac3lvbmUuY29tIiwiaWF0IjoxNTcxMzA2NDYwLCJleHAiOjE1NzEzMDgyNjAsInBlcm1pc3Npb24iOjF9.S_aolNGYOj_GX7KDftI3HVkzIC5yvdPyXsoheS5bp6M', 1571308260),
(448, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MTMwNjYyMCwiZXhwIjoxNTcxMzA4NDIwLCJwZXJtaXNzaW9uIjoxfQ._1zr7UMLPyTv-3mmI04JNSJiRC-rRRAV0RiGk4odVkY', 1571308420),
(454, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MTM5NjI0NSwiZXhwIjoxNTcxMzk4MDQ1LCJwZXJtaXNzaW9uIjoxfQ.8MRa7SYkh1fguKfYScRZD_Oxz2--_X2RfssjP5gauxY', 1571398045),
(460, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3MTc2MDM3MiwiZXhwIjoxNTcxNzYyMTcyLCJwZXJtaXNzaW9uIjoxfQ._5WH06yAKtyBmUh3JeMbV7uZv9woQdUJ3RsVLFGk9ko', 1571762172),
(466, 10, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiTWlndWVsIFNhcm1lbnRvIiwiY29tcG1haWwiOiJtaWd1ZWwuc2FybWVudG9Ac3lvbmUuY29tIiwiaWF0IjoxNTcyMDE4MjQ3LCJleHAiOjE1NzIwMjAwNDcsInBlcm1pc3Npb24iOjF9.s5923_Q7B3JPpnZdGvimAzTML5-qFTiUWyZLPz6ajnU', 1572020047),
(469, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub21lIjoiQWRtaW4iLCJjb21wbWFpbCI6Im5laUBhYXVhdi5wdCIsImlhdCI6MTU3NTY2NjA0MywiZXhwIjoxNTc1NjY3ODQzLCJwZXJtaXNzaW9uIjoxfQ.Pvi9c4YNhhUwpVwfYQSOVyBGjrK7Pol-rCnjPpcbMTA', 1575667843);

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

CREATE TABLE `history` (
  `moment` date NOT NULL,
  `title` varchar(120) DEFAULT NULL,
  `body` text,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `history`
--

INSERT INTO `history` (`moment`, `title`, `body`, `image`) VALUES
('2018-04-30', 'Elaboração de Candidatura para o Encontro Nacional de Estudantes de Informática 2019', 'Entrega de uma candidatura conjunta (NEI+AETTUA) para a organização do Encontro Nacional de Estudantes de Informática 2019. Esta candidatura teve a concorrência de uma candidatura conjunta do ISCAC Junior Solutions e Junisec, constituída por alunos do Politécnico de Coimbra, que acabaram por ser a candidatura vencedora.', '/history/20180430.png'),
('2019-03-09', '1ª Edição ThinkTwice', 'A primeira edição do evento, realizada em 2019, teve lugar no Auditório Mestre Hélder Castanheira da Universidade de Aveiro e contou com uma duração de 24 horas para a resolução de 30 desafios colocados, que continham diferentes graus de dificuldade. O evento contou com a participação de 34 estudantes, perfazendo um total de 12 equipas.', '/history/20190309.jpg'),
('2019-06-12', '2º Lugar Futsal', 'Num jogo em que se fizeram das tripas coração, o NEI defrontou a equipa de EGI num jogo que veio a perder, foi um jogo bastante disputado, contudo, acabou por ganhar EGI remetendo o NEI para o 2º lugar.', '/history/20190612.jpg'),
('2019-06-30', 'Candidatura ENEI 2020', 'Entrega de uma candidatura conjunta (NEI+NEECT+AETTUA) para a organização do Encontro Nacional de Estudantes de Informática 2019. Esta candidatura teve a concorrência de uma candidatura conjunta da CESIUM, constituída por alunos da Universidade do Minho, que acabaram por ser a candidatura vencedora.', '/history/20190630.png'),
('2020-03-06', '2ª Edição ThinkTwice', 'A edição de 2020 contou com a participação de 57 participantes divididos em 19 equipas, com 40 desafios de algoritmia de várias dificuldades para serem resolvidos em 40 horas, tendo lugar nas instalações da Casa do Estudante da Universidade de Aveiro. Esta edição contou ainda com 2 workshops e um momento de networking com as empresas patrocinadoras do evento.', '/history/20200306.jpg'),
('2021-05-07', '3ª Edição ThinkTwice', 'Devido ao contexto pandémico que se vivia a 3ª edição foi 100% online através de plataformas como o Discord e a Twitch, de 7 a 9 de maio. Nesta edição as 11 equipas participantes puderam escolher participar em uma de três tipos de competição: desafios de algoritmia, projeto de gamificação e projeto de cibersegurança. O evento contou ainda com 4 workshops e uma sessão de networking com as empresas patrocinadoras.', '/history/20210507.png');

-- --------------------------------------------------------

--
-- Table structure for table `jogos_tacaua`
--

CREATE TABLE `jogos_tacaua` (
  `id` int(11) NOT NULL,
  `idModalidade` int(11) NOT NULL,
  `idEquipaCasa` int(11) NOT NULL,
  `idEquipaFora` int(11) NOT NULL,
  `golosCasa` int(11) NOT NULL DEFAULT '0',
  `golosFora` int(11) NOT NULL DEFAULT '0',
  `jornada` int(11) NOT NULL,
  `data` text NOT NULL,
  `fc` int(11) DEFAULT NULL,
  `fase` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Links`
--

CREATE TABLE `Links` (
  `id` int(255) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `link` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Links`
--

INSERT INTO `Links` (`id`, `nome`, `link`) VALUES
(1, 'T-shirt', 'https://docs.google.com/forms/d/e/1FAIpQLScaS36JNqd-LMbllFmjrUZyHwrtV9kCaemLDlyEiFwD24YYdw/viewform?usp=send_form'),
(2, 'Guia2019', 'https://nei.web.ua.pt/upload/Guias_Sobrevivencia/2019.pdf'),
(3, 'taca19', 'https://docs.google.com/forms/d/e/1FAIpQLScJHg7usV7EiMYiDhkNdgGKBuBtz0sv6dVE2V8l_k0rRSuIbg/viewform?usp=send_form'),
(4, 'aluvioes19', 'https://www.facebook.com/groups/2765476590131837/'),
(5, 'insta', 'https://www.instagram.com/nei.aauav/'),
(6, 'face', 'https://www.facebook.com/nei.aauav/'),
(7, 'cinema', 'https://docs.google.com/forms/d/e/1FAIpQLSdjAp4iP0oOW76ctfzXeqHXC2ncBS2GvTOGke9KdpWGubr1kg/viewform'),
(8, 'codigo', 'https://nei.web.ua.pt/upload/faina/CodigoFaina.pdf'),
(10, 'rally', 'https://nei.web.ua.pt/upload/NEI/Regulamento.pdf'),
(16, 'irally', 'https://forms.gle/WYennag21QQpXM6e9'),
(22, 'fp', 'https://www.facebook.com/events/493810694797695/'),
(24, 'workshopCV', 'https://forms.gle/aoZrkSWWKmcJcQKj8'),
(27, '2fp19', 'https://github.com/NEI-AAUAV/2_Sessao_FP2019'),
(29, 'rac19', 'https://nei.web.ua.pt/upload/documents/RAC/2019/RAC_NEI2019.pdf');

-- --------------------------------------------------------

--
-- Table structure for table `merchandisings`
--

CREATE TABLE `merchandisings` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `price` double NOT NULL,
  `number_of_items` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `merchandisings`
--

INSERT INTO `merchandisings` (`id`, `name`, `image`, `price`, `number_of_items`) VALUES
(2, 'Emblema de curso', '/merch/emblema.png', 2.5, 125),
(10, 'Cachecol de curso', '', 3.5, 0),
(13, 'Casaco de curso', '/merch/casaco.png', 16.5, 0),
(16, 'Sweat de curso', '/merch/sweat.png', 18, 0),
(19, 'Emblema NEI', '/merch/emblemanei.png', 2.25, 0);

-- --------------------------------------------------------

--
-- Table structure for table `modalidades_tacaua`
--

CREATE TABLE `modalidades_tacaua` (
  `id` int(11) NOT NULL,
  `modalidade` text NOT NULL,
  `tipo_modalidade` enum('COLETIVA','INDIVIDUAL') NOT NULL,
  `ano_letivo` text NOT NULL,
  `divisao` int(11) NOT NULL,
  `grupo` text,
  `pontos_vitoria` int(11) NOT NULL,
  `pontos_empate` int(11) DEFAULT NULL,
  `pontos_derrota` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `modalidades_tacaua`
--

INSERT INTO `modalidades_tacaua` (`id`, `modalidade`, `tipo_modalidade`, `ano_letivo`, `divisao`, `grupo`, `pontos_vitoria`, `pontos_empate`, `pontos_derrota`) VALUES
(19, 'Andebol', 'COLETIVA', '2018/2019', 1, 'A', 3, 2, 1),
(20, 'Andebol', 'COLETIVA', '2018/2019', 1, 'B', 3, 2, 1),
(21, 'Basquetebol Feminino', 'COLETIVA', '2018/2019', 1, NULL, 2, NULL, 1),
(22, 'Basquetebol Masculino', 'COLETIVA', '2018/2019', 1, NULL, 2, NULL, 1),
(23, 'Basquetebol Masculino', 'COLETIVA', '2018/2019', 2, NULL, 2, NULL, 1),
(24, 'Futsal Feminino', 'COLETIVA', '2018/2019', 1, 'A', 3, 2, 1),
(25, 'Futsal Feminino', 'COLETIVA', '2018/2019', 1, 'B', 3, 2, 1),
(26, 'Futsal Masculino', 'COLETIVA', '2018/2019', 1, NULL, 3, 2, 1),
(27, 'Futsal Masculino', 'COLETIVA', '2018/2019', 2, 'A', 3, 2, 1),
(28, 'Futsal Masculino', 'COLETIVA', '2018/2019', 2, 'B', 3, 2, 1),
(29, 'Futebol 7', 'COLETIVA', '2018/2019', 1, 'I', 3, 2, 1),
(30, 'Futebol 7', 'COLETIVA', '2018/2019', 1, 'II', 3, 2, 1),
(31, 'Futebol 7', 'COLETIVA', '2018/2019', 1, 'III', 3, 2, 1),
(32, 'Voleibol Feminino', 'COLETIVA', '2018/2019', 1, NULL, 2, NULL, 1),
(33, 'Voleibol Feminino', 'COLETIVA', '2018/2019', 2, 'A', 2, NULL, 1),
(34, 'Voleibol Feminino', 'COLETIVA', '2018/2019', 2, 'B', 2, NULL, 1),
(35, 'Voleibol Masculino', 'COLETIVA', '2018/2019', 1, NULL, 2, NULL, 1),
(36, 'Voleibol Masculino', 'COLETIVA', '2018/2019', 2, NULL, 2, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `NEI_Disciplina`
--

CREATE TABLE `NEI_Disciplina` (
  `paco_code` smallint(5) UNSIGNED NOT NULL,
  `nome` varchar(60) NOT NULL,
  `ano` tinyint(4) NOT NULL,
  `semestre` tinyint(4) NOT NULL,
  `short` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `NEI_Disciplina`
--

INSERT INTO `NEI_Disciplina` (`paco_code`, `nome`, `ano`, `semestre`, `short`) VALUES
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

-- --------------------------------------------------------

--
-- Table structure for table `NEI_Disciplina_Apontamentos`
--

CREATE TABLE `NEI_Disciplina_Apontamentos` (
  `disciplina` smallint(5) UNSIGNED NOT NULL,
  `link_ficheiro` varchar(200) NOT NULL,
  `nome_recurso` varchar(100) NOT NULL DEFAULT '-',
  `autor` varchar(40) NOT NULL DEFAULT '-'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `NEI_Disciplina_Apontamentos`
--

INSERT INTO `NEI_Disciplina_Apontamentos` (`disciplina`, `link_ficheiro`, `nome_recurso`, `autor`) VALUES
(40337, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19.zip', 'MPEI 18/19 (zip)', 'Diogo Silva'),
(40337, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/mpei/MP_Exemplo_Teste.pdf', 'MPEI Exemplo Teste 2014', 'Paulo Ferreira'),
(40337, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/mpei/RafaelDireito_2017_2018_MPEI.zip', 'Diversos - 2017/2018 (zip)', 'Rafael Direito'),
(40337, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/mpei/Resumos_Teoricas.zip', 'Resumos Teóricos (zip)', '-'),
(40379, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/fp/Goncalo_FP.zip', 'Resumos FP 2018/2019 (zip)', 'Gonçalo Matos'),
(40379, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/fp/RafaelDireito_FP_16_17.zip', 'Material FP 2016/2017 (zip)', 'Rafael Direito'),
(40379, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/fp/resolucoes18_19.zip', 'Resoluções 18/19', '-'),
(40380, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/itw/apontamentos001.pdf', 'Apontamentos Globais', '-'),
(40380, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW.zip', 'Resumos ITW 2018/2019 (zip)', 'Gonçalo Matos'),
(40380, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17.zip', 'Material ITW 2016/2017 (zip)', 'Rafael Direito'),
(40381, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/so/DS_SO_18_19.zip', 'SO 18/19 (zip)', 'Diogo Silva'),
(40381, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/so/Questões.zip', 'Questões de SO (zip)', '-'),
(40381, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/so/RafaelDireito_2017_2018_SO.zip', 'Diversos - 2017/2018 (zip)', 'Rafael Direito'),
(40382, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/cd/DS_CD_18_19.zip', 'CD 18/19 (zip)', 'Diogo Silva'),
(40383, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/pds/DS_PDS_18_19.zip', 'PDS 18/19 (zip)', 'Diogo Silva'),
(40383, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/pds/JoaoAlegria_PDS.zip', 'Apontamentos Diversos (zip)', 'João Alegria'),
(40383, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/pds/pds_apontamentos_001.pdf', 'Resumos de 2015/2016', 'João Alegria'),
(40383, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/pds/pds_apontamentos_002.pdf', 'Apontamentos genéricos I', '-'),
(40383, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/pds/pds_apontamentos_003.pdf', 'Apontamentos genéricos II', '-'),
(40385, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/primeiro_semestre/cbd/InesCorreia_CBD(CC_JLO).zip', 'Diversos - CBD Prof. JLO (zip)', 'Inês Correia'),
(40431, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/mas/BarbaraJael_14_15_MAS.zip', 'MAS 2014/2015 (zip)', 'Bárbara Jael'),
(40431, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/mas/Duarte_MAS.pdf', 'Preparação para Exame Final de MAS', 'Duarte Mortágua'),
(40431, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/mas/Goncalo_MAS.zip', 'Resumos MAS 2018/2019 (zip)', 'Gonçalo Matos'),
(40431, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/mas/RafaelDireito_2016_2017_mas.zip', 'MAS 2016/2017 (zip)', 'Rafael Direito'),
(40431, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/mas/Resumos_MAS_Carina.zip', 'Resumos_MAS', 'Carina Neves'),
(40432, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19.zip', 'SMU 18/19 (zip)', 'Diogo Silva'),
(40432, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/smu/RafaelDireito_2017_2018_SM.zip', 'Resoluções + Bibliografia - 2017/2018 (zip)', 'Rafael Direito'),
(40432, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/smu/Resoluçao_das_fichas.zip', 'Resolução das fichas (zip)', '-'),
(40432, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/smu/Resumo.zip', 'Resumos (zip)', '-'),
(40432, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/smu/smu_apontamentos_001.pdf', 'Resumos de 2013/2014', 'Bárbara Jael'),
(40432, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/smu/smu_apontamentos_002.pdf', 'Resumos de 2016/2017', 'Carolina Albuquerque'),
(40432, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/smu/smu_apontamentos_003.pdf', 'Resumos de 2017/2018', 'Rui Coelho'),
(40432, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/smu/SMU_Resumos.pdf', 'Resumos 2018/19', '-'),
(40433, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/rs/DS_RS_18_19.zip', 'RS 18/19 (zip)', 'Diogo Silva'),
(40433, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/rs/RafaelDireito_2017_2018_RS.zip', 'Diversos - 2017/2018 (zip)', 'Rafael Direito'),
(40433, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/rs/Resumo.zip', 'Resumos (zip)', '-'),
(40433, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/rs/rs_apontamentos_001.pdf', 'Caderno', 'Bárbara Jael'),
(40436, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/poo/Carina_POO_Resumos.zip', 'Resumos_POO', 'Carina Neves'),
(40436, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/poo/Goncalo_POO.zip', 'Resumos POO 2018/2019 (zip)', 'Gonçalo Matos'),
(40436, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/poo/RafaelDireito_2016_2017_POO.zip', 'Diversos - Prática e Teórica (zip)', 'Rafael Direito'),
(40436, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/poo/Resumos.zip', 'Resumos Teóricos (zip)', '-'),
(40437, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/aed/aed_apontamentos_001.pdf', 'Resumos de 2016/2017', 'Carolina Albuquerque'),
(40437, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/aed/bibliografia.zip', 'Bibliografia (zip)', '-'),
(40437, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/aed/DS_AED_18_19.zip', 'AED 18/19 (zip)', 'Diogo Silva'),
(40437, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/primeiro_semestre/aed/RafaelDireito_2017_2018_AED.zip', 'Diversos - 2017/2018 (zip)', 'Rafael Direito'),
(40551, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/segundo_semestre/tpw/Exercicios.zip', 'Exercícios (zip)', '-'),
(40751, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/aa/aa_apontamentos_001.pdf', 'Resumos 2016/2017', 'João Alegria'),
(40752, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/tai/tai_apontamentos_001.pdf', 'Exames 2017/2018', 'João Alegria'),
(40752, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/tai/tai_apontamentos_002.pdf', 'Teste Modelo 2016/2017', 'João Alegria'),
(40752, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/tai/tai_apontamentos_003.pdf', 'Ficha de Exercícios 1 - 2016/2017', 'João Alegria'),
(40752, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/tai/tai_apontamentos_004.pdf', 'Ficha de Exercícios 2 - 2016/2017', 'João Alegria'),
(40753, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/cle/cle_apontamentos_001.pdf', 'Resumos 2016/2017', 'João Alegria'),
(40756, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/gic/gic_apontamentos_001.pdf', 'Resumos 2016/2017', 'João Alegria'),
(40757, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/as/as_apontamentos_001.pdf', 'Resumos 2016/2017', 'João Alegria'),
(40757, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/as/JoaoAlegria_ResumosPorCapitulo.zip', 'Resumos por capítulo (zip)', 'João Alegria'),
(40846, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/primeiro_semestre/ia/ia_apontamentos_002.pdf', 'Resumos 2017/2018', 'Carolina Albuquerque'),
(40846, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/primeiro_semestre/ia/InesCorreia_IA.zip', 'Diversos - Teórica e Prática (zip)', 'Inês Correia'),
(40846, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/primeiro_semestre/ia/resumo.zip', 'Resumos (zip)', '-'),
(41469, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/c/Aulas_Teóricas.zip', 'Aulas Teóricas (zip)', '-'),
(41469, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19.zip', 'Compiladores 18/19 (zip)', 'Diogo Silva'),
(41469, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/c/Guião_de _preparacao_para_o_teste_pratico.zip', 'Guião de preparacao para o teste prático (zip)', '-'),
(41549, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/ihc/Apontamentos.zip', 'Apontamentos Diversos (zip)', '-'),
(41549, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19.zip', 'IHC 18/19 (zip)', 'Diogo Silva'),
(41549, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_001.pdf', 'Avaliação Heurística', 'João Alegria'),
(41549, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_002.pdf', 'Resumos de 2014/2015', 'Bárbara Jael'),
(41549, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/ihc/Resolução_de_fichas.zip', 'Resolução de fichas (zip)', '-'),
(41791, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/ef/BarbaraJael_EF.zip', 'Apontamentos EF (zip)', 'Bárbara Jael'),
(41791, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/ef/Carolina_EF.zip', 'EF Carolina (zip)', 'Carolina Albuquerque'),
(41791, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_001.pdf', 'Exercícios 2017/2018', 'Rafael Direito'),
(41791, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_002.pdf', 'Exercícios 2016/17', 'Rafael Direito'),
(41791, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/ef/Goncalo_EF.zip', 'Resumos EF 2018/2019 (zip)', 'Gonçalo Matos'),
(41791, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/ef/Pedro_Oliveira_2018_2019.zip', 'Exercícios 2018/19', 'Pedro Oliveira'),
(41791, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/ef/Resoluçoes_EF_DS.zip', 'Resolucoes_EF', 'Diogo Silva'),
(42502, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/iac/exames.zip', 'Exames (zip)', '-'),
(42502, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/iac/Goncalo_IAC.zip', 'Resumos IAC 2018/2019 (zip)', 'Gonçalo Matos'),
(42502, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/iac/PedroOliveira.zip', 'Apontamentos e Resoluções (zip)', 'Pedro Oliveira'),
(42502, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/iac/RafaelDireito_2016_2017_iac.zip', 'Diversos - 2016/2017', 'Rafael Direito (zip)'),
(42532, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/bd/bd_apontamentos_001.pdf', 'Caderno - 2016/2017', 'Carolina Albuquerque'),
(42532, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/bd/bd_apontamentos_002.pdf', 'Resumos - 2014/2015', 'João Alegria'),
(42532, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/bd/BD_Resumos.pdf', 'Resumos globais', '-'),
(42532, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/bd/DS_BD_18_19.zip', 'BD 18/19 (zip)', 'Diogo Silva'),
(42532, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/bd/Resumos.zip', 'Resumos Diversos (zip)', '-'),
(42532, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/segundo_ano/segundo_semestre/bd/Slides_Teoricas.zip', 'Slides das Aulas Teóricas (zip)', '-'),
(42573, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/primeiro_semestre/sio/JoaoAlegria_sio.zip', 'Apontamentos Diversos (zip)', 'João Alegria'),
(42573, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/primeiro_semestre/sio/Outros_Resumos.zip', 'Outros Resumos (zip)', '-'),
(42573, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_001.pdf', 'Resumo geral de segurança I', '-'),
(42573, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_002.pdf', 'Resumo geral de segurança II', '-'),
(42573, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_003.pdf', 'Resumos de 2015/2016', 'Bárbara Jael'),
(42573, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_004.pdf', 'Resumo geral de segurança III', '-'),
(42573, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_005.pdf', 'Apontamentos genéricos', '-'),
(42709, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/alga/Carolina_Albuquerque_ALGA.zip', 'Resumos de ALGA (zip)', 'Carolina Albuquerque'),
(42709, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/alga/DiogoSilva_17_18_ALGA.zip', 'ALGA 2017/2018 (zip)', 'Diogo Silva'),
(42709, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/alga/Goncalo_ALGA.zip', 'Resumos ALGA 2018/2019 (zip)', 'Gonçalo Matos'),
(42709, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/alga/Rafael_Direito.zip', 'Resumos ALGA (zip)', 'Rafael Direito'),
(42728, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_001.pdf', 'Resumos 2016/2017', 'Pedro Ferreira'),
(42728, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_002.pdf', 'Resumos 2016/2017', 'Rui Coelho'),
(42728, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_003.pdf', 'Teste Primitivas 2016/2017', 'Rafael Direito'),
(42728, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_004.pdf', 'Exercícios 2016/2017', 'Rafael Direito'),
(42728, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_005.pdf', 'Resumos 2016/2017', 'Rafael Direito'),
(42728, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_006.pdf', 'Fichas 2016/2017', 'Rafael Direito'),
(42728, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/c1/CarolinaAlbuquerque_C1_caderno.zip', 'Caderno de cálculo (zip)', 'Carolina Albuquerque'),
(42728, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/c1/DiogoSilva_17_18_C1.zip', 'CI 2017/2018 (zip)', 'Diogo Silva'),
(42728, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/primeiro_semestre/c1/Goncalo_C1.zip', 'Resumos Cálculo I 2018/2019 (zip)', 'Gonçalo Matos'),
(42729, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/c2/calculoii_apontamentos_003.pdf', 'Caderno de 2016/2017', 'Pedro Ferreira'),
(42729, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/c2/Goncalo_C2.zip', 'Resumos Cálculo II 2018/2019 (zip)', 'Gonçalo Matos'),
(42729, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/c2/PedroOliveira.zip', 'Resolução de exercícios', 'Pedro Oliveira'),
(44156, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/vi/vi_apontamentos_001.pdf', 'Resumos 2016/2017', 'João Alegria'),
(44158, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/ws/JoaoAlegria_ResumosPorCapítulo.zip', 'Resumos por capítulo (zip)', 'João Alegria'),
(44158, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/ws/web_semantica_apontamentos_001.pdf', 'Resumos 2016/2017', 'João Alegria'),
(45424, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/primeiro_semestre/icm/Inês_Correia_ICM.pdf', 'Apontamentos Diversos', 'Inês Correia'),
(45424, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/primeiro_semestre/icm/Resumo.zip', 'Apontamentos Gerais (zip)', '-'),
(45426, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/segundo_semestre/tqs/Inês_Correia_TQS.pdf', 'Apontamentos Diversos', 'Inês Correia'),
(45426, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/segundo_semestre/tqs/resumos.zip', 'Resumos (zip)', '-'),
(45426, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/terceiro_ano/segundo_semestre/tqs/tqs_apontamentos_002.pdf', 'Resumos 2015/2016', 'João Alegria'),
(45587, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/ed/ed_dm_apontamentos_001.pdf', 'Resumos 2017/2018 - I', 'João Alegria'),
(45587, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/mestrado/ed/ed_dm_apontamentos_002.pdf', 'Resumos 2017/2018 - II', 'João Alegria'),
(47166, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/md/Goncalo_MD.zip', 'Resumos MD 2018/2019 (zip)', 'Gonçalo Matos'),
(47166, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/md/md_apontamentos_003.pdf', 'Arranjos - 2016/2017', 'Rafael Direito'),
(47166, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/md/md_apontamentos_004.pdf', 'Princípios de Enumeração Combinatória - 2016/2017', 'Rafael Direito'),
(47166, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/md/md_apontamentos_011.pdf', 'Lógica de 1ª Ordem - 2016/2017', 'Rafael Direito'),
(47166, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/md/md_apontamentos_012.pdf', 'Lógica Proposicional - 2016/2017', 'Rafael Direito'),
(47166, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/md/md_apontamentos_013.pdf', 'Relações Binárias - 2016/2017', 'Rafael Direito'),
(47166, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/md/MD_Capitulo5.pdf', 'Resumos 2017/2018', 'Carina Neves'),
(47166, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/md/PedroOliveira.zip', 'Apontamentos e Resoluções', 'Pedro Oliveira'),
(47166, 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/apontamentos/primeiro_ano/segundo_semestre/md/RafaelDireito_2016_2017_MD.zip', 'RafaelDireito_2016_2017_MD.zip', 'Rafael Direito');

-- --------------------------------------------------------

--
-- Table structure for table `NEI_Merch`
--

CREATE TABLE `NEI_Merch` (
  `id` int(200) NOT NULL,
  `data` varchar(200) NOT NULL,
  `hora` varchar(200) NOT NULL,
  `nome` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `estado` enum('0','1') NOT NULL DEFAULT '0',
  `ficheiro` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `NEI_Merch`
--

INSERT INTO `NEI_Merch` (`id`, `data`, `hora`, `nome`, `email`, `estado`, `ficheiro`) VALUES
(4, '2019/08/28', '14:56:39', 'António Fernandes', 'antoniojorgefernandes@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/945_20191001115850.pdf'),
(7, '2019/08/28', '15:02:13', 'Hugo Paiva', 'hugofpaiva@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/1329_20191001120130.pdf'),
(10, '2019/08/28', '15:31:07', 'Francisca Barros', 'francisca.mbarros@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/1254_20191001121027.pdf'),
(13, '2019/08/28', '15:37:43', 'Isadora Loredo', 'isadora.fl@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/1350_20191001121510.pdf'),
(19, '2019/08/28', '15:53:49', 'André Gomes', 'andresgomes@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/930_20191001121741.pdf'),
(25, '2019/08/28', '16:36:31', 'João Dias', 'joaomadias@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/1425_20191001121935.pdf'),
(28, '2019/08/28', '16:38:20', 'Flávia Figueiredo', 'flaviafigueiredo@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/1245_20191001122138.pdf'),
(31, '2019/08/28', '17:29:39', 'Lucas Sousa', 'joselmdbsousa@ua.pt', '1', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/1479_20191001122246.pdf'),
(34, '2019/08/28', '18:07:03', 'Luís Fonseca', 'luiscdf@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/1545_20191001122358.pdf'),
(37, '2019/08/28', '23:01:11', 'João Silva', 'joaosilva9@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/1452_20191001122442.pdf'),
(40, '2019/08/29', '16:57:54', 'Rui Melo', 'r.melo@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/1794_20191001122541.pdf'),
(43, '2019/09/12', '20:34:46', 'Renato Dias', 'renatoaldias12@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/2066_20191001122631.pdf'),
(46, '2019/09/17', '20:34:46', 'Carlos Soares', 'cmsoares@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/1059_20191001122721.pdf'),
(49, '2019/08/29', '17:50:35', 'Daniel Gomes', 'dagomes@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/1074_20191001122841.pdf'),
(52, '2019/09/11', '15:48:49', 'Afonso Fernandes', 'afonjose31@gmail.com', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/tshirt_20191001122935.pdf'),
(55, '2019/09/25', '19:03:39', 'Fábio Martins', 'fabio.m@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/2040_20191001131718.pdf'),
(67, '2019/10/13', '15:12:45', 'Rui Fernandes', 'rfmf@ua.pt', '0', 'https://nei.web.ua.pt/scripts/unlock.php?url=/upload/encomendas/1821_20191013151246.pdf');

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `id` int(11) NOT NULL,
  `header` varchar(255) NOT NULL,
  `status` enum('0','1') NOT NULL COMMENT '0 if disable 1 if showing',
  `title` varchar(255) NOT NULL,
  `category` varchar(255) DEFAULT NULL,
  `content` varchar(20000) NOT NULL,
  `publish_by` int(11) NOT NULL COMMENT 'user id that created new',
  `created_at` date NOT NULL COMMENT 'When new created',
  `last_change_at` date DEFAULT NULL COMMENT 'When new was last changed',
  `changed_by` int(11) DEFAULT NULL COMMENT 'user id that changed new',
  `author` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `news`
--

INSERT INTO `news` (`id`, `header`, `status`, `title`, `category`, `content`, `publish_by`, `created_at`, `last_change_at`, `changed_by`, `author`) VALUES
(30, '/news/6aniversario.jpg', '1', '6º Aniversário NEI', 'Event', 'Fez 6 anos, no passado dia 24 de Janeiro, que se formou o Núcleo de Estudantes de Informática. Para celebrar o 6º aniversário do NEI, convidamos todos os nossos alunos, colegas e amigos a juntarem-se a nós num jantar repleto de surpresas. O jantar realizar-se-á no dia 28 de fevereiro no restaurante \"Monte Alentejano\" - Rua de São Sebastião 27A - pelas 20h00 tendo um custo de 11 euros por pessoa. Contamos com a presença de todos para apagarmos as velas e comermos o bolo, porque alegria e diversão já têm presença marcada!\r\n<hr>\r\n<b>Ementa</b>\r\n<ul>\r\n<li>Carne de porco à alentejana/ opção vegetariana</li>\r\n<li>Bebida à descrição</li>\r\n<li>Champanhe</li>\r\n<li>Bolo</li>\r\n</ul>  \r\nNota: Caso pretendas opção vegetariana deves comunicar ao NEI por mensagem privada no facebook ou então via email.\r\n<hr>\r\n<b>Informações</b><br>\r\nInscrições até dia 21 de fevereiro sendo que as mesmas estão limitadas a 100 pessoas.<br>\r\n&#9888;&#65039; A inscrição só será validada após o pagamento junto de um elemento do NEI até dia 22 de fevereiro às 16horas!<br>\r\n+info: nei@aauav.pt ou pela nossa página de Facebook<br>\r\n<hr>\r\n<b>Logins</b><br>\r\nCaso não saibas o teu login contacta: <a href=\"https://www.facebook.com/ruicoelho43\">Rui Coelho</a> ou então diretamente com o <a href=\"https://www.facebook.com/nei.aauav/\">NEI</a>, podes ainda mandar mail para o NEI, nei@aauav.pt.', 1866, '2019-01-18', NULL, NULL, 1),
(33, '/news/rgm1.png', '1', 'Convocatória RGM Extraordinária', 'Event', 'De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos Núcleos da Associação Académica da Universidade de Aveiro, convocam-se todos os membros da Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática para uma Reunião Geral de Membros Extraordinária, que se realizará no dia 14 do mês de Fevereiro de 2019, na sala 102 do Departamento de Eletrónica, Telecomunicações e Informática da Universidade de Aveiro, pelas 18 horas, com a seguinte ordem de trabalhos:  <br>\r\n<br>\r\n1. Aprovação da Ata da RGM anterior;   <br>\r\n2. Informações;   <br>\r\n3. Apresentação do Plano de Atividades e Orçamento;  <br>\r\n4. Aprovação do Plano de Atividades e Orçamentos;  <br>\r\n5. Outros assuntos.   <br>\r\n<br>\r\nMais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI.<br>\r\n<br>\r\n<div style=\"text-align:center\">\r\nAveiro, 11 de janeiro de 2019<br>\r\nDavid Augusto de Sousa Fernandes<br>\r\nPresidente da Mesa da Reunião Geral de Membros<br>\r\nNúcleo de Estudantes de Informática da AAUAv <br>\r\n</div>\r\n<hr>\r\nLinks úteis:<br>\r\n<a href=\"https://nei.web.ua.pt/scripts/unlock.php?url=upload/documents/RGM_ATAS/2018/RGM_10jan2019.pdf\" target=\"_blank\">Ata da RGM anterior</a><br>\r\n<a href=\"https://nei.web.ua.pt/upload/documents/CONV_ATAS/2019/1RGM.pdf\" target=\"_blank\">Documento da convocatória</a> ', 1866, '2019-02-11', NULL, NULL, 1),
(36, '/news/rgm2.png', '1', 'Convocatória RGM Extraordinária', 'Event', 'De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos  Núcleos  da  Associação Académica  da  Universidade  de  Aveiro,  convocam-se  todos  os membros  da  Licenciatura  em  Engenharia  Informática  e  Mestrado  em  Engenharia  Informática para uma Reunião Geral de MembrosExtraordinária, que se realizará no dia 1do mês de Abrilde 2019,   na   sala   102   do   Departamento   de   Eletrónica,   Telecomunicações   e   Informática   da Universidade de Aveiro, pelas 17:45horas, com a seguinte ordem de trabalhos: <br>\r\n<br>\r\n1. Aprovação da Ata da RGM anterior;   <br>\r\n2. Informações;   <br>\r\n3. Discussão sobre o tema da barraca;  <br>\r\n4. Orçamento Participativo 2019;  <br>\r\n5. Outros assuntos.   <br>\r\n<br>\r\nSe   à   hora   indicada   não   existir   quórum,   a   Assembleia   iniciar-se-á   meia   hora   depois, independentemente do número de membros presentes, no mesmo local, e com a mesma ordem de trabalhos.\r\n<br>\r\nMais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI (https://nei.web.ua.pt).<br>\r\n<br>\r\n<div style=\"text-align:center\">\r\nAveiro, 28 de Março de 2019<br>\r\nDavid Augusto de Sousa Fernandes<br>\r\nPresidente da Mesa da Reunião Geral de Membros<br>\r\nNúcleo de Estudantes de Informática da AAUAv <br>\r\n</div>\r\n<hr>', 1866, '2019-03-28', NULL, NULL, 1),
(39, '/news/idpimage.png', '1', 'Integração IDP', 'News', 'Recentemente foi feito um update no site que permite agora aos alunos de Engenharia Informática, quer mestrado, quer licenciatura, iniciar sessão no site  <a href=\"https://nei.web.ua.pt\">nei.web.ua.pt</a> através do idp. <br>\r\nEsta alteração tem por consequência direta que a gestão de passwords deixa de estar diretamente ligada ao NEI passando assim, deste modo, qualquer password que seja perdida ou seja necessária alterar, responsabilidade do IDP da UA.<br><hr>\r\n<h5 style=\"text-align: center\"><strong>Implicações diretas</strong></h5><br>\r\nTodas as funcionalidades do site se mantém e esta alteração em nada afeta o normal workflow do site, os apontamentos vão continuar na mesma disponíveis e em breve irão sofrer um update sendo corrigidas eventuais falhas nos atuais e adicionados mais alguns apontamentos No que diz respeito aos jantares de curso, a inscrição para estes também será feita via login através do IDP.<br>\r\nDe forma genérica o IDP veio simplificar a forma como acedemos às plataformas do NEI, usando assim o Utilizador Universal da Universidade de Aveiro para fazer o login.<br>\r\nÉ de frisar que <strong>apenas</strong> os estudantes dos cursos  <strong>Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática  </strong>têm acesso ao site, todos os outros irão receber uma mensagem de erro quando fazem login e serão redirecionados para a homepage, não tendo, assim, acesso à informação e funcionalidades que necessitam de autenticação.<hr>\r\n<h5 style=\"text-align: center\"><strong>Falha nos acessos</strong></h5><br>\r\nExiste a possibilidade de alguns alunos não terem acesso caso ainda não tivessem sido registados na versão antiga do site, assim, caso não consigas aceder por favor entra em contacto connosco via email para o <a href=\"mailto:nei@aauav.pt?Subject=Acesso%20NEI\" target=\"_top\">NEI</a> ou via facebook por mensagem direta para o <a href=\"https://www.facebook.com/nei.aauav/\">NEI</a> ou então diretamente com o <a href=\"https://www.facebook.com/ruicoelho43\">Rui Coelho</a>.<br>\r\n', 1866, '2019-05-15', NULL, NULL, 1),
(46, '/news/florinhas.jpg', '1', 'Entrega de t-shirts à Florinhas de Vouga', 'News', 'Hoje procedemos à entrega de mais de 200 t-shirts em bom estado que nos sobraram ao longo dos anos às Florinhas Do Vouga, possibilitando assim roupa a quem mais precisa.\r\n<br>\r\nA IPSS – Florinhas do Vouga é uma Instituição Diocesana de Superior Interesse Social, fundada em 6 de Outubro de 1940 por iniciativa do Bispo D. João Evangelista de Lima Vidal, a quem se deve a criação de obras similares, as Florinhas da Rua em Lisboa e as Florinhas da Neve em Vila Real.\r\n<br>\r\nA Instituição desenvolve a sua intervenção na cidade de Aveiro, mais concretamente na freguesia da Glória, onde se situa um dos Bairros Sociais mais problemáticos da cidade (Bairro de Santiago), dando também resposta, sempre que necessário, às solicitações das freguesias limítrofes e outras, algumas delas fora do Concelho.\r\n<br>\r\nNo desenvolvimento da sua actividade mantém com o CDSSS de Aveiro Acordos de Cooperação nas áreas da Infância e Juventude; População Idosa; Família e Comunidade e Toxicodependência.\r\n<br>\r\nÉ Entidade aderente do Núcleo Local de Inserção no âmbito do Rendimento Social de Inserção, parceira do CLAS, assumindo com os diferentes Organismos e Instituições uma parceria activa.\r\n<br>\r\nO desenvolvimento das respostas decorreu até Agosto de 2008 em equipamentos dispersos na freguesia da Glória e Vera Cruz, o que levou a Instituição a construir um edifício de raiz na freguesia da Glória, espaço onde passou a ter condições para concentrar parte das respostas que desenvolvia (nomeadamente Estabelecimento de Educação Pré-Escolar, CATL e SAD), assumir novas respostas (Creche), dar continuidade ao trabalho desenvolvido e garantir uma melhoria substancial na qualidade dos serviços prestados, encontrando-se neste momento num processo de implementação de Sistema de Gestão de Qualidade com vista à certificação.\r\n<br>\r\nA presença de famílias numerosas, multiproblemáticas, sem rendimentos de trabalho, quase que limitadas a rendimentos provenientes de prestações sociais, famílias com fortes vulnerabilidades, levaram a Instituição a ser mediadora no Programa Comunitário de Ajuda a Carenciados e a procurar sinergias capazes de optimizar os seus recursos existentes e dar resposta à emergência social, são exemplos disso a acção “Mercearia e Companhia”, que apoia mensalmente cerca de 200 famílias em géneros alimentares, vestuário e outros e a “Ceia com Calor” que distribui diariamente um suplemento alimentar aos Sem-abrigo de Aveiro.\r\n<br>\r\nÉ de salientar que as famílias que usufruem de Respostas Socais tipificadas, face às suas vulnerabilidades acabam por não conseguir assumir o pagamento das mensalidades mínimas que deveriam pagar pela prestação dos serviços que lhe são garantidos pela Instituição, o que exige um maior esforço por parte desta.\r\n<br>\r\nEm termos globais, a Instituição tem assumido uma estratégia de efectiva prevenção, promoção e inclusão da população alvo.\r\n<br>\r\n<strong>Se tiveres roupa ou produtos de higiene a mais e queres ajudar as Florinhas por favor dirige-te à instituição e entrega as mesmas!</strong><br>\r\nFica a conhecer mais sobre esta instituição: http://www.florinhasdovouga.pt', 1452, '2019-09-11', NULL, NULL, 1),
(47, '/news/rgm3.png', '1', 'Convocatória RGM Extraordinária', 'Event', 'De acordo com o disposto na alínea b) do n.º 3 do artigo 24.º, do Regulamento Interno Genérico dos Núcleos da Associação Académica da Universidade de Aveiro, convocam-se todos os membros da Licenciatura em Engenharia Informática e Mestrado em Engenharia Informática para uma Reunião Geral de Membros Extraordinária, que se realizará no dia 24 do mês de Setembro de 2019, na sala 102 do Departamento de Eletrónica, Telecomunicações e Informática da Universidade de Aveiro, pelas 18:00 horas, com a seguinte ordem de trabalhos: <br>\r\n<br>\r\n1. Aprovação da Ata da RGM anterior; <br>\r\n2. Informações; <br>\r\n3. Pitch Bootcamp; <br>\r\n4. Taça UA; <br>\r\n5. Programa de Integração; <br>\r\n6. Outros assuntos. <br>\r\n<br>\r\nSe à hora indicada não existir quórum, a Assembleia iniciar-se-á meia hora depois, independentemente do número de membros presentes, no mesmo local, e com a mesma ordem de trabalhos.\r\n<br>\r\nMais se informa que a ata em aprovação já se encontra disponível para consulta na plataforma online do NEI (https://nei.web.ua.pt), sendo necessário fazer login na plataforma para ter acesso à mesma.<br>\r\n<br>\r\n<div style=\"text-align:center\">\r\nDavid Augusto de Sousa Fernandes<br>\r\nAveiro, 20 de setembro de 2019<br>\r\nPresidente da Mesa da Reunião Geral de Membros<br>\r\nNúcleo de Estudantes de Informática da AAUAv <br>\r\n</div>\r\n<hr>', 1452, '2019-09-20', NULL, NULL, 1),
(48, '/news/newNei.png', '1', 'Lançamento do novo portal do NEI', 'News', 'Passado um cerca de um ano após o lançamento da versão anterior do portal do NEI, lançamos agora uma versão renovada do mesmo com um desgin mais atrativo utilizando react para a sua criação.\r\n<br>\r\nEsta nova versão do site conta com algumas novas features:\r\n<ol>\r\n  <li>Podes agora ter uma foto utilizando o gravatar, fizemos a integração com o mesmo.</li>\r\n  <li>Podes associar o teu CV, linkedin e conta git ao teu perfil.</li>\r\n  <li>Vais poder acompanhar tudo o que se passa na taça UA com as equipas do NEI a partir da plataforma de desporto que em breve será colocada online.</li>\r\n  <li>Existe uma secção que vai permitir aos alunos interessados no curso encontrar informação sobre o mesmo mais facilmente.</li>\r\n  <li>Podes encontrar a composição de todas as coordenações na página dedicada à equipa.</li>\r\n  <li>Podes encontrar a composição de todas as comissões de faina na página dedicada à equipa.</li>\r\n  <li>Integração dos eventos criados no facebook.</li>\r\n  <li>Podes ver todas as tuas compras de Merchandising.</li>\r\n  <li>Possibilidade de divulgar os projetos no site do NEI todos os projetos que fazes, estes não precisam de ser apenas projetos universitários, podem ser também projetos pessoais. Esta função ainda não está ativa mas em breve terás novidades.</li>\r\n  <li>Foi redesenhada a página dos apontamentos sendo agora mais fácil encontrares os apontamentos que precisas, podes pesquisar diretamente ou utilizar diferentes sorts de modo a que fiquem ordenados a teu gosto.</li>\r\n</ol> \r\nÀ semelhança da anterior versão do website do NEI continuamos a ter a integração do IPD da UA fazendo assim a gestão de acessos ao website mais facilmente. \r\nCaso tenhas algum problema com o teu login entra em contacto conosco para resolvermos essa situação.\r\n<br>\r\nDa mesma que o IDP se manteve, todas as funcionalidades anteriores foram mantidas, apenas remodelamos a imagem. Quanto às funcionalidades existentes, fizemos uma pequena alteração nas atas da RGM, as mesmas passam agora apenas a estarem disponíveis para os membros do curso.\r\nChamamos para a atenção do facto de que, na anterior versão todas as opções existentes no site apareciam logo sem login e posteriormente é que era pedido o mesmo, alteramos isso, agora só aparecem todas as opções após login.\r\n<hr>\r\nCaso encontres algum bug por favor informa o NEI de modo a que este possa ser corrigido!', 1866, '2019-07-22', '2019-09-06', 1866, 1),
(61, '/news/mecvsei.jpg', '1', 'Engenharia Mecânica vs Engenharia Informática (3-2)', 'Event', 'Apesar da derrota frente a Engenharia Mecânica por 3-2 num jogo bastante efusivo tivemos as bancadas cheias.<br>\r\nMostramos hoje, novamente, que não é por acaso que ganhamos o prémio de melhor claque da época 2018/2019<br>\r\nPodes ver as fotos do jogo no nosso facebook:<br><br>\r\n<iframe src=\"https://www.facebook.com/plugins/post.php?href=https%3A%2F%2Fwww.facebook.com%2Fmedia%2Fset%2F%3Fset%3Da.2657806134483446%26type%3D3&width=500\" width=\"500\" height=\"650\" align=\"middle\" style=\"border:none;overflow:hidden\" scrolling=\"no\" frameborder=\"0\" allowTransparency=\"true\" allow=\"encrypted-media\"></iframe>', 1866, '2019-10-17', NULL, NULL, 1),
(64, '/news/melhorclaque.jpg', '1', 'Melhor Claque 2018/2019', 'News', 'No passado domingo, dia 13 de outubro, decorreu a gala <strong>Academia de Ouro</strong> organizada pela Associação Académica da Universidade de Aveiro.<br>\r\nEsta gala visa distinguir personalidades que se destacaram na época de 2018/2019 e dar a conhecer a nova época.<br>\r\nO curso de Engenharia Informática foi nomeado para melhor claque e acabou por vencer trazendo para o DETI um prémio que faltava no palmarés.<br>\r\nO troféu encontra-se agora exposto junto da porta que dá acesso ao aquário.<br>\r\nResalvamos que esteve ainda nomeado o Bruno Barbosa para melhor jogador mas infelizmente não ganhou o prémio.<br>', 1866, '2019-10-17', NULL, NULL, 1),
(67, '/news/boxburger.png', '1', 'Aproveita o teu desconto de 25%', 'Parceria', 'Façam como a Flávia e o Luís e comam no Box Burger.<br>\r\nAgora qualquer estudante de Engenharia Informática tem desconto de 25%. Basta apresentarem o cartão de estudante e informar que são de Engenharia Informática.<br>\r\nDo que estás à espera? Aproveita!', 1866, '2019-10-17', NULL, NULL, 1),
(68, '/news/rally.jpg', '1', 'Aveiro Horror Story | Rally Tascas #2', 'Event', 'És aquele que boceja nos filmes de terror? Adormeceste enquanto dava a parte mais tramada do filme? Este Rally Tascas é para ti!<br>\r\nVem pôr à prova a tua capacidade de engolir o medo no próximo dia 31, e habilita-te a ganhar um prémio!<br>\r\nO último Rally foi só o trailer... desta vez vens viver um episódio de terror!<br>\r\n<br>\r\nNão percas a oportunidade e inscreve-te <a href=\"https://nei.web.ua.pt/links/irally\" target=\"_blank\">aqui!</a><br>\r\n<br>\r\nConsulta o Regulamento <a href=\"https://nei.web.ua.pt/links/rally\" target=\"_blank\"> aqui!</a>', 1866, '2019-10-17', NULL, NULL, 1),
(76, '/news/sessfp.jpg', '1', '1ª Sessão de Dúvidas // Fundamentos de Programação', 'Event', 'O NEI está a organizar uma sessão de dúvidas que te vai ajudar a preparar de uma melhor forma para os teus exames da unidade curricular de Fundamentos da Porgramação.<br>\r\nA sessão vai ter lugar no dia 22 de outubro e ocorrerá no DETI entre as 18-22h.<br>\r\nÉ importante trazeres o teu material de estudo e o teu computador pessoal uma vez que nem todas as salas têm computadores à disposição.<br>\r\nAs salas ainda não foram atribuídas, serão no dia do evento, está atento ao <a href=\"https://www.facebook.com/events/493810694797695/\">nosso facebook!</a><br>', 1866, '2019-10-18', NULL, NULL, 1),
(82, '/news/newNei.png', '1', 'PWA NEI', 'News', 'Agora o site do NEI já possui uma PWA, basta aceder ao site e carregar na notificação para fazer download da mesma.<br>\r\nFica atento, em breve, terás novidades sobre uma plataforma para a Taça UA! Vais poder acompanhar tudo o que se passa e inclusivé ver os resultados do teu curso em direto.<br>\r\n<img src=\"https://nei.web.ua.pt/upload/NEI/pwa.jpg\" height=\"400\"/>\r\n<img src=\"https://nei.web.ua.pt/upload/NEI/pwa2.jpg\" height=\"400\"/>\r\n', 1866, '2019-10-21', NULL, NULL, 1),
(84, '/news/const_cv.png', '1', 'Como construir um bom CV? by Olisipo', 'Event', 'Dada a competitividade atual do mercado de trabalho, apresentar um bom currículo torna-se cada vez mais indispensável. Desta forma, o NEI e o NEECT organizaram um workshop chamado \"Como construir um bom CV?\", com o apoio da Olisipo. \r\n<br>\r\nInformações relevantes:<br>\r\n<ul>\r\n <li> 7 de Novembro pelas 18h no DETI (Sala 102)</li>\r\n <li> Participação Gratuita</li>\r\n <li> INSCRIÇÕES OBRIGATÓRIAS</li>\r\n <li> INSCRIÇÕES LIMITADAS</li>\r\n <li> Inscrições <a href=\"https://docs.google.com/forms/d/e/1FAIpQLSf4e3ZnHdp4INHrFgVCaXQv3pvVgkXrWN_U39s94X7Hvd98XA/viewform\" target=\"_blank\">aqui</a></li>\r\n</ul> \r\n <br> \r\nNesta atividade serão abordados diversos tópicos relativos à importância de um bom currículo e quais as formas corretas de o apresentar.', 1866, '2019-11-02', NULL, 1866, 1),
(85, '/news/apontamentos.png', '1', 'Apontamentos que já não precisas? Há quem precise!\r\n', 'News', 'Tens apontamentos, resoluções ou qualquer outro material de estudo que já não precisas?\r\nVem promover a inter-ajuda e entrega-os na sala do NEI (132) ou digitaliza-os e envia para nei@aauav.pt.\r\nEstarás a contribuir para uma base de dados de apontamentos mais sólida, organizada e completa para o nosso curso!\r\nOs alunos de informática agradecem!', 1719, '2020-01-29', NULL, NULL, 1),
(86, '/news/nei_aniv.png', '1', '7º ANIVERSÁRIO DO NEI\r\n', 'Event', 'Foi no dia 25, há 7 anos atrás, que o TEU núcleo foi criado. Na altura chamado de Núcleo de Estudantes de Sistemas de Informação, mudou para o seu nome atual em 2014.\r\nDos marcos do núcleo ao longo da sua história destacam-se o ENEI em 2014, o Think Twice em 2019 e as diversas presenças nas atividades em grande escala da AAUAv.\r\nParabéns a todos os que contribuíram para o NEI que hoje temos!', 1719, '2020-01-29', NULL, NULL, 1),
(87, '/news/delloitte_consultantforaday.png', '1', 'Queres ser consultor por um dia? A Deloitte dá-te essa oportunidade\r\n', 'Event', 'A Deloitte Portugal está a organizar o evento “Be a Consultant for a Day | Open House Porto”. Esta iniciativa dá-te acesso a um dia com várias experiências de desenvolvimento de competências e terás ainda a oportunidade de conhecer melhor as áreas de negócio integradas em consultoria tecnológica.\r\nO evento irá decorrer no Deloitte Studio do Porto e contará com alunos de várias Universidades da região Norte (Coimbra, Aveiro, Porto e Minho).', 1719, '2020-01-29', NULL, NULL, 1),
(88, '/news/pub_rgm.png', '1', 'Primeira RGM Ordinária', 'Event', 'Convocam-se todos os membros de LEI e MEI para a 1ª RGM ordinária com a seguinte ordem de trabalhos:\r\n<br><br>\r\n1. Aprovação da ata da RGM anterior;<br>\r\n2. Apresentação do Plano de Atividades e Orçamento;\r\n<br>\r\n3. Aprovação do Plano de Atividades e Orçamento;\r\n<br>\r\n4. Discução relativa à modalidade do Evento do Aniversário do NEI;\r\n<br>\r\n5. Colaboradores do NEI;\r\n<br>\r\n6. Informações relativas à Barraca do Enterro 2020;\r\n<br>\r\n7. Discussão sobre as Unidades Curriculares do 1º Semestre;\r\n<br>\r\n8. Outros assuntos.\r\n<br><br>\r\nLink para o Plano de Atividades e Orçamento (PAO):\r\n<br>\r\nhttps://nei.web.ua.pt/upload/documents/PAO/2020/PAO_NEI2020.pdf\r\n<br><br>\r\nNa RGM serão discutidos assuntos relativos a TODOS os estudantes de informática.\r\n<br>\r\nSendo assim, apelamos à participação de TODOS!', 1719, '2020-02-18', '2020-02-18', 1719, 1),
(89, '/news/colaboradores.jpg', '1', 'Vem ser nosso Colaborador!', 'Event', 'És um estudante ativo?<br>\r\nProcuras aprender novas competências e desenvolver novas?<br>\r\nGostavas de ajudar o teu núcleo a proporcionar as melhores atividades da Universidade?<br>\r\nSe respondeste sim a pelo menos uma destas questões clica <a href=\"https://forms.gle/3y5JZfNvN7rBjFZT8\" target=\"_blank\">aqui</a><br>\r\nE preenche o formulário!<br>\r\nSendo um colaborador do NEI vais poder desenvolver várias capacidades, sendo que maioria delas não são abordadas nas Unidades Curriculares!<br>\r\nVais fazer amizades e a cima de tudo vais te divertir!<br>\r\nJunta-te a nós e ajuda o NEI a desenvolver as melhores atividades possíveis!', 1719, '2020-02-19', NULL, NULL, 1),
(90, '/news/dia-syone.jpg', '1', 'Dia da Syone', 'Event', 'A Syone é uma empresa portuguesa provedora de Open Software Solutions.\r\n<br/>\r\nNeste dia podes participar num workshop, almoço gratuito e num mini-hackathon com prémios! <i class=\"fa fa-trophy\" style=\"color: gold\"></i>\r\n<br/>\r\nGarante já a tua presença através do <a href=\"https://forms.gle/62yYsFiiiZXoTiaR8\" target=\"_blank\">formulário</a>.\r\n<br/>\r\nO evento está limitado a 30 pessoas!', 1719, '2020-02-26', NULL, NULL, 1),
(91, '/news/roundtable.jpg', '1', 'Round Table - Bolsas de Investigação', 'Event', 'Gostavas de estudar e de ao mesmo tempo desenvolver trabalho de investigação? E se com isto tiveres acesso a uma bolsa?\r\n<br/>\r\nAparece nesta round table com os docentes responsáveis pelas bolsas de investigação e vem esclarecer todas as tuas dúvidas!', 1719, '2020-02-26', '2020-03-01', 1719, 1),
(92, '/news/jogos-marco.jpg', '1', 'Calendário dos Jogos de março', 'Event', 'Não percas os jogos do teu curso na Taça UA para o mês de março!\r\n<br/>\r\nAparece ao máximo de jogos possível para apoiares o teu curso em todas as modalidades.\r\n<br/>\r\nVem encher a bancada e fazer parte da melhor claque da UA! Contamos contigo e o teu magnifico apoio!', 1719, '2020-03-01', NULL, NULL, 1),
(93, '/news/hackathome.png', '1', 'HackatHome', 'Event', 'Tens andado aborrecido nesta quarentena? É contigo em mente que decidimos contornar esta triste situação e organizar um HackatHome!\r\n<br/>\r\nO HackatHome é uma competição de programação online promovida pelo NEI que consiste na resolução de uma coleção de desafios de programação.\r\n<br/>\r\nA partir desta quarta feira, e todas as quartas durante as próximas 12 semanas(!), será disponibilizado um desafio, o qual os participantes têm até à quarta-feira seguinte para resolver (1 semana).\r\n<br/>\r\nToda a competição assentará na plataforma GitHub Classroom, utilizada para requisitar e submeter os desafios. As pontuações são atribuídas por desafio, e ganha o participante com mais pontos acumulados ao final das 12 semanas!\r\n<br/>\r\nNão há processo de inscrição, apenas tens de estar atento à divulgação dos links dos desafios nos meios de comunicação do NEI, resolver e submeter através da tua conta GitHub!\r\n<br/>\r\nAlém do prémio do vencedor, será também premiado um participante aleatório! Interessante não? &#129300;\r\n<br/>\r\nConsulta o <a href=\"https://nei.web.ua.pt/upload/NEI/Regulamento_HackatHome.pdf\" target=\"_blank\">regulamento</a>!\r\n<br/>\r\nE prepara-te para a competição! &#128170;\r\n<br/>\r\n<h2><b>Desafios</b></h2>\r\n<h4><a href=\"https://bit.ly/3bJBNaA\" target=\"_blank\">Desafio 1</a></h4>\r\n<h4><a href=\"https://bit.ly/2Rnuy03\" target=\"_blank\">Desafio 2</a></h4>\r\n<h4><a href=\"https://bit.ly/2wKmZJW\" target=\"_blank\">Desafio 3</a></h4>\r\n<h4><a href=\"http://tiny.cc/Desafio4\" target=\"_blank\">Desafio 4</a></h4>\r\n<h4><a href=\"http://tiny.cc/DESAFIO5\" target=\"_blank\">Desafio 5</a></h4>\r\n<h4><a href=\"http://tiny.cc/Desafio6\" target=\"_blank\">Desafio 6</a></h4>\r\n<h4><a href=\"http://tiny.cc/Desafio7\" target=\"_blank\">Desafio 7</a></h4>', 1719, '2020-03-30', '2020-05-13', 1719, 1),
(94, '/news/pleiathome.png', '1', 'PLEIATHOME', 'Event', 'O PL<b style=\"color: #59CD00\">EI</b>ATHOME é um conjunto de mini-torneios de jogos online que se vão desenrolar ao longo do semestre. As equipas acumulam \"pontos PLEIATHOME\" ao longo dos mini-torneios, sendo que os vencedores finais ganham prémios!\r\n<br/>\r\nOrganiza a tua equipa e vai participar em mais uma saga AtHome do NEI!\r\nPodes consultar o <a href=\"https://nei.web.ua.pt/upload/NEI/Regulamento_PLEIATHOME.pdf\" target=\"_blank\">regulamento</a> do evento.\r\n<br/>\r\n<br/>\r\n<b><big>FIRST TOURNAMENT</big></b>\r\n<br/>\r\nKABOOM!! Chegou o primeiro torneio da competição PL<b style=\"color: #59CD00\">EI</b>ATHOME, com o jogo Bombtag!\r\n<br/>\r\nO mini-torneio terá início dia 10 de abril pelas 19h, inscreve-te neste <a href=\"https://bit.ly/3dXrAsU\" target=\"_blank\">formulário</a> do Kaboom.\r\n<br/>\r\nE consulta o <a href=\"https://nei.web.ua.pt/upload/NEI/Regulamento_Kaboom.pdf\" target=\"_blank\">regulamento</a> do Kaboom.\r\n<br/>\r\nVamos lá!\r\n<br/>\r\n<br/>\r\n<b><big>SECOND TOURNAMENT</big></b>\r\n<br/>\r\nSpeedTux &#128039;&#128168; Chegou o segundo torneio PL<b style=\"color: #59CD00\">EI</b>ATHOME, com o clássico SuperTux!\r\n<br/>\r\nO mini-torneio terá início dia 24 de abril, pelas 19h. Inscreve-te neste <a href=\"https://bit.ly/34ClZE3\" target=\"_blank\">formulário</a> até às 12h desse mesmo dia. E consulta o <a href=\"https://nei.web.ua.pt/upload/NEI/Regulamento_SpeedTux.pdf\" target=\"_blank\">regulamento</a> do SpeedTux.\r\n<br/>\r\nEstás à altura? &#128170;\r\n<br/>\r\n<br/>\r\n<b><big>THIRD TOURNAMENT</big></b>\r\n<br/>\r\nRaces à La Kart! Chegou mais um torneio PL<b style=\"color: #59CD00\">EI</b>ATHOME, com o famoso TrackMania!\r\n<br/>\r\nO mini-torneio terá início dia 8 de maio (sexta-feira) pelas 19h, inscreve-te no <a href=\"tiny.cc/racesalakart\" target=\"_blank\">formulário</a> e consulta o <a href=\"https://nei.web.ua.pt/upload/NEI/Regulamento_Races_a_la_KART.pdf\" target=\"_blank\">regulamento</a>.\r\n<br/>\r\nDescobre se és o mais rápido! &#127988;', 1719, '2020-04-06', '2020-05-04', 1719, 1),
(95, '/news/nei_lol.png', '1', 'Torneio Nacional de LoL', 'Event', 'Como a vida não é só trabalho, vem divertir-te a jogar e representar a Universidade de Aveiro em simultâneo! O NEEEC-FEUP está a organizar um torneio de League of Legends inter-universidades a nível nacional, e a UA está apta para participar.\r\n<br/>\r\nExistirá uma ronda de qualificação em Aveiro para determinar as 2 equipas que participam nacionalmente. O torneio é de inscrição gratuita e garante prémios para as equipas que conquistem o 1º e 2º lugar!\r\n<br/>\r\nForma equipa e mostra o que vales!\r\n<br/>\r\n<a href=\"http://tiny.cc/torneioLOL\" target=\"_blank\">Inscreve-te</a>!', 1719, '2020-05-13', NULL, NULL, 1),
(96, '/news/202122/96.jpg', '1', 'Roots Beach Club', 'Event', '<p>A primeira semana de aulas vai terminar em grande!</p>\r\n<p>Na sexta-feira vem ao Roots Beach Club para uma beach party incrível.</p>\r\n<p>A pulseira do evento garante o transporte desde Aveiro até à Praia da Barra, um teste antigénio à covid e a entrada no bar com uma bebida incluída!</p>\r\n<p>Reserva a tua pulseira terça feira das 16h às 19h na sala 4.1.32.</p>', 1602, '2021-10-10', NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `notes`
--

CREATE TABLE `notes` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `subject` int(11) DEFAULT NULL,
  `author` int(11) DEFAULT NULL,
  `schoolYear` int(4) DEFAULT NULL,
  `teacher` int(11) DEFAULT NULL,
  `summary` tinyint(1) DEFAULT NULL,
  `tests` tinyint(1) DEFAULT NULL,
  `bibliography` tinyint(1) DEFAULT NULL,
  `slides` tinyint(1) DEFAULT NULL,
  `exercises` tinyint(1) DEFAULT NULL,
  `projects` tinyint(1) DEFAULT NULL,
  `notebook` tinyint(1) DEFAULT NULL,
  `content` text,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `type` int(11) NOT NULL,
  `size` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `notes`
--

INSERT INTO `notes` (`id`, `name`, `location`, `subject`, `author`, `schoolYear`, `teacher`, `summary`, `tests`, `bibliography`, `slides`, `exercises`, `projects`, `notebook`, `content`, `createdAt`, `type`, `size`) VALUES
(1, 'MPEI Exemplo Teste 2014', '/notes/segundo_ano/primeiro_semestre/mpei/MP_Exemplo_Teste.pdf', 40337, NULL, 1, 5, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(2, 'Diversos - 2017/2018 (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/RafaelDireito_2017_2018_MPEI.zip', 40337, 1800, 2, 4, 1, 0, 1, 1, 1, 0, 0, NULL, '2021-06-14 19:17:30', 2, 35),
(3, 'Resumos Teóricos (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/Resumos_Teoricas.zip', 40337, 1023, 1, 5, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos_Teóricas</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 8),
(4, 'Resumos FP 2018/2019 (zip)', '/notes/primeiro_ano/primeiro_semestre/fp/Goncalo_FP.zip', 40379, 1275, 3, 27, 1, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aulas Práticas</dt><dd><dd>148 pastas</dd><dd>132 ficheiros</dd><dd></dl><dl><dt>Resumos</dt><dd><dd>1 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Testes para praticar</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Visualize Cod...</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 30),
(5, 'Material FP 2016/2017 (zip)', '/notes/primeiro_ano/primeiro_semestre/fp/RafaelDireito_FP_16_17.zip', 40379, 1800, 4, NULL, 1, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>34 pastas</dd><dd>30 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 14),
(6, 'Resoluções 18/19', '/notes/primeiro_ano/primeiro_semestre/fp/resolucoes18_19.zip', 40379, NULL, 3, NULL, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>18-19</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(7, 'Apontamentos Globais', '/notes/primeiro_ano/primeiro_semestre/itw/apontamentos001.pdf', 40380, NULL, NULL, 8, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 3),
(8, 'Questões de SO (zip)', '/notes/segundo_ano/primeiro_semestre/so/Questões.zip', 40381, NULL, 5, NULL, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Quest?es</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(9, 'Diversos - 2017/2018 (zip)', '/notes/segundo_ano/primeiro_semestre/so/RafaelDireito_2017_2018_SO.zip', 40381, 1800, 2, 1, 1, 0, 0, 1, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>46 pastas</dd><dd>43 ficheiros</dd><dd></dl><dl><dt>Rafael_Diteit...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 35),
(10, 'Apontamentos Diversos (zip)', '/notes/segundo_ano/segundo_semestre/pds/JoaoAlegria_PDS.zip', 40383, 1455, 5, 12, 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_R...</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>JoaoAlegria_E...</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 6),
(11, 'Resumos de 2015/2016', '/notes/segundo_ano/segundo_semestre/pds/pds_apontamentos_001.pdf', 40383, 1455, 5, 12, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 4),
(12, 'Apontamentos genéricos I', '/notes/segundo_ano/segundo_semestre/pds/pds_apontamentos_002.pdf', 40383, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(13, 'Apontamentos genéricos II', '/notes/segundo_ano/segundo_semestre/pds/pds_apontamentos_003.pdf', 40383, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(14, 'Diversos - CBD Prof. JLO (zip)', '/notes/terceiro_ano/primeiro_semestre/cbd/InesCorreia_CBD(CC_JLO).zip', 40385, 1335, NULL, 12, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>InesCorreia_C...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 2),
(15, 'MAS 2014/2015 (zip)', '/notes/primeiro_ano/segundo_semestre/mas/BarbaraJael_14_15_MAS.zip', 40431, 963, 1, 13, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>resumo-mas.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 14),
(16, 'Preparação para Exame Final de MAS', '/notes/primeiro_ano/segundo_semestre/mas/Duarte_MAS.pdf', 40431, 1182, 3, 13, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(17, 'MAS 2016/2017 (zip)', '/notes/primeiro_ano/segundo_semestre/mas/RafaelDireito_2016_2017_MAS.zip', 40431, 1800, 4, 13, 1, 0, 1, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 19),
(18, 'Resumos_MAS', '/notes/primeiro_ano/segundo_semestre/mas/Resumos_MAS_Carina.zip', 40431, 1002, 2, 13, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>MAS_Resumos.pdf</dt><dd><dd></dl><dl><dt>MAS_Resumos2.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 8),
(19, 'Resolução das fichas (zip)', '/notes/segundo_ano/primeiro_semestre/smu/Resoluçao_das_fichas.zip', 40432, NULL, NULL, NULL, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resoluçao das fichas</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 27),
(20, 'Resumos (zip)', '/notes/segundo_ano/primeiro_semestre/smu/Resumo.zip', 40432, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 116),
(21, 'Resumos de 2013/2014', '/notes/segundo_ano/primeiro_semestre/smu/smu_apontamentos_001.pdf', 40432, 963, 6, 26, 1, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 11),
(22, 'Resumos de 2016/2017', '/notes/segundo_ano/primeiro_semestre/smu/smu_apontamentos_002.pdf', 40432, 1023, 4, 15, 1, 1, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(23, 'Resumos de 2017/2018', '/notes/segundo_ano/primeiro_semestre/smu/smu_apontamentos_003.pdf', 40432, 1866, 2, 15, 1, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 7),
(24, 'Resumos 2018/19', '/notes/segundo_ano/primeiro_semestre/smu/SMU_Resumos.pdf', 40432, NULL, NULL, NULL, 1, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 4),
(25, 'Resumos (zip)', '/notes/segundo_ano/primeiro_semestre/rs/Resumo.zip', 40433, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 24),
(26, 'Caderno', '/notes/segundo_ano/primeiro_semestre/rs/rs_apontamentos_001.pdf', 40433, 963, 1, 16, 1, 0, 0, 0, 1, 0, 1, NULL, '2021-06-14 19:17:30', 1, 6),
(27, 'Resumos_POO', '/notes/primeiro_ano/segundo_semestre/poo/Carina_POO_Resumos.zip', 40436, 1002, 2, 31, 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>POO_Resumos_OT.pdf</dt><dd><dd></dl><dl><dt>POO_Resumos.pdf</dt><dd><dd></dl><dl><dt>POO_resumos_v2.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 6),
(28, 'Resumos POO 2018/2019 (zip)', '/notes/primeiro_ano/segundo_semestre/poo/Goncalo_POO.zip', 40436, 1275, 3, 28, 1, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Apontamentos</dt><dd><dd>1 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Aulas Práticas</dt><dd><dd>17 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 4),
(29, 'Diversos - Prática e Teórica (zip)', '/notes/primeiro_ano/segundo_semestre/poo/RafaelDireito_2016_2017_POO.zip', 40436, 1800, 4, NULL, 1, 1, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>495 pastas</dd><dd>492 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 43),
(30, 'Resumos Teóricos (zip)', '/notes/primeiro_ano/segundo_semestre/poo/Resumos.zip', 40436, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 22),
(31, 'Resumos de 2016/2017', '/notes/segundo_ano/primeiro_semestre/aed/aed_apontamentos_001.pdf', 40437, 1023, 4, 17, 1, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 5),
(32, 'Bibliografia (zip)', '/notes/segundo_ano/primeiro_semestre/aed/bibliografia.zip', 40437, NULL, NULL, NULL, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Linguagem C -...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 33),
(33, 'Resumos 2016/2017', '/notes/mestrado/aa/aa_apontamentos_001.pdf', 40751, 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(34, 'Exames 2017/2018', '/notes/mestrado/tai/tai_apontamentos_001.pdf', 40752, 1455, 2, NULL, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(35, 'Teste Modelo 2016/2017', '/notes/mestrado/tai/tai_apontamentos_002.pdf', 40752, 1455, 4, NULL, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 3),
(36, 'Ficha de Exercícios 1 - 2016/2017', '/notes/mestrado/tai/tai_apontamentos_003.pdf', 40752, 1455, 4, NULL, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 5),
(37, 'Ficha de Exercícios 2 - 2016/2017', '/notes/mestrado/tai/tai_apontamentos_004.pdf', 40752, 1455, 4, NULL, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 3),
(38, 'Resumos 2016/2017', '/notes/mestrado/cle/cle_apontamentos_001.pdf', 40753, 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 12),
(39, 'Resumos 2016/2017', '/notes/mestrado/gic/gic_apontamentos_001.pdf', 40756, 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 12),
(40, 'Resumos 2017/2018', '/notes/terceiro_ano/primeiro_semestre/ia/ia_apontamentos_002.pdf', 40846, 1023, 2, 30, 1, 1, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 6),
(41, 'Aulas Teóricas (zip)', '/notes/segundo_ano/segundo_semestre/c/Aulas_Teóricas.zip', 41469, NULL, 5, 10, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aulas Teóricas</dt><dd><dd>41 pastas</dd><dd>27 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 6),
(42, 'Guião de preparacao para o teste prático (zip)', '/notes/segundo_ano/segundo_semestre/c/Guião_de _preparacao_para_o_teste_pratico.zip', 41469, NULL, NULL, NULL, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Gui?o de prep...</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(43, 'Apontamentos Diversos (zip)', '/notes/segundo_ano/segundo_semestre/ihc/Apontamentos.zip', 41549, NULL, NULL, NULL, 1, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Apontamentos</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 16),
(44, 'Avaliação Heurística', '/notes/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_001.pdf', 41549, 1455, 1, 9, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(45, 'Resumos de 2014/2015', '/notes/segundo_ano/segundo_semestre/ihc/ihc_apontamentos_002.pdf', 41549, 963, 1, 9, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 3),
(46, 'Resolução de fichas (zip)', '/notes/segundo_ano/segundo_semestre/ihc/Resolução_de_fichas.zip', 41549, NULL, NULL, 9, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resoluç?o de fichas</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 14),
(47, 'Apontamentos EF (zip)', '/notes/primeiro_ano/primeiro_semestre/ef/BarbaraJael_EF.zip', 41791, 963, 1, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>BarbaraJael_1...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 4),
(48, 'Exercícios 2017/2018', '/notes/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_001.pdf', 41791, 1800, 2, 24, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(49, 'Exercícios 2016/17', '/notes/primeiro_ano/primeiro_semestre/ef/ef_apontamentos_002.pdf', 41791, 1800, 4, NULL, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 7),
(50, 'Resumos EF 2018/2019 (zip)', '/notes/primeiro_ano/primeiro_semestre/ef/Goncalo_EF.zip', 41791, 1275, 3, 29, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Documento_Obt...pdf</dt><dd><dd></dl><dl><dt>Documento_Tra...pdf</dt><dd><dd></dl><dl><dt>P4_7-12.pdf</dt><dd><dd></dl><dl><dt>PL1_Ótica.pdf</dt><dd><dd></dl><dl><dt>PL2_Pêndulo E...pdf</dt><dd><dd></dl><dl><dt>PL2_Pêndulo E...jpg</dt><dd><dd></dl><dl><dt>PL2_Pêndulo E...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração.pdf</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL3_Difração_...jpg</dt><dd><dd></dl><dl><dt>PL4_Relatório.pdf</dt><dd><dd></dl><dl><dt>PL_Pauta Final.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 5),
(51, 'Exercícios 2018/19', '/notes/primeiro_ano/primeiro_semestre/ef/Pedro_Oliveira_2018_2019.zip', 41791, 1764, 3, 29, 0, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pedro Oliveira</dt><dd><dd>6 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 28),
(52, 'Apontamentos e Resoluções (zip)', '/notes/primeiro_ano/segundo_semestre/iac/PedroOliveira.zip', 42502, 1764, 2, 6, 0, 1, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pedro Oliveira</dt><dd><dd>10 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 23),
(53, 'Caderno - 2016/2017', '/notes/segundo_ano/segundo_semestre/bd/bd_apontamentos_001.pdf', 42532, 1023, 4, 7, 1, 0, 0, 0, 1, 0, 1, NULL, '2021-06-14 19:17:30', 1, 2),
(54, 'Resumos - 2014/2015', '/notes/segundo_ano/segundo_semestre/bd/bd_apontamentos_002.pdf', 42532, 1455, 1, 7, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(55, 'Resumos globais', '/notes/segundo_ano/segundo_semestre/bd/BD_Resumos.pdf', 42532, NULL, NULL, 7, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 8),
(56, 'Slides das Aulas Teóricas (zip)', '/notes/segundo_ano/segundo_semestre/bd/Slides_Teoricas.zip', 42532, NULL, 1, 7, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides_Teoricas</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 21),
(57, 'Outros Resumos (zip)', '/notes/terceiro_ano/primeiro_semestre/sio/Outros_Resumos.zip', 42573, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Outros Resumos</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 3),
(58, 'Resumo geral de segurança I', '/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_001.pdf', 42573, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(59, 'Resumo geral de segurança II', '/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_002.pdf', 42573, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(60, 'Resumos de 2015/2016', '/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_003.pdf', 42573, 963, 5, 3, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 8),
(61, 'Resumo geral de segurança III', '/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_004.pdf', 42573, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(62, 'Apontamentos genéricos', '/notes/terceiro_ano/primeiro_semestre/sio/sio_apontamentos_005.pdf', 42573, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 1),
(63, 'Resumos de ALGA (zip)', '/notes/primeiro_ano/primeiro_semestre/alga/Carolina_Albuquerque_ALGA.zip', 42709, 1023, 5, 23, 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>ALGA - Resumo...pdf</dt><dd><dd></dl><dl><dt>Exemplos da i...pdf</dt><dd><dd></dl><dl><dt>Exemplos de m...pdf</dt><dd><dd></dl><dl><dt>Exemplos de m...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 59),
(64, 'ALGA 2017/2018 (zip)', '/notes/primeiro_ano/primeiro_semestre/alga/DiogoSilva_17_18_ALGA.zip', 42709, 1161, 2, 23, 0, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>DiogoSilva_17...</dt><dd><dd>0 pastas</dd><dd>26 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 21),
(65, 'Resumos ALGA 2018/2019 (zip)', '/notes/primeiro_ano/primeiro_semestre/alga/Goncalo_ALGA.zip', 42709, 1275, 3, 19, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_Matrizes e ...pdf</dt><dd><dd></dl><dl><dt>2_Determinantes.pdf</dt><dd><dd></dl><dl><dt>3_Vetores, re...pdf</dt><dd><dd></dl><dl><dt>4_Espaços vet...pdf</dt><dd><dd></dl><dl><dt>5_Valores e v...pdf</dt><dd><dd></dl><dl><dt>6_Cónicas e q...pdf</dt><dd><dd></dl><dl><dt>7_Aplicações ...pdf</dt><dd><dd></dl><dl><dt>Complemento_C...pdf</dt><dd><dd></dl><dl><dt>Complemento_C...pdf</dt><dd><dd></dl><dl><dt>Resumo Teste ...pdf</dt><dd><dd></dl><dl><dt>Resumo Teste ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 41),
(66, 'Resumos 2016/2017', '/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_001.pdf', 42728, 1719, 4, 21, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 16),
(67, 'Resumos 2016/2017', '/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_002.pdf', 42728, 1866, 4, 21, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 5),
(68, 'Teste Primitivas 2016/2017', '/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_003.pdf', 42728, 1800, 4, 21, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(69, 'Exercícios 2016/2017', '/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_004.pdf', 42728, 1800, 4, 21, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 5),
(70, 'Resumos 2016/2017', '/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_005.pdf', 42728, 1800, 4, 21, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 11),
(71, 'Fichas 2016/2017', '/notes/primeiro_ano/primeiro_semestre/c1/calculo_apontamentos_006.pdf', 42728, 1800, 4, 21, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 22),
(72, 'CI 2017/2018 (zip)', '/notes/primeiro_ano/primeiro_semestre/c1/DiogoSilva_17_18_C1.zip', 42728, 1161, 2, 21, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>28821701_4498...jpg</dt><dd><dd></dl><dl><dt>28768155_4497...jpg</dt><dd><dd></dl><dl><dt>28927694_4497...jpg</dt><dd><dd></dl><dl><dt>28821773_4497...jpg</dt><dd><dd></dl><dl><dt>28876807_4497...jpg</dt><dd><dd></dl><dl><dt>28879472_4497...jpg</dt><dd><dd></dl><dl><dt>28822131_4497...jpg</dt><dd><dd></dl><dl><dt>28768108_4497...jpg</dt><dd><dd></dl><dl><dt>28811040_4497...jpg</dt><dd><dd></dl><dl><dt>28943154_4497...jpg</dt><dd><dd></dl><dl><dt>28879660_4497...jpg</dt><dd><dd></dl><dl><dt>28876653_4497...jpg</dt><dd><dd></dl><dl><dt>28768432_4497...jpg</dt><dd><dd></dl><dl><dt>28768056_4497...jpg</dt><dd><dd></dl><dl><dt>28877054_4497...jpg</dt><dd><dd></dl><dl><dt>28768634_4497...jpg</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 2),
(73, 'Resumos Cálculo I 2018/2019 (zip)', '/notes/primeiro_ano/primeiro_semestre/c1/Goncalo_C1.zip', 42728, 1275, 3, 18, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>0_Formulário_...pdf</dt><dd><dd></dl><dl><dt>0_FORMULÁRIO_...pdf</dt><dd><dd></dl><dl><dt>0_Revisões se...pdf</dt><dd><dd></dl><dl><dt>1_Funções tri...pdf</dt><dd><dd></dl><dl><dt>2_Teoremas do...pdf</dt><dd><dd></dl><dl><dt>3_Integrais i...pdf</dt><dd><dd></dl><dl><dt>4_Integrais d...pdf</dt><dd><dd></dl><dl><dt>5_Integrais i...pdf</dt><dd><dd></dl><dl><dt>6_Séries numé...pdf</dt><dd><dd></dl><dl><dt>Formulário_Sé...pdf</dt><dd><dd></dl><dl><dt>Resumo_Integr...pdf</dt><dd><dd></dl><dl><dt>Tópicos_Teste 1.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 24),
(74, 'Caderno de 2016/2017', '/notes/primeiro_ano/segundo_semestre/c2/calculoii_apontamentos_003.pdf', 42729, 1719, 4, 22, 0, 0, 0, 0, 0, 0, 1, NULL, '2021-06-14 19:17:30', 1, 18),
(75, 'Resumos Cálculo II 2018/2019 (zip)', '/notes/primeiro_ano/segundo_semestre/c2/Goncalo_C2.zip', 42729, 1275, 3, 19, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>0_Revisões.pdf</dt><dd><dd></dl><dl><dt>1_Séries de p...pdf</dt><dd><dd></dl><dl><dt>2_Sucessões e...pdf</dt><dd><dd></dl><dl><dt>3.1_Funções r...pdf</dt><dd><dd></dl><dl><dt>3.2_Funções r...pdf</dt><dd><dd></dl><dl><dt>4_Equações di...pdf</dt><dd><dd></dl><dl><dt>5_Transformad...pdf</dt><dd><dd></dl><dl><dt>Detalhes para...pdf</dt><dd><dd></dl><dl><dt>Detalhes para...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 21),
(76, 'Resumos 2016/2017', '/notes/mestrado/vi/vi_apontamentos_001.pdf', 44156, 1455, 4, 9, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 4),
(77, 'Resumos por capítulo (zip)', '/notes/mestrado/ws/JoaoAlegria_ResumosPorCapítulo.zip', 44158, 1455, 4, 25, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_R...</dt><dd><dd>0 pastas</dd><dd>10 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 8),
(78, 'Resumos 2016/2017', '/notes/mestrado/ws/web_semantica_apontamentos_001.pdf', 44158, 1455, 4, 25, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 9),
(79, 'Apontamentos Diversos', '/notes/terceiro_ano/primeiro_semestre/icm/Inês_Correia_ICM.pdf', 45424, 1335, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(80, 'Apontamentos Diversos', '/notes/terceiro_ano/segundo_semestre/tqs/Inês_Correia_TQS.pdf', 45426, 1335, 4, 13, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 14),
(81, 'Resumos (zip)', '/notes/terceiro_ano/segundo_semestre/tqs/resumos.zip', 45426, NULL, 4, 13, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos_chave</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 22),
(82, 'Resumos 2015/2016', '/notes/terceiro_ano/segundo_semestre/tqs/tqs_apontamentos_002.pdf', 45426, 1455, 5, 13, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 3),
(83, 'Resumos 2017/2018 - I', '/notes/mestrado/ed/ed_dm_apontamentos_001.pdf', 45587, 1455, 4, 26, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 36),
(84, 'Resumos 2017/2018 - II', '/notes/mestrado/ed/ed_dm_apontamentos_002.pdf', 45587, 1455, 4, 26, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 48),
(85, 'Resumos MD 2018/2019 (zip)', '/notes/primeiro_ano/segundo_semestre/md/Goncalo_MD.zip', 47166, 1275, 3, 20, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1.1_Lógica pr...pdf</dt><dd><dd></dl><dl><dt>1.2_Conjuntos.pdf</dt><dd><dd></dl><dl><dt>1.3_Relações ...pdf</dt><dd><dd></dl><dl><dt>1.4_Funções.pdf</dt><dd><dd></dl><dl><dt>1.5_Relações ...pdf</dt><dd><dd></dl><dl><dt>1.6_Lógica de...pdf</dt><dd><dd></dl><dl><dt>2_Contextos e...pdf</dt><dd><dd></dl><dl><dt>3_Princípios ...pdf</dt><dd><dd></dl><dl><dt>4_Permutações.pdf</dt><dd><dd></dl><dl><dt>5_Agrupamento...pdf</dt><dd><dd></dl><dl><dt>6_Recorrência...pdf</dt><dd><dd></dl><dl><dt>7_Elementos d...pdf</dt><dd><dd></dl><dl><dt>Detalhes capí...pdf</dt><dd><dd></dl><dl><dt>Detalhes capí...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 27),
(86, 'Resumos 2017/2018', '/notes/primeiro_ano/segundo_semestre/md/MD_Capitulo5.pdf', 47166, 1002, 2, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 4),
(87, 'RafaelDireito_2016_2017_MD.zip', '/notes/primeiro_ano/segundo_semestre/md/RafaelDireito_2016_2017_MD.zip', 47166, 1800, 4, NULL, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...</dt><dd><dd>11 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 24),
(88, 'RafaelDireito_MD_16_17_Apontamentos (zip)', '/notes/primeiro_ano/segundo_semestre/md/RafaelDireito_MD_16_17_Apontamentos.zip', 47166, 1800, 4, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dl><dt>md_apontament...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 4),
(89, 'DS_MPEI_18_19_Testes (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Testes.zip', 40337, 1161, 3, 4, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Enunciados</dt><dd><dd>5 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>Teste 1 2015</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Teste 2 2015</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Teste 2 2017</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 23),
(90, 'DS_MPEI_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_SlidesTeoricos.zip', 40337, 1161, 3, 4, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>MPEI-2017-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2017-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dl><dt>MPEI-2018-201...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 27),
(91, 'DS_MPEI_18_19_Resumos (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Resumos.zip', 40337, 1161, 3, 4, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo1</dt><dd><dd>0 pastas</dd><dd>39 ficheiros</dd><dd></dl><dl><dt>Resumo2</dt><dd><dd>0 pastas</dd><dd>24 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 209),
(92, 'DS_MPEI_18_19_Projeto (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Projeto.zip', 40337, 1161, 3, 4, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>mpei.pptx</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 16),
(93, 'DS_MPEI_18_19_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Praticas.zip', 40337, 1161, 3, 4, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P01</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>P02</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P03</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>P04</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>P05</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P06</dt><dd><dd>0 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>P07</dt><dd><dd>0 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>P08</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>Remakes</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 9),
(94, 'DS_MPEI_18_19_Livros (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Livros.zip', 40337, 1161, 3, 4, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>estatistica-f...pdf</dt><dd><dd></dl><dl><dt>Livro.pdf</dt><dd><dd></dl><dl><dt>matlabnuminst...pdf</dt><dd><dd></dl><dl><dt>MATLAB_Starte...pdf</dt><dd><dd></dl><dl><dt>pt.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 6),
(95, 'DS_MPEI_18_19_Exercicios (zip)', '/notes/segundo_ano/primeiro_semestre/mpei/DS_MPEI_18_19_Exercicios.zip', 40337, 1161, 3, 4, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>2</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>3</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Slides Exercicios</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 37),
(96, 'Goncalo_ITW_18_19_Testes (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Testes.zip', 40380, 1275, 3, 8, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P7 05_Nov_201...</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>Teste teórico 1.zip</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(97, 'Goncalo_ITW_18_19_Resumos (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Resumos.zip', 40380, 1275, 3, 8, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>ITW _ BOOTSTRAP.pdf</dt><dd><dd></dl><dl><dt>ITW _ CSS.pdf</dt><dd><dd></dl><dl><dt>ITW _ HTML.pdf</dt><dd><dd></dl><dl><dt>ITW _ JAVASCRIPT.pdf</dt><dd><dd></dl><dl><dt>JAVACRIPT _ E...pdf</dt><dd><dd></dl><dl><dt>JAVACRIPT _P6...pdf</dt><dd><dd></dl><dl><dt>Resumo_T10_Kn...pdf</dt><dd><dd></dl><dl><dt>Resumo_T11_Du...pdf</dt><dd><dd></dl><dl><dt>Resumo_T8_jQu...pdf</dt><dd><dd></dl><dl><dt>Resumo_T9_Goo...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 12),
(98, 'Goncalo_ITW_18_19_Projeto (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Projeto.zip', 40380, 1275, 3, 8, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>P11 03_Nov_20...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>PROJETO</dt><dd><dd>147 pastas</dd><dd>147 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 33),
(99, 'Goncalo_ITW_18_19_Praticas (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/Goncalo_ITW_18_19_Praticas.zip', 40380, 1275, 3, 8, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P1 24_Set_2018</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P10 26_Nov_20...</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P11 03_Nov_20...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>P2 01_Out_2018</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>P3 08_Out_2018</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P4 15_Out_2018</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>P5 22_Out_2018</dt><dd><dd>1 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>P6 29_Out_2018</dt><dd><dd>1 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>P7 05_Nov_201...</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>P8 12_Nov_2018</dt><dd><dd>0 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>P9 19_Nov_201...</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 30),
(100, 'RafaelDireito_ITW_18_19_Testes (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Testes.zip', 40380, 1800, 4, 8, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bootstrap+Tes...rar</dt><dd><dd></dl><dl><dt>Teste Prático ITW</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>Teste Teórico 2</dt><dd><dd>0 pastas</dd><dd>20 ficheiros</dd><dd></dl><dl><dt>Teste_Prático_ITW</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>Teste_Prático...</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>ITW-Teste Teórico</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>ITW_Teste</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 9),
(101, 'RafaelDireito_ITW_18_19_Slides (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Slides.zip', 40380, 1800, 4, 8, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aula 1 - Apre...pdf</dt><dd><dd></dl><dl><dt>Aula 1 -Intro...pdf</dt><dd><dd></dl><dl><dt>Aula 10 - Goo...pdf</dt><dd><dd></dl><dl><dt>Aula 11 - ITW...pdf</dt><dd><dd></dl><dl><dt>Aula 11 - Tra...pdf</dt><dd><dd></dl><dl><dt>Aula 2 - Form...pdf</dt><dd><dd></dl><dl><dt>Aula 3 - CSS.pdf</dt><dd><dd></dl><dl><dt>Aula 4 -Twitt...pdf</dt><dd><dd></dl><dl><dt>Aula 5 -Javas...pdf</dt><dd><dd></dl><dl><dt>Aula 7 -Javas...pdf</dt><dd><dd></dl><dl><dt>Aula 8 -JQuery.pdf</dt><dd><dd></dl><dl><dt>Aula 9 -JQuer...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 19),
(102, 'RafaelDireito_ITW_18_19_Praticas (zip)', '/notes/primeiro_ano/primeiro_semestre/itw/RafaelDireito_ITW_16_17_Praticas.zip', 40380, 1800, 4, 8, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aula 8</dt><dd><dd>3 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Aula5-Js</dt><dd><dd>1 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>Aulas Práticas</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>Bilhete-Aviao</dt><dd><dd>6 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Calculadora-JS</dt><dd><dd>2 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Concerto- GER...</dt><dd><dd>3 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>Concerto-Jquery</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Concerto-Jque...</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Concerto-JS</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>Conferencia</dt><dd><dd>6 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Gráficos</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>ITW java</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>ITW-Bootstrap_1</dt><dd><dd>20 pastas</dd><dd>26 ficheiros</dd><dd></dl><dl><dt>ITW_jQuery</dt><dd><dd>3 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Links de Apoi...txt</dt><dd><dd></dl><dl><dt>Mapa</dt><dd><dd>3 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Treino-ITW-2</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Weather</dt><dd><dd>3 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>GitHub-  stor.txt</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 18),
(103, 'DS_SO_18_19_Testes (zip)', '/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Testes.zip', 40381, 1161, 3, 1, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Enunciados</dt><dd><dd>1 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Teorico-Pratico</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Teste 2015</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Teste 2017</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 46),
(104, 'DS_SO_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_SlidesTeoricos.zip', 40381, 1161, 3, 1, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>sop_1819_0918...pdf</dt><dd><dd></dl><dl><dt>sop_1819_1002...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1023...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1030...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1106...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1120...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1127...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1204...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1211...ppt</dt><dd><dd></dl><dl><dt>sop_1819_1218...ppt</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 11),
(105, 'DS_SO_18_19_ResumosTeoricos (zip)', '/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_ResumosTeoricos.zip', 40381, 1161, 3, 1, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Teorico</dt><dd><dd>0 pastas</dd><dd>43 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 157),
(106, 'DS_SO_18_19_ResumosPraticos (zip)', '/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_ResumosPraticos.zip', 40381, 1161, 3, 1, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pratico</dt><dd><dd>0 pastas</dd><dd>38 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 122),
(107, 'DS_SO_18_19_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Praticas.zip', 40381, 1161, 3, 1, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P01</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P02</dt><dd><dd>1 pastas</dd><dd>24 ficheiros</dd><dd></dl><dl><dt>P03</dt><dd><dd>0 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P04</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>P05</dt><dd><dd>2 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>P06</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>P07</dt><dd><dd>0 pastas</dd><dd>10 ficheiros</dd><dd></dl><dl><dt>P08</dt><dd><dd>1 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>P09</dt><dd><dd>7 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P10</dt><dd><dd>3 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>P11</dt><dd><dd>1 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Remakes</dt><dd><dd>24 pastas</dd><dd>18 ficheiros</dd><dd></dl><dl><dt>Remakes2</dt><dd><dd>9 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 5),
(108, 'DS_SO_18_19_Fichas (zip)', '/notes/segundo_ano/primeiro_semestre/so/DS_SO_18_19_Fichas.zip', 40381, 1161, 3, 1, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Enunciados</dt><dd><dd>10 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>Ficha 1</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>Ficha 2</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Ficha 3</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Ficha NEI 1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Ficha NEI 2</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>Ficha NEI 4</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 51),
(109, 'CD_18_19_Livros (zip)', '/notes/segundo_ano/segundo_semestre/cd/CD_18_19_Livros.zip', 40382, NULL, NULL, NULL, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Distributed_S...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 19),
(110, 'DS_CD_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_SlidesTeoricos.zip', 40382, 1161, 3, 2, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Aula 1.pdf</dt><dd><dd></dl><dl><dt>Aula 2.pdf</dt><dd><dd></dl><dl><dt>Aula 3.pdf</dt><dd><dd></dl><dl><dt>Aula 4.pdf</dt><dd><dd></dl><dl><dt>Aula 6.pdf</dt><dd><dd></dl><dl><dt>Aula 7.pdf</dt><dd><dd></dl><dl><dt>Aula 8.pdf</dt><dd><dd></dl><dl><dt>Cloud Computing.pdf</dt><dd><dd></dl><dl><dt>Flask.pdf</dt><dd><dd></dl><dl><dt>Syllabus.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 32),
(111, 'DS_CD_18_19_Resumos (zip)', '/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Resumos.zip', 40382, 1161, 3, 2, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>CDresumoch6.docx</dt><dd><dd></dl><dl><dt>CDresumoch6.pdf</dt><dd><dd></dl><dl><dt>CDresumoch7.docx</dt><dd><dd></dl><dl><dt>CDresumoch7.pdf</dt><dd><dd></dl><dl><dt>CDresumoch8.docx</dt><dd><dd></dl><dl><dt>GIT 101.pdf</dt><dd><dd></dl><dl><dt>Resumo Ch1-4</dt><dd><dd>0 pastas</dd><dd>104 ficheiros</dd><dd></dl><dl><dt>Resumos Ch5-8</dt><dd><dd>0 pastas</dd><dd>34 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 309),
(112, 'DS_CD_18_19_Projetos (zip)', '/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Projetos.zip', 40382, 1161, 3, 2, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>Projeto 1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Projeto 2</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(113, 'DS_CD_18_19_Praticas (zip)', '/notes/segundo_ano/segundo_semestre/cd/DS_CD_18_19_Praticas.zip', 40382, 1161, 3, 2, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P01</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>P02</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P03</dt><dd><dd>36 pastas</dd><dd>36 ficheiros</dd><dd></dl><dl><dt>P04</dt><dd><dd>6 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 3),
(114, 'DS_PDS_18_19_Testes (zip)', '/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Testes.zip', 40383, 1161, 3, 12, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Teste 2019</dt><dd><dd>0 pastas</dd><dd>26 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(115, 'DS_PDS_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_SlidesTeoricos.zip', 40383, 1161, 3, 12, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>PDS_0.pdf</dt><dd><dd></dl><dl><dt>PDS_09_Lambda...pdf</dt><dd><dd></dl><dl><dt>PDS_1_Softwar...pdf</dt><dd><dd></dl><dl><dt>PDS_2_GRASP.pdf</dt><dd><dd></dl><dl><dt>PDS_3_Pattern...pdf</dt><dd><dd></dl><dl><dt>PDS_4_Creatio...pdf</dt><dd><dd></dl><dl><dt>PDS_5_Structu...pdf</dt><dd><dd></dl><dl><dt>PDS_6_Behavio...pdf</dt><dd><dd></dl><dl><dt>PDS_7_Softwar...pdf</dt><dd><dd></dl><dl><dt>PDS_8_Reflection.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 81),
(116, 'DS_PDS_18_19_Resumos (zip)', '/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Resumos.zip', 40383, 1161, 3, 12, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo 1</dt><dd><dd>0 pastas</dd><dd>35 ficheiros</dd><dd></dl><dl><dt>Resumo 2</dt><dd><dd>0 pastas</dd><dd>25 ficheiros</dd><dd></dl><dl><dt>Resumo 3</dt><dd><dd>0 pastas</dd><dd>25 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 185),
(117, 'DS_PDS_18_19_Praticas (zip)', '/notes/segundo_ano/segundo_semestre/pds/DS_PDS_18_19_Praticas.zip', 40383, 1161, 3, 12, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Guioes</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>pds_2019_g22</dt><dd><dd>70 pastas</dd><dd>61 ficheiros</dd><dd></dl><dl><dt>PraticasRemade</dt><dd><dd>277 pastas</dd><dd>276 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 6),
(118, 'MAS_18_19_Bibliografia (zip)', '/notes/primeiro_ano/segundo_semestre/mas/MAS_18_19_Bibliografia.zip', 40431, NULL, NULL, NULL, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bibliografia_...pdf</dt><dd><dd></dl><dl><dt>Bibliografia_...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 6),
(119, 'MAS_18_19_Topicos_Estudo_Exame (zip)', '/notes/primeiro_ano/segundo_semestre/mas/MAS_18_19_Topicos_Estudo_Exame.zip', 40431, NULL, 3, 13, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>MAS 201819 - ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(120, 'Goncalo_MAS_18_19_Resumos (zip)', '/notes/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Resumos.zip', 40431, 1275, 3, 13, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1. O que é qu...pdf</dt><dd><dd></dl><dl><dt>2. Modelos de...pdf</dt><dd><dd></dl><dl><dt>3. Modelos no...pdf</dt><dd><dd></dl><dl><dt>MAA_Resumos.pdf</dt><dd><dd></dl><dl><dt>Post-it.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 10),
(121, 'Goncalo_MAS_18_19_Projeto (zip)', '/notes/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Projeto.zip', 40431, 1275, 3, 13, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>AMS-E3-Visao ...docx</dt><dd><dd></dl><dl><dt>Apresentacion...pdf</dt><dd><dd></dl><dl><dt>Apresentaç?o ...odt</dt><dd><dd></dl><dl><dt>CalEntregas.png</dt><dd><dd></dl><dl><dt>Elaboration 1</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Gui?o.pdf</dt><dd><dd></dl><dl><dt>Inception1</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>JMeter</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>MAS - Projeto...pdf</dt><dd><dd></dl><dl><dt>MicroSite</dt><dd><dd>24 pastas</dd><dd>20 ficheiros</dd><dd></dl><dl><dt>Projeto.zip</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 22),
(122, 'Goncalo_MAS_18_19_Praticas (zip)', '/notes/primeiro_ano/segundo_semestre/mas/Goncalo_MAS_18_19_Praticas.zip', 40431, 1275, 3, 13, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Lab1</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>Lab2</dt><dd><dd>1 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Lab3</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>Lab5</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>Lab6</dt><dd><dd>1 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>Lab7</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>MAS_Práticas-...zip</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 46),
(123, 'RafaelDireito_SMU_17_18_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Praticas.zip', 40432, 1800, 2, 15, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P</dt><dd><dd>11 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>12 pastas</dd><dd>12 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 40),
(124, 'RafaelDireito_SMU_17_18_TP (zip)', '/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_TP.zip', 40432, 1800, 2, 15, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>TP</dt><dd><dd>0 pastas</dd><dd>10 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 68),
(125, 'RafaelDireito_SMU_17_18_Prep2Test (zip)', '/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Prep2Teste.zip', 40432, 1800, 2, 15, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Prep2Teste</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 3),
(126, 'RafaelDireito_SMU_17_18_Bibliografia (zip)', '/notes/segundo_ano/primeiro_semestre/smu/RafaelDireito_SMU_17_18_Bibliografia.zip', 40432, 1800, 2, 15, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bibliografia</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 54),
(127, 'DS_SMU_18_19_Fichas (zip)', '/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Fichas.zip', 40432, 1161, 3, 14, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>12 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>13 pastas</dd><dd>13 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 113),
(128, 'DS_SMU_18_19_Livros (zip)', '/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Livros.zip', 40432, 1161, 3, 14, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Livros</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 54),
(129, 'DS_SMU_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_SlidesTeoricos.zip', 40432, 1161, 3, 14, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Teoricos</dt><dd><dd>1 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>2 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 30),
(130, 'DS_SMU_18_19_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Praticas.zip', 40432, 1161, 3, 14, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Praticas</dt><dd><dd>19 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>20 pastas</dd><dd>20 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 26),
(131, 'DS_SMU_18_19_Resumos (zip)', '/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Resumos.zip', 40432, 1161, 3, 14, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 181),
(132, 'DS_SMU_18_19_Testes (zip)', '/notes/segundo_ano/primeiro_semestre/smu/DS_SMU_18_19_Testes.zip', 40432, 1161, 3, 14, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>8 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>9 pastas</dd><dd>9 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 60),
(133, 'DS_RS_18_19_Testes (zip)', '/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Testes.zip', 40433, 1161, 3, 16, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>16 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>17 pastas</dd><dd>17 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 130),
(134, 'DS_RS_18_19_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Praticas.zip', 40433, 1161, 3, 16, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Praticas</dt><dd><dd>2 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 2),
(135, 'DS_RS_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_SlidesTeoricos.zip', 40433, 1161, 3, 16, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Teoricos</dt><dd><dd>0 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 10),
(136, 'DS_RS_18_19_Resumos (zip)', '/notes/segundo_ano/primeiro_semestre/rs/DS_RS_18_19_Resumos.zip', 40433, 1161, 3, 16, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(137, 'DS_AED_18_19_Resumos (zip)', '/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Resumos.zip', 40437, 1161, 3, 11, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 271),
(138, 'DS_AED_18_19_Livros (zip)', '/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Livros.zip', 40437, 1161, 3, 11, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Livros</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 20),
(139, 'DS_AED_18_19_Testes (zip)', '/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Testes.zip', 40437, 1161, 3, 11, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>24 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>25 pastas</dd><dd>25 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 94),
(140, 'DS_AED_18_19_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Praticas.zip', 40437, 1161, 3, 11, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pr?Çáticas</dt><dd><dd>21 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>20 pastas</dd><dd>20 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 20),
(141, 'DS_AED_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_SlidesTeoricos.zip', 40437, 1161, 3, 11, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Te?óricos</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 2),
(142, 'DS_AED_18_19_Fichas (zip)', '/notes/segundo_ano/primeiro_semestre/aed/DS_AED_18_19_Fichas.zip', 40437, 1161, 3, 11, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>2 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 16);
INSERT INTO `notes` (`id`, `name`, `location`, `subject`, `author`, `schoolYear`, `teacher`, `summary`, `tests`, `bibliography`, `slides`, `exercises`, `projects`, `notebook`, `content`, `createdAt`, `type`, `size`) VALUES
(143, 'RafaelDireito_AED_17_18_Praticas (zip)', '/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Praticas.zip', 40437, 1800, 2, 31, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>P</dt><dd><dd>4 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>5 pastas</dd><dd>5 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(144, 'RafaelDireito_AED_17_18_Testes (zip)', '/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Testes.zip', 40437, 1800, 2, 31, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>0 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(145, 'RafaelDireito_AED_17_18_Books (zip)', '/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_Praticas.zip', 40437, 1800, 2, 31, 0, 0, 1, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2, NULL),
(146, 'RafaelDireito_AED_17_18_LearningC (zip)', '/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_LearningC.zip', 40437, 1800, 2, 31, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>LearningC</dt><dd><dd>0 pastas</dd><dd>21 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(147, 'RafaelDireito_AED_17_18_AED (pdf)', '/notes/segundo_ano/primeiro_semestre/aed/RafaelDireito_AED_17_18_AED.pdf', 40437, 1800, 2, 31, 0, 0, 0, 1, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(148, 'DS_Compiladores_18_19_Praticas (zip)', '/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Praticas.zip', 41469, 1161, 3, 10, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Praticas</dt><dd><dd>35 pastas</dd><dd>32 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>31 pastas</dd><dd>31 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(149, 'DS_Compiladores_18_19_Fichas (zip)', '/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Fichas.zip', 41469, 1161, 3, 10, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 42),
(150, 'DS_Compiladores_18_19_Testes (zip)', '/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Testes.zip', 41469, 1161, 3, 10, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 33),
(151, 'DS_Compiladores_18_19_Resumos (zip)', '/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_Resumos.zip', 41469, 1161, 3, 10, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>3 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>4 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 242),
(152, 'DS_Compiladores_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/segundo_semestre/c/DS_Compiladores_18_19_SlidesTeoricos.zip', 41469, 1161, 3, 10, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Te?óricos</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 4),
(153, 'DS_IHC_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_SlidesTeoricos.zip', 41549, 1161, 3, 9, 0, 0, 0, 1, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2, NULL),
(154, 'DS_IHC_18_19_Fichas (zip)', '/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_Fichas.zip', 41549, 1161, 3, 9, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Fichas</dt><dd><dd>5 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>6 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 51),
(155, 'DS_IHC_18_19_Projetos (zip)', '/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_Projetos.zip', 41549, 1161, 3, 9, 0, 0, 0, 0, 0, 1, 0, '<dl><dt>/</dt><dd><dl><dt>Projetos</dt><dd><dd>5 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>6 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 90),
(156, 'DS_IHC_18_19_Testes (zip)', '/notes/segundo_ano/segundo_semestre/ihc/DS_IHC_18_19_SlidesTeoricos.zip', 41549, 1161, 3, 9, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2, NULL),
(157, 'Resumos (zip)', '/notes/terceiro_ano/primeiro_semestre/ia/resumo.zip', 40846, NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumo.pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(158, 'DS_EF_17_18_Resumos (zip)', '/notes/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Resumos.zip', 41791, 1161, 2, 24, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 4),
(159, 'DS_EF_17_18_Exercicios (zip)', '/notes/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Exercicios.zip', 41791, 1161, 2, 24, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Exerci?ücios</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 3),
(160, 'DS_EF_17_18_Exames (zip)', '/notes/primeiro_ano/primeiro_semestre/ef/DS_EF_17_18_Exames.zip', 41791, 1161, 2, 24, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Exames</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 2),
(161, 'Exames (zip)', '/notes/primeiro_ano/segundo_semestre/iac/exames.zip', 42502, NULL, NULL, 6, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>iac_apontamen...pdf</dt><dd><dd></dl><dl><dt>iac_apontamen...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(162, 'Goncalo_IAC_18_19_Praticas (zip)', '/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Praticas.zip', 42502, 1275, 3, 6, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pr?íticas</dt><dd><dd>113 pastas</dd><dd>111 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>113 pastas</dd><dd>113 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 44),
(163, 'Goncalo_IAC_18_19_Resumos (zip)', '/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Resumos.zip', 42502, 1275, 3, 6, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 17),
(164, 'Goncalo_IAC_18_19_Apontamentos (zip)', '/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Apontamentos.zip', 42502, 1275, 3, 6, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Apontamentos</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 3),
(165, 'Goncalo_IAC_18_19_Bibliografia (zip)', '/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Bibliografia.zip', 42502, 1275, 3, 6, 0, 0, 1, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Bibliografia ...pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>Bibliografia ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 18),
(166, 'Goncalo_IAC_18_19_Testes (zip)', '/notes/primeiro_ano/segundo_semestre/iac/Goncalo_IAC_18_19_Testes.zip', 42502, 1275, 3, 6, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 2),
(167, 'RafaelDireito_IAC_16_17_Testes (zip)', '/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Testes.zip', 42502, 1800, 4, 6, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Testes</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 3),
(168, 'RafaelDireito_IAC_16_17_Teorica (zip)', '/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Teorica.zip', 42502, 1800, 4, 6, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Te?órica</dt><dd><dd>0 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 14),
(169, 'RafaelDireito_IAC_16_17_FolhasPraticas (zip)', '/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_FolhasPraticas.zip', 42502, 1800, 4, 6, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>FolhasPr?Çáticas</dt><dd><dd>0 pastas</dd><dd>16 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 13),
(170, 'RafaelDireito_IAC_16_17_ExerciciosResolvidos (zip)', '/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_ExerciciosResolvidos.zip', 42502, 1800, 4, 6, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>ExerciciosResolvidos</dt><dd><dd>6 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>7 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(171, 'RafaelDireito_IAC_16_17_Resumos (zip)', '/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_Resumos.zip', 42502, 1800, 4, 6, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>RafaelDireito...pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>RafaelDiteito...pdf</dt><dd><dd></dl><dl><dt>RafaelDireito...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 10),
(172, 'RafaelDireito_IAC_16_17_DossiePedagogicov2 (zip)', '/notes/primeiro_ano/segundo_semestre/iac/RafaelDireito_IAC_16_17_DossiePedagogicov2.zip', 42502, 1800, 4, 6, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>DossiePedagog...pdf</dt><dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(173, 'DS_BD_18_19_SlidesTeoricos (zip)', '/notes/segundo_ano/segundo_semestre/bd/DS_BD_18_19_SlidesTeoricos.zip', 42532, 1161, 3, 7, 0, 0, 0, 1, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Slides Te?óricos</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 30),
(174, 'DS_BD_18_19_Resumos (zip)', '/notes/segundo_ano/segundo_semestre/bd/DS_BD_18_19_Resumos.zip', 42532, 1161, 3, 7, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>2 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>3 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 144),
(175, 'DS_BD_18_19_Praticas (zip)', '/notes/segundo_ano/segundo_semestre/bd/DS_BD_18_19_Praticas.zip', 42532, 1161, 3, 7, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Pr?Çáticas</dt><dd><dd>48 pastas</dd><dd>34 ficheiros</dd><dd></dl><dl><dt>__MACOSX</dt><dd><dd>45 pastas</dd><dd>45 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 81),
(176, 'Resumos Diversos (zip)', '/notes/segundo_ano/segundo_semestre/bd/Resumos.zip', 42532, NULL, NULL, NULL, 1, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Resumos</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 1),
(177, 'Resumos EF', '/notes/primeiro_ano/primeiro_semestre/ef/CarolinaAlbuquerque_EF_Resumo.pdf', 41791, 1023, 5, 24, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 8),
(178, 'Resolução Fichas EF', '/notes/primeiro_ano/primeiro_semestre/ef/CarolinaAlbuquerque_EF_ResolucoesFichas.zip', 41791, 1023, 5, 24, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>CarolinaAlbuq...</dt><dd><dd>6 pastas</dd><dd>0 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 169),
(179, 'Exames SIO resolvidos', '/notes/terceiro_ano/primeiro_semestre/sio/JoaoAlegria_Exames.zip', 42573, 1455, 4, NULL, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_Exames</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 13),
(180, 'Resumos SIO', '/notes/terceiro_ano/primeiro_semestre/sio/JoaoAlegria_Resumos.zip', 42573, 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>JoaoAlegria_Resumos</dt><dd><dd>1 pastas</dd><dd>2 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 20),
(181, 'Exames e testes ALGA', '/notes/primeiro_ano/primeiro_semestre/alga/Rafael_Direito_Exames.zip', 42709, 1800, 4, 23, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dl><dt>alga_apontame...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 9),
(182, 'Fichas resolvidas ALGA', '/notes/primeiro_ano/primeiro_semestre/alga/RafaelDireito_Fichas.pdf', 42709, 1800, 4, 23, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 15),
(183, 'Resumos ALGA ', '/notes/primeiro_ano/primeiro_semestre/alga/RafelDireito_Resumos.pdf', 42709, 1800, 4, 23, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 8),
(184, 'Caderno de cálculo', '/notes/primeiro_ano/primeiro_semestre/c1/CarolinaAlbuquerque_C1_caderno.pdf', 42728, 1023, 5, 19, 0, 0, 0, 0, 0, 0, 1, NULL, '2021-06-14 19:17:30', 1, 11),
(185, 'Fichas resolvidas CII', '/notes/primeiro_ano/segundo_semestre/c2/PedroOliveira_Fichas.zip', 42729, 1764, 3, 19, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Ficha1</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dl><dt>Ficha2</dt><dd><dd>0 pastas</dd><dd>15 ficheiros</dd><dd></dl><dl><dt>Ficha3</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>ficha3-part2.pdf</dt><dd><dd></dl><dl><dt>ficha3.pdf</dt><dd><dd></dl><dl><dt>Ficha4_000001.pdf</dt><dd><dd></dl><dl><dt>Ficha5_000001.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 110),
(186, 'Testes CII', '/notes/primeiro_ano/segundo_semestre/c2/PedroOliveira_testes-resol.zip', 42729, 1764, 3, 19, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>testes-resol</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 24),
(187, 'Apontamentos Gerais ICM', '/notes/terceiro_ano/primeiro_semestre/icm/Resumo Geral Android.pdf', 45424, 1335, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 3),
(188, 'Resoluções material apoio MD', '/notes/primeiro_ano/segundo_semestre/md/PedroOliveira_EA.zip', 47166, 1764, 3, 20, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>EA(livro nos ...</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>EA1</dt><dd><dd>0 pastas</dd><dd>7 ficheiros</dd><dd></dl><dl><dt>EA1(refeito)</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>EA2(Completo)</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>EA2.pdf</dt><dd><dd></dl><dl><dt>EA2ex4.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 45),
(189, 'Resoluções fichas MD', '/notes/primeiro_ano/segundo_semestre/md/PedroOliveira_Fichas.zip', 47166, 1764, 3, 20, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Ficha1</dt><dd><dd>0 pastas</dd><dd>5 ficheiros</dd><dd></dl><dl><dt>ficha2.pdf</dt><dd><dd></dl><dl><dt>ficha3_000001.pdf</dt><dd><dd></dl><dl><dt>ficha4_000001.pdf</dt><dd><dd></dl><dl><dt>ficha5-cont.pdf</dt><dd><dd></dl><dl><dt>ficha5.pdf</dt><dd><dd></dl><dl><dt>Ficha6.pdf</dt><dd><dd></dl><dl><dt>ficha7(incomp...pdf</dt><dd><dd></dl><dl><dt>Ficha8_000001.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 79),
(190, 'Resoluções testes MD', '/notes/primeiro_ano/segundo_semestre/md/PedroOliveira_testes.zip', 47166, 1764, 3, 20, 0, 1, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>testes</dt><dd><dd>0 pastas</dd><dd>8 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 33),
(191, 'Estudo para o exame', '/notes/segundo_ano/primeiro_semestre/rs/RafaelDireito_2017_RSexame.pdf', 40433, 1800, 2, 4, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 6),
(192, 'Exercícios TPW', '/notes/terceiro_ano/segundo_semestre/tpw/Exercicios.zip', 40551, NULL, NULL, NULL, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Exercicios</dt><dd><dd>0 pastas</dd><dd>12 ficheiros</dd><dd></dl><dd></dl>', '2021-06-14 19:17:30', 2, 14),
(193, 'Resumos 2016/2017', '/notes/mestrado/as/as_apontamentos_001.pdf', 40757, 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 2),
(194, 'Resumos por capítulo (zip)', '/notes/mestrado/as/JoaoAlegria_ResumosPorCapitulo.zip', 40757, 1455, 4, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 2, 2),
(195, 'Exercícios IA', '/notes/terceiro_ano/primeiro_semestre/ia/Inês_Correia_IA_exercícios.pdf', 40846, 1335, NULL, NULL, 0, 0, 0, 0, 1, 0, 0, NULL, '2021-06-14 19:17:30', 1, 7),
(196, 'Resumos IA', '/notes/terceiro_ano/primeiro_semestre/ia/Inês_Correia_IA_resumo.pdf', 40846, 1335, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-06-14 19:17:30', 1, 9),
(197, 'Caderno MD Cap. 6 e 7', '/notes/primeiro_ano/segundo_semestre/md/MarianaRosa_Caderno_Capts6e7.pdf', 47166, 2051, 7, 32, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, '2021-06-16 22:18:59', 1, 20),
(198, 'Resumos 1.ª Parte MD', '/notes/primeiro_ano/segundo_semestre/md/MarianaRosa_Resumos_1aParte.pdf', 47166, 2051, 7, 32, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:21:33', 1, 13),
(199, 'Práticas BD', '/notes/segundo_ano/segundo_semestre/bd/Goncalo_Praticas.zip', 42532, 1275, 7, 8, NULL, NULL, NULL, NULL, 1, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>P</dt><dd><dd>11 pastas</dd><dd>6 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:27:12', 2, 23),
(200, 'Resumos BD', '/notes/segundo_ano/segundo_semestre/bd/Goncalo_Resumos.zip', 42532, 1275, 7, 7, 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>TP</dt><dd><dd>0 pastas</dd><dd>14 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:28:20', 2, 20),
(201, 'Resumos Caps. 3 e 4', '/notes/segundo_ano/segundo_semestre/c/Goncalo_TP.zip', 41469, 1275, 7, 10, 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>TP</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 8),
(202, 'Resumos ANTLR4', '/notes/segundo_ano/segundo_semestre/c/Goncalo_ANTLR4.zip', 41469, 1275, 7, 10, 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>ANTLR4 Listeners.pdf</dt><dd><dd></dl><dl><dt>ANTLR4 Visitors.pdf</dt><dd><dd></dl><dl><dt>ANTLR4.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 1),
(203, 'Guiões P Resolvidos', '/notes/segundo_ano/segundo_semestre/c/Goncalo_GuioesPraticos.zip', 41469, 1275, 7, 10, NULL, NULL, NULL, NULL, 1, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>P1_20fev2020</dt><dd><dd>1 pastas</dd><dd>6 ficheiros</dd><dd></dl><dl><dt>P2_05fev2020</dt><dd><dd>35 pastas</dd><dd>37 ficheiros</dd><dd></dl><dl><dt>P3</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 2),
(204, 'Resumos Práticos', '/notes/segundo_ano/segundo_semestre/c/Goncalo_ResumosPraticos.zip', 41469, 1275, 7, 10, 1, NULL, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>1_Compiladores.pdf</dt><dd><dd></dl><dl><dt>2_ANTLR4.pdf</dt><dd><dd></dl><dl><dt>3_Análise sem...pdf</dt><dd><dd></dl><dl><dt>5_Análise sem...pdf</dt><dd><dd></dl><dl><dt>6_Geração de ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 17),
(205, 'Bibliografia', '/notes/segundo_ano/segundo_semestre/cd/Bibliografia.zip', 40382, 1275, 7, 2, NULL, NULL, 1, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>mvsteen-distr...pdf</dt><dd><dd></dl><dl><dt>ResolucaoPerg...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 39),
(206, 'Cheatsheet', '/notes/segundo_ano/segundo_semestre/cd/Goncalo_CheatSheet.pdf', 40382, 1275, 7, 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 1, 1),
(207, 'Aulas Resolvidas', '/notes/segundo_ano/segundo_semestre/cd/Goncalo_Aulas.zip', 40382, 1275, 7, 2, NULL, NULL, NULL, NULL, 1, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>P1_11Fev2020</dt><dd><dd>138 pastas</dd><dd>140 ficheiros</dd><dd></dl><dl><dt>P2_10Fev2020</dt><dd><dd>125 pastas</dd><dd>128 ficheiros</dd><dd></dl><dl><dt>P3_28Abr2020</dt><dd><dd>103 pastas</dd><dd>104 ficheiros</dd><dd></dl><dl><dt>P4_19Mai2020</dt><dd><dd>183 pastas</dd><dd>183 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 8),
(208, 'Projeto1', '/notes/segundo_ano/segundo_semestre/cd/Goncalo_Projeto1.zip', 40382, 1275, 7, 2, NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>message-broke...</dt><dd><dd>260 pastas</dd><dd>268 ficheiros</dd><dd></dl><dl><dt>Projecto 1 - ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 3),
(209, 'Projeto2', '/notes/segundo_ano/segundo_semestre/cd/Goncalo_Projeto2.zip', 40382, 1275, 7, 2, NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>distributed-o...</dt><dd><dd>7 pastas</dd><dd>22 ficheiros</dd><dd></dl><dl><dt>Projecto 2 - ...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 15),
(210, 'Resumos Teóricos', '/notes/segundo_ano/segundo_semestre/cd/Goncalo_TP.pdf', 40382, 1275, 7, 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 1, 6),
(211, 'Paper \"Help, I am stuck...\"', '/notes/segundo_ano/segundo_semestre/ihc/Goncalo_Francisca_Paper.zip', 41549, 1275, 7, 9, NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>92972_93102_[...pdf</dt><dd><dd></dl><dl><dt>IHC_Paper.pdf</dt><dd><dd></dl><dl><dt>Paper-selecti...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 2),
(212, 'Resumos (incompletos)', '/notes/segundo_ano/segundo_semestre/ihc/Goncalo_TP.pdf', 41549, 1275, 7, 9, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 1, 1),
(213, 'Perguntitas de preparação exame', '/notes/segundo_ano/segundo_semestre/ihc/Perguntitaspreparaçaoexame.zip', 41549, 1275, 7, 9, NULL, 1, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>(1) User prof...pdf</dt><dd><dd></dl><dl><dt>(2) User ... ...pdf</dt><dd><dd></dl><dl><dt>(3) User mode...pdf</dt><dd><dd></dl><dl><dt>(4) Input & O...pdf</dt><dd><dd></dl><dl><dt>(5) Usability...pdf</dt><dd><dd></dl><dl><dt>exam.pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 1),
(214, 'Resumos teóricos', '/notes/segundo_ano/segundo_semestre/pds/Goncalo_TP.pdf', 40383, 1275, 7, 12, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-16 22:32:40', 1, 11),
(215, 'Projeto final: Padrões Bridge e Flyweight e Refactoring', '/notes/segundo_ano/segundo_semestre/pds/Goncalo_Projeto.zip', 40383, 1275, 7, 12, NULL, NULL, NULL, NULL, NULL, 1, NULL, '<dl><dt>/</dt><dd><dl><dt>Entrega</dt><dd><dd>0 pastas</dd><dd>4 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 74),
(216, 'Aulas P Resolvidas', '/notes/segundo_ano/segundo_semestre/pds/Goncalo_Aulas.zip', 40383, 1275, 7, 12, NULL, NULL, NULL, NULL, 1, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>P1_11fev2020</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P2_03mar2020</dt><dd><dd>0 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P3_10mar2020</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P4_17mar2020</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>P5_24mar2020</dt><dd><dd>1 pastas</dd><dd>1 ficheiros</dd><dd></dl><dl><dt>P6_31mar2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P7_14abr2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P8_21abr2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P9_28abr2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P10_05mai2020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P11_19mai29020</dt><dd><dd>0 pastas</dd><dd>3 ficheiros</dd><dd></dl><dl><dt>P12_26mai2020</dt><dd><dd>0 pastas</dd><dd>0 ficheiros</dd><dd></dl><dl><dt>P13_02jun2020</dt><dd><dd>0 pastas</dd><dd>2 ficheiros</dd><dd></dl><dl><dt>pds_2020_g205</dt><dd><dd>482 pastas</dd><dd>481 ficheiros</dd><dd></dl><dl><dt>Readme.txt</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 38),
(217, 'Exame final', '/notes/segundo_ano/segundo_semestre/pds/Goncalo_Exame.zip', 40383, 1275, 7, 12, NULL, 1, NULL, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>92972</dt><dd><dd>0 pastas</dd><dd>16 ficheiros</dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 1),
(218, 'Bibliografia', '/notes/segundo_ano/segundo_semestre/pds/Bibliografia.zip', 40383, 1275, 7, 12, NULL, NULL, 1, NULL, NULL, NULL, NULL, '<dl><dt>/</dt><dd><dl><dt>applying-uml-...pdf</dt><dd><dd></dl><dl><dt>DesignPatterns.pdf</dt><dd><dd></dl><dl><dt>kupdf.net_use...pdf</dt><dd><dd></dl><dl><dt>software-arch...pdf</dt><dd><dd></dl><dd></dl>', '2021-06-16 22:32:40', 2, 159),
(220, 'Projeto final \"Show tracker\"', 'https://github.com/gmatosferreira/show-tracker-app', 41549, 1275, 7, 9, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, '2021-10-18 15:00:00', 3, NULL),
(232, 'AI: A Modern Approach', '/notes/terceiro_ano/primeiro_semestre/ia/artificial-intelligence-modern-approach.9780131038059.25368.pdf', 40846, NULL, 8, 30, 0, 0, 1, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 38),
(238, 'Resumos', '/notes/terceiro_ano/primeiro_semestre/ia/Goncalo_IA_TP.pdf', 40846, 1275, 8, 30, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 3),
(241, 'Notas código práticas', '/notes/terceiro_ano/primeiro_semestre/ia/Goncalo_Código_Anotado_Práticas.zip', 40846, 1275, 8, 2, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>BayesNet.pdf</dt><dd><dd></dl><dl><dt>ConstraintSearch.pdf</dt><dd><dd></dl><dl><dt>SearchTree.pdf</dt><dd><dd></dl><dl><dt>SemanticNetwork.pdf</dt><dd><dd></dl><dl><dt>Strips.pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 4),
(244, 'Código práticas', '/notes/terceiro_ano/primeiro_semestre/ia/Goncalo_Praticas.zip', 40846, 1275, 8, 2, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>guiao-de-prog...</dt><dd><dd>6 pastas</dd><dd>9 ficheiros</dd><dd></dl><dl><dt>guiao-rc-gmat...</dt><dd><dd>6 pastas</dd><dd>13 ficheiros</dd><dd></dl><dl><dt>guiao-sobre-p...</dt><dd><dd>6 pastas</dd><dd>15 ficheiros</dd><dd></dl><dl><dt>ia-iia-tpi-1-...</dt><dd><dd>4 pastas</dd><dd>11 ficheiros</dd><dd></dl><dl><dt>ia-iia-tpi2-g...</dt><dd><dd>1 pastas</dd><dd>10 ficheiros</dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 2),
(247, 'Resumos', '/notes/terceiro_ano/primeiro_semestre/ge/Goncalo_GE_TP.pdf', 2450, 1275, 8, 34, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 2),
(250, 'Post-its', '/notes/terceiro_ano/primeiro_semestre/ge/Goncalo_Postits.zip', 2450, 1275, 8, 34, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_Introduçao ...pdf</dt><dd><dd></dl><dl><dt>2_Modelo de n...pdf</dt><dd><dd></dl><dl><dt>3_Modelo de n...pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 11),
(253, 'Post-its', '/notes/terceiro_ano/primeiro_semestre/ies/Goncalo_Postits.zip', 40384, 1275, 8, 12, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_IES.pdf</dt><dd><dd></dl><dl><dt>2_Processo so...pdf</dt><dd><dd></dl><dl><dt>3_Desenvolvim...pdf</dt><dd><dd></dl><dl><dt>4_Devops.pdf</dt><dd><dd></dl><dl><dt>5_Padroes arq...pdf</dt><dd><dd></dl><dl><dt>6_Web framewo...pdf</dt><dd><dd></dl><dl><dt>8_Spring fram...pdf</dt><dd><dd></dl><dl><dt>9_Spring boot.pdf</dt><dd><dd></dl><dl><dt>10_Microserviços.pdf</dt><dd><dd></dl><dl><dt>11_Sistemas b...pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 12),
(256, 'Aulas práticas', '/notes/terceiro_ano/primeiro_semestre/ies/Goncalo_Práticas.zip', 40384, 1275, 8, 12, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Lab1_92972.zip</dt><dd><dd></dl><dl><dt>Lab2_92972.zip</dt><dd><dd></dl><dl><dt>Lab3_92972.zip</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 3),
(259, 'Resumos', '/notes/terceiro_ano/primeiro_semestre/ies/Goncalo_IES_TP.pdf', 40384, 1275, 8, 12, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 5),
(262, 'Projeto final \"Store Go\"', 'https://github.com/gmatosferreira/IES_Project_G31', 40384, 1275, 8, 12, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', 3, NULL),
(265, 'Resumos', '/notes/terceiro_ano/primeiro_semestre/sio/Goncalo_SIO_TP.pdf', 42573, 1275, 8, 3, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 4),
(268, 'Tópicos exame', '/notes/terceiro_ano/primeiro_semestre/sio/Goncalo_Tópicos_exame.pdf', 42573, 1275, 8, 3, 0, 1, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 2),
(271, 'Security in Computing', '/notes/terceiro_ano/primeiro_semestre/sio/security-in-computing-5-e.pdf', 42573, NULL, 8, 3, 0, 0, 1, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 18),
(274, 'Projeto 1 \"Exploração de vulnerabilidades\"', '/notes/terceiro_ano/primeiro_semestre/sio/Goncalo_[SIO][Projeto 1]_Relatório.pdf', 42573, 1275, 8, 3, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', 1, 1),
(277, 'Projeto 4 \"Forensics\"', '/notes/terceiro_ano/primeiro_semestre/sio/Goncalo_[SIO][Projeto 4]_Relatório.pdf', 42573, 1275, 8, 3, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', 1, 1),
(280, 'Projeto 2 \"Secure Media Player\"', 'https://github.com/gmatosferreira/securemediaplayer', 42573, 1275, 8, 3, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-10-18 00:00:00', 3, NULL),
(283, 'Resumos', '/notes/terceiro_ano/primeiro_semestre/cbd/Goncalo_CBD_TP.pdf', 40385, 1275, 8, 12, 1, 0, 0, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 3),
(286, 'Post-its', '/notes/terceiro_ano/primeiro_semestre/cbd/Goncalo_Postits.zip', 40385, 1275, 8, 12, 1, 0, 0, 0, 0, 0, 0, '<dl><dt>/</dt><dd><dl><dt>1_Foco nos dados.pdf</dt><dd><dd></dl><dl><dt>2_Modelos de ...pdf</dt><dd><dd></dl><dl><dt>3_Armazenamen...pdf</dt><dd><dd></dl><dl><dt>4_Formatos do...pdf</dt><dd><dd></dl><dl><dt>5 a 8_Tipos b...pdf</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 6),
(289, 'Práticas', '/notes/terceiro_ano/primeiro_semestre/cbd/Goncalo_Praticas.zip', 40385, 1275, 8, 12, 0, 0, 0, 0, 1, 0, 0, '<dl><dt>/</dt><dd><dl><dt>Lab-1_92972.zip</dt><dd><dd></dl><dl><dt>Lab2_92972.zip</dt><dd><dd></dl><dl><dt>92972_Lab3.zip</dt><dd><dd></dl><dl><dt>92972_Lab4.zip</dt><dd><dd></dl><dd></dl>', '2021-10-18 00:00:00', 2, 4),
(292, 'Designing Data Intensive Applications', '/notes/terceiro_ano/primeiro_semestre/cbd/Designing Data Intensive Applications.pdf', 40385, NULL, 8, 12, 0, 0, 1, 0, 0, 0, 0, NULL, '2021-10-18 00:00:00', 1, 25),
(298, 'Projeto 2 \"Secure Media Player\"', 'https://github.com/margaridasmartins/digital-rights-management', 42573, 1602, 8, 3, 0, 0, 0, 0, 0, 1, 0, NULL, '2021-11-15 19:17:30', 3, NULL),
(304, 'Práticas POO', 'https://github.com/Rui-FMF/POO', 40436, 1821, 3, 28, 0, 1, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', 3, NULL),
(307, 'Práticas FP', 'https://github.com/Rui-FMF/FP', 40379, 1821, 3, 27, 0, 0, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', 3, NULL),
(313, 'Práticas IAC', 'https://github.com/Rui-FMF/IAC', 42502, 1821, 3, 6, 0, 0, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', 3, NULL),
(319, 'Projeto RS', 'https://github.com/Rui-FMF/RS', 40433, 1821, 7, 16, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(322, 'Práticas e projeto MPEI', 'https://github.com/Rui-FMF/MPEI', 40337, 1821, 7, 28, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(325, 'Projetos AED', 'https://github.com/Rui-FMF/AED', 40437, 1821, 7, 11, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(328, 'Projetos SO', 'https://github.com/Rui-FMF/SO', 40381, 1821, 7, 1, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(331, 'Guiões e Exame P, Projeto T', 'https://github.com/Rui-FMF/PDS', 40383, 1821, 7, 12, 0, 1, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(334, 'Práticas e Projetos CD', 'https://github.com/Rui-FMF/CD', 40382, 1821, 7, 2, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(337, 'Projeto 1 TAA', 'https://github.com/Rui-FMF/TAA_1', 12832, 1821, 8, 40, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(340, 'Projetos e artigo IHC', 'https://github.com/Rui-FMF/IHC', 41549, 1821, 7, 9, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(343, 'Guiões P e Homework TQS', 'https://github.com/Rui-FMF/TQS', 45426, 1821, 8, 13, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(346, 'Práticas e projeto C', 'https://github.com/Rui-FMF/C', 41469, 1821, 7, 10, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(349, 'Labs CBD', 'https://github.com/Rui-FMF/CBD', 40385, 1821, 8, 12, 0, 0, 0, 0, 1, 0, 0, '', '2021-11-15 00:00:00', 3, NULL),
(352, 'Guiões, TPI e Projeto de IA', 'https://github.com/Rui-FMF/IA', 40846, 1821, 8, 2, 0, 1, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(355, 'Labs e projeto de IES', 'https://github.com/Rui-FMF/IES', 40384, 1821, 8, 12, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(358, 'Projetos SIO', 'https://github.com/Rui-FMF/SIO', 42573, 1821, 8, 3, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(361, 'Projetos TPW', 'https://github.com/Rui-FMF/TPW', 40551, 1821, 8, 25, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(364, 'Projeto de IES', 'https://github.com/margaridasmartins/IES_Project', 40384, 1602, 8, 12, 0, 0, 0, 0, 0, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(367, 'Guiões P e Homework TQS', 'https://github.com/margaridasmartins/TQSLabs', 45426, 1602, 8, 13, 0, 0, 0, 0, 1, 1, 0, '', '2021-11-15 00:00:00', 3, NULL),
(370, 'Programas MSF', '/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_Programas.zip', 14817, 2125, 8, 29, 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', 2, NULL),
(373, 'Exercícios resolvidos MSF', '/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_ExsResolvidos.zip', 14817, 2125, 8, 29, 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', 2, NULL),
(376, 'Exercícios MSF', '/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_Exercicios.zip', 14817, 2125, 8, 29, 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', 2, NULL),
(379, 'Guiões práticos MSF', '/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_Ps.zip', 14817, 2125, 8, 29, 0, 0, 0, 0, 1, 0, 0, NULL, '2022-01-31 20:37:14', 2, NULL),
(382, 'Slides teóricos MSF', '/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_TPs.zip', 14817, 2125, 8, 29, 0, 0, 0, 1, 0, 0, 0, NULL, '2022-01-31 20:37:14', 2, NULL),
(385, 'Formulário MSF', '/notes/primeiro_ano/segundo_semestre/msf/20_21_Artur_Form.pdf', 14817, 2125, 8, 29, 1, 0, 0, 0, 0, 0, 0, NULL, '2022-01-31 20:37:14', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `notes_schoolyear`
--

CREATE TABLE `notes_schoolyear` (
  `id` int(11) NOT NULL,
  `yearBegin` smallint(4) DEFAULT NULL,
  `yearEnd` smallint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `notes_schoolyear`
--

INSERT INTO `notes_schoolyear` (`id`, `yearBegin`, `yearEnd`) VALUES
(1, 2014, 2015),
(2, 2017, 2018),
(3, 2018, 2019),
(4, 2016, 2017),
(5, 2015, 2016),
(6, 2013, 2014),
(7, 2019, 2020),
(8, 2020, 2021);

-- --------------------------------------------------------

--
-- Table structure for table `notes_subjects`
--

CREATE TABLE `notes_subjects` (
  `paco_code` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `year` int(11) NOT NULL,
  `semester` int(11) NOT NULL,
  `short` varchar(5) NOT NULL,
  `discontinued` tinyint(1) DEFAULT '0',
  `optional` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `notes_subjects`
--

INSERT INTO `notes_subjects` (`paco_code`, `name`, `year`, `semester`, `short`, `discontinued`, `optional`) VALUES
(2373, 'Empreendedorismo', 3, 3, 'E', 0, 1),
(2450, 'Gestão de Empresas', 3, 3, 'GE', 0, 0),
(9270, 'Arquitectura e Gestão de Redes', 3, 3, 'AGR', 0, 1),
(12271, 'Aspetos Profissionais e Sociais da Engenharia Informática', 3, 3, 'APSEI', 0, 0),
(12830, 'Complementos Sobre Linguagens de Programação', 3, 3, 'CSLP', 0, 1),
(12832, 'Tópicos de Aprendizagem Automática', 3, 2, 'TAA', 0, 0),
(14817, 'Modelação de Sistemas Físicos', 1, 1, 'MSF', 0, 0),
(40337, 'Métodos Probabilísticos para Engenharia Informática', 2, 1, 'MPEI', 0, 0),
(40379, 'Fundamentos de Programação', 1, 1, 'FP', 0, 0),
(40380, 'Introdução às Tecnologias Web', 1, 1, 'ITW', 0, 0),
(40381, 'Sistemas Operativos', 2, 1, 'SO', 0, 0),
(40382, 'Computação Distribuída', 2, 2, 'CD', 0, 0),
(40383, 'Padrões e Desenho de Software', 2, 2, 'PDS', 0, 0),
(40384, 'Introdução à Engenharia de Software', 3, 1, 'IES', 0, 0),
(40385, 'Complementos de Bases de Dados', 3, 1, 'CBD', 0, 0),
(40431, 'Modelação e Análise de Sistemas', 1, 2, 'MAS', 0, 0),
(40432, 'Sistemas Multimédia', 2, 1, 'SM', 0, 0),
(40433, 'Redes e Serviços', 2, 1, 'RS', 0, 0),
(40436, 'Programação Orientada a Objetos', 1, 2, 'POO', 0, 0),
(40437, 'Algoritmos e Estruturas de Dados', 2, 1, 'AED', 0, 0),
(40551, 'Tecnologias e Programação Web', 3, 3, 'TPW', 0, 0),
(40751, 'Algoritmos Avançados', 4, 1, 'AA', 0, 0),
(40752, 'Teoria Algorítmica da Informação', 4, 1, 'TAI', 0, 0),
(40753, 'Computação em Larga Escala', 4, 2, 'CLE', 0, 0),
(40756, 'Gestão de Infraestruturas de Computação', 4, 2, 'GIC', 0, 0),
(40757, 'Arquiteturas de Software', 4, 2, 'AS', 0, 0),
(40846, 'Inteligência Artificial', 3, 1, 'IA', 0, 0),
(41469, 'Compiladores', 2, 2, 'C', 0, 0),
(41549, 'Interação Humano-Computador', 2, 2, 'IHC', 0, 0),
(41791, 'Elementos de Fisíca', 1, 1, 'EF', 1, 0),
(42502, 'Introdução à Arquitetura de Computadores', 1, 2, 'IAC', 0, 0),
(42532, 'Bases de Dados', 2, 2, 'BD', 0, 0),
(42573, 'Segurança Informática e Nas Organizações', 3, 1, 'SIO', 0, 0),
(42709, 'Álgebra Linear e Geometria Analítica', 1, 1, 'ALGA', 0, 0),
(42728, 'Cálculo I', 1, 1, 'C1', 0, 0),
(42729, 'Cálculo II', 1, 2, 'C2', 0, 0),
(44156, 'Visualização de Informação', 4, 1, 'VI', 0, 0),
(44158, 'Web Semântica', 4, 2, 'WS', 0, 0),
(45424, 'Introdução à Computação Móvel', 3, 3, 'ICM', 0, 0),
(45426, 'Teste e Qualidade de Software', 3, 2, 'TQS', 0, 0),
(45587, 'Exploração de Dados', 4, 1, 'ED', 0, 0),
(47166, 'Matemática Discreta', 1, 2, 'MD', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `notes_teachers`
--

CREATE TABLE `notes_teachers` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `personalPage` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `notes_teachers`
--

INSERT INTO `notes_teachers` (`id`, `name`, `personalPage`) VALUES
(1, 'José Nuno Panelas Nunes Lau', 'https://www.ua.pt/pt/p/10312826'),
(2, 'Diogo Nuno Pereira Gomes', 'https://www.ua.pt/pt/p/10331537'),
(3, 'João Paulo Silva Barraca', 'https://www.ua.pt/pt/p/10333322'),
(4, 'Carlos Alberto da Costa Bastos', 'https://www.ua.pt/pt/p/10312427'),
(5, 'Paulo Jorge dos Santos Gonçalves Ferreira', 'https://www.ua.pt/pt/p/10308388'),
(6, 'Pedro Miguel Ribeiro Lavrador', 'https://www.ua.pt/pt/p/16606771'),
(7, 'Carlos Manuel Azevedo Costa', 'https://www.ua.pt/pt/p/10322010'),
(8, 'Joaquim Manuel Henriques de Sousa Pinto', 'https://www.ua.pt/pt/p/10312245'),
(9, 'Maria Beatriz Alves de Sousa Santos', 'https://www.ua.pt/pt/p/10306666'),
(10, 'Miguel Augusto Mendes Oliveira e Silva', 'https://www.ua.pt/pt/p/10313337'),
(11, 'Tomás António Mendes Oliveira e Silva', 'https://www.ua.pt/pt/p/10309907'),
(12, 'José Luis Guimarães Oliveira', 'https://www.ua.pt/pt/p/10309676'),
(13, 'Ilídio Fernando de Castro Oliveira', 'https://www.ua.pt/pt/p/10318398'),
(14, 'Telmo Reis Cunha', 'https://www.ua.pt/pt/p/10322185'),
(15, 'José Manuel Neto Vieira', 'https://www.ua.pt/pt/p/10311461'),
(16, 'António Manuel Duarte Nogueira', 'https://www.ua.pt/pt/p/10317117'),
(17, 'Joaquim João Estrela Ribeiro Silvestre Madeira', 'https://www.ua.pt/en/p/10320092'),
(18, 'Vera Ivanovna Kharlamova', 'https://www.ua.pt/pt/p/10317978'),
(19, 'Isabel Alexandra Vieira Brás', 'https://www.ua.pt/pt/p/10310747'),
(20, 'Paula Cristina Roque da Silva Rama', 'https://www.ua.pt/pt/p/10312567'),
(21, 'António Manuel Rosa Pereira Caetano', 'https://www.ua.pt/pt/p/10312455'),
(22, 'José Alexandre da Rocha Almeida', 'https://www.ua.pt/pt/p/10316585'),
(23, 'Maria Raquel Rocha Pinto', 'https://www.ua.pt/pt/p/10312973'),
(24, 'Mário Fernando dos Santos Ferreira', 'https://www.ua.pt/pt/p/10308549'),
(25, 'Helder Troca Zagalo', 'https://www.ua.pt/pt/p/10316375'),
(26, 'Ana Maria Perfeito Tomé', 'https://www.ua.pt/pt/p/10307429'),
(27, 'João Manuel de Oliveira e Silva Rodrigues', 'https://www.ua.pt/pt/p/10314156'),
(28, 'António Joaquim da Silva Teixeira', 'https://www.ua.pt/pt/p/10315017'),
(29, 'Vitor José Babau Torres', 'https://www.ua.pt/pt/p/10307149'),
(30, 'Luís Filipe de Seabra Lopes', 'https://www.ua.pt/pt/p/10314261'),
(31, 'António José Ribeiro Neves', 'https://www.ua.pt/pt/p/16606785'),
(32, 'Maria Elisa Carrancho Fernandes', 'https://www.ua.pt/pt/p/10321317'),
(34, 'Cristina Isabel Assis de Morais Miguéns', 'https://www.ua.pt/pt/p/10333350'),
(40, 'Pétia Georgieva Georgieva', 'https://www.ua.pt/pt/p/10321408');

-- --------------------------------------------------------

--
-- Table structure for table `notes_thanks`
--

CREATE TABLE `notes_thanks` (
  `id` int(11) NOT NULL,
  `author` int(11) DEFAULT NULL,
  `notesPersonalPage` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `notes_thanks`
--

INSERT INTO `notes_thanks` (`id`, `author`, `notesPersonalPage`) VALUES
(4, 1161, 'https://resumosdeinformatica.netlify.app/');

-- --------------------------------------------------------

--
-- Table structure for table `notes_types`
--

CREATE TABLE `notes_types` (
  `id` int(11) NOT NULL,
  `name` varchar(40) DEFAULT NULL,
  `download_caption` varchar(40) DEFAULT NULL,
  `icon_display` varchar(40) DEFAULT NULL,
  `icon_download` varchar(40) DEFAULT NULL,
  `external` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `notes_types`
--

INSERT INTO `notes_types` (`id`, `name`, `download_caption`, `icon_display`, `icon_download`, `external`) VALUES
(1, 'PDF NEI', 'Descarregar', 'fas file-pdf', 'fas cloud-download-alt', 0),
(2, 'ZIP NEI', 'Descarregar', 'fas folder', 'fas cloud-download-alt', 0),
(3, 'Repositório', 'Repositório', 'fab github', 'fab github', 1),
(4, 'Google Drive', 'Google Drive', 'fab google-drive', 'fab google-drive', 1);

-- --------------------------------------------------------

--
-- Table structure for table `partners`
--

CREATE TABLE `partners` (
  `id` int(11) NOT NULL,
  `header` varchar(255) NOT NULL,
  `company` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `content` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `bannerUrl` varchar(255) DEFAULT NULL,
  `bannerImage` varchar(255) DEFAULT NULL,
  `bannerUntil` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `partners`
--

INSERT INTO `partners` (`id`, `header`, `company`, `description`, `content`, `link`, `bannerUrl`, `bannerImage`, `bannerUntil`) VALUES
(1, '/partners/LavandariaFrame.jpg', 'Lavandaria Portuguesa', 'A Lavandaria Portuguesa encontra-se aliada ao NEI desde março de 2018, ajudando o núcleo na área desportiva com lavagens de equipamentos dos atletas que representam o curso.', NULL, 'https://www.facebook.com/alavandariaportuguesa.pt/', NULL, NULL, NULL),
(4, '/partners/OlisipoFrame.jpg', 'Olisipo', 'Fundada em 1994, a Olisipo é a única empresa portuguesa com mais de 25 anos de experiência dedicada à Gestão de Profissionais na área das Tecnologias de Informação.\n\nSomos gestores de carreira de mais de 500 profissionais de TI e temos Talent Managers capazes de influenciar o sucesso da carreira dos nossos colaboradores e potenciar o crescimento dos nossos clientes.\n\nVem conhecer um Great Place to Work® e uma das 30 melhores empresas para trabalhar em Portugal.', NULL, 'https://bit.ly/3KVT8zs', 'https://bit.ly/3KVT8zs', '/partners/banners/Olisipo.png', '2023-01-31 23:59:59');

-- --------------------------------------------------------

--
-- Table structure for table `RecoverToken`
--

CREATE TABLE `RecoverToken` (
  `id` int(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expire_date` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `redirects`
--

CREATE TABLE `redirects` (
  `id` int(11) NOT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `redirect` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `redirects`
--

INSERT INTO `redirects` (`id`, `alias`, `redirect`) VALUES
(3, 'mapa', '/static/integracao/202122/peddypaper/mapa.png'),
(6, 'glicinias', '/static/integracao/202122/peddypaper/glicinias.jpg'),
(9, 'ribau', '/static/integracao/202122/peddypaper/congressos.jpg'),
(12, 'forum', '/static/integracao/202122/peddypaper/forum.jpg'),
(15, 'santos', '/static/integracao/202122/peddypaper/santos.jpg'),
(18, 'macaca', '/static/integracao/202122/peddypaper/macaca.jpg'),
(21, 'convivio', '/static/integracao/202122/peddypaper/convivio.jpg'),
(24, 'be', '/static/integracao/202122/peddypaper/be.jpg'),
(30, 'socorro', '/static/integracao/202122/guiasobrevivencia.pdf');

-- --------------------------------------------------------

--
-- Table structure for table `rgm`
--

CREATE TABLE `rgm` (
  `id` int(11) NOT NULL,
  `categoria` varchar(11) NOT NULL,
  `mandato` int(11) NOT NULL,
  `file` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `rgm`
--

INSERT INTO `rgm` (`id`, `categoria`, `mandato`, `file`) VALUES
(9, 'RAC', 2013, '/rgm/RAC/2013/RAC_NESI2013.pdf'),
(18, 'RAC', 2014, '/rgm/RAC/2014/RAC_NEI2014.pdf'),
(24, 'RAC', 2015, '/rgm/RAC/2015/RAC_NEI2015.pdf'),
(27, 'RAC', 2016, '/rgm/RAC/2016/RAC_NEI2016.pdf'),
(30, 'RAC', 2017, '/rgm/RAC/2017/RAC_NEI2017.pdf'),
(33, 'RAC', 2018, '/rgm/RAC/2018/RAC_NEI2018.pdf'),
(36, 'RAC', 2019, '/rgm/RAC/2019/RAC_NEI2019.pdf'),
(39, 'PAO', 2013, '/rgm/PAO/2013/PAO_NESI2013.pdf'),
(42, 'PAO', 2014, '/rgm/PAO/2014/PAO_NESI2014.pdf'),
(45, 'PAO', 2015, '/rgm/PAO/2015/PAO_NEI2015.pdf'),
(48, 'PAO', 2016, '/rgm/PAO/2016/PAO_NEI2016.pdf'),
(51, 'PAO', 2017, '/rgm/PAO/2017/PAO_NEI2017.pdf'),
(54, 'PAO', 2018, '/rgm/PAO/2018/PAO_NEI2018.pdf'),
(57, 'PAO', 2019, '/rgm/PAO/2019/PAO_NEI2019.pdf'),
(58, 'PAO', 2020, '/rgm/PAO/2020/PAO_NEI2020.pdf'),
(60, 'ATAS', 2013, '/rgm/ATAS/2013/5.pdf'),
(63, 'ATAS', 2013, '/rgm/ATAS/2013/3.pdf'),
(66, 'ATAS', 2013, '/rgm/ATAS/2013/1.pdf'),
(69, 'ATAS', 2013, '/rgm/ATAS/2013/4.pdf'),
(72, 'ATAS', 2013, '/rgm/ATAS/2013/2.pdf'),
(75, 'ATAS', 2014, '/rgm/ATAS/2014/2.pdf'),
(78, 'ATAS', 2014, '/rgm/ATAS/2014/4.pdf'),
(81, 'ATAS', 2014, '/rgm/ATAS/2014/3.pdf'),
(84, 'ATAS', 2014, '/rgm/ATAS/2014/1.pdf'),
(87, 'ATAS', 2014, '/rgm/ATAS/2014/5.pdf'),
(90, 'ATAS', 2015, '/rgm/ATAS/2015/2.pdf'),
(93, 'ATAS', 2015, '/rgm/ATAS/2015/3.pdf'),
(96, 'ATAS', 2015, '/rgm/ATAS/2015/1.pdf'),
(99, 'ATAS', 2016, '/rgm/ATAS/2016/2.pdf'),
(102, 'ATAS', 2016, '/rgm/ATAS/2016/1.pdf'),
(105, 'ATAS', 2017, '/rgm/ATAS/2017/3.pdf'),
(108, 'ATAS', 2017, '/rgm/ATAS/2017/2.pdf'),
(111, 'ATAS', 2017, '/rgm/ATAS/2017/1.pdf'),
(114, 'ATAS', 2018, '/rgm/ATAS/2018/4.pdf'),
(117, 'ATAS', 2018, '/rgm/ATAS/2018/2.pdf'),
(120, 'ATAS', 2018, '/rgm/ATAS/2018/1.pdf'),
(123, 'ATAS', 2018, '/rgm/ATAS/2018/3.pdf'),
(126, 'ATAS', 2019, '/rgm/ATAS/2019/1.pdf'),
(129, 'ATAS', 2019, '/rgm/ATAS/2019/2.pdf'),
(132, 'ATAS', 2019, '/rgm/ATAS/2019/3.pdf'),
(135, 'ATAS', 2019, '/rgm/ATAS/2019/4.pdf'),
(136, 'ATAS', 2020, '/rgm/ATAS/2020/1.pdf'),
(137, 'RAC', 2020, '/rgm/RAC/2020/RAC_NEI2020.pdf'),
(138, 'ATAS', 2020, '/rgm/ATAS/2020/2.pdf'),
(139, 'PAO', 2021, '/rgm/PAO/2021/PAO_NEI2021.pdf'),
(140, 'ATAS', 2021, '/rgm/ATAS/2021/1.pdf'),
(142, 'RAC', 2021, '/rgm/RAC/2021/RAC_NEI2021.pdf'),
(145, 'ATAS', 2021, '/rgm/ATAS/2021/2.pdf'),
(151, 'PAO', 2022, '/rgm/PAO/2022/PAO_NEI2022.pdf'),
(154, 'ATAS', 2022, '/rgm/ATAS/2022/1.pdf');

-- --------------------------------------------------------

--
-- Table structure for table `seniors`
--

CREATE TABLE `seniors` (
  `year` int(11) NOT NULL,
  `course` varchar(3) NOT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `seniors`
--

INSERT INTO `seniors` (`year`, `course`, `image`) VALUES
(2020, 'LEI', '/seniors/lei/2020_3.jpg'),
(2020, 'MEI', '/seniors/mei/2020.jpg'),
(2021, 'LEI', NULL),
(2021, 'MEI', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `seniors_students`
--

CREATE TABLE `seniors_students` (
  `year` int(11) NOT NULL,
  `course` varchar(3) NOT NULL,
  `userId` int(11) NOT NULL,
  `quote` varchar(280) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `seniors_students`
--

INSERT INTO `seniors_students` (`year`, `course`, `userId`, `quote`, `image`) VALUES
(2020, 'LEI', 873, NULL, NULL),
(2020, 'LEI', 879, NULL, NULL),
(2020, 'LEI', 897, NULL, NULL),
(2020, 'LEI', 900, NULL, NULL),
(2020, 'LEI', 927, NULL, NULL),
(2020, 'LEI', 999, NULL, NULL),
(2020, 'LEI', 1002, NULL, NULL),
(2020, 'LEI', 1137, NULL, NULL),
(2020, 'LEI', 1161, NULL, NULL),
(2020, 'LEI', 1245, NULL, NULL),
(2020, 'LEI', 1266, NULL, NULL),
(2020, 'LEI', 1362, NULL, NULL),
(2020, 'LEI', 1425, NULL, NULL),
(2020, 'LEI', 1476, NULL, NULL),
(2020, 'LEI', 1545, NULL, NULL),
(2020, 'LEI', 1647, NULL, NULL),
(2020, 'LEI', 1764, NULL, NULL),
(2020, 'LEI', 1938, NULL, NULL),
(2020, 'LEI', 1995, NULL, NULL),
(2020, 'LEI', 2130, NULL, NULL),
(2020, 'MEI', 1059, NULL, NULL),
(2020, 'MEI', 2131, NULL, NULL),
(2021, 'LEI', 1020, 'Level up', '/seniors/lei/2021/1020.jpg'),
(2021, 'LEI', 1164, 'Mal posso esperar para ver o que se segue', '/seniors/lei/2021/1164.jpg'),
(2021, 'LEI', 1200, 'Já dizia a minha avó: \"O meu neto não bebe álcool\"', '/seniors/lei/2021/1200.jpg'),
(2021, 'LEI', 1275, NULL, '/seniors/lei/2021/1275.jpg'),
(2021, 'LEI', 1329, NULL, '/seniors/lei/2021/1329.jpg'),
(2021, 'LEI', 1461, 'Simplesmente viciado em café e futebol', '/seniors/lei/2021/1461.jpg'),
(2021, 'LEI', 1602, 'MD é fixe.', '/seniors/lei/2021/1602.jpg'),
(2021, 'LEI', 1716, 'Há tempo para tudo na vida académica!', '/seniors/lei/2021/1716.jpg'),
(2021, 'LEI', 1827, 'Melhorias = Mito', '/seniors/lei/2021/1827.jpg'),
(2021, 'MEI', 1023, '<h1>Fun fact: #EAAA00</h1>', '/seniors/mei/2021/1023.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `tacaua_classification`
--

CREATE TABLE `tacaua_classification` (
  `team` int(11) NOT NULL,
  `modality` int(11) NOT NULL,
  `score` smallint(6) NOT NULL,
  `games` tinyint(4) NOT NULL,
  `victories` tinyint(4) NOT NULL,
  `draws` tinyint(4) NOT NULL,
  `defeats` tinyint(4) NOT NULL,
  `g_scored` smallint(6) NOT NULL,
  `g_conceded` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tacaua_classification`
--

INSERT INTO `tacaua_classification` (`team`, `modality`, `score`, `games`, `victories`, `draws`, `defeats`, `g_scored`, `g_conceded`) VALUES
(0, 1, 3, 3, 0, 0, 3, 32, 55),
(1, 1, 7, 3, 2, 0, 1, 77, 43);

-- --------------------------------------------------------

--
-- Table structure for table `tacaua_games`
--

CREATE TABLE `tacaua_games` (
  `id` int(11) NOT NULL,
  `team1` int(11) NOT NULL,
  `team2` int(11) NOT NULL,
  `goals1` tinyint(4) NOT NULL,
  `goals2` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tacaua_games`
--

INSERT INTO `tacaua_games` (`id`, `team1`, `team2`, `goals1`, `goals2`) VALUES
(4, 0, 1, 15, 22);

-- --------------------------------------------------------

--
-- Table structure for table `tacaua_modalities`
--

CREATE TABLE `tacaua_modalities` (
  `id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `type` enum('COLETIVA','INDIVIDUAL') NOT NULL,
  `gender` enum('MISTO','MASCULINO','FEMININO') NOT NULL,
  `year` year(4) NOT NULL,
  `division` tinyint(4) NOT NULL DEFAULT '1',
  `division_group` varchar(5) DEFAULT NULL,
  `pts_victory` tinyint(4) DEFAULT NULL,
  `pts_draw` tinyint(4) DEFAULT NULL,
  `pts_defeat` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tacaua_modalities`
--

INSERT INTO `tacaua_modalities` (`id`, `name`, `type`, `gender`, `year`, `division`, `division_group`, `pts_victory`, `pts_draw`, `pts_defeat`) VALUES
(1, 'Andebol', 'COLETIVA', 'MISTO', 2022, 1, 'A', 3, 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tacaua_teams`
--

CREATE TABLE `tacaua_teams` (
  `id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `image` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tacaua_teams`
--

INSERT INTO `tacaua_teams` (`id`, `name`, `image`) VALUES
(0, 'Eng. Informática', '/sports/info.jpg'),
(1, 'Fisioterapia', '/sports/fisio.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `team`
--

CREATE TABLE `team` (
  `id` int(11) NOT NULL,
  `header` varchar(255) NOT NULL,
  `mandato` int(4) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `team`
--

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

-- --------------------------------------------------------

--
-- Table structure for table `team_colaborators`
--

CREATE TABLE `team_colaborators` (
  `colaborator` int(11) DEFAULT NULL,
  `mandate` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `team_colaborators`
--

INSERT INTO `team_colaborators` (`colaborator`, `mandate`) VALUES
(2104, 2021),
(2132, 2021),
(2136, 2021),
(2033, 2021),
(2035, 2021),
(2133, 2021),
(2055, 2021),
(2134, 2021),
(2058, 2021),
(2132, 2021);

-- --------------------------------------------------------

--
-- Table structure for table `team_roles`
--

CREATE TABLE `team_roles` (
  `id` int(11) NOT NULL,
  `name` varchar(120) DEFAULT NULL,
  `weight` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `team_roles`
--

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

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `uu_email` varchar(255) NOT NULL,
  `uu_iupi` varchar(255) NOT NULL,
  `curriculo` varchar(255) NOT NULL,
  `linkedIn` varchar(255) NOT NULL,
  `git` varchar(255) NOT NULL,
  `permission` enum('DEFAULT','FAINA','HELPER','COLABORATOR','MANAGER','ADMIN') NOT NULL,
  `created_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `full_name`, `uu_email`, `uu_iupi`, `curriculo`, `linkedIn`, `git`, `permission`, `created_at`) VALUES
(1, 'NEI', 'Núcleo de Estudantes de Informática', '', '', '', '', '', '', '2021-04-26'),
(840, 'Afonso Rodrigues', 'AFONSO ANTÓNIO MAIA RODRIGUES', 'aamrodrigues@ua.pt', '2DAF6140-A055-4F1D-BFE6-6E79D9A0B345', '', '', '', '', '0000-00-00'),
(843, 'Alexandre Rodrigues', 'ALEXANDRE ANTUNES RODRIGUES', 'aarodrigues@ua.pt', '8D850DA2-EB43-4D1E-A2C9-6DD7FA1E48DD', '', '', '', '', '0000-00-00'),
(846, 'Beatriz Marques', 'ANA BEATRIZ BORREGO MARQUES', 'abbm@ua.pt', '2FD4A666-1EA5-4E36-8119-A8DDCB374AD9', '', 'https://www.linkedin.com/in/beatriz-marques-6a677414b/', '', '', '2013-09-12'),
(849, 'Abel Fernando', 'ABEL FERNANDO BARROS RODRIGUES', 'abelfernando@ua.pt', '5A10E15C-0EC2-4DE6-9F44-F886DF4CB178', '/upload/curriculos/849.pdf', '', '', '', '2018-12-14'),
(852, 'Ana Rodrigues', 'ANA CRISTINA DOS SANTOS RODRIGUES', 'acsr@ua.pt', '64402D72-6638-4733-8725-63A423A75A69', '', '', '', '', '2013-09-12'),
(855, 'André Soares', 'ANDRÉ FILIPE BARBOSA SOARES', 'afbs@ua.pt', 'B7D88976-208B-4698-BA7C-DF23A7665921', '', '', '', '', '2013-09-12'),
(858, 'André Moleirinho', 'ANDRÉ FONSECA MOLEIRINHO', 'afmoleirinho@ua.pt', 'EF4A4ACD-9469-4D79-B663-E8843FD4F1E7', '', 'https://www.linkedin.com/in/andr%C3%A9-moleirinho/', '', '', '2014-09-18'),
(861, 'Afonso Pimentel', 'AFONSO JOÃO PIRES PIMENTEL', 'afonsopimentel@ua.pt', 'B90DB218-13DF-4066-B8BE-EC25917AAFE2', '', '', '', '', '2015-09-23'),
(864, 'Afonso Silva', 'AFONSO DE SALGUEIRO E SILVA', 'afonsosilva6@ua.pt', '7C325E15-DEFA-4E5B-8E45-C02CF50B6970', '', '', '', '', '0000-00-00'),
(867, 'André Almeida', 'ANDRÉ GOMES DE ALMEIDA', 'aga@ua.pt', 'FC6F9D25-CBBF-4F7C-8BE3-29752FBBAA37', '', '', '', '', '2013-09-12'),
(870, 'Alexandra Carvalho', 'ALEXANDRA TEIXEIRA DE SOUSA MARQUES DE CARVALHO', 'alexandracarvalho@ua.pt', 'B7D45431-DAE9-4320-BD68-9FD26DD01152', '', '', '', '', '0000-00-00'),
(873, 'Alexandre Lopes', 'Alexandre Lopes', 'alexandrejflopes@ua.pt', '', '', '', '', '', '2019-07-02'),
(876, 'Alex Santos', 'ALEX MIRANDA DOS SANTOS', 'alexmsantos@ua.pt', 'A9704A27-68DD-4B8E-98E4-17C6E5C489AD', '', '', '', '', '2013-09-25'),
(879, 'Alina Yanchuk', 'ALINA YANCHUK', 'alinayanchuk@ua.pt', '1E1D1C86-7A29-4BC5-83D5-751A85C5D253', '', '', '', '', '2017-10-23'),
(882, 'Miguel Almeida', 'MIGUEL ÂNGELO FERNANDES DE ALMEIDA', 'almeida.m@ua.pt', '35076817-7687-4DAD-88D6-2934A7131C34', '', '', '', '', '0000-00-00'),
(885, 'Bruno Almeida', 'BRUNO MIGUEL TAVARES DE ALMEIDA', 'almeidabruno@ua.pt', 'D7FFFAB2-2660-483D-B910-D661427969A9', '', '', '', '', '2014-04-02'),
(888, 'Ana Almeida', 'ANA FILIPA SIMÃO DE ALMEIDA', 'anaa@ua.pt', 'E5D766B9-6D25-4039-9594-485841E14E48', '', '', '', '', '2015-09-23'),
(891, 'Ana Tavares', 'ANA FILIPA FERREIRA TAVARES', 'anafilipatavares@ua.pt', '00FFA235-5496-43A3-A8A7-AA78DCB816BC', '', '', '', '', '2014-09-17'),
(894, 'Ana Ortega', 'ANA ISABEL CARVALHO ORTEGA', 'anaortega@ua.pt', '1F04EE42-7F10-43E7-97A7-AFEBB6CA59C2', '', '', '', '', '2013-09-12'),
(897, 'Rafaela Vieira', 'ANA RAFAELA RODRIGUES VIEIRA', 'anarafaela98@ua.pt', 'B62E7A1F-B77D-4245-93F2-500642B1E8CD', '', '', '', '', '2018-01-11'),
(900, 'André Alves', 'ANDRÉ TEIXEIRA BAIÃO ALVES', 'andre.alves@ua.pt', '08C6C0B0-CDDE-4472-8DE1-233CE88B7840', '/upload/curriculos/900.pdf', '', '', '', '2017-10-23'),
(903, 'André Amorim', 'ANDRÉ DE ARAÚJO E SILVA AMORIM', 'andre.amorim@ua.pt', 'BB8A45B6-3632-46B9-BCE6-37BE08FD110B', '', '', '', '', '2017-10-23'),
(906, 'André Catarino', 'ANDRÉ ALMEIDA CATARINO', 'andre.catarino@ua.pt', '2D115D45-ACCF-44BB-907C-1EAA121330DC', '/upload/curriculos/906.pdf', '', '', '', '2017-10-23'),
(909, 'André Ribas', 'ANDRÉ FILIPE DA SILVA RIBAS', 'andre.ribass@ua.pt', '53655B49-A049-4C45-B405-D0495A102924', '', '', '', '', '2013-09-12'),
(912, 'Nuno Barreto', 'NUNO ANDRÉ TÁVORA BARRETO', 'andrebarreto@ua.pt', 'A919A5D4-43DC-4D65-BE53-473ED0B932DC', '', '', '', '', '2013-09-12'),
(915, 'André Bastos', 'ANDRÉ PAULO BASTOS', 'andrebastos@ua.pt', '0060AE76-8081-45FD-89BB-F6A9A30775EE', '', '', '', '', '2013-09-24'),
(918, 'André Brandão', 'ANDRÉ XAVIER RIBEIRO DE ALMEIDA BRANDÃO', 'andrebrandao@ua.pt', 'C9482D49-4992-4F1D-8933-C3CBF2370FDA', '', '', '', '', '2018-01-11'),
(921, 'André Gual', 'ANDRÉ FREITAS BAPTISTA GUAL', 'andregual@ua.pt', 'CF14E72E-54F9-44FE-9EA9-77B3608FE3A8', '', '', '', '', '2017-10-23'),
(924, 'André Bastos', 'ANDRÉ MARTINS BASTOS', 'andrembastos@ua.pt', '5BD6FB14-7351-4E8B-9D24-ECAE0F3484BD', '', '', '', '', '2013-09-26'),
(927, 'André Amarante', 'ANDRÉ GRAMATA RIBAU AMARANTE', 'andreribau@ua.pt', '0AB48885-9F64-418E-AAC9-CC6C698B4F32', '', '', '', '', '2017-10-23'),
(930, 'André Gomes', 'ANDRÉ SANTOS GOMES', 'andresgomes@ua.pt', '54176BC4-E0CA-42CF-A488-58BA5195A251', '', '', '', '', '2018-01-11'),
(933, 'Anthony Pereira', 'ANTHONY DOS SANTOS PEREIRA', 'anthonypereira@ua.pt', '922D8550-C063-41FC-85AA-B3CB00818B3D', '', '', '', '', '0000-00-00'),
(936, 'António Castanheira', 'ANTÓNIO MANUEL DE MELO CASTANHEIRA', 'antonio.castanheira@ua.pt', '2C74D3CA-60DD-438F-8478-BD5428D466D1', '', '', '', '', '2015-09-23'),
(939, 'António Freire', 'ANTÓNIO EMANUEL TEIXEIRA FREIRE', 'antonio.emanuel@ua.pt', 'DE93C4B5-50F9-4D6E-B667-A4F3AC026F67', '', '', '', '', '2013-09-28'),
(942, 'António Gomes', 'ANTÓNIO SÉRGIO PEREIRA SÁ GOMES', 'antonio97@ua.pt', 'EBE79A24-71A8-4423-984C-FC1E17D49C65', '', '', '', '', '2015-09-23'),
(945, 'António Fernandes', 'ANTÓNIO JORGE OLIVEIRA FERNANDES', 'antoniojorgefernandes@ua.pt', '516B2525-3A36-4194-836A-56632BD275E0', '', '', '', '', '0000-00-00'),
(948, 'Ana Gonçalves', 'ANA ROSA MARQUES GONÇALVES', 'argoncalves@ua.pt', '0E1B019F-8877-4D8E-B9AB-8196FC3FADD2', '', '', '', '', '2014-04-01'),
(951, 'Ana Oliveira', 'ANA RITA RODRIGUES OLIVEIRA', 'arro@ua.pt', 'D30218AF-85F6-49D6-9C90-7975C2690965', '', '', '', '', '2015-09-23'),
(954, 'Artur Sousa', 'ARTUR SAMPAIO LEITÃO ALVES DE SOUSA', 'artur.sousa@ua.pt', 'B6119592-AB33-4F8C-9CE3-6813ED394B16', '', '', '', '', '2018-10-28'),
(957, 'André Pedrosa', 'ANDRÉ SILVA PEDROSA', 'aspedrosa@ua.pt', '9D7069F7-116D-424F-8898-59F9E6F9C962', '', '', '', '', '2018-01-11'),
(960, 'Leticia Azevedo', 'LETÍCIA ISABEL GOMES AZEVEDO', 'azevedo.leticia@ua.pt', '9A5B040B-ADB3-4610-853B-75C0349EEB70', '', '', '', '', '2018-10-22'),
(963, 'Bárbara Neto', 'BÁRBARA JAEL DOS SANTOS NETO', 'barbara.jael@ua.pt', '3BD02E80-1927-41BD-B64A-37F61B852EEF', '/upload/curriculos/963.pdf', 'https://www.linkedin.com/in/barbarajael/', '', '', '2013-09-25'),
(966, 'Bernardo Domingues', 'BERNARDO DE OLIVEIRA DOMINGUES', 'bernardo.domingues@ua.pt', '3A8F740A-BDCE-4836-B006-40919821C5D5', '', 'https://www.linkedin.com/in/bernardodomingues/', '', '', '2017-02-09'),
(969, 'Bernardo Rodrigues', 'BERNARDO JOÃO GONÇALVES DA CRUZ RODRIGUES', 'bernardorodrigues@ua.pt', '14E96F4E-A5E1-4C4A-BF84-18DFD75CDEA6', '', '', '', '', '2017-10-23'),
(972, 'Bruno Rocha', 'BRUNO MIGUEL FONSECA DA ROCHA', 'bmfrocha@ua.pt', '1B157763-88C9-435E-BBAB-F59B0D1FB9AB', '', '', '', '', '2013-09-12'),
(975, 'Bruno Pereira', 'BRUNO MIGUEL DA SILVA PEREIRA', 'bmpereira@ua.pt', '50A5FD5C-940C-4AB5-8FBE-E28E60EC2ED1', '', '', '', '', '2013-09-28'),
(978, 'Breno Salles', 'BRENO DA FONSECA SALLES', 'brenosalles@ua.pt', 'F948C6F4-5B2F-490D-80AE-688DB6314198', '', '', '', '', '2015-09-23'),
(981, 'Bruno Cruz', 'BRUNO SIMÕES CRUZ', 'bruno.cruz@ua.pt', 'CA156253-519C-4B63-8B02-C2A7F358711B', '', '', '', '', '2013-10-04'),
(984, 'Bruno Barbosa', 'BRUNO MIGUEL PINHO BARBOSA', 'brunobarbosa@ua.pt', '604DE09F-F2CB-466E-B8CB-40E87BE3063C', '', '', '', '', '2013-09-25'),
(987, 'Bruno Pinto', 'BRUNO MARQUES PINTO', 'brunopinto5151@ua.pt', 'B14C29C0-DB97-4276-845D-7B91B93F3FF7', '/upload/curriculos/987.pdf', '', '', '', '2013-09-24'),
(990, 'Bruno Rabaçal', 'BRUNO NELSON DIOGO RABAÇAL', 'brunorabacal@ua.pt', '14319191-66EF-472D-BF7B-A6EA70AD4CFF', '', '', '', '', '2018-01-11'),
(993, 'Bruno Bastos', 'BRUNO DE SOUSA BASTOS', 'brunosb@ua.pt', '588FF064-CAB3-4718-AD1C-00D4C113C0DC', '', '', '', '', '0000-00-00'),
(996, 'Caio Jacobina', 'CAIO SANTANA JACOBINA', 'caio@ua.pt', 'EDEC525F-783D-4480-85CE-4FF5773FC986', '', '', '', '', '2013-09-24'),
(999, 'Camila Uachave', 'CAMILA EUGÉNIO SILVESTRE FRANCISCO UACHAVE', 'camilauachave@ua.pt', '4F9312E0-1093-4702-87F6-BF048F466202', '', '', '', '', '2018-12-06'),
(1002, 'Carina Neves', 'CARINA FILIPA FREITAS DAS NEVES', 'carina.f.f.neves@ua.pt', '88A27055-CD44-4662-981B-3907A9E4488B', '', '', '', '', '2018-12-05'),
(1005, 'Pacheco', 'CARLOS ANTÓNIO RIBEIRO FERREIRA PACHECO', 'carlos.pacheco@ua.pt', '0FD9DCD6-C3F8-4434-9627-12CE1DA35323', '', '', '', '', '2013-09-12'),
(1008, 'Carlos Cabral', 'CARLOS MANUEL MOURA CABRAL', 'carlosmcabral@ua.pt', 'D52D08BC-6207-4FB7-B62D-218BEE4111E5', '', '', '', '', '2013-09-12'),
(1011, 'Carlos Raimundo', 'CARLOS ANDRÉ SILVA RAIMUNDO', 'carlosraimundo7@ua.pt', '4A60311D-1650-4CA1-A800-782FCE42D02A', '', '', '', '', '2013-09-15'),
(1014, 'Carlos Ying Zhu', 'CARLOS YING ZHU', 'carlosyingzhu@ua.pt', '76FEBB6A-CB39-43A9-B653-991B736EE34C', '', '', '', '', '2017-05-27'),
(1017, 'Carlota Marques', 'CARLOTA RIBEIRO MARQUES', 'carlotamarques@ua.pt', '323DFF5C-4246-4B9E-90A5-4FF6310F7213', '', 'https://www.linkedin.com/in/carlota-marques/', '', '', '2014-09-15'),
(1020, 'Carolina Araújo', 'CAROLINA SIMÕES ARAÚJO', 'carolina.araujo00@ua.pt', 'B644062B-1275-4AE1-BA60-7E2783D72F78', '', '', '', '', '0000-00-00'),
(1023, 'Carolina Albuquerque', 'CAROLINA MARQUES ALBUQUERQUE', 'carolinaalbuquerque@ua.pt', 'CCCE24F9-1B0C-4184-A1A9-13F809AA4F67', '/upload/curriculos/1023.pdf', 'https://www.linkedin.com/in/carolina-albuquerque29/', '', '', '2015-09-23'),
(1026, 'Carolina Marques', 'CAROLINA RESENDE MARQUES', 'carolinaresendemarques@ua.pt', 'C8AC5540-2103-4BFB-BD5D-EADE71C35C40', '', '', '', '', '2018-01-11'),
(1029, 'Daniela Carvalho', 'DANIELA FILIPA PIRES DE CARVALHO', 'carvalho.filipa@ua.pt', 'EF46A01F-5187-438A-ACD7-A0B3492606CC', '', '', '', '', '2013-09-24'),
(1032, 'Andreia Ferreira', 'ANDREIA DE CASTRO FERREIRA', 'castroferreira@ua.pt', '394756EA-3DE8-46E3-9C9A-FC5156265FDA', '', 'https://www.linkedin.com/in/castroferreira/', '', '', '2013-09-12'),
(1035, 'Catarina Fonseca', 'CATARINA ISABEL VASCO FONSECA', 'catarina.vasco.fonseca@ua.pt', '5F99620C-32AD-48B6-9897-4009CEE87E51', '', '', '', '', '2016-03-19'),
(1038, 'Catarina Vinagre', 'CATARINA JOÃO ALMEIDA VINAGRE', 'catarinajvinagre@ua.pt', '297A9A21-49B7-4DE2-9AF4-0645255735F2', '', '', '', '', '2013-09-27'),
(1041, 'Catarina Xavier', 'CATARINA MARGARIDA NUNES SOARES XAVIER', 'catarinaxavier@ua.pt', '1CE18A6E-7C12-438C-B8FA-79B266F5ACB7', '', '', '', '', '2018-01-11'),
(1044, 'Cátia Matos', 'CÁTIA RAQUEL DE LIMA MATOS', 'catiamatos@ua.pt', '4DE33C79-ED78-4A22-BA25-38407B165075', '', '', '', '', '2013-09-12'),
(1047, 'Carlos Daniel Santos Marques', 'CARLOS DANIEL SANTOS MARQUES', 'cdaniel@ua.pt', '85372F54-019E-4851-9C5C-D7BABC215D62', '/upload/curriculos/1047.pdf', '', '', '', '2018-01-11'),
(1050, 'Carlos Ferreira', 'CARLOS HENRIQUE DE FIGUEIREDO FERREIRA', 'chff@ua.pt', '404B77B7-A6D8-43F2-ACC8-9D16E88804A2', '', '', '', '', '2015-09-23'),
(1053, 'Claudio Costa', 'CLÁUDIO MIGUEL DOS SANTOS MOREIRA DA COSTA', 'claudio.costa@ua.pt', 'EACC20D1-AD0F-4CA6-BE79-7E99F3A86C29', '', 'https://www.linkedin.com/in/cláudio-costa-8912a4192/', '', '', '2018-01-11'),
(1056, 'Claudio Santos', 'CLÁUDIO VEIGAS SANTOS', 'claudioveigas@ua.pt', '0E74058D-E006-412D-8383-7230944DEAE6', '', 'https://www.linkedin.com/in/claudiovsantos/', '', '', '2014-09-17'),
(1059, 'Carlos Soares', 'CARLOS MANUEL LOPES SOARES', 'cmsoares@ua.pt', 'A72E83A0-001C-4AD6-8FFA-34E362BA2969', '', 'https://www.linkedin.com/in/carlos-soares-56a754152/', '', '', '2015-09-23'),
(1062, 'João Costa', 'JOÃO ANTÓNIO TEIXEIRA COSTA', 'costa.j@ua.pt', '0EE19EC6-D7D7-4390-B0E1-2759E5FDA6F6', '', '', '', '', '2013-09-12'),
(1065, 'Cristóvão Freitas', 'JOÃO CRISTÓVÃO ALVES FREITAS', 'cristovaofreitas@ua.pt', 'DFF321A8-E7FF-4044-8CBB-42A5ABE982E0', '', 'https://www.linkedin.com/in/cristovaofreitas/', '', '', '2013-09-12'),
(1068, 'Dinis Cruz', 'DINIS BARROQUEIRO CRUZ', 'cruzdinis@ua.pt', '9D8BCB3A-6022-4AF9-9B56-C3879D17D7C6', '', '', '', '', '0000-00-00'),
(1071, 'Mimi Cunha', 'ANA FILIPA MAIA CUNHA', 'cunha.filipa.ana@ua.pt', 'F582AF03-C72D-404D-89E1-B7C530C6E98E', '', 'https://www.linkedin.com/in/filipacunha29/', '', '', '2013-09-24'),
(1074, 'Daniel Gomes', 'DANIEL DE AMARAL GOMES', 'dagomes@ua.pt', 'E546076D-C0A9-4A10-8C1C-344399F86BA4', '', '', '', '', '0000-00-00'),
(1077, 'Daniel Couto', 'DANIEL SERAFIM GOMES COUTO', 'daniel.couto@ua.pt ', 'C957CF34-150C-4545-A6FA-640CBF07D75D', '', '', '', '', '0000-00-00'),
(1080, 'Daniel Rodrigues', 'DANIEL VALÉRIO RODRIGUES', 'daniel.v.rodrigues@ua.pt', 'B3D0A53C-6E0D-48AD-A9D2-C9D8D283AA43', '', 'https://www.linkedin.com/in/danielvrodrigues/', '', '', '2013-09-12'),
(1083, 'Daniela Pinto', 'DANIELA ALEXANDRA BASTOS PINTO', 'daniela.pinto@ua.pt', 'C3ACB56C-57D6-4FE9-AD1F-7CE4FAE314F8', '', '', '', '', '2013-10-21'),
(1086, 'Daniel Moreira', 'DANIEL BARBOSA MOREIRA', 'danielbarbosa@ua.pt', '682FE72D-577F-4431-956D-55D92F198F48', '', '', '', '', '2013-09-24'),
(1089, 'Daniel Silva', 'DANIEL LEMOS DA SILVA', 'daniellemossilva@ua.pt', '6FCE3F27-F871-4161-984D-3CE23D217429', '', '', '', '', '2014-09-15'),
(1092, 'Daniel Gonçalves', 'DANIEL MATEUS GONÇALVES', 'danielmateusgoncalves@ua.pt', '2B0A2A92-FF40-4F78-902A-322B78B1B02B', '', '', '', '', '2015-09-23'),
(1095, 'Daniel Nunes', 'DANIEL FILIPE BRITO NUNES', 'danielnunes98@ua.pt', '9279330F-5115-4FFA-BF67-3656CA643475', '/upload/curriculos/1095.pdf', '', '', '', '2018-01-11'),
(1098, 'Daniel Teixeira', 'DANIEL OLIVEIRA TEIXEIRA', 'danielteixeira31@ua.pt', '136A6B77-EE67-46F5-8898-5D7061FDEC22', '', 'https://www.linkedin.com/in/daniel-teixeira-75b64217b/', 'https://github.com/DamnDaniel7', '', '2018-01-11'),
(1101, 'David Fernandes', 'DAVID AUGUSTO DE SOUSA FERNANDES', 'dasfernandes@ua.pt', '77238D3D-B708-47ED-A1F8-B18C6CE16D7F', '/upload/curriculos/1101.pdf', 'https://www.linkedin.com/in/dasfernandes/', '', '', '2016-02-23'),
(1104, 'Jorge Loureiro', 'JORGE DAVID DE OLIVEIRA LOUREIRO', 'david.jorge@ua.pt', '60CFC2CF-3B4A-48B9-8218-04F6F4550890', '', '', '', '', '2013-09-25'),
(1107, 'David Ferreira', 'DAVID DA CRUZ FERREIRA', 'davidcruzferreira@ua.pt', '23C10F1D-6629-47C1-82B0-FB930A1D99D1', '', 'https://www.linkedin.com/in/david-ferreira-a49580147/', '', '', '2013-09-25'),
(1110, 'Davide Pontes', 'DAVIDE FRAGA PACHECO PEREIRA PONTES', 'davidepontes@ua.pt', '8A7641DE-65F0-4597-B0C2-86F9FB14646D', '', '', '', '', '2013-09-12'),
(1113, 'David Morais', 'DAVID GOMES MORAIS', 'davidmorais35@ua.pt', 'B6438AEE-A01B-4112-A8F2-BF326B1EFD18', '', '', '', '', '0000-00-00'),
(1116, 'David Ferreira', 'DAVID DOS SANTOS FERREIRA', 'davidsantosferreira@ua.pt', '1E2EC34C-C3A6-48D0-9CAD-16D57A4D285D', '', '', '', '', '2013-09-24'),
(1119, 'Rafael Batista', 'RAFAEL DURÃES BAPTISTA', 'dbrafael@ua.pt', '0F9685A6-A478-4730-BE2D-DDA3FEC36B26', '', '', '', '', '2018-01-11'),
(1122, 'Diogo Carvalho', 'DIOGO FILIPE AMARAL CARVALHO', 'dfac@ua.pt', '4B5560CD-9D67-4ACC-95C8-13D370264521', '', '', '', '', '0000-00-00'),
(1125, 'Diogo Cunha', 'DIOGO GUILHERME ROCHA CUNHA', 'dgcunha@ua.pt', 'FB2E2BE1-ED33-49DE-870D-1A18A33D241D', '', '', '', '', '0000-00-00'),
(1128, 'Diego Santos', 'DIEGO ALESSANDRO BATISTA SANTOS', 'diego.santos@ua.pt', 'DAE94FDC-99FA-4AD9-A4D0-D682209E2278', '', '', '', '', '0000-00-00'),
(1131, 'Diego Trovisco', 'DIEGO FERNANDO ALVES TROVISCO', 'diegotrovisco@ua.pt', '2A6B35CB-1EB7-4FF6-B3A9-8EE57545C1D7', '', '', '', '', '2015-09-23'),
(1134, 'Dimitri Silva', 'DIMITRI ALEXANDRE DA SILVA', 'dimitrisilva@ua.pt', '5D53B30C-4001-4038-9309-588A20D1DF12', '', '', '', '', '2015-09-23'),
(1137, 'Diogo Andrade', 'DIOGO ANDRÉ LOPES ANDRADE', 'diogo.andrade@ua.pt', 'D241CE33-7CB7-49D1-AE19-F660BD633F47', '', '', '', '', '2017-10-23'),
(1140, 'Diogo Arrais', 'DIOGO FRADINHO ARRAIS', 'diogo.arrais@ua.pt', '5BA6FD65-D93A-4F53-AEB1-5B55A933EAE9', '', '', '', '', '2013-09-12'),
(1143, 'Diogo Borges', 'DIOGO RAIMONDI BORGES', 'diogo.borges@ua.pt', 'C433B7FD-77D4-4A0F-9849-4570952C2C25', '', '', '', '', '2013-09-25'),
(1146, 'Diogo Moreita', 'DIOGO EMANUEL DE OLIVEIRA MOREIRA', 'diogo.e.moreira@ua.pt', 'E6175917-4FD8-4903-BBA1-B8799820CE3C', '', '', '', '', '0000-00-00'),
(1149, 'Diogo Silva', 'DIOGO GUIMARÃES SILVA', 'diogo.g@ua.pt', '10694C97-193E-48E8-A58B-2DEA9BA74455', '', '', '', '', '0000-00-00'),
(1152, 'Diogo Jorge', 'DIOGO JORGE FERREIRA', 'diogo.jorge97@ua.pt', '846FA9A2-3812-46D7-B090-0DD0C47EDD28', '/upload/curriculos/1152.pdf', '', '', '', '2015-09-23'),
(1155, 'Diogo Reis', 'DIOGO FILIPE ESTEVES REIS', 'diogo.reis@ua.pt', '3D5BC612-4DAF-4457-BE03-88C1E7C349E7', '', 'https://www.linkedin.com/in/diogo-f-reis/', '', '', '2014-03-05'),
(1158, 'Diogo Silveira', 'DIOGO MIGUEL DE ALMEIDA SILVEIRA', 'diogo.silveira10@ua.pt', 'B60EF0F6-AC7D-4C83-8CC4-40B3B07FA521', '', '', '', '', '2018-01-11'),
(1161, 'Diogo Silva', 'DIOGO GONÇALVES SILVA', 'diogo04@ua.pt', '319E204B-87ED-48FE-BFFE-48A6F619EC17', '/upload/curriculos/1161.pdf', '', '', '', '2017-10-23'),
(1164, 'Diogo Bento', 'DIOGO OLIVEIRA BENTO', 'diogobento@ua.pt', '849B6413-3265-463A-91DB-4B650CDEA75E', '', '', '', '', '0000-00-00'),
(1167, 'Diogo Ramos', 'DIOGO RAFAEL RODRIGUES RAMOS', 'diogorafael@ua.pt', 'DB9EC254-97D8-4F39-81B1-264193124D71', '', '', '', '', '2013-09-28'),
(1170, 'Daniel Lopes', 'DANIEL ALMEIDA LOPES', 'dlopes@ua.pt', 'FD42B037-3CC4-4885-A154-2C3A8E21163A', '', '', '', '', '2015-09-23'),
(1173, 'Daniel Pinto', 'DANIEL JOSÉ MATIAS PINTO', 'dmatiaspinto@ua.pt', '3DF564DB-A663-43CD-93E6-AC334B1C00A2', '', '', '', '', '2017-10-23'),
(1176, 'Diogo Sousa', 'DIOGO MACEDO DE SOUSA', 'dmdsousa@ua.pt', '319B53BC-CC20-4C73-86E5-150B46FB60DA', '', '', '', '', '2013-09-24'),
(1179, 'Diogo Paiva', 'DIOGO OLIVEIRA PAIVA', 'dpaiva@ua.pt', '7D2444A9-1CB3-41C6-9271-81D6CF0737E1', '', 'https://www.linkedin.com/in/diogo-paiva-bb578877/', '', '', '2013-09-09'),
(1182, 'Duarte Mortágua', 'DUARTE NEVES TAVARES MORTÁGUA', 'duarte.ntm@ua.pt', '0798A134-0DBB-4E1F-88D1-24358E6C6AF9', '', 'https://www.linkedin.com/in/duartemortagua/', 'https://github.com/DNTM2802', '', '0000-00-00'),
(1185, 'Duarte Castanho', 'DUARTE MANUEL CUNHA PINTO COSTA CASTANHO', 'duartecastanho@ua.pt', 'FD192438-1C4B-4287-9190-9F1DED6F1FA6', '', '', '', '', '2018-01-11'),
(1188, 'Nuno Fonseca', 'NUNO DUARTE SIMÃO DA FONSECA', 'duartenuno@ua.pt', '9727D515-1099-4A66-9D4E-1BF4D7F555D5', '', '', '', '', '2014-09-17'),
(1191, 'Eduardo Martins', 'EDUARDO GUERRA MARTINS', 'e.martins@ua.pt', '95C38707-5BFC-4939-8DD8-6894D8B75D14', '', 'https://www.linkedin.com/in/eduardo-martins-5b616367/', '', '', '2013-09-12'),
(1194, 'Emanuel Laranjo', 'EMANUEL ALEXANDRE PEREIRA LARANJO', 'ealaranjo@ua.pt', '97D9E83B-C61B-4D5D-BF8F-939F550A72F3', '', 'https://www.linkedin.com/in/emanuel-laranjo-63bb5012a/', '', '', '2013-09-12'),
(1197, 'Edgar Morais', 'EDGAR GUILHERME SILVA MORAIS', 'edgarmorais@ua.pt', '25571A85-2A63-47FE-B18A-7F3D1FC30968', '', '', '', '', '2017-10-23'),
(1200, 'Eduardo Santos', 'EDUARDO HENRIQUE FERREIRA SANTOS', 'eduardosantoshf@ua.pt', 'DC2AC32D-50A9-403A-BA15-A492640FD869', '', 'https://www.linkedin.com/in/eduardosantoshf/', '', '', '0000-00-00'),
(1203, 'Eleandro Laureano', 'ELEANDRO GISENEL GAMBÔA LAUREANO', 'eleandrog@ua.pt', '0967AF88-0903-4D65-AAC0-25A587FC32E9', '', '', '', '', '2018-01-11'),
(1206, 'Pedro Escaleira', 'PEDRO MIGUEL NICOLAU ESCALEIRA', 'escaleira@ua.pt', '0FBC7C37-68C8-40B7-BF39-20A41B98141B', '/upload/curriculos/1206.pdf', '', '', '', '2017-10-23'),
(1209, 'Sara Espanhol', 'SARA SOFIA GIGA ESPANHOL', 'espanholgiga@ua.pt', 'F1B28154-76D2-4D03-8650-783C2B156873', '', '', '', '', '2013-09-24'),
(1212, 'Francisco Fontinha', 'FRANCISCO ALEXANDRE AIRES FONTINHA', 'f.fontinha@ua.pt', 'C9A68D7E-E21A-443B-B121-4390C6F28DDC', '', '', '', '', '2014-09-17'),
(1215, 'Fábio Carmelino', 'FÁBIO ALEXANDRE ANDRADE CARMELINO', 'faac@ua.pt', 'AAFD5676-61F0-4F10-97F0-6C152BD03C85', '', '', '', '', '0000-00-00'),
(1218, 'Fábio Almeida', 'FÁBIO LUÍS ESTIMA DE ALMEIDA', 'fabio.almeida@ua.pt', '0642471C-4907-49FF-A118-1ED5752A7675', '', '', '', '', '2013-09-12'),
(1221, 'Fábio Luís', 'FÁBIO ANDRÉ DE ALMEIDA LUÍS', 'fabio.luis@ua.pt', 'F83EA9E8-B6BC-4C36-B015-839338ED7F75', '', '', '', '', '2013-09-20'),
(1224, 'Fábio Rogão', 'FÁBIO BARREIRA ROGÃO', 'fabio.rogao@ua.pt', '4D14A892-4C8C-47B5-B2AC-9EA0985E283B', '', '', '', '', '2015-09-23'),
(1227, 'Fábio Ferreira', 'FÁBIO XAVIER LEITE FERREIRA', 'fabio.xavier@ua.pt', 'A87EE122-324C-4CCD-B8FB-CD81DAE690D1', '', '', '', '', '2013-09-24'),
(1230, 'Fábio Alves', 'FÁBIO ANDRÉ TEIXEIRA ALVES', 'fabioalves@ua.pt', 'DFE162EA-2722-46B5-9611-199D1EA2C94B', '', '', '', '', '2013-09-12'),
(1233, 'Fábio Barros', 'FÁBIO DANIEL RODRIGUES BARROS', 'fabiodaniel@ua.pt', '8C2F1324-FE76-4DA7-B3CF-6F995D55FEA6', '', '', '', '', '2016-09-25'),
(1236, 'Fábio Pereira', 'FÁBIO MANUEL BAPTISTA PEREIRA', 'fabiompereira@ua.pt', '2EBE112D-21FC-43A3-B760-E63ED579F6D3', '', '', '', '', '2013-09-20'),
(1239, 'Filipe Castro', 'FILIPE MIGUEL SANTOS DE CASTRO', 'filipemcastro@ua.pt', '802508C6-40FC-4984-8004-085D72629B0F', '', 'https://www.linkedin.com/in/filipe-castro-8738a497/', '', '', '2013-09-12'),
(1242, 'Filipe Neto Pires', 'FILIPE DA SILVA NETO ABRANCHES PIRES', 'filipesnetopires@ua.pt', '09E8B4D6-FCFE-4A53-858A-5E6D7C1A9075', '/upload/curriculos/1242.pdf', '', '', '', '2018-01-11'),
(1245, 'Flávia Figueiredo', 'FLÁVIA GOMES FIGUEIREDO', 'flaviafigueiredo@ua.pt', '0BE574DF-4044-400A-BE42-A8FFC88ECCB7', '', 'https://www.linkedin.com/in/flavia-figueiredo/', '', '', '2017-10-23'),
(1248, 'Flávia Cardoso', 'FLAVIA MANUELA PINHEIRO CARDOSO', 'flaviamcardoso@ua.pt', '22B54D25-3009-404C-9199-D02EA787FBB8', '', '', '', '', '2013-09-12'),
(1251, 'Fábio Santos', 'FÁBIO MIGUEL TOMAZ DOS SANTOS', 'fmts@ua.pt', '50DCE9CF-23FD-4926-B881-A44F2667CB85', '', '', '', '', '2015-09-23'),
(1254, 'Francisca Barros', 'FRANCISCA INÊS MARCOS DE BARROS', 'francisca.mbarros@ua.pt', '27F22927-E453-4AE1-B78E-BBE67C8218E1', '', '', '', '', '0000-00-00'),
(1257, 'Francisco Machado', 'FRANCISCO JOÃO DUARTE MACHADO', 'francisco.machado@ua.pt', '583878B4-6C43-4296-B504-1E5F65E45689', '', '', '', '', '2013-09-29'),
(1260, 'Francisco Pinho', 'FRANCISCO PINHO OLIVEIRA', 'francisco.pinho@ua.pt', 'A5BFCA8B-FCC3-4C55-9883-7CA737CABE74', '', '', '', '', '2014-09-17'),
(1263, 'Francisco Araújo', 'FRANCISCO FERNANDO VILELA ARAÚJO', 'franciscoaraujo@ua.pt', 'EC8EB5CF-0E82-4C33-900F-26A94F634C99', '', '', '', '', '2015-09-23'),
(1266, 'Francisco Silveira', 'FRANCISCO LOURENÇO BRASIL SILVEIRA', 'franciscosilveira@ua.pt', '0F843A02-F4CB-4BB5-9EFA-7D9D9B267D00', '/upload/curriculos/1266.pdf', '', '', '', '2018-01-11'),
(1269, 'Frederico Avo', 'FREDERICO CAMPOS DE AVO', 'fredericoavo@ua.pt', '5D6270FF-B082-46A5-A3D7-31BBFF394229', '', '', '', '', '2015-09-23'),
(1272, 'Gil Mesquita', 'GIL GUILHERME CAÇADOR FERNANDES MESQUITA', 'gil.mesquita@ua.pt', 'A3ED09EC-019D-4D93-A945-0D43D65A2B4A', '', '', '', '', '2013-09-24'),
(1275, 'Gonçalo Matos', 'GONÇALO ANDRÉ FERREIRA MATOS', 'gmatos.ferreira@ua.pt', 'ADE949DB-D390-4AC3-82FB-9F1D609FEA8D', '', 'https://www.linkedin.com/in/goncalofmatos/', '', '', '0000-00-00'),
(1278, 'Gonçalo Almeida', 'GONÇALO LIMA DE ALMEIDA', 'goncalo.almeida@ua.pt', '9DFA3F2B-4B3F-468F-B487-67C7F05AD822', '', '', '', '', '2015-09-23'),
(1281, 'Gonçalo Nogueira', 'GONÇALO PINTO NOGUEIRA', 'goncalo34@ua.pt', 'DC029634-313B-4F06-B615-3C291B2542DB', '', '', '', '', '2017-10-23'),
(1284, 'Gonçalo Freixinho', 'GONÇALO JOSÉ DE BARROS FREIXINHO', 'goncalofreixinho@ua.pt', 'B094AB13-79C6-45FC-A03D-857498C09CA3', '', '', '', '', '2017-10-23'),
(1287, 'Gonçalo Passos', 'GONÇALO CORREIA PASSOS', 'goncalopassos@ua.pt', '6A53CE74-BFCD-4682-9393-516A9CF3B250', '', '', '', '', '2017-10-23'),
(1290, 'Gonçalo Pinto', 'GONÇALO DIOGO AUGUSTO RODRIGUES PINTO', 'goncalopinto@ua.pt', '0CABD920-5044-4D75-8FBE-8310387BBF43', '', '', '', '', '2013-09-12'),
(1293, 'Guilherme Moura', 'GUILHERME PAULO OLIVEIRA MOURA', 'gpmoura@ua.pt', '38F52836-4107-4EBB-8811-EA47AC6D4531', '', '', '', '', '2013-09-12'),
(1296, 'Guilherme Lopes', 'GUILHERME MATOS LOPES', 'guilherme.lopes@ua.pt', '0B016983-7B1E-46BF-83D9-007F5D78E0ED', '', '', '', '', '2017-10-23'),
(1299, 'Gustavo Neves', 'GUSTAVO NUNO NEVES FERREIRA', 'gustavo.neves@ua.pt', '4AE4151C-4599-42FC-B587-58023A92E7A3', '', '', '', '', '2016-03-04'),
(1302, 'Manso', 'HENRIQUE JOSÉ MARQUES MANSO', 'henrique.manso@ua.pt', '2DFB83A2-EEBC-46B8-BBE7-0DFFA3FDF7DC', '', '', '', '', '2013-09-12'),
(1305, 'Henrique Moreira', 'HENRIQUE MANUEL DE ALMEIDA MOREIRA', 'henrique.moreira@ua.pt', 'C778294E-8B32-4BFD-AFAA-62C6AAE0FCF9', '', '', '', '', '2013-09-24'),
(1308, 'Henrique Gonçalves', 'HENRIQUE EMANUEL OLIVEIRA GONÇALVES', 'henriqueoliveira@ua.pt', 'FED17B86-84DC-47CD-B7E5-9A341A11D674', '', '', '', '', '2013-09-15'),
(1311, 'Hugo Soares', 'HUGO EMANUEL DE OLIVEIRA SOARES', 'heos@ua.pt', '541D5C5E-1CF2-4763-BD52-6692EC4A8870', '', '', '', '', '2014-04-02'),
(1314, 'Hugo Oliveira', 'HUGO FILIPE FERREIRA OLIVEIRA', 'hffoliveira@ua.pt', '64745D10-EEBD-48CE-8FAF-96F88F07E2AA', '', '', '', '', '2014-09-17'),
(1317, 'Hugo Pintor', 'HUGO RAFAEL CAMPINOS PINTOR', 'hrcpintor@ua.pt', '347D34DE-3120-4F50-9407-B363FFB48518', '', 'https://www.linkedin.com/in/hugo-pintor/', '', '', '2014-09-15'),
(1320, 'Hugo Correia', 'HUGO ANDRÉ MARTINS CORREIA', 'hugo.andre@ua.pt', '519E3111-2CF4-4DAD-8C29-B0E6EE4BF09C', '', 'https://www.linkedin.com/in/hugo-correia-0985888b/', '', '', '2013-09-09'),
(1323, 'Hugo Santos', 'HUGO ANDRÉ FERREIRA DE ALMEIDA SANTOS', 'hugoandre@ua.pt', 'BF75A2F3-A6CC-4A54-A1BD-A38476700A6D', '', '', '', '', '2013-09-12'),
(1326, 'Hugo Ferreira', 'HUGO DINIS OLIVEIRA FERREIRA', 'hugodinis@ua.pt', 'BB7590A4-9C27-4F56-A892-FA8426EA681B', '', '', '', '', '0000-00-00'),
(1329, 'Hugo Almeida', 'HUGO FILIPE RIBEIRO PAIVA DE ALMEIDA', 'hugofpaiva@ua.pt', 'A08FAA58-5EB0-444F-B4D5-A538E5A915C5', '', 'https://www.linkedin.com/in/hugofpaiva/', '', '', '0000-00-00'),
(1332, 'Hugo Silva', 'HUGO MIGUEL OLIVEIRA E SILVA', 'hugomsilva@ua.pt', '8D5E7D6E-44E1-4A01-A9C8-A9E933175F6E', '', '', '', '', '2013-09-25'),
(1335, 'Inês Correia', 'INÊS GOMES CORREIA', 'ines.gomes.correia@ua.pt', '110C5947-2E01-48FA-8574-36536F06A212', '/upload/curriculos/1335.pdf', 'https://www.linkedin.com/in/in%C3%AAs-correia/', '', '', '2014-09-15'),
(1338, 'Inês Santos', 'INES DE OLIVEIRA SANTOS', 'ines.oliveira@ua.pt', '6D666A90-4C57-4FDF-A7D9-40DDA7930A08', '', '', '', '', '2013-09-12'),
(1341, 'Inês Leite', 'INÊS PINHO LEITE', 'ines.pl@ua.pt', '3095F985-9843-4EF4-A0DA-A1396CEE7AA3', '', '', '', '', '0000-00-00'),
(1344, 'Maria Rocha', 'MARIA INÊS SEABRA ROCHA', 'ines.seabrarocha@ua.pt', 'DEB666E5-3DB2-4E4F-A4B5-C3A1E5AD3077', '', '', '', '', '0000-00-00'),
(1347, 'Inês Pombinho', 'INÊS COSTA POMBINHO', 'inespombinho@ua.pt', '1353F351-E649-4D58-875E-E59E3601B131', '', '', '', '', '2017-10-23'),
(1350, 'Isadora Loredo', 'ISADORA FERREIRA LOREDO', 'isadora.fl@ua.pt', '7200E484-B90B-4257-9E57-60D9541A70E0', '/upload/curriculos/1350.pdf', 'https://www.linkedin.com/in/isadora-f-loredo/', 'https://github.com/flisadora', '', '0000-00-00'),
(1353, 'Isaac dos Anjos', 'ISAAC TOMÉ DOS ANJOS', 'itda@ua.pt', '6E2743D8-7B4E-43EB-9F9A-B80FE9B5FFE7', '/upload/curriculos/1353.pdf', '', '', '', '2017-05-27'),
(1356, 'Ivo Angélico', 'IVO ALEXANDRE COSTA ALVES ANGÉLICO', 'ivoangelico@ua.pt', '7D447F49-BD63-4C90-B3D1-ECD6F98F8A08', '', '', '', '', '2019-02-13'),
(1359, 'Jean Brito', 'Jean Brito', 'j.brito@ua.pt', 'B14C29C0-DB97-4276-845D-7B91B93F3FF7', '/upload/curriculos/1359.pdf', 'https://www.linkedin.com/in/britojean/', '', '', '2019-04-24'),
(1362, 'João Vasconcelos', 'JOÃO MIGUEL NUNES DE MEDEIROS E VASCONCELOS', 'j.vasconcelos99@ua.pt', '9B7FC8DC-465E-4C5D-A609-F46515BFF072', '/upload/curriculos/1362.pdf', 'https://www.linkedin.com/in/jo%C3%A3o-vasconcelos/', '', '', '2017-10-23'),
(1365, 'Joao Costa', 'JOÃO ARTUR DOS SANTOS MOREIRA DA COSTA', 'jarturcosta@ua.pt', '589DF9F1-6453-4869-B999-858C7F05F23B', '/upload/curriculos/1365.pdf', 'https://www.linkedin.com/in/jo%C3%A3o-artur-costa-328712146/', 'https://gitlab.com/jarturcosta', '', '2015-09-23'),
(1368, 'João Santos', 'JOÃO CARLOS PINTO SANTOS', 'jcps@ua.pt', '6F626743-2C65-4880-B520-FCF40BB31926', '', '', '', '', '2013-09-29'),
(1371, 'Soares', 'JOÃO FERREIRA SOARES', 'jfsoares@ua.pt', '70015803-03FE-4C5D-AE32-9D067A422F8F', '', '', '', '', '2015-09-23'),
(1374, 'João Catarino', 'JOÃO FRANCISCO TEIXEIRA CATARINO', 'jftcatarino@ua.pt', '3C5A4E24-0648-4AFF-AB20-74620471EFE3', '', '', '', '', '0000-00-00'),
(1377, 'João Gravato', 'JOÃO MIGUEL LOPES GRAVATO', 'jmlgravato@ua.pt', '7B31513F-1C0C-48A4-91DC-1A46D6FE1416', '', '', '', '', '2013-09-12'),
(1380, 'Joana Coelho', 'JOANA COELHO VIGÁRIO', 'joana.coelho@ua.pt', '9568B59A-B5E5-4E8D-BDAA-21B00EF08263', '', 'https://www.linkedin.com/in/joanacoelhovigario/', '', '', '2013-09-12'),
(1383, 'João Carvalho', 'JOÃO MIGUEL SANTOS CARVALHO', 'joao.carvalho19@ua.pt', 'A56441CD-9528-413E-8AAD-377E49AFFC05', '', '', '', '', '2018-12-07'),
(1386, 'João Faria', 'JOÃO DA SILVA FARIA', 'joao.faria00@ua.pt', '961FC997-E7D4-4E23-9BF7-982518CD3D5C', '', '', '', '', '2017-10-23'),
(1389, 'João Laranjo', 'JOÃO PEDRO DE MELO LARANJO', 'joao.laranjo@ua.pt', 'C7D9883A-22F2-4D83-97DF-FE0C4BB6D310', '', 'https://www.linkedin.com/in/joaolaranj0/', '', '', '2018-10-09'),
(1392, 'Joao Mourao', 'JOÃO MANUEL PALMARES MOURÃO', 'joao.mourao97@ua.pt', '339B8F99-6F03-4847-A9F1-65B249C9E780', '', '', '', '', '2015-09-23'),
(1395, 'Joao Marques', 'Joao Marques', 'joao.p.marques@ua.pt', '', '', '', '', '', '2019-06-24'),
(1398, 'João Pedro Alegria', 'JOÃO PEDRO SIMÕES ALEGRIA', 'joao.p@ua.pt', 'CC1CB549-04F7-4445-BDA9-B3DD36B72869', '/upload/curriculos/1398.pdf', '', '', '', '2018-01-11'),
(1401, 'Gold', 'JOÃO PEDRO SANTOS ROCHA', 'joao.pedro.rocha@ua.pt', '92071185-57B0-4208-AA38-B317B57C0613', '', '', '', '', '2013-09-12'),
(1404, 'João Almeida', 'JOÃO RAFAEL DUARTE DE ALMEIDA', 'joao.rafael.almeida@ua.pt', '988D005C-9110-4501-9F8D-CF8C868C1AB2', '', '', '', '', '2013-10-05'),
(1407, 'Joao Serpa', 'JOÃO CARREIRO SERPA', 'joao.serpa@ua.pt', 'AB9502DA-B04A-4310-97B8-85F427602D6A', '', '', '', '', '2015-09-23'),
(1410, 'João Ribeiro', 'JOÃO ANTÓNIO LOPES RIBEIRO', 'joaoantonioribeiro@ua.pt', '169CA622-6142-4BAC-8083-CD8BB0A7047C', '', 'https://www.linkedin.com/in/jo%C3%A3o-ribeiro-a76951168/', '', '', '2018-01-11'),
(1413, 'Joao Cruz', 'JOÃO PEDRO PINHO DA CRUZ', 'joaocruz@ua.pt', '94D83A7E-6C5C-495D-98F4-2EF6E861C933', '', '', '', '', '2015-09-23'),
(1416, 'João Carvalho', 'JOÃO FILIPE MAGALHÃES CARVALHO', 'joaofcarvalho@ua.pt', '8762767F-F805-441F-8F45-4E0E38A941F2', '', '', '', '', '2014-09-15'),
(1419, 'Joao Ferreira', 'JOÃO GUILHERME MENDONÇA PIMENTA DE OLIVEIRA FERREIRA', 'joaogferreira@ua.pt', 'A7CC0EB3-724C-4B2A-B9B6-E1222158E77A', '', '', '', '', '2015-09-23'),
(1422, 'João Limas', 'JOÃO RENATO PINTO LIMAS', 'joaolimas@ua.pt', 'A608E4D0-FCCB-42DA-AAA5-C70BFEC03B99', '', 'https://www.linkedin.com/in/joao-limas/', '', '', '2013-09-12'),
(1425, 'Joao Dias', 'JOÃO MIGUEL ABRANTES DIAS', 'joaomadias@ua.pt', 'AE87359F-C162-4085-AAD2-7099B5CFA5AF', '', '', '', '', '2019-03-27'),
(1428, 'João Dias', 'JOÃO MIGUEL SERRAS DIAS', 'joaomdias@ua.pt', '850A054B-F4FF-498A-A7CB-557EC3D38A6C', '', '', '', '', '2017-10-23'),
(1431, 'João Lourenço', 'JOÃO MIGUEL ISIDORO DA ROCHA LOURENÇO', 'joaomiguellourenco@ua.pt', 'BF89508C-AF78-40D8-BA28-F5D5EB4C0ADC', '', '', '', '', '0000-00-00'),
(1434, 'João Nogueira', 'JOÃO EDUARDO ALVES NOGUEIRA', 'joaonogueira20@ua.pt', '1638DD9E-49B2-48B3-82E1-2B789C09D75E', '', '', '', '', '2017-10-23'),
(1437, 'João Paúl', 'JOÃO ANTÓNIO CALISTO PAÚL', 'joaopaul@ua.pt', '24FD9E12-64E1-4833-B345-F4317B778737', '', '', '', '', '2014-09-15'),
(1440, 'João Martins', 'JOÃO PEDRO MARTINS GONÇALVES', 'joaopmg96@ua.pt', '4F43F42B-3496-4AF2-9C6C-FF4BC4F3A216', '', '', '', '', '2014-09-17'),
(1443, 'João Pedrosa', 'JOÃO PEDRO OLIVEIRA PEDROSA', 'joaoppedrosa@ua.pt', '08E09FA7-C16B-4582-87AC-873B452313B9', '', '', '', '', '2013-10-18'),
(1446, 'João Vasconcelos', 'JOÃO PEDRO LACERDA VASCONCELOS', 'joaopvasconcelos@ua.pt', 'E525FE41-FC06-4CA1-8CBF-C25095FF6534', '', '', '', '', '2018-12-15'),
(1449, 'João Campos', 'JOÃO RICARDO ANTUNES CAMPOS', 'joaoricardoantunescampos@ua.pt', '601E1072-5A3E-4F1F-9AA0-57F3FCB2E5ED', '', '', '', '', '2014-09-17'),
(1452, 'Joao Abilio Rodrigues', 'JOÃO ABÍLIO DA SILVA RODRIGUES', 'joaosilva9@ua.pt', '2F81E704-6632-43B7-8B3F-46CCE4BBDDFA', '/upload/curriculos/1452.pdf', 'https://www.linkedin.com/in/joaoarodrigues9', '', '', '2017-10-22'),
(1455, 'João Alegria', 'JOÃO TIAGO FARIA ALEGRIA', 'joaotalegria@ua.pt', '3865AA07-9DFB-4157-801B-D136D22E1244', '', 'https://www.linkedin.com/in/jtalegria/', '', '', '2013-09-12'),
(1458, 'Joao Tomaz', 'JOÃO DANIEL GOMES TOMAZ', 'joaotomaz@ua.pt', 'A918FB1F-3924-4A84-8965-D90F9B4E1A2A', '', '', '', '', '2014-09-15'),
(1461, 'João Soares', 'JOÃO TEIXEIRA SOARES', 'joaots@ua.pt', 'D18FF07E-2577-47D0-B038-94D5AE7CA829', '', '', '', '', '0000-00-00'),
(1464, 'Jorge Fernandes', 'JORGE FRANCLIM MARTINS NASCIMENTO FERNANDES', 'jorge.fernandes@ua.pt', 'FA37FBF2-2797-48BB-B86F-D5AC58819379', '', 'https://www.linkedin.com/in/jorge-fernandes/', '', '', '2013-10-10'),
(1467, 'Jorge Pimenta', 'JORGE HUMBERTO E SOUSA PIMENTA', 'jorge.pimenta@ua.pt', 'A6E05F3E-E29B-41F7-89B0-1E642A55C0D8', '', '', '', '', '2013-09-24'),
(1470, 'Jorge Leite', 'JORGE BARROCAS LEITE', 'jorgeleite@ua.pt', '8059E358-46BC-4F3D-AEF6-5FE398DE8FAA', '', '', '', '', '0000-00-00'),
(1473, 'José Santos', 'JOSÉ PEDRO VAZ SANTOS', 'jose.vaz@ua.pt', '46C75291-8FC7-4A8B-B19A-902DAA0717D5', '', '', '', '', '2017-10-23'),
(1476, 'José Frias', 'JOSÉ ANDRÉ LOPES FRIAS', 'josefrias99@ua.pt', '6E752B76-0600-42D1-A8D6-36ACE20E8BC8', '', '', '', '', '2017-10-23'),
(1479, 'José Sousa', 'JOSÉ LUCAS MIMOSO DONAS BOTTO SOUSA', 'joselmdbsousa@ua.pt', '9CA67BF3-30F1-4E86-9EB9-135F5557CA5B', '', '', '', '', '0000-00-00'),
(1482, 'José Pedro', 'JOSÉ PEDRO ALVES FERREIRA DO CARMO', 'josepedrocarmo@ua.pt', 'E8CE6C40-94CF-48A3-85A3-DA9F93616E26', '', '', '', '', '2013-11-07'),
(1485, 'Jose Moreira', 'JOSÉ PEDRO PINTO MOREIRA', 'joseppmoreira@ua.pt', '2B61A8A7-D3E2-4F16-B70B-18F66EEA7920', '', '', '', '', '2015-09-23'),
(1488, 'Jose Ribeiro', 'Jose Ribeiro', 'josepribeiro@ua.pt', '', '', '', '', '', '2019-05-20'),
(1491, 'José Rego', 'JOSÉ FILIPE DIAS REGO', 'joserego@ua.pt', 'A3F5D504-8663-4107-9679-6E3E33F5AD7F', '', '', '', '', '2013-09-12'),
(1494, 'José Reis', 'JOSÉ FILIPE RIBAS DOS SANTOS REIS', 'josereis@ua.pt', '3250B11C-63AC-4DAD-AD59-2D16550CC3CF', '', '', '', '', '2013-10-11'),
(1497, 'José Sá', 'JOSÉ AUGUSTO DE GÓIS RODRIGUES DE SÁ', 'josesa@ua.pt', '497AF720-BEA4-49B6-BEB2-46C3C5E6C40A', '', '', '', '', '2013-09-29'),
(1500, 'Josimar Cassandra', 'JOSIMAR DOS PRAZERES BENEDITO CASSANDRA', 'josimarcassandra@ua.pt', '5DF16216-8395-4FF1-B629-6A792B8E9CA9', '', 'https://www.linkedin.com/in/josimar-cassandra-28888b11b/', '', '', '2013-09-12'),
(1503, 'João Pereira', 'JOÃO PEDRO FERNANDES PEREIRA', 'jpedro@ua.pt', 'A03A64C6-AA0C-49EB-8E28-E667E662B122', '', '', '', '', '2013-10-15'),
(1506, 'José Gonçalves', 'JOSÉ PEDRO DOMINGUES GONÇALVES', 'jpedrogoncalves@ua.pt', '311F08A8-B708-4950-BBC7-91C2780BFBD1', '', '', '', '', '2018-01-11'),
(1509, 'João Gonçalves', 'JOÃO PEDRO PINO GONÇALVES', 'jpedropino@ua.pt', 'BC060265-0D1A-4DB2-AF73-B616293D4256', '', '', '', '', '2014-09-15'),
(1512, 'Joao Magalhaes', 'JOÃO RICARDO SANTANA RIBEIRO MAGALHÃES', 'jrsrm@ua.pt', '9528C242-2E32-401E-8F2F-788941F01B28', '', '', '', '', '2015-09-23'),
(1515, 'Luís Oliveira', 'LUÍS FILIPE PINTO OLIVEIRA', 'l.f.p.o@ua.pt', '1000B683-5AE8-4724-A510-B66456B079E5', '', '', '', '', '2013-09-24'),
(1518, 'Luís Rêgo', 'LUÍS ALVES DE SOUSA RÊGO', 'lasr@ua.pt', 'DA0FF020-911B-4263-8E39-2105E8715C7E', '', '', '', '', '2018-12-09'),
(1521, 'Leandro Silva', 'LEANDRO EMANUEL SOARES ALVES DA SILVA', 'leandrosilva12@ua.pt', 'AC4E9C03-8C71-4B0E-AF0F-B072868BEBA2', '/upload/curriculos/1521.pdf', '', '', '', '0000-00-00'),
(1524, 'Luís Miguel Costa', 'LUÍS MIGUEL DIAS DOS SANTOS PEREIRA DA COSTA', 'lmcosta98@ua.pt', '9817C75D-ED1C-46A4-86AF-199C5CD7B472', '', '', '', '', '2018-01-11'),
(1527, 'Francisco Lopes', 'FRANCISCO QUADRADO LOPES', 'lopes.francisco@ua.pt', '53F43B53-2FBD-4A4B-BB8C-118032833B97', '', '', '', '', '2014-09-15'),
(1530, 'Luís Cardoso', 'LUÍS PEDRO CARDOSO', 'lpcardoso@ua.pt', 'CBC71464-4CF1-4E6B-B6B1-B1433C38EFED', '', '', '', '', '2018-01-11'),
(1533, 'Tiago Santos', 'TIAGO LUIS SALGUEIRO DOS SANTOS', 'ltiagosantos@ua.pt', 'B32FD58A-04F0-4EBD-8739-068F6127E2B2', '', '', '', '', '2013-10-21'),
(1536, 'Lucas Silva', 'LUCAS AQUILINO ALMEIDA DA SILVA', 'lucasaquilino@ua.pt', '904CFA62-ED8E-46A0-B8A3-D967EC34EBBB', '', '', '', '', '2018-01-11'),
(1539, 'Lucas Barros', 'LUCAS FILIPE ROBERTO DE BARROS', 'lucasfrb45@ua.pt', 'CCE70F43-70A4-4A7B-867A-A8D42E4E2E5C', '', '', '', '', '2018-01-11'),
(1542, 'Luís Pereira', 'LUÍS ANTÓNIO CASTRO MORAIS PINTO PEREIRA', 'luis.pinto.pereira@ua.pt', '7C0AE4E2-DC10-496D-8F26-F674FC154753', '', '', '', '', '0000-00-00'),
(1545, 'Luís Fonseca', 'LUÍS CARLOS DUARTE FONSECA', 'luiscdf@ua.pt', '3B5E7C5A-71C8-4853-A188-1C4C11FDD642', '', '', '', '', '2017-10-23'),
(1548, 'Luís Silva', 'LUÍS FILIPE GUEDES BORGES DA SILVA', 'luisfgbs@ua.pt', '937406ED-D4C5-48F8-A585-98236F77BED9', '', '', '', '', '2017-10-23'),
(1551, 'Luis Santos', 'LUIS FILIPE ALMEIDA SANTOS', 'luisfsantos@ua.pt', '2150D9AB-7CF5-4EB4-BDD1-7C9F3EF11713', '', 'https://www.linkedin.com/in/luis-filipe-santos-2510/', '', '', '2013-09-18'),
(1554, 'Luís Oliveira', 'LUÍS ANDRÉ PAIS ALVES DE OLIVEIRA', 'luisoliveira98@ua.pt', 'F53C29C5-533C-4465-A909-16DBE4F6299B', '', '', '', '', '2018-01-11'),
(1557, 'Luís Valetim', 'LUÍS MIGUEL GOULART VALENTIM', 'lvalentim@ua.pt', '3CDE541D-3BE9-4432-B1C2-D5F9F9B1E744', '', '', '', '', '0000-00-00'),
(1560, 'Maria Lopes', 'MARIA SALOMÉ FIGUEIRA LOPES', 'm.lopes1@ua.pt', '63826462-8106-4F35-B9CC-5BB25CC38D33', '', '', '', '', '2015-09-23'),
(1563, 'Gonçalo Ferreira', 'GONÇALO MACÁRIO FERREIRA', 'macario.goncalo@ua.pt', '2D4F1C1E-6958-40E6-9198-179836B50A55', '', '', '', '', '2013-09-12'),
(1566, 'Andreia Machado', 'ANDREIA RAQUEL FILIPE MACHADO', 'machadoandreia@ua.pt', 'AD211965-137B-45DB-9DB1-2857A5CF7DAA', '', '', '', '', '2014-09-17'),
(1569, 'Manuel Marcos', 'MANUEL CURA MARCOS', 'manuel.cura@ua.pt', '3231D5EA-10B7-48F1-AE02-5C5F6236E415', '', '', '', '', '2014-09-17'),
(1572, 'Manuel Felizardo', 'MANUEL ANTÓNIO FELIZARDO ROXO', 'manuel.felizardo@ua.pt', '23994C79-C4F1-4AE2-B4AE-3BD6B19CFF41', '', '', '', '', '2015-09-23'),
(1575, 'Manuel Gil', 'MANUEL JOÃO BALTAZAR GIL', 'manuel.gil@ua.pt', 'DD6E142F-010E-4006-A0F3-63CE940D1D35', '', '', '', '', '2013-09-24'),
(1578, 'Manuel Roda', 'MANUEL LUÍS VALENTE RODA', 'manuel.roda@ua.pt', '81E78F6D-F58C-4582-A01B-0849D3499735', '', '', '', '', '2014-09-17'),
(1581, 'Marcelo Cardoso', 'MARCELO JOSÉ FIGUEIREDO CARDOSO', 'marcelocardoso@ua.pt', 'CB7EE087-4425-4981-8E08-E48B7E40334F', '', '', '', '', '2013-09-24'),
(1584, 'Marcelo Génio', 'MARCELO PEREIRA GÉNIO', 'marcelog@ua.pt', 'D2F7C1A8-49E0-4D50-A9F3-AA06D731B261', '', '', '', '', '2013-09-25'),
(1587, 'Márcia', 'MÁRCIA DE CARVALHO CARDOSO', 'marciaccardoso@ua.pt', '7C66D413-A9A8-46CC-A83E-EA1B42516D72', '', '', '', '', '2015-09-23'),
(1590, 'Márcio Fernandes', 'MÁRCIO ANDRÉ NOGUEIRA FERNANDES', 'marcioafernandes@ua.pt', 'E21F145B-A4B7-4E72-8AE6-A058D5FEA267', '', '', '', '', '2013-09-12'),
(1593, 'Marco Miranda', 'MARCO RODRIGUES MIRANDA', 'marco.miranda@ua.pt', '040D58CA-41EC-4245-8DE8-EC560F275B3D', '', '', '', '', '2013-09-12'),
(1596, 'Marco Ventura', 'MARCO ANDRÉ MORAIS VENTURA', 'marcoandreventura@ua.pt', 'FA796E0B-BA72-4756-82B9-AA0B486ECED7', '/upload/curriculos/1596.pdf', '', '', '', '2014-09-15'),
(1599, 'Marcos Silva', 'MARCOS OLIVEIRA MOREIRA DA SILVA', 'marcossilva@ua.pt', 'ECABF47F-0A5A-4EFD-B157-4AC9AAC6E261', '', 'https://www.linkedin.com/in/marcos-silva-a64b7850/', '', '', '2013-09-09'),
(1602, 'Margarida Martins', 'MARGARIDA SILVA MARTINS', 'margarida.martins@ua.pt', 'A2FF0A2A-52F1-45E6-8869-B9DD2340E385', '/upload/curriculos/1602.pdf', 'https://www.linkedin.com/in/margarida-martins-140086173/', '', '', '0000-00-00'),
(1605, 'Mariana Gameiro', 'MARIANA BALUGA GAMEIRO', 'mari.gameiro@ua.pt', '2E566B1B-75A1-4B72-81C2-4CD0565D14CF', '', '', '', '', '2017-10-23'),
(1608, 'Mariana Ladeiro', 'MARIANA BACÊLO LADEIRO', 'marianaladeiro@ua.pt', '18F478C2-84DB-4150-AFB7-DB40D509CCD6', '', '', '', '', '0000-00-00'),
(1611, 'Mariana Santos', 'MARIANA SOUSA PINHO SANTOS', 'marianasps@ua.pt', '945900A4-7A8E-4998-B935-E85206B02E8D', '', '', '', '', '0000-00-00'),
(1614, 'Marina Wischert', 'MARINA FARIAS WISCHERT', 'marinawischert@ua.pt', 'D536B8F0-EE1F-410C-BFFF-E0B4DAA437AA', '', '', '', '', '2013-09-12'),
(1617, 'Mário Correia', 'MÁRIO JORGE LOPES CORREIA', 'mariocorreia@ua.pt', '67C01E23-6771-4449-843B-8B04E985EA88', '', '', '', '', '2014-04-01'),
(1620, 'Mário Silva', 'MÁRIO FRANCISCO COSTA SILVA', 'mariosilva@ua.pt', 'A5D099D7-4F7F-4382-874C-59078B7E6DEF', '', '', '', '', '0000-00-00'),
(1623, 'André Cardoso', 'ANDRÉ FILIPE MARQUES CARDOSO', 'marquescardoso@ua.pt', 'DBC00079-CCFF-4FE8-8FB6-4DFCEBBFF9B7', '', '', '', '', '2015-09-21'),
(1626, 'Marta Ferreira', 'MARTA SEABRA FERREIRA', 'martasferreira@ua.pt', '8FA9F1BD-7E8A-45F0-BF41-7B3F7A6282AD', '', 'https://www.linkedin.com/in/marta-sferreira/', '', '', '2017-10-23'),
(1629, 'Maxlaine Moreira', 'MAXLAINE SILVA MOREIRA', 'maxlainesmoreira@ua.pt', 'CCE9E2A9-F921-4A84-9CD4-86E9D008BEB9', '', '', '', '', '2013-09-24'),
(1632, 'Miguel Araújo', 'MIGUEL DIOGO FERRAZ ARAÚJO', 'mdaraujo@ua.pt', '9A40CB93-7894-4BC7-8BDC-44FE472EB056', '', '', '', '', '2019-01-06'),
(1635, 'Ana Mendes', 'ANA FILIPA VINHAS MENDES', 'mendesana@ua.pt', 'B963547E-D8AE-40BA-A8E2-BB3BC9D67E4A', '', '', '', '', '2013-09-18'),
(1638, 'Mariana Sequeira', 'MARIANA FIGUEIREDO SEQUEIRA', 'mfs98@ua.pt', '39C30989-D52C-4943-BDDF-A9836BCABDA5', '', 'https://www.linkedin.com/in/mariana-sequeira-82a811171/', '', '', '2018-01-11'),
(1641, 'Micael Mendes', 'MICAEL MARQUES MENDES', 'micaelmendes@ua.pt', '031DB6CD-F6B0-47CB-8E65-7584E3EC2A8D', '', '', '', '', '2015-09-23'),
(1644, 'Miguel Fradinho', 'MIGUEL FRADINHO ALVES', 'miguel.fradinho@ua.pt', '705A65FE-A078-4BEF-B7DE-3770BC49D5C3', '/upload/curriculos/1644.pdf', '', '', '', '2018-12-05'),
(1647, 'Miguel Mota', 'MIGUEL MARTINS MOTA', 'miguel.mota@ua.pt', 'DDE195D9-090B-42F7-B9BC-3FFB2F1466B8', '', '', '', '', '2017-10-23'),
(1650, 'Miguel Santos', 'VÍTOR MIGUEL CASTANHEIRA DOS SANTOS', 'miguel.santos@ua.pt', '394DDFA9-67C4-42C3-B271-F060AB14E3B3', '', '', '', '', '2014-03-31'),
(1653, 'Miguel Antunes', 'MIGUEL ÂNGELO FARINHA ANTUNES', 'miguelaantunes@ua.pt', 'E474FAEA-769D-4ABC-86CA-3C6AC906E1D4', '', 'https://www.linkedin.com/in/miguel-antunes/', '', '', '2013-09-12'),
(1656, 'Miguel Angelo Da Costa Rodrigu', 'MIGUEL ÂNGELO DA COSTA RODRIGUES', 'miguelangelorodrigues@ua.pt', '4FD1462C-6C7D-412F-9F16-9D65DC130612', '', '', '', '', '2014-11-11'),
(1659, 'Miguel Matos', 'MIGUEL FILIPE CARVALHAIS DOS SANTOS DE MATOS', 'miguelcarvalhaismatos@ua.pt', 'C3DA7E5D-013E-4A35-9084-963D362BCDED', '', '', '', '', '2014-09-17'),
(1662, 'Luís Castro', 'LUÍS MIGUEL SANTOS CASTRO', 'miguelcastro@ua.pt', 'A6D80A43-214F-4609-A5A8-3BDCC04F2920', '', '', '', '', '2014-09-17'),
(1665, 'Miguel Matos', 'MIGUEL CRUZ MATOS', 'miguelcruzmatos@ua.pt', '625E0BF7-67B2-4FF3-BD97-13736F336726', '', '', '', '', '2017-10-23'),
(1668, 'Miguel Santos', 'JOÃO MIGUEL VALENTE DOS SANTOS', 'miguelsantos@ua.pt', '4B6E7539-B628-4DA5-AC50-2C185EEA431D', '', '', '', '', '2014-04-02'),
(1671, 'Miguel Simoes', 'MIGUEL MARQUES SIMÕES', 'mmsimoes@ua.pt', '9A15CED1-2546-4EB4-9DA8-6FEA1D679B33', '', '', '', '', '2015-09-23'),
(1674, 'André Morais', 'ANDRÉ FILIPE MONIZ MORAIS', 'moraisandre@ua.pt', '777366FB-58C9-4D6C-87B5-6625532C46E5', '', 'https://www.linkedin.com/in/andre-moniz-morais/', '', '', '0000-00-00'),
(1677, 'Yuriy Muryn', 'YURIY MURYN', 'murynyuriy@ua.pt', 'FCC43FE4-92ED-4087-8CFD-5F25614E98B9', '', '', '', '', '2014-09-17'),
(1680, 'Neusa Barbosa', 'NEUSA SOFIA LOPES BARBOSA', 'neusa.barbosa@ua.pt', '7CAB7DE2-CE2D-41FE-A8B7-A3E6A1FE68FF', '', '', '', '', '2019-02-25'),
(1683, 'Nuno Cardoso', 'NUNO MIGUEL DE SOUSA CARDOSO', 'nmsc@ua.pt', '5957B054-04F7-429C-A8B5-925E9B3E8940', '', '', '', '', '2013-09-25'),
(1686, 'Nuno Aparicio', 'Nuno Aparicio', 'nuno.aparicio@ua.pt', '', '', '', '', '', '2019-05-20'),
(1689, 'Nuno Matamba', 'NUNO ALEXANDRE GOMES MATAMBA', 'nuno.matamba@ua.pt', 'DE62AE7E-E45D-4311-8891-1887F6D2D283', '', '', '', '', '2015-09-24'),
(1692, 'Nuno Silva', 'NUNO FILIPE MACHADO LOPES DA SILVA', 'nuno1@ua.pt', 'A8626D6D-2B31-4523-9609-C68FFE574A11', '', '', '', '', '2015-09-23'),
(1695, 'Olga Oliveira', 'OLGA MARGARIDA FAJARDA OLIVEIRA', 'olga.oliveira@ua.pt', 'D81DB24D-ACFC-4056-AD2C-65AF00210470', '', '', '', '', '2013-09-12'),
(1698, 'Orlando Macedo', 'ORLANDO JORGE RIBEIRO MACEDO', 'orlando.macedo15@ua.pt', '76D84966-DFCC-4D5E-8319-AC6010DF0700', '', '', '', '', '0000-00-00'),
(1701, 'Paulo Seixas', 'PAULO ALEXANDRE MARTINS SEIXAS', 'p.seixas96@ua.pt', '9ED1E631-9CE0-456D-AF89-6FE709732A92', '', 'https://www.linkedin.com/in/pauloamseixas/', '', '', '2014-09-17'),
(1704, 'Andreia Patrocinio', 'ANDREIA FILIPA MARTINS PATROCÍNIO', 'patrocinioandreia@ua.pt', '29B7A3BD-BC5F-484E-BE0B-2DA2E865FC8A', '/upload/curriculos/1704.pdf', '', '', '', '2015-09-23'),
(1707, 'Paulo Oliveira', 'PAULO JORGE NASCIMENTO DE OLIVEIRA', 'paulo.nascimento@ua.pt', '058BFF3D-53B0-46E8-AE2C-1277EFA99786', '', '', '', '', '2013-09-12'),
(1710, 'Paulo Pintor', 'PAULO SÉRGIO OLIVEIRA PINTOR', 'paulopintor@ua.pt', '033F2231-7E9F-40BA-8269-921BB7E4562E', '', 'https://www.linkedin.com/in/paulo-pintor/', '', '', '2013-10-15'),
(1713, 'Pedro Amaral', 'PEDRO MIGUEL LOUREIRO AMARAL', 'pedro.amaral@ua.pt', '8E7FAB88-0F36-4824-8103-25257F6FB9D8', '', '', '', '', '0000-00-00'),
(1716, 'Pedro Bastos', 'PEDRO MIGUEL BASTOS DE ALMEIDA', 'pedro.bas@ua.pt', '6671B2E9-0A68-4806-A16F-13CDEA958BFA', '', '', '', '', '0000-00-00'),
(1719, 'Pedro Ferreira', 'PEDRO JOSÉ GOMES FERREIRA', 'pedro.joseferreira@ua.pt', '8A248D9E-DA97-45C1-A10F-0E7594059860', '/upload/curriculos/1719.pdf', 'https://www.linkedin.com/in/pedro-ferreira-1a6756153/', '', '', '2018-01-11'),
(1722, 'Pedro Santos', 'PEDRO MIGUEL ALMEIDA SANTOS', 'pedro.miguel50@ua.pt', '025A4C5B-B629-46C1-9184-580C1032909C', '', '', '', '', '0000-00-00'),
(1725, 'Pedro Miguel Oliveira Costa', 'PEDRO MIGUEL OLIVEIRA COSTA', 'pedro.oliveira.costa@ua.pt', '85A9B0C2-3B84-474D-A2B5-8D62C5C1102C', '', '', '', '', '2017-05-27'),
(1728, 'Pedro Fernandes', 'PEDRO ALEXANDRE SANTOS FERNANDES', 'pedroafernandes@ua.pt', 'C83D9721-A4A9-435A-9A12-13F496F1674B', '', '', '', '', '2013-10-09'),
(1731, 'Pedro Dias', 'PEDRO ARTUR AFONSO DIAS', 'pedroafonsodias@ua.pt', 'F2285129-947B-4530-B0B3-39EF6841B2C4', '', '', '', '', '2013-09-15'),
(1734, 'Pedro Marques', 'PEDRO ALEXANDRE GONÇALVES MARQUES', 'pedroagoncalvesmarques@ua.pt', 'EA5279B0-0B1F-4421-AA04-EDE259F76780', '', '', '', '', '0000-00-00'),
(1737, 'Pedro Candoso', 'PEDRO BARBOSA CANDOSO', 'pedrocandoso2@ua.pt', '58DCED63-E656-4761-A9AF-9D50B8126A3F', '', '', '', '', '2018-01-11'),
(1740, 'Pedro Cavadas', 'PEDRO XAVIER LEITE CAVADAS', 'pedrocavadas@ua.pt', 'A3D697F1-5DCA-4405-93EC-6FD2D4C9AF26', '', '', '', '', '2018-01-11'),
(1743, 'Pedro Tavares', 'PEDRO DINIS BASTOS TAVARES', 'pedrod33@ua.pt', '7AFB2BC0-EF13-4D8C-AB91-2EF249CA7CEA', '', '', '', '', '0000-00-00'),
(1746, 'Pedro Fajardo', 'PEDRO MIGUEL OLIVEIRA FAJARDO', 'pedrofajardo98@ua.pt', '12EEEE5A-AD7D-4056-892A-04CE572B97EF', '', '', '', '', '2018-01-11'),
(1749, 'Pedro Fonseca', 'PEDRO MIGUEL LOPES DA FONSECA', 'pedrofonseca98@ua.pt', '42B04729-4FEF-460C-BE1A-B66DB4F81DC2', '/upload/curriculos/1749.pdf', '', '', '', '2018-01-11'),
(1752, 'Pedro Matos', 'PEDRO GUILHERME SILVA MATOS', 'pedroguilhermematos@ua.pt', 'AEC02114-337E-4F69-B559-9ABEB88DEFAA', '', 'https://www.linkedin.com/in/matos-pedro/', '', '', '2016-03-14'),
(1755, 'Pedro Matos', 'PEDRO DAVID LOPES MATOS', 'pedrolopesmatos@ua.pt', 'CBCF6FBB-1707-4163-A51D-FA7FD003D1D6', '', '', '', '', '2018-01-11'),
(1758, 'Pedro Souto', 'PEDRO MIGUEL GOMES DE ALMEIDA SOUTO', 'pedromgsouto@ua.pt', '44278869-CBA7-4B9B-BD33-849DEC8E6B79', '', '', '', '', '0000-00-00'),
(1761, 'Pedro Miguel', 'PEDRO MIGUEL FERREIRA MARQUES', 'pedromm@ua.pt', '2D34958A-AE4D-46BD-949F-12294AC356FD', '', '', '', '', '2018-12-07'),
(1764, 'Pedro Oliveira', 'PEDRO MIGUEL ROCHA OLIVEIRA', 'pedrooliveira99@ua.pt', 'E0854A60-C9D4-4181-A6D7-13668AF40266', '/upload/curriculos/1764.pdf', 'https://www.linkedin.com/in/pedromroliveira/', '', '', '2017-10-23'),
(1767, 'Gonçalo Pereira', 'GONÇALO DA COSTA PEREIRA', 'pereira.goncalo@ua.pt', '9B26B8A1-063D-44BF-8590-E75C8FE97D29', '', '', '', '', '0000-00-00'),
(1770, 'Jorge Pereira', 'JORGE MIGUEL ANTUNES PEREIRA', 'pereira.jorge@ua.pt', '0EEE15DC-CD62-4F43-AA88-0BAE7764DE27', '', 'https://www.linkedin.com/in/jorge-pereira-956095178/', '', '', '2013-09-12'),
(1773, 'Hélio Pesanhane', 'HÉLIO SALOMÃO PESANHANE', 'pesanhane@ua.pt', '81EDA7F9-27ED-4EA3-AF65-646E9B5F9296', '', '', '', '', '2013-10-05'),
(1776, 'João Rodrigues', 'JOÃO PEDRO GONÇALVES RODRIGUES', 'pgr96@ua.pt', 'C112BC74-FF42-4060-A339-18ECF2D11D06', '', 'https://www.linkedin.com/in/pedro-rodrigues-36b295139/', '', '', '2014-09-17'),
(1779, 'Pedro Casimiro', 'PEDRO LARANJINHA CASIMIRO', 'plcasimiro@ua.pt', '0F0774DE-E454-41CE-B0C7-6EBF66820B82', '', '', '', '', '0000-00-00'),
(1782, 'Pedro Silva', 'PEDRO MIGUEL ALVES SILVA', 'pmasilva20@ua.pt', 'A4B4B85D-CE88-48EE-B02F-8AE1763F1527', '', '', '', '', '0000-00-00'),
(1785, 'Pedro Neves', 'PEDRO MIGUEL PEREIRA NEVES', 'pmn@ua.pt', 'BA870AB8-87E0-40D7-87F2-1C4A209DE41F', '', '', '', '', '2013-09-12'),
(1788, 'Pedro Pires', 'PEDRO TEIXEIRA PIRES', 'ptpires@ua.pt', '2C9EB760-267A-4987-B926-89148B8E5DC7', '', 'https://www.linkedin.com/in/el-pires/', '', '', '2015-09-23'),
(1791, 'Rui Jesus', 'RUI FILIPE RIBEIRO JESUS', 'r.jesus@ua.pt', '3E743B4C-D130-4134-8A20-08A6925623BB', '', '', '', '', '2015-09-23');
INSERT INTO `users` (`id`, `name`, `full_name`, `uu_email`, `uu_iupi`, `curriculo`, `linkedIn`, `git`, `permission`, `created_at`) VALUES
(1794, 'Rui Melo', 'RUI FILIPE COIMBRA PEREIRA DE MELO', 'r.melo@ua.pt', '7EB9EABE-2838-4FFA-AF04-E28CC73EFF3C', '', '', '', '', '2017-10-23'),
(1797, 'Ricardo Antão', 'RICARDO NUNO DE LIMA ANTÃO', 'r.n.l.a@ua.pt', '3754DDDA-7400-4964-8423-3249FDAC6B13', '', '', '', '', '2013-09-25'),
(1800, 'Rafael Direito', 'RAFAEL DAS NEVES SIMÕES DIREITO', 'rafael.neves.direito@ua.pt', '841B00B4-DC68-42B4-AC21-531081E66FD3', '/upload/curriculos/1800.pdf', '', '', '', '2017-10-22'),
(1803, 'Rafael Baptista', 'RAFAEL FERREIRA BAPTISTA', 'rafaelbaptista@ua.pt', 'D2523B84-7133-43F3-8410-6C255DF94D09', '', '', '', '', '0000-00-00'),
(1806, 'Rafael Teixeira', 'RAFAEL GONÇALVES TEIXEIRA', 'rafaelgteixeira@ua.pt', '32039F55-1583-4DE1-B88A-030785C6EEAF', '/upload/curriculos/1806.pdf', 'https://www.linkedin.com/in/rafael-teixeira-652618170/', '', '', '2018-01-11'),
(1809, 'Rafael Simões', 'RAFAEL JOSÉ SANTOS SIMÕES', 'rafaeljsimoes@ua.pt', 'B8F34D36-6564-43D2-9AD1-89BDB6CF48B2', '/upload/curriculos/1809.pdf', 'https://www.linkedin.com/in/rafael-simões-60958b173', '', '', '2017-10-23'),
(1812, 'Raul VilasBoas', 'RAUL VILAS BOAS', 'raulvilasboas97@ua.pt', 'EE7550C7-3A2E-4B89-B3AD-300A435ECAE0', '', '', '', '', '2015-09-23'),
(1815, 'Renan Ferreira', 'RENAN ALVES FERREIRA', 'renanaferreira@ua.pt', '31FD00B0-3E42-4FA8-AF2D-2E6695E39EF2', '/upload/curriculos/1815.pdf', '', '', '', '0000-00-00'),
(1818, 'Renato Duarte', 'RENATO VALENTE DUARTE', 'renato.duarte@ua.pt', 'A621A8D7-0AB2-4027-B133-8C0BFBD62D74', '', '', '', '', '2013-09-12'),
(1821, 'Rui Fernandes', 'RUI FILIPE MONTEIRO FERNANDES', 'rfmf@ua.pt', '0BBEFA9E-590B-4B1D-AB57-273BC3E3C1DB', '', '', '', '', '0000-00-00'),
(1824, 'João Peixe Ribeiro', 'JOÃO GONÇALO PEIXE RIBEIRO', 'ribeirojoao@ua.pt', '727C7ECB-12BC-47AD-B743-064D5A48EE87', '', 'https://www.linkedin.com/in/joao-peixe-ribeiro/', '', '', '2013-09-12'),
(1827, 'Ricardo Cruz', 'RICARDO SARAIVA DA CRUZ', 'ricardo.cruz29@ua.pt', '1D65A881-CD4E-4428-BD3C-B7C680CD0B3D', '', '', '', '', '0000-00-00'),
(1830, 'Ricardo Lucas', 'RICARDO JORGE MARTINS LUCAS', 'ricardo.lucas@ua.pt', '3C1E3961-C932-4021-837F-B9C7F83D94DB', '', '', '', '', '2013-09-30'),
(1833, 'Ricardo Mendes', 'RICARDO DANIEL RAMOS MENDES', 'ricardo.mendes@ua.pt', '4A3C5C2A-071A-4F72-979D-C4CC37525C41', '', 'https://www.linkedin.com/in/rdrmendes/', '', '', '2013-10-15'),
(1836, 'Ricardo Querido', 'RICARDO FILIPE MARTINS QUERIDO', 'ricardo.querido98@ua.pt', '7FDB78FD-74FD-4AFF-98DF-8A41DB6EB880', '', '', '', '', '2018-01-11'),
(1839, 'Ricardo Gonçalves', 'RICARDO JORGE ALVES GONÇALVES', 'ricardojagoncalves@ua.pt', 'FE33D7CD-ED95-4517-9793-FCBE77898367', '', '', '', '', '0000-00-00'),
(1842, 'Ricardo Castor', 'RICARDO JOSÉ SIMÕES CASTOR', 'ricardojscastor@ua.pt', 'DDEA1C81-CADF-4385-B61A-3A5A19A20C65', '', '', '', '', '2018-01-11'),
(1845, 'Ana Rita Cerdeira Marques', 'ANA RITA CERDEIRA MARQUES', 'ritacerdeira@ua.pt', '65437B50-258D-4AEC-865D-7CB33EFEFBD8', '', '', '', '', '2017-05-27'),
(1848, 'Rita Jesus', 'RITA ALEXANDRA DA FONSECA JESUS', 'ritajesus@ua.pt', '0906B877-582F-4B35-B382-1077754DF67C', '', 'https://www.linkedin.com/in/ritajesus/', '', '', '2013-09-12'),
(1851, 'Rita Portas', 'RITA FERNANDA REIS COLETA PORTAS', 'ritareisportas@ua.pt', 'F1026687-606F-48CE-B1DA-A39349B85147', '', 'https://www.linkedin.com/in/rita-reis-portas/', '', '', '2013-09-18'),
(1854, 'Rafael Martins', 'RAFAEL JOSÉ DA SILVA MARTINS', 'rjmartins@ua.pt', 'B06A4751-5340-4E6F-868B-6DB91BC7151F', '', 'https://www.linkedin.com/in/rafael-martins-68661985/', '', '', '2013-09-12'),
(1857, 'João Rocha', 'JOÃO MIGUEL ARAÚJO MONTEIRO DA ROCHA', 'rocha.miguel@ua.pt', '27D646B9-A1AD-4CBC-9841-FA1D0A789176', '', '', '', '', '2013-09-24'),
(1860, 'Rui Serrano', 'RUI MIGUEL PARDAL HANEMANN GUIMARAES SERRANO', 'rui.serrano@ua.pt', 'C463CE13-1102-4EF7-9496-E52324C85700', '', '', '', '', '2013-09-12'),
(1863, 'Rui Brito', 'RUI DANIEL REBELO BRITO', 'ruibrito@ua.pt', '64E01601-E756-4FC6-9C2D-623C228F69C8', '', '', '', '', '2013-09-12'),
(1866, 'Rui Coelho', 'RUI MIGUEL OLIVEIRA COELHO', 'ruicoelho@ua.pt', '45F37FEC-D896-4527-8F77-F7C89FDA904D', '/upload/curriculos/1866.pdf', 'https://www.linkedin.com/in/ruimigueloliveiracoelho/', 'https://github.com/user-cube/', '', '2018-01-10'),
(1869, 'Rui Mendes', 'RUI DANIEL ALVES MENDES', 'ruidamendes@ua.pt', 'F2D30783-5E7D-4DFC-A1CB-D93C75B1919A', '', '', '', '', '2013-09-12'),
(1872, 'Rui Lopes', 'RUI EDUARDO DE FIGUEIREDO ARNAY LOPES', 'ruieduardo.fa.lopes@ua.pt', '1F2A48CF-6843-4DFE-B124-5293333418AB', '', '', '', '', '2013-09-24'),
(1875, 'Rui Azevedo', 'RUI MANUEL CASTRO AZEVEDO', 'ruimazevedo@ua.pt', '26D9C32B-70C4-44D7-8535-9D58B16F8BE3', '', 'https://www.linkedin.com/in/ruimcazevedo/', '', '', '2013-09-12'),
(1878, 'Rui Mendes', 'RUI ALEXANDRE DA SILVA MENDES', 'ruimendes@ua.pt', '13C0DB18-A0E7-4530-BA7F-4A654A97C87E', '', '', '', '', '2013-09-12'),
(1881, 'Rui Silva', 'RUI PEDRO SOARES TAVARES DA SILVA', 'ruipsilva@ua.pt', 'D891C72A-0586-4D66-B647-0DD1FEDFFFB3', '', '', '', '', '2013-09-26'),
(1884, 'Rui Sacchetti', 'RUI MAIA BARRETO SACCHETTI', 'ruisacchetti@ua.pt', '10C4FFC1-7A63-4241-B2AF-C690955B8391', '', '', '', '', '2013-09-24'),
(1887, 'Rui Simões', 'RUI FILIPE DE ALMEIDA SIMÕES', 'ruisimoes@ua.pt', '39D636A2-AF1E-40B9-866A-73F0CF5912B9', '', '', '', '', '2013-09-12'),
(1890, 'Samuel Gomes', 'SAMUEL CONCEIÇÃO GOMES', 's.gomes@ua.pt', '823F8F55-E4C2-4A3F-B322-52EDC31B09B7', '', '', '', '', '2013-09-24'),
(1893, 'Joana Silva', 'JOANA CATARINA DOS SANTOS SILVA', 's.joana@ua.pt', 'BD164E15-993F-40AF-A02A-EEB7F0696617', '', 'https://www.linkedin.com/in/joanacssilva/', '', '', '2013-09-12'),
(1896, 'Samuel Campos', 'SAMUEL PIRES CAMPOS', 'samuel.campos@ua.pt', 'CDEDF986-62B0-4856-9DD9-26B9A6A9CDFA', '', '', '', '', '2013-09-30'),
(1899, 'Sanaz Shahbazzadegan', 'SANAZ SHAHBAZ ZADEGAN', 'sanaz.shahbazzadegan@ua.pt', 'CAC6517F-C851-455A-B016-161B47BF472C', '', '', '', '', '2013-09-12'),
(1902, 'Sandra Andrade', 'SANDRA MARISA CARVALHO DE ANDRADE', 'sandraandrade@ua.pt', '6AD97E0C-2252-47CD-B305-3DBC0E0F4049', '', '', '', '', '2018-01-11'),
(1905, 'Sandybel Osório', 'SANDYBEL VEIGA OSÓRIO', 'sandybel@ua.pt', 'B3302A7B-5000-4EC0-ABAD-A08763E1CC1F', '', '', '', '', '2013-11-17'),
(1908, 'Sara Dias', 'SARA RAQUEL DIAS DA RESSURREIÇÃO', 'sara.dias@ua.pt', '4B7E7DE2-6A0A-4F94-A18A-F5517565EB7A', '', '', '', '', '2013-09-12'),
(1911, 'Sara Matos', 'SARA DA SILVA MATOS', 'saramatos@ua.pt', '5ADB4876-E4AD-4BC7-B27C-0D3155C9C5E5', '', '', '', '', '2013-11-14'),
(1914, 'Sergio Gonzalez', 'SÉRGIO ANDRÉ GONZALEZ RIBEIRO', 'sergiogonzalez@ua.pt', '851B6734-DD47-4A0C-A0F9-CE222DDDB1D2', '', '', '', '', '2018-01-11'),
(1917, 'Sérgio Martins', 'SÉRGIO DE OLIVEIRA MARTINS', 'sergiomartins8@ua.pt', '44FC1466-A886-4011-8B89-0BE43A735BEF', '', '', '', '', '2013-09-12'),
(1920, 'Sérgio Cunha', 'SÉRGIO DANIEL MARQUES CUNHA', 'sergiomcunha@ua.pt', 'EE60C20F-B734-4255-BE99-14A6C75A0CFB', '', '', '', '', '2013-09-12'),
(1923, 'Sara Furão', 'SARA DA SILVA FURÃO', 'sfurao@ua.pt', '357C7899-946E-41E4-B3A7-06ADE1A4241A', '', '', '', '', '2013-09-12'),
(1926, 'Susana Gomes', 'SUSANA GONÇALVES GOMES', 'sgg@ua.pt', 'EA4A6E86-1CCB-4CED-BD6A-DA4DC72198AD', '', '', '', '', '0000-00-00'),
(1929, 'Simão Arrais', 'SIMÃO TELES ARRAIS', 'simaoarrais@ua.pt', 'ECD5E1F2-B075-4F5D-8073-3FDB9086256A', '', '', '', '', '2018-01-11'),
(1932, 'Ivanov', 'SAVELIY IVANOV', 'sivanov@ua.pt', '321FDBFF-69BA-4E79-8504-C2A695F0A670', '', '', '', '', '2015-09-23'),
(1935, 'Sofia Marques', 'SOFIA LOPES MARQUES', 'sofia.marques99@ua.pt', '38F90093-1796-4FEC-9C5F-5D2C8EDAAD37', '', '', '', '', '2017-10-23'),
(1938, 'Sofia Moniz', 'ANA SOFIA MEDEIROS DE CASTRO MONIZ FERNANDES', 'sofiamoniz@ua.pt', 'B30018AB-D80C-4A5A-95B2-0E473F9BBD9E', '/upload/curriculos/1938.pdf', 'https://www.linkedin.com/in/sofiamoniz/', '', '', '2017-10-23'),
(1941, 'Sandra Silva', 'SANDRA PATRÍCIA PINTO DA SILVA', 'spps@ua.pt', '158B3BF7-D90D-4B36-8D66-9D11C6EEF843', '', '', '', '', '2013-09-30'),
(1944, 'Stive Oliveira', 'STIVE DUARTE OLIVEIRA', 'stiveoliveira@ua.pt', 'FE604B8D-6C94-494A-AD7A-E575DFEC2B56', '', '', '', '', '2018-10-16'),
(1947, 'Tiago Cardoso', 'TIAGO FILIPE TEODÓSIO CARDOSO', 't.cardoso@ua.pt', '3DE2E157-BBAC-4E8D-8369-E12D96E022FF', '', 'https://www.linkedin.com/in/tkardozo/', '', '', '2015-09-23'),
(1950, 'Tiago Soares', 'TIAGO ALEXANDRE SILVA SOARES', 'tasoares@ua.pt', '5426CA8E-D570-4497-B7E9-41B55E168C27', '', '', '', '', '2013-09-24'),
(1953, 'Tiago Coelho', 'TIAGO DIONÍSIO ANTUNES COELHO', 'tiago.coelho@ua.pt', 'A47D4FEA-E9A1-4FF4-801D-8AFEEA8A4690', '', '', '', '', '2013-09-24'),
(1956, 'Tiago Oliveira', 'TIAGO DA SILVA RIBEIRO VAZ OLIVEIRA', 'tiago.srv.oliveira@ua.pt', '431A0A24-BB36-4DFE-9DB8-4ECCB52387C4', '', '', '', '', '0000-00-00'),
(1959, 'Tiago Alves', 'TIAGO ANDRE SANTOS MARQUES BAPTISTA ALVES', 'tiagoaalves@ua.pt', '5910D0D3-2495-4DFD-A4ED-17F893B26E6D', '', '', '', '', '2014-04-08'),
(1962, 'Tiago Pereira', 'TIAGO ANDRÉ DA SILVA PEREIRA', 'tiagoapereira@ua.pt', '7D820E6D-BE7A-4E3D-8E10-E3A4E5BAAA08', '', '', '', '', '2013-09-12'),
(1965, 'Tiago Mendes', 'TIAGO CARVALHO MENDES', 'tiagocmendes@ua.pt', '6B45E2C1-D3B6-4AB6-A937-B34622B08F50', '/upload/curriculos/1965.pdf', '', '', '', '2017-10-23'),
(1968, 'Tiago Duarte', 'TIAGO FILIPE RODRIGUES DUARTE', 'tiagoduarte21@ua.pt', '5D2DC36B-25F5-44DB-9CE2-AA7AD0044E96', '', '', '', '', '2013-09-12'),
(1971, 'Tiago Martins', 'TIAGO FERREIRA MARTINS', 'tiagofmartins@ua.pt', '3F6ED8F3-1103-451E-973D-AB14200E61E2', '', '', '', '', '2013-09-12'),
(1974, 'Tiago Teixeira', 'TIAGO FILIPE MAIO TEIXEIRA', 'tiagomaioteixeira@ua.pt', 'D91D54B0-1DA6-45B4-9F4F-8DE59BA53486', '', '', '', '', '2013-09-12'),
(1977, 'Tiago Melo', 'TIAGO MANUEL BORGES LEÓN GOMES DE MELO', 'tiagomelo@ua.pt', '80072C01-651A-4DB9-B292-7BF60A53BB0D', '/upload/curriculos/1977.pdf', '', '', '', '2017-10-23'),
(1980, 'Tiago Almeida', 'TIAGO ALEXANDRE MELO ALMEIDA', 'tiagomeloalmeida@ua.pt', '35DAADC5-1442-4F6D-A963-AD5EAED6F860', '', '', '', '', '2014-09-17'),
(1983, 'Tibério Baptista', 'TIBÉRIO FILIPE PACHECO BAPTISTA', 'tiberio.baptista@ua.pt', 'C9A1F0C4-5209-4C9E-8DE5-1349B5DFDE4B', '', '', '', '', '2018-12-17'),
(1986, 'Tiago Brito', 'TIAGO LOPES FERREIRA BRITO', 'tlfbrito@ua.pt', '012FC7FF-2529-4237-9793-778D4F74DF28', '', '', '', '', '2013-09-12'),
(1989, 'Tomás Batista', 'TOMÁS DOS SANTOS BATISTA', 'tomasbatista99@ua.pt', 'B2747FEF-3590-44CC-8803-E6E799BBE938', '', 'https://www.linkedin.com/in/tomas99batista/', '', '', '2017-10-23'),
(1992, 'Tomás Rocha', 'TOMÁS DOS SANTOS CARVALHO ROCHA', 'tomascarvalho@ua.pt', 'B676DB10-A19E-4230-8A15-2C865FC45E0A', '', '', '', '', '2013-09-12'),
(1995, 'Tomás Costa', 'TOMÁS OLIVEIRA DA COSTA', 'tomascosta@ua.pt', 'E9310711-3AF9-448D-AE8A-F338BE750D83', '/upload/curriculos/1995.pdf', 'https://www.linkedin.com/in/tomascostax/', '', '', '2017-10-23'),
(1998, 'Tomás Lopes', 'TOMÁS HENRIQUE NOGUEIRA LOPES', 'tomaslopes@ua.pt', 'FD4A5960-AD7F-4503-B19F-72E1DCAF266E', '', '', '', '', '0000-00-00'),
(2001, 'Tomé Marques', 'TOMÉ DOS SANTOS MARQUES', 'tomemarques@ua.pt', '4787029A-1332-4118-A976-D7CA977C5CC7', '', '', '', '', '2014-04-02'),
(2004, 'Vasco Marieiro', 'Vasco Marieiro', 'vasco.marieiro@ua.pt', '', '', '', '', '', '2019-04-30'),
(2007, 'Vasco Ramos', 'VASCO ANTÓNIO LOPES RAMOS', 'vascoalramos@ua.pt', 'C2EFB820-1F50-4ABB-B0E6-BBE6A42C1E72', '/upload/curriculos/2007.pdf', '', '', '', '2017-10-23'),
(2010, 'Vinicius Ribeiro', 'VINÍCIUS BENITE RIBEIRO', 'viniciusribeiro@ua.pt', '1A3E50D1-E54F-49F3-92BA-40D6F81EBBEC', '', '', '', '', '0000-00-00'),
(2013, 'Vitor Fajardo', 'VÍTOR MANUEL OLIVEIRA FAJARDO', 'vitorfajardo@ua.pt', '9FBF6844-2384-4EC9-B4EC-7BF1D465ED25', '', '', '', '', '2018-01-11'),
(2016, 'Wei Ye', 'WEI YE', 'weiye@ua.pt', 'C3D585A1-2B0F-441A-AE06-4CCC0F744AA4', '', '', '', '', '0000-00-00'),
(2019, 'Yanick Alfredo', 'YANICK HAYES MONDLANE ALFREDO', 'yanick.alfredo@ua.pt', '49ABA8A5-BD5F-491F-9F7C-A800009348BA', '', '', '', '', '2018-12-17'),
(2020, 'Afonso Botô', 'AFONSO MIGUEL SANTOS BÔTO', 'afonso.boto@ua.pt', '', '', '', '', '', '0000-00-00'),
(2021, 'Alexandre Serras', 'ALEXANDRE MAIA SERRAS', 'alexandreserras@ua.pt', '', '', '', '', '', '2019-09-13'),
(2022, 'Alexandre Pinto', 'ALEXANDRE PEREIRA PINTO', 'alexandrepp07@ua.pt', '', '', '', '', '', '2019-09-13'),
(2023, 'André Gomes', 'ANDRÉ LOURENÇO GOMES', 'alg@ua.pt', '', '', '', '', '', '2019-09-13'),
(2024, 'André Freixo', 'ANDRÉ SEQUEIRA FREIXO', 'andrefreixo18@ua.pt', '', '', '', '', '', '2019-09-13'),
(2025, 'Andreia Portela', 'ANDREIA DE SÁ PORTELA', 'andreia.portela@ua.pt', '', '', '', '', '', '2019-09-13'),
(2026, 'Artur Romão', 'ARTUR CORREIA ROMÃO', 'artur.romao@ua.pt', '', '', '', '', '', '2019-09-13'),
(2027, 'Bernardo Leandro', 'BERNARDO ALVES LEANDRO', 'bernardoleandro1@ua.pt', '', '', '', '', '', '2019-09-13'),
(2028, 'Camila Fonseca', 'CAMILA FRANCO DE SÁ FONSECA', 'cffonseca@ua.pt', '', '', '', '', '', '2019-09-13'),
(2029, 'Catarina Oliveira', 'CATARINA CRUZ OLIVEIRA', 'catarinaoliveira@ua.pt', '', '', '', '', '', '2019-09-13'),
(2030, 'Daniel Figueiredo', 'DANIEL ANTÓNIO FERREIRA FIGUEIREDO', 'dani.figa@ua.pt', '', '', '', '', '', '2019-09-13'),
(2031, 'Daniel Francisco', 'DANIEL JOÃO FRANCISCO', 'daniel.francisco@ua.pt', '', '', '', '', '', '2019-09-13'),
(2032, 'Daniela Dias', 'DANIELA FILIPA PINTO DIAS', 'ddias@ua.pt', '', '', '', '', '', '2019-09-13'),
(2033, 'Diana Siso', 'DIANA ELISABETE SISO OLIVEIRA', 'diana.siso@ua.pt', '', '', '', '', '', '2019-09-13'),
(2034, 'Dinis Lei', 'DINIS DOS SANTOS LEI', 'dinislei@ua.pt', '', '', '', '', '', '2019-09-13'),
(2035, 'Diogo Monteiro', 'DIOGO MARCELO OLIVEIRA MONTEIRO', 'diogo.mo.monteiro@ua.pt', '', '', '', '', '', '2019-09-13'),
(2036, 'Diogo Silva', 'DIOGO MIGUEL FERREIRA SILVA', 'diogomfsilva98@ua.pt', '', '', '', '', '', '2019-09-13'),
(2037, 'Diogo Cruz', 'DIOGO PEREIRA HENRIQUES CRUZ', 'diogophc@ua.pt', '', '', '', '', '', '2019-09-13'),
(2038, 'Eduardo Fernandes', 'EDUARDO ROCHA FERNANDES', 'eduardofernandes@ua.pt', '', '', '', '', '', '2019-09-13'),
(2039, 'Eva Bartolomeu', 'EVA POMPOSO BARTOLOMEU', 'evabartolomeu@ua.pt', '', '', '', '', '', '2019-09-13'),
(2040, 'Fábio Martins', 'FÁBIO ALEXANDRE RAMOS MARTINS', 'fabio.m@ua.pt', '', '', '', '', '', '2019-09-13'),
(2041, 'Filipe Gonçalves', 'FILIPE ANDRÉ SEABRA GONÇALVES', 'fasd@ua.pt', '', '', '', '', '', '2019-09-13'),
(2042, 'Gonçalo Machado', 'GONÇALO FERNANDES MACHADO', 'goncalofmachado@ua.pt', '', '', '', '', '', '2019-09-13'),
(2043, 'Gonçalo Silva', 'GONÇALO LEAL SILVA', 'goncalolealsilva@ua.pt', '', '', '', '', '', '2019-09-13'),
(2044, 'Henrique Sousa', 'HENRIQUE CARVALHO SOUSA', 'hsousa@ua.pt', '', '', '', '', '', '2019-09-13'),
(2045, 'Hugo Gonçalves', 'HUGO MIGUEL TEIXEIRA GONÇALVES', 'hugogoncalves13@ua.pt', '', '', '', '', '', '2019-09-13'),
(2046, 'Isabel Rosário', 'ISABEL ALEXANDRA JORDÃO ROSÁRIO', 'isabel.rosario@ua.pt', '', '', '', '', '', '2019-09-13'),
(2047, 'João Reis', 'JOÃO ANTÓNIO ASSIS REIS', 'joaoreis16@ua.pt', '', '', '', '', '', '2019-09-13'),
(2048, 'João Bernardo', 'JOÃO BERNARDO TAVARES FARIAS', 'joaobernardo0@ua.pt', '', '', '', '', '', '2019-09-13'),
(2049, 'João Borges', 'JOÃO PEDRO SARAIVA BORGES', 'borgesjps@ua.pt', '', '', '', '', '', '2019-09-13'),
(2050, 'José Trigo', 'JOSÉ PEDRO MARTA TRIGO', 'josetrigo@ua.pt', '', '', '', '', '', '2019-09-13'),
(2051, 'Mariana Sousa', 'MARIANA CABRAL DA SILVA SILVEIRA ROSA', 'marianarosa@ua.pt', '', '', '', '', '', '2019-09-13'),
(2052, 'Marta Fradique', 'MARTA SOFIA AZEVEDO FRADIQUE', 'martafradique@ua.pt', '', '', '', '', '', '2019-09-13'),
(2053, 'Martinho Tavares', 'MARTINHO MARTINS BASTOS TAVARES', 'martinho.tavares@ua.pt', '', '', '', '', '', '2019-09-13'),
(2054, 'Miguel Beirão', 'MIGUEL BEIRÃO E BRANQUINHO OLIVEIRA MONTEIRO', 'mbeiraob@ua.pt', '', '', '', '', '', '2019-09-13'),
(2055, 'Miguel Ferreira', 'MIGUEL ROCHA FERREIRA', 'miguel.r.ferreira@ua.pt', '', '', '', '', '', '2019-09-13'),
(2056, 'Nuno Souza', 'NUNO PINTO SOUZA', 'nunosouza10@ua.pt', '', '', '', '', '', '2019-09-13'),
(2057, 'Patrícia Dias', 'PATRÍCIA MATIAS DIAS', 'pmd8@ua.pt', '', '', '', '', '', '2019-09-13'),
(2058, 'Paulo Pereira', 'PAULO GUILHERME SOARES PEREIRA', 'paulogspereira@ua.pt', '', '', '', '', '', '2019-09-13'),
(2059, 'Pedro Sobral', 'PEDRO ALEXANDRE COELHO SOBRAL', 'sobral@ua.pt', '', '', '', '', '', '2019-09-13'),
(2060, 'Pedro Alexandre', 'PEDRO ALEXANDRE CORREIA DE FIGUEIREDO', 'palexandre@ua.pt', '', '', '', '', '', '2019-09-13'),
(2061, 'Pedro Lopes', 'PEDRO DANIEL FONTES LOPES', 'pdfl@ua.pt', '', '', '', '', '', '2019-09-13'),
(2062, 'Pedro Duarte', 'PEDRO DANIEL LOPES DUARTE', 'pedro.dld@ua.pt', '', '', '', '', '', '2019-09-13'),
(2063, 'Pedro Monteiro', 'PEDRO MIGUEL AFONSO DE PINA MONTEIRO', 'pmapm@ua.pt', '', '', '', '', '', '2019-09-13'),
(2064, 'Pedro Simão', 'PEDRO SIMÃO MINISTRO JORGE', 'pedro.simao10@ua.pt', '', '', '', '', '', '2019-09-13'),
(2065, 'Raquel Ferreira', 'RAQUEL DA SILVA FERREIRA', 'raquelsf@ua.pt', '', '', '', '', '', '2019-09-13'),
(2066, 'Renato Dias', 'RENATO ALEXANDRE LOURENÇO DIAS', 'renatoaldias12@ua.pt', '', '', 'https://www.linkedin.com/in/renato-a-l-dias-2919a3195/', '', '', '2019-09-13'),
(2067, 'Ricardo Ferreira', 'RICARDO DE ANDRADE SERRANO FERREIRA', 'ricardoserranoferreira@ua.pt', '', '', '', '', '', '2019-09-13'),
(2068, 'Ricardo Rodriguez', 'RICARDO MANUEL BATISTA RODRIGUEZ', 'ricardorodriguez@ua.pt', '', '', '', '', '', '2019-09-13'),
(2069, 'Rodrigo Lima', 'RODRIGO FRANÇA LIMA', 'rodrigoflima@ua.pt', '', '', '', '', '', '2019-09-13'),
(2070, 'Tiago Brandão Costa', 'TIAGO MANUEL CALISTO BRANDÃO COSTA', 'bran.costa@ua.pt', '', '', '', '', '', '2019-09-13'),
(2071, 'Tiago Matos', 'TIAGO MIGUEL RUIVO DE MATOS', 'tiagomrm@ua.pt', '', '', '', '', '', '2019-09-13'),
(2072, 'Tomé Carvalho', 'TOMÉ LOPES CARVALHO', 'tomecarvalho@ua.pt', '', '', '', '', '', '2019-09-13'),
(2073, 'Vasco Regal', 'VASCO JORGE REGAL SOUSA', 'vascoregal24@ua.pt', '', '', '', '', '', '2019-09-13'),
(2074, 'Vicente Costa', 'VICENTE SAMUEL GONÇALVES COSTA', 'vicente.costa@ua.pt', '', '', '', '', '', '2019-09-13'),
(2075, 'Vitor Dias', 'VITOR FRANCISCO RIBEIRO DIAS', 'vfrd00@ua.pt', '', '', 'https://www.linkedin.com/in/v%C3%ADtor-dias-7b566920a', '', '', '2019-09-13'),
(2077, 'Ivan Garcia', 'Ivan Manso', 'ivanmansogarcia@ua.pt', ' ', '', '', '', 'DEFAULT', '2019-09-26'),
(2080, 'Brais Perez', 'Brais Gonzalez Peres', 'brais@ua.pt', '', '', '', '', 'DEFAULT', '2019-09-26'),
(2086, 'Guilherme Alegre', 'Guilherme Alegre', 'guilhermealegre@ua.pt', '', '', '', '', 'DEFAULT', '2019-10-09'),
(2092, 'Pedro Rodrigues', 'Pedro Miguel Tavares Rodrigues', 'ped.rodr@ua.pt', '', '', '', '', 'DEFAULT', '2019-10-13'),
(2098, 'Luís Martins', 'Luís Martins', 'luisccmartins88@ua.pt', ' ', '', '', '', 'DEFAULT', '2019-10-23'),
(2104, 'Afonso Campos', 'Afonso Campos', 'afonso.campos@ua.pt', ' ', '', '', '', 'DEFAULT', '2019-10-25'),
(2106, 'Sophie Pousinho', 'Sophie Pousinho', 'sophiepousinho@ua.pt', '', '', '', '', 'DEFAULT', '2019-11-05'),
(2109, 'Filipe Gonçalves', 'Filipe Gonçalves', 'filipeg@ua.pt', '', '', '', '', 'DEFAULT', '2019-11-05'),
(2112, 'Dani Figueiredo', 'Dani Figueiredo', 'dani.fig@ua.pt', '', '', '', '', 'DEFAULT', '2019-11-05'),
(2118, 'Airton Moreira', 'Airton Moreira', 'agm@ua.pt', '', '', '', '', 'DEFAULT', '2019-11-06'),
(2121, 'Hugo Silva', 'HUGO TAVARES SILVA', 'hugot.silva@ua.pt', '', '', '', '', '', '2019-10-01'),
(2122, 'Yanis Faquir', 'Yanis Marina Faquir', 'yanismarinafaquir@ua.pt', '', '', '', '', 'DEFAULT', '2020-03-10'),
(2123, 'Rita Ferrolho', '', 'ritaferrolho@ua.pt', '', '', '', '', 'DEFAULT', '2020-04-21'),
(2124, 'Pedro Figueiredo', 'Pedro Figueiredo', 'palexandre09@ua.pt', ' ', ' ', 'https://www.linkedin.com/in/pedro-figueiredo-9983181ba/', ' ', 'DEFAULT', '2021-03-09'),
(2125, 'Artur Correia', 'Artur Correia', 'non@ua.pt', ' ', ' ', '', ' ', 'DEFAULT', '2021-03-09'),
(2126, 'André Benquerença', 'André Benquerença', 'non@ua.pt', ' ', ' ', '', ' ', 'DEFAULT', '2021-03-09'),
(2127, 'Daniel Carvalho', 'Daniel Carvalho', 'dl.carvalho@ua.pt', ' ', '', 'http://www.linkedin.com/in/daniel-carvalho-a89b1b176', ' ', 'DEFAULT', '2021-03-09'),
(2128, 'Rafael Gonçalves', 'Rafael Gonçalves', 'non@ua.pt', ' ', ' ', '', ' ', 'DEFAULT', '2021-03-09'),
(2129, 'Inês Ferreira', 'Inês Queirós Ferreira', 'non@ua.pt', ' ', ' ', '', ' ', 'DEFAULT', '2021-03-09'),
(2130, 'Rodrigo Oliveira', 'Rodrigo Oliveira', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2131, 'Miguel Fonseca', 'Miguel Fonseca', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2132, 'Catarina Costa', 'Catarina Costa', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2133, 'Leonardo Almeida', 'Leonardo Almeida', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2134, 'Lucius Filho', 'Lucius Vinicius Rocha Machado Filho', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2135, 'Yanis Faquir', 'Yanis Marina Faquir', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2136, 'Daniel Ferreira', 'Daniel Martins Ferreira,', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2137, 'Filipe Silva', 'Filipe Silva', '', '', '', '', '', 'DEFAULT', '2021-06-11'),
(2138, 'Alexandre Santos', 'Alexandre Santos', '', '', '', '', '', 'DEFAULT', '2021-06-11');

-- --------------------------------------------------------

--
-- Table structure for table `videos`
--

CREATE TABLE `videos` (
  `id` int(11) NOT NULL,
  `tag` int(11) DEFAULT NULL,
  `ytId` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  `playlist` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `videos`
--

INSERT INTO `videos` (`id`, `tag`, `ytId`, `title`, `subtitle`, `image`, `created`, `playlist`) VALUES
(1, 1, 'PL0-X-dbGZUABPg-FWm3tT7rCVh6SESK2d', 'FP', 'Fundamentos de Programação', '/videos/FP_2020.jpg', '2020-12-09 00:00:00', 1),
(2, 1, 'PL0-X-dbGZUAA8rQm4klslEksHCrb3EIDG', 'IAC', 'Introdução à Arquitetura de Computadores', '/videos/IAC_2020.jpg', '2020-06-10 00:00:00', 1),
(3, 1, 'PL0-X-dbGZUABp2uATg_-lqfT4FTFlyNir', 'ITW', 'Introdução às Tecnologias Web', '/videos/ITW_2020.jpg', '2020-12-17 00:00:00', 1),
(4, 1, 'PL0-X-dbGZUACS3EkepgT7DOf287MiTzp0', 'POO', 'Programação Orientada a Objetos', '/videos/POO_2020.jpg', '2020-11-16 00:00:00', 1),
(5, 5, 'ips-tkEr_pM', 'Discord Bot', 'Workshop', '/videos/discord.jpg', '2021-07-14 00:00:00', 0),
(6, 6, '3hjRgoIItYk', 'Anchorage', 'Palestra', '/videos/anchorage.jpg', '2021-04-01 00:00:00', 0),
(7, 5, 'GmNvZC6iv1Y', 'Git', 'Workshop', '/videos/git.jpg', '2020-04-28 00:00:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `videos_tags`
--

CREATE TABLE `videos_tags` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `color` varchar(18) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `videos_tags`
--

INSERT INTO `videos_tags` (`id`, `name`, `color`) VALUES
(1, '1A', 'rgb(1, 202, 228)'),
(2, '2A', 'rgb(1, 171, 192)'),
(3, '3A', 'rgb(1, 135, 152)'),
(4, 'MEI', 'rgb(1, 90, 101)'),
(5, 'Workshops', 'rgb(11, 66, 21)'),
(6, 'Palestras', 'rgb(20, 122, 38)');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `classificacao_tacaua`
--
ALTER TABLE `classificacao_tacaua`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idModalidade` (`idModalidade`),
  ADD KEY `idEquipa` (`idEquipa`);

--
-- Indexes for table `companies`
--
ALTER TABLE `companies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `equipas_tacaua`
--
ALTER TABLE `equipas_tacaua`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `estatistica`
--
ALTER TABLE `estatistica`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `estatistica_comp`
--
ALTER TABLE `estatistica_comp`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faina`
--
ALTER TABLE `faina`
  ADD PRIMARY KEY (`mandato`);

--
-- Indexes for table `faina_memb`
--
ALTER TABLE `faina_memb`
  ADD PRIMARY KEY (`id`),
  ADD KEY `mandato_k` (`ano`);

--
-- Indexes for table `faina_member`
--
ALTER TABLE `faina_member`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member` (`member`),
  ADD KEY `year` (`year`),
  ADD KEY `role` (`role`);

--
-- Indexes for table `faina_roles`
--
ALTER TABLE `faina_roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `GenTokens`
--
ALTER TABLE `GenTokens`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `GenTokensComp`
--
ALTER TABLE `GenTokensComp`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `history`
--
ALTER TABLE `history`
  ADD PRIMARY KEY (`moment`);

--
-- Indexes for table `jogos_tacaua`
--
ALTER TABLE `jogos_tacaua`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Links`
--
ALTER TABLE `Links`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `merchandisings`
--
ALTER TABLE `merchandisings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `modalidades_tacaua`
--
ALTER TABLE `modalidades_tacaua`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `NEI_Disciplina`
--
ALTER TABLE `NEI_Disciplina`
  ADD PRIMARY KEY (`paco_code`);

--
-- Indexes for table `NEI_Disciplina_Apontamentos`
--
ALTER TABLE `NEI_Disciplina_Apontamentos`
  ADD PRIMARY KEY (`disciplina`,`link_ficheiro`);

--
-- Indexes for table `NEI_Merch`
--
ALTER TABLE `NEI_Merch`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`),
  ADD KEY `publish_by` (`publish_by`),
  ADD KEY `changed_by` (`changed_by`);

--
-- Indexes for table `notes`
--
ALTER TABLE `notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subject` (`subject`),
  ADD KEY `author` (`author`),
  ADD KEY `schoolYear` (`schoolYear`),
  ADD KEY `teacher` (`teacher`),
  ADD KEY `type` (`type`);

--
-- Indexes for table `notes_schoolyear`
--
ALTER TABLE `notes_schoolyear`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notes_subjects`
--
ALTER TABLE `notes_subjects`
  ADD PRIMARY KEY (`paco_code`);

--
-- Indexes for table `notes_teachers`
--
ALTER TABLE `notes_teachers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `notes_thanks`
--
ALTER TABLE `notes_thanks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `author` (`author`);

--
-- Indexes for table `notes_types`
--
ALTER TABLE `notes_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `partners`
--
ALTER TABLE `partners`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `RecoverToken`
--
ALTER TABLE `RecoverToken`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `redirects`
--
ALTER TABLE `redirects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `alias_unique` (`alias`);

--
-- Indexes for table `rgm`
--
ALTER TABLE `rgm`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `seniors`
--
ALTER TABLE `seniors`
  ADD PRIMARY KEY (`year`,`course`);

--
-- Indexes for table `seniors_students`
--
ALTER TABLE `seniors_students`
  ADD PRIMARY KEY (`year`,`course`,`userId`),
  ADD KEY `userId` (`userId`);

--
-- Indexes for table `tacaua_classification`
--
ALTER TABLE `tacaua_classification`
  ADD PRIMARY KEY (`team`,`modality`),
  ADD KEY `modality` (`modality`);

--
-- Indexes for table `tacaua_games`
--
ALTER TABLE `tacaua_games`
  ADD PRIMARY KEY (`id`),
  ADD KEY `team1` (`team1`),
  ADD KEY `team2` (`team2`);

--
-- Indexes for table `tacaua_modalities`
--
ALTER TABLE `tacaua_modalities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tacaua_teams`
--
ALTER TABLE `tacaua_teams`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `team`
--
ALTER TABLE `team`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `team_colaborators`
--
ALTER TABLE `team_colaborators`
  ADD KEY `colaborator` (`colaborator`);

--
-- Indexes for table `team_roles`
--
ALTER TABLE `team_roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `videos`
--
ALTER TABLE `videos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tag` (`tag`);

--
-- Indexes for table `videos_tags`
--
ALTER TABLE `videos_tags`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `classificacao_tacaua`
--
ALTER TABLE `classificacao_tacaua`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `companies`
--
ALTER TABLE `companies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `equipas_tacaua`
--
ALTER TABLE `equipas_tacaua`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `estatistica_comp`
--
ALTER TABLE `estatistica_comp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faina`
--
ALTER TABLE `faina`
  MODIFY `mandato` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2021;

--
-- AUTO_INCREMENT for table `faina_memb`
--
ALTER TABLE `faina_memb`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=248;

--
-- AUTO_INCREMENT for table `faina_member`
--
ALTER TABLE `faina_member`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=293;

--
-- AUTO_INCREMENT for table `faina_roles`
--
ALTER TABLE `faina_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `GenTokens`
--
ALTER TABLE `GenTokens`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9130;

--
-- AUTO_INCREMENT for table `GenTokensComp`
--
ALTER TABLE `GenTokensComp`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=470;

--
-- AUTO_INCREMENT for table `jogos_tacaua`
--
ALTER TABLE `jogos_tacaua`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Links`
--
ALTER TABLE `Links`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `merchandisings`
--
ALTER TABLE `merchandisings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `modalidades_tacaua`
--
ALTER TABLE `modalidades_tacaua`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `NEI_Merch`
--
ALTER TABLE `NEI_Merch`
  MODIFY `id` int(200) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `news`
--
ALTER TABLE `news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT for table `notes`
--
ALTER TABLE `notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=386;

--
-- AUTO_INCREMENT for table `notes_schoolyear`
--
ALTER TABLE `notes_schoolyear`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `notes_teachers`
--
ALTER TABLE `notes_teachers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `notes_thanks`
--
ALTER TABLE `notes_thanks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `notes_types`
--
ALTER TABLE `notes_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `partners`
--
ALTER TABLE `partners`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `RecoverToken`
--
ALTER TABLE `RecoverToken`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `redirects`
--
ALTER TABLE `redirects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `rgm`
--
ALTER TABLE `rgm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=157;

--
-- AUTO_INCREMENT for table `tacaua_games`
--
ALTER TABLE `tacaua_games`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tacaua_modalities`
--
ALTER TABLE `tacaua_modalities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tacaua_teams`
--
ALTER TABLE `tacaua_teams`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `team`
--
ALTER TABLE `team`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=340;

--
-- AUTO_INCREMENT for table `team_roles`
--
ALTER TABLE `team_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2139;

--
-- AUTO_INCREMENT for table `videos`
--
ALTER TABLE `videos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `videos_tags`
--
ALTER TABLE `videos_tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `classificacao_tacaua`
--
ALTER TABLE `classificacao_tacaua`
  ADD CONSTRAINT `classificacao_tacaua_ibfk_1` FOREIGN KEY (`idModalidade`) REFERENCES `modalidades_tacaua` (`id`),
  ADD CONSTRAINT `classificacao_tacaua_ibfk_2` FOREIGN KEY (`idEquipa`) REFERENCES `equipas_tacaua` (`id`);

--
-- Constraints for table `estatistica`
--
ALTER TABLE `estatistica`
  ADD CONSTRAINT `acesso` FOREIGN KEY (`id`) REFERENCES `users` (`id`);

--
-- Constraints for table `faina_memb`
--
ALTER TABLE `faina_memb`
  ADD CONSTRAINT `mandato_k` FOREIGN KEY (`ano`) REFERENCES `faina` (`mandato`);

--
-- Constraints for table `faina_member`
--
ALTER TABLE `faina_member`
  ADD CONSTRAINT `faina_member_ibfk_1` FOREIGN KEY (`member`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `faina_member_ibfk_2` FOREIGN KEY (`year`) REFERENCES `faina` (`mandato`),
  ADD CONSTRAINT `faina_member_ibfk_3` FOREIGN KEY (`role`) REFERENCES `faina_roles` (`id`);

--
-- Constraints for table `NEI_Disciplina_Apontamentos`
--
ALTER TABLE `NEI_Disciplina_Apontamentos`
  ADD CONSTRAINT `Disciplina_Apontamentos_FK` FOREIGN KEY (`disciplina`) REFERENCES `NEI_Disciplina` (`paco_code`);

--
-- Constraints for table `news`
--
ALTER TABLE `news`
  ADD CONSTRAINT `news_ibfk_2` FOREIGN KEY (`publish_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `news_ibfk_3` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `notes`
--
ALTER TABLE `notes`
  ADD CONSTRAINT `notes_ibfk_1` FOREIGN KEY (`subject`) REFERENCES `notes_subjects` (`paco_code`),
  ADD CONSTRAINT `notes_ibfk_2` FOREIGN KEY (`author`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `notes_ibfk_3` FOREIGN KEY (`schoolYear`) REFERENCES `notes_schoolyear` (`id`),
  ADD CONSTRAINT `notes_ibfk_4` FOREIGN KEY (`teacher`) REFERENCES `notes_teachers` (`id`),
  ADD CONSTRAINT `notes_ibfk_5` FOREIGN KEY (`type`) REFERENCES `notes_types` (`id`);

--
-- Constraints for table `notes_thanks`
--
ALTER TABLE `notes_thanks`
  ADD CONSTRAINT `notes_thanks_ibfk_1` FOREIGN KEY (`author`) REFERENCES `users` (`id`);

--
-- Constraints for table `seniors_students`
--
ALTER TABLE `seniors_students`
  ADD CONSTRAINT `seniors_students_ibfk_1` FOREIGN KEY (`year`,`course`) REFERENCES `seniors` (`year`, `course`),
  ADD CONSTRAINT `seniors_students_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`id`);

--
-- Constraints for table `tacaua_classification`
--
ALTER TABLE `tacaua_classification`
  ADD CONSTRAINT `tacaua_classification_ibfk_1` FOREIGN KEY (`team`) REFERENCES `tacaua_teams` (`id`),
  ADD CONSTRAINT `tacaua_classification_ibfk_2` FOREIGN KEY (`modality`) REFERENCES `tacaua_modalities` (`id`);

--
-- Constraints for table `tacaua_games`
--
ALTER TABLE `tacaua_games`
  ADD CONSTRAINT `tacaua_games_ibfk_1` FOREIGN KEY (`team1`) REFERENCES `tacaua_teams` (`id`),
  ADD CONSTRAINT `tacaua_games_ibfk_2` FOREIGN KEY (`team2`) REFERENCES `tacaua_teams` (`id`);

--
-- Constraints for table `team`
--
ALTER TABLE `team`
  ADD CONSTRAINT `team_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `team_colaborators`
--
ALTER TABLE `team_colaborators`
  ADD CONSTRAINT `team_colaborators_ibfk_1` FOREIGN KEY (`colaborator`) REFERENCES `users` (`id`);

--
-- Constraints for table `videos`
--
ALTER TABLE `videos`
  ADD CONSTRAINT `videos_ibfk_1` FOREIGN KEY (`tag`) REFERENCES `videos_tags` (`id`);

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`aauav-nei-dbo`@`%` EVENT `CleanTokens` ON SCHEDULE EVERY 1 DAY STARTS '2019-10-03 02:36:00' ENDS '2020-10-03 00:00:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE COMMENT 'Delete tokens' DO DELETE FROM `aauav-nei`.GenTokens$$

CREATE DEFINER=`aauav-nei-dbo`@`%` EVENT `IncrementToken` ON SCHEDULE EVERY 1 DAY STARTS '2019-10-03 02:30:01' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE COMMENT 'Auto_Increment to 1' DO ALTER TABLE GenTokens AUTO_INCREMENT =1$$

CREATE DEFINER=`aauav-nei-dbo`@`%` EVENT `Acessos` ON SCHEDULE EVERY 1 DAY STARTS '2019-10-08 01:59:55' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE COMMENT 'New status' DO INSERT INTO estatistica SELECT userid, COUNT(*) FROM GenTokens GROUP BY id ON DUPLICATE KEY UPDATE acessos = VALUES(acessos) + acessos$$

CREATE DEFINER=`aauav-nei-dbo`@`%` EVENT `Empresas` ON SCHEDULE EVERY 1 DAY STARTS '2019-10-08 02:05:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE COMMENT 'Estatística empresas' DO INSERT INTO estatistica_comp SELECT compid, COUNT(*) FROM GenTokensComp GROUP BY id ON DUPLICATE KEY UPDATE acessos = VALUES(acessos) + acessos$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
