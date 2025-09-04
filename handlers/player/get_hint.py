import logging
from datetime import datetime
from aiogram import Router
from aiogram.types import Message
from db import get_connection, get_game_status

router = Router()


@router.message(lambda m: m.text == "Получить подсказку")
async def get_hint(message: Message):
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
        cur.execute("SELECT id FROM players WHERE username = %s", (username,))
        player = cur.fetchone()
        if not player:
            await message.answer("❌ Ты не зарегистрирован в игре.")
            conn.close()
            return

        # Ищем активное задание
        cur.execute("""
            SELECT pt.id as player_task_id, pt.status, pt.started_at, t.hint1, t.hint2
            FROM player_tasks pt
            JOIN tasks t ON pt.task_id = t.id
            WHERE pt.player_id = %s AND pt.game_id = %s
              AND pt.status IN ('waiting_answer','hint1_sent','hint2_sent')
            ORDER BY pt.seq_num ASC
            LIMIT 1
        """, (player["id"], game["id"]))
        row = cur.fetchone()

        if not row:
            await message.answer("📭 Сначала получите задание.")
            conn.close()
            return

        started_at = row["started_at"]
        now = datetime.now()
        elapsed = now - started_at
        minutes = int(elapsed.total_seconds() // 60)

        if row["status"] == "waiting_answer":
            if minutes < 20:
                await message.answer(f"⏳ Первая подсказка будет доступна через {20 - minutes} мин.")
            else:
                cur.execute("UPDATE player_tasks SET status='hint1_sent' WHERE id=%s", (row["player_task_id"],))
                conn.commit()
                await message.answer(f"💡 Подсказка 1:\n{row['hint1']}")

        elif row["status"] == "hint1_sent":
            if minutes < 40:
                await message.answer(f"⏳ Вторая подсказка будет доступна через {40 - minutes} мин.")
            else:
                cur.execute("UPDATE player_tasks SET status='hint2_sent' WHERE id=%s", (row["player_task_id"],))
                conn.commit()
                await message.answer(f"💡 Подсказка 2:\n{row['hint2']}")

        elif row["status"] == "hint2_sent":
            await message.answer("❌ Больше подсказок нет.")

        conn.close()

    except Exception as e:
        logging.error(f"Ошибка при получении подсказки: {e}")
        await message.answer(f"⚠️ Ошибка при получении подсказки: {e}")
