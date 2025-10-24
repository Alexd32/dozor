-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 20, 2025 at 02:44 AM
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
(2, 'Секс после 40', 'finished', '2025-09-19 19:00:02', '2025-09-20 00:25:23');

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
(34, 2, 1, 'ПеReDoZzz ✔️', 8, 'success', '2025-09-19 22:03:46', '2025-09-19 22:23:46', '2025-09-19 22:44:09', '2025-09-19 23:02:10', '2025-09-19 23:02:10', 0, 237),
(35, 2, 2, 'АбсуRD ✔️', 8, 'success', '2025-09-19 23:25:21', '2025-09-19 23:45:21', NULL, '2025-09-19 23:49:37', '2025-09-19 23:49:37', 0, 221),
(36, 2, 3, 'The Wanted ✔️', 8, 'success', '2025-09-19 22:32:29', '2025-09-19 22:52:57', NULL, '2025-09-19 23:18:26', '2025-09-19 23:18:26', 0, 254),
(37, 2, 4, 'Масаны. Клан Малкавиан ✔️', 8, 'success', '2025-09-19 22:25:33', NULL, NULL, '2025-09-19 22:58:28', '2025-09-19 22:58:28', 0, 234),
(38, 2, 5, 'Феникс ✔️', 8, 'success', '2025-09-19 23:43:22', '2025-09-20 00:03:25', NULL, '2025-09-20 00:12:42', '2025-09-20 00:12:42', 0, 248),
(39, 2, 6, 'Темные ✔️', 8, 'success', '2025-09-19 23:19:00', '2025-09-19 23:42:00', NULL, '2025-09-19 23:52:44', '2025-09-19 23:52:44', 0, 286),
(40, 2, 7, 'Мудрые бобры ✔️', 8, 'success', '2025-09-19 22:33:21', NULL, NULL, '2025-09-19 22:53:55', '2025-09-19 22:53:55', 0, 230),
(41, 2, 8, 'Candy Бобер ✔️', 8, 'success', '2025-09-19 23:06:32', NULL, NULL, '2025-09-19 23:25:14', '2025-09-19 23:25:14', 0, 259),
(42, 2, 9, 'КоноПля ✔️', 8, 'success', '2025-09-19 22:45:44', '2025-09-19 23:06:21', '2025-09-19 23:25:53', '2025-09-19 23:31:25', '2025-09-19 23:31:25', 0, 207),
(43, 2, 10, 'Три сына и две дочки ✔️', 8, 'hint1', '2025-09-19 23:56:54', '2025-09-20 00:17:05', NULL, NULL, '2025-09-20 00:17:05', 0, 168),
(44, 2, 11, 'The Most ✔️', 8, 'success', '2025-09-19 23:15:05', NULL, NULL, '2025-09-19 23:42:37', '2025-09-19 23:42:37', 0, 278);

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
(256, 2, 1, 25, 1, 'success', '2025-09-19 19:00:02', '2025-09-19 19:29:22'),
(257, 2, 1, 26, 2, 'success', '2025-09-19 19:29:27', '2025-09-19 19:52:53'),
(258, 2, 1, 27, 3, 'success', '2025-09-19 19:53:04', '2025-09-19 20:43:27'),
(259, 2, 1, 28, 4, 'success', '2025-09-19 20:43:30', '2025-09-19 21:03:56'),
(260, 2, 1, 29, 5, 'success', '2025-09-19 21:04:18', '2025-09-19 21:24:10'),
(261, 2, 1, 30, 6, 'success', '2025-09-19 21:24:13', '2025-09-19 21:41:05'),
(262, 2, 1, 31, 7, 'success', '2025-09-19 21:41:08', '2025-09-19 22:03:43'),
(263, 2, 1, 32, 8, 'success', '2025-09-19 22:03:46', '2025-09-19 23:02:10'),
(264, 2, 2, 32, 1, 'success', '2025-09-19 19:00:03', '2025-09-19 19:43:01'),
(265, 2, 2, 25, 2, 'success', '2025-09-19 19:45:01', '2025-09-19 20:16:20'),
(266, 2, 2, 26, 3, 'success', '2025-09-19 20:16:27', '2025-09-19 20:45:20'),
(267, 2, 2, 27, 4, 'success', '2025-09-19 20:45:28', '2025-09-19 21:27:58'),
(268, 2, 2, 28, 5, 'success', '2025-09-19 21:28:13', '2025-09-19 21:43:40'),
(269, 2, 2, 29, 6, 'success', '2025-09-19 21:45:27', '2025-09-19 22:24:55'),
(270, 2, 2, 30, 7, 'timeout', '2025-09-19 22:25:01', '2025-09-19 23:25:21'),
(271, 2, 2, 31, 8, 'success', '2025-09-19 23:25:21', '2025-09-19 23:49:37'),
(272, 2, 3, 31, 1, 'success', '2025-09-19 19:00:07', '2025-09-19 19:17:33'),
(273, 2, 3, 32, 2, 'success', '2025-09-19 19:18:03', '2025-09-19 19:56:13'),
(274, 2, 3, 25, 3, 'success', '2025-09-19 19:56:17', '2025-09-19 20:16:25'),
(275, 2, 3, 26, 4, 'success', '2025-09-19 20:16:33', '2025-09-19 20:35:26'),
(276, 2, 3, 27, 5, 'success', '2025-09-19 20:35:36', '2025-09-19 21:28:44'),
(277, 2, 3, 28, 6, 'success', '2025-09-19 21:28:47', '2025-09-19 21:46:58'),
(278, 2, 3, 29, 7, 'success', '2025-09-19 21:47:02', '2025-09-19 22:32:05'),
(279, 2, 3, 30, 8, 'success', '2025-09-19 22:32:29', '2025-09-19 23:18:26'),
(280, 2, 4, 30, 1, 'success', '2025-09-19 19:00:02', '2025-09-19 19:29:24'),
(281, 2, 4, 31, 2, 'success', '2025-09-19 19:29:29', '2025-09-19 19:58:00'),
(282, 2, 4, 32, 3, 'success', '2025-09-19 19:58:04', '2025-09-19 20:44:30'),
(283, 2, 4, 25, 4, 'success', '2025-09-19 20:44:33', '2025-09-19 21:06:15'),
(284, 2, 4, 26, 5, 'success', '2025-09-19 21:06:19', '2025-09-19 21:23:35'),
(285, 2, 4, 27, 6, 'success', '2025-09-19 21:23:39', '2025-09-19 22:06:21'),
(286, 2, 4, 28, 7, 'success', '2025-09-19 22:06:26', '2025-09-19 22:25:30'),
(287, 2, 4, 29, 8, 'success', '2025-09-19 22:25:33', '2025-09-19 22:58:28'),
(288, 2, 5, 29, 1, 'success', '2025-09-19 19:00:02', '2025-09-19 19:42:59'),
(289, 2, 5, 30, 2, 'success', '2025-09-19 19:44:09', '2025-09-19 20:09:55'),
(290, 2, 5, 31, 3, 'success', '2025-09-19 20:10:02', '2025-09-19 20:39:07'),
(291, 2, 5, 32, 4, 'success', '2025-09-19 20:39:19', '2025-09-19 21:29:26'),
(292, 2, 5, 25, 5, 'success', '2025-09-19 21:29:34', '2025-09-19 21:51:54'),
(293, 2, 5, 26, 6, 'success', '2025-09-19 21:52:01', '2025-09-19 22:43:05'),
(294, 2, 5, 27, 7, 'timeout', '2025-09-19 22:43:11', '2025-09-19 23:43:21'),
(295, 2, 5, 28, 8, 'success', '2025-09-19 23:43:22', '2025-09-20 00:12:42'),
(296, 2, 6, 28, 1, 'success', '2025-09-19 19:00:03', '2025-09-19 19:23:50'),
(297, 2, 6, 29, 2, 'timeout', '2025-09-19 19:23:54', '2025-09-19 20:23:54'),
(298, 2, 6, 30, 3, 'success', '2025-09-19 20:25:05', '2025-09-19 21:17:27'),
(299, 2, 6, 31, 4, 'success', '2025-09-19 21:17:30', '2025-09-19 21:51:00'),
(300, 2, 6, 32, 5, 'success', '2025-09-19 21:51:05', '2025-09-19 22:23:03'),
(301, 2, 6, 25, 6, 'success', '2025-09-19 22:23:06', '2025-09-19 22:58:58'),
(302, 2, 6, 26, 7, 'success', '2025-09-19 22:59:02', '2025-09-19 23:18:18'),
(303, 2, 6, 27, 8, 'success', '2025-09-19 23:19:00', '2025-09-19 23:52:44'),
(304, 2, 7, 27, 1, 'success', '2025-09-19 19:00:03', '2025-09-19 19:30:07'),
(305, 2, 7, 28, 2, 'success', '2025-09-19 19:30:11', '2025-09-19 19:56:03'),
(306, 2, 7, 29, 3, 'success', '2025-09-19 19:56:07', '2025-09-19 20:25:11'),
(307, 2, 7, 30, 4, 'success', '2025-09-19 20:25:22', '2025-09-19 21:20:33'),
(308, 2, 7, 31, 5, 'success', '2025-09-19 21:20:36', '2025-09-19 21:54:10'),
(309, 2, 7, 32, 6, 'success', '2025-09-19 21:54:12', '2025-09-19 22:12:33'),
(310, 2, 7, 25, 7, 'success', '2025-09-19 22:12:35', '2025-09-19 22:33:19'),
(311, 2, 7, 26, 8, 'success', '2025-09-19 22:33:21', '2025-09-19 22:53:55'),
(312, 2, 8, 26, 1, 'success', '2025-09-19 19:00:04', '2025-09-19 19:25:45'),
(313, 2, 8, 27, 2, 'success', '2025-09-19 19:26:04', '2025-09-19 20:01:51'),
(314, 2, 8, 28, 3, 'success', '2025-09-19 20:01:56', '2025-09-19 20:31:09'),
(315, 2, 8, 29, 4, 'success', '2025-09-19 20:31:12', '2025-09-19 21:10:59'),
(316, 2, 8, 30, 5, 'success', '2025-09-19 21:11:02', '2025-09-19 21:51:32'),
(317, 2, 8, 31, 6, 'success', '2025-09-19 21:51:40', '2025-09-19 22:14:34'),
(318, 2, 8, 32, 7, 'success', '2025-09-19 22:14:37', '2025-09-19 23:06:29'),
(319, 2, 8, 25, 8, 'success', '2025-09-19 23:06:32', '2025-09-19 23:25:14'),
(320, 2, 9, 26, 1, 'success', '2025-09-19 19:00:03', '2025-09-19 19:21:25'),
(321, 2, 9, 30, 2, 'success', '2025-09-19 19:21:46', '2025-09-19 19:45:14'),
(322, 2, 9, 25, 3, 'timeout', '2025-09-19 19:45:28', '2025-09-19 20:45:36'),
(323, 2, 9, 27, 4, 'success', '2025-09-19 20:45:36', '2025-09-19 21:34:02'),
(324, 2, 9, 31, 5, 'success', '2025-09-19 21:34:14', '2025-09-19 21:47:53'),
(325, 2, 9, 28, 6, 'success', '2025-09-19 21:47:56', '2025-09-19 22:10:03'),
(326, 2, 9, 32, 7, 'success', '2025-09-19 22:10:06', '2025-09-19 22:45:42'),
(327, 2, 9, 29, 8, 'success', '2025-09-19 22:45:44', '2025-09-19 23:31:25'),
(328, 2, 10, 25, 1, 'timeout', '2025-09-19 19:00:03', '2025-09-19 20:00:05'),
(329, 2, 10, 31, 2, 'success', '2025-09-19 20:00:05', '2025-09-19 20:20:41'),
(330, 2, 10, 32, 3, 'success', '2025-09-19 20:22:53', '2025-09-19 20:58:44'),
(331, 2, 10, 30, 4, 'success', '2025-09-19 20:58:48', '2025-09-19 21:45:07'),
(332, 2, 10, 26, 5, 'success', '2025-09-19 21:45:30', '2025-09-19 22:16:31'),
(333, 2, 10, 27, 6, 'timeout', '2025-09-19 22:16:34', '2025-09-19 23:20:05'),
(334, 2, 10, 28, 7, 'success', '2025-09-19 23:20:05', '2025-09-19 23:56:51'),
(335, 2, 10, 29, 8, 'hint1', '2025-09-19 23:56:54', NULL),
(336, 2, 11, 32, 1, 'success', '2025-09-19 19:00:07', '2025-09-19 19:48:27'),
(337, 2, 11, 31, 2, 'success', '2025-09-19 19:48:31', '2025-09-19 20:05:55'),
(338, 2, 11, 30, 3, 'success', '2025-09-19 20:06:00', '2025-09-19 20:47:05'),
(339, 2, 11, 29, 4, 'success', '2025-09-19 20:47:16', '2025-09-19 21:22:51'),
(340, 2, 11, 25, 5, 'success', '2025-09-19 21:23:06', '2025-09-19 21:52:53'),
(341, 2, 11, 28, 6, 'success', '2025-09-19 21:52:56', '2025-09-19 22:18:13'),
(342, 2, 11, 27, 7, 'success', '2025-09-19 22:18:17', '2025-09-19 23:14:51'),
(343, 2, 11, 26, 8, 'success', '2025-09-19 23:15:05', '2025-09-19 23:42:37');

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
(25, 2, 1, ' ', 'Жизнь после 40 только начинается», — сказал он. А его внук, Алексей Аркадьевич, с радостью подгонит вам колеса :) Код опасности 1', 'Тихо, тихо 🌊', 'Тихорецкая, 2 — колеси там.', 'DR6380'),
(26, 2, 2, ' ', 'Большая крайность случается и тогда, когда вы согласны и на хостел, и на ламповый отель, и на апартовый. Но остаётся лишь вводить себя в интернет-журнал и вглядываться в знаки из-за забора, вспоминая стоп-слово \"флюгегехаймен\".  Код опасности 1. Метка. Формат кода DRцифры', 'Паломники, встречая новые ворота перед собой, вглядываются ввысь, чтобы понять,  что их ждёт у неба.', 'Большая красная, 8 — ищи верное окно.', 'DR88'),
(27, 2, 3, ' ', 'Если к 40 ты уже эмигрировал, то нам ты уже совсем не близкий. Смотришь там на выстроившиеся в очередь пошкрябанные бетонные LGBT-шные парочки. А лучше двигайся с самого начала.\nМетка. Это начало. Код опасности 1', 'В начале поэемы огня будут знаки, там и определишь порядок латиницы.', 'Скрябина, считай парные бетонные столбы.', 'DR6539'),
(28, 2, 4, ' ', 'После 40, после секса, тянет иногда сыграть на русской мандолине и спеть на диалектах \nавстронезийских языков (например, маралангко или гасагаса). Или забросить всё и уйти на производство. Код опасности 1. Метка.', 'Вату тут не катаем, больница закрыта, идите напротив счастье пытать.', 'Ватутина, 13, но лазить напротив.', 'DR725'),
(29, 2, 5, ' ', 'За 40, как и за 41 и 43, а может быть, и ближе к 45 ты уже предпочитаешь не лазать по хозяйственным блокам сам, а предпочитаешь поручать это Владимиру Викторовичу. Код опасности 1. Метки.\n', 'Вызывая скорую с мобильного, можете попасть в школу.', 'Адоратского: около 103 школы ищите недострой.', 'DR25843'),
(30, 2, 6, ' ', 'Секс после 40 может быть и бесплатным в каком-нибудь ГСК. Но после выбора таких мест ты уже ни разу не античный бог: не 1самец, а, скорее, в самом конце списка. Код опасности 2. Метки.', 'Омега тем и хороша, что в центре её есть глубина.', 'ГСК Омега на Восстания,  в центре бункер, лезь туда.', 'DR2534'),
(31, 2, 7, ' ', 'После 40 цвет страсти даст кошениль. Она же поможет выбрать нужную позу. А от прилёта аиста — предохраняйтесь, поворачивая в сторону. Код опасности 1. Метки.', 'В этой позиции я просто теку-у-у… Тебе точно не 27?', 'Красная позиция, 27 — шуруй к ЖД.', 'DR25116'),
(32, 2, 8, ' ', 'После 40 вместо секса приходят странные сны: то ты расстреливаешь белые чешки из пулемёта, то обернулся соловьём, мчишь по стоку и забиваешь ГОЛ :) Код опасности 2+. Метки.', 'Сворачивай в победный лес, твои сны утекут в землю.', 'Край Горкинско-Ометьевского леса: Южка у перекрестка с Братьев Касимовых, спуск к коллектору.', 'DR2535');

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
