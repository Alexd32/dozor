import logging
from aiogram import Router, F
from aiogram.types import Message
from db import get_connection

router = Router(name="admin_start_game")

@router.message(F.text == "Начать игру")
async def start_game(message: Message):
    """
    Старт игры:
    - games.status -> in_progress
    - games.started_at = NOW(), games.finished_at = NULL
    - рассылаем уведомления игрокам (через message.bot, без циклических импортов)
    """
    try:
        conn = get_connection()
        cur = conn.cursor(dictionary=True)

        # Берём последнюю игру
        cur.execute("SELECT id, status FROM games ORDER BY id DESC LIMIT 1")
        game = cur.fetchone()
        if not game:
            await message.answer("⚠️ Сначала создайте игру в БД (таблица games).")
            return

        if game["status"] == "in_progress":
            await message.answer("⚠️ Игра уже идёт.")
            return
        if game["status"] == "finished":
            await message.answer("⚠️ Игра уже завершена. Создайте новую игру.")
            return

        # Стартуем
        cur.execute("""
            UPDATE games
               SET status = 'in_progress',
                   started_at = NOW(),
                   finished_at = NULL
             WHERE id = %s
        """, (game["id"],))
        conn.commit()

        # Оповещение игроков (без импортов bot из main)
        cur.execute("SELECT telegram_id FROM players")
        players = cur.fetchall()
        for p in players:
            try:
                await message.bot.send_message(p["telegram_id"], "✅ Игра началась! Удачи!")
            except Exception:
                # не валим сценарий, просто лог
                logging.exception("Не удалось отправить уведомление игроку")

        await message.answer("✅ Игра запущена! Уведомления игрокам отправлены.")
    except Exception as e:
        logging.exception("Ошибка при старте игры")
        await message.answer(f"⚠️ Ошибка при старте игры: {e}")
    finally:
        try:
            cur.close()
            conn.close()
        except Exception:
            pass
