-- Игроки + прогресс (текущая сессия)
CREATE TABLE players (
    id INT AUTO_INCREMENT PRIMARY KEY,
    telegram_id BIGINT NOT NULL UNIQUE,
    username VARCHAR(255),
    team VARCHAR(255),

    -- Текущее задание
    current_task INT DEFAULT 1,       -- номер текущего задания
    total_tasks INT NOT NULL,         -- общее количество заданий

    -- Состояние текущего задания
    status ENUM(
        'idle',            -- ещё не начали
        'waiting_answer',  -- задание выдано, ждём ответ
        'hint1',           -- подсказка 1 выдана
        'hint2',           -- подсказка 2 выдана
        'success',         -- задание решено
        'timeout'          -- время вышло
    ) DEFAULT 'idle',

    -- Таймеры
    started_at TIMESTAMP NULL,   -- когда выдано задание
    hint1_at TIMESTAMP NULL,     -- подсказка 1
    hint2_at TIMESTAMP NULL,     -- подсказка 2
    finished_at TIMESTAMP NULL,  -- завершение задания

    -- Аналитика (живое состояние)
    last_action_at TIMESTAMP NULL,
    time_spent INT DEFAULT 0,    -- время на текущее задание
    total_time INT DEFAULT 0,    -- общее время на все задания

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Справочник заданий
CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seq_num INT NOT NULL,        -- номер задания
    text TEXT NOT NULL,
    hint1 TEXT,
    hint2 TEXT,
    answer_code VARCHAR(50) NOT NULL
);

-- Статистика игр (архив)
CREATE TABLE game_stats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    task_num INT NOT NULL,          -- номер задания
    status ENUM('success','timeout') NOT NULL,
    started_at TIMESTAMP NOT NULL,  -- начало задания
    finished_at TIMESTAMP NOT NULL, -- конец задания
    time_spent INT NOT NULL,        -- время в секундах
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (player_id) REFERENCES players(id)
);
