-- --------------------------------------------------------
-- Структура базы данных для dozor
-- --------------------------------------------------------

CREATE DATABASE IF NOT EXISTS dozor
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE dozor;

-- --------------------------------------------------------
-- Таблица players
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS players (
  id INT AUTO_INCREMENT PRIMARY KEY,
  telegram_id BIGINT NOT NULL UNIQUE,
  username VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- Таблица games (добавлено поле status)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS games (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  status ENUM('not_started','in_progress','finished') NOT NULL DEFAULT 'not_started',
  started_at TIMESTAMP NULL DEFAULT NULL,
  finished_at TIMESTAMP NULL DEFAULT NULL
);

-- --------------------------------------------------------
-- Таблица tasks
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  game_id INT NOT NULL,
  seq_num INT NOT NULL,
  text TEXT NOT NULL,
  hint1 TEXT,
  hint2 TEXT,
  answer_code VARCHAR(50) NOT NULL,
  FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- Таблица game_players
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS game_players (
  id INT AUTO_INCREMENT PRIMARY KEY,
  game_id INT NOT NULL,
  player_id INT NOT NULL,
  team VARCHAR(255),

  current_task INT DEFAULT 1,
  status ENUM('idle','waiting_answer','hint1','hint2','success','timeout','finished') DEFAULT 'idle',

  started_at TIMESTAMP NULL,
  hint1_at TIMESTAMP NULL,
  hint2_at TIMESTAMP NULL,
  finished_at TIMESTAMP NULL,

  last_action_at TIMESTAMP NULL,
  time_spent INT DEFAULT 0,
  total_time INT DEFAULT 0,

  FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
  FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- Таблица game_stats
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS game_stats (
  id INT AUTO_INCREMENT PRIMARY KEY,
  game_id INT NOT NULL,
  player_id INT NOT NULL,
  task_num INT NOT NULL,
  status ENUM('success','timeout') NOT NULL,
  started_at TIMESTAMP NOT NULL,
  finished_at TIMESTAMP NOT NULL,
  time_spent INT NOT NULL,

  FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
  FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- Индексы
-- --------------------------------------------------------
CREATE INDEX idx_game_players_game ON game_players(game_id);
CREATE INDEX idx_game_stats_game ON game_stats(game_id);
CREATE INDEX idx_tasks_game ON tasks(game_id);

-- --------------------------------------------------------
-- Тестовые данные
-- --------------------------------------------------------

-- Игроки
INSERT INTO players (id, telegram_id, username, created_at) VALUES
(1, 10001, 'team_alpha', NOW()),
(2, 10002, 'team_bravo', NOW()),
(3, 10003, 'team_charlie', NOW()),
(4, 10004, 'team_delta', NOW()),
(5, 10005, 'team_echo', NOW()),
(6, 10006, 'team_foxtrot', NOW()),
(7, 10007, 'team_golf', NOW()),
(8, 10008, 'team_hotel', NOW()),
(9, 10009, 'team_india', NOW()),
(10, 10010, 'team_juliet', NOW());

-- Игры
INSERT INTO games (id, name, status, started_at, finished_at) VALUES
(1, 'Тестовая игра 1', 'in_progress', NOW(), NULL);

-- Задания
INSERT INTO tasks (id, game_id, seq_num, text, hint1, hint2, answer_code) VALUES
(1, 1, 1, 'Задание 1: Найди памятник у фонтана.', 'Центр города.', 'Рядом с театром.', 'CODE1'),
(2, 1, 2, 'Задание 2: Сфотографируй здание с часами.', 'На главной площади.', 'Там проходят парады.', 'CODE2'),
(3, 1, 3, 'Задание 3: Найди красный дом.', 'На улице Ленина.', 'Напротив парка.', 'CODE3');

-- Игроки в игре
INSERT INTO game_players (id, game_id, player_id, team, current_task, status, started_at, last_action_at, time_spent, total_time) VALUES
(1, 1, 1, 'Team Alpha', NULL, 'idle', NULL, NOW(), 0, 0),
(2, 1, 2, 'Team Bravo', 1, 'waiting_answer', NOW() - INTERVAL 5 MINUTE, NOW(), 300, 0),
(3, 1, 3, 'Team Charlie', 1, 'hint1', NOW() - INTERVAL 25 MINUTE, NOW(), 1500, 0),
(4, 1, 4, 'Team Delta', 1, 'hint2', NOW() - INTERVAL 45 MINUTE, NOW(), 2700, 0),
(5, 1, 5, 'Team Echo', 1, 'success', NOW() - INTERVAL 10 MINUTE, NOW(), 540, 540),
(6, 1, 6, 'Team Foxtrot', 1, 'timeout', NOW() - INTERVAL 70 MINUTE, NOW(), 3600, 3600),
(7, 1, 7, 'Team Golf', 2, 'waiting_answer', NOW() - INTERVAL 2 MINUTE, NOW(), 120, 600),
(8, 1, 8, 'Team Hotel', 2, 'success', NOW() - INTERVAL 15 MINUTE, NOW(), 840, 1500),
(9, 1, 9, 'Team India', 3, 'finished', NOW() - INTERVAL 1 HOUR, NOW(), 3600, 3600),
(10, 1, 10, 'Team Juliet', NULL, 'idle', NULL, NOW(), 0, 0);

-- Статистика
INSERT INTO game_stats (id, game_id, player_id, task_num, status, started_at, finished_at, time_spent) VALUES
(1, 1, 5, 1, 'success', NOW() - INTERVAL 10 MINUTE, NOW() - INTERVAL 1 MINUTE, 540),
(2, 1, 6, 1, 'timeout', NOW() - INTERVAL 70 MINUTE, NOW() - INTERVAL 10 MINUTE, 3600),
(3, 1, 8, 2, 'success', NOW() - INTERVAL 15 MINUTE, NOW() - INTERVAL 1 MINUTE, 840),
(4, 1, 9, 1, 'success', NOW() - INTERVAL 50 MINUTE, NOW() - INTERVAL 40 MINUTE, 600),
(5, 1, 9, 2, 'success', NOW() - INTERVAL 35 MINUTE, NOW() - INTERVAL 25 MINUTE, 600),
(6, 1, 9, 3, 'success', NOW() - INTERVAL 20 MINUTE, NOW() - INTERVAL 5 MINUTE, 900);
