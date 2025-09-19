-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 19, 2025 at 07:49 PM
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
(2, 'Секс после 40', 'not_started', NULL, NULL);

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
(34, 2, 1, 'ПеReDoZzz ✔️', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(35, 2, 2, 'АбсуRD ✔️', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(36, 2, 3, 'The Wanted ✔️', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(37, 2, 4, 'Масаны. Клан Малкавиан ✔️', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(38, 2, 5, 'Феникс ✔️', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(39, 2, 6, 'Темные ✔️', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(40, 2, 7, 'Мудрые бобры ✔️', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(41, 2, 8, 'Candy Бобер ✔️', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(42, 2, 9, 'КоноПля ✔️', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(43, 2, 10, 'Три сына и две дочки ✔️', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0),
(44, 2, 11, 'The Most ✔️', 1, 'idle', NULL, NULL, NULL, NULL, NULL, 0, 0);

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
(1, 10001, 'Bob_chemist', '2025-09-03 04:40:57'),
(2, 10002, 'lx_kzn', '2025-09-03 04:40:57'),
(3, 10003, 'Airat_Gimadutdinov', '2025-09-03 04:40:57'),
(4, 10004, 'masankzn', '2025-09-03 04:40:57'),
(5, 10005, 'Caine_kzn', '2025-09-03 04:40:57'),
(6, 10006, 'Malikova_Binka', '2025-09-03 04:40:57'),
(7, 10007, 'helga_kazan', '2025-09-03 04:40:57'),
(8, 10008, 'alisha_murmur', '2025-09-03 04:40:57'),
(9, 10009, 'imp7_kzn', '2025-09-03 04:40:57'),
(10, 10010, 'kir0w', '2025-09-03 04:40:57'),
(11, 10011, 'Aidar_Khuzin', '2025-09-03 04:40:57');

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
(256, 2, 1, 25, 1, 'not_started', NULL, NULL),
(257, 2, 1, 26, 2, 'not_started', NULL, NULL),
(258, 2, 1, 27, 3, 'not_started', NULL, NULL),
(259, 2, 1, 28, 4, 'not_started', NULL, NULL),
(260, 2, 1, 29, 5, 'not_started', NULL, NULL),
(261, 2, 1, 30, 6, 'not_started', NULL, NULL),
(262, 2, 1, 31, 7, 'not_started', NULL, NULL),
(263, 2, 1, 32, 8, 'not_started', NULL, NULL),
(264, 2, 2, 32, 1, 'not_started', NULL, NULL),
(265, 2, 2, 25, 2, 'not_started', NULL, NULL),
(266, 2, 2, 26, 3, 'not_started', NULL, NULL),
(267, 2, 2, 27, 4, 'not_started', NULL, NULL),
(268, 2, 2, 28, 5, 'not_started', NULL, NULL),
(269, 2, 2, 29, 6, 'not_started', NULL, NULL),
(270, 2, 2, 30, 7, 'not_started', NULL, NULL),
(271, 2, 2, 31, 8, 'not_started', NULL, NULL),
(272, 2, 3, 31, 1, 'not_started', NULL, NULL),
(273, 2, 3, 32, 2, 'not_started', NULL, NULL),
(274, 2, 3, 25, 3, 'not_started', NULL, NULL),
(275, 2, 3, 26, 4, 'not_started', NULL, NULL),
(276, 2, 3, 27, 5, 'not_started', NULL, NULL),
(277, 2, 3, 28, 6, 'not_started', NULL, NULL),
(278, 2, 3, 29, 7, 'not_started', NULL, NULL),
(279, 2, 3, 30, 8, 'not_started', NULL, NULL),
(280, 2, 4, 30, 1, 'not_started', NULL, NULL),
(281, 2, 4, 31, 2, 'not_started', NULL, NULL),
(282, 2, 4, 32, 3, 'not_started', NULL, NULL),
(283, 2, 4, 25, 4, 'not_started', NULL, NULL),
(284, 2, 4, 26, 5, 'not_started', NULL, NULL),
(285, 2, 4, 27, 6, 'not_started', NULL, NULL),
(286, 2, 4, 28, 7, 'not_started', NULL, NULL),
(287, 2, 4, 29, 8, 'not_started', NULL, NULL),
(288, 2, 5, 29, 1, 'not_started', NULL, NULL),
(289, 2, 5, 30, 2, 'not_started', NULL, NULL),
(290, 2, 5, 31, 3, 'not_started', NULL, NULL),
(291, 2, 5, 32, 4, 'not_started', NULL, NULL),
(292, 2, 5, 25, 5, 'not_started', NULL, NULL),
(293, 2, 5, 26, 6, 'not_started', NULL, NULL),
(294, 2, 5, 27, 7, 'not_started', NULL, NULL),
(295, 2, 5, 28, 8, 'not_started', NULL, NULL),
(296, 2, 6, 28, 1, 'not_started', NULL, NULL),
(297, 2, 6, 29, 2, 'not_started', NULL, NULL),
(298, 2, 6, 30, 3, 'not_started', NULL, NULL),
(299, 2, 6, 31, 4, 'not_started', NULL, NULL),
(300, 2, 6, 32, 5, 'not_started', NULL, NULL),
(301, 2, 6, 25, 6, 'not_started', NULL, NULL),
(302, 2, 6, 26, 7, 'not_started', NULL, NULL),
(303, 2, 6, 27, 8, 'not_started', NULL, NULL),
(304, 2, 7, 27, 1, 'not_started', NULL, NULL),
(305, 2, 7, 28, 2, 'not_started', NULL, NULL),
(306, 2, 7, 29, 3, 'not_started', NULL, NULL),
(307, 2, 7, 30, 4, 'not_started', NULL, NULL),
(308, 2, 7, 31, 5, 'not_started', NULL, NULL),
(309, 2, 7, 32, 6, 'not_started', NULL, NULL),
(310, 2, 7, 25, 7, 'not_started', NULL, NULL),
(311, 2, 7, 26, 8, 'not_started', NULL, NULL),
(312, 2, 8, 26, 1, 'not_started', NULL, NULL),
(313, 2, 8, 27, 2, 'not_started', NULL, NULL),
(314, 2, 8, 28, 3, 'not_started', NULL, NULL),
(315, 2, 8, 29, 4, 'not_started', NULL, NULL),
(316, 2, 8, 30, 5, 'not_started', NULL, NULL),
(317, 2, 8, 31, 6, 'not_started', NULL, NULL),
(318, 2, 8, 32, 7, 'not_started', NULL, NULL),
(319, 2, 8, 25, 8, 'not_started', NULL, NULL),
(320, 2, 9, 26, 1, 'not_started', NULL, NULL),
(321, 2, 9, 30, 2, 'not_started', NULL, NULL),
(322, 2, 9, 25, 3, 'not_started', NULL, NULL),
(323, 2, 9, 27, 4, 'not_started', NULL, NULL),
(324, 2, 9, 31, 5, 'not_started', NULL, NULL),
(325, 2, 9, 28, 6, 'not_started', NULL, NULL),
(326, 2, 9, 32, 7, 'not_started', NULL, NULL),
(327, 2, 9, 29, 8, 'not_started', NULL, NULL),
(328, 2, 10, 25, 1, 'not_started', NULL, NULL),
(329, 2, 10, 31, 2, 'not_started', NULL, NULL),
(330, 2, 10, 32, 3, 'not_started', NULL, NULL),
(331, 2, 10, 30, 4, 'not_started', NULL, NULL),
(332, 2, 10, 26, 5, 'not_started', NULL, NULL),
(333, 2, 10, 27, 6, 'not_started', NULL, NULL),
(334, 2, 10, 28, 7, 'not_started', NULL, NULL),
(335, 2, 10, 29, 8, 'not_started', NULL, NULL),
(336, 2, 11, 32, 1, 'not_started', NULL, NULL),
(337, 2, 11, 31, 2, 'not_started', NULL, NULL),
(338, 2, 11, 30, 3, 'not_started', NULL, NULL),
(339, 2, 11, 29, 4, 'not_started', NULL, NULL),
(340, 2, 11, 25, 5, 'not_started', NULL, NULL),
(341, 2, 11, 28, 6, 'not_started', NULL, NULL),
(342, 2, 11, 27, 7, 'not_started', NULL, NULL),
(343, 2, 11, 26, 8, 'not_started', NULL, NULL);

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
(25, 2, 1, 'Тихорецкая 2', 'Жизнь после 40 только начинается», — сказал он. А его внук, Алексей Аркадьевич, с радостью подгонит вам колеса :) Код опасности 1', 'Тихо, тихо 🌊', 'Тихорецкая, 2 — колеси там.', 'DR6380'),
(26, 2, 2, 'Большая красная 8', 'Большая крайность случается и тогда, когда вы согласны и на хостел, и на ламповый отель, и на апартовый. Но остаётся лишь вводить себя в интернет-журнал и вглядываться в знаки из-за забора, вспоминая стоп-слово \"флюгегехаймен\".  Код опасности 1. Метка. Формат кода DRцифры', 'Паломники, встречая новые ворота перед собой, вглядываются ввысь, чтобы понять,  что их ждёт у неба.', 'Большая красная, 8 — ищи верное окно.', 'DR88'),
(27, 2, 3, 'Скрябина', 'Если к 40 ты уже эмигрировал, то нам ты уже совсем не близкий. Смотришь там на выстроившиеся в очередь пошкрябанные бетонные LGBT-шные парочки. А лучше двигайся с самого начала.\nМетка. Это начало. Код опасности 1', 'В начале поэемы огня будут знаки, там и определишь порядок латиницы.', 'Скрябина, считай парные бетонные столбы.', 'DR6539'),
(28, 2, 4, 'Ватутина', 'После 40, после секса, тянет иногда сыграть на русской мандолине и спеть на диалектах \nавстронезийских языков (например, маралангко или гасагаса). Или забросить всё и уйти на производство. Код опасности 1. Метка.', 'Вату тут не катаем, больница закрыта, идите напротив счастье пытать.', 'Ватутина, 13, но лазить напротив.', 'DR725'),
(29, 2, 5, 'Адоратского', 'За 40, как и за 41 и 43, а может быть, и ближе к 45 ты уже предпочитаешь не лазать по хозяйственным блокам сам, а предпочитаешь поручать это Владимиру Викторовичу. Код опасности 1. Метки.\n', 'Вызывая скорую с мобильного, можете попасть в школу.', 'Адоратского: около 103 школы ищите недострой.', 'DR25843'),
(30, 2, 6, 'Восстания', 'Секс после 40 может быть и бесплатным в каком-нибудь ГСК. Но после выбора таких мест ты уже ни разу не античный бог: не 1самец, а, скорее, в самом конце списка. Код опасности 2. Метки.', 'Омега тем и хороша, что в центре её есть глубина.', 'ГСК Омега на Восстания,  в центре бункер, лезь туда.', 'DR2534'),
(31, 2, 7, 'Кр. Позиция', 'После 40 цвет страсти даст кошениль. Она же поможет выбрать нужную позу. А от прилёта аиста — предохраняйтесь, поворачивая в сторону. Код опасности 1. Метки.', 'В этой позиции я просто теку-у-у… Тебе точно не 27?', 'Красная позиция, 27 — шуруй к ЖД.', 'DR25116'),
(32, 2, 8, 'Южка', 'После 40 вместо секса приходят странные сны: то ты расстреливаешь белые чешки из пулемёта, то обернулся соловьём, мчишь по стоку и забиваешь ГОЛ :) Код опасности 2+. Метки.', 'Сворачивай в победный лес, твои сны утекут в землю.', 'Край Горкинско-Ометьевского леса: Южка у перекрестка с Братьев Касимовых, спуск к коллектору.', 'DR2535');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `game_stats`
--
ALTER TABLE `game_stats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `player_tasks`
--
ALTER TABLE `player_tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=344;

--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

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
