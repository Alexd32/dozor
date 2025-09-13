import logging
from aiogram import Router, F
from aiogram.types import Message
from db import get_connection

router = Router(name="admin_stop_game")

@router.message(F.text == "Закончить игру")
async def stop_game(message: Message):
    """
    Стоп игры:
    - games.status -> finished
    - games.finished_at = NOW()
    - рассылаем уведомления игрокам
    """
    try:
        conn = get_connection()
        cur = conn.cursor(dictionary=True)

        cur.execute("SELECT id, status FROM games ORDER BY id DESC LIMIT 1")
        game = cur.fetchone()
        if not game:
            await message.answer("⚠️ Игра не найдена.")
            return

        if game["status"] != "in_progress":
            await message.answer("⚠️ Нельзя завершить: игра ещё не запущена.")
            return

        cur.execute("""
            UPDATE games
               SET status = 'finished',
                   finished_at = NOW()
             WHERE id = %s
        """, (game["id"],))
        conn.commit()

        cur.execute("SELECT telegram_id FROM players")
        players = cur.fetchall()
        for p in players:
            try:
                await message.bot.send_message(p["telegram_id"], "🏁 Игра завершена! Спасибо за участие.")
            except Exception:
                logging.exception("Не удалось отправить уведомление игроку")

        await message.answer("🏁 Игра завершена! Уведомления игрокам отправлены.")
    except Exception as e:
        logging.exception("Ошибка при завершении игры")
        await message.answer(f"⚠️ Ошибка при завершении игры: {e}")
    finally:
        try:
            cur.close()
            conn.close()
        except Exception:
            pass
