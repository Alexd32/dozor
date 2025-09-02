-- Создание базы
CREATE DATABASE IF NOT EXISTS dozor
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE dozor;

-- Справочник игроков (все пользователи, кто когда-либо регистрировался в боте)
CREATE TABLE players (
    id INT AUTO_INCREMENT PRIMARY KEY,
    telegram_id BIGINT NOT NULL UNIQUE,
    username VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Игры (каждая новая партия)
CREATE TABLE games (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMP NULL
);

-- Задания для каждой игры
CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT NOT NULL,
    seq_num INT NOT NULL, -- порядковый номер задания
    text TEXT NOT NULL,
    hint1 TEXT,
    hint2 TEXT,
    answer_code VARCHAR(50) NOT NULL,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
);

-- Игроки внутри конкретной игры (состояние)
CREATE TABLE game_players (
    id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT NOT NULL,
    player_id INT NOT NULL,
    team VARCHAR(255),

    current_task INT DEFAULT 1,
    status ENUM('idle','waiting_answer','hint1','hint2','success','timeout') DEFAULT 'idle',

    started_at TIMESTAMP NULL,   -- когда игрок получил текущее задание
    hint1_at TIMESTAMP NULL,     -- когда выдана первая подсказка
    hint2_at TIMESTAMP NULL,     -- когда выдана вторая подсказка
    finished_at TIMESTAMP NULL,  -- когда задание завершено (успех или таймаут)

    last_action_at TIMESTAMP NULL, -- последняя активность
    time_spent INT DEFAULT 0,      -- время на текущее задание
    total_time INT DEFAULT 0,      -- суммарное время за игру

    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
);

-- Архив статистики по выполнению заданий
CREATE TABLE game_stats (
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

-- Индексы для ускорения выборки
CREATE INDEX idx_game_players_game ON game_players(game_id);
CREATE INDEX idx_game_stats_game ON game_stats(game_id);
CREATE INDEX idx_tasks_game ON tasks(game_id);
