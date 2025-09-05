import logging
from datetime import datetime
from aiogram import Router
from aiogram.types import Message
from db import get_connection, get_game_status
from limits import *

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
            SELECT pt.id as player_task_id, pt.status, pt.started_at, pt.seq_num,
                   t.hint1, t.hint2
            FROM player_tasks pt
            JOIN tasks t ON pt.task_id = t.id
            WHERE pt.player_id = %s AND pt.game_id = %s
              AND pt.status IN ('waiting_answer','hint1','hint2')
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
        elapsed_minutes = int((now - started_at).total_seconds() // 60)

        # 1-я подсказка
        if row["status"] == "waiting_answer":
            if elapsed_minutes < HINT1_DELAY:
                await message.answer(f"⏳ Первая подсказка будет доступна через {HINT1_DELAY - elapsed_minutes} мин.")
            else:
                cur.execute("UPDATE player_tasks SET status='hint1' WHERE id=%s", (row["player_task_id"],))
                cur.execute("""
                    UPDATE game_players
                    SET status='hint1',
                        hint1_at=NOW(),
                        last_action_at=NOW(),
                        current_task=%s
                    WHERE game_id=%s AND player_id=%s
                """, (row["seq_num"], game["id"], player["id"]))
                conn.commit()
                await message.answer(f"💡 Подсказка 1:\n{row['hint1']}")

        # 2-я подсказка
        elif row["status"] == "hint1":
            if elapsed_minutes < HINT2_DELAY:
                await message.answer(f"⏳ Вторая подсказка будет доступна через {HINT2_DELAY - elapsed_minutes} мин.")
            else:
                cur.execute("UPDATE player_tasks SET status='hint2' WHERE id=%s", (row["player_task_id"],))
                cur.execute("""
                    UPDATE game_players
                    SET status='hint2',
                        hint2_at=NOW(),
                        last_action_at=NOW(),
                        current_task=%s
                    WHERE game_id=%s AND player_id=%s
                """, (row["seq_num"], game["id"], player["id"]))
                conn.commit()
                await message.answer(f"💡 Подсказка 2:\n{row['hint2']}")

        # Больше подсказок нет
        elif row["status"] == "hint2":
            await message.answer("❌ Больше подсказок нет.")

        conn.close()

    except Exception as e:
        logging.error(f"Ошибка при получении подсказки: {e}")
        await message.answer(f"⚠️ Ошибка при получении подсказки: {e}")
