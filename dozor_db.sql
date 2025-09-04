-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 04, 2025 at 11:16 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dozor`
--

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` enum('not_started','in_progress','finished') NOT NULL DEFAULT 'not_started',
  `started_at` timestamp NULL DEFAULT NULL,
  `finished_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`id`, `name`, `status`, `started_at`, `finished_at`) VALUES
(2, 'Тестовая игра', 'in_progress', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `game_players`
--

CREATE TABLE `game_players` (
  `id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `team` varchar(255) DEFAULT NULL,
  `current_task` int(11) DEFAULT 1,
  `status` enum('idle','waiting_answer','hint1','hint2','success','timeout','finished') DEFAULT 'idle',
  `started_at` timestamp NULL DEFAULT NULL,
  `hint1_at` timestamp NULL DEFAULT NULL,
  `hint2_at` timestamp NULL DEFAULT NULL,
  `finished_at` timestamp NULL DEFAULT NULL,
  `last_action_at` timestamp NULL DEFAULT NULL,
  `time_spent` int(11) DEFAULT 0,
  `total_time` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `game_players`
--

INSERT INTO `game_players` (`id`, `game_id`, `player_id`, `team`, `current_task`, `status`, `started_at`, `hint1_at`, `hint2_at`, `finished_at`, `last_action_at`, `time_spent`, `total_time`) VALUES
(19, 2, 1, 'Team simsim_pro', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(20, 2, 2, 'Team team_bravo', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(21, 2, 3, 'Team team_charlie', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(22, 2, 4, 'Team team_delta', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(23, 2, 5, 'Team team_echo', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(24, 2, 6, 'Team team_foxtrot', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(25, 2, 7, 'Team team_golf', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(26, 2, 8, 'Team team_hotel', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(27, 2, 9, 'Team team_india', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(28, 2, 10, 'Team team_juliet', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `game_stats`
--

CREATE TABLE `game_stats` (
  `id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `task_num` int(11) NOT NULL,
  `status` enum('success','timeout') NOT NULL,
  `started_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `finished_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_spent` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `telegram_id` bigint(20) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`id`, `telegram_id`, `username`, `created_at`) VALUES
(1, 10001, 'simsim_pro', '2025-09-03 04:40:57'),
(2, 10002, 'team_bravo', '2025-09-03 04:40:57'),
(3, 10003, 'team_charlie', '2025-09-03 04:40:57'),
(4, 10004, 'team_delta', '2025-09-03 04:40:57'),
(5, 10005, 'team_echo', '2025-09-03 04:40:57'),
(6, 10006, 'team_foxtrot', '2025-09-03 04:40:57'),
(7, 10007, 'team_golf', '2025-09-03 04:40:57'),
(8, 10008, 'team_hotel', '2025-09-03 04:40:57'),
(9, 10009, 'team_india', '2025-09-03 04:40:57'),
(10, 10010, 'team_juliet', '2025-09-03 04:40:57');

-- --------------------------------------------------------

--
-- Table structure for table `player_tasks`
--

CREATE TABLE `player_tasks` (
  `id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `seq_num` int(11) NOT NULL,
  `status` enum('not_started','waiting_answer','hint1','hint2','success','timeout') DEFAULT 'not_started',
  `started_at` timestamp NULL DEFAULT NULL,
  `finished_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_tasks`
--

INSERT INTO `player_tasks` (`id`, `game_id`, `player_id`, `task_id`, `seq_num`, `status`, `started_at`, `finished_at`) VALUES
(1, 2, 1, 28, 1, 'not_started', NULL, NULL),
(2, 2, 1, 26, 2, 'not_started', NULL, NULL),
(3, 2, 1, 29, 3, 'not_started', NULL, NULL),
(4, 2, 1, 30, 4, 'not_started', NULL, NULL),
(5, 2, 1, 31, 5, 'not_started', NULL, NULL),
(6, 2, 1, 27, 6, 'not_started', NULL, NULL),
(7, 2, 1, 25, 7, 'not_started', NULL, NULL),
(8, 2, 2, 27, 1, 'not_started', NULL, NULL),
(9, 2, 2, 29, 2, 'not_started', NULL, NULL),
(10, 2, 2, 26, 3, 'not_started', NULL, NULL),
(11, 2, 2, 30, 4, 'not_started', NULL, NULL),
(12, 2, 2, 31, 5, 'not_started', NULL, NULL),
(13, 2, 2, 28, 6, 'not_started', NULL, NULL),
(14, 2, 2, 25, 7, 'not_started', NULL, NULL),
(15, 2, 3, 30, 1, 'not_started', NULL, NULL),
(16, 2, 3, 25, 2, 'not_started', NULL, NULL),
(17, 2, 3, 28, 3, 'not_started', NULL, NULL),
(18, 2, 3, 26, 4, 'not_started', NULL, NULL),
(19, 2, 3, 31, 5, 'not_started', NULL, NULL),
(20, 2, 3, 27, 6, 'not_started', NULL, NULL),
(21, 2, 3, 29, 7, 'not_started', NULL, NULL),
(22, 2, 4, 30, 1, 'not_started', NULL, NULL),
(23, 2, 4, 28, 2, 'not_started', NULL, NULL),
(24, 2, 4, 31, 3, 'not_started', NULL, NULL),
(25, 2, 4, 29, 4, 'not_started', NULL, NULL),
(26, 2, 4, 27, 5, 'not_started', NULL, NULL),
(27, 2, 4, 26, 6, 'not_started', NULL, NULL),
(28, 2, 4, 25, 7, 'not_started', NULL, NULL),
(29, 2, 5, 30, 1, 'not_started', NULL, NULL),
(30, 2, 5, 27, 2, 'not_started', NULL, NULL),
(31, 2, 5, 25, 3, 'not_started', NULL, NULL),
(32, 2, 5, 26, 4, 'not_started', NULL, NULL),
(33, 2, 5, 28, 5, 'not_started', NULL, NULL),
(34, 2, 5, 31, 6, 'not_started', NULL, NULL),
(35, 2, 5, 29, 7, 'not_started', NULL, NULL),
(36, 2, 6, 31, 1, 'not_started', NULL, NULL),
(37, 2, 6, 29, 2, 'not_started', NULL, NULL),
(38, 2, 6, 30, 3, 'not_started', NULL, NULL),
(39, 2, 6, 25, 4, 'not_started', NULL, NULL),
(40, 2, 6, 26, 5, 'not_started', NULL, NULL),
(41, 2, 6, 28, 6, 'not_started', NULL, NULL),
(42, 2, 6, 27, 7, 'not_started', NULL, NULL),
(43, 2, 7, 30, 1, 'not_started', NULL, NULL),
(44, 2, 7, 31, 2, 'not_started', NULL, NULL),
(45, 2, 7, 25, 3, 'not_started', NULL, NULL),
(46, 2, 7, 28, 4, 'not_started', NULL, NULL),
(47, 2, 7, 29, 5, 'not_started', NULL, NULL),
(48, 2, 7, 26, 6, 'not_started', NULL, NULL),
(49, 2, 7, 27, 7, 'not_started', NULL, NULL),
(50, 2, 8, 28, 1, 'not_started', NULL, NULL),
(51, 2, 8, 31, 2, 'not_started', NULL, NULL),
(52, 2, 8, 25, 3, 'not_started', NULL, NULL),
(53, 2, 8, 29, 4, 'not_started', NULL, NULL),
(54, 2, 8, 30, 5, 'not_started', NULL, NULL),
(55, 2, 8, 27, 6, 'not_started', NULL, NULL),
(56, 2, 8, 26, 7, 'not_started', NULL, NULL),
(57, 2, 9, 26, 1, 'not_started', NULL, NULL),
(58, 2, 9, 27, 2, 'not_started', NULL, NULL),
(59, 2, 9, 31, 3, 'not_started', NULL, NULL),
(60, 2, 9, 25, 4, 'not_started', NULL, NULL),
(61, 2, 9, 28, 5, 'not_started', NULL, NULL),
(62, 2, 9, 29, 6, 'not_started', NULL, NULL),
(63, 2, 9, 30, 7, 'not_started', NULL, NULL),
(64, 2, 10, 28, 1, 'not_started', NULL, NULL),
(65, 2, 10, 30, 2, 'not_started', NULL, NULL),
(66, 2, 10, 25, 3, 'not_started', NULL, NULL),
(67, 2, 10, 27, 4, 'not_started', NULL, NULL),
(68, 2, 10, 31, 5, 'not_started', NULL, NULL),
(69, 2, 10, 29, 6, 'not_started', NULL, NULL),
(70, 2, 10, 26, 7, 'not_started', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `seq_num` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `text` text NOT NULL,
  `hint1` text DEFAULT NULL,
  `hint2` text DEFAULT NULL,
  `answer_code` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` (`id`, `game_id`, `seq_num`, `name`, `text`, `hint1`, `hint2`, `answer_code`) VALUES
(25, 2, 1, 'Мост на Гвардейской', 'В жизни Шурика бывало разное: например, нужно найти контрагента с дебиторской задолженностью (1660218703). И вот он мчится по этому адресу, слушая песню RHCP:\r\n«Sometimes I feel\r\nLike I don\'t have a partner…»\r\nКод опасности 2, метки. На брифе вы получили конфету. Это бонус на всю игру. Дерзайте.', 'Судя по количеству колец, директор этой фирмы убегает от алиментов и прячется под каким-нибудь мостом, но Шурик его найдёт…', 'Это текст второй подсказки', '25DZR3061'),
(26, 2, 2, 'КФЭИ', 'Альма-матер Шурика использовалась им всегда для подтягивания икроножных мышц. Фантазируя над картой, Шурик загадывал бы это место как точку схождения американских подпольных спиртных дел мастеров. Вдобавок шифровались они шифровались и меняли форматы. Код опасности 1. Пароль: период дат без тире', 'RAR распакуется иначе.', 'Это текст второй подсказки', '25DZR19361950'),
(27, 2, 3, 'Лаванда', 'Используйте реквизит. Код опасности 1. Ожидают агенты.', 'Шурик любил разгадывать загадки:\r\nЯ современный «Бог войны», защитник рубежей страны, ведь прежде чем пойти на бой, меня пускают на «разбой».\r\nА я цветочек синий, в кофе добавляюсь. Лечебный, и приятный запах источаю.', 'Это текст второй подсказки', '25DZR3366'),
(28, 2, 4, 'Дубравный лес', 'Шурик хотел вернуться в прошлое. Пересмотрев «Назад в будущее», он решил, что для начала ему нужно место, в которое чаще всего бьют молнии. Чаще всего скопление их притягивает молнии. Шурик знал это место ещё по игре «Незваный гость» от KiCaDa, состоявшейся 16 декабря 2006 года. Код опасности 1, метки.', '55.734744, 49.197000', 'Это текст второй подсказки', '25DZR9047'),
(29, 2, 5, 'Озеро Кабан', 'Одним из новых приключений Шурика была съёмка в фильме 2013 года и дружба с Гошей К. «О. К. тогда, – сказал себе Шурик, – всё равно надо вставить туда любимую песню:\r\n«Постой, паровоз, не стучите колёса,\r\nКондуктор, нажми на тормоза,\r\nЯ к маменьке родной с последним приветом…»\r\nКод опасности 2, метки.', 'Кондуктор, бас тормозынга, тимер юлдан барасын бит.', 'Это текст второй подсказки', '25DZR212'),
(30, 2, 6, 'Аракчино, 43 артиллерийская база', 'В армии Шурик не служил, хотя иногда и подумывал об этом. Финансисту-оценщику нашлось бы место на какой-нибудь основе, фундаменте. Но часть выбрал бы себе обязательно с красивым номером, как у родного региона. Код опасности 2, метки.', 'Такие мысли посещали его только до 13 сентября 2016 года.', 'Это текст второй подсказки', '25DZR908531'),
(31, 2, 7, 'Пляж Локомотив', 'Хорошая девочка Лида… Шурик не был святым или протопопом, и ему точно она была нужна утром. Однако в это время было не просто отсутствие, а вавуум. Да ещё и сосед Хасаныч своими археологическими историями их отпугивал напрочь. Код опасности 1. Задание делать последним. Ожидают агенты.', 'Красно-зелёный горит небосвод. Наш паровоз – как самолёт! Снова победа от нас не уйдёт!', 'Это текст второй подсказки', '25DZR555');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `game_players`
--
ALTER TABLE `game_players`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `idx_game_players_game` (`game_id`);

--
-- Indexes for table `game_stats`
--
ALTER TABLE `game_stats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `idx_game_stats_game` (`game_id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `telegram_id` (`telegram_id`);

--
-- Indexes for table `player_tasks`
--
ALTER TABLE `player_tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `task_id` (`task_id`),
  ADD KEY `idx_player_tasks_game_player` (`game_id`,`player_id`);

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tasks_game` (`game_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `game_players`
--
ALTER TABLE `game_players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `game_stats`
--
ALTER TABLE `game_stats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `player_tasks`
--
ALTER TABLE `player_tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=128;

--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `game_players`
--
ALTER TABLE `game_players`
  ADD CONSTRAINT `game_players_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `game_players_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `game_stats`
--
ALTER TABLE `game_stats`
  ADD CONSTRAINT `game_stats_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `game_stats_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_tasks`
--
ALTER TABLE `player_tasks`
  ADD CONSTRAINT `player_tasks_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `player_tasks_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `player_tasks_ibfk_3` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
