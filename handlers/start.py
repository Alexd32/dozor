from aiogram import Router
from aiogram.types import Message
from aiogram.filters import Command
import config
from db import get_connection
from keyboards import admin_kb, player_kb

router = Router()


def is_admin(username: str) -> bool:
    return username and username.lower() in [u.lower() for u in config.ADMINS]


@router.message(Command("start"))
async def start_cmd(message: Message):
    username = message.from_user.username
    if not username:
        await message.answer("❌ У тебя нет username в Telegram. Установи его в настройках.")
        return

    # Проверка: админ?
    if is_admin(username):
        await message.answer("👑 Привет, админ! Вот твои кнопки:", reply_markup=admin_kb)
        return

    # Проверка: игрок в БД?
    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT gp.team
        FROM game_players gp
        JOIN players p ON gp.player_id = p.id
        WHERE p.username = %s
        LIMIT 1
    """, (username,))
    row = cur.fetchone()
    conn.close()

    if row:
        await message.answer(f"✅ Команда зарегистрирована: {row['team']}", reply_markup=player_kb)
    else:
        await message.answer("❌ Нет доступа")
