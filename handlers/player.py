import logging
from aiogram import Router
from aiogram.types import Message
from db import get_connection, get_game_status
from keyboards import player_kb

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

        # Определяем игрока
        cur.execute("SELECT id, team_name FROM players WHERE username = %s", (username,))
        player = cur.fetchone()
        if not player:
            await message.answer("❌ Ты не зарегистрирован в игре.")
            conn.close()
            return

        # Ищем задание
        cur.execute("""
            SELECT pt.id as player_task_id, pt.seq_num, t.text
            FROM player_tasks pt
            JOIN tasks t ON pt.task_id = t.id
            WHERE pt.player_id = %s AND pt.game_id = %s
              AND pt.status = 'not_started'
            ORDER BY pt.seq_num ASC
            LIMIT 1
        """, (player["id"], game["id"]))
        row = cur.fetchone()

        if not row:
            await message.answer("🎉 Все задания для твоей команды уже выполнены!")
            conn.close()
            return

        # Обновляем статус
        cur.execute("""
            UPDATE player_tasks
            SET status = 'waiting_answer', started_at = NOW()
            WHERE id = %s
        """, (row["player_task_id"],))
        conn.commit()
        conn.close()

        await message.answer(
            f"📜 Задание #{row['seq_num']} для команды *{player['team_name']}*:\n\n{row['text']}",
            parse_mode="Markdown",
            reply_markup=player_kb
        )

    except Exception as e:
        logging.error(f"Ошибка при получении задания: {e}")
        await message.answer(f"⚠️ Ошибка получения задания: {e}")
