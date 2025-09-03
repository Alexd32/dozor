import logging
from aiogram import Router
from aiogram.types import Message
from db import get_connection

router = Router()


@router.message(lambda m: m.text == "Начать игру")
async def start_game(message: Message):
    try:
        conn = get_connection()
        cur = conn.cursor(dictionary=True)

        # Находим последнюю игру
        cur.execute("SELECT id, status FROM games ORDER BY id DESC LIMIT 1")
        game = cur.fetchone()

        if not game:
            await message.answer("⚠️ В базе нет ни одной игры.")
            conn.close()
            return

        if game["status"] == "in_progress":
            await message.answer("⏳ Игра уже запущена.")
            conn.close()
            return

        if game["status"] == "finished":
            await message.answer("🏁 Эта игра уже завершена. Создайте новую для запуска.")
            conn.close()
            return

        # Обновляем статус и время старта
        cur.execute("""
            UPDATE games
            SET status = 'in_progress', started_at = NOW()
            WHERE id = %s
        """, (game["id"],))
        conn.commit()
        conn.close()

        await message.answer("✅ Игра запущена!")

    except Exception as e:
        logging.error(f"Ошибка при запуске игры: {e}")
        await message.answer(f"⚠️ Ошибка: {e}")


@router.message(lambda m: m.text == "Закончить игру")
async def stop_game(message: Message):
    try:
        conn = get_connection()
        cur = conn.cursor(dictionary=True)

        # Находим последнюю игру
        cur.execute("SELECT id, status FROM games ORDER BY id DESC LIMIT 1")
        game = cur.fetchone()

        if not game:
            await message.answer("⚠️ В базе нет ни одной игры.")
            conn.close()
            return

        if game["status"] == "finished":
            await message.answer("🏁 Игра уже завершена.")
            conn.close()
            return

        if game["status"] == "not_started":
            await message.answer("⏳ Игра ещё не начиналась.")
            conn.close()
            return

        # Завершаем игру
        cur.execute("""
            UPDATE games
            SET status = 'finished', finished_at = NOW()
            WHERE id = %s
        """, (game["id"],))
        conn.commit()
        conn.close()

        await message.answer("🏁 Игра завершена!")

    except Exception as e:
        logging.error(f"Ошибка при завершении игры: {e}")
        await message.answer(f"⚠️ Ошибка: {e}")


@router.message(lambda m: m.text == "Показать статистику")
async def show_stats(message: Message):
    # Пока заглушка
    await message.answer("📊 Статистика пока не реализована.")
