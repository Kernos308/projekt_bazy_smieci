-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 17 Sty 2024, 10:13
-- Wersja serwera: 10.4.24-MariaDB
-- Wersja PHP: 8.1.6

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

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `archiwum_druzyna`
--

CREATE TABLE `archiwum_druzyna` (
  `druzyna_id` bigint(20) UNSIGNED NOT NULL,
  `nazwa_druzyny` varchar(100) DEFAULT NULL,
  `trener` varchar(50) DEFAULT NULL,
  `rok_zalozenia` date DEFAULT NULL,
  `data_usuniecia` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `archiwum_mecz`
--

CREATE TABLE `archiwum_mecz` (
  `mecz_id` bigint(20) UNSIGNED NOT NULL,
  `data_meczu` date DEFAULT NULL,
  `druzyna_gospodarz_id` int(11) DEFAULT NULL,
  `druzyna_gosc_id` int(11) DEFAULT NULL,
  `wynik_gospodarz` int(11) DEFAULT NULL,
  `wynik_gosc` int(11) DEFAULT NULL,
  `data_usuniecia` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `archiwum_statystyki`
--

CREATE TABLE `archiwum_statystyki` (
  `statystyki_id` bigint(20) UNSIGNED NOT NULL,
  `mecz_id` int(11) DEFAULT NULL,
  `druzyna_id` int(11) DEFAULT NULL,
  `posiadanie_pilki` int(11) DEFAULT NULL,
  `podania` int(11) DEFAULT NULL,
  `strzaly_celne` int(11) DEFAULT NULL,
  `strzaly_niecelne` int(11) DEFAULT NULL,
  `rzuty_rozne` int(11) DEFAULT NULL,
  `rzuty_karne` int(11) DEFAULT NULL,
  `faule` int(11) DEFAULT NULL,
  `spalone` int(11) DEFAULT NULL,
  `data_usuniecia` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `archiwum_zawodnik`
--

CREATE TABLE `archiwum_zawodnik` (
  `zawodnik_id` int(11) NOT NULL,
  `imie_nazwisko` varchar(50) DEFAULT NULL,
  `data_urodzenia` date DEFAULT NULL,
  `reprezentacja` varchar(50) DEFAULT NULL,
  `pozycja` varchar(5) DEFAULT NULL,
  `druzyna_id` int(11) DEFAULT NULL,
  `data_usuniecia` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `archiwum_zawodnik`
--

INSERT INTO `archiwum_zawodnik` (`zawodnik_id`, `imie_nazwisko`, `data_urodzenia`, `reprezentacja`, `pozycja`, `druzyna_id`, `data_usuniecia`) VALUES
(5, 'Olisadebe', '2023-10-28', 'Polska', 'GK', 1, '2024-01-17 07:52:35');

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
(1, 'Torpeda Rożental', 'Gruby Benek', '2023-10-28', 'Rozentalski grod');

--
-- Wyzwalacze `druzyna`
--
DELIMITER $$
CREATE TRIGGER `usuniecie_danych_druzyna_trigger` BEFORE DELETE ON `druzyna` FOR EACH ROW BEGIN
    -- Przeniesienie rekordu do archiwum
    INSERT INTO archiwum_druzyna (druzyna_id, nazwa_druzyny, trener, rok_zalozenia, stadion)
    VALUES (OLD.druzyna_id, OLD.nazwa_druzyny, OLD.trener, OLD.rok_zalozenia, OLD.stadion);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `logi`
--

CREATE TABLE `logi` (
  `id` int(11) NOT NULL,
  `user` varchar(255) DEFAULT NULL,
  `polecenie` varchar(255) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `logi`
--

INSERT INTO `logi` (`id`, `user`, `polecenie`, `timestamp`) VALUES
(1, 'root@localhost', 'INSERT INTO zawodnik (`zawodnik_id`, `imie_nazwisko`, `data_urodzenia`, `reprezentacja`, `pozycja`, `druzyna_id`)\r\n 	VALUES (\'6\', \'Olisabebe\', \'2024-01-03\', \'POL\', \'GK\', \'1\', ...))', '2024-01-17 08:59:15');

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

--
-- Wyzwalacze `mecz`
--
DELIMITER $$
CREATE TRIGGER `usuniecie_danych_mecz_trigger` BEFORE DELETE ON `mecz` FOR EACH ROW BEGIN
    -- Przeniesienie rekordu do archiwum
    INSERT INTO archiwum_mecz (mecz_id, data_meczu, druzyna_gospodarz_id, druzyna_gosc_id, wynik_gospodarz, wynik_gosc)
    VALUES (OLD.mecz_id, OLD.data_meczu, OLD.druzyna_gospodarz_id, OLD.druzyna_gosc_id, OLD.wynik_gospodarz, OLD.wynik_gosc);
END
$$
DELIMITER ;

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

--
-- Wyzwalacze `statystyki`
--
DELIMITER $$
CREATE TRIGGER `usuniecie_danych_statystyki_trigger` BEFORE DELETE ON `statystyki` FOR EACH ROW BEGIN
    -- Przeniesienie rekordu do archiwum
    INSERT INTO archiwum_statystyki (statystyki_id, mecz_id, druzyna_id, posiadanie_pilki, podania, strzaly_celne, strzaly_niecelne, rzuty_rozne, rzuty_karne, faule, spalone)
    VALUES (OLD.statystyki_id, OLD.mecz_id, OLD.druzyna_id, OLD.posiadanie_pilki, OLD.podania, OLD.strzaly_celne, OLD.strzaly_niecelne, OLD.rzuty_rozne, OLD.rzuty_karne, OLD.faule, OLD.spalone);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `zawodnik`
--

CREATE TABLE `zawodnik` (
  `zawodnik_id` int(11) NOT NULL,
  `imie_nazwisko` varchar(50) NOT NULL,
  `data_urodzenia` date NOT NULL,
  `reprezentacja` varchar(50) NOT NULL,
  `pozycja` varchar(3) NOT NULL,
  `druzyna_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `zawodnik`
--

INSERT INTO `zawodnik` (`zawodnik_id`, `imie_nazwisko`, `data_urodzenia`, `reprezentacja`, `pozycja`, `druzyna_id`) VALUES
(6, 'Olisabebe', '2024-01-03', 'POL', 'GK', 1);

--
-- Wyzwalacze `zawodnik`
--
DELIMITER $$
CREATE TRIGGER `logowanie_insert_zawodnik` AFTER INSERT ON `zawodnik` FOR EACH ROW BEGIN
    INSERT INTO logi (user, polecenie)
    VALUES (USER(), CONCAT('INSERT INTO zawodnik (`zawodnik_id`, `imie_nazwisko`, `data_urodzenia`, `reprezentacja`, `pozycja`, `druzyna_id`)\r\n \tVALUES (', QUOTE(NEW.zawodnik_id), ', ', QUOTE(NEW.imie_nazwisko), ', ', QUOTE(NEW.data_urodzenia), ', ', QUOTE(NEW.reprezentacja),
	', ', QUOTE(NEW.pozycja), ', ', QUOTE(NEW.druzyna_id),
	', ...)', ')'));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `usuniecie_danych_zawodnik_trigger` BEFORE DELETE ON `zawodnik` FOR EACH ROW BEGIN
    -- Przeniesienie rekordu do archiwum
    INSERT INTO archiwum_zawodnik (`zawodnik_id`, `imie_nazwisko`, `data_urodzenia`, `reprezentacja`,`pozycja`,`druzyna_id`)
    VALUES (OLD.zawodnik_id, OLD.imie_nazwisko, OLD.data_urodzenia, OLD.reprezentacja, OLD.pozycja, OLD.druzyna_id);
END
$$
DELIMITER ;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `archiwum_druzyna`
--
ALTER TABLE `archiwum_druzyna`
  ADD PRIMARY KEY (`druzyna_id`);

--
-- Indeksy dla tabeli `archiwum_mecz`
--
ALTER TABLE `archiwum_mecz`
  ADD PRIMARY KEY (`mecz_id`),
  ADD KEY `druzyna_gospodarz_id` (`druzyna_gospodarz_id`),
  ADD KEY `druzyna_gosc_id` (`druzyna_gosc_id`);

--
-- Indeksy dla tabeli `archiwum_statystyki`
--
ALTER TABLE `archiwum_statystyki`
  ADD PRIMARY KEY (`statystyki_id`),
  ADD KEY `mecz_id` (`mecz_id`),
  ADD KEY `druzyna_id` (`druzyna_id`);

--
-- Indeksy dla tabeli `archiwum_zawodnik`
--
ALTER TABLE `archiwum_zawodnik`
  ADD PRIMARY KEY (`zawodnik_id`),
  ADD KEY `druzyna_id` (`druzyna_id`);

--
-- Indeksy dla tabeli `druzyna`
--
ALTER TABLE `druzyna`
  ADD PRIMARY KEY (`druzyna_id`);

--
-- Indeksy dla tabeli `logi`
--
ALTER TABLE `logi`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT dla tabeli `archiwum_druzyna`
--
ALTER TABLE `archiwum_druzyna`
  MODIFY `druzyna_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `archiwum_mecz`
--
ALTER TABLE `archiwum_mecz`
  MODIFY `mecz_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `archiwum_statystyki`
--
ALTER TABLE `archiwum_statystyki`
  MODIFY `statystyki_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `druzyna`
--
ALTER TABLE `druzyna`
  MODIFY `druzyna_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `logi`
--
ALTER TABLE `logi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  MODIFY `zawodnik_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `archiwum_mecz`
--
ALTER TABLE `archiwum_mecz`
  ADD CONSTRAINT `archiwum_mecz_ibfk_1` FOREIGN KEY (`druzyna_gospodarz_id`) REFERENCES `druzyna` (`druzyna_id`),
  ADD CONSTRAINT `archiwum_mecz_ibfk_2` FOREIGN KEY (`druzyna_gosc_id`) REFERENCES `druzyna` (`druzyna_id`);

--
-- Ograniczenia dla tabeli `archiwum_statystyki`
--
ALTER TABLE `archiwum_statystyki`
  ADD CONSTRAINT `archiwum_statystyki_ibfk_1` FOREIGN KEY (`mecz_id`) REFERENCES `mecz` (`mecz_id`),
  ADD CONSTRAINT `archiwum_statystyki_ibfk_2` FOREIGN KEY (`druzyna_id`) REFERENCES `druzyna` (`druzyna_id`);

--
-- Ograniczenia dla tabeli `archiwum_zawodnik`
--
ALTER TABLE `archiwum_zawodnik`
  ADD CONSTRAINT `archiwum_zawodnik_ibfk_1` FOREIGN KEY (`druzyna_id`) REFERENCES `druzyna` (`druzyna_id`);

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
