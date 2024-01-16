-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 15 Sty 2024, 08:19
-- Wersja serwera: 10.4.21-MariaDB
-- Wersja PHP: 7.4.25

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
  `pozycja` int(11) NOT NULL,
  `druzyna_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
  MODIFY `druzyna_id` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `zawodnik_id` int(11) NOT NULL AUTO_INCREMENT;

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
