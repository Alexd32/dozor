-- ============================================
-- Сброс тестовых данных для игры "Dozor"
-- Возвращает БД в исходное состояние:
--  • игра ещё не началась
--  • задания игроками не получены
--  • игроки "чистые"
--  • статистика пустая
-- ============================================

-- Сбрасываем статус игры
UPDATE games
SET status = 'not_started',
    started_at = NULL,
    finished_at = NULL;

-- Очищаем игровую статистику
TRUNCATE TABLE game_stats;

-- Сбрасываем прогресс игроков
UPDATE game_players
SET current_task = NULL,
    status = 'idle',
    started_at = NULL,
    hint1_at = NULL,
    hint2_at = NULL,
    finished_at = NULL,
    last_action_at = NULL,
    time_spent = 0,
    total_time = 0;

-- Сбрасываем прогресс по заданиям игроков
UPDATE player_tasks
SET status = 'not_started',
    started_at = NULL,
    finished_at = NULL;

-- ============================================
-- Теперь база данных полностью сброшена
-- Можно снова тестировать игру "с нуля"
-- ============================================
