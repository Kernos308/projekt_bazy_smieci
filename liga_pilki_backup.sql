-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 17 Sty 2024, 10:04
-- Wersja serwera: 10.4.21-MariaDB
-- Wersja PHP: 8.0.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `liga_pilki`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AktualizujMecz` (IN `id` INT(11), IN `nowaData` DATE, IN `nowyGospodarz` INT(11), IN `nowyGosc` INT(11), IN `nowyGospWynik` INT(11), IN `nowyGoscWynik` INT(11))  BEGIN
    UPDATE mecz
    SET 
        data_meczu = IF(nowaData  IS NOT NULL, nowaData, data_meczu),
        druzyna_gospodarz_id = IF(nowyGospodarz  IS NOT NULL, nowyGospodarz, druzyna_gospodarz_id),
        druzyna_gosc_id = IF(nowyGosc IS NOT NULL, nowyGosc, druzyna_gosc_id),
        wynik_gospodarza = IF(nowyGospWynik IS NOT NULL, nowyGospWynik, wynik_gospodarza),
        wynik_goscia = IF(nowyGoscWynik IS NOT NULL, nowyGoscWynik, wynik_goscia)
    WHERE
        mecz_id = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AktualizujStatystyki` (IN `id` INT(11), IN `nowyMecz` INT(11), IN `nowaDruzyna` INT(11), IN `nowePosiadanie` INT(11), IN `nowePodania` INT(11), IN `noweCelne` INT(11), IN `noweNiecelne` INT(11), IN `noweRozne` INT(11), IN `noweKarne` INT(11), IN `noweFaule` INT(11), IN `noweSpalone` INT(11))  BEGIN
    UPDATE statystyki
    SET 
        mecz_id = IF(nowyMecz  IS NOT NULL, nowyMecz, mecz_id), 
        druzyna_id = IF(nowaDruzyna  IS NOT NULL, nowaDruzyna, druzyna_id), 
        posiadanie_pilki = IF(nowePosiadanie  IS NOT NULL, nowePosiadanie, posiadanie_pilki), 
        podania = IF(nowePodania  IS NOT NULL, nowePodania, podania), 
        strzaly_celne = IF(noweCelne  IS NOT NULL, noweCelne, strzaly_celne), 
        strzaly_niecelne = IF(noweNiecelne  IS NOT NULL, noweNiecelne, strzaly_niecelne), 
        rzuty_rozne = IF(noweRozne  IS NOT NULL, noweRozne, rzuty_rozne), 
        rzuty_karne = IF(noweKarne  IS NOT NULL, noweKarne, rzuty_karne), 
        faule = IF(noweFaule  IS NOT NULL, noweFaule, faule), 
        spalone = IF(noweSpalone  IS NOT NULL, noweSpalone, spalone)
    WHERE
        statystyki_id = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AktualizujZawodnika` (IN `id` INT(11), IN `nowaNazwa` VARCHAR(50), IN `nowaDataUrodzenia` DATE, IN `nowaReprezentacja` VARCHAR(50), IN `nowaPozycja` VARCHAR(5), IN `nowaDruzyna` INT(11))  BEGIN
    DECLARE Err_too_long_code CONDITION FOR SQLSTATE '45000';

    UPDATE zawodnik
    SET 
        imie_nazwisko = IF(nowaNazwa IS NOT NULL, nowaNazwa, imie_nazwisko),
        data_urodzenia = IF(nowaDataUrodzenia IS NOT NULL, nowaDataUrodzenia, data_urodzenia),
        reprezentacja = IF(nowaReprezentacja IS NOT NULL, nowaReprezentacja, reprezentacja),
        pozycja = IF(nowaPozycja IS NOT NULL, nowaPozycja, pozycja),
        druzyna_id = IF(nowaDruzyna IS NOT NULL, nowaDruzyna, druzyna_id)
    WHERE
        zawodnik_id = id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Błąd: Brak rekordu do zaktualizowania dla podanego ID.';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AktualizujZawodnika2` (IN `id` INT(11), IN `nowaNazwa` VARCHAR(100), IN `nowaDataUrodzenia` DATE, IN `nowaReprezentacja` VARCHAR(50), IN `nowaPozycja` VARCHAR(5), IN `nowaDruzyna` INT(11))  BEGIN
    UPDATE zawodnik
    SET 
        imie_nazwisko = IF(nowaNazwa  IS NOT NULL, nowaNazwa, imie_nazwisko),
        data_urodzenia = IF(nowaDataUrodzenia  IS NOT NULL, nowaDataUrodzenia, data_urodzenia),
        reprezentacja = IF(nowaReprezentacja IS NOT NULL, nowaReprezentacja, reprezentacja),
        pozycja = IF(nowaPozycja IS NOT NULL, nowaPozycja, pozycja),
        druzyna_id = IF(nowaDruzyna IS NOT NULL, nowaDruzyna, druzyna_id)
    WHERE
        zawodnik_id = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AktuzalizujDruzyne` (IN `id` INT(11), IN `nowaNazwa` VARCHAR(100), IN `nowyTrener` VARCHAR(50), IN `nowyRokZalozenia` DATE, IN `nowyStadion` VARCHAR(100))  BEGIN
    UPDATE druzyna
    SET 
        nazwa_druzyny = IF(nowaNazwa  IS NOT NULL, nowaNazwa, nazwa_druzyny),
        rok_zalozenia = IF(nowyRokZalozenia  IS NOT NULL, nowyRokZalozenia, rok_zalozenia),
        trener = IF(nowyTrener IS NOT NULL, nowyTrener, trener),
        stadion = IF(nowyStadion IS NOT NULL, nowyStadion, stadion)
    WHERE
        druzyna_id = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DodajDruzyne` (IN `NowaNazwa` VARCHAR(100))  BEGIN
    INSERT INTO druzyna (nazwa_druzyny)
    VALUES (NowaNazwa);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DodajMecz` (IN `dataMeczu` DATE, IN `gospodarz` INT(11), IN `gosc` INT(11), IN `gsp_gole` INT(11), IN `gos_gole` INT(11))  BEGIN
    INSERT INTO mecz (data_meczu, druzyna_gospodarz_Id, druzyna_gosc_Id, wynik_gospodarz, wynik_gosc)
    VALUES (dataMeczu, gospodarz, gosc, gsp_gole, gos_gole);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DodajStatystyki` (IN `p_mecz_id` INT(11), IN `p_druzyna_id` INT(11), IN `posiadanie` INT(11), IN `podania` INT(11), IN `celne` INT(11), IN `niecelne` INT(11), IN `rozne` INT(11), IN `karne` INT(11), IN `faul` INT(11), IN `spalony` INT(11))  BEGIN
    INSERT INTO statystyki (mecz_id, druzyna_id, posiadanie_pilki, podania, strzaly_celne, strzaly_niecelne, rzuty_rozne, rzuty_karne, faule, spalone)
    VALUES (p_mecz_id, p_druzyna_id, posiadanie, podania, celne, niecelne, rozne, karne, faul, spalony);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DodajZawodnika` (IN `dane` VARCHAR(50), IN `urodzenie` DATE, IN `reprezentacja` VARCHAR(50), IN `pozycja` VARCHAR(5), IN `druzyna_id` INT(11))  BEGIN
    DECLARE Err_too_long_code CONDITION FOR SQLSTATE '45000';

    IF LENGTH(reprezentacja) = 3 THEN
        INSERT INTO zawodnik (imie_nazwisko, data_urodzenia, reprezentacja, pozycja, druzyna_id)
        VALUES (dane, urodzenie, reprezentacja, pozycja, druzyna_id);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Błąd: Reprezentacja musi być trzyliterowym kodem.';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DodajZawodnika2` (IN `dane` VARCHAR(50), IN `urodzenie` DATE, IN `reprezentacja` VARCHAR(50), IN `pozycja` VARCHAR(5), IN `druzyna_id` INT(11))  BEGIN
    INSERT INTO zawodnik (imie_nazwisko, data_urodzenia, reprezentacja, pozycja, druzyna_id)
    VALUES (dane, urodzenie, reprezentacja, pozycja, druzyna_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UsunDruzynaId` (IN `id_delete` INT)  BEGIN
    DELETE FROM druzyna
    WHERE druzyna_id = id_delete;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UsunDruzynaNazwa` (IN `nazwa` VARCHAR(50))  BEGIN
    DELETE FROM druzyna
    WHERE nazwa_druzyny = nazwa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UsunMeczId` (IN `id_delete` INT)  BEGIN
    DELETE FROM mecz
    WHERE mecz_id = id_delete;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UsunStatystykiId` (IN `id_delete` INT)  BEGIN
    DELETE FROM statystyki
    WHERE statystyki_id = id_delete;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UsunZawodnikaImieNazwisko` (IN `nazwaZawodnika` VARCHAR(50))  BEGIN
    DELETE FROM zawodnik
    WHERE imie_nazwisko = nazwaZawodnika;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UsunZawodnikID` (IN `idZawodnika` INT)  BEGIN
    DELETE FROM zawodnik
    WHERE zawodnik_id = idZawodnika;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `bramka`
--

CREATE TABLE `bramka` (
  `bramka_id` int(11) NOT NULL,
  `mecz_id` int(11) NOT NULL,
  `zawodnik_id` int(11) NOT NULL,
  `minuta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `druzyna`
--

CREATE TABLE `druzyna` (
  `druzyna_id` int(11) NOT NULL,
  `nazwa_druzyny` varchar(100) NOT NULL,
  `trener` varchar(50) NOT NULL,
  `rok_zalozenia` date NOT NULL,
  `stadion` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `druzyna`
--

INSERT INTO `druzyna` (`druzyna_id`, `nazwa_druzyny`, `trener`, `rok_zalozenia`, `stadion`) VALUES
(1, 'Eibar', '', '0000-00-00', ''),
(2, 'Celta Vigo', '', '0000-00-00', ''),
(3, 'Athletic Club', '', '0000-00-00', ''),
(4, 'Granada', '', '0000-00-00', ''),
(5, 'Cádiz', '', '0000-00-00', ''),
(6, 'Osasuna', '', '0000-00-00', ''),
(7, 'Alavés', '', '0000-00-00', ''),
(8, 'Betis', '', '0000-00-00', ''),
(9, 'Valladolid', '', '0000-00-00', ''),
(10, 'Real Sociedad', '', '0000-00-00', ''),
(11, 'Huesca', '', '0000-00-00', ''),
(12, 'Villarreal', '', '0000-00-00', ''),
(13, 'Levante', '', '0000-00-00', ''),
(14, 'Valencia', '', '0000-00-00', ''),
(15, 'Getafe', '', '0000-00-00', ''),
(16, 'Real Madrid', '', '0000-00-00', ''),
(17, 'Elche', '', '0000-00-00', ''),
(18, 'Atlético Madrid', '', '0000-00-00', ''),
(19, 'Sevilla', '', '0000-00-00', ''),
(20, 'Barcelona', '', '0000-00-00', ''),
(22, 'Eibar', '', '0000-00-00', ''),
(23, 'Celta Vigo', '', '0000-00-00', ''),
(24, 'Athletic Club', '', '0000-00-00', ''),
(25, 'Granada', '', '0000-00-00', ''),
(26, 'Cádiz', '', '0000-00-00', ''),
(27, 'Osasuna', '', '0000-00-00', ''),
(28, 'Alavés', '', '0000-00-00', ''),
(29, 'Betis', '', '0000-00-00', ''),
(30, 'Valladolid', '', '0000-00-00', ''),
(31, 'Real Sociedad', '', '0000-00-00', ''),
(32, 'Huesca', '', '0000-00-00', ''),
(33, 'Villarreal', '', '0000-00-00', ''),
(34, 'Levante', '', '0000-00-00', ''),
(35, 'Valencia', '', '0000-00-00', ''),
(36, 'Getafe', '', '0000-00-00', ''),
(37, 'Real Madrid', '', '0000-00-00', ''),
(38, 'Elche', '', '0000-00-00', ''),
(39, 'Atlético Madrid', '', '0000-00-00', ''),
(40, 'Sevilla', '', '0000-00-00', ''),
(41, 'Barcelona', '', '0000-00-00', '');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kartka`
--

CREATE TABLE `kartka` (
  `kartka_id` int(11) NOT NULL,
  `mecz_id` int(11) NOT NULL,
  `zawodnik_id` int(11) NOT NULL,
  `rodzaj_kartki` varchar(10) NOT NULL,
  `minuta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mecz`
--

CREATE TABLE `mecz` (
  `mecz_id` int(11) NOT NULL,
  `data_meczu` date NOT NULL,
  `druzyna_gospodarz_id` int(11) NOT NULL,
  `druzyna_gosc_id` int(11) NOT NULL,
  `wynik_gospodarz` int(11) NOT NULL,
  `wynik_gosc` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `statystyki`
--

CREATE TABLE `statystyki` (
  `statystyki_id` int(11) NOT NULL,
  `mecz_id` int(11) NOT NULL,
  `druzyna_id` int(11) NOT NULL,
  `posiadanie_pilki` int(11) NOT NULL,
  `podania` int(11) NOT NULL,
  `strzaly_celne` int(11) NOT NULL,
  `strzaly_niecelne` int(11) NOT NULL,
  `rzuty_rozne` int(11) NOT NULL,
  `rzuty_karne` int(11) NOT NULL,
  `faule` int(11) NOT NULL,
  `spalone` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `zawodnik`
--

CREATE TABLE `zawodnik` (
  `zawodnik_id` int(11) NOT NULL,
  `imie_nazwisko` varchar(50) NOT NULL,
  `data_urodzenia` date NOT NULL,
  `reprezentacja` varchar(50) NOT NULL,
  `pozycja` varchar(5) NOT NULL,
  `druzyna_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `zawodnik`
--

INSERT INTO `zawodnik` (`zawodnik_id`, `imie_nazwisko`, `data_urodzenia`, `reprezentacja`, `pozycja`, `druzyna_id`) VALUES
(2, 'Jeremi Wiśniowecki', '1990-01-20', 'Polska', 'LM', 10),
(101, 'Aarón Escandell', '1995-09-13', 'ESP', 'GK', 9),
(102, 'Aarón Martín', '1997-04-07', 'ESP', 'LB', 17),
(103, 'Abdallahi Mahmoud', '2000-04-19', 'MTN', 'CM', 10),
(104, 'Abdoulay Diaby', '1991-05-28', 'MLI', 'CB', 11),
(105, 'Adnan Januzaj', '1995-01-21', 'BEL', 'RW', 13),
(106, 'Adrián López', '1987-12-28', 'ESP', 'LM', 10),
(107, 'Adrián Marín', '1996-12-25', 'ESP', 'LB', 9),
(108, 'Aihen Muñoz', '1997-07-23', 'ESP', 'LB', 8),
(109, 'Aitor Fernández', '1991-04-21', 'ESP', 'GK', 17),
(110, 'Aitor Ruibal', '1996-03-07', 'ESP', 'LW', 18),
(111, 'Alberto Cifuentes', '1979-06-09', 'ESP', 'GK', 18),
(112, 'Alberto Moreno', '1992-06-20', 'ESP', 'LB', 16),
(113, 'Alberto Perea', '1990-12-04', 'ESP', 'LW', 9),
(114, 'Alberto Soro', '1999-02-22', 'ESP', 'RM', 9),
(115, 'Aleix García', '1997-06-13', 'ESP', 'CM', 20),
(116, 'Aleix Vidal', '1989-08-08', 'ESP', 'RB', 12),
(117, 'Alejandro Blanco', '1998-11-24', 'ESP', 'LM', 16),
(118, 'Alejandro Blesa', '2001-12-28', 'ESP', 'CM', 3),
(119, 'Alejandro Pozo Pozo', '1999-02-07', 'ESP', 'RB', 16),
(120, 'Alex Baena', '2001-07-03', 'ESP', 'RM', 16),
(121, 'Alexander Isak', '1999-09-05', 'SWE', 'FW', 13),
(122, 'Alfon', '1999-04-27', 'ESP', 'RM', 17),
(123, 'Alfonso Espino', '1991-12-22', 'URU', 'LB', 14),
(124, 'Alfonso Pedraza', '1996-03-23', 'ESP', 'LB', 4),
(125, 'Allan Nyom', '1988-04-27', 'CMR', 'LB', 8),
(126, 'Anaitz Arbilla', '1987-05-03', 'ESP', 'CB', 16),
(127, 'Ander Barrenetxea', '2001-12-10', 'ESP', 'LW', 13),
(128, 'Ander Capa', '1992-01-29', 'ESP', 'RB', 10),
(129, 'Ander Guevara', '1997-06-21', 'ESP', 'DM', 13),
(130, 'Andoni Gorosabel', '1996-07-19', 'ESP', 'RB', 13),
(131, 'Andrés Fernández', '1986-12-05', 'ESP', 'GK', 17),
(132, 'Andrés Guardado', '1986-09-16', 'MEX', 'DM', 18),
(133, 'Ansu Fati', '2002-10-30', 'ESP', 'FW', 8),
(134, 'Ante Budimir', '1991-07-08', 'CRO', 'FW', 2),
(135, 'Ante Palaversa', '2000-04-04', 'CRO', 'DM', 13),
(136, 'Anthony Lozano', '1993-04-10', 'HON', 'LM', 14),
(137, 'Antoine Griezmann', '1991-03-08', 'FRA', 'RW', 6),
(138, 'Antonio Barragán', '1987-05-31', 'ESP', 'CB', 1),
(139, 'Antonio Puertas', '1992-02-08', 'ESP', 'LB', 9),
(140, 'Antonio Sanabria', '1996-02-25', 'PAR', 'FW', 16),
(141, 'Antonio Sivera', '1996-07-27', 'ESP', 'GK', 15),
(142, 'Aridane Hernández', '1989-03-11', 'ESP', 'CB', 14),
(143, 'Aritz Elustondo', '1994-03-13', 'ESP', 'CB', 13),
(144, 'Asier Illarramendi', '1990-02-23', 'ESP', 'DM', 11),
(145, 'Asier Villalibre', '1997-09-15', 'ESP', 'FW', 7),
(146, 'Augusto Fernández', '1986-03-27', 'ARG', 'CM', 9),
(147, 'Augusto Solari', '1991-12-21', 'ARG', 'LM', 17),
(148, 'Aïssa Mandi', '1991-10-09', 'ALG', 'CB', 4),
(149, 'Barcia', '2000-12-29', 'ESP', 'LB', 9),
(150, 'Bobby Adekanye', '1999-02-12', 'NED', 'LM', 16),
(151, 'Borja García', '1990-10-09', 'ESP', 'FW', 7),
(152, 'Borja Iglesias', '1993-01-03', 'ESP', 'FW', 18),
(153, 'Borja Mayoral', '1997-04-11', 'ESP', 'FW', 12),
(154, 'Borja Sainz', '2001-01-16', 'ESP', 'LM', 2),
(155, 'Brais Méndez', '1996-12-23', 'ESP', 'RM', 17),
(156, 'Bruno González', '1990-05-11', 'ESP', 'CB', 20),
(157, 'Bryan Gil', '2001-01-26', 'ESP', 'RM', 16),
(158, 'Burgui', '1993-10-21', 'ESP', 'RM', 12),
(159, 'Cala', '1989-11-14', 'ESP', 'CB', 19),
(160, 'Carles Aleñá', '1997-12-21', 'ESP', 'CM', 8),
(161, 'Carlos Akapo', '1993-02-24', 'EQG', 'RB', 9),
(162, 'Carlos Bacca', '1986-08-25', 'COL', 'FW', 4),
(163, 'Carlos Clerc', '1992-02-06', 'ESP', 'LB', 3),
(164, 'Carlos Dominguez', '2001-01-26', 'ESP', 'CB', 17),
(165, 'Carlos Fernández', '1996-05-06', 'ESP', 'AM', 13),
(166, 'Carlos Neva', '1996-05-29', 'ESP', 'WB', 9),
(167, 'Carlos Soler', '1996-12-18', 'ESP', 'CM', 12),
(168, 'Casemiro', '1992-02-08', 'BRA', 'CM', 20),
(169, 'Cheick Doukouré', '1992-08-29', 'CIV', 'CM', 1),
(170, 'Chema', '1992-02-18', 'ESP', 'CB', 8),
(171, 'Christian Oliva', '1996-05-17', 'URU', 'CM', 15),
(172, 'Cifu', '1990-09-21', 'ESP', 'RB', 7),
(173, 'Claudio Bravo', '1983-04-02', 'CHI', 'GK', 18),
(174, 'Clément Lenglet', '1995-06-04', 'FRA', 'CB', 1),
(175, 'Coke', '1987-04-12', 'ESP', 'RB', 3),
(176, 'Cristian Tello', '1991-07-29', 'ESP', 'LW', 18),
(177, 'Cristiano Piccini', '1992-09-12', 'ITA', 'RB', 12),
(178, 'Cucho', '1999-04-05', 'COL', 'FW', 8),
(179, 'Cárdenas', '1997-03-11', 'ESP', 'GK', 3),
(180, 'Damian Kądzior', '1992-06-14', 'POL', 'RW', 8),
(181, 'Damián Suárez', '1988-04-14', 'URU', 'RB', 8),
(182, 'Dani Calvo', '1994-03-18', 'ESP', 'CB', 1),
(183, 'Dani Carvajal', '1991-12-30', 'ESP', 'RB', 7),
(184, 'Dani Escriche', '1998-03-08', 'ESP', 'DM', 5),
(185, 'Dani García', '1990-05-11', 'ESP', 'CM', 3),
(186, 'Dani Gómez', '1998-07-13', 'ESP', 'FW', 3),
(187, 'Dani Plomer', '1998-11-29', 'ESP', 'RW', 9),
(188, 'Dani Raba', '1995-10-13', 'ESP', 'FW', 4),
(189, 'Daniel Parejo', '1989-04-01', 'ESP', 'CM', 4),
(190, 'Daniel Wass', '1989-05-18', 'DEN', 'CM', 12),
(191, 'Darko Brašanac', '1992-01-30', 'SRB', 'CM', 4),
(192, 'Darwin Machís', '1993-01-24', 'VEN', 'LM', 9),
(193, 'Darío Poveda', '1997-02-26', 'ESP', 'FW', 5),
(194, 'David Ferreiro', '1988-03-18', 'ESP', 'CM', 5),
(195, 'David García', '1994-01-30', 'ESP', 'CB', 2),
(196, 'David Gil', '1993-12-26', 'ESP', 'GK', 9),
(197, 'David Silva', '1985-12-26', 'ESP', 'AM', 13),
(198, 'David Soria', '1993-03-22', 'ESP', 'GK', 2),
(199, 'David Timor', '1989-10-04', 'ESP', 'CB', 13),
(200, 'Denis Cheryshev', '1990-12-13', 'RUS', 'LM', 16),
(201, 'Denis Suárez', '1993-12-23', 'ESP', 'CM', 17),
(202, 'Denis Vavro', '1996-03-25', 'SVK', 'CB', 5),
(203, 'Deyverson', '1991-04-26', 'BRA', 'FW', 12),
(204, 'Diego Carlos', '1993-02-28', 'BRA', 'CB', 8),
(205, 'Diego Costa', '1988-10-08', 'ESP', 'FW', 14),
(206, 'Diego González', '1995-01-13', 'ESP', 'CB', 7),
(207, 'Diego Lainez', '2000-05-24', 'MEX', 'RW', 18),
(208, 'Diego Llorente', '1993-08-23', 'ESP', 'CB', 10),
(209, 'Dimitri Foulquier', '1993-03-09', 'FRA', 'RB', 9),
(210, 'Dimitris Siovas', '1988-09-02', 'GRE', 'CB', 5),
(211, 'Djené', '1991-12-18', 'TOG', 'CB', 8),
(212, 'Domingos Duarte', '1995-02-24', 'POR', 'CB', 6),
(213, 'Domingos Quina', '1999-11-03', 'POR', 'CM', 6),
(214, 'Eden Hazard', '1990-12-25', 'BEL', 'LW', 18),
(215, 'Edgar Sevikyan', '2001-08-06', 'ARM', 'RM', 17),
(216, 'Edu Expósito', '1996-07-17', 'ESP', 'CM', 20),
(217, 'Eliaquim Mangala', '1991-01-31', 'FRA', 'CB', 12),
(218, 'Emerson', '1998-12-30', 'BRA', 'RB', 18),
(219, 'Emiliano Rigoni', '1993-01-23', 'ARG', 'RM', 17),
(220, 'Emmanuel Amankwaa Akurugu', '2001-11-05', 'GHA', 'LB', 11),
(221, 'Emre Mor', '1997-07-17', 'TUR', 'RM', 17),
(222, 'Enes Ünal', '1997-04-25', 'TUR', 'FW', 8),
(223, 'Enis Bardhi', '1995-06-16', 'MKD', 'LM', 3),
(224, 'Enric Gallego', '1986-08-30', 'ESP', 'FW', 2),
(225, 'Erick Cabaco', '1995-04-05', 'URU', 'CB', 8),
(226, 'Esteban Burgos', '1991-12-14', 'ARG', 'CB', 11),
(227, 'Eugeni Valderrama', '1994-07-20', 'ESP', 'CM', 7),
(228, 'Ezequiel Ávila', '1994-01-23', 'ARG', 'CM', 4),
(229, 'Eñaut Mendía', '1999-06-29', 'ESP', 'RW', 13),
(230, 'Fabián Orellana', '1986-01-15', 'CHI', 'LM', 9),
(231, 'Facundo Ferreyra', '1991-03-02', 'ARG', 'LM', 3),
(232, 'Facundo Pellistri', '2001-12-04', 'URU', 'RW', 15),
(233, 'Facundo Roncaglia', '1987-01-29', 'ARG', 'CB', 18),
(234, 'Fali', '1993-07-27', 'ESP', 'CB', 9),
(235, 'Fede San Emeterio', '1997-03-01', 'ESP', 'CM', 11),
(236, 'Fede Vico', '1994-06-20', 'ESP', 'CM', 9),
(237, 'Federico Valverde', '1998-07-05', 'URU', 'RM', 20),
(238, 'Felipe', '1989-05-03', 'BRA', 'CB', 10),
(239, 'Ferland Mendy', '1995-05-18', 'FRA', 'LB', 7),
(240, 'Fernando', '1987-07-12', 'BRA', 'DM', 8),
(241, 'Fernando Niño', '2000-10-07', 'ESP', 'FW', 16),
(242, 'Fernando Pacheco', '1992-05-04', 'ESP', 'GK', 15),
(243, 'Fidel', '1989-10-14', 'ESP', 'LB', 1),
(244, 'Filip Malbašić', '1992-11-02', 'SRB', 'FW', 9),
(245, 'Florian Lejeune', '1991-05-07', 'FRA', 'CB', 15),
(246, 'Fran Beltrán', '1999-01-19', 'ESP', 'DM', 17),
(247, 'Francis Coquelin', '1991-04-28', 'FRA', 'CM', 4),
(248, 'Francisco Portillo', '1990-05-21', 'ESP', 'CM', 18),
(249, 'Francisco Reis Ferreira', '1997-03-11', 'POR', 'CB', 16),
(250, 'Francisco Trincão', '1999-12-14', 'POR', 'RW', 6),
(251, 'Franco Vázquez', '1989-02-09', 'ARG', 'LM', 12),
(252, 'Frenkie de Jong', '1997-04-27', 'NED', 'CB', 6),
(253, 'Gabriel Paulista', '1990-11-13', 'BRA', 'CB', 12),
(254, 'Gabriel Veiga', '2002-05-11', 'ESP', 'RB', 17),
(255, 'Gastón Silva', '1994-02-18', 'URU', 'CB', 5),
(256, 'Geoffrey Kondogbia', '1993-02-01', 'CTA', 'DM', 10),
(257, 'Gerard Moreno', '1992-03-22', 'ESP', 'FW', 4),
(258, 'Gerard Piqué', '1987-01-22', 'ESP', 'CB', 1),
(259, 'Germán Sánchez', '1986-11-30', 'ESP', 'CB', 9),
(260, 'Gerónimo Rulli', '1992-05-04', 'ARG', 'GK', 4),
(261, 'Giorgi Kochorashvili', '1999-06-15', 'GEO', 'LM', 17),
(262, 'Gonzalo Melero', '1993-12-17', 'ESP', 'CM', 3),
(263, 'Gonzalo Verdú', '1988-10-08', 'ESP', 'CB', 1),
(264, 'Gonçalo Guedes', '1996-11-14', 'POR', 'LM', 12),
(265, 'Guido Carrillo', '1991-05-11', 'ARG', 'FW', 7),
(266, 'Guido Rodríguez', '1994-03-29', 'ARG', 'DM', 18),
(267, 'Guillem Molina', '2000-04-06', 'ESP', 'RB', 16),
(268, 'Helibelton Palacios', '1993-05-28', 'COL', 'RB', 1),
(269, 'Hugo Duro', '1999-10-31', 'ESP', 'FW', 20),
(270, 'Hugo Mallo', '1991-06-10', 'ESP', 'CB', 10),
(271, 'Hugo Sotelo', '2003-12-04', 'ESP', 'CM', 10),
(272, 'Héctor Herrera', '1990-04-06', 'MEX', 'DM', 10),
(273, 'Iago Aspas', '1987-07-20', 'ESP', 'FW', 17),
(274, 'Ibai Gómez', '1989-10-29', 'ESP', 'LM', 7),
(275, 'Idrissa Doumbia', '1998-03-31', 'CIV', 'FW', 18),
(276, 'Iglesias', '1998-06-18', 'ESP', 'RB', 8),
(277, 'Igor Zubeldia', '1997-03-16', 'ESP', 'CB', 1),
(278, 'Iker Muniain', '1992-11-26', 'ESP', 'LM', 7),
(279, 'Ilaix Moriba', '2003-01-03', 'GUI', 'CM', 6),
(280, 'Isaac Carcelen', '1993-04-07', 'ESP', 'LB', 9),
(281, 'Isco', '1992-04-05', 'ESP', 'AM', 20),
(282, 'Isma Ruiz', '2001-02-12', 'ESP', 'DM', 9),
(283, 'Ivan Rakitić', '1988-02-26', 'CRO', 'CM', 12),
(284, 'Ivan Šaponjić', '1997-07-17', 'SRB', 'FW', 14),
(285, 'Iván Alejo', '1995-01-26', 'ESP', 'RM', 14),
(286, 'Iván Marcone', '1990-05-21', 'ARG', 'CM', 1),
(287, 'Iván Villar', '1997-06-24', 'ESP', 'GK', 17),
(288, 'Iñaki Williams', '1994-06-01', 'GHA', 'FW', 7),
(289, 'Iñigo Córdoba', '1997-02-18', 'ESP', 'LM', 6),
(290, 'Iñigo Lekue', '1993-04-20', 'ESP', 'RB', 7),
(291, 'Iñigo Martínez', '1991-05-04', 'ESP', 'CB', 3),
(292, 'Iñigo Pérez', '1988-01-05', 'ESP', 'CM', 2),
(293, 'Iñigo Vicente', '1997-12-22', 'ESP', 'LM', 7),
(294, 'Jaime Mata', '1988-10-11', 'ESP', 'FW', 8),
(295, 'Jaime Seoane', '1997-01-06', 'ESP', 'CM', 5),
(296, 'Jairo Izquierdo', '1993-10-06', 'ESP', 'RM', 9),
(297, 'Jan Oblak', '1992-12-24', 'SVN', 'GK', 10),
(298, 'Jason', '1994-06-22', 'ESP', 'AM', 15),
(299, 'Jasper Cillessen', '1989-04-09', 'NED', 'GK', 12),
(300, 'Jaume Costa', '1988-03-04', 'ESP', 'LB', 16),
(301, 'Jaume Doménech', '1990-10-23', 'ESP', 'GK', 6),
(302, 'Javi Galán', '1994-11-04', 'ESP', 'LW', 5),
(303, 'Javi López', '2001-12-08', 'ESP', 'LB', 6),
(304, 'Javi Martínez', '1999-12-06', 'ESP', 'CM', 2),
(305, 'Javi Moyano', '1986-03-03', 'ESP', 'RB', 7),
(306, 'Javi Sánchez', '1997-02-27', 'ESP', 'CB', 15),
(307, 'Javier Ontiveros', '1997-08-29', 'ESP', 'AM', 20),
(308, 'Jawad El Yamiq', '1992-02-16', 'MAR', 'CB', 11),
(309, 'Jeison Lucumí', '1995-04-08', 'COL', 'RM', 4),
(310, 'Jeison Murillo', '1992-05-14', 'COL', 'CB', 3),
(311, 'Jens Jønsson', '1992-12-25', 'DEN', 'RM', 9),
(312, 'Jeremías Ledesma', '1993-01-31', 'ARG', 'GK', 5),
(313, 'Jesús Navas', '1985-11-08', 'ESP', 'RB', 8),
(314, 'Jesús Vallejo', '1996-12-21', 'ESP', 'CB', 9),
(315, 'Joan Jordán', '1994-06-22', 'ESP', 'RM', 12),
(316, 'Joaquín', '1981-07-09', 'ESP', 'RW', 9),
(317, 'Joaquín Fernández', '1996-05-16', 'ESP', 'CB', 15),
(318, 'Joaquín Muñoz', '1999-03-15', 'ESP', 'RW', 2),
(319, 'Joel Robles', '1990-06-07', 'ESP', 'GK', 17),
(320, 'Johan Mojica', '1992-08-07', 'COL', 'LB', 1),
(321, 'John Donald', '2000-08-19', 'ESP', 'CM', 18),
(322, 'John Guidetti', '1992-04-01', 'SWE', 'FW', 15),
(323, 'John Joe', '2003-10-19', 'IRL', 'LM', 16),
(324, 'Jokin Ezkieta', '1996-08-02', 'ESP', 'GK', 7),
(325, 'Jon Ander Garrido', '1989-09-24', 'ESP', 'CB', 9),
(326, 'Jon Bautista', '1995-06-19', 'ESP', 'FW', 11),
(327, 'Jon Guridi', '1995-02-15', 'ESP', 'DM', 1),
(328, 'Jon Moncayola', '1998-04-27', 'ESP', 'CM', 2),
(329, 'Jon Morcillo', '1998-08-31', 'ESP', 'LM', 3),
(330, 'Jon Pacheco', '2000-12-24', 'ESP', 'CB', 1),
(331, 'Jonathan Calleri', '1993-08-29', 'ARG', 'FW', 2),
(332, 'Jony', '1991-06-25', 'ESP', 'LW', 2),
(333, 'Jony Álamo', '2001-09-14', 'ESP', 'CM', 18),
(334, 'Jonás Ramalho', '1993-05-26', 'ESP', 'CB', 2),
(335, 'Jordan Holsgrove', '1999-08-27', 'SCO', 'RM', 10),
(336, 'Jordi Alba', '1989-03-08', 'ESP', 'LB', 6),
(337, 'Jordi Masip', '1988-12-21', 'ESP', 'GK', 11),
(338, 'Jorge Miramón', '1989-05-21', 'ESP', 'RB', 17),
(339, 'Jorge Molina', '1982-04-11', 'ESP', 'FW', 9),
(340, 'Jorge Pombo', '1994-02-06', 'ESP', 'LM', 9),
(341, 'Jorge Pulido', '1991-03-25', 'ESP', 'CB', 5),
(342, 'Jorge de Frutos', '1997-02-03', 'ESP', 'RM', 3),
(343, 'Josan', '1989-11-20', 'ESP', 'RB', 1),
(344, 'Joseba Zaldúa', '1992-06-10', 'ESP', 'RB', 11),
(345, 'Joselu', '1990-03-14', 'ESP', 'FW', 15),
(346, 'Josema', '1996-05-22', 'ESP', 'CB', 1),
(347, 'Joseph Aidoo', '1995-09-16', 'GHA', 'CB', 10),
(348, 'José Antonio Miranda', '1998-07-07', 'EQG', 'LM', 8),
(349, 'José Campaña', '1993-06-01', 'ESP', 'LM', 17),
(350, 'José Fontán', '2000-01-28', 'ESP', 'LB', 3),
(351, 'José Luis Gayà', '1995-05-11', 'ESP', 'LB', 12),
(352, 'José Luis Morales', '1987-07-09', 'ESP', 'LM', 3),
(353, 'José Mari', '1987-11-22', 'ESP', 'LM', 9),
(354, 'José María Giménez', '1995-01-06', 'URU', 'CB', 10),
(355, 'José Ángel', '1989-08-23', 'ESP', 'LB', 20),
(356, 'Jota', '1991-06-04', 'ESP', 'LW', 12),
(357, 'João Félix', '1999-10-26', 'POR', 'LM', 10),
(358, 'Juan Brunet', '1998-01-09', 'ARG', 'CM', 9),
(359, 'Juan Carlos', '1991-03-08', 'ESP', 'AM', 19),
(360, 'Juan Cruz Armada', '1992-07-14', 'ESP', 'CB', 4),
(361, 'Juan Foyth', '1997-12-28', 'ARG', 'RB', 5),
(362, 'Juan Miranda', '2000-01-04', 'ESP', 'LB', 18),
(363, 'Juan Pérez', '1996-06-29', 'ESP', 'GK', 2),
(364, 'Juan Sánchez Miño', '1989-12-29', 'ARG', 'LB', 5),
(365, 'Juanmi', '1993-05-07', 'ESP', 'RW', 2),
(366, 'Jules Koundé', '1998-10-28', 'FRA', 'CB', 12),
(367, 'Junior Firpo', '1996-08-07', 'ESP', 'LM', 6),
(368, 'Karim Benzema', '1987-12-05', 'FRA', 'FW', 20),
(369, 'Karim Rekik', '1994-11-18', 'NED', 'CB', 12),
(370, 'Kelechi Nwakali', '1998-05-29', 'NGA', 'FW', 8),
(371, 'Kenan Kodro', '1993-08-05', 'BIH', 'FW', 15),
(372, 'Kenedy', '1996-01-26', 'BRA', 'LM', 2),
(373, 'Kevin Vázquez', '1993-03-09', 'ESP', 'RB', 17),
(374, 'Kieran Trippier', '1990-09-06', 'ENG', 'RB', 10),
(375, 'Kike Barja', '1997-03-16', 'ESP', 'LW', 2),
(376, 'Kike Pérez', '1997-01-30', 'ESP', 'CM', 11),
(377, 'Kiko Olivas', '1988-08-08', 'ESP', 'CB', 11),
(378, 'Kiké', '1989-11-12', 'ESP', 'FW', 16),
(379, 'Kingsley Fobi', '1998-09-20', 'GHA', 'RB', 9),
(380, 'Koba Koindredi', '2001-10-19', 'FRA', 'CM', 8),
(381, 'Koke', '1991-12-26', 'ESP', 'CM', 10),
(382, 'Koke Vegas', '1995-10-03', 'ESP', 'GK', 19),
(383, 'Kuki', '1998-04-27', 'ESP', 'AM', 12),
(384, 'Kévin Gameiro', '1987-04-27', 'FRA', 'FW', 12),
(385, 'Kévin Rodrigues', '1994-02-19', 'POR', 'LM', 20),
(386, 'Lauti', '2001-02-05', 'URU', 'LM', 7),
(387, 'Lee Kang-in', '2001-02-03', 'KOR', 'RM', 12),
(388, 'Lionel Messi', '1987-06-13', 'ARG', 'FW', 1),
(389, 'Loren Morón', '1993-12-16', 'ESP', 'FW', 18),
(390, 'Lucas Boyé', '1996-02-14', 'ARG', 'FW', 1),
(391, 'Lucas Ocampos', '1994-06-27', 'ARG', 'LW', 12),
(392, 'Lucas Olaza', '1994-07-07', 'URU', 'LB', 11),
(393, 'Lucas Pérez', '1988-08-28', 'ESP', 'FW', 15),
(394, 'Lucas Torreira', '1996-01-31', 'URU', 'CM', 3),
(395, 'Lucas Torró', '1994-07-04', 'ESP', 'CM', 2),
(396, 'Lucas Vázquez', '1991-06-11', 'ESP', 'RB', 7),
(397, 'Luis Javier Suárez', '1997-11-17', 'COL', 'LM', 9),
(398, 'Luis Milla', '1994-09-30', 'ESP', 'CM', 7),
(399, 'Luis Pérez', '1995-01-21', 'ESP', 'RB', 15),
(400, 'Luis Rioja', '1993-10-02', 'ESP', 'LM', 15),
(401, 'Luis Suárez', '1987-01-12', 'URU', 'FW', 10),
(402, 'Luisinho', '1985-05-08', 'POR', 'LB', 7),
(403, 'Luismi', '1992-04-23', 'ESP', 'CM', 17),
(404, 'Luka Jović', '1997-12-27', 'SRB', 'FW', 1),
(405, 'Luka Modrić', '1985-08-26', 'CRO', 'LM', 20),
(406, 'Luuk de Jong', '1990-08-14', 'NED', 'FW', 12),
(407, 'Manu García', '1986-04-14', 'ESP', 'LM', 15),
(408, 'Manu Sánchez', '2000-08-07', 'ESP', 'LB', 2),
(409, 'Manu Trigueros', '1991-10-02', 'ESP', 'LM', 4),
(410, 'Manu Vallejo', '1997-01-30', 'ESP', 'RM', 12),
(411, 'Marc Bartra', '1991-01-02', 'ESP', 'CB', 18),
(412, 'Marc Baró', '1999-08-15', 'ESP', 'LB', 20),
(413, 'Marc Cardona', '1995-07-14', 'ESP', 'FW', 17),
(414, 'Marc Cucurella', '1998-07-07', 'ESP', 'LM', 8),
(415, 'Marc-André ter Stegen', '1992-04-17', 'GER', 'GK', 1),
(416, 'Marcelo', '1988-04-27', 'BRA', 'WB', 20),
(417, 'Marco Asensio', '1996-01-05', 'ESP', 'RW', 20),
(418, 'Marcos Acuña', '1991-10-14', 'ARG', 'LB', 8),
(419, 'Marcos André', '1996-10-05', 'BRA', 'FW', 11),
(420, 'Marcos Llorente', '1995-01-16', 'ESP', 'RM', 10),
(421, 'Marcos Mauro López Gutiérrez', '1990-12-26', 'ARG', 'CB', 14),
(422, 'Mariano', '1993-07-16', 'DOM', 'FW', 20),
(423, 'Mario Gaspar', '1990-11-09', 'ESP', 'RB', 4),
(424, 'Mario Hermoso', '1995-06-04', 'ESP', 'LB', 10),
(425, 'Marko Dmitrović', '1992-01-11', 'SRB', 'GK', 20),
(426, 'Martin Agirregabiria', '1996-04-25', 'ESP', 'RB', 2),
(427, 'Martin Braithwaite', '1991-05-23', 'DEN', 'FW', 6),
(428, 'Martin Ødegaard', '1998-12-13', 'NOR', 'RM', 7),
(429, 'Martín Merquelanz', '1995-05-30', 'ESP', 'LW', 1),
(430, 'Martín Montoya', '1991-04-08', 'ESP', 'RB', 7),
(431, 'Martín Zubimendi', '1999-01-17', 'ESP', 'DM', 13),
(432, 'Marvin', '2000-06-19', 'ESP', 'RB', 13),
(433, 'Mathías Olivera', '1997-10-17', 'URU', 'LB', 2),
(434, 'Mauro Arambarri', '1995-09-16', 'URU', 'CM', 13),
(435, 'Maxi Gómez', '1996-07-30', 'URU', 'FW', 12),
(436, 'Maxime Gonalons', '1989-02-25', 'FRA', 'DM', 6),
(437, 'Mickael Malsa', '1995-09-26', 'MTQ', 'CM', 3),
(438, 'Miguel Atienza', '1999-05-12', 'ESP', 'CM', 16),
(439, 'Miguel Baeza', '2000-03-11', 'ESP', 'DM', 17),
(440, 'Miguel Gutiérrez', '2001-07-09', 'ESP', 'LB', 20),
(441, 'Miguel Rodríguez', '2003-04-21', 'ESP', 'RM', 12),
(442, 'Miguel Ángel Rubio', '1998-02-16', 'ESP', 'CB', 15),
(443, 'Mikel Balenziaga', '1988-02-17', 'ESP', 'LB', 7),
(444, 'Mikel Merino', '1996-06-08', 'ESP', 'LM', 19),
(445, 'Mikel Oyarzabal', '1997-04-05', 'ESP', 'LW', 13),
(446, 'Mikel Rico', '1984-10-22', 'ESP', 'DM', 5),
(447, 'Mikel Vesga', '1993-05-07', 'ESP', 'CM', 7),
(448, 'Miralem Pjanić', '1990-03-20', 'BIH', 'RM', 6),
(449, 'Modibo Sagnan', '1999-03-31', 'FRA', 'CB', 1),
(450, 'Moi Gómez', '1994-06-07', 'ESP', 'LM', 4),
(451, 'Mouctar Diakhaby', '1996-12-04', 'GUI', 'CB', 12),
(452, 'Moussa Dembélé', '1996-06-27', 'FRA', 'RW', 19),
(453, 'Munir El Haddadi', '1995-08-07', 'MAR', 'RW', 6),
(454, 'Míchel', '1988-07-16', 'ESP', 'CM', 11),
(455, 'Nabil Fekir', '1993-07-04', 'FRA', 'AM', 18),
(456, 'Nacho', '1989-02-22', 'ESP', 'LB', 20),
(457, 'Nacho Monreal', '1986-02-13', 'ESP', 'LB', 13),
(458, 'Nacho Vidal', '1995-01-09', 'ESP', 'RB', 2),
(459, 'Nano', '1995-02-09', 'ESP', 'FW', 17),
(460, 'Nehuén Pérez', '2000-06-08', 'ARG', 'CB', 6),
(461, 'Nemanja Gudelj', '1991-11-03', 'SRB', 'CM', 12),
(462, 'Nemanja Maksimović', '1995-01-12', 'SRB', 'CM', 8),
(463, 'Nemanja Radoja', '1993-01-15', 'SRB', 'CM', 14),
(464, 'Neto', '1989-07-06', 'BRA', 'GK', 6),
(465, 'Nico Williams', '2002-07-02', 'ESP', 'RM', 19),
(466, 'Nieto', '1998-03-23', 'ESP', 'RB', 7),
(467, 'Nikola Vukčević', '1991-12-01', 'MNE', 'CM', 11),
(468, 'Nino', '1980-05-30', 'ESP', 'FW', 1),
(469, 'Nolito', '1986-10-03', 'ESP', 'LM', 17),
(470, 'Néstor Araujo', '1991-08-16', 'MEX', 'CB', 17),
(471, 'Oier Sanjurjo', '1986-05-12', 'ESP', 'CM', 2),
(472, 'Oier Zarraga', '1998-12-22', 'ESP', 'CM', 20),
(473, 'Oihan Sancet', '2000-04-09', 'ESP', 'FW', 7),
(474, 'Okay Yokuşlu', '1994-03-03', 'TUR', 'CM', 17),
(475, 'Omenuke Mfulu', '1994-03-06', 'COD', 'CM', 1),
(476, 'Oriol Rey', '1998-02-13', 'ESP', 'DM', 4),
(477, 'Ousmane Dembélé', '1997-04-30', 'FRA', 'LW', 6),
(478, 'Oussama Idrissi', '1996-02-18', 'MAR', 'LM', 4),
(479, 'Pablo Hervías', '1993-02-22', 'ESP', 'RB', 11),
(480, 'Pablo Insua', '1993-08-26', 'ESP', 'CB', 17),
(481, 'Pablo Maffeo', '1997-06-26', 'ESP', 'RW', 5),
(482, 'Pablo Piatti', '1989-03-18', 'ARG', 'CM', 1),
(483, 'Paco Alcácer', '1993-08-14', 'ESP', 'FW', 4),
(484, 'Papakouli Diop', '1986-03-07', 'SEN', 'CM', 16),
(485, 'Papu Gómez', '1988-02-03', 'ARG', 'LW', 12),
(486, 'Patrick Cutrone', '1997-12-08', 'ITA', 'FW', 16),
(487, 'Pau Torres', '1996-12-30', 'ESP', 'CB', 4),
(488, 'Paul Akouokou', '1997-11-24', 'CIV', 'DM', 9),
(489, 'Paulo Gazzaniga', '1991-12-20', 'ARG', 'GK', 1),
(490, 'Paulo Oliveira', '1991-12-26', 'POR', 'CB', 16),
(491, 'Pedri', '2002-11-10', 'ESP', 'CM', 1),
(492, 'Pedro Alcalá', '1989-03-04', 'ESP', 'CB', 9),
(493, 'Pedro Bigas', '1990-09-02', 'ESP', 'CB', 16),
(494, 'Pedro León', '1986-11-12', 'ESP', 'RM', 16),
(495, 'Pedro López Muñoz', '1983-10-20', 'ESP', 'RW', 5),
(496, 'Pedro Mosquera', '1988-04-07', 'ESP', 'CB', 5),
(497, 'Pepe Sánchez', '2000-02-15', 'ESP', 'CB', 9),
(498, 'Pere Milla', '1992-09-09', 'ESP', 'FW', 1),
(499, 'Pere Pons', '1993-02-06', 'ESP', 'RM', 15),
(500, 'Pervis Estupiñán', '1998-01-06', 'ECU', 'LB', 8),
(501, 'Philippe Coutinho', '1992-06-10', 'BRA', 'CM', 4),
(502, 'Portu', '1992-05-06', 'ESP', 'RW', 13),
(503, 'Quini', '1989-09-11', 'ESP', 'LB', 6),
(504, 'Quique', '1990-05-03', 'ESP', 'FW', 16),
(505, 'Rafa Mir', '1997-06-02', 'ESP', 'FW', 5),
(506, 'Rafa Soares', '1995-04-25', 'POR', 'LB', 16),
(507, 'Ramiro Funes Mori', '1991-02-19', 'ARG', 'RB', 16),
(508, 'Ramon Azeez', '1992-12-18', 'NGA', 'DM', 13),
(509, 'Ramón Folch', '1989-10-10', 'ESP', 'CM', 8),
(510, 'Raphaël Varane', '1993-04-09', 'FRA', 'CB', 20),
(511, 'Raúl Albiol', '1985-08-21', 'ESP', 'CB', 4),
(512, 'Raúl García', '1986-06-29', 'ESP', 'LM', 3),
(513, 'Raúl Guti', '1996-12-15', 'ESP', 'CM', 1),
(514, 'Raúl Navas', '1988-05-12', 'ESP', 'CB', 10),
(515, 'Recio', '1990-12-29', 'ESP', 'RM', 20),
(516, 'Renan Lodi', '1998-03-24', 'BRA', 'LB', 10),
(517, 'Renato Tapia', '1995-07-15', 'PER', 'DM', 3),
(518, 'Riqui Puig', '1999-07-29', 'ESP', 'LM', 6),
(519, 'Rober', '1995-01-31', 'ESP', 'CB', 3),
(520, 'Rober Correa', '1992-09-06', 'ESP', 'RB', 16),
(521, 'Roberto', '1986-01-29', 'ESP', 'GK', 20),
(522, 'Roberto López', '2000-04-07', 'ESP', 'FW', 13),
(523, 'Roberto Soldado', '1985-05-15', 'ESP', 'FW', 9),
(524, 'Roberto Torres', '1989-02-21', 'ESP', 'RW', 2),
(525, 'Robin Le Normand', '1996-10-26', 'ESP', 'CB', 13),
(526, 'Rodri', '2000-04-30', 'ESP', 'RW', 18),
(527, 'Rodrigo Battaglia', '1991-06-29', 'ARG', 'RM', 15),
(528, 'Rodrigo Ely', '1993-11-03', 'BRA', 'CB', 12),
(529, 'Rodrygo', '2000-12-22', 'BRA', 'WB', 20),
(530, 'Roger Martí', '1990-12-19', 'ESP', 'FW', 3),
(531, 'Ronald Araújo', '1999-02-20', 'URU', 'CB', 6),
(532, 'Roque Mesa', '1989-05-25', 'ESP', 'CM', 11),
(533, 'Rubén', '1984-06-22', 'ESP', 'GK', 9),
(534, 'Rubén Alcaraz', '1991-04-18', 'ESP', 'CM', 15),
(535, 'Rubén Blanco', '1995-07-16', 'ESP', 'GK', 2),
(536, 'Rubén Duarte', '1995-10-04', 'ESP', 'LB', 15),
(537, 'Rubén García', '1993-06-30', 'ESP', 'LB', 4),
(538, 'Rubén Peña', '1991-07-03', 'ESP', 'RM', 4),
(539, 'Rubén Rochina', '1991-03-11', 'ESP', 'CM', 7),
(540, 'Rubén Sobrino', '1992-05-16', 'ESP', 'RW', 9),
(541, 'Rubén Yáñez', '1993-09-28', 'ESP', 'GK', 8),
(542, 'Rui Silva', '1994-01-26', 'POR', 'GK', 17),
(543, 'Rúben Vezo', '1994-04-12', 'POR', 'CB', 17),
(544, 'Sabit Abdulai', '1999-04-26', 'GHA', 'CM', 8),
(545, 'Saidy Janko', '1995-10-08', 'GAM', 'RB', 11),
(546, 'Salvi', '1991-03-18', 'ESP', 'RM', 19),
(547, 'Samuel Chukwueze', '1999-05-07', 'NGA', 'RW', 8),
(548, 'Samuel Umtiti', '1993-10-31', 'FRA', 'CB', 6),
(549, 'Sandro Ramírez', '1995-06-24', 'ESP', 'FW', 5),
(550, 'Santi Mina', '1995-11-23', 'ESP', 'FW', 17),
(551, 'Saúl Ñíguez', '1994-11-07', 'ESP', 'LM', 10),
(552, 'Sergi Enrich', '1990-02-13', 'ESP', 'FW', 16),
(553, 'Sergi García', '1999-04-20', 'ESP', 'CM', 7),
(554, 'Sergi Guardiola', '1991-05-16', 'ESP', 'FW', 11),
(555, 'Sergi Gómez', '1992-03-16', 'ESP', 'CB', 13),
(556, 'Sergi Roberto', '1992-01-26', 'ESP', 'RB', 9),
(557, 'Sergio Arribas', '2001-09-15', 'ESP', 'LW', 14),
(558, 'Sergio Asenjo', '1989-06-14', 'ESP', 'GK', 16),
(559, 'Sergio Benito', '1999-03-13', 'ESP', 'RW', 7),
(560, 'Sergio Busquets', '1988-07-03', 'ESP', 'CM', 6),
(561, 'Sergio Canales', '1991-02-02', 'ESP', 'DM', 9),
(562, 'Sergio Carreira', '2000-10-16', 'ESP', 'RB', 1),
(563, 'Sergio Cubero Ezcurra', '1999-09-02', 'ESP', 'AM', 8),
(564, 'Sergio Escudero', '1989-08-20', 'ESP', 'LB', 12),
(565, 'Sergio González', '1997-05-20', 'ESP', 'DM', 5),
(566, 'Sergio Gómez', '2000-08-18', 'ESP', 'LW', 5),
(567, 'Sergio Herrera', '1993-05-22', 'ESP', 'GK', 4),
(568, 'Sergio León', '1988-12-25', 'ESP', 'FW', 17),
(569, 'Sergio Postigo', '1988-10-23', 'ESP', 'CB', 1),
(570, 'Sergio Ramos', '1986-03-19', 'ESP', 'CB', 20),
(571, 'Sergio Álvarez', '1992-01-10', 'ESP', 'CM', 16),
(572, 'Sergiño Dest', '2000-10-18', 'USA', 'RB', 6),
(573, 'Shinji Okazaki', '1986-04-05', 'JPN', 'CB', 2),
(574, 'Shon Weissman', '1996-01-31', 'ISR', 'FW', 11),
(575, 'Sidnei', '1989-08-15', 'BRA', 'CB', 17),
(576, 'Sofian Chakla', '1993-08-19', 'MAR', 'CB', 13),
(577, 'Son', '1994-03-14', 'ESP', 'RB', 3),
(578, 'Stefan Savić', '1990-12-26', 'MNE', 'CB', 19),
(579, 'Suso', '1993-11-05', 'ESP', 'RW', 12),
(580, 'Tachi', '1997-08-26', 'ESP', 'CB', 15),
(581, 'Takashi Inui', '1988-05-20', 'JPN', 'LM', 16),
(582, 'Takefusa Kubo', '2001-05-19', 'JPN', 'FW', 8),
(583, 'Tete Morente', '1996-11-19', 'ESP', 'RM', 16),
(584, 'Thibaut Courtois', '1992-04-25', 'BEL', 'GK', 20),
(585, 'Thierry Correia', '1999-02-22', 'POR', 'RB', 12),
(586, 'Thomas Lemar', '1995-10-30', 'FRA', 'AM', 11),
(587, 'Thomas Partey', '1993-06-18', 'GHA', 'CM', 3),
(588, 'Tomás Pina Isla', '1987-10-02', 'ESP', 'CM', 15),
(589, 'Tomás Tavares', '2001-03-03', 'POR', 'RB', 20),
(590, 'Tomáš Vaclík', '1989-03-16', 'CZE', 'GK', 12),
(591, 'Toni Kroos', '1989-12-25', 'GER', 'LM', 6),
(592, 'Toni Lato', '1997-11-06', 'ESP', 'LB', 16),
(593, 'Toni Villa', '1994-12-24', 'ESP', 'LM', 11),
(594, 'Toño', '1989-10-23', 'ESP', 'LB', 3),
(595, 'Unai Arietaleanizbeaskoa', '1999-01-02', 'ESP', 'DM', 10),
(596, 'Unai Dufur', '1998-12-24', 'ESP', 'RB', 11),
(597, 'Unai García', '1992-01-20', 'ESP', 'CB', 2),
(598, 'Unai López', '1995-10-16', 'ESP', 'CM', 7),
(599, 'Unai Núñez', '1997-01-15', 'ESP', 'CB', 7),
(600, 'Unai Simón', '1997-05-27', 'ESP', 'GK', 3),
(601, 'Unai Vencedor Paris', '2000-10-30', 'ESP', 'CM', 7),
(602, 'Urko González', '2001-02-24', 'ESP', 'CM', 9),
(603, 'Uroš Račić', '1998-03-02', 'SRB', 'CM', 12),
(604, 'Vicente Esquerdo', '1999-01-07', 'ESP', 'CM', 6),
(605, 'Vicente Iborra', '1988-01-17', 'ESP', 'CM', 11),
(606, 'Victor Mollejo', '2001-01-18', 'ESP', 'CB', 13),
(607, 'Vinicius Júnior', '2000-06-24', 'BRA', 'LW', 20),
(608, 'Vitolo', '1989-10-09', 'ESP', 'WB', 18),
(609, 'Víctor Chust', '2000-02-10', 'ESP', 'CB', 1),
(610, 'Víctor Díaz', '1988-05-30', 'ESP', 'CB', 9),
(611, 'Víctor Laguardia', '1989-10-23', 'ESP', 'CB', 2),
(612, 'Víctor Rodríguez', '1989-07-11', 'ESP', 'CM', 7),
(613, 'Víctor Ruiz', '1989-01-12', 'ESP', 'CB', 18),
(614, 'Waldo Rubio', '1995-08-03', 'ESP', 'LM', 16),
(615, 'William Carvalho', '1992-03-24', 'POR', 'DM', 18),
(616, 'Willian José', '1991-11-26', 'BRA', 'FW', 20),
(617, 'Xabier Etxeita', '1987-10-12', 'ESP', 'CB', 1),
(618, 'Ximo Navarro', '1990-01-10', 'ESP', 'RB', 15),
(619, 'Yan Brice Eteki', '1997-08-11', 'CMR', 'CM', 9),
(620, 'Yangel Herrera', '1998-01-01', 'VEN', 'DM', 19),
(621, 'Yann Bodiger', '1995-01-30', 'FRA', 'CM', 1),
(622, 'Yannick Carrasco', '1993-08-21', 'BEL', 'LW', 10),
(623, 'Yassine Bounou', '1991-03-22', 'MAR', 'GK', 8),
(624, 'Yeray Álvarez', '1995-01-10', 'ESP', 'CB', 7),
(625, 'Yeremi Pino', '2002-10-02', 'ESP', 'RM', 4),
(626, 'Yoel', '1988-08-15', 'ESP', 'GK', 16),
(627, 'Yoshinori Mutō', '1992-07-01', 'JPN', 'FW', 20),
(628, 'Youssef En-Nesyri', '1997-05-17', 'MAR', 'FW', 12),
(629, 'Youssouf Koné', '1995-07-07', 'MLI', 'AM', 3),
(630, 'Yunus Musah', '2002-11-13', 'USA', 'RM', 16),
(631, 'Yuri Berchiche', '1990-01-19', 'ESP', 'LB', 7),
(632, 'Álex Berenguer', '1995-06-20', 'ESP', 'RM', 7),
(633, 'Álex Cantero', '2000-05-21', 'ESP', 'FW', 3),
(634, 'Álex Fernández', '1992-10-01', 'ESP', 'LM', 18),
(635, 'Álex Martín', '1998-01-09', 'ESP', 'RB', 14),
(636, 'Álex Millán', '1999-11-06', 'ESP', 'FW', 7),
(637, 'Álex Moreno', '1993-05-25', 'ESP', 'LB', 18),
(638, 'Álex Remiro', '1995-03-09', 'ESP', 'GK', 13),
(639, 'Álvaro Bastida', '2004-04-23', 'ESP', 'CM', 9),
(640, 'Álvaro Bravo', '1998-02-03', 'ESP', 'AM', 9),
(641, 'Álvaro Fernández', '1998-03-28', 'ESP', 'GK', 5),
(642, 'Álvaro Giménez', '1991-05-11', 'ESP', 'FW', 1),
(643, 'Álvaro Negredo', '1985-08-06', 'ESP', 'FW', 9),
(644, 'Álvaro Odriozola', '1995-11-28', 'ESP', 'RB', 20),
(645, 'Álvaro Tejero', '1996-07-25', 'ESP', 'RB', 15),
(646, 'Ángel', '2002-06-21', 'ESP', 'GK', 9),
(647, 'Ángel Correa', '1995-02-23', 'ARG', 'RW', 10),
(648, 'Ángel Montoro', '1988-06-14', 'ESP', 'AM', 19),
(649, 'Ángel Rodríguez', '1987-04-15', 'ESP', 'FW', 2),
(650, 'Éder Militão', '1998-01-01', 'BRA', 'CB', 20),
(651, 'Édgar Badía', '1992-01-23', 'ESP', 'GK', 11),
(652, 'Édgar Méndez', '1989-12-20', 'ESP', 'LW', 15),
(653, 'Étienne Capoue', '1988-06-26', 'FRA', 'CM', 4),
(654, 'Óliver Torres', '1994-10-27', 'ESP', 'RM', 12),
(655, 'Óscar Duarte', '1989-05-19', 'CRC', 'CB', 3),
(656, 'Óscar Mingueza', '1999-04-28', 'ESP', 'CB', 6),
(657, 'Óscar Plano', '1991-01-29', 'ESP', 'RM', 11),
(658, 'Óscar Rodríguez Arnaiz', '1998-06-13', 'ESP', 'LM', 12),
(659, 'Óscar de Marcos', '1989-04-01', 'ESP', 'RB', 7),
(660, 'Šime Vrsaljko', '1991-12-21', 'CRO', 'RB', 3),
(661, 'Marcin Bułka Przez Bibułka', '2020-10-20', 'EPA', 'LM', 20);

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `bramka`
--
ALTER TABLE `bramka`
  ADD PRIMARY KEY (`bramka_id`),
  ADD KEY `mecz_id` (`mecz_id`),
  ADD KEY `zawodnik_id` (`zawodnik_id`);

--
-- Indeksy dla tabeli `druzyna`
--
ALTER TABLE `druzyna`
  ADD PRIMARY KEY (`druzyna_id`);

--
-- Indeksy dla tabeli `kartka`
--
ALTER TABLE `kartka`
  ADD PRIMARY KEY (`kartka_id`),
  ADD KEY `mecz_id` (`mecz_id`),
  ADD KEY `zawodnik_id` (`zawodnik_id`);

--
-- Indeksy dla tabeli `mecz`
--
ALTER TABLE `mecz`
  ADD PRIMARY KEY (`mecz_id`),
  ADD KEY `druzyna_gosc_id` (`druzyna_gosc_id`),
  ADD KEY `druzyna_gospodarz_id` (`druzyna_gospodarz_id`);

--
-- Indeksy dla tabeli `statystyki`
--
ALTER TABLE `statystyki`
  ADD PRIMARY KEY (`statystyki_id`),
  ADD KEY `druzyna_id` (`druzyna_id`),
  ADD KEY `mecz_id` (`mecz_id`);

--
-- Indeksy dla tabeli `zawodnik`
--
ALTER TABLE `zawodnik`
  ADD PRIMARY KEY (`zawodnik_id`),
  ADD KEY `druzyna_id` (`druzyna_id`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `bramka`
--
ALTER TABLE `bramka`
  MODIFY `bramka_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `druzyna`
--
ALTER TABLE `druzyna`
  MODIFY `druzyna_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT dla tabeli `kartka`
--
ALTER TABLE `kartka`
  MODIFY `kartka_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `mecz`
--
ALTER TABLE `mecz`
  MODIFY `mecz_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `statystyki`
--
ALTER TABLE `statystyki`
  MODIFY `statystyki_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `zawodnik`
--
ALTER TABLE `zawodnik`
  MODIFY `zawodnik_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=662;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `bramka`
--
ALTER TABLE `bramka`
  ADD CONSTRAINT `bramka_ibfk_1` FOREIGN KEY (`mecz_id`) REFERENCES `mecz` (`mecz_id`),
  ADD CONSTRAINT `bramka_ibfk_2` FOREIGN KEY (`zawodnik_id`) REFERENCES `zawodnik` (`zawodnik_id`);

--
-- Ograniczenia dla tabeli `kartka`
--
ALTER TABLE `kartka`
  ADD CONSTRAINT `kartka_ibfk_1` FOREIGN KEY (`mecz_id`) REFERENCES `mecz` (`mecz_id`),
  ADD CONSTRAINT `kartka_ibfk_2` FOREIGN KEY (`zawodnik_id`) REFERENCES `zawodnik` (`zawodnik_id`);

--
-- Ograniczenia dla tabeli `mecz`
--
ALTER TABLE `mecz`
  ADD CONSTRAINT `mecz_ibfk_1` FOREIGN KEY (`druzyna_gosc_id`) REFERENCES `druzyna` (`druzyna_id`),
  ADD CONSTRAINT `mecz_ibfk_2` FOREIGN KEY (`druzyna_gospodarz_id`) REFERENCES `druzyna` (`druzyna_id`);

--
-- Ograniczenia dla tabeli `statystyki`
--
ALTER TABLE `statystyki`
  ADD CONSTRAINT `statystyki_ibfk_1` FOREIGN KEY (`druzyna_id`) REFERENCES `druzyna` (`druzyna_id`),
  ADD CONSTRAINT `statystyki_ibfk_2` FOREIGN KEY (`mecz_id`) REFERENCES `mecz` (`mecz_id`);

--
-- Ograniczenia dla tabeli `zawodnik`
--
ALTER TABLE `zawodnik`
  ADD CONSTRAINT `zawodnik_ibfk_1` FOREIGN KEY (`druzyna_id`) REFERENCES `druzyna` (`druzyna_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
