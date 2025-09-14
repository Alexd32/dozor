import logging
import re
from datetime import datetime, timedelta
from aiogram import Router
from aiogram.types import Message
from db import get_connection, get_game_status
from limits import *

router = Router()


def normalize_code(text: str) -> str:
    """Очищаем код: только латиница и цифры, без пробелов и спецсимволов, в нижнем регистре"""
    if not text:
        return ""
    cleaned = re.sub(r'[^A-Za-z0-9]', '', text)
    return cleaned.lower()


@router.message(lambda m: m.text == "Ввести код")
async def ask_code(message: Message):
    game = get_game_status()
    if not game:
        await message.answer("❌ Ошибка: нет активной игры.")
        return

    if game["status"] == "not_started":
        await message.answer("⏳ Игра ещё не началась.")
        return
    if game["status"] == "finished":
        await message.answer("🏁 Игра завершена.")
        return

    username = message.from_user.username
    if not username:
        await message.answer("❌ У тебя нет username в Telegram.")
        return

    try:
        conn = get_connection()
        cur = conn.cursor(dictionary=True)

        # Ищем активное задание
        cur.execute("""
            SELECT pt.id, pt.seq_num
            FROM player_tasks pt
            JOIN players p ON p.id = pt.player_id
            WHERE p.username = %s AND pt.game_id = %s
              AND pt.status IN ('waiting_answer','hint1','hint2')
            ORDER BY pt.seq_num ASC
            LIMIT 1
        """, (username, game["id"]))
        active = cur.fetchone()

        if active:
            await message.answer("⌨️ Введи код для текущего задания (одно слово, латиница и цифры).")
        else:
            # Проверяем, остались ли ещё не начатые задания
            cur.execute("""
                SELECT COUNT(*) as cnt
                FROM player_tasks pt
                JOIN players p ON p.id = pt.player_id
                WHERE p.username = %s AND pt.game_id = %s
                  AND pt.status = 'not_started'
            """, (username, game["id"]))
            row = cur.fetchone()
            if row["cnt"] > 0:
                await message.answer("📭 Сначала получите задание.")
            else:
                await message.answer("🎉 Все задания завершены.")

        conn.close()

    except Exception as e:
        logging.error(f"Ошибка ask_code: {e}")
        await message.answer(f"⚠️ Ошибка при проверке кода: {e}")


@router.message(lambda m: not m.text.startswith("/") and len(m.text) <= 50)
async def enter_code(message: Message):
    # Фильтр: не реагируем на служебные кнопки
    if message.text in ("Получить задание", "Получить подсказку", "Ввести код"):
        return

    game = get_game_status()
    if not game or game["status"] != "in_progress":
        return

    username = message.from_user.username
    if not username:
        await message.answer("❌ У тебя нет username в Telegram.")
        return

    try:
        conn = get_connection()
        cur = conn.cursor(dictionary=True)

        # Ищем активное задание
        cur.execute("""
            SELECT pt.id as player_task_id, pt.seq_num, pt.started_at,
                   t.answer_code, p.id as player_id
            FROM player_tasks pt
            JOIN tasks t ON pt.task_id = t.id
            JOIN players p ON p.id = pt.player_id
            WHERE p.username = %s AND pt.game_id = %s
              AND pt.status IN ('waiting_answer','hint1','hint2')
            ORDER BY pt.seq_num ASC
            LIMIT 1
        """, (username, game["id"]))
        row = cur.fetchone()

        if not row:
            await message.answer("📭 У тебя сейчас нет активного задания.")
            conn.close()
            return

        user_code = normalize_code(message.text)
        correct_code = normalize_code(row["answer_code"])

        if not user_code:
            await message.answer("❌ Код должен состоять только из латинских букв и цифр.")
            conn.close()
            return

        if user_code == correct_code:
            now_ts = datetime.now()

            # если по какой-то причине нет started_at, чтобы не падать — считаем 0 минут
            started_at = row["started_at"] or now_ts

            elapsed_sec = int((now_ts - started_at).total_seconds())
            elapsed_minutes = elapsed_sec // 60

            # проверяем лимит времени на задание
            if elapsed_sec > TASK_TIME_LIMIT * 60:
                # просрочено: фиксируем окончание на границе лимита, чтобы в статистике было ровно TASK_TIME_LIMIT минут
                capped_finish = started_at + timedelta(minutes=TASK_TIME_LIMIT)

                # Обновляем player_tasks -> timeout
                cur.execute("""
                    UPDATE player_tasks
                       SET status='timeout', finished_at=%s
                     WHERE id=%s
                """, (capped_finish, row["player_task_id"]))

                # Обновляем game_players -> timeout, total_time + лимит минут
                cur.execute("""
                    UPDATE game_players
                       SET status='timeout',
                           finished_at=%s,
                           total_time = total_time + %s,
                           last_action_at=NOW(),
                           current_task=%s
                     WHERE game_id=%s AND player_id=%s
                """, (capped_finish, TASK_TIME_LIMIT, row["seq_num"], game["id"], row["player_id"]))
                conn.commit()
                conn.close()

                await message.answer(
                    f"⏰ Время на выполнение задания #{row['seq_num']} истекло "
                    f"(лимит {TASK_TIME_LIMIT} мин). Код после истечения времени не принимается."
                )
                return

            # успели в лимит → success
            cur.execute("""
                UPDATE player_tasks
                   SET status='success', finished_at=NOW()
                 WHERE id=%s
            """, (row["player_task_id"],))

            cur.execute("""
                UPDATE game_players
                   SET status='success',
                       finished_at=NOW(),
                       total_time = total_time + %s,
                       last_action_at=NOW(),
                       current_task=%s
                 WHERE game_id=%s AND player_id=%s
            """, (elapsed_minutes, row["seq_num"], game["id"], row["player_id"]))
            conn.commit()
            conn.close()

            await message.answer(f"✅ Код принят! Задание #{row['seq_num']} выполнено.")
        else:
            await message.answer("❌ Неверный код. Попробуй ещё раз.")

    except Exception as e:
        logging.error(f"Ошибка enter_code: {e}")
        await message.answer(f"⚠️ Ошибка при проверке кода: {e}")
