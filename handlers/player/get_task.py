import logging
from datetime import datetime
from aiogram import Router
from aiogram.types import Message
from db import get_connection, get_game_status
from keyboards import player_kb
from limits import *

router = Router()


@router.message(lambda m: m.text == "Получить задание")
async def get_task(message: Message):
    game = get_game_status()
    if not game:
        await message.answer("⚠️ Нет активной игры.")
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

        # Определяем игрока и его команду
        cur.execute("""
            SELECT p.id, gp.team
            FROM players p
            JOIN game_players gp ON p.id = gp.player_id
            WHERE p.username = %s
            LIMIT 1
        """, (username,))
        player = cur.fetchone()
        if not player:
            await message.answer("❌ Ты не зарегистрирован в игре.")
            conn.close()
            return

        # Проверяем активное задание
        cur.execute("""
            SELECT pt.id as player_task_id, pt.seq_num, pt.status, pt.started_at,
                   t.name, t.text
            FROM player_tasks pt
            JOIN tasks t ON pt.task_id = t.id
            WHERE pt.player_id = %s AND pt.game_id = %s
              AND pt.status IN ('waiting_answer','hint1_sent','hint2_sent')
            ORDER BY pt.seq_num ASC
            LIMIT 1
        """, (player["id"], game["id"]))
        active = cur.fetchone()

        now = datetime.now()

        if active:
            started_at = active["started_at"]
            elapsed = now - started_at
            minutes = int(elapsed.total_seconds() // TASK_TIME_LIMIT)

            if minutes < TASK_TIME_LIMIT:
                await message.answer(
                    f"⏳ Новое задание будет доступно через {TASK_TIME_LIMIT - minutes} мин.\n"
                    f"📜 Текущее задание №{active['seq_num']}:\n"
                    f"🏷 {active['name']}\n"
                    f"📖 {active['text']}",
                    parse_mode="Markdown",
                    reply_markup=player_kb
                )
                conn.close()
                return
            else:
                # Время вышло — ставим timeout
                cur.execute("""
                    UPDATE player_tasks
                    SET status='timeout', finished_at=NOW()
                    WHERE id=%s
                """, (active["player_task_id"],))
                conn.commit()

        # Ищем следующее задание
        cur.execute("""
            SELECT pt.id as player_task_id, pt.seq_num, t.name, t.text
            FROM player_tasks pt
            JOIN tasks t ON pt.task_id = t.id
            WHERE pt.player_id = %s AND pt.game_id = %s
              AND pt.status = 'not_started'
            ORDER BY pt.seq_num ASC
            LIMIT 1
        """, (player["id"], game["id"]))
        row = cur.fetchone()

        if not row:
            await message.answer("🎉 Все задания уже выполнены или просрочены!")
            conn.close()
            return

        # Запускаем новое задание
        cur.execute("""
            UPDATE player_tasks
            SET status='waiting_answer', started_at=NOW()
            WHERE id=%s
        """, (row["player_task_id"],))
        conn.commit()
        conn.close()

        await message.answer(
            f"📜 Задание №{row['seq_num']} для команды *{player['team']}*:\n\n"
            f"🏷 {row['name']}\n"
            f"📖 {row['text']}",
            parse_mode="Markdown",
            reply_markup=player_kb
        )

    except Exception as e:
        logging.error(f"Ошибка при получении задания: {e}")
        await message.answer(f"⚠️ Ошибка получения задания: {e}")
