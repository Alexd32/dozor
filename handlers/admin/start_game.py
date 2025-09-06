import logging
from aiogram import Router
from aiogram.types import Message
from db import get_connection
from bot_instance import bot

router = Router()

@router.message(lambda m: m.text == "Начать игру")
async def start_game(message: Message):
    try:
        conn = get_connection()
        cur = conn.cursor(dictionary=True)

        cur.execute("SELECT id, status FROM games ORDER BY id DESC LIMIT 1")
        game = cur.fetchone()

        if not game:
            await message.answer("⚠️ В базе нет ни одной игры.")
            conn.close()
            return

        if game["status"] == "in_progress":
            await message.answer("⏳ Игра уже идёт.")
            conn.close()
            return

        if game["status"] == "finished":
            await message.answer("🏁 Эта игра уже завершена. Создайте новую для запуска.")
            conn.close()
            return

        # Стартуем игру
        cur.execute("""
            UPDATE games
            SET status = 'in_progress', started_at = NOW()
            WHERE id = %s
        """, (game["id"],))
        conn.commit()

        # Берём всех игроков этой игры
        cur.execute("""
            SELECT p.telegram_id
            FROM game_players gp
            JOIN players p ON p.id = gp.player_id
            WHERE gp.game_id = %s
        """, (game["id"],))
        players = cur.fetchall()
        conn.close()

        # Рассылка
        for p in players:
            try:
                await bot.send_message(p["telegram_id"], "🎮 Игра началась!")
            except Exception as e:
                logging.error(f"Не удалось отправить игроку {p['telegram_id']}: {e}")

        await message.answer("✅ Игра запущена! Уведомления игрокам отправлены.")

    except Exception as e:
        logging.error(f"Ошибка при запуске игры: {e}")
        await message.answer(f"⚠️ Ошибка: {e}")
